﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	ЛексСервер.УвеличитьДополнительныйЛимит(МассивСпецификаций, Движения, Дата, Подразделение);
	
	Для Каждого Элемент Из СписокСпецификаций Цикл
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Элемент.Спецификация) = Перечисления.СтатусыСпецификации.Размещен Тогда
			Документы.Спецификация.УстановитьСтатусСпецификации(Элемент.Спецификация, Перечисления.СтатусыСпецификации.ПереданВЦех);
		КонецЕсли;
	КонецЦикла;
	
	Движения.Управленческий.Записывать = Истина;
	
КонецПроцедуры

Функция ПовторнаяПередачаВПроизводство()
	
	ПовторнаяПередача = Ложь;
	
	Спецификации = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НарядСсылка", Ссылка);
	Запрос.УстановитьПараметр("Спецификации", Спецификации);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НарядЗаданиеСписокСпецификаций.Спецификация,
	|	НарядЗаданиеСписокСпецификаций.Ссылка,
	|	НарядЗаданиеСписокСпецификаций.НомерСтроки
	|ИЗ
	|	Документ.НарядЗадание.СписокСпецификаций КАК НарядЗаданиеСписокСпецификаций
	|ГДЕ
	|	НарядЗаданиеСписокСпецификаций.Спецификация В(&Спецификации)
	|	И НарядЗаданиеСписокСпецификаций.Ссылка <> &НарядСсылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ПовторнаяПередача = Истина;
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 уже передана в производство документом %2", Выборка.Спецификация, Выборка.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект);
		// Можно и к полю привязать, но тогда нужна таблица значений с номером строки
		
	КонецЦикла;
	
	Возврат ПовторнаяПередача;
	
КонецФункции

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Изменение статусов спецификаций
	Для Каждого Элемент Из СписокСпецификаций Цикл
		
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Элемент.Спецификация) = Перечисления.СтатусыСпецификации.ПереданВЦех Тогда
			
			Документы.Спецификация.УстановитьСтатусСпецификации(Элемент.Спецификация, Перечисления.СтатусыСпецификации.Размещен);
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	Отказ = ПовторнаяПередачаВПроизводство();
	
	Если НЕ ЗначениеЗаполнено(ДатаИзготовления) Тогда
		ДатаИзготовления = Дата + 86400;
		Если ДеньНедели(ДатаИзготовления) Тогда
			ДатаИзготовления = Дата + 86400;
		КонецЕсли;
	КонецЕсли;
	
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НарядЗаданиеСписокСпецификаций.Спецификация
	|ИЗ
	|	Документ.НарядЗадание.СписокСпецификаций КАК НарядЗаданиеСписокСпецификаций
	|ГДЕ
	|	НЕ НарядЗаданиеСписокСпецификаций.Спецификация В (&МассивСпецификаций)
	|	И НарядЗаданиеСписокСпецификаций.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Документы.Спецификация.ПолучитьСтатусСпецификации(Выборка.Спецификация) = Перечисления.СтатусыСпецификации.ПереданВЦех Тогда
				Документы.Спецификация.УстановитьСтатусСпецификации(Выборка.Спецификация, Перечисления.СтатусыСпецификации.Размещен);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	СуммаДокумента = СписокСпецификаций.Итог("СуммаНаряда");
	КоличествоСпецификаций = СписокСпецификаций.Количество();
	
КонецПроцедуры
