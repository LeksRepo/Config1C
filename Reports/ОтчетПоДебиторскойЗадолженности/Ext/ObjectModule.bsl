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
	|	Договор.Автор,
	|	Договор.Комментарий,
	|	Договор.Подразделение,
	|	Договор.СуммаДокумента КАК СуммаДоговора
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(&ТекущаяДата, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ВзаиморасчетыСПокупателями), , ТИПЗНАЧЕНИЯ(Субконто2) = ТИП(Документ.Договор)) КАК УправленческийОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК Договор
	|		ПО УправленческийОстатки.Субконто2 = Договор.Ссылка
	|ГДЕ
	|	УправленческийОстатки.СуммаОстаток <> 0";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Договор");
	ТЗ.Колонки.Добавить("Автор");
	ТЗ.Колонки.Добавить("СуммаДоговора");
	ТЗ.Колонки.Добавить("Комментарий");
	ТЗ.Колонки.Добавить("Подразделение");
	ТЗ.Колонки.Добавить("СуммаПени");
	ТЗ.Колонки.Добавить("СуммаПросрочки");
	ТЗ.Колонки.Добавить("ДнейПросрочки");
	ТЗ.Колонки.Добавить("ПервыйПросроченныйПлатеж");
	
	Пока Выборка.Следующий() Цикл
		
		ПросрочкаПеня = Документы.Договор.РасчетПени(Выборка.Договор, КонецДня(НастройкаДаты.Дата));
		
		Если ТЗ.Найти(Выборка.Договор, "Договор") = Неопределено Тогда
			
			НоваяСтрока = ТЗ.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ПросрочкаПеня);
			
			Если (Число(НоваяСтрока.СуммаПросрочки) <= 0 И Число(НоваяСтрока.СуммаПени) = 0) Тогда
				
				ТЗ.Удалить(НоваяСтрока);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
			
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТЗ", ТЗ);

	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры
