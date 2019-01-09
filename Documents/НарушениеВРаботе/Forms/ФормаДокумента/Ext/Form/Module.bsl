﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Пользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Автор = Пользователь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СписокНарушенийНарушениеПриИзменении(Элемент)
	
	ТекДанные = Элементы.СписокНарушений.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекДанные.Нарушение) Тогда
		 ТекДанные.Удержание = ЛексСервер.ЗначениеРеквизитаОбъекта(ТекДанные.Нарушение, "Удержание");
	КонецЕсли;
	
КонецПроцедуры
