﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ВыплатаИзКассы = ТипЗнч(СчетКасса) = Тип("СправочникСсылка.Кассы");
	
	Если ВыплатаИзКассы Тогда
		СчетКт = ПланыСчетов.Управленческий.Касса;
		ВидСубконтоКт = ПланыВидовХарактеристик.ВидыСубконто.Кассы;
	Иначе 
		СчетКт = ПланыСчетов.Управленческий.РасчетныйСчет;
		ВидСубконтоКт = ПланыВидовХарактеристик.ВидыСубконто.РасчетныйСчет;
	КонецЕсли;
	
	Для Каждого ТекСтрокаСписокФизЛиц Из СписокФизЛиц Цикл
		
		Движение = Движения.Управленческий.Добавить();
		Движение.СчетКт = СчетКт;
		Движение.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
		Движение.Период = Дата;
		Движение.Подразделение = Подразделение;
		Движение.Сумма = ТекСтрокаСписокФизЛиц.Выплачено;
		Движение.Содержание = ТекСтрокаСписокФизЛиц.Комментарий;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = ТекСтрокаСписокФизЛиц.Сотрудник;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний] = Справочники.ВидыНачисленийУдержаний.ВыплатаЗаработнойПлаты;
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДДС] = ТекСтрокаСписокФизЛиц.Статья;
		Движение.СубконтоКт[ВидСубконтоКт] = СчетКасса;
		
	КонецЦикла;
	
	Движения.Управленческий.Записывать = Истина;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	СуммаДокумента = СписокФизЛиц.Итог("Выплачено");
	
КонецПроцедуры
