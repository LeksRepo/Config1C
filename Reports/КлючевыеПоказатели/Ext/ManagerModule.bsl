﻿
#Область Экспортные

Функция СформироватьОтчетЭкономика(НачалоПериода, КонецПериода, СписокПодразделений, ДанныеПродажи) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ФиксацияСверху = 2;
	ТабДок.ФиксацияСлева = 1;
	
	Макет = Отчеты.КлючевыеПоказатели.ПолучитьМакет("Макет");
	ОбластьШапкаПериод = Макет.ПолучитьОбласть("Шапка|Период");
	ОбластьШапкаКолонкаЗеленая = Макет.ПолучитьОбласть("Шапка|КолонкаЗеленая");
	ОбластьШапкаКолонкаКрасная = Макет.ПолучитьОбласть("Шапка|КолонкаКрасная");
	ОбластьШапкаКолонкаСиняя = Макет.ПолучитьОбласть("Шапка|КолонкаСиняя");
	ОбластьСтрокаПериод = Макет.ПолучитьОбласть("Строка|Период");
	ОбластьСтрокаКолонкаЗеленая = Макет.ПолучитьОбласть("Строка|КолонкаЗеленая");
	ОбластьСтрокаКолонкаКрасная = Макет.ПолучитьОбласть("Строка|КолонкаКрасная");
	ОбластьСтрокаКолонкаСиняя = Макет.ПолучитьОбласть("Строка|КолонкаСиняя");
	
	///////////////////////////////////////////////////////
	// заполнение колонки Продажи
		
	МассивКолонкаПродажи = ДанныеПродажи;
	СуммаПродажи = 0;
	
	Для Каждого Эл ИЗ МассивКолонкаПродажи Цикл
		
		СуммаПродажи = СуммаПродажи + Эл.Сумма;
		
	КонецЦикла;
	
	//__________________________________________________________________________________________________________________________
	// Данные по колонкам
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РазделыАналитики.Порядок КАК НомерКолонки,
	|	РазделыАналитики.Ссылка КАК Раздел,
	|	-СУММА(ЕСТЬNULL(УправленческийОбороты.СуммаОборотДт, 0)) КАК Расход,
	|	СУММА(ЕСТЬNULL(УправленческийОбороты.СуммаОборотКт, 0)) КАК Доход
	|ИЗ
	|	Справочник.РазделыАналитики КАК РазделыАналитики
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Обороты(
	|				&НачалоПериода,
	|				КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ),
	|				День,
	|				Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПрибыльУбытки)),
	|				,
	|				Подразделение В (&СписокПодразделений)
	|					И Субконто1 <> ЗНАЧЕНИЕ(Справочник.СтатьиДоходовРасходов.ЗакрытиеДоходовНаФинРезультат)
	|					И Субконто1 <> ЗНАЧЕНИЕ(Справочник.СтатьиДоходовРасходов.ЗакрытиеРасходовНаФинРезультат),
	|				,
	|				) КАК УправленческийОбороты
	|		ПО РазделыАналитики.Ссылка = УправленческийОбороты.Субконто1.РазделАналитики
	|
	|СГРУППИРОВАТЬ ПО
	|	РазделыАналитики.Порядок,
	|	РазделыАналитики.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	РазделыАналитики.Порядок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УправленческийОбороты.Период КАК Период,
	|	РазделыАналитики.Ссылка КАК Раздел,
	|	-ЕСТЬNULL(УправленческийОбороты.СуммаОборотДт, 0) КАК Расход,
	|	ЕСТЬNULL(УправленческийОбороты.СуммаОборотКт, 0) КАК Доход
	|ИЗ
	|	Справочник.РазделыАналитики КАК РазделыАналитики
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Обороты(&НачалоПериода, КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ), День, Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПрибыльУбытки)), , Подразделение В (&СписокПодразделений), , ) КАК УправленческийОбороты
	|		ПО РазделыАналитики.Ссылка = УправленческийОбороты.Субконто1.РазделАналитики
	|
	|УПОРЯДОЧИТЬ ПО
	|	РазделыАналитики.Порядок,
	|	Период
	|ИТОГИ
	|	МАКСИМУМ(Раздел),
	|	СУММА(Расход),
	|	СУММА(Доход)
	|ПО
	|	Период ПЕРИОДАМИ(ДЕНЬ, &НачалоПериода, &КонецПериода),
	|	РазделыАналитики.Ссылка.Наименование";
	
	ТабДок.Вывести(ОбластьШапкаПериод);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	// ШАПКА
	
	Выборка = РезультатЗапроса[0].Выбрать();
	
	ОбластьШапкаКолонкаСиняя.Параметры.Статья = "Продажи";
	ТабДок.Присоединить(ОбластьШапкаКолонкаСиняя);
	
	ОбластьШапкаКолонкаЗеленая.Параметры.Статья = "Доход";
	ТабДок.Присоединить(ОбластьШапкаКолонкаЗеленая);
	
	Пока Выборка.Следующий() Цикл
		
		ОбластьШапкаКолонкаЗеленая.Параметры.Статья = Выборка.Раздел;
		ОбластьШапкаКолонкаЗеленая.Параметры.Расшифровка = Новый Структура("Раздел, ВидРасшифровки", Выборка.Раздел, "Шапка");
		ТабДок.Присоединить(ОбластьШапкаКолонкаЗеленая);
		
	КонецЦикла;
	
	ОбластьШапкаКолонкаСиняя.Параметры.Статья = "Итог по строке";
	ОбластьШапкаКолонкаСиняя.Параметры.Расшифровка = Новый Структура("Раздел, ВидРасшифровки", Выборка.Раздел, "Шапка");
	ТабДок.Присоединить(ОбластьШапкаКолонкаСиняя);
	
	// ИТОГ ДОХОДЫ
	
	ОбластьСтрокаПериод.Параметры.Период = "Доход";
	ТабДок.Вывести(ОбластьСтрокаПериод);
	Выборка.Сбросить();
	
	ОбластьСтрокаКолонкаСиняя.Параметры.Сумма = "";
	ТабДок.Присоединить(ОбластьСтрокаКолонкаСиняя);
	
	ОбластьСтрокаКолонкаЗеленая.Параметры.Сумма = "";
	ТабДок.Присоединить(ОбластьСтрокаКолонкаЗеленая);
	
	СуммаИтогДоходы = 0;
	
	Пока Выборка.Следующий() Цикл
		
		ОбластьСтрокаКолонкаЗеленая.ТекущаяОбласть.Шрифт = Новый Шрифт(,, Истина);
		ОбластьСтрокаКолонкаЗеленая.Параметры.Сумма = Выборка.Доход;
		ТабДок.Присоединить(ОбластьСтрокаКолонкаЗеленая);
		
		СуммаИтогДоходы = СуммаИтогДоходы + Выборка.Доход;
		
	КонецЦикла;
	
	ОбластьСтрокаКолонкаСиняя.ТекущаяОбласть.Шрифт = Новый Шрифт(,, Истина);
	ОбластьСтрокаКолонкаСиняя.Параметры.Сумма = СуммаИтогДоходы;
	ТабДок.Присоединить(ОбластьСтрокаКолонкаСиняя);
	
	/////////////////////////////////////////////////////////////////////////////////
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ВыборкаПериод = РезультатЗапроса[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ПЕРИОД", "ВСЕ");
	СуммаДоход = 0;
	
	Пока ВыборкаПериод.Следующий() Цикл
		
		Если НЕ ЗначениеЗаполнено(ВыборкаПериод.Период) Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьСтрокаПериод.Параметры.Период = ВыборкаПериод.Период;
		ТабДок.Вывести(ОбластьСтрокаПериод);
		
		ОбластьСтрокаКолонкаСиняя.ТекущаяОбласть.Шрифт = Новый Шрифт(,, Ложь);
		
		Если МассивКолонкаПродажи[0].Минимум < 0 Тогда
			ОбластьСтрокаКолонкаСиняя.ТекущаяОбласть.ЦветТекста = ЦветаСтиля.ЦветОтрицательногоЧисла;
		Иначе
			ОбластьСтрокаКолонкаСиняя.ТекущаяОбласть.ЦветТекста = WebЦвета.Черный;
		КонецЕсли;
		
		ОбластьСтрокаКолонкаСиняя.Параметры.Сумма = МассивКолонкаПродажи[0].Сумма;
		ОбластьСтрокаКолонкаСиняя.Параметры.Расшифровка = Новый Структура("Раздел, ВидРасшифровки, Период, Статья", "Продажи", "ДР", ВыборкаПериод.Период, "Продажи");
		ТабДок.Присоединить(ОбластьСтрокаКолонкаСиняя);
		МассивКолонкаПродажи.Удалить(0);
		
		ОбластьСтрокаКолонкаЗеленая.ТекущаяОбласть.Шрифт = Новый Шрифт(,, Ложь);
		ОбластьСтрокаКолонкаЗеленая.Параметры.Сумма = ВыборкаПериод.Доход;
		ОбластьСтрокаКолонкаЗеленая.Параметры.Расшифровка = Новый Структура("Раздел, ВидРасшифровки, Период", "Доход", "День", ВыборкаПериод.Период);
		ТабДок.Присоединить(ОбластьСтрокаКолонкаЗеленая);
		
		ВыборкаРаздел = ВыборкаПериод.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Наименование", "ВСЕ");
		
		Пока ВыборкаРаздел.Следующий() Цикл
			
			Доход = 0;
			Если ЗначениеЗаполнено(ВыборкаРаздел.Доход) Тогда
				Доход = ВыборкаРаздел.Доход;
			КонецЕсли;
			
			СуммаДоход = СуммаДоход + Доход;
			
			ОбластьСтрокаКолонкаКрасная.Параметры.Сумма = ВыборкаРаздел.Расход;
			ОбластьСтрокаКолонкаКрасная.Параметры.Расшифровка = Новый Структура("Раздел, ВидРасшифровки, Период", ВыборкаРаздел.Раздел, "День", ВыборкаПериод.Период);
			ТабДок.Присоединить(ОбластьСтрокаКолонкаКрасная);
			
		КонецЦикла;
		
		ИтогДоход = 0;
		Если ЗначениеЗаполнено(ВыборкаПериод.Доход) Тогда
			ИтогДоход = ВыборкаПериод.Доход;
		КонецЕсли;
		
		ИтогРасход = 0;
		Если ЗначениеЗаполнено(ВыборкаПериод.Расход) Тогда
			ИтогРасход = ВыборкаПериод.Расход;
		КонецЕсли;
		
		ОбластьСтрокаКолонкаСиняя.Параметры.Сумма = ИтогДоход + ИтогРасход;
		ОбластьСтрокаКолонкаСиняя.Параметры.Расшифровка = Новый Структура("Раздел, ВидРасшифровки, Период", "Итог", "День", ВыборкаПериод.Период);
		ТабДок.Присоединить(ОбластьСтрокаКолонкаСиняя);
		
	КонецЦикла;
	
	// ИТОГИ
	
	ОбластьСтрокаПериод.Параметры.Период = "Итого:";
	ТабДок.Вывести(ОбластьСтрокаПериод);
	Выборка.Сбросить();
	
	ОбластьСтрокаКолонкаСиняя.ТекущаяОбласть.Шрифт = Новый Шрифт(,, Истина);
	ОбластьСтрокаКолонкаСиняя.Параметры.Сумма = СуммаПродажи;
	ТабДок.Присоединить(ОбластьСтрокаКолонкаСиняя);
	
	ОбластьСтрокаКолонкаЗеленая.ТекущаяОбласть.Шрифт = Новый Шрифт(,, Истина);
	ОбластьСтрокаКолонкаЗеленая.Параметры.Сумма = СуммаДоход;
	ТабДок.Присоединить(ОбластьСтрокаКолонкаЗеленая);
	
	СуммаРасход = 0;
	
	Пока Выборка.Следующий() Цикл
		
		ОбластьСтрокаКолонкаКрасная.ТекущаяОбласть.Шрифт = Новый Шрифт(,, Истина);
		ОбластьСтрокаКолонкаКрасная.Параметры.Сумма = Выборка.Расход;
		ТабДок.Присоединить(ОбластьСтрокаКолонкаКрасная);
		
		СуммаРасход = СуммаРасход + Выборка.Расход;
		
	КонецЦикла;
	
	ОбластьСтрокаКолонкаСиняя.ТекущаяОбласть.Шрифт = Новый Шрифт(,, Истина);
	ОбластьСтрокаКолонкаСиняя.Параметры.Сумма = СуммаРасход;
	ТабДок.Присоединить(ОбластьСтрокаКолонкаСиняя);
	
	// ПРИБЫЛЬ
	
	ОбластьСтрокаПериод.Параметры.Период = "Прибыль";
	ТабДок.Вывести(ОбластьСтрокаПериод);
	Выборка.Сбросить();
	
	ОбластьСтрокаКолонкаСиняя.Параметры.Сумма = "";
	ТабДок.Присоединить(ОбластьСтрокаКолонкаСиняя);
	
	ОбластьСтрокаКолонкаЗеленая.Параметры.Сумма = "";
	ТабДок.Присоединить(ОбластьСтрокаКолонкаЗеленая);
	
	СуммаПрибыль = 0;
	
	Пока Выборка.Следующий() Цикл
		
		ОбластьСтрокаКолонкаСиняя.ТекущаяОбласть.Шрифт = Новый Шрифт(,, Истина);
		ОбластьСтрокаКолонкаСиняя.Параметры.Сумма = Выборка.Доход + Выборка.Расход;
		ТабДок.Присоединить(ОбластьСтрокаКолонкаСиняя);
		
		СуммаПрибыль = СуммаПрибыль + (Выборка.Доход + Выборка.Расход);  
		
	КонецЦикла;
	
	ОбластьСтрокаКолонкаСиняя.ТекущаяОбласть.Шрифт = Новый Шрифт(,, Истина);
	ОбластьСтрокаКолонкаСиняя.Параметры.Сумма = СуммаПрибыль;
	ТабДок.Присоединить(ОбластьСтрокаКолонкаСиняя);
	
	// ПРОЦЕНТ
	
	ОбластьСтрокаПериод.Параметры.Период = "Процент";
	ТабДок.Вывести(ОбластьСтрокаПериод);
	Выборка.Сбросить();
	
	ОбластьСтрокаКолонкаСиняя.Параметры.Сумма = "";
	ТабДок.Присоединить(ОбластьСтрокаКолонкаСиняя);
	
	ОбластьСтрокаКолонкаЗеленая.Параметры.Сумма = "";
	ТабДок.Присоединить(ОбластьСтрокаКолонкаЗеленая);
	
	Пока Выборка.Следующий() Цикл
		
		Прибыль = Выборка.Доход + Выборка.Расход;
		Если Выборка.Доход <> 0 Тогда
			Процент = Окр(Прибыль / Выборка.Доход * 100, 2);
		Иначе
			Процент = 0;
		КонецЕсли;
		
		ОбластьСтрокаКолонкаСиняя.ТекущаяОбласть.ВыделятьОтрицательные = Истина;
		ОбластьСтрокаКолонкаСиняя.ТекущаяОбласть.Шрифт = Новый Шрифт(,, Истина);
		ОбластьСтрокаКолонкаСиняя.ТекущаяОбласть.Формат = "ЧДЦ = 2";
		ОбластьСтрокаКолонкаСиняя.Параметры.Сумма = Процент;
		ТабДок.Присоединить(ОбластьСтрокаКолонкаСиняя);
		
	КонецЦикла;
	
	ОбластьСтрокаКолонкаСиняя.Параметры.Сумма = "";
	ТабДок.Присоединить(ОбластьСтрокаКолонкаСиняя);
	
	Возврат ТабДок;
	
КонецФункции

Функция СформироватьОтчет(НачалоПериода, КонецПериода, СписокПодразделений, ВидОтчета, ДанныеПродажи) Экспорт
	
	Перем Область;
	Перем ТЗСтатьи;
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ФиксацияСверху = 1;
	ТабДок.ФиксацияСлева = 1;
	
	Макет = Отчеты.КлючевыеПоказатели.ПолучитьМакет("Макет");
	ОбластьШапкаПериод = Макет.ПолучитьОбласть("Шапка|Период");
	ОбластьШапкаКолонкаЗеленая = Макет.ПолучитьОбласть("Шапка|КолонкаЗеленая");
	ОбластьШапкаКолонкаКрасная = Макет.ПолучитьОбласть("Шапка|КолонкаКрасная");
	ОбластьШапкаКолонкаСиняя = Макет.ПолучитьОбласть("Шапка|КолонкаСиняя");
	ОбластьСтрокаПериод = Макет.ПолучитьОбласть("Строка|Период");
	ОбластьСтрокаКолонкаЗеленая = Макет.ПолучитьОбласть("Строка|КолонкаЗеленая");
	ОбластьСтрокаКолонкаКрасная = Макет.ПолучитьОбласть("Строка|КолонкаКрасная");
	ОбластьСтрокаКолонкаСиняя = Макет.ПолучитьОбласть("Строка|КолонкаСиняя");
	
	Таблица = ЗаполнитьТаблицуДанных(НачалоПериода, КонецПериода, СписокПодразделений, ВидОтчета, ТЗСтатьи, ДанныеПродажи);
//	ДатыДопУменьшение = ПолучитьДатыСОтрицательнымиДопСоглашениями(СписокПодразделений, НачалоПериода, КонецПериода);
	
	//////////////////////////////////////
	// ШАПКА
	ПерваяКолонка = Истина;
	Для каждого Колонка Из Таблица.Колонки Цикл
		
		Если ПерваяКолонка Тогда
			ТабДок.Вывести(ОбластьШапкаПериод);
			ПерваяКолонка = Ложь;
			Продолжить;
		КонецЕсли;
		
		Цвет = ОпределитьЦветКолонки(Колонка, ТЗСтатьи);
		Выполнить("Область = ОбластьШапкаКолонка" + Цвет);
		
		СтрокаСтатья = ТЗСтатьи.Найти(Колонка.Имя, "ИмяПредопределенного");
		Если СтрокаСтатья <> Неопределено Тогда
			Статья = СтрокаСтатья.Ссылка;
			Ссылка = СтрокаСтатья.Ссылка;
		Иначе
			Статья = Колонка.Имя;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Ссылка) Тогда
			Если ТипЗнч(Ссылка.ВидСтатьи) = Тип("ПеречислениеСсылка.ВидыСтатейДДС") Тогда
				ВидРасшифровки = "ШапкаДДС";
			ИначеЕсли ТипЗнч(Ссылка.ВидСтатьи) = Тип("ПеречислениеСсылка.ВидыСтатейДР") Тогда
				ВидРасшифровки = "ШапкаДР";
			КонецЕсли;
		КонецЕсли;
		
		Область.Параметры.Расшифровка = Новый Структура("Период, Статья, ВидРасшифровки", "Месяц", Статья, ВидРасшифровки);
		Область.Параметры.Статья = Колонка.Заголовок;
		ТабДок.Присоединить(Область);
		
		Ссылка = Неопределено;
		ВидРасшифровки = Неопределено;
		
	КонецЦикла;
	
	//////////////////////////////////////
	// СТРОКИ
	Для каждого Строка Из Таблица Цикл
		
		ОбластьСтрокаПериод.Параметры.Период = Строка.Период;
		ТабДок.Вывести(ОбластьСтрокаПериод);
		
		ПерваяКолонка = Истина;
		
		Для каждого Колонка Из Таблица.Колонки Цикл
			
			Если ПерваяКолонка Тогда
				ПерваяКолонка = Ложь;
				Продолжить;
			КонецЕсли;
			
			Цвет = ОпределитьЦветКолонки(Колонка, ТЗСтатьи);
			Выполнить("Область = ОбластьСтрокаКолонка" + Цвет);
			
			Если Строка.Период = "Итого" ИЛИ Найти(Строка.Период, "%") > 0 Тогда
				Область.ТекущаяОбласть.Шрифт = Новый Шрифт(,, Истина);
				ВидРасшифровки = "Итого";
			КонецЕсли;
			
			Если Найти(Строка.Период, "%") > 0 Тогда
				Область.ТекущаяОбласть.Формат = "ЧДЦ = 2";
				ВидРасшифровки = "ПроцентКЗеленым";
			КонецЕсли;
			
			СтрокаСтатья = ТЗСтатьи.Найти(Колонка.Имя, "ИмяПредопределенного");
			Если СтрокаСтатья <> Неопределено Тогда
				Статья = СтрокаСтатья.Ссылка;
				Если ТипЗнч(СтрокаСтатья.ВидСтатьи) = Тип("ПеречислениеСсылка.ВидыСтатейДДС") Тогда
					ВидРасшифровки = "ДДС";
				ИначеЕсли ТипЗнч(СтрокаСтатья.ВидСтатьи) = Тип("ПеречислениеСсылка.ВидыСтатейДР") Тогда
					ВидРасшифровки = "ДР";
				КонецЕсли;
			Иначе
				Статья = Колонка.Имя;
				ВидРасшифровки = "ДР";
			КонецЕсли;
			
			//Если Колонка.Имя = "Продажи" И ДатыДопУменьшение.Найти(Строка.Период) <> Неопределено Тогда
			//	Область.ТекущаяОбласть.ЦветТекста = ЦветаСтиля.ЦветОтрицательногоЧисла;
			//Иначе
			//	Область.ТекущаяОбласть.ЦветТекста = Новый Цвет(0, 0, 0);
			//КонецЕсли;
			
			Область.Параметры.Сумма = Строка[Колонка.Имя];
			Область.Параметры.Расшифровка = Новый Структура("Период, Статья, ВидРасшифровки", Строка.Период, Статья, ВидРасшифровки);
			ТабДок.Присоединить(Область);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

#КонецОбласти

#Область Вывод_данных

Функция ОпределитьЦветКолонки(Колонка, ТЗСтатьи)
	
	Строка = ТЗСтатьи.Найти(Колонка.Имя, "ИмяПредопределенного");
	Если Строка = Неопределено Тогда
		Цвет = "Синяя";
	Иначе
		Цвет = Строка.Цвет;
	КонецЕсли;
	
	Возврат Цвет;
	
КонецФункции

Функция ПолучитьДатыСОтрицательнымиДопСоглашениями(СписокПодразделений, НачалоПериода, КонецПериода)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДополнительноеСоглашение.Ссылка,
	|	ДополнительноеСоглашение.Договор,
	|	НАЧАЛОПЕРИОДА(ДополнительноеСоглашение.Дата, ДЕНЬ) КАК Дата
	|ИЗ
	|	Документ.ДополнительноеСоглашение КАК ДополнительноеСоглашение
	|ГДЕ
	|	ДополнительноеСоглашение.Договор.Подразделение В(&СписокПодразделений)
	|	И ДополнительноеСоглашение.Дата МЕЖДУ &НачалоПериода И КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ)
	|	И ДополнительноеСоглашение.Проведен
	|	И ДополнительноеСоглашение.СуммаДокумента < 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	Таблица = РезультатЗапроса.Выгрузить();
	Массив = Таблица.ВыгрузитьКолонку("Дата");
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти

#Область Получение_данных

Функция ЗаполнитьТаблицуДанных(НачалоПериода, КонецПериода, СписокПодразделений, ВидОтчета, тзГруппыСтатей, ДанныеПродажи)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ВидОтчета = "Касса" Тогда
		Счет = ПланыСчетов.Управленческий.ДенежныеСредства;
		СпрСтатьи = Справочники.СтатьиДвиженияДенежныхСредств;
	ИначеЕсли ВидОтчета = "Начисления" Тогда
		СпрСтатьи = Справочники.СтатьиДоходовРасходов;
		Счет = ПланыСчетов.Управленческий.ПрибыльУбытки;
	КонецЕсли;
	
	ВыборкаГруппы = ПолучитьВыборкуГрупп(ВидОтчета);
	
	Таблицы = ПолучитьТаблицыДанных(ВыборкаГруппы, СпрСтатьи);
	ТЗ = Таблицы.тзДанные;
	тзГруппыСтатей = Таблицы.тзГруппыСтатей;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ВидОтчета", ВидОтчета);
	ПараметрыОтчета.Вставить("НачалоПериода", НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода", КонецПериода);
	ПараметрыОтчета.Вставить("СписокПодразделений", СписокПодразделений);
	ПараметрыОтчета.Вставить("тзДанные", Таблицы.тзДанные);
	ПараметрыОтчета.Вставить("тзГруппыСтатей", Таблицы.тзГруппыСтатей);
	
	ЗаполнитьСтроки(ПараметрыОтчета, Счет, СпрСтатьи);
	
	//Продажи//////////////////////////////////////////////
	
	ИндП=0;
	
	Для каждого Строка Из ПараметрыОтчета.тзДанные Цикл
		Строка.Продажи = ДанныеПродажи[ИндП].Сумма;
		ИндП = ИндП + 1;
	КонецЦикла;
	
	///////////////////////////////////////////////////////
	
	ВсегоЗеленых = СформироватьИтогиПоКолонкам(ПараметрыОтчета);
	
	СформироватьПроцентКДоходам(ПараметрыОтчета, ВсегоЗеленых);
	
	Возврат ТЗ;
	
КонецФункции

Функция ЗаполнитьСтроки(ПараметрыОтчета, Счет, СпрСтатьи)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", ПараметрыОтчета.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", ПараметрыОтчета.КонецПериода);
	Запрос.УстановитьПараметр("СписокПодразделений", ПараметрыОтчета.СписокПодразделений);
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОбороты.Период КАК Период,
	|	ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Справочник.СтатьиДвиженияДенежныхСредств).Родитель КАК Статья,
	|	ЕСТЬNULL(УправленческийОбороты.СуммаОборот, 0) КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ),
	|			День,
	|			Счет В ИЕРАРХИИ (&Счет),
	|			,
	|			Подразделение В (&СписокПодразделений)
	|				И ВЫРАЗИТЬ(Субконто1 КАК Справочник.СтатьиДвиженияДенежныхСредств).МеждуСчетами = ЛОЖЬ
	|				И Субконто1 <> ЗНАЧЕНИЕ(Справочник.СтатьиДоходовРасходов.ЗакрытиеДоходовНаФинРезультат)
	|				И Субконто1 <> ЗНАЧЕНИЕ(Справочник.СтатьиДоходовРасходов.ЗакрытиеРасходовНаФинРезультат),
	|			,
	|			) КАК УправленческийОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	Период ПЕРИОДАМИ(ДЕНЬ, &НачалоПериода, &КонецПериода),
	|	Статья";
	
	Если ПараметрыОтчета.ВидОтчета = "Начисления" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Субконто1 КАК Справочник.СтатьиДвиженияДенежныхСредств)", "Субконто1 КАК Справочник.СтатьиДоходовРасходов)");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "УправленческийОбороты.СуммаОборот", "-УправленческийОбороты.СуммаОборот");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	// заполнение строк
	
	ВыборкаПериод = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ПЕРИОД", "ВСЕ");
	Пока ВыборкаПериод.Следующий() Цикл
		
		ИтогПоСтроке = 0;
		
		НоваяСтрока = ПараметрыОтчета.тзДанные.Добавить();
		НоваяСтрока.Период =ВыборкаПериод.Период;
		ВыборкаСтатья = ВыборкаПериод.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "СТАТЬЯ", "ВСЕ");
		Пока ВыборкаСтатья.Следующий() Цикл
			
			ИмяПоля = СпрСтатьи.ПолучитьИмяПредопределенного(ВыборкаСтатья.Статья);
			НоваяСтрока[ИмяПоля] = ВыборкаСтатья.Сумма;
			
			Если ЗначениеЗаполнено(ВыборкаСтатья.Сумма) Тогда
				ИтогПоСтроке = ИтогПоСтроке + ВыборкаСтатья.Сумма;
			КонецЕсли;
			
		КонецЦикла;
		
		НоваяСтрока.Итог = ИтогПоСтроке;
		
	КонецЦикла;
	
КонецФункции

Функция ЗаполнитьПродажи(НачалоПериода, КонецПериода, СписокПодразделений) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Доки.Сумма КАК Сумма,
	|	Доки.Сумма КАК Мин,
	|	НАЧАЛОПЕРИОДА(Доки.Дата, ДЕНЬ) КАК Период
	|ИЗ
	|	(ВЫБРАТЬ
	|		УправленческийОбороты.СуммаОборот КАК Сумма,
	|		УправленческийОбороты.Период КАК Дата
	|	ИЗ
	|		РегистрБухгалтерии.Управленческий.Обороты(
	|				&НачалоПериода,
	|				&КонецПериода,
	|				Регистратор,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|				,
	|				Подразделение В (&СписокПодразделений)
	|					И Субконто1 = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.СтоимостьЗаключенныхДоговоров),
	|				,
	|				) КАК УправленческийОбороты
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Спецификация.СуммаДокумента,
	|		Спецификация.Дата
	|	ИЗ
	|		Документ.Спецификация КАК Спецификация
	|	ГДЕ
	|		Спецификация.Проведен
	|		И Спецификация.Изделие = ЗНАЧЕНИЕ(Справочник.Изделия.Детали)
	|		И Спецификация.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|		И Спецификация.Подразделение В(&СписокПодразделений)) КАК Доки
	|УПОРЯДОЧИТЬ ПО
	|	Период
	|ИТОГИ
	|	СУММА(Сумма),
	|	МИНИМУМ(Мин)
	|ПО
	|	Период ПЕРИОДАМИ(ДЕНЬ, &НачалоПериода, &КонецПериода)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ПЕРИОД", "ВСЕ");
	
	МассивКолонкаПродажи = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		Стр = Новый Структура;
		
		ВСумма = 0;
		
		Если ЗначениеЗаполнено(Выборка.Сумма) Тогда
			ВСумма = Окр(Выборка.Сумма);
			Стр.Вставить("Минимум", Выборка.Мин);
			Стр.Вставить("Сумма", ВСумма);
		Иначе
			Стр.Вставить("Минимум", 0);
			Стр.Вставить("Сумма", 0);
		КонецЕсли;
		
		МассивКолонкаПродажи.Добавить(Стр);
		
	КонецЦикла;
	
	Возврат МассивКолонкаПродажи;
	
КонецФункции

Функция ПолучитьТаблицыДанных(Выборка, СпрСтатьи)
	
	тзГруппыСтатей = Новый ТаблицаЗначений;
	тзГруппыСтатей.Колонки.Добавить("Ссылка");
	тзГруппыСтатей.Колонки.Добавить("ВидСтатьи");
	тзГруппыСтатей.Колонки.Добавить("ИмяПредопределенного");
	тзГруппыСтатей.Колонки.Добавить("Цвет");
	
	тзДанные = Новый ТаблицаЗначений;
	тзДанные.Колонки.Добавить("Период",, "Период");
	тзДанные.Колонки.Добавить("Продажи",, "Продажи");
	
	Пока Выборка.Следующий() Цикл
		
		ИмяПредопределенного = СпрСтатьи.ПолучитьИмяПредопределенного(Выборка.Ссылка);
		
		НоваяСтрока = тзГруппыСтатей.Добавить();
		НоваяСтрока.Ссылка = Выборка.Ссылка;
		НоваяСтрока.ВидСтатьи = Выборка.ВидСтатьи;
		НоваяСтрока.ИмяПредопределенного = ИмяПредопределенного;
		НоваяСтрока.Цвет = Выборка.Цвет;
		
		тзДанные.Колонки.Добавить(ИмяПредопределенного,, Выборка.Наименование);
		
	КонецЦикла;
	
	тзДанные.Колонки.Добавить("Итог",,"Итог");
	
	Результат = Новый Структура;
	Результат.Вставить("тзДанные", тзДанные);
	Результат.Вставить("тзГруппыСтатей", тзГруппыСтатей);
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьВыборкуГрупп(ВидОтчета)
	
	ЗапросГруппы= Новый Запрос;
	ЗапросГруппы.Текст =
	"ВЫБРАТЬ
	|	Статьи.Ссылка,
	|	Статьи.ВидСтатьи,
	|	Статьи.Наименование,
	|	ВЫБОР
	|		КОГДА Статьи.ВидСтатьи = ЗНАЧЕНИЕ(Перечисление.ВидыСтатейДДС.Выплата)
	|				ИЛИ Статьи.ВидСтатьи = ЗНАЧЕНИЕ(Перечисление.ВидыСтатейДР.Расход)
	|			ТОГДА ""Красная""
	|		ИНАЧЕ ""Зеленая""
	|	КОНЕЦ КАК Цвет
	|ИЗ
	|	Справочник.СтатьиДвиженияДенежныхСредств КАК Статьи
	|ГДЕ
	|	Статьи.ЭтоГруппа
	|	И НЕ Статьи.МеждуСчетами
	|	И Статьи.Предопределенный
	|
	|УПОРЯДОЧИТЬ ПО
	|	Статьи.НомерКолонки";
	
	Если ВидОтчета = "Начисления" Тогда
		ЗапросГруппы.Текст = СтрЗаменить(ЗапросГруппы.Текст, "Справочник.СтатьиДвиженияДенежныхСредств", "Справочник.СтатьиДоходовРасходов");
	КонецЕсли;
	
	Результат = ЗапросГруппы.Выполнить();
	
	Возврат Результат.Выбрать();
	
КонецФункции

Функция СформироватьИтогиПоКолонкам(ПараметрыОтчета)
	
	Результат = 0;
	
	СтрокаИтоги = ПараметрыОтчета.тзДанные.Добавить();
	Для каждого Колонка ИЗ ПараметрыОтчета.тзДанные.Колонки Цикл
		
		Сумма = ПараметрыОтчета.тзДанные.Итог(Колонка.Имя);
		СтрокаИтоги[Колонка.Имя] = Сумма;
		
		Строка = ПараметрыОтчета.тзГруппыСтатей.Найти(Колонка.Имя, "ИмяПредопределенного");
		
		Если Строка <> Неопределено 
			И (Строка.ВидСтатьи = Перечисления.ВидыСтатейДДС.Поступление ИЛИ Строка.ВидСтатьи = Перечисления.ВидыСтатейДР.Доход) Тогда
			Результат = Результат + Сумма;
		КонецЕсли;
		
	КонецЦикла;
	
	СтрокаИтоги.Период = "Итого";
	
	
	Возврат Результат;
	
КонецФункции

Функция СформироватьПроцентКДоходам(ПараметрыОтчета, ИтогДоход)
	
	СтрокаПроцент = ПараметрыОтчета.тзДанные.Добавить();
	Для каждого Колонка Из ПараметрыОтчета.тзДанные.Колонки Цикл
		
		Если ИтогДоход <> 0 Тогда
			Сумма = ПараметрыОтчета.тзДанные.Итог(Колонка.Имя) / 2 / ИтогДоход * 100;
		Иначе
			Сумма = 0;
		КонецЕсли;
		
		Сумма = ?(Сумма > 0, Сумма, - Сумма);
		СтрокаПроцент[Колонка.Имя] = Сумма;
	КонецЦикла;
	СтрокаПроцент.Период = "% к зеленым";
	
КонецФункции

#КонецОбласти