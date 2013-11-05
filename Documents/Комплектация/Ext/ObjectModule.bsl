﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Спецификация") Тогда
		
		Подразделение = ДанныеЗаполнения.Подразделение;
		Спецификация = ДанныеЗаполнения;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Спецификация 			= ЭтотОбъект.Спецификация;
	КомплектацияСсылка 	= Документы.Комплектация.ПолучитьКомплектацию(Спецификация);
	
	Если ЗначениеЗаполнено(КомплектацияСсылка) И Ссылка <> КомплектацияСсылка Тогда
		
		Отказ 					= Истина;
		ТекстСообщения 	= "К " + Спецификация + " уже введена " + КомплектацияСсылка;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, КомплектацияСсылка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Управленческий.Записать();
	
	Ошибки 						= Неопределено;
	СвойстваДокумента 	= ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Ссылка, "Подразделение, Дата");
	Склад 						= ОбщегоНазначения.ПолучитьЗначениеРеквизита(СвойстваДокумента.Подразделение, "ОсновнойСклад");
	Нехватка 					= ЛексСервер.ПеремещениеМатериаловСЛогистики(Ссылка, Движения);
	
	Для каждого СтрокаНехватки Из Нехватка Цикл
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("На складе %1 недостаточно свободного материала %2. Из требуемых %3 есть только %4", 
		Склад,
		СтрокаНехватки.Номенклатура, 
		СтрокаНехватки.КоличествоТребуется,
		СтрокаНехватки.КоличествоОстаток);
		Поле = "СписокНоменклатуры[" +Строка(СтрокаНехватки.НомерСтроки-1) + "].Количество";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстСообщения);
		
	КонецЦикла;
	
	Если Ошибки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		Возврат;
		
	КонецЕсли;
	
	Движения.Управленческий.Записывать = Истина;
	
	//Движения.Управленческий.Записать();
	//СвойстваДокумента 	= ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Ссылка, "Подразделение, Дата");
	//ВидыСубконто 			= Новый Массив;
	//ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Склады);
	//ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура);
	//
	//НехваткаМатериалов = Новый ТаблицаЗначений;
	//НехваткаМатериалов.Колонки.Добавить("Номенклатура");
	//НехваткаМатериалов.Колонки.Добавить("КоличествоТребуется");
	//НехваткаМатериалов.Колонки.Добавить("КоличествоОстаток");
	//НехваткаМатериалов.Колонки.Добавить("НомерСтроки");
	//
	//ИтогСуммаРеализации 	= 0;
	//Отказ 							= Ложь;
	//Запрос 							= Новый Запрос;
	//Запрос.Текст 					= 
	//"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//|	СписокНоменклатуры.НомерСтроки,
	//|	СписокНоменклатуры.Номенклатура,
	//|	СписокНоменклатуры.Количество,
	//|	СписокНоменклатуры.ЕдиницаИзмерения
	//|ПОМЕСТИТЬ СписокНоменклатуры
	//|ИЗ
	//|	Документ.Комплектация.СписокНоменклатуры КАК СписокНоменклатуры
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	СписокНоменклатуры.Номенклатура,
	//|	СписокНоменклатуры.Количество,
	//|	ЕСТЬNULL(УправленческийОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	//|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
	//|	СписокНоменклатуры.Количество * ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Внутренняя, 0) КАК СуммаРеализации
	//|ИЗ
	//|	СписокНоменклатуры КАК СписокНоменклатуры
	//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	//|				&МоментВремени,
	//|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	//|				&ВидыСубконто,
	//|				Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.Логистика)
	//|					И Субконто2 В
	//|						(ВЫБРАТЬ
	//|							СписокНоменклатуры.Номенклатура
	//|						ИЗ
	//|							СписокНоменклатуры)) КАК УправленческийОстатки
	//|		ПО СписокНоменклатуры.Номенклатура = УправленческийОстатки.Субконто2
	//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	//|				&МоментВремени,
	//|				Регион = &Регион
	//|					И Номенклатура В
	//|						(ВЫБРАТЬ
	//|							СписокНоменклатуры.Номенклатура
	//|						ИЗ
	//|							СписокНоменклатуры)) КАК ЦеныНоменклатурыСрезПоследних
	//|		ПО СписокНоменклатуры.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура";
	//
	//Запрос.УстановитьПараметр("Ссылка", Ссылка);
	//Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	//Запрос.УстановитьПараметр("МоментВремени", Ссылка.МоментВремени());
	//Запрос.УстановитьПараметр("Регион", Ссылка.Подразделение.Регион);
	//
	//Выборка = Запрос.Выполнить().Выбрать();
	//
	//Пока Выборка.Следующий() Цикл
	//	
	//	Если Выборка.КоличествоОстаток < Выборка.Количество Тогда
	//		
	//		НоваяСтрока 									= НехваткаМатериалов.Добавить();
	//		НоваяСтрока.Номенклатура 				= Выборка.Номенклатура;
	//		НоваяСтрока.НомерСтроки 				= Выборка.НомерСтроки;
	//		НоваяСтрока.КоличествоТребуется 	= Выборка.Количество;
	//		НоваяСтрока.КоличествоОстаток 		= Выборка.КоличествоОстаток;
	//		
	//		Отказ = Истина;
	//		
	//		Продолжить;
	//		
	//	КонецЕсли;
	//	
	//	Себестоимость 									= Выборка.Количество / Выборка.КоличествоОстаток * Выборка.СуммаОстаток;
	//	Движение 											= Движения.Управленческий.Добавить();
	//	Движение.Период 								= СвойстваДокумента.Дата;
	//	Движение.Подразделение 					= Справочники.Подразделения.Логистика;
	//	Движение.СчетКт 								= ПланыСчетов.Управленческий.МатериалыНаСкладе;
	//	Движение.СубконтоКт.Склады 				= СвойстваДокумента.Подразделение.ОсновнойСклад;
	//	Движение.СубконтоКт.Номенклатура 	= Выборка.Номенклатура;
	//	Движение.КоличествоКт 						= Выборка.Количество;
	//	Движение.СчетДт 								= ПланыСчетов.Управленческий.РасходыЛогистики;
	//	Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходыНаПроизводственныйМатериал;
	//	Движение.Сумма = Себестоимость;
	//	
	//	Движение 							= Движения.Управленческий.Добавить();
	//	Движение.Период 				= СвойстваДокумента.Дата;
	//	Движение.Подразделение 	= СвойстваДокумента.Подразделение;
	//	Движение.СчетКт 				= ПланыСчетов.Управленческий.ВзаиморасчетыСПодразделениями;
	//	Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Подразделения] = Справочники.Подразделения.Логистика;
	//	
	//	Движение.СчетДт 								= ПланыСчетов.Управленческий.ОсновноеПроизводство;
	//	Движение.СубконтоДт.Номенклатура 	= ?(Выборка.Базовый, Выборка.Номенклатура, Выборка.БазоваяНоменклатура);
	//	Движение.КоличествоДт 						= Выборка.Количество * Выборка.КоэффициентБазовых;
	//	
	//	Движение.Сумма 								= Выборка.СуммаРеализации;
	//	ИтогСуммаРеализации 						= Выборка.СуммаРеализации + ИтогСуммаРеализации;
	//	
	//КонецЦикла;
	//
	//Движение 							= Движения.Управленческий.Добавить();
	//Движение.Период 				= СвойстваДокумента.Дата;
	//Движение.Подразделение 	= Справочники.Подразделения.Логистика;
	//Движение.СчетДт 				= ПланыСчетов.Управленческий.ВзаиморасчетыСПодразделениями;
	//Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Подразделения] = СвойстваДокумента.Подразделение;
	//
	//Движение.СчетКт = ПланыСчетов.Управленческий.Доходы;
	//Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыЛогистаОтПроизводства;
	//
	//Движение.Сумма = ИтогСуммаРеализации;
	
	
КонецПроцедуры

