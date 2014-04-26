﻿
Функция ЕстьКомплектации(СпецификацияСсылка) Экспорт
	
	Результат = Новый Структура("Цех, Склад", Ложь, Ложь);
	
	Для каждого Строка Из СпецификацияСсылка.СкладГотовойПродукции Цикл
		
		Если Строка.КоличествоЦех > 0 Тогда
			Результат.Цех = Истина;
		КонецЕсли;
		
		Если Строка.КоличествоСклад > 0 Тогда
			Результат.Склад = Истина;
		КонецЕсли;
		
		Если Результат.Склад И Результат.Цех Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ВывестиПроизводственныйОтчет(ТабДок, Подразделение) Экспорт
	
	//Просроченное изготовление
	Макет = Отчеты.ПроизводственныйОтчет.ПолучитьМакет("Макет");
	ПросроченныеСпецификации = Макет.ПолучитьОбласть("ПросроченныеСпецификации");
	СпецификацииСтрока = Макет.ПолучитьОбласть("СпецификацииСтрока");
	СтрокаЗаметка = Макет.ПолучитьОбласть("СтрокаЗаметка");
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДокСпецификация.Ссылка КАК Спецификация,
	|	ДокСпецификация.Номер КАК НомерСпецификации,
	|	ДокСпецификация.Изделие,
	|	ДокСпецификация.ДатаИзготовления КАК ДатаИзготовления,
	|	ДокСпецификация.Срочный,
	|	ДокСпецификация.СуммаНарядаСпецификации КАК СуммаНаряда,
	|	ДокСпецификация.ДатаОтгрузки,
	|	НарядЗаданиеСписокСпецификаций.Ссылка КАК НарядЗадание,
	|	спрЗаметки.ТекстСодержания КАК Заметка
	|ИЗ
	|	Документ.Спецификация КАК ДокСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО (СтатусСпецификацииСрезПоследних.Спецификация = ДокСпецификация.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Заметки КАК спрЗаметки
	|		ПО ДокСпецификация.Ссылка = спрЗаметки.Предмет
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НарядЗадание.СписокСпецификаций КАК НарядЗаданиеСписокСпецификаций
	|		ПО (НарядЗаданиеСписокСпецификаций.Спецификация = ДокСпецификация.Ссылка)
	|ГДЕ
	|	СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ПереданВЦех)
	|	И ДокСпецификация.Производство = &Подразделение
	|
	|УПОРЯДОЧИТЬ ПО
	|	НарядЗаданиеСписокСпецификаций.Ссылка.Дата УБЫВ,
	|	ДатаИзготовления
	|ИТОГИ ПО
	|	НарядЗадание";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		
		НомерСтроки = 1;
		
		ВыборкаНаряды = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаНаряды.Следующий() Цикл
			
			Если ЗначениеЗаполнено(ВыборкаНаряды.НарядЗадание) Тогда
				СтрокаНаряда = ВыборкаНаряды.НарядЗадание;
			Иначе
				СтрокаНаряда = "Без наряда (срочные)";
			КонецЕсли;
			
			ПросроченныеСпецификации.Параметры.Наряд = СтрокаНаряда;
			ТабДок.Вывести(ПросроченныеСпецификации);
			
			Выборка = ВыборкаНаряды.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока Выборка.Следующий() Цикл
				
				СпецификацииСтрока.Параметры.Заполнить(Выборка);
				СпецификацииСтрока.Параметры.Изделие = Выборка.Изделие;
				СпецификацииСтрока.Параметры.НомерСтроки = НомерСтроки;
				СпецификацииСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.НомерСпецификации, "0");
				СпецификацииСтрока.Параметры.КоличествоДверей = ПосчитатьКоличествоДверей(Выборка.Спецификация);
				
				Комплектации = ЕстьКомплектации(Выборка.Спецификация);
				СпецификацииСтрока.Параметры.КомплектацияЦех = Комплектации.Цех;
				СпецификацииСтрока.Параметры.КомплектацияСклад = Комплектации.Склад;
				
				ТабДок.Вывести(СпецификацииСтрока);
				
				Если ЗначениеЗаполнено(Выборка.Заметка) Тогда
					
					СтрокаЗаметка.Параметры.Заметка = Выборка.Заметка;
					СтрокаЗаметка.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.НомерСпецификации, "0");
					ТабДок.Вывести(СтрокаЗаметка);
					
				КонецЕсли;
				
				НомерСтроки = 1 + НомерСтроки;
				
			КонецЦикла; // выборка по спецификациям
			
		КонецЦикла; // выборка по нарядам
		
	КонецЕсли;
	
	///Изделия на складе готовой прдукции
	Шапка = Макет.ПолучитьОбласть("ИзделияНаСкладеШапка");
	Строка = Макет.ПолучитьОбласть("ИзделияНаСкладеСтрока");
	СтрокаЗаметка = Макет.ПолучитьОбласть("СтрокаЗаметка");
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Производство", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	докСпецификация.АдресМонтажа КАК Адрес,
	|	докСпецификация.Контрагент КАК Контрагент,
	|	докСпецификация.Изделие,
	|	докСпецификация.Номер,
	|	докСпецификация.СуммаДокумента КАК СуммаДокумента,
	|	докСпецификация.ДатаОтгрузки КАК ДатаОтгрузки,
	|	докСпецификация.ПакетУслуг,
	|	спрЗаметки.ТекстСодержания КАК Заметка
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО (СтатусСпецификацииСрезПоследних.Спецификация = докСпецификация.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Заметки КАК спрЗаметки
	|		ПО докСпецификация.Ссылка = спрЗаметки.Предмет
	|ГДЕ
	|	СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Изготовлен)
	|	И докСпецификация.Производство = &Производство
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаОтгрузки
	|ИТОГИ
	|	СУММА(СуммаДокумента)
	|ПО
	|	ОБЩИЕ";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		ВыборкаИтоги = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		ВыборкаИтоги.Следующий();
		Шапка.Параметры.СуммаИтог = ВыборкаИтоги.СуммаДокумента;
		ТабДок.Вывести(Шапка);
		
		НомерСтроки = 1;
		
		Выборка = ВыборкаИтоги.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока Выборка.Следующий() Цикл
			
			Строка.Параметры.Заполнить(Выборка);
			Строка.Параметры.НомерСтроки = НомерСтроки;
			Строка.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.Номер, "0");
			Строка.Параметры.ЕстьДоставка = Выборка.ПакетУслуг <> Перечисления.ПакетыУслуг.СамовывозОтПроизводителя;
			ТабДок.Вывести(Строка);
			НомерСтроки = 1 + НомерСтроки;
			
			Если ЗначениеЗаполнено(Выборка.Заметка) Тогда
				
				СтрокаЗаметка.Параметры.Заметка = Выборка.Заметка;
				СтрокаЗаметка.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.Номер, "0");
				ТабДок.Вывести(СтрокаЗаметка);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	//График отгрузок
	СхемаКомпоновкиДанных = Отчеты.ГрафикОтгрузок.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	Настройки.Отбор.Элементы[0].ПравоеЗначение = Подразделение;
	Настройки.ПараметрыДанных.Элементы[0].Значение = КонецДня(ТекущаяДата());
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки);
	Результат = Новый ТабличныйДокумент;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	ТабДок.Вывести(Результат); 
	
	///График доставок
	СхемаКомпоновкиДанных = Отчеты.ГрафикДоставок.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	Настройки.Отбор.Элементы[0].ПравоеЗначение = Подразделение;
	Настройки.ПараметрыДанных.Элементы[0].Значение = Новый СтандартныйПериод(НачалоДня(ТекущаяДата()), КонецДня(ТекущаяДата()));
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки);
	Результат = Новый ТабличныйДокумент;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Попытка
		
		СхемаКомпоновкиДанных = Отчеты.ГрафикМонтажей.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
		Настройки.ПараметрыДанных.Элементы[0].Значение = Подразделение;
		Настройки.ПараметрыДанных.Элементы[0].Использование = Истина;
		Настройки.ПараметрыДанных.Элементы[1].Значение = НачалоДня(ТекущаяДата());
		Настройки.ПараметрыДанных.Элементы[1].Использование = Истина;
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
		ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки);
		Результат = Новый ТабличныйДокумент;
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(Результат);
		ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
		ТабДок.Вывести(Результат);
		
	Исключение
		
	КонецПопытки;
	
КонецФункции


Функция ПосчитатьКоличествоДверей(СпецификацияСсылка) Экспорт
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета="дверь, двери, двери, ж, копейка, копейки, копеек, ж, 0";
	
	КоличествоДверейПрописью = "";
	КоличествоДверей = 0;
	Для каждого СтрокаДверь Из СпецификацияСсылка.СписокДверей Цикл
		КоличествоДверей = КоличествоДверей + СтрокаДверь.Двери.Количество;
	КонецЦикла;
	
	Если КоличествоДверей > 0 Тогда
		КоличествоДверейПрописью = ЧислоПрописью(КоличествоДверей, ФормСтрока, ПарПредмета);
	КонецЕсли;
	
	Возврат КоличествоДверейПрописью ;
	
КонецФункции

Функция СформироватьНомераСпецификаций(Ссылка) Экспорт
	
	Результат = "";
	
	Для каждого Строка Из Ссылка.СписокСпецификаций Цикл
		
		Номер = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Строка.Спецификация, "Номер");
		Результат = Результат + СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Номер, "0") + ", ";
		
	КонецЦикла;
	
	Если Результат <> "" Тогда
		Результат = Лев(Результат, СтрДлина(Результат) - 2) + "." ;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
