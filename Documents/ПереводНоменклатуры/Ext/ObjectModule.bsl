﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Записать();
	
	// Блокировку
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(ПереводНоменклатурыСписокНоменклатуры.НомерСтроки) КАК НомерСтроки,
	|	СУММА(ПереводНоменклатурыСписокНоменклатуры.КоличествоОтправляемое) КАК КоличествоОтправляемое,
	|	СУММА(ПереводНоменклатурыСписокНоменклатуры.КоличествоПолучаемое) КАК КоличествоПолучаемое,
	|	ПереводНоменклатурыСписокНоменклатуры.НоменклатураИсточник,
	|	ПереводНоменклатурыСписокНоменклатуры.НоменклатураПолучатель
	|ПОМЕСТИТЬ втСписокНоменклатуры
	|ИЗ
	|	Документ.ПереводНоменклатуры.СписокНоменклатуры КАК ПереводНоменклатурыСписокНоменклатуры
	|ГДЕ
	|	ПереводНоменклатурыСписокНоменклатуры.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПереводНоменклатурыСписокНоменклатуры.НоменклатураПолучатель,
	|	ПереводНоменклатурыСписокНоменклатуры.НоменклатураИсточник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втСписокНоменклатуры.НомерСтроки,
	|	втСписокНоменклатуры.КоличествоОтправляемое,
	|	втСписокНоменклатуры.КоличествоПолучаемое,
	|	втСписокНоменклатуры.НоменклатураИсточник,
	|	втСписокНоменклатуры.НоменклатураПолучатель,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстатокДт, 0) КАК КоличествоОстаток,
	|	ЕСТЬNULL(УправленческийОстатки.СуммаОстатокДт, 0) КАК СуммаОстаток
	|ИЗ
	|	втСписокНоменклатуры КАК втСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				&МоментВремени,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто1 = &Склад
	|					И Субконто2 В
	|						(ВЫБРАТЬ
	|							втСписокНоменклатуры.НоменклатураИсточник
	|						ИЗ
	|							втСписокНоменклатуры)) КАК УправленческийОстатки
	|		ПО втСписокНоменклатуры.НоменклатураИсточник = УправленческийОстатки.Субконто2";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Ошибки = Неопределено;
	
	Пока Выборка.Следующий() Цикл
		
		Нехватка = Выборка.КоличествоОтправляемое - Выборка.КоличествоОстаток;
		Если Нехватка > 0 Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("На складе %1 недостаточно %2 ед. материала %3", Склад, Нехватка, Выборка.НоменклатураИсточник);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.СписокНоменклатуры[%1].КоличествоОтправляемое", ТекстОшибки,,Выборка.НомерСтроки-1);
			
		КонецЕсли;
		
		Если Ошибки = Неопределено Тогда
			
			Если Выборка.КоличествоОстаток <> 0 Тогда
				Себестоимость = Выборка.КоличествоОтправляемое / Выборка.КоличествоОстаток * Выборка.СуммаОстаток;
			Иначе
				Себестоимость = 0;
			КонецЕсли;
			
			Проводка = Движения.Управленческий.Добавить();
			Проводка.Подразделение = Подразделение;
			Проводка.Период = Дата;
			Проводка.Сумма = Себестоимость;
			Проводка.СчетДт = ПланыСчетов.Управленческий.МатериалыНаСкладе;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = Склад;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Выборка.НоменклатураПолучатель;
			Проводка.КоличествоДт = Выборка.КоличествоПолучаемое;
			
			Проводка.СчетКт = ПланыСчетов.Управленческий.МатериалыНаСкладе;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = Склад;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Выборка.НоменклатураИсточник;
			Проводка.КоличествоКт = Выборка.КоличествоОтправляемое;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если НЕ Отказ Тогда
		Движения.Управленческий.Записывать = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если СданВАрхив Тогда
		
		ДоступноПринятие = ЛексСервер.ДоступноПринятиеБухгалтером(Ссылка);
	
		Если НЕ ДоступноПринятие Тогда
			
		   Сообщить("Документ сдан в архив. Обратитесь в бухгалтерию.");
		   Отказ = Истина;
		   
	    КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры