﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Отправка SMS"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Отправляет SMS через настроенного поставщика услуги, возвращает идентификатор сообщения.
//
// Параметры:
//  ПараметрыОтправки - Структура:
//    Провайдер - ПеречислениеСсылка.ПровайдерыSMS - поставщик услуги по отправке SMS.
//    НомераПолучателей  - Массив - массив строк номеров получателей в формате +7ХХХХХХХХХХ;
//    Текст              - Строка - текст сообщения, максимальная длина у операторов может быть разной;
//    ИмяОтправителя     - Строка - имя отправителя, которое будет отображаться вместо номера у получателей.
//    Логин              - Строка - логин для доступа к услуге отправки SMS.
//    Пароль             - Строка - пароль для доступа к услуге отправки SMS.
//  Результат - Структура - (возвращаемое значение):
//    ОтправленныеСообщения - Массив структур:
//      НомерПолучателя - Строка - номер получателя из массива НомераПолучателей;
//      ИдентификаторСообщения - Строка - идентификатор SMS, по которому можно запросить статус отправки.
//    ОписаниеОшибки - Строка - пользовательское представление ошибки, если пустая строка, то ошибки нет.
//
Процедура ОтправитьSMS(ПараметрыОтправки, Результат) Экспорт
	
	
	
КонецПроцедуры

// Запрашивает статус доставки SMS у поставщика услуг.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный SMS при отправке;
//  Логин              - Строка - логин для доступа к услуге отправки SMS.
//  Пароль             - Строка - пароль для доступа к услуге отправки SMS.
//  Результат          - Перечисление.СтатусыДоставкиSMS - (возвращаемое значение) статус доставки.
//
Процедура СтатусДоставки(ИдентификаторСообщения, Провайдер, Логин, Пароль, Результат) Экспорт 
	
	
	
КонецПроцедуры
