﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ОткрытьЗначение(Элементы.Список.ТекущиеДанные.БизнесПроцесс);
 	КонецЕсли;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ОткрытьЗначение(Элемент.ТекущиеДанные.БизнесПроцесс);
		Отказ = Истина;
 	КонецЕсли;       
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПометкаУдаления(Команда)
	БизнесПроцессыИЗадачиКлиент.СписокБизнесПроцессовПометкаУдаления(Элементы.Список);
КонецПроцедуры
