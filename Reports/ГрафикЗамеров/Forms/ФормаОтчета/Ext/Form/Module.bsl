﻿
&НаКлиенте
Процедура Сформировать(Команда)
	
	Если НЕ ЗначениеЗаполнено(Период) Тогда
		
		Период.Вариант = ВариантСтандартногоПериода.ЭтаНеделя;
		
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	
	ПараметрыОтчета.Вставить("Период", Период);
	ПараметрыОтчета.Вставить("Замерщик", Замерщик);
	ПараметрыОтчета.Вставить("Подразделение", Подразделение);
	СформироватьНаСервере(ТабДок, ПараметрыОтчета);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СформироватьНаСервере(ТабДок, ПараметрыОтчета)
	
	ТабДок.Очистить();
	ТабДок = Отчеты.ГрафикЗамеров.СформироватьОтчет(ПараметрыОтчета);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Период.Вариант = ВариантСтандартногоПериода.Следующие7Дней;
	
КонецПроцедуры

