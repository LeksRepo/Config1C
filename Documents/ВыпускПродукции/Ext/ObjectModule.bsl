﻿
Функция СуммаНарядовСпецификации(МассивСпецификаций)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Спецификация.СуммаНарядаСпецификации КАК Сумма
	|ИЗ
	|	Документ.Спецификация КАК Спецификация
	|ГДЕ
	|	Спецификация.Ссылка В(&МассивСпецификаций)
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	ОБЩИЕ";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Выборка.Следующий();
	
	Возврат Выборка.Сумма;
	
КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	// проверка повторного ввода спецификаций
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВыпускПродукцииСписокСпецификаций.Ссылка
	|ИЗ
	|	Документ.ВыпускПродукции.СписокСпецификаций КАК ВыпускПродукцииСписокСпецификаций
	|ГДЕ
	|	ВыпускПродукцииСписокСпецификаций.Спецификация В(&МассивСпецификаций)
	|	И ВыпускПродукцииСписокСпецификаций.Ссылка <> &Ссылка";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		
		// Сделать.
		// Сообщить какие спец. в каких выпусках уже встречаются.
		// Привязать к нужной строке.
		
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Уже есть Выпуск продукции к некоторым спецификациям", ЭтотОбъект, "Номер");
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// { Васильев Александр Леонидович [18.05.2015]
	// Если удалили какие-то спецификации из документа.
	// } Васильев Александр Леонидович [18.05.2015]
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВыпускПродукцииСписокСпецификаций.Спецификация КАК Спецификация
	|ИЗ
	|	Документ.ВыпускПродукции.СписокСпецификаций КАК ВыпускПродукцииСписокСпецификаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО ВыпускПродукцииСписокСпецификаций.Спецификация = СтатусСпецификацииСрезПоследних.Спецификация
	|ГДЕ
	|	НЕ ВыпускПродукцииСписокСпецификаций.Спецификация В (&МассивСпецификаций)
	|	И ВыпускПродукцииСписокСпецификаций.Ссылка = &Ссылка
	|	И СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Изготовлен)";
	
	Результат = Запрос.Выполнить();
	Массив = Результат.Выгрузить().ВыгрузитьКолонку("Спецификация");
	ЛексСервер.ГрупповаяСменаСтатуса(Массив, Перечисления.СтатусыСпецификации.ПереданВЦех);
	
	СуммаДокумента = СуммаНарядовСпецификации(МассивСпецификаций);
	КоличествоСпецификаций = СписокСпецификаций.Количество();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Ошибки = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВыпускПродукцииСписокСпецификаций.Спецификация КАК Спецификация,
	|	ВЫБОР
	|		КОГДА ВыпускПродукцииСписокСпецификаций.Спецификация.ТребуетсяКомплектация
	|					И Комплектация.Проведен
	|				ИЛИ НЕ ВыпускПродукцииСписокСпецификаций.Спецификация.ТребуетсяКомплектация
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПроведенаКомплектация
	|ПОМЕСТИТЬ СписокСпецификаций
	|ИЗ
	|	Документ.ВыпускПродукции.СписокСпецификаций КАК ВыпускПродукцииСписокСпецификаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Комплектация КАК Комплектация
	|		ПО ВыпускПродукцииСписокСпецификаций.Спецификация = Комплектация.Спецификация
	|ГДЕ
	|	ВыпускПродукцииСписокСпецификаций.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпецификацияСписокНоменклатуры.Ссылка КАК Спецификация,
	|	СпецификацияСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СпецификацияСписокНоменклатуры.Количество,
	|	СписокСпецификаций.ПроведенаКомплектация КАК ПроведенаКомплектация
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ СписокСпецификаций КАК СписокСпецификаций
	|		ПО СпецификацияСписокНоменклатуры.Ссылка = СписокСпецификаций.Спецификация
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В
	|			(ВЫБРАТЬ
	|				СписокСпецификаций.Спецификация
	|			ИЗ
	|				СписокСпецификаций)
	|	И СпецификацияСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|	И НЕ СпецификацияСписокНоменклатуры.ПредоставитЗаказчик
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	Спецификация
	|ИТОГИ
	|	МАКСИМУМ(ПроведенаКомплектация)
	|ПО
	|	Спецификация";
	
	ВыборкаСпецификация = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСпецификация.Следующий() Цикл
		
		Если Дата > '2015.01.15' И НЕ ВыборкаСпецификация.ПроведенаКомплектация Тогда // костыль
			
			Отказ = Истина; // Чтобы ниже списание не происходило.
			
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Отсутствует комплектация для %1", ВыборкаСпецификация.Спецификация);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , СтрокаСообщения);
			
		КонецЕсли;
		
		Если НЕ Отказ Тогда
			
			// Списание материалов с цеха и уменьшение дополнительного лимита.
			ВыборкаНоменклатура = ВыборкаСпецификация.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаНоменклатура.Следующий() Цикл
				
				Проводка = Движения.Управленческий.Добавить();
				Проводка.Период = Дата;
				Проводка.Содержание = "Списание материалов с цеха по " + ВыборкаСпецификация.Спецификация;
				Проводка.Подразделение = Подразделение;
				Проводка.Сумма = 0;
				Проводка.СчетДт = ПланыСчетов.Управленческий.ВспомогательныйСчет;
				
				Проводка.СчетКт = ПланыСчетов.Управленческий.ОсновноеПроизводство;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = ВыборкаНоменклатура.Номенклатура;
				Проводка.КоличествоКт = ВыборкаНоменклатура.Количество;
				
				Проводка = Движения.Управленческий.Добавить();
				Проводка.Период = Дата;
				Проводка.Подразделение = Подразделение;
				Проводка.СчетКт = ПланыСчетов.Управленческий.ДополнительныйЛимитЦеха;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = ВыборкаНоменклатура.Номенклатура;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Спецификации] = ВыборкаНоменклатура.Спецификация;
				Проводка.КоличествоКт = ВыборкаНоменклатура.Количество;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла; // ВыборкаСпецификация.Следующий()
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из СписокСпецификаций Цикл
		
		Если Строка.Спецификация.Изделие.Серийное Тогда
			Продолжить;
		КонецЕсли;
		
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.Сумма = Строка.Спецификация.ЗабалансоваяСтоимость;
		Проводка.СчетДт = ПланыСчетов.Управленческий.СкладГотовойПродукции;
		Проводка.КоличествоДт = 1;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ДокументВзаиморасчетов] = Строка.Спецификация;
		
	КонецЦикла;
	
	ИзменитьСтатусыСпецификаций();
	ОприходоватьСерийныеНаСклад();
	НачислитьЗарплатуЦеху();
	
	Движения.Управленческий.Записывать = Истина;
	
КонецПроцедуры

Функция ИзменитьСтатусыСпецификаций()
	
	МассивИзготовлен = Новый Массив;
	МассивСерийные = Новый Массив;
	
	// Изменяем статус спецификаций.
	Для каждого Строка Из СписокСпецификаций Цикл
		
		Если Строка.Спецификация.Изделие.Серийное Тогда
			МассивСерийные.Добавить(Строка.Спецификация);
		Иначе
			МассивИзготовлен.Добавить(Строка.Спецификация);
		КонецЕсли;
		
	КонецЦикла;
	
	ЛексСервер.ГрупповаяСменаСтатуса(МассивИзготовлен, Перечисления.СтатусыСпецификации.Изготовлен, Перечисления.СтатусыСпецификации.ПереданВЦех);
	ЛексСервер.ГрупповаяСменаСтатуса(МассивСерийные, Перечисления.СтатусыСпецификации.Отгружен, Перечисления.СтатусыСпецификации.ПереданВЦех);
	
КонецФункции

Функция ОприходоватьСерийныеНаСклад()
	
	тзИзделия = Новый ТаблицаЗначений;
	тзИзделия.Колонки.Добавить("Номенклатура");
	тзИзделия.Колонки.Добавить("Количество");
	
	Для каждого СтрокаСпецификация Из СписокСпецификаций Цикл
		
		ТабличнаяЧасть = СтрокаСпецификация.Спецификация.СписокСерийныхИзделий;
		
		Для каждого СтрокаСерийноеИзделие Из ТабличнаяЧасть Цикл
			
			НоваяСтрока = тзИзделия.Добавить();
			НоваяСтрока.Номенклатура = СтрокаСерийноеИзделие.Номенклатура;
			НоваяСтрока.Количество = СтрокаСерийноеИзделие.Количество;
			
		КонецЦикла;
		
	КонецЦикла;
	
	тзИзделия.Свернуть("Номенклатура", "Количество");
	
	Для каждого Строка Из тзИзделия Цикл
		
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.СчетДт = ПланыСчетов.Управленческий.МатериалыНаСкладе;
		Проводка.КоличествоДт = Строка.Количество;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = Подразделение.ОсновнойСклад;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Строка.Номенклатура;
		
		Проводка.СчетКт = ПланыСчетов.Управленческий.ВспомогательныйСчет;
		
	КонецЦикла;
	
КонецФункции

Процедура НачислитьЗарплатуЦеху()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивСпецификаций", СписокСпецификаций.ВыгрузитьКолонку("Спецификация"));
	Запрос.Текст=
	"ВЫБРАТЬ
	|	Список.Ссылка КАК Спецификация,
	|	Список.Номенклатура КАК Номенклатура,
	|	СУММА(Список.Количество) КАК Количество,
	|	СУММА(Список.ЗарплатаЦеха) КАК Сумма
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК Список
	|ГДЕ
	|	Список.Ссылка В(&МассивСпецификаций)
	|	И Список.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Услуга)
	|	И Список.Номенклатура.ЦеховаяЗона <> ЗНАЧЕНИЕ(Перечисление.ЦеховыеЗоны.ВнешниеУслуги)
	|	И Список.ЗарплатаЦеха > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	Список.Номенклатура,
	|	Список.Ссылка";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Проводка = Движения.Управленческий.Добавить();
			Проводка.Период = Дата;
			Проводка.Подразделение = Подразделение;
			Проводка.Сумма = Выборка.Сумма;
			Проводка.СчетДт = ПланыСчетов.Управленческий.ЗарплатаЦеха;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ДокументВзаиморасчетов] = Выборка.Спецификация;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Выборка.Номенклатура;
			Проводка.КоличествоДт = Выборка.Количество;
			Проводка.Содержание = "За " + Выборка.Спецификация;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Спецификация") Тогда
		
		Подразделение = ДанныеЗаполнения.Подразделение;
		СписокСпецификаций.Загрузить(ЛексСервер.ПолучитьСпецификацииПоСтатусу(Подразделение, Перечисления.СтатусыСпецификации.ПереданВЦех));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Изменение статуса спецификации
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	ЛексСервер.ГрупповаяСменаСтатуса(МассивСпецификаций, Перечисления.СтатусыСпецификации.ПереданВЦех);
	
КонецПроцедуры