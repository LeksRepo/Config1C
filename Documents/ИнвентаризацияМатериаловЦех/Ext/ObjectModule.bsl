﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Для Каждого Строка Из СписокНоменклатуры Цикл
		
		Если НЕ Строка.Номенклатура.Базовый Тогда
			
			Отказ = Истина;
			Сообщить("Не допускается НЕ Базовая номенклатура: "+Строка.Номенклатура.Наименование);
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;	
		
КонецПроцедуры
