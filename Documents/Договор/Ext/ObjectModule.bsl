﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.Управленческий.Записывать = Истина;
	
	// { Васильев Александр Леонидович [11.02.2014]
	// вынести бы за транзакцию создание Монтажа
	// уточнить надо бы...
	// } Васильев Александр Леонидович [11.02.2014]
	
	ДатаМонтажа = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Спецификация, "ДатаМонтажа");
	ПакетУслуг = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Спецификация, "ПакетУслуг");
	СоздатьМонтаж = ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж И ЗначениеЗаполнено(ДатаМонтажа);
	СоздатьМонтаж = СоздатьМонтаж И НЕ Подразделение.СвоиМонтажи;
	ДокументМонтаж = Документы.Спецификация.ПолучитьМонтаж(Спецификация);
	
	// нет монтажа
	Если СоздатьМонтаж И ДокументМонтаж = Документы.Монтаж.ПустаяСсылка() Тогда
		
		Монтаж = Документы.Монтаж.СоздатьДокумент();
		Монтаж.Спецификация = Спецификация;
		Монтаж.ДатаМонтажа = Спецификация.ДатаМонтажа;
		Монтаж.Дата = ?(ЗначениеЗаполнено(Спецификация.ДатаОтгрузки), Спецификация.ДатаОтгрузки, ТекущаяДата());
		Монтаж.Подразделение = Спецификация.Производство;
		Монтаж.Записать(РежимЗаписиДокумента.Проведение);
		
	КонецЕсли;
	
	ЛексСервер.СформироватьПоказателиСотрудников(Движения, Ссылка);
	
	// Изменение статуса спецификации
	Статус = Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация);
	
	Если Спецификация.Изделие = Справочники.Изделия.ШкафКупеПоКаталогу Тогда
		Если Статус = Перечисления.СтатусыСпецификации.ПроверенТехнологом
			ИЛИ Статус = Перечисления.СтатусыСпецификации.ПроверяетсяТехнологом Тогда
			
			НачатьТранзакцию();
			ОбъектСпецификация = Спецификация.ПолучитьОбъект();
			Если НЕ ЗначениеЗаполнено(ОбъектСпецификация.Технолог) Тогда
				Если НЕ ОбъектСпецификация.Дилерский Тогда
					
					ОбъектСпецификация.Технолог = ПользователиКлиентСервер.ТекущийПользователь().ФизическоеЛицо;
					
				КонецЕсли;
				
			КонецЕсли; 
			
			Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Размещен);
			ОбъектСпецификация.Записать(РежимЗаписиДокумента.Проведение);
			ЗафиксироватьТранзакцию();
			
			Если НЕ ОбъектСпецификация.Проведен Тогда
				
				Отказ = Истина;
				ТекстСообщения = Строка(Спецификация) + " не проведена.";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.ПроверенТехнологом);
				
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		Если Статус = Перечисления.СтатусыСпецификации.ПроверенТехнологом
			ИЛИ Статус = Перечисления.СтатусыСпецификации.Сохранен
			ИЛИ Статус = Перечисления.СтатусыСпецификации.ПроверяетсяТехнологом Тогда
			
			Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Рассчитывается);
			
		КонецЕсли;
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////////
	// АКТИВНОСТЬ ЗАМЕРА
	
	ЗамерСсылка = Спецификация.ДокументОснование;
	Если ТипЗнч(ЗамерСсылка) = Тип("ДокументСсылка.Замер") Тогда
		
		НаборЗаписей = РегистрыСведений.АктивностьЗамеров.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Замер.Установить(ЗамерСсылка);
		НаборЗаписей.Прочитать();
		
		Запись = ?(НаборЗаписей.Количество() = 0, НаборЗаписей.Добавить(), НаборЗаписей[0]);
		Запись.Замер = ЗамерСсылка;
		Запись.Статус = Ложь;
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
	// АКТИВНОСТЬ ЗАМЕРА
	////////////////////////////////////////////////////////////////////////////////
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// { Васильев Александр Леонидович [29.06.2014]
	// Часть проверок оставляем здесь,
	// а не переносим в ОбработкуПроверкиЗаполнения,
	// чтобы даже не сохранялись в базе совсем клинические случаи,
	// вроде нескольких договоров к одной спецификации.
	// } Васильев Александр Леонидович [29.06.2014]
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	ДоговорСсылка = Документы.Спецификация.ПолучитьДоговор(Спецификация);
	
	Если ЗначениеЗаполнено(ДоговорСсылка) И Ссылка <> ДоговорСсылка Тогда
		Отказ= Истина;
		ТекстСообщения = "К " + Спецификация + " уже введен " + ДоговорСсылка;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДоговорСсылка);
	КонецЕсли;
	
	Если Ссылка.Пустая() И НЕ Документы.Договор.РазрешеноВвестиДоговор(Спецификация) Тогда
		Отказ = Истина;
		ТекстСообщения = "Для изделия вида " + Спецификация.Изделие + " запрещено вводить договор.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДоговорСсылка);
	КонецЕсли;
	
	// только новые спецификации проверяем. там нахуярили уже договоров к доп. соглашеням
	Если Спецификация <> Ссылка.Спецификация Тогда
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Ссылка.Спецификация) = Перечисления.СтатусыСпецификации.Рассчитывается Тогда
			Документы.Спецификация.УстановитьСтатусСпецификации(Ссылка.Спецификация, Перечисления.СтатусыСпецификации.ПроверенТехнологом);
		КонецЕсли;
	КонецЕсли;
	
	Если Спецификация.ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж Тогда
		
		ДатаУстановитьНеПозднее = Спецификация.ДатаМонтажа + 30 * 24 * 3600;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения)
		И ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Спецификация") Тогда
		
		ПакетУслуг = ДанныеЗаполнения.ПакетУслуг;
		АдресМонтажа = ДанныеЗаполнения.АдресМонтажа;
		
		Если (ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж ИЛИ ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиента) И АдресМонтажа = "Введите адрес" Тогда
			
			Отказ = Истина;
			ТекстСообщения = "Укажите адрес";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДанныеЗаполнения, , , Отказ);
			
		КонецЕсли;
		
		Если ДанныеЗаполнения.Контрагент <> Справочники.Контрагенты.ЧастноеЛицо Тогда
			Контрагент = ДанныеЗаполнения.Контрагент;
		КонецЕсли;
		Спецификация = ДанныеЗаполнения;
		СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
		СуммаДокументаБезСкидки = ДанныеЗаполнения.СуммаДокумента;
		Офис = ДанныеЗаполнения.Офис;
		Подразделение = ДанныеЗаполнения.Подразделение;
		
		Если Контрагент.ЮридическоеЛицо Тогда
			ВидОплатыДоговора = Перечисления.ВидыОплатыДоговоров.Рассрочка1Месяц;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Изменение статуса спецификации
	Если Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация) = Перечисления.СтатусыСпецификации.Рассчитывается Тогда
		Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.ПроверенТехнологом);
	ИначеЕсли Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация) = Перечисления.СтатусыСпецификации.Размещен
		И Спецификация.Изделие = Справочники.Изделия.ШкафКупеПоКаталогу Тогда
		Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.ПроверенТехнологом);
		СпецификацияОбъект = Спецификация.ПолучитьОбъект();
		СпецификацияОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	
	// Проверка оплаты.
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
	
	// Проверка статуса.
	Отказ = Отказ ИЛИ НЕ Документы.Договор.СпецификацияПроверена(Спецификация);
	
КонецПроцедуры
