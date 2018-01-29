﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.ЦеховойЛимит.Записывать = Истина;
	
	Для Каждого День Из ТаблицаДней Цикл
		
		Запись = Движения.ЦеховойЛимит.Добавить();
		Запись.Период = НачалоДня(День.Дата);
		Запись.КоличествоКоробов = День.КоличествоКоробов;
		Запись.КоличествоДеталейПлан = День.КоличествоДеталей;
		Запись.КоличествоДоставокПлан = День.КоличествоДоставок;
		Запись.СтоимостьУслуг = День.Норматив;
		Запись.Подразделение = Подразделение;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Дата = КонецМесяца(ТекущаяДата());
	КонецЕсли;
	
КонецПроцедуры
