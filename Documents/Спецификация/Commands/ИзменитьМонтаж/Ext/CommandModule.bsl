﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если НЕ ЗначениеЗаполнено(ПараметрКоманды) ИЛИ ТипЗнч(ПараметрКоманды) <> Тип("ДокументСсылка.Спецификация") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Спецификация", ПараметрКоманды);
	ПараметрыФормы.Вставить("Город", ПолучитьГород(ПараметрКоманды));
	
	Если ОпределитьМонтаж(ПараметрКоманды) Тогда
		ОткрытьФорму("Документ.Спецификация.Форма.ФормаВыбораМонтажника", ПараметрыФормы);
	Иначе
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("В спецификации %1 нет монтажа", ПараметрКоманды);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОпределитьМонтаж(СпецификацияСсылка)
	
	ПакетУслугСпецификации = ЛексСервер.ЗначениеРеквизитаОбъекта(СпецификацияСсылка, "ПакетУслуг");
	Возврат ПакетУслугСпецификации = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж;
	
КонецФункции

&НаСервере
Функция ПолучитьГород(Спецификация)
	
	Возврат Спецификация.Подразделение.Город;
	
КонецФункции // ПолучитьГород()
