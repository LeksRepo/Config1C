﻿
&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Подразделение", Подразделение);
	ПараметрыОтчета.Вставить("СтаршийДизайнер", СтаршийДизайнер);
	
	ТабДок = Отчеты.ОтчетСтаршегоДизайнера.СформироватьОтчет(ПараметрыОтчета);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Подразделение = ПараметрыСеанса.ТекущееПодразделение;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		Если Расшифровка.Свойство("Заметка") Тогда
			Если Расшифровка.Заметка Тогда
				СтандартнаяОбработка = Ложь;
				НашаЗаметка = НайтиЗаметку(Расшифровка.Предмет);
				ОткрытьЗначение(НашаЗаметка);
			КонецЕсли;
		ИначеЕсли Расшифровка.Свойство("РасшифровкаАдрес") Тогда
			ОткрытьЗначение(Расшифровка.РасшифровкаАдрес);
		ИначеЕсли Расшифровка.Свойство("РасшифровкаДоговор") Тогда
			ОткрытьЗначение(Расшифровка.РасшифровкаДоговор);
		ИначеЕсли Расшифровка.Свойство("РасшифровкаАкт") Тогда
			ОткрытьЗначение(Расшифровка.РасшифровкаАкт);	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НайтиЗаметку(Предмет)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Предмет", Предмет);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Заметки.Ссылка
	|ИЗ
	|	Справочник.Заметки КАК Заметки
	|ГДЕ
	|	Заметки.Предмет = &Предмет";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() > 0 Тогда
		Выборка.Следующий();
		Возврат Выборка[0].Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции