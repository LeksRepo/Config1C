﻿
Функция ЗамерщикСвободен()
	
	Результат = Истина;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сотрудник", Замерщик);
	Запрос.УстановитьПараметр("ДатаЗамера", ДатаЗамера);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГрафикВстречИЗамеров.Период,
	|	ГрафикВстречИЗамеров.Сотрудник,
	|	ГрафикВстречИЗамеров.Занят
	|ИЗ
	|	РегистрСведений.ГрафикВстречИЗамеров КАК ГрафикВстречИЗамеров
	|ГДЕ
	|	ГрафикВстречИЗамеров.Сотрудник = &Сотрудник
	|	И ГрафикВстречИЗамеров.Период = &ДатаЗамера";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Результат = Ложь;
		СтрокаСообщения = "Замерщик %1 уже занят %2 в %3. Выберите другое время";
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения,
		Замерщик,
		Формат(ДатаЗамера, "ДЛФ=Д"),
		Формат(ДатаЗамера, "ДЛФ=T"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения, ЭтотОбъект, "ДатаЗамера");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если НЕ ЗамерщикСвободен() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если СуммаОплаты > 0 И Дата < '20140901' Тогда
		
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
		Проводка.Период = ДатаПриемаОплаты;
		Проводка.СчетДт = ПланыСчетов.Управленческий.Расходы;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходыЗарплатаЗамерыИАктивныеПродажи;
		Проводка.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
		Проводка.Сумма = СуммаОплаты;
		Проводка.Содержание = Комментарий;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Замерщик;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний] = Справочники.ВидыНачисленийУдержаний.ЗаУдаленныйЗамер;
		
	КонецЕсли;
	
	// Показатель КоличествоЗамеров
	
	Если НЕ ЗначениеЗаполнено(ПервыйЗамер)
		И НЕ ЗначениеЗаполнено(Дилер) Тогда
		
		Движения.Управленческий.Записывать = Истина;
		
		Проводки = Движения.Управленческий.Добавить();
		Проводки.Период = ДатаЗамера;
		Проводки.Подразделение = Подразделение;
		Проводки.СчетДт = ПланыСчетов.Управленческий.ПоказателиСотрудника;
		
		Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ВидыПоказателейСотрудников] = Перечисления.ВидыПоказателейСотрудников.КоличествоЗамеров;
		Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Автор.ФизическоеЛицо;
		
		Проводки.Сумма = 1;
		
		ДвиженияПродажиФакт();
		
	КонецЕсли;
	
	// График
	
	Движения.ГрафикВстречИЗамеров.Записывать = Истина;
	
	Проводки = Движения.ГрафикВстречИЗамеров.Добавить();
	Проводки.Сотрудник = Замерщик;
	Проводки.Подразделение = Подразделение;
	Проводки.Занят = Истина;
	Проводки.Период = ДатаЗамера;
	
КонецПроцедуры

Функция ДвиженияПродажиФакт()
	
	Проводка = Движения.ПродажиФакт.Добавить();
	Движения.ПродажиФакт.Записывать = Истина;
	Проводка.Период = Дата;
	Проводка.Подразделение = Подразделение;
	Проводка.ВидПродажи = Перечисления.ВидыПродаж.Замер;
	Проводка.Сотрудник = Автор.ФизическоеЛицо;
	Проводка.Офис = Офис;
	Проводка.Количество = 1;
	
КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Не Отказ Тогда
		ДатаЗамера = НачалоЧаса(ДатаЗамера);
		Если ТипЗнч(Автор) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
			Дилер = Автор.ОбъектАвторизации;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	ДатаЗамера = НачалоДня(ТекущаяДата() + 86400) + 3600 * 14; // Завтра на 14:00
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ОбработкаЗаписьНаЗамер") Тогда
		
		Замерщик = ДанныеЗаполнения.Замерщик;
		ДатаЗамера = ДанныеЗаполнения.ДатаЗамера;
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
		Офис = ДанныеЗаполнения.Офис;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Ошибки = Неопределено;
	
	Если ЭтотОбъект.АдресЗамера = "Введите адрес" Тогда
		
		ТекстСообщения = "Укажите адрес замера";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.АдресЗамера", ТекстСообщения);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПервыйЗамер) Тогда
		
		Если АдресЗамера <> ПервыйЗамер.АдресЗамера Тогда
			ТекстСообщения = "Адрес не совпадает с адресом в основном замере (" + ПервыйЗамер.АдресЗамера + ")";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.АдресЗамера", ТекстСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Дилер) Тогда
		ПроверяемыеРеквизиты.Добавить("ОткудаПришел");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если НЕ Документы.Замер.РольДоступняДляРедактирования() Тогда
		Если НачалоЧаса(ДатаЗамера) < ТекущаяДата() Тогда
			
			Отказ 					= Истина;
			ТекстСообщения 	= "Время замера уже прошло, нельзя отказаться от замера.";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаЗамера");
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Дилер) Тогда
		
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
		
	КонецЕсли;
	
	//АКТИВНОСТЬ ЗАМЕРА
	///////////////////////////////////////////////////////////////////////////
	
КонецПроцедуры
