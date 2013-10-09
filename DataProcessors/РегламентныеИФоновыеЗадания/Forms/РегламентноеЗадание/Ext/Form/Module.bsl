﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа.
		                             |
		                             |Изменение свойств регламентного задания
		                             |выполняется только администраторами.'");
	КонецЕсли;
	
	Действие = Параметры.Действие;
	
	Если Найти(", Добавить, Скопировать, Изменить,", ", " + Действие + ",") = 0 Тогда
		
		ВызватьИсключение НСтр("ru = 'Неверные параметры открытия формы ""Регламентное задание"".'");
	КонецЕсли;
	
	Элементы.ИмяПользователя.Доступность = НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	Если Действие = "Добавить" Тогда
		
		Расписание = Новый РасписаниеРегламентногоЗадания;
		
		Для каждого РегламентноеЗаданиеМетаданные ИЗ Метаданные.РегламентныеЗадания Цикл
			ОписанияМетаданныхРегламентныхЗаданий.Добавить(
				РегламентноеЗаданиеМетаданные.Имя
					+ Символы.ПС
					+ РегламентноеЗаданиеМетаданные.Синоним
					+ Символы.ПС
					+ РегламентноеЗаданиеМетаданные.ИмяМетода,
				?(ПустаяСтрока(РегламентноеЗаданиеМетаданные.Синоним),
				  РегламентноеЗаданиеМетаданные.Имя,
				  РегламентноеЗаданиеМетаданные.Синоним) );
		КонецЦикла;
	Иначе
		Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(Параметры.Идентификатор);
		ЗаполнитьЗначенияСвойств(
			ЭтаФорма,
			Задание,
			"Ключ,
			|Предопределенное,
			|Использование,
			|Наименование,
			|ИмяПользователя,
			|ИнтервалПовтораПриАварийномЗавершении,
			|КоличествоПовторовПриАварийномЗавершении");
		
		Идентификатор = Строка(Задание.УникальныйИдентификатор);
		Если Задание.Метаданные = Неопределено Тогда
			ИмяМетаданных        = НСтр("ru = '<нет метаданных>'");
			СинонимМетаданных    = НСтр("ru = '<нет метаданных>'");
			ИмяМетодаМетаданных  = НСтр("ru = '<нет метаданных>'");
		Иначе
			ИмяМетаданных        = Задание.Метаданные.Имя;
			СинонимМетаданных    = Задание.Метаданные.Синоним;
			ИмяМетодаМетаданных  = Задание.Метаданные.ИмяМетода;
		КонецЕсли;
		Расписание = Задание.Расписание;
		
		СообщенияПользователюИОписаниеИнформацииОбОшибке = РегламентныеЗаданияСлужебный
			.СообщенияИОписанияОшибокРегламентногоЗадания(Задание);
	КонецЕсли;
	
	Если Действие <> "Изменить" Тогда
		Идентификатор = НСтр("ru = '<будет создан при записи>'");
		Использование = Ложь;
		
		Наименование = ?(
			Действие = "Добавить",
			"",
			РегламентныеЗаданияСлужебный.ПредставлениеРегламентногоЗадания(Задание));
	КонецЕсли;
	
	// Заполнение списка выбора имени пользователя.
	МассивПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	Для каждого Пользователь Из МассивПользователей Цикл
		Элементы.ИмяПользователя.СписокВыбора.Добавить(Пользователь.Имя);
	КонецЦикла;
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Действие = "Добавить" Тогда
		
		// Выбор шаблона регламентного задания (метаданные).
		ЭлементСписка = ОписанияМетаданныхРегламентныхЗаданий.ВыбратьЭлемент(
			НСтр("ru = 'Выберите шаблон регламентного задания'"));
		
		Если ЭлементСписка = Неопределено Тогда
			Отказ = Истина;
			Возврат;
		Иначе
			ИмяМетаданных       = СтрПолучитьСтроку(ЭлементСписка.Значение, 1);
			СинонимМетаданных   = СтрПолучитьСтроку(ЭлементСписка.Значение, 2);
			ИмяМетодаМетаданных = СтрПолучитьСтроку(ЭлементСписка.Значение, 3);
			Наименование        = ЭлементСписка.Представление;
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьЗаголовокФормы();

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ЗапроситьПодтверждениеЗакрытияФормы(Отказ, Модифицированность);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьРегламентноеЗадание();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ЗаписатьРегламентноеЗадание();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеВыполнить()

	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	
	Если Диалог.ОткрытьМодально() Тогда
		Расписание = Диалог.Расписание;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ЗаписатьРегламентноеЗадание()
	
	ЗаписатьРегламентноеЗаданиеНаСервере();
	ОбновитьЗаголовокФормы();
	Оповестить("Запись_РегламентныеИФоновыеЗадания", Параметры.Идентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРегламентноеЗаданиеНаСервере()
	
	Если Действие = "Изменить" Тогда
		Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(Идентификатор);
	Иначе
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(
			Метаданные.РегламентныеЗадания[ИмяМетаданных]);
		
		Идентификатор = Строка(Задание.УникальныйИдентификатор);
		Действие = "Изменить";
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		Задание,
		ЭтаФорма,
		"Ключ, 
		|Наименование,
		|Использование,
		|ИмяПользователя,
		|ИнтервалПовтораПриАварийномЗавершении,
		|КоличествоПовторовПриАварийномЗавершении");
	
	Задание.Расписание = Расписание;
	Задание.Записать();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокФормы()
	
	Если НЕ ПустаяСтрока(Наименование) Тогда
		Представление = Наименование;
		
	ИначеЕсли НЕ ПустаяСтрока(СинонимМетаданных) Тогда
		Представление = СинонимМетаданных;
	Иначе
		Представление = ИмяМетаданных;
	КонецЕсли;
	
	Если Действие = "Изменить" Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (Регламентное задание)'"), Представление);
	Иначе
		Заголовок = НСтр("ru = 'Регламентное задание (создание)'");
	КонецЕсли;
	
КонецПроцедуры
