﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Управленческий.Очистить();
	Движения.Управленческий.Записать();
	
	Для Каждого Строка из СписокНоменклатуры Цикл
		
		Проводки = Движения.Управленческий.Добавить();
		Проводки.Период = Дата;
		Проводки.Подразделение = Подразделение;
		
		Проводки.КоличествоДт = - Строка.Количество;
		
		Проводки.СчетДт = ПланыСчетов.Управленческий.ОсновноеПроизводство;
		Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Строка.Номенклатура;
		
		Проводки.СчетКт = ПланыСчетов.Управленческий.Доходы;
		Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ОприходованиеМатериалов;
		
	КонецЦикла;;
	
	Если НЕ Отказ Тогда
		
		Движения.Управленческий.Записывать = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
		ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры
