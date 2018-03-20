﻿
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

Функция ПечатьТоварныйЧек(МассивДокументов, ОбъектыПечати) Экспорт
	
	Макет = Документы.РеализацияМатериалов.ПолучитьМакет("ПечатьТоварныйЧек");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСписокНоменклатурыШапка = Макет.ПолучитьОбласть("СписокНоменклатурыШапка");
	ОбластьСписокНоменклатуры = Макет.ПолучитьОбласть("СписокНоменклатуры");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал"); 
	ОбластьСтрокаРазделитель = Макет.ПолучитьОбласть("СтрокаРазделитель");
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_РеализацияМатериалов";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивДокументов", МассивДокументов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияМатериалов.Ссылка КАК ДокРеализация,
	|	РеализацияМатериалов.Ссылка.Автор,
	|	РеализацияМатериалов.Ссылка.Дата,
	|	РеализацияМатериалов.Ссылка.Контрагент,
	|	РеализацияМатериалов.Ссылка.Комментарий,
	|	РеализацияМатериалов.Ссылка.Номер,
	|	РеализацияМатериалов.Ссылка.Подразделение,
	|	РеализацияМатериалов.Ссылка.Склад,
	|	РеализацияМатериалов.Ссылка.Склад.МОЛ КАК МОЛ,
	|	РеализацияМатериалов.Ссылка.СуммаДокумента,
	|	РеализацияМатериалов.Ссылка.Подразделение.Организация КАК Организация,
	|	РеализацияМатериалов.НомерСтроки,
	|	РеализацияМатериалов.Номенклатура,
	|	РеализацияМатериалов.Количество,
	|	РеализацияМатериалов.Цена,
	|	РеализацияМатериалов.Сумма,
	|	РеализацияМатериалов.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	НастройкиНоменклатуры.АдресХранения КАК АдресХранения,
	|	РеализацияМатериалов.Ссылка.АдресДоставки
	|ИЗ
	|	Документ.РеализацияМатериалов.СписокНоменклатуры КАК РеализацияМатериалов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(, ) КАК НастройкиНоменклатуры
	|		ПО РеализацияМатериалов.Номенклатура = НастройкиНоменклатуры.Номенклатура
	|			И РеализацияМатериалов.Ссылка.Подразделение = НастройкиНоменклатуры.Подразделение
	|ГДЕ
	|	РеализацияМатериалов.Ссылка В(&МассивДокументов)
	|	И РеализацияМатериалов.Ссылка.Проведен
	|ИТОГИ ПО
	|	ДокРеализация";
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ДокРеализация");
	
	ВставлятьРазделительСтраниц = Ложь;
	
	Пока Выборка.Следующий() Цикл
		
		ТабДокДоп = Новый ТабличныйДокумент;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		Если ВставлятьРазделительСтраниц Тогда
			
			ТабДокДоп.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ОбластьЗаголовок.Параметры.Дата = Формат(Выборка.Дата, "ДЛФ=DD");
		ОбластьЗаголовок.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Выборка.Номер);
		ТабДокДоп.Вывести(ОбластьЗаголовок);
		
		ОбластьШапка.Параметры.Заполнить(Выборка);
		ОбластьШапка.Параметры.АдресДоставки = ?(Выборка.АдресДоставки = "Введите адрес", "Без доставки", Выборка.АдресДоставки);
		
		ТабДокДоп.Вывести(ОбластьШапка, Выборка.Уровень());
		
		ТабДокДоп.Вывести(ОбластьСписокНоменклатурыШапка);
		
		ВыборкаСписокНоменклатуры = Выборка.Выбрать();
		
		Пока ВыборкаСписокНоменклатуры.Следующий() Цикл
			
			ОбластьСписокНоменклатуры.Параметры.Заполнить(ВыборкаСписокНоменклатуры);
			ТабДокДоп.Вывести(ОбластьСписокНоменклатуры, ВыборкаСписокНоменклатуры.Уровень());
			
		КонецЦикла;
		
		ОбластьПодвал.Параметры.Заполнить(Выборка);
		ОбластьПодвал.Параметры.СуммаДокументаПрописью = ЧислоПрописью(Выборка.СуммаДокумента, СтрокиСообщений.ФормСтрока(), СтрокиСообщений.ПарПредмета());
		
		ТабДок.Вывести(ТабДокДоп);
		ТабДок.Вывести(ОбластьПодвал);
		ТабДок.Вывести(ОбластьСтрокаРазделитель);
		
		Если Выборка.ДокРеализация.ОбрезкиХлыстовогоМатериала.Количество() > 0 Тогда
			ПечатьХлыстовойМатериал(ТабДокДоп, Выборка.ДокРеализация, ОбъектыПечати, МассивДокументов);
		КонецЕсли;
		
		ТабДок.Вывести(ТабДокДоп);
		ТабДок.Вывести(ОбластьПодвал);
		
		ВставлятьРазделительСтраниц = Истина;
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, МассивДокументов);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьХлыстовойМатериал(ТабДок, РеализацияСсылка, ОбъектыПечати, МассивДокументов) Экспорт
	
	ТабДокХлыстовойМатериал = Новый ТабличныйДокумент;
	
	Макет = ПолучитьОбщийМакет("ПечатьХлыстовойМатериал");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("РеализацияСсылка", РеализацияСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.Ссылка.Номер КАК НомерДокумента,
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.Ссылка.Дата КАК ДатаДокумента,
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.Номенклатура,
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.Описание,
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.РазмерЗаготовки,
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.РазмерПродаваемый,
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.РазмерХлыста
	|ИЗ
	|	Документ.РеализацияМатериалов.ОбрезкиХлыстовогоМатериала КАК РеализацияМатериаловОбрезкиХлыстовогоМатериала
	|ГДЕ
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.Ссылка = &РеализацияСсылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат -277;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	НомерСтрокиНачало = ТабДокХлыстовойМатериал.ВысотаТаблицы + 1;
	
	ОбластьЗаголовок.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Выборка.НомерДокумента);
	ОбластьЗаголовок.Параметры.ДатаДокумента = Формат(Выборка.ДатаДокумента, "ДЛФ=DD");
	ОбластьЗаголовок.Параметры.ЗаголовокДокумента = "Хлыстовой материал для реализации ";
	
	ТабДокХлыстовойМатериал.Вывести(ОбластьЗаголовок);
	ТабДокХлыстовойМатериал.Вывести(ОбластьШапка);
	
	Выборка.Сбросить();
	Пока Выборка.Следующий() Цикл
		
		ОбластьСтрока.Параметры.Заполнить(Выборка);
		ОбластьСтрока.Параметры.Комментарий = Выборка.Описание;
		ОбластьСтрока.Параметры.АдресХранения = "Обрезок";
		ОбластьСтрока.Параметры.Оприходовать = Выборка.РазмерХлыста - Выборка.РазмерПродаваемый;
		
		ТабДокХлыстовойМатериал.Вывести(ОбластьСтрока);
		ТабДокХлыстовойМатериал.Области.Строка.СоздатьФорматСтрок();
		
	КонецЦикла;
	
	ТабДокХлыстовойМатериал.Области.Заголовок.СоздатьФорматСтрок();
	ТабДокХлыстовойМатериал.Области.Шапка.СоздатьФорматСтрок();
	
	ТабДок.Вывести(ТабДокХлыстовойМатериал);
	
КонецФункции

Функция ПечатьТорг12(МассивДокументов, ОбъектыПечати) Экспорт
	
	ТабДок = ЛексСервер.ПечататьТорг12(МассивДокументов, ОбъектыПечати);
	Возврат ТабДок;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьТорг12") Тогда
		
		ПодготовитьПечатнуюФорму("ПечатьТорг12", "ПечатьТорг12", "Документ.РеализацияМатериалов.ПечатьТорг12",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьТоварныйЧек") Тогда
		
		ПодготовитьПечатнуюФорму("ПечатьТоварныйЧек", "ПечатьТоварныйЧек", "Документ.РеализацияМатериалов.ПечатьТоварныйЧек",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
		
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	Если ИмяМакета = "ПечатьТорг12" Тогда
		
		ТабДок = ПечатьТорг12(МассивОбъектов, ОбъектыПечати); 
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета, 
		ПредставлениеМакета, ТабДок, , ПолныйПутьКМакету);
		
	ИначеЕсли ИмяМакета = "ПечатьТоварныйЧек" Тогда
		
		ТабДок = ПечатьТоварныйЧек(МассивОбъектов, ОбъектыПечати);
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета, 
		ПредставлениеМакета, ТабДок, , ПолныйПутьКМакету);
		
	КонецЕсли;
	
КонецПроцедуры
