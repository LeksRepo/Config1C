﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Записать();
	
	Ошибки = Неопределено;
	
	МассивСпецификацийРозничныеПроводки = Новый Массив;
	
	//////////////////////////
	// БЛОКИРОВКА
	
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	БухгалтерскийУчетПроведениеСервер.СформироватьПроводкиРеализацииСпецификаций(МассивСпецификаций, МоментВремени(), Подразделение, Движения, Ошибки);
	
	Если Ошибки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		Возврат;
		
	КонецЕсли;
	
	ЛексСервер.ГрупповаяСменаСтатуса(МассивСпецификаций, Перечисления.СтатусыСпецификации.Отгружен, Перечисления.СтатусыСпецификации.Изготовлен);
	
	БухгалтерскийУчетПроведениеСервер.СформироватьПроводкиПрибыльПроизводства(МассивСпецификаций, Движения, Дата);
	
	БухгалтерскийУчетПроведениеСервер.ЗакрытьДопСоглашенияДоговора(МассивСпецификаций, Движения, Дата);
	
	БухгалтерскийУчетПроведениеСервер.РеализацияИзделийРозничныеПроводки(МассивСпецификаций, Движения, Дата);
	
	Движения.Управленческий.Записывать = Истина;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Изменение статуса спецификации
	Для Каждого Элемент Из СписокСпецификаций Цикл
		
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Элемент.Спецификация) = Перечисления.СтатусыСпецификации.Отгружен Тогда
			
			Документы.Спецификация.УстановитьСтатусСпецификации(Элемент.Спецификация, Перечисления.СтатусыСпецификации.Изготовлен);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВыпускПродукции") Тогда
		
		СписокСпецификаций.Загрузить(ЛексСервер.ПолучитьСпецификацииПоСтатусу(Подразделение, Перечисления.СтатусыСпецификации.Изготовлен));
		ЭтотОбъект.Подразделение	= ДанныеЗаполнения.Подразделение;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеализацияГотовойПродукцииСписокСпецификаций.Спецификация
	|ИЗ
	|	Документ.РеализацияГотовойПродукции.СписокСпецификаций КАК РеализацияГотовойПродукцииСписокСпецификаций
	|ГДЕ
	|	НЕ РеализацияГотовойПродукцииСписокСпецификаций.Спецификация В (&МассивСпецификаций)
	|	И РеализацияГотовойПродукцииСписокСпецификаций.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Выборка.Спецификация) = Перечисления.СтатусыСпецификации.Отгружен Тогда
			Документы.Спецификация.УстановитьСтатусСпецификации(Выборка.Спецификация, Перечисления.СтатусыСпецификации.Изготовлен);
		КонецЕсли;
	КонецЦикла;
	
	// проверка повторного ввода спецификаций
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияГотовойПродукцииСписокСпецификаций.Ссылка
	|ИЗ
	|	Документ.РеализацияГотовойПродукции.СписокСпецификаций КАК РеализацияГотовойПродукцииСписокСпецификаций
	|ГДЕ
	|	РеализацияГотовойПродукцииСписокСпецификаций.Спецификация В(&МассивСпецификаций)
	|	И РеализацияГотовойПродукцииСписокСпецификаций.Ссылка <> &Ссылка";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Уже есть Реализация изделия к некоторым спецификациям", ЭтотОбъект, "Номер");
	КонецЕсли;
	
КонецПроцедуры

Функция СоздатьПроводку(фПодразделение, фСумма)
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = Дата;
	Проводка.Подразделение = фПодразделение;
	Проводка.Сумма = фСумма;
	
	Возврат Проводка;
	
КонецФункции
