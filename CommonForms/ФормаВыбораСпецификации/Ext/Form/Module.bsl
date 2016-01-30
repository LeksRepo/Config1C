﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Статус = Параметры.Статус;
	Подразделение = Параметры.Подразделение;
	ПереданнаяТаблица = Параметры.ТЗ.Выгрузить();
	НайденнаяСтрока = Неопределено;
	ОбщаяСуммаНаряда = 0;
	
	ЗаполнитьТаблицуСпецификаций(Подразделение, Статус, ПереданнаяТаблица);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ОповеститьОВыборе(ПолучитьАдресХранилища());
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресХранилища()
	
	Отбор = Новый Структура("Пометка", Истина);
	ВремТЗ = ТЗ.Выгрузить(Отбор, "Спецификация, Срочный, СуммаНаряда, ДатаИзготовления, ОсобыеУслуги, ЦветЛДСПОсновной");
	Возврат ПоместитьВоВременноеХранилище(ВремТЗ);
	
КонецФункции

&НаКлиенте
Процедура Отмена(Команда)
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	Для каждого Элемент Из ТЗ Цикл
		Элемент.Пометка = Истина;
	КонецЦикла;
	ОбщаяСуммаНаряда = ТЗ.Итог("СуммаНаряда");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда)
	
	Для каждого Элемент Из ТЗ Цикл
		Элемент.Пометка = Ложь;
	КонецЦикла;
	ОбщаяСуммаНаряда = 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ТЗПометкаПриИзменении(Элемент)
	
	Данные = Элементы.ТЗ.ТекущиеДанные;
	Если Данные.Пометка Тогда
		ОбщаяСуммаНаряда = ОбщаяСуммаНаряда + Данные.СуммаНаряда;
	Иначе
		ОбщаяСуммаНаряда = ОбщаяСуммаНаряда - Данные.СуммаНаряда;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	ТЗ.Очистить();
	ЗаполнитьТаблицуСпецификаций(Подразделение, Статус);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуСпецификаций(Подразделение, Статус, ПереданнаяТаблица = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Статус", Статус);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтатусСпецификацииСрезПоследних.Спецификация,
	|	СтатусСпецификацииСрезПоследних.Спецификация.Номер КАК Номер,
	|	СтатусСпецификацииСрезПоследних.Спецификация.Срочный КАК Срочный,
	|	СтатусСпецификацииСрезПоследних.Спецификация.ДатаИзготовления КАК ДатаИзготовления,
	|	СтатусСпецификацииСрезПоследних.Спецификация.СуммаНарядаСпецификации КАК СуммаНаряда,
	|	СтатусСпецификацииСрезПоследних.Статус,
	|	СтатусСпецификацииСрезПоследних.Спецификация.ДатаОтгрузки КАК ДатаОтгрузки,
	|	СтатусСпецификацииСрезПоследних.Спецификация.Изделие КАК Изделие,
	|	СтатусСпецификацииСрезПоследних.Спецификация.ОсобыеУслуги КАК ОсобыеУслуги,
	|	НаличиеЗаметокПоПредмету.ЕстьЗаметка,
	|	СтатусСпецификацииСрезПоследних.Спецификация.ЦветЛДСПОсновной КАК ЦветЛДСПОсновной
	|ИЗ
	|	РегистрСведений.СтатусСпецификации.СрезПоследних(, ) КАК СтатусСпецификацииСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеЗаметокПоПредмету КАК НаличиеЗаметокПоПредмету
	|		ПО СтатусСпецификацииСрезПоследних.Спецификация = НаличиеЗаметокПоПредмету.Предмет
	|ГДЕ
	|	СтатусСпецификацииСрезПоследних.Спецификация.Проведен
	|	И СтатусСпецификацииСрезПоследних.Спецификация.Подразделение = &Подразделение
	|	И ВЫБОР
	|			КОГДА &Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ СтатусСпецификацииСрезПоследних.Статус В (&Статус)
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номер";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ТЗ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		Если ЗначениеЗаполнено(ПереданнаяТаблица) Тогда
			
			НайденнаяСтрока = ПереданнаяТаблица.Найти(Выборка.Спецификация, "Спецификация");
			
			Если ЗначениеЗаполнено(НайденнаяСтрока) Тогда
				
				НоваяСтрока.Пометка = Истина;
				ОбщаяСуммаНаряда = ОбщаяСуммаНаряда + НоваяСтрока.СуммаНаряда;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТЗВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТЗ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Пометка = НЕ ТекущиеДанные.Пометка;
	
КонецПроцедуры
