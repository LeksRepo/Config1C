﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Ошибки = Неопределено;
	Отказ = Ложь;
	
	Спецификация = ПараметрКоманды;
	
	Если НЕ ЗначениеЗаполнено(Спецификация)
		ИЛИ ТипЗнч(Спецификация) <> Тип("ДокументСсылка.Спецификация") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	РезультатПроверки = ПроверитьИРазместить(Спецификация, Ошибки);
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	
	Если РезультатПроверки.СформироватьРаскрой Тогда
		
		СвойстваРаскроя = ПолучитьСвойстваРаскроя(Спецификация, Отказ);
		
		Если НЕ Отказ Тогда
			ПолучитьРисункиРаскроя(СвойстваРаскроя, Спецификация);
			ЗаписатьРисункиРаскроя(СвойстваРаскроя, Спецификация, Отказ);
			Оповестить("ИзмененСтатусСпецификации", Спецификация);
		КонецЕсли;
		
	КонецЕсли;
	
	Если РезультатПроверки.ВопросПередатьНаПроверку Тогда
		
		ТекстВопроса = "Передать %1 на проверку материала?";
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Спецификация);
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос(ТекстВопроса, Режим, 0);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ПередатьНаПроверкуМатериала(Спецификация);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДатаСпец(Ссылка)
	
	Возврат Ссылка.ДатаСоздания;
	
КонецФункции

&НаСервере
Функция ПередатьНаПроверкуМатериала(СпецификацияСсылка)
	
	Документы.Спецификация.УстановитьСтатусСпецификации(СпецификацияСсылка, Перечисления.СтатусыСпецификации.ПроверяетсяМатериал);
	
КонецФункции

&НаСервере
Функция ЗаписатьРисункиРаскроя(СвойстваРаскроя, СпецификацияСсылка, Отказ)
	
	НаборЗаписей = ПолучитьНаборЗаписейРегистра(СпецификацияСсылка, Отказ);
	
	Запись = НаборЗаписей[0];
	
	Если Запись <> Неопределено Тогда
		
		Запись.РисунокКривогоПила = СвойстваРаскроя.РисунокКривогоПила;
		Запись.РисунокРаскроя = СвойстваРаскроя.РисунокРаскроя;
		
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПроверитьИРазместить(СпецификацияСсылка, Ошибки)
	
	Результат = Новый Структура;
	Результат.Вставить("ВопросПередатьНаПроверку", Ложь);
	Результат.Вставить("СформироватьРаскрой", Истина);
	
	ТекущийСтатус = Документы.Спецификация.ПолучитьСтатусСпецификации(СпецификацияСсылка);
	
	Если ТекущийСтатус <> Перечисления.СтатусыСпецификации.МатериалПроверен
		И ТекущийСтатус <> Перечисления.СтатусыСпецификации.Сохранен 
		И ТекущийСтатус <> Перечисления.СтатусыСпецификации.Рассчитывается Тогда
		
		Результат.СформироватьРаскрой = Ложь;
		
		ТекстСообщения = "Разместить спецификацию можно только со статусами 'Сохранен', 'Рассчитывается' и 'Материал проверен' . У %1 статус '%2'";
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СпецификацияСсылка, ТекущийСтатус);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, СпецификацияСсылка, ТекстСообщения);
		
	КонецЕсли;
	
	Если НЕ Документы.Спецификация.МатериалПодЗаказПроверен(СпецификацияСсылка, Ошибки) Тогда
		
		Результат.СформироватьРаскрой = Ложь;
		Результат.ВопросПередатьНаПроверку = ТекущийСтатус = Перечисления.СтатусыСпецификации.Сохранен;
		
	КонецЕсли;
	
	Для каждого Строка Из СпецификацияСсылка.СписокМатериаловПодЗаказ Цикл
		
		Если Строка.Цена = 0 ИЛИ Строка.Поставщик.Пустая() Тогда
			Результат.СформироватьРаскрой = Ложь;
			ТекстСообщения = "%1 установите цену и поставщика для материала 'Под заказ'";
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СпецификацияСсылка, ТекущийСтатус);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, СпецификацияСсылка, ТекстСообщения);
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Результат.СформироватьРаскрой Тогда
		
		ДокОбъект = СпецификацияСсылка.ПолучитьОбъект();
		
		НачатьТранзакцию();
		
		Попытка
			// В момент проведения проходят несколько проверок.
			Документы.Спецификация.УстановитьСтатусСпецификации(СпецификацияСсылка, Перечисления.СтатусыСпецификации.Размещен);
			ДокОбъект.Дата = ТекущаяДата();
			ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
		КонецПопытки;
		
		ЗафиксироватьТранзакцию();
		
		Результат.СформироватьРаскрой = ДокОбъект.Проведен;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьСвойстваРаскроя(СпецификацияСсылка, Отказ)
	
	Перем Структура;
	
	НаборЗаписей = ПолучитьНаборЗаписейРегистра(СпецификацияСсылка, Отказ);
	
	Если Отказ Тогда
		
		//	// Ошибка получения раскроя спецификации
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Запись = НаборЗаписей[0];
	
	Если Запись <> Неопределено Тогда
		
		Структура = Новый Структура;
		Структура.Вставить("СтрокаКривогоПила", Запись.СтрокаКривогоПила);
		Структура.Вставить("СтрокаРаскрой", Запись.СтрокаРаскрой);
		
	КонецЕсли;
	
	Возврат Структура;
	
КонецФункции

&НаСервере
Функция ПолучитьНаборЗаписейРегистра(СпецификацияСсылка, Отказ)
	
	НаборЗаписей = РегистрыСведений.РаскройДеталей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(СпецификацияСсылка);
	
	НаборЗаписей.Прочитать();
	
	Отказ = НаборЗаписей.Количество() <> 1;
	
	Возврат НаборЗаписей;
	
КонецФункции

&НаКлиенте
Функция ПолучитьРисункиРаскроя(СвойстваРаскроя, СпецификацияСсылка)
	
	СвойстваРаскроя.Вставить("РисунокКривогоПила", "");
	СвойстваРаскроя.Вставить("РисунокРаскроя", "");
	
	Если ЗначениеЗаполнено(СвойстваРаскроя.СтрокаКривогоПила) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Спецификация", СпецификацияСсылка);
		ПараметрыФормы.Вставить("ХранимыйФайл", "КривойПил");
		ПараметрыФормы.Вставить("СтрокаКривогоПила", СвойстваРаскроя.СтрокаКривогоПила);
		
		СвойстваРаскроя.РисунокКривогоПила = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СвойстваРаскроя.СтрокаРаскрой) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Спецификация", СпецификацияСсылка);
		ПараметрыФормы.Вставить("ХранимыйФайл", "НовыйРаскрой");
		ПараметрыФормы.Вставить("СтрокаНовогоРаскрояЛДСП", СвойстваРаскроя.СтрокаРаскрой);
		ПараметрыФормы.Вставить("ВидОтображения", "1");
		
		СвойстваРаскроя.РисунокРаскроя = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы);
		
	КонецЕсли;
	
КонецФункции
