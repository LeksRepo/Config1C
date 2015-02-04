﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Регистратор = Отбор.Регистратор.Значение;
	
	Ошибки = Неопределено;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если НЕ Запись.Номенклатура.Базовый Тогда
			
			ТекстОшибки = "Ноиенклатура '%1' не является базовой";
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Запись.Номенклатура);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Регистратор, ТекстОшибки);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры