﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ХранимыйФайлРаскрой = "НовыйРаскрой";
	ХранимыйФайлКривойПил = "КривойПил";
	
	СпецификацияСсылка = ПараметрКоманды; 
	
	Определитель = ОбновитьРаскройНаСервере(СпецификацияСсылка);
			
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СпецификацияСсылка", Определитель.Спецификация);
	
	Если ЗначениеЗаполнено(Определитель.СтрокаРаскрой) Тогда
		
		ВидОтображения = ?(СпецификацияПроведена(СпецификацияСсылка),"2","3");

		ПараметрыФормы.Вставить("Спецификация", Определитель.Спецификация);
		ПараметрыФормы.Вставить("ХранимыйФайл", ХранимыйФайлРаскрой);
		ПараметрыФормы.Вставить("СтрокаНовогоРаскрояЛДСП", Определитель.СтрокаРаскрой);
		ПараметрыФормы.Вставить("ВидОтображения", ВидОтображения);
		ОткрытьФорму("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы,, Истина);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Определитель.СтрокаКривогоПилаФРС) Тогда
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Спецификация", "КриволинейныеДеталиФРС", ПараметрКоманды, ПараметрыВыполненияКоманды, Неопределено);

	КонецЕсли;
	
	Если ЗначениеЗаполнено(Определитель.СтрокаКривогоПилаСтеколка) Тогда
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Спецификация", "КриволинейныеДеталиСтеколка", ПараметрКоманды, ПараметрыВыполненияКоманды, Неопределено);

	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СпецификацияПроведена(Спецификация) 
		
	Проведен = Спецификация.Проведен;
	Статус = Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация); 
	
	Возврат Проведен И (Статус <> Перечисления.СтатусыСпецификации.Сохранен);
		
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
