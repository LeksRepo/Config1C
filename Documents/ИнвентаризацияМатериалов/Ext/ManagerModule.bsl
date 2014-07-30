﻿
Функция ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти, РезультатПриОшибке = Истина) Экспорт
	
	Попытка
		Возврат ТабДокумент.ПроверитьВывод(ВыводимыеОбласти);
	Исключение
		ОписаниеОшибки = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
		НСТр("ru = 'Невозможно получить информацию о текущем принтере (возможно, в системе не установлено ни одного принтера)'"),
		УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки.Описание);
		Возврат РезультатПриОшибке;
	КонецПопытки;
	
КонецФункции // ПроверитьВыводТабличногоДокумента()

Функция ПолучитьВыборку(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	//RonEXI edit
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнвентаризацияМатериалов.Ссылка,
	|	ИнвентаризацияМатериалов.Номер КАК НомерДокумента,
	|	ИнвентаризацияМатериалов.Подразделение.Организация КАК ПредставлениеОрганизации,
	|	ИнвентаризацияМатериалов.Дата,
	|	ИнвентаризацияМатериалов.Подразделение,
	|	ИнвентаризацияМатериалов.Склад,
	|	ИнвентаризацияМатериалов.Автор,
	|	ИнвентаризацияМатериалов.СписокНоменклатуры.(
	|		Ссылка,
	|		Номенклатура,
	|		НомерСтроки,
	|		КоличествоУчетное,
	|		КоличествоФакт,
	|		Отклонение,
	|		СтоимостьФакт,
	|		СтоимостьУчетная,
	|		Цена,
	|		Номенклатура.Код КАК КодАртикул,
	|		СтоимостьУчетная КАК СуммаПоУчету,
	|		Номенклатура.Наименование КАК Товар
	|	),
	|	ИнвентаризацияМатериалов.Склад.МОЛ.Представление КАК ФИОМОЛ1,
	|	ФизическиеЛица.Должность КАК ДолжностьМОЛ1
	|ИЗ
	|	Документ.ИнвентаризацияМатериалов КАК ИнвентаризацияМатериалов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ПО ИнвентаризацияМатериалов.Склад.МОЛ = ФизическиеЛица.Ссылка
	|ГДЕ
	|	ИнвентаризацияМатериалов.Ссылка В(&МассивОбъектов)";

	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Процедура ПечатьИнвентаризационнаяОпись(ТабДокумент, МассивОбъектов) Экспорт
	
	Выборка = ПолучитьВыборку(МассивОбъектов);
	
	Макет = Документы.ИнвентаризацияМатериалов.ПолучитьМакет("ИНВ3");
	
	ПервыйДокумент = Истина;
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ВыборкаСтрокМатериалы = Выборка.СписокНоменклатуры.Выбрать();
		
		//////////////////////////////////////////////////////////////////////
		// 1-я страница формы
		
		// Выводим шапку накладной
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.ДатаДокумента = Выборка.Дата;
//		ОбластьМакета.Параметры.ДатаОкончанияИнвентаризацииЛокальныйФормат = Выборка.ДатаОкончанияИнвентаризации; 
		ОбластьМакета.Параметры.Подразделение = Выборка.Подразделение;
		
		ТабДокумент.Вывести(ОбластьМакета);
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		//////////////////////////////////////////////////////////////////////
		// 2-я страница формы
		ИтоговоеКоличествоСтрок = 0;
		ИтогФактКоличество = 0;
		ИтогФактСумма = 0;
		ИтогФактСуммаВсего = 0;
		ИтогБухКоличество = 0;
		ИтогБухСумма = 0;
		
		КолвоСтрокПоСтранице = 0;
		КолвоПоСтранице = 0;
		СуммаЛиста = 0;
		ИтогоКолво = 0;
		
		НомерСтраницы = 2;
		Ном = 0;
		
		// Выводим заголовок таблицы
		ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы; 
		ТабДокумент.Вывести(ЗаголовокТаблицы);
		
		// Выводим многострочную часть документа
		ПодвалСтраницы  = Макет.ПолучитьОбласть("ПодвалСтраницы");
		
		Пока ВыборкаСтрокМатериалы.Следующий() Цикл
			
			Ном = Ном + 1;
			СтрокаТаблицы = Макет.ПолучитьОбласть("Строка");
			СтрокаТаблицы.Параметры.Заполнить(ВыборкаСтрокМатериалы);
			// это зачем так?
			// СтрокаТаблицы.Параметры.СуммаПоУчету = ВыборкаСтрокМатериалы.КоличествоУчетное * ВыборкаСтрокМатериалы.Цена;
			СтрокаСПодвалом = Новый Массив;
			СтрокаСПодвалом.Добавить(СтрокаТаблицы);
			СтрокаСПодвалом.Добавить(ПодвалСтраницы);
			
			Если НЕ ПроверитьВыводТабличногоДокумента(ТабДокумент, СтрокаСПодвалом) Тогда
				
				ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ПодвалСтраницы");
				ПараметрыОбласти = ОбластьИтоговПоСтранице.Параметры;
				
				ПараметрыОбласти.ИтогоФактКоличество = ИтогФактКоличество;
				ПараметрыОбласти.ИтогоФактСумма = ИтогФактСумма;
				ПараметрыОбласти.ИтогоБухКоличество = ИтогБухКоличество;
				ПараметрыОбласти.ИтогоБухСумма = ИтогБухСумма;
				
				ПараметрыОбласти.КоличествоПорядковыхНомеровНаСтраницеПрописью = ЧислоПрописью(КолвоСтрокПоСтранице, ,",,,,,,,,0");
				ПараметрыОбласти.ОбщееКоличествоЕдиницФактическиНаСтраницеПрописью = ЧислоПрописью(ИтогФактКоличество, ,",,,,,,,,0");
				ПараметрыОбласти.СуммаФактическиНаСтраницеПрописью = ЧислоПрописью(ИтогФактСумма, "Л = ru_RU; ДП = Истина","рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2");
				ТабДокумент.Вывести(ОбластьИтоговПоСтранице);
				
				НомерСтраницы = НомерСтраницы + 1;
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
				ЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы;
				ТабДокумент.Вывести(ЗаголовокТаблицы);
				
				ИтогФактКоличество = 0;
				ИтогФактСумма = 0;
				ИтогБухКоличество = 0;
				ИтогБухСумма = 0;
				
				КолвоСтрокПоСтранице = 0;
				КолвоПоСтранице = 0;
				СуммаЛиста = 0;
				
			КонецЕсли;
			
			СтрокаТаблицы.Параметры.Номер = Ном;
			СтрокаТаблицы.Параметры.ТоварНаименование = ВыборкаСтрокМатериалы.Номенклатура;
			
			ТабДокумент.Вывести(СтрокаТаблицы);
			
			ИтогФактКоличество 		= ИтогФактКоличество + ВыборкаСтрокМатериалы.КоличествоФакт;
			ИтогФактСуммаВсего 		= ИтогФактСуммаВсего + ВыборкаСтрокМатериалы.СтоимостьУчетная; // фиг знает что за сумма тут
			ИтогоКолво 		   		= ИтогоКолво 		 + ВыборкаСтрокМатериалы.КоличествоФакт; 
			ИтогФактСумма	   		= ИтогФактСумма 	 + ВыборкаСтрокМатериалы.СтоимостьФакт;
			ИтогБухКоличество  		= ИтогБухКоличество  + ВыборкаСтрокМатериалы.КоличествоУчетное;
			ИтогБухСумма 	   		= ИтогБухСумма 		 + ВыборкаСтрокМатериалы.КоличествоУчетное*ВыборкаСтрокМатериалы.Цена;
			
			КолвоСтрокПоСтранице 	= КолвоСтрокПоСтранице 	  + 1;
			КолвоПоСтранице 	 	= КолвоПоСтранице 	      + ВыборкаСтрокМатериалы.КоличествоФакт;
			СуммаЛиста 			 	= СуммаЛиста 			  + ВыборкаСтрокМатериалы.СтоимостьФакт;
			ИтоговоеКоличествоСтрок = ИтоговоеКоличествоСтрок + 1;
			
		КонецЦикла;
		
		// Выводим итоги по последней странице
		ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ПодвалСтраницы");
		ПараметрыОбласти 		= ОбластьИтоговПоСтранице.Параметры;
		
		ПараметрыОбласти.ИтогоФактКоличество = ИтогФактКоличество;
		ПараметрыОбласти.ИтогоФактСумма 	 = ИтогФактСумма;
		ПараметрыОбласти.ИтогоБухКоличество  = ИтогБухКоличество;
		ПараметрыОбласти.ИтогоБухСумма 		 = ИтогБухСумма;
		
		
		ПараметрыОбласти.КоличествоПорядковыхНомеровНаСтраницеПрописью 	   = ЧислоПрописью(КолвоСтрокПоСтранице, ,",,,,,,,,0");
		ПараметрыОбласти.ОбщееКоличествоЕдиницФактическиНаСтраницеПрописью = ЧислоПрописью(КолвоПоСтранице, ,",,,,,,,,0");
		ПараметрыОбласти.СуммаФактическиНаСтраницеПрописью				   = ЧислоПрописью(ИтогФактСумма, "Л = ru_RU; ДП = Истина","рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2");
		ТабДокумент.Вывести(ОбластьИтоговПоСтранице);
		
		// Выводим подвал документа
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалОписи");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.ОбщееКоличествоЕдиницФактическиНаСтраницеПрописью = ЧислоПрописью(ИтогоКолво, ,",,,,,,,,0");
		ОбластьМакета.Параметры.КоличествоПорядковыхНомеровНаСтраницеПрописью = ЧислоПрописью(ИтоговоеКоличествоСтрок, ,",,,,,,,,0");
		ОбластьМакета.Параметры.СуммаФактическиНаСтраницеПрописью = ЧислоПрописью(ИтогФактСуммаВсего, "Л = ru_RU; ДП = Истина","рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2");
		
		ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалОписиМОЛ");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		
		ОбластьМакета.Параметры.НачальныйНомерПоПорядку = 1;
		ОбластьМакета.Параметры.НомерКонца 				= ВыборкаСтрокМатериалы.Количество();
		ОбластьМакета.Параметры.ДатаДокумента 			= Выборка.Дата;
		ТабДокумент.Вывести(ОбластьМакета);
		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ПечатьСличительнаяВедомость(ТабДокумент, МассивОбъектов, ИгнорироватьПустые = Истина) Экспорт
	
	Выборка = ПолучитьВыборку(МассивОбъектов);
	
	Макет = Документы.ИнвентаризацияМатериалов.ПолучитьМакет("ИНВ19");
	
	ПервыйДокумент = Истина;
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ПервыйДокумент Тогда
			
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало 	= ТабДокумент.ВысотаТаблицы + 1;
		ОбластьМакетаШапка	= Макет.ПолучитьОбласть("Шапка");
		
		ОбластьМакетаШапка.Параметры.Заполнить(Выборка);
		
		ОбластьМакетаШапка.Параметры.ДатаДокумента = Выборка.Дата;
		
		ТабДокумент.Вывести(ОбластьМакетаШапка);
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		ВыборкаСтрокМатериалы = Выборка.СписокНоменклатуры.Выбрать();
		
		НомерСтраницы = 2;
		НомерСтроки = 1;
		КоличествоСтрок = ВыборкаСтрокМатериалы.Количество();
		
		ИтогоРезультатИзлишекКоличество = 0;
		ИтогоРезультатИзлишекСумма = 0;
		ИтогоРезультатНедостачаКоличество = 0;
		ИтогоРезультатНедостачаСумма = 0;
		
		ОбщееИтогоРезультатИзлишекКоличество = 0;
		ОбщееИтогоРезультатИзлишекСумма = 0;
		ОбщееИтогоРезультатНедостачаКоличество = 0;
		ОбщееИтогоРезультатНедостачаСумма = 0;
		
		// Вывод заголовка таблицы.
		ОбластьМакетаЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		
		ОбластьМакетаЗаголовок.Параметры.НомерСтраницы = "Страница " + НомерСтраницы; 
		ТабДокумент.Вывести(ОбластьМакетаЗаголовок);
		
		ОбластьМакетаСтрока 		 = Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаИтогоПоСтранице = Макет.ПолучитьОбласть("Итого");
		ОбластьМакетаПодвал 		 = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакетаИтогоПоОписи 	 = Макет.ПолучитьОбласть("ИтогоПоОписи");
		
		Пока ВыборкаСтрокМатериалы.Следующий() Цикл
			
			Если ИгнорироватьПустые И ВыборкаСтрокМатериалы.Отклонение = 0  Тогда
				Продолжить;
			КонецЕсли;
			
			ОбластьМакетаСтрока.Параметры.Заполнить(ВыборкаСтрокМатериалы);
			ОбластьМакетаСтрока.Параметры.ТоварНаименование = ВыборкаСтрокМатериалы.Товар;
			
			// Проверка вывода.
			СтрокаСПодвалом = Новый Массив();
			СтрокаСПодвалом.Добавить(ОбластьМакетаСтрока);
			СтрокаСПодвалом.Добавить(ОбластьМакетаИтогоПоСтранице);
			СтрокаСПодвалом.Добавить(ОбластьМакетаПодвал);
			
			Если НЕ ПроверитьВыводТабличногоДокумента(ТабДокумент, СтрокаСПодвалом) Тогда
				
				ОбластьМакетаИтогоПоСтранице.Параметры.ИтогоРезультатИзлишекКоличество   = ИтогоРезультатИзлишекКоличество;
				ОбластьМакетаИтогоПоСтранице.Параметры.ИтогоРезультатИзлишекСумма 		 = ИтогоРезультатИзлишекСумма;
				ОбластьМакетаИтогоПоСтранице.Параметры.ИтогоРезультатНедостачаКоличество = ИтогоРезультатНедостачаКоличество;
				ОбластьМакетаИтогоПоСтранице.Параметры.ИтогоРезультатНедостачаСумма 	 = ИтогоРезультатНедостачаСумма;
				//Вывод итого по странице.
				ТабДокумент.Вывести(ОбластьМакетаИтогоПоСтранице);
				
				// Вывод разделителя страниц.
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
				// Вывод заголовка таблицы.
				НомерСтраницы = НомерСтраницы + 1;
				ОбластьМакетаЗаголовок.Параметры.НомерСтраницы  = "Страница " + НомерСтраницы;
				ТабДокумент.Вывести(ОбластьМакетаЗаголовок);
			
				ИтогоРезультатИзлишекКоличество = 0;
				ИтогоРезультатИзлишекСумма = 0;
				ИтогоРезультатНедостачаКоличество = 0;
				ИтогоРезультатНедостачаСумма = 0;
				
			КонецЕсли;
			
			Разница 		 = ВыборкаСтрокМатериалы.КоличествоФакт - ВыборкаСтрокМатериалы.КоличествоУчетное;
			СтоимостьРазницы = Разница * ВыборкаСтрокМатериалы.Цена;
			
			ОбластьМакетаСтрока.Параметры.РезультатИзлишекКоличество = 0;
			ОбластьМакетаСтрока.Параметры.РезультатИзлишекСумма = 0;
			ОбластьМакетаСтрока.Параметры.РезультатНедостачаКоличество = 0;
			ОбластьМакетаСтрока.Параметры.РезультатНедостачаСумма = 0;
			
			Если Разница < 0 Тогда
				
				ОбластьМакетаСтрока.Параметры.РезультатНедостачаКоличество = - Разница;
				ОбластьМакетаСтрока.Параметры.РезультатНедостачаСумма = - СтоимостьРазницы;
				
				ИтогоРезультатНедостачаКоличество = ИтогоРезультатНедостачаКоличество - Разница;
				ИтогоРезультатНедостачаСумма = ИтогоРезультатНедостачаСумма - СтоимостьРазницы;
				
				ОбщееИтогоРезультатНедостачаКоличество = ОбщееИтогоРезультатНедостачаКоличество - Разница;
				ОбщееИтогоРезультатНедостачаСумма  = ОбщееИтогоРезультатНедостачаСумма - СтоимостьРазницы;
				
			ИначеЕсли Разница > 0 Тогда
				
				ОбластьМакетаСтрока.Параметры.РезультатИзлишекКоличество = Разница;
				ОбластьМакетаСтрока.Параметры.РезультатИзлишекСумма = СтоимостьРазницы;
				
				ИтогоРезультатИзлишекКоличество = ИтогоРезультатИзлишекКоличество + Разница;
				ИтогоРезультатИзлишекСумма = ИтогоРезультатИзлишекСумма + СтоимостьРазницы;
				
				ОбщееИтогоРезультатИзлишекКоличество = ОбщееИтогоРезультатИзлишекКоличество + Разница;
				ОбщееИтогоРезультатИзлишекСумма = ОбщееИтогоРезультатИзлишекСумма + СтоимостьРазницы;
				
			КонецЕсли;
			
			ОбластьМакетаСтрока.Параметры.Номер = НомерСтроки;
			ТабДокумент.Вывести(ОбластьМакетаСтрока);
			НомерСтроки = НомерСтроки + 1;
			
		КонецЦикла;
		
		// Вывод итого по странице.
		ОбластьМакетаИтогоПоСтранице.Параметры.ИтогоРезультатИзлишекКоличество = ИтогоРезультатИзлишекКоличество;
		ОбластьМакетаИтогоПоСтранице.Параметры.ИтогоРезультатИзлишекСумма = ИтогоРезультатИзлишекСумма;
		ОбластьМакетаИтогоПоСтранице.Параметры.ИтогоРезультатНедостачаКоличество = ИтогоРезультатНедостачаКоличество;
		ОбластьМакетаИтогоПоСтранице.Параметры.ИтогоРезультатНедостачаСумма = ИтогоРезультатНедостачаСумма;
		ТабДокумент.Вывести(ОбластьМакетаИтогоПоСтранице);
		
		//Вывод ИтогоПоОбласти
		ОбластьМакетаИтогоПоОписи.Параметры.ИтогоРезультатИзлишекКоличество = ОбщееИтогоРезультатИзлишекКоличество;
		ОбластьМакетаИтогоПоОписи.Параметры.ИтогоРезультатИзлишекСумма = ОбщееИтогоРезультатИзлишекСумма;
		ОбластьМакетаИтогоПоОписи.Параметры.ИтогоРезультатНедостачаКоличество = ОбщееИтогоРезультатНедостачаКоличество;
		ОбластьМакетаИтогоПоОписи.Параметры.ИтогоРезультатНедостачаСумма = ОбщееИтогоРезультатНедостачаСумма;
		ТабДокумент.Вывести(ОбластьМакетаИтогоПоОписи);
		
		// Вывод подвала.
		ОбластьМакетаПодвал.Параметры.Заполнить(Выборка);
		ТабДокумент.Вывести(ОбластьМакетаПодвал);
		
	КонецЦикла;
	
КонецПроцедуры
