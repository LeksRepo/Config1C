﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИсторияПоиска = ИсторияПоиска();
	Если ТипЗнч(ИсторияПоиска) = Тип("Массив") Тогда
		Элементы.СтрокаПоиска.СписокВыбора.ЗагрузитьЗначения(ИсторияПоиска);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	
	ПодключитьОбработчикОжидания("ОткрытьФормуПоиска", 0.1, Истина);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОткрытьФормуПоиска()
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		Предупреждение(НСтр("ru = 'Введите, что нужно найти.'"));
		Возврат;
	КонецЕсли;
	
	ФормаПараметры = Новый Структура;
	ФормаПараметры.Вставить("ПереданнаяСтрокаПоиска", СтрокаПоиска);
	
	ФормаИмя = СтрЗаменить(ИмяФормы, ".УпрощеннаяФорма", ".Форма");
	ОткрытьФорму(ФормаИмя, ФормаПараметры, , Истина);
	
	ИсторияПоиска = ИсторияПоиска();
	Если ТипЗнч(ИсторияПоиска) = Тип("Массив") Тогда
		Элементы.СтрокаПоиска.СписокВыбора.ЗагрузитьЗначения(ИсторияПоиска);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИсторияПоиска()
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска");
КонецФункции

