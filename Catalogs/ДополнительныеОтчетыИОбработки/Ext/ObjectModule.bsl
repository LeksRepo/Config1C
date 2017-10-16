﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем УстанавливатьПривилегированныйРежим, ЭтоГлобальнаяОбработка;

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеОтчетыИОбработки.ПроверитьГлобальнаяОбработка(Вид) Тогда
		Если НЕ ИспользоватьДляФормыОбъекта И НЕ ИспользоватьДляФормыСписка 
			И Публикация <> Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Необходимо отключить публикацию или выбрать для использования как минимум одну из форм'")
				,
				,
				,
				"Объект.ИспользоватьДляФормыОбъекта",
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
	// Если отчет публикуется, то необходим контроль уникальности имени объекта, 
	//     под которым дополнительный отчет регистрируется в системе
	Если Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется Тогда
		
		// Проверка имени
		ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1
		|ИЗ
		|	Справочник.ДополнительныеОтчетыИОбработки КАК ДопОтчеты
		|ГДЕ
		|	ДопОтчеты.ИмяОбъекта = &ИмяОбъекта
		|	И &УсловиеДопОтчет
		|	И ДопОтчеты.Публикация = ЗНАЧЕНИЕ(Перечисление.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется)
		|	И ДопОтчеты.ПометкаУдаления = ЛОЖЬ
		|	И ДопОтчеты.Ссылка <> &Ссылка";
		
		ВидыДопОтчетов = Новый Массив;
		ВидыДопОтчетов.Добавить(Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет);
		ВидыДопОтчетов.Добавить(Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет);
		
		Если ВидыДопОтчетов.Найти(Вид) <> Неопределено Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеДопОтчет", "ДопОтчеты.Вид В (&ВидыДопОтчетов)");
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеДопОтчет", "НЕ ДопОтчеты.Вид В (&ВидыДопОтчетов)");
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ИмяОбъекта",     ИмяОбъекта);
		Запрос.УстановитьПараметр("ВидыДопОтчетов", ВидыДопОтчетов);
		Запрос.УстановитьПараметр("Ссылка",         Ссылка);
		Запрос.Текст = ТекстЗапроса;
		
		УстановитьПривилегированныйРежим(Истина);
		Конфликтующие = Запрос.Выполнить().Выгрузить();
		УстановитьПривилегированныйРежим(Ложь);
		
		Если Конфликтующие.Количество() > 0 Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Имя ""%1"", используемое данным отчетом (обработкой), уже занято другим опубликованным дополнительным отчетом (обработкой). 
					|
					|Для продолжения необходимо изменить вид Публикации с ""%2"" на ""%3"" или ""%4"".'"),
					ИмяОбъекта,
					Строка(Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется),
					Строка(Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.РежимОтладки),
					Строка(Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена)
				),
				,
				"Объект.Публикация");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	// Вызывается непосредственно до записи объекта в базу данных
	ДополнительныеОтчетыИОбработки.ПередЗаписьюДополнительнойОбработки(ЭтотОбъект, Отказ);
	
	Если ЭтоНовый() И НЕ ДополнительныеОтчетыИОбработки.ПравоДобавления(ЭтотОбъект) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для добавления дополнительных отчетов или обработок.'");
	КонецЕсли;
	
	// Предварительные проверки
	Если НЕ ЭтоНовый() И Вид <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Вид") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Невозможно сменить вид существующего дополнительного отчета или обработки.'"),,,,
			Отказ);
		Возврат;
	КонецЕсли;
	
	// Связь реквизитов с пометкой удаления
	Если ПометкаУдаления Тогда
		Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена;
	КонецЕсли;
	
	// Кэш стандартных проверок
	ДополнительныеСвойства.Вставить("ПубликацияИспользуется", Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется);
	
	Если ЭтоГлобальнаяОбработка() Тогда
		Если ПравоНастройкиРасписания() Тогда
			ПередЗаписьюГлобальнойОбработки(Отказ);
		КонецЕсли;
		Назначение.Очистить();
	Иначе
		ПередЗаписьюНазначаемойОбработки(Отказ);
		Разделы.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	// Вызывается непосредственно после записи объекта в базу данных
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	БыстрыйДоступ = Неопределено;
	Если ДополнительныеСвойства.Свойство("БыстрыйДоступ", БыстрыйДоступ) Тогда
		РегистрыСведений.ПользовательскиеНастройкиДоступаКОбработкам.ОбновитьДанныеПриЗаписиДополнительногоОбъекта(Ссылка, БыстрыйДоступ);
	КонецЕсли;
	
	Если ЭтоГлобальнаяОбработка() Тогда
		Если ПравоНастройкиРасписания() Тогда
			ПриЗаписиГлобальнойОбработки(Отказ);
		КонецЕсли;
	Иначе
		ПриЗаписиНазначаемойОбработки(Отказ);
	КонецЕсли;
	
	Если Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		ПриЗаписиГлобальногоОтчета(Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	// Вызывается непосредственно перед удалением объекта из базы данных
	ДополнительныеОтчетыИОбработки.ПередУдалениемДополнительнойОбработки(ЭтотОбъект, Отказ);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеОтчетыИОбработки.ПроверитьГлобальнаяОбработка(Вид) Тогда
		ПередУдалениемГлобальнойОбработки(Отказ);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоГлобальнаяОбработка()
	
	Если ЭтоГлобальнаяОбработка = Неопределено Тогда
		ЭтоГлобальнаяОбработка = ДополнительныеОтчетыИОбработки.ПроверитьГлобальнаяОбработка(Вид);
	КонецЕсли;
	
	Возврат ЭтоГлобальнаяОбработка;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Глобальные обработки

Процедура ПередЗаписьюГлобальнойОбработки(Отказ)
	Если Отказ ИЛИ НЕ ДополнительныеСвойства.Свойство("АктуальныеКоманды") Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаКоманд = ДополнительныеСвойства.АктуальныеКоманды;
	
	ЗаданияДляОбновления = Новый Соответствие;
	
	ПубликацияВключена = (Публикация <> Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена);
	
	// Регламентные задание необходимо изменять в неразделенном режиме.
	Если УстанавливатьПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	// Очистка заданий по командам, которые были удалены из таблицы.
	Если НЕ ЭтоНовый() Тогда
		Для Каждого СтараяКоманда Из Ссылка.Команды Цикл
			Если ЗначениеЗаполнено(СтараяКоманда.РегламентноеЗаданиеGUID)
				И ТаблицаКоманд.Найти(СтараяКоманда.РегламентноеЗаданиеGUID, "РегламентноеЗаданиеGUID") = Неопределено Тогда
				
				Задание = ДополнительныеОтчетыИОбработкиРегламентныеЗадания.НайтиЗадание(СтараяКоманда.РегламентноеЗаданиеGUID);
				Если Задание <> Неопределено Тогда
					ДополнительныеОтчетыИОбработкиРегламентныеЗадания.УдалитьЗадание(Задание);
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Актуализация набора регламентных заданий для записи их идентификаторов в табличную часть.
	Для Каждого АктуальнаяКоманда Из ТаблицаКоманд Цикл
		
		Команда = Команды.Найти(АктуальнаяКоманда.Идентификатор, "Идентификатор");
		
		Если ПубликацияВключена И АктуальнаяКоманда.РегламентноеЗаданиеРасписание.Количество() > 0 Тогда
			Расписание    = АктуальнаяКоманда.РегламентноеЗаданиеРасписание[0].Значение;
			Использование = АктуальнаяКоманда.РегламентноеЗаданиеИспользование И РасписаниеЗадано(Расписание);
		Иначе
			Расписание = Неопределено;
			Использование = Ложь;
		КонецЕсли;
		
		Задание = ДополнительныеОтчетыИОбработкиРегламентныеЗадания.НайтиЗадание(АктуальнаяКоманда.РегламентноеЗаданиеGUID);
		
		Если Задание = Неопределено Тогда // Не найдено
			
			Если Использование Тогда
				
				Задание = ДополнительныеОтчетыИОбработкиРегламентныеЗадания.СоздатьНовоеЗадание(
					ПредставлениеЗадания(АктуальнаяКоманда));
				
				ЗаданияДляОбновления.Вставить(АктуальнаяКоманда, Задание);
				
				// Создать и зарегистрировать
				Команда.РегламентноеЗаданиеGUID = 
					ДополнительныеОтчетыИОбработкиРегламентныеЗадания.ПолучитьИдентификаторЗадания(
						Задание);
				
			Иначе
				// Действие не требуется
			КонецЕсли;
			
		Иначе // Найдено
			
			Если Использование Тогда
				// Зарегистрировать
				ЗаданияДляОбновления.Вставить(АктуальнаяКоманда, Задание);
			Иначе
				// Удалить
				ДополнительныеОтчетыИОбработкиРегламентныеЗадания.УдалитьЗадание(Задание);
				Команда.РегламентноеЗаданиеGUID = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("ЗаданияДляОбновления", ЗаданияДляОбновления);
	
	Если УстанавливатьПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписиГлобальнойОбработки(Отказ)
	
	Если Отказ ИЛИ НЕ ДополнительныеСвойства.Свойство("АктуальныеКоманды") Тогда
		Возврат;
	КонецЕсли;
	
	ПубликацияВключена = (Публикация <> Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена);
	
	// Регламентные задание необходимо изменять в неразделенном режиме.
	Если УстанавливатьПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из ДополнительныеСвойства.ЗаданияДляОбновления Цикл
		
		Команда = КлючИЗначение.Ключ;
		Задание = КлючИЗначение.Значение;
		
		Если ПубликацияВключена И Команда.РегламентноеЗаданиеРасписание.Количество() > 0 Тогда
			Расписание    = Команда.РегламентноеЗаданиеРасписание[0].Значение;
			Использование = Команда.РегламентноеЗаданиеИспользование И РасписаниеЗадано(Расписание);
		Иначе
			Расписание    = Неопределено;
			Использование = Ложь;
		КонецЕсли;
		
		ПараметрыЗадания = Новый Массив;
		ПараметрыЗадания.Добавить(Ссылка);
		ПараметрыЗадания.Добавить(Команда.Идентификатор);
		
		ДополнительныеОтчетыИОбработкиРегламентныеЗадания.УстановитьПараметрыЗадания(
			Задание,
			Использование,
			Лев(ПредставлениеЗадания(Команда), 120),
			ПараметрыЗадания,
			Расписание);
		
	КонецЦикла;
	
	Если УстанавливатьПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалениемГлобальнойОбработки(Отказ)
	// Регламентные задание необходимо изменять в неразделенном режиме.
	Если УстанавливатьПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Для Каждого Команда Из Команды Цикл
		
		Задание = ДополнительныеОтчетыИОбработкиРегламентныеЗадания.НайтиЗадание(
			Команда.РегламентноеЗаданиеGUID);
			
		Если Задание <> Неопределено Тогда
			ДополнительныеОтчетыИОбработкиРегламентныеЗадания.УдалитьЗадание(Задание);
		КонецЕсли;
	КонецЦикла;
	
	Если УстанавливатьПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с регламентными заданиями

Функция ПравоНастройкиРасписания()
	// Проверяет наличие права настройки расписания дополнительных отчетов и обработок.
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеДополнительныхОтчетовИОбработок");
КонецФункции

Функция ПредставлениеЗадания(Команда)
	// '%1: %2 / Команда: %3'
	Возврат (
		СокрЛП(Вид)
		+ ": "
		+ СокрЛП(Наименование)
		+ " / "
		+ НСтр("ru = 'Команда'")
		+ ": "
		+ СокрЛП(Команда.Представление));
КонецФункции

Функция РасписаниеЗадано(Расписание)
	
	Возврат Строка(Расписание) <> Строка(Новый РасписаниеРегламентногоЗадания);
	
КонецФункции

Функция УстанавливатьПривилегированныйРежим()
	
	Если УстанавливатьПривилегированныйРежим = Неопределено Тогда
		УстанавливатьПривилегированныйРежим = Ложь;
		Если РольДоступна(Метаданные.Роли.ДобавлениеИзменениеДополнительныхОтчетовИОбработок)
			И Не ПравоДоступа("Администрирование", Метаданные) Тогда
			УстанавливатьПривилегированныйРежим = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат УстанавливатьПривилегированныйРежим;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Назначаемые обработки

Процедура ПередЗаписьюНазначаемойОбработки(Отказ)
	ТаблицаНазначение = Назначение.Выгрузить();
	ТаблицаНазначение.Свернуть("ОбъектНазначения");
	Назначение.Загрузить(ТаблицаНазначение);
	
	ОбновлениеРегистраНазначение = Новый Структура("МассивСсылок");
	
	СсылкиОбъектовМетаданных = ТаблицаНазначение.ВыгрузитьКолонку("ОбъектНазначения");
	
	Если НЕ ЭтоНовый() Тогда
		Для Каждого СтрокаТаблицы Из Ссылка.Назначение Цикл
			Если СсылкиОбъектовМетаданных.Найти(СтрокаТаблицы.ОбъектНазначения) = Неопределено Тогда
				СсылкиОбъектовМетаданных.Добавить(СтрокаТаблицы.ОбъектНазначения);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("СсылкиОбъектовМетаданных", СсылкиОбъектовМетаданных);
КонецПроцедуры

Процедура ПриЗаписиНазначаемойОбработки(Отказ)
	Если Отказ ИЛИ НЕ ДополнительныеСвойства.Свойство("СсылкиОбъектовМетаданных") Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.НазначениеДополнительныхОбработок.ОбновитьДанныеПоСсылкамОбъектовМетаданных(ДополнительныеСвойства.СсылкиОбъектовМетаданных);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Глобальные отчеты

Процедура ПриЗаписиГлобальногоОтчета(Отказ)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		
		Попытка
			Если ЭтоНовый() Тогда
				ВнешнийОбъект = ВнешниеОтчеты.Создать(ИмяОбъекта);
			Иначе
				ВнешнийОбъект = ДополнительныеОтчетыИОбработки.ПолучитьОбъектВнешнейОбработки(Ссылка);
			КонецЕсли;
		Исключение
			ТекстОшибки = НСтр("ru = 'Ошибка подключения:'") + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ДополнительныеОтчетыИОбработки.ЗаписатьОшибку(Ссылка, ТекстОшибки);
			ДополнительныеСвойства.Вставить("ОшибкаПодключения", ТекстОшибки);
			Возврат;
		КонецПопытки;
		
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
		МодульВариантыОтчетов.ПриЗаписиДополнительногоОтчета(ЭтотОбъект, Отказ, ВнешнийОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
