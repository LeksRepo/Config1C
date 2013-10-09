﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Процедура ПриЗаписи(Отказ)
	
	ОбщегоНазначения.УстановитьЗначенияДополнительныхКонстант(Значение, Метаданные().Имя);
	
	Если Значение = Истина Тогда
		
		СтандартныеПодсистемыПереопределяемый.ПриВключенииСинхронизацииДанных(Отказ);
		
	ИначеЕсли Значение = Ложь Тогда
		
		СтандартныеПодсистемыПереопределяемый.ПриОтключенииСинхронизацииДанных(Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли