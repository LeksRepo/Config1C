﻿
// СтандартныеПодсистемы

// СтандартныеПодсистемы.БазоваяФункциональность

// СписокЗначений для накапливания пакета сообщений в журнал регистрации, 
// формируемых в клиентской бизнес-логике.
Перем СообщенияДляЖурналаРегистрации Экспорт; 
// Признак того, что в данном сеансе не нужно повторно предлагать установку
Перем ПредлагатьУстановкуРасширенияРаботыСФайлами Экспорт;
// Признак того, что в данном сеансе не нужно запрашивать стандартное подтверждение при выходе
Перем ПропуститьПредупреждениеПередЗавершениемРаботыСистемы Экспорт;
// Структура параметров для клиентской логики по завершению работы в программе.
Перем ПараметрыРаботыКлиентаПриЗавершении Экспорт;
// Признак того, что при запуске в сеансе администратора нужно вывести форму описаний изменений.
Перем ВывестиОписаниеИзмененийДляАдминистратора Экспорт;
// Структура, содержащая в себе время начала и окончания обновления программы.
Перем ПараметрыРаботыКлиентаПриОбновлении Экспорт;

// Конец СтандартныеПодсистемы.БазоваяФункциональность

// СтандартныеПодсистемы.ЗавершениеРаботыПользователей
Перем РаботаПользователейЗавершается Экспорт;
// Конец СтандартныеПодсистемы.ЗавершениеРаботыПользователей

// СтандартныеПодсистемы.ОбновлениеКонфигурации

// Информация о доступном обновлении конфигурации, обнаруженном в Интернете
// при запуске программы.
Перем ДоступноеОбновлениеКонфигурации Экспорт;
// Структура с параметрами помощника обновления конфигурации.
Перем НастройкиОбновленияКонфигурации Экспорт; 
// Признак необходимости обновления конфигурации информационной базы при завершении сеанса.
Перем ПредлагатьОбновлениеИнформационнойБазыПриЗавершенииСеанса Экспорт;
// Конец СтандартныеПодсистемы.ОбновлениеКонфигурации

// СтандартныеПодсистемы.РаботаСФайлами
Перем КомпонентаTwain Экспорт; // Twain компонента для работы со сканером
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.ФайловыеФункции
// Признак того, что в данном сеансе не нужно повторно делать проверку доступа к каталогу на диске
Перем ПроверкаДоступаКРабочемуКаталогуВыполнена Экспорт;
// Конец СтандартныеПодсистемы.ФайловыеФункции

// СтандартныеПодсистемы.РезервноеКопированиеИБ

// Параметры для резервного копирования
Перем ПараметрыРезервногоКопированияИБ Экспорт;
// Признак выполнения резервного копирования при завершении сеанса
Перем ОповещатьОРезервномКопированииПриЗавершенииСеанса Экспорт;
// Максимальная дата отложенного резервного копирования
Перем ДатаОтложенногоРезервногоКопирования Экспорт;

// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ

// СтандартныеПодсистемы.ОценкаПроизводительности
Перем ОценкаПроизводительностиЗамерВремени Экспорт;
// Конец СтандартныеПодсистемы.ОценкаПроизводительности

// СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса
Перем ПредлагатьСинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииСеанса Экспорт;
// Конец СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса

// Конец СтандартныеПодсистемы

Процедура ПередНачаломРаботыСистемы(Отказ)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ДействияПередНачаломРаботыСистемы(Отказ);
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ДействияПриНачалеРаботыСистемы(Истина);
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ДействияПередЗавершениемРаботыСистемы(Отказ);
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры
