﻿Перем
СчетОсновноеПроизводство,
СчетГотоваяПродукция,
СчетДополнительныйЛимитЦеха,
ПВХНоменклатура,
ПВХСпецификация;

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
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
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Документы.Спецификация.ПолучитьСтатусСпецификации(Выборка.Спецификация) = Перечисления.СтатусыСпецификации.Изготовлен Тогда
				
				Документы.Спецификация.УстановитьСтатусСпецификации(Выборка.Спецификация, Перечисления.СтатусыСпецификации.ПереданВЦех);
				
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Записать();
	
	ИнициализироватьПеременные();
	
	//пропорционально списать материалы и оприходовать изделие на склад готовой продукции
	// Дт Готовая продукция Кт Основное производство
	
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", МассивСпецификаций);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпецификацияСписокНоменклатуры.Номенклатура,
	|	СУММА(СпецификацияСписокНоменклатуры.Количество) КАК Количество,
	|	СпецификацияСписокНоменклатуры.Ссылка КАК Спецификация
	|ПОМЕСТИТЬ втНоменклатура
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В(&Ссылка)
	|	И СпецификацияСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|	И НЕ СпецификацияСписокНоменклатуры.ЧерезСклад
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Номенклатура,
	|	СпецификацияСписокНоменклатуры.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНоменклатура.Номенклатура
	|ИЗ
	|	втНоменклатура КАК втНоменклатура";
	
	//	блокировка
	
	ТЗНоменклатура = Запрос.Выполнить().Выгрузить();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрБухгалтерии.Управленческий");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;	
	ЭлементБлокировки.УстановитьЗначение("Подразделение", Подразделение);
	ЭлементБлокировки.УстановитьЗначение("Счет", ПланыСчетов.Управленческий.ОсновноеПроизводство);
	ЭлементБлокировки.ИсточникДанных = ТЗНоменклатура;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура, "Номенклатура");
	Блокировка.Заблокировать();
	
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	втНоменклатура.Номенклатура КАК Номенклатура,
	|	втНоменклатура.Количество КАК Количество,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстатокДт, 0) КАК КоличествоОстаток,
	|	втНоменклатура.Спецификация,
	|	ЕСТЬNULL(УправленческийОстатки.СуммаОстатокДт, 0) КАК СуммаОстаток
	|ИЗ
	|	втНоменклатура КАК втНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				&МоментВремени,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ОсновноеПроизводство),
	|				ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконто.Номенклатура),
	|				Подразделение = &Подразделение
	|					И Субконто1 В
	|						(ВЫБРАТЬ
	|							втНоменклатура.Номенклатура
	|						ИЗ
	|							втНоменклатура)) КАК УправленческийОстатки
	|		ПО втНоменклатура.Номенклатура = УправленческийОстатки.Субконто1
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура
	|ИТОГИ
	|	СУММА(Количество),
	|	МАКСИМУМ(КоличествоОстаток)
	|ПО
	|	Номенклатура";
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.КоличествоОстаток < Выборка.Количество Тогда
			УменьшитьДополнительныйЛимит = Выборка.КоличествоОстаток;
			СписываемПропорционально = Истина;
		Иначе
			СписываемПропорционально = Ложь;
			УменьшитьДополнительныйЛимит = Выборка.Количество;
			// здесь можно накопить экономию
		КонецЕсли;
		
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.СчетКт = СчетДополнительныйЛимитЦеха;
		Проводка.СубконтоКт[ПВХНоменклатура] = Выборка.Номенклатура;
		Проводка.КоличествоКт = УменьшитьДополнительныйЛимит;
		
		ВыборкаПоСпецификациям = Выборка.Выбрать();
		
		Пока ВыборкаПоСпецификациям.Следующий() Цикл
			
			Если ВыборкаПоСпецификациям.КоличествоОстаток > 0 Тогда
				
				Если СписываемПропорционально Тогда
					КоличествоСписываемое = ВыборкаПоСпецификациям.КоличествоОстаток / Выборка.Количество * ВыборкаПоСпецификациям.Количество;
				Иначе
					КоличествоСписываемое = ВыборкаПоСпецификациям.Количество;
				КонецЕсли;
				
				СуммаСписания = КоличествоСписываемое / ВыборкаПоСпецификациям.КоличествоОстаток * ВыборкаПоСпецификациям.СуммаОстаток;
				
				Проводка = Движения.Управленческий.Добавить();
				Проводка.Период = Дата;
				Проводка.Подразделение = Подразделение;
				Проводка.СчетДт = СчетГотоваяПродукция;
				Проводка.СубконтоДт[ПВХСпецификация] = ВыборкаПоСпецификациям.Спецификация;
				Проводка.СчетКт = СчетОсновноеПроизводство;
				Проводка.СубконтоКт[ПВХНоменклатура] = ВыборкаПоСпецификациям.Номенклатура;
				Проводка.КоличествоКт = КоличествоСписываемое;
				Проводка.Сумма = СуммаСписания;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// оприходовать количество готовой продукции
	Для Каждого Элемент Из МассивСпецификаций Цикл
		
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.СчетДт = СчетГотоваяПродукция;
		Проводка.СубконтоДт[ПВХСпецификация] = Элемент;
		Проводка.КоличествоДт = 1;
		Проводка.СчетКт = СчетОсновноеПроизводство;
		Проводка.Сумма = 0;
		
		// Изменение статуса спецификации
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Элемент) = Перечисления.СтатусыСпецификации.ПереданВЦех Тогда
			Документы.Спецификация.УстановитьСтатусСпецификации(Элемент, Перечисления.СтатусыСпецификации.Изготовлен);
		КонецЕсли;
	КонецЦикла;
	
	//////////////////////////////////////////
	// уменьшить дополнительный лимит цеха
	
	//	Для каждого Строка Из СписокНоменклатуры Цикл
	//	
	//	Проводка = Движения.Управленческий.Добавить();
	//	Проводка.Период = Дата;
	//	Проводка.Подразделение = Подразделение;
	//	Проводка.СчетДт = Счет;
	
	//	Если Строка.Номенклатура.Базовый Тогда
	//		Номенклатура = Строка.Номенклатура;
	//		Количество = Строка.КоличествоТребуется;
	//	Иначе
	//		Номенклатура = Строка.Номенклатура.БазоваяНоменклатура;
	//		Количество = Строка.Номенклатура.КоэффициентБазовых;
	//	КонецЕсли;
	//		Проводка.СубконтоДт[ПВХНоменклатура] = Номенклатура;
	//		Проводка.КоличествоДт = Строка.КоличествоТребуется;
	//	
	//КонецЦикла;
	
	// начислить заработную плату цеховым ???
	
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
		
		Подразделение 	= ДанныеЗаполнения.Производство;
		СписокСпецификаций.Загрузить(ЛексСервер.ПолучитьСпецификацииПоСтатусу(Подразделение, Перечисления.СтатусыСпецификации.ПереданВЦех));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Изменение статуса спецификации
	Для Каждого Элемент Из СписокСпецификаций Цикл
		
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Элемент.Спецификация) = Перечисления.СтатусыСпецификации.Изготовлен Тогда
			
			Документы.Спецификация.УстановитьСтатусСпецификации(Элемент.Спецификация, Перечисления.СтатусыСпецификации.ПереданВЦех);
			
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ПолучитьВыпускПродукции(СсылкаСпецификация) Экспорт
	
	//МассивДокументов = ЛексСервер.НайтиПодчиненныеДокументы(СсылкаСпецификация, "Документ.ВыпускПродукции", "Спецификация");
	//Если МассивДокументов.Количество() = 1 Тогда
	//	Возврат МассивДокументов[0];
	//ИначеЕсли МассивДокументов.Количество() = 0 Тогда
	//	Возврат Документы.ВыпускПродукции.ПустаяСсылка();
	//Иначе
	//	ВызватьИсключение "Ошибка 791: Нарушена связь ""Спецификации"" и документа ""Выпуск продукции""";
	//КонецЕсли;
	
КонецФункции