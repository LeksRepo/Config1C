﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Параметры.Ключ.ПолучитьОбъект(), "Объект");
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.СрокИсполнения);
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.Дата);
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.ДатаИсполнения);
	
КонецПроцедуры

#КонецОбласти
