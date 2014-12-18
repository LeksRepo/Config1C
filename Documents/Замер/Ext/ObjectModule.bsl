﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сотрудник", Замерщик);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГрафикВстречИЗамеров.Период,
	|	ГрафикВстречИЗамеров.Сотрудник,
	|	ГрафикВстречИЗамеров.Занят
	|ИЗ
	|	РегистрСведений.ГрафикВстречИЗамеров КАК ГрафикВстречИЗамеров
	|ГДЕ
	|	ГрафикВстречИЗамеров.Сотрудник = &Сотрудник
	|	И ГрафикВстречИЗамеров.Период = &Дата";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Текст = "Замерщик " + Замерщик + " занят " +Формат(Дата, "ДЛФ=Д") + " в " + Формат(Дата, "ДЛФ=T") + ". Выберите другое время";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, "Дата");
		Отказ = Истина;
		
	Иначе
		
		Если СуммаОплаты <> 0 И ДатаПриемаОплаты < '20140901' Тогда
			
			Движения.Управленческий.Записывать = Истина;
			
			Проводка = Движения.Управленческий.Добавить();
			Проводка.Подразделение = Подразделение;
			Проводка.Период = ДатаПриемаОплаты;
			Проводка.Сумма = СуммаОплаты;
			Проводка.Содержание = Комментарий;
			Проводка.СчетДт = ПланыСчетов.Управленческий.ОперационнаяКасса;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДДС] = Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияПрочие;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Автор.ФизическоеЛицо;
			Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыПрочие;
			
			Проводка = Движения.Управленческий.Добавить();
			Проводка.Подразделение = Подразделение;
			Проводка.Период = ДатаПриемаОплаты; // будем подумать
			Проводка.СчетДт = ПланыСчетов.Управленческий.Расходы;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходыЗарплатаЗамерыИАктивныеПродажи;
			Проводка.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
			Проводка.Сумма = СуммаОплаты;
			Проводка.Содержание = Комментарий;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Замерщик;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний] = Справочники.ВидыНачисленийУдержаний.ЗаУдаленныйЗамер;
			
		КонецЕсли;
		
		// Показатель КоличествоЗамеров
		
		Если НЕ ЗначениеЗаполнено(ПервыйЗамер) Тогда
			
			Движения.Управленческий.Записывать = Истина;
			
			Проводки = Движения.Управленческий.Добавить();
			Проводки.Период = Дата;
			Проводки.Подразделение = Подразделение;
			Проводки.СчетДт = ПланыСчетов.Управленческий.ПоказателиСотрудника;
			
			Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ВидыПоказателейСотрудников] = Перечисления.ВидыПоказателейСотрудников.КоличествоЗамеров;
			Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Агент;
			
			Проводки.Сумма = 1;
			
		КонецЕсли;
		
		// График
		
		Движения.ГрафикВстречИЗамеров.Записывать = Истина;
		
		Проводки = Движения.ГрафикВстречИЗамеров.Добавить();
		Проводки.Сотрудник = Замерщик;
		Проводки.Подразделение = Подразделение;
		Проводки.Занят = Истина;
		Проводки.Период = Дата;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Дата = НачалоЧаса(Дата);
	
	Если Дата > '2015.01.01' Тогда // Костыль.
		Отказ = Отказ ИЛИ НЕ ПроверитьЗаполнение();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	ДатаПриемаОплаты = ТекущаяДата();
	Дата = НачалоЧаса(Дата);
	
	// если вводится из обработки ЗаписьНаЗамер
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ОбработкаЗаписьНаЗамер") Тогда
		
		Замерщик = ДанныеЗаполнения.Замерщик;
		Дата = ДанныеЗаполнения.ДатаЗамера;
		Подразделение = ДанныеЗаполнения.Подразделение;
		
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
	
	Если ЭтотОбъект.АдресЗамера = "Введите адрес" Тогда
		
		ТекстСообщения = "Необходимо ввести адрес";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.АдресЗамера", ТекстСообщения);
		
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
	
	Если НЕ Документы.Замер.РольДоступняДляРедактирования() Тогда
		Если НачалоЧаса(Дата) < ТекущаяДата() Тогда
			
			Отказ 					= Истина;
			ТекстСообщения 	= "Время замера уже прошло, нельзя отказаться от замера.";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Дата");
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	///////////////////////////////////////////////////////////////////////////
	//АКТИВНОСТЬ ЗАМЕРА
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Договор.Ссылка
	|ИЗ
	|	Документ.Договор КАК Договор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Замер КАК Замер
	|		ПО Замер.Ссылка = Договор.Спецификация.ДокументОснование
	|ГДЕ
	|	Замер.Ссылка = &Ссылка";
	
	ЕстьДоговор = НЕ Запрос.Выполнить().Пустой();
	
	НаборЗаписей = РегистрыСведений.АктивностьЗамеров.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Замер.Установить(Ссылка);
	НаборЗаписей.Прочитать();
	
	Запись = ?(НаборЗаписей.Количество() = 0, НаборЗаписей.Добавить(), НаборЗаписей[0]);
	Запись.Замер = Ссылка;
	Если ЗначениеЗаполнено(ПричинаОтказа) ИЛИ ЗначениеЗаполнено(ПервыйЗамер) ИЛИ ЕстьДоговор Тогда
		Запись.Статус = Ложь;
	Иначе
		Запись.Статус = Истина;
	КонецЕсли;
	
	НаборЗаписей.Записать(); 
	
	//АКТИВНОСТЬ ЗАМЕРА
	///////////////////////////////////////////////////////////////////////////
	
КонецПроцедуры
