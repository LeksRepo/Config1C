﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сотрудник", Замерщик);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГрафикЗамеров.Период,
	|	ГрафикЗамеров.Сотрудник,
	|	ГрафикЗамеров.Занят
	|ИЗ
	|	РегистрСведений.ГрафикЗамеров КАК ГрафикЗамеров
	|ГДЕ
	|	ГрафикЗамеров.Сотрудник = &Сотрудник
	|	И ГрафикЗамеров.Период = &Дата";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Текст = "Замерщик " + Замерщик + " занят " +Формат(Дата, "ДЛФ=Д") + " в " + Формат(Дата, "ДЛФ=T") + ". Выберите другое время";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, "Дата");
		Отказ = Истина;
		
	Иначе
		
		Движения.Управленческий.Записывать = Истина;
		
		Проводки 							= Движения.ГрафикЗамеров.Добавить();
		Проводки.Сотрудник 			= Замерщик;
		Проводки.Подразделение 	= Подразделение;
		Проводки.Занят 					= Истина;
		Проводки.Период 				= Дата;
		
		Проводка 							= Движения.Управленческий.Добавить();
		Проводка.Подразделение 	= Подразделение;
		Проводка.Период 				= Дата;
		Проводка.Сумма		 			= 1;
		Проводка.СчетДт 				= ПланыСчетов.Управленческий.ПоказателиСотрудника;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ВидыПоказателейСотрудников] = Перечисления.ВидыПоказателейСотрудников.КоличествоЗамеров;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Автор.ФизическоеЛицо;
		
		Если СуммаОплаты <> 0 Тогда
			
			Проводка 							= Движения.Управленческий.Добавить();
			Проводка.Подразделение 	= Подразделение;
			Проводка.Период 				= ДатаПриемаОплаты;
			Проводка.Сумма		 			= СуммаОплаты;
			Проводка.Содержание			= Комментарий;
			Проводка.СчетДт 				= ПланыСчетов.Управленческий.ОперационнаяКасса;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДДС] = Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияПрочие;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Автор.ФизическоеЛицо;
			Проводка.СчетКт 				= ПланыСчетов.Управленческий.Доходы;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыПрочие;
			
			Проводка 							= Движения.Управленческий.Добавить();
			Проводка.Подразделение 	= Подразделение;
			Проводка.Период 				= ДатаПриемаОплаты; // будем подумать
			Проводка.СчетДт 				= ПланыСчетов.Управленческий.РасходыРозничнойСети;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходыЗарплатаЗамерыИАктивныеПродажи;
			Проводка.СчетКт 				= ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
			Проводка.Сумма		 			= СуммаОплаты;
			Проводка.Содержание			= Комментарий;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Замерщик;
			
		КонецЕсли;
		
		
		Движения.ГрафикЗамеров.Записывать = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Отказ = НЕ ПроверитьЗаполнение();
	Дата = НачалоЧаса(Дата);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)                       
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	ДатаПриемаОплаты 	= ТекущаяДата();
	Дата 							= НачалоЧаса(Дата);
	
	// если вводится из обработки ЗаписьНаЗамер
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ОбработкаЗаписьНаЗамер") Тогда
		
		Замерщик 			= ДанныеЗаполнения.Замерщик;
		Дата 					= ДанныеЗаполнения.ДатаЗамера;
		Подразделение 	= ДанныеЗаполнения.Подразделение;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Замер") Тогда	
		
		ПервыйЗамер = ?(ЗначениеЗаполнено(ДанныеЗаполнения.ПервыйЗамер), ДанныеЗаполнения.ПервыйЗамер, ДанныеЗаполнения.Ссылка);
		
		Подразделение = ДанныеЗаполнения.Подразделение;
		ИмяЗаказчика = ДанныеЗаполнения.ИмяЗаказчика;
		ОткудаПришел = ДанныеЗаполнения.ОткудаПришел;
		АдресЗамера = ДанныеЗаполнения.АдресЗамера;
		Километраж = ДанныеЗаполнения.Километраж;
		Замерщик = ДанныеЗаполнения.Замерщик;
		Телефон = ДанныеЗаполнения.Телефон;
		Агент = ДанныеЗаполнения.Агент;
		Офис = ДанныеЗаполнения.Офис;
		
	КонецЕсли;                               
	                                         
	//срабатывает подписка                  
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Ошибки = Неопределено;
	
	Если СуммаОплаты <> 0 И НЕ ЗначениеЗаполнено(ДатаПриемаОплаты) Тогда
		ТекстСообщения = "Заполните дату приема оплаты";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДатаПриемаОплаты", ТекстСообщения);	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПервыйЗамер) Тогда
		
		Если Агент <> ПервыйЗамер.Агент Тогда
			ТекстСообщения = "Агент не совпадает с агентом в основном замере (" + ПервыйЗамер.Агент + ")";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Агент", ТекстСообщения);	
		КонецЕсли;
		
		Если АдресЗамера <> ПервыйЗамер.АдресЗамера Тогда
			ТекстСообщения = "Адрес не совпадает с адресом в основном замере (" + ПервыйЗамер.АдресЗамера + ")";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.АдресЗамера", ТекстСообщения);	
		КонецЕсли;
		
	КонецЕсли;
	
	Если Ошибки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		Возврат;
		
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если НачалоЧаса(Дата) < ТекущаяДата() Тогда
		
		Отказ 					= Истина;
		ТекстСообщения 	= "Время замера уже прошло, нельзя отказаться от замера.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Дата");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	///////////////////////////////////////////////////////////////////////////
	//АКТИВНОСТЬ ЗАМЕРА
	
	НаборЗаписей = РегистрыСведений.АктивностьЗамеров.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Замер.Установить(Ссылка);		
	НаборЗаписей.Прочитать();                   
	
	Запись = ?(НаборЗаписей.Количество() = 0, НаборЗаписей.Добавить(), НаборЗаписей[0]);
	Запись.Замер = Ссылка;                                   
	Если ЗначениеЗаполнено(ПричинаОтказа) ИЛИ ЗначениеЗаполнено(ПервыйЗамер) Тогда
		Запись.Статус = Ложь;
	Иначе
		Запись.Статус = Истина;
	КонецЕсли;
	
	НаборЗаписей.Записать(); 
	
	//АКТИВНОСТЬ ЗАМЕРА
	///////////////////////////////////////////////////////////////////////////
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ