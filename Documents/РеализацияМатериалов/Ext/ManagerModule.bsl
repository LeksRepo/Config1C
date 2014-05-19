﻿
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

Функция ПечатьТоварныйЧек(МассивДокументов, ОбъектыПечати) Экспорт
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета = "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
	
	Макет = Документы.РеализацияМатериалов.ПолучитьМакет("ПечатьТоварныйЧек");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСписокНоменклатурыШапка = Макет.ПолучитьОбласть("СписокНоменклатурыШапка");
	ОбластьСписокНоменклатуры = Макет.ПолучитьОбласть("СписокНоменклатуры");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал"); 
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_РеализацияМатериалов";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияМатериалов.Автор,
	|	РеализацияМатериалов.Дата,
	|	РеализацияМатериалов.Контрагент,
	|	РеализацияМатериалов.Номер,
	|	РеализацияМатериалов.Подразделение,
	|	РеализацияМатериалов.Склад,
	|	РеализацияМатериалов.СуммаДокумента,
	|	РеализацияМатериалов.СписокНоменклатуры.(
	|		НомерСтроки,
	|		Номенклатура,
	|		Количество,
	|		Цена,
	|		Сумма,
	|		Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|	),
	|	РеализацияМатериалов.Подразделение.Организация КАК Организация
	|ИЗ
	|	Документ.РеализацияМатериалов КАК РеализацияМатериалов
	|ГДЕ
	|	РеализацияМатериалов.Ссылка В(&МассивДокументов)
	|	И РеализацияМатериалов.Проведен";
	Запрос.Параметры.Вставить("МассивДокументов", МассивДокументов);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ВставлятьРазделительСтраниц = Ложь;
	
	Пока Выборка.Следующий() Цикл
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		Если ВставлятьРазделительСтраниц Тогда
			
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли; 
		
		ОбластьЗаголовок.Параметры.Заполнить(Выборка);
		ОбластьЗаголовок.Параметры.Дата = Формат(Выборка.Дата, "ДЛФ=DD");
		ТабДок.Вывести(ОбластьЗаголовок);
		
		ОбластьШапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(ОбластьШапка, Выборка.Уровень());
		
		ТабДок.Вывести(ОбластьСписокНоменклатурыШапка);
		ВыборкаСписокНоменклатуры = Выборка.СписокНоменклатуры.Выбрать();
		
		Пока ВыборкаСписокНоменклатуры.Следующий() Цикл
			
			ОбластьСписокНоменклатуры.Параметры.Заполнить(ВыборкаСписокНоменклатуры);
			ТабДок.Вывести(ОбластьСписокНоменклатуры, ВыборкаСписокНоменклатуры.Уровень());
			
		КонецЦикла;
		
		ОбластьПодвал.Параметры.Заполнить(Выборка);
		ОбластьПодвал.Параметры.СуммаДокументаПрописью = ЧислоПрописью(Выборка.СуммаДокумента, ФормСтрока, ПарПредмета);
		ТабДок.Вывести(ОбластьПодвал); 
		
		ВставлятьРазделительСтраниц = Истина;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, МассивДокументов);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьТорг12(МассивДокументов, ОбъектыПечати) Экспорт
	
	// { Васильев Александр Леонидович [16.10.2013]
	// пока нельзя печатать
	// возврат
	// } Васильев Александр Леонидович [16.10.2013]
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_РеализацияМатериалов";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет = ПолучитьОбщийМакет("ТОРГ12");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьЗаголовокТаб = Макет.ПолучитьОбласть("ЗаголовокТаб");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьВсего = Макет.ПолучитьОбласть("Всего");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивДокументов", МассивДокументов);
	Спецификация = ТипЗнч(МассивДокументов[0].Ссылка) = Тип("ДокументСсылка.Спецификация");
	
	Если НЕ Спецификация Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	РеализацияМатериалов.Автор,
		|	РеализацияМатериалов.Дата КАК ДатаДокумента,
		|	РеализацияМатериалов.Контрагент,
		|	РеализацияМатериалов.Номер КАК НомерДокумента,
		|	РеализацияМатериалов.Подразделение,
		|	РеализацияМатериалов.Склад,
		|	РеализацияМатериалов.СуммаДокумента,
		|	РеализацияМатериалов.СписокНоменклатуры.(
		|		НомерСтроки КАК Номер,
		|		Номенклатура,
		|		Номенклатура.КоэффициентБазовых КАК Коэффициент,
		|		Номенклатура.Код КАК ТоварКод,
		|		Количество,
		|		Цена,
		|		Сумма КАК СуммаБезНДС,
		|		Сумма КАК СуммаСНДС,
		|		""Без НДС"" КАК СтавкаНДС,
		|		0 КАК СуммаНДС,
		|		Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|		Номенклатура.ЕдиницаИзмерения.Наименование КАК ЕдиницаНаименование,
		|		Номенклатура.ЕдиницаИзмерения.Код КАК ЕдиницаКодПоОКЕИ
		|	),
		|	РеализацияМатериалов.Подразделение.Организация.ПолноеНаименование + "", ИНН "" + РеализацияМатериалов.Подразделение.Организация.ИНН + "", "" + РеализацияМатериалов.Подразделение.Организация.ЮридическийАдрес + "", р/с "" + РеализацияМатериалов.Подразделение.Организация.РасчетныйСчет + "", БИК "" + РеализацияМатериалов.Подразделение.Организация.БИК + "", корр/с "" + РеализацияМатериалов.Подразделение.Организация.КорреспондирующийСчет КАК ПредставлениеПоставщика,
		|	РеализацияМатериалов.Подразделение.Организация.ПолноеНаименование + "", ИНН "" + РеализацияМатериалов.Подразделение.Организация.ИНН + "", "" + РеализацияМатериалов.Подразделение.Организация.ЮридическийАдрес + "", р/с "" + РеализацияМатериалов.Подразделение.Организация.РасчетныйСчет + "", БИК "" + РеализацияМатериалов.Подразделение.Организация.БИК + "", корр/с "" + РеализацияМатериалов.Подразделение.Организация.КорреспондирующийСчет КАК ПредставлениеОрганизации,
		|	РеализацияМатериалов.Контрагент.ПолноеНаименование КАК ПолноеНаименование,
		|	РеализацияМатериалов.Контрагент.ЮридическийАдрес КАК АдресДоставки,
		|	РеализацияМатериалов.Контрагент.Телефон КАК Телефон,
		|	РеализацияМатериалов.Контрагент.БанковскиеРеквизиты КАК БанковскиеРеквизиты
		|ИЗ
		|	Документ.РеализацияМатериалов КАК РеализацияМатериалов
		|ГДЕ
		|	РеализацияМатериалов.Ссылка В(&МассивДокументов)
		|	И РеализацияМатериалов.Проведен";
		
	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Спецификация.Автор,
		|	Спецификация.Дата КАК ДатаДокумента,
		|	Спецификация.Контрагент,
		|	Спецификация.Номер КАК НомерДокумента,
		|	Спецификация.Подразделение,
		|	Спецификация.Подразделение.ОсновнойСклад,
		|	Спецификация.СуммаДокумента,
		|	1 КАК Номер,
		|	""Мебельный комплект"" КАК Номенклатура,
		|	Спецификация.Контрагент.ПолноеНаименование КАК ПолноеНаименование,
		|	Спецификация.Контрагент.ЮридическийАдрес КАК АдресДоставки,
		|	Спецификация.Контрагент.Телефон КАК Телефон,
		|	Спецификация.Контрагент.БанковскиеРеквизиты КАК БанковскиеРеквизиты,
		|	1 КАК Количество,
		|	Спецификация.СуммаДокумента КАК Цена,
		|	Спецификация.СуммаДокумента КАК СуммаБезНДС,
		|	Спецификация.СуммаДокумента КАК СуммаСНДС,
		|	""Шт."" КАК ЕдиницаИзмерения,
		|	""Шт."" КАК ЕдиницаНаименование,
		|	""Без НДС"" КАК СтавкаНДС,
		|	0 КАК СуммаНДС,
		|	Спецификация.Производство.ЮридическийАдресОрганизации КАК ПодразделениеЮридическийАдресОрганизации
		|ИЗ
		|	Документ.Спецификация КАК Спецификация
		|ГДЕ
		|	Спецификация.Ссылка В(&МассивДокументов)"
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	ВставлятьРазделительСтраниц = Ложь;
	
	Пока Выборка.Следующий() Цикл
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		ВсегоКоличество = 0;
		ВсегоСумма = 0;
		
		Если ВставлятьРазделительСтраниц Тогда
			
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		Если Спецификация Тогда
			
			Вяс = Справочники.Организации.НайтиПоКоду("000000005");
			СтруктураРеквизитовВяса = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Вяс, "ПолноеНаименование, ИНН, РасчетныйСчет, БИК, КорреспондирующийСчет");
			ЧастноеЛицо = Справочники.Контрагенты.ЧастноеЛицо;
			ПредставлениеГрузополучателя = ЧастноеЛицо;
			ПредставлениеГрузоотпрвителя = СтруктураРеквизитовВяса.ПолноеНаименование + ", ИНН " + СтруктураРеквизитовВяса.ИНН + ", " + Выборка.ПодразделениеЮридическийАдресОрганизации + ", р/с " + СтруктураРеквизитовВяса.РасчетныйСчет + ", БИК " + СтруктураРеквизитовВяса.БИК + ", корр/с " + СтруктураРеквизитовВяса.КорреспондирующийСчет;
			ОбластьШапка.Параметры.Заполнить(Выборка);
			НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Выборка.НомерДокумента);
			ОбластьШапка.Параметры.НомерДокумента = НомерДокумента;
			ОбластьШапка.Параметры.ПредставлениеОрганизации = ПредставлениеГрузоотпрвителя;
			ОбластьШапка.Параметры.Основание = "Заказ №" + НомерДокумента + " от " + Формат(Выборка.ДатаДокумента,"ДЛФ=Д");
			ОбластьШапка.Параметры.ПредставлениеПоставщика = ПредставлениеГрузоотпрвителя;
			ОбластьШапка.Параметры.ПредставлениеГрузополучателя = ПредставлениеГрузополучателя;
			ОбластьШапка.Параметры.ПредставлениеПлательщика = ЧастноеЛицо;
			ТабДок.Вывести(ОбластьШапка);
			ТабДок.Вывести(ОбластьЗаголовокТаб);
			ВсегоКоличество = 1;
			ВсегоСумма = Выборка.СуммаДокумента;
			ОбластьСтрока.Параметры.Заполнить(Выборка);
			ТабДок.Вывести(ОбластьСтрока);
			
		Иначе
			
			ПредставлениеГрузополучателя = "" + Выборка.ПолноеНаименование + ?(ЗначениеЗаполнено(Выборка.АдресДоставки), ", адрес: " + Выборка.АдресДоставки, "") 
			+ ?(ЗначениеЗаполнено(Выборка.Телефон), ", тел: " + Выборка.Телефон, "") + ?(ЗначениеЗаполнено(Выборка.БанковскиеРеквизиты), ", " + Выборка.БанковскиеРеквизиты, "");
			ОбластьШапка.Параметры.Заполнить(Выборка);
			НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Выборка.НомерДокумента);
			ОбластьШапка.Параметры.НомерДокумента = НомерДокумента;
			ОбластьШапка.Параметры.ПредставлениеГрузополучателя = ПредставлениеГрузополучателя;
			ТабДок.Вывести(ОбластьШапка);
			ТабДок.Вывести(ОбластьЗаголовокТаб);
			ВыборкаСписокНоменклатуры = Выборка.СписокНоменклатуры.Выбрать();
			
			Пока ВыборкаСписокНоменклатуры.Следующий() Цикл
				
				ВсегоКоличество = ВыборкаСписокНоменклатуры.Количество + ВсегоКоличество;
				ВсегоСумма = ВыборкаСписокНоменклатуры.СуммаБезНДС + ВсегоСумма;;
				
				
			КонецЦикла;
			
		КонецЕсли;
				
		ОбластьВсего.Параметры.Заполнить(Выборка);
		ОбластьВсего.Параметры.ИтогКоличество = ВсегоКоличество;
		ОбластьВсего.Параметры.ИтогСуммыСНДС = ВсегоСумма;
		ОбластьВсего.Параметры.ИтогСуммы = ВсегоСумма;
		ТабДок.Вывести(ОбластьВсего);
		
		СуммаПрописью = ЧислоПрописью(ВсегоСумма,"Л=ru_RU; ДП=Ложь","рубль, рубля, рублей, м, копейка, копейки, копеек, ж" );
		ОбластьПодвал.Параметры.Заполнить(Выборка);
		ОбластьПодвал.Параметры.СуммаПрописью = СуммаПрописью;
		ТабДок.Вывести(ОбластьПодвал);
		
		ВставлятьРазделительСтраниц = Истина;
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, МассивДокументов);
		
	КонецЦикла;
	
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
