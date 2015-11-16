﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Спецификация = ПараметрКоманды;
	
	Если НЕ ЗначениеЗаполнено(Спецификация) 
		ИЛИ ТипЗнч(Спецификация) <> Тип("ДокументСсылка.Спецификация") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Форма = ПараметрыВыполненияКоманды.Источник;
	
	Отказ = ИзменитьОкруглениеДоЛистов(Спецификация);
	
	Если НЕ Отказ Тогда
		
		ОповеститьОбИзменении(Спецификация);
		Форма.Прочитать();
		Форма.Записать();
		
		Если Форма.Модифицированность Тогда
			ИзменитьОкруглениеДоЛистов(Спецификация);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИзменитьОкруглениеДоЛистов(СпецификацияСсылка)
	
	Отказ = Ложь;
	ТекстСообщения = "";
	
	ТекущийСтатус = Документы.Спецификация.ПолучитьСтатусСпецификации(СпецификацияСсылка);
	
	Если ТекущийСтатус <> Перечисления.СтатусыСпецификации.Сохранен Тогда
			
			ТекстСообщения = "Изменить округление до листов можно только в спецификации со статусом 'Сохранен'. У %1 статус '%2'";
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СпецификацияСсылка, ТекущийСтатус);
			Отказ = Истина;
			
		КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Документы.Спецификация.УстановитьОкруглятьДоЛистов(СпецификацияСсылка);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, СпецификацияСсылка);
		
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции
