﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТаблицаОбрезков = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыОбрезков);
		
	Запрос = Новый Запрос;
	Переименование = Ложь;
	
	Если ЗначениеЗаполнено(Параметры.АдресТаблицыИспользующейсяНомеклатуры) Тогда
		ТаблицаИспользующейсяНомеклатуры = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыИспользующейсяНомеклатуры);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(тзНоменклатура.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура
		|ПОМЕСТИТЬ втНоменклатура
		|ИЗ
		|	&тзНоменклатура КАК тзНоменклатура
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОбрезкиМатериаловОстатки.Номенклатура,
		|	ОбрезкиМатериаловОстатки.Высота,
		|	ОбрезкиМатериаловОстатки.Ширина,
		|	ОбрезкиМатериаловОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	РегистрНакопления.ОбрезкиМатериалов.Остатки(
		|			,
		|			Подразделение = &Подразделение
		|				И Номенклатура В
		|					(ВЫБРАТЬ
		|						втНоменклатура.Номенклатура
		|					ИЗ
		|						втНоменклатура КАК втНоменклатура)) КАК ОбрезкиМатериаловОстатки
		|ГДЕ
		|	ОбрезкиМатериаловОстатки.КоличествоОстаток > 0";
		
		Запрос.УстановитьПараметр("тзНоменклатура", ТаблицаИспользующейсяНомеклатуры);
		
	Иначе
		
		Переименование = Истина;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбрезкиМатериаловОстатки.Номенклатура КАК Номенклатура,
		|	ОбрезкиМатериаловОстатки.Высота КАК Высота,
		|	ОбрезкиМатериаловОстатки.Ширина,
		|	ОбрезкиМатериаловОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	РегистрНакопления.ОбрезкиМатериалов.Остатки(
		|			,
		|			Подразделение = &Подразделение
		|				И Номенклатура.НоменклатурнаяГруппа.ВидМатериала = &ВидМатериала) КАК ОбрезкиМатериаловОстатки
		|ГДЕ
		|	ОбрезкиМатериаловОстатки.КоличествоОстаток > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номенклатура,
		|	Высота";
		
		Запрос.УстановитьПараметр("ВидМатериала", Перечисления.ВидыМатериалов.Листовой);
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Дата", Параметры.Дата);
	Запрос.УстановитьПараметр("Подразделение", Параметры.Подразделение);

	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Для Счетчик = 1 По ВыборкаДетальныеЗаписи.Количество Цикл
			НоваяСтрока = ТаблицаОстатков.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
		КонецЦикла;
		
	КонецЦикла;
	
	Если ТаблицаОбрезков.Количество() > 0 Тогда
		
		Для каждого Строка Из ТаблицаОбрезков Цикл
			
			Отбор = Новый Структура;
			Отбор.Вставить("Выбрать", Ложь);
			Отбор.Вставить("Номенклатура", Строка.Номенклатура);
			Если Переименование Тогда
				Отбор.Вставить("Высота", Строка.Высота);
				Отбор.Вставить("Ширина", Строка.Ширина);
			Иначе
				Отбор.Вставить("Высота", Строка.ВысотаОстатка);
				Отбор.Вставить("Ширина", Строка.ШиринаОстатка);
			КонецЕсли;
			МассивРезультатов = ТаблицаОстатков.НайтиСтроки(Отбор);
			
			Если МассивРезультатов.Количество() > 0 Тогда
				МассивРезультатов[0].Выбрать = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Структура = Новый Структура;
	Структура.Вставить("АдресХранилища", ПолучитьАдресХранилища());
	ОповеститьОВыборе(Структура);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресХранилища()
	
	СтруктураДляОстатков = Новый Структура;
	СтруктураДляОстатков.Вставить("Выбрать", Истина);
	МассивОстатков = ТаблицаОстатков.НайтиСтроки(СтруктураДляОстатков);
	Возврат ПоместитьВоВременноеХранИЛИще(ТаблицаОстатков.Выгрузить(МассивОстатков));
	
КонецФункции

&НаКлиенте
Процедура УстановитьОтметки(Команда)
		ПоставитьСнятьОтметки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметки(Команда)
		ПоставитьСнятьОтметки(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПоставитьСнятьОтметки(Отметка)
	    Для каждого Строка Из ТаблицаОстатков Цикл
			     Строка.Выбрать = Отметка;
		КонецЦикла;
КонецПроцедуры


