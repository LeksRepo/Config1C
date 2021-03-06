﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Подразделение = Параметры.Подразделение;
	ПереданнаяТаблица = Параметры.ТЗ.Выгрузить();
	НайденнаяСтрока = Неопределено;
	ЗаМесяц = Истина;
	
	ЗаполнитьТаблицуНарядов(Подразделение, ПереданнаяТаблица);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ОповеститьОВыборе(ПолучитьАдресХранилища());
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресХранилища()
	
	Отбор = Новый Структура("Пометка", Истина);
	ВремТЗ = ТЗ.Выгрузить(Отбор, "Наряд");
	Возврат ПоместитьВоВременноеХранилище(ВремТЗ);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуНарядов(Подразделение, ПереданнаяТаблица = Неопределено)
	
	ТЗ.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ЗаМесяц", ЗаМесяц);
	Запрос.УстановитьПараметр("НачалоПериода", ДобавитьМесяц(ТекущаяДата(),-1));
	Запрос.УстановитьПараметр("КонецПериода", ДобавитьМесяц(ТекущаяДата(),1));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НарядЗадание.Ссылка КАК Наряд,
	|	НарядЗадание.ДатаИзготовления КАК ДатаИзготовления,
	|	НарядЗадание.СуммаДокумента КАК Сумма,
	|	НарядЗадание.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.НарядЗадание КАК НарядЗадание
	|ГДЕ
	|	НарядЗадание.Проведен
	|	И НарядЗадание.Подразделение = &Подразделение
	|	И ВЫБОР
	|			КОГДА &ЗаМесяц
	|				ТОГДА НарядЗадание.ДатаИзготовления МЕЖДУ &НачалоПериода И &КонецПериода
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаИзготовления УБЫВ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ТЗ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		Если ЗначениеЗаполнено(ПереданнаяТаблица) Тогда
			
			НайденнаяСтрока = ПереданнаяТаблица.Найти(Выборка.Наряд, "Наряд");
			
			Если ЗначениеЗаполнено(НайденнаяСтрока) Тогда
				
				НоваяСтрока.Пометка = Истина;
	
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

&НаКлиенте
Процедура ЗаМесяцПриИзменении(Элемент)
	ЗаполнитьТаблицуНарядов(Подразделение);
КонецПроцедуры
