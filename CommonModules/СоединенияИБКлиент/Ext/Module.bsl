﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Завершение работы пользователей".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Выполняет действия перед началом работы системы.
//
Процедура ПередНачаломРаботыСистемы(Отказ) Экспорт
	
	ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	ТекстСообщения = "";
	Если Не ПараметрыРаботыКлиентаПриЗапуске.Свойство("СеансыОбластиДанныхЗаблокированы", ТекстСообщения) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = ПараметрыРаботыКлиентаПриЗапуске.ПредложениеВойти;
	Если Не ПустаяСтрока(ТекстВопроса) Тогда
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Войти'"));
		Если ПараметрыРаботыКлиентаПриЗапуске.ВозможноСнятьБлокировку Тогда
			Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Снять блокировку и войти'"));
		КонецЕсли;
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		Ответ = Вопрос(ТекстВопроса, Кнопки, 15, КодВозвратаДиалога.Отмена,, КодВозвратаДиалога.Отмена);
		Если Ответ = КодВозвратаДиалога.Да Тогда // входим в заблокированное приложение
			Возврат;
		ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда // снимаем блокировку и входим в приложение
			СоединенияИБВызовСервера.УстановитьБлокировкуСеансовОбластиДанных(Новый Структура("Установлена", Ложь));
			Возврат;
		КонецЕсли;
	Иначе
		Предупреждение(ТекстСообщения, 15);
	КонецЕсли;
	
	Отказ = Истина;
	
КонецПроцедуры

// Выполняет действия при начале работы системы.
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	ПараметрыРаботы = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если НЕ ПараметрыРаботы.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьСкоростьКлиентскогоСоединения() <> СкоростьКлиентскогоСоединения.Обычная Тогда
		Возврат;	
	КонецЕсли;
	
	РежимБлокировки = ПараметрыРаботы.ПараметрыБлокировкиСеансов;
	ТекущееВремя = РежимБлокировки.ТекущаяДатаСеанса;
	Если РежимБлокировки.Установлена 
		 И (НЕ ЗначениеЗаполнено(РежимБлокировки.Начало) ИЛИ ТекущееВремя >= РежимБлокировки.Начало) 
		 И (НЕ ЗначениеЗаполнено(РежимБлокировки.Конец) ИЛИ ТекущееВремя <= РежимБлокировки.Конец) Тогда
		// Если пользователь зашел в базу, в которой установлена режим блокировки, значит использовался ключ /UC.
		// Завершать работу такого пользователя не следует
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей", 60);	
	
КонецПроцедуры

// Обработать параметры запуска, связанные с завершение и разрешение соединений ИБ.
//
// Параметры
//  ЗначениеПараметраЗапуска  – Строка – главный параметр запуска
//  ПараметрыЗапуска          – Массив – дополнительные параметры запуска, разделенные
//                                       символом ";".
//
// Возвращаемое значение:
//   Булево   – Истина, если требуется прекратить выполнение запуска системы.
//
Функция ОбработатьПараметрыЗапуска(Знач ЗначениеПараметраЗапуска, Знач ПараметрыЗапуска) Экспорт

	ПараметрыРаботы = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если НЕ ПараметрыРаботы.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Обработка параметров запуска программы - 
	// ЗапретитьРаботуПользователей и РазрешитьРаботуПользователей
	Если ЗначениеПараметраЗапуска = Врег("РазрешитьРаботуПользователей") Тогда
		
		Если НЕ СоединенияИБВызовСервера.РазрешитьРаботуПользователей() Тогда
			ТекстСообщения = НСтр("ru = 'Параметр запуска РазрешитьРаботуПользователей не отработан. Нет прав на администрирование информационной базы.'");
			Предупреждение(ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
		
		ЗавершитьРаботуСистемы(Ложь);
		Возврат Истина;
		
	// Параметр может содержать две дополнительные части, разделенные символом ";" - 
	// имя и пароль администратора ИБ, от имени которого происходит подключение к кластеру серверов
	// в клиент-серверном варианте развертывания системы. Их необходимо передавать в случае, 
	// если текущий пользователь не является администратором ИБ.
	// См. использование в процедуре ЗавершитьРаботуПользователей().
	ИначеЕсли ЗначениеПараметраЗапуска = Врег("ЗавершитьРаботуПользователей") Тогда
		
		// поскольку блокировка еще не установлена, то при входе в систему
		// для данного пользователя был подключен обработчик ожидания завершения работы.
		// Отключаем его. Так как для этого пользователя подключается специализированный обработчики ожидания
		// "ЗавершитьРаботуПользователей", который ориентирован на то, что данный пользователь
		// должен быть отключен последним.
		ОтключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей");
		
		Если НЕ СоединенияИБВызовСервера.УстановитьБлокировкуСоединений() Тогда
			ТекстСообщения = НСтр("ru = 'Параметр запуска ЗавершитьРаботуПользователей не отработан. Нет прав на администрирование информационной базы.'");
			Предупреждение(ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("ЗавершитьРаботуПользователей", 60);
		ЗавершитьРаботуПользователей();
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Подключить обработчик ожидания КонтрольРежимаЗавершенияРаботыПользователей или
// ЗавершитьРаботуПользователей в зависимости от параметра УстановитьБлокировкуСоединений.
//
Процедура УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(Знач УстановитьБлокировкуСоединений) Экспорт
	
	УстановитьПризнакРаботаПользователейЗавершается(УстановитьБлокировкуСоединений);
	Если УстановитьБлокировкуСоединений Тогда
		// поскольку блокировка еще не установлена, то при входе в систему
		// для данного пользователя был подключен обработчик ожидания завершения работы.
		// Отключаем его. Так как для этого пользователя подключается специализированный обработчик ожидания
		// "ЗавершитьРаботуПользователей", который ориентирован на то, что данный пользователь
		// должен быть отключен последним.
		
		ОтключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей");
		ПодключитьОбработчикОжидания("ЗавершитьРаботуПользователей", 60);
		ЗавершитьРаботуПользователей();
	Иначе
		ОтключитьОбработчикОжидания("ЗавершитьРаботуПользователей");
		ПодключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей", 60);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в эту подсистему

// Вызывается при неудачной попытке установить монопольный режим в файловой базе.
// 
// Параметры:
//  Отказ - булево - если Истина - завершает работу программы
//
Процедура ПриОткрытииФормыОшибкиУстановкиМонопольногоРежима(Отказ) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ЗавершитьРаботуПрограммы = ОткрытьФормуМодально(
		"Обработка.БлокировкаРаботыПользователей.Форма.ОшибкаУстановкиМонопольногоРежима",
		ПараметрыФормы);
	Если ЗавершитьРаботуПрограммы = Неопределено
		Или ЗавершитьРаботуПрограммы Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Вызывается при интерактивном начале работы пользователя с областью данных.
//
// Параметры:
//  ПервыйПараметр   - Строка - первое значение параметра запуска,
//                     до первого символа ";" в верхнем регистре.
//  ПараметрыЗапуска – Массив – массив строк разделенных символом ";" в параметре запуска,
//                     переданным в конфигурацию с помощью ключа командной строки /C.
//  Отказ            - Булево (возвращаемое значение), если установить Истина,
//                     обработка события ПриНачалеРаботыСистемы будет прервана.
//
Процедура ПриОбработкеПараметровЗапуска(ПервыйПараметр, ПараметрыЗапуска, Отказ) Экспорт
	
	Отказ = Отказ Или ОбработатьПараметрыЗапуска(ПервыйПараметр, ПараметрыЗапуска);
	
КонецПроцедуры

// Переопределяет стандартное предупреждение открытием произвольной формы активных пользователей.
//
// Параметры:
//  ИмяФормы - Строка (возвращаемое значение).
//
Процедура ПриОпределенииФормыАктивныхПользователей(ИмяФормы) Экспорт
	
	ИмяФормы = "Обработка.АктивныеПользователи.Форма.ФормаСпискаАктивныхПользователей";
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистемы БазоваяФункциональность.

// Устанавливает значение переменной РаботаПользователейЗавершается в значение Значение.
//
// Параметры
//   Значение - Булево - устанавливаемое значение.
//
Процедура УстановитьПризнакРаботаПользователейЗавершается(Значение) Экспорт
	
	РаботаПользователейЗавершается = Значение;
	
КонецПроцедуры	


