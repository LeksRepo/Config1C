﻿///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК ТРАНСЛЯЦИИ СООБЩЕНИЙ КОНТРОЛЯ РЕЗЕРВНОГО КОПИРОВАНИЯ ОБЛАСТЕЙ ДАННЫХ
//  ИЗ ВЕРСИИ 1.0.3.1 В ВЕРСИЮ 1.0.2.1
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает номер версии, для трансляции с которой предназначен обработчик
Функция ИсходнаяВерсия() Экспорт
	
	Возврат "1.0.3.1";
	
КонецФункции

// Возвращает пространство имен версии, для трансляции с которой предназначен обработчик
Функция ПакетИсходнойВерсии() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ControlZonesBackup/1.0.3.1";
	
КонецФункции

// Возвращает номер версии, для трансляции в которую предназначен обработчик
Функция РезультирующаяВерсия() Экспорт
	
	Возврат "1.0.2.1";
	
КонецФункции

// Возвращает пространство имен версии, для трансляции в которую предназначен обработчик
Функция ПакетРезультирующейВерсии() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ControlZonesBackup/1.0.2.1";
	
КонецФункции

// Обработчик проверки выполнения стандартной обработки трансляции
//
// Параметры:
//  ИсходноеСообщение - ОбъектXDTO, транслируемое сообщение,
//  СтандартнаяОбработка - Булево, для отмены выполнения стандартной обработки трансляции
//    этому параметру внутри данной процедуры необходимо установить значение Ложь.
//    При этом вместо выполнения стандартной обработки трансляции будет вызвана функция
//    ТрансляцияСообщения() обработчика трансляции.
//
Процедура ПередТрансляцией(Знач ИсходноеСообщение, СтандартнаяОбработка) Экспорт
	
	ТипТела = ИсходноеСообщение.Тип();
	
	Если ТипТела = Интерфейс().СообщениеРезервнаяКопияОбластиСоздана(ПакетИсходнойВерсии()) Тогда
		СтандартнаяОбработка = Ложь;
	ИначеЕсли ТипТела = Интерфейс().СообщениеОшибкаАрхивацииОбласти(ПакетИсходнойВерсии()) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик выполнения произвольной трансляции сообщения. Вызывается только в том случае,
//  если при выполнении процедуры ПередТрансляцией значению параметра СтандартнаяОбработка
//  было установлено значение Ложь.
//
// Параметры:
//  ИсходноеСообщение - ОбъектXDTO, транслируемое сообщение.
//
// Возвращаемое значение:
//  ОбъектXDTO, результат произвольной трансляции сообщения.
//
Функция ТрансляцияСообщения(Знач ИсходноеСообщение) Экспорт
	
	ТипТела = ИсходноеСообщение.Тип();
	
	Если ТипТела = Интерфейс().СообщениеРезервнаяКопияОбластиСоздана(ПакетИсходнойВерсии()) Тогда
		Возврат ТранслироватьРезервнаяКопияОбластиСоздана(ИсходноеСообщение);
	ИначеЕсли ТипТела = Интерфейс().СообщениеОшибкаАрхивацииОбласти(ПакетИсходнойВерсии()) Тогда
		Возврат ТранслироватьОшибкаАрхивацииОбласти(ИсходноеСообщение);
	ИначеЕсли ТипТела = Интерфейс().СообщениеАрхивацияОбластиПропущена(ПакетИсходнойВерсии()) Тогда
		Возврат ТранслироватьАрхивацияОбластиПропущена(ИсходноеСообщение);
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция Интерфейс()
	
	Возврат СообщенияКонтрольРезервногоКопированияИнтерфейс;
	
КонецФункции

Функция ТранслироватьРезервнаяКопияОбластиСоздана(Знач ИсходноеСообщение)
	
	Результат = ФабрикаXDTO.Создать(
		Интерфейс().СообщениеРезервнаяКопияОбластиСоздана(ПакетРезультирующейВерсии()));
		
	Результат.Zone = ИсходноеСообщение.Zone;
	Результат.BackupId = ИсходноеСообщение.BackupId;
	Результат.Date = ИсходноеСообщение.Date;
	Результат.FileId = ИсходноеСообщение.FileId;
	
	Возврат Результат;
	
КонецФункции

Функция ТранслироватьОшибкаАрхивацииОбласти(Знач ИсходноеСообщение)
	
	Результат = ФабрикаXDTO.Создать(
		Интерфейс().СообщениеОшибкаАрхивацииОбласти(ПакетРезультирующейВерсии()));
		
	Результат.Zone = ИсходноеСообщение.Zone;
	Результат.BackupId = ИсходноеСообщение.BackupId;
	
	Возврат Результат;
	
КонецФункции

Функция ТранслироватьАрхивацияОбластиПропущена(Знач ИсходноеСообщение)
	
	Результат = ФабрикаXDTO.Создать(
		Интерфейс().СообщениеАрхивацияОбластиПропущена(ПакетРезультирующейВерсии()));
		
	Результат.Zone = ИсходноеСообщение.Zone;
	Результат.BackupId = ИсходноеСообщение.BackupId;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
