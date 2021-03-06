﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
 
#Область СлужебныеПроцедурыИФункции
 
// Заполняет настройки вариантов отчета.
// Подробнее - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	
	Отчет = МодульВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.БизнесПроцессы);
	Отчет.Описание = НСтр("ru = 'Список и сводная статистика по всем бизнес-процессам.'");
	
	Вариант = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "СписокБизнесПроцессов");
	Вариант.Описание = НСтр("ru = 'Список бизнес-процессов определенных видов за указанный интервал.'");
	
	Вариант = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "СтатистикаПоВидам");
	Вариант.Описание = НСтр("ru = 'Сводная диаграмма по количеству активных и завершенных бизнес-процессов.'");
	
КонецПроцедуры
 
#КонецОбласти

#КонецЕсли