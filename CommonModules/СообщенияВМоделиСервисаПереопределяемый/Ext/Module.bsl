﻿////////////////////////////////////////////////////////////////////////////////
// Обработчик каналов сообщений для сообщений модели сервиса, переопределяемые
//  процедуры и функции
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обработчик события при получении сообщения.
// Обработчик данного события вызывается при получении сообщения из XML-потока.
// Обработчик вызывается для каждого получаемого сообщения.
//
//  Параметры:
// КаналСообщений (только чтение) Тип: Строка. Идентификатор канала сообщений, из которого получено сообщение.
// ТелоСообщения (чтение и запись) Тип: Произвольный. Тело полученного сообщения.
// В обработчике события тело сообщения может быть изменено, например, дополнено информацией.
//
Процедура ПриПолученииСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения) Экспорт
	
	
	
КонецПроцедуры

// Обработчик события при отправке сообщения.
// Обработчик данного события вызывается перед помещением сообщения в XML-поток.
// Обработчик вызывается для каждого отправляемого сообщения.
//
//  Параметры:
// КаналСообщений (только чтение) Тип: Строка. Идентификатор канала сообщений, в который отправляется сообщение.
// ТелоСообщения (чтение и запись) Тип: Произвольный. Тело отправляемого сообщения.
// В обработчике события тело сообщения может быть изменено, например, дополнено информацией.
//
Процедура ПриОтправкеСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения) Экспорт
	
	
	
КонецПроцедуры

// Процедура вызывается при начале обработки входящего сообщения
//
// Параметры:
//  Сообщение - ОбъектXDTO, входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, соответствующей
//    информационной базе, отправившей сообщение.
//
Процедура ПриНачалеОбработкиСообщения(Знач Сообщение, Знач Отправитель) Экспорт
	
	
	
КонецПроцедуры

// Процедура вызывается после обработки входящего сообщения
//
// Параметры:
//  Сообщение - ОбъектXDTO, входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, соответствующей
//    информационной базе, отправившей сообщение,
//  СообщениеОбработано - булево, флаг того, что сообщение было успешно обработано. Если значение
//    установлено равным Ложь - после выполнения этой процедуры будет вызвано исключение. В данной
//    процедуре значение данного параметра может быть изменено.
//
Процедура ПослеОбработкиСообщения(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	
	
КонецПроцедуры

// Процедура вызывается при возникновении ошибки обработки сообщения
//
// Параметры:
//  Сообщение - ОбъектXDTO, входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, соответствующей
//    информационной базе, отправившей сообщение.
//
Процедура ПриОшибкеОбработкиСообщения(Знач Сообщение, Знач Отправитель) Экспорт
	
	
	
КонецПроцедуры
