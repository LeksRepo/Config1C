﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ПолучитьСкидку()
	
	Скидка = 0;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидОплатыДоговора", Объект.ВидОплатыДоговора);
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СкидкиДоговоровСрезПоследних.ВторойПределСкидка,
	|	СкидкиДоговоровСрезПоследних.ВторойПределСумма,
	|	СкидкиДоговоровСрезПоследних.ПервыйПределСкидка,
	|	СкидкиДоговоровСрезПоследних.ПервыйПределСумма
	|ИЗ
	|	РегистрСведений.СкидкиДоговоров.СрезПоследних(
	|			&Период,
	|			Подразделение = &Подразделение
	|				И ВидыОплатыДоговоров = &ВидОплатыДоговора) КАК СкидкиДоговоровСрезПоследних";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.ПервыйПределСумма <= Объект.СуммаДокумента И ВыборкаДетальныеЗаписи.ВторойПределСумма > Объект.СуммаДокумента Тогда
			Скидка = ВыборкаДетальныеЗаписи.ПервыйПределСкидка;
		ИначеЕсли ВыборкаДетальныеЗаписи.ВторойПределСумма <= Объект.СуммаДокумента Тогда
			Скидка = ВыборкаДетальныеЗаписи.ВторойПределСкидка;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Скидка;
	
КонецФункции

&НаСервере
Функция ПересчитатьСуммуДокумента()
	
	Если ЗначениеЗаполнено(Объект.Спецификация) Тогда
		СтоимостьСпецификации = ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.Спецификация, "СуммаДокумента");
		Объект.СуммаДокумента = СтоимостьСпецификации * (100 - Объект.ПроцентСкидки) / 100;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьОстатокОплаты()
	
	СтруктураСумм = ПолучитьСуммыДопСоглашенийИПлатежей(Объект.Ссылка);
	СуммаДопСоглашения = СтруктураСумм.ДопСоглашение;
	ОсталосьОплатить = СтруктураСумм.Остаток;
	
КонецПроцедуры // ЗаполнитьОстатокОплаты()

&НаСервереБезКонтекста
Функция ПолучитьСуммыДопСоглашенийИПлатежей(Договор)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Структура = Новый Структура;
	Структура.Вставить("ДопСоглашение", Документы.Договор.ПолучитьСуммуДопСоглашений(Договор));
	Структура.Вставить("Остаток", Документы.Договор.ПолучитьСуммуОстатка(Договор));
	
	Возврат Структура;
	
КонецФункции // ()

&НаСервере
Процедура ЗаполнитьТаблицуРассрочка()
	
	Объект.Рассрочка.Очистить();
	
	Если Объект.МесяцевРассрочки = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СуммаПервыйПлатеж = Документы.Договор.ПолучитьСуммуАванса(Объект.Ссылка);
	ДатаРассрочки = Объект.Дата;
	НужноРаспределить = Объект.СуммаДокумента - СуммаПервыйПлатеж;
	ОсталосьРаспределить = НужноРаспределить;
	
	Для ы = 1 По Объект.МесяцевРассрочки Цикл
		
		ДатаРассрочки = ДобавитьМесяц(ДатаРассрочки, 1);
		
		Если ы = Объект.МесяцевРассрочки Тогда
			
			СуммаРаспределения = ОсталосьРаспределить;
			
		Иначе
			
			ПредполагаемаяСумма = Окр(НужноРаспределить / Объект.МесяцевРассрочки, -2);
			СуммаРаспределения = Мин(ПредполагаемаяСумма, ОсталосьРаспределить);
			
		КонецЕсли;
		
		ОсталосьРаспределить = ОсталосьРаспределить - СуммаРаспределения;
		НоваяСтрока = Объект.Рассрочка.Добавить();
		НоваяСтрока.Дата = ДатаРассрочки;
		НоваяСтрока.Сумма = СуммаРаспределения;
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьРассрочку()

&НаКлиенте
Процедура АктВыполненияСпецификацииНажатие(Элемент, СтандартнаяОбработка)
	
	Если ТипЗнч(АктВыполнения) = Тип("Строка") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если Найти(АктВыполнения, "Ошибка") <> 0 Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыАктВыполненияСпецификации = Новый Структура();
		ПараметрыАктВыполненияСпецификации.Вставить("Основание", Объект.Ссылка);
		ФормаГрафикМонтажа = ПолучитьФорму("Документ.АктВыполненияДоговора.ФормаОбъекта", ПараметрыАктВыполненияСпецификации, ЭтаФорма);
		ФормаГрафикМонтажа.Открыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОрганизацию(Подразделение, Контрагент)
	
	Если Контрагент.ЮридическоеЛицо Тогда
		
		Организация = Константы.ОрганизацияДляДоговоровСЮрЛицами.Получить();
		
	Иначе
		
		Организация = Подразделение.Организация;
		
	КонецЕсли;
	
	Возврат Организация;
	
КонецФункции // ПолучитьОрганизацию()

&НаСервереБезКонтекста
Функция СпецификацияПроверена(СпецификацияСсылка)
	
	Статус = Документы.Спецификация.ПолучитьСтатусСпецификации(СпецификацияСсылка);
	
	Если Статус = Перечисления.СтатусыСпецификации.Проверен Тогда
		Ответ =  Истина;
	Иначе
		ТекстСообщения = "Для ввода договора, спецификация должна быть проверена технологом расчетного центра";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Ответ = Ложь;
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.Организация.Пустая() Тогда
		ТекущийОбъект.Организация = ПолучитьОрганизацию(ТекущийОбъект.Подразделение, ТекущийОбъект.Контрагент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьОстатокОплаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ЗаполнитьОстатокОплаты();
	
	ИзмененияДоговора.Параметры.УстановитьЗначениеПараметра("Договор", Объект.Ссылка);
	
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Договор", Объект.Ссылка);
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Контрагент", Объект.Контрагент);
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Подразделение", Объект.Подразделение);
	
	Если НЕ ВладелецФормы = Неопределено Тогда
		
		ЗакрыватьПриВыборе = Ложь;
		ОповеститьОВыборе(Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

//&НаСервереБезКонтекста
//Функция ПолучитьМонтаж(Спецификация)

//	Структура = Новый Структура;
//	Структура.Вставить("УслугаМонтаж", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Спецификация, "УслугаМонтаж"));
//	
//	Параметры = Новый Структура;
//	Параметры.Вставить("Подразделение", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Спецификация, "Подразделение"));
//	Параметры.Вставить("Спецификация", Спецификация);
//	Параметры.Вставить("ДатаДоставки", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Спецификация, "ДатаДоставки"));
//	Параметры.Вставить("ДатаМонтажа", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Спецификация, "ДатаМонтажа"));
//	
//	Структура.Вставить("Параметры", Параметры);
//	
//	Запрос = Новый Запрос;
//	Запрос.УстановитьПараметр("Спецификация", Спецификация);
//	Запрос.Текст = 
//	"ВЫБРАТЬ
//	|	Монтаж.Ссылка
//	|ИЗ
//	|	Документ.Монтаж КАК Монтаж
//	|ГДЕ
//	|	Монтаж.Спецификация = &Спецификация";
//	Выборка = Запрос.Выполнить().Выбрать();
//	
//	КоличествоМонтажей = 0;
//	
//	Пока Выборка.Следующий() Цикл
//		
//		КоличествоМонтажей =  КоличествоМонтажей + 1;
//		
//	КонецЦикла;
//	
//	Структура.Вставить("КоличествоМонтажей", КоличествоМонтажей);
//	
//	Возврат Структура;
//	
//КонецФункции // ПолучитьМонтаж(Спецификация);()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Договор = Неопределено;
	
	Если ЗначениеЗаполнено(Параметры.Основание) Тогда
		
		Если ТипЗнч(Параметры.Основание) = Тип("ДокументСсылка.Спецификация") Тогда
			
			Договор = Документы.Спецификация.ПолучитьДоговор(Параметры.Основание);
			
			Если НЕ Договор.Пустая() Тогда
				
				Отказ 					= Истина;
				Сообщение 			= Новый СообщениеПользователю();
				Сообщение.Текст 	= "Договор на основании данной спецификации уже существует";
				Сообщение.Сообщить();
				Возврат;
				
			КонецЕсли;
			
			// проверить статус спецификации
			
			//Отказ = НЕ СпецификацияПроверена(Параметры.Основание);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Договор = ?(Договор = Неопределено, Объект.Ссылка, Договор);
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Договор", Объект.Ссылка);
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Контрагент", Договор.Контрагент);
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Подразделение", Договор.Подразделение);
	ИзмененияДоговора.Параметры.УстановитьЗначениеПараметра("Договор", Объект.Ссылка);
	
	// Акт выполнения
	АктВыполнения = Документы.Договор.ПолучитьАктВыполнения(Объект.Ссылка);
	Если НЕ ЗначениеЗаполнено(АктВыполнения) Тогда
		АктВыполнения = "Ввести Акт";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПересчитатьРассрочкуСкидку();
	КонецЕсли;

	//// Монтаж
	//МассивМонтажей = ЛексСервер.НайтиПодчиненныеДокументы(Договор, "Документ.Монтаж", "Договор");
	//
	//Если МассивМонтажей.Количество() = 1 Тогда
	//	
	//	Монтаж = МассивМонтажей[0];
	//	
	//ИначеЕсли МассивМонтажей.Количество() = 0 Тогда
	//	
	//	Монтаж = "Ввести монтаж";
	//	
	//Иначе
	//	
	//	Монтаж = "Ошибка связи Графика монтажа с Договором";
	//	
	//КонецЕсли;
	
	// заполнить динамичесие таблицы
	// Платежи и Изменения договора
	//ЗаполнитьТаблицуИзмененияДоговора();
	//ЗаполнитьТаблицуОплаты();
	//ОбновитьСостояниеИзделий();
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ПользовательИнженер = УправлениеДоступомПереопределяемый.ЕстьДоступКПрофилюГруппДоступа(Пользователь, Справочники.ПрофилиГруппДоступа.Администратор);
	Если ПользовательИнженер Тогда
		
		ЭтаФОрма.Элементы.Рассрочка.ТолькоПросмотр = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элемент.ТекущиеДанные.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмененияДоговораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элемент.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежныеДокументыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	//ОповеститьОбИзменении(
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ДокументСсылка.АктВыполненияДоговора") Тогда
		
		АктВыполнения = ВыбранноеЗначение;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Контрагент", Объект.Контрагент);
	Объект.Организация = ПолучитьОрганизацию(Объект.Подразделение, Объект.Контрагент);
	ПересчитатьРассрочкуСкидку();
	
КонецПроцедуры

&НаКлиенте
Процедура СпецификацияПриИзменении(Элемент)
	
	СтруктураДанныхСпецификации = СпецификацияПриИзмененииНаСервере(Объект.Спецификация);
	ПересчитатьСуммуДокумента();
	Если СтруктураДанныхСпецификации.УслугаМонтаж Тогда 
		Объект.ДатаУстановитьНеПозднее = ?(ЗначениеЗаполнено(СтруктураДанныхСпецификации.ДатаМонтажа), СтруктураДанныхСпецификации.ДатаМонтажа + 30*24*3600, Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СпецификацияПриИзмененииНаСервере(Ссылка)
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("СуммаДокумента", Ссылка.СуммаДокумента);
	СтруктураДанных.Вставить("ДатаМонтажа", Ссылка.ДатаМонтажа);
	СтруктураДанных.Вставить("УслугаМонтаж", Ссылка.УслугаМонтаж);
	СтруктураДанных.Вставить("Доставка", Ссылка.Доставка);
	СтруктураДанных.Вставить("Упаковка", Ссылка.Упаковка);
	Возврат СтруктураДанных;
	
КонецФункции

&НаКлиенте
Процедура ВидОплатыДоговораПриИзменении(Элемент)
	
	ПересчитатьРассрочкуСкидку();
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьРассрочкуСкидку()
	
	ДоговорСЮрЛицом = Объект.Контрагент.ЮридическоеЛицо;
	
	Элементы.ВидОплатыДоговора.Доступность = НЕ ДоговорСЮрЛицом;
	
	Если ДоговорСЮрЛицом Тогда
		Объект.ВидОплатыДоговора = Перечисления.ВидыОплатыДоговоров.Рассрочка1Месяц;
	КонецЕсли;
	
	Объект.ПроцентСкидки = ПолучитьСкидку();
	
	ВидОплатыСтрокой = Объект.ВидОплатыДоговора;
	Объект.Банк = Неопределено;
	
	Если ВидОплатыСтрокой = Перечисления.ВидыОплатыДоговоров.Рассрочка1Месяц Тогда
		Объект.МесяцевРассрочки = 1;
	ИначеЕсли ВидОплатыСтрокой = Перечисления.ВидыОплатыДоговоров.Рассрочка4Месяца Тогда
		Объект.МесяцевРассрочки = 4;
	ИначеЕсли ВидОплатыСтрокой = Перечисления.ВидыОплатыДоговоров.БанковскийКредит 
		или ВидОплатыСтрокой = Перечисления.ВидыОплатыДоговоров.Предоплата50БанковскийКредит Тогда
		Объект.Банк = Константы.БанкДляРассрочкиКлиенту;
		Объект.МесяцевРассрочки = 0;
	ИначеЕсли ВидОплатыСтрокой = Перечисления.ВидыОплатыДоговоров.ПолнаяПредоплата Тогда
		Объект.МесяцевРассрочки = 0;
	КонецЕсли;
	
	ЗаполнитьТаблицуРассрочка();
	
	ПересчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Объект.Организация = ПолучитьОрганизацию(Объект.Подразделение, Объект.Контрагент);
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Подразделение", Объект.Подразделение);
	ПересчитатьРассрочкуСкидку();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ПересчитатьРассрочкуСкидку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежныеДокументыПриИзменении(Элемент)
	
	ЗаполнитьОстатокОплаты();	
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмененияДоговораСсылкаПриИзменении(Элемент)
	
	ЗаполнитьОстатокОплаты();
	
КонецПроцедуры


