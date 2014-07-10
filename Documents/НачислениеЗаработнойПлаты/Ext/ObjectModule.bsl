﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	ЗатратныйСчет = ЛексСервер.ПолучитьЗатратныйСчетПодразделения(Подразделение);
	
	Для Каждого ТекСтрокаСписокФизлиц Из СписокФизлиц Цикл
		
		Движение = Движения.Управленческий.Добавить();
		Движение.Период = Дата;
		Движение.Подразделение = Подразделение;
		Движение.Сумма = ТекСтрокаСписокФизлиц.Сумма;
		Движение.Содержание = ТекСтрокаСписокФизлиц.Комментарий;
		
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний] = ТекСтрокаСписокФизлиц.ВидыНачисленийУдержаний;
		
		Движение.СчетДт = ЗатратныйСчет;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = ТекСтрокаСписокФизлиц.Статья;
		Движение.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = ТекСтрокаСписокФизлиц.ФизЛицо;
		
	КонецЦикла;
	
	Движения.Управленческий.Записывать = Истина;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	СуммаДокумента = СписокФизлиц.Итог("Сумма");
	
КонецПроцедуры
