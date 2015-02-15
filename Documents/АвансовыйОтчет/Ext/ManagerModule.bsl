﻿
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АвансовыйОтчет") Тогда
		ПодготовитьПечатнуюФорму("АвансовыйОтчет", "Авансовый отчет", "Документ.АвансовыйОтчет.АвансовыйОтчет",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриходныйОрдер") Тогда
		ПодготовитьПечатнуюФорму("ПриходныйОрдер", "Приходный ордер", "Документ.АвансовыйОтчет.ПриходныйОрдер",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	Если ИмяМакета = "АвансовыйОтчет" Тогда
		ТабДок = ПечатьАвансовыйОтчет(МассивОбъектов, ОбъектыПечати);
	КонецЕсли;
	
	Если ИмяМакета = "ПриходныйОрдер" Тогда
		ТабДок = ПриходныйОрдер(МассивОбъектов, ОбъектыПечати);
	КонецЕсли;
	
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета,
	ПредставлениеМакета, ТабДок,, ПолныйПутьКМакету);
	
КонецПроцедуры

Функция ПечатьАвансовыйОтчет(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_АвансовыйОтчет";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АвансовыйОтчет.Подразделение КАК ПредставлениеПодразделения,
	|	АвансовыйОтчет.СуммаДокумента КАК Израсходовано,
	|	АвансовыйОтчет.ФизЛицо КАК ПредставлениеПодотчетногоЛица,
	|	АвансовыйОтчет.Подразделение.Организация КАК ПредставлениеОрганизации,
	|	АвансовыйОтчет.Дата КАК ДатаДокумента,
	|	АвансовыйОтчет.СписокПлатежей.(
	|		НомерСтроки,
	|		Сумма КАК ПоОтчету,
	|		СчетУчета КАК ДебетСубСчета,
	|		СтатьяДДС КАК НаименованиеРасхода
	|	),
	|	АвансовыйОтчет.Ссылка,
	|	АвансовыйОтчет.Номер КАК НомерДокумента,
	|	АвансовыйОтчет.ФизЛицо.ВЛице КАК ПредставлениеПодотчетногоЛицаОт,
	|	АвансовыйОтчет.СписокНоменклатуры.(
	|		НомерСтроки,
	|		Номенклатура,
	|		Сумма КАК ПоОтчету
	|	)
	|ИЗ
	|	Документ.АвансовыйОтчет КАК АвансовыйОтчет
	|ГДЕ
	|	АвансовыйОтчет.Проведен
	|	И АвансовыйОтчет.Ссылка В(&Ссылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Макет = Документы.АвансовыйОтчет.ПолучитьМакет("АвансовыйОтчет");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Титул = Макет.ПолучитьОбласть("Титул");
	Строка = Макет.ПолучитьОбласть("Строка");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	
	ТабДок.Очистить();
	
	ВставлятьРазделительСтраниц = Ложь;
	
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		ФормСтрока = "Л = ru_RU; ДП = Истина";
		ПарПредмета = "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
		СуммаОтчетаПрописью = ЧислоПрописью(Выборка.Израсходовано, ФормСтрока, ПарПредмета);
		ИзрасходованоРуб = Цел(Выборка.Израсходовано);
		ИзрасходованоКоп = Формат((Выборка.Израсходовано - ИзрасходованоРуб) * 100, "ЧЦ=2; ЧН=00; ЧВН=");
		Титул.Параметры.Заполнить(Выборка);
		Титул.Параметры.СуммаОтчетаПрописью 	= СуммаОтчетаПрописью;
		Титул.Параметры.ИзрасходованоРуб = ИзрасходованоРуб;
		Титул.Параметры.ИзрасходованоКоп = ИзрасходованоКоп;
		ТабДок.Вывести(Титул);
		
		ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		
		// ОБОРОТНАЯ СТОРОНА
		ТабДок.Вывести(Шапка);
		
		// Выводим табличные части
		
		ТЗ = Выборка.СписокПлатежей.Выгрузить();
		Для Каждого Стр Из ТЗ Цикл
			Строка.Параметры.Заполнить(Стр);
			Строка.Параметры.ДокументДата = Выборка.ДатаДокумента;
			Строка.Параметры.ДокументНомер = Выборка.НомерДокумента;
			ТабДок.Вывести(Строка);
		КонецЦикла;
		
		ТЗНоменклатура = Выборка.СписокНоменклатуры.Выгрузить();
		Для Каждого СтрокаНоменклатуры Из ТЗНоменклатура Цикл
			Строка.Параметры.Заполнить(СтрокаНоменклатуры);
			Строка.Параметры.ДебетСубСчета = ПланыСчетов.Управленческий.МатериалыНаСкладе;
			Строка.Параметры.НаименованиеРасхода = СтрокаНоменклатуры.Номенклатура.СтатьяДвиженияДенежныхСредств;
			Строка.Параметры.ДокументДата = Выборка.ДатаДокумента;
			Строка.Параметры.ДокументНомер = Выборка.НомерДокумента;
			ТабДок.Вывести(Строка);
		КонецЦикла;
		
		Подвал.Параметры.ИтогоПоОтчету = Выборка.Израсходовано;
		Подвал.Параметры.ПредставлениеПодотчетногоЛица = Выборка.ПредставлениеПодотчетногоЛица;
		ТабДок.Вывести(Подвал);
		
		ВставлятьРазделительСтраниц = Истина;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, 
		НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

Функция ПриходныйОрдер(МассивОбъектов, ОбъектыПечати) Экспорт	
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПриходныйОрдер";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = Документы.АвансовыйОтчет.ПолучитьМакет("ПриходныйОрдер");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	СтрокаВыделенная = Макет.ПолучитьОбласть("СтрокаВыделенная");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	СтруктураРеквизитов = ЛексСервер.ЗначенияРеквизитовОбъекта(МассивОбъектов[0], "Дата, Подразделение, Склад");
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивОбъектов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АвансовыйОтчетСписокНоменклатуры.Ссылка КАК АвансовыйОтчет,
	|	АвансовыйОтчетСписокНоменклатуры.Ссылка.ДокументОснование КАК ОперативныйЗакуп,
	|	АвансовыйОтчетСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	АвансовыйОтчетСписокНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(АвансовыйОтчетСписокНоменклатуры.Количество) КАК КоличествоАванс,
	|	СРЕДНЕЕ(АвансовыйОтчетСписокНоменклатуры.Цена) КАК ЦенаАванс,
	|	СУММА(АвансовыйОтчетСписокНоменклатуры.Сумма) КАК СуммаАванс,
	|	АвансовыйОтчетСписокНоменклатуры.Контрагент КАК КонтрагентАванс
	|ПОМЕСТИТЬ втАвансовыйОтчет
	|ИЗ
	|	Документ.АвансовыйОтчет.СписокНоменклатуры КАК АвансовыйОтчетСписокНоменклатуры
	|ГДЕ
	|	АвансовыйОтчетСписокНоменклатуры.Ссылка В(&МассивОбъектов)
	|
	|СГРУППИРОВАТЬ ПО
	|	АвансовыйОтчетСписокНоменклатуры.Контрагент,
	|	АвансовыйОтчетСписокНоменклатуры.Номенклатура,
	|	АвансовыйОтчетСписокНоменклатуры.Ссылка,
	|	АвансовыйОтчетСписокНоменклатуры.Номенклатура.ЕдиницаИзмерения,
	|	АвансовыйОтчетСписокНоменклатуры.Ссылка.ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АвансовыйОтчет.Ссылка КАК АвансовыйОтчет,
	|	ОперативныйЗакупСписокНоменклатуры.Ссылка КАК ОперативныйЗакуп,
	|	ОперативныйЗакупСписокНоменклатуры.Номенклатура,
	|	ОперативныйЗакупСписокНоменклатуры.ЕдиницаИзмерения,
	|	ОперативныйЗакупСписокНоменклатуры.КоличествоАвансовый КАК КоличествоОпер,
	|	ОперативныйЗакупСписокНоменклатуры.Поставщик КАК КонтрагентОпер,
	|	ОперативныйЗакупСписокНоменклатуры.Цена КАК ЦенаОпер,
	|	ОперативныйЗакупСписокНоменклатуры.Стоимость КАК СуммаОпер
	|ПОМЕСТИТЬ втОперативныйЗакуп
	|ИЗ
	|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК ОперативныйЗакупСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АвансовыйОтчет КАК АвансовыйОтчет
	|		ПО ОперативныйЗакупСписокНоменклатуры.Ссылка = АвансовыйОтчет.ДокументОснование
	|ГДЕ
	|	ОперативныйЗакупСписокНоменклатуры.Ссылка В
	|			(ВЫБРАТЬ
	|				т.ОперативныйЗакуп
	|			ИЗ
	|				втАвансовыйОтчет КАК т)
	|	И ОперативныйЗакупСписокНоменклатуры.КоличествоАвансовый > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втАвансовыйОтчет.АвансовыйОтчет,
	|	втАвансовыйОтчет.ОперативныйЗакуп,
	|	втАвансовыйОтчет.Номенклатура,
	|	втАвансовыйОтчет.ЕдиницаИзмерения,
	|	втАвансовыйОтчет.КоличествоАванс,
	|	втАвансовыйОтчет.ЦенаАванс,
	|	втАвансовыйОтчет.СуммаАванс,
	|	втАвансовыйОтчет.КонтрагентАванс,
	|	0 КАК КоличествоОпер,
	|	0 КАК КонтрагентОпер,
	|	0 КАК ЦенаОпер,
	|	0 КАК СуммаОпер
	|ПОМЕСТИТЬ втДанные
	|ИЗ
	|	втАвансовыйОтчет КАК втАвансовыйОтчет
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	втОперативныйЗакуп.АвансовыйОтчет,
	|	втОперативныйЗакуп.ОперативныйЗакуп,
	|	втОперативныйЗакуп.Номенклатура,
	|	втОперативныйЗакуп.ЕдиницаИзмерения,
	|	0,
	|	0,
	|	0,
	|	0,
	|	втОперативныйЗакуп.КоличествоОпер,
	|	втОперативныйЗакуп.КонтрагентОпер,
	|	втОперативныйЗакуп.ЦенаОпер,
	|	втОперативныйЗакуп.СуммаОпер
	|ИЗ
	|	втОперативныйЗакуп КАК втОперативныйЗакуп
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанные.АвансовыйОтчет КАК АвансовыйОтчет,
	|	втДанные.ОперативныйЗакуп,
	|	втДанные.Номенклатура,
	|	втДанные.ЕдиницаИзмерения,
	|	СУММА(втДанные.КоличествоАванс) КАК КоличествоАванс,
	|	СУММА(втДанные.ЦенаАванс) КАК ЦенаАванс,
	|	СУММА(втДанные.СуммаАванс) КАК СуммаАванс,
	|	МАКСИМУМ(втДанные.КонтрагентАванс) КАК КонтрагентАванс,
	|	СУММА(втДанные.КоличествоОпер) КАК КоличествоОпер,
	|	МАКСИМУМ(втДанные.КонтрагентОпер) КАК КонтрагентОпер,
	|	СУММА(втДанные.ЦенаОпер) КАК ЦенаОпер,
	|	СУММА(втДанные.СуммаОпер) КАК СуммаОпер
	|ИЗ
	|	втДанные КАК втДанные
	|
	|СГРУППИРОВАТЬ ПО
	|	втДанные.ЕдиницаИзмерения,
	|	втДанные.Номенклатура,
	|	втДанные.АвансовыйОтчет,
	|	втДанные.ОперативныйЗакуп
	|ИТОГИ ПО
	|	АвансовыйОтчет";
	
	ВыборкаДокументы = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВставлятьРазделительСтраниц = Ложь;
	
	Пока ВыборкаДокументы.Следующий() Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		// { Васильев Александр Леонидович [15.02.2015]
		// Знаю, что запрос в цикле, но для простоты чтения не буду переносить в запрос.
		ДанныеДокумента = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ВыборкаДокументы.АвансовыйОтчет, "СуммаДокумента, Номер, Дата");
		// } Васильев Александр Леонидович [15.02.2015]
		
		ОбластьЗаголовок.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ДанныеДокумента.Номер);
		ОбластьЗаголовок.Параметры.ДатаДокумента = Формат(ДанныеДокумента.Дата, "ДФ=dd.MM.yyyy");
		ТабДок.Вывести(ОбластьЗаголовок);
		
		ОбластьШапка.Параметры.Заполнить(ВыборкаДокументы.АвансовыйОтчет);
		ТабДок.Вывести(ОбластьШапка);
		
		СуммаПерерасхода = 0;
		НомерСтроки = 1;
		Выборка = ВыборкаДокументы.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.КонтрагентОпер <> Выборка.КонтрагентАванс Тогда
				Область = СтрокаВыделенная;
			Иначе
				Область = ОбластьСтрока;
			КонецЕсли;
			
			Перерасход = Выборка.СуммаАванс - Выборка.СуммаОпер;
			
			Область.Параметры.Заполнить(Выборка);
			Область.Параметры.НомерСтроки = НомерСтроки;
			Область.Параметры.ОтклонениеКоличество = Выборка.КоличествоАванс - Выборка.КоличествоОпер;
			Область.Параметры.Перерасход = Перерасход;
			ТабДок.Вывести(Область);
			
			СуммаПерерасхода = СуммаПерерасхода + Перерасход;
			НомерСтроки = НомерСтроки + 1;
			
		КонецЦикла; //Выборка.Следующий()
		
		ОбластьПодвал.Параметры.СуммаДокумента = ДанныеДокумента.СуммаДокумента;
		ОбластьПодвал.Параметры.СуммаПерерасхода = СуммаПерерасхода;
		ТабДок.Вывести(ОбластьПодвал);
		
		ВставлятьРазделительСтраниц = Истина;
		
	КонецЦикла;//ВыборкаДокументы.Следующий()
	
	Возврат ТабДок;
	
КонецФункции

//"ВЫБРАТЬ
//|	АвансовыйОтчетСписокНоменклатуры.Номенклатура КАК Номенклатура,
//|	АвансовыйОтчетСписокНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
//|	АвансовыйОтчетСписокНоменклатуры.Количество,
//|	АвансовыйОтчетСписокНоменклатуры.Цена,
//|	АвансовыйОтчетСписокНоменклатуры.Сумма,
//|	АвансовыйОтчетСписокНоменклатуры.Контрагент КАК Поставщик
//|ПОМЕСТИТЬ втАвансовыйОтчет
//|ИЗ
//|	Документ.АвансовыйОтчет.СписокНоменклатуры КАК АвансовыйОтчетСписокНоменклатуры
//|ГДЕ
//|	АвансовыйОтчетСписокНоменклатуры.Ссылка В(&МассивОбъектов)
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	втНоменклатура.Номенклатура КАК Номенклатура,
//|	втНоменклатура.ЕдиницаИзмерения,
//|	втНоменклатура.Количество,
//|	втНоменклатура.Цена,
//|	втНоменклатура.Сумма,
//|	ВЫРАЗИТЬ(ВЫБОР
//|			КОГДА ВЫРАЗИТЬ(втНоменклатура.Номенклатура КАК Справочник.Номенклатура).Базовый
//|				ТОГДА ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная
//|			ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * втНоменклатура.Номенклатура.КоэффициентБазовых
//|		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК ПлановаяЦена,
//|	ВЫБОР
//|		КОГДА НЕ втНоменклатура.Номенклатура.МатериалЗаказчика
//|				И втНоменклатура.Номенклатура.ВидНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Услуга)
//|			ТОГДА втНоменклатура.Сумма - ЕСТЬNULL(ВЫРАЗИТЬ(ВЫБОР
//|							КОГДА ВЫРАЗИТЬ(втНоменклатура.Номенклатура КАК Справочник.Номенклатура).Базовый
//|								ТОГДА ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная
//|							ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * втНоменклатура.Номенклатура.КоэффициентБазовых
//|						КОНЕЦ КАК ЧИСЛО(15, 2)), 0) * втНоменклатура.Количество
//|		ИНАЧЕ 0
//|	КОНЕЦ КАК Отклонение,
//|	ВЫБОР
//|		КОГДА втНоменклатура.Поставщик <> ЦеныНоменклатурыСрезПоследних.Поставщик
//|			ТОГДА ИСТИНА
//|		ИНАЧЕ ЛОЖЬ
//|	КОНЕЦ КАК Выделить
//|ПОМЕСТИТЬ Аванс
//|ИЗ
//|	втАвансовыйОтчет КАК втНоменклатура
//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(&ДатаДокумента, Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних
//|		ПО (ВЫБОР
//|				КОГДА втНоменклатура.Номенклатура.Базовый
//|					ТОГДА втНоменклатура.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
//|				ИНАЧЕ втНоменклатура.Номенклатура.БазоваяНоменклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
//|			КОНЕЦ)
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	СписокНоменклатуры.Номенклатура,
//|	СписокНоменклатуры.КоличествоАвансовый КАК Количество,
//|	СписокНоменклатуры.ЕдиницаИзмерения,
//|	СписокНоменклатуры.Поставщик
//|ПОМЕСТИТЬ втОперативныйЗакуп
//|ИЗ
//|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК СписокНоменклатуры
//|ГДЕ
//|	СписокНоменклатуры.Ссылка = &Закуп
//|	И СписокНоменклатуры.КоличествоАвансовый > 0
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	Список.Номенклатура,
//|	СУММА(Список.Количество) КАК Количество,
//|	Список.ЕдиницаИзмерения,
//|	ВЫРАЗИТЬ(ВЫБОР
//|			КОГДА ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура).Базовый
//|				ТОГДА ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная
//|			ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * Список.Номенклатура.КоэффициентБазовых
//|		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК ПлановаяЦена,
//|	ВЫБОР
//|		КОГДА Список.Поставщик <> ЦеныНоменклатурыСрезПоследних.Поставщик
//|			ТОГДА ИСТИНА
//|		ИНАЧЕ ЛОЖЬ
//|	КОНЕЦ КАК Выделить
//|ПОМЕСТИТЬ Закуп
//|ИЗ
//|	втОперативныйЗакуп КАК Список
//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(&ДатаДокумента, Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних
//|		ПО (ВЫБОР
//|				КОГДА Список.Номенклатура.Базовый
//|					ТОГДА Список.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
//|				ИНАЧЕ Список.Номенклатура.БазоваяНоменклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
//|			КОНЕЦ)
//|
//|СГРУППИРОВАТЬ ПО
//|	Список.Номенклатура,
//|	Список.ЕдиницаИзмерения,
//|	ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная,
//|	ВЫРАЗИТЬ(ВЫБОР
//|			КОГДА ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура).Базовый
//|				ТОГДА ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная
//|			ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * Список.Номенклатура.КоэффициентБазовых
//|		КОНЕЦ КАК ЧИСЛО(15, 2)),
//|	ВЫБОР
//|		КОГДА Список.Поставщик <> ЦеныНоменклатурыСрезПоследних.Поставщик
//|			ТОГДА ИСТИНА
//|		ИНАЧЕ ЛОЖЬ
//|	КОНЕЦ
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	ВЫБОР
//|		КОГДА Закуп.Номенклатура ЕСТЬ NULL 
//|			ТОГДА Аванс.Номенклатура
//|		ИНАЧЕ Закуп.Номенклатура
//|	КОНЕЦ КАК Номенклатура,
//|	ВЫБОР
//|		КОГДА Закуп.ЕдиницаИзмерения ЕСТЬ NULL 
//|			ТОГДА Аванс.ЕдиницаИзмерения
//|		ИНАЧЕ Закуп.ЕдиницаИзмерения
//|	КОНЕЦ КАК ЕдиницаИзмерения,
//|	ЕСТЬNULL(Закуп.Количество, 0) КАК ОпЗакуп,
//|	ЕСТЬNULL(Аванс.Количество, 0) КАК Куплено,
//|	ЕСТЬNULL(Аванс.Количество, 0) - ЕСТЬNULL(Закуп.Количество, 0) КАК Отклонение,
//|	ВЫБОР
//|		КОГДА Закуп.ПлановаяЦена ЕСТЬ NULL 
//|			ТОГДА Аванс.ПлановаяЦена
//|		ИНАЧЕ Закуп.ПлановаяЦена
//|	КОНЕЦ КАК ПлановаяЦена,
//|	ВЫБОР
//|		КОГДА Аванс.Цена ЕСТЬ NULL 
//|			ТОГДА Закуп.ПлановаяЦена
//|		ИНАЧЕ Аванс.Цена
//|	КОНЕЦ КАК Цена,
//|	ВЫБОР
//|		КОГДА Аванс.Выделить ЕСТЬ NULL 
//|			ТОГДА Закуп.Выделить
//|		ИНАЧЕ Аванс.Выделить
//|	КОНЕЦ КАК Выделить
//|ПОМЕСТИТЬ ПолныйНабор
//|ИЗ
//|	Закуп КАК Закуп
//|		ПОЛНОЕ СОЕДИНЕНИЕ Аванс КАК Аванс
//|		ПО Закуп.Номенклатура = Аванс.Номенклатура
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	ПолныйНабор.Номенклатура,
//|	ПолныйНабор.ЕдиницаИзмерения,
//|	ПолныйНабор.ОпЗакуп,
//|	ПолныйНабор.Куплено,
//|	ПолныйНабор.Отклонение,
//|	ПолныйНабор.ПлановаяЦена,
//|	ПолныйНабор.Цена,
//|	ПолныйНабор.Выделить,
//|	ВЫРАЗИТЬ(ПолныйНабор.Куплено * ПолныйНабор.Цена КАК ЧИСЛО(15, 2)) КАК Сумма,
//|	ВЫРАЗИТЬ(ПолныйНабор.Куплено * ПолныйНабор.Цена - ПолныйНабор.Куплено * ПолныйНабор.ПлановаяЦена КАК ЧИСЛО(15, 2)) КАК Перерасход
//|ИЗ
//|	ПолныйНабор КАК ПолныйНабор";
