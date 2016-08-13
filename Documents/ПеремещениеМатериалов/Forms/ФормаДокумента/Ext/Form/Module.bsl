﻿
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.Склад = Объект.СкладПолучатель Тогда
		
		Отказ = Истина;
		ТекстСообщения = "Выберите разные склады";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, "ДатаПоступления");
	
	КонецЕсли; 
	
	Если Объект.Подразделение <> Объект.ПодразделениеПолучатель 
		 И ЗначениеЗаполнено(Объект.ДатаПоступления) 
		 И НачалоДня(Объект.Дата) > Объект.ДатаПоступления Тогда
		
		Отказ = Истина;
		
		ТекстСообщения = "Дата поступления не может быть меньше даты перемещения";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, "ДатаПоступления"); 
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПолучательПриИзменении(Элемент)
	
	Если Объект.Подразделение = Объект.ПодразделениеПолучатель Тогда
		Элементы.ДатаПоступления.Доступность = Ложь;
	Иначе
		Элементы.ДатаПоступления.Доступность = Истина;
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Если Объект.Подразделение = Объект.ПодразделениеПолучатель Тогда
		Элементы.ДатаПоступления.Доступность = Ложь;
	Иначе
		Элементы.ДатаПоступления.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если Объект.Подразделение = Объект.ПодразделениеПолучатель Тогда
		Элементы.ДатаПоступления.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоступноПринятие = ЛексСервер.ДоступноПринятиеБухгалтером(Объект.Ссылка);
	
	Если ЗначениеЗаполнено(Объект.ДатаПередачи) 
	   И ЗначениеЗаполнено(Объект.ОтветственныйЗаХранение)
	   И НЕ ДоступноПринятие Тогда
	   
	   ЭтаФорма.ТолькоПросмотр = Истина;
	   
   КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ТекущийОбъект.ДатаПередачи)
	   И ЗначениеЗаполнено(ТекущийОбъект.ОтветственныйЗаХранение) Тогда
	    ТекущийОбъект.СданВАрхив = Истина;
    Иначе
	    ТекущийОбъект.СданВАрхив = Ложь;
    КонецЕсли;
	
КонецПроцедуры


