﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Параметры.Подразделение);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Остатки.Номенклатура КАК Номенклатура,
	|	Остатки.Длина КАК Длина,
	|	Остатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.ОбрезкиХлыстовойМатериал.Остатки(, Подразделение = &Подразделение) КАК Остатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	Длина";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Для Счетчик = 1 По ВыборкаДетальныеЗаписи.Количество Цикл
			НоваяСтрока = ТаблицаОстатков.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
		КонецЦикла;
		
	КонецЦикла;
	
	ОтметитьСуществующиеВДокументе(Параметры.АдресТаблицыОбрезков);
	
КонецПроцедуры

&НаСервере
Функция ОтметитьСуществующиеВДокументе(АдресХранилища)
	
	ТаблицаОбрезков = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыОбрезков);
	
	Для каждого Строка Из ТаблицаОбрезков Цикл
		
		Отбор = Новый Структура;
		Отбор.Вставить("Выбрать", Ложь);
		Отбор.Вставить("Номенклатура", Строка.Номенклатура);
		Отбор.Вставить("Длина", Строка.Длина);
		
		МассивРезультатов = ТаблицаОстатков.НайтиСтроки(Отбор);
		
		Если МассивРезультатов.Количество() > 0 Тогда
			МассивРезультатов[0].Выбрать = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

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
