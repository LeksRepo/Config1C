﻿
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПечатьАктНаСписание(ТабДок, Ссылка) Экспорт
	
	ФормСтрока = "Л=ru_RU";
	ПарПредмета="рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 0";
	
	Макет = Документы.СписаниеМатериалов.ПолучитьМакет("ПечатьАктСписание");

	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаТаблица = Макет.ПолучитьОбласть("ШапкаТаблица");
	ОбластьСтрокаТаблица = Макет.ПолучитьОбласть("СтрокаТаблица");
	Подписи = Макет.ПолучитьОбласть("Подписи");
	
	Для Каждого Док Из Ссылка Цикл
	
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Док);
		Запрос.УстановитьПараметр("Подразделение", Док.Подразделение);
		Запрос.УстановитьПараметр("НачалоПериода", Док.Дата+1);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СписаниеМатериалов.Ссылка КАК Ссылка,
		|	СписаниеМатериалов.Ссылка.Автор КАК Автор,
		|	СписаниеМатериалов.Ссылка.Дата КАК Дата,
		|	СписаниеМатериалов.Ссылка.Номер КАК Номер,
		|	СписаниеМатериалов.Ссылка.Подразделение КАК Подразделение,
		|	СписаниеМатериалов.Ссылка.Склад КАК Скдал,
		|	СписаниеМатериалов.Ссылка.СуммаДокумента КАК СуммаДокумента,
		|	СписаниеМатериалов.Ссылка.Склад.МОЛ КАК СкладМОЛ,
		|	СписаниеМатериалов.Ссылка.Комментарий КАК Комментарий,
		|	СписаниеМатериалов.НомерСтроки КАК НомерСтроки,
		|	СписаниеМатериалов.Номенклатура,
		|	СписаниеМатериалов.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	СписаниеМатериалов.Количество,
		|	СписаниеМатериалов.Описание,
		|	УправленческийОстатки.КоличествоОстаток КАК ОстатокНаСкладе
		|ИЗ
		|	Документ.СписаниеМатериалов.СписокНоменклатуры КАК СписаниеМатериалов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(&НачалоПериода, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе), , Подразделение = &Подразделение) КАК УправленческийОстатки
		|		ПО ((ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Справочник.Номенклатура)) = СписаниеМатериалов.Номенклатура)
		|ГДЕ
		|	СписаниеМатериалов.Ссылка В(&Ссылка)
		|	И СписаниеМатериалов.Ссылка.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|ИТОГИ
		|	МАКСИМУМ(Автор),
		|	МАКСИМУМ(Дата),
		|	МАКСИМУМ(Номер),
		|	МАКСИМУМ(Подразделение),
		|	МАКСИМУМ(Скдал),
		|	МАКСИМУМ(СуммаДокумента),
		|	МАКСИМУМ(СкладМОЛ),
		|	МАКСИМУМ(Комментарий)
		|ПО
		|	Ссылка";

		Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

		ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		
		Пока Выборка.Следующий() Цикл
			
			Шапка.Параметры.Заполнить(Выборка);
			Шапка.Параметры.Склад = Док.Склад;
			Шапка.Параметры.Дата = Формат(Док.Дата, "ДФ='dd.MM.yyyy H:mm:ss'");
			Шапка.Параметры.Комментарий = Док.Комментарий;
			Шапка.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(Док.Номер);
			
			ТабДок.Вывести(Шапка);
			ТабДок.Вывести(ОбластьШапкаТаблица);
			
			ВыборкаСписокНоменклатуры = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаСписокНоменклатуры.Следующий() Цикл
				ОбластьСтрокаТаблица.Параметры.Заполнить(ВыборкаСписокНоменклатуры);
				ТабДок.Вывести(ОбластьСтрокаТаблица, ВыборкаСписокНоменклатуры.Уровень());
			КонецЦикла;
			
			Подписи.Параметры.Заполнить(Выборка);
			Подписи.Параметры.Сумма = Строка(Выборка.СуммаДокумента) + "  ( " + ЧислоПрописью(Выборка.СуммаДокумента, ФормСтрока, ПарПредмета)+" )";
			Подписи.Параметры.ФизЛицоДиректор = ФизическиеЛицаКлиентСервер.ФамилияИнициалыФизЛица(Док.Подразделение.Руководитель);
			Подписи.Параметры.ФизЛицоУправляющий = ФизическиеЛицаКлиентСервер.ФамилияИнициалыФизЛица(Док.Подразделение.Управляющий);
			ТабДок.Вывести(Подписи);
			
			ВставлятьРазделительСтраниц = Истина;
			
		КонецЦикла;
	
	КонецЦикла;
	
КонецПроцедуры