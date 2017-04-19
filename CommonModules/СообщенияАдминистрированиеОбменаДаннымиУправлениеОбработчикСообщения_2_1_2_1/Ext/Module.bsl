﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК КАНАЛОВ СООБЩЕНИЙ ДЛЯ ВЕРСИИ 2.1.2.1 ИНТЕРФЕЙСА СООБЩЕНИЙ
//  УПРАВЛЕНИЯ АДМИНИСТРИРОВАНИЕМ ОБМЕНА ДАННЫМИ
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает пространство имен версии интерфейса сообщений
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ExchangeAdministration/Manage";
	
КонецФункции

// Возвращает версию интерфейса сообщений, обслуживаемую обработчиком
Функция Версия() Экспорт
	
	Возврат "2.1.2.1";
	
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
	
	Словарь = СообщенияАдминистрированиеОбменаДаннымиУправлениеИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеПодключитьКорреспондента(Пакет()) Тогда
		ПодключитьКорреспондента(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУстановитьНастройкиТранспорта(Пакет()) Тогда
		УстановитьНастройкиТранспорта(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУдалитьНастройкуСинхронизации(Пакет()) Тогда
		УдалитьНастройкуСинхронизации(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеВыполнитьСинхронизацию(Пакет()) Тогда
		ВыполнитьСинхронизацию(Сообщение, Отправитель);
	Иначе
		СообщениеОбработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПодключитьКорреспондента(Сообщение, Отправитель)
	
	Тело = Сообщение.Body;
	
	// Проверяем эту конечную точку
	ЭтаКонечнаяТочка = ПланыОбмена.ОбменСообщениями.НайтиПоКоду(Тело.SenderId);
	
	Если ЭтаКонечнаяТочка.Пустая()
		ИЛИ ЭтаКонечнаяТочка <> ОбменСообщениямиВнутренний.ЭтотУзел() Тогда
		
		// Отправляем сообщение в менеджер сервиса об ошибке
		ПредставлениеОшибки = НСтр("ru = 'Конечная точка не соответствует ожидаемой. Код ожидаемой конечной точки %1. Код текущей конечной точки %2.'");
		ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеОшибки,
			Тело.SenderId,
			ОбменСообщениямиВнутренний.КодЭтогоУзла());
		
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииПодключениеКорреспондента(),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		
		ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПодключенияКорреспондента());
		ОтветноеСообщение.Body.RecipientId      = Тело.RecipientId;
		ОтветноеСообщение.Body.SenderId         = Тело.SenderId;
		ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
		
		НачатьТранзакцию();
		СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель);
		ЗафиксироватьТранзакцию();
		Возврат;
	КонецЕсли;
	
	// Проверяем то, что корреспондент уже был подключен ранее
	Корреспондент = ПланыОбмена.ОбменСообщениями.НайтиПоКоду(Тело.RecipientId);
	
	Если Корреспондент.Пустая() Тогда // Подключаем конечную точку корреспондента
		
		Отказ = Ложь;
		ПодключенныйКорреспондент = Неопределено;
		
		ОбменСообщениями.ПодключитьКонечнуюТочку(
									Отказ,
									Тело.RecipientURL,
									Тело.RecipientUser,
									Тело.RecipientPassword,
									Тело.SenderURL,
									Тело.SenderUser,
									Тело.SenderPassword,
									ПодключенныйКорреспондент,
									Тело.RecipientName,
									Тело.SenderName);
		
		Если Отказ Тогда // Отправляем сообщение в менеджер сервиса об ошибке
			
			ПредставлениеОшибки = НСтр("ru = 'Ошибка подключения конечной точки корреспондента обмена. Код конечной точки корреспондента обмена %1.'");
			ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеОшибки,
				Тело.RecipientId);
			
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииПодключениеКорреспондента(),
				УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			
			ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
				СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПодключенияКорреспондента());
			ОтветноеСообщение.Body.RecipientId      = Тело.RecipientId;
			ОтветноеСообщение.Body.SenderId         = Тело.SenderId;
			ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
			
			НачатьТранзакцию();
			СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель);
			ЗафиксироватьТранзакцию();
			Возврат;
		КонецЕсли;
		
		ПодключенныйКорреспондентКод = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПодключенныйКорреспондент, "Код");
		
		Если ПодключенныйКорреспондентКод <> Тело.RecipientId Тогда
			
			// Подключили не того корреспондента обмена.
			// Отправляем сообщение в менеджер сервиса об ошибке
			ПредставлениеОшибки = НСтр("ru = 'Ошибка при подключении конечной точки корреспондента обмена.
				|Настройки подключения веб-сервиса не соответствуют ожидаемым.
				|Код ожидаемой конечной точки корреспондента обмена %1.
				|Код подключенной конечной точки корреспондента обмена %2.'");
			ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеОшибки,
				Тело.RecipientId,
				ПодключенныйКорреспондентКод);
			
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииПодключениеКорреспондента(),
				УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			
			ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
				СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПодключенияКорреспондента());
			ОтветноеСообщение.Body.RecipientId      = Тело.RecipientId;
			ОтветноеСообщение.Body.SenderId         = Тело.SenderId;
			ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
			
			НачатьТранзакцию();
			СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель);
			ЗафиксироватьТранзакцию();
			Возврат;
		КонецЕсли;
		
		КорреспондентОбъект = ПодключенныйКорреспондент.ПолучитьОбъект();
		КорреспондентОбъект.Заблокирована = Истина;
		КорреспондентОбъект.Записать();
		
	Иначе // Обновляем настройки подключения этой конечной точки и корреспондента
		
		Отказ = Ложь;
		
		ОбменСообщениями.ОбновитьНастройкиПодключенияКонечнойТочки(
									Отказ,
									Корреспондент,
									Тело.RecipientURL,
									Тело.RecipientUser,
									Тело.RecipientPassword,
									Тело.SenderURL,
									Тело.SenderUser,
									Тело.SenderPassword);
		
		Если Отказ Тогда // Отправляем сообщение в менеджер сервиса об ошибке
			
			ПредставлениеОшибки = НСтр("ru = 'Ошибка обновления параметров подключения этой конечной точки и конечной точки корреспондента обмена.
				|Код этой конечной токи %1
				|Код конечной точки корреспондента обмена %2'");
			ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеОшибки,
				ОбменСообщениямиВнутренний.КодЭтогоУзла(),
				Тело.RecipientId);
			
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииПодключениеКорреспондента(),
				УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			
			ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
				СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПодключенияКорреспондента());
			ОтветноеСообщение.Body.RecipientId      = Тело.RecipientId;
			ОтветноеСообщение.Body.SenderId         = Тело.SenderId;
			ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
			
			НачатьТранзакцию();
			СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель);
			ЗафиксироватьТранзакцию();
			Возврат;
		КонецЕсли;
		
		КорреспондентОбъект = Корреспондент.ПолучитьОбъект();
		КорреспондентОбъект.Заблокирована = Истина;
		КорреспондентОбъект.Записать();
		
	КонецЕсли;
	
	// Отправляем сообщение в менеджер сервиса об успешном выполнении операции
	НачатьТранзакцию();
	ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
		СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс.СообщениеКорреспондентУспешноПодключен());
	ОтветноеСообщение.Body.RecipientId = Тело.RecipientId;
	ОтветноеСообщение.Body.SenderId    = Тело.SenderId;
	СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель);
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура УстановитьНастройкиТранспорта(Сообщение, Отправитель)
	
	Тело = Сообщение.Body;
	
	Корреспондент = ПланыОбмена.ОбменСообщениями.НайтиПоКоду(Тело.RecipientId);
	
	Если Корреспондент.Пустая() Тогда
		СтрокаСообщения = НСтр("ru = 'Не найдена конечная точка корреспондента с кодом ""%1"".'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, Тело.RecipientId);
		ВызватьИсключение СтрокаСообщения;
	КонецЕсли;
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("КонечнаяТочкаКорреспондента", Корреспондент);
	
	СтруктураЗаписи.Вставить("FILEКаталогОбменаИнформацией",       Тело.FILE_ExchangeFolder);
	СтруктураЗаписи.Вставить("FILEСжиматьФайлИсходящегоСообщения", Тело.FILE_CompressExchangeMessage);
	
	СтруктураЗаписи.Вставить("FTPСжиматьФайлИсходящегоСообщения",                  Тело.FTP_CompressExchangeMessage);
	СтруктураЗаписи.Вставить("FTPСоединениеМаксимальныйДопустимыйРазмерСообщения", Тело.FTP_MaxExchangeMessageSize);
	СтруктураЗаписи.Вставить("FTPСоединениеПароль",                                Тело.FTP_Password);
	СтруктураЗаписи.Вставить("FTPСоединениеПассивноеСоединение",                   Тело.FTP_PassiveMode);
	СтруктураЗаписи.Вставить("FTPСоединениеПользователь",                          Тело.FTP_User);
	СтруктураЗаписи.Вставить("FTPСоединениеПорт",                                  Тело.FTP_Port);
	СтруктураЗаписи.Вставить("FTPСоединениеПуть",                                  Тело.FTP_ExchangeFolder);
	
	СтруктураЗаписи.Вставить("ВидТранспортаСообщенийОбменаПоУмолчанию",      Перечисления.ВидыТранспортаСообщенийОбмена[Тело.ExchangeTransport]);
	СтруктураЗаписи.Вставить("КоличествоЭлементовВТранзакцииВыгрузкиДанных", Тело.ExportTransactionQuantity);
	СтруктураЗаписи.Вставить("КоличествоЭлементовВТранзакцииЗагрузкиДанных", Тело.ImportTransactionQuantity);
	СтруктураЗаписи.Вставить("ПарольАрхиваСообщенияОбмена",                  Тело.ExchangeMessagePassword);
	
	РегистрыСведений.НастройкиТранспортаОбменаОбластейДанных.ОбновитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

Процедура УдалитьНастройкуСинхронизации(Сообщение, Отправитель)
	
	Тело = Сообщение.Body;
	
	// Поиск узла по формату кода узла "S00000123"
	Корреспондент = ПланыОбмена[Тело.ExchangePlan].НайтиПоКоду(
		ОбменДаннымиВМоделиСервиса.КодУзлаПланаОбменаВСервисе(Тело.CorrespondentZone));
	Если Корреспондент.Пустая() Тогда
		
		// Поиск узла по формату кода узла "0000123" (старый формат)
		Корреспондент = ПланыОбмена[Тело.ExchangePlan].НайтиПоКоду(
			Формат(Тело.CorrespondentZone,"ЧЦ=7; ЧВН=; ЧГ=0"));
	КонецЕсли;
	
	Если Корреспондент.Пустая() Тогда
		Возврат; // настройка обмена не найдена (возможно, была удалена ранее)
	КонецЕсли;
	
	НастройкиТранспорта = РегистрыСведений.НастройкиТранспортаОбменаОбластиДанных.НастройкиТранспорта(Корреспондент);
	
	Если НастройкиТранспорта <> Неопределено
		И НастройкиТранспорта.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.FILE Тогда
		
		Если Не ПустаяСтрока(НастройкиТранспорта.FILEОбщийКаталогОбменаИнформацией)
			И Не ПустаяСтрока(НастройкиТранспорта.FILEОтносительныйКаталогОбменаИнформацией) Тогда
			
			АбсолютныйКаталогОбменаИнформацией = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
				НастройкиТранспорта.FILEОбщийКаталогОбменаИнформацией,
				НастройкиТранспорта.FILEОтносительныйКаталогОбменаИнформацией);
			
			АбсолютныйКаталог = Новый Файл(АбсолютныйКаталогОбменаИнформацией);
			
			Попытка
				УдалитьФайлы(АбсолютныйКаталог.ПолноеИмя);
			Исключение
				ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
					УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Удаляем узел корреспондента
	Корреспондент.ПолучитьОбъект().Удалить();
	
КонецПроцедуры

Процедура ВыполнитьСинхронизацию(Сообщение, Отправитель)
	
	СценарийОбменаДанными = СериализаторXDTO.ПрочитатьXDTO(Сообщение.Body.Scenario);
	
	Если СценарийОбменаДанными.Количество() > 0 Тогда
		
		// Для совместимости с БСП 2.1.1.
		СценарийОбменаДанными.Колонки.Добавить("ИнициированоПользователем");
		СценарийОбменаДанными.ЗаполнитьЗначения(Истина, "ИнициированоПользователем");
		
		// Запускаем выполнение сценария
		ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВПервойИнформационнойБазе(0, СценарийОбменаДанными);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СобытиеЖурналаРегистрацииПодключениеКорреспондента()
	
	Возврат НСтр("ru = 'Обмен данными.Подключение корреспондента обмена'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции
