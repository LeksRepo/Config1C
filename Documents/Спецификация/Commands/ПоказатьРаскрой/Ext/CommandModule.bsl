﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отказ = Ложь;
	
	СпецификацияСсылка = ПараметрКоманды[0];
	
	Состояние("Формирование раскроя, это может занять длительное время");
	СвойстваРаскроя = ОбновитьРаскройНаСервере(СпецификацияСсылка);
	СтрокаРаскрой = СвойстваРаскроя.СтрокаРаскрой;

	Если ЗначениеЗаполнено(СтрокаРаскрой) Тогда
		
		ВидОтображения = ПолучитьВидОтображенияФлэш(СпецификацияСсылка);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Спецификация", СпецификацияСсылка);
		ПараметрыФормы.Вставить("ХранимыйФайл", "НовыйРаскрой");
		ПараметрыФормы.Вставить("СтрокаНовогоРаскрояЛДСП", СтрокаРаскрой);
		ПараметрыФормы.Вставить("ВидОтображения", ВидОтображения);
		ОткрытьФорму("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы,, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВидОтображенияФлэш(Спецификация) Экспорт
	
	ВидОтображения = "2";
	
	Проведен = Спецификация.Проведен;
	Статус = Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация);
	
	Если Спецификация.Дилерский И НЕ (Проведен И (Статус <> Перечисления.СтатусыСпецификации.Сохранен)) Тогда	
		ВидОтображения = "3";
	КонецЕсли;
	
	Возврат ВидОтображения;
	
КонецФункции

&НаСервере
Функция ОбновитьРаскройНаСервере(Спецификация)
	
	Структура = РегистрыСведений.РаскройДеталей.СформироватьРаскрой(Спецификация, ,Истина);
	
	СтруктураПередачи = Новый Структура;
	СтруктураПередачи.Вставить("СтрокаКривогоПилаФРС", Структура.СтрокаКривогоПилаФРС);
	СтруктураПередачи.Вставить("СтрокаКривогоПилаСтеколка", Структура.СтрокаКривогоПилаСтеколка);
	СтруктураПередачи.Вставить("ТекущаяСтрокаРаскроя", Структура.ДанныеДляРаскроя);
	СтруктураПередачи.Вставить("СтрокаРаскрой", Структура.ДанныеДляРаскроя);
	СтруктураПередачи.Вставить("ТаблицаДеталей", Структура.ТаблицаДеталей);
	СтруктураПередачи.Вставить("ТаблицаДеталей", Структура.ТаблицаДеталей);
	
	Попытка
		СтруктураПередачи.Вставить("ЛучшийПроцентОтхода", Структура.ЛучшийПроцентОтхода);
		СтруктураПередачи.Вставить("ВремяФормирования", Структура.ВремяФормирования);
	Исключение
		
	КонецПопытки;
	
	СтруктураПередачи.Вставить("АлгоритмРаскроя", Структура.АлгоритмРаскроя);
	СтруктураПередачи.Вставить("Спецификация", Спецификация);
	СтруктураПередачи.Вставить("РисунокКривогоПилаФРС", "");
	СтруктураПередачи.Вставить("РисунокКривогоПилаСтеколка", "");
	СтруктураПередачи.Вставить("РисунокРаскроя", "");
	
	Возврат СтруктураПередачи;
	
КонецФункции

