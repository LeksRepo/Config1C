﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ВидОперацииНаСервере()
	
	СтруктураСчетов = БухгалтерскийУчетСервер.ПолучитьСчетаПоВидуОперации(Объект.ВидОперации);
	Объект.СчетДт = СтруктураСчетов.СчетДт; 
	Объект.СчетКт = СтруктураСчетов.СчетКт;
	
	СчетПриИзмененииСервер("Дт");
	СчетПриИзмененииСервер("Кт");
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииНаКлиенте()
	
	СчетПриИзмененииСервер("Дт");
	СчетПриИзмененииСервер("Кт");
	
	ПрочийПриход = Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОпераций.ПрочийПриход");
	
	Элементы.СчетДт.Доступность = НЕ ЗначениеЗаполнено(Объект.СчетДт) ИЛИ ПрочийПриход;
	Элементы.СчетКт.Доступность = НЕ ЗначениеЗаполнено(Объект.СчетКт) ИЛИ ПрочийПриход;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

&НаСервере
Процедура СчетПриИзмененииСервер(ВидСчета)
	
	ЗаголовкиСубконто = Новый Структура;
	ЗаголовкиСубконто.Вставить("Субконто1", Ложь);
	ЗаголовкиСубконто.Вставить("Субконто2", Ложь);
	ЗаголовкиСубконто.Вставить("Субконто3", Ложь);
	
	Субконто = Объект["Счет" + ВидСчета].ВидыСубконто;
	Для Каждого Стр Из Субконто Цикл
		ИмяСубконто = "Субконто" + Стр.НомерСтроки + ВидСчета;
		Объект[ИмяСубконто] = Стр.ВидСубконто.ТипЗначения.ПривестиЗначение(Объект[ИмяСубконто]);
		Элементы[ИмяСубконто].Заголовок = Стр.ВидСубконто.Наименование;
		ЗаголовкиСубконто["Субконто" + Стр.НомерСтроки] = Истина;
	КонецЦикла;
	
	Элементы["Субконто1" + ВидСчета].Видимость = ЗаголовкиСубконто["Субконто1"];
	Элементы["Субконто2" + ВидСчета].Видимость = ЗаголовкиСубконто["Субконто2"];
	Элементы["Субконто3" + ВидСчета].Видимость = ЗаголовкиСубконто["Субконто3"];
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ДокументСозданКопированием = ЗначениеЗаполнено(Параметры.ЗначениеКопирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И НЕ ДокументСозданКопированием Тогда	
		ВидОперацииПриИзменении();
	Иначе
		ВидОперацииНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ СВОЙСТВ И КАТЕГОРИЙ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент = Неопределено)
	
	ВидОперацииНаСервере();
	
	ПрочийПриход = Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОпераций.ПрочийПриход");
	
	Элементы.СчетДт.Доступность = НЕ ЗначениеЗаполнено(Объект.СчетДт) ИЛИ ПрочийПриход;
	Элементы.СчетКт.Доступность = НЕ ЗначениеЗаполнено(Объект.СчетКт) ИЛИ ПрочийПриход;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетДтПриИзменении(Элемент)
	
	СчетПриИзмененииСервер("Дт");
	
КонецПроцедуры

&НаКлиенте
Процедура СчетКтПриИзменении(Элемент)
	
	СчетПриИзмененииСервер("Кт");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОбИзменении(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто2ДтНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// { Васильев Александр Леонидович [13.01.2015]
	// Костыль.
	// Одинаковый код с ПриходомДенежныхСредств.
	// Объеденить, вынести в общий модуль.
	// } Васильев Александр Леонидович [13.01.2015]
	
	ТипСубконто = ТипЗнч(Объект.Субконто2Дт);
	
	Если ТипСубконто = Тип("СправочникСсылка.Счета") 
		ИЛИ ТипСубконто = Тип("СправочникСсылка.Кассы") Тогда
	
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПринадлежитПодразделению", Объект.Подразделение);
		ПараметрыФормы.Вставить("Активность", Истина);
		
		ЗначениеСправочника = Неопределено;
		
		Если ТипСубконто = Тип("СправочникСсылка.Счета") Тогда
			ИмяФормыВыбора = "Справочник.Счета.ФормаВыбора";
		Иначе
			ИмяФормыВыбора = "Справочник.Кассы.ФормаВыбора";
		КонецЕсли;
		
		ЗначениеСправочника = ОткрытьФормуМодально(ИмяФормыВыбора, Новый Структура("Отбор", ПараметрыФормы));
		
		Если ЗначениеСправочника <> Неопределено Тогда
			Объект.Субконто2Дт = ЗначениеСправочника;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ <Наименование>

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
