﻿
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПечатьОперативныйЗакуп(ТабДок, Ссылка) Экспорт
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета="рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 0";
	
	Макет = Документы.ОперативныйЗакуп.ПолучитьМакет("ПечатьОперативныйЗакуп");
	
		
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСписокНоменклатурыШапка = Макет.ПолучитьОбласть("СписокНоменклатурыШапка");
	ОбластьСписокНоменклатуры = Макет.ПолучитьОбласть("СписокНоменклатуры");
	ОбластьКонтрагент = Макет.ПолучитьОбласть("Контрагент");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	ТабДок.Очистить();
	
	ВставлятьРазделительСтраниц = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОперативныйЗакупСписокНоменклатуры.Ссылка.Ссылка КАК Ссылка,
	|	ОперативныйЗакупСписокНоменклатуры.Ссылка.Автор,
	|	ОперативныйЗакупСписокНоменклатуры.Ссылка.Дата,
	|	ОперативныйЗакупСписокНоменклатуры.Ссылка.Подразделение,
	|	ОперативныйЗакупСписокНоменклатуры.Ссылка.СуммаДокумента,
	|	ОперативныйЗакупСписокНоменклатуры.Ссылка.Коментарий,
	|	ОперативныйЗакупСписокНоменклатуры.Поставщик КАК Поставщик,
	|	ОперативныйЗакупСписокНоменклатуры.Номенклатура,
	|	ОперативныйЗакупСписокНоменклатуры.Количество,
	|	ОперативныйЗакупСписокНоменклатуры.ЕдиницаИзмерения,
	|	ОперативныйЗакупСписокНоменклатуры.Стоимость,
	|	ОперативныйЗакупСписокНоменклатуры.НомерСтроки,
	|	ОперативныйЗакупСписокНоменклатуры.Ссылка.Номер
	|ИЗ
	|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК ОперативныйЗакупСписокНоменклатуры
	|ГДЕ
	|	ОперативныйЗакупСписокНоменклатуры.Ссылка В(&Ссылка)
	|ИТОГИ ПО
	|	Ссылка,
	|	Поставщик";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСсылка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСсылка.Следующий() Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ТабДок.Вывести(ОбластьЗаголовок);
		
		Шапка.Параметры.Заполнить(ВыборкаСсылка);
		ТабДок.Вывести(Шапка, ВыборкаСсылка.Уровень());
		
		ВыборкаПоставщик = ВыборкаСсылка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПоставщик.Следующий() Цикл
			
			ОбластьКонтрагент.Параметры.Заполнить(ВыборкаПоставщик);
			ТабДок.Вывести(ОбластьКонтрагент);
			ТабДок.Вывести(ОбластьСписокНоменклатурыШапка);
			
			ВыборкаДетальныеЗаписи = ВыборкаПоставщик.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
				ОбластьСписокНоменклатуры.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
				ТабДок.Вывести(ОбластьСписокНоменклатуры, ВыборкаДетальныеЗаписи.Уровень());
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры
