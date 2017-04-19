﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интерфейсы сообщений в модели сервиса".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает поддерживаемые версии интерфейса сообщений, поддерживаемые текущей
//  информационной базой
//
// Параметры:
//  ИмяИнтерфейса - строка, имя программного интерфейса сообщений
//
// Возвращаемое значение:
//  Массив (элементы - строка), номера поддерживаемых версий в формате РР.{П|ПП}.ЗЗ.СС
//
Функция ВерсииИнтерфейсаТекущейИБ(Знач ИмяИнтерфейса) Экспорт
	
	Результат = Неопределено;
	
	ИнтерфейсыОтправителя = Новый Структура;
	ЗарегистрироватьВерсииОтправляемыхСообщений(ИнтерфейсыОтправителя);
	ИнтерфейсыОтправителя.Свойство(ИмяИнтерфейса, Результат);
	
	Если Результат = Неопределено ИЛИ Результат.Количество() = 0 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Текущая информационная база не поддерживает интерфейс %1!'"), ИмяИнтерфейса);
	Иначе
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

// Возвращает версии интерфейса сообщений, поддерживаемые ИБ-корреспондентом
//
// Параметры:
//  ИнтерфейсСообщения - строка, имя программного интерфейса сообщений
//  ПараметрыПодключения - структура, параметры подключения к ИБ-корреспонденту
//  ПредставлениеПолучателя - строка, представление ИБ-корреспондента
//  ИнтерфейсТекущейИБ - строка, имя программного интерфейса текущей ИБ (используется
//    для обеспечения обратной совместимости с предыдущими версиями БСП)
//
// Возвращаемое значение:
//  Строка, максимальная версия интерфейса, поддерживаемая как ИБ-корреспондентом, так и текущей ИБ
//
Функция ВерсияИнтерфейсаКорреспондента(Знач ИнтерфейсСообщения, Знач ПараметрыПодключения, Знач ПредставлениеПолучателя, Знач ИнтерфейсТекущейИБ = "") Экспорт
	
	ВерсииКорреспондента = ОбщегоНазначения.ПолучитьВерсииИнтерфейса(ПараметрыПодключения, ИнтерфейсСообщения);
	Если ИнтерфейсТекущейИБ = "" Тогда
		ВерсияКорреспондента = ВыборВерсииКорреспондента(ИнтерфейсСообщения, ВерсииКорреспондента);
	Иначе
		ВерсияКорреспондента = ВыборВерсииКорреспондента(ИнтерфейсТекущейИБ, ВерсииКорреспондента);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса") Тогда
		МодульИнтерфейсыСообщенийВМоделиСервисаСтандартныеПодсистемы = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ИнтерфейсыСообщенийВМоделиСервисаСтандартныеПодсистемы");
		МодульИнтерфейсыСообщенийВМоделиСервисаСтандартныеПодсистемы.ПриОпределенииВерсииИнтерфейсаКорреспондента(
			ИнтерфейсСообщения,
			ПараметрыПодключения,
			ПредставлениеПолучателя,
			ВерсияКорреспондента);
	КонецЕсли;
	
	ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ПриОпределенииВерсииИнтерфейсаКорреспондента(
		ИнтерфейсСообщения,
		ПараметрыПодключения,
		ПредставлениеПолучателя,
		ВерсияКорреспондента);
	
	Возврат ВерсияКорреспондента;
	
КонецФункции

// Возвращает имена каналов сообщений из заданного пакета
//
// Параметры:
//  URIПакета - Строка - URI пакета XDTO, типы сообщений из которого
//   требуется получить
//  БазовыйТип - ТипXDTO, базовый тип
//
// Возвращаемое значение:
//  ФиксированныйМассив(Строка) - имена каналов найденные в пакете
//
Функция ПолучитьКаналыПакета(Знач URIПакета, Знач БазовыйТип) Экспорт
	
	Результат = Новый Массив;
	
	ТипыСообщенийПакета = 
		ПолучитьТипыСообщенийПакета(URIПакета, БазовыйТип);
	
	Для каждого ТипСообщения Из ТипыСообщенийПакета Цикл
		Результат.Добавить(СообщенияВМоделиСервиса.ИмяКаналаПоТипуСообщения(ТипСообщения));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

// Возвращает типы объектов XDTO содержащихся в заданном
// пакете, являющиеся типа сообщений удаленного администрирования
//
// Параметры:
//  URIПакета - Строка - URI пакета XDTO, типы сообщений из которого
//   требуется получить,
//  БазовыйТип - ТипXDTO, базовый тип
//
// Возвращаемое значение:
//  Массив(ТипОбъектаXDTO) - типы сообщений найденные в пакете
//
Функция ПолучитьТипыСообщенийПакета(Знач URIПакета, Знач БазовыйТип) Экспорт
	
	Результат = Новый Массив;
	
	МоделиПакетов = ФабрикаXDTO.ЭкспортМоделиXDTO(URIПакета);
	
	Для Каждого МодельПакета Из МоделиПакетов.package Цикл
		Для Каждого МодельОбъектногоТипа Из МодельПакета.objectType Цикл
			ТипОбъекта = ФабрикаXDTO.Тип(URIПакета, МодельОбъектногоТипа.name);
			Если НЕ ТипОбъекта.Абстрактный
				И БазовыйТип.ЭтоПотомок(ТипОбъекта) Тогда
				
				Результат.Добавить(ТипОбъекта);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает фиксированный массив, заполненный общими модулями, являющимися
//  обработчиками интерфейсов отправляемых сообщений
//
// Возвращаемое значение:
//  ФиксированныйМассив.
//
Функция ПолучитьОбработчикиИнтерфейсовОтправляемыхСообщений() Экспорт
	
	МассивОбработчиков = Новый Массив();
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса") Тогда
		МодульИнтерфейсыСообщенийВМоделиСервисаСтандартныеПодсистемы = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ИнтерфейсыСообщенийВМоделиСервисаСтандартныеПодсистемы");
		МодульИнтерфейсыСообщенийВМоделиСервисаСтандартныеПодсистемы.ЗаполнитьОбработчикиОтправляемыхСообщений(МассивОбработчиков);
	КонецЕсли;
	
	ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиОтправляемыхСообщений(
		МассивОбработчиков);
	
	Возврат Новый ФиксированныйМассив(МассивОбработчиков);
	
КонецФункции

// Возвращает фиксированный массив, заполненный общими модулями, являющимися
//  обработчиками интерфейсов принимаемых сообщений
//
// Возвращаемое значение:
//  ФиксированныйМассив.
//
Функция ПолучитьОбработчикиИнтерфейсовПринимаемыхСообщений() Экспорт
	
	МассивОбработчиков = Новый Массив();
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса") Тогда
		МодульИнтерфейсыСообщенийВМоделиСервисаСтандартныеПодсистемы = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ИнтерфейсыСообщенийВМоделиСервисаСтандартныеПодсистемы");
		МодульИнтерфейсыСообщенийВМоделиСервисаСтандартныеПодсистемы.ЗаполнитьОбработчикиПринимаемыхСообщений(МассивОбработчиков);
	КонецЕсли;
	
	ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиПринимаемыхСообщений(
		МассивОбработчиков);
	
	Возврат Новый ФиксированныйМассив(МассивОбработчиков);
	
КонецФункции

// Возвращает соответствие названий программных интерфейсов сообщений и их обработчиков
//
// Возвращаемое значение:
//  ФиксированноеСоответствие:
//    Ключ - строка, название программного интерфейса,
//    Значение - ОбщийМодуль
//
Функция ПолучитьИнтерфейсыОтправляемыхСообщений() Экспорт
	
	Результат = Новый Соответствие();
	МассивОбработчиков = ПолучитьОбработчикиИнтерфейсовОтправляемыхСообщений();
	Для Каждого Обработчик Из МассивОбработчиков Цикл
		
		Попытка
			Результат.Вставить(Обработчик.Пакет(), Обработчик.ПрограммныйИнтерфейс());
		Исключение
			// Обработчик может не экспортировать программный интерфейс
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

// Возвращает соответствие названий программных интерфейсов и их текущих версий (сообщения которых создаются
//  в вызывающем коде)
//
// Возвращаемое значение:
//  ФиксированноеСоответствие:
//    Ключ - строка, название программного интерфейса
//    Значение - строка, номер версии
//
Функция ПолучитьВерсииОтправляемыхСообщений() Экспорт
	
	Результат = Новый Соответствие();
	МассивОбработчиков = ПолучитьОбработчикиИнтерфейсовОтправляемыхСообщений();
	Для Каждого Обработчик Из МассивОбработчиков Цикл
		
		Попытка
			Результат.Вставить(Обработчик.ПрограммныйИнтерфейс(), Обработчик.Версия());
		Исключение
			// Обработчик может не экспортировать программный интерфейс
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

// Возвращает массив обработчиков трансляции для сообщений модели сервиса.
//
// Возвращаемое значение:
//  Массив(ОбщийМодуль).
//
Функция ПолучитьОбработчикиТрансляцииСообщений() Экспорт
	
	Результат = Новый Массив();
	
	ОбработчикиИнтерфейсов = ПолучитьОбработчикиИнтерфейсовОтправляемыхСообщений();
	
	Для Каждого ОбработчикИнтерфейса Из ОбработчикиИнтерфейсов Цикл
		
		ОбработчикиТрансляции = Новый Массив();
		ОбработчикИнтерфейса.ОбработчикиТрансляцииСообщений(ОбработчикиТрансляции);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат, ОбработчикиТрансляции);
		
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики[
			"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменСообщениями\ПриОпределенииОбработчиковКаналовСообщений"].Добавить(
				"ИнтерфейсыСообщенийВМоделиСервиса");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов"].Добавить(
			"ИнтерфейсыСообщенийВМоделиСервиса");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Получает список обработчиков сообщений, которые обрабатывают подсистемы библиотеки.
// 
// Параметры:
//  Обработчики - ТаблицаЗначений - состав полей см. в ОбменСообщениями.НоваяТаблицаОбработчиковСообщений
// 
Процедура ПриОпределенииОбработчиковКаналовСообщений(Обработчики) Экспорт
	
	ОбработчикиИнтерфейсов = ПолучитьОбработчикиИнтерфейсовПринимаемыхСообщений();
	
	Для Каждого ОбработчикИнтерфейса Из ОбработчикиИнтерфейсов Цикл
		
		ОбработчикиКаналовИнтерфейса  = Новый Массив();
		ОбработчикИнтерфейса.ОбработчикиКаналовСообщений(ОбработчикиКаналовИнтерфейса);
		
		Для Каждого ОбработчикКаналаИнтерфейса Из ОбработчикиКаналовИнтерфейса Цикл
			
			Пакет = ОбработчикКаналаИнтерфейса.Пакет();
			БазовыйТип = ОбработчикКаналаИнтерфейса.БазовыйТип();
			
			ИменаКаналов = ПолучитьКаналыПакета(Пакет, БазовыйТип);
			
			Для Каждого ИмяКанала Из ИменаКаналов Цикл
				Обработчик = Обработчики.Добавить();
				Обработчик.Канал = ИмяКанала;
				Обработчик.Обработчик = СообщенияВМоделиСервисаОбработчикСообщений;
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Заполняет структуру массивами поддерживаемых версий всех подлежащих версионированию подсистем,
// используя в качестве ключей названия подсистем.
// Обеспечивает функциональность Web-сервиса InterfaceVersion.
// При внедрении надо поменять тело процедуры так, чтобы она возвращала актуальные наборы версий (см. пример.ниже).
//
// Параметры:
// СтруктураПоддерживаемыхВерсий - Структура: 
//	- Ключи = Названия подсистем. 
//	- Значения = Массивы названий поддерживаемых версий.
//
// Пример реализации:
//
//	// СервисПередачиФайлов
//	МассивВерсий = Новый Массив;
//	МассивВерсий.Добавить("1.0.1.1");	
//	МассивВерсий.Добавить("1.0.2.1"); 
//	СтруктураПоддерживаемыхВерсий.Вставить("СервисПередачиФайлов", МассивВерсий);
//	// Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(Знач СтруктураПоддерживаемыхВерсий) Экспорт
	
	ЗарегистрироватьВерсииПринимаемыхСообщений(СтруктураПоддерживаемыхВерсий);
	
КонецПроцедуры

// Заполняет переданную структуру поддерживаемых версий поддерживаемыми версиями принимаемых
//  сообщений.
//
// Параметры:
//  СтруктураПоддерживаемыхВерсий - Структура:
//    Ключ - названия подсистемы,
//    Значение - массивы названий поддерживаемых версий.
//
Процедура ЗарегистрироватьВерсииПринимаемыхСообщений(СтруктураПоддерживаемыхВерсий)
	
	ОбработчикиИнтерфейсов = ПолучитьОбработчикиИнтерфейсовПринимаемыхСообщений();
	
	Для Каждого ОбработчикИнтерфейса Из ОбработчикиИнтерфейсов Цикл
		
		ОбработчикиКаналов = Новый Массив();
		ОбработчикИнтерфейса.ОбработчикиКаналовСообщений(ОбработчикиКаналов);
		
		ПоддерживаемыеВерсии = Новый Массив();
		
		Для Каждого ОбработчикВерсии Из ОбработчикиКаналов Цикл
			
			ПоддерживаемыеВерсии.Добавить(ОбработчикВерсии.Версия());
			
		КонецЦикла;
		
		СтруктураПоддерживаемыхВерсий.Вставить(
			ОбработчикИнтерфейса.ПрограммныйИнтерфейс(),
			ПоддерживаемыеВерсии);
		
	КонецЦикла;
	
КонецПроцедуры

// Заполняет переданную структуру поддерживаемых версий поддерживаемыми версиями отправляемых
//  сообщений.
//
// Параметры:
//  СтруктураПоддерживаемыхВерсий - Структура:
//    Ключ - названия подсистемы,
//    Значение - массивы названий поддерживаемых версий.
//
Процедура ЗарегистрироватьВерсииОтправляемыхСообщений(СтруктураПоддерживаемыхВерсий)
	
	ОбработчикиИнтерфейсов = ПолучитьОбработчикиИнтерфейсовОтправляемыхСообщений();
	
	Для Каждого ОбработчикИнтерфейса Из ОбработчикиИнтерфейсов Цикл
		
		ОбработчикиТрансляции = Новый Массив();
		ОбработчикИнтерфейса.ОбработчикиТрансляцииСообщений(ОбработчикиТрансляции);
		
		ПоддерживаемыеВерсии = Новый Массив();
		
		Для Каждого ОбработчикВерсии Из ОбработчикиТрансляции Цикл
			
			ПоддерживаемыеВерсии.Добавить(ОбработчикВерсии.РезультирующаяВерсия());
			
		КонецЦикла;
		
		ПоддерживаемыеВерсии.Добавить(ОбработчикИнтерфейса.Версия());
		
		СтруктураПоддерживаемыхВерсий.Вставить(
			ОбработчикИнтерфейса.ПрограммныйИнтерфейс(),
			ПоддерживаемыеВерсии);
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняет выбор версии интерфейса, поддерживаемой как текущей информационной
// базой, так и информационной базой - корреспондентом.
//
// Параметры:
//  Интерфейс - Строка, имя интерфейса сообщений,
//  ВерсииКорреспондента - Массив(Строка), версии интерфейса-сообщений,
//    поддерживаемые информационной базой - корреспондентом.
//
Функция ВыборВерсииКорреспондента(Знач Интерфейс, Знач ВерсииКорреспондента)
	
	ВерсииОтправителя = ВерсииИнтерфейсаТекущейИБ(Интерфейс);
	
	ВыбраннаяВерсия = Неопределено;
	
	Для Каждого ВерсияКорреспондента Из ВерсииКорреспондента Цикл
		
		Если ВерсииОтправителя.Найти(ВерсияКорреспондента) <> Неопределено Тогда
			
			Если ВыбраннаяВерсия = Неопределено Тогда
				ВыбраннаяВерсия = ВерсияКорреспондента;
			Иначе
				ВыбраннаяВерсия = ?(ОбщегоНазначенияКлиентСервер.СравнитьВерсии(
						ВерсияКорреспондента, ВыбраннаяВерсия) > 0, ВерсияКорреспондента,
						ВыбраннаяВерсия);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВыбраннаяВерсия;
	
КонецФункции
