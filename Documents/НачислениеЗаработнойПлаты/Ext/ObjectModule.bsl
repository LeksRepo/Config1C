﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	// { Васильев Александр Леонидович [24.09.2013]
	//Движения.Записать();
	// Лёша, зачем эта строка?
	// } Васильев Александр Леонидович [24.09.2013]
	
	// Затратный счет не обязательно получать в каждой строке
	ЗатратныйСчет = ЛексСервер.ПолучитьЗатратныйСчетПодразделения(Подразделение);
	Для Каждого ТекСтрокаСписокФизлиц Из СписокФизлиц Цикл
		Движение = Движения.Управленческий.Добавить();
		Движение.Период = Дата;
		Движение.Подразделение = Подразделение;
		Движение.Сумма = ТекСтрокаСписокФизлиц.Сумма;
		Движение.Содержание = ТекСтрокаСписокФизлиц.Комментарий;
		
		Движение.СчетДт = ЗатратныйСчет;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = ТекСтрокаСписокФизлиц.Статья;
		Движение.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = ТекСтрокаСписокФизлиц.ФизЛицо;
		
	КонецЦикла;
	
	Движения.Управленческий.Записывать = Истина;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//СуммаДокумента = СписокФизлиц.Итог("Сумма");
	
КонецПроцедуры
