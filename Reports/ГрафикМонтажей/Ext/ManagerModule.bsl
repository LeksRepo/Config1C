﻿
Функция СформироватьОтчет(ПараметрыОтчета) Экспорт
	
	НачалоПериода = ПараметрыОтчета.Период.ДатаНачала;
	КонецПериода = ПараметрыОтчета.Период.ДатаОкончания;
	
	Макет = Отчеты.ГрафикМонтажей.ПолучитьМакет("ГрафикМонтажа");
	Запрос = Новый Запрос;
	Запрос.Текст =
	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Монтаж.Монтажник КАК Монтажник,
	|	Монтаж.Ссылка КАК СсылкаНаМонтаж,
	|	Монтаж.Ссылка.Дата КАК ДатаДоставки,
	|	Монтаж.ДатаМонтажа КАК Дата,
	|	Монтаж.Ссылка.Экспедитор КАК Экспедитор,
	|	Монтаж.Спецификация.АдресМонтажа КАК АдресМонтажа,
	|	Монтаж.Спецификация.Доставка КАК Доставка,
	|	Монтаж.Спецификация.Номер КАК НомерСпецификации,
	|	Монтаж.ДатаМонтажа КАК ДатаМонтажа,
	|	Договор.Номер КАК НомерДоговора,
	|	Договор.Контрагент.Телефон КАК Телефон,
	|	Договор.Ссылка КАК СсылкаНаДоговор,
	|	Договор.Контрагент.ТелефонДополнительный КАК ТелефонДополнительный
	|ИЗ
	|	Документ.Монтаж КАК Монтаж
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК Договор
	|		ПО Монтаж.Спецификация = Договор.Спецификация
	|ГДЕ
	|	Монтаж.ДатаМонтажа МЕЖДУ &НачалоПериода И &КонецПериода
	|	И Монтаж.Ссылка.Проведен
	|	И Монтаж.Монтажник В (&МассивМонтажников)
	|	И Договор.Офис.Город В (&МассивГородов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Если ПараметрыОтчета.МассивМонтажников.Количество() = 0 Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Монтаж.Монтажник В (&МассивМонтажников)", "");
		
	КонецЕсли;
	
	Если ПараметрыОтчета.МассивГородов.Количество() = 0 Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Договор.Офис.Город В (&МассивГородов)", "");
		
	КонецЕсли;
	
	Запрос.Параметры.Вставить("НачалоПериода", НачалоПериода);
	Запрос.Параметры.Вставить("КонецПериода", КонецПериода);
	Запрос.Параметры.Вставить("МассивМонтажников", ПараметрыОтчета.МассивМонтажников);
	Запрос.Параметры.Вставить("МассивГородов", ПараметрыОтчета.МассивГородов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Шапка.Параметры.ПериодСтр = ПредставлениеПериода(НачалоПериода, КонецПериода);
	Строка = Макет.ПолучитьОбласть("Строка");
	ПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");
	
	ТабДок 									= Новый ТабличныйДокумент;
	ТабДок.АвтоМасштаб 				= Истина;
	ТабДок.ОриентацияСтраницы 	= ОриентацияСтраницы.Ландшафт;
	ТабДок.ОтображатьСетку 		= Ложь;
	ТабДок.Защита 						= Ложь;
	ТабДок.ТолькоПросмотр 			= Ложь;
	
	ТабДок.Вывести(Шапка);
		
	НомерСтроки = 5;
	НачалоТекДата = 5;
	ТекДата = '0001.01.01';
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ЗначениеЗаполнено(ТекДата) Тогда
			ТекДата = НачалоДня(Выборка.ДатаМонтажа);
		КонецЕсли;
		
		НомерСтроки = 1 + НомерСтроки;
		
		Если НачалоДня(ТекДата) <> НачалоДня(Выборка.ДатаМонтажа) Тогда
			
			ТабДок.Вывести(ПустаяСтрока);
			ТабДок.Вывести(ПустаяСтрока);
			НомерСтроки = 2 + НомерСтроки;
			
			Область = ТабДок.Область(НачалоТекДата, 1, НомерСтроки - 2, 1);
			Область.Объединить();
			ТекДата = НачалоДня(Выборка.ДатаМонтажа);
			НачалоТекДата = НомерСтроки - 1;
			
		КонецЕсли;
		
		Строка.Параметры.Заполнить(Выборка);
		
		Адрес = ЛексСервер.ПолучитьСтруктуруИзАдреса(Выборка.АдресМонтажа);
		Строка.Параметры.Подъезд = Адрес.Подъезд;
		Строка.Параметры.Этаж = Адрес.Этаж;
		Строка.Параметры.Код = Адрес.КодПодъезда;
		Строка.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.НомерСпецификации, "0");
		Строка.Параметры.Дата = Формат((Выборка.ДатаМонтажа), "ДФ = дд.ММ")+" "+Формат((Выборка.ДатаМонтажа), "ДФ = дддд");
		
		Строка.Параметры.Телефоны = "" + Выборка.Телефон + Символы.ПС + Выборка.ТелефонДополнительный;
		ТабДок.Вывести(Строка);
		
	КонецЦикла;
	
	//ТабДок.Вывести(ПустаяСтрока);
	//ТабДок.Вывести(ПустаяСтрока);
	//НомерСтроки = 2 + НомерСтроки;
	
	Область = ТабДок.Область(НачалоТекДата, 1, НомерСтроки - 1, 1);
	Область.Объединить();
	
	Возврат ТабДок;
	
КонецФункции
