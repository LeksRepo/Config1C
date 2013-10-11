﻿Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,
	ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриходныйКассовыйОрдер") Тогда
		ПодготовитьПечатнуюФорму("ПриходныйКассовыйОрдер", "Приходный кассовый ордер", "Документ.ПриходДенежныхСредств.ПриходныйКассовыйОрдер",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТоварныйЧек") Тогда
		ПодготовитьПечатнуюФорму("ТоварныйЧек", "Товарный чек", "Документ.ПриходДенежныхСредств.ТоварныйЧек",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета);
	Если НужноПечататьМакет Тогда
		Если ИмяМакета = "ПриходныйКассовыйОрдер" Тогда
			ТабДок = ПечатьКассовыйОрдер(МассивОбъектов, ОбъектыПечати);
		ИначеЕсли ИмяМакета = "ТоварныйЧек" Тогда
			Для Каждого Элемент Из МассивОбъектов Цикл
				Если Элемент.СчетКт <> ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями Тогда
					МассивОбъектов.Удалить(МассивОбъектов.Найти(Элемент));
				КонецЕсли;
			КонецЦикла;
			ТабДок = ПечатьТоварныйЧек(МассивОбъектов, ОбъектыПечати);
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета,
		ПредставлениеМакета, ТабДок,, ПолныйПутьКМакету);
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьКассовыйОрдер(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПриходныйКассовыйОрдер";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПриходДенежныхСредств.Подразделение КАК ПредставлениеПодразделения,
	|	ПриходДенежныхСредств.Подразделение.Организация КАК ПредставлениеОрганизации,
	|	ПриходДенежныхСредств.Номер КАК НомерДокумента,
	|	ПриходДенежныхСредств.Дата КАК ДатаДокумента,
	|	ПриходДенежныхСредств.Подразделение.Код,
	|	ПриходДенежныхСредств.Субконто1Дт КАК Основание,
	|	ПриходДенежныхСредств.Субконто1Кт,
	|	ПриходДенежныхСредств.Субконто2Дт,
	|	ПриходДенежныхСредств.Субконто2Кт,
	|	ПриходДенежныхСредств.Субконто3Дт,
	|	ПриходДенежныхСредств.Субконто3Кт,
	|	ПриходДенежныхСредств.Сумма,
	|	ПриходДенежныхСредств.Подразделение.Организация.ФИОДолжностногоЛица,
	|	ПриходДенежныхСредств.СчетДт.Код КАК КодДебета,
	|	ПриходДенежныхСредств.СчетКт.Код КАК СубСчет,
	|	ПриходДенежныхСредств.Ссылка
	|ИЗ
	|	Документ.ПриходДенежныхСредств КАК ПриходДенежныхСредств
	|ГДЕ
	|	ПриходДенежныхСредств.Ссылка В(&Ссылка)
	|	И ПриходДенежныхСредств.Проведен";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Макет 	= Документы.ПриходДенежныхСредств.ПолучитьМакет("ПриходныйКассовыйОрдер");
	Шапка 	= Макет.ПолучитьОбласть("Шапка");
	ФормСтрока 		= "Л = ru_RU; ДП = Истина";
	ПарПредмета 	= "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
	
	ТабДок.Очистить();
	
	ВставлятьРазделительСтраниц = Ложь;	
	
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		СуммаПрописью 	= ЧислоПрописью(Выборка.Сумма, ФормСтрока, ПарПредмета);
		
		ДатаПрописью 	= ЛексКлиентСервер.ДатаПрописью(Выборка.ДатаДокумента);
		
		Сотрудник 		= ?(ТипЗнч(Выборка.Субконто1Кт) = Тип("СправочникСсылка.Контрагенты"), Выборка.Субконто1Кт, Выборка.Субконто2Кт);
		
		
		Шапка.Параметры.Заполнить(Выборка);
		
		Шапка.Параметры.Сотрудник 		= Сотрудник;
		Шапка.Параметры.СуммаПрописью 	= СуммаПрописью;
		
		ТабДок.Вывести(Шапка);
		
		ВставлятьРазделительСтраниц = Истина;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, 
		НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьТоварныйЧек(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ТоварныйЧек";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПриходДенежныхСредств.Номер КАК НомерДокумента,
	|	ПриходДенежныхСредств.Субконто2Кт.Дата КАК ДатаДоговора,
	|	ПриходДенежныхСредств.Субконто2Кт.Номер КАК НомерДоговора,
	|	ПриходДенежныхСредств.Субконто2Кт.Контрагент КАК Клиент,
	|	ПриходДенежныхСредств.Сумма КАК Сумма,
	|	ПриходДенежныхСредств.Автор КАК Автор,
	|	ПриходДенежныхСредств.Дата КАК ДатаДокумента,
	|	ПриходДенежныхСредств.Офис.Адрес КАК Адрес,
	|	ПриходДенежныхСредств.Офис.Телефон КАК Телефон,
	|	ПриходДенежныхСредств.Офис.Владелец.Организация.ОГРН КАК ОГРН,
	|	ПриходДенежныхСредств.Офис.Владелец.Организация.ИНН КАК ИНН,
	|	ПриходДенежныхСредств.Офис.Владелец.Организация КАК Организация,
	|	ПриходДенежныхСредств.Офис.Владелец.Организация.ДатаВыдачиОГРН КАК ДатаВыдачиОГРН,
	|	ПриходДенежныхСредств.Ссылка
	|ИЗ
	|	Документ.ПриходДенежныхСредств КАК ПриходДенежныхСредств
	|ГДЕ
	|	ПриходДенежныхСредств.Ссылка В(&Ссылка)
	|	И ПриходДенежныхСредств.Проведен";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Макет 	= Документы.ПриходДенежныхСредств.ПолучитьМакет("ТоварныйЧек");
	Чек 	= Макет.ПолучитьОбласть("Чек");
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета="рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 0";
	ТабДок.Очистить();
	
	ВставлятьРазделительСтраниц = Ложь;	
	
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		Чек.Параметры.Заполнить(Выборка);
		Чек.Параметры.ДатаДокумента = Формат(Выборка.ДатаДокумента, "ДЛФ=DD");
		Чек.Параметры.ДатаДоговора = Формат(Выборка.ДатаДоговора, "ДЛФ=DD");
		Чек.Параметры.ДатаВыдачиОГРН = Формат(Выборка.ДатаВыдачиОГРН, "ДЛФ=DD");
		Чек.Параметры.СуммаПрописью = ЧислоПрописью(Выборка.Сумма, ФормСтрока, ПарПредмета);
		
		ТабДок.Вывести(Чек);
		
		ВставлятьРазделительСтраниц = Истина;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, 
		НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры
