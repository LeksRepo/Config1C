﻿
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,
	ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АвансовыйОтчет") Тогда
		ПодготовитьПечатнуюФорму("АвансовыйОтчет", "Авансовый отчет", "Документ.АвансовыйОтчет.АвансовыйОтчет",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета);
	Если НужноПечататьМакет Тогда
		Если ИмяМакета = "АвансовыйОтчет" Тогда
			ТабДок = ПечатьКассовыйОрдер(МассивОбъектов, ОбъектыПечати); 
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета,
		ПредставлениеМакета, ТабДок,, ПолныйПутьКМакету);
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьКассовыйОрдер(МассивОбъектов, ОбъектыПечати) Экспорт
	
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
	Макет 	= Документы.АвансовыйОтчет.ПолучитьМакет("АвансовыйОтчет");
	Шапка 	= Макет.ПолучитьОбласть("Шапка");
	Титул 	= Макет.ПолучитьОбласть("Титул");
	Строка 	= Макет.ПолучитьОбласть("Строка");
	Подвал 	= Макет.ПолучитьОбласть("Подвал");
	
	ТабДок.Очистить();
	
	ВставлятьРазделительСтраниц = Ложь;	
	
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		ФормСтрока 		= "Л = ru_RU; ДП = Истина";
		ПарПредмета 	= "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
		СуммаОтчетаПрописью 	= ЧислоПрописью(Выборка.Израсходовано, ФормСтрока, ПарПредмета);
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

Процедура ПриходныйОрдер(ТабДок, Ссылка) Экспорт
	
	Макет = Документы.АвансовыйОтчет.ПолучитьМакет("ПриходныйОрдер");
	Запрос = Новый Запрос;
	
	Для каждого Документ Из Ссылка Цикл
		
		СтруктураРеквизитов = ЛексСервер.ЗначенияРеквизитовОбъекта(Документ, "Дата, Подразделение, Склад");
		ДатаДокумента = СтруктураРеквизитов.Дата;
		//Регион = ЛексСервер.ЗначениеРеквизитаОбъекта(СтруктураРеквизитов.Склад, "Регион");
		//
		//Если НЕ ЗначениеЗаполнено(Регион) Тогда
		//	
		//	Регион = ЛексСервер.ЗначениеРеквизитаОбъекта(СтруктураРеквизитов.Подразделение, "Регион");
		//	
		//КонецЕсли;
		
		Запрос.Параметры.Вставить("Ссылка", Документ);
		Запрос.Параметры.Вставить("ДатаДокумента", ДатаДокумента);
		//Запрос.Параметры.Вставить("Регион", Регион);
		Запрос.Параметры.Вставить("Подразделение", СтруктураРеквизитов.Подразделение);
		Запрос.Текст =
		
		//Дима сказал не выводить платежи в Приходном ордере, только материалы
		
		"ВЫБРАТЬ
		|	АвансовыйОтчетСписокНоменклатуры.Ссылка.Автор,
		|	АвансовыйОтчетСписокНоменклатуры.Ссылка.Дата,
		|	АвансовыйОтчетСписокНоменклатуры.Ссылка.Комментарий,
		|	АвансовыйОтчетСписокНоменклатуры.Ссылка.Номер,
		|	АвансовыйОтчетСписокНоменклатуры.Ссылка.Подразделение,
		|	АвансовыйОтчетСписокНоменклатуры.Ссылка.СуммаДокумента,
		|	АвансовыйОтчетСписокНоменклатуры.Ссылка.ФизЛицо,
		|	АвансовыйОтчетСписокНоменклатуры.НомерСтроки,
		|	АвансовыйОтчетСписокНоменклатуры.Номенклатура КАК Номенклатура,
		|	АвансовыйОтчетСписокНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	АвансовыйОтчетСписокНоменклатуры.Количество,
		|	АвансовыйОтчетСписокНоменклатуры.Цена,
		|	АвансовыйОтчетСписокНоменклатуры.Сумма,
		|	АвансовыйОтчетСписокНоменклатуры.Ссылка,
		|	АвансовыйОтчетСписокНоменклатуры.Контрагент КАК Поставщик
		|ПОМЕСТИТЬ СпНоменклатуры
		|ИЗ
		|	Документ.АвансовыйОтчет.СписокНоменклатуры КАК АвансовыйОтчетСписокНоменклатуры
		|ГДЕ
		|	АвансовыйОтчетСписокНоменклатуры.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СпНоменклатуры.Автор КАК Автор,
		|	СпНоменклатуры.Дата КАК Дата,
		|	СпНоменклатуры.Комментарий КАК Комментарий,
		|	СпНоменклатуры.Номер КАК Номер,
		|	СпНоменклатуры.Подразделение КАК Подразделение,
		|	СпНоменклатуры.СуммаДокумента КАК СуммаДокумента,
		|	СпНоменклатуры.ФизЛицо КАК ФизЛицо,
		|	СпНоменклатуры.НомерСтроки КАК НомерСтроки,
		|	СпНоменклатуры.Номенклатура КАК Номенклатура,
		|	СпНоменклатуры.ЕдиницаИзмерения,
		|	СпНоменклатуры.Количество,
		|	СпНоменклатуры.Цена,
		|	СпНоменклатуры.Сумма,
		|	СпНоменклатуры.Ссылка КАК Ссылка,
		|	СпНоменклатуры.Поставщик КАК Поставщик,
		|	ВЫРАЗИТЬ(ВЫБОР
		|			КОГДА ВЫРАЗИТЬ(СпНоменклатуры.Номенклатура КАК Справочник.Номенклатура).Базовый
		|				ТОГДА ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная
		|			ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * СпНоменклатуры.Номенклатура.КоэффициентБазовых
		|		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК ПлановаяЦена,
		|	ВЫБОР
		|		КОГДА НЕ СпНоменклатуры.Номенклатура.МатериалЗаказчика
		|				И СпНоменклатуры.Номенклатура.ВидНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Услуга)
		|			ТОГДА СпНоменклатуры.Сумма - ЕСТЬNULL(ВЫРАЗИТЬ(ВЫБОР
		|							КОГДА ВЫРАЗИТЬ(СпНоменклатуры.Номенклатура КАК Справочник.Номенклатура).Базовый
		|								ТОГДА ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная
		|							ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * СпНоменклатуры.Номенклатура.КоэффициентБазовых
		|						КОНЕЦ КАК ЧИСЛО(15, 2)), 0) * СпНоменклатуры.Количество
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Отклонение
		|ИЗ
		|	СпНоменклатуры КАК СпНоменклатуры
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(&ДатаДокумента, Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних
		|		ПО (ВЫБОР
		|				КОГДА СпНоменклатуры.Номенклатура.Базовый
		|					ТОГДА СпНоменклатуры.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
		|				ИНАЧЕ СпНоменклатуры.Номенклатура.БазоваяНоменклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
		|			КОНЕЦ)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|ИТОГИ
		|	МАКСИМУМ(Автор),
		|	МАКСИМУМ(Дата),
		|	МАКСИМУМ(Комментарий),
		|	МАКСИМУМ(Номер),
		|	МАКСИМУМ(Подразделение),
		|	МАКСИМУМ(СуммаДокумента),
		|	МАКСИМУМ(ФизЛицо),
		|	СУММА(Отклонение)
		|ПО
		|	Ссылка";
		
		Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
						
		Запрос.Параметры.Вставить("Ссылка", Документ.ДокументОснование);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СписокНоменклатуры.Номенклатура,
		|	СписокНоменклатуры.Поставщик,
		|	СписокНоменклатуры.РучнойВвод КАК Количество,
		|	СписокНоменклатуры.ЕдиницаИзмерения
		|ПОМЕСТИТЬ Список
		|ИЗ
		|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК СписокНоменклатуры
		|ГДЕ
		|	СписокНоменклатуры.Ссылка = &Ссылка
		|	И СписокНоменклатуры.РучнойВвод > 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СписокНоменклатурыПодЗаказ.Номенклатура,
		|	СписокНоменклатурыПодЗаказ.Поставщик,
		|	СписокНоменклатурыПодЗаказ.РучнойВвод,
		|	СписокНоменклатурыПодЗаказ.ЕдиницаИзмерения
		|ИЗ
		|	Документ.ОперативныйЗакуп.СписокНоменклатурыПодЗаказ КАК СписокНоменклатурыПодЗаказ
		|ГДЕ
		|	СписокНоменклатурыПодЗаказ.Ссылка = &Ссылка
		|	И СписокНоменклатурыПодЗаказ.РучнойВвод > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Список.Номенклатура,
		|	Список.Поставщик,
		|	СУММА(Список.Количество) КАК Количество,
		|	Список.ЕдиницаИзмерения,
		|	ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная КАК Цена,
		|	ВЫРАЗИТЬ(ВЫБОР
		|			КОГДА ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура).Базовый
		|				ТОГДА ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная
		|			ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * Список.Номенклатура.КоэффициентБазовых
		|		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК ПлановаяЦена
		|ИЗ
		|	Список КАК Список
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(&ДатаДокумента, Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних
		|		ПО (ВЫБОР
		|				КОГДА Список.Номенклатура.Базовый
		|					ТОГДА Список.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
		|				ИНАЧЕ Список.Номенклатура.БазоваяНоменклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
		|			КОНЕЦ)
		|
		|СГРУППИРОВАТЬ ПО
		|	Список.Номенклатура,
		|	Список.Поставщик,
		|	Список.ЕдиницаИзмерения,
		|	ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная,
		|	ВЫРАЗИТЬ(ВЫБОР
		|			КОГДА ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура).Базовый
		|				ТОГДА ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная
		|			ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * Список.Номенклатура.КоэффициентБазовых
		|		КОНЕЦ КАК ЧИСЛО(15, 2))";
		
		ОпЗакуп = Запрос.Выполнить().Выгрузить();
		
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		Шапка = Макет.ПолучитьОбласть("Шапка");
		ОбластьСписокПлатежейШапка = Макет.ПолучитьОбласть("СписокПлатежейШапка");
		ОбластьСписокПлатежей = Макет.ПолучитьОбласть("СписокПлатежей");
		Подвал = Макет.ПолучитьОбласть("Подвал");
		ИтогПлатежей = Макет.ПолучитьОбласть("ИтогПлатежей");
		
		ОбластьШапкаМатериалыНаОсновании = Макет.ПолучитьОбласть("ШапкаМатериалыНаОсновании");
		ОбластьШапкаМатериалыВручную = Макет.ПолучитьОбласть("ШапкаМатериалыВручную");
		ОбластьШапкаМатериалыНеКупленные = Макет.ПолучитьОбласть("ШапкаМатериалыНеКупленные");
		ОбластьШапкаПлатежи = Макет.ПолучитьОбласть("ШапкаПлатежи");
		
		ОбластьРазделитель = Макет.ПолучитьОбласть("Разделитель");
		
		ТабДок.Очистить();
		
		ВставлятьРазделительСтраниц = Ложь;
		Пока Выборка.Следующий() Цикл
			Если ВставлятьРазделительСтраниц Тогда
				ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ТабДок.Вывести(ОбластьЗаголовок);
			
			Шапка.Параметры.Заполнить(Выборка);
			ТабДок.Вывести(Шапка, Выборка.Уровень());
			
			// Раскидать материалы по таблицам
			
			СписокНоменклатуры = Выборка.Выбрать();
			СписокНоменклатуры = ЗаполнитьМассивНоменклатуры(СписокНоменклатуры);
			
			СписокНаОсновании = Новый Массив;
			СписокНеКупленных = Новый Массив;
			СписокДобавленных = Новый Массив;
	
			Для Каждого СтрокаНом Из СписокНоменклатуры Цикл
				
					ЕстьСтрока = Ложь;
				
					Для Каждого ОпЗакупСтрока Из ОпЗакуп Цикл
						
						Если (ОпЗакупСтрока.Номенклатура = СтрокаНом.Номенклатура) И (ОпЗакупСтрока.Поставщик = СтрокаНом.Поставщик) Тогда
							
							ЕстьСтрока = Истина;
							
							Если ОпЗакупСтрока.Количество >= СтрокаНом.Количество Тогда
								
								ДобавитьВСписок(СтрокаНом, СписокНаОсновании, СтрокаНом.Количество);
								ДобавитьВСписок(СтрокаНом, СписокНеКупленных, ОпЗакупСтрока.Количество - СтрокаНом.Количество);
								
							Иначе
								
								ДобавитьВСписок(СтрокаНом, СписокНаОсновании, ОпЗакупСтрока.Количество);
								ДобавитьВСписок(СтрокаНом, СписокДобавленных, СтрокаНом.Количество - ОпЗакупСтрока.Количество);
		
						    КонецЕсли;
								 	
						КонецЕсли;
						
					КонецЦикла;
					
					Если НЕ ЕстьСтрока Тогда
						
						ДобавитьВСписок(СтрокаНом, СписокДобавленных, СтрокаНом.Количество);	
						
					КонецЕсли;
		
			КонецЦикла;
			
			Для Каждого ОпЗакупСтрока Из ОпЗакуп Цикл
				
			 	 ЕстьСтрока = Ложь;
				 
				 Для Каждого СтрокаНом Из СписокНоменклатуры Цикл
					 
					 Если (ОпЗакупСтрока.Номенклатура = СтрокаНом.Номенклатура) И (ОпЗакупСтрока.Поставщик = СтрокаНом.Поставщик) Тогда
						 
						 ЕстьСтрока = Истина;
						 Прервать;
							 
					 КонецЕсли;
					
				 КонецЦикла;
				 
				 Если НЕ ЕстьСтрока Тогда
					 
					 ДобавитьВСписок(ОпЗакупСтрока, СписокНеКупленных, ОпЗакупСтрока.Количество);
					 
				 КонецЕсли;
				
				
			КонецЦикла;
			 
			// Вывести материалы по таблицам
			
			СуммаОтклонение = 0;
			СуммаДокумента = 0;
			
			// На Основании
	
			Если СписокНаОсновании.Количество() > 0 Тогда
				
				ТабДок.Вывести(ОбластьРазделитель);
				ТабДок.Вывести(ОбластьШапкаМатериалыНаОсновании);
				ТабДок.Вывести(ОбластьСписокПлатежейШапка);
								
				Для Каждого Строка Из СписокНаОсновании Цикл
					
					ОбластьСписокПлатежей.Параметры.Заполнить(Строка);
					ОбластьСписокПлатежей.Параметры.Цена = Окр(Строка.Цена);
					ОбластьСписокПлатежей.Параметры.ПлановаяЦена = Окр(Строка.ПлановаяЦена);
					ОбластьСписокПлатежей.Параметры.Сумма = Строка.Количество*Окр(Строка.Цена);
					
					СуммаДокумента = СуммаДокумента + Строка.Количество*Окр(Строка.Цена);
					
					Отклонение = Строка.Количество*Окр(Строка.Цена) - Строка.Количество*Окр(Строка.ПлановаяЦена); 
					ОбластьСписокПлатежей.Параметры.Отклонение = Отклонение;
					
					СуммаОтклонение = СуммаОтклонение + Отклонение;
					
					ТабДок.Вывести(ОбластьСписокПлатежей);

				КонецЦикла;
			
			КонецЕсли;
			
			// Добавленные
			
			Если СписокДобавленных.Количество() > 0 Тогда
				
				ТабДок.Вывести(ОбластьРазделитель);
				ТабДок.Вывести(ОбластьШапкаМатериалыВручную);
				ТабДок.Вывести(ОбластьСписокПлатежейШапка);
								
				Для Каждого Строка Из СписокДобавленных Цикл
					
					ОбластьСписокПлатежей.Параметры.Заполнить(Строка);
					ОбластьСписокПлатежей.Параметры.Цена = Окр(Строка.Цена);
					ОбластьСписокПлатежей.Параметры.ПлановаяЦена = Окр(Строка.ПлановаяЦена);
					ОбластьСписокПлатежей.Параметры.Сумма = Строка.Количество*Окр(Строка.Цена);
					
					СуммаДокумента = СуммаДокумента + Строка.Количество*Окр(Строка.Цена);
					
					Отклонение = Строка.Количество*Окр(Строка.Цена) - Строка.Количество*Окр(Строка.ПлановаяЦена); 
					ОбластьСписокПлатежей.Параметры.Отклонение = Отклонение;
					
					СуммаОтклонение = СуммаОтклонение + Отклонение;
					
					ТабДок.Вывести(ОбластьСписокПлатежей);

				КонецЦикла;
			
			КонецЕсли;
						
			ИтогПлатежей.Параметры.Сумма = СуммаДокумента;  
			ИтогПлатежей.Параметры.Отклонение = СуммаОтклонение;
			ТабДок.Вывести(ИтогПлатежей);
			
			ТабДок.Вывести(ОбластьРазделитель);
			Подвал.Параметры.Заполнить(Выборка);
			ТабДок.Вывести(Подвал);
			
			// Не Купленные
			
			Если СписокНеКупленных.Количество() > 0 Тогда
				
				ТабДок.Вывести(ОбластьРазделитель);
				ТабДок.Вывести(ОбластьШапкаМатериалыНеКупленные);
				ТабДок.Вывести(ОбластьСписокПлатежейШапка);
								
				Для Каждого Строка Из СписокНеКупленных Цикл
					
					ОбластьСписокПлатежей.Параметры.Заполнить(Строка);					
					ОбластьСписокПлатежей.Параметры.Цена = Окр(Строка.ПлановаяЦена);
					ОбластьСписокПлатежей.Параметры.ПлановаяЦена = Окр(Строка.ПлановаяЦена);
					ОбластьСписокПлатежей.Параметры.Сумма = Строка.Количество*Окр(Строка.ПлановаяЦена);
					ОбластьСписокПлатежей.Параметры.Отклонение = "";
					
					ТабДок.Вывести(ОбластьСписокПлатежей);

				КонецЦикла;
			
			КонецЕсли;
			
			ВставлятьРазделительСтраниц = Истина;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЗаполнитьМассивНоменклатуры(Выборка)
	
	Мас = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		Стр = Новый Структура;
		Стр.Вставить("Номенклатура", Выборка.Номенклатура);
		Стр.Вставить("Количество", Выборка.Количество);
		Стр.Вставить("Цена", Выборка.Цена);
		Стр.Вставить("ЕдиницаИзмерения", Выборка.ЕдиницаИзмерения);
		Стр.Вставить("Поставщик", Выборка.Поставщик);
		Стр.Вставить("ПлановаяЦена", Выборка.ПлановаяЦена);
		
		Мас.Добавить(Стр);
		
	КонецЦикла;
	
	Возврат Мас;
	
КонецФункции

Процедура ДобавитьВСписок(Элемент, Массив, Количество)
	
	Если Количество > 0 Тогда 
		
		Флаг = Ложь;
		
		Стр = Новый Структура;
		Стр.Вставить("Номенклатура", Элемент.Номенклатура);
		Стр.Вставить("Количество", Количество);
		Стр.Вставить("Цена", Элемент.Цена);
		Стр.Вставить("ЕдиницаИзмерения", Элемент.ЕдиницаИзмерения);
		Стр.Вставить("Поставщик", Элемент.Поставщик);
		Стр.Вставить("ПлановаяЦена", Элемент.ПлановаяЦена);
		
		Для Каждого Строка Из Массив Цикл
			
			Если (Строка.Номенклатура = Стр.Номенклатура) И (Строка.Поставщик = Стр.Поставщик) Тогда
				
				Строка.Количество = Строка.Количество + Стр.Количество;
				Флаг = Истина;
				Прервать;
					
			КонецЕсли;
			
		КонецЦикла;
		
		Если НЕ Флаг Тогда
			
			Массив.Добавить(Стр);
			
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры
