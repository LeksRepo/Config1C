﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет запись в регистр по переданным значениям структуры
Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияОбменовДаннымиОбластейДанных");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли