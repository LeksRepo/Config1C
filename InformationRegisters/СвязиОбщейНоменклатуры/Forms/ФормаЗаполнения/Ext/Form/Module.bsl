﻿
&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьНаСервере();
	Модифицированность = Ложь;
	
	Оповестить("Записано");
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	Для Каждого Строка Из Список Цикл
		
		Если ЗначениеЗаполнено(Строка.ОбщаяНоменклатура) И ЗначениеЗаполнено(Строка.Номенклатура) Тогда
		
			НаборЗаписей = РегистрыСведений.СвязиОбщейНоменклатуры.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ОбщаяНоменклатура.Установить(Строка.ОбщаяНоменклатура);
			НаборЗаписей.Отбор.Подразделение.Установить(Подразделение);
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество() = 0 Тогда			
				НоваяЗапись = НаборЗаписей.Добавить();			
			Иначе		
				НоваяЗапись = НаборЗаписей[0];			
			КонецЕсли;
			
			НоваяЗапись.Подразделение = Подразделение;
			НоваяЗапись.ОбщаяНоменклатура = Строка.ОбщаяНоменклатура;
			НоваяЗапись.Номенклатура = Строка.Номенклатура;
			
			НаборЗаписей.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТекущими(Команда)
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		Список.Очистить();
		ЗаполнитьТекущимиНаСервере();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните подразделение",,"Подразделение");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекущимиНаСервере()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Общая.Ссылка КАК ОбщаяНоменклатура,
	|	СвязиОбщейНоменклатуры.Номенклатура
	|ИЗ
	|	Справочник.ОбщаяНоменклатура КАК Общая
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиОбщейНоменклатуры КАК СвязиОбщейНоменклатуры
	|		ПО Общая.Ссылка = СвязиОбщейНоменклатуры.ОбщаяНоменклатура
	|			И (СвязиОбщейНоменклатуры.Подразделение = &Подразделение)
	|ГДЕ
	|	НЕ Общая.ПометкаУдаления
	|	И НЕ Общая.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	Общая.Наименование";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			  Строка = Список.Добавить();
			  Строка.ОбщаяНоменклатура = Выборка.ОбщаяНоменклатура;
			  Строка.Номенклатура = Выборка.Номенклатура;
			
		КонецЦикла;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочник(Команда)
	ОткрытьФорму("Справочник.ОбщаяНоменклатура.ФормаСписка");
КонецПроцедуры
