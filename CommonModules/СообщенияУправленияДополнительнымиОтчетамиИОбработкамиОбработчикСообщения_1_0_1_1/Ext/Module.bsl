﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК КАНАЛОВ СООБЩЕНИЙ ДЛЯ ВЕРСИИ 1.0.1.1 ИНТЕРФЕЙСА СООБЩЕНИЙ
//  УПРАВЛЕНИЯ ДОПОЛНИТЕЛЬНЫМИ ОТЧЕТАМИ И ОБРАБОТКАМИ
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает пространство имен версии интерфейса сообщений
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/ApplicationExtensions/Management/" + Версия();
	
КонецФункции

// Возвращает версию интерфейса сообщений, обслуживаемую обработчиком
Функция Версия() Экспорт
	
	Возврат "1.0.1.1";
	
КонецФункции

// Возвращает базовый тип для сообщений версии
Функция БазовыйТип() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипТело();
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса
//
// Параметры:
//  Сообщение - ОбъектXDTO, входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями, узел плана обмена, соответствующий отправителю сообщения
//  СообщениеОбработано - булево, флаг успешной обработки сообщения. Значение данного параметра необходимо
//    установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияУправленияДополнительнымиОтчетамиИОбработкамиИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеУстановитьДополнительныйОтчетИлиОбработку(Пакет()) Тогда
		УстановитьДополнительныйОтчетИлиОбработку(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУдалитьДополнительныйОтчетИлиОбработку(Пакет()) Тогда
		УдалитьДополнительныйОтчетИлиОбработку(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеОтключитьДополнительныйОтчетИлиОбработку(Пакет()) Тогда
		ОтключитьДополнительныйОтчетИлиОбработку(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеВключитьДополнительныйОтчетИлиОбработку(Пакет()) Тогда
		ВключитьДополнительныйОтчетИлиОбработку(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеОтозватьДополнительныйОтчетИлиОбработку(Пакет()) Тогда
		ОтозватьДополнительныйОтчетИлиОбработку(Сообщение, Отправитель);
	Иначе
		СообщениеОбработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура УстановитьДополнительныйОтчетИлиОбработку(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	
	НастройкиКоманд = Новый ТаблицаЗначений();
	НастройкиКоманд.Колонки.Добавить("Идентификатор");
	НастройкиКоманд.Колонки.Добавить("БыстрыйДоступ");
	НастройкиКоманд.Колонки.Добавить("Расписание");
	
	Если ЗначениеЗаполнено(ТелоСообщения.CommandSettings) Тогда
		
		Для Каждого CommandSettings Из ТелоСообщения.CommandSettings Цикл
			
			НастройкиКоманды = НастройкиКоманд.Добавить();
			НастройкиКоманды.Идентификатор = CommandSettings.Id;
			
			Если CommandSettings.Settings <> Неопределено Тогда
				
				МассивИдентификаторов = Новый Массив;
				Для Каждого UserGUID Из CommandSettings.Settings.UsersFastAccess Цикл
					МассивИдентификаторов.Добавить(UserGUID);
				КонецЦикла;
				
				НастройкиКоманды.БыстрыйДоступ = МассивИдентификаторов;
				
				Если CommandSettings.Settings.Schedule <> Неопределено Тогда
					
					НастройкиКоманды.Расписание = СериализаторXDTO.ПрочитатьXDTO(CommandSettings.Settings.Schedule);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	НастройкиРазделов = Новый ТаблицаЗначений();
	НастройкиРазделов.Колонки.Добавить("Раздел");
	
	НастройкиНазначения = Новый ТаблицаЗначений();
	НастройкиНазначения.Колонки.Добавить("ОбъектНазначения");
	
	НастройкиРасположенияКоманд = Новый Структура();
	
	Если ЗначениеЗаполнено(ТелоСообщения.Assignments) Тогда
		
		Для Каждого Assignment Из ТелоСообщения.Assignments Цикл
			
			Если Assignment.Тип() = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНазначениеРазделам() Тогда
				
				Для Каждого AssignmentObject Из Assignment.Objects Цикл
					
					СтрокаРаздела = НастройкиРазделов.Добавить();
					Если AssignmentObject.ObjectName = ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола() Тогда
						СтрокаРаздела.Раздел = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
					Иначе
						СтрокаРаздела.Раздел = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(AssignmentObject.ObjectName);
					КонецЕсли;
					
				КонецЦикла;
				
			ИначеЕсли Assignment.Тип() = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНазначениеСправочникамИДокументам() Тогда
				
				Для Каждого AssignmentObject Из Assignment.Objects Цикл
					
					СтрокаНазначения = НастройкиНазначения.Добавить();
					СтрокаНазначения.ОбъектНазначения = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
						AssignmentObject.ObjectName);
					
				КонецЦикла;
				
				НастройкиРасположенияКоманд.Вставить("ИспользоватьДляФормыСписка",
					Assignment.UseInListsForms);
				НастройкиРасположенияКоманд.Вставить("ИспользоватьДляФормыОбъекта",
					Assignment.UseInObjectsForms);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	НастройкиВариантов = Новый ТаблицаЗначений();
	НастройкиВариантов.Колонки.Добавить("Ключ", Новый ОписаниеТипов("Строка"));
	НастройкиВариантов.Колонки.Добавить("Размещение", Новый ОписаниеТипов("Массив"));
	НастройкиВариантов.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Если ТелоСообщения.ReportVariants <> Неопределено Тогда
		
		Для Каждого ReportVariant Из ТелоСообщения.ReportVariants Цикл
			
			НастройкаВарианта = НастройкиВариантов.Добавить();
			НастройкаВарианта.Ключ = ReportVariant.VariantKey;
			НастройкаВарианта.Представление = ReportVariant.Representation;
			
			Размещение = Новый Массив;
			Для Каждого ReportVariantAssignment Из ReportVariant.Assignments Цикл
				
				Раздел = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
					ReportVariantAssignment.ObjectName);
				Важный = Ложь;
				СмТакже = Ложь;
				Если ReportVariantAssignment.Importance = "High" Тогда
					Важный = Истина;
				ИначеЕсли ReportVariantAssignment.Importance = "Low" Тогда
					СмТакже = Истина;
				КонецЕсли;
				ЭлементРазмещения = Новый Структура("Раздел,Важный,СмТакже", Раздел, Важный, СмТакже);
				Размещение.Добавить(ЭлементРазмещения);
				
			КонецЦикла;
			
			НастройкаВарианта.Размещение = Размещение;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОписаниеИнсталляции = Новый Структура(
		"Идентификатор,Представление,Инсталляция",
		ТелоСообщения.Extension,
		ТелоСообщения.Representation,
		ТелоСообщения.Installation);
	
	СообщенияУправленияДополнительнымиОтчетамиИОбработкамиРеализация.УстановитьДополнительныйОтчетИлиОбработку(
		ОписаниеИнсталляции, НастройкиКоманд, НастройкиРасположенияКоманд, НастройкиРазделов,
		НастройкиНазначения, НастройкиВариантов, ТелоСообщения.InitiatorServiceID);
	
КонецПроцедуры

Процедура УдалитьДополнительныйОтчетИлиОбработку(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияУправленияДополнительнымиОтчетамиИОбработкамиРеализация.УдалитьДополнительныйОтчетИлиОбработку(
		ТелоСообщения.Extension, ТелоСообщения.Installation);
	
КонецПроцедуры

Процедура ОтключитьДополнительныйОтчетИлиОбработку(Знач Сообщение, Знач Отправитель)
	
	СообщенияУправленияДополнительнымиОтчетамиИОбработкамиРеализация.ОтключитьДополнительныйОтчетИлиОбработку(
		Сообщение.Body.Extension);
	
КонецПроцедуры

Процедура ВключитьДополнительныйОтчетИлиОбработку(Знач Сообщение, Знач Отправитель)
	
	СообщенияУправленияДополнительнымиОтчетамиИОбработкамиРеализация.ВключитьДополнительныйОтчетИлиОбработку(
		Сообщение.Body.Extension);
	
КонецПроцедуры

Процедура ОтозватьДополнительныйОтчетИлиОбработку(Знач Сообщение, Знач Отправитель)
	
	СообщенияУправленияДополнительнымиОтчетамиИОбработкамиРеализация.ОтозватьДополнительныйОтчетИлиОбработку(
		Сообщение.Body.Extension);
	
КонецПроцедуры

