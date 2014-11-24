﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	БухгалтерскийУчетСервер.ПроведениеДенежныхСредств(Ссылка, Движения);
	
	Если СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями Тогда
		
		ТипСубконто2 = ТипЗнч(Субконто2Дт);
		
		Если ТипСубконто2 = Тип("ДокументСсылка.Договор")
			ИЛИ ТипСубконто2 = Тип("ДокументСсылка.ДополнительноеСоглашение")
			ИЛИ ТипСубконто2 = Тип("ДокументСсылка.Спецификация") Тогда
			ДвиженияПоказатели();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДвиженияПоказатели()
	
	ТипСубконто2 = ТипЗнч(Субконто2Дт);
	
	Если ТипСубконто2 = Тип("ДокументСсылка.Договор") Тогда
		ФизЛицо = Субконто2Дт.Автор.ФизическоеЛицо;
		ДобавитьПоказательСотруднику(ФизЛицо, Перечисления.ВидыПоказателейСотрудников.Выручка, Сумма, Субконто2Дт);
	ИначеЕсли ТипСубконто2 = Тип("ДокументСсылка.ДополнительноеСоглашение") Тогда
		ФизЛицо = Субконто2Дт.Договор.Автор.ФизическоеЛицо;
		ДобавитьПоказательСотруднику(ФизЛицо, Перечисления.ВидыПоказателейСотрудников.Выручка, Сумма, Субконто2Дт);
	ИначеЕсли ТипСубконто2 = Тип("ДокументСсылка.Спецификация") Тогда
		ФизЛицо = Субконто2Дт.Автор.ФизическоеЛицо;
		ДобавитьПоказательСотруднику(ФизЛицо, Перечисления.ВидыПоказателейСотрудников.Выручка, Сумма, Субконто2Дт);
		ДобавитьПоказательСотруднику(ФизЛицо, Перечисления.ВидыПоказателейСотрудников.ВыручкаЗаДетали, Сумма, Субконто2Дт);
	КонецЕсли;
	
КонецПроцедуры

Функция ДобавитьПоказательСотруднику(ФизЛицо, ВидПоказателя, Значение, Основание)
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = Дата;
	Проводка.Подразделение = Подразделение;
	Проводка.Содержание = "К документу " + Основание;
	Проводка.СчетКт = ПланыСчетов.Управленческий.ПоказателиСотрудника;
	Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ВидыПоказателейСотрудников] = ВидПоказателя;
	Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = ФизЛицо;
	Проводка.Сумма = Значение;
	
КонецФункции

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
		Если НЕ (СчетДт.ВидыСубконто[Счетчик-1].ВидСубконто=ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор ИЛИ СчетДт.ВидыСубконто[Счетчик-1].ВидСубконто=ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний) Тогда
			ПроверяемыеРеквизиты.Добавить("Субконто"+Счетчик+"Дт");
		КонецЕсли;			
	КонецЦикла;
	Для Счетчик = 1 По КоличествоКт Цикл
		Если НЕ (СчетКт.ВидыСубконто[Счетчик-1].ВидСубконто=ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор ИЛИ СчетКт.ВидыСубконто[Счетчик-1].ВидСубконто=ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний) Тогда
			ПроверяемыеРеквизиты.Добавить("Субконто"+Счетчик+"Кт");
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры
