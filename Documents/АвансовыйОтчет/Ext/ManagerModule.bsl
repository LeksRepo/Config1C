﻿Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,
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
	|	АвансовыйОтчет.ФизЛицо.ВЛице КАК ПредставлениеПодотчетногоЛицаОт
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
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АвансовыйОтчетСписокПлатежей.Ссылка.Автор КАК Автор,
	|	АвансовыйОтчетСписокПлатежей.Ссылка.Дата КАК Дата,
	|	АвансовыйОтчетСписокПлатежей.Ссылка.Комментарий КАК Комментарий,
	|	АвансовыйОтчетСписокПлатежей.Ссылка.Номер КАК Номер,
	|	АвансовыйОтчетСписокПлатежей.Ссылка.Подразделение КАК Подразделение,
	|	АвансовыйОтчетСписокПлатежей.Ссылка.СуммаДокумента КАК СуммаДокумента,
	|	АвансовыйОтчетСписокПлатежей.Ссылка.ФизЛицо КАК ФизЛицо,
	|	АвансовыйОтчетСписокПлатежей.НомерСтроки КАК НомерСтроки,
	|	АвансовыйОтчетСписокПлатежей.Субконто2,
	|	АвансовыйОтчетСписокПлатежей.Субконто2.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	АвансовыйОтчетСписокПлатежей.Количество,
	|	АвансовыйОтчетСписокПлатежей.Цена,
	|	АвансовыйОтчетСписокПлатежей.Сумма,
	|	АвансовыйОтчетСписокПлатежей.Ссылка КАК Ссылка,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА АвансовыйОтчетСписокПлатежей.Субконто2.Базовый
	|				ТОГДА ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная
	|			ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * АвансовыйОтчетСписокПлатежей.Субконто2.КоэффициентБазовых
	|		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК ПлановаяЦена,
	|	АвансовыйОтчетСписокПлатежей.Сумма - ЕСТЬNULL(ВЫРАЗИТЬ(ВЫБОР
	|				КОГДА АвансовыйОтчетСписокПлатежей.Субконто2.Базовый
	|					ТОГДА ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная
	|				ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * АвансовыйОтчетСписокПлатежей.Субконто2.КоэффициентБазовых
	|			КОНЕЦ КАК ЧИСЛО(15, 2)), 0) * АвансовыйОтчетСписокПлатежей.Количество КАК Отклонение
	|ИЗ
	|	Документ.АвансовыйОтчет.СписокПлатежей КАК АвансовыйОтчетСписокПлатежей
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних КАК ЦеныНоменклатурыСрезПоследних
	|		ПО АвансовыйОтчетСписокПлатежей.Ссылка.Подразделение.Регион = ЦеныНоменклатурыСрезПоследних.Регион
	|			И (ВЫБОР
	|				КОГДА АвансовыйОтчетСписокПлатежей.Субконто2.Базовый
	|					ТОГДА АвансовыйОтчетСписокПлатежей.Субконто2 = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|				ИНАЧЕ АвансовыйОтчетСписокПлатежей.Субконто2.БазоваяНоменклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|			КОНЕЦ)
	|			И (ЦеныНоменклатурыСрезПоследних.Период <= АвансовыйОтчетСписокПлатежей.Ссылка.Дата)
	|ГДЕ
	|	АвансовыйОтчетСписокПлатежей.Ссылка В(&Ссылка)
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
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСписокПлатежейШапка = Макет.ПолучитьОбласть("СписокПлатежейШапка");
	ОбластьСписокПлатежей = Макет.ПолучитьОбласть("СписокПлатежей");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	ИтогПлатежей = Макет.ПолучитьОбласть("ИтогПлатежей");
	
	ТабДок.Очистить();
	
	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ТабДок.Вывести(ОбластьЗаголовок);
		
		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());
		
		ТабДок.Вывести(ОбластьСписокПлатежейШапка);
		ВыборкаСписокПлатежей = Выборка.Выбрать();
		Пока ВыборкаСписокПлатежей.Следующий() Цикл
			ОбластьСписокПлатежей.Параметры.Заполнить(ВыборкаСписокПлатежей);
			ТабДок.Вывести(ОбластьСписокПлатежей, ВыборкаСписокПлатежей.Уровень());
		КонецЦикла;
		
		ИтогПлатежей.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(ИтогПлатежей);
		Подвал.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Подвал);
		
		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	
КонецПроцедуры
