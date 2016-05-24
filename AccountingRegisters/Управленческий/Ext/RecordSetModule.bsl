﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи)
	
	Регистратор = Отбор.Регистратор.Значение;
	СчетДоходы = ПланыСчетов.Управленческий.Доходы;
	СчетРасходы = ПланыСчетов.Управленческий.Расходы;
	ПВХСтатьиДР = ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР;
	ПВХСтатьиДС = ПланыВидовХарактеристик.ВидыСубконто.СтатьиДДС;
	
	Ошибки = Неопределено;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		СчетДт = Запись.СчетДт;
		СчетКт = Запись.СчетКт;
		
		Запись.СчетДтЧтение = Запись.СчетДт;
		Запись.СчетКтЧтение = Запись.СчетКт;
		
		////////////////////////////////////////////
		// проверка: использование счетов с субсчетами
		
		Если СчетКт.ЗапретитьИспользоватьВПроводках Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Регистратор, СформироватьТекстОшибкиСчета(СчетКт, Запись.НомерСтроки + 1));
		КонецЕсли;
		
		Если СчетДт.ЗапретитьИспользоватьВПроводках Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Регистратор, СформироватьТекстОшибкиСчета(СчетДт, Запись.НомерСтроки + 1));
		КонецЕсли;
		
		////////////////////////////////////////////
		// проверка: корректность статей дохода и расхода
		
		Если ТипЗнч(Регистратор) <> Тип("ДокументСсылка.ЗакрытиеМесяца") Тогда
			
			// Только документ Закрытие месяца можно делать "неправильные" проводки.
			
			Если СчетДт = ПланыСчетов.Управленческий.Доходы Тогда
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Регистратор, "Запрещено использование счета Доходы по дебету");
			КонецЕсли;
			
			Если СчетКт = ПланыСчетов.Управленческий.Расходы Тогда
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Регистратор, "Запрещено использование счета Расходы по кредиту");
			КонецЕсли;
			
		КонецЕсли;
		
		Если СчетДт = СчетРасходы Тогда
			
			Статья = Запись.СубконтоДт[ПВХСтатьиДР];
			
			Если Статья.ВидСтатьи <> Перечисления.ВидыСтатейДР.Расход Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Ошибка в проводке %1. Статья '%2' не является статьей расхода", Запись.НомерСтроки + 1, Статья);
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Регистратор, ТекстОшибки);
			КонецЕсли;
			
		КонецЕсли;
		
		Если СчетКт = СчетДоходы Тогда
			
			Статья = Запись.СубконтоКт[ПВХСтатьиДР];
			ВидСтатьи = Перечисления.ВидыСтатейДР.Доход;
			
			Если Статья.ВидСтатьи <> ВидСтатьи Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Статья '%1' не является статьей дохода", Статья);
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Регистратор, ТекстОшибки);
			КонецЕсли;
			
		КонецЕсли;
		
		////////////////////////////////////////////
		// проверка: корректность статей оплаты и поступления
		
		Если ЗначениеЗаполнено(СчетКт)
			И ЗначениеЗаполнено(СчетДт) Тогда
			СчетДтДеньги = СчетДт.ПринадлежитЭлементу(ПланыСчетов.Управленческий.ДенежныеСредства);
			СчетКтДеньги = СчетКт.ПринадлежитЭлементу(ПланыСчетов.Управленческий.ДенежныеСредства);
		Иначе
			СчетДтДеньги = Ложь;
			СчетКтДеньги = Ложь;
		КонецЕсли;
		
		Если СчетДтДеньги И СчетКтДеньги Тогда
			
			СтатьяДт = Запись.СубконтоДт[ПВХСтатьиДС];
			СтатьяКт = Запись.СубконтоКт[ПВХСтатьиДС];
			
			Если НЕ (СтатьяДт = СтатьяКт И СтатьяДт = Справочники.СтатьиДвиженияДенежныхСредств.ПеремещениеДенежныхСредств) Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Ошибка в проводке %1. При перемещении денежных средств в одном подразделении, статья оплаты и поступления должна быть 'Перемещение денежных средств'", Запись.НомерСтроки + 1);
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Регистратор, ТекстОшибки);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла; // Для каждого Запись Из ЭтотОбъект Цикл
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Функция СформироватьТекстОшибкиСчета(Счет, НомерСтроки)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Ошибка в проводке %1. Счет '%1' запрещено использовать в проводках -- используйте субсчета", Счет, НомерСтроки);
	
КонецФункции