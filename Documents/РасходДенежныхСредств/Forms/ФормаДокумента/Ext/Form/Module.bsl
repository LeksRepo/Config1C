﻿
////////////////////////////////////////////////////////////////////////////////
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
	
	РассчитатьОстаток = Объект.ВидОперации = Перечисления.ВидыОпераций.ВыплатаЗаработнойПлатыРаботнику;
	
	СчетПриИзмененииСервер("Дт");
	СчетПриИзмененииСервер("Кт");
	
	Если РассчитатьОстаток Тогда
		РассчитатьОстатокНаСервере();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииНаКлиенте()
	
	РассчитатьОстаток = Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОпераций.ВыплатаЗаработнойПлатыРаботнику");
	
	СчетПриИзмененииСервер("Дт");
	СчетПриИзмененииСервер("Кт");
	
	Если РассчитатьОстаток Тогда
		РассчитатьОстатокНаСервере();
	КонецЕсли;	
	
	Элементы.СчетДт.Доступность = НЕ ЗначениеЗаполнено(Объект.СчетДт);
	Элементы.СчетКт.Доступность = НЕ ЗначениеЗаполнено(Объект.СчетКт);
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьОстатокНаСервере()
	
	Остаток = БухгалтерскийУчетСервер.ПолучитьОстатокПоСчету(Объект.СчетДт, Объект.Субконто1Дт, Объект.Подразделение);
	
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
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
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
	
	Элементы.СчетДт.Доступность = НЕ ЗначениеЗаполнено(Объект.СчетДт);
	Элементы.СчетКт.Доступность = НЕ ЗначениеЗаполнено(Объект.СчетКт);
	
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
Процедура Субконто1ДтПриИзменении(Элемент)
	
	Если РассчитатьОстаток Тогда
		РассчитатьОстатокНаСервере();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Если РассчитатьОстаток Тогда
		РассчитатьОстатокНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОбИзменении(Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ <Наименование>

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

