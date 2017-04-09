﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.СтраницыДеятельностьПрекращена.Видимость = Объект.ДеятельностьПрекращена Или Пользователи.ЭтоПолноправныйПользователь();
	Элементы.СтраницыДеятельностьПрекращена.ТекущаяСтраница = ?(Пользователи.ЭтоПолноправныйПользователь(),
		Элементы.СтраницаФлажокДеятельностьПрекращена, Элементы.СтраницаНадписьДеятельностьПрекращена);
		
	Если Объект.ДеятельностьПрекращена Тогда
		КлючСохраненияПоложенияОкна = "ДеятельностьПрекращена";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
		
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("АвтономнаяРабота");
		Модуль.ОбъектПриЧтенииНаСервере(ТекущийОбъект, ЭтаФорма.ТолькоПросмотр);
		
	КонецЕсли;
	
КонецПроцедуры


