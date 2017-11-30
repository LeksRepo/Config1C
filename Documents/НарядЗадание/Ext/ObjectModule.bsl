﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	МассивСпецификацийДляИзмененияСтатуса = Новый Массив;
	Ошибки = Неопределено;
	
	Для Каждого Элемент Из СписокСпецификаций Цикл
		
		Спецификация = Элемент.Спецификация;
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация) = Перечисления.СтатусыСпецификации.Размещен Тогда
			ПроверкаМатериалаЗаказчикаПровалена = ПроверкаДокументаПриходМатериаловЗаказчика(Спецификация);
			Если ПроверкаМатериалаЗаказчикаПровалена Тогда
				ТекстСообщения = "Для " + Спецификация + " необходим проведенный документ ""приход материалов заказчика""";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.СписокСпецификаций", ТекстСообщения);
			Иначе
				МассивСпецификацийДляИзмененияСтатуса.Добавить(Спецификация);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если ОстаткиЛистовогоМатериала.Количество() > 0 ИЛИ СписокИсключаемыхОстатков.Количество() > 0 Тогда
		ЗаполнитьДвиженияДеловыеОстатки(Отказ, РежимПроведения);
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Если Дата > Дата("20160601000000") Тогда
			УвеличитьКомплектацииСпецификаций(МассивСпецификаций);
		КонецЕсли;
		
		Движения.ЦеховойЛимит.Записывать = Истина;
		Движения.Управленческий.Записывать = Истина;
		Движения.ОбрезкиМатериалов.Записывать = Истина;

		ДвиженияЦеховойЛимит(МассивСпецификаций);
		УвеличитьДополнительныйЛимит(МассивСпецификаций);
		
		ЛексСервер.ГрупповаяСменаСтатуса(МассивСпецификаций, Перечисления.СтатусыСпецификации.ПереданВЦех, Перечисления.СтатусыСпецификации.Размещен);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ДвиженияЦеховойЛимит(МассивСпецификаций)
	
	Для Каждого Спец ИЗ МассивСпецификаций Цикл
		
		Если НачалоДня(Спец.ДатаИзготовления) > НачалоДня(ДатаИзготовления) Тогда  
		
			Запись = Движения.ЦеховойЛимит.Добавить();
			Запись.Период = НачалоДня(Спец.ДатаИзготовления);
			Запись.Подразделение = Подразделение;
			Запись.СтоимостьУслуг = Спец.СуммаНарядаСпецификации;
			Запись.КоличествоКоробов = Спец.КоличествоКоробов;
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецФункции

Функция ПроверкаДокументаПриходМатериаловЗаказчика(Спецификация)
	
	Результат = Ложь;
	СтатусСпецификации = Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация);
	
	Если Спецификация.ТребуетсяПриходМатериаловЗаказчика и СтатусСпецификации = Перечисления.СтатусыСпецификации.Размещен Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Спецификация);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПриходМатериаловЗаказчика.Ссылка
		|ИЗ
		|	Документ.ПриходМатериаловЗаказчика КАК ПриходМатериаловЗаказчика
		|ГДЕ
		|	ПриходМатериаловЗаказчика.Спецификация = &Ссылка
		|	И ПриходМатериаловЗаказчика.Проведен";
		
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
			
			Результат = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПовторнаяПередачаВПроизводство()
	
	ПовторнаяПередача = Ложь;
	
	Спецификации = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НарядСсылка", Ссылка);
	Запрос.УстановитьПараметр("Спецификации", Спецификации);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НарядЗаданиеСписокСпецификаций.Спецификация,
	|	НарядЗаданиеСписокСпецификаций.Ссылка,
	|	НарядЗаданиеСписокСпецификаций.НомерСтроки
	|ИЗ
	|	Документ.НарядЗадание.СписокСпецификаций КАК НарядЗаданиеСписокСпецификаций
	|ГДЕ
	|	НарядЗаданиеСписокСпецификаций.Спецификация В(&Спецификации)
	|	И НарядЗаданиеСписокСпецификаций.Ссылка <> &НарядСсылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ПовторнаяПередача = Истина;
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 уже передана в производство документом %2", Выборка.Спецификация, Выборка.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект);
		// Можно и к полю привязать, но тогда нужна таблица значений с номером строки
		
	КонецЦикла;
	
	Возврат ПовторнаяПередача;
	
КонецФункции

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	
	Массив = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	ЛексСервер.ГрупповаяСменаСтатуса(Массив, Перечисления.СтатусыСпецификации.Размещен, Перечисления.СтатусыСпецификации.ПереданВЦех);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	Отказ = Отказ ИЛИ ПовторнаяПередачаВПроизводство();
	
	Если НЕ Отказ Тогда
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаИзготовления) Тогда
		ДатаИзготовления = Дата + 86400;
		Если ДеньНедели(ДатаИзготовления) Тогда
			ДатаИзготовления = Дата + 86400;
		КонецЕсли;
	КонецЕсли;
	
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НарядЗаданиеСписокСпецификаций.Спецификация
	|ИЗ
	|	Документ.НарядЗадание.СписокСпецификаций КАК НарядЗаданиеСписокСпецификаций
	|ГДЕ
	|	НЕ НарядЗаданиеСписокСпецификаций.Спецификация В (&МассивСпецификаций)
	|	И НарядЗаданиеСписокСпецификаций.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Документы.Спецификация.ПолучитьСтатусСпецификации(Выборка.Спецификация) = Перечисления.СтатусыСпецификации.ПереданВЦех Тогда
				Документы.Спецификация.УстановитьСтатусСпецификации(Выборка.Спецификация, Перечисления.СтатусыСпецификации.Размещен);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	СуммаДокумента = СписокСпецификаций.Итог("СуммаНаряда");
	КоличествоСпецификаций = СписокСпецификаций.Количество();
	
КонецПроцедуры

Процедура СписатьИсключаемыеОстатки()
	
	Движения.ОбрезкиМатериалов.Записывать = Истина;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Наряд", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Остатки.Номенклатура КАК Номенклатура,
	|	Остатки.Высота КАК ВысотаОстатка,
	|	Остатки.Ширина КАК ШиринаОстатка,
	|	Остатки.Резерв КАК Резерв
	|ИЗ
	|	Документ.НарядЗадание.СписокИсключаемыхОстатков КАК Остатки
	|ГДЕ
	|	Остатки.Ссылка = &Наряд";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Запись = Движения.ОбрезкиМатериалов.ДобавитьРасход();
		Запись.Период = Дата;
		Запись.Подразделение = Подразделение;
		Запись.Номенклатура = Выборка.Номенклатура;
		Запись.Ширина = Выборка.ШиринаОстатка;
		Запись.Высота = Выборка.ВысотаОстатка;
		
		Если ЗначениеЗаполнено(Выборка.Резерв) Тогда		
			Запись.КоличествоРезерв = 1;
			Запись.Спецификация = Выборка.Резерв;
		Иначе
			Запись.Количество = 1;
		КонецЕсли;
			
	КонецЦикла;
	
	Движения.ОбрезкиМатериалов.Записать();
			
КонецПроцедуры

Процедура СписатьОстаткиСРезерва()
	
	Движения.ОбрезкиМатериалов.Записывать = Истина;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("СписокСпецификаций", СписокСпецификаций.ВыгрузитьКолонку("Спецификация"));
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбрезкиМатериаловОстатки.Номенклатура КАК Номенклатура,
	|	ОбрезкиМатериаловОстатки.Высота КАК ВысотаОстатка,
	|	ОбрезкиМатериаловОстатки.Ширина КАК ШиринаОстатка,
	|	ОбрезкиМатериаловОстатки.КоличествоРезервОстаток КАК КоличествоРезерв,
	|	ОбрезкиМатериаловОстатки.Спецификация
	|ИЗ
	|	РегистрНакопления.ОбрезкиМатериалов.Остатки(
	|			,
	|			Подразделение = &Подразделение
	|				И Спецификация В (&СписокСпецификаций)) КАК ОбрезкиМатериаловОстатки";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Запись = Движения.ОбрезкиМатериалов.ДобавитьРасход();
		Запись.Период = Дата;
		Запись.Подразделение = Подразделение;
		Запись.Номенклатура = Выборка.Номенклатура;
		Запись.Ширина = Выборка.ШиринаОстатка;
		Запись.Высота = Выборка.ВысотаОстатка;
		Запись.КоличествоРезерв = Выборка.КоличествоРезерв;
		Запись.Спецификация = Выборка.Спецификация;
		
		Запись = Движения.ОбрезкиМатериалов.ДобавитьПриход();
		Запись.Период = Дата;
		Запись.Подразделение = Подразделение;
		Запись.Номенклатура = Выборка.Номенклатура;
		Запись.Ширина = Выборка.ШиринаОстатка;
		Запись.Высота = Выборка.ВысотаОстатка;
		Запись.Количество = Выборка.КоличествоРезерв;
		
	КонецЦикла;
	
	Движения.ОбрезкиМатериалов.Записать();
		
КонецПроцедуры

Процедура ЗаполнитьДвиженияДеловыеОстатки(Отказ, РежимПроведения)

	Движения.ОбрезкиМатериалов.Очистить();
	Движения.ОбрезкиМатериалов.Записать();
	
	СписатьИсключаемыеОстатки();
	СписатьОстаткиСРезерва();

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Остатки.Номенклатура,
	|	СУММА(1) КАК Количество,
	|	Остатки.ВысотаОстатка КАК Высота,
	|	Остатки.ШиринаОстатка КАК Ширина
	|ИЗ
	|	Документ.НарядЗадание.ОстаткиЛистовогоМатериала КАК Остатки
	|ГДЕ
	|	Остатки.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Остатки.Номенклатура,
	|	Остатки.ВысотаОстатка,
	|	Остатки.ШиринаОстатка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Движение = Движения.ОбрезкиМатериалов.ДобавитьРасход();
		Движение.Период = Дата;
		Движение.Подразделение = Подразделение;
		Движение.Номенклатура = Выборка.Номенклатура;
		Движение.Ширина = Выборка.Ширина;
		Движение.Высота = Выборка.Высота;
		Движение.Количество = Выборка.Количество;
		
	КонецЦикла;
	
	//RonEXI: Проверим минуса.
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("СписокНоменклатуры", СписокИсключаемыхОстатков.ВыгрузитьКолонку("Номенклатура"));
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Остатки.Номенклатура,
	|	Остатки.КоличествоОстаток КАК Количество,
	|	Остатки.КоличествоРезервОстаток КАК КоличествоРезерв,
	|	Остатки.Высота КАК Высота,
	|	Остатки.Ширина КАК Ширина,
	|	Остатки.Спецификация КАК Спецификация
	|ИЗ
	|	РегистрНакопления.ОбрезкиМатериалов.Остатки(, Подразделение = &Подразделение) КАК Остатки
	|ГДЕ
	|	Остатки.Номенклатура В(&СписокНоменклатуры)
	|	И (Остатки.КоличествоОстаток < 0
	|			ИЛИ Остатки.КоличествоРезервОстаток < 0)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Ошибки = Неопределено;
	ШаблонСтроки = "%1 (%2х%3) недостаточно делового остатка %4 шт.";
	
	Пока Выборка.Следующий() Цикл
		
		Нехватка =  ?(Выборка.Количество < 0, Выборка.Количество, 0) + ?(Выборка.КоличествоРезерв < 0, Выборка.КоличествоРезерв, 0);
		
		Если Нехватка < 0 Тогда
			
		        Отказ = Истина;
				СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСтроки,
				Выборка.Номенклатура,
				Выборка.Ширина,
				Выборка.Высота,
				-Нехватка);
				
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,,СтрокаОшибки,,);
				
		КонецЕсли;
			
	КонецЦикла;
		
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);

КонецПроцедуры

// Увеличивает дополнительный лимит цеха на количество
// требуемое по переданным спецификациям
//
// Параметры
//  МассивСпецификаций  - Массив - Массив спецификаций для которых увеличить лимит
//
// Возвращаемое значение:
//   нет   - 
//
Функция УвеличитьДополнительныйЛимит(МассивСпецификаций)
	
	Счет = ПланыСчетов.Управленческий.ДополнительныйЛимитЦеха;
	ПВХНоменклатура = ПланыВидовХарактеристик.ВидыСубконто.Номенклатура;
	ПВХСпецификации = ПланыВидовХарактеристик.ВидыСубконто.Спецификации;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпецификацияСписокНоменклатуры.Номенклатура,
	|	СпецификацияСписокНоменклатуры.Ссылка КАК Спецификация,
	|	СУММА(СпецификацияСписокНоменклатуры.Количество) КАК Количество
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В(&МассивСпецификаций)
	|	И СпецификацияСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|	И НЕ СпецификацияСписокНоменклатуры.ПредоставитЗаказчик
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Номенклатура,
	|	СпецификацияСписокНоменклатуры.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.СчетДт = Счет;
		Проводка.СубконтоДт[ПВХНоменклатура] = Выборка.Номенклатура;
		Проводка.СубконтоДт[ПВХСпецификации] = Выборка.Спецификация;
		Проводка.КоличествоДт = Выборка.Количество;
		
	КонецЦикла;
	
КонецФункции

Функция УвеличитьКомплектацииСпецификаций(МассивСпецификаций)
	
	Счет = ПланыСчетов.Управленческий.КомплектацииСпецификаций;
	
	ПВХМестоОбработки = ПланыВидовХарактеристик.ВидыСубконто.МестоОбработки;
	ПВХСпецификации = ПланыВидовХарактеристик.ВидыСубконто.Спецификации;
	ПВХНоменклатура = ПланыВидовХарактеристик.ВидыСубконто.Номенклатура;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпецификацияСкладГотовойПродукции.Номенклатура КАК Номенклатура,
	|	СпецификацияСкладГотовойПродукции.Ссылка КАК Спецификация,
	|	СУММА(СпецификацияСкладГотовойПродукции.КоличествоСклад) КАК КоличествоСклад,
	|	СУММА(СпецификацияСкладГотовойПродукции.КоличествоЦех) КАК КоличествоЦех
	|ИЗ
	|	Документ.Спецификация.СкладГотовойПродукции КАК СпецификацияСкладГотовойПродукции
	|ГДЕ
	|	СпецификацияСкладГотовойПродукции.Ссылка В(&МассивСпецификаций)
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСкладГотовойПродукции.Ссылка,
	|	СпецификацияСкладГотовойПродукции.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	Спецификация,
	|	Номенклатура";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.КоличествоСклад > 0 Тогда
			
			Проводка = Движения.Управленческий.Добавить();
			Проводка.Период = Дата;
			Проводка.Подразделение = Подразделение;
			Проводка.СчетДт = Счет;
			
			Проводка.СубконтоДт[ПВХМестоОбработки] = Перечисления.МестоОбработки.Отгрузка;
			Проводка.СубконтоДт[ПВХСпецификации] = Выборка.Спецификация;
			Проводка.СубконтоДт[ПВХНоменклатура] = Выборка.Номенклатура;
			Проводка.КоличествоДт = Выборка.КоличествоСклад;
			
		КонецЕсли;
		
		Если Выборка.КоличествоЦех > 0 Тогда
			
			Проводка = Движения.Управленческий.Добавить();
			Проводка.Период = Дата;
			Проводка.Подразделение = Подразделение;
			Проводка.СчетДт = Счет;
			
			Проводка.СубконтоДт[ПВХМестоОбработки] = Перечисления.МестоОбработки.Цех;
			Проводка.СубконтоДт[ПВХСпецификации] = Выборка.Спецификация;
			Проводка.СубконтоДт[ПВХНоменклатура] = Выборка.Номенклатура;
			Проводка.КоличествоДт = Выборка.КоличествоЦех;
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецФункции
