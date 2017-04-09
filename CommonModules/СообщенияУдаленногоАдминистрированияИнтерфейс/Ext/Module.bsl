﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК ИНТЕРФЕЙСА СООБЩЕНИЙ УДАЛЕННОГО АДМИНИСТРИРОВАНИЯ
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/RemoteAdministration/App/" + Версия();
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений
Функция Версия() Экспорт
	
	Возврат "1.0.3.4";
	
КонецФункции

// Возвращает название программного интерфейса сообщений
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "RemoteAdministrationApp";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_1);
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_2);
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_3);
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_4);
	
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
	
	
	
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}UpdateUser
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОбновитьПользователя(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "UpdateUser");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetFullControl
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьПолныеПраваОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetFullControl");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetApplicationAccess
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьДоступКОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetApplicationAccess");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetDefaultUserRights
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьПраваПользователяПоУмолчанию(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetDefaultUserRights");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}PrepareApplication
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПодготовитьОбластьДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "PrepareApplication");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}BindApplication
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПрикрепитьОбластьДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "BindApplication");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}UsersList
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеСписокПользователей(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "UsersList");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}PrepareCustomApplication
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПодготовитьОбластьДанныхИзВыгрузки(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "PrepareCustomApplication");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}DeleteApplication
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУдалитьОбластьДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DeleteApplication");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetApplicationParams
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьПараметрыОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetApplicationParams");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetIBParams
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьПараметрыИБ(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetIBParams");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetServiceManagerEndPoint
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьКонечнуюТочкуМенеджераСервиса(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetServiceManagerEndPoint");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}ApplicationsRating
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция ТипРейтингОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ApplicationRating");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetApplicationsRating
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьРейтингОбластейДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetApplicationsRating");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}InstallExtension
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьДополнительныйОтчетИлиОбработку(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "InstallExtension");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}ExtensionCommandSettings
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция ТипНастройкиКомандыДополнительногоОтчетаИлиОбработки(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionCommandSettings");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}DeleteExtension
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУдалитьДополнительныйОтчетИлиОбработку(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DeleteExtension");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}DisableExtension
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОтключитьДополнительныйОтчетИлиОбработку(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DisableExtension");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}EnableExtension
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеВключитьДополнительныйОтчетИлиОбработку(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "EnableExtension");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}DropExtension
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОтозватьДополнительныйОтчетИлиОбработку(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DropExtension");
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет = Неопределено, Знач Тип)
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции