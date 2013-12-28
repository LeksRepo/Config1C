﻿
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьНарядЗадания") Тогда
		ПодготовитьПечатнуюФорму("ПечатьНарядЗадания", "Печать наряд задания", "Документ.НарядЗадание.ПечатьНарядЗадания",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьМатериалПоЦеховымЗонам") Тогда
		ПодготовитьПечатнуюФорму("ПечатьМатериалПоЦеховымЗонам", "Печать материал по цеховым зонам", "Документ.НарядЗадание.ПечатьМатериалПоЦеховымЗонам",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьГрафикОтгрузки") Тогда
		ПодготовитьПечатнуюФорму("ПечатьГрафикОтгрузки", "Печать графика отгрузок", "Документ.НарядЗадание.ПечатьГрафикОтгрузки",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета);
	Если НужноПечататьМакет Тогда
		
		Если ИмяМакета = "ПечатьНарядЗадания" Тогда
			ТабДок = ПечатьНарядЗадания(МассивОбъектов, ОбъектыПечати);
		ИначеЕсли ИмяМакета = "ПечатьМатериалПоЦеховымЗонам" Тогда
			ТабДок = ПечатьМатериалПоЦеховымЗонам(МассивОбъектов, ОбъектыПечати);
		ИначеЕсли ИмяМакета = "ПечатьГрафикОтгрузки" Тогда
			ТабДок = ПечатьГрафикОтгрузки(МассивОбъектов, ОбъектыПечати);
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета,
		ПредставлениеМакета, ТабДок,, ПолныйПутьКМакету);
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьГрафикОтгрузки(МассивОбъектов, ОбъектыПечати) Экспорт
	
	// { Васильев Александр Леонидович [28.12.2013]
	// на будущее
	// } Васильев Александр Леонидович [28.12.2013]
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПечатьНарядЗадани1111";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета="дверь, двери, двери, ж, копейка, копейки, копеек, ж, 0";
	
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, 1, ОбъектыПечати, Неопределено);
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьНарядЗадания(МассивОбъектов, ОбъектыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПечатьНарядЗадания";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета="дверь, двери, двери, ж, копейка, копейки, копеек, ж, 0";
	ВидыСубконто = Новый Массив;
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура);
	
	Макет = Документы.НарядЗадание.ПолучитьМакет("ПечатьНарядЗадания");
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Подразделение", );
	Запрос.Параметры.Вставить("Ссылка", МассивОбъектов);
	Запрос.Параметры.Вставить("ВидыСубконто", ВидыСубконто);
	Запрос.Текст =
	"ВЫБРАТЬ 
	|	НарядЗаданиеСписокНоменклатуры.Номенклатура,
	|	НарядЗаданиеСписокНоменклатуры.Ссылка КАК Ссылка,
	|	НарядЗаданиеСписокНоменклатуры.Затребовано,
	|	НарядЗаданиеСписокНоменклатуры.ОстатокВЦеху,
	|	НарядЗаданиеСписокНоменклатуры.ОстатокНаСкладе,
	|	НарядЗаданиеСписокНоменклатуры.ТребуетсяПоСпецификациям,
	|	НарядЗаданиеСписокНоменклатуры.Лимит,
	|	НарядЗаданиеСписокНоменклатуры.Номенклатура.ЦеховаяЗона КАК ЦеховаяЗона,
	|	НарядЗаданиеСписокНоменклатуры.НомерСтроки,
	|	НарядЗаданиеСписокНоменклатуры.Ссылка.Номер КАК НомерДокумента,
	|	НарядЗаданиеСписокНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|ИЗ
	|	Документ.НарядЗадание.СписокНоменклатуры КАК НарядЗаданиеСписокНоменклатуры
	|ГДЕ
	|	НарядЗаданиеСписокНоменклатуры.Ссылка В(&Ссылка)
	|ИТОГИ ПО
	|	Ссылка,
	|	ЦеховаяЗона";
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСписокНоменклатурыШапка = Макет.ПолучитьОбласть("СписокНоменклатурыШапка");
	ОбластьСписокНоменклатуры = Макет.ПолучитьОбласть("СписокНоменклатуры");
	ОбластьСписокИнженерныхРасчетовШапка = Макет.ПолучитьОбласть("СписокИнженерныхРасчетовШапка");
	ОбластьСписокИнженерныхРасчетов = Макет.ПолучитьОбласть("СписокИнженерныхРасчетов");
	ОбластьЦеховаяЗонаШапка = Макет.ПолучитьОбласть("ЦеховаяЗонаШапка");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	
	ТабДок.Очистить();
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		ТабДок.Вывести(ОбластьЗаголовок);
		
		Шапка.Параметры.Заполнить(Выборка.Ссылка);
		Шапка.Параметры.Номер =Выборка.НомерДокумента;
		ТабДок.Вывести(Шапка);
		
		// в запрос бы по хорошему
		ТабДок.Вывести(ОбластьСписокИнженерныхРасчетовШапка);
		Для каждого Строка Из Выборка.Ссылка.СписокСпецификаций Цикл
			
			КоличествоДверей = 0;
			Для каждого СтрокаДверь Из Строка.Спецификация.СписокДверей Цикл
				КоличествоДверей = КоличествоДверей + СтрокаДверь.Двери.Количество;
			КонецЦикла;
			
			Если КоличествоДверей > 0 Тогда
				КоличествоДверейПрописью = ЧислоПрописью(КоличествоДверей, ФормСтрока, ПарПредмета);
			КонецЕсли;
			
			ОбластьСписокИнженерныхРасчетов.Параметры.Заполнить(Строка);
			ОбластьСписокИнженерныхРасчетов.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Строка.Спецификация.Номер, "0");
			ОбластьСписокИнженерныхРасчетов.Параметры.КоличествоДверей = КоличествоДверейПрописью;
			ОбластьСписокИнженерныхРасчетов.Параметры.ЕстьКомплектация = ЕстьКомплектация(Строка.Спецификация);
			
			ТабДок.Вывести(ОбластьСписокИнженерныхРасчетов);
			
		КонецЦикла;
		
		Подвал.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Подвал);
		
		//////////////////////////////// ГРАФИК ОТГРУЗОК
		
		ВывестиГрафикОтгрузок(ТабДок, Выборка.Ссылка.Дата, Выборка.Ссылка.Подразделение);
		
		//////////////////////////////// ГРАФИК ДОСТАВОК
		
		ВывестиГрафикДоставок(ТабДок, Выборка.Ссылка.Дата, Выборка.Ссылка.Подразделение);
		
		//////////////////////////////// ГРАФИК МОНТАЖЕЙ
		
		ВывестиГрафикМонтажей(ТабДок, Выборка.Ссылка.Дата, Выборка.Ссылка.Подразделение);
		
		ВставлятьРазделительСтраниц = Истина;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьМатериалПоЦеховымЗонам(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПечаПечатьМатериалПоЦеховымЗонамтьНарядЗадания";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = Документы.НарядЗадание.ПолучитьМакет("ПечатьМатериалПоЦеховымЗонам");
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивНарядов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НарядЗаданиеСписокНоменклатуры.Номенклатура,
	|	НарядЗаданиеСписокНоменклатуры.Ссылка КАК Ссылка,
	|	0 КАК Затребовано,
	|	НарядЗаданиеСписокНоменклатуры.ОстатокВЦеху,
	|	НарядЗаданиеСписокНоменклатуры.ОстатокНаСкладе,
	|	НарядЗаданиеСписокНоменклатуры.ТребуетсяПоСпецификациям,
	|	НарядЗаданиеСписокНоменклатуры.Лимит,
	|	НарядЗаданиеСписокНоменклатуры.Номенклатура.ЦеховаяЗона КАК ЦеховаяЗона,
	|	НарядЗаданиеСписокНоменклатуры.НомерСтроки КАК НомерСтроки,
	|	НарядЗаданиеСписокНоменклатуры.Ссылка.Номер КАК НомерДокумента,
	|	НарядЗаданиеСписокНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	НарядЗаданиеСписокНоменклатуры.Ссылка.Дата ДатаДокумента
	|ИЗ
	|	Документ.НарядЗадание.СписокНоменклатуры КАК НарядЗаданиеСписокНоменклатуры
	|ГДЕ
	|	НарядЗаданиеСписокНоменклатуры.Ссылка В(&МассивНарядов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка,
	|	ЦеховаяЗона";
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьСписокНоменклатурыШапка = Макет.ПолучитьОбласть("СписокНоменклатурыШапка");
	ОбластьСписокНоменклатурыСтрока = Макет.ПолучитьОбласть("СписокНоменклатурыСтрока");
	
	ВставлятьРазделительСтраниц = Ложь;
	
	ВыборкаДокументы = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаДокументы.Следующий() Цикл
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		ВыборкаЦеховаяЗона = ВыборкаДокументы.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаЦеховаяЗона.Следующий() Цикл
			
			Если ВставлятьРазделительСтраниц Тогда
				ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ОбластьЗаголовок.Параметры.НомерДокумента = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(ВыборкаДокументы.НомерДокумента, "0");
			ОбластьЗаголовок.Параметры.ДатаДокумента = Формат(ВыборкаДокументы.ДатаДокумента, "ДЛФ=DD");
			ТабДок.Вывести(ОбластьЗаголовок);
			
			ОбластьСписокНоменклатурыШапка.Параметры.ЦеховаяЗона = ВыборкаЦеховаяЗона.ЦеховаяЗона;
			ТабДок.Вывести(ОбластьСписокНоменклатурыШапка);
			
			ВыборкаНоменклатура = ВыборкаЦеховаяЗона.Выбрать();
			
			Пока ВыборкаНоменклатура.Следующий() Цикл
				
				ОбластьСписокНоменклатурыСтрока.Параметры.Заполнить(ВыборкаНоменклатура);
				ТабДок.Вывести(ОбластьСписокНоменклатурыСтрока);
				
			КонецЦикла;
			
			ВставлятьРазделительСтраниц = Истина;
			
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументы.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

Функция ЕстьКомплектация(СпецификацияСсылка)
	
	Результат = Ложь;
	
	Для каждого Строка Из СпецификацияСсылка.СкладГотовойПродукции Цикл
		Если Строка.КоличествоЦех > 0 Тогда
			Результат = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ВывестиГрафикДоставок(ТабДок, Период, Подразделение)
	
	//Получаем схему из макета
	СхемаКомпоновкиДанных = Отчеты.ГрафикДоставок.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	//Из схемы возьмем настройки по умолчанию
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	Настройки.Отбор.Элементы[0].ПравоеЗначение = Подразделение;
	Настройки.ПараметрыДанных.Элементы[0].Значение = Новый СтандартныйПериод(НачалоДня(Период), КонецДня(Период));
	
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
	
	ТабДок.Вывести(Результат);
	
КонецФункции

Функция ВывестиГрафикМонтажей(ТабДок, Период, Подразделение)
	
	ПараметрыОтчета = Новый Структура;
	МассивМонтажников = Новый Массив;
	МассивГородов = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регион", Подразделение.Регион);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Города.Ссылка
	|ИЗ
	|	Справочник.Города КАК Города
	|ГДЕ
	|	Города.Регион = &Регион";
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МассивГородов.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
	
	ПараметрыОтчета.Вставить("Период", Новый СтандартныйПериод(НачалоДня(Период), КонецДня(Период)));
	ПараметрыОтчета.Вставить("МассивМонтажников", МассивМонтажников);
	ПараметрыОтчета.Вставить("МассивГородов", МассивГородов);
	
	ГрафикМонтажей = Отчеты.ГрафикМонтажей.СформироватьОтчет(ПараметрыОтчета);
	
	ТабДок.Вывести(ГрафикМонтажей);
	
КонецФункции

Функция ВывестиГрафикОтгрузок(ТабДок, Период, Подразделение)
	
	//Получаем схему из макета
	СхемаКомпоновкиДанных = Отчеты.ГрафикОтгрузок.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	//Из схемы возьмем настройки по умолчанию
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	Настройки.Отбор.Элементы[0].ПравоеЗначение = Подразделение;
	Настройки.ПараметрыДанных.Элементы[0].Значение = Новый СтандартныйПериод(НачалоДня(Период), КонецДня(Период));
	
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
	
	ТабДок.Вывести(Результат);
	
КонецФункции