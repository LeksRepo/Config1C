﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка 		= Ложь;
	СхемаКомпоновкиДанных 	= ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Настройки 							= СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КомпоновщикМакета 			= Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки 				= КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	НастройкаДаты = КомпоновщикНастроек.ПолучитьНастройки().ПараметрыДанных.Элементы[0].Значение;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяДата", КонецДня(НастройкаДаты.Дата));
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УправленческийОстатки.Субконто2 КАК Договор,
	|	Договор.Автор.ФизическоеЛицо КАК Автор,
	|	Договор.Комментарий,
	|	Договор.Подразделение,
	|	Договор.СуммаДокумента КАК СуммаДоговора
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			&ТекущаяДата,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ВзаиморасчетыСПокупателями),
	|			,
	|			Субконто2 ССЫЛКА Документ.Договор
	|				И (ВЫРАЗИТЬ(Субконто2 КАК Документ.Договор)) <> ЗНАЧЕНИЕ(Документ.Договор.ПустаяСсылка)) КАК УправленческийОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК Договор
	|		ПО ((ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Документ.Договор)) = Договор.Ссылка)";
	
	Выборка = Запрос.Выполнить().Выгрузить();
	ТЗ = Документы.Договор.РасчетПени(Выборка.ВыгрузитьКолонку("Договор"), КонецДня(НастройкаДаты.Дата));
		
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТЗ", ТЗ);

	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры
