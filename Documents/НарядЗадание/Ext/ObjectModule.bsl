﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	МассивСпецификацийДляИзмененияСтатуса = Новый Массив;
	Ошибки = Неопределено;
	
	Для Каждого Элемент Из СписокСпецификаций Цикл
		
		Спецификация = Элемент.Спецификация;
		СтатусСпецификации = Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация);
		
		Если СтатусСпецификации = Перечисления.СтатусыСпецификации.Размещен Тогда
			
			ПроверкаМатериалаЗаказчикаПровалена = ПроверкаДокументаПриходМатериаловЗаказчика(Спецификация);
			Если ПроверкаМатериалаЗаказчикаПровалена Тогда
				ТекстСообщения = "Для " + Спецификация + " необходим проведенный документ ""приход материалов заказчика""";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.СписокСпецификаций", ТекстСообщения);
			Иначе
				МассивСпецификацийДляИзмененияСтатуса.Добавить(Спецификация);
			КонецЕсли;
				
		КонецЕсли;
		
		Если НЕ Проведен Тогда
			Если НЕ (СтатусСпецификации = Перечисления.СтатусыСпецификации.Размещен
				ИЛИ СтатусСпецификации = Перечисления.СтатусыСпецификации.ПереданВЦех) Тогда 
				
				ТекстСообщения = "" + Спецификация + " не размещена.";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.СписокСпецификаций", ТекстСообщения);
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если ОстаткиЛистовогоМатериала.Количество() > 0 ИЛИ СписокИсключаемыхОстатков.Количество() > 0 Тогда
		ЗаполнитьДвиженияДеловыеОстатки(Отказ, РежимПроведения);
	КонецЕсли;
	
	Если ОстаткиХлыстов.Количество() > 0 Тогда
		СписаниеХлыстовыхОбрезков(Отказ);
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Движения.ЦеховойЛимит.Записывать = Истина;
		Движения.Управленческий.Записывать = Истина;
		Движения.ОбрезкиЛистовойМатериал.Записывать = Истина;
		Движения.ОбрезкиХлыстовойМатериал.Записывать = Истина;

		ДвиженияЦеховойЛимит(МассивСпецификаций);
		УвеличитьДополнительныйЛимит(МассивСпецификаций);
		
		ЛексСервер.ГрупповаяСменаСтатуса(МассивСпецификаций, Перечисления.СтатусыСпецификации.ПереданВЦех, Перечисления.СтатусыСпецификации.Размещен);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СписаниеХлыстовыхОбрезков(Отказ)
	
	Движения.ОбрезкиХлыстовойМатериал.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Список.Номенклатура,
	|	Список.Размер КАК Размер
	|ИЗ
	|	Документ.НарядЗадание.ОстаткиХлыстов КАК Список
	|ГДЕ
	|	Список.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Запись = Движения.ОбрезкиХлыстовойМатериал.ДобавитьРасход();
		Запись.Период = Дата;
		Запись.Подразделение = Подразделение;
		Запись.Номенклатура = Выборка.Номенклатура;
		Запись.Размер = Выборка.Размер;
		Запись.Количество = 1;	
		
	КонецЦикла;
	
	Движения.Записать();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Список.Номенклатура КАК Номенклатура,
	|	Список.Размер КАК Размер,
	|	&Подразделение КАК Подразделение
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	Документ.НарядЗадание.ОстаткиХлыстов КАК Список
	|ГДЕ
	|	Список.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНоменклатура.Номенклатура,
	|	-Обрезки.КоличествоОстаток КАК Нехватка,
	|	втНоменклатура.Размер
	|ИЗ
	|	ВТ КАК втНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОбрезкиХлыстовойМатериал.Остатки(, ) КАК Обрезки
	|		ПО втНоменклатура.Номенклатура = Обрезки.Номенклатура
	|			И втНоменклатура.Размер = Обрезки.Размер
	|			И втНоменклатура.Подразделение = Обрезки.Подразделение
	|ГДЕ
	|	Обрезки.КоличествоОстаток < 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Ошибки = Неопределено;
		ШаблонСтроки = "Обрезок %1 (%2) недостаточно %3 шт.";
		ИмяПоляОшибки = "Объект.ОстаткиХлыстов";
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСтроки,
			Выборка.Номенклатура,
			Выборка.Размер,
			Выборка.Нехватка);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, ИмяПоляОШибки, СтрокаОшибки,,);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если Не Отказ Тогда
		Движения.ОбрезкиХлыстовойМатериал.Записывать = Истина;
	Иначе
		Движения.ОбрезкиХлыстовойМатериал.Записывать = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Функция ДвиженияЦеховойЛимит(МассивСпецификаций)
	
	Для Каждого Спец ИЗ МассивСпецификаций Цикл
		
		Если НачалоДня(Спец.ДатаИзготовления) > НачалоДня(ДатаИзготовления) Тогда  
		
			Запись = Движения.ЦеховойЛимит.Добавить();
			Запись.Период = НачалоДня(Спец.ДатаИзготовления);
			Запись.Подразделение = Подразделение;
			Запись.СтоимостьУслугПлан = Спец.СуммаНарядаСпецификации;
			Запись.КоличествоКоробовПлан = Спец.КоличествоКоробов;
			Запись.КоличествоДеталейПлан = Спец.КоличествоДеталей;
			
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
	
	Ошибки = Неопределено;
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	Отказ = Отказ ИЛИ ПовторнаяПередачаВПроизводство();
	
	Если НЕ Отказ И НЕ Проведен И (РежимЗаписи = РежимЗаписиДокумента.Проведение) Тогда
		
		Для Каждого Элемент Из СписокСпецификаций Цикл
		
			Спецификация = Элемент.Спецификация;
			СтатусСпецификации = Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация);

			Если НЕ (СтатусСпецификации = Перечисления.СтатусыСпецификации.Размещен) Тогда 
					
				ТекстСообщения = "" + Спецификация + " не размещена.";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "СписокСпецификаций", ТекстСообщения);
				
			КонецЕсли;
			
		КонецЦикла;
	
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
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Процедура СписатьИсключаемыеОстатки()
	
	Движения.ОбрезкиЛистовойМатериал.Записывать = Истина;
	
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
		
		Запись = Движения.ОбрезкиЛистовойМатериал.ДобавитьРасход();
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
	
	Движения.ОбрезкиЛистовойМатериал.Записать();
			
КонецПроцедуры

Процедура СписатьОстаткиСРезерва()
	
	Движения.ОбрезкиЛистовойМатериал.Записывать = Истина;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("СписокСпецификаций", СписокСпецификаций.ВыгрузитьКолонку("Спецификация"));
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбрезкиЛистовойМатериалОстатки.Номенклатура КАК Номенклатура,
	|	ОбрезкиЛистовойМатериалОстатки.Высота КАК ВысотаОстатка,
	|	ОбрезкиЛистовойМатериалОстатки.Ширина КАК ШиринаОстатка,
	|	ОбрезкиЛистовойМатериалОстатки.КоличествоРезервОстаток КАК КоличествоРезерв,
	|	ОбрезкиЛистовойМатериалОстатки.Спецификация
	|ИЗ
	|	РегистрНакопления.ОбрезкиЛистовойМатериал.Остатки(
	|			,
	|			Подразделение = &Подразделение
	|				И Спецификация В (&СписокСпецификаций)) КАК ОбрезкиЛистовойМатериалОстатки";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Запись = Движения.ОбрезкиЛистовойМатериал.ДобавитьРасход();
		Запись.Период = Дата;
		Запись.Подразделение = Подразделение;
		Запись.Номенклатура = Выборка.Номенклатура;
		Запись.Ширина = Выборка.ШиринаОстатка;
		Запись.Высота = Выборка.ВысотаОстатка;
		Запись.КоличествоРезерв = Выборка.КоличествоРезерв;
		Запись.Спецификация = Выборка.Спецификация;
		
		Запись = Движения.ОбрезкиЛистовойМатериал.ДобавитьПриход();
		Запись.Период = Дата;
		Запись.Подразделение = Подразделение;
		Запись.Номенклатура = Выборка.Номенклатура;
		Запись.Ширина = Выборка.ШиринаОстатка;
		Запись.Высота = Выборка.ВысотаОстатка;
		Запись.Количество = Выборка.КоличествоРезерв;
		
	КонецЦикла;
	
	Движения.ОбрезкиЛистовойМатериал.Записать();
		
КонецПроцедуры

Процедура ЗаполнитьДвиженияДеловыеОстатки(Отказ, РежимПроведения)

	Движения.ОбрезкиЛистовойМатериал.Очистить();
	Движения.ОбрезкиЛистовойМатериал.Записать();
	
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
		
		Движение = Движения.ОбрезкиЛистовойМатериал.ДобавитьРасход();
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
	|	РегистрНакопления.ОбрезкиЛистовойМатериал.Остатки(, Подразделение = &Подразделение) КАК Остатки
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