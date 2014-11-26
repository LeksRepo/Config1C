﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры

//Функция ПечатьИНВ3() Экспорт
//	
//	ТабДок = Новый ТабличныйДокумент;
//	
//	Запрос = Новый Запрос;
//	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
//	
//	Запрос.Текст = 
//	"ВЫБРАТЬ
//	|ИнвентаризацияМатериаловНаСкладе.Организация.ПолноеНаименование КАК ПредставлениеОрганизации,
//	|ИнвентаризацияМатериаловНаСкладе.Номер КАК НомерДокумента,
//	|ИнвентаризацияМатериаловНаСкладе.Дата КАК ДатаДокумента,
//	|ИнвентаризацияМатериаловНаСкладе.МОЛ КАК ФИОМОЛ1
//	|ИЗ
//	|Документ.ИнвентаризацияМатериаловНаСкладе КАК ИнвентаризацияМатериаловНаСкладе
//	|ГДЕ
//	|ИнвентаризацияМатериаловНаСкладе.Ссылка = &ТекущийДокумент";
//	Шапка = Запрос.Выполнить().Выбрать();
//	Шапка.Следующий();
//	Макет = ПолучитьОбщийМакет("ИНВ3");
//	
//	//выводим шапку
//	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
//	ОбластьМакета.Параметры.Заполнить(Шапка);
//	ОбластьМакета.Параметры.ДатаСнятияОстатков = Формат(Шапка.ДатаДокумента, "ДЛФ=ДД");
//	ТабДок.Вывести(ОбластьМакета);
//	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
//	
//	ЗапросПоТоварам = Новый Запрос;
//	ЗапросПоТоварам.УстановитьПараметр("ТекущийДокумент",ЭтотОбъект.Ссылка);
//	ЗапросПоТоварам.Текст =
//	"ВЫБРАТЬ
//	|ИнвентаризацияМатериаловНаСкладеТовары.НомерСтроки КАК Номер,
//	|ИнвентаризацияМатериаловНаСкладеТовары.Наименование КАК ТоварНаименование,
//	|ИнвентаризацияМатериаловНаСкладеТовары.Наименование.Код КАК ТоварКод,
//	|ИнвентаризацияМатериаловНаСкладеТовары.Наименование.ДополнительнаяЕдиницаИзмерения.ЕдиницаПоКлассификатору КАК ЕдиницаИзмеренияКодПоОКЕИ,
//	|ИнвентаризацияМатериаловНаСкладеТовары.Наименование.ДополнительнаяЕдиницаИзмерения.НаименованиеПолное КАК ЕдиницаИзмеренияНаименование,
//	|ИнвентаризацияМатериаловНаСкладеТовары.Цена КАК Цена,
//	|ИнвентаризацияМатериаловНаСкладеТовары.КоличествоНаСкладе КАК ФактКоличество,
//	|ИНвентаризацияМатериаловНаСкладеТовары.СуммаФакт КАК ФактСумма,
//	|ИнвентаризацияМатериаловНаСкладеТовары.КоличествоПоУчету КАК БухКоличество,
//	|ИнвентаризацияМатериаловНаСкладеТовары.СуммаУчет КАК БухСумма
//	|ИЗ
//	|Документ.ИнвентаризацияМатериаловНаСкладе.Материалы КАК ИнвентаризацияМатериаловНаСкладеТовары
//	|ГДЕ
//	|ИнвентаризацияМатериаловНаСкладеТовары.Ссылка = &ТекущийДокумент";
//	
//	Выборка = ЗапросПоТоварам.Выполнить().Выгрузить();
//	Выборка.Сортировать("Номер Возр",);
//	
//	//выводим заголовок таблицы
//	ОбластьЗаголовка = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
//	Если Выборка.Количество() > 15 Тогда 
//		СтраницаНомер = 1;
//		ОбластьЗаголовка.Параметры.НомерСтраницы = СтраницаНомер;
//	Иначе
//		СтраницаНомер = 0;
//	КонецЕсли;
//	ТабДок.Вывести(ОбластьЗаголовка);
//	
//	//Выводим строки таблицы товаров
//	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
//	
//	ИтогоФактКоличество = 0;
//	ИтогоФактСумма = 0;
//	ИтогоБухКоличество = 0;
//	ИтогоБухСумма = 0;
//	
//	//выводим подвал страницы
//	ОбластьПодвала = Макет.ПолучитьОбласть("ПодвалСтраницы");
//	
//	Параметр = "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
//	ПараметрКол="шт,шт,шт,м,,,,ж,2";
//	Для Каждого Строка Из Выборка Цикл
//		ОбластьМакета.Параметры.Заполнить(Строка);
//		Если (Строка.Номер - 15*(СтраницаНомер-1)) > 15 Тогда 
//			ОбластьЗаголовка.Параметры.НомерСтраницы = СтраницаНомер+1;
//			ОбластьПодвала.Параметры.ИтогоФактКоличество = ИтогоФактКоличество;
//			ОбластьПодвала.Параметры.ИтогоФактСумма = ИтогоФактСумма;
//			ОбластьПодвала.Параметры.ИтогоБухКоличество = ИтогоБухКоличество;
//			ОбластьПодвала.Параметры.ИтогоБухСумма = ИтогоБухСумма;
//			ОбластьПодвала.Параметры.ОбщееКоличествоЕдиницФактическиНаСтраницеПрописью = ЧислоПрописью(ИтогоФактКоличество,,ПараметрКол);
//			ОбластьПодвала.Параметры.СуммаФактическиНаСтраницеПрописью = ЧислоПрописью(ИтогоФактСумма,,Параметр);
//			ТабДок.Вывести(ОбластьПодвала);
//			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
//			ТабДок.Вывести(ОбластьЗаголовка);
//			СтраницаНомер = СтраницаНомер + 1;
//			ИтогоФактКоличество = 0;
//			ИтогоФактСумма = 0;
//			ИтогоБухКоличество = 0;
//			ИтогоБухСумма = 0;
//		КонецЕсли;
//		
//		ТабДок.Вывести(ОбластьМакета);
//		ИтогоФактКоличество = ИтогоФактКоличество + Строка.ФактКоличество;
//		ИтогоФактСумма = ИтогоФактСумма + Строка.ФактСумма;
//		ИтогоБухКоличество = ИтогоБухКоличество + Строка.БухКоличество;
//		ИтогоБухСумма = ИтогоБухСумма + Строка.БухСумма;
//	КонецЦикла;
//	
//	ОбластьПодвала.Параметры.ИтогоФактКоличество = ИтогоФактКоличество;
//	ОбластьПодвала.Параметры.ИтогоФактСумма = ИтогоФактСумма;
//	ОбластьПодвала.Параметры.ИтогоБухКоличество = ИтогоБухКоличество;
//	ОбластьПодвала.Параметры.ИтогоБухСумма = ИтогоБухСумма;
//	ОбластьПодвала.Параметры.ОбщееКоличествоЕдиницФактическиНаСтраницеПрописью = ЧислоПрописью(ИтогоФактКоличество,,ПараметрКол);
//	ОбластьПодвала.Параметры.СуммаФактическиНаСтраницеПрописью = ЧислоПрописью(ИтогоФактСумма,,Параметр);
//	ТабДок.Вывести(ОбластьПодвала);
//	
//	ФактКоличествоПоДокументу = Выборка.Итог("ФактКоличество");
//	ФактСуммаПоДокументу = Выборка.Итог("ФактСумма");
//	
//	//Выводим итоги по документу
//	ОбластьМакета = Макет.ПолучитьОбласть("ПодвалОписи");
//	ОбластьМакета.Параметры.Заполнить(Шапка);
//	ОбластьМакета.Параметры.ОбщееКоличествоЕдиницФактическиНаСтраницеПрописью = ЧислоПрописью(ФактКоличествоПоДокументу,,);
//	ОбластьМакета.Параметры.СуммаФактическиНаСтраницеПрописью = ЧислоПрописью(ФактСуммаПоДокументу,,Параметр);
//	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
//	ТабДок.Вывести(ОбластьМакета);
//	
//	
//	Возврат ТабДок;
//	
//КонецФункции

//Функция ПечатьИнвентаризация() Экспорт
//	
//	ТабДок = Новый ТабличныйДокумент;
//	
//	Запрос = Новый Запрос;
//	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
//	
//	Запрос.Текст = 
//	"ВЫБРАТЬ
//	|ИнвентаризацияМатериаловНаСкладе.Организация.ПолноеНаименование КАК ПредставлениеОрганизации,
//	|ИнвентаризацияМатериаловНаСкладе.Номер КАК НомерДокумента,
//	|ИнвентаризацияМатериаловНаСкладе.Дата КАК ДатаДокумента,
//	|ИнвентаризацияМатериаловНаСкладе.МОЛ КАК ФИОМОЛ1,
//	|ИнвентаризацияМатериаловНаСкладе.Склад КАК ПредставлениеСклада
//	|ИЗ
//	|Документ.ИнвентаризацияМатериаловНаСкладе КАК ИнвентаризацияМатериаловНаСкладе
//	|ГДЕ
//	|ИнвентаризацияМатериаловНаСкладе.Ссылка = &ТекущийДокумент";
//	Шапка = Запрос.Выполнить().Выбрать();
//	Шапка.Следующий();
//	Макет = ПолучитьМакет("Инвентаризация");
//	
//	//выводим заголовок
//	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
//	ОбластьМакета.Параметры.ТекстЗаголовка ="Инвентаризация товаров на складе № "+ Шапка.НомерДокумента + Формат(Шапка.ДатаДокумента, "ДЛФ=ДД");
//	ТабДок.Вывести(ОбластьМакета);
//	
//	//выводим информацию о поставщике
//	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
//	ОбластьМакета.Параметры.Заполнить(Шапка);
//	ТабДок.Вывести(ОбластьМакета);
//	
//	//выводим шапку таблицы
//	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
//	ТабДок.Вывести(ОбластьМакета);
//	
//	ЗапросПоТоварам = Новый Запрос;
//	ЗапросПоТоварам.УстановитьПараметр("ТекущийДокумент",ЭтотОбъект.Ссылка);
//	ЗапросПоТоварам.Текст =
//	"ВЫБРАТЬ
//	|ИнвентаризацияМатериаловНаСкладеТовары.НомерСтроки КАК НомерСтроки,
//	|ИнвентаризацияМатериаловНаСкладеТовары.Наименование КАК Товар,
//	|ИнвентаризацияМатериаловНаСкладеТовары.Наименование.ДополнительнаяЕдиницаИзмерения.ЕдиницаПоКлассификатору КАК ЕдиницаИзмерения,
//	|ИнвентаризацияМатериаловНаСкладеТовары.Цена КАК Цена,
//	|ИнвентаризацияМатериаловНаСкладеТовары.КоличествоНаСкладе КАК Количество,
//	|ИНвентаризацияМатериаловНаСкладеТовары.СуммаФакт КАК Сумма,
//	|ИнвентаризацияМатериаловНаСкладеТовары.КоличествоПоУчету КАК КоличествоПоУчету,
//	|ИнвентаризацияМатериаловНаСкладеТовары.СуммаУчет КАК СуммаПоУчету
//	|ИЗ
//	|Документ.ИнвентаризацияМатериаловНаСкладе.Материалы КАК ИнвентаризацияМатериаловНаСкладеТовары
//	|ГДЕ
//	|ИнвентаризацияМатериаловНаСкладеТовары.Ссылка = &ТекущийДокумент";
//	
//	Выборка = ЗапросПоТоварам.Выполнить().Выгрузить();
//	Выборка.Сортировать("НомерСтроки Возр",);
//	
//	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
//	
//	
//	Параметр = "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
//	ПараметрКол="шт,шт,шт,м,,,,ж,2";
//	Для Каждого Строка Из Выборка Цикл
//		ОбластьМакета.Параметры.Заполнить(Строка);
//		ТабДок.Вывести(ОбластьМакета);
//	КонецЦикла;
//	
//	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
//	ОбластьМакета.Параметры.Всего = Выборка.Итог("Сумма");
//	ОбластьМакета.Параметры.ВсегоПоУчету = Выборка.Итог("СуммаПоУчету");
//	ТабДок.Вывести(ОбластьМакета);
//	
//	ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
//	ТабДок.Вывести(ОбластьМакета);
//	
//	Возврат ТабДок;
//	
//КонецФункции
