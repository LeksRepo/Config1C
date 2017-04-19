﻿////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Обработчик события ПриНачалеРаботыСистемы вызывается
// для выполнения действий, требуемых для подсистемы РегламентныеЗадания.
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если Не ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Или ПараметрыРаботыКлиента.РазделениеВключено Тогда
		Возврат;
	КонецЕсли;
	
	Если Найти(ПараметрЗапуска, "DoScheduledJobs") <> 0 Тогда
		
		ОбработатьПараметрыЗапуска();
		
	ИначеЕсли ПараметрыРаботыКлиента.ИнформационнаяБазаФайловаяБезМенеджераФоновыхЗаданий Тогда
		
		ПараметрыТолькоЧтение = ПараметрыРаботыКлиента.ПараметрыЗапускаОтдельногоСеансаВыполненияРегламентныхЗаданий;
		
		Если ПараметрыТолькоЧтение.Отказ Тогда
			ПриОшибкеВыполненияРегламентныхЗаданий(ПараметрыТолькоЧтение.ОписаниеОшибки);
		ИначеЕсли ПараметрыТолькоЧтение.ТребуетсяОткрытьОтдельныйСеанс Тогда
			ПодключитьОбработчикОжидания("ЗапуститьОтдельныйСеансДляВыполненияРегламентныхЗаданийЧерезОбработчикОжидания", 1, Истина);
		КонецЕсли;
		
		Если ПараметрыТолькоЧтение.УведомлятьОНекорректномВыполнении Тогда
			ПодключитьОбработчикОжидания("УведомлятьОНекорректномВыполненииРегламентныхЗаданий", ПараметрыТолькоЧтение.ПериодУведомления * 60, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьПараметрыЗапуска()

	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Предупреждать  = (Найти(ПараметрЗапуска, "SkipMessageBox") =  0);
	ОтдельныйСеанс = (Найти(ПараметрЗапуска, "AloneIBSession") <> 0);
	// В веб-клиенте обработка регламентных заданий в отдельном сеансе недоступно.
#Если ВебКлиент Тогда
	ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина;
	ЗавершитьРаботуСистемы(Ложь);
#КонецЕсли
	
	// Для клиент-серверной базы.
	Если Не ПараметрыРаботыКлиента.ИнформационнаяБазаФайловаяБезМенеджераФоновыхЗаданий Тогда
		Если Предупреждать Тогда
			Если ПараметрыРаботыКлиента.ИнформационнаяБазаФайловая Тогда
				Предупреждение(НСтр("ru = 'Регламентные задания выполняются платформой в скрытом сеансе.'"));
			Иначе
				Предупреждение(НСтр("ru = 'Регламентные задания выполняются на сервере.'"));
			КонецЕсли;
		КонецЕсли;
		Если ОтдельныйСеанс Тогда
			ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина;
			ЗавершитьРаботуСистемы(Ложь);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// Для файл-серверной базы.
	ЗаданияВыполняютсяНормально = Неопределено;
	ОписаниеОшибки = "";
	Если РегламентныеЗаданияСлужебныйВызовСервера.ТекущийСеансВыполняетРегламентныеЗадания(ЗаданияВыполняютсяНормально, Истина, ОписаниеОшибки) Тогда
		
		Префикс = НСтр("ru = 'Выполнение регламентных заданий'");
		
		Если ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83БезРежимаСовместимости() Тогда
			Выполнить("УстановитьЗаголовокКлиентскогоПриложения(Префикс +"": ""+ + ПолучитьЗаголовокКлиентскогоПриложения());");
		Иначе
			Выполнить("УстановитьЗаголовокПриложения(Префикс +"": ""+ ПолучитьЗаголовокПриложения());");
		КонецЕсли;
		
		Если ОтдельныйСеанс Тогда
			// Выполнять в отдельном сеансе.
			ОсновноеОкно = ОсновноеОкно();

			ИзПрограммы = (Найти(ПараметрЗапуска, "From1C") <> 0); 
			ПараметрыВФорму = Новый Структура("ЗаголовокНадписи", 
				?(ИзПрограммы, НСтр("ru = 'Сеанс закроется автоматически при закрытии основного сеанса.'"), ""));
			
			Если ОсновноеОкно = Неопределено Тогда
				ОткрытьФорму(
					"Обработка.РегламентныеИФоновыеЗадания.Форма.РабочийСтолОтдельногоСеансаВыполненияРегламентныхЗаданий",
					ПараметрыВФорму);
			Иначе
				ОткрытьФорму(
					"Обработка.РегламентныеИФоновыеЗадания.Форма.РабочийСтолОтдельногоСеансаВыполненияРегламентныхЗаданий",
					ПараметрыВФорму,
					,
					,
					ОсновноеОкно);
			КонецЕсли;
			
			ОткрытьФормуМодально("Обработка.РегламентныеИФоновыеЗадания.Форма.ВыполнениеРегламентныхЗаданий");
		Иначе
			// Выполнять в этом сеансе.
			ПодключитьОбработчикОжидания("ВыполнениеРегламентныхЗаданийВОсновномСеансе", 1, Истина);
		КонецЕсли;
	Иначе
		Если Предупреждать Тогда
			
			Если ЗаданияВыполняютсяНормально Тогда
				ТекстСообщения = НСтр("ru = 'Сеанс, обрабатывающий регламентные задания, уже открыт.'");
			Иначе
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сеанс, выполняющий регламентные задания, уже открыт.
						| 
						|%1'"), ОписаниеОшибки);
				Предупреждение(ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
		Если ОтдельныйСеанс Тогда
			ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина;
			ЗавершитьРаботуСистемы(Ложь);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры 

// Выполняет попытку открытия нового сеанса, обрабатывающего регламентные задания.
//
// Параметры:
//  Параметры    - Структура, используемые свойства:
//                   ДополнительныеПараметрыКоманднойСтроки - Строка.
//                   Отказ                                  - Булево, выходной параметр.
//                   ОписаниеОшибки                         - Строка, выходной параметр.
// 
Процедура ПопыткаЗапуститьОтдельныйСеансДляВыполненияРегламентныхЗаданий(Знач Параметры) Экспорт
	
	#Если НЕ ВебКлиент Тогда
		Попытка
			Параметры.ВыполненаПопыткаОткрытия = Истина;
			ЗапуститьСистему(
				?(Найти(ВРег(ПараметрЗапуска), "/DEBUG") = 0, "", "/DEBUG ")
				+ Параметры.ДополнительныеПараметрыКоманднойСтроки);
		Исключение
			Параметры.ОписаниеОшибки = ОписаниеОшибки();
			Параметры.Отказ = Истина;
		КонецПопытки;
	#Иначе
		Параметры.Отказ = Истина;
		Параметры.ОписаниеОшибки =
			НСтр("ru = 'Выполнение регламентных заданий в отдельном сеансе веб-клиента невозможна.
			           |
			           |Для выполнения регламентных заданий, необходимо, чтобы администратор настроил запуск обычного
			           |или тонкого клиента на веб-сервере.'");
	#КонецЕсли
	Параметры.ОписаниеОшибки =
		?(ПустаяСтрока(Параметры.ОписаниеОшибки),
		  "",
		  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка открытия сеанса для выполнения регламентных заданий:
				           |
				           |%1'"),
				Параметры.ОписаниеОшибки));
	
КонецПроцедуры

// Оповещает пользователя об ошибке выполнения регламентных заданий.
//
// Вызывается из процедуры РегламентныеЗаданияСлужебныйГлобальный.УведомлятьОНекорректномВыполненииРегламентныхЗаданий() и
// РегламентныеЗаданияСлужебныйКлиент.ПриНачалеРаботыСистемы().
//
//  Вызов происходит, если обнаружено, что нет сеанса выполнения или
// сеанс есть, но "висит" (долго "не работает").
//
// Параметры:
//  ОписаниеОшибки - Строка.
//
Процедура ПриОшибкеВыполненияРегламентныхЗаданий(ОписаниеОшибки) Экспорт
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ПараметрыЗапускаОтдельногоСеансаВыполненияРегламентныхЗаданий.ТекущийПользовательАдминистратор Тогда
		ПоказатьОповещениеПользователя(
				НСтр("ru = 'Регламентные задания не выполняются.'"),
				"e1cib/app/Обработка.РегламентныеИФоновыеЗадания",
				ОписаниеОшибки,
				БиблиотекаКартинок.ОшибкаВыполненияРегламентныхЗаданий);
	Иначе
		ПоказатьОповещениеПользователя(
				НСтр("ru = 'Регламентные задания не выполняются.'"),
				,
				ОписаниеОшибки + Символы.ПС + НСтр("ru = 'Обратитесь к администратору.'"),
				БиблиотекаКартинок.ОшибкаВыполненияРегламентныхЗаданий);
	КонецЕсли;
	
КонецПроцедуры

// Подключает глобальный обработчик ожидания в форме.
Процедура ПодключитьГлобальныйОбработчикОжидания(ИмяПроцедуры, Интервал, Однократно = Ложь) Экспорт
	
	ПодключитьОбработчикОжидания(ИмяПроцедуры, Интервал, Однократно);
	
КонецПроцедуры

// Отключает глобальный обработчик ожидания в форме.
Процедура ОтключитьГлобальныйОбработчикОжидания(ИмяПроцедуры) Экспорт
	
	ОтключитьОбработчикОжидания(ИмяПроцедуры);
	
КонецПроцедуры

// Возвращает основное окно приложения.
Функция ОсновноеОкно() Экспорт
	
	ОсновноеОкно = Неопределено;
	
	Окна = ПолучитьОкна();
	Если Окна <> Неопределено Тогда
		Для каждого Окно Из Окна Цикл
			Если Окно.Основное Тогда
				ОсновноеОкно = Окно;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ОсновноеОкно;
	
КонецФункции
