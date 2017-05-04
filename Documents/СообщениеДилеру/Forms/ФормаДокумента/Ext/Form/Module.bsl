﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбАвтор = Объект.Автор;
	
	Если ОбАвтор = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка") Тогда	
		ОбАвтор=ПараметрыСеанса.ТекущийПользователь;
		Элементы.Ознакомленные.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)	
	УдалитьОзнакомленные();
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаСервере
Процедура УдалитьОзнакомленные()
	
	Записи = РегистрыСведений.ОзнакомленСообщенияДилеру.СоздатьНаборЗаписей();
	Записи.Отбор.Сообщение.Установить(Объект.Ссылка);
	Записи.Прочитать();

	Для Каждого Зап Из Записи Цикл
	    Записи.Удалить(Зап);
	КонецЦикла;

	Записи.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура Ознакомленные(Команда)
	ПараметрыФормы = Новый Структура("Сообщение", Объект.Ссылка);
	ОткрытьФорму("Документ.СообщениеДилеру.Форма.ФормаОзнакомленные", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры
