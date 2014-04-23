﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.Подразделение.ВидПодразделения <> Перечисления.ВидыПодразделений.Производство Тогда
			ТекстОшибки = "Установка доступности номенклатуры возможна только для производственных подразделений";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			Отказ = Истина;
		КонецЕсли;
		
		Если НЕ Запись.Номенклатура.Базовый Тогда
			ТекстОшибки = "Установка доступности возможна только для производственных подразделений";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			Отказ = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
