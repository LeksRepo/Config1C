﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Информация при запуске"
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий

// Вызывается при запуске конфигурации, открывает окно информации.
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.Свойство("ИнформацияПриЗапуске") И ПараметрыКлиента.ИнформацияПриЗапуске.Показывать Тогда
		ОткрытьФорму("Обработка.ИнформацияПриЗапуске.Форма");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
