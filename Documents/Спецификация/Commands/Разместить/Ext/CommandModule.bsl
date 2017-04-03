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
	
	Если НЕ ПроверитьЗаполнение(Спецификация) Тогда
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
Функция ПроверитьЗаполнение(Ссылка)
	
	Возврат Ссылка.ПолучитьОбъект().ПроверитьЗаполнение();
	
КонецФункции

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
		
		Запись.РисунокКривогоПилаФРС = СвойстваРаскроя.РисунокКривогоПилаФРС;
		Запись.РисунокКривогоПилаСтеколка = СвойстваРаскроя.РисунокКривогоПилаСтеколка;
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
	
	Если СпецификацияСсылка.Дилерский Тогда
		
		ЭтоСеансДилера = ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя();
		
		Если ЭтоСеансДилера Тогда
			Пользователь = ПользователиКлиентСервер.ТекущийВнешнийПользователь();
			БезПроверкиСпецификаций = ЛексСервер.НастройкаПользователя(Пользователь,"Без проверки спецификаций");
		Иначе
			БезПроверкиСпецификаций = Истина;
		КонецЕсли;

		Если СпецификацияСсылка.КоробаРедактированы И ЭтоСеансДилера Тогда
			
			Результат.СформироватьРаскрой = Ложь;
		
			ТекстСообщения = "Каталожные модули были изменены. Для размещения спецификации обратитесь к супервайзеру.";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, СпецификацияСсылка, ТекстСообщения);
			
		ИначеЕсли НЕ БезПроверкиСпецификаций Тогда
			
			Результат.СформироватьРаскрой = Ложь;
			
			ТекстСообщения = "Для размещения спецификации обратитесь к супервайзеру.";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, СпецификацияСсылка, ТекстСообщения);
			
		КонецЕсли;
		
	КонецЕсли;	
	
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
		
		Попытка
			НачатьТранзакцию();
			// В момент проведения проходят несколько проверок.
			Документы.Спецификация.УстановитьСтатусСпецификации(СпецификацияСсылка, Перечисления.СтатусыСпецификации.Размещен);
			ДокОбъект.Дата = ТекущаяДата();
			
			Если НЕ ЗначениеЗаполнено(ДокОбъект.Технолог) 
				И НЕ ДокОбъект.Дилерский Тогда
				ДокОбъект.Технолог = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
			КонецЕсли;
			
			ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			Сообщить("Не удалось разместить спецификацию " + СпецификацияСсылка);
		КонецПопытки;
		
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
		Структура.Вставить("СтрокаКривогоПилаФРС", Запись.СтрокаКривогоПилаФРС);
		Структура.Вставить("СтрокаКривогоПилаСтеколка", Запись.СтрокаКривогоПилаСтеколка);
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
	
	СвойстваРаскроя.Вставить("РисунокКривогоПилаФРС", "");
	СвойстваРаскроя.Вставить("РисунокКривогоПилаСтеколка", "");
	
	СвойстваРаскроя.Вставить("РисунокРаскроя", "");
	
	ВидОтображения = ПолучитьВидОтображенияФлэш(СпецификацияСсылка);
	
	Если ЗначениеЗаполнено(СвойстваРаскроя.СтрокаКривогоПилаФРС) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Спецификация", СпецификацияСсылка);
		ПараметрыФормы.Вставить("ХранимыйФайл", "КривойПил");
		ПараметрыФормы.Вставить("СтрокаКривогоПила", СвойстваРаскроя.СтрокаКривогоПилаФРС);
		ПараметрыФормы.Вставить("ВидОтображения", ВидОтображения);
		
		СвойстваРаскроя.РисунокКривогоПилаФРС = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СвойстваРаскроя.СтрокаКривогоПилаСтеколка) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Спецификация", СпецификацияСсылка);
		ПараметрыФормы.Вставить("ХранимыйФайл", "КривойПил");
		ПараметрыФормы.Вставить("СтрокаКривогоПила", СвойстваРаскроя.СтрокаКривогоПилаСтеколка);
		ПараметрыФормы.Вставить("ВидОтображения", ВидОтображения);
		
		СвойстваРаскроя.РисунокКривогоПилаСтеколка = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы);
		
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
