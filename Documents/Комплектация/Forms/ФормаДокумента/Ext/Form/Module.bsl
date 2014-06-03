﻿
&НаКлиенте
Процедура СпецификацияПриИзменении(Элемент)
	
	Спецификация = Объект.Спецификация;
	ПерезаполнитьНаСервере(Спецификация);
	
КонецПроцедуры

&НаКлиенте
Процедура Перезаполнить(Команда)
	
	Ошибки 				= Неопределено;
	Спецификация 	= Объект.Спецификация;
	
	Если НЕ ЗначениеЗаполнено(Объект.Подразделение) Тогда
		
		ТекстСообщения = "Не выбрано подразделение";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Подразделение", ТекстСообщения);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Спецификация) Тогда
		
		ТекстСообщения = "Не выбрана спецификация";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Спецификация", ТекстСообщения);
		
	КонецЕсли;
	
	Если Ошибки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		Возврат;
		
	КонецЕсли;
	
	ПерезаполнитьНаСервере(Спецификация);
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьНаСервере(СпецификацияСсылка)
	
	Объект.СписокНоменклатуры.Очистить();
	
	Выборка = Документы.Спецификация.ПерезаполнитьКомплектацию(СпецификацияСсылка);
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.СписокНоменклатуры.Добавить();
		НоваяСтрока.Номенклатура = Выборка.Номенклатура;
		НоваяСтрока.КоличествоСклад = Выборка.КоличествоСклад;
		НоваяСтрока.КоличествоЦех = Выборка.КоличествоЦех;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Спецификация = Объект.Спецификация;
	
	Если Объект.Ссылка = Документы.Комплектация.ПустаяСсылка() И ЗначениеЗаполнено(Объект.Спецификация) И ЗначениеЗаполнено(Объект.Подразделение) Тогда
		
		ПерезаполнитьНаСервере(Спецификация);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры
