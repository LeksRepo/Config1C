﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиенте
Функция ОбновитьДоступностьВидОплаты()
	
	ВидОплаты = Объект.ВидОплатыДоговора;
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ДоговорСЮрЛицом = ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.Контрагент, "ЮридическоеЛицо");
		Элементы.ВидОплатыДоговора.Доступность = НЕ ДоговорСЮрЛицом;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПересчитатьСуммуДокумента()
	
	Если ЗначениеЗаполнено(Объект.Спецификация) Тогда
		СтоимостьСпецификации = ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.Спецификация, "СуммаДокумента");
		Объект.СуммаДокументаБезСкидки = СтоимостьСпецификации;
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
		ОткрытьФорму("Документ.АктВыполненияДоговора.ФормаОбъекта", ПараметрыАктВыполненияСпецификации, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОрганизацию(Подразделение, Офис, Контрагент)
	
	Если Контрагент.ЮридическоеЛицо И НЕ Подразделение.БрендДилер Тогда
		
		Организация = Константы.ОрганизацияДляДоговоровСЮрЛицами.Получить();
		
	Иначе
		
		ОрганизацияОфиса = Офис.Организация;
		
		Если ЗначениеЗаполнено(ОрганизацияОфиса) Тогда
			Организация = ОрганизацияОфиса;
		Иначе
			Организация = Подразделение.Организация;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Организация;
	
КонецФункции // ПолучитьОрганизацию()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.Организация.Пустая() Тогда
		ТекущийОбъект.Организация = ПолучитьОрганизацию(ТекущийОбъект.Подразделение, ТекущийОбъект.Офис, ТекущийОбъект.Контрагент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьСкидки = Ложь;
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И ЗначениеЗаполнено(Объект.Спецификация) Тогда
		ИзменитьСкидки = Истина;
		ДатаМонтажа = ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.Спецификация, "ДатаМонтажа");
		Если НЕ ЗначениеЗаполнено(ДатаМонтажа) Тогда
			Режим = РежимДиалогаВопрос.ДаНет;
			Ответ = Вопрос("Договор без даты монтажа" + Символы.ПС + "Продолжить?", Режим, 0);
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьОстатокОплаты();
	ОбновитьДоступностьВидОплаты();
	
	ПересчитатьСкидку(ИзменитьСкидки);
	
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

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	Договор = Неопределено;
	
	Если ЗначениеЗаполнено(Параметры.Основание) Тогда
		
		Если ТипЗнч(Параметры.Основание) = Тип("ДокументСсылка.Спецификация") Тогда
			
			// проверка статуса
			Отказ = НЕ Документы.Договор.СпецификацияПроверена(Параметры.Основание);
			
			// проверка уже существующего договора
			ДоговорСпецификации = Документы.Спецификация.ПолучитьДоговор(Параметры.Основание);
			Если НЕ ДоговорСпецификации.Пустая() Тогда
				Отказ = Истина;
				ТекстСообщения = "К " + Параметры.Основание + " уже введен " + ДоговорСпецификации;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
			
			// проверка корректного вида изделия
			Если НЕ Документы.Договор.РазрешеноВвестиДоговор(Параметры.Основание) Тогда
				Отказ = Истина;
				ТекстСообщения = "Для изделия вида " + ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Основание, "Изделие") + " запрещено вводить договор.";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
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
		Объект.Дата = ТекущаяДата();
		ЗаполнитьТаблицуРассрочка();
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
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ДокументСсылка.АктВыполненияДоговора") Тогда
		АктВыполнения = ВыбранноеЗначение;
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("ДокументСсылка.ПриходДенежныхСредств") Тогда
		ЗаполнитьТаблицуРассрочка();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Контрагент", Объект.Контрагент);
	Объект.Организация = ПолучитьОрганизацию(Объект.Подразделение, Объект.Офис, Объект.Контрагент);
	
	ДоговорСЮрЛицом = ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.Контрагент, "ЮридическоеЛицо");
	Если ДоговорСЮрЛицом Тогда
		Объект.ВидОплатыДоговора = ПредопределенноеЗначение("Перечисление.ВидыОплатыДоговоров.Рассрочка1Месяц");
	КонецЕсли;
	
	ОбновитьДоступностьВидОплаты();
	ПересчитатьСкидку();
	ЗаполнитьТаблицуРассрочка();
	ЗаполнитьОстатокОплаты();
	
КонецПроцедуры

&НаКлиенте
Процедура СпецификацияПриИзменении(Элемент)
	
	СтруктураДанныхСпецификации = СпецификацияПриИзмененииНаСервере(Объект.Спецификация);
	
	Если СтруктураДанныхСпецификации = Неопределено Тогда
		
		ТекстСообщения = "Для изделия вида " + ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.Спецификация, "Изделие") + " запрещено вводить договор.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Ссылка);
		Объект.Спецификация = Неопределено;
		
	ИначеЕсли ТипЗнч(СтруктураДанныхСпецификации) = Тип("Структура") Тогда
		ПересчитатьСуммуДокумента();
		ПересчитатьСкидку();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СпецификацияПриИзмененииНаСервере(СпецификацияСсылка)
	
	Если Документы.Договор.РазрешеноВвестиДоговор(СпецификацияСсылка) Тогда
		СтруктураДанных = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СпецификацияСсылка, "СуммаДокумента, ДатаМонтажа, Упаковка, ПакетУслуг");
		СтруктураДанных.Вставить("УслугаМонтаж", СтруктураДанных.ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж);
	КонецЕсли;
	
	Возврат СтруктураДанных;
	
КонецФункции

&НаКлиенте
Процедура ВидОплатыДоговораПриИзменении(Элемент)
	
	ВидОплатыСтрока = Объект.ВидОплатыДоговора;
	
	// { Васильев Александр Леонидович [21.12.2013]
	// ой некрасиво с этим предопределенным значением...
	// } Васильев Александр Леонидович [21.12.2013]
	
	Если ВидОплатыСтрока = ПредопределенноеЗначение("Перечисление.ВидыОплатыДоговоров.Рассрочка1Месяц") Тогда
		Объект.МесяцевРассрочки = 1;
	ИначеЕсли ВидОплатыСтрока = ПредопределенноеЗначение("Перечисление.ВидыОплатыДоговоров.Рассрочка4Месяца") Тогда
		Объект.МесяцевРассрочки = 4;
	ИначеЕсли ВидОплатыСтрока = ПредопределенноеЗначение("Перечисление.ВидыОплатыДоговоров.БанковскийКредит")
		ИЛИ ВидОплатыСтрока = ПредопределенноеЗначение("Перечисление.ВидыОплатыДоговоров.Предоплата50БанковскийКредит")
		ИЛИ ВидОплатыСтрока = ПредопределенноеЗначение("Перечисление.ВидыОплатыДоговоров.ПолнаяПредоплата") Тогда
		Объект.МесяцевРассрочки = 0;
	КонецЕсли;
	
	ПересчитатьСкидку();
	ЗаполнитьТаблицуРассрочка();
	ЗаполнитьОстатокОплаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСкидку(ИзменитьСуммы = Истина)

	СтруктураСкидка = ЛексСервер.ПолучитьСкидкуДоговора(Объект.Подразделение, Объект.Дата, Объект.СуммаДокументаБезСкидки, Объект.ВидОплатыДоговора, Объект.Офис, Объект.Контрагент, Объект.Ссылка);
	Элементы.СкидкаПостоянномуКлиенту.Заголовок = "Постоянному клиенту скидка + " + СтруктураСкидка.РазмерСкидкиПостоянногоКлиента + "%";
	Элементы.СкидкаПостоянномуКлиенту.Видимость = СтруктураСкидка.ЭтоПостоянныйКлиент;
	
	Если ИзменитьСуммы Тогда
		Объект.ПроцентСкидки = СтруктураСкидка.РазмерСкидки;
		Объект.СуммаДокумента = Объект.СуммаДокументаБезСкидки - (Объект.СуммаДокументаБезСкидки * Объект.ПроцентСкидки / 100);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Объект.Организация = ПолучитьОрганизацию(Объект.Подразделение, Объект.Подразделение, Объект.Контрагент);
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Подразделение", Объект.Подразделение);
	ПересчитатьСкидку();
	ЗаполнитьТаблицуРассрочка();
	ЗаполнитьОстатокОплаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ПересчитатьСкидку();
	ЗаполнитьТаблицуРассрочка();
	ЗаполнитьОстатокОплаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ОфисПриИзменении(Элемент)
	
	Объект.Организация = ПолучитьОрганизацию(Объект.Подразделение, Объект.Офис, Объект.Контрагент);
	ПересчитатьСкидку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежныеДокументыПриИзменении(Элемент)
	
	Если НЕ Объект.Проведен Тогда
		ЗаполнитьТаблицуРассрочка();
	КонецЕсли;
	ЗаполнитьОстатокОплаты();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ЗаполнитьТаблицуРассрочка();
	ЗаполнитьОстатокОплаты();
КонецПроцедуры
