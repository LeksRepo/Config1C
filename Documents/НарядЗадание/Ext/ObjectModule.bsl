﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

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
	
	Если НЕ Отказ Тогда
		
		Если Дата > Дата("20160601000000") Тогда
			УвеличитьКомплектацииСпецификаций(МассивСпецификаций);
		КонецЕсли;
		
		УвеличитьДополнительныйЛимит(МассивСпецификаций);
		Движения.Управленческий.Записывать = Истина;
		ЛексСервер.ГрупповаяСменаСтатуса(МассивСпецификаций, Перечисления.СтатусыСпецификации.ПереданВЦех, Перечисления.СтатусыСпецификации.Размещен);
		
	КонецЕсли;
	
КонецПроцедуры

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
	Отказ = ПовторнаяПередачаВПроизводство();
	
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