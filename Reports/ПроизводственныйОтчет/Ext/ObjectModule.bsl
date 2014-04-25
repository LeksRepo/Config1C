﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	// Вставить содержимое обработчика.

	
	//Получаем схему из макета
	СхемаКомпоновкиДанных = Отчеты.ГрафикМонтажей.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	//Из схемы возьмем настройки по умолчанию
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	Настройки2 = КомпоновщикНастроек.ПолучитьНастройки();
	//Настройки.ПараметрыДанных.Элементы[0].Значение = Подразделение;
	Настройки.ПараметрыДанных.Элементы[0].Использование = Истина;
	Настройки.ПараметрыДанных.Элементы[1].Значение = НачалоДня(ТекущаяДата());
	Настройки.ПараметрыДанных.Элементы[1].Использование = Истина;
	
	//Помещаем в переменную данные о расшифровке данных
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки);
	
	//Очищаем поле табличного документа
	Результат = Новый ТабличныйДокумент;
	
	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	//ТабДок.Вывести(Результат);
	
КонецПроцедуры
