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
	
	Если Параметры.Свойство("ТекущаяСтрока") Тогда 
		Элементы.Папки.ТекущаяСтрока = Параметры.ТекущаяСтрока;
	КонецЕсли;
	
	Если РаботаСФайламиСлужебныйВызовСервера.ПолучитьИспользоватьЭлектронныеЦифровыеПодписиИШифрование() = Ложь Тогда
		Элементы.ПодписанЭЦП.Видимость = Ложь;
		Элементы.Зашифрован.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Папки

&НаКлиенте
Процедура ГруппыПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура обновляет список Файлов
&НаКлиенте
Процедура ОбработкаОжидания()
	
	Если Элементы.Папки.ТекущаяСтрока <> Неопределено Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;	
	
КонецПроцедуры

