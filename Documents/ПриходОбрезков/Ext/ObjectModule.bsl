﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.ОбрезкиМатериалов.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПриходОбрезковСписокНоменклатуры.Высота,
	|	СУММА(ПриходОбрезковСписокНоменклатуры.Количество) КАК Количество,
	|	ПриходОбрезковСписокНоменклатуры.Номенклатура,
	|	ПриходОбрезковСписокНоменклатуры.Ширина
	|ИЗ
	|	Документ.ПриходОбрезков.СписокНоменклатуры КАК ПриходОбрезковСписокНоменклатуры
	|ГДЕ
	|	ПриходОбрезковСписокНоменклатуры.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПриходОбрезковСписокНоменклатуры.Номенклатура,
	|	ПриходОбрезковСписокНоменклатуры.Высота,
	|	ПриходОбрезковСписокНоменклатуры.Ширина";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Запись = Движения.ОбрезкиМатериалов.ДобавитьПриход();
		Запись.Подразделение = Подразделение;
		Запись.Период = Дата;
		Запись.Номенклатура = Выборка.Номенклатура;
		Запись.Ширина = Выборка.Ширина;
		Запись.Высота = Выборка.Высота;
		Запись.Количество = Выборка.Количество;
	КонецЦикла;
	
	Движения.ОбрезкиХлыстовойМатериал.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Хлысты.Длина,
	|	СУММА(Хлысты.Количество) КАК Количество,
	|	Хлысты.Номенклатура
	|ИЗ
	|	Документ.ПриходОбрезков.СписокХлыстовойНоменклатуры КАК Хлысты
	|ГДЕ
	|	Хлысты.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Хлысты.Номенклатура,
	|	Хлысты.Длина";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Запись = Движения.ОбрезкиХлыстовойМатериал.ДобавитьПриход();
		Запись.Подразделение = Подразделение;
		Запись.Период = Дата;
		Запись.Номенклатура = Выборка.Номенклатура;
		Запись.Длина = Выборка.Длина;
		Запись.Количество = Выборка.Количество;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Ошибки;
	
	Для Каждого Строка Из СписокНоменклатуры Цикл
		
		Если НЕ Строка.Номенклатура.НоменклатурнаяГруппа.ВидМатериала = Перечисления.ВидыМатериалов.Листовой Тогда
			
			ТекстСообщения = "" + Строка.Номенклатура + " не листовой материал";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.СписокНоменклатуры[%1].Номенклатура", ТекстСообщения,,Строка.НомерСтроки - 1);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Строка Из СписокХлыстовойНоменклатуры Цикл
		
		Если НЕ Строка.Номенклатура.НоменклатурнаяГруппа.ВидМатериала = Перечисления.ВидыМатериалов.Хлыстовой Тогда
			
			ТекстСообщения = "" + Строка.Номенклатура + " не хлыстовой материал";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.СписокХлыстовойНоменклатуры[%1].Номенклатура", ТекстСообщения,,Строка.НомерСтроки - 1);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры
