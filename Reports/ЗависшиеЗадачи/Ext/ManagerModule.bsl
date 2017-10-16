﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
 
#Область СлужебныеПроцедурыИФункции
 
// Заполняет настройки вариантов отчета.
// Подробнее - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	
	// ЗависшиеЗадачи
	Отчет = МодульВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ЗависшиеЗадачи);
	Отчет.Описание = НСтр("ru = 'Анализ зависших задач, которые не могут быть выполнены, так как у них не назначены исполнители.'");
	
	Вариант = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "СводкаПоЗависшимЗадачам");
	Вариант.Описание = НСтр("ru = 'Сводка по количеству зависших задач, назначенных на роли, для которых не задано ни одного исполнителя.'");
	
	Вариант = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ЗависшиеЗадачиПоИсполнителям");
	Вариант.Описание = НСтр("ru = 'Список зависших задач, назначенных на роли, для которых не задано ни одного исполнителя.'");
	
	Вариант = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ЗависшиеЗадачиПоОбъектамАдресации");
	Вариант.Описание = НСтр("ru = 'Список зависших задач по объектам адресации.'");
	
	Вариант = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ПросроченныеЗадачи");
	Вариант.Описание = НСтр("ru = 'Список просроченных и зависших задач, которые не могут быть выполнены, так как у них не назначены исполнители.'");
	
КонецПроцедуры
 
#КонецОбласти

#КонецЕсли