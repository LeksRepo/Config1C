﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными в модели сервиса".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Переопределяет действие перед авторизацией пользователя,
// выполняемой при начале работы системы (в процессе получения
// параметров работы клиента при запуске).
//
// Можно заполнить состав пользователей и выполнить перезапуск.
// 
// Требуется, например, при настройке автономного рабочего места.
// 
// Параметры:
//  Перезапустить - Булево, начальное значение Ложь. Если указать
//                  Истина, тогда работа системы будет прекращена.
//
Процедура ПередАвторизациейТекущегоПользователяПриНачалеРаботыСистемы(Перезапустить) Экспорт
	
	Если НеобходимоВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске() Тогда
		ВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске();
		Перезапустить = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ, ИСПОЛЬЗУЕМЫЕ НА СТОРОНЕ СЕРВИСА

// Для внутреннего использования
// 
Процедура СоздатьНачальныйОбразАвтономногоРабочегоМеста(Параметры,
			АдресВременногоХранилищаНачальногоОбраза,
			АдресВременногоХранилищаИнформацииОПакетеУстановки
	) Экспорт
	
	ПомощникСозданияАвтономногоРабочегоМеста = Обработки.ПомощникСозданияАвтономногоРабочегоМеста.Создать();
	
	ЗаполнитьЗначенияСвойств(ПомощникСозданияАвтономногоРабочегоМеста, Параметры);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПомощникСозданияАвтономногоРабочегоМеста.СоздатьНачальныйОбразАвтономногоРабочегоМеста(
				Параметры.НастройкаОтборовНаУзле,
				Параметры.ВыбранныеПользователиСинхронизации,
				АдресВременногоХранилищаНачальногоОбраза,
				АдресВременногоХранилищаИнформацииОПакетеУстановки);
	
КонецПроцедуры

// Для внутреннего использования
// 
Процедура УдалитьАвтономноеРабочееМесто(Параметры, АдресХранилища) Экспорт
	
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		// ============================ {для совместимости с БСП 2.1.3}
		Пользователь = РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.ПользовательДляСинхронизацииДанных(Параметры.АвтономноеРабочееМесто);
		
		Если Пользователь <> Неопределено Тогда
			
			ПользовательОбъект = Пользователь.ПолучитьОбъект();
			
			Если ПользовательОбъект <> Неопределено Тогда
				
				ПользовательОбъект.Удалить();
				
			КонецЕсли;
			
		КонецЕсли;
		// ============================ {для совместимости с БСП 2.1.3}
		
		АвтономноеРабочееМестоОбъект = Параметры.АвтономноеРабочееМесто.ПолучитьОбъект();
		
		Если АвтономноеРабочееМестоОбъект <> Неопределено Тогда
			
			АвтономноеРабочееМестоОбъект.Удалить();
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Для внутреннего использования
// 
Функция АвтономнаяРаботаПоддерживается() Экспорт
	
	Возврат ОбменДаннымиПовтИсп.АвтономнаяРаботаПоддерживается();
	
КонецФункции

// Для внутреннего использования
// 
Функция КоличествоАвтономныхРабочихМест() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	ПланОбмена.[ИмяПланаОбмена] КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка <> &ПриложениеВСервисе
	|	И НЕ Таблица.ПометкаУдаления";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяПланаОбмена]", ПланОбменаАвтономнойРаботы());
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПриложениеВСервисе", ПриложениеВСервисе());
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Количество;
КонецФункции

// Для внутреннего использования
// 
Функция ПриложениеВСервисе() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбменДаннымиСервер.ГлавныйУзел() <> Неопределено Тогда
		
		Возврат ОбменДаннымиСервер.ГлавныйУзел();
		
	Иначе
		
		Возврат ПланыОбмена[ПланОбменаАвтономнойРаботы()].ЭтотУзел();
		
	КонецЕсли;
	
КонецФункции

// Для внутреннего использования
// 
Функция АвтономноеРабочееМесто() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.Ссылка КАК АвтономноеРабочееМесто
	|ИЗ
	|	ПланОбмена.[ИмяПланаОбмена] КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка <> &ПриложениеВСервисе
	|	И НЕ Таблица.ПометкаУдаления";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяПланаОбмена]", ПланОбменаАвтономнойРаботы());
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПриложениеВСервисе", ПриложениеВСервисе());
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.АвтономноеРабочееМесто;
КонецФункции

// Для внутреннего использования
// 
Функция ПланОбменаАвтономнойРаботы() Экспорт
	
	Возврат ОбменДаннымиПовтИсп.ПланОбменаАвтономнойРаботы();
	
КонецФункции

// Для внутреннего использования
// 
Функция ЭтоУзелАвтономногоРабочегоМеста(Знач УзелИнформационнойБазы) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиПовтИсп.ЭтоУзелАвтономногоРабочегоМеста(УзелИнформационнойБазы);
	
КонецФункции

// Для внутреннего использования
// 
Функция ДатаПоследнейУспешнойСинхронизации(АвтономноеРабочееМесто) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	МИНИМУМ(СостоянияУспешныхОбменовДанными.ДатаОкончания) КАК ДатаСинхронизации
	|ИЗ
	|	[СостоянияУспешныхОбменовДанными] КАК СостоянияУспешныхОбменовДанными
	|ГДЕ
	|	СостоянияУспешныхОбменовДанными.УзелИнформационнойБазы = &АвтономноеРабочееМесто";
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[СостоянияУспешныхОбменовДанными]", "РегистрСведений.СостоянияУспешныхОбменовДаннымиОбластейДанных");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[СостоянияУспешныхОбменовДанными]", "РегистрСведений.СостоянияУспешныхОбменовДанными");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("АвтономноеРабочееМесто", АвтономноеРабочееМесто);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат ?(ЗначениеЗаполнено(Выборка.ДатаСинхронизации), Выборка.ДатаСинхронизации, Неопределено);
КонецФункции

// Для внутреннего использования
// 
Функция СформироватьНаименованиеАвтономногоРабочегоМестаПоУмолчанию() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	ПланОбмена.[ИмяПланаОбмена] КАК Таблица
	|ГДЕ
	|	Таблица.Наименование ПОДОБНО &ШаблонИмени";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяПланаОбмена]", ПланОбменаАвтономнойРаботы());
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ШаблонИмени", НаименованиеАвтономногоРабочегоМестаПоУмолчанию() + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Количество = Выборка.Количество;
	
	Если Количество = 0 Тогда
		
		Возврат НаименованиеАвтономногоРабочегоМестаПоУмолчанию();
		
	Иначе
		
		Результат = "[Наименование] ([Количество])";
		Результат = СтрЗаменить(Результат, "[Наименование]", НаименованиеАвтономногоРабочегоМестаПоУмолчанию());
		Результат = СтрЗаменить(Результат, "[Количество]", Формат(Количество + 1, "ЧГ=0"));
		
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

// Для внутреннего использования
// 
Функция СформироватьПрефиксАвтономногоРабочегоМеста(Знач ПоследнийПрефикс = "") Экспорт
	
	ДопустимыеСимволы = ДопустимыеСимволыПрефиксаАвтономногоРабочегоМеста();
	
	СимволПоследнегоАвтономногоРабочегоМеста = Лев(ПоследнийПрефикс, 1);
	
	ПозицияСимвола = Найти(ДопустимыеСимволы, СимволПоследнегоАвтономногоРабочегоМеста);
	
	Если ПозицияСимвола = 0 ИЛИ ПустаяСтрока(СимволПоследнегоАвтономногоРабочегоМеста) Тогда
		
		Символ = Лев(ДопустимыеСимволы, 1); // Используем первый символ
		
	ИначеЕсли ПозицияСимвола >= СтрДлина(ДопустимыеСимволы) Тогда
		
		Символ = Прав(ДопустимыеСимволы, 1); // Используем последний символ
		
	Иначе
		
		Символ = Сред(ДопустимыеСимволы, ПозицияСимвола + 1, 1); // Используем следующий символ
		
	КонецЕсли;
	
	ПрефиксПриложения = Прав(ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы"), 1);
	
	Результат = "[Символ][ПрефиксПриложения]";
	Результат = СтрЗаменить(Результат, "[Символ]", Символ);
	Результат = СтрЗаменить(Результат, "[ПрефиксПриложения]", ПрефиксПриложения);
	
	Возврат Результат;
КонецФункции

// Для внутреннего использования
// 
Функция ИмяФайлаПакетаУстановки() Экспорт
	
	Возврат НСтр("ru = 'Автономная работа.zip'");
	
КонецФункции

// Для внутреннего использования
// 
Функция ОписаниеОграниченийПередачиДанных(АвтономноеРабочееМесто) Экспорт
	
	ПланОбменаАвтономнойРаботы = ПланОбменаАвтономнойРаботы();
	
	НастройкаОтборовНаУзле = ПланыОбмена[ПланОбменаАвтономнойРаботы].НастройкаОтборовНаУзле();
	
	Если НастройкаОтборовНаУзле = Неопределено
		ИЛИ НастройкаОтборовНаУзле.Количество() = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Реквизиты = Новый Массив;
	
	Для Каждого Элемент Из НастройкаОтборовНаУзле Цикл
		
		Реквизиты.Добавить(Элемент.Ключ);
		
	КонецЦикла;
	
	Реквизиты = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(Реквизиты);
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(АвтономноеРабочееМесто, Реквизиты);
	
	Для Каждого Элемент Из НастройкаОтборовНаУзле Цикл
		
		Если ТипЗнч(Элемент.Значение) = Тип("Структура") Тогда
			
			Таблица = ЗначенияРеквизитов[Элемент.Ключ].Выгрузить();
			
			Для Каждого ВложенныйЭлемент Из Элемент.Значение Цикл
				
				НастройкаОтборовНаУзле[Элемент.Ключ][ВложенныйЭлемент.Ключ] = Таблица.ВыгрузитьКолонку(ВложенныйЭлемент.Ключ);
				
			КонецЦикла;
			
		Иначе
			
			НастройкаОтборовНаУзле[Элемент.Ключ] = ЗначенияРеквизитов[Элемент.Ключ];
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПланыОбмена[ПланОбменаАвтономнойРаботы].ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле);
КонецФункции

// Для внутреннего использования
// 
Функция МониторАвтономныхРабочихМест() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	СостоянияУспешныхОбменовДанными.УзелИнформационнойБазы КАК АвтономноеРабочееМесто,
	|	МИНИМУМ(СостоянияУспешныхОбменовДанными.ДатаОкончания) КАК ДатаСинхронизации
	|ПОМЕСТИТЬ СостоянияУспешныхОбменовДанными
	|ИЗ
	|	РегистрСведений.СостоянияУспешныхОбменовДаннымиОбластейДанных КАК СостоянияУспешныхОбменовДанными
	|
	|СГРУППИРОВАТЬ ПО
	|	СостоянияУспешныхОбменовДанными.УзелИнформационнойБазы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланОбмена.Ссылка КАК АвтономноеРабочееМесто,
	|	ЕСТЬNULL(СостоянияУспешныхОбменовДанными.ДатаСинхронизации, Неопределено) КАК ДатаСинхронизации
	|ИЗ
	|	ПланОбмена.[ИмяПланаОбмена] КАК ПланОбмена
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ СостоянияУспешныхОбменовДанными КАК СостоянияУспешныхОбменовДанными
	|	ПО ПланОбмена.Ссылка = СостоянияУспешныхОбменовДанными.АвтономноеРабочееМесто
	|
	|ГДЕ
	|	ПланОбмена.Ссылка <> &ПриложениеВСервисе
	|	И НЕ ПланОбмена.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПланОбмена.Представление";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяПланаОбмена]", ПланОбменаАвтономнойРаботы());
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПриложениеВСервисе", ПриложениеВСервисе());
	Запрос.Текст = ТекстЗапроса;
	
	НастройкиСинхронизации = Запрос.Выполнить().Выгрузить();
	НастройкиСинхронизации.Колонки.Добавить("ПредставлениеДатыСинхронизации");
	
	Для Каждого НастройкаСинхронизации Из НастройкиСинхронизации Цикл
		
		Если ЗначениеЗаполнено(НастройкаСинхронизации.ДатаСинхронизации) Тогда
			НастройкаСинхронизации.ПредставлениеДатыСинхронизации =
				ОбменДаннымиСервер.ОтносительнаяДатаСинхронизации(НастройкаСинхронизации.ДатаСинхронизации);
		Иначе
			НастройкаСинхронизации.ПредставлениеДатыСинхронизации = НСтр("ru = 'не выполнялась'");
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НастройкиСинхронизации;
КонецФункции

// Для внутреннего использования
// 
Функция СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста() Экспорт
	
	Возврат НСтр("ru = 'Автономная работа.Создание автономного рабочего места'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

// Для внутреннего использования
// 
Функция СобытиеЖурналаРегистрацииУдалениеАвтономногоРабочегоМеста() Экспорт
	
	Возврат НСтр("ru = 'Автономная работа.Удаление автономного рабочего места'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

// Для внутреннего использования
// 
Функция ТекстИнструкцииИзМакета(Знач ИмяМакета) Экспорт
	
	Результат = Обработки.ПомощникСозданияАвтономногоРабочегоМеста.ПолучитьМакет(ИмяМакета).ПолучитьТекст();
	Результат = СтрЗаменить(Результат, "[НазваниеПрограммы]", Метаданные.Синоним);
	Результат = СтрЗаменить(Результат, "[ВерсияПлатформы]", ОбменДаннымиВМоделиСервиса.ТребуемаяВерсияПлатформы());
	Возврат Результат;
КонецФункции

// Для внутреннего использования
// 
Функция ЗаменитьНедопустимыеСимволыВИмениПользователя(Знач Значение, Знач СимволЗамены = "_") Экспорт
	
	НедопустимыеСимволы = ОбменДаннымиКлиентСервер.НедопустимыеСимволыВИмениПользователяWSПрокси();
	
	Для Индекс = 1 По СтрДлина(НедопустимыеСимволы) Цикл
		
		НедопустимыйСимвол = Сред(НедопустимыеСимволы, Индекс, 1);
		
		Значение = СтрЗаменить(Значение, НедопустимыйСимвол, СимволЗамены);
		
	КонецЦикла;
	
	Возврат Значение;
КонецФункции

//

// Для внутреннего использования
// 
Функция НаименованиеАвтономногоРабочегоМестаПоУмолчанию()
	
	Результат = НСтр("ru = 'Автономная работа - %1'");
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Результат, ПолноеИмяПользователя());
КонецФункции

// Для внутреннего использования
// 
Функция ДопустимыеСимволыПрефиксаАвтономногоРабочегоМеста()
	
	Возврат НСтр("ru = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЭЮЯабвгдежзиклмнопрстуфхцчшэюя'"); // 54 символа
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ, ИСПОЛЬЗУЕМЫЕ НА СТОРОНЕ АВТОНОМНОГО РАБОЧЕГО МЕСТА

// Для внутреннего использования
// 
Процедура СинхронизироватьДанныеСПриложениемВИнтернете() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЭтоАвтономноеРабочееМесто() Тогда
		
		КодОсновногоЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка();
		
		ПодробноеПредставлениеОшибкиДляЖурналаРегистрации =
			НСтр("ru = 'Эта информационная база не является автономным рабочим местом. Синхронизация данных отменена.'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())
		;
		ПодробноеПредставлениеОшибки =
			НСтр("ru = 'Эта информационная база не является автономным рабочим местом. Синхронизация данных отменена.'")
		; // Строка записывается в Журнал регистрации
		
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСинхронизацияДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибкиДляЖурналаРегистрации);
		ВызватьИсключение ПодробноеПредставлениеОшибки;
		
	КонецЕсли;
	
	Отказ = Ложь;
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(Отказ, ПриложениеВСервисе(), Истина, Истина,
		Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	
	Если Отказ Тогда
		ВызватьИсключение НСтр("ru = 'В процессе синхронизации данных с приложением в Интернете возникли ошибки (см. журнал регистрации).'");
	КонецЕсли;
	
КонецПроцедуры

// Для внутреннего использования
// 
Процедура ВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске()
	
	Если Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ВызватьИсключение НСтр("ru = 'Первый запуск автономного рабочего места должен выполняться
								|в файловом режиме работы информационной базы.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Правила обмена не мигрируют в РИБ, поэтому выполняем загрузку правил
	ОбменДаннымиСервер.ВыполнитьОбновлениеПравилДляОбменаДанными();
	
	ЗагрузитьДанныеНачальногоОбраза();
	
	ЗагрузитьПараметрыИзНачальногоОбраза();
	
КонецПроцедуры

// Для внутреннего использования
// 
Процедура ОтключитьАвтоматическуюСинхронизациюДанныхСПриложениемВИнтернете() Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
			Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете, Ложь);
	
	КонецЕсли;
	
КонецПроцедуры

// Для внутреннего использования
// 
Функция НеобходимоВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ЭтоАвтономноеРабочееМесто()
		И Не Константы.НастройкаАвтономногоРабочегоМестаЗавершена.Получить()
	;
КонецФункции

// Для внутреннего использования
// 
Функция СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботы() Экспорт
	
	Возврат ЭтоАвтономноеРабочееМесто()
		И Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Получить()
		И Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботыПрограммы.Получить()
		И СинхронизацияССервисомДавноНеВыполнялась()
		И ОбменДаннымиСервер.СинхронизацияДанныхРазрешена()
	;
КонецФункции

// Для внутреннего использования
// 
Функция СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботы() Экспорт
	
	Возврат ЭтоАвтономноеРабочееМесто()
		И Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Получить()
		И Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботыПрограммы.Получить()
		И ОбменДаннымиСервер.СинхронизацияДанныхРазрешена()
	;
КонецФункции

// Для внутреннего использования
// 
Функция ОткрытьПомощникНастройкиАвтономногоРабочегоМеста() Экспорт
	
	Возврат ЭтоАвтономноеРабочееМесто()
		И Не Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Получить()
	;
КонецФункции

// Для внутреннего использования
// 
Функция РасписаниеСинхронизацииДанныхПоУмолчанию() Экспорт // Каждый час
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.Месяцы                   = Месяцы;
	Расписание.ДниНедели                = ДниНедели;
	Расписание.ПериодПовтораВТечениеДня = 60*60; // 60 минут
	Расписание.ПериодПовтораДней        = 1; // каждый день
	
	Возврат Расписание;
КонецФункции

// Для внутреннего использования
// 
Функция ЭтоАвтономноеРабочееМесто() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиПовтИсп.ЭтоАвтономноеРабочееМесто();
	
КонецФункции

// Для внутреннего использования
// 
Функция АдресДляВосстановленияПароляУчетнойЗаписи() Экспорт
	
	Результат = "";
	Результат = ОбменДаннымиВМоделиСервисаПереопределяемый.АдресДляВосстановленияПароляУчетнойЗаписи();
	
	Если ПустаяСтрока(Результат) Тогда
		Результат = "https://1cfresh.com/recover";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Для внутреннего использования
// 
Функция ПараметрыФормыВыполненияОбменаДанными() Экспорт
	
	Возврат Новый Структура("УзелИнформационнойБазы, АдресДляВосстановленияПароляУчетнойЗаписи, ЗакрытьПриУспешнойСинхронизации",
		ПриложениеВСервисе(), АдресДляВосстановленияПароляУчетнойЗаписи(), Истина);
КонецФункции

// Для внутреннего использования
// 
Функция СинхронизацияССервисомДавноНеВыполнялась(Знач Интервал = 3600) Экспорт // 1 час по умолчанию
	
	Возврат Истина;
	
КонецФункции

// Определяет возможность внесения изменений в объект
// Объект нельзя записать в Автономном рабочем месте, если он одновременно соответствует следующим условиям:
//	1. Это автономное рабочее место.
//	2. Это неразделенный объект метаданных.
//	3. Этот объект входит в состав плана обмена автономной работы.
//	4. Не входит в список исключений.
//
// Параметры:
//	ОбъектМетаданных - Метаданные проверяемого объекта
//	Только просмотр - Булево - Если Истина, то объект доступен только для просмотра.
//
Процедура ОпределитьВозможностьИзмененияДанных(ОбъектМетаданных, ТолькоПросмотр) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТолькоПросмотр = ЭтоАвтономноеРабочееМесто()
		И (Не ОбщегоНазначенияПовтИсп.ЭтоРазделенныйОбъектМетаданных(ОбъектМетаданных.ПолноеИмя(),
			ОбщегоНазначенияПовтИсп.РазделительОсновныхДанных())
			И Не ОбщегоНазначенияПовтИсп.ЭтоРазделенныйОбъектМетаданных(ОбъектМетаданных.ПолноеИмя(),
				ОбщегоНазначенияПовтИсп.РазделительВспомогательныхДанных()))
		И Не ОбъектМетаданныхЯвляетсяИсключением(ОбъектМетаданных)
		И Метаданные.ПланыОбмена[ПланОбменаАвтономнойРаботы()].Состав.Содержит(ОбъектМетаданных);
	
КонецПроцедуры

//

// Для внутреннего использования
// 
Процедура ЗагрузитьПараметрыИзНачальногоОбраза()
	
	Параметры = ПолучитьПараметрыИзНачальногоОбраза();
	
	Попытка
		ПланыОбмена.УстановитьГлавныйУзел(Неопределено);
	Исключение
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение НСтр("ru = 'Возможно, информационная база открыта в режиме конфигуратора.
		|Завершите работу конфигуратора и повторите запуск программы.'");
	КонецПопытки;
	
	// Создаем узлы плана обмена автономной работы в нулевой области данных
	УзелАвтономногоРабочегоМеста = ПланыОбмена[ПланОбменаАвтономнойРаботы()].ЭтотУзел().ПолучитьОбъект();
	УзелАвтономногоРабочегоМеста.Код          = Параметры.КодАвтономногоРабочегоМеста;
	УзелАвтономногоРабочегоМеста.Наименование = Параметры.НаименованиеАвтономногоРабочегоМеста;
	УзелАвтономногоРабочегоМеста.ДополнительныеСвойства.Вставить("ПолучениеСообщенияОбмена");
	УзелАвтономногоРабочегоМеста.Записать();
	
	УзелПриложенияВСервисе = ПланыОбмена[ПланОбменаАвтономнойРаботы()].СоздатьУзел();
	УзелПриложенияВСервисе.Код          = Параметры.КодПриложенияВСервисе;
	УзелПриложенияВСервисе.Наименование = Параметры.НаименованиеПриложенияВСервисе;
	УзелПриложенияВСервисе.ДополнительныеСвойства.Вставить("ПолучениеСообщенияОбмена");
	УзелПриложенияВСервисе.Записать();
	
	// Назначаем созданный узел главным
	ПланыОбмена.УстановитьГлавныйУзел(УзелПриложенияВСервисе.Ссылка);
	
	НачатьТранзакцию();
	Попытка
		
		Константы.НастройкаАвтономногоРабочегоМестаЗавершена.Установить(Истина);
		Константы.ИспользоватьСинхронизациюДанных.Установить(Истина);
		Константы.НастройкиПодчиненногоУзлаРИБ.Установить("");
		Константы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Установить(Параметры.Префикс);
		Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботыПрограммы.Установить(Истина);
		Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботыПрограммы.Установить(Истина);
		Константы.ЗаголовокСистемы.Установить(Параметры.ЗаголовокСистемы);
		
		Константы.ЭтоАвтономноеРабочееМесто.Установить(Истина);
		Константы.ИспользоватьРазделениеПоОбластямДанных.Установить(Ложь);
		
		// константа влияет на открытие помощника по настройке автономного рабочего места
		Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Установить(Истина);
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("Узел", ПриложениеВСервисе());
		СтруктураЗаписи.Вставить("ВидТранспортаСообщенийОбменаПоУмолчанию", Перечисления.ВидыТранспортаСообщенийОбмена.WS);
		
		СтруктураЗаписи.Вставить("КоличествоЭлементовВТранзакцииВыгрузкиДанных", 200);
		СтруктураЗаписи.Вставить("КоличествоЭлементовВТранзакцииЗагрузкиДанных", 200);
		
		СтруктураЗаписи.Вставить("WSИспользоватьПередачуБольшогоОбъемаДанных", Истина);
		
		СтруктураЗаписи.Вставить("WSURLВебСервиса", Параметры.URL);
		
		// добавляем запись в РС
		РегистрыСведений.НастройкиТранспортаОбмена.ДобавитьЗапись(СтруктураЗаписи);
		
		// Устанавливаем дату создания начального образа, как дату первой успешной синхронизации данных.
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", ПриложениеВСервисе());
		СтруктураЗаписи.Вставить("ДействиеПриОбмене", Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
		СтруктураЗаписи.Вставить("ДатаОкончания", Параметры.ДатаСозданияНачальногоОбраза);
		РегистрыСведений.СостоянияУспешныхОбменовДанными.ДобавитьЗапись(СтруктураЗаписи);
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", ПриложениеВСервисе());
		СтруктураЗаписи.Вставить("ДействиеПриОбмене", Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
		СтруктураЗаписи.Вставить("ДатаОкончания", Параметры.ДатаСозданияНачальногоОбраза);
		РегистрыСведений.СостоянияУспешныхОбменовДанными.ДобавитьЗапись(СтруктураЗаписи);
		
		// Устанавливаем расписание синхронизации по умолчанию.
		// Расписание отключаем, т.к. пароль пользователя не задан.
		РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете);
		РегламентноеЗадание.Использование = Ложь;
		РегламентноеЗадание.Расписание = РасписаниеСинхронизацииДанныхПоУмолчанию();
		РегламентноеЗадание.Записать();
		
		// Создаем пользователя ИБ и связываем его с пользователем из справочника пользователей.
		Роли = Новый Массив;
		Роли.Добавить("АдминистраторСистемы");
		Роли.Добавить("ПолныеПрава");
		
		ОписаниеПользователяИБ = Новый Структура;
		ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		ОписаниеПользователяИБ.Вставить("Имя",       Параметры.ИмяВладельца);
		ОписаниеПользователяИБ.Вставить("Роли",      Роли);
		ОписаниеПользователяИБ.Вставить("АутентификацияСтандартная", Истина);
		ОписаниеПользователяИБ.Вставить("ПоказыватьВСпискеВыбора", Истина);
		
		Пользователь = Справочники.Пользователи.ПолучитьСсылку(Новый УникальныйИдентификатор(Параметры.Владелец)).ПолучитьОбъект();
		
		Если Пользователь = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Идентификация пользователя не выполнена.
				|Возможно, справочник пользователей не включен в состав плана обмена автономной работы.'");
		КонецЕсли;
		
		УстановитьМинимальнуюДлинуПаролейПользователей(0);
		УстановитьПроверкуСложностиПаролейПользователей(Ложь);
		
		Пользователь.Служебный = Ложь;
		Пользователь.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		Пользователь.Записать();
		
		ПланыОбмена.УдалитьРегистрациюИзменений(УзелПриложенияВСервисе.Ссылка);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Для внутреннего использования
// 
Процедура ЗагрузитьДанныеНачальногоОбраза()
	
	КаталогИнформационнойБазы = ОбщегоНазначенияКлиентСервер.КаталогФайловойИнформационнойБазы();
	
	ИмяФайлаДанныхНачальногоОбраза = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		КаталогИнформационнойБазы,
		"data.xml");
	
	ФайлДанныхНачальногоОбраза = Новый Файл(ИмяФайлаДанныхНачальногоОбраза);
	Если Не ФайлДанныхНачальногоОбраза.Существует() Тогда
		Возврат; // Данные начального образа были успешно загружены ранее
	КонецЕсли;
	
	ДанныеНачальногоОбраза = Новый ЧтениеXML;
	ДанныеНачальногоОбраза.ОткрытьФайл(ИмяФайлаДанныхНачальногоОбраза);
	ДанныеНачальногоОбраза.Прочитать();
	ДанныеНачальногоОбраза.Прочитать();
	
	НачатьТранзакцию();
	Попытка
		
		Пока ВозможностьЧтенияXML(ДанныеНачальногоОбраза) Цикл
			
			ЭлементДанных = ПрочитатьXML(ДанныеНачальногоОбраза);
			ЭлементДанных.ДополнительныеСвойства.Вставить("СозданиеНачальногоОбраза");
			
			ПолучениеЭлемента = ПолучениеЭлементаДанных.Авто;
			СтандартныеПодсистемыСервер.ПриПолученииДанныхОтГлавного(ЭлементДанных, ПолучениеЭлемента, Ложь);
			
			Если ПолучениеЭлемента = ПолучениеЭлементаДанных.Игнорировать Тогда
				Продолжить;
			КонецЕсли;
			
			ЭлементДанных.ОбменДанными.Загрузка = Истина;
			ЭлементДанных.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
			ЭлементДанных.Записать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ДанныеНачальногоОбраза = Неопределено;
		ВызватьИсключение;
	КонецПопытки;
	
	ДанныеНачальногоОбраза.Закрыть();
	
	Попытка
		УдалитьФайлы(ИмяФайлаДанныхНачальногоОбраза);
	Исключение
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(), УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Для внутреннего использования
// 
Функция ПолучитьПараметрыИзНачальногоОбраза()
	
	СтрокаXML = Константы.НастройкиПодчиненногоУзлаРИБ.Получить();
	
	Если ПустаяСтрока(СтрокаXML) Тогда
		ВызватьИсключение НСтр("ru = 'В автономное рабочее место не были переданы настройки.
									|Работа с автономным рабочим место невозможна.'");
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	ЧтениеXML.Прочитать(); // Параметры
	ВерсияФормата = ЧтениеXML.ПолучитьАтрибут("ВерсияФормата");
	
	ЧтениеXML.Прочитать(); // ПараметрыАвтономногоРабочегоМеста
	
	Результат = СчитатьДанныеВСтуктуру(ЧтениеXML);
	
	ЧтениеXML.Закрыть();
	
	Возврат Результат;
КонецФункции

// Для внутреннего использования
// 
Функция СчитатьДанныеВСтуктуру(ЧтениеXML)
	
	// возвращаемое значение функции
	Результат = Новый Структура;
	
	Если ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка чтения XML'");
	КонецЕсли;
	
	ЧтениеXML.Прочитать();
	
	Пока ЧтениеXML.ТипУзла <> ТипУзлаXML.КонецЭлемента Цикл
		
		Ключ = ЧтениеXML.Имя;
		
		Результат.Вставить(Ключ, ПрочитатьXML(ЧтениеXML));
		
	КонецЦикла;
	
	ЧтениеXML.Прочитать();
	
	Возврат Результат;
КонецФункции

// Для внутреннего использования
// 
Функция СобытиеЖурналаРегистрацииСинхронизацияДанных()
	
	Возврат НСтр("ru = 'Автономная работа.Синхронизация данных'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы

// Выполняет проверку объекта на вхождение в список исключений
Функция ОбъектМетаданныхЯвляетсяИсключением(Знач ОбъектМетаданных)
	
	// Константа ПараметрыСлужебныхСобытий является объектом начального узла РИБ,
	// но должна проверяться без вызова служебных событий.
	Если ОбъектМетаданных = Метаданные.Константы.ПараметрыСлужебныхСобытий Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Справочник ИдентификаторыОбъектовМетаданных не является объектом начального узла РИБ.
	// В подчиненных узлах РИБ допустимо обновление многих реквизитов справочника по значениям
	// свойств метаданных в строгом соответствии главному узлу (требуется для нештатных ситуаций).
	// Контроль изменения осуществляется в справочнике в процедуре ПередЗаписью модуля объекта.
	Если ОбъектМетаданных = Метаданные.Справочники.ИдентификаторыОбъектовМетаданных Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат СтандартныеПодсистемыСервер.ЭтоОбъектНачальногоОбразаУзлаРИБ(ОбъектМетаданных);
	
КонецФункции
