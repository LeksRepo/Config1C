﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.Управленческий.Записать();
	
	// { Васильев Александр Леонидович [16.10.2013]
	// блокировку бы...
	// } Васильев Александр Леонидович [16.10.2013]
	
	Запрос 			= Новый Запрос;
	Запрос.Текст 	= 
	"ВЫБРАТЬ
	|	МИНИМУМ(РеализацияМатериаловСписокНоменклатуры.НомерСтроки) КАК НомерСтроки,
	|	РеализацияМатериаловСписокНоменклатуры.Номенклатура,
	|	СУММА(РеализацияМатериаловСписокНоменклатуры.Количество) КАК Количество,
	|	СУММА(РеализацияМатериаловСписокНоменклатуры.Сумма) КАК Сумма
	|ПОМЕСТИТЬ тчДок
	|ИЗ
	|	Документ.РеализацияМатериалов.СписокНоменклатуры КАК РеализацияМатериаловСписокНоменклатуры
	|ГДЕ
	|	РеализацияМатериаловСписокНоменклатуры.Ссылка = &Ссылка
	|	И (РеализацияМатериаловСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|			ИЛИ РеализацияМатериаловСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Комплект))
	|
	|СГРУППИРОВАТЬ ПО
	|	РеализацияМатериаловСписокНоменклатуры.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	тчДок.НомерСтроки,
	|	тчДок.Номенклатура,
	|	тчДок.Количество,
	|	тчДок.Сумма КАК Сумма,
	|	ЕСТЬNULL(УправленческийОстатки.СуммаОстаток, 0) КАК СтоимостьОстаток,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток
	|ИЗ
	|	тчДок КАК тчДок
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				&МоментВремени,
	|				,
	|				,
	|				Субконто1 = &Склад
	|					И Субконто2 В
	|						(ВЫБРАТЬ
	|							т.Номенклатура
	|						ИЗ
	|							тчДок КАК т)) КАК УправленческийОстатки
	|		ПО тчДок.Номенклатура = УправленческийОстатки.Субконто2
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	ОБЩИЕ";
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Пока Выборка.Следующий() Цикл
		
		СуммаПоДокументу 	= Выборка.Сумма;
		ДетальныеЗаписи 	= Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		
		Пока ДетальныеЗаписи.Следующий() Цикл
			
			Если ДетальныеЗаписи.Количество > ДетальныеЗаписи.КоличествоОстаток Тогда
				
				Сообщение 			= Новый СообщениеПользователю;
				Сообщение.Текст 	="На складе """ + Склад + """ недостаточно свободного товара """ + ДетальныеЗаписи.Номенклатура + 
					""". Из требуемых " + ДетальныеЗаписи.Количество + " есть только " + ДетальныеЗаписи.КоличествоОстаток;
				Сообщение.Поле 	= "СписокНоменклатуры[" + (ДетальныеЗаписи.НомерСтроки-1) + "].Количество";
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Сообщить();
				
				Отказ = Истина;
				Продолжить;
				
			КонецЕсли;
			
			Если ДетальныеЗаписи.КоличествоОстаток <> 0 Тогда
				Себестоимость = ДетальныеЗаписи.Количество / ДетальныеЗаписи.КоличествоОстаток * ДетальныеЗаписи.СтоимостьОстаток;
			Иначе
				Себестоимость = 0;
			КонецЕсли;
				
			Проводки 							= Движения.Управленческий.Добавить();
			Проводки.Период 				= Дата;
			Проводки.Подразделение 	= Справочники.Подразделения.Логистика;
			Проводки.СчетДт 				=ПланыСчетов.Управленческий.РасходыЛогистики;
			Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] 			= Справочники.СтатьиДоходовРасходов.РасходыСебестоимостьРеализованногоМатериала;
			Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] 	= ДетальныеЗаписи.Номенклатура;
			Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Склады] 				= Ссылка.Склад;
			
			Проводки.СчетКт 				= ПланыСчетов.Управленческий.МатериалыНаСкладе;
			Проводки.КоличествоКт 		= ДетальныеЗаписи.Количество;
			Проводки.Сумма 				= Себестоимость;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если НЕ Отказ Тогда
		Проводки = Движения.Управленческий.Добавить();
		Проводки.Период = Дата;
		Проводки.Подразделение = Справочники.Подразделения.Логистика;
		Проводки.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
		Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = Контрагент;
		Проводки.СчетКт = ПланыСчетов.Управленческий.Доходы;
		Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыОтРеализацииМатериалов;
		Проводки.Сумма = СуммаПоДокументу;
		
		Проводки = Движения.Управленческий.Добавить();
		Проводки.Период = Дата;
		Проводки.Подразделение = Справочники.Подразделения.Логистика;
		Проводки.СчетДт = ПланыСчетов.Управленческий.ОперационнаяКасса;
		Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Ссылка.Автор.ФизическоеЛицо;
		Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДДС] = Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтРеализацииМатериалов;
		Проводки.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
		Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = Контрагент;
		Проводки.Сумма = СуммаПоДокументу;
		
		Движения.Управленческий.Записывать = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	СуммаДокумента = СписокНоменклатуры.Итог("Сумма");
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Подразделение = Справочники.Подразделения.Логистика;
	
КонецПроцедуры
