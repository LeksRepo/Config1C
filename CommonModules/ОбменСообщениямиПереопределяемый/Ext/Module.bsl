﻿////////////////////////////////////////////////////////////////////////////////
// ОбменСообщениямиПереопределяемый: механизм обмена сообщениями.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает список обработчиков сообщений, которые обрабатывает
// данная информационная система.
// 
// Параметры:
//  Обработчики - ТаблицаЗначений - состав полей см. в ОбменСообщениями.НоваяТаблицаОбработчиковСообщений
// 
Процедура ПолучитьОбработчикиКаналовСообщений(Обработчики) Экспорт
	
	
	
КонецПроцедуры

// Обработчик получения динамического списка конечных точек сообщений
//
// Параметры:
//  КаналСообщений - Строка - Идентификатор канала сообщений, для которого необходимо определить конечные точки.
//  Получатели     - Массив - Массив конечных точек, в которые следует адресовать сообщение,
//                            должен быть заполнен элементами типа ПланОбменаСсылка.ОбменСообщениями.
//                            Этот параметр необходимо определить в теле обработчика.
//
Процедура ПолучателиСообщения(Знач КаналСообщений, Получатели) Экспорт
	
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий отправки и получения сообщений

// Обработчик события при отправке сообщения.
// Обработчик данного события вызывается перед помещением сообщения в XML-поток.
// Обработчик вызывается для каждого отправляемого сообщения.
//
// Параметры:
//  КаналСообщений - Строка - Идентификатор канала сообщений, в который отправляется сообщение.
//  ТелоСообщения - Произвольный - Тело отправляемого сообщения. В обработчике события тело сообщения
//                                может быть изменено, например, дополнено информацией.
//
Процедура ПриОтправкеСообщения(КаналСообщений, ТелоСообщения) Экспорт
	
КонецПроцедуры

// Обработчик события при получении сообщения.
// Обработчик данного события вызывается при получении сообщения из XML-потока.
// Обработчик вызывается для каждого получаемого сообщения.
//
// Параметры:
//  КаналСообщений - Строка - Идентификатор канала сообщений, из которого получено сообщение.
//  ТелоСообщения - Произвольный - Тело полученного сообщения. В обработчике события тело сообщения
//                                 может быть изменено, например, дополнено информацией.
//
Процедура ПриПолученииСообщения(КаналСообщений, ТелоСообщения) Экспорт
	
КонецПроцедуры

#КонецОбласти
