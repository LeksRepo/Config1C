﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
 
#Область СлужебныеПроцедурыИФункции
 
// Заполняет настройки вариантов отчета.
// Подробнее - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	
	Отчет = МодульВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ЗадачиИстекающиеНаДату);
	Отчет.Описание = НСтр("ru = 'Список задач, которые должны быть выполнены к указанной дате.'");
	
	Вариант = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ЗадачиИстекающиеНаДату");
	Вариант.Описание = НСтр("ru = 'Список задач, которые должны быть выполнены к указанной дате.'");
	
КонецПроцедуры
 
#КонецОбласти

#КонецЕсли