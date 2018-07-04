﻿
Функция ПолучитьОбщуюНоменклатуруПолностью(Подразделение) Экспорт
	
	Данные = Новый Структура();
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
			
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Общая.ИмяПредопределенныхДанных КАК ОбщаяНоменклатураИмя,
		|	СвязиОбщейНоменклатуры.Номенклатура
		|ИЗ
		|	Справочник.ОбщаяНоменклатура КАК Общая
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиОбщейНоменклатуры КАК СвязиОбщейНоменклатуры
		|		ПО Общая.Ссылка = СвязиОбщейНоменклатуры.ОбщаяНоменклатура
		|			И (СвязиОбщейНоменклатуры.Подразделение = &Подразделение)
		|ГДЕ
		|	НЕ Общая.ПометкаУдаления
		|	И НЕ Общая.ЭтоГруппа
		|
		|УПОРЯДОЧИТЬ ПО
		|	Общая.Наименование";
		
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				  Данные.Вставить(Выборка.ОбщаяНоменклатураИмя,Выборка.Номенклатура);
			КонецЦикла;
		
		КонецЕсли;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните подразделение.");
		
	КонецЕсли;
		
	Возврат Данные;
	
КонецФункции

Функция ПолучитьОбщуюНоменклатуру(ОбщаяНоменклатура, Подразделение) Экспорт
	
	Номенклатура = Неопределено;
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
			
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		Запрос.УстановитьПараметр("ОбщаяНоменклатура", ОбщаяНоменклатура);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Общая.Ссылка КАК ОбщаяНоменклатура,
		|	СвязиОбщейНоменклатуры.Номенклатура
		|ИЗ
		|	Справочник.ОбщаяНоменклатура КАК Общая
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиОбщейНоменклатуры КАК СвязиОбщейНоменклатуры
		|		ПО Общая.Ссылка = СвязиОбщейНоменклатуры.ОбщаяНоменклатура
		|			И (СвязиОбщейНоменклатуры.Подразделение = &Подразделение)
		|ГДЕ
		|	Общая.Ссылка = &ОбщаяНоменклатура
		|	И НЕ Общая.ПометкаУдаления
		|	И НЕ Общая.ЭтоГруппа
		|
		|УПОРЯДОЧИТЬ ПО
		|	Общая.Наименование";
		
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			Номенклатура = Выборка.Номенклатура;
		
		КонецЕсли;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните подразделение.");
		
	КонецЕсли;
		
	Возврат Номенклатура;
	
КонецФункции

Функция ПолучитьРазмерыЛиста(ТекущаяНоменклатура, Подразделение) Экспорт
	
	СтруктураРазмеровЛиста = Новый Структура;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(НастройкиНоменклатуры.ОсновнаяПоСкладу.ДлинаДетали, СпрНом.ДлинаДетали) КАК ВысотаЛиста,
	|	ЕСТЬNULL(НастройкиНоменклатуры.ОсновнаяПоСкладу.ШиринаДетали, СпрНом.ШиринаДетали) КАК ШиринаЛиста,
	|	ЕСТЬNULL(НастройкиНоменклатуры.ОсновнаяПоСкладу.ДлинаБезТорцовки, СпрНом.ДлинаБезТорцовки) КАК ВысотаЛистаБезТорцовки,
	|	ЕСТЬNULL(НастройкиНоменклатуры.ОсновнаяПоСкладу.ШиринаБезТорцовки, СпрНом.ШиринаБезТорцовки) КАК ШиринаЛистаБезТорцовки
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНом
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(, Подразделение = &Подразделение) КАК НастройкиНоменклатуры
	|		ПО (НастройкиНоменклатуры.Номенклатура = СпрНом.Ссылка)
	|ГДЕ
	|	СпрНом.Ссылка = &Номенклатура";
	
	Запрос.УстановитьПараметр("Номенклатура", ТекущаяНоменклатура);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СтруктураРазмеровЛиста.Вставить("ВысотаЛиста", ВыборкаДетальныеЗаписи.ВысотаЛиста);
		СтруктураРазмеровЛиста.Вставить("ШиринаЛиста", ВыборкаДетальныеЗаписи.ШиринаЛиста);
		СтруктураРазмеровЛиста.Вставить("ВысотаЛистаБезТорцовки", ВыборкаДетальныеЗаписи.ВысотаЛистаБезТорцовки);
		СтруктураРазмеровЛиста.Вставить("ШиринаЛистаБезТорцовки", ВыборкаДетальныеЗаписи.ШиринаЛистаБезТорцовки);

	КонецЦикла;
	
	Возврат СтруктураРазмеровЛиста;
	
КонецФункции

Функция ПоложениеПазовПетли(Расположение) Экспорт
	
	Возврат Расположение.ПоложениеПазов; 
	
КонецФункции
