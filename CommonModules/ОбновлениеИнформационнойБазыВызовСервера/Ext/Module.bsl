﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление версии ИБ"
// Серверные процедуры и функции обновления информационной базы
// при смене версии конфигурации.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же функции в модуле ОбновлениеИнформационнойБазы.
Функция ВыполнитьОбновлениеИнформационнойБазы(ИсключениеПриНевозможностиБлокировкиИБ = Истина,
                                              ПриЗапускеКлиентскогоПриложения = Ложь,
                                              Перезапустить = Ложь) Экспорт
	
	Возврат ОбновлениеИнформационнойБазы.ВыполнитьОбновлениеИнформационнойБазы(
		ИсключениеПриНевозможностиБлокировкиИБ, ПриЗапускеКлиентскогоПриложения, Перезапустить);
	
КонецФункции

// Снимает блокировку информационной файловой базы.
Процедура СнятьБлокировкуФайловойБазы() Экспорт
	
	ОбновлениеИнформационнойБазы.ПриСнятииБлокировкиФайловойБазы();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Записывает в константу продолжительность основного цикла обновления.
//
Процедура ЗаписатьВремяВыполненияОбновления(ВремяНачалаОбновления, ВремяОкончанияОбновления) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазы.СведенияОбОбновленииИнформационнойБазы();
	СведенияОбОбновлении.ВремяНачалаОбновления = ВремяНачалаОбновления;
	СведенияОбОбновлении.ВремяОкончанияОбновления = ВремяОкончанияОбновления;
	
	ВремяВСекундах = ВремяОкончанияОбновления - ВремяНачалаОбновления;
	
	Часы = Цел(ВремяВСекундах/3600);
	Минуты = Цел((ВремяВСекундах - Часы * 3600) / 60);
	Секунды = ВремяВСекундах - Часы * 3600 - Минуты * 60;
	
	ПродолжительностьЧасы = ?(Часы = 0, "",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 час'"), Часы));
	ПродолжительностьМинуты = ?(Минуты = 0, "",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 мин'"), Минуты));
	ПродолжительностьСекунды = ?(Секунды = 0, "",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 сек'"), Секунды));
	
	ПродолжительностьОбновления = ПродолжительностьЧасы + " " + ПродолжительностьМинуты + " " + ПродолжительностьСекунды;
	
	СведенияОбОбновлении.ПродолжительностьОбновления = СокрЛП(ПродолжительностьОбновления);
	
	ОбновлениеИнформационнойБазы.ЗаписатьСведенияОбОбновленииИнформационнойБазы(
		СведенияОбОбновлении);
	
КонецПроцедуры

// Проверяет статус отложенных обработчиков обновления.
//
Функция ЕстьНеВыполненныеОбработчики() Экспорт
	
	Если Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат "";
	КонецЕсли;
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазы.СведенияОбОбновленииИнформационнойБазы();
	Если СведенияОбОбновлении = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Для Каждого СтрокаДереваБиблиотека Из СведенияОбОбновлении.ДеревоОбработчиков.Строки Цикл
		Для Каждого СтрокаДереваВерсия Из СтрокаДереваБиблиотека.Строки Цикл
			Для Каждого Обработчик Из СтрокаДереваВерсия.Строки Цикл
				Если Обработчик.Статус = "Ошибка" Тогда
					Возврат "СтатусОшибка";
				ИначеЕсли Обработчик.Статус <> "Выполнено" Тогда
					Возврат "СтатусНеВыполнено";
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат "";
	
КонецФункции