﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи)
	
	Регистратор = Отбор.Регистратор.Значение;
	СчетДоходы = ПланыСчетов.Управленческий.Доходы;
	СчетРасходы = ПланыСчетов.Управленческий.Расходы;
	ПВХСтатьиДР = ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР;
	
	Ошибки = Неопределено;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		СчетДт = Запись.СчетДт;
		СчетКт = Запись.СчетКт;
		
		Запись.СчетДтЧтение = Запись.СчетДт;
		Запись.СчетКтЧтение = Запись.СчетКт;
		
		////////////////////////////////////////////
		// проверка на использование счетов с субсчетами
		
		Если СчетКт.ЗапретитьИспользоватьВПроводках Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Регистратор, СформироватьТекстОшибкиСчета(СчетКт));
		КонецЕсли;
		
		Если СчетДт.ЗапретитьИспользоватьВПроводках Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Регистратор, СформироватьТекстОшибкиСчета(СчетДт));
		КонецЕсли;
		
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
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Статья '%1' не является статьей расхода", Статья);
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
		
	КонецЦикла; // Для каждого Запись Из ЭтотОбъект Цикл
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Функция СформироватьТекстОшибкиСчета(Счет)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Счет '%1' запрещено использовать в проводках -- используйте субсчета", Счет);
	
КонецФункции