﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ВыбраннаяФорма = "НастройкаНаСторонеАвтономногоРабочегоМеста";
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли