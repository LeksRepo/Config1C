﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Обороты = Документы.ДополнительноеСоглашение.ПолучитьСуммыПлатежей(Ссылка);
	
	Если СуммаДокумента > 0 И Обороты.ОборотКт <> СуммаДокумента Тогда
		Текст = "Примите полную предоплату " + СуммаДокумента + " руб.";
	ИначеЕсли СуммаДокумента < 0 И Обороты.ОборотДт <> -СуммаДокумента Тогда
		Текст = "Проведите клиенту возврат на сумму " + -СуммаДокумента + " руб.";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, "СуммаДокумента");
		Отказ = Истина;
	КонецЕсли;
	
	ЛексСервер.СформироватьПоказателиСотрудников(Движения, Ссылка);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Договор") Тогда
		Офис = ДанныеЗаполнения.Офис;
		Договор = ДанныеЗаполнения.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры
