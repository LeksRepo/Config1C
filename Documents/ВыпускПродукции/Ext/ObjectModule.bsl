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
	ЛексСервер.ГрупповаяСменаСтатуса(Массив, Перечисления.СтатусыСпецификации.Изготовлен, Перечисления.СтатусыСпецификации.ПереданВЦех);
	
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
				Проводка.КоличествоКт = ВыборкаНоменклатура.Количество;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла; // ВыборкаСпецификация.Следующий()
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// оприходовать количество готовой продукции
	Для Каждого Строка Из СписокСпецификаций Цикл
		
		// начислить заработную плату цеховым ???
		СуммаНаряда = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Строка.Спецификация, "СуммаНарядаСпецификации");
		Если ЗначениеЗаполнено(СуммаНаряда) Тогда
			Проводка = Движения.Управленческий.Добавить();
			Проводка.Период = Дата;
			Проводка.Подразделение = Подразделение;
			Проводка.Сумма = СуммаНаряда;
			Проводка.СчетДт = ПланыСчетов.Управленческий.ЗарплатаЦеха;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Строка.Спецификация;
			Проводка.Содержание = "За " + Строка.Спецификация;
		КонецЕсли;
		
		// забалансовый счет СкладГотовойПродукции
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.Сумма = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Строка.Спецификация, "СуммаДокумента");
		Проводка.СчетДт = ПланыСчетов.Управленческий.СкладГотовойПродукции;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Строка.Спецификация;
		Проводка.КоличествоДт = 1;
		
	КонецЦикла;
	
	// Изменяем статус спецификаций.
	Массив = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	ЛексСервер.ГрупповаяСменаСтатуса(Массив, Перечисления.СтатусыСпецификации.Изготовлен, Перечисления.СтатусыСпецификации.ПереданВЦех);
	
	Движения.Управленческий.Записывать = Истина;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Спецификация") Тогда
		
		Подразделение = ДанныеЗаполнения.Производство;
		СписокСпецификаций.Загрузить(ЛексСервер.ПолучитьСпецификацииПоСтатусу(Подразделение, Перечисления.СтатусыСпецификации.ПереданВЦех));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Изменение статуса спецификации
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	ЛексСервер.ГрупповаяСменаСтатуса(МассивСпецификаций, Перечисления.СтатусыСпецификации.ПереданВЦех);
	
КонецПроцедуры