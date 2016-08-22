﻿
&НаКлиенте
Процедура Сформировать(Команда)
	
	Если НЕ ЗначениеЗаполнено(Период) Тогда	
		Период.Вариант = ВариантСтандартногоПериода.ЭтотГод;	
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Контрагент) ИЛИ НЕ ЗначениеЗаполнено(Организация) ИЛИ НЕ ЗначениеЗаполнено(Подразделение) Тогда
		Сообщить("Заполните поля: Контрагент, Организация, Подразделение");
		Возврат;		
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	
	ПараметрыОтчета.Вставить("Период", Период);
	ПараметрыОтчета.Вставить("Контрагент", Контрагент);
	ПараметрыОтчета.Вставить("Организация", Организация);
	ПараметрыОтчета.Вставить("Подразделение", Подразделение);

	СформироватьНаСервере(ТабличныйДокумент, ПараметрыОтчета);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СформироватьНаСервере(ТабличныйДокумент, ПараметрыОтчета)
	
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент = Отчеты.АктСверки.СформироватьОтчет(ПараметрыОтчета);
	
КонецПроцедуры
