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
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Автор,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Дата,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Номер,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Комментарий,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.СуммаДокумента,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Склад,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Подразделение,
	|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения
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
		Подвал.Параметры.СуммаДокументаПрописью = ЧислоПрописью(ВыборкаДокументы.СуммаДокумента, ФормСтрока, ПарПредмета);
		
		ТабДок.Вывести(Подвал, ВыборкаДокументы.Уровень());
		
		//ВывестиКонтрольРасходаМатериалов(ТабДок, ВыборкаДокументы.Дата, ВыборкаДокументы.Подразделение);
		
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
   
		ПФорма = КоллекцияПечатныхФорм.Найти(ИмяМакета, "ИмяМакета");
		Если ЗначениеЗаполнено(ПФорма) И ТабДок.КоличествоЭкземпляров > 1 Тогда
			ПФорма.Экземпляров = ТабДок.КоличествоЭкземпляров; 	
		КонецЕсли;
		
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
	|ПОМЕСТИТЬ втНомСпецификации
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
	|	кКромки.Спецификация,
	|	кКромки.Кромка КАК Номенклатура,
	|	ВЫРАЗИТЬ(кКромки.Количество + 0.4999 КАК ЧИСЛО(15, 0)) КАК Количество
	|ПОМЕСТИТЬ втКривКромки
	|ИЗ
	|	втНомСпецификации КАК кКромки
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
	|   0
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
	|   0
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
	|	НарядЗаданиеРаскройХлыстов.Количество,
	|	НарядЗаданиеРаскройХлыстов.НомерХлыста,
	|	НарядЗаданиеРаскройХлыстов.Остаток,
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
	|			(ВЫБРАТЬ
	|				т.Номенклатура
	|			ИЗ
	|				втХлысты КАК т)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втХлысты.Номенклатура КАК Номенклатура,
	|	втХлысты.Количество КАК Количество,
	|	втХлысты.НомерХлыста КАК НомерХлыста,
	|	ВЫБОР
	|		КОГДА втХлысты.Остаток
	|			ТОГДА втХлысты.Количество
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РазмерОстатка,
	|	втХлысты.РазмерХлыста КАК РазмерХлыста,
	|	втНомПодразделений.ОсновнаяПоСкладу КАК ОсновнаяПоСкладу,
	|	втНомПодразделений.ОсновнаяПоСкладу.КоэффициентБазовых * 1000 КАК РазмерЦелогоХлыста
	|ИЗ
	|	втХлысты КАК втХлысты
	|		ЛЕВОЕ СОЕДИНЕНИЕ втНомПодразделений КАК втНомПодразделений
	|		ПО втХлысты.Номенклатура = втНомПодразделений.Номенклатура
	|ИТОГИ
	|	СУММА(Количество),
	|	МАКСИМУМ(РазмерОстатка),
	|	МАКСИМУМ(РазмерХлыста),
	|	МАКСИМУМ(ОсновнаяПоСкладу),
	|	МАКСИМУМ(РазмерЦелогоХлыста)
	|ПО
	|	Номенклатура,
	|	НомерХлыста";
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаНоменклатура = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаНоменклатура.Следующий() Цикл
		
		КоличествоЦелыхХлыстов = 0;
		
		ВыборкаХлысты = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаХлысты.Следующий() Цикл
			
			ИзОстатка = ВыборкаХлысты.РазмерЦелогоХлыста <> ВыборкаХлысты.РазмерХлыста;
			
			Если ВыборкаХлысты.РазмерОстатка > 0 ИЛИ ИзОстатка Тогда
				
				НоваяСтрока = ТЗ.Добавить();
				НоваяСтрока.Номенклатура = ВыборкаХлысты.Номенклатура;
				НоваяСтрока.Затребовано = (ВыборкаХлысты.Количество - ВыборкаХлысты.РазмерОстатка) / 1000;
				Если ИзОстатка Тогда
					Содержание = "Из остатка размером " + ВыборкаХлысты.РазмерХлыста;
				Иначе
					Содержание = "Хлыст № " + ВыборкаХлысты.НомерХлыста + " Оставить " + ВыборкаХлысты.РазмерОстатка;
				КонецЕсли;
				НоваяСтрока.Содержание = Содержание;
				
			Иначе
				
				КоличествоЦелыхХлыстов = КоличествоЦелыхХлыстов + 1;
				
			КонецЕсли;
			
		КонецЦикла; // ВыборкаХлысты.Следующий()
		
		Если КоличествоЦелыхХлыстов > 0 Тогда
			
			НоваяСтрока = ТЗ.Добавить();
			НоваяСтрока.Номенклатура = ВыборкаНоменклатура.ОсновнаяПоСкладу;
			НоваяСтрока.Затребовано = КоличествоЦелыхХлыстов;
			
		КонецЕсли;
		
	КонецЦикла; // ВыборкаНоменклатура
	
	Возврат ТЗ;
	
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
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
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
	|	КОНЕЦ КАК ВидПредоставления
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
		
		ОбластьЗаголовок.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаДокументы.ТребованиеСсылка.Номер);
		ОбластьЗаголовок.Параметры.Дата = Формат(ВыборкаДокументы.ТребованиеСсылка.Дата, "ДЛФ=DD");
		
		ТабДок.Вывести(ОбластьЗаголовок);
		
		ОбластьШапка.Параметры.Автор =  ВыборкаДокументы.ТребованиеСсылка.Автор;
		ОбластьШапка.Параметры.Комментарий =  ВыборкаДокументы.ТребованиеСсылка.Комментарий;
		ОбластьШапка.Параметры.Подразделение =  ВыборкаДокументы.ТребованиеСсылка.Подразделение;
		ОбластьШапка.Параметры.Склад =  ВыборкаДокументы.ТребованиеСсылка.Склад;
		ОбластьШапка.Параметры.СуммаДокумента =  ВыборкаДокументы.ТребованиеСсылка.СуммаДокумента;	
		
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
		
		ОбластьПодвал.Параметры.СуммаДокумента = ВыборкаДокументы.ТребованиеСсылка.СуммаДокумента;
		ОбластьПодвал.Параметры.СуммаДокументаПрописью = ЧислоПрописью(ВыборкаДокументы.ТребованиеСсылка.СуммаДокумента, ФормСтрока, ПарПредмета);
		ОбластьПодвал.Параметры.Автор = ВыборкаДокументы.ТребованиеСсылка.Автор;
		
		ТабДок.Вывести(ОбластьПодвал);

		ВставлятьРазделительСтраниц = Истина;
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументы.ТребованиеСсылка);
		
	КонецЦикла; // ВыборкаДокументы.Следующий()
	
	Возврат ТабДок;
	
КонецФункции