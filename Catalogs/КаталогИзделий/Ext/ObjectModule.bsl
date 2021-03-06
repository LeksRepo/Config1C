﻿
Процедура ПриЗаписи(Отказ)
	
	Если СписокДопЭлементов.Количество() > 0  И НЕ ЗначениеЗаполнено(Шаг) Тогда
		
		Текст = "Для изделий с доп. элементами укажите шаг";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, "Шаг");
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЭтоГруппа Тогда
		Если СтатусИзделияПоКаталогу <> Ссылка.СтатусИзделияПоКаталогу Тогда
			
			ДатаУстановкиСтатуса = ТекущаяДата();
			АвторСменыСтатуса = ПараметрыСеанса.ТекущийПользователь;
			
		КонецЕсли;
		
		Если ВидИзделияПоКаталогу <> Справочники.ВидыИзделийПоКаталогу.ОсновнойЭлемент И СписокХарактеристик.Количество() > 0 Тогда
			
			СписокХарактеристик.Очистить();
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

