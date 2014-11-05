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
	ОбластьСписокНоменклатурыОптом = Макет.ПолучитьОбласть("СписокНоменклатурыОптом");
	ОбластьКонтрагент = Макет.ПолучитьОбласть("Контрагент");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	ПодЗаказЗаголовок = Макет.ПолучитьОбласть("ПодЗаказЗаголовок");
	ПодЗаказШапка = Макет.ПолучитьОбласть("ПодЗаказШапка");
	ПодЗаказСтрока = Макет.ПолучитьОбласть("ПодЗаказСтрока");
	ПодЗаказСтрокаОптом = Макет.ПолучитьОбласть("ПодЗаказСтрокаОптом");
	ПодЗаказЗаголовокВнеГрупп = Макет.ПолучитьОбласть("ПодЗаказЗаголовокВнеГрупп");
	
	ТабДок.Очистить();
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ПолеСлева = 5;
	ТабДок.ПолеСправа = 1;
	ТабДок.ПолеСверху = 5;
	ТабДок.ПолеСнизу = 5;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОперативныйЗакупСписокНоменклатуры.Номенклатура.Наименование КАК Номенклатура,
	|	ОперативныйЗакупСписокНоменклатуры.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ОперативныйЗакупСписокНоменклатуры.Цена КАК ПлановаяЦена,
	|	ОперативныйЗакупСписокНоменклатуры.РучнойВвод КАК Количество,
	|	ОперативныйЗакупСписокНоменклатуры.ЗакупОптом КАК ЗакупОптом,
	|	NULL КАК Спецификация,
	|	NULL КАК Комментарий,
	|	ВЫБОР
	|		КОГДА ОперативныйЗакупСписокНоменклатуры.Поставщик ЕСТЬ NULL 
	|				ИЛИ ОперативныйЗакупСписокНоменклатуры.Поставщик = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|			ТОГДА ""Не Указан""
	|		ИНАЧЕ ОперативныйЗакупСписокНоменклатуры.Поставщик.Наименование
	|	КОНЕЦ КАК Поставщик,
	|	ВЫБОР
	|		КОГДА ОперативныйЗакупСписокНоменклатуры.Поставщик ЕСТЬ NULL 
	|				ИЛИ ОперативныйЗакупСписокНоменклатуры.Поставщик = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ПустойПоставщик
	|ИЗ
	|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК ОперативныйЗакупСписокНоменклатуры
	|ГДЕ
	|	ОперативныйЗакупСписокНоменклатуры.Ссылка В(&Ссылка)
	|	И ОперативныйЗакупСписокНоменклатуры.РучнойВвод > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОперативныйЗакупСписокНоменклатурыПодЗаказ.Номенклатура.Наименование КАК Номенклатура,
	|	ОперативныйЗакупСписокНоменклатурыПодЗаказ.ЕдиницаИзмерения,
	|	ОперативныйЗакупСписокНоменклатурыПодЗаказ.Цена,
	|	ОперативныйЗакупСписокНоменклатурыПодЗаказ.РучнойВвод,
	|	ОперативныйЗакупСписокНоменклатурыПодЗаказ.ЗакупОптом,
	|	ОперативныйЗакупСписокНоменклатурыПодЗаказ.Спецификация,
	|	ОперативныйЗакупСписокНоменклатурыПодЗаказ.Комментарий,
	|	ВЫБОР
	|		КОГДА ОперативныйЗакупСписокНоменклатурыПодЗаказ.Поставщик ЕСТЬ NULL 
	|				ИЛИ ОперативныйЗакупСписокНоменклатурыПодЗаказ.Поставщик = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|			ТОГДА ""Не Указан""
	|		ИНАЧЕ ОперативныйЗакупСписокНоменклатурыПодЗаказ.Поставщик.Наименование
	|	КОНЕЦ КАК Поставщик,
	|	1 КАК ПустойПоставщик
	|ИЗ
	|	Документ.ОперативныйЗакуп.СписокНоменклатурыПодЗаказ КАК ОперативныйЗакупСписокНоменклатурыПодЗаказ
	|ГДЕ
	|	ОперативныйЗакупСписокНоменклатурыПодЗаказ.Ссылка В(&Ссылка)
	|	И ОперативныйЗакупСписокНоменклатурыПодЗаказ.РучнойВвод > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПустойПоставщик,
	|	Поставщик,
	|	Спецификация,
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОперативныйЗакуп.Ссылка.Номер КАК Номер,
	|	ОперативныйЗакуп.Ссылка.Дата КАК Дата,
	|	ОперативныйЗакуп.Ссылка.Автор КАК Автор,
	|	ОперативныйЗакуп.Ссылка.Подразделение КАК Подразделение,
	|	ОперативныйЗакуп.Ссылка.Комментарий КАК Комментарий,
	|	ОперативныйЗакуп.СуммаЗаявленная
	|ИЗ
	|	Документ.ОперативныйЗакуп КАК ОперативныйЗакуп
	|ГДЕ
	|	ОперативныйЗакуп.Ссылка В(&Ссылка)";
			
	РезультатЗапроса = Запрос.ВыполнитьПакет();

	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	ТабДок.Вывести(ОбластьЗаголовок);
	
	ДанныеДокумента = РезультатЗапроса[1].Выбрать();
	ДанныеДокумента.Следующий();
	Шапка.Параметры.Заполнить(ДанныеДокумента);
	ТабДок.Вывести(Шапка);
	
	Подвал.Параметры.ИтогСтоимостьПрописью = " "+ДанныеДокумента.СуммаЗаявленная+" руб. ( "+ЧислоПрописью(ДанныеДокумента.СуммаЗаявленная,"Л=ru_RU; ДП=Ложь","рубль, рубля, рублей, м, копейка, копейки, копеек, ж")+" )";	
		
	НомерСтроки = 1;
	
	ТЗМатериалы = РезультатЗапроса[0].Выгрузить();

	Пока ТЗМатериалы.Количество() > 0 Цикл
		
		ТекущийПоставщик = ТЗМатериалы[0].Поставщик;
		
		Сч = 0;
		ПервыйНеПодЗаказ = Истина;
		
		Пока Сч < ТЗМатериалы.Количество() Цикл
			
			 Строка = ТЗМатериалы[Сч];
			 
			 Если (ТекущийПоставщик = Строка.Поставщик) И ( НЕ ЗначениеЗаполнено(Строка.Спецификация) ) Тогда
				 
				 
				 Если Строка.ЗакупОптом Тогда
					ОбластьСтрока = ОбластьСписокНоменклатурыОптом;					
				 Иначе
					ОбластьСтрока = ОбластьСписокНоменклатуры;	
				 КонецЕсли;
				 
				 ОбластьКонтрагент.Параметры.Заполнить(Строка);
				 ОбластьСтрока.Параметры.Заполнить(Строка);
				 ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
				 
				 Если ПервыйНеПодЗаказ Тогда
					
					ПервыйНеПодЗаказ = Ложь;
										
					ДляПроверкиВывода = Новый Массив;
					ДляПроверкиВывода.Добавить(ОбластьКонтрагент); 
					ДляПроверкиВывода.Добавить(ОбластьСписокНоменклатурыШапка);
					ДляПроверкиВывода.Добавить(ОбластьСтрока);	

					Пока НЕ ТабДок.ПроверитьВывод(ДляПроверкиВывода) Цикл
						ТабДок.ВывестиГоризонтальныйРазделительСтраниц();	
					КонецЦикла;
					
					ТабДок.Вывести(ОбластьКонтрагент);
					ТабДок.Вывести(ОбластьСписокНоменклатурыШапка);
					
				 КонецЕсли;
				
				 ТабДок.Вывести(ОбластьСтрока);

				 НомерСтроки = НомерСтроки + 1;
				 ТЗМатериалы.Удалить(Строка);
				 
			 Иначе
				 
				 Сч = Сч + 1;
				 
			 КонецЕсли;
			
		КонецЦикла;
		
		Сч = 0;
		ПервыйПодЗаказ = Истина;	 
		
		Пока Сч < ТЗМатериалы.Количество() Цикл
			
			 Строка = ТЗМатериалы[Сч];
			 
			 Если (ТекущийПоставщик = Строка.Поставщик) И ( ЗначениеЗаполнено(Строка.Спецификация) ) Тогда
				 
				 
				 Если Строка.ЗакупОптом Тогда
					ОбластьСтрока = ПодЗаказСтрокаОптом;					
				 Иначе
					ОбластьСтрока = ПодЗаказСтрока;	
				 КонецЕсли;
				 
				 ОбластьКонтрагент.Параметры.Заполнить(Строка);
				 ОбластьСтрока.Параметры.Заполнить(Строка);
				 ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
				 ОбластьСтрока.Параметры.Комментарий = "Спец: "+Формат(Строка.Спецификация, "ЧВН=; ЧГ=0")+". "+Строка.Комментарий;
					
				 
				 Если ПервыйПодЗаказ И ПервыйНеПодЗаказ Тогда
					
					ПервыйПодЗаказ = Ложь;
										
					ДляПроверкиВывода = Новый Массив;
					ДляПроверкиВывода.Добавить(ОбластьКонтрагент); 
					ДляПроверкиВывода.Добавить(ПодЗаказЗаголовокВнеГрупп);
					ДляПроверкиВывода.Добавить(ПодЗаказШапка);
					ДляПроверкиВывода.Добавить(ОбластьСтрока);
					
					Пока НЕ ТабДок.ПроверитьВывод(ДляПроверкиВывода) Цикл
						ТабДок.ВывестиГоризонтальныйРазделительСтраниц();	
					КонецЦикла;
					
					ТабДок.Вывести(ОбластьКонтрагент);
					ТабДок.Вывести(ПодЗаказЗаголовокВнеГрупп);
					ТабДок.Вывести(ПодЗаказШапка);
					
				 КонецЕсли;
				
				 Если ПервыйПодЗаказ И НЕ ПервыйНеПодЗаказ Тогда
					
					ПервыйПодЗаказ = Ложь;
										
					ДляПроверкиВывода = Новый Массив;
					ДляПроверкиВывода.Добавить(ПодЗаказЗаголовок);
					ДляПроверкиВывода.Добавить(ПодЗаказШапка);
					ДляПроверкиВывода.Добавить(ОбластьСтрока);
					
					Пока НЕ ТабДок.ПроверитьВывод(ДляПроверкиВывода) Цикл
						ТабДок.ВывестиГоризонтальныйРазделительСтраниц();	
					КонецЦикла;
					
					ТабДок.Вывести(ПодЗаказЗаголовок);
					ТабДок.Вывести(ПодЗаказШапка);
					
				 КонецЕсли;
				
				 ТабДок.Вывести(ОбластьСтрока);

				 НомерСтроки = НомерСтроки + 1;
				 ТЗМатериалы.Удалить(Строка);
				 
			 Иначе
				 
				 Сч = Сч + 1;
				 
			 КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ТабДок.Вывести(Подвал);
	
КонецПроцедуры