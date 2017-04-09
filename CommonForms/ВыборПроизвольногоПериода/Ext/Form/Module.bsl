﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НачалоПериода = Параметры.НачалоПериода;
	КонецПериода  = Параметры.КонецПериода;
	
	Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
		НачалоПериода = ФункцииОтчетовКлиентСервер.НачалоПериодаОтчета(Параметры.МинимальныйПериод, ТекущаяДатаСеанса());
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода  = ФункцииОтчетовКлиентСервер.КонецПериодаОтчета(Параметры.МинимальныйПериод, ТекущаяДатаСеанса());
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	Если НачалоПериода > КонецПериода Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Дата начала периода больше чем дата окончания периода'"), , "НачалоПериода");
		Возврат;
	КонецЕсли;
	
	РезультатВыбора = Новый Структура("НачалоПериода, КонецПериода");
	ЗаполнитьЗначенияСвойств(РезультатВыбора, ЭтаФорма);
	
	Закрыть(РезультатВыбора);
КонецПроцедуры
