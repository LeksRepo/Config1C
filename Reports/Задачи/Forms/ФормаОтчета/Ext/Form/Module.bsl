﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Не ОбщегоНазначения.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	ЗначениеРасшифровки = Неопределено;
	Если БизнесПроцессыИЗадачиВызовСервера.ЭтоЗадачаИсполнителю(Расшифровка, ДанныеРасшифровки, ЗначениеРасшифровки) Тогда
		СтандартнаяОбработка = НЕ БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(ЗначениеРасшифровки);
	КонецЕсли;
КонецПроцедуры


