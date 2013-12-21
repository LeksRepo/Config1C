﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.Управленческий.Записывать = Истина;
	
	Спецификация 		= ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Спецификация");
	ПакетУслуг 			= ОбщегоНазначения.ПолучитьЗначениеРеквизита(Спецификация, "ПакетУслуг");
	ДокументМонтаж 	= Документы.Спецификация.ПолучитьМонтаж(Спецификация);
	СоздатьМонтаж = НЕ ПакетУслуг = Перечисления.ПакетыУслуг.СамовывозОтПроизводителя;
	
	// нет монтажа
	Если СоздатьМонтаж И ДокументМонтаж = Документы.Монтаж.ПустаяСсылка() Тогда
		
		Монтаж 							= Документы.Монтаж.СоздатьДокумент();
		Монтаж.Спецификация 	= Спецификация;
		Монтаж.ДатаМонтажа 		= Спецификация.ДатаМонтажа;
		Монтаж.Дата					= ?(ЗначениеЗаполнено(Спецификация.ДатаОтгрузки), Спецификация.ДатаОтгрузки, ТекущаяДата());
		Монтаж.Подразделение 	= Спецификация.Производство;
		Монтаж.Записать(РежимЗаписиДокумента.Проведение);
		
	КонецЕсли;
	
	ЛексСервер.СформироватьПоказателиСотрудников(Движения, Ссылка);
	
	// Изменение статуса спецификации
	Статус = Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация);
	
	Если Статус = Перечисления.СтатусыСпецификации.Проверен
		ИЛИ Статус = Перечисления.СтатусыСпецификации.Сохранен
		ИЛИ Статус = Перечисления.СтатусыСпецификации.ПроверяетсяИнженером Тогда
		
		Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Рассчитывается);
		
	КонецЕсли;
	
КонецПроцедуры

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
	
	Если Спецификация.ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж Тогда
		
		ДатаУстановитьНеПозднее = Дата + 30*24*3600;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		
		Если ДанныеЗаполнения.Контрагент <> Справочники.Контрагенты.ЧастноеЛицо Тогда
			Контрагент							= ДанныеЗаполнения.Контрагент;
		КонецЕсли;
		Спецификация					= ДанныеЗаполнения;
		СуммаДокумента					= ДанныеЗаполнения.СуммаДокумента;
		СуммаДокументаБезСкидки = ДанныеЗаполнения.СуммаДокумента;
		Офис 								= ДанныеЗаполнения.Офис;
		Подразделение 					= ДанныеЗаполнения.Подразделение;
		
		Если Контрагент.ЮридическоеЛицо Тогда
			ВидОплатыДоговора = Перечисления.ВидыОплатыДоговоров.Рассрочка1Месяц;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Изменение статуса спецификации
	Если Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация) = Перечисления.СтатусыСпецификации.Рассчитывается Тогда
		Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Проверен);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
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
	
КонецПроцедуры
