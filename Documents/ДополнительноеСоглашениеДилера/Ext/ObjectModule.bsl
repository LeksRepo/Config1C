﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ДоговорДилера") Тогда
		
		Договор = ДанныеЗаполнения.Ссылка;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Префикс = Автор.ОбъектАвторизации.Префикс;
	
	ЛексСервер.УстановитьПрефиксКонтрагента(Ссылка, Префикс);
	
КонецПроцедуры
