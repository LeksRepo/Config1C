﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Отправка SMS"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Отправляет SMS через веб-сервис МТС, возвращает идентификатор сообщения.
//
// Параметры:
//  НомераПолучателей - Массив - номера получателей в формате +7ХХХХХХХХХХ;
//  Текст 			  - Строка - текст сообщения, длиной не более 480 символов;
//  ИмяОтправителя 	  - Строка - имя отправителя, которое будет отображаться вместо номера входящего SMS;
//  Логин			  - Строка - логин пользователя услуги отправки sms;
//  Пароль			  - Строка - пароль пользователя услуги отправки sms.
//
// Возвращаемое значение:
//  Структура: ОтправленныеСообщения - Массив структур: НомерОтправителя
//                                                  ИдентификаторСообщения
//             ОписаниеОшибки        - Строка - пользовательское представление ошибки, если пустая строка,
//                                          то ошибки нет.
Функция ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя, Логин, Пароль) Экспорт
	
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	// подготовка строки получателей
	СтрокаПолучателей = МассивПолучателейСтрокой(НомераПолучателей);
	
	// проверка на заполнение обязательных параметров
	Если ПустаяСтрока(СтрокаПолучателей) Или ПустаяСтрока(Текст) Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Неверные параметры сообщения'");
		Возврат Результат;
	КонецЕсли;
	
	// подготовка параметров запроса
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("user",	 Логин);
	ПараметрыЗапроса.Вставить("pass",	 Пароль);
	ПараметрыЗапроса.Вставить("gzip",	 "none");
	ПараметрыЗапроса.Вставить("action",	 "post_sms");
	ПараметрыЗапроса.Вставить("message", Текст);
	ПараметрыЗапроса.Вставить("target",	 СтрокаПолучателей);
	ПараметрыЗапроса.Вставить("sender",	 ИмяОтправителя);
	
	// отправка запроса
	ИмяФайлаОтвета = ВыполнитьЗапрос(ПараметрыЗапроса);
	Если ПустаяСтрока(ИмяФайлаОтвета) Тогда
		Результат.ОписаниеОшибки = Результат.ОписаниеОшибки + НСтр("ru = 'Соединение не установлено'");
		Возврат Результат;
	КонецЕсли;		
	
	// обработка результата запроса (получение идентификаторов сообщений)
	СтруктураОтвета = Новый ЧтениеXML;
	СтруктураОтвета.ОткрытьФайл(ИмяФайлаОтвета);
	ОписаниеОшибки = "";
	Пока СтруктураОтвета.Прочитать() Цикл 
		Если СтруктураОтвета.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Если СтруктураОтвета.Имя = "sms" Тогда 
				ИдентификаторСообщения = "";
				НомерПолучателя = "";
				Пока СтруктураОтвета.ПрочитатьАтрибут() Цикл 
					Если СтруктураОтвета.Имя = "id" Тогда 
						ИдентификаторСообщения = СтруктураОтвета.Значение;
					ИначеЕсли СтруктураОтвета.Имя = "phone" Тогда
						НомерПолучателя = СтруктураОтвета.Значение;
					КонецЕсли;
				КонецЦикла;
				Если Не ПустаяСтрока(НомерПолучателя) Тогда
					ОтправленноеСообщение = Новый Структура("НомерПолучателя,ИдентификаторСообщения",
														 НомерПолучателя,ИдентификаторСообщения);
					Результат.ОтправленныеСообщения.Добавить(ОтправленноеСообщение);
				КонецЕсли;
			ИначеЕсли СтруктураОтвета.Имя = "error" Тогда
				СтруктураОтвета.Прочитать();
				ОписаниеОшибки = ОписаниеОшибки + СтруктураОтвета.Значение + Символы.ПС;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	СтруктураОтвета.Закрыть();
	УдалитьФайлы(ИмяФайлаОтвета);
	
	Результат.ОписаниеОшибки = СокрП(ОписаниеОшибки);
	
	Возврат Результат;
	
КонецФункции

// Возвращает текстовое представление статуса доставки сообщения.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный sms при отправке;
//  Логин			- Строка - логин пользователя услуги отправки sms;
//  Пароль			- Строка - пароль пользователя услуги отправки sms.
//
// Возвращаемое значение:
//  Строка - статус доставки. См. описание функции ОтправкаSMS.СтатусДоставки.
Функция СтатусДоставки(ИдентификаторСообщения, Логин, Пароль) Экспорт
	
	// подготовка параметров запроса
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("user",	 Логин);
	ПараметрыЗапроса.Вставить("pass",	 Пароль);
	ПараметрыЗапроса.Вставить("gzip",	 "none");
	ПараметрыЗапроса.Вставить("action",	 "status");
	ПараметрыЗапроса.Вставить("sms_id",	 ИдентификаторСообщения);
	
	// отправка запроса
	ИмяФайлаОтвета = ВыполнитьЗапрос(ПараметрыЗапроса);
	Если ПустаяСтрока(ИмяФайлаОтвета) Тогда
		Возврат "Ошибка";
	КонецЕсли;
	
	// обработка результата запроса
	SMSSTS_CODE = "";
	ТекущийSMS_ID = "";
	СтруктураОтвета = Новый ЧтениеXML;
	СтруктураОтвета.ОткрытьФайл(ИмяФайлаОтвета);
	Пока СтруктураОтвета.Прочитать() Цикл 
		Если СтруктураОтвета.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Если СтруктураОтвета.Имя = "MESSAGE" Тогда 
				Пока СтруктураОтвета.ПрочитатьАтрибут() Цикл 
					Если СтруктураОтвета.Имя = "SMS_ID" Тогда 
						ТекущийSMS_ID = СтруктураОтвета.Значение;
					КонецЕсли;
				КонецЦикла;
			ИначеЕсли СтруктураОтвета.Имя = "SMSSTC_CODE" И ИдентификаторСообщения = ТекущийSMS_ID Тогда
				СтруктураОтвета.Прочитать();
				SMSSTS_CODE = СтруктураОтвета.Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	СтруктураОтвета.Закрыть();
	УдалитьФайлы(ИмяФайлаОтвета);
	
	Возврат СтатусДоставкиSMS(SMSSTS_CODE); 
	
КонецФункции

Функция СтатусДоставкиSMS(СтатусСтрокой)
	СоответствиеСтатусов = Новый Соответствие;
	СоответствиеСтатусов.Вставить("", "НеОтправлялось");
	СоответствиеСтатусов.Вставить("queued", "НеОтправлялось");
	СоответствиеСтатусов.Вставить("wait", "Отправляется");
	СоответствиеСтатусов.Вставить("accepted", "Отправлено");
	СоответствиеСтатусов.Вставить("delivered", "Доставлено");
	СоответствиеСтатусов.Вставить("failed", "НеДоставлено");
	
	Результат = СоответствиеСтатусов[НРег(СтатусСтрокой)];
	Возврат ?(Результат = Неопределено, "Ошибка", Результат);
КонецФункции

Функция ВыполнитьЗапрос(ПараметрыЗапроса)
	
	Результат = "";
	
	ИмяФайлаЗапроса = СформироватьФайлДляPOSTЗапроса(ПараметрыЗапроса);
	ИмяФайлаОтвета = ПолучитьИмяВременногоФайла("xml");
	
	// формирование заголовка
	Заголовок = Новый Соответствие;
	Заголовок.Вставить("Content-Type", "application/x-www-form-urlencoded");
	Заголовок.Вставить("Content-Length", XMLСтрока(РазмерФайла(ИмяФайлаЗапроса)));
	
	// отправка запроса и получение ответа
	Попытка
		Соединение = Новый HTTPСоединение("beeline.amega-inform.ru", , , , ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси("http"), 60);
		Соединение.ОтправитьДляОбработки(ИмяФайлаЗапроса, "/sendsms/", ИмяФайлаОтвета, Заголовок);
		Результат = ИмяФайлаОтвета;
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Отправка SMS'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	УдалитьФайлы(ИмяФайлаЗапроса);
	
	Возврат Результат;
	
КонецФункции

Функция СформироватьФайлДляPOSTЗапроса(ПараметрыЗапроса)
	СтрокаЗапроса = "";
	Для Каждого Параметр Из ПараметрыЗапроса Цикл
		Если Не ПустаяСтрока(СтрокаЗапроса) Тогда
			СтрокаЗапроса = СтрокаЗапроса + "&";
		КонецЕсли;
		СтрокаЗапроса = СтрокаЗапроса + Параметр.Ключ + "=" + КодироватьСтроку(Параметр.Значение, СпособКодированияСтроки.КодировкаURL);
	КонецЦикла;
	
	ИмяФайлаЗапроса = ПолучитьИмяВременногоФайла("txt");
	
	ФайлЗапроса = Новый ЗаписьТекста(ИмяФайлаЗапроса, КодировкаТекста.ANSI);
	ФайлЗапроса.Записать(СтрокаЗапроса);
	ФайлЗапроса.Закрыть();
	
	Возврат ИмяФайлаЗапроса;
КонецФункции

Функция РазмерФайла(ИмяФайла)
    Файл = Новый Файл(ИмяФайла);
    Возврат Файл.Размер();
КонецФункции

Функция МассивПолучателейСтрокой(Массив)
	Результат = "";
	Для Каждого Элемент Из Массив Цикл
		Номер = ФорматироватьНомер(Элемент);
		Если НЕ ПустаяСтрока(Номер) Тогда 
			Если Не ПустаяСтрока(Результат) Тогда
				Результат = Результат + ",";
			КонецЕсли;
			Результат = Результат + Номер;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ФорматироватьНомер(Номер)
	Результат = "";
	ДопустимыеСимволы = "+1234567890";
	Для Позиция = 1 По СтрДлина(Номер) Цикл
		Символ = Сред(Номер,Позиция,1);
		Если Найти(ДопустимыеСимволы, Символ) > 0 Тогда
			Результат = Результат + Символ;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;	
КонецФункции
