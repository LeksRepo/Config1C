﻿
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

Функция ПечатьТребованиеНакладная(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета ="рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 0";
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПечатьНарядЗадания";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.КоличествоЭкземпляров = 2;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	ВидыСубконто = Новый Массив;
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура);
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивОбъектов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка КАК Ссылка,
	|	ТребованиеНакладнаяСписокНоменклатуры.НомерСтроки,
	|	ТребованиеНакладнаяСписокНоменклатуры.Затребовано,
	|	ТребованиеНакладнаяСписокНоменклатуры.Отпущено,
	|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура,
	|	ТребованиеНакладнаяСписокНоменклатуры.Содержание,
	|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.ЦеховаяЗона КАК ЦеховаяЗона,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Дата,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Номер,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Комментарий,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Склад,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Подразделение,
	|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Склад.МОЛ
	|ИЗ
	|	Документ.ТребованиеНакладная.СписокНоменклатуры КАК ТребованиеНакладнаяСписокНоменклатуры
	|ГДЕ
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка В(&МассивОбъектов)
	|ИТОГИ ПО
	|	Ссылка,
	|	ЦеховаяЗона";
	
	ВыборкаДокументы = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Макет = Документы.ТребованиеНакладная.ПолучитьМакет("ПечатьТребованиеНакладная");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСписокНоменклатурыШапка = Макет.ПолучитьОбласть("СписокНоменклатурыШапка");
	ОбластьСписокНоменклатуры = Макет.ПолучитьОбласть("СписокНоменклатуры");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	
	ВставлятьРазделительСтраниц = Ложь;
	
	Пока ВыборкаДокументы.Следующий() Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		ОбластьЗаголовок.Параметры.Номер = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(ВыборкаДокументы.Номер, "0");
		ОбластьЗаголовок.Параметры.Дата = Формат(ВыборкаДокументы.Дата, "ДЛФ=DD");
		ТабДок.Вывести(ОбластьЗаголовок);
		
		Шапка.Параметры.Заполнить(ВыборкаДокументы);
		ТабДок.Вывести(Шапка, ВыборкаДокументы.Уровень());
		
		ВыборкаЦеховаяЗона = ВыборкаДокументы.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаЦеховаяЗона.Следующий() Цикл
			
			ОбластьСписокНоменклатурыШапка.Параметры.Заполнить(ВыборкаЦеховаяЗона);
			ТабДок.Вывести(ОбластьСписокНоменклатурыШапка);
			
			ВыборкаСписокНоменклатуры = ВыборкаЦеховаяЗона.Выбрать();
			
			Пока ВыборкаСписокНоменклатуры.Следующий() Цикл
				
				ОбластьСписокНоменклатуры.Параметры.Заполнить(ВыборкаСписокНоменклатуры);
				ТабДок.Вывести(ОбластьСписокНоменклатуры, ВыборкаСписокНоменклатуры.Уровень());
				
			КонецЦикла;
			
		КонецЦикла;
		
		Подвал.Параметры.Заполнить(ВыборкаДокументы);
		
		ТабДок.Вывести(Подвал, ВыборкаДокументы.Уровень());
		
		ВставлятьРазделительСтраниц = Истина;
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументы.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьТребованиеНакладная") Тогда
		ПодготовитьПечатнуюФорму("ПечатьТребованиеНакладная", "Печать требования накладной", "Документ.ТребованиеНакладная.ПечатьТребованиеНакладная",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьРулонныйМатериал") Тогда
		ПодготовитьПечатнуюФорму("ПечатьРулонныйМатериал", "Печать рулонный материал", "Документ.ТребованиеНакладная.ПечатьРулонныйМатериал",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьХлыстовойМатериал") Тогда
		ПодготовитьПечатнуюФорму("ПечатьХлыстовойМатериал", "Печать хлыстовой материал", "Документ.ТребованиеНакладная.ПечатьХлыстовойМатериал",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьЛистовойМатериал") Тогда
		ПодготовитьПечатнуюФорму("ПечатьЛистовойМатериал", "Печать листовой материал", "Документ.ТребованиеНакладная.ПечатьЛистовойМатериал",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьШтучныйМатериал") Тогда
		ПодготовитьПечатнуюФорму("ПечатьШтучныйМатериал", "Печать штучный материал", "Документ.ТребованиеНакладная.ПечатьШтучныйМатериал",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета) Тогда
		
		Если ИмяМакета = "ПечатьТребованиеНакладная" Тогда
			ТабДок = ПечатьТребованиеНакладная(МассивОбъектов, ОбъектыПечати);
		КонецЕсли;
		
		Если ИмяМакета = "ПечатьРулонныйМатериал" Тогда
			ТабДок = ПечатьРулонныйМатериал(МассивОбъектов, ОбъектыПечати);
		КонецЕсли;
		
		Если ИмяМакета = "ПечатьХлыстовойМатериал" Тогда
			ТабДок = ПечатьХлыстовойМатериал(МассивОбъектов, ОбъектыПечати);
		КонецЕсли;
		
		Если ИмяМакета = "ПечатьЛистовойМатериал" Тогда
			ТабДок = ПечатьЛистовойМатериал(МассивОбъектов, ОбъектыПечати);
		КонецЕсли;
		
		Если ИмяМакета = "ПечатьШтучныйМатериал" Тогда
			ТабДок = ПечатьШтучныйМатериал(МассивОбъектов, ОбъектыПечати);
		КонецЕсли;
		
		// { Васильев Александр Леонидович [03.11.2017]
		// Это што за хрень?
		//ПФорма = КоллекцияПечатныхФорм.Найти(ИмяМакета, "ИмяМакета");
		//Если ЗначениеЗаполнено(ПФорма) И ТабДок.КоличествоЭкземпляров > 1 Тогда
		//	ПФорма.Экземпляров = ТабДок.КоличествоЭкземпляров;
		//КонецЕсли;
		// } Васильев Александр Леонидович [03.11.2017]
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета, ПредставлениеМакета, ТабДок,, ПолныйПутьКМакету);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьТаблицуМатериалов(НарядЗадание) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НарядЗадание", НарядЗадание);
	Запрос.УстановитьПараметр("Подразделение", НарядЗадание.Подразделение);
	Запрос.УстановитьПараметр("Период", НарядЗадание.МоментВремени());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НарядЗаданиеСписокСпецификаций.Спецификация КАК Спецификация
	|ПОМЕСТИТЬ втСпецификации
	|ИЗ
	|	Документ.НарядЗадание.СписокСпецификаций КАК НарядЗаданиеСписокСпецификаций
	|ГДЕ
	|	НарядЗаданиеСписокСпецификаций.Ссылка = &НарядЗадание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокНоменклатуры.Ссылка КАК Спецификация,
	|	СписокНоменклатуры.Номенклатура КАК Кромка,
	|	СУММА(СписокНоменклатуры.Количество) КАК Количество
	|ПОМЕСТИТЬ втКриволинейнаяКромка
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ втСпецификации КАК Спец
	|		ПО СписокНоменклатуры.Ссылка = Спец.Спецификация
	|ГДЕ
	|	СписокНоменклатуры.Ссылка В
	|			(ВЫБРАТЬ
	|				Спец.Спецификация
	|			ИЗ
	|				втСпецификации КАК Спец)
	|	И СписокНоменклатуры.КриволинейнаяКромка
	|
	|СГРУППИРОВАТЬ ПО
	|	СписокНоменклатуры.Ссылка,
	|	СписокНоменклатуры.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втКриволинейнаяКромка.Спецификация,
	|	втКриволинейнаяКромка.Кромка КАК Номенклатура,
	|	ВЫРАЗИТЬ(втКриволинейнаяКромка.Количество + 0.4999 КАК ЧИСЛО(15, 0)) КАК Количество
	|ПОМЕСТИТЬ втКривКромки
	|ИЗ
	|	втКриволинейнаяКромка КАК втКриволинейнаяКромка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокНоменклатуры.Количество КАК Затребовано,
	|	СписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СписокНоменклатуры.Спецификация КАК Спецификация,
	|	ЕСТЬNULL(КривКромки.Количество, 0) КАК КривКромкаКоличество
	|ИЗ
	|	Документ.НарядЗадание.СписокНоменклатурыПоСпецификациям КАК СписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ втКривКромки КАК КривКромки
	|		ПО (КривКромки.Спецификация = СписокНоменклатуры.Спецификация)
	|			И (КривКромки.Номенклатура = СписокНоменклатуры.Номенклатура)
	|ГДЕ
	|	СписокНоменклатуры.Ссылка = &НарядЗадание
	|	И СписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа.ВидМатериала = ЗНАЧЕНИЕ(Перечисление.ВидыМатериалов.Рулонный)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	СписокНоменклатуры.КоличествоТребуется,
	|	СписокНоменклатуры.Номенклатура,
	|	NULL,
	|	0
	|ИЗ
	|	Документ.НарядЗадание.СписокНоменклатуры КАК СписокНоменклатуры
	|ГДЕ
	|	СписокНоменклатуры.Ссылка = &НарядЗадание
	|	И СписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа.ВидМатериала <> ЗНАЧЕНИЕ(Перечисление.ВидыМатериалов.Листовой)
	|	И СписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа.ВидМатериала <> ЗНАЧЕНИЕ(Перечисление.ВидыМатериалов.Рулонный)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА НастройкиНоменклатуры.ОсновнаяПоСкладу ЕСТЬ NULL
	|				ИЛИ НастройкиНоменклатуры.ОсновнаяПоСкладу = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			ТОГДА ВЫБОР
	|					КОГДА НарядЗаданиеСписокЛистовНоменклатуры.Номенклатура.ШиринаБезТорцовки + НарядЗаданиеСписокЛистовНоменклатуры.Номенклатура.ДлинаБезТорцовки = 0
	|						ТОГДА НарядЗаданиеСписокЛистовНоменклатуры.Номенклатура.ШиринаДетали * НарядЗаданиеСписокЛистовНоменклатуры.Номенклатура.ДлинаДетали / 1000000 * НарядЗаданиеСписокЛистовНоменклатуры.Количество
	|					ИНАЧЕ НарядЗаданиеСписокЛистовНоменклатуры.Номенклатура.ШиринаБезТорцовки * НарядЗаданиеСписокЛистовНоменклатуры.Номенклатура.ДлинаБезТорцовки / 1000000 * НарядЗаданиеСписокЛистовНоменклатуры.Количество
	|				КОНЕЦ
	|		ИНАЧЕ НастройкиНоменклатуры.ОсновнаяПоСкладу.КоэффициентБазовых * НарядЗаданиеСписокЛистовНоменклатуры.Количество
	|	КОНЕЦ,
	|	НарядЗаданиеСписокЛистовНоменклатуры.Номенклатура,
	|	NULL,
	|	0
	|ИЗ
	|	Документ.НарядЗадание.СписокЛистовНоменклатуры КАК НарядЗаданиеСписокЛистовНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(&Период, Подразделение = &Подразделение) КАК НастройкиНоменклатуры
	|		ПО НарядЗаданиеСписокЛистовНоменклатуры.Номенклатура = НастройкиНоменклатуры.Номенклатура
	|ГДЕ
	|	НарядЗаданиеСписокЛистовНоменклатуры.Ссылка = &НарядЗадание
	|	И НарядЗаданиеСписокЛистовНоменклатуры.Номенклатура.НоменклатурнаяГруппа.ВидМатериала = ЗНАЧЕНИЕ(Перечисление.ВидыМатериалов.Листовой)";
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	ТЗ.Колонки.Добавить("Содержание", Новый ОписаниеТипов("Строка"));
	
	//RonEXI: Отделим криволинейные кромки в отдельные строки и подпишем неноменклатурный.
	
	Для Каждого Стр ИЗ ТЗ Цикл
		
		Если Стр.Номенклатура.Неноменклатурный И Найти(Стр.Содержание, "НЕНОМЕНКЛАТУРНЫЙ") = 0 Тогда
			
			Стр.Содержание = ?(ЗначениеЗаполнено(Стр.Содержание), Стр.Содержание + " ", "") + "НЕНОМЕНКЛАТУРНЫЙ"; 
			
		КонецЕсли;
		
		Если Стр.КривКромкаКоличество > 0 Тогда
			
			НоваяСтрока = ТЗ.Добавить();
			НоваяСтрока.Затребовано = Стр.КривКромкаКоличество;
			НоваяСтрока.Номенклатура = Стр.Номенклатура;
			НоваяСтрока.Спецификация = Стр.Спецификация;
			НоваяСтрока.КривКромкаКоличество = 0;
			НоваяСтрока.Содержание = "Криволинейка" + ?(ЗначениеЗаполнено(Стр.Содержание), " " + Стр.Содержание, "");
			
			Стр.Затребовано = Стр.Затребовано - Стр.КривКромкаКоличество;
			Стр.КривКромкаКоличество = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НарядЗаданиеРаскройХлыстов.Номенклатура,
	|	НарядЗаданиеРаскройХлыстов.НомерХлыста,
	|	НарядЗаданиеРаскройХлыстов.РазмерХлыста
	|ПОМЕСТИТЬ втХлысты
	|ИЗ
	|	Документ.НарядЗадание.РаскройХлыстов КАК НарядЗаданиеРаскройХлыстов
	|ГДЕ
	|	НарядЗаданиеРаскройХлыстов.Ссылка = &НарядЗадание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкиНоменклатуры.Номенклатура,
	|	НастройкиНоменклатуры.ОсновнаяПоСкладу
	|ПОМЕСТИТЬ втНомПодразделений
	|ИЗ
	|	РегистрСведений.НастройкиНоменклатуры.СрезПоследних(&Период, Подразделение = &Подразделение) КАК НастройкиНоменклатуры
	|ГДЕ
	|	НастройкиНоменклатуры.Номенклатура В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				т.Номенклатура
	|			ИЗ
	|				втХлысты КАК т)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втХлысты.Номенклатура КАК Номенклатура,
	|	втХлысты.НомерХлыста КАК НомерХлыста,
	|	втХлысты.РазмерХлыста КАК РазмерХлыста,
	|	втНомПодразделений.ОсновнаяПоСкладу КАК ОсновнаяПоСкладу,
	|	втНомПодразделений.ОсновнаяПоСкладу.КоэффициентБазовых * 1000 КАК РазмерЦелогоХлыста
	|ИЗ
	|	втХлысты КАК втХлысты
	|		ЛЕВОЕ СОЕДИНЕНИЕ втНомПодразделений КАК втНомПодразделений
	|		ПО втХлысты.Номенклатура = втНомПодразделений.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура";
	
	ВыборкаХлысты = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаХлысты.Следующий() Цикл
		
		Если ВыборкаХлысты.РазмерЦелогоХлыста = ВыборкаХлысты.РазмерХлыста Тогда
			
			Если ЗначениеЗаполнено(ВыборкаХлысты.ОсновнаяПоСкладу) Тогда
				НоваяСтрока = ТЗ.Добавить();
				НоваяСтрока.Номенклатура = ВыборкаХлысты.ОсновнаяПоСкладу;
				НоваяСтрока.Затребовано = 1;
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнена основная по складу, для номенклатуры " + ВыборкаХлысты.Номенклатура + ". Строка не добавлена.");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ТЗ.Свернуть("Номенклатура,Спецификация,Содержание", "Затребовано"); 
	
	Возврат ТЗ;
	
КонецФункции

Функция ПечатьШтучныйМатериал(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПечатьШтучныйМатериал";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = Документы.ТребованиеНакладная.ПолучитьМакет("ПечатьШтучныйМатериал");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
	ОбластьСтрокаПарковка = Макет.ПолучитьОбласть("СтрокаПарковка");
	ОбластьКомплектацииШапка = Макет.ПолучитьОбласть("КомплектацииШапка");
	ОбластьКомплектацииСтрока = Макет.ПолучитьОбласть("КомплектацииСтрока");
	
	ВставлятьРазделительСтраниц = Ложь;
	
	Для Каждого ТребованиеНакладная Из МассивОбъектов Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ЕстьШтучный = Ложь;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		Запрос = Новый Запрос;
		Запрос.Параметры.Вставить("ТребованиеНакладная", ТребованиеНакладная);
		Запрос.Параметры.Вставить("Подразделение", ТребованиеНакладная.Подразделение);
		Запрос.Параметры.Вставить("МоментВремени", ТребованиеНакладная.МоментВремени());
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТребованиеНакладнаяСписокНоменклатуры.НомерСтроки,
		|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура,
		|	ТребованиеНакладнаяСписокНоменклатуры.Затребовано,
		|	ТребованиеНакладнаяСписокНоменклатуры.Отпущено,
		|	ТребованиеНакладнаяСписокНоменклатуры.Содержание,
		|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	НастройкиНоменклатурыСрезПоследних.АдресХранения КАК АдресХранения,
		|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.Парковка КАК Парковка
		|ИЗ
		|	Документ.ТребованиеНакладная.СписокНоменклатуры КАК ТребованиеНакладнаяСписокНоменклатуры
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(&МоментВремени, Подразделение = &Подразделение) КАК НастройкиНоменклатурыСрезПоследних
		|		ПО (ТребованиеНакладнаяСписокНоменклатуры.Номенклатура = НастройкиНоменклатурыСрезПоследних.Номенклатура
		|				ИЛИ ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.БазоваяНоменклатура = НастройкиНоменклатурыСрезПоследних.Номенклатура)
		|ГДЕ
		|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка = &ТребованиеНакладная
		|	И ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа.ВидМатериала = ЗНАЧЕНИЕ(Перечисление.ВидыМатериалов.Штучный)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.Парковка,
		|	ТребованиеНакладнаяСписокНоменклатуры.НомерСтроки
		|ИТОГИ ПО
		|	Парковка";
		
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			
			ЕстьШтучный = Истина;
			
			ОбластьШапка.Параметры.Подразделение = ТребованиеНакладная.Подразделение; 
			ОбластьШапка.Параметры.Склад = ТребованиеНакладная.Склад; 
			ОбластьШапка.Параметры.Дата = Формат(ТребованиеНакладная.Дата, "ДЛФ=DD");
			ОбластьШапка.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ТребованиеНакладная.Номер);
			ТабДок.Вывести(ОбластьШапка);
			ТабДок.Вывести(ОбластьШапкаТаблицы);
			
			ВыборкаПарковка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаПарковка.Следующий() Цикл
				
				ОбластьСтрокаПарковка.Параметры.Заполнить(ВыборкаПарковка);
				ТабДок.Вывести(ОбластьСтрокаПарковка);
				
				ВыборкаСтрока = ВыборкаПарковка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока ВыборкаСтрока.Следующий() Цикл
					
					ОбластьСтрокаТаблицы.Параметры.Заполнить(ВыборкаСтрока);
					ТабДок.Вывести(ОбластьСтрокаТаблицы);
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТребованиеНакладная.НарядЗадание) Тогда 
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Спецификации", ТребованиеНакладная.НарядЗадание.СписокСпецификаций.ВыгрузитьКолонку("Спецификация"));
			Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	КОЛИЧЕСТВО(Склад.Номенклатура) КАК Количество,
			|	Склад.Ссылка КАК Спецификация
			|ИЗ
			|	Документ.Спецификация.СкладГотовойПродукции КАК Склад
			|ГДЕ
			|	Склад.Ссылка В(&Спецификации)
			|	И Склад.КоличествоЦех > 0
			|
			|СГРУППИРОВАТЬ ПО
			|	Склад.Ссылка
			|
			|УПОРЯДОЧИТЬ ПО
			|	Спецификация";
			
			Результат = Запрос.Выполнить();
			
			Если НЕ Результат.Пустой() Тогда
				
				Если НЕ ЕстьШтучный Тогда
					
					ОбластьШапка.Параметры.Подразделение = ТребованиеНакладная.Подразделение; 
					ОбластьШапка.Параметры.Склад = ТребованиеНакладная.Склад; 
					ОбластьШапка.Параметры.Дата = Формат(ТребованиеНакладная.Дата, "ДЛФ=DD");
					ОбластьШапка.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ТребованиеНакладная.Номер);
					ТабДок.Вывести(ОбластьШапка);
					
				КонецЕсли;
				
				ТабДок.Вывести(ОбластьКомплектацииШапка);
				
				Выборка = Результат.Выбрать();
				
				Пока Выборка.Следующий() Цикл
					
					ОбластьКомплектацииСтрока.Параметры.Заполнить(Выборка);
					ТабДок.Вывести(ОбластьКомплектацииСтрока);
					
				КонецЦикла;
				
				
			КонецЕсли;
			
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ТребованиеНакладная);
		ВставлятьРазделительСтраниц = Истина;
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьРулонныйМатериал(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПечатьРулонныйМатериал";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета ="рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 0";
	
	Макет = Документы.ТребованиеНакладная.ПолучитьМакет("ПечатьРулонныйМатериал");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	
	ОбластьНоменклатураШапка = Макет.ПолучитьОбласть("НоменклатураШапка");
	ОбластьНоменклатураСтрока = Макет.ПолучитьОбласть("НоменклатураСтрока");
	ОбластьСпецификацияСтрока = Макет.ПолучитьОбласть("СпецификацияСтрока");
	
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивТребования", МассивОбъектов);
	Запрос.Параметры.Вставить("Подразделение", МассивОбъектов[0].Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокНом.Ссылка КАК ТребованиеСсылка,
	|	СписокНом.Номенклатура КАК Номенклатура,
	|	СписокНом.Номенклатура.КраткоеНаименование КАК КраткоеНаименование,
	|	СписокНом.Затребовано КАК КоличествоТребуется,
	|	СписокНом.Отпущено КАК КоличествоОтпущено,
	|	СписокНом.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СписокНом.Спецификация КАК Спецификация,
	|	СписокНом.Спецификация.Номер КАК НомерСпецификации,
	|	СписокНом.Содержание КАК Содержание,
	|	НастройкиНоменклатуры.АдресХранения КАК АдресХранения,
	|	ВЫБОР
	|		КОГДА НЕ МатПодЗаказ.Комментарий ЕСТЬ NULL
	|			ТОГДА МатПодЗаказ.Комментарий
	|		ИНАЧЕ ЕСТЬNULL(МатЗаказчика.Комментарий, """")
	|	КОНЕЦ КАК КомментарийПодЗаказ,
	|	ВЫБОР
	|		КОГДА МатПодЗаказ.Номенклатура ЕСТЬ NULL
	|				И МатЗаказчика.Номенклатура ЕСТЬ NULL
	|			ТОГДА 0
	|		ИНАЧЕ ВЫБОР
	|				КОГДА НЕ МатПодЗаказ.Номенклатура ЕСТЬ NULL
	|					ТОГДА 1
	|				ИНАЧЕ 2
	|			КОНЕЦ
	|	КОНЕЦ КАК ВидПредоставления,
	|	СписокНом.Ссылка.Склад.МОЛ КАК СкладМОЛ
	|ИЗ
	|	Документ.ТребованиеНакладная.СписокНоменклатуры КАК СписокНом
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СписокМатериаловПодЗаказ КАК МатПодЗаказ
	|		ПО (МатПодЗаказ.Ссылка = СписокНом.Спецификация)
	|			И (МатПодЗаказ.Номенклатура = СписокНом.Номенклатура
	|				ИЛИ МатПодЗаказ.Номенклатура = СписокНом.Номенклатура.БазоваяНоменклатура)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СписокМатериаловЗаказчика КАК МатЗаказчика
	|		ПО (МатЗаказчика.Ссылка = СписокНом.Спецификация)
	|			И (МатЗаказчика.Номенклатура = СписокНом.Номенклатура
	|				ИЛИ МатЗаказчика.Номенклатура = СписокНом.Номенклатура.БазоваяНоменклатура)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(, Подразделение = &Подразделение) КАК НастройкиНоменклатуры
	|		ПО (СписокНом.Номенклатура = НастройкиНоменклатуры.Номенклатура
	|				ИЛИ СписокНом.Номенклатура.БазоваяНоменклатура = НастройкиНоменклатуры.Номенклатура)
	|ГДЕ
	|	СписокНом.Ссылка В(&МассивТребования)
	|	И СписокНом.Номенклатура.НоменклатурнаяГруппа.ВидМатериала = ЗНАЧЕНИЕ(Перечисление.ВидыМатериалов.Рулонный)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СписокНом.Спецификация.Номер,
	|	СписокНом.Номенклатура
	|ИТОГИ
	|	МАКСИМУМ(КоличествоТребуется),
	|	МАКСИМУМ(ЕдиницаИзмерения),
	|	МАКСИМУМ(НомерСпецификации),
	|	МАКСИМУМ(АдресХранения)
	|ПО
	|	ТребованиеСсылка,
	|	Спецификация";
	
	ВставлятьРазделительСтраниц = Ложь;
	ВыборкаДокументы = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаДокументы.Следующий() Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		ОбластьШапка.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаДокументы.ТребованиеСсылка.Номер);
		ОбластьШапка.Параметры.Дата = Формат(ВыборкаДокументы.ТребованиеСсылка.Дата, "ДЛФ=DD");
		
		ОбластьШапка.Параметры.Подразделение = ВыборкаДокументы.ТребованиеСсылка.Подразделение;
		ОбластьШапка.Параметры.Склад = ВыборкаДокументы.ТребованиеСсылка.Склад;
		
		ТабДок.Вывести(ОбластьШапка);
		ТабДок.Вывести(ОбластьНоменклатураШапка);
		
		ВыборкаСпецификация = ВыборкаДокументы.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаСпецификация.Следующий() Цикл
			
			ОбластьСпецификацияСтрока.Параметры.НомерСпецификации = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаСпецификация.НомерСпецификации);
			ТабДок.Вывести(ОбластьСпецификацияСтрока);
			
			ВыборкаНоменклатура = ВыборкаСпецификация.Выбрать();
			
			Пока ВыборкаНоменклатура.Следующий() Цикл
				
				ОбластьНоменклатураСтрока = Макет.ПолучитьОбласть("НоменклатураСтрока");
				
				ОбластьНоменклатураСтрока.Параметры.Заполнить(ВыборкаНоменклатура);
				ОбластьНоменклатураСтрока.Параметры.АдресХранения = ВыборкаНоменклатура.АдресХранения;
				
				ОбластьНоменклатураСтрока.Параметры.КраткоеНаименованиеТорцевойЛенты = ?(ЗначениеЗаполнено(ВыборкаНоменклатура.КомментарийПодЗаказ),"( " + ВыборкаНоменклатура.КомментарийПодЗаказ + " ) ", "") + ВыборкаНоменклатура.КраткоеНаименование;
				
				ОбластьНоменклатураСтрока.Параметры.Затребовано = Строка(ВыборкаНоменклатура.КоличествоТребуется) + " ";
				ОбластьНоменклатураСтрока.Параметры.Отпущено = Строка(ВыборкаНоменклатура.КоличествоОтпущено) + " ";
				
				ОбластьНоменклатураСтрока.Параметры.Содержание = ВыборкаНоменклатура.Содержание;
				
				Если ВыборкаНоменклатура.ВидПредоставления = 0 Тогда			
					ОбластьНоменклатураСтрока.Рисунки.Удалить(ОбластьНоменклатураСтрока.Рисунки.КартинкаПодЗаказ);
					ОбластьНоменклатураСтрока.Рисунки.Удалить(ОбластьНоменклатураСтрока.Рисунки.КартинкаПредоставляемый);	
				ИначеЕсли ВыборкаНоменклатура.ВидПредоставления = 1 Тогда
					ОбластьНоменклатураСтрока.Рисунки.Удалить(ОбластьНоменклатураСтрока.Рисунки.КартинкаПредоставляемый);
				Иначе
					ОбластьНоменклатураСтрока.Рисунки.Удалить(ОбластьНоменклатураСтрока.Рисунки.КартинкаПодЗаказ);
				КонецЕсли;
				
				ТабДок.Вывести(ОбластьНоменклатураСтрока);
				
			КонецЦикла; // ВыборкаНоменклатура.Следующий()
			
		КонецЦикла; // ВыборкаСпецификация.Следующий()
		
		ОбластьПодвал.Параметры.Заполнить(ВыборкаДокументы);
		
		ТабДок.Вывести(ОбластьПодвал);
		
		ВставлятьРазделительСтраниц = Истина;
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументы.ТребованиеСсылка);
		
	КонецЦикла; // ВыборкаДокументы.Следующий()
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьХлыстовойМатериал(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПечатьХлыстовойМатериал";
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = ПолучитьОбщийМакет("ПечатьХлыстовойМатериал");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	МассивНарядов = Новый Массив();
	
	Для Каждого Об ИЗ МассивОбъектов Цикл
		
		Если ЗначениеЗаполнено(Об.НарядЗадание) Тогда
			МассивНарядов.Добавить(Об.НарядЗадание);
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивНарядов", МассивНарядов);
	Запрос.Параметры.Вставить("Подразделение", МассивОбъектов[0].Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НарядЗаданиеРаскройХлыстов.Ссылка КАК Ссылка,
	|	НарядЗаданиеРаскройХлыстов.Ссылка.Номер КАК НомерНаряда,
	|	НарядЗаданиеРаскройХлыстов.Ссылка.Дата КАК ДатаНаряда,
	|	НарядЗаданиеРаскройХлыстов.Размер КАК РазмерОтрезка,
	|	НарядЗаданиеРаскройХлыстов.Номенклатура КАК Номенклатура,
	|	НарядЗаданиеРаскройХлыстов.Номенклатура.Кратность КАК Кратность,
	|	НарядЗаданиеРаскройХлыстов.Номенклатура.ДлинаДетали КАК ДлинаДетали,
	|	НарядЗаданиеРаскройХлыстов.НомерХлыста КАК НомерХлыста,
	|	НарядЗаданиеРаскройХлыстов.Остаток,
	|	НарядЗаданиеРаскройХлыстов.РазмерХлыста КАК РазмерХлыста,
	|	НастройкиНоменклатуры.АдресХранения КАК АдресХранения,
	|	ВЫБОР
	|		КОГДА НЕ МатПодЗаказ.Комментарий ЕСТЬ NULL
	|			ТОГДА МатПодЗаказ.Комментарий
	|		ИНАЧЕ ЕСТЬNULL(МатЗаказчика.Комментарий, """")
	|	КОНЕЦ КАК Комментарий
	|ИЗ
	|	Документ.НарядЗадание.РаскройХлыстов КАК НарядЗаданиеРаскройХлыстов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(, Подразделение = &Подразделение) КАК НастройкиНоменклатуры
	|		ПО (НарядЗаданиеРаскройХлыстов.Номенклатура = НастройкиНоменклатуры.Номенклатура
	|				ИЛИ НарядЗаданиеРаскройХлыстов.Номенклатура.БазоваяНоменклатура = НастройкиНоменклатуры.Номенклатура)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СписокМатериаловПодЗаказ КАК МатПодЗаказ
	|		ПО (МатПодЗаказ.Ссылка = НарядЗаданиеРаскройХлыстов.Спецификация)
	|			И (МатПодЗаказ.Номенклатура = НарядЗаданиеРаскройХлыстов.Номенклатура
	|				ИЛИ МатПодЗаказ.Номенклатура = НарядЗаданиеРаскройХлыстов.Номенклатура.БазоваяНоменклатура)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СписокМатериаловЗаказчика КАК МатЗаказчика
	|		ПО (МатЗаказчика.Ссылка = НарядЗаданиеРаскройХлыстов.Спецификация)
	|			И (МатЗаказчика.Номенклатура = НарядЗаданиеРаскройХлыстов.Номенклатура
	|				ИЛИ МатЗаказчика.Номенклатура = НарядЗаданиеРаскройХлыстов.Номенклатура.БазоваяНоменклатура)
	|ГДЕ
	|	НарядЗаданиеРаскройХлыстов.Ссылка В(&МассивНарядов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НарядЗаданиеРаскройХлыстов.Номенклатура.Цвет,
	|	НомерХлыста
	|ИТОГИ
	|	СУММА(РазмерОтрезка),
	|	МАКСИМУМ(РазмерХлыста),
	|	МАКСИМУМ(АдресХранения)
	|ПО
	|	Ссылка,
	|	Номенклатура,
	|	НомерХлыста";
	
	ВставлятьРазделительСтраниц = Ложь;
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДокументы = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаДокументы.Следующий() Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		ОбластьЗаголовок.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаДокументы.НомерНаряда);
		ОбластьЗаголовок.Параметры.ДатаДокумента = Формат(ВыборкаДокументы.ДатаНаряда, "ДЛФ=DD");
		ОбластьЗаголовок.Параметры.ЗаголовокДокумента = "Хлыстовой материал на наряд ";
		
		ТабДок.Вывести(ОбластьЗаголовок);
		ТабДок.Вывести(ОбластьШапка);
		
		ВыборкаНоменклатура = ВыборкаДокументы.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаНоменклатура.Следующий() Цикл
			
			ВыборкаХлысты = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаХлысты.Следующий() Цикл
				
				ОбластьСтрока.Параметры.Заполнить(ВыборкаХлысты);
				
				РазмерЗаготовки = ВыборкаХлысты.РазмерХлыста;
				Комментарий = "";
				
				ВыборкаСпецификации = ВыборкаХлысты.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока ВыборкаСпецификации.Следующий() Цикл
					
					Если ВыборкаСпецификации.Остаток Тогда
						РазмерЗаготовки = ВыборкаСпецификации.РазмерХлыста - ВыборкаСпецификации.РазмерОтрезка;
					Иначе
						Если ЗначениеЗаполнено(ВыборкаСпецификации.Комментарий) Тогда
							Комментарий = ВыборкаСпецификации.Комментарий
						КонецЕсли;
					КонецЕсли;
					
				КонецЦикла;
				
				ОбластьСтрока.Параметры.Комментарий = Комментарий;
				
				Если ВыборкаХлысты.РазмерХлыста < ВыборкаХлысты.ДлинаДетали Тогда
					ОбластьСтрока.Параметры.АдресХранения = "Обрезок";
				КонецЕсли;
				
				ОбластьСтрока.Параметры.РазмерЗаготовки = РазмерЗаготовки;
				
				Оприходовать = ВыборкаХлысты.РазмерХлыста - РазмерЗаготовки;
				
				Если Оприходовать > ВыборкаХлысты.Кратность * 1000 Тогда
					ОбластьСтрока.Параметры.Оприходовать = Оприходовать;
				Иначе
					ОбластьСтрока.Параметры.Оприходовать = "";
				КонецЕсли;
				
				ТабДок.Вывести(ОбластьСтрока);
				
			КонецЦикла;
			
		КонецЦикла;
		
		ТабДок.Вывести(ОбластьПодвал);
		
		ВставлятьРазделительСтраниц = Истина;
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументы.Ссылка);
		
	КонецЦикла; // ВыборкаДокументы.Следующий()
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьЛистовойМатериал(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПечатьЛистовойМатериал";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = Документы.ТребованиеНакладная.ПолучитьМакет("ПечатьЛистовойМатериал");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаТаблицыЛисты = Макет.ПолучитьОбласть("ШапкаТаблицыЛисты");
	ОбластьСтрокаТаблицыЛисты = Макет.ПолучитьОбласть("СтрокаТаблицыЛисты");
	ОбластьШапкаТаблицыОбрезки = Макет.ПолучитьОбласть("ШапкаТаблицыОбрезки");
	ОбластьСтрокаТаблицыОбрезки = Макет.ПолучитьОбласть("СтрокаТаблицыОбрезки");
	ОбластьСтрокаПарковка = Макет.ПолучитьОбласть("СтрокаПарковка");
	
	ВставлятьРазделительСтраниц = Ложь;
	
	Для Каждого ТребованиеНакладная Из МассивОбъектов Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		Запрос = Новый Запрос;
		Запрос.Параметры.Вставить("ТребованиеНакладная", ТребованиеНакладная);
		Запрос.Параметры.Вставить("Подразделение", ТребованиеНакладная.Подразделение);
		Запрос.Параметры.Вставить("Наряд", ТребованиеНакладная.НарядЗадание);
		Запрос.Параметры.Вставить("МоментВремени", ТребованиеНакладная.МоментВремени());
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Остатки.Номенклатура,
		|	Остатки.НомерСтроки КАК НомерСтроки,
		|	Остатки.ВысотаОстатка,
		|	Остатки.ШиринаОстатка
		|ПОМЕСТИТЬ втОбрезки
		|ИЗ
		|	Документ.НарядЗадание.ОстаткиЛистовогоМатериала КАК Остатки
		|ГДЕ
		|	Остатки.Ссылка = &Наряд
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втОбрезки.Номенклатура,
		|	СУММА(1) КАК КоличествоОбрезков
		|ПОМЕСТИТЬ втКоличествоОбрезков
		|ИЗ
		|	втОбрезки КАК втОбрезки
		|
		|СГРУППИРОВАТЬ ПО
		|	втОбрезки.Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТребованиеНакладнаяСписокНоменклатуры.НомерСтроки,
		|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура,
		|	ТребованиеНакладнаяСписокНоменклатуры.Затребовано,
		|	ТребованиеНакладнаяСписокНоменклатуры.Отпущено,
		|	ТребованиеНакладнаяСписокНоменклатуры.Содержание,
		|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	втКоличествоОбрезков.КоличествоОбрезков КАК КоличествоОбрезков,
		|	НастройкиНоменклатурыСрезПоследних.АдресХранения КАК АдресХранения,
		|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Номер,
		|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Дата,
		|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Склад,
		|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Подразделение,
		|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.Парковка КАК Парковка
		|ИЗ
		|	Документ.ТребованиеНакладная.СписокНоменклатуры КАК ТребованиеНакладнаяСписокНоменклатуры
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(&МоментВремени, Подразделение = &Подразделение) КАК НастройкиНоменклатурыСрезПоследних
		|		ПО (ТребованиеНакладнаяСписокНоменклатуры.Номенклатура = НастройкиНоменклатурыСрезПоследних.Номенклатура
		|				ИЛИ ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.БазоваяНоменклатура = НастройкиНоменклатурыСрезПоследних.Номенклатура)
		|		ЛЕВОЕ СОЕДИНЕНИЕ втКоличествоОбрезков КАК втКоличествоОбрезков
		|		ПО (ТребованиеНакладнаяСписокНоменклатуры.Номенклатура = втКоличествоОбрезков.Номенклатура
		|				ИЛИ ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.БазоваяНоменклатура = втКоличествоОбрезков.Номенклатура)
		|ГДЕ
		|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка = &ТребованиеНакладная
		|	И ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа.ВидМатериала = ЗНАЧЕНИЕ(Перечисление.ВидыМатериалов.Листовой)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.Парковка,
		|	ТребованиеНакладнаяСписокНоменклатуры.НомерСтроки
		|ИТОГИ ПО
		|	Парковка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втОбрезки.Номенклатура,
		|	втОбрезки.НомерСтроки,
		|	втОбрезки.ВысотаОстатка,
		|	втОбрезки.ШиринаОстатка
		|ИЗ
		|	втОбрезки КАК втОбрезки";
		
		Результат = Запрос.ВыполнитьПакет();
		РезультатТребование = Результат[2];
		РезультатНаряд = Результат[3];
		
		Если НЕ РезультатТребование.Пустой() Тогда
			
			ОбластьШапка.Параметры.Подразделение = ТребованиеНакладная.Подразделение; 
			ОбластьШапка.Параметры.Склад = ТребованиеНакладная.Склад; 
			ОбластьШапка.Параметры.Дата = Формат(ТребованиеНакладная.Дата, "ДЛФ=DD");
			ОбластьШапка.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ТребованиеНакладная.Номер);
			ТабДок.Вывести(ОбластьШапка);
			ТабДок.Вывести(ОбластьШапкаТаблицыЛисты);
			
			ВыборкаПарковка = РезультатТребование.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаПарковка.Следующий() Цикл
				
				ОбластьСтрокаПарковка.Параметры.Заполнить(ВыборкаПарковка);
				ТабДок.Вывести(ОбластьСтрокаПарковка);
				
				ВыборкаСтрока = ВыборкаПарковка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока ВыборкаСтрока.Следующий() Цикл
					
					ОбластьСтрокаТаблицыЛисты.Параметры.Заполнить(ВыборкаСтрока);
					ТабДок.Вывести(ОбластьСтрокаТаблицыЛисты);
					
				КонецЦикла;
				
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если НЕ РезультатНаряд.Пустой() Тогда
			
			ТабДок.Вывести(ОбластьШапкаТаблицыОбрезки);
			Выборка = РезультатНаряд.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				ОбластьСтрокаТаблицыОбрезки.Параметры.Заполнить(Выборка);
				ТабДок.Вывести(ОбластьСтрокаТаблицыОбрезки);
				
			КонецЦикла;
			
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ТребованиеНакладная);
		ВставлятьРазделительСтраниц = Истина;
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Функция СформироватьНомераСпецификаций(Ссылка)
	
	Результат = "";
	
	Для каждого Строка Из Ссылка.СписокСпецификаций Цикл
		
		Номер = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Строка.Спецификация, "Номер");
		Результат = Результат + ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Номер) + ", ";
		
	КонецЦикла;
	
	Если Результат <> "" Тогда
		Результат = Лев(Результат, СтрДлина(Результат) - 2) + "." ;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции