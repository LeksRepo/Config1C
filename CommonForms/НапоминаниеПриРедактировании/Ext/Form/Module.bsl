﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	БольшеНеПоказывать = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СисИнфо = Новый СистемнаяИнформация;
	
	Если Найти(СисИнфо.ИнформацияПрограммыПросмотра, "Firefox") <> 0 Тогда
		Элементы.Дополнения.ТекущаяСтраница = Элементы.MozillaFireFox;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(БольшеНеПоказывать);
	
КонецПроцедуры
