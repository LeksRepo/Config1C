﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	РеквизитыСпецификации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Спецификация, "ПакетУслуг, Контрагент");
	
//	Если РеквизитыСпецификации.ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж И ПервыйМонтаж(РеквизитыСпецификации.Контрагент) Тогда
	Если РеквизитыСпецификации.ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж Тогда
		Запись = Движения.СвободныеМонтажники.Добавить();
		Запись.Город = Спецификация.Офис.Город;
		Запись.Период = ДатаМонтажа;
		Запись.КоличествоМонтажей = 1;
		
	КонецЕсли;
	
	Движения.СвободныеМонтажники.Записывать = Истина;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПакетУслуг = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Спецификация, "ПакетУслуг");
	
	Если ПакетУслуг <> Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж Тогда
		
		Если ЗначениеЗаполнено(Монтажник) Тогда
			
			Отказ = Истина;
			ТекстСообщения = "Спецификация к договору без монтажа. Уберите монтажника";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Монтажник");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПервыйМонтаж(Контрагент)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Монтаж.Ссылка,
	|	Монтаж.Дата,
	|	Монтаж.Спецификация.Контрагент
	|ИЗ
	|	Документ.Монтаж КАК Монтаж
	|ГДЕ
	|	Монтаж.Подразделение = &Подразделение
	|	И Монтаж.Спецификация.Контрагент = &Контрагент
	|	И НАЧАЛОПЕРИОДА(Монтаж.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ)
	|	И Монтаж.Ссылка <> &Ссылка
	|	И Монтаж.Проведен";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Дата", ДатаМонтажа);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции // ПовторныйМонтаж()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	МонтажСсылка= Документы.Спецификация.ПолучитьМонтаж(Спецификация);
	
	Если ЗначениеЗаполнено(МонтажСсылка) И Ссылка <> МонтажСсылка Тогда
		Отказ = Истина;
		ТекстСообщения = "К " + Ссылка + " уже введен " + МонтажСсылка;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, МонтажСсылка);
	КонецЕсли;

КонецПроцедуры
