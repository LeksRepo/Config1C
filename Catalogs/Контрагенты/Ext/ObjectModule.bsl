﻿
Процедура ПередЗаписью(Отказ)
	
	Перем Ошибки;
	
	Если НЕ ЭтоГруппа Тогда
		
		Префикс = ВРег(Префикс);
		
		Если ЮридическоеЛицо И НЕ ЗначениеЗаполнено(ИНН) Тогда
			 ТекстСообщения = "Заполните ИНН контрагента.";
			 ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ИНН", ТекстСообщения);	
		КонецЕсли;
		
		Если НЕ ЮридическоеЛицо И (НЕ ЗначениеЗаполнено(Имя) ИЛИ НЕ ЗначениеЗаполнено(Фамилия) ИЛИ НЕ ЗначениеЗаполнено(Отчество)) Тогда
			 ТекстСообщения = "Заполните фамилию, имя и отчество контрагента.";
			 ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Префикс", ТекстСообщения);	
		КонецЕсли;
		
		// Сбросили флаг Дилер у контрагента
		Если Ссылка.Дилер И НЕ Дилер Тогда
			
			ТекстСообщения = "Запрещено убирать признак дилера";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Дилер", ТекстСообщения);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Префикс) Тогда
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Префикс", Префикс);
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	Контрагенты.Ссылка
			|ИЗ
			|	Справочник.Контрагенты КАК Контрагенты
			|ГДЕ
			|	Контрагенты.Префикс = &Префикс
			|	И Контрагенты.Ссылка <> &Ссылка";
			
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
				
				ТекстСообщения = "Такой префикс уже существует, укажите другой.";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Префикс", ТекстСообщения);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Ошибки;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Дилер Тогда
		Если НЕ ЗначениеЗаполнено(Префикс) ИЛИ СтрДлина(Префикс) <> 3 Тогда
			ТекстСообщения = "Префикс у дилера должен состоять из трех букв";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Префикс", ТекстСообщения);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Подразделение) Тогда
			ТекстСообщения = "Укажите подразделение";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Подразделение", ТекстСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры