﻿
&НаКлиенте
Процедура Перенести(Команда)
	
	Данные = Новый Структура();
	
	Если НаименованиеОбновлять Тогда
		Данные.Вставить("Наименование", Наименование);
	КонецЕсли;
	
	Если ИННОбновлять Тогда
		Данные.Вставить("ИНН", ИНН);
	КонецЕсли;	
	
	Если КППОбновлять Тогда
		Данные.Вставить("КПП", КПП);
	КонецЕсли;	
		
	Если ОГРНОбновлять Тогда	
		Данные.Вставить("ОГРН", ОГРН);
	КонецЕсли;	
	
	Если ЮридическийАдресОбновлять Тогда
		Данные.Вставить("ЮридическийАдрес", ЮридическийАдрес);
	КонецЕсли;	
	
	Если ПочтовыйАдресОбновлять Тогда
		Данные.Вставить("ПочтовыйАдрес", ПочтовыйАдрес);
	КонецЕсли;	
	
	Если РуководительОбновлять Тогда	
		Данные.Вставить("Руководитель", Руководитель);
	КонецЕсли;
	
	Если ПолноеНаименованиеОбновлять Тогда
		Данные.Вставить("ПолноеНаименование", ПолноеНаименование);
	КонецЕсли;	
		
	ОповеститьОВыборе(Данные);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Наименование = Параметры.Наименование;
	ИНН = Параметры.ИНН;
	КПП = Параметры.КПП;
	ОГРН = Параметры.ОГРН;
	ЮридическийАдрес = Параметры.ЮридическийАдрес;
	ПочтовыйАдрес = Параметры.ПочтовыйАдрес;
	Руководитель = Параметры.Руководитель;
	ПолноеНаименование = Параметры.ПолноеНаименование;
	
	НаименованиеСтарый = Параметры.НаименованиеСтарый;
	ИННСтарый = Параметры.ИННСтарый;
	КППСтарый = Параметры.КППСтарый;
	ОГРНСтарый = Параметры.ОГРНСтарый;
	ЮридическийАдресСтарый = Параметры.ЮридическийАдресСтарый;
	ПочтовыйАдресСтарый = Параметры.ПочтовыйАдресСтарый;
	РуководительСтарый = Параметры.РуководительСтарый;
	ПолноеНаименованиеСтарый = Параметры.ПолноеНаименованиеСтарый;
	
	НаименованиеОбновлять = Истина;
	ИННОбновлять = Истина;
	КППОбновлять = Истина;
	ОГРНОбновлять = Истина;
	ЮридическийАдресОбновлять = Истина;
	ПочтовыйАдресОбновлять = Истина;
	РуководительОбновлять = Истина;
	ПолноеНаименованиеОбновлять = Истина;
	
КонецПроцедуры
