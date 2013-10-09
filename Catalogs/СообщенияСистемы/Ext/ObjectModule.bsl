﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КаналСообщений = Наименование;
	
	СодержимоеТела = ТелоСообщения.Получить();
	
	// СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса
	СообщенияВМоделиСервиса.ПередОтправкойСообщения(КаналСообщений, СодержимоеТела);
	// Конец СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса
	
	ТелоСообщения = Новый ХранилищеЗначения(СодержимоеТела);
	
КонецПроцедуры

#КонецЕсли