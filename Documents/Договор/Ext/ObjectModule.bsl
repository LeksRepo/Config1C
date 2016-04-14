﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Перем Ошибки;
	
	Если НЕ Спецификация.Проведен Тогда
		
		Если Документы.Спецификация.МатериалПодЗаказПроверен(Спецификация, Ошибки) Тогда
			
			ОбъектСпецификация = Спецификация.ПолучитьОбъект();
			НачатьТранзакцию();
			
			Попытка
				
				Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Рассчитывается);
				ОбъектСпецификация.Записать(РежимЗаписиДокумента.Проведение);
				
			Исключение
			КонецПопытки;
			
			ЗафиксироватьТранзакцию();
			
			Если НЕ ОбъектСпецификация.Проведен Тогда
				
				ТекстСообщения = "Ошибка размещения %1. Заключение договора невозможно";
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Спецификация);
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Спецификация, ТекстСообщения);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если Отказ Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Движения.Управленческий.Записывать = Истина;
	
	НачислитьЗарплатуДизайнеру();
	ЛексСервер.СформироватьПоказателиСотрудников(Движения, Ссылка);
	УстановитьАктивностьЗамера(Ложь);
	
КонецПроцедуры

Функция УстановитьАктивностьЗамера(НовыйСтатус)
	
	ЗамерСсылка = Спецификация.ДокументОснование;
	Если ТипЗнч(ЗамерСсылка) = Тип("ДокументСсылка.Замер") Тогда
		
		НаборЗаписей = РегистрыСведений.АктивностьЗамеров.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Замер.Установить(ЗамерСсылка);
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() <> 1 Тогда
			Запись = НаборЗаписей.Добавить()
		Иначе
			Запись = НаборЗаписей[0];
		КонецЕсли;
		
		Запись.Замер = ЗамерСсылка;
		Запись.Статус = Ложь;
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
КонецФункции

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
	
	ТекущийСтатус = Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация);
	
	Если Дата > '2015.07.01' Тогда // Костыль
		
		Для каждого Строка Из Спецификация.СписокМатериаловПодЗаказ Цикл
			
			Если Строка.Цена = 0 ИЛИ Строка.Поставщик.Пустая() Тогда
				ТекстСообщения = "%1 установите цену у материала 'Под заказ'";
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Спецификация, ТекущийСтатус);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДоговорСсылка);
				Отказ = Истина;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
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
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	УстановитьАктивностьЗамера(Истина);
	
	// Изменение статуса спецификации
	Если Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация) = Перечисления.СтатусыСпецификации.Рассчитывается Тогда
		Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Сохранен);
		СпецификацияОбъект = Спецификация.ПолучитьОбъект();
		СпецификацияОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Ошибки;
	
	Если НЕ ЗначениеЗаполнено(ВидОплаты) И НЕ ЗначениеЗаполнено(ВидОплатыДоговора) Тогда
		
		ТекстОшибки = "Заполните вид оплаты";				
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ТекстОшибки);
		
	КонецЕсли;
	
	// Проверка оплаты.
	Если НЕ Контрагент.ЮридическоеЛицо Тогда
		
		СуммаАванса = Документы.Договор.ПолучитьСуммуАванса(Ссылка);
		
		ПолнаяПредоплата = Ложь;
		
		Если ЗначениеЗаполнено(ВидОплаты) Тогда
			ПолнаяПредоплата = ВидОплаты.ПолнаяПредоплата;
		Иначе	
			ПолнаяПредоплата = (ВидОплатыДоговора = Перечисления.ВидыОплатыДоговоров.ПолнаяПредоплата);
		КонецЕсли;

		Если ПолнаяПредоплата Тогда
			
			Если СуммаАванса < СуммаДокумента Тогда
				
				ТекстОшибки = "Примите полную предоплату к договору (%1 руб.)";
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, СуммаДокумента);
				
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.СуммаДокумента", ТекстОшибки);
				
			КонецЕсли;
			
		Иначе
			
			ПроцентПервогоВзноса = ЛексСервер.ПолучитьНастройкуПодразделения(Подразделение, Перечисления.ВидыНастроекПодразделений.ПроцентПервогоВзноса, Дата);
			
			Если ПроцентПервогоВзноса = Неопределено Тогда
				ПроцентПервогоВзноса = 0;
			КонецЕсли;
			
			СуммаПервогоВзноса = СуммаДокумента * ПроцентПервогоВзноса / 100 ;
			
			Если СуммаАванса < СуммаПервогоВзноса Тогда
				
				ТекстОшибки = "Примите предоплату. Более %1%% от суммы договора (%2 руб.)";
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ПроцентПервогоВзноса, СуммаПервогоВзноса);
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.СуммаДокумента", ТекстОшибки);
				
			КонецЕсли;
			
			Если НЕ (ЗначениеЗаполнено(Контрагент.ПаспортНомер)
				И ЗначениеЗаполнено(Контрагент.ПаспортКемВыдан)
				И ЗначениеЗаполнено(Контрагент.ПаспортДатаВыдачи)) Тогда
				
				ТекстОшибки = "Заполните паспортные данные у контрагента: " + Контрагент;
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Контрагент", ТекстОшибки);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли; // НЕ Контрагент.ЮридическоеЛицо
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Функция НачислитьЗарплатуДизайнеру()
	
	Движение = Движения.Управленческий.Добавить();
	Движение.Период = Дата;
	Движение.Подразделение = Подразделение;
	Движение.Сумма = Спецификация.ЗарплатаДизайнера;
	Движение.Содержание = "Зарплата дизайнера " + Спецификация;
	
	Движение.СчетДт = ПланыСчетов.Управленческий.Расходы;
	Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходыЗарплатаЗамерыИАктивныеПродажи;
	Движение.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
	Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Автор.ФизическоеЛицо;
	Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний] = Справочники.ВидыНачисленийУдержаний.ДизайнеруЗаДоговор;
	
КонецФункции // НачислитьЗарплатуДизайнеру()