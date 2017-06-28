﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Регламентные задания".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса\ПриЗаполненииТаблицыПараметровИБ"].Добавить(
			"РегламентныеЗаданияСлужебный");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Вызывает исключение, если у пользователя нет права администрирования.
Процедура ВызватьИсключениеЕслиНетПраваАдминистрирования() Экспорт
	
	Если НЕ ПривилегированныйРежим() Тогда
		ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Формирует список параметров ИБ.
//
// Параметры:
// ТаблицаПараметров - ТаблицаЗначений - таблица описания параметров.
// Описание состав колонок - см. РаботаВМоделиСервиса.ПолучитьТаблицуПараметровИБ()
//
Процедура ПриЗаполненииТаблицыПараметровИБ(Знач ТаблицаПараметров) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		МодульРаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "МаксимальнаяДлительностьВыполненияИсполняющегоФоновогоЗадания");
		МодульРаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "МаксимальноеКоличествоИсполняющихФоновыхЗаданий");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы с регламентными заданиями

// Предназначена для "ручного" немедленного выполнения процедуры регламентного задания
// либо в сеансе клиента (в файловой ИБ), либо в фоновом задании на сервере (в серверной ИБ)
// Применяется в любом режиме соединения
// "Ручной" режим запуска не влияет на выполнение регламентного задания по аварийному
// и основному расписаниям, т.к. не указывается ссылка на регламентное задание у фонового задания
// Тип ФоновоеЗадание не допускает установки такой ссылки, поэтому для файлового режима применяется
// тоже правило
// 
// Параметры:
//  Задание       -   РегламентноеЗадание, Строка - уникального идентификатора РегламентногоЗадания
//  МоментЗапуска -   Неопределено, Дата
//                    Для файловой ИБ устанавливает переданный момент, как момент запуска
//                    метода регламентного задания
//                    Для серверной ИБ - возвращает момент запуска фонового задания по факту
//  ИдентификаторФоновогоЗадания - Строка
//                    Для серверной ИБ возвращает идентификатор запущенного фонового задания
//  МоментОкончания - Неопределено, Дата
//                    Для файловой ИБ возвращает момент завершения метода регламентного задания
//
Функция ВыполнитьРегламентноеЗаданиеВручную(Знач Задание,
                                            МоментЗапуска = Неопределено,
                                            ИдентификаторФоновогоЗадания = "",
                                            МоментОкончания = Неопределено,
                                            НомерСеанса = Неопределено,
                                            НачалоСеанса = Неопределено,
                                            ПредставлениеФоновогоЗадания = "",
                                            ПроцедураУжеВыполняется = Неопределено) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	ПроцедураУжеВыполняется = Ложь;
	Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(Задание);
	
	Запуск = Ложь;
	СвойстваПоследнегоФоновогоЗадания = ПолучитьСвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(Задание);
	
	Если СвойстваПоследнегоФоновогоЗадания <> Неопределено
	   И СвойстваПоследнегоФоновогоЗадания.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		
		МоментЗапуска  = СвойстваПоследнегоФоновогоЗадания.Начало;
		Если ЗначениеЗаполнено(СвойстваПоследнегоФоновогоЗадания.Наименование) Тогда
			ПредставлениеФоновогоЗадания = СвойстваПоследнегоФоновогоЗадания.Наименование;
		Иначе
			ПредставлениеФоновогоЗадания = ПредставлениеРегламентногоЗадания(Задание);
		КонецЕсли;
	Иначе
		НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Запуск вручную: %1'"), ПредставлениеРегламентногоЗадания(Задание));
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(Задание.Метаданные.ИмяМетода, Задание.Параметры, Строка(Задание.УникальныйИдентификатор), НаименованиеФоновогоЗадания);
		ИдентификаторФоновогоЗадания = Строка(ФоновоеЗадание.УникальныйИдентификатор);
		МоментЗапуска = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ФоновоеЗадание.УникальныйИдентификатор).Начало;
		Запуск = Истина;
	КонецЕсли;
	
	ПроцедураУжеВыполняется = НЕ Запуск;
	
	Возврат Запуск;
	
КонецФункции

// Возвращает представление регламентного задания,
// это по порядку исключения незаполненных реквизитов:
// Наименование, Метаданные.Синоним, Метаданные.Имя.
//
// Параметры:
//  Задание      - РегламентноеЗадание, Строка - если строка, тогда УникальныйИдентификатор строкой.
//
// Возвращаемое значение:
//  Строка.
//
Функция ПредставлениеРегламентногоЗадания(Знач Задание) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Задание) = Тип("РегламентноеЗадание") Тогда
		РегламентноеЗадание = Задание;
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(Задание));
	КонецЕсли;
	
	Если РегламентноеЗадание <> Неопределено Тогда
		Представление = РегламентноеЗадание.Наименование;
		
		Если ПустаяСтрока(РегламентноеЗадание.Наименование) Тогда
			Представление = РегламентноеЗадание.Метаданные.Синоним;
			
			Если ПустаяСтрока(Представление) Тогда
				Представление = РегламентноеЗадание.Метаданные.Имя;
			КонецЕсли
		КонецЕсли;
	Иначе
		Представление = ТекстНеОпределено();
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

// Возвращает текст "<не определено>".
Функция ТекстНеОпределено() Экспорт
	
	Возврат НСтр("ru = '<не определено>'");
	
КонецФункции

// Возвращает многострочную Строку содержащую Сообщения и ОписаниеИнформацииОбОшибке,
// последнее фоновое задание найдено по идентификатору регламентного задания
// и сообщения/ошибки есть.
//
// Параметры:
//  Задание      - РегламентноеЗадание, Строка - УникальныйИдентификатор
//                 РегламентногоЗадания строкой.
//
// Возвращаемое значение:
//  Строка.
//
Функция СообщенияИОписанияОшибокРегламентногоЗадания(Знач Задание) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);

	ИдентификаторРегламентногоЗадания = ?(ТипЗнч(Задание) = Тип("РегламентноеЗадание"), Строка(Задание.УникальныйИдентификатор), Задание);
	СвойстваПоследнегоФоновогоЗадания = ПолучитьСвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(ИдентификаторРегламентногоЗадания);
	Возврат ?(СвойстваПоследнегоФоновогоЗадания = Неопределено,
	          "",
	          СообщенияИОписанияОшибокФоновогоЗадания(СвойстваПоследнегоФоновогоЗадания.Идентификатор) );
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы с фоновыми заданиями

// Отменяет фоновое задание, если это возможно, а именно, если оно выполняется на сервере, и активно.
//
// Параметры:
//  Идентификатор  - Строка уникального идентификатора ФоновогоЗадания.
// 
Процедура ОтменитьФоновоеЗадание(Идентификатор) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Отбор = Новый Структура("УникальныйИдентификатор", Новый УникальныйИдентификатор(Идентификатор));
	МассивФоновыхЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если МассивФоновыхЗаданий.Количество() = 1 Тогда
		ФоновоеЗадание = МассивФоновыхЗаданий[0];
	Иначе
		ВызватьИсключение НСтр("ru = 'Фоновое задание не найдено на сервере.'");
	КонецЕсли;
	
	Если ФоновоеЗадание.Состояние <> СостояниеФоновогоЗадания.Активно Тогда
		ВызватьИсключение НСтр("ru = 'Задание не выполняется, его нельзя отменить.'");
	КонецЕсли;
	
	ФоновоеЗадание.Отменить();
	
КонецПроцедуры

// Возвращает таблицу свойств фоновых заданий.
//  Структуру таблицы смотри в функции ПустаяТаблицаСвойствФоновыхЗаданий().
// 
// Параметры:
//  Отбор        - Структура - допустимые поля:
//                 Идентификатор, Ключ, Состояние, Начало, Конец,
//                 Наименование, ИмяМетода, РегламентноеЗадание. 
//
// Возвращаемое значение:
//  ТаблицаЗначений  - возвращается таблица после отбора.
//
Функция ПолучитьТаблицуСвойствФоновыхЗаданий(Отбор = Неопределено) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Таблица = ПустаяТаблицаСвойствФоновыхЗаданий();
	
	Если ЗначениеЗаполнено(Отбор) И Отбор.Свойство("ПолучитьПоследнееФоновоеЗаданиеРегламентногоЗадания") Тогда
		Отбор.Удалить("ПолучитьПоследнееФоновоеЗаданиеРегламентногоЗадания");
		ПолучитьПоследнее = Истина;
	Иначе
		ПолучитьПоследнее = Ложь;
	КонецЕсли;
	
	РегламентноеЗадание = Неопределено;
	
	// Добавление истории фоновых заданий, полученных с сервера.
	Если ЗначениеЗаполнено(Отбор) И Отбор.Свойство("ИдентификаторРегламентногоЗадания") Тогда
		Если Отбор.ИдентификаторРегламентногоЗадания <> "" Тогда
			РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(
				Новый УникальныйИдентификатор(Отбор.ИдентификаторРегламентногоЗадания));
			ТекущийОтбор = Новый Структура("Ключ", Отбор.ИдентификаторРегламентногоЗадания);
			ФоновыеЗаданияЗапущенныеВручную = ФоновыеЗадания.ПолучитьФоновыеЗадания(ТекущийОтбор);
			Если РегламентноеЗадание <> Неопределено Тогда
				ПоследнееФоновоеЗадание = РегламентноеЗадание.ПоследнееЗадание;
			КонецЕсли;
			Если НЕ ПолучитьПоследнее ИЛИ ПоследнееФоновоеЗадание = Неопределено Тогда
				ТекущийОтбор = Новый Структура("РегламентноеЗадание", РегламентноеЗадание);
				АвтоматическиеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(ТекущийОтбор);
			КонецЕсли;
			Если ПолучитьПоследнее Тогда
				Если ПоследнееФоновоеЗадание = Неопределено Тогда
					ПоследнееФоновоеЗадание = ПоследнееФоновоеЗаданиеВМассиве(АвтоматическиеФоновыеЗадания);
				КонецЕсли;
				
				ПоследнееФоновоеЗадание = ПоследнееФоновоеЗаданиеВМассиве(
					ФоновыеЗаданияЗапущенныеВручную, ПоследнееФоновоеЗадание);
				
				Если ПоследнееФоновоеЗадание <> Неопределено Тогда
					МассивФоновыхЗаданий = Новый Массив;
					МассивФоновыхЗаданий.Добавить(ПоследнееФоновоеЗадание);
					ДобавитьСвойстваФоновыхЗаданий(МассивФоновыхЗаданий, Таблица);
				КонецЕсли;
				Возврат Таблица;
			КонецЕсли;
			ДобавитьСвойстваФоновыхЗаданий(ФоновыеЗаданияЗапущенныеВручную, Таблица);
			ДобавитьСвойстваФоновыхЗаданий(АвтоматическиеФоновыеЗадания, Таблица);
		Иначе
			МассивФоновыхЗаданий = Новый Массив;
			ВсеИдентификаторыРегламентныхЗаданий = Новый Соответствие;
			Для каждого ТекущееЗадание Из РегламентныеЗадания.ПолучитьРегламентныеЗадания() Цикл
				ВсеИдентификаторыРегламентныхЗаданий.Вставить(
					Строка(ТекущееЗадание.УникальныйИдентификатор), Истина);
			КонецЦикла;
			ВсеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания();
			Для каждого ТекущееЗадание Из ВсеФоновыеЗадания Цикл
				Если ТекущееЗадание.РегламентноеЗадание = Неопределено
				   И ВсеИдентификаторыРегламентныхЗаданий[ТекущееЗадание.Ключ] = Неопределено Тогда
				
					МассивФоновыхЗаданий.Добавить(ТекущееЗадание);
				КонецЕсли;
			КонецЦикла;
			ДобавитьСвойстваФоновыхЗаданий(МассивФоновыхЗаданий, Таблица);
		КонецЕсли;
	Иначе
		Если НЕ ЗначениеЗаполнено(Отбор) Тогда
			МассивФоновыхЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания();
		Иначе
			Если Отбор.Свойство("Идентификатор") Тогда
				Отбор.Вставить("УникальныйИдентификатор", Новый УникальныйИдентификатор(Отбор.Идентификатор));
				Отбор.Удалить("Идентификатор");
			КонецЕсли;
			МассивФоновыхЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
			Если Отбор.Свойство("УникальныйИдентификатор") Тогда
				Отбор.Вставить("Идентификатор", Строка(Отбор.УникальныйИдентификатор));
				Отбор.Удалить("УникальныйИдентификатор");
			КонецЕсли;
		КонецЕсли;
		ДобавитьСвойстваФоновыхЗаданий(МассивФоновыхЗаданий, Таблица);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отбор) И Отбор.Свойство("ИдентификаторРегламентногоЗадания") Тогда
		РегламентныеЗаданияДляОбработки = Новый Массив;
		Если Отбор.ИдентификаторРегламентногоЗадания <> "" Тогда
			Если РегламентноеЗадание = Неопределено Тогда
				РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(
					Новый УникальныйИдентификатор(Отбор.ИдентификаторРегламентногоЗадания));
			КонецЕсли;
			Если РегламентноеЗадание <> Неопределено Тогда
				РегламентныеЗаданияДляОбработки.Добавить(РегламентноеЗадание);
			КонецЕсли;
		КонецЕсли;
	Иначе
		РегламентныеЗаданияДляОбработки = РегламентныеЗадания.ПолучитьРегламентныеЗадания();
	КонецЕсли;
	
	Таблица.Сортировать("Начало Убыв, Конец Убыв");
	
	// Отбор фоновых заданий.
	Если ЗначениеЗаполнено(Отбор) Тогда
		Начало    = Неопределено;
		Конец     = Неопределено;
		Состояние = Неопределено;
		Если Отбор.Свойство("Начало") Тогда
			Начало = ?(ЗначениеЗаполнено(Отбор.Начало), Отбор.Начало, Неопределено);
			Отбор.Удалить("Начало");
		КонецЕсли;
		Если Отбор.Свойство("Конец") Тогда
			Конец = ?(ЗначениеЗаполнено(Отбор.Конец), Отбор.Конец, Неопределено);
			Отбор.Удалить("Конец");
		КонецЕсли;
		Если Отбор.Свойство("Состояние") Тогда
			Если ТипЗнч(Отбор.Состояние) = Тип("Массив") Тогда
				Состояние = Отбор.Состояние;
				Отбор.Удалить("Состояние");
			КонецЕсли;
		КонецЕсли;
		
		Если Отбор.Количество() <> 0 Тогда
			Строки = Таблица.НайтиСтроки(Отбор);
		Иначе
			Строки = Таблица;
		КонецЕсли;
		// Выполнение дополнительного отбора по периоду и состоянию (если отбор определен).
		НомерЭлемента = Строки.Количество() - 1;
		Пока НомерЭлемента >= 0 Цикл
			Если Начало    <> Неопределено И Начало > Строки[НомерЭлемента].Начало ИЛИ
				 Конец     <> Неопределено И Конец  < ?(ЗначениеЗаполнено(Строки[НомерЭлемента].Конец), Строки[НомерЭлемента].Конец, ТекущаяДатаСеанса()) ИЛИ
				 Состояние <> Неопределено И Состояние.Найти(Строки[НомерЭлемента].Состояние) = Неопределено Тогда
				Строки.Удалить(НомерЭлемента);
			КонецЕсли;
			НомерЭлемента = НомерЭлемента - 1;
		КонецЦикла;
		// Удаление лишних строк из таблицы.
		Если ТипЗнч(Строки) = Тип("Массив") Тогда
			НомерСтроки = Таблица.Количество() - 1;
			Пока НомерСтроки >= 0 Цикл
				Если Строки.Найти(Таблица[НомерСтроки]) = Неопределено Тогда
					Таблица.Удалить(Таблица[НомерСтроки]);
				КонецЕсли;
				НомерСтроки = НомерСтроки - 1;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Таблица;
	
КонецФункции

// Возвращает свойства ФоновогоЗадания по строке уникального идентификатора.
//
// Параметры:
//  Идентификатор - Строка - уникального идентификатора ФоновогоЗадания.
//  ИменаСвойств  - Строка, если заполнено, возвращается структура с указанными свойствами.
// 
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Структура - свойства ФоновогоЗадания.
//
Функция ПолучитьСвойстваФоновогоЗадания(Идентификатор, ИменаСвойств = "") Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Отбор = Новый Структура("Идентификатор", Идентификатор);
	ТаблицаСвойствФоновыхЗаданий = ПолучитьТаблицуСвойствФоновыхЗаданий(Отбор);
	
	Если ТаблицаСвойствФоновыхЗаданий.Количество() > 0 Тогда
		Если ЗначениеЗаполнено(ИменаСвойств) Тогда
			Результат = Новый Структура(ИменаСвойств);
			ЗаполнитьЗначенияСвойств(Результат, ТаблицаСвойствФоновыхЗаданий[0]);
		Иначе
			Результат = ТаблицаСвойствФоновыхЗаданий[0];
		КонецЕсли;
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает свойства последнего фонового задания выполненного при выполнении регламентного задания, если оно есть.
// Процедура работает, как в файл-серверном, так и в клиент-серверном режимах.
//
// Параметры:
//  РегламентноеЗадание - РегламентноеЗадание, Строка - строка уникального идентификатора РегламентногоЗадания.
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено.
//
Функция ПолучитьСвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(РегламентноеЗадание) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторРегламентногоЗадания = ?(ТипЗнч(РегламентноеЗадание) = Тип("РегламентноеЗадание"), Строка(РегламентноеЗадание.УникальныйИдентификатор), РегламентноеЗадание);
	Отбор = Новый Структура;
	Отбор.Вставить("ИдентификаторРегламентногоЗадания", ИдентификаторРегламентногоЗадания);
	Отбор.Вставить("ПолучитьПоследнееФоновоеЗаданиеРегламентногоЗадания");
	ТаблицаСвойствФоновыхЗаданий = ПолучитьТаблицуСвойствФоновыхЗаданий(Отбор);
	ТаблицаСвойствФоновыхЗаданий.Сортировать("Конец Возр");
	
	Если ТаблицаСвойствФоновыхЗаданий.Количество() = 0 Тогда
		СвойстваФоновогоЗадания = Неопределено;
	ИначеЕсли НЕ ЗначениеЗаполнено(ТаблицаСвойствФоновыхЗаданий[0].Конец) Тогда
		СвойстваФоновогоЗадания = ТаблицаСвойствФоновыхЗаданий[0];
	Иначе
		СвойстваФоновогоЗадания = ТаблицаСвойствФоновыхЗаданий[ТаблицаСвойствФоновыхЗаданий.Количество()-1];
	КонецЕсли;
	
	Возврат СвойстваФоновогоЗадания;
	
КонецФункции

// Возвращает многострочную Строку содержащую Сообщения и ОписаниеИнформацииОбОшибке,
// если фоновое задание найдено по идентификатору и сообщения/ошибки есть.
//
// Параметры:
//  Задание      - Строка - УникальныйИдентификатор ФоновогоЗадания строкой.
//
// Возвращаемое значение:
//  Строка.
//
Функция СообщенияИОписанияОшибокФоновогоЗадания(Идентификатор, СвойстваФоновогоЗадания = Неопределено) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Если СвойстваФоновогоЗадания = Неопределено Тогда
		СвойстваФоновогоЗадания = ПолучитьСвойстваФоновогоЗадания(Идентификатор);
	КонецЕсли;
	
	Строка = "";
	Если СвойстваФоновогоЗадания <> Неопределено Тогда
		Для каждого Сообщение Из СвойстваФоновогоЗадания.СообщенияПользователю Цикл
			Строка = Строка + ?(Строка = "",
			                    "",
			                    "
			                    |
			                    |") + Сообщение.Текст;
		КонецЦикла;
		Если ЗначениеЗаполнено(СвойстваФоновогоЗадания.ОписаниеИнформацииОбОшибке) Тогда
			Строка = Строка + ?(Строка = "",
			                    СвойстваФоновогоЗадания.ОписаниеИнформацииОбОшибке,
			                    "
			                    |
			                    |" + СвойстваФоновогоЗадания.ОписаниеИнформацииОбОшибке);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Строка;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

// Возвращает новую таблицу свойств фоновых заданий.
//
// Возвращаемое значение:
//  ТаблицаЗначений.
//
Функция ПустаяТаблицаСвойствФоновыхЗаданий()
	
	НоваяТаблица = Новый ТаблицаЗначений;
	НоваяТаблица.Колонки.Добавить("Идентификатор",                     Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Наименование",                      Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Ключ",                              Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Начало",                            Новый ОписаниеТипов("Дата"));
	НоваяТаблица.Колонки.Добавить("Конец",                             Новый ОписаниеТипов("Дата"));
	НоваяТаблица.Колонки.Добавить("ИдентификаторРегламентногоЗадания", Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Состояние",                         Новый ОписаниеТипов("СостояниеФоновогоЗадания"));
	НоваяТаблица.Колонки.Добавить("ИмяМетода",                         Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Расположение",                      Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("ОписаниеИнформацииОбОшибке",        Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("ПопыткаЗапуска",                    Новый ОписаниеТипов("Число"));
	НоваяТаблица.Колонки.Добавить("СообщенияПользователю",             Новый ОписаниеТипов("Массив"));
	НоваяТаблица.Колонки.Добавить("НомерСеанса",                       Новый ОписаниеТипов("Число"));
	НоваяТаблица.Колонки.Добавить("НачалоСеанса",                      Новый ОписаниеТипов("Дата"));
	НоваяТаблица.Индексы.Добавить("Идентификатор, Начало");
	
	Возврат НоваяТаблица;
	
КонецФункции

Процедура ДобавитьСвойстваФоновыхЗаданий(Знач МассивФоновыхЗаданий, Знач ТаблицаСвойствФоновыхЗаданий)
	
	Индекс = МассивФоновыхЗаданий.Количество() - 1;
	Пока Индекс >= 0 Цикл
		ФоновоеЗадание = МассивФоновыхЗаданий[Индекс];
		Строка = ТаблицаСвойствФоновыхЗаданий.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, ФоновоеЗадание);
		Строка.Идентификатор = ФоновоеЗадание.УникальныйИдентификатор;
		РегламентноеЗадание = ФоновоеЗадание.РегламентноеЗадание;
		
		Если РегламентноеЗадание = Неопределено
		   И СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(ФоновоеЗадание.Ключ) Тогда
			
			РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ФоновоеЗадание.Ключ));
		КонецЕсли;
		Строка.ИдентификаторРегламентногоЗадания = ?(
			РегламентноеЗадание = Неопределено,
			"",
			РегламентноеЗадание.УникальныйИдентификатор);
		
		Строка.ОписаниеИнформацииОбОшибке = ?(
			ФоновоеЗадание.ИнформацияОбОшибке = Неопределено,
			"",
			ПодробноеПредставлениеОшибки(ФоновоеЗадание.ИнформацияОбОшибке));
		
		Индекс = Индекс - 1;
	КонецЦикла;
	
КонецПроцедуры

Функция ПоследнееФоновоеЗаданиеВМассиве(МассивФоновыхЗаданий, ПоследнееФоновоеЗадание = Неопределено)
	
	Для каждого ТекущееФоновоеЗадание Из МассивФоновыхЗаданий Цикл
		Если ПоследнееФоновоеЗадание = Неопределено Тогда
			ПоследнееФоновоеЗадание = ТекущееФоновоеЗадание;
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(ПоследнееФоновоеЗадание.Конец) Тогда
			Если НЕ ЗначениеЗаполнено(ТекущееФоновоеЗадание.Конец)
			 ИЛИ ПоследнееФоновоеЗадание.Конец < ТекущееФоновоеЗадание.Конец Тогда
				ПоследнееФоновоеЗадание = ТекущееФоновоеЗадание;
			КонецЕсли;
		Иначе
			Если НЕ ЗначениеЗаполнено(ТекущееФоновоеЗадание.Конец)
			   И ПоследнееФоновоеЗадание.Начало < ТекущееФоновоеЗадание.Начало Тогда
				ПоследнееФоновоеЗадание = ТекущееФоновоеЗадание;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПоследнееФоновоеЗадание;
	
КонецФункции