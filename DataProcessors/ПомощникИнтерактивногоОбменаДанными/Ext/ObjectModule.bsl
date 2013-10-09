﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции

// Получает статистику сопоставления объектов для строк таблицы ИнформацияСтатистики
//
// Параметры:
//  Отказ – Булево – флаг отказа; поднимается в случае возникновения ошибок при работе процедуры
//  ИндексыСтрок (необязательный) – Массив – индексы строк таблицы ИнформацияСтатистики
//              для которых необходимо получить информацию статистики сопоставления.
//              Если не указан, то операция будет выполнена для всех строк таблицы.
// 
Процедура ПолучитьСтатистикуСопоставленияОбъектовПоСтроке(Отказ, ИндексыСтрок = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ИндексыСтрок = Неопределено Тогда
		
		ИндексыСтрок = Новый Массив;
		
		Для Каждого СтрокаТаблицы Из ИнформацияСтатистики Цикл
			
			ИндексыСтрок.Добавить(ИнформацияСтатистики.Индекс(СтрокаТаблицы));
			
		КонецЦикла;
		
	КонецЕсли;
	
	// выполняем загрузку данных из сообщения обмена в кэш сразу для нескольких таблиц
	ВыполнитьЗагрузкуДанныхИзСообщенияОбменаВКэш(Отказ, ИндексыСтрок);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СопоставлениеОбъектовИнформационныхБаз = Обработки.СопоставлениеОбъектовИнформационныхБаз.Создать();
	
	// получаем информацию дайджеста сопоставления отдельно для каждой таблицы
	Для Каждого ИндексСтроки Из ИндексыСтрок Цикл
		
		СтрокаТаблицы = ИнформацияСтатистики[ИндексСтроки];
		
		Если Не СтрокаТаблицы.СинхронизироватьПоИдентификатору Тогда
			Продолжить;
		КонецЕсли;
		
		// инициализация свойств обработки
		СопоставлениеОбъектовИнформационныхБаз.ИмяТаблицыПриемника            = СтрокаТаблицы.ИмяТаблицыПриемника;
		СопоставлениеОбъектовИнформационныхБаз.ИмяТипаОбъектаТаблицыИсточника = СтрокаТаблицы.ТипОбъектаСтрокой;
		СопоставлениеОбъектовИнформационныхБаз.УзелИнформационнойБазы         = УзелИнформационнойБазы;
		СопоставлениеОбъектовИнформационныхБаз.ИмяФайлаСообщенияОбмена        = ИмяФайлаСообщенияОбмена;
		
		СопоставлениеОбъектовИнформационныхБаз.ТипИсточникаСтрокой = СтрокаТаблицы.ТипИсточникаСтрокой;
		СопоставлениеОбъектовИнформационныхБаз.ТипПриемникаСтрокой = СтрокаТаблицы.ТипПриемникаСтрокой;
		
		// конструктор
		СопоставлениеОбъектовИнформационныхБаз.Конструктор();
		
		// получаем информацию дайджеста сопоставления
		СопоставлениеОбъектовИнформационныхБаз.ПолучитьИнформациюДайджестаСопоставленияОбъектов(Отказ);
		
		// информация дайджеста сопоставления
		СтрокаТаблицы.КоличествоОбъектовВИсточнике       = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовВИсточнике();
		СтрокаТаблицы.КоличествоОбъектовВПриемнике       = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовВПриемнике();
		СтрокаТаблицы.КоличествоОбъектовСопоставленных   = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовСопоставленных();
		СтрокаТаблицы.КоличествоОбъектовНесопоставленных = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовНесопоставленных();
		СтрокаТаблицы.ПроцентСопоставленияОбъектов       = СопоставлениеОбъектовИнформационныхБаз.ПроцентСопоставленияОбъектов();
		СтрокаТаблицы.ИндексКартинки                     = ОбменДаннымиСервер.ИндексКартинкиТаблицыИнформацииСтатистики(СтрокаТаблицы.КоличествоОбъектовНесопоставленных, СтрокаТаблицы.ДанныеУспешноЗагружены);
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняет автоматическое сопоставление объектов информационных баз
//  с заданными значениями по умолчанию и получает статистику сопоставления объектов
//  после автоматического сопоставления
//
// Параметры:
//  Отказ – Булево – флаг отказа; поднимается в случае возникновения ошибок при работе процедуры
//  ИндексыСтрок (необязательный) – Массив – индексы строк таблицы ИнформацияСтатистики
//              для которых необходимо выполнить автоматическое сопоставление и получить информацию статистики.
//              Если не указан, то операция будет выполнена для всех строк таблицы.
// 
Процедура ВыполнитьАвтоматическоеСопоставлениеПоУмолчаниюИПолучитьСтатистикуСопоставления(Отказ, ИндексыСтрок = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ИндексыСтрок = Неопределено Тогда
		
		ИндексыСтрок = Новый Массив;
		
		Для Каждого СтрокаТаблицы Из ИнформацияСтатистики Цикл
			
			ИндексыСтрок.Добавить(ИнформацияСтатистики.Индекс(СтрокаТаблицы));
			
		КонецЦикла;
		
	КонецЕсли;
	
	// выполняем загрузку данных из сообщения обмена в кэш сразу для нескольких таблиц
	ВыполнитьЗагрузкуДанныхИзСообщенияОбменаВКэш(Отказ, ИндексыСтрок);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СопоставлениеОбъектовИнформационныхБаз = Обработки.СопоставлениеОбъектовИнформационныхБаз.Создать();
	
	// выполняем автоматическое сопоставление
	// получаем информацию дайджеста сопоставления
	Для Каждого ИндексСтроки Из ИндексыСтрок Цикл
		
		СтрокаТаблицы = ИнформацияСтатистики[ИндексСтроки];
		
		Если Не СтрокаТаблицы.СинхронизироватьПоИдентификатору Тогда
			Продолжить;
		КонецЕсли;
		
		// инициализация свойств обработки
		СопоставлениеОбъектовИнформационныхБаз.ИмяТаблицыПриемника            = СтрокаТаблицы.ИмяТаблицыПриемника;
		СопоставлениеОбъектовИнформационныхБаз.ИмяТипаОбъектаТаблицыИсточника = СтрокаТаблицы.ТипОбъектаСтрокой;
		СопоставлениеОбъектовИнформационныхБаз.ПоляТаблицыПриемника           = СтрокаТаблицы.ПоляТаблицы;
		СопоставлениеОбъектовИнформационныхБаз.ПоляПоискаТаблицыПриемника     = СтрокаТаблицы.ПоляПоиска;
		СопоставлениеОбъектовИнформационныхБаз.УзелИнформационнойБазы         = УзелИнформационнойБазы;
		СопоставлениеОбъектовИнформационныхБаз.ИмяФайлаСообщенияОбмена        = ИмяФайлаСообщенияОбмена;
		
		СопоставлениеОбъектовИнформационныхБаз.ТипИсточникаСтрокой = СтрокаТаблицы.ТипИсточникаСтрокой;
		СопоставлениеОбъектовИнформационныхБаз.ТипПриемникаСтрокой = СтрокаТаблицы.ТипПриемникаСтрокой;
		
		// конструктор
		СопоставлениеОбъектовИнформационныхБаз.Конструктор();
		
		// выполняем автоматическое сопоставление объектов по умолчанию
		СопоставлениеОбъектовИнформационныхБаз.ВыполнитьАвтоматическоеСопоставлениеПоУмолчанию(Отказ);
		
		// получаем информацию дайджеста сопоставления
		СопоставлениеОбъектовИнформационныхБаз.ПолучитьИнформациюДайджестаСопоставленияОбъектов(Отказ);
		
		// информация дайджеста сопоставления
		СтрокаТаблицы.КоличествоОбъектовВИсточнике       = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовВИсточнике();
		СтрокаТаблицы.КоличествоОбъектовВПриемнике       = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовВПриемнике();
		СтрокаТаблицы.КоличествоОбъектовСопоставленных   = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовСопоставленных();
		СтрокаТаблицы.КоличествоОбъектовНесопоставленных = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовНесопоставленных();
		СтрокаТаблицы.ПроцентСопоставленияОбъектов       = СопоставлениеОбъектовИнформационныхБаз.ПроцентСопоставленияОбъектов();
		СтрокаТаблицы.ИндексКартинки                     = ОбменДаннымиСервер.ИндексКартинкиТаблицыИнформацииСтатистики(СтрокаТаблицы.КоличествоОбъектовНесопоставленных, СтрокаТаблицы.ДанныеУспешноЗагружены);
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняет загрузку данных в информационную базу для строк таблицы ИнформацияСтатистики.
//  В случае если будут загружены все данные сообщения обмена,
//  то в узел обмена будет записан номер входящего сообщения.
//  Это означает, что данные сообщения полностью загружены в информационную базу.
//  Повторная загрузка этого сообщения будет отменена.
//
// Параметры:
//  Отказ – Булево – флаг отказа; поднимается в случае возникновения ошибок при работе процедуры
//  ИндексыСтрок (необязательный) – Массив – индексы строк таблицы ИнформацияСтатистики
//              для которых необходимо выполнить загрузку данных.
//              Если не указан, то операция будет выполнена для всех строк таблицы.
// 
Процедура ВыполнитьЗагрузкуДанных(Отказ, ИндексыСтрок = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ИндексыСтрок = Неопределено Тогда
		
		ИндексыСтрок = Новый Массив;
		
		Для Каждого СтрокаТаблицы Из ИнформацияСтатистики Цикл
			
			ИндексыСтрок.Добавить(ИнформацияСтатистики.Индекс(СтрокаТаблицы));
			
		КонецЦикла;
		
	КонецЕсли;
	
	ТаблицыДляЗагрузки = Новый Массив;
	
	Для Каждого ИндексСтроки Из ИндексыСтрок Цикл
		
		СтрокаТаблицы = ИнформацияСтатистики[ИндексСтроки];
		
		КлючТаблицыДанных = ОбменДаннымиСервер.КлючТаблицыДанных(СтрокаТаблицы.ТипИсточникаСтрокой, СтрокаТаблицы.ТипПриемникаСтрокой, СтрокаТаблицы.ЭтоУдалениеОбъекта);
		
		ТаблицыДляЗагрузки.Добавить(КлючТаблицыДанных);
		
	КонецЦикла;
	
	// инициализация свойств обработки
	СопоставлениеОбъектовИнформационныхБаз = Обработки.СопоставлениеОбъектовИнформационныхБаз.Создать();
	СопоставлениеОбъектовИнформационныхБаз.ИмяФайлаСообщенияОбмена = ИмяФайлаСообщенияОбмена;
	СопоставлениеОбъектовИнформационныхБаз.УзелИнформационнойБазы  = УзелИнформационнойБазы;
	
	// выполняем загрузку файла
	СопоставлениеОбъектовИнформационныхБаз.ВыполнитьЗагрузкуДанныхВИнформационнуюБазу(Отказ, ТаблицыДляЗагрузки);
	
	ДанныеУспешноЗагружены = Не Отказ;
	
	Для Каждого ИндексСтроки Из ИндексыСтрок Цикл
		
		СтрокаТаблицы = ИнформацияСтатистики[ИндексСтроки];
		
		СтрокаТаблицы.ДанныеУспешноЗагружены = ДанныеУспешноЗагружены;
		СтрокаТаблицы.ИндексКартинки = ОбменДаннымиСервер.ИндексКартинкиТаблицыИнформацииСтатистики(СтрокаТаблицы.КоличествоОбъектовНесопоставленных, СтрокаТаблицы.ДанныеУспешноЗагружены);
	
	КонецЦикла;
	
	// если загрузка всех данных выполнена, то устанавливаем номер входящего сообщения в узле информационной базы
	Если ПакетДанныхЗагруженПолностью() Тогда
		
		УстановитьНомерВходящегоСообщенияУзлаИнформационнойБазы(Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет загрузку сообщения обмена из внешнего источника
//  (ftp, e-mail, сетевой каталог) во временный каталог пользователя операционной системы
//
// Параметры:
//  Отказ – Булево – флаг отказа; поднимается в случае возникновения ошибок при работе процедуры
//  ИдентификаторФайлаПакетаДанных – ДатаВремя – дата изменения сообщения обмена;
//                   выступает в качестве идентификатора файла для подсистемы обмена данными
// 
Процедура ПолучитьСообщениеОбменаВоВременныйКаталог(
		Отказ,
		ИдентификаторФайлаПакетаДанных = Неопределено,
		ИдентификаторФайла = "",
		ДлительнаяОперация = Ложь,
		ИдентификаторОперации = "",
		Пароль = ""
	) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// удаляем предыдущий временный каталог сообщений обмена со всеми вложенными файлами
	УдалитьВременныйКаталогСообщенийОбмена(ИмяВременногоКаталогаСообщенийОбмена);
	
	Если ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.COM Тогда
		
		СтруктураДанных = ОбменДаннымиСервер.ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондента(Отказ, УзелИнформационнойБазы, Ложь);
		
	ИначеЕсли ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.WS Тогда
		
		СтруктураДанных = ОбменДаннымиСервер.ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервис(
				Отказ,
				УзелИнформационнойБазы,
				ИдентификаторФайла,
				ДлительнаяОперация,
				ИдентификаторОперации,
				Пароль
		);
		
	Иначе // FILE, FTP, EMAIL
		
		СтруктураДанных = ОбменДаннымиСервер.ПолучитьСообщениеОбменаВоВременныйКаталог(Отказ, УзелИнформационнойБазы, ВидТранспортаСообщенийОбмена,,Ложь);
		
	КонецЕсли;
	
	ИмяВременногоКаталогаСообщенийОбмена = СтруктураДанных.ИмяВременногоКаталогаСообщенийОбмена;
	ИдентификаторФайлаПакетаДанных       = СтруктураДанных.ИдентификаторФайлаПакетаДанных;
	ИмяФайлаСообщенияОбмена              = СтруктураДанных.ИмяФайлаСообщенияОбмена;
	
КонецПроцедуры

// Выполняет загрузку сообщения обмена из сервиса передачи файлов
// во временный каталог пользователя операционной системы
//
Процедура ПолучитьСообщениеОбменаВоВременныйКаталогОкончаниеДлительнойОперации(
			Отказ,
			ИдентификаторФайлаПакетаДанных,
			ИдентификаторФайла,
			Знач Пароль = ""
	) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// удаляем предыдущий временный каталог сообщений обмена со всеми вложенными файлами
	УдалитьВременныйКаталогСообщенийОбмена(ИмяВременногоКаталогаСообщенийОбмена);
	
	СтруктураДанных = ОбменДаннымиСервер.ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервисЗавершениеДлительнойОперации(
		Отказ,
		УзелИнформационнойБазы,
		ИдентификаторФайла,
		Пароль
	);
	
	ИмяВременногоКаталогаСообщенийОбмена = СтруктураДанных.ИмяВременногоКаталогаСообщенийОбмена;
	ИдентификаторФайлаПакетаДанных       = СтруктураДанных.ИдентификаторФайлаПакетаДанных;
	ИмяФайлаСообщенияОбмена              = СтруктураДанных.ИмяФайлаСообщенияОбмена;
	
КонецПроцедуры

// Выполняет анализ входящего сообщения обмена. Заполняет данными таблицу ИнформацияСтатистики
//
// Параметры:
//  Отказ – Булево – флаг отказа; поднимается в случае возникновения ошибок при работе процедуры
//  ПринятьСообщение - Булево - сообщение обмена считается принятым, если загружены все данные из сообщения.
//   Если Истина, то номер входящего сообщения в узле плана обмена устанавливается. Если Ложь, то номер входящего сообщения 
//   не устанавливается, даже если все данные сообщения были успешно загружены.
//
Процедура ВыполнитьАнализСообщенияОбмена(Отказ, ПринятьСообщение = Истина) Экспорт
	
	Если ПустаяСтрока(ИмяВременногоКаталогаСообщенийОбмена) Тогда
        // Не удалось получить данные из другой программы
        Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбработкаОбменаДанными = ОбменДаннымиПовтИсп.ОбработкаОбменаДляЗагрузкиДанных(Отказ, УзелИнформационнойБазы, ИмяФайлаСообщенияОбмена);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаОбменаДанными.ВыполнитьАнализСообщенияОбмена();
	
	Если ОбработкаОбменаДанными.ФлагОшибки() Тогда
		
		НСтрока = НСтр("ru = 'Ошибка: %1'");
		НСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, ОбработкаОбменаДанными.СтрокаСообщенияОбОшибке());
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтрока,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	НомерВходящегоСообщения = ОбработкаОбменаДанными.НомерСообщения();
	
	ИнформацияСтатистики.Загрузить(ОбработкаОбменаДанными.ТаблицаДанныхЗаголовкаПакета());
	
	// дополняем таблицу статистики служебными данными
	ДополнитьТаблицуСтатистики(Отказ);
	
	// определяем строки таблицы с признаком "ОдинКоМногим"
	ИнформацияСтатистикиВременная = ИнформацияСтатистики.Выгрузить(, "ИмяТаблицыПриемника, ЭтоУдалениеОбъекта");
	
	ДобавитьКолонкуСоЗначениемВТаблицу(ИнформацияСтатистикиВременная, 1, "Итератор");
	
	ИнформацияСтатистикиВременная.Свернуть("ИмяТаблицыПриемника, ЭтоУдалениеОбъекта", "Итератор");
	
	Для Каждого СтрокаТаблицы Из ИнформацияСтатистикиВременная Цикл
		
		Если СтрокаТаблицы.Итератор > 1 И Не СтрокаТаблицы.ЭтоУдалениеОбъекта Тогда
			
			Строки = ИнформацияСтатистики.НайтиСтроки(Новый Структура("ИмяТаблицыПриемника, ЭтоУдалениеОбъекта",
				СтрокаТаблицы.ИмяТаблицыПриемника, СтрокаТаблицы.ЭтоУдалениеОбъекта));
			
			Для Каждого Строка Из Строки Цикл
				
				Строка["ОдинКоМногим"] = Истина;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// если загрузка всех данных выполнена, то устанавливаем номер входящего сообщения в узле информационной базы
	Если ПринятьСообщение И ПакетДанныхЗагруженПолностью() Тогда
		
		УстановитьНомерВходящегоСообщенияУзлаИнформационнойБазы(Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции

// Выполняет загрузку данных (таблиц) из сообщения обмена в кэш
// Загружаются только те таблицы, которые ранее не были загружены
// Переменная ОбработкаОбменаДанными содержит (кэширует) ранее загруженные таблицы
//
// Параметры:
//  Нет.
// 
Процедура ВыполнитьЗагрузкуДанныхИзСообщенияОбменаВКэш(Отказ, ИндексыСтрок)
	
	ОбработкаОбменаДанными = ОбменДаннымиПовтИсп.ОбработкаОбменаДляЗагрузкиДанных(Отказ, УзелИнформационнойБазы, ИмяФайлаСообщенияОбмена);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// получаем массив таблиц, которые необходимо пакетно загрузить в кэш платформы
	ТаблицыДляЗагрузки = Новый Массив;
	
	Для Каждого ИндексСтроки Из ИндексыСтрок Цикл
		
		СтрокаТаблицы = ИнформацияСтатистики[ИндексСтроки];
		
		Если Не СтрокаТаблицы.СинхронизироватьПоИдентификатору Тогда
			Продолжить;
		КонецЕсли;
		
		КлючТаблицыДанных = ОбменДаннымиСервер.КлючТаблицыДанных(СтрокаТаблицы.ТипИсточникаСтрокой, СтрокаТаблицы.ТипПриемникаСтрокой, СтрокаТаблицы.ЭтоУдалениеОбъекта);
		
		// таблица данных может быть уже загружена и находиться в кэше обработки ОбработкаОбменаДанными
		ТаблицаДанных = ОбработкаОбменаДанными.ТаблицыДанныхСообщенияОбмена().Получить(КлючТаблицыДанных);
		
		Если ТаблицаДанных = Неопределено Тогда
			
			ТаблицыДляЗагрузки.Добавить(КлючТаблицыДанных);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// выполняем пакетную загрузку таблиц в кэш
	Если ТаблицыДляЗагрузки.Количество() > 0 Тогда
		
		ОбработкаОбменаДанными.ВыполнитьЗагрузкуДанныхВТаблицуЗначений(ТаблицыДляЗагрузки);
		
		Если ОбработкаОбменаДанными.ФлагОшибки() Тогда
			
			НСтрока = НСтр("ru = 'При загрузке сообщения обмена возникли ошибки: %1'");
			НСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, ОбработкаОбменаДанными.СтрокаСообщенияОбОшибке());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтрока,,,, Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьНомерВходящегоСообщенияУзлаИнформационнойБазы(Отказ)
	
	УзелИнформационнойБазыОбъект = УзелИнформационнойБазы.ПолучитьОбъект();
	УзелИнформационнойБазыОбъект.НомерПринятого = НомерВходящегоСообщения;
	УзелИнформационнойБазыОбъект.ДополнительныеСвойства.Вставить("ПолучениеСообщенияОбмена");
	
	Попытка
		УзелИнформационнойБазыОбъект.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),,,, Отказ);
	КонецПопытки;
	
КонецПроцедуры

Процедура УдалитьВременныйКаталогСообщенийОбмена(ИмяВременногоКаталога)
	
	Если Не ПустаяСтрока(ИмяВременногоКаталога) Тогда
		
		Попытка
			УдалитьФайлы(ИмяВременногоКаталога);
			ИмяВременногоКаталога = "";
		Исключение
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьТаблицуСтатистики(Отказ)
	
	Для Каждого СтрокаТаблицы Из ИнформацияСтатистики Цикл
		
		Попытка
			Тип = Тип(СтрокаТаблицы.ТипОбъектаСтрокой);
		Исключение
			
			СтрокаСообщения = НСтр("ru = 'Ошибка: тип ""%1"" не определен.'");
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, СтрокаТаблицы.ТипОбъектаСтрокой);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,,,, Отказ);
			Продолжить;
			
		КонецПопытки;
		
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(Тип);
		
		СтрокаТаблицы.ИмяТаблицыПриемника = МетаданныеОбъекта.ПолноеИмя();
		СтрокаТаблицы.Представление       = МетаданныеОбъекта.Представление();
		
		СтрокаТаблицы.Ключ = Строка(Новый УникальныйИдентификатор());
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьКолонкуСоЗначениемВТаблицу(Таблица, ЗначениеИтератора, ИмяПоляИтератора)
	
	Таблица.Колонки.Добавить(ИмяПоляИтератора);
	
	Таблица.ЗаполнитьЗначения(ЗначениеИтератора, ИмяПоляИтератора);
	
КонецПроцедуры

Функция ПакетДанныхЗагруженПолностью()
	
	ТаблицаУспешныхЗагрузок = ИнформацияСтатистики.Выгрузить(Новый Структура("ДанныеУспешноЗагружены", Истина) ,"ДанныеУспешноЗагружены");
	
	Возврат ТаблицаУспешныхЗагрузок.Количество() = ИнформацияСтатистики.Количество();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции-свойства

// Данные табличной части ИнформацияСтатистики
//
// Тип: ТаблицаЗначений
//
Функция ТаблицаИнформацииСтатистики() Экспорт
	
	Возврат ИнформацияСтатистики.Выгрузить();
	
КонецФункции

#КонецЕсли