﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиенте
Функция ОбновитьДоступностьВидОплаты()
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ДоговорСЮрЛицом = ЛексСервер.ЗначениеРеквизитаОбъекта(Контрагент, "ЮридическоеЛицо");
		ЗаполнитьВидыОплаты(ДоговорСЮрЛицом);
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьВидыОплаты(ЮрЛицо)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЮрЛицо", ЮрЛицо);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыОплаты.Ссылка
	|ИЗ
	|	Справочник.ВидыОплаты КАК ВидыОплаты
	|ГДЕ
	|	ВидыОплаты.Активность
	|	И ВидыОплаты.Подразделение = &Подразделение
	|	И ВЫБОР
	|			КОГДА &ЮрЛицо
	|				ТОГДА ВидыОплаты.ДоступенДляЮрЛиц
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ";
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Элементы.ВидОплаты.СписокВыбора.ЗагрузитьЗначения(Результат.ВыгрузитьКолонку("Ссылка"));		   
	
КонецПроцедуры

&НаСервере
Функция ПересчитатьСуммуДокумента(СтруктураДанныхСпецификации)
	
	Если ЗначениеЗаполнено(Объект.Спецификация) Тогда
		СтоимостьСпецификации = ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.Спецификация, "СуммаДокумента");
		Объект.СуммаДокументаБезСкидки = СтоимостьСпецификации;
		Объект.ЗарплатаДизайнера = СтруктураДанныхСпецификации.ЗарплатаДизайнера;
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

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И ЗначениеЗаполнено(Объект.Спецификация) Тогда
		
		// Вопрос об открытой дате
		ДатаМонтажа = ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.Спецификация, "ДатаМонтажа");
		
		Если НЕ ЗначениеЗаполнено(ДатаМонтажа) Тогда
			Режим = РежимДиалогаВопрос.ДаНет;
			Ответ = Вопрос("Договор с открытой датой монтажа" + Символы.ПС + "Продолжить?", Режим, 0);
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьОстатокОплаты();
	ОбновитьДоступностьВидОплаты();
	ЗаполнитьТаблицуРассрочка();
			
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКонтрагента(Спецификация)
	
	Возврат Спецификация.Контрагент;
	
КонецФункции

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ЗаполнитьОстатокОплаты();
	
	ИзмененияДоговора.Параметры.УстановитьЗначениеПараметра("Договор", Объект.Ссылка);
	
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Договор", Объект.Ссылка);
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Контрагент", Контрагент);
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
	
	// { Васильев Александр Леонидович [16.06.2015]
	// Сделать.
	// СообщитьОшибкиПользователю()
	// } Васильев Александр Леонидович [16.06.2015]
	
	Если ЗначениеЗаполнено(Параметры.Основание) Тогда
		
		Если ТипЗнч(Параметры.Основание) = Тип("ДокументСсылка.Спецификация") Тогда
			
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
	
	Контрагент = Объект.Спецификация.Контрагент;
		
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Договор", Объект.Ссылка);
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Контрагент", Контрагент);
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Подразделение", Объект.Подразделение);
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
		Если Объект.МесяцевРассрочки > 0 Тогда
			ЗаполнитьТаблицуРассрочка();
			Записать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпецификацияПриИзменении(Элемент)
	
	СтруктураДанныхСпецификации = СпецификацияПриИзмененииНаСервере(Объект.Спецификация);
	Контрагент = ПолучитьКонтрагента(Объект.Спецификация);
	
	Если СтруктураДанныхСпецификации = Неопределено Тогда
		
		ТекстСообщения = "Для изделия вида " + ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.Спецификация, "Изделие") + " запрещено вводить договор.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Ссылка);
		Объект.Спецификация = Неопределено;
		
	ИначеЕсли ТипЗнч(СтруктураДанныхСпецификации) = Тип("Структура") Тогда
		ПересчитатьСуммуДокумента(СтруктураДанныхСпецификации);
		ПересчитатьСкидку();		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СпецификацияПриИзмененииНаСервере(СпецификацияСсылка)
	
	Если Документы.Договор.РазрешеноВвестиДоговор(СпецификацияСсылка) Тогда
		СтруктураДанных = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СпецификацияСсылка, "СуммаДокумента, ДатаМонтажа, Упаковка, ПакетУслуг, ЗарплатаДизайнера");
		СтруктураДанных.Вставить("УслугаМонтаж", СтруктураДанных.ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж);
	КонецЕсли;
	
	Возврат СтруктураДанных;
	
КонецФункции

&НаКлиенте
Процедура ПересчитатьСкидку()
	
	ВидОплаты = Объект.ВидОплаты;
	
	СтруктураСкидка = ЛексСервер.ПолучитьСкидкуДоговора(Объект.СуммаДокументаБезСкидки, ВидОплаты); 
	
	Объект.ПроцентСкидки = СтруктураСкидка.РазмерСкидки;
	
	Если СтруктураСкидка.СуммаДокумента <> 0 Тогда
		Объект.СуммаДокумента = СтруктураСкидка.СуммаДокумента - (СтруктураСкидка.СуммаДокумента * Объект.ПроцентСкидки / 100);
	Иначе
		Объект.СуммаДокумента = Объект.СуммаДокументаБезСкидки - (Объект.СуммаДокументаБезСкидки * Объект.ПроцентСкидки / 100);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ПлатежныеДокументы.Параметры.УстановитьЗначениеПараметра("Подразделение", Объект.Подразделение);
	ПересчитатьСкидку();
	ЗаполнитьТаблицуРассрочка();
	ЗаполнитьОстатокОплаты();
	ОбновитьДоступностьВидОплаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ПересчитатьСкидку();
	ЗаполнитьТаблицуРассрочка();
	ЗаполнитьОстатокОплаты();
	
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

&НаКлиенте
Процедура ВидОплатыПриИзменении(Элемент)
	
	Объект.МесяцевРассрочки = ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.ВидОплаты, "КоличествоМесяцевРассрочки");
	
	ПересчитатьСкидку();
	ЗаполнитьТаблицуРассрочка();
	ЗаполнитьОстатокОплаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСуммаДоговора(Команда)
	
	Парам = Новый Структура();
	Парам.Вставить("Скидка", Объект.ПроцентСкидки);
	Парам.Вставить("СуммаБезСкидки", Объект.СуммаДокументаБезСкидки);
	
	НоваяСумма = ОткрытьФормуМодально("Документ.Договор.Форма.ФормаСуммаДокумента", Парам);
	
	Если ЗначениеЗаполнено(НоваяСумма) Тогда
	
		Объект.СуммаДокументаБезСкидки = НоваяСумма; 
		
		ПересчитатьСкидку();
		ЗаполнитьТаблицуРассрочка();
		ЗаполнитьОстатокОплаты();
		
	КонецЕсли;
	
КонецПроцедуры
