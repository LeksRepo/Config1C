﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контактная информация".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ОбработкаЗаполненияКИ(Источник, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	// Заполним наименование
	Наименование = "";
	Если ДанныеЗаполнения.Свойство("Наименование", Наименование) Тогда
		Источник.Наименование = Наименование;
	КонецЕсли;
	
	// Заполним контактную информацию
	КонтактнаяИнформация = Неопределено;
	Если ДанныеЗаполнения.Свойство("КонтактнаяИнформация", КонтактнаяИнформация) Тогда
		Для Каждого СтрокаКИ Из КонтактнаяИнформация Цикл
			
			НоваяСтрокаКИ = Источник.КонтактнаяИнформация.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаКИ, СтрокаКИ);
			
			Если ТипЗнч(СтрокаКИ.ЗначенияПолей) = Тип("СписокЗначений") Тогда
				НоваяСтрокаКИ.ЗначенияПолей = Новый ХранилищеЗначения(СтрокаКИ.ЗначенияПолей);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры
