﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура-обработчик закрытия формы настройки узлов плана обмена
//
// Параметры:
//  Форма – управляемая форма, из которой вызвана процедура
// 
Процедура ФормаНастройкиУзловКомандаЗакрытьФорму(Форма) Экспорт
	
	Если Не Форма.ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Форма.Модифицированность = Ложь;
	Форма.Закрыть(ВыгрузитьКонтекстИзФормы(Форма));
	
КонецПроцедуры

// Процедура-обработчик закрытия формы настройки узла плана обмена
//
// Параметры:
//  Форма – управляемая форма, из которой вызвана процедура
// 
Процедура ФормаНастройкиУзлаКомандаЗакрытьФорму(Форма) Экспорт
	
	ПриЗакрытииФормыНастройкиУзлаПланаОбмена(Форма, "НастройкаОтборовНаУзле");
	
КонецПроцедуры

// Процедура-обработчик закрытия формы настройки значений по умолчанию узла плана обмена
//
// Параметры:
//  Форма – управляемая форма, из которой вызвана процедура
// 
Процедура ФормаНастройкиЗначенийПоУмолчаниюКомандаЗакрытьФорму(Форма) Экспорт
	
	ПриЗакрытииФормыНастройкиУзлаПланаОбмена(Форма, "ЗначенияПоУмолчаниюНаУзле");
	
КонецПроцедуры

// Процедура-обработчик закрытия формы настройки узла плана обмена
//
// Параметры:
//  Отказ – флаг отказа от закрытия формы
//  Форма – управляемая форма, из которой вызвана процедура
// 
Процедура ФормаНастройкиПередЗакрытием(Отказ, Форма) Экспорт
	
	Если Форма.Модифицированность Тогда
		
		Ответ = Вопрос(НСтр("ru = 'Данные были изменены. Закрыть форму без сохранения изменений?'"), РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
		
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму помощника настройки обмена данными для заданного плана обмена
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, как объекта метаданных, для которого необходимо открыть помощник
// 
Процедура ОткрытьПомощникНастройкиОбменаДанными(Знач ИмяПланаОбмена, НастройкаОбменаССервисом = Ложь) Экспорт
	
	Если Найти(ИмяПланаОбмена, "КорреспондентВМоделиСервиса") > 0 Тогда
		
		ИмяПланаОбмена = СтрЗаменить(ИмяПланаОбмена, "КорреспондентВМоделиСервиса", "");
		
		НастройкаОбменаССервисом = Истина;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ИмяПланаОбмена", ИмяПланаОбмена);
	
	Если НастройкаОбменаССервисом Тогда
		
		ПараметрыФормы.Вставить("НастройкаОбменаССервисом");
		
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ПомощникСозданияОбменаДанными.Форма.Форма", ПараметрыФормы,, ИмяПланаОбмена + НастройкаОбменаССервисом, ВариантОткрытияОкна.ОтдельноеОкно);
	
КонецПроцедуры

// Обработчик начала выбора элемента для формы задания настроек узла базы-корреспондента при настройке обмена через внешнее соединение
//
Процедура ОбработчикВыбораЭлементовБазыКорреспондентаНачалоВыбора(ИмяРеквизита, 
																ИмяТаблицы, 
																Владелец, 
																СтандартнаяОбработка, 
																ПараметрыВнешнегоСоединения
	) Экспорт
	
	НачальноеЗначениеВыбора = "";
	
	Если ТипЗнч(Владелец) = Тип("ТаблицаФормы") Тогда
		
		ТекущиеДанные = Владелец.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда
			
			НачальноеЗначениеВыбора = ТекущиеДанные[ИмяРеквизита + "_Ключ"];
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Владелец) = Тип("УправляемаяФорма") Тогда
		
		НачальноеЗначениеВыбора = Владелец[ИмяРеквизита + "_Ключ"];
		
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",        ПараметрыВнешнегоСоединения);
	ПараметрыФормы.Вставить("ПолноеИмяТаблицыБазыКорреспондента", ИмяТаблицы);
	ПараметрыФормы.Вставить("НачальноеЗначениеВыбора", НачальноеЗначениеВыбора);
	ПараметрыФормы.Вставить("ИмяРеквизита", ИмяРеквизита);
	
	ОткрытьФорму("ОбщаяФорма.ВыборОбъектовИнформационнойБазыКорреспондента", ПараметрыФормы, Владелец);
	
КонецПроцедуры

// Обработчик подбора элементов для формы задания настроек узла базы-корреспондента при настройке обмена через внешнее соединение
//
Процедура ОбработчикВыбораЭлементовБазыКорреспондентаПодбор(ИмяРеквизита, 
														ИмяТаблицы, 
														Владелец, 
														ПараметрыВнешнегоСоединения
	) Экспорт
	
	НачальноеЗначениеВыбора = "";
	
	ТекущиеДанные = Владелец.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		НачальноеЗначениеВыбора = ТекущиеДанные[ИмяРеквизита + "_Ключ"];
		
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",        ПараметрыВнешнегоСоединения);
	ПараметрыФормы.Вставить("ПолноеИмяТаблицыБазыКорреспондента", ИмяТаблицы);
	ПараметрыФормы.Вставить("НачальноеЗначениеВыбора", НачальноеЗначениеВыбора);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("ИмяРеквизита", ИмяРеквизита);
	
	ОткрытьФорму("ОбщаяФорма.ВыборОбъектовИнформационнойБазыКорреспондента", ПараметрыФормы, Владелец);
	
КонецПроцедуры

// Обработчик обработки выбора элемента для формы задания настроек узла базы-корреспондента при настройке обмена через внешнее соединение
//
Процедура ОбработчикВыбораЭлементовБазыКорреспондентаОбработкаВыбора(Элемент, ВыбранноеЗначение, ДанныеФормыКоллекция = Неопределено) Экспорт
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		Если ТипЗнч(Элемент) = Тип("ТаблицаФормы") Тогда
			
			Если ВыбранноеЗначение.РежимПодбора Тогда
				
				Если ДанныеФормыКоллекция <> Неопределено
					И ДанныеФормыКоллекция.НайтиСтроки(Новый Структура(ВыбранноеЗначение.ИмяРеквизита + "_Ключ", ВыбранноеЗначение.Идентификатор)).Количество() > 0 Тогда
					
					Возврат;
					
				КонецЕсли;
				
				Элемент.ДобавитьСтроку();
				
			КонецЕсли;
			
			ТекущиеДанные = Элемент.ТекущиеДанные;
			
			Если ТекущиеДанные <> Неопределено Тогда
				
				ТекущиеДанные[ВыбранноеЗначение.ИмяРеквизита]           = ВыбранноеЗначение.Представление;
				ТекущиеДанные[ВыбранноеЗначение.ИмяРеквизита + "_Ключ"] = ВыбранноеЗначение.Идентификатор;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("УправляемаяФорма") Тогда
			
			Элемент[ВыбранноеЗначение.ИмяРеквизита]           = ВыбранноеЗначение.Представление;
			Элемент[ВыбранноеЗначение.ИмяРеквизита + "_Ключ"] = ВыбранноеЗначение.Идентификатор;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Проверяет установку флага "Использовать" для всех строк таблицы
//
Функция ВТаблицеОтмеченыВсеЭлементы(Таблица) Экспорт
	
	Для Каждого Элемент Из Таблица Цикл
		
		Если Элемент.Использовать = Ложь Тогда
			
			Возврат Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные функции-свойства

// Возвращает максимально допустимое количество полей,
//  которые отображаются в помощнике сопоставления объектов ИБ.
//
// Тип: Число
//
Функция МаксимальноеКоличествоПолейСопоставленияОбъектов() Экспорт
	
	Возврат 5;
	
КонецФункции

// Возвращает структуру статусов выполнения загрузки данных
//
Функция СтраницыСтатусаЗагрузкиДанных() Экспорт
	
	Структура = Новый Структура;
	Структура.Вставить("Неопределено", "СтатусЗагрузкиНеопределено");
	Структура.Вставить("Ошибка",       "СтатусЗагрузкиОшибка");
	Структура.Вставить("Успех",        "СтатусЗагрузкиУспех");
	Структура.Вставить("Выполнение",   "СтатусЗагрузкиВыполнение");
	
	Структура.Вставить("Предупреждение_СообщениеОбменаБылоРанееПринято", "СтатусЗагрузкиПредупреждение");
	Структура.Вставить("ВыполненоСПредупреждениями",                     "СтатусЗагрузкиПредупреждение");
	Структура.Вставить("Ошибка_ТранспортСообщения",                      "СтатусЗагрузкиОшибка");
	
	Возврат Структура;
КонецФункции

// Возвращает структуру статусов выполнения выгрузки данных
//
Функция СтраницыСтатусаВыгрузкиДанных() Экспорт
	
	Структура = Новый Структура;
	Структура.Вставить("Неопределено", "СтатусВыгрузкиНеопределено");
	Структура.Вставить("Ошибка",       "СтатусВыгрузкиОшибка");
	Структура.Вставить("Успех",        "СтатусВыгрузкиУспех");
	Структура.Вставить("Выполнение",   "СтатусВыгрузкиВыполнение");
	
	Структура.Вставить("Предупреждение_СообщениеОбменаБылоРанееПринято", "СтатусВыгрузкиПредупреждение");
	Структура.Вставить("ВыполненоСПредупреждениями",                     "СтатусВыгрузкиПредупреждение");
	Структура.Вставить("Ошибка_ТранспортСообщения",                      "СтатусВыгрузкиОшибка");
	
	Возврат Структура;
КонецФункции

// Возвращает структуру с наименованием гиперссылки поля загрузки данных
//
Функция ЗаголовкиГиперссылокЗагрузкиДанных() Экспорт
	
	Структура = Новый Структура;
	Структура.Вставить("Неопределено",               НСтр("ru = 'Получение данных не выполнялось'"));
	Структура.Вставить("Ошибка",                     НСтр("ru = 'Не удалось получить данные'"));
	Структура.Вставить("ВыполненоСПредупреждениями", НСтр("ru = 'Данные получены с предупреждениями'"));
	Структура.Вставить("Успех",                      НСтр("ru = 'Данные успешно получены'"));
	Структура.Вставить("Выполнение",                 НСтр("ru = 'Выполняется получение данных...'"));
	
	Структура.Вставить("Предупреждение_СообщениеОбменаБылоРанееПринято", НСтр("ru = 'Нет новых данных для получения'"));
	Структура.Вставить("Ошибка_ТранспортСообщения",                      НСтр("ru = 'Не удалось получить данные'"));
	
	Возврат Структура;
КонецФункции

// Возвращает структуру с наименованием гиперссылки поля выгрузки данных
//
Функция ЗаголовкиГиперссылокВыгрузкиДанных() Экспорт
	
	Структура = Новый Структура;
	Структура.Вставить("Неопределено", НСтр("ru = 'Отправка данных не выполнялась'"));
	Структура.Вставить("Ошибка",       НСтр("ru = 'Не удалось отправить данные'"));
	Структура.Вставить("Успех",        НСтр("ru = 'Данные успешно отправлены'"));
	Структура.Вставить("Выполнение",   НСтр("ru = 'Выполняется отправка данных...'"));
	
	Структура.Вставить("Предупреждение_СообщениеОбменаБылоРанееПринято", НСтр("ru = 'Данные отправлены с предупреждениями'"));
	Структура.Вставить("ВыполненоСПредупреждениями",                     НСтр("ru = 'Данные отправлены с предупреждениями'"));
	Структура.Вставить("Ошибка_ТранспортСообщения",                      НСтр("ru = 'Не удалось отправить данные'"));
	
	Возврат Структура;
КонецФункции

// Открывает форму или гиперссылку с подробным описанием синхронизации данных
//
Процедура ОткрытьПодробноеОписаниеСинхронизации(СсылкаНаПодробноеОписание) Экспорт
	
	Если Врег(Лев(СсылкаНаПодробноеОписание, 4)) = "HTTP" Тогда
		
		ПерейтиПоНавигационнойСсылке(СсылкаНаПодробноеОписание);
		
	Иначе
		
		ОткрытьФорму(СсылкаНаПодробноеОписание);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Вызывается при интерактивном начале работы пользователя с областью данных.
//
// Параметры:
//  ПервыйПараметр   - Строка - первое значение параметра запуска,
//                     до первого символа ";" в верхнем регистре.
//  ПараметрыЗапуска – Массив – массив строк разделенных символом ";" в параметре запуска,
//                     переданным в конфигурацию с помощью ключа командной строки /C.
//  Отказ            - Булево (возвращаемое значение), если установить Истина,
//                     обработка события ПриНачалеРаботыСистемы будет прервана.
//
Процедура ПриОбработкеПараметровЗапуска(ПервыйПараметр, ПараметрыЗапуска, Отказ) Экспорт
	
	Если ОбработатьПараметрыЗапуска(ПервыйПараметр, ПараметрыЗапуска) Тогда
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик запуска клиентского сеанса приложения.
// Если выполняется запуск ИБ для подчиненного узла РИБ,
// с необходимостью повтора загрузки сообщения обмена, тогда
// пользователю предлагается принять решение о повторной загрузке
// или продолжении без загрузки.
// 
Процедура ПередНачаломРаботыСистемы(Отказ, ПараметрыКлиента, ОбновитьПараметрыКлиента) Экспорт
	
	Если НЕ ПараметрыКлиента.Свойство("ПовторитьЗагрузкуСообщенияОбменаДаннымиПередЗапуском") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьПараметрыКлиента = Истина;
	
	Результат = ОткрытьФормуМодально(
		"РегистрСведений.НастройкиТранспортаОбмена.Форма.ПовторнаяСинхронизацияДанныхПередЗапуском");
	
	Если Результат <> "Продолжить" Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик запуска клиентского сеанса приложения.
// Если выполняется первый запуск ИБ для подчиненного узла РИБ,
// то открывается форма помощника создания обмена данными.
// 
Процедура ПриНачалеРаботыСистемы(Знач ОбрабатыватьПараметрыЗапуска = Ложь) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если НЕ ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных ИЛИ ПараметрыРаботыКлиента.РазделениеВключено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.ОткрытьПомощникСозданияОбменаДаннымиДляНастройкиПодчиненногоУзла Тогда
		
		ПараметрыФормы = Новый Структура("ИмяПланаОбмена, ЭтоПродолжениеНастройкиВПодчиненномУзлеРИБ", ПараметрыРаботыКлиента.ИмяПланаОбменаРИБ);
		ОткрытьФорму("Обработка.ПомощникСозданияОбменаДанными.Форма.Форма", ПараметрыФормы, , , ВариантОткрытияОкна.ОтдельноеОкно);
		
	ИначеЕсли ПараметрыРаботыКлиента.ПроверитьНеобходимостьОбновленияКонфигурацииПодчиненногоУзла Тогда
		
		ПодключитьОбработчикОжидания("ПроверитьНеобходимостьОбновленияКонфигурацииПодчиненногоУзлаПриЗапуске", 1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции

// Открывает файл в ассоциированном приложении операционной системы
// Каталоги открываются в приложении explorer
//
// Параметры:
//  Объект - объект из которого по имени свойства будет получено имя файла для открытия
//  ИмяСвойства - Строка - имя свойства объекта из которого будет получено имя файла для открытия
//  СтандартнаяОбработка - Булево - флаг стандартной обработки. Устанавливается в значение Ложь.
// 
Процедура ОбработчикОткрытияФайлаИлиКаталога(Объект, ИмяСвойства, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПолноеИмяФайла = Объект[ИмяСвойства];
	
	Если ПустаяСтрока(ПолноеИмяФайла) Тогда
		Возврат;
	КонецЕсли;
	
	// открываем каталог в приложении explorer
	// файл открываем в ассоциированном приложении
	ЗапуститьПриложение(ПолноеИмяФайла);
	
КонецПроцедуры

// Открывает диалог для выбора файлового каталога
//
Процедура ОбработчикВыбораФайловогоКаталога(Объект, ИмяСвойства, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ПодключитьРасширениеРаботыСФайлами() Тогда
		Предупреждение(НСтр("ru = 'Для данной операции необходимо установить расширение работы с файлами.'"));
		Возврат;
	КонецЕсли;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	
	Диалог.Заголовок = НСтр("ru = 'Укажите каталог'");
	Диалог.Каталог   = Объект[ИмяСвойства];
	
	Если Диалог.Выбрать() Тогда
		
		Объект[ИмяСвойства] = Диалог.Каталог;
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает диалог для выбора файла
//
Процедура ОбработчикВыбораФайла(Объект,
								ИмяСвойства,
								СтандартнаяОбработка,
								Фильтр = "",
								ПроверятьСуществованиеФайла = Истина) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ПодключитьРасширениеРаботыСФайлами() Тогда
		Предупреждение(НСтр("ru = 'Для данной операции необходимо установить расширение работы с файлами.'"));
		Возврат;
	КонецЕсли;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	Диалог.Заголовок = НСтр("ru = 'Выберите файл'");
	Диалог.ПолноеИмяФайла = Объект[ИмяСвойства];
	Диалог.МножественныйВыбор          = Ложь;
	Диалог.ПредварительныйПросмотр     = Ложь;
	Диалог.ПроверятьСуществованиеФайла = ПроверятьСуществованиеФайла;
	Диалог.Фильтр                      = Фильтр;
	
	Если Диалог.Выбрать() Тогда
		
		Объект[ИмяСвойства] = Диалог.ПолноеИмяФайла;
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму записи регистра сведений по заданному отбору
// 
Процедура ОткрытьФормуЗаписиРегистраСведенийПоОтбору(
												Отбор,
												ЗначенияЗаполнения,
												Знач ИмяРегистра,
												ФормаВладелец,
												Знач ИмяФормы = "",
												ПараметрыФормы = Неопределено,
												ОткрытьМодально = Ложь) Экспорт
	
	Перем КлючЗаписи;
	
	НаборЗаписейПустой = ОбменДаннымиВызовСервера.НаборЗаписейРегистраПустой(Отбор, ИмяРегистра);
	
	Если Не НаборЗаписейПустой Тогда
		
		ТипЗначения = Тип("РегистрСведенийКлючЗаписи." + ИмяРегистра);
		Параметры = Новый Массив(1);
		Параметры[0] = Отбор;
		
		КлючЗаписи = Новый(ТипЗначения, Параметры);
		
	КонецЕсли;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Ключ",               КлючЗаписи);
	ПараметрыЗаписи.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Если ПараметрыФормы <> Неопределено Тогда
		
		Для Каждого Элемент Из ПараметрыФормы Цикл
			
			ПараметрыЗаписи.Вставить(Элемент.Ключ, Элемент.Значение);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяФормы) Тогда
		
		ПолноеИмяФормы = "РегистрСведений.[ИмяРегистра].ФормаЗаписи";
		ПолноеИмяФормы = СтрЗаменить(ПолноеИмяФормы, "[ИмяРегистра]", ИмяРегистра);
		
	Иначе
		
		ПолноеИмяФормы = "РегистрСведений.[ИмяРегистра].Форма.[ИмяФормы]";
		ПолноеИмяФормы = СтрЗаменить(ПолноеИмяФормы, "[ИмяРегистра]", ИмяРегистра);
		ПолноеИмяФормы = СтрЗаменить(ПолноеИмяФормы, "[ИмяФормы]", ИмяФормы);
		
	КонецЕсли;
	
	// открываем форму записи РС
	Если ОткрытьМодально Тогда
		ОткрытьФормуМодально(ПолноеИмяФормы, ПараметрыЗаписи, ФормаВладелец);
	Иначе
		ОткрытьФорму(ПолноеИмяФормы, ПараметрыЗаписи, ФормаВладелец);
	КонецЕсли;
	
КонецПроцедуры

// Открывает журнал регистрации с отбором по событиям выгрузки или загрузки данных для заданного узла плана обмена
// 
Процедура ПерейтиВЖурналРегистрацииСобытийДанных(УзелИнформационнойБазы, ПараметрыВыполненияКоманды, ДействиеПриОбменеСтрокой) Экспорт
	
	СобытиеЖурналаРегистрации = ОбменДаннымиВызовСервера.ПолучитьКлючСообщенияЖурналаРегистрацииПоСтрокеДействия(УзелИнформационнойБазы, ДействиеПриОбменеСтрокой);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СобытиеЖурналаРегистрации", СобытиеЖурналаРегистрации);
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

// Открывает модально журнал регистрации с отбором по событиям выгрузки или загрузки данных для заданного узла плана обмена
//
Процедура ПерейтиВЖурналРегистрацииСобытийДанныхМодально(УзелИнформационнойБазы, Владелец, ДействиеПриОбмене) Экспорт
	
	// вызов сервера
	ПараметрыФормы = ОбменДаннымиВызовСервера.ПолучитьСтруктуруДанныхОтбораЖурналаРегистрации(УзелИнформационнойБазы, ДействиеПриОбмене);
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", ПараметрыФормы, Владелец);
	
КонецПроцедуры

// Открывает форму выполнения обмена данными для заданного узла плана обмена
//
// Параметры:
//  УзелИнформационнойБазы - ПланОбменаСсылка - узел плана обмена, для которого необходимо открыть форму;
//  Владелец               – форма-владелец для открываемой формы;
// 
Процедура ВыполнитьОбменДаннымиОбработкаКоманды(УзелИнформационнойБазы, Владелец, АдресДляВосстановленияПароляУчетнойЗаписи = "") Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УзелИнформационнойБазы", УзелИнформационнойБазы);
	ПараметрыФормы.Вставить("АдресДляВосстановленияПароляУчетнойЗаписи", АдресДляВосстановленияПароляУчетнойЗаписи);
	
	ОткрытьФорму("Обработка.ВыполнениеОбменаДанными.Форма.Форма", ПараметрыФормы, Владелец, УзелИнформационнойБазы);
	
КонецПроцедуры

// Открывает форму интерактивного выполнения обмена данными для заданного узла плана обмена
//
// Параметры:
//  УзелИнформационнойБазы - ПланОбменаСсылка - узел плана обмена, для которого необходимо открыть форму;
//  Владелец               – форма-владелец для открываемой формы;
//
Процедура ОткрытьПомощникСопоставленияОбъектовОбработкаКоманды(УзелИнформационнойБазы, Владелец) Экспорт
	
	// открываем форму помощника сопоставления объектов;
	// в качестве параметра формы задаем узел информационной базы;
	ПараметрыФормы = Новый Структура("УзелИнформационнойБазы", УзелИнформационнойБазы);
	
	ОткрытьФорму("Обработка.ПомощникИнтерактивногоОбменаДанными.Форма", ПараметрыФормы, Владелец, УзелИнформационнойБазы);
	
КонецПроцедуры

// Открывает форму списка сценариев выполнения обмена данными для заданного узла плана обмена
//
// Параметры:
//  УзелИнформационнойБазы - ПланОбменаСсылка - узел плана обмена, для которого необходимо открыть форму;
//  Владелец               – форма-владелец для открываемой формы;
//
Процедура ОбработкаКомандыНастроитьРасписаниеВыполненияОбмена(УзелИнформационнойБазы, Владелец) Экспорт
	
	ПараметрыФормы = Новый Структура("УзелИнформационнойБазы", УзелИнформационнойБазы);
	
	ОткрытьФорму("Справочник.СценарииОбменовДанными.Форма.НастройкаРасписанияОбменовДанными", ПараметрыФормы, Владелец);
	
КонецПроцедуры

// Обработать параметры запуска
//
// Параметры
//  ЗначениеПараметраЗапуска  – Строка – главный параметр запуска
//  ПараметрыЗапуска          – Массив – дополнительные параметры запуска, разделенные
//                                       символом ";".
//
// Возвращаемое значение:
//   Булево   – Истина, если требуется прекратить выполнение запуска системы.
//
Функция ОбработатьПараметрыЗапуска(Знач ЗначениеПараметраЗапуска, Знач ПараметрыЗапуска) Экспорт
	
	Если НЕ СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске().ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ЗначениеПараметраЗапуска = ВРег("ВыполнитьИнтерактивнуюЗагрузкуДанных") Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ИмяПланаОбмена",            ПараметрыЗапуска[1]);
		ПараметрыФормы.Вставить("КодУзлаИнформационнойБазы", ПараметрыЗапуска[2]);
		
		ОткрытьФормуМодально("Обработка.ПомощникИнтерактивногоОбменаДанными.Форма.Форма", ПараметрыФормы);
		
		// безусловное завершение работы программы
		ЗавершитьРаботуСистемы(Ложь);
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции

// Выполняет запуск приложения 1С:Предприятие, при котором выполняется
// сеанс работы с помощником интерактивной загрузки данных.
// После завершения работы с помощником работа приложения завершается.
//
Процедура ЗапуститьПриложение1СПредприятиеИВыполнитьИнтерактивнуюЗагрузкуДанных(ПараметрыПодключения, ИмяПланаОбмена) Экспорт
	
#Если ВебКлиент Тогда
	
	Предупреждение(НСтр("ru = 'В Веб-клиенте данная возможность не поддерживается'"));
	
#Иначе
	
	КодНовогоУзлаВторойБазы = ОбменДаннымиВызовСервера.ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена);
	
	ПутьКИсполняемомуФайлуПриложения = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогПрограммы(), "1cv8.exe");
	
	Если ПараметрыПодключения.ВариантРаботыИнформационнойБазы = 0 Тогда // файловый
		
		СтрокаКоманды = "%1 ENTERPRISE /F""%2"" /N""%3"" /P""%4"" /CВыполнитьИнтерактивнуюЗагрузкуДанных;%5;%6";
		
		СтрокаКоманды = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаКоманды,
						ПутьКИсполняемомуФайлуПриложения,
						ПараметрыПодключения.КаталогИнформационнойБазы,
						ПараметрыПодключения.ИмяПользователя,
						ПараметрыПодключения.ПарольПользователя,
						ИмяПланаОбмена,
						КодНовогоУзлаВторойБазы);
		
	Иначе // клиент-серверный
		
		СтрокаКоманды = "%1 ENTERPRISE /S%2\%3 /N""%4"" /P""%5"" /CВыполнитьИнтерактивнуюЗагрузкуДанных;%6;%7";
		
		СтрокаКоманды = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаКоманды,
						ПутьКИсполняемомуФайлуПриложения,
						ПараметрыПодключения.ИмяСервера1СПредприятия,
						ПараметрыПодключения.ИмяИнформационнойБазыНаСервере1СПредприятия,
						ПараметрыПодключения.ИмяПользователя,
						ПараметрыПодключения.ПарольПользователя,
						ИмяПланаОбмена,
						КодНовогоУзлаВторойБазы);
		
	КонецЕсли;
	
	ЗапуститьПриложение(СтрокаКоманды,, Истина);
	
#КонецЕсли
	
КонецПроцедуры

// Оповещает все открытые динамические списки о необходимости обновить отображаемые данные.
//
Процедура ОбновитьВсеОткрытыеДинамическиеСписки() Экспорт
	
	Типы = ОбменДаннымиВызовСервера.ВсеСсылочныеТипыКонфигурации();
	
	Для Каждого Тип Из Типы Цикл
		
		ОповеститьОбИзменении(Тип);
		
	КонецЦикла;
	
КонецПроцедуры

// Для внутреннего использования
//
Процедура ВыполнитьОбновлениеИнформационнойБазы(ЗавершениеРаботыСистемы = Ложь) Экспорт
	
	СтандартнаяОбработка = Истина;
	
	ПриВыполненииОбновленияИнформационнойБазы(СтандартнаяОбработка, ЗавершениеРаботыСистемы);
	
	Если СтандартнаяОбработка Тогда
		ОткрытьФорму("ОбщаяФорма.ДополнительноеОписание", Новый Структура("Заголовок,ИмяМакета",
			НСтр("ru = 'Установка обновления'"), "ИнструкцияКакВыполнитьУстановкуОбновленияВручную"));
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму монитора зарегистрированных к отправке данных
//
Процедура ОткрытьСоставОтправляемыхДанных(Знач УзелИнформационнойБазы) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УзелОбмена", УзелИнформационнойБазы);
	ПараметрыФормы.Вставить("ЗапрещеноВыбиратьУзелОбмена", Истина);
	
	ПараметрыФормы.Вставить("ИменаСкрываемыхМетаданных", Новый СписокЗначений);
	ПараметрыФормы.ИменаСкрываемыхМетаданных.Добавить("РегистрСведений.СоответствияОбъектовИнформационныхБаз");
	
	ОткрытьФорму("Обработка.РегистрацияИзмененийДляОбменаДанными.Форма", ПараметрыФормы,, УзелИнформационнойБазы);
КонецПроцедуры

// Выполняет удаление настройки синхронизации данных
//
Процедура УдалитьНастройкуСинхронизации(Знач УзелИнформационнойБазы) Экспорт
	
	Ответ = Вопрос(НСтр("ru = 'Удалить настройку синхронизации данных?'"), РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ОбменДаннымиВызовСервера.УдалитьНастройкуСинхронизации(УзелИнформационнойБазы);
		
		Оповестить("Запись_УзелПланаОбмена");
		
		ЗакрытьФормы("ФормаУзла");
		
	КонецЕсли;
	
КонецПроцедуры

// Закрывает все открытые формы, в имени которых встречается указанная подстрока,
// и у которых не установлен флаг модифицированности.
//
Процедура ЗакрытьФормы(Знач ИмяФормы)
	
	Окна = ПолучитьОкна();
	
	Если Окна <> Неопределено Тогда
		
		Для Каждого Окно Из Окна Цикл
			
			Если Не Окно.Основное Тогда
				
				Форма = Окно.ПолучитьСодержимое();
				
				Если ТипЗнч(Форма) = Тип("УправляемаяФорма")
					И Не Форма.Модифицированность
					И Найти(Форма.ИмяФормы, ИмяФормы) <> 0 Тогда
					
					Форма.Закрыть();
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов из других подсистем

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы

// Обновляет конфигурацию базы данных.
//
// Параметры:
//  СтандартнаяОбработка - Булево - если в процедуре установить данному параметру значение Ложь, то инструкция по
//                                  "ручному" обновлению показана не будет.
Процедура ПриВыполненииОбновленияИнформационнойБазы(СтандартнаяОбработка, ЗавершениеРаботыСистемы = Ложь)
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеКонфигурации") Тогда
		МодульОбновлениеКонфигурацииКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ОбновлениеКонфигурацииКлиент");
		МодульОбновлениеКонфигурацииКлиент.ПриВыполненииОбновленияИнформационнойБазы(СтандартнаяОбработка, ЗавершениеРаботыСистемы);
	КонецЕсли;
	
КонецПроцедуры

// Используется для открытия формы группового изменения объектов.
//
// Параметры:
//  Список - ТаблицаФормы - элемент формы списка, содержащий ссылки на изменяемые объекты.
//
Процедура ПриИзмененииВыделенныхОбъектов(Список) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов") Тогда
		МодульГрупповоеИзменениеОбъектовКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ГрупповоеИзменениеОбъектовКлиент");
		МодульГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Список);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик вызывается при завершении работы помощника создания обмена данными по нажатию в помощнике на кнопку "Готово".
//
// Параметры:
//  <Помощник> 
// Тип: Управляемая форма, Обычная форма.
// Форма помощника создания обмена данными, которая является инициатором события.
//
//  <ЗапуститьМенеджерЗаданий>
// Тип: Булево.
// Признак, показывающий, что необходимо выполнить запуск менеджера заданий (отдельного сеанса 1С:Предприятия)
// для отработки регламентных и фоновых заданий при файловом режиме работы информационной базы.
// Параметр имеет значение Истина, когда в помощнике создания обмена пользователь указал расписание
// и режим работы информационной базы файловый. 
// Если режим работы информационной базы клиент-серверный, то значение параметра всегда Ложь.
//
Процедура ПриЗавершенииРаботыПомощникаСозданияОбмена(Помощник, ЗапуститьМенеджерЗаданий) Экспорт
	
	Если ЗапуститьМенеджерЗаданий Тогда
		Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
			МодульРегламентныеЗаданияСлужебныйГлобальный = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РегламентныеЗаданияСлужебныйГлобальный");
			МодульРегламентныеЗаданияСлужебныйГлобальный.ЗапуститьОтдельныйСеансДляВыполненияРегламентныхЗаданийЧерезОбработчикОжидания();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события открытия инструкции по восстановлению/изменению пароля синхронизации данных
// с автономным рабочим местом.
//
Процедура ПриОткрытииИнструкцииКакИзменитьПарольСинхронизацииДанных(Знач АдресДляВосстановленияПароляУчетнойЗаписи) Экспорт
	
	Если ПустаяСтрока(АдресДляВосстановленияПароляУчетнойЗаписи) Тогда
		
		Предупреждение(НСтр("ru = 'Адрес для восстановления пароля учетной записи не задан.'"));
		
	Иначе
		
		ПерейтиПоНавигационнойСсылке(АдресДляВосстановленияПароляУчетнойЗаписи);
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает отчет о версии или о сравнении версий
//
// Параметры:
//	Ссылка - Ссылка на объект
//	СравниваемыеВерсии - Массив - Содержит массив сравниваемых версий,
//	если версия одна, то открывается отчет о версии
//
Процедура ПриОткрытииФормыОтчетаПоВерсии(Ссылка, СравниваемыеВерсии) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектовКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ВерсионированиеОбъектовКлиент");
		МодульВерсионированиеОбъектовКлиент.ПриОткрытииФормыОтчетаПоВерсии(Ссылка, СравниваемыеВерсии);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции

Функция ВыгрузитьКонтекстИзФормы(Форма)
	
	// возвращаемое значение функции
	Контекст = Новый Структура;
	
	Реквизиты = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Форма.Реквизиты);
	
	Для Каждого Реквизит Из Реквизиты Цикл
		
		Если Найти(Реквизит, ".") > 0 Тогда
			
			Колонки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Реквизит, ".");
			
			Если Колонки.Количество() > 0 Тогда
				
				ИмяТаблицы = Колонки[0];
				
				Колонки.Удалить(0);
				
				КолонкиСтрокой = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(Колонки);
				
				Таблица = Новый Массив;
				
				Для Каждого Элемент Из Форма[ИмяТаблицы] Цикл
					
					СтрокаТаблицы = Новый Структура(КолонкиСтрокой);
					
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Элемент);
					
					Таблица.Добавить(СтрокаТаблицы);
					
				КонецЦикла;
				
				Контекст.Вставить(ИмяТаблицы, Таблица)
				
			КонецЕсли;
			
		Иначе
			
			Контекст.Вставить(Реквизит, Форма[Реквизит])
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Контекст;
КонецФункции

Процедура ПриЗакрытииФормыНастройкиУзлаПланаОбмена(Форма, ИмяРеквизитаФормы)
	
	Если Не Форма.ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого НастройкаОтбора Из Форма[ИмяРеквизитаФормы] Цикл
		
		Если ТипЗнч(Форма[НастройкаОтбора.Ключ]) = Тип("ДанныеФормыКоллекция") Тогда
			
			СтруктураТабличнойЧасти = Форма[ИмяРеквизитаФормы][НастройкаОтбора.Ключ];
			
			Для Каждого Элемент Из СтруктураТабличнойЧасти Цикл
				
				СтруктураТабличнойЧасти[Элемент.Ключ].Очистить();
				
				Для Каждого СтрокаКоллекции Из Форма[НастройкаОтбора.Ключ] Цикл
					
					СтруктураТабличнойЧасти[Элемент.Ключ].Добавить(СтрокаКоллекции[Элемент.Ключ]);
					
				КонецЦикла;
				
			КонецЦикла;
			
		Иначе
			
			Форма[ИмяРеквизитаФормы][НастройкаОтбора.Ключ] = Форма[НастройкаОтбора.Ключ];
			
		КонецЕсли;
		
	КонецЦикла;
	
	Форма.Модифицированность = Ложь;
	Форма.Закрыть(Форма[ИмяРеквизитаФормы]);
	
КонецПроцедуры

