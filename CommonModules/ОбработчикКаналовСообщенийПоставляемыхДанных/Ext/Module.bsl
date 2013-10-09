﻿////////////////////////////////////////////////////////////////////////////////
// Подписка на уведомления о поступлении новых поставляемых данных
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


// Получает список обработчиков сообщений, которые обрабатывает данная подсистема.
// 
// Параметры:
//  Обработчики - ТаблицаЗначений - состав полей см. в ОбменСообщениями.НоваяТаблицаОбработчиковСообщений
// 
Процедура ПолучитьОбработчикиКаналовСообщений(Знач Обработчики) Экспорт
	
	ДобавитьОбработчикКаналаСообщений("ПоставляемыеДанные\Обновление", ОбработчикКаналовСообщенийПоставляемыхДанных, Обработчики);
	
КонецПроцедуры

// Выполняет обработку тела сообщения из канала в соответствии с алгоритмом текущего канала сообщений
//
// Параметры:
//  <КаналСообщений> (обязательный). Тип:Строка. Идентификатор канала сообщений, из которого получено сообщение.
//  <ТелоСообщения> (обязательный). Тип: Произвольный. Тело сообщения, полученное из канала, которое подлежит обработке.
//  <Отправитель> (обязательный). Тип: ПланОбменаСсылка.ОбменСообщениями. Конечная точка, которая является отправителем сообщения.
//
Процедура ОбработатьСообщение(Знач КаналСообщений, Знач ТелоСообщения, Знач Отправитель) Экспорт
	
	Попытка
		Дескриптор = ДесериализоватьXDTO(ТелоСообщения);
		
		Если КаналСообщений = "ПоставляемыеДанные\Обновление" Тогда
			
			ОбработатьНовыйДескриптор(Дескриптор);
			
		КонецЕсли;
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка обработки сообщения'"), 
			УровеньЖурналаРегистрации.Ошибка, ,
			, ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор) + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
	
КонецПроцедуры

// Обрабатывает новые данные. Вызывается из ОбработатьСообщение и из ПоставляемыеДанные.ЗагрузитьИОбработатьДанные
//
// Параметры
//  Дескриптор - ОбъектXDTO Descriptor
Процедура ОбработатьНовыйДескриптор(Знач Дескриптор) Экспорт
	
	Загружать = Ложь;
	НаборЗаписей = РегистрыСведений.ПоставляемыеДанныеТребующиеОбработки.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторФайла.Установить(Дескриптор.FileGUID);
	
	Для каждого Обработчик Из ПолучитьОбработчики(Дескриптор.DataType) Цикл
		
		ОбработчикЗагружать = Ложь;
		
		Обработчик.Обработчик.ДоступныНовыеДанные(Дескриптор, ОбработчикЗагружать);
		
		Если ОбработчикЗагружать Тогда
			НеобработанныеДанные = НаборЗаписей.Добавить();
			НеобработанныеДанные.ИдентификаторФайла = Дескриптор.FileGUID;
			НеобработанныеДанные.КодОбработчика = Обработчик.КодОбработчика;
			Загружать = Истина;
		КонецЕсли;
		
	КонецЦикла; 
	
	Если Загружать Тогда
		УстановитьПривилегированныйРежим(Истина);
		НаборЗаписей.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗапланироватьЗагрузкуДанных(Дескриптор);
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Доступны новые данные'"), 
		УровеньЖурналаРегистрации.Информация, ,
		, ?(Загружать, НСтр("ru = 'В очередь добавлено задание на загрузку.'"), НСтр("ru = 'Загрузка данных не требуется.'"))
		+ Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор));
		

КонецПроцедуры

// Запланировать загрузку данных, соответствующих дескриптору
//
// Параметры
//   Дескриптор - ОбъектXDTO Descriptor.
//
Процедура ЗапланироватьЗагрузкуДанных(Знач Дескриптор) Экспорт
	Перем ДескрипторXML, ПараметрыМетода;
	
	Если Дескриптор.RecommendedUpdateDate = Неопределено Тогда
		Дескриптор.RecommendedUpdateDate = ТекущаяУниверсальнаяДата();
	КонецЕсли;		
	
	ДескрипторXML = СериализоватьXDTO(Дескриптор);
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(ДескрипторXML);

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ИмяМетода"    , "ОбработчикКаналовСообщенийПоставляемыхДанных.ЗагрузитьДанные");
	ПараметрыЗадания.Вставить("Параметры"    , ПараметрыМетода);
	ПараметрыЗадания.Вставить("Использование", Истина);
	ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", МестноеВремя(Дескриптор.RecommendedUpdateDate));
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
		
	ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания, -1);

КонецПроцедуры

// Произвести загрузку данных, соответствующих дескриптору
//
// Параметры
//   Дескриптор - ОбъектXDTO Descriptor.
//
Процедура ЗагрузитьДанные(Знач ДескрипторXML) Экспорт
	Перем Дескриптор, ИмяФайлаВыгрузки;
	
	Попытка
		Дескриптор = ДесериализоватьXDTO(ДескрипторXML);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка работы с XML'"), 
				УровеньЖурналаРегистрации.Ошибка, ,
				, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
				+ ДескрипторXML);
		Возврат;
	КонецПопытки;

	ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Загрузка данных'"), 
		УровеньЖурналаРегистрации.Информация, ,
		, НСтр("ru = 'Загрузка начата'") + Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор));

	Если ЗначениеЗаполнено(Дескриптор.FileGUID) Тогда
		ИмяФайлаВыгрузки = ПолучитьФайлИзХранилища(Дескриптор);
	
		Если ИмяФайлаВыгрузки = Неопределено Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// РегистрСведений.ПоставляемыеДанныеТребующиеОбработки используется на тот случай, если выполнение
	// цикла было прервано перезагрузкой сервера.
	// В этой ситуации единственный способ сохранить информацию о отработавших обработчиках (если их более 1) - 
	// оперативно записывать их в указанный регистр.
	НаборНеобработанныхДанных = РегистрыСведений.ПоставляемыеДанныеТребующиеОбработки.СоздатьНаборЗаписей();
	НаборНеобработанныхДанных.Отбор.ИдентификаторФайла.Установить(Дескриптор.FileGUID);
	НаборНеобработанныхДанных.Прочитать();
	БылиОшибки = Ложь;
	
	Для каждого Обработчик Из ПолучитьОбработчики(Дескриптор.DataType) Цикл
		ЗаписьНайдена = Ложь;
		Для каждого ЗаписьНеобработанныхДанных Из НаборНеобработанныхДанных Цикл
			Если ЗаписьНеобработанныхДанных.КодОбработчика = Обработчик.КодОбработчика Тогда
				ЗаписьНайдена = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла; 
		
		Если Не ЗаписьНайдена Тогда 
			Продолжить;
		КонецЕсли;
			
		Попытка
			Обработчик.Обработчик.ОбработатьНовыеДанные(Дескриптор, ИмяФайлаВыгрузки);
			НаборНеобработанныхДанных.Удалить(ЗаписьНеобработанныхДанных);
			НаборНеобработанныхДанных.Записать();			
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка обработки'"), 
				УровеньЖурналаРегистрации.Ошибка, ,
				, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
				+ Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор)
				+ Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Код обработчика: %1'"), Обработчик.КодОбработчика));
				
			ЗаписьНеобработанныхДанных.КоличествоПопыток = ЗаписьНеобработанныхДанных.КоличествоПопыток + 1;
			Если ЗаписьНеобработанныхДанных.КоличествоПопыток > 3 Тогда
				УведомитьОбОтменеОбработки(Обработчик, Дескриптор);
				НаборНеобработанныхДанных.Удалить(ЗаписьНеобработанныхДанных);
			Иначе
				БылиОшибки = Истина;
			КонецЕсли;
			НаборНеобработанныхДанных.Записать();			
			
		КонецПопытки;
	КонецЦикла; 
	
	Попытка
		УдалитьФайлы(ИмяФайлаВыгрузки);
	Исключение
	КонецПопытки;
	
	Если БылиОшибки Тогда
		//Откладываем загрузку на 5 минут				
		Дескриптор.RecommendedUpdateDate = ТекущаяУниверсальнаяДата() + 5 * 60;
		ЗапланироватьЗагрузкуДанных(Дескриптор);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка обработки'"), 
			УровеньЖурналаРегистрации.Информация, , ,
			НСтр("ru = 'Обработка данных будет запущена повторно из-за ошибки обработчика.'")
			 + Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор)
			);
	Иначе
		НаборНеобработанныхДанных.Очистить();
		НаборНеобработанныхДанных.Записать();
		
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Загрузка данных'"), 
		УровеньЖурналаРегистрации.Информация, ,
		, НСтр("ru = 'Новые данные обработаны'") + Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор));

	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьСведенияОНеобработанныхДанных(Знач Дескриптор)
	
	НаборНеобработанныхДанных = РегистрыСведений.ПоставляемыеДанныеТребующиеОбработки.СоздатьНаборЗаписей();
	НаборНеобработанныхДанных.Отбор.ИдентификаторФайла.Установить(Дескриптор.FileGUID);
	НаборНеобработанныхДанных.Прочитать();
	
	Для каждого Обработчик Из ПолучитьОбработчики(Дескриптор.DataType) Цикл
		ЗаписьНайдена = Ложь;
		
		Для каждого ЗаписьНеобработанныхДанных Из НаборНеобработанныхДанных Цикл
			Если ЗаписьНеобработанныхДанных.КодОбработчика = Обработчик.КодОбработчика Тогда
				ЗаписьНайдена = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла; 
		
		Если Не ЗаписьНайдена Тогда 
			Продолжить;
		КонецЕсли;
			
		УведомитьОбОтменеОбработки(Обработчик, Дескриптор);
		
	КонецЦикла; 
	НаборНеобработанныхДанных.Очистить();
	НаборНеобработанныхДанных.Записать();
	
КонецПроцедуры

Процедура УведомитьОбОтменеОбработки(Знач Обработчик, Знач Дескриптор)
	
	Попытка
		Обработчик.Обработчик.ОбработкаДанныхОтменена(Дескриптор);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Отмена обработки'"), 
		УровеньЖурналаРегистрации.Информация, ,
		, ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор)
		+ Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Код обработчика: %1'"), Обработчик.КодОбработчика));
	
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Отмена обработки'"), 
			УровеньЖурналаРегистрации.Ошибка, ,
			, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			+ Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор)
			+ Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Код обработчика: %1'"), Обработчик.КодОбработчика));
	КонецПопытки;

КонецПроцедуры

Функция ПолучитьФайлИзХранилища(Знач Дескриптор)
	
	Попытка
		ИмяФайлаВыгрузки = РаботаВМоделиСервиса.ПолучитьФайлИзХранилищаМенеджераСервиса(Дескриптор.FileGUID);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка хранилища'"), 
				УровеньЖурналаРегистрации.Ошибка, ,
				, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
				+ Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор));
				
		//Откладываем загрузку на час				
		Дескриптор.RecommendedUpdateDate = Дескриптор.RecommendedUpdateDate + 60 * 60;
		ЗапланироватьЗагрузкуДанных(Дескриптор);
		Возврат Неопределено;
	КонецПопытки;
	
	// Если файл был заменен или удален между перезапусками функции - 
	// удалим старый план обновления
	Если ИмяФайлаВыгрузки = Неопределено Тогда
		УдалитьСведенияОНеобработанныхДанных(Дескриптор);
	КонецЕсли;
	
	Возврат ИмяФайлаВыгрузки;

КонецФункции

Функция ПолучитьОбработчики(Знач ВидДанных)
	
	Обработчики = Новый ТаблицаЗначений;
	Обработчики.Колонки.Добавить("ВидДанных");
	Обработчики.Колонки.Добавить("Обработчик");
	Обработчики.Колонки.Добавить("КодОбработчика");

	СтандартныеПодсистемыПереопределяемый.ПолучитьОбработчикиПоставляемыхДанных(Обработчики);
	ПоставляемыеДанныеПереопределяемый.ПолучитьОбработчикиПоставляемыхДанных(Обработчики);
	
	Возврат Обработчики.Скопировать(Новый Структура("ВидДанных", ВидДанных), "Обработчик, КодОбработчика");
	
КонецФункции	

Функция СериализоватьXDTO(Знач XDTOОбъект)
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	ФабрикаXDTO.ЗаписатьXML(Запись, XDTOОбъект, , , , НазначениеТипаXML.Явное);
	Возврат Запись.Закрыть();
КонецФункции

Функция ДесериализоватьXDTO(Знач СтрокаXML)
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(СтрокаXML);
	XDTOОбъект = ФабрикаXDTO.ПрочитатьXML(Чтение);
	Чтение.Закрыть();
	Возврат XDTOОбъект;
КонецФункции


// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ДобавитьОбработчикКаналаСообщений(Знач Канал, Знач ОбработчикКанала, Знач Обработчики)
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Канал = Канал;
	Обработчик.Обработчик = ОбработчикКанала;
	
КонецПроцедуры
