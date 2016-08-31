﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ФормироватьРаскрой = Истина;
	
	Если ФормироватьРаскрой Тогда
		
		Состояние("Формирование раскроя, это может занят длительное время");
		Массив = ОбновитьРаскройНаСервере(ПараметрКоманды);
		
		Для Каждого Элемент Из Массив Цикл
			
			НашНарядЗадание = Элемент.НарядЗадание;
			
			Если ЗначениеЗаполнено(Элемент.СтрокаКривогоПила) Тогда
				
				ПараметрыФормы = Новый Структура;
				ПараметрыФормы.Вставить("ХранимыйФайл", "КривойПил");
				ПараметрыФормы.Вставить("Спецификация", НашНарядЗадание);
				ПараметрыФормы.Вставить("СтрокаКривогоПила", Элемент.СтрокаКривогоПила);
				
				Значение = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы);
				
				Элемент.РисунокКривогоПила = Значение;
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Элемент.СтрокаРаскрой) Тогда
				
				ПараметрыФормы = Новый Структура;
				ПараметрыФормы.Вставить("ХранимыйФайл", "НовыйРаскрой");
				ПараметрыФормы.Вставить("Спецификация", НашНарядЗадание);
				ПараметрыФормы.Вставить("СтрокаНовогоРаскрояЛДСП", Элемент.СтрокаРаскрой);
				ПараметрыФормы.Вставить("ВидОтображения", "1");
				
				Значение = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы);
				
				Элемент.РисунокРаскроя = Значение;
				
			КонецЕсли;
			
		КонецЦикла;
		
		ЗаписатьРаскрой(Массив);
		Если ПараметрыВыполненияКоманды.Источник.ВладелецФормы <> Неопределено Тогда
			ПараметрыВыполненияКоманды.Источник.Прочитать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбновитьРаскройНаСервере(НарядЗадание)
	
	Массив = Новый Массив;
	Структура = РегистрыСведений.РаскройДеталей.СформироватьРаскрой(НарядЗадание);
	
	СтруктураПередачи = Новый Структура;
	СтруктураПередачи.Вставить("СтрокаКривогоПила", Структура.СтрокаКривогоПила);
	СтруктураПередачи.Вставить("ТекущаяСтрокаРаскроя", Структура.ДанныеДляРаскроя);
	СтруктураПередачи.Вставить("СтрокаРаскрой", Структура.ДанныеДляРаскроя);
	СтруктураПередачи.Вставить("ТаблицаДеталей", Структура.ТаблицаДеталей);
	
	Попытка
		СтруктураПередачи.Вставить("ЛучшийПроцентОтхода", Структура.ЛучшийПроцентОтхода);
		СтруктураПередачи.Вставить("ВремяФормирования", Структура.ВремяФормирования);
	Исключение
		
	КонецПопытки;
	
	СтруктураПередачи.Вставить("АлгоритмРаскроя", Структура.АлгоритмРаскроя);
	СтруктураПередачи.Вставить("НарядЗадание", НарядЗадание);
	СтруктураПередачи.Вставить("РисунокКривогоПила", "");
	СтруктураПередачи.Вставить("РисунокРаскроя", "");
	ОбъектНарядЗадание = НарядЗадание.ПолучитьОбъект();
	ОбъектНарядЗадание.СписокЛистовНоменклатуры.Загрузить(Структура.ТаблицаЛистовНоменклатуры);
	ОбъектНарядЗадание.ДополнительныеСвойства.Вставить("НеОчищатьСтрокуРаскроя", Истина);
	ОбъектНарядЗадание.Записать();
	//Документ = ДанныеФормыВЗначение(ОбъектНарядЗадание, Тип("ДокументОбъект.НарядЗадание"));
	//ЗначениеВДанныеФормы(Документ, ОбъектНарядЗадание);
	
	Массив.Добавить(СтруктураПередачи);
	
	Возврат Массив;
	
КонецФункции

&НаСервере
Функция ЗаписатьРаскрой(Массив)
	
	Для Каждого Элемент Из Массив Цикл
		
		НаборЗаписей = РегистрыСведений.РаскройДеталей.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(Элемент.НарядЗадание);
		
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество() = 1 Тогда
			Запись = НаборЗаписей[0];
		Иначе
			Запись = НаборЗаписей.Добавить();
			Запись.Объект = Элемент.НарядЗадание;
		КонецЕсли;
		
		Запись.СтрокаРаскрой = Элемент.СтрокаРаскрой;
		Запись.ТекущаяСтрокаРаскроя = Элемент.ТекущаяСтрокаРаскроя;	
		Запись.РисунокРаскроя = Элемент.РисунокРаскроя;
		Запись.РисунокКривогоПила = Элемент.РисунокКривогоПила;
		Запись.СтрокаКривогоПила = Элемент.СтрокаКривогоПила;
		
		Попытка
			Запись.ИдеальныйПроцентОтхода = Элемент.ЛучшийПроцентОтхода;
			Запись.ВремяФормирования = Элемент.ВремяФормирования;
		Исключение
			
		КонецПопытки;
		
		Запись.ТаблицаДеталей = Элемент.ТаблицаДеталей;
		Запись.АлгоритмРаскроя = Элемент.АлгоритмРаскроя;
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецФункции

