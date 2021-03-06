﻿////////////////////////////////////////////////////////////////////////////////
// Функции и процедуры обеспечения формирования бухгалтерских отчетов.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура заполняет список значений с ключами отчетов, которые поддерживаются подсистемой
//
Процедура СписокОтчетовПоддерживаемыхПодсистемой(СписокОтчетов) Экспорт
	
КонецПроцедуры

Процедура ОбработатьНаборДанныхСвязаннойИнформации(Схема, ИмяНабора, ПараметрыПоляВладельца, ИмяПоляПрефикс = "Субконто") Экспорт
	
	Если ПараметрыПоляВладельца.ИндексСубконто > 0 Тогда
		ПутьКДаннымОсновногоПоля = "";
		ЗаголовокОсновногоПоля = "";
		Для Каждого ПолеНабора Из Схема.НаборыДанных[ИмяНабора].Поля Цикл
			Если Найти(ПолеНабора.Поле, "СвязанноеПолеСсылка") = 1 Тогда
				ПутьКДаннымОсновногоПоля = ПолеНабора.ПутьКДанным;
				ЗаголовокОсновногоПоля = СтрЗаменить(ПолеНабора.Заголовок, ".Ссылка", "");
			КонецЕсли;
		КонецЦикла;
		Для Каждого ПолеНабора Из Схема.НаборыДанных[ИмяНабора].Поля Цикл
			Если Найти(ПолеНабора.Поле, "СвязанноеПоле") = 1 Тогда
				ПолеНабора.ПутьКДанным = СтрЗаменить(ПолеНабора.ПутьКДанным, ПутьКДаннымОсновногоПоля, ИмяПоляПрефикс + ПараметрыПоляВладельца.ИндексСубконто);
				ПолеНабора.Заголовок   = СтрЗаменить(ПолеНабора.Заголовок, ЗаголовокОсновногоПоля, ПараметрыПоляВладельца.ЗаголовокСубконто);
				ПолеНабора.ОграничениеИспользования.Группировка = Истина;
				ПолеНабора.ОграничениеИспользования.Поле = Ложь;
				ПолеНабора.ОграничениеИспользования.Условие = Истина;
				ПолеНабора.ОграничениеИспользования.Порядок = Ложь;
			КонецЕсли;
		КонецЦикла;
		Для Каждого Связь Из Схема.СвязиНаборовДанных Цикл
			Если Связь.НаборДанныхПриемник = ИмяНабора Тогда
				Связь.ВыражениеИсточник = ИмяПоляПрефикс + ПараметрыПоляВладельца.ИндексСубконто;
				Связь.ВыражениеПриемник = ИмяПоляПрефикс + ПараметрыПоляВладельца.ИндексСубконто;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Для Каждого ПолеНабора Из Схема.НаборыДанных[ИмяНабора].Поля Цикл
			Если Найти(ПолеНабора.Поле, "СвязанноеПоле") = 1 Тогда
				ПолеНабора.ОграничениеИспользования.Группировка = Истина;
				ПолеНабора.ОграничениеИспользования.Поле = Истина;
				ПолеНабора.ОграничениеИспользования.Условие = Истина;
				ПолеНабора.ОграничениеИспользования.Порядок = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
