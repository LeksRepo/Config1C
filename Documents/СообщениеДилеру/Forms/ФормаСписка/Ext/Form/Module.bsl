﻿&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		СтандартнаяОбработка=Ложь;
		ОткрытьФормуЭлемента(Элемент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		Отказ=Истина;
		ОткрытьФормуЭлемента(Элемент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЭлемента(Элемент)
	
	ПараметрыФормы = Новый Структура("Ключ", Элемент.ТекущиеДанные.Ссылка);
	ОткрытьФорму("Документ.СообщениеДилеру.Форма.ФормаПросмотра", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		Дилер=ПользователиКлиентСервер.ТекущийВнешнийПользователь();
		Элементы.Ознакомленные.Видимость = Ложь;
	Иначе
		Дилер=Ложь;
	КонецЕсли; 
	
	Список.Параметры.УстановитьЗначениеПараметра("Дилер", Дилер);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)      
	Если ИмяСобытия = "ОбновитьСписок" Тогда       
		Элементы.Список.Обновить();
 	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Ознакомленные(Команда)
	ПараметрыФормы = Новый Структура("Сообщение", Элементы.Список.ТекущиеДанные.Ссылка);
	ОткрытьФорму("Документ.СообщениеДилеру.Форма.ФормаОзнакомленные", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры

 
