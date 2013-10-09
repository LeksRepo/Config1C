﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Макет = Обработки.ПомощникСозданияОбменаДанными.ПолучитьМакет(Параметры.ИмяМакета);
	
	ПолеHTMLДокумента = Макет.ПолучитьТекст();
	
	Если    ВРег(Параметры.ИмяМакета) = ВРег("КакОпределитьПараметрыПодключенияКСервису")
		ИЛИ ВРег(Параметры.ИмяМакета) = ВРег("КакОпределитьПараметрыПодключенияКВебСервису") Тогда
		
		ПолеHTMLДокумента = СтрЗаменить(ПолеHTMLДокумента, "[НедопустимыеСимволы]", ОбменДаннымиКлиентСервер.НедопустимыеСимволыВИмениПользователяWSПрокси());
		
	КонецЕсли;
	
	Заголовок = Параметры.Заголовок;
	
КонецПроцедуры
