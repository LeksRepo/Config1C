﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ХранимыйФайлРаскрой = "НовыйРаскрой";
	
	МассивСтруктур = НайтиСтрокиРаскроя(ПараметрКоманды);
	
	Для каждого Структура Из МассивСтруктур Цикл
		
		Если ЗначениеЗаполнено(Структура.СтрокаНовогоРаскрояЛДСП) Тогда
			
			Структура.Вставить("ХранимыйФайл", ХранимыйФайлРаскрой);
			Структура.Вставить("ВидОтображения", "2");
			ОткрытьФорму("Документ.Спецификация.Форма.ФормаФлэш", Структура,, Истина);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция НайтиСтрокиРаскроя(МассивСсылок)
	
	МассивСтрок = Новый Массив;
	Структура = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РаскройДеталей.Объект КАК Ссылка,
	|	РаскройДеталей.СтрокаРаскрой КАК Раскрой
	|ИЗ
	|	РегистрСведений.РаскройДеталей КАК РаскройДеталей
	|ГДЕ
	|	РаскройДеталей.Объект В(&МассивСсылок)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Структура.Вставить("СтрокаНовогоРаскрояЛДСП", Выборка.Раскрой);
		МассивСтрок.Добавить(Структура);
	КонецЦикла;
	   	
	Возврат МассивСтрок;
	
КонецФункции