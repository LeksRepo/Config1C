﻿
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЭтоГруппа И ЗначениеЗаполнено(Префикс) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Контрагенты.Префикс
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты";
		
		МассивПрефиксов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Префикс");
		
		Если МассивПрефиксов.Найти(Префикс) <> Неопределено Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Такой префикс уже существует", ,"Объект.Префикс");
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Ошибки = Неопределено;
	
	Если (Поставщик ИЛИ Дилер) И НЕ ЗначениеЗаполнено(Город) Тогда
		ТекстСообщения = "Заполните город";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Город", ТекстСообщения);
	КонецЕсли;
	
	Если Дилер И НЕ ЗначениеЗаполнено(Префикс) Тогда
		ТекстСообщения = "Заполните префикс";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Префикс", ТекстСообщения);
	КонецЕсли;
	
	Если Ошибки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		Возврат;
		
	КонецЕсли;
	
	
КонецПроцедуры
