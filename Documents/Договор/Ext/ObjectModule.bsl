﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// совпадает ли сумма договора
	// с внесёнными рассрочками и платежами
	
	// проверка на оплату 50% от договора
	
	Если НЕ Контрагент.ЮридическоеЛицо Тогда
		
		ПредоплатаКредит = ВидОплатыДоговора = Перечисления.ВидыОплатыДоговоров.Предоплата50БанковскийКредит;
		
		Если ВидОплатыДоговора = Перечисления.ВидыОплатыДоговоров.Рассрочка1Месяц ИЛИ ВидОплатыДоговора = Перечисления.ВидыОплатыДоговоров.Рассрочка4Месяца ИЛИ ПредоплатаКредит Тогда
			
			ПоловинаСуммыДоговора = Окр(СуммаДокумента / 2);
			СуммаАванса = Документы.Договор.ПолучитьСуммуАванса(Ссылка);
			
			Если НЕ ПредоплатаКредит И СуммаАванса < ПоловинаСуммыДоговора Тогда
				
				Текст = "Оплата, при заключении договора, сумма аванса должна составлять не менее 50% от суммы договора (" + ПоловинаСуммыДоговора + " руб.)";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, "СуммаДокумента");
				Отказ = Истина;
				
			ИначеЕсли ПредоплатаКредит И СуммаАванса <> ПоловинаСуммыДоговора Тогда
				
				Текст = "Оплата, при заключении договора, должна составлять РОВНО 50% от суммы договора (" + ПоловинаСуммыДоговора + " руб.)";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, "СуммаДокумента");
				Отказ = Истина;
				
			КонецЕсли;
			
			Если НЕ (ЗначениеЗаполнено(Контрагент.ПаспортНомер) И ЗначениеЗаполнено(Контрагент.ПаспортКемВыдан)
				И ЗначениеЗаполнено(Контрагент.ПаспортДатаВыдачи)) Тогда
				
				Текст = "Паспортные данные должны быть заполнены у контрагента - " + Контрагент;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, "Контрагент");
				Отказ = Истина;
				
			КонецЕсли;
			
		ИначеЕсли ВидОплатыДоговора = Перечисления.ВидыОплатыДоговоров.ПолнаяПредоплата Тогда
			
			// проверка на оплату 100% от договора
			
			Если Документы.Договор.ПолучитьСуммуАванса(Ссылка) < СуммаДокумента Тогда
				
				Текст = "Оплата, при заключении договора, должна составлять 100% от суммы договора (" + СуммаДокумента + " руб.)";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, "СуммаДокумента");
				Отказ = Истина;
				
			КонецЕсли;
			
		КонецЕсли;	
		
	КонецЕсли; // НЕ Контрагент.ЮридическоеЛицо
	
	Движения.Управленческий.Записывать = Истина;
	
	Спецификация 		= ОбщегоНазначения.ПолучитьЗначениеРеквизита(ЭтотОбъект.Ссылка, "Спецификация");
	УслугаМонтаж 		= ОбщегоНазначения.ПолучитьЗначениеРеквизита(Спецификация, "УслугаМонтаж");
	ДокументМонтаж 	= Документы.Спецификация.ПолучитьМонтаж(Спецификация);
	
	Если УслугаМонтаж и ДокументМонтаж = Документы.Монтаж.ПустаяСсылка() Тогда
		
		Монтаж 							= Документы.Монтаж.СоздатьДокумент();
		Монтаж.Спецификация 	= Спецификация;
		Монтаж.ДатаМонтажа 		= Спецификация.ДатаМонтажа;
		Монтаж.Дата					= ?(ЗначениеЗаполнено(Спецификация.ДатаДоставки), Спецификация.ДатаДоставки, ТекущаяДата());
		Монтаж.Подразделение 	= Спецификация.Производство;
		Монтаж.Записать(РежимЗаписиДокумента.Проведение);
		
	КонецЕсли;
	
	ЛексСервер.СформироватьПоказателиСотрудников(Движения, Ссылка);
	
	// Изменение статуса договора
	
	Статус = Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация);
	
	Если Статус = Перечисления.СтатусыСпецификации.Проверен 
		ИЛИ Статус = Перечисления.СтатусыСпецификации.Сохранен
		ИЛИ Статус = Перечисления.СтатусыСпецификации.ПроверяетсяИнженером Тогда
		
		Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Рассчитывается);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПоказателиДизайнера()

	ПоказательКоличествоДоговоров = Перечисления.ВидПоказателяСотрудника.КоличествоДоговоров;
	ПоказательСуммаЗаключенныхДоговоров = Перечисления.ВидПоказателяСотрудника.СтоимостьДоговоров;

	СформироватьПоказатель(Движения, Автор.ФизЛицо, СуммаДокумента - СуммаДокумента * ПроцентПоделиться / 100, ПоказательСуммаЗаключенныхДоговоров);
	СформироватьПоказатель(Движения, Автор.ФизЛицо, 1 - ПроцентПоделиться / 100, ПоказательКоличествоДоговоров);
	
	Если ЗначениеЗаполнено(Поделиться) Тогда
		СформироватьПоказатель(Движения, Поделиться, СуммаДокумента * ПроцентПоделиться / 100, ПоказательСуммаЗаключенныхДоговоров);
		СформироватьПоказатель(Движения, Поделиться, ПроцентПоделиться / 100, ПоказательКоличествоДоговоров);
	КонецЕсли;

КонецФункции // СформироватьПоказателиДизайнера()

Функция СформироватьПоказатель(Движения, Сотрудник, Значение, Показатель)

	Запись = Движения.ПоказателиСотрудников.Добавить();
	Запись.Период = Дата;
	Запись.Подразделение = Подразделение;
	Запись.Показатель = Показатель;
	Запись.Сотрудник = Сотрудник;
	Запись.Значение = Значение;

КонецФункции // СформироватьПоказатель()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Спецификация = ЭтотОбъект.Спецификация;
	ДоговорСсылка = Документы.Спецификация.ПолучитьДоговор(Спецификация);
	
	Если ЗначениеЗаполнено(ДоговорСсылка) И Ссылка <> ДоговорСсылка Тогда
		
		Отказ= Истина;
		ТекстСообщения = "К " + Спецификация + " уже введен " + ДоговорСсылка;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДоговорСсылка);
		
	КонецЕсли;
	
	Если Спецификация <> Ссылка.Спецификация Тогда
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Ссылка.Спецификация) = Перечисления.СтатусыСпецификации.Рассчитывается Тогда
			Документы.Спецификация.УстановитьСтатусСпецификации(Ссылка.Спецификация, Перечисления.СтатусыСпецификации.Проверен);
		КонецЕсли;
	КонецЕсли;
	
	СуммаДокументаБезСкидки = СуммаДокумента + (СуммаДокумента * ПроцентСкидки / 100);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		
		Контрагент							= ДанныеЗаполнения.Контрагент;
		Спецификация					= ДанныеЗаполнения;
		СуммаДокумента					= ДанныеЗаполнения.СуммаДокумента;
		Офис 								= ДанныеЗаполнения.Офис;
		Подразделение 					= ДанныеЗаполнения.Подразделение;
		ДатаУстановитьНеПозднее 	= ?(ДанныеЗаполнения.УслугаМонтаж, ДанныеЗаполнения.ДатаМонтажа + 30*24*3600, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	//Если Проведен И ЗначениеЗаполнено(ДатаУстановки) И НЕ МонтажПоСоглашению Тогда
	//	// если нет графика монтажа, то создать его
	//	МассивГрафикМонтажа = ЛексСервер.НайтиПодчиненныеДокументы(Ссылка, "Документ.ГрафикМонтажа", "Договор");
	//	Если МассивГрафикМонтажа.Количество() = 1 Тогда
	//		// уже есть график монтажа, ничего не делать
	//	ИначеЕсли МассивГрафикМонтажа.Количество() = 0 Тогда
	//		// нету графика монтажа, создать новый
	//		НовыйГрафикМонтажа = Документы.ГрафикМонтажа.СоздатьДокумент();
	//		НовыйГрафикМонтажа.Заполнить(Ссылка);
	//		НовыйГрафикМонтажа.Записать(РежимЗаписиДокумента.Проведение);
	//	Иначе
	//		// есть непонятное количество графиков монтажа
	//		ТекстСообщения = "Ошибка связи Договора с Графиком монтажа";
	//		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка);
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
		// Изменение статуса договора
	
	Если Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация) = Перечисления.СтатусыСпецификации.Рассчитывается Тогда
		
		Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Проверен);
		
	КонецЕсли;
КонецПроцедуры
