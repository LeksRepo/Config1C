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
	
	ВидыСубконто = Новый Массив;
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура);
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивОбъектов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НарядЗаданиеСписокСпецификаций.Ссылка КАК Ссылка,
	|	НарядЗаданиеСписокСпецификаций.НомерСтроки,
	|	НарядЗаданиеСписокСпецификаций.ДатаИзготовления,
	|	НарядЗаданиеСписокСпецификаций.Спецификация,
	|	НарядЗаданиеСписокСпецификаций.Спецификация.Изделие КАК Изделие,
	|	НарядЗаданиеСписокСпецификаций.Спецификация.Номер КАК НомерСпецификации,
	|	НарядЗаданиеСписокСпецификаций.СуммаНаряда,
	|	НарядЗаданиеСписокСпецификаций.Ссылка.Номер КАК НомерНаряда,
	|	НарядЗаданиеСписокСпецификаций.Ссылка.Дата КАК ДатаНаряда,
	|	НарядЗаданиеСписокСпецификаций.Ссылка.Подразделение,
	|	НарядЗаданиеСписокСпецификаций.Ссылка.СуммаДокумента
	|ИЗ
	|	Документ.НарядЗадание.СписокСпецификаций КАК НарядЗаданиеСписокСпецификаций
	|ГДЕ
	|	НарядЗаданиеСписокСпецификаций.Ссылка В(&МассивОбъектов)
	|ИТОГИ ПО
	|	Ссылка";
	
	Макет = Документы.НарядЗадание.ПолучитьМакет("ПечатьНарядЗадания");
	Заголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	СпецификацииШапка = Макет.ПолучитьОбласть("СпецификацииШапка");
	СпецификацииСтрока = Макет.ПолучитьОбласть("СпецификацииСтрока");
	
	ВыборкаДокументы = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВставлятьРазделительСтраниц = Ложь;
	
	Пока ВыборкаДокументы.Следующий() Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		ТабДок.Вывести(Заголовок);
		
		Шапка.Параметры.Заполнить(ВыборкаДокументы);
		ТабДок.Вывести(Шапка);
		
		ТабДок.Вывести(СпецификацииШапка);
		
		ВыборкаСпецификации = ВыборкаДокументы.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаСпецификации.Следующий() Цикл
			
			СпецификацииСтрока.Параметры.Заполнить(ВыборкаСпецификации);
			СпецификацииСтрока.Параметры.Изделие = ВыборкаСпецификации.Изделие;
			СпецификацииСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(ВыборкаСпецификации.НомерСпецификации, "0");
			СпецификацииСтрока.Параметры.КоличествоДверей = ПосчитатьКоличествоДверей(ВыборкаСпецификации.Спецификация);;
			СпецификацииСтрока.Параметры.ЕстьКомплектация = ЕстьКомплектация(ВыборкаСпецификации.Спецификация);
			
			ТабДок.Вывести(СпецификацииСтрока);
			
		КонецЦикла;
		
		//////////////////////////////// ПРОСРОЧЕННОЕ ИЗГОТОВЛЕНИЕ
		
		ВывестиПросроченноеИзготовление(ТабДок, ВыборкаДокументы.ДатаНаряда, ВыборкаДокументы.Подразделение);
		
		//////////////////////////////// ГРАФИК ОТГРУЗОК
		
		ВывестиГрафикОтгрузок(ТабДок, ВыборкаДокументы.ДатаНаряда, ВыборкаДокументы.Подразделение);
		
		//////////////////////////////// ГРАФИК ДОСТАВОК
		
		ВывестиГрафикДоставок(ТабДок, ВыборкаДокументы.ДатаНаряда, ВыборкаДокументы.Подразделение);
		
		//////////////////////////////// ГРАФИК МОНТАЖЕЙ
		
		ВывестиГрафикМонтажей(ТабДок, ВыборкаДокументы.ДатаНаряда, ВыборкаДокументы.Подразделение);
		
		ВставлятьРазделительСтраниц = Истина;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументы.Ссылка);
		
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
	Настройки.ПараметрыДанных.Элементы[0].Значение = КонецДня(Период);
	
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

Функция ВывестиПросроченноеИзготовление(ТабДок, Период, Подразделение)
	
	Макет = Документы.НарядЗадание.ПолучитьМакет("ПечатьНарядЗадания");
	ПросроченныеСпецификации = Макет.ПолучитьОбласть("ПросроченныеСпецификации");
	СпецификацииСтрока = Макет.ПолучитьОбласть("СпецификацииСтрока");
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Период", Период);
	Запрос.Параметры.Вставить("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДокСпецификация.Ссылка КАК Спецификация,
	|	ДокСпецификация.Номер КАК НомерСпецификации,
	|	ДокСпецификация.Изделие,
	|	ДокСпецификация.ДатаИзготовления КАК ДатаИзготовления,
	|	ДокСпецификация.Срочный,
	|	ДокСпецификация.СуммаНарядаСпецификации КАК СуммаНаряда
	|ИЗ
	|	Документ.Спецификация КАК ДокСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО (СтатусСпецификацииСрезПоследних.Спецификация = ДокСпецификация.Ссылка)
	|ГДЕ
	|	ДокСпецификация.ДатаИзготовления < НАЧАЛОПЕРИОДА(&Период, ДЕНЬ)
	|	И (СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен)
	|			ИЛИ СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ПереданВЦех))
	|	И ДокСпецификация.Производство = &Подразделение
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаИзготовления";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		ТабДок.Вывести(ПросроченныеСпецификации);
		
		НомерСтроки = 1;
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СпецификацииСтрока.Параметры.Заполнить(Выборка);
			СпецификацииСтрока.Параметры.Изделие = Выборка.Изделие;
			СпецификацииСтрока.Параметры.НомерСтроки = НомерСтроки;
			СпецификацииСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.НомерСпецификации, "0");
			СпецификацииСтрока.Параметры.КоличествоДверей = ПосчитатьКоличествоДверей(Выборка.Спецификация);
			СпецификацииСтрока.Параметры.ЕстьКомплектация = ЕстьКомплектация(Выборка.Спецификация);
			
			ТабДок.Вывести(СпецификацииСтрока);
			
			НомерСтроки = 1 + НомерСтроки;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции

Функция ПосчитатьКоличествоДверей(СпецификацияСсылка)
	
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
