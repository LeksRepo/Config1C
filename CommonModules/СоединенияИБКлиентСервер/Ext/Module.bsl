﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Завершение работы пользователей".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Принудительное отключение сеансов.

// Отключает сеанс по номеру сеанса.
//
// Параметры
//  НомерСеанса - Число - номер сеанса для отключения
//  СообщениеОбОшибке - Строка - в этом параметре возвращается текст сообщения об ошибке в случае неудачи
// 
// Возвращаемое значение:
//  Булево – результат отключения сеанса.
//
Функция ОтключитьСеанс(НомерСеанса, СообщениеОбОшибке) Экспорт
	
	Если СоединенияИБВызовСервера.КоличествоСеансовИнформационнойБазы() <= 1 Тогда
		Возврат Истина;// Отключены все пользователи, кроме текущего сеанса
	КонецЕсли;
	
	// Невозможно принудительно отсоединить сеансы в файловом режиме работы
	Если ИнформационнаяБазаФайловая() Тогда
		СообщениеОбОшибке = НСтр("ru = 'Невозможно принудительно завершить сеанс в файловом режиме работы'");
		СоединенияИБВызовСервера.ЗаписатьНазванияСоединенийИБ(СообщениеОбОшибке);
		Возврат Ложь;
	КонецЕсли;
	
#Если НаКлиенте Тогда
	Если ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер()
		Или ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		// Передаем управление на Windows-сервер
		Возврат СоединенияИБВызовСервера.ОтключитьСеанс(НомерСеанса, СообщениеОбОшибке);
	КонецЕсли;
#КонецЕсли
	
	Попытка
		Возврат ЗавершитьСеанс(НомерСеанса);
	Исключение
		СообщениеОбОшибке = НСтр("ru = 'Невозможно принудительно завершить сеанс
			|по причине:
			|%1
			|
			|Возможно не настроены параметры администрирования ИБ.
			|Технические подробности об ошибке см. в Журнале регистрации.'");
		ИнфоОбОшибке = ИнформацияОбОшибке();
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, 
			КраткоеПредставлениеОшибки(ИнфоОбОшибке));
		ЗаписатьСобытие(ПодробноеПредставлениеОшибки(ИнфоОбОшибке), "Ошибка");
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

// Отключить все активные соединения ИБ (кроме текущего сеанса).
//
// Параметры
//  ПараметрыАдминистрированияИБ  – Структура – параметры администрирования ИБ.  
//
// Возвращаемое значение:
//   Булево   – результат отключения соединений.
//
Функция ОтключитьСоединенияИБ(Знач ПараметрыАдминистрированияИБ = Неопределено) Экспорт
	
	Если СоединенияИБВызовСервера.КоличествоСеансовИнформационнойБазы() <= 1 Тогда
		Возврат Истина; // Отключены все пользователи, кроме текущего сеанса
	КонецЕсли;
	
	// Невозможно принудительно отсоединить сеансы в файловом режиме работы
	Если ИнформационнаяБазаФайловая() Тогда
 		СоединенияИБВызовСервера.ЗаписатьНазванияСоединенийИБ(НСтр("ru = 'Невозможно принудительно завершить сеансы в файловом режиме работы'"));
		Возврат Ложь;
	КонецЕсли;
	
#Если НаКлиенте Тогда
	Если ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер()
		Или ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Если СоединенияИБПовтИсп.ПараметрыОтключенияСеансов().WindowsПлатформаНаСервере Тогда
			// Передаем управление на сервер
			Возврат СоединенияИБВызовСервера.ОтключитьСоединенияИБ(ПараметрыАдминистрированияИБ);
		КонецЕсли;
 		СоединенияИБВызовСервера.ЗаписатьНазванияСоединенийИБ(
			НСтр("ru = 'Невозможно принудительно завершить сеансы,
			| если на сервере не установлена ОС Microsoft Windows'"));
		Возврат Ложь;
	КонецЕсли;
#КонецЕсли
	
	Попытка
		Сеансы = ПолучитьАктивныеСеансыИБ(Истина, ПараметрыАдминистрированияИБ);
		Для каждого Сеанс Из Сеансы.Сеансы Цикл
			// Разрываем сеансы с ИБ
			Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Завершается сеанс: %1, компьютер %2, начат %3, режим %4'"),
				Сеанс.UserName,
				Сеанс.Host,
				Сеанс.StartedAt,
				Сеанс.AppID);
			
			ЗаписатьСобытие(Сообщение, "Информация", Ложь);
			Сеансы.АгентСервера.TerminateSession(Сеансы.КластерСерверов, Сеанс);
		КонецЦикла;
		
#Если НаКлиенте Тогда
		КлиентскиеСообщения = СообщенияДляЖурналаРегистрации;
#Иначе
		КлиентскиеСообщения = Неопределено;
#КонецЕсли
		Возврат СоединенияИБВызовСервера.КоличествоСеансовИнформационнойБазы(КлиентскиеСообщения) <= 1;
	Исключение
		ЗаписатьСобытие(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), "Ошибка");
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

// Подключается к кластеру серверов и получает список 
// активных сеансов с использованием указанных параметров администрирования.
//
// Параметры
//  ПараметрыАдминистрированияИБ  – Структура – параметры администрирования ИБ
//  ПодробноеСообщениеОбОшибке    – Булево    – в случае ошибки в текст исключения включается 
//                                              дополнительная информация об ошибке.
//
// Возвращаемое значение:
//   Булево   – Истина, если проверка завершена успешно.
//
Процедура ПроверитьПараметрыАдминистрированияИБ(ПараметрыАдминистрированияИБ,
	Знач ПодробноеСообщениеОбОшибке = Ложь) Экспорт
	
	Попытка
		Если ИнформационнаяБазаФайловая() Тогда
			ВызватьИсключение НСтр("ru = 'Невозможно получить список активных соединений в файловом режиме работы'");
		КонецЕсли;
		
#Если НаКлиенте Тогда
	Если ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер() Тогда
		Если СоединенияИБПовтИсп.ПараметрыОтключенияСеансов().WindowsПлатформаНаСервере Тогда
			// Передаем управление на сервер
			СоединенияИБВызовСервера.ПроверитьПараметрыАдминистрированияИБ(ПараметрыАдминистрированияИБ, ПодробноеСообщениеОбОшибке);
		КонецЕсли;
		// Невозможно выполнить операцию при работе с клиента через веб-сервер,
		// если на сервере не установлена ОС Microsoft Windows
		ВызватьИсключение НСтр("ru = 'Невозможно получить список активных соединений при работе через веб-сервер'");
	КонецЕсли;
#КонецЕсли
		
		Сеансы = ПолучитьАктивныеСеансыИБ(Истина, ПараметрыАдминистрированияИБ);
	Исключение
		Сообщение = НСтр("ru = 'Не удалось подключиться к кластеру серверов.'");
		ЗаписатьСобытие(Сообщение + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), "Ошибка");
		Если ПодробноеСообщениеОбОшибке Тогда
			Сообщение = Сообщение + " " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецЕсли;
		ВызватьИсключение Сообщение;
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Блокировка регламентных заданий.

// Установить или снять блокировку регламентных заданий.
//
// Параметры
//   Значение   – Булево - если Истина, то будет установлена блокировка регламентных заданий
//
Процедура УстановитьБлокировкуРегламентныхЗаданий(Значение) Экспорт
	
	Если ИнформационнаяБазаФайловая() Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно установить блокировку регламентных и фоновых заданий в файловом режиме работы'");
	КонецЕсли;

#Если НаКлиенте Тогда
	Если ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер() Тогда
		Если СоединенияИБПовтИсп.ПараметрыОтключенияСеансов().WindowsПлатформаНаСервере Тогда
			// Передаем управление на сервер
			СоединенияИБВызовСервера.УстановитьБлокировкуРегламентныхЗаданий(Значение);
		КонецЕсли;
 		ВызватьИсключение НСтр("ru = 'Невозможно установить блокировку регламентных и фоновых заданий при работе с клиента через веб-сервер,
			| если на сервере не установлена ОС Microsoft Windows'");
	КонецЕсли;
#КонецЕсли

	Подключение = ПодключитьсяКТекущейИБ();
	Подключение.ТекущаяБаза.ScheduledJobsDenied = Значение;
	Подключение.РабочийПроцесс.UpdateInfoBase(Подключение.ТекущаяБаза);
	
КонецПроцедуры	

// Получить текущее состояние блокировки регламентных заданий.
//
// Возвращаемое значение:
//   Булево   – Истина, если блокировка установлена.
//
Функция БлокировкаРегламентныхЗаданийУстановлена() Экспорт
	
	Если ИнформационнаяБазаФайловая() Тогда
		Возврат Ложь;	
	КонецЕсли;
	
#Если НаКлиенте Тогда
	Если ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер() Тогда
		Если СоединенияИБПовтИсп.ПараметрыОтключенияСеансов().WindowsПлатформаНаСервере Тогда
			// Передаем управление на сервер
			Возврат СоединенияИБВызовСервера.БлокировкаРегламентныхЗаданийУстановлена();
		КонецЕсли;
 		Возврат Ложь;
	КонецЕсли;
#КонецЕсли

	Подключение = ПодключитьсяКТекущейИБ();
	Возврат Подключение.ТекущаяБаза.ScheduledJobsDenied;
		
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Получить строку соединения ИБ, если задан нестандартный порт кластера серверов.
//
// Параметры
//  ПортКластераСерверов  - Число - нестандартный порт кластера серверов
//
// Возвращаемое значение:
//   Строка   - строка соединения ИБ
//
Функция ПолучитьСтрокуСоединенияИнформационнойБазы(Знач ПортКластераСерверов = 0) Экспорт

	Результат = СтрокаСоединенияИнформационнойБазы();
	Если ИнформационнаяБазаФайловая() Или (ПортКластераСерверов = 0) Тогда
		Возврат Результат;
	КонецЕсли;
	
#Если НаКлиенте Тогда
	Если ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер() Тогда
		Возврат Результат;
	КонецЕсли;
#КонецЕсли
	
	ПодстрокиСтрокиСоединения  = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Результат, ";");
	ИмяСервера = СтроковыеФункцииКлиентСервер.СократитьДвойныеКавычки(Сред(ПодстрокиСтрокиСоединения[0], 7));
	ИмяИБ      = СтроковыеФункцииКлиентСервер.СократитьДвойныеКавычки(Сред(ПодстрокиСтрокиСоединения[1], 6));
	Результат  = "Srvr=" + """" + ИмяСервера + 
		?(Найти(ИмяСервера, ":") > 0, "", ":" + Формат(ПортКластераСерверов, "ЧГ=0")) + """;" + 
		"Ref=" + """" + ИмяИБ + """;";
	Возврат Результат;

КонецФункции

// Возвращает полный путь к информационной базе (строку соединения).
//
// Параметры
//  ПризнакФайловогоРежима  - Булево - выходной параметр. Принимает значение 
//                                     Истина, если текущая ИБ - файловая;
//                                     Ложь - если клиент-серверная.
//  ПортКластераСерверов    - Число  - входной параметр. Задается в случае, если
//                                     кластер серверов использует нестандартный номер порта.
//                                     Значение по умолчанию - 0, означает, что 
//                                     кластер серверов занимает номер порта по умолчанию.
//
// Возвращаемое значение:
//   Строка   - строка соединения ИБ.
//
Функция ПутьКИнформационнойБазе(ПризнакФайловогоРежима = Неопределено, Знач ПортКластераСерверов = 0) Экспорт
	
	СтрокаСоединения = ПолучитьСтрокуСоединенияИнформационнойБазы(ПортКластераСерверов);
	
	ПозицияПоиска = Найти(Врег(СтрокаСоединения), "FILE=");
	
	Если ПозицияПоиска = 1 Тогда // файловая ИБ
		
		ПутьКИБ = Сред(СтрокаСоединения, 6, СтрДлина(СтрокаСоединения) - 6);
		ПризнакФайловогоРежима = Истина;
		
	Иначе
		ПризнакФайловогоРежима = Ложь;
		
		ПозицияПоиска = Найти(Врег(СтрокаСоединения), "SRVR=");
		
		Если НЕ (ПозицияПоиска = 1) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПозицияТочкиСЗапятой = Найти(СтрокаСоединения, ";");
		НачальнаяПозицияКопирования = 6 + 1;
		КонечнаяПозицияКопирования = ПозицияТочкиСЗапятой - 2;
		
		ИмяСервера = Сред(СтрокаСоединения, НачальнаяПозицияКопирования, КонечнаяПозицияКопирования - НачальнаяПозицияКопирования + 1);
		
		СтрокаСоединения = Сред(СтрокаСоединения, ПозицияТочкиСЗапятой + 1);
		
		// позиция имени сервера
		ПозицияПоиска = Найти(Врег(СтрокаСоединения), "REF=");
		
		Если НЕ (ПозицияПоиска = 1) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		НачальнаяПозицияКопирования = 6;
		ПозицияТочкиСЗапятой = Найти(СтрокаСоединения, ";");
		КонечнаяПозицияКопирования = ПозицияТочкиСЗапятой - 2;
		
		ИмяИБНаСервере = Сред(СтрокаСоединения, НачальнаяПозицияКопирования, КонечнаяПозицияКопирования - НачальнаяПозицияКопирования + 1);
		
		ПутьКИБ = """" + ИмяСервера + "\" + ИмяИБНаСервере + """";
	КонецЕсли;
	
	Возврат ПутьКИБ;
	
КонецФункции

// Получить пустую структуру параметров администрирования кластера серверов.
//
// Параметры:
//	ИмяАдминистратораИБ - Строка - имя администратора информационной базы.
//	ПарольАдминистратораИБ - Строка - пароль администратора информационной базы. 
//	ИмяАдминистратораКластера - Строка - имя администратора кластера.
//	ПарольАдминистратораКластера - Строка - пароль администратора кластера.
//	ПортКластераСерверов - Число - порт кластера серверов.
//	ПортАгентаСервера - Число - порт агента серверов.
//
// Возвращаемое значение:
//	Структура – структура с полями входящих параметров данной функции.
//
Функция НовыеПараметрыАдминистрированияИБ(Знач ИмяАдминистратораИБ = "", Знач ПарольАдминистратораИБ = "",
	Знач ИмяАдминистратораКластера = "", Знач ПарольАдминистратораКластера = "", 
	Знач ПортКластераСерверов = 0, Знач ПортАгентаСервера = 0) Экспорт
	
	Возврат Новый Структура("ИмяАдминистратораИБ,ПарольАдминистратораИБ,ИмяАдминистратораКластера,
		|ПарольАдминистратораКластера,ПортКластераСерверов,ПортАгентаСервера",
		ИмяАдминистратораИБ,
		ПарольАдминистратораИБ,
		ИмяАдминистратораКластера,
		ПарольАдминистратораКластера,
		ПортКластераСерверов,
		ПортАгентаСервера);
	
КонецФункции

// Возвращает текстовую константу для формирования сообщений.
// Используется в целях локализации.
//
// Возвращаемое значение:
//	Строка - текст для администратора.
//
Функция ТекстДляАдминистратора() Экспорт
	
	Возврат НСтр("ru = 'Для администратора:'");
	
КонецФункции

// Возвращает пользовательский текст сообщения блокировки сеансов.
//
// Параметры:
//	 Сообщение - Строка - полное сообщение.
// 
// Возвращаемое значение:
//	Строка - сообщение блокировки.
//
Функция ИзвлечьСообщениеБлокировки(Знач Сообщение) Экспорт
	
	ИндексМаркера = Найти(Сообщение, ТекстДляАдминистратора());
	Если ИндексМаркера = 0  Тогда
		Возврат Сообщение;
	ИначеЕсли ИндексМаркера >= 3 Тогда
		Возврат Сред(Сообщение, 1, ИндексМаркера - 3);
	Иначе
		Возврат "";
	КонецЕсли;
		
КонецФункции

// Возвращает строковую константу для формирования сообщений журнала регистрации.
//
// Возвращаемое значение:
//   Строка - наименование события для журнала регистрации.
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Завершение работы пользователей'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

// Подключается к агенту сервера.
//
// Параметры:
//	ПараметрыСоединенияССервером1СПредприятие - Структура - параметры соединения с сервером 1С:Предприятие.
//
// Возвращаемое значение - Структура с полями:
//	COMСоединитель - COMОбъект - COMОбъект Com-соединителя.
//  ИмяСервера - Строка - имя сервера.
//	ИмяИБ - Строка - имя информационной базы.
//	АгентСервера - Строка - агент сервера.
//	НомерПортаКластера - Число - номер порта кластера.
//	ИдентификаторАгентаСервера - Строка - идентификатор агента сервера.
//
Функция ПодключитьсяКАгентуСервера(ПараметрыСоединенияССервером1СПредприятие)
	
	ПодстрокиСтрокиСоединения = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
		СтрокаСоединенияИнформационнойБазы(), ";");
	
	СтрокаИмениСервера = СтроковыеФункцииКлиентСервер.СократитьДвойныеКавычки(Сред(ПодстрокиСтрокиСоединения[0], 7));
	ИмяИБ      = СтроковыеФункцииКлиентСервер.СократитьДвойныеКавычки(Сред(ПодстрокиСтрокиСоединения[1], 6));
	
	#Если Клиент Тогда
		COMСоединитель = Новый COMОбъект(СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИмяCOMСоединителя);
	#Иначе
		COMСоединитель = Новый COMОбъект(ОбщегоНазначения.ИмяCOMСоединителя());
	#КонецЕсли
	
	СписокСерверовКластера = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаИмениСервера, ",");
	
	СообщениеОбОшибке = Символы.ПС;
	ШаблонОшибки = Нстр("ru = 'Не удалось подключиться к серверу ""%1"" по причине:
		|%2'");
	
	Для Каждого ИмяСервера Из СписокСерверовКластера Цикл
	
		РазделительПорта = Найти(ИмяСервера, ":");
		Если РазделительПорта > 0 Тогда
			ИмяИПортСервера = ИмяСервера;
			ИмяСервера = Сред(ИмяИПортСервера, 1, РазделительПорта - 1);
			НомерПортаКластера = Число(Сред(ИмяИПортСервера, РазделительПорта + 1));
		ИначеЕсли ПараметрыСоединенияССервером1СПредприятие.ПортКластераСерверов <> 0 Тогда
			НомерПортаКластера = ПараметрыСоединенияССервером1СПредприятие.ПортКластераСерверов;
		Иначе
			НомерПортаКластера = COMСоединитель.RMngrPortDefault;
		КонецЕсли;
		
		ИдентификаторАгентаСервера = ИмяСервера;
		Если ПараметрыСоединенияССервером1СПредприятие.ПортАгентаСервера <> 0 Тогда
			ИдентификаторАгентаСервера = ИдентификаторАгентаСервера + ":" +
			Формат(ПараметрыСоединенияССервером1СПредприятие.ПортАгентаСервера, "ЧГ=0");
		КонецЕсли;
		
		// Подключение к агенту сервера
		Попытка
			
			АгентСервера = COMСоединитель.ConnectAgent(ИдентификаторАгентаСервера);
			Результат = Новый Структура("COMСоединитель,ИмяСервера,ИмяИБ,АгентСервера,НомерПортаКластера,ИдентификаторАгентаСервера");
			Результат.COMСоединитель = COMСоединитель;
			Результат.ИмяСервера = ИмяСервера;
			Результат.ИмяИБ = ИмяИБ;
			Результат.АгентСервера = АгентСервера;
			Результат.НомерПортаКластера = НомерПортаКластера;
			Результат.ИдентификаторАгентаСервера = ИдентификаторАгентаСервера;
			Возврат Результат;
			
		Исключение
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки,
				ИмяСервера, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			СообщениеОбОшибке = СообщениеОбОшибке + ТекстОшибки + Символы.ПС + Символы.ПС;
			
		КонецПопытки;
		
	КонецЦикла;
	
	ВызватьИсключение СообщениеОбОшибке;
	
КонецФункции

// Подключается к рабочему процессу.
//
// Параметры:
//	ПараметрыСоединенияССервером1СПредприятие - Структура - параметры соединения с сервером 1С:Предприятие.
//
// Возвращаемое значение - Структура с полями:
//	COMСоединитель - COMОбъект - COMОбъект Com-соединителя.
//  ИмяСервера - Строка - имя сервера.
//	ИмяИБ - Строка - имя информационной базы.
//	АгентСервера - COMОбъект - агент сервера.
//	НомерПортаКластера - Число - номер порта кластера.
//	ИдентификаторАгентаСервера - Строка - идентификатор агента сервера.
//	РабочийПроцесс - РабочийПроцесс - рабочий процесс.
//
Функция ПодключитьсяКРабочемуПроцессу(ПараметрыСоединенияССервером1СПредприятие)
	
	// Подключение к агенту сервера
	Подключение = ПодключитьсяКАгентуСервера(ПараметрыСоединенияССервером1СПредприятие);
	
	// Найдем необходимый нам кластер
	Для каждого Кластер Из Подключение.АгентСервера.GetClusters() Цикл
		
		Если Кластер.MainPort <> Подключение.НомерПортаКластера Тогда
			Продолжить;
		КонецЕсли;
		
		ПортРабочегоПроцесса = -1;
		Подключение.АгентСервера.Authenticate(Кластер, 
			ПараметрыСоединенияССервером1СПредприятие.ИмяАдминистратораКластера, 
			ПараметрыСоединенияССервером1СПредприятие.ПарольАдминистратораКластера);
		РабочиеПроцессы = Подключение.АгентСервера.GetWorkingProcesses(Кластер);
		Для Каждого РабочийПроцесс Из РабочиеПроцессы Цикл
			Если РабочийПроцесс.Running = 1 Тогда
				ПортРабочегоПроцесса = РабочийПроцесс.MainPort;
				ИмяСервераРабочегоПроцесса = РабочийПроцесс.HostName;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ПортРабочегоПроцесса = -1 Тогда
	 		ВызватьИсключение НСтр("ru = 'Нет ни одного активного рабочего процесса'");
		КонецЕсли;
		Прервать;
		
	КонецЦикла;
	
	ИдентификаторРабочегоПроцесса = ИмяСервераРабочегоПроцесса + ":" + Формат(ПортРабочегоПроцесса, "ЧГ=0");
		
	// Подключение к рабочему процессу
	РабочийПроцесс = Подключение.COMСоединитель.ConnectWorkingProcess(ИдентификаторРабочегоПроцесса);
	Подключение.Вставить("РабочийПроцесс", РабочийПроцесс);
	Возврат Подключение;
	
КонецФункции

// Подключиться к рабочему процессу текущей информационной базы.
//
// Возвращаемое значение - Структура с полями:
//	COMСоединитель - COMОбъект - COMОбъект Com-соединителя.
//  ИмяСервера - Строка - имя сервера.
//	ИмяИБ - Строка - имя информационной базы.
//	АгентСервера - COMОбъект - агент сервера.
//	НомерПортаКластера - Число - номер порта кластера.
//	ИдентификаторАгентаСервера - Строка - идентификатор агента сервера.
//	ТекущаяБаза - IInfoBaseInfo -  информационная база.
//
Функция ПодключитьсяКТекущейИБ()
	
	ПараметрыАдминистрированияИБ = СоединенияИБПовтИсп.ПолучитьПараметрыАдминистрированияИБ();
	Подключение = ПодключитьсяКРабочемуПроцессу(ПараметрыАдминистрированияИБ);
	Подключение.РабочийПроцесс.AddAuthentication(ПараметрыАдминистрированияИБ.ИмяАдминистратораИБ, 
		ПараметрыАдминистрированияИБ.ПарольАдминистратораИБ);
		
	Базы = Подключение.РабочийПроцесс.GetInfoBases();
	ТекущаяБаза = Неопределено;
	Для Каждого База Из Базы Цикл
		Если База.Name = Подключение.ИмяИБ Тогда
			ТекущаяБаза = База;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если ТекущаяБаза = Неопределено Тогда
 		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'База ""%1"" не зарегистрирована в кластере сервером'"), Подключение.ИмяИБ);
	КонецЕсли;
	Подключение.Вставить("ТекущаяБаза", ТекущаяБаза);
	Возврат Подключение;
	
КонецФункции

// Возвращает активные сеансы информационной базы.
//
// Параметры:
//	ВсеКромеТекущего - Булево - Истина, если не считать текущий сеанс.
//	ПараметрыАдминистрированияИБ - Структура - см. НовыеПараметрыАдминистрированияИБ.
//
// Возвращаемое значение - Структура с полями:
//	АгентСервера - COMОбъект - агент сервера.
//	КластерСерверов - COMОбъект - кластер серверов.
//	Сеансы - Массив - активные сеансы.
//
Функция ПолучитьАктивныеСеансыИБ(Знач ВсеКромеТекущего = Истина, Знач ПараметрыАдминистрированияИБ = Неопределено)
	
	Результат = Новый Структура("АгентСервера,КластерСерверов,Сеансы", Неопределено, Неопределено, Новый Массив);
	
	// Подключение к агенту сервера
	Параметры = ПараметрыАдминистрированияИБ;
	Если Параметры = Неопределено Тогда
		Параметры = СоединенияИБПовтИсп.ПолучитьПараметрыАдминистрированияИБ();
	КонецЕсли;
	Подключение = ПодключитьсяКАгентуСервера(Параметры);
	Результат.АгентСервера = Подключение.АгентСервера;
	
	// Найдем необходимый нам кластер
	Для каждого Кластер Из Подключение.АгентСервера.GetClusters() Цикл
		
		Если Кластер.MainPort <> Подключение.НомерПортаКластера Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.КластерСерверов = Кластер;
		Подключение.АгентСервера.Authenticate(Кластер, 
			Параметры.ИмяАдминистратораКластера, 
			Параметры.ПарольАдминистратораКластера);
		
		// Получаем список сеансов
		НомерТекущегоСеанса = СоединенияИБПовтИсп.ПараметрыОтключенияСеансов().НомерСеансаИнформационнойБазы;
		СписокСеансов = Подключение.АгентСервера.GetSessions(Кластер);
		Для Каждого Сеанс из СписокСеансов Цикл
			Если ВРег(Сеанс.InfoBase.Name) <> ВРег(Подключение.ИмяИБ) Тогда
				Продолжить;
			КонецЕсли;
			Если НЕ ВсеКромеТекущего ИЛИ (НомерТекущегоСеанса <> Сеанс.SessionID) Тогда
				Результат.Сеансы.Добавить(Сеанс);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает активные сеансы информационной базы.
//
// Параметры:
//	НомерСеансаДляЗавершения - Число - номер сеанса.
//
// Возвращаемое значение:
//	Булево - Истина, если сеанс удалось завершить. 
//
Функция ЗавершитьСеанс(Знач НомерСеансаДляЗавершения)
	
	Результат = Новый Структура("СоединениеСРабочимПроцессом, Соединения", Неопределено, Новый Массив);
	
	Если ИнформационнаяБазаФайловая() Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно получить список активных соединений в файловом режиме работы'");
	КонецЕсли;
	
#Если НаКлиенте Тогда
	Если ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер() Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно получить список активных соединений при работе через веб-сервер'");
	КонецЕсли;
#КонецЕсли
	
	// Подключение к агенту сервера
	ПараметрыАдминистрированияИБ = СоединенияИБПовтИсп.ПолучитьПараметрыАдминистрированияИБ();
	Подключение = ПодключитьсяКАгентуСервера(ПараметрыАдминистрированияИБ);
	
	// Найдем необходимый нам кластер
	Для Каждого Кластер Из Подключение.АгентСервера.GetClusters() Цикл
		
		Если Кластер.MainPort = Подключение.НомерПортаКластера Тогда
			
			Подключение.АгентСервера.Authenticate(Кластер,
				ПараметрыАдминистрированияИБ.ИмяАдминистратораКластера,
				ПараметрыАдминистрированияИБ.ПарольАдминистратораКластера);
			СписокСеансов = Подключение.АгентСервера.GetSessions(Кластер);
			Для Каждого Сеанс из СписокСеансов Цикл
				Если ВРег(Сеанс.InfoBase.Name) = ВРег(Подключение.ИмяИБ) Тогда
					Если Сеанс.SessionID = НомерСеансаДляЗавершения Тогда
						Подключение.АгентСервера.TerminateSession(Кластер, Сеанс);
						Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Разорван сеанс %1: Пользователь %2, компьютер %3, начат %4, режим %5'"),
								Формат(НомерСеансаДляЗавершения, "ЧГ=0"),
								Сеанс.UserName,
								Сеанс.Host,
								Сеанс.StartedAt,
								Сеанс.AppID);
						ЗаписатьСобытие(Сообщение, "Информация");
						Возврат Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает является ли информационная база файловой.
//
// Возвращаемое значение:
//	Булево - Истина, если информационная база файловая.
//
Функция ИнформационнаяБазаФайловая()
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Результат = ОбщегоНазначения.ИнформационнаяБазаФайловая();
#Иначе
	Результат = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
#КонецЕсли
	Возврат Результат;
КонецФункции

// Записывает событие в журнал регистрации.
//
// Параметры:
//	ТекстСобытия - Строка - текст события.
//  ПредставлениеУровня - Строка - представление уровня.
//  Записать - Булево - Истина, если сразу записать в журнал регистрации.
//
Процедура ЗаписатьСобытие(Знач ТекстСобытия, ПредставлениеУровня = "Информация", Записать = Истина)
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), 
		ПредопределенноеЗначение("УровеньЖурналаРегистрации." + ПредставлениеУровня),,, ТекстСобытия);
#Иначе
	ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(),
		ПредставлениеУровня, ТекстСобытия,,Записать);
#КонецЕсли
КонецПроцедуры			
