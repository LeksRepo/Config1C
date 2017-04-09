﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Содержит сохраненные параметры, используемые подсистемой.
Функция ПараметрыБазовойФункциональности() Экспорт
	
	СохраненныеПараметры = ОбновлениеИнформационнойБазы.ПараметрыРаботыПрограммы(
		"ПараметрыБазовойФункциональности");
	
	ПредставлениеПараметра = "";
	
	Если НЕ СохраненныеПараметры.Свойство("ИдентификаторыОбъектовМетаданных") Тогда
		ПредставлениеПараметра = НСтр("ru = 'Идентификаторы объектов метаданных'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставлениеПараметра) Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка обновления информационной базы.
			           |Не заполнен параметр базовой функциональности:
			           |""%1"".'"),
			ПредставлениеПараметра);
	КонецЕсли;
	
	Возврат СохраненныеПараметры;
	
КонецФункции

// Содержит сохраненные параметры, используемые подсистемой.
Функция ПараметрыПрограммныхСобытий() Экспорт
	
	СохраненныеПараметры = ОбновлениеИнформационнойБазы.ПараметрыРаботыПрограммы(
		"ПараметрыСлужебныхСобытий");
	
	ПредставлениеПараметра = "";
	
	Если НЕ СохраненныеПараметры.Свойство("ОбработчикиСобытий") Тогда
		ПредставлениеПараметра = НСтр("ru = 'Обработчики событий'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставлениеПараметра) Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка обновления информационной базы.
			           |Не заполнен параметр служебных событий:
			           |""%1"".'"),
			ПредставлениеПараметра);
	КонецЕсли;
	
	Возврат СохраненныеПараметры;
	
КонецФункции

// Возвращает описания всех библиотек конфигурации, включая
// описание самой конфигурации.
//
Функция ОписанияПодсистем() Экспорт
	
	МодулиПодсистем = Новый Массив;
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБСП");
	
	ПодсистемыКонфигурацииПереопределяемый.ПриДобавленииПодсистем(МодулиПодсистем);
	
	ОписаниеКонфигурацииНайдено = Ложь;
	ОписанияПодсистем = Новый Структура;
	ОписанияПодсистем.Вставить("Порядок",  Новый Массив);
	ОписанияПодсистем.Вставить("ПоИменам", Новый Соответствие);
	
	ВсеТребуемыеПодсистемы = Новый Соответствие;
	
	Для каждого ИмяМодуля Из МодулиПодсистем Цикл
		
		Описание = НовоеОписаниеПодсистемы();
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль(ИмяМодуля);
		Модуль.ПриДобавленииПодсистемы(Описание);
		
		Если Описание.Имя = "СтандартныеПодсистемы" Тогда
			// <СВОЙСТВА ТОЛЬКО ДЛЯ БИБЛИОТЕКИ СТАНДАРТНЫХ ПОДСИСТЕМ>
			Описание.ДобавлятьСлужебныеСобытия            = Истина;
			Описание.ДобавлятьОбработчикиСлужебныхСобытий = Истина;
		КонецЕсли;
		
		Если ОписанияПодсистем.ПоИменам.Получить(Описание.Имя) <> Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при подготовке описаний подсистем:
				           |в описании очередной подсистемы (см. процедуру
				           |ПриДобавленииПодсистемы в общем модуле ""%1"")
				           |указано имя подсистемы ""%2"", которое уже зарегистрировано.'"),
				ИмяМодуля,
				Описание.Имя);
		КонецЕсли;
		
		Если Описание.Имя = Метаданные.Имя Тогда
			ОписаниеКонфигурацииНайдено = Истина;
			Описание.Вставить("ЭтоКонфигурация", Истина);
		Иначе
			Описание.Вставить("ЭтоКонфигурация", Ложь);
		КонецЕсли;
		
		Описание.Вставить("ОсновнойСерверныйМодуль", ИмяМодуля);
		
		ОписанияПодсистем.ПоИменам.Вставить(Описание.Имя, Описание);
		// Настройка порядка подсистем с учетом порядка добавления основных модулей.
		ОписанияПодсистем.Порядок.Добавить(Описание.Имя);
		// Сборка всех требуемых подсистем.
		Для каждого ТребуемаяПодсистема Из Описание.ТребуемыеПодсистемы Цикл
			Если ВсеТребуемыеПодсистемы.Получить(ТребуемаяПодсистема) = Неопределено Тогда
				ВсеТребуемыеПодсистемы.Вставить(ТребуемаяПодсистема, Новый Массив);
			КонецЕсли;
			ВсеТребуемыеПодсистемы[ТребуемаяПодсистема].Добавить(Описание.Имя);
		КонецЦикла;
	КонецЦикла;
	
	// Проверка описания основной конфигурации.
	Если ОписаниеКонфигурацииНайдено Тогда
		Описание = ОписанияПодсистем.ПоИменам[Метаданные.Имя];
		Если Описание.Версия <> Метаданные.Версия Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при подготовке описаний подсистем:
				           |для конфигурации ""%1""
				           |версия ""%2"" в описании (см. процедуру
				           |ПриДобавленииПодсистемы в общем модуле ""%3"")
				           |не совпадает с версией конфигурации в метаданных ""%4"".'"),
				Описание.Имя,
				Описание.Версия,
				Описание.ОсновнойСерверныйМодуль,
				Метаданные.Версия);
		КонецЕсли;
	Иначе
		Описание = НовоеОписаниеПодсистемы();
		Описание.Вставить("Имя",    Метаданные.Имя);
		Описание.Вставить("Версия", Метаданные.Версия);
		Описание.Вставить("ЭтоКонфигурация", Истина);
		ОписанияПодсистем.ПоИменам.Вставить(Описание.Имя, Описание);
		ОписанияПодсистем.Порядок.Добавить(Описание.Имя);
	КонецЕсли;
	
	// Проверка наличия всех требуемых подсистем.
	Для каждого КлючИЗначение Из ВсеТребуемыеПодсистемы Цикл
		Если ОписанияПодсистем.ПоИменам.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
			ЗависимыеПодсистемы = "";
			Для каждого ЗависимаяПодсистема Из КлючИЗначение.Значение Цикл
				ЗависимыеПодсистемы = Символы.ПС + ЗависимаяПодсистема;
			КонецЦикла;
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при подготовке описаний подсистем:
				           |не найдена подсистема ""%1"" требуемая для подсистем: %2.'"),
				КлючИЗначение.Ключ,
				ЗависимыеПодсистемы);
		КонецЕсли;
	КонецЦикла;
	
	// Настройка порядка подсистем с учетом зависимостей.
	Для каждого КлючИЗначение Из ОписанияПодсистем.ПоИменам Цикл
		Имя = КлючИЗначение.Ключ;
		Порядок = ОписанияПодсистем.Порядок.Найти(Имя);
		Для каждого ТребуемаяПодсистема Из КлючИЗначение.Значение.ТребуемыеПодсистемы Цикл
			ПорядокТребуемойПодсистемы = ОписанияПодсистем.Порядок.Найти(ТребуемаяПодсистема);
			Если Порядок < ПорядокТребуемойПодсистемы Тогда
				Взаимозависимость = ОписанияПодсистем.ПоИменам[ТребуемаяПодсистема
					].ТребуемыеПодсистемы.Найти(Имя) <> Неопределено;
				Если Взаимозависимость Тогда
					НовыйПорядок = ПорядокТребуемойПодсистемы;
				Иначе
					НовыйПорядок = ПорядокТребуемойПодсистемы + 1;
				КонецЕсли;
				Если Порядок <> НовыйПорядок Тогда
					ОписанияПодсистем.Порядок.Вставить(НовыйПорядок, Имя);
					ОписанияПодсистем.Порядок.Удалить(Порядок);
					Порядок = НовыйПорядок - 1;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	// Смещение описания конфигурации в конец массива.
	Индекс = ОписанияПодсистем.Порядок.Найти(Метаданные.Имя);
	Если ОписанияПодсистем.Порядок.Количество() > Индекс + 1 Тогда
		ОписанияПодсистем.Порядок.Удалить(Индекс);
		ОписанияПодсистем.Порядок.Добавить(Метаданные.Имя);
	КонецЕсли;
	
	Для каждого КлючИЗначение Из ОписанияПодсистем.ПоИменам Цикл
		
		КлючИЗначение.Значение.ТребуемыеПодсистемы =
			Новый ФиксированныйМассив(КлючИЗначение.Значение.ТребуемыеПодсистемы);
		
		ОписанияПодсистем.ПоИменам[КлючИЗначение.Ключ] =
			Новый ФиксированнаяСтруктура(КлючИЗначение.Значение);
	КонецЦикла;
	
	ОписанияПодсистем.Порядок  = Новый ФиксированныйМассив(ОписанияПодсистем.Порядок);
	ОписанияПодсистем.ПоИменам = Новый ФиксированноеСоответствие(ОписанияПодсистем.ПоИменам);
	
	Возврат Новый ФиксированнаяСтруктура(ОписанияПодсистем);
	
КонецФункции

// Возвращает массив описаний обработчиков серверного события.
Функция ОбработчикиСерверногоСобытия(Событие, Служебное = Ложь) Экспорт
	
	ПодготовленныеОбработчики = ПодготовленныеОбработчикиСерверногоСобытия(Событие, Служебное);
	
	Если ПодготовленныеОбработчики = Неопределено Тогда
		// Автообновление кэша. Обновление повторно используемых значений требуется.
		Константы.ПараметрыСлужебныхСобытий.СоздатьМенеджерЗначения().Обновить();
		ОбновитьПовторноИспользуемыеЗначения();
		// Повторная попытка получить обработчики события.
		ПодготовленныеОбработчики = ПодготовленныеОбработчикиСерверногоСобытия(Событие, Служебное, Ложь);
	КонецЕсли;
	
	Возврат ПодготовленныеОбработчики;
	
КонецФункции

// Возвращает соответствие имен подсистем и значения Истина;
Функция ИменаПодсистем() Экспорт
	
	Возврат Новый ФиксированноеСоответствие(ИменаПодчиненныхПодсистем(Метаданные));
	
КонецФункции

// Возвращает список объектов метаданных, которые используются в РИБ
// только в момент создания начального образа подчиненного узла.
// Список объектов получается для всех подсистем, для которых определено событие
// "СтандартныеПодсистемы.БазоваяФункциональность\ПриПолученииОбъектовНачальногоОбразаПланаОбмена"
//
//  Возвращаемое значение:
// Тип: ФиксированноеСоответствие. Ключ – объект метаданных; Значение – Истина.
//
Функция ОбъектыНачальногоОбраза() Экспорт
	
	Результат = Новый Соответствие;
	
	Объекты = Новый Массив;
	
	// Получаем объекты начального образа
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПолученииОбъектовНачальногоОбразаПланаОбмена"
	);
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		
		Обработчик.Модуль.ПриПолученииОбъектовНачальногоОбразаПланаОбмена(Объекты);
		
	КонецЦикла;
	
	Для Каждого Объект Из Объекты Цикл
		
		Результат.Вставить(Объект.ПолноеИмя(), Истина);
		
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

// Только для внутреннего использования.
Функция ИмяТекущегоПриложения() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НомерСеанса = НомерСеансаИнформационнойБазы();
	Сеансы = ПолучитьСеансыИнформационнойБазы();
	
	ИмяПриложения = "";
	
	Для каждого Сеанс Из Сеансы Цикл
		Если Сеанс.НомерСеанса = НомерСеанса Тогда
			ИмяПриложения = Сеанс.ИмяПриложения;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИмяПриложения;
	
КонецФункции

// Возвращает список планов обмена РИБ.
// Если конфигурация работает в модели сервиса,
// то возвращает список разделенных планов обмена РИБ.
//
Функция ПланыОбменаРИБ() Экспорт
	
	Результат = Новый Массив;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
			
			Если ПланОбмена.РаспределеннаяИнформационнаяБаза
				И ОбщегоНазначенияПовтИсп.ЭтоРазделенныйОбъектМетаданных(ПланОбмена.ПолноеИмя(),
					ОбщегоНазначенияПовтИсп.РазделительОсновныхДанных())
				Тогда
				
				Результат.Добавить(ПланОбмена.Имя);
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
			
			Если ПланОбмена.РаспределеннаяИнформационнаяБаза Тогда
				
				Результат.Добавить(ПланОбмена.Имя);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает соответствие имен предопределенных значений ссылкам на них.
//
// Параметры:
//  ПолноеИмяОбъектаМетаданных - Строка, например, "Справочник.ВидыНоменклатуры",
//                               Поддерживаются таблицы для которых доступен
//                               метод ПолучитьИмяПредопределенного:
//                               - Справочники,
//                               - Планы видов характеристик,
//                               - Планы счетов,
//                               - Планы видов расчета.
// 
// Возвращаемое значение:
//  Соответствие, где
//   Ключ     - Строка - имя предопределенного,
//   Значение - Ссылка предопределенного.
//
Функция СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТекущаяТаблица.Ссылка КАК Ссылка
	|ИЗ
	|	&ТекущаяТаблица КАК ТекущаяТаблица
	|ГДЕ
	|	ТекущаяТаблица.Предопределенный";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекущаяТаблица", ПолноеИмяОбъектаМетаданных);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	
	ПредопределенныеЗначения = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		ИмяПредопределенного = Менеджер.ПолучитьИмяПредопределенного(Выборка.Ссылка);
		ПредопределенныеЗначения.Вставить(ИмяПредопределенного, Выборка.Ссылка);
	КонецЦикла;
	
	Возврат ПредопределенныеЗначения;
	
КонецФункции

// Возвращает Истина, если привилегированный режим был установлен
// при запуске с помощью параметра UsePrivilegedMode.
//
// Поддерживается только при запуске клиентских приложений
// (внешнее соединение не поддерживается).
//
Функция ПривилегированныйРежимУстановленПриЗапуске() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить(
		"ПривилегированныйРежимУстановленПриЗапуске") = Истина;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Для обновления справочника ИдентификаторыОбъектовМетаданных

// Только для внутреннего использования.
Функция ТаблицаПереименованияДляТекущейВерсии() Экспорт
	
	Таблица = Справочники.ИдентификаторыОбъектовМетаданных.ТаблицаПереименованияДляТекущейВерсии(
		Справочники.ИдентификаторыОбъектовМетаданных.СвойстваКоллекцийОбъектовМетаданных());
	
	Возврат Таблица;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция НовоеОписаниеПодсистемы()
	
	Описание = Новый Структура;
	Описание.Вставить("Имя",    "");
	Описание.Вставить("Версия", "");
	Описание.Вставить("ТребуемыеПодсистемы", Новый Массив);
	
	// Свойство устанавливается автоматически.
	Описание.Вставить("ЭтоКонфигурация", Ложь);
	
	// Имя основного модуля библиотеки.
	// Может быть пустым для конфигурации.
	Описание.Вставить("ОсновнойСерверныйМодуль", "");
	
	//  <СВОЙСТВА ТОЛЬКО ДЛЯ БИБЛИОТЕКИ СТАНДАРТНЫХ ПОДСИСТЕМ>
	
	Описание.Вставить("ДобавлятьСобытия",            Ложь);
	Описание.Вставить("ДобавлятьОбработчикиСобытий", Ложь);
	
	//  ДобавлятьСлужебныеСобытия - Булево - если Истина, будет вызвана стандартная процедура
	//                         ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия)
	//                         из основного модуля библиотеки.
	// 
	//  ДобавлятьОбработчикиСлужебныхСобытий - Булево - если Истина, будет вызвана стандартная процедура
	//                         ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики)
	//                         из основного модуля библиотеки.
	
	Описание.Вставить("ДобавлятьСлужебныеСобытия",            Ложь);
	Описание.Вставить("ДобавлятьОбработчикиСлужебныхСобытий", Ложь);
	
	Возврат Описание;
	
КонецФункции

Функция ИменаПодчиненныхПодсистем(РодительскаяПодсистема)
	
	Имена = Новый Соответствие;
	
	Для каждого ТекущаяПодсистема Из РодительскаяПодсистема.Подсистемы Цикл
		
		Имена.Вставить(ТекущаяПодсистема.Имя, Истина);
		ИменаПодчиненных = ИменаПодчиненныхПодсистем(ТекущаяПодсистема);
		
		Для каждого ИмяПодчиненной Из ИменаПодчиненных Цикл
			Имена.Вставить(ТекущаяПодсистема.Имя + "." + ИмяПодчиненной.Ключ, Истина);
		КонецЦикла;
	КонецЦикла;
	
	Возврат Имена;
	
КонецФункции

Функция ПодготовленныеОбработчикиСерверногоСобытия(Событие, Служебное = Ложь, ПерваяПопытка = Истина)
	
	Параметры = СтандартныеПодсистемыПовтИсп.ПараметрыПрограммныхСобытий(
		).ОбработчикиСобытий.НаСервере;
	
	Если Служебное Тогда
		Обработчики = Параметры.ОбработчикиСлужебныхСобытий.Получить(Событие);
	Иначе
		Обработчики = Параметры.ОбработчикиСобытий.Получить(Событие);
	КонецЕсли;
	
	Если ПерваяПопытка И Обработчики = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Обработчики = Неопределено Тогда
		Если Служебное Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не найдено серверное служебное событие ""%1"".'"), Событие);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не найдено серверное событие ""%1"".'"), Событие);
		КонецЕсли;
	КонецЕсли;
	
	Массив = Новый Массив;
	
	Для каждого Обработчик Из Обработчики Цикл
		Элемент = Новый Структура;
		Модуль = Неопределено;
		Если ПерваяПопытка Тогда
			Попытка
				Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль(Обработчик.Модуль);
			Исключение
				Возврат Неопределено;
			КонецПопытки;
		Иначе
			Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль(Обработчик.Модуль);
		КонецЕсли;
		Элемент.Вставить("Модуль",     Обработчик.Модуль);
		Элемент.Вставить("Версия",     Обработчик.Версия);
		Элемент.Вставить("Подсистема", Обработчик.Подсистема);
		Массив.Добавить(Новый ФиксированнаяСтруктура(Элемент));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Массив);
	
КонецФункции
