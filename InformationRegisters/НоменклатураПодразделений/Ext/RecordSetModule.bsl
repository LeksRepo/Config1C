﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если НЕ Запись.Номенклатура.Базовый Тогда
			ТекстОшибки = "Установка доступности возможна только для базовой номенклатуры";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			Отказ = Истина;
		КонецЕсли;
		
		НоменклатурнаяГруппа = Запись.Номенклатура.НоменклатурнаяГруппа;
		
		Если ЗначениеЗаполнено(НоменклатурнаяГруппа)
			И Запись.ОкруглятьДоЛистов
			И НЕ НоменклатурнаяГруппа.ПринадлежитЭлементу(Справочники.НоменклатурныеГруппы.Кромка) Тогда
			Запись.ПроцентОтхода = 0;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры