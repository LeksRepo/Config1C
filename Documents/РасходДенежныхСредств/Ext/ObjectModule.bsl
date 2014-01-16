﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	БухгалтерскийУчетСервер.ПроведениеДенежныхСредств(Ссылка, Движения);
	
	Если СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями Тогда
		Если ТипЗнч(Субконто2Дт) = Тип("ДокументСсылка.Договор") ИЛИ ТипЗнч(Субконто2Кт) = Тип("ДокументСсылка.ДополнительноеСоглашение") Тогда
			ДобавитьПоказателиСотрудникам();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//Для Каждого Элемент Из СчетДт.ВидыСубконто Цикл
	//	ПроверяемыеРеквизиты.Добавить("Субконто" +Элемент.НомерСтроки+ "Дт");
	//КонецЦикла;
	//
	//Для Каждого Элемент Из СчетКт.ВидыСубконто Цикл
	//	ПроверяемыеРеквизиты.Добавить("Субконто" +Элемент.НомерСтроки+ "Кт");
	//КонецЦикла;	
	
КонецПроцедуры

Процедура ДобавитьПоказателиСотрудникам()
	
	ПроцентПоделиться = Субконто2Дт.ПроцентПоделиться / 100;
	ПроцентАвтора = 1 - ПроцентПоделиться;
	
	СоздатьПроводкуПоказательСотрудника(Субконто2Дт.Автор.ФизическоеЛицо, Сумма * ПроцентПоделиться);
	
	Если ПроцентПоделиться <> 0 Тогда
		
		СоздатьПроводкуПоказательСотрудника(Субконто2Дт.Поделиться, Сумма * ПроцентАвтора)
		
	КонецЕсли;
	
КонецПроцедуры

Функция СоздатьПроводкуПоказательСотрудника(ФизическоеЛицо, Сумма)
	
	ДопПроводки = Движения.Управленческий.Добавить();
	ДопПроводки.Период = Дата;
	ДопПроводки.Подразделение = Подразделение;
	ДопПроводки.СчетКт = ПланыСчетов.Управленческий.ПоказателиСотрудника;
	ДопПроводки.СубконтоКт.ВидыПоказателейСотрудников = Перечисления.ВидыПоказателейСотрудников.ВыручкаПоДоговорам;
	ДопПроводки.СубконтоКт.ФизическиеЛица = ФизическоеЛицо;
	ДопПроводки.Сумма = Сумма;
	
КонецФункции
