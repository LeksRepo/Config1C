﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ВладелецФайла") Тогда 
		Список.Параметры.УстановитьЗначениеПараметра(
			"Владелец", Параметры.ВладелецФайла);
	
		Если ТипЗнч(Параметры.ВладелецФайла) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
			Элементы.Папки.ТекущаяСтрока = Параметры.ВладелецФайла;
			Элементы.Папки.ВыделенныеСтроки.Очистить();
			Элементы.Папки.ВыделенныеСтроки.Добавить(Элементы.Папки.ТекущаяСтрока);
		Иначе
			Элементы.Папки.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Если Параметры.Свойство("ВыборШаблона") И Параметры.ВыборШаблона Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Группы, "Ссылка", Справочники.ПапкиФайлов.Шаблоны,
				ВидСравненияКомпоновкиДанных.ВИерархии, , Истина);
			
			Элементы.Папки.ТекущаяСтрока = Справочники.ПапкиФайлов.Шаблоны;
			Элементы.Папки.ВыделенныеСтроки.Очистить();
			Элементы.Папки.ВыделенныеСтроки.Добавить(Элементы.Папки.ТекущаяСтрока);
		КонецЕсли;
		
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Папки

&НаКлиенте
Процедура ГруппыПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	
	Параметр = Новый Структура;
	Параметр.Вставить("ФайлСсылка", ФайлСсылка);
	
	ОповеститьОВыборе(Параметр);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработкаОжидания()
	
	Если Элементы.Папки.ТекущаяСтрока <> Неопределено Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;	
	
КонецПроцедуры

