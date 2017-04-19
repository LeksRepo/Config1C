﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК ИНТЕРФЕЙСА МАНИФЕСТА ДОПОЛНИТЕЛЬНЫХ ОТЧЕТОВ И ОБРАБОТОК В МОДЕЛИ
//  СЕРВИСА
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/ApplicationExtensions/Manifest/" + Версия();
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений
Функция Версия() Экспорт
	
	Возврат "1.0.0.1";
	
КонецФункции

// Возвращает название программного интерфейса сообщений
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "ApplicationExtensionsCore";
	
КонецФункции

// Выполняет регистрацию поддерживаемых версий интерфейса сообщений
//
// Параметры:
//  СтруктураПоддерживаемыхВерсий - структура:
//    Ключ - название программного интерфейса
//    Значение - массив поддерживаемых версий
//
Процедура ЗарегистрироватьИнтерфейс(Знач СтруктураПоддерживаемыхВерсий) Экспорт
	
	МассивВерсий = Новый Массив;
	МассивВерсий.Добавить("1.0.0.1");
	СтруктураПоддерживаемыхВерсий.Вставить(ПрограммныйИнтерфейс(), МассивВерсий);
	
КонецПроцедуры

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
КонецПроцедуры

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionAssignmentObject
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция ТипОбъектНазначения(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionAssignmentObject");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionAssignmentBase
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция ТипНазначениеБазовое(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionAssignmentBase");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionSubsystemsAssignment
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция ТипНазначениеРазделам(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionSubsystemsAssignment");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionCatalogsAndDocumentsAssignment
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция ТипНазначениеСправочникамИДокументам(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionCatalogsAndDocumentsAssignment");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionCommand
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция ТипКоманда(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionCommand");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionReportVariantAssignment
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция ТипНазначениеВариантаОтчета(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionReportVariantAssignment");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionReportVariant
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция ТипВариантОтчета(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionReportVariant");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionCommandSettings
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция ТипНастройкиКоманды(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionCommandSettings");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionManifest
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция ТипМанифест(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionManifest");
	
КонецФункции

// Возвращает словарь соответствий значений перечисления ВидыДополнительныхОтчетовИОбработок
//  значения XDTO-типа {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionCategory
//
Функция СловарьВидыДополнительныхОтчетовИОбработок() Экспорт
	
	Словарь = Новый Структура();
	Менеджер = Перечисления.ВидыДополнительныхОтчетовИОбработок;
	
	Словарь.Вставить("AdditionalProcessor", Менеджер.ДополнительнаяОбработка);
	Словарь.Вставить("AdditionalReport", Менеджер.ДополнительныйОтчет);
	Словарь.Вставить("ObjectFilling", Менеджер.ЗаполнениеОбъекта);
	Словарь.Вставить("Report", Менеджер.Отчет);
	Словарь.Вставить("PrintedForm", Менеджер.ПечатнаяФорма);
	Словарь.Вставить("LinkedObjectCreation", Менеджер.СозданиеСвязанныхОбъектов);
	
	Возврат Словарь;
	
КонецФункции

// Возвращает словарь соответствий значений перечисления СпособыВызоваДополнительныхОбработок
//  значения XDTO-типа {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionStartupType
//
Функция СловарьСпособыВызоваДополнительныхОтчетовИОбработок() Экспорт
	
	Словарь = Новый Структура();
	Менеджер = Перечисления.СпособыВызоваДополнительныхОбработок;
	
	Словарь.Вставить("ClientCall", Менеджер.ВызовКлиентскогоМетода);
	Словарь.Вставить("ServerCall", Менеджер.ВызовСерверногоМетода);
	Словарь.Вставить("FormOpen", Менеджер.ОткрытиеФормы);
	Словарь.Вставить("FormFill", Менеджер.ЗаполнениеФормы);
	Словарь.Вставить("SafeModeExtension", Менеджер.СценарийВБезопасномРежиме);
	
	Возврат Словарь;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
		
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции