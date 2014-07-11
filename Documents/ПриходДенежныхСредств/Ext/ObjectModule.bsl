﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	БухгалтерскийУчетСервер.ПроведениеДенежныхСредств(Ссылка, Движения);
	
	Если СчетДт = ПланыСчетов.Управленческий.РасчетныйСчет И
		Субконто2Дт.ПринадлежитПодразделению <> Подразделение Тогда
		ВзаиморасчетыПодразделений();
	КонецЕсли;
	
	Если СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями Тогда
		Если ТипЗнч(Субконто2Кт) = Тип("ДокументСсылка.Договор") ИЛИ ТипЗнч(Субконто2Кт) = Тип("ДокументСсылка.ДополнительноеСоглашение") Тогда
			ДобавитьПоказателиСотрудникам();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВзаиморасчетыПодразделений()
	
	ДопПроводки = Движения.Управленческий.Добавить();
	ДопПроводки.Период = Дата;
	ДопПроводки.СчетДт = ЛексСервер.ПолучитьЗатратныйСчетПодразделения(Подразделение);
	ДопПроводки.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПоставщиками;
	ДопПроводки.Подразделение = Подразделение;
	ДопПроводки.Сумма = Сумма;
	ДопПроводки.Содержание = "Взаиморасчеты между подразделениями";
	
	ДопПроводки = Движения.Управленческий.Добавить();
	ДопПроводки.Период = Дата;
	ДопПроводки.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПоставщиками;
	ДопПроводки.СчетКт = ПланыСчетов.Управленческий.Доходы;
	ДопПроводки.Подразделение = Субконто2Дт.ПринадлежитПодразделению;
	ДопПроводки.Сумма = Сумма;
	ДопПроводки.Содержание = "Взаиморасчеты между подразделениями";
	
КонецПроцедуры

Процедура ДобавитьПоказателиСотрудникам()
	
	Если ТипЗнч(Субконто2Кт) = Тип("ДокументСсылка.ДополнительноеСоглашение") Тогда
		ПроцентПоделиться = Субконто2Кт.Договор.ПроцентПоделиться / 100;
		ПроцентАвтора = 1 - ПроцентПоделиться;
		ФизЛицоПоделиться = Субконто2Кт.Договор.Поделиться;
	Иначе
		ПроцентПоделиться = Субконто2Кт.ПроцентПоделиться / 100;
		ПроцентАвтора = 1 - ПроцентПоделиться;
		ФизЛицоПоделиться = Субконто2Кт.Поделиться;
	КонецЕсли;                                                  
	
	ДопПроводки = Движения.Управленческий.Добавить();
	ДопПроводки.Период = Дата;
	ДопПроводки.СчетДт = ПланыСчетов.Управленческий.ПоказателиСотрудника;
	ДопПроводки.Подразделение = Подразделение;
	ДопПроводки.СубконтоДт.ВидыПоказателейСотрудников = Перечисления.ВидыПоказателейСотрудников.ВыручкаПоДоговорам;
	ДопПроводки.СубконтоДт.ФизическиеЛица = Субконто2Кт.Автор.ФизическоеЛицо;
	ДопПроводки.Сумма = Сумма * ПроцентАвтора;
	
	ДопПроводки.Содержание = "Показатели сотрудников";
	
	Если ПроцентПоделиться <> 0 Тогда
		
		ДопПроводки = Движения.Управленческий.Добавить();
		ДопПроводки.Период = Дата;
		ДопПроводки.СчетДт = ПланыСчетов.Управленческий.ПоказателиСотрудника;
		ДопПроводки.Подразделение = Подразделение;
		ДопПроводки.СубконтоДт.ВидыПоказателейСотрудников = Перечисления.ВидыПоказателейСотрудников.ВыручкаПоДоговорам;
		ДопПроводки.СубконтоДт.ФизическиеЛица = ФизЛицоПоделиться;
		ДопПроводки.Сумма = Сумма * ПроцентПоделиться;
		ДопПроводки.Содержание = "Показатели сотрудников";
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	Если ЭтоНовый() Тогда
		
		ЛексСервер.ПрисвоитьФискальныйНомер(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	КоличествоДт = СчетДт.ВидыСубконто.Количество();
	КоличествоКт = СчетКт.ВидыСубконто.Количество();
	Для Счетчик = 1 По КоличествоДт Цикл
		Если НЕ СчетДт.ВидыСубконто[Счетчик-1].ВидСубконто=ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор Тогда
			ПроверяемыеРеквизиты.Добавить("Субконто"+Счетчик+"Дт");
		КонецЕсли;			
	КонецЦикла;
	Для Счетчик = 1 По КоличествоКт Цикл
		Если НЕ СчетКт.ВидыСубконто[Счетчик-1].ВидСубконто=ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор Тогда
			ПроверяемыеРеквизиты.Добавить("Субконто"+Счетчик+"Кт");
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры

