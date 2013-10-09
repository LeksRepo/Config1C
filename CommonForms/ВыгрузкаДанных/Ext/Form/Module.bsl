﻿&НаКлиенте
Перем ИтерацияПроверки;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ТекстЗаголовкаФормы = НСтр("ru = 'Выгрузить данные в локальную версию'");
		ТекстСообщения      = НСтр("ru = 'Данные из сервиса будут выгружены в файл для последующей их загрузки
			|и использования в локальной версии.'");
	Иначе
		ТекстЗаголовкаФормы = НСтр("ru = 'Выгрузить данные для перехода в сервис'");
		ТекстСообщения      = НСтр("ru = 'Данные из локальной версии будут выгружены в файл для последующей их загрузки
			|и использования в режиме сервиса.'");
	КонецЕсли;
	Элементы.ДекорацияПредупреждение.Заголовок = ТекстСообщения;
	Заголовок = ТекстЗаголовкаФормы;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОткрытьФормуАктивныхПользователей(Команда)
	
	ОткрытьФорму("Обработка.АктивныеПользователи.Форма.ФормаСпискаАктивныхПользователей");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая Тогда
		
		ПодготовитьВыгрузкуДанных();
		СохранитьФайлВыгрузки();
	Иначе
		
		ЗапуститьВыгрузкуДанных();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьВыгрузкуДанных()
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ВыгрузкаЗагрузкаДанных.ВыгрузитьТекущуюОбластьВоВременноеХранилище(АдресХранилища);
	
КонецПроцедуры

&НаКлиенте 
Процедура СохранитьФайлВыгрузки()
	
	НазваниеФайла = "data_dump.zip";
	
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		
		ПолучаемыеФайлы = Новый Массив;
		
		ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		ДиалогВыбора.Фильтр = "ZIP архив(*.zip)|*.zip";
		ДиалогВыбора.Расширение = "zip";
		ДиалогВыбора.ПолноеИмяФайла = НазваниеФайла;
		
		Если ДиалогВыбора.Выбрать() Тогда
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ДиалогВыбора.ПолноеИмяФайла, АдресХранилища);
			ПолучаемыеФайлы.Добавить(ОписаниеФайла);
			
			ПолучитьФайлы(ПолучаемыеФайлы, , , Ложь);
			
		КонецЕсли;
		
	Иначе
		
		ПолучитьФайл(АдресХранилища, НазваниеФайла, Истина);
		
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьВыгрузкуДанных()
	
	ЗапуститьВыгрузкуДанныхНаСервере();
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Выгрузка;
	
	ИтерацияПроверки = 1;
	
	ПодключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки", 15);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьГотовностьВыгрузки()
	
	Попытка
		ГотовностьВыгрузки = ВыгрузкаГотова();
	Исключение
		ОтключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки");
		ВызватьИсключение;
	КонецПопытки;
	
	Если ГотовностьВыгрузки Тогда
		ОтключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки");
		СохранитьФайлВыгрузки();
	Иначе
		
		ИтерацияПроверки = ИтерацияПроверки + 1;
		
		Если ИтерацияПроверки = 3 Тогда
			ОтключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки");
			ПодключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки", 30);
		ИначеЕсли ИтерацияПроверки = 4 Тогда
			ОтключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки");
			ПодключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки", 60);
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиЗаданиеПоИдентификатору(Идентификатор)
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	
	Возврат Задание;
	
КонецФункции

&НаСервере
Функция ВыгрузкаГотова()
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	
	Если Задание <> Неопределено
		И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Предупреждение;
	
	Если Задание = Неопределено Тогда
		ВызватьИсключение(НСтр("ru = 'При подготовке выгрузки произошла ошибка - не найдено задание подготавливающее выгрузку.'"));
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		ОшибкаЗадания = Задание.ИнформацияОбОшибке;
		Если ОшибкаЗадания <> Неопределено Тогда
			ВызватьИсключение(ПодробноеПредставлениеОшибки(ОшибкаЗадания));
		Иначе
			ВызватьИсключение(НСтр("ru = 'При подготовке выгрузки произошла ошибка - задание подготавливающее выгрузку завершилось с неизвестной ошибкой.'"));
		КонецЕсли;
	ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
		ВызватьИсключение(НСтр("ru = 'При подготовке выгрузки произошла ошибка - задание подготавливающее выгрузку было отменено администратором.'"));
	Иначе
		ИдентификаторЗадания = Неопределено;
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗапуститьВыгрузкуДанныхНаСервере()
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(АдресХранилища);
	
	Задание = ФоновыеЗадания.Выполнить("ВыгрузкаЗагрузкаДанных.ВыгрузитьТекущуюОбластьВоВременноеХранилище", 
		ПараметрыЗадания,
		,
		НСтр("ru = 'Подготовка выгрузки области данных'"));
		
	ИдентификаторЗадания = Задание.УникальныйИдентификатор;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьЗаданиеПодготовки(ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьЗаданиеПодготовки(Знач ИдентификаторЗадания)
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	Если Задание = Неопределено
		ИЛИ Задание.Состояние <> СостояниеФоновогоЗадания.Активно Тогда
		
		Возврат;
	КонецЕсли;
	
	Попытка
		Задание.Отменить();
	Исключение
		// Возможно задание как раз в этот момент закончилось и ошибки нет
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отмена выполнения задания подготовки выгрузки области данных'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры
