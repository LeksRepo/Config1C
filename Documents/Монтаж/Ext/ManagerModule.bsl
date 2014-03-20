﻿
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПечатьАктДоставкаСборка(ТабДок, Ссылка) Экспорт
	
	Перем Инженер;
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета="рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 0";
	Спецификация = Ссылка.Спецификация;
	ДоговорСсылка = Документы.Спецификация.ПолучитьДоговор(Спецификация);
	
	Макет = Документы.Монтаж.ПолучитьМакет("АктДоставкаСборка");
	Запрос = Новый Запрос;
	Запрос.Текст =
	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Монтаж.Дата,
	|	Монтаж.Спецификация,
	|	Монтаж.Номер,
	|	Монтаж.Подразделение,
	|	Монтаж.Экспедитор,
	|	Монтаж.Подразделение.Организация.ПолноеНаименование КАК ПолноеНаименование,
	|	Монтаж.Монтажник,
	|	Монтаж.Спецификация.Автор КАК Инженер,
	|	Договор.Контрагент КАК ФИОКлиента,
	|	Договор.Офис КАК АдресОфиса,
	|	Договор.Автор КАК Дизайнер,
	|	Договор.Дата КАК ДатаДоговора,
	|	Договор.Номер КАК НомерДоговора,
	|	Договор.СуммаДокумента КАК СуммаДокумента,
	|	Монтаж.Спецификация.Изделие КАК Изделие,
	|	Договор.Спецификация.АдресМонтажа КАК АдресМонтажа,
	|	Договор.Контрагент.Телефон КАК Телефон,
	|	Договор.Контрагент.ТелефонДополнительный КАК ТелефонДополнительный,
	|	ПРЕДСТАВЛЕНИЕ(Договор.Ссылка) КАК Договор,
	|	Монтаж.Спецификация.Номер КАК НомерСпецификации,
	|	Договор.Спецификация.КоличествоМетровЛДСП КАК КоличествоМетровЛДСП
	|ИЗ
	|	Документ.Монтаж КАК Монтаж
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК Договор
	|		ПО Монтаж.Спецификация = Договор.Спецификация
	|ГДЕ
	|	Монтаж.Ссылка = &Ссылка";
	
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если НЕ Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	// ################
	// Доставка
	
	ОбластьТело = Макет.ПолучитьОбласть("Тело");
	
	ОбластьТело.Параметры.Заполнить(Выборка);
	ОбластьТело.Параметры.ДатаДоговора = Формат(Выборка.ДатаДоговора, "ДЛФ=DD");
	ОбластьТело.Параметры.ДатаДоставки = Формат(Выборка.Дата, "ДЛФ=DD");
	ТабДок.Вывести(ОбластьТело);
	
КонецПроцедуры

Функция ПолучитьПоДоговору(ДоговорСсылка) Экспорт
	
	Результат = Документы.Монтаж.ПустаяСсылка();
	
	МассивМонтаж = ЛексСервер.НайтиПодчиненныеДокументы(ДоговорСсылка, "Документ.Монтаж", "Договор");
	Количество = МассивМонтаж.Количество();
	
	Если Количество = 0 Тогда
		Результат = Документы.Монтаж.ПустаяСсылка();
	ИначеЕсли Количество = 1 Тогда
		Результат = МассивМонтаж[0];
	ИначеЕсли Количество > 1 Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Ошибка! С %1 связано несколько Графиков монтажа. Сообщите администратору номер договора", ДоговорСсылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ДоговорСсылка);
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ПолучитьПоДоговору()

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктПередачи") Тогда
		ПодготовитьПечатнуюФорму("АктПередачи", "Акт передачи мебельного комплекта", "",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета);
	
	Если НужноПечататьМакет Тогда
		
		Если ИмяМакета = "АктПередачи" Тогда
			
			ТабДок = ПечатьАктПередачи(МассивОбъектов, ОбъектыПечати);
			
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета,
		ПредставлениеМакета, ТабДок,, ПолныйПутьКМакету);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьАктПередачи(МассивОбъектов, ОбъектыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПечатьНарядЗадания";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = ПолучитьОбщийМакет("АктПередачи");
	ОбластьТело = Макет.ПолучитьОбласть("Тело");
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Ссылка", МассивОбъектов);
	Запрос.Текст =
	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Монтаж.Экспедитор,
	|	Монтаж.Подразделение.Организация.ПолноеНаименование КАК ОрганизацияИзготовилеть,
	|	Монтаж.Монтажник,
	|	Договор.Контрагент КАК ФИОКлиента,
	|	Договор.Офис КАК АдресОфиса,
	|	Договор.Автор КАК Дизайнер,
	|	Договор.Дата КАК ДатаДоговора,
	|	Договор.Номер КАК НомерДоговора,
	|	Договор.СуммаДокумента КАК СуммаДокумента,
	|	Монтаж.Спецификация.Изделие КАК Изделие,
	|	Договор.Спецификация.АдресМонтажа КАК АдресМонтажа,
	|	Договор.Контрагент.Телефон КАК Телефон,
	|	Договор.Контрагент.ТелефонДополнительный КАК ТелефонДополнительный,
	|	ПРЕДСТАВЛЕНИЕ(Договор.Ссылка) КАК Договор,
	|	Договор.Спецификация.КоличествоМетровЛДСП КАК КоличествоМетровЛДСП,
	|	Монтаж.Ссылка,
	|	Договор.Организация.ПолноеНаименование КАК ОрганизацияПродавец,
	|	Договор.Офис.Телефон КАК ТелефонОфиса,
	|	ВЫРАЗИТЬ(Договор.Спецификация.ДокументОснование КАК Документ.Замер).Замерщик КАК Замерщик,
	|	Договор.Спецификация.СуммаНарядаСпецификации КАК СуммаНаряда 
	|ИЗ
	|	Документ.Монтаж КАК Монтаж
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК Договор
	|		ПО Монтаж.Спецификация = Договор.Спецификация
	|ГДЕ
	|	Монтаж.Ссылка В(&Ссылка)";
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ВставлятьРазделительСтраниц = Ложь;
	
	Пока Выборка.Следующий() Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		ОбластьТело.Параметры.Заполнить(Выборка);
		ОбластьТело.Параметры.ДатаДоговора = Формат(Выборка.ДатаДоговора, "ДЛФ=DD");
		ТабДок.Вывести(ОбластьТело);
		
		ВставлятьРазделительСтраниц = Истина;
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции
