﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаЗаписи" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если Параметры.Ключ.ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов Тогда
			
			ВыбраннаяФорма = "РегистрСведений.ПравилаДляОбменаДанными.Форма.ПравилаКонвертацииОбъектов";
			
		ИначеЕсли Параметры.Ключ.ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаРегистрацииОбъектов Тогда
			
			ВыбраннаяФорма = "РегистрСведений.ПравилаДляОбменаДанными.Форма.ПравилаРегистрацииОбъектов";
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Загружает правила в регистр
//
// Параметры:
//	Отказ - Булево - Отказ от записи в регистр
//	Запись - РегистрСведенийЗапись.ПравилаДляОбменаДанными - запись регистра, в которую будут помещены данные
//	АдресВременногоХранилища - Строка - Адрес временного хранилища, из которого будут загружены XML-правила 
//	ИмяФайлаПравил - Строка - Имя файла из которого были загружены файлы(оно также фиксируется в регистре)	
//	ДвоичныеДанные - ДвоичныеДанные - данные, в которые сохраняется XML-файл (в том числе и распакованный из ZIP-архива)
//	ЭтоАрхив - Булево - Признак того, что правила загружаются из ZIP-архива, а не из XML-файла
//
Процедура ЗагрузитьПравила(Отказ, Запись, АдресВременногоХранилища = "", ИмяФайлаПравил = "", ДвоичныеДанные = Неопределено, ЭтоАрхив = Ложь) Экспорт
	
	// проверка заполнения обязательныех полей записи
	ВыполнитьПроверкуЗаполненияПолей(Отказ, Запись);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ДвоичныеДанные = Неопределено Тогда
		
		// получаем двоичные данные правил из файла или макета конфигурации
		Если Запись.ИсточникПравил = Перечисления.ИсточникиПравилДляОбменаДанными.МакетКонфигурации Тогда
			
			ДвоичныеДанные = ПолучитьДвоичныеДанныеИзМакетаКонфигурации(Отказ, Запись.ИмяПланаОбмена, Запись.ИмяМакетаПравил);
			
		Иначе
			
			ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Если это архив, тогда разархивируем его и заново заложим в двоичные данные для дальнейшей работы.
	Если ЭтоАрхив Тогда
		
		// Получаем файл архива из двоичных данных
		ИмяВременногоАрхива = ПолучитьИмяВременногоФайла("zip");
		ДвоичныеДанные.Записать(ИмяВременногоАрхива);
		ВременныйФайлАрхива = Новый Файл(ИмяВременногоАрхива);
		
		// Распаковываем архив
		ИмяВременнойПапки = СтрЗаменить(ВременныйФайлАрхива.ПолноеИмя, ВременныйФайлАрхива.Расширение, "");
		Если ОбменДаннымиСервер.РаспаковатьZipФайл(ИмяВременногоАрхива, ИмяВременнойПапки) Тогда
			
			СписокРаспакованныхФайлов = НайтиФайлы(ИмяВременнойПапки, "*.*", Истина);
			
			// Закладываем полученный файл правил обратно в двоичные данные
			Если СписокРаспакованныхФайлов.Количество() = 1 Тогда
				ДвоичныеДанные = Новый ДвоичныеДанные(СписокРаспакованныхФайлов[0].ПолноеИмя);
				
			// В архиве оказалось несколько файлов, хотя должен быть один - отказываеся от загрузки	
			ИначеЕсли СписокРаспакованныхФайлов.Количество() > 1 Тогда
				НСтрока = НСтр("ru = 'При распаковке архива найдено несколько файлов. Должен быть только один файл с правилами.'");
				ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
				
			// В архиве не было ни одного файла - отказываемся от загрузки
			ИначеЕсли СписокРаспакованныхФайлов.Количество() = 0 Тогда
				НСтрока = НСтр("ru = 'При распаковке архива не найден файл с правилами.'");
				ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
			КонецЕсли;
			
		// Если не удалось распаковать файл - отказываемся от загрузки
		Иначе
			НСтрока = НСтр("ru = 'Не удалось распаковать архив с правилами.'");
			ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
		КонецЕсли;
		
		// Удаляем временный архив и временную папку, в которую был распакован архив
		УдалитьВременныйФайл(ИмяВременнойПапки);
		УдалитьВременныйФайл(ИмяВременногоАрхива);
			
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// получаем имя временного файла в локальной ФС на сервере
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	
	// получаем файл правил для зачитки
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
	Если Запись.ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов Тогда
		
		// зачитываем правила конвертации
		КонвертацияОбъектовИнформационныхБаз = Обработки.КонвертацияОбъектовИнформационныхБаз.Создать();
		
		// свойства обработки
		КонвертацияОбъектовИнформационныхБаз.ИмяПланаОбменаВРО = Запись.ИмяПланаОбмена;
		КонвертацияОбъектовИнформационныхБаз.КлючСообщенияЖурналаРегистрации = ОбменДаннымиСервер.СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными();
		
		
		НастройкиОтладки = ОбменДаннымиСервер.НастройкиРежимаОтладки(Запись.ИмяПланаОбмена);
		
		Если НастройкиОтладки = Неопределено Или ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			
			КонвертацияОбъектовИнформационныхБаз.ОтладкаОбработчиковВыгрузки = Ложь;
			КонвертацияОбъектовИнформационныхБаз.ИмяФайлаВнешнейОбработкиОтладкиВыгрузки = "";
			
		Иначе;
			
			КонвертацияОбъектовИнформационныхБаз.ОтладкаОбработчиковВыгрузки = НастройкиОтладки.РежимОтладкиВыгрузки;
			КонвертацияОбъектовИнформационныхБаз.ИмяФайлаВнешнейОбработкиОтладкиВыгрузки = НастройкиОтладки.ИмяФайлаОбработкиДляОтладкиВыгрузки;
			
		КонецЕсли;
		
		// методы обработки
		ПравилаЗачитанные = КонвертацияОбъектовИнформационныхБаз.ПолучитьСтруктуруПравилОбмена(ИмяВременногоФайла);
		
		ИнформацияОПравилах = КонвертацияОбъектовИнформационныхБаз.ПолучитьИнформациюОПравилах();
		
		Если КонвертацияОбъектовИнформационныхБаз.ФлагОшибки() Тогда
			Отказ = Истина;
		КонецЕсли;
		
	Иначе // ПравилаРегистрацииОбъектов
		
		// зачитываем правила регистрации
		ЗагрузкаПравилРегистрации = Обработки.ЗагрузкаПравилРегистрацииОбъектов.Создать();
		
		// свойства обработки
		ЗагрузкаПравилРегистрации.ИмяПланаОбменаДляЗагрузки = Запись.ИмяПланаОбмена;
		
		// методы обработки
		ЗагрузкаПравилРегистрации.ЗагрузитьПравила(ИмяВременногоФайла);
		
		ПравилаЗачитанные = ЗагрузкаПравилРегистрации.ПравилаРегистрацииОбъектов;
		
		ИнформацияОПравилах = ЗагрузкаПравилРегистрации.ПолучитьИнформациюОПравилах();
		
		Если ЗагрузкаПравилРегистрации.ФлагОшибки Тогда
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	// удаляем временный файл правил
	УдалитьВременныйФайл(ИмяВременногоФайла);
	
	Если Не Отказ Тогда
		
		Запись.ПравилаXML          = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных());
		Запись.ПравилаЗачитанные   = Новый ХранилищеЗначения(ПравилаЗачитанные);
		
		Запись.ИнформацияОПравилах = ИнформацияОПравилах;
		
		Запись.ИмяФайлаПравил = ИмяФайлаПравил;
		
		Запись.ПравилаЗагружены = Истина;
		
		Запись.ИмяПланаОбменаИзПравил = Запись.ИмяПланаОбмена;
		
	КонецЕсли;
	
КонецПроцедуры

// Получает зачитанные правила конвертации объектов из ИБ для плана обмена
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена как объекта метаданных
// 
// Возвращаемое значение:
//  ПравилаЗачитанные - ХранилищеЗначения - зачитанные правила конвертации объектов
//  Неопределено - Если правила конвертации не были загружены в базу для плана обмена
//
Функция ПолучитьЗачитанныеПравилаКонвертацииОбъектов(Знач ИмяПланаОбмена) Экспорт
	
	// возвращаемое значение функции
	ПравилаЗачитанные = Неопределено;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ПравилаДляОбменаДанными.ПравилаЗачитанные КАК ПравилаЗачитанные
	|ИЗ
	|	РегистрСведений.ПравилаДляОбменаДанными КАК ПравилаДляОбменаДанными
	|ГДЕ
	|	  ПравилаДляОбменаДанными.ИмяПланаОбмена = &ИмяПланаОбмена
	|	И ПравилаДляОбменаДанными.ВидПравил      = ЗНАЧЕНИЕ(Перечисление.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов)
	|	И ПравилаДляОбменаДанными.ПравилаЗагружены
	|";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ИмяПланаОбмена", ИмяПланаОбмена);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		ПравилаЗачитанные = Выборка.ПравилаЗачитанные;
		
	КонецЕсли;
	
	Возврат ПравилаЗачитанные;
	
КонецФункции

Процедура ЗагрузитьИнформациюОПравилах(Отказ, АдресВременногоХранилища, СтрокаИнформацииОПравилах) Экспорт
	
	Перем ВидПравил;
	
	СтрокаИнформацииОПравилах = "";
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	// получаем имя временного файла в локальной ФС на сервере
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	
	// получаем файл правил для зачитки
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
	ОпределитьВидПравилДляОбменаДанными(ВидПравил, ИмяВременногоФайла, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов Тогда
		
		// зачитываем правила конвертации
		КонвертацияОбъектовИнформационныхБаз = Обработки.КонвертацияОбъектовИнформационныхБаз.Создать();
		
		КонвертацияОбъектовИнформационныхБаз.ЗагрузитьПравилаОбмена(ИмяВременногоФайла, "XMLФайл",, Истина);
		
		Если КонвертацияОбъектовИнформационныхБаз.ФлагОшибки() Тогда
			Отказ = Истина;
		КонецЕсли;
		
		Если Не Отказ Тогда
			СтрокаИнформацииОПравилах = КонвертацияОбъектовИнформационныхБаз.ПолучитьИнформациюОПравилах();
		КонецЕсли;
		
	Иначе // ПравилаРегистрацииОбъектов
		
		// зачитываем правила регистрации
		ЗагрузкаПравилРегистрации = Обработки.ЗагрузкаПравилРегистрацииОбъектов.Создать();
		
		ЗагрузкаПравилРегистрации.ЗагрузитьПравила(ИмяВременногоФайла, Истина);
		
		Если ЗагрузкаПравилРегистрации.ФлагОшибки Тогда
			Отказ = Истина;
		КонецЕсли;
		
		Если Не Отказ Тогда
			СтрокаИнформацииОПравилах = ЗагрузкаПравилРегистрации.ПолучитьИнформациюОПравилах();
		КонецЕсли;
		
	КонецЕсли;
	
	// удаляем временный файл правил
	УдалитьВременныйФайл(ИмяВременногоФайла);
	
КонецПроцедуры

Функция ПолучитьДвоичныеДанныеИзМакетаКонфигурации(Отказ, ИмяПланаОбмена, ИмяМакета)
	
	// получаем имя временного файла в локальной ФС на сервере
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	
	ПланОбменаМенеджер = ОбменДаннымиПовтИсп.ПолучитьМенеджерПланаОбменаПоИмени(ИмяПланаОбмена);
	
	// получаем макет типовых правил
	Попытка
		МакетПравил = ПланОбменаМенеджер.ПолучитьМакет(ИмяМакета);
	Исключение
		
		СтрокаСообщения = НСтр("ru = 'Ошибка получения макета конфигурации %1 для плана обмена %2'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ИмяМакета, ИмяПланаОбмена);
		ОбменДаннымиСервер.СообщитьОбОшибке(СтрокаСообщения, Отказ);
		Возврат Неопределено;
		
	КонецПопытки;
	
	МакетПравил.Записать(ИмяВременногоФайла);
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
	
	// удаляем временный файл правил
	УдалитьВременныйФайл(ИмяВременногоФайла);
	
	Возврат ДвоичныеДанные;
КонецФункции

Процедура УдалитьВременныйФайл(ИмяВременногоФайла)
	
	Попытка
		Если Не ПустаяСтрока(ИмяВременногоФайла) Тогда
			УдалитьФайлы(ИмяВременногоФайла);
		КонецЕсли;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура ВыполнитьПроверкуЗаполненияПолей(Отказ, Запись)
	
	Если ПустаяСтрока(Запись.ИмяПланаОбмена) Тогда
		
		НСтрока = НСтр("ru = 'Укажите план обмена.'");
		
		ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
		
	ИначеЕсли Запись.ИсточникПравил = Перечисления.ИсточникиПравилДляОбменаДанными.МакетКонфигурации
		    И ПустаяСтрока(Запись.ИмяМакетаПравил) Тогда
		
		НСтрока = НСтр("ru = 'Укажите типовые правила.'");
		
		ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОпределитьВидПравилДляОбменаДанными(ВидПравил, ИмяФайла, Отказ)
	
	// открываем файл для чтения
	Попытка
		Правила = Новый ЧтениеXML();
		Правила.ОткрытьФайл(ИмяФайла);
		Правила.Прочитать();
	Исключение
		Правила = Неопределено;
		
		НСтрока = НСтр("ru = 'Не удалось определить вид правил из-за ошибки в разбора XML-файла [ИмяФайла]. 
		|Возможно выбран не тот файл, либо XML-файл имеет некорректную структуру. Выберите корректный файл.'");
		НСтрока = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(НСтрока, Новый Структура("ИмяФайла", ИмяФайла));
		ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
		Возврат;
	КонецПопытки;
	
	Если Правила.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
		
		Если Правила.ЛокальноеИмя = "ПравилаОбмена" Тогда
			
			ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов;
			
		ИначеЕсли Правила.ЛокальноеИмя = "ПравилаРегистрации" Тогда
			
			ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаРегистрацииОбъектов;
			
		Иначе
			
			НСтрока = НСтр("ru = 'Не удалось определить вид правил из-за ошибки в формате правил XML-файла [ИмяФайла].
			|Возможно выбран не тот файл, либо XML-файл имеет некорректную структуру. Выберите корректный файл.'");
			НСтрока = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(НСтрока, Новый Структура("ИмяФайла", ИмяФайла));
			ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
			
		КонецЕсли;
		
	Иначе
		
		НСтрока = НСтр("ru = 'Не удалось определить вид правил из-за ошибки в формате правил XML-файла [ИмяФайла].
		|Возможно выбран не тот файл, либо XML-файл имеет некорректную структуру. Выберите корректный файл.'");
		НСтрока = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(НСтрока, Новый Структура("ИмяФайла", ИмяФайла));
		ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
		
	КонецЕсли;
	
	Правила.Закрыть();
	Правила = Неопределено;
	
КонецПроцедуры

// Процедура добавляет запись в регистр по переданным значениям структуры
Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "ПравилаДляОбменаДанными");
	
КонецПроцедуры

#КонецЕсли