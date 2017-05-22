﻿////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки СтандартныеПодсистемы (БСП).
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Сведения о библиотеке (или конфигурации).

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                  Обработчики обновления таких библиотек должны быть вызваны ранее
//                                  обработчиков обновления данной библиотеки.
//                                  При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                  порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                  в процедуре ПриДобавленииПодсистем общего модуля ПодсистемыКонфигурацииПереопределяемый.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "СтандартныеПодсистемы";
	Описание.Версия = "2.1.6.20";
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//  Обработчики - ТаблицаЗначений - описание полей, см. в процедуре
//                ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.МонопольныйРежим    = Ложь;
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	// Обработчики этого события для подсистем БСП добавляются через подписку на служебное событие:
	// "СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления".
	//
	// Процедуры обработки этого события всех подсистем БСП имеют то же имя, что и эта процедура,
	// но размещены в своих подсистемах.
	// Чтобы найти процедуры можно выполнить глобальный поиск по имени процедуры.
	// Чтобы найти модули в которых размещены процедуры, можно выполнить поиск по имени события.
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Если Обработчик.Подсистема <> "СтандартныеПодсистемы" Тогда
			Продолжить;
		КонецЕсли;
		Обработчик.Модуль.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЦикла;
	
КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	// Обработчики этого события для подсистем БСП добавляются через подписку на служебное событие:
	// "СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПередОбновлениемИнформационнойБазы".
	//
	// Процедуры обработки этого события всех подсистем БСП имеют то же имя, что и эта процедура,
	// но размещены в своих подсистемах.
	// Чтобы найти процедуры можно выполнить глобальный поиск по имени процедуры.
	// Чтобы найти модули в которых размещены процедуры, можно выполнить поиск по имени события.
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПередОбновлениемИнформационнойБазы");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Если Обработчик.Подсистема <> "СтандартныеПодсистемы" Тогда
			Продолжить;
		КонецЕсли;
		Обработчик.Модуль.ПередОбновлениемИнформационнойБазы();
	КонецЦикла;
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсия       - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия          - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - (возвращаемое значение) если установить Истина,
//                                то будет выведена форма с описанием обновлений. По умолчанию, Истина.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
// Пример обхода выполненных обработчиков обновления:
//
//	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//		
//		Если Версия.Версия = "*" Тогда
//			// Обработчик, который может выполнятся при каждой смене версии.
//		Иначе
//			// Обработчик, который выполняется для определенной версии.
//		КонецЕсли;
//		
//		Для Каждого Обработчик Из Версия.Строки Цикл
//			...
//		КонецЦикла;
//		
//	КонецЦикла;
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	// Вызываем процедуры-обработчики служебного события "ПослеОбновленияИнформационнойБазы".
	// (Для быстрого перехода к процедурам-обработчикам выполнить глобальный поиск по имени события.)
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПослеОбновленияИнформационнойБазы");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Если Обработчик.Подсистема <> "СтандартныеПодсистемы" Тогда
			Продолжить;
		КонецЕсли;
		Обработчик.Модуль.ПослеОбновленияИнформационнойБазы(ПредыдущаяВерсия, ТекущаяВерсия,
			ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим);
	КонецЦикла;
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры
