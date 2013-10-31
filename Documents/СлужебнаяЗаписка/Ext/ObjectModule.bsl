﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	ПользовательАдминистратор = УправлениеДоступомПереопределяемый.ЕстьДоступКПрофилюГруппДоступа(Пользователь, Справочники.ПрофилиГруппДоступа.Администратор);
	ПользовательКадроваяСлужба = УправлениеДоступомПереопределяемый.ЕстьДоступКПрофилюГруппДоступа(Пользователь, Справочники.ПрофилиГруппДоступа.КадроваяСлужба);
	
	СменаДаты = ПользовательКадроваяСлужба ИЛИ ПользовательАдминистратор;
	НашаДата = ТекущаяДата();
	
	Если НЕ (ЗначениеЗаполнено(ДатаКонтроля) И СменаДаты) Тогда
		Если ВидСлужебнойЗаписки <> Перечисления.ВидыСлужебнойЗаписки.Поручение Тогда 
			
			ДатаКонтроля = НашаДата + 2 * 86400;
			
		КонецЕсли;
		
		Если ДеньНедели(Дата) >= 5 Тогда
			ДатаКонтроля = ДатаКонтроля + 86400;
		КонецЕсли;
	КонецЕсли;
	
	ДатаКонтроля = КонецДня(ДатаКонтроля);
	
	Если ЭтоНовый() Тогда
		Если ДатаКонтроля < ТекущаяДата() Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Дата контроля не может быть меньше текущей даты");
			Возврат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)

	Если ВидСлужебнойЗаписки = Перечисления.ВидыСлужебнойЗаписки.НарушенияВРаботе Тогда
		Движение = Движения.ОшибкиСотрудников.Добавить();
		Движение.Период = Дата;
		Движение.Сотрудник = Виновный;
		Движение.Количество = 1;
	КонецЕсли;
	
	Движения.ОшибкиСотрудников.Записывать = Истина;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Документ = ДанныеЗаполнения.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВидСлужебнойЗаписки = Перечисления.ВидыСлужебнойЗаписки.НарушенияВРаботе
		ИЛИ ВидСлужебнойЗаписки = Перечисления.ВидыСлужебнойЗаписки.НарушениеСроков Тогда
		
		ПроверяемыеРеквизиты.Добавить("Виновный");
		
	ИначеЕсли ВидСлужебнойЗаписки = Перечисления.ВидыСлужебнойЗаписки.Поручение Тогда
		
		ПроверяемыеРеквизиты.Добавить("ДатаКонтроля");	
		
	КонецЕсли;
	
КонецПроцедуры
