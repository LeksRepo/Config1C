﻿Перем
СчетОсновноеПроизводство,
СчетГотоваяПродукция,
СчетДополнительныйЛимитЦеха,
ПВХНоменклатура,
ПВХСпецификация;

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВыпускПродукцииСписокСпецификаций.Спецификация
	|ИЗ
	|	Документ.ВыпускПродукции.СписокСпецификаций КАК ВыпускПродукцииСписокСпецификаций
	|ГДЕ
	|	НЕ ВыпускПродукцииСписокСпецификаций.Спецификация В (&МассивСпецификаций)
	|	И ВыпускПродукцииСписокСпецификаций.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Выборка.Спецификация) = Перечисления.СтатусыСпецификации.Изготовлен Тогда
			Документы.Спецификация.УстановитьСтатусСпецификации(Выборка.Спецификация, Перечисления.СтатусыСпецификации.ПереданВЦех);
		КонецЕсли;
	КонецЦикла;
	
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
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Уже есть Выпуск продукции к некоторым спецификациям", ЭтотОбъект, "Номер");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Ошибки = Неопределено;
	ИнициализироватьПеременные();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВыпускПродукцииСписокСпецификаций.Спецификация КАК Спецификация,
	|	ЕСТЬNULL(Комплектация.Проведен, ЛОЖЬ) КАК ПроведенаКомплектация
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
			
			// { Васильев Александр Леонидович [13.01.2015]
			// Миш, сделай красивее.
			// Плохо проверять каждую спецификацию на наличие комплектации.
			// } Васильев Александр Леонидович [13.01.2015]
			
			Отказ = Истина;
			
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Проведите Комплектацию для %1", ВыборкаСпецификация.Спецификация);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , СтрокаСообщения);
			
		КонецЕсли;
		
		Если НЕ Отказ Тогда
			
			// Списание материалов с цеха и уменьшение дополнительного лимита.
			ВыборкаНоменклатура = ВыборкаСпецификация.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаНоменклатура.Следующий() Цикл
				
				Проводка = Движения.Управленческий.Добавить();
				Проводка.Период = Дата;
				Проводка.Содержание = "Списание материалов по " + ВыборкаСпецификация.Спецификация;
				Проводка.Подразделение = Подразделение;
				Проводка.Сумма = 0;
				Проводка.СчетДт = СчетГотоваяПродукция;
				Проводка.СубконтоДт[ПВХСпецификация] = ВыборкаСпецификация.Спецификация;
				
				Проводка.СчетКт = СчетОсновноеПроизводство;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = ВыборкаНоменклатура.Номенклатура;
				Проводка.КоличествоКт = ВыборкаНоменклатура.Количество;
				
				Проводка = Движения.Управленческий.Добавить();
				Проводка.Период = Дата;
				Проводка.Подразделение = Подразделение;
				Проводка.СчетКт = СчетДополнительныйЛимитЦеха;
				Проводка.СубконтоКт[ПВХНоменклатура] = ВыборкаНоменклатура.Номенклатура;
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
			Проводка.СубконтоДт[ПВХСпецификация] = Строка.Спецификация;
			Проводка.Содержание = "За " + Строка.Спецификация;
		КонецЕсли;
		
		// забалансовый счет СкладГотовойПродукции
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.Сумма = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Строка.Спецификация, "ВнутренняяСтоимостьСпецификации");
		Проводка.СчетДт = ПланыСчетов.Управленческий.СкладГотовойПродукции;
		Проводка.СубконтоДт[ПВХСпецификация] = Строка.Спецификация;
		Проводка.КоличествоДт = 1;
		
		// Изменение статуса спецификации
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Строка.Спецификация) = Перечисления.СтатусыСпецификации.ПереданВЦех Тогда
			Документы.Спецификация.УстановитьСтатусСпецификации(Строка.Спецификация, Перечисления.СтатусыСпецификации.Изготовлен);
		КонецЕсли;
		
	КонецЦикла;
	
	Движения.Управленческий.Записывать = Истина;
	
КонецПроцедуры

Функция ИнициализироватьПеременные()
	
	СчетОсновноеПроизводство = ПланыСчетов.Управленческий.ОсновноеПроизводство;
	СчетГотоваяПродукция = ПланыСчетов.Управленческий.ГотоваяПродукция;
	ПВХНоменклатура = ПланыВидовХарактеристик.ВидыСубконто.Номенклатура;
	ПВХСпецификация = ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор;
	СчетДополнительныйЛимитЦеха = ПланыСчетов.Управленческий.ДополнительныйЛимитЦеха;
	
КонецФункции

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
