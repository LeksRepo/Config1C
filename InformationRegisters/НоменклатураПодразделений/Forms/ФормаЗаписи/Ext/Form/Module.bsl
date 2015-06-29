﻿
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Перем Ошибки;
	
	Если НЕ ТекущийОбъект.ОкруглятьДоЛистов Тогда
		
		ТребоватьПроцентОтхода = ТекущийОбъект.Номенклатура.НоменклатурнаяГруппа.ТребоватьПроцентОтхода;
		Если ТребоватьПроцентОтхода 
			И ТекущийОбъект.ПроцентОтхода = 0 Тогда
			
			Сообщить("Установите процент отхода или включите округление до листов.");
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОВыборе("Ping");
	
КонецПроцедуры
