﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлы.ПриСозданииНаСервереПрисоединенныйФайл(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПерейтиКФормеФайла(Команда)
	
	ПрисоединенныеФайлыКлиент.ПерейтиКФормеПрисоединенногоФайла(ЭтаФорма);
	
КонецПроцедуры
