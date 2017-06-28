﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Включать и отключать синхронизацию данных может только администратор обмена (для абонента).
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	Если Не ОбменДаннымиВМоделиСервисаПовтИсп.СинхронизацияДанныхПоддерживается() Тогда
		
		ВызватьИсключение НСтр("ru = 'Синхронизация данных для конфигурации не поддерживается!'");
		
	КонецЕсли;
	
	СобытиеЖурналаРегистрацииМониторСинхронизацииДанных = ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииМониторСинхронизацииДанных();
	
	СценарийПолученияНастроекСинхронизации();
	
	Элементы.НастройкиСинхронизацииДанныхОтключитьСинхронизациюДанных.Доступность = Ложь;
	Элементы.НастройкиСинхронизацииДанныхКонтекстноеМенюОтключитьСинхронизациюДанных.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Позиционируемся на втором шаге помощника
	УстановитьПорядковыйНомерПерехода(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Создание_СинхронизацияДанных"
		ИЛИ ИмяСобытия = "Отключение_СинхронизацияДанных" Тогда
		
		ОбновитьМонитор();
		
	ИначеЕсли ИмяСобытия = "ЗакрытаФормаРезультатовОбменаДанными" Тогда
		
		ОбновитьНастройкиСинхронизацииДанных();
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчики ожидания

&НаКлиенте
Процедура ОбработчикОжиданияДлительнойОперации()
	
	Попытка
		СтатусСессии = СтатусСессии(Сессия);
	Исключение
		ЗаписатьОшибкуВЖурналРегистрации(
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), СобытиеЖурналаРегистрацииМониторСинхронизацииДанных);
		ПерейтиНазад();
		Возврат;
	КонецПопытки;
	
	Если СтатусСессии = "Успешно" Тогда
		
		ПерейтиДалее();
		
	ИначеЕсли СтатусСессии = "Ошибка" Тогда
		
		ПерейтиНазад();
		Возврат;
		
	Иначе
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОтправитьДанные(Команда)
	// Добавить к выгружаемым данным новые
	
	ДанныеПриложения = Элементы.НастройкиСинхронизацииДанных.ТекущиеДанные;
	Если ДанныеПриложения=Неопределено Или Не ДанныеПриложения.СинхронизацияНастроена Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ПомощникИнтерактивногоОбменаДаннымиВМоделиСервиса.Форма.Форма",
		Новый Структура("ЗапретитьВыгрузкуТолькоИзмененного, УзелИнформационнойБазы", 
			Истина, ДанныеПриложения.Корреспондент
		), ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСинхронизациюДанных(Команда)
	
	ПерейтиДалее();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСинхронизациюДанных(Команда)
	
	ВыполнитьНастройкуСинхронизацииДанных(Элементы.НастройкиСинхронизацииДанных.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьСинхронизациюДанных(Команда)
	
	ТекущиеДанные = Элементы.НастройкиСинхронизацииДанных.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено
		И ТекущиеДанные.СинхронизацияНастроена Тогда
		
		Если ТекущиеДанные.НастройкаСинхронизацииВМенеджереСервиса Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Для отключения синхронизации данных перейдите в менеджер сервиса.
				|В менеджере сервиса воспользуйтесь командой ""Синхронизация данных"".'"));
		Иначе
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ИмяПланаОбмена",              ТекущиеДанные.ПланОбмена);
			ПараметрыФормы.Вставить("ОбластьДанныхКорреспондента", ТекущиеДанные.ОбластьДанных);
			ПараметрыФормы.Вставить("НаименованиеКорреспондента",  ТекущиеДанные.НаименованиеПриложения);
			
			ОткрытьФорму("Обработка.ПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете.Форма.ОтключениеСинхронизацииДанных", ПараметрыФормы, ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьМонитор();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиСинхронизацииДанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыполнитьНастройкуСинхронизацииДанных(Элементы.НастройкиСинхронизацииДанных.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиСинхронизацииДанныхПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные=Неопределено Тогда
		Элементы.НастройкиСинхронизацииДанныхОтключитьСинхронизациюДанных.Доступность = Ложь;
		Элементы.НастройкиСинхронизацииДанныхКонтекстноеМенюОтключитьСинхронизациюДанных.Доступность = Ложь;
		НастройкиСинхронизацииДанныхОписание = "";
		
		Элементы.НастройкиСинхронизацииДанныхПодготовитьДанные.Доступность = Ложь;
		Элементы.НастройкиСинхронизацииДанныхКонтекстноеМенюОтправитьДанные.Доступность = Ложь;
	Иначе		
		Элементы.НастройкиСинхронизацииДанныхОтключитьСинхронизациюДанных.Доступность = ТекущиеДанные.СинхронизацияНастроена;
		Элементы.НастройкиСинхронизацииДанныхКонтекстноеМенюОтключитьСинхронизациюДанных.Доступность = ТекущиеДанные.СинхронизацияНастроена;
		НастройкиСинхронизацииДанныхОписание = ТекущиеДанные.Описание;
		
		Элементы.НастройкиСинхронизацииДанныхПодготовитьДанные.Доступность = ТекущиеДанные.СинхронизацияНастроена;
		Элементы.НастройкиСинхронизацииДанныхКонтекстноеМенюОтправитьДанные.Доступность = ТекущиеДанные.СинхронизацияНастроена;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиККонфликтам(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УзлыОбмена", МассивИспользуемыхУзлов(НастройкиСинхронизацииДанных));
	ОткрытьФорму("РегистрСведений.РезультатыОбменаДанными.Форма.Форма", ПараметрыФормы);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ (Поставляемая часть)

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 0 Тогда
		
		ПорядковыйНомерПерехода = 0;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяСтраницыДекорации) Тогда
		
		Элементы.ПанельСинхронизацииДанных.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыДекорации];
		
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// обработчик ПриПереходеДалее
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
				
				Отказ = Ложь;
				
				А = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// обработчик ПриПереходеНазад
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
				
				Отказ = Ложь;
				
				А = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		А = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// обработчик ОбработкаДлительнойОперации
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		А = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ТаблицаПереходовНоваяСтрока(ПорядковыйНомерПерехода,
									ИмяОсновнойСтраницы,
									ИмяСтраницыНавигации = "",
									ИмяСтраницыДекорации = "",
									ИмяОбработчикаПриОткрытии = "",
									ИмяОбработчикаПриПереходеДалее = "",
									ИмяОбработчикаПриПереходеНазад = "",
									ДлительнаяОперация = Ложь,
									ИмяОбработчикаДлительнойОперации = "")
	НоваяСтрока = ТаблицаПереходов.Добавить();
	
	НоваяСтрока.ПорядковыйНомерПерехода = ПорядковыйНомерПерехода;
	НоваяСтрока.ИмяОсновнойСтраницы     = ИмяОсновнойСтраницы;
	НоваяСтрока.ИмяСтраницыДекорации    = ИмяСтраницыДекорации;
	НоваяСтрока.ИмяСтраницыНавигации    = ИмяСтраницыНавигации;
	
	НоваяСтрока.ИмяОбработчикаПриПереходеДалее = ИмяОбработчикаПриПереходеДалее;
	НоваяСтрока.ИмяОбработчикаПриПереходеНазад = ИмяОбработчикаПриПереходеНазад;
	НоваяСтрока.ИмяОбработчикаПриОткрытии      = ИмяОбработчикаПриОткрытии;
	
	НоваяСтрока.ДлительнаяОперация = ДлительнаяОперация;
	НоваяСтрока.ИмяОбработчикаДлительнойОперации = ИмяОбработчикаДлительнойОперации;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МассивИспользуемыхУзлов(НастройкиСинхронизацииДанных)
	
	УзлыОбмена = Новый Массив;
	
	Для Каждого СтрокаУзла Из НастройкиСинхронизацииДанных Цикл
		Если СтрокаУзла.СинхронизацияНастроена Тогда
			УзлыОбмена.Добавить(СтрокаУзла.Корреспондент);
		КонецЕсли;
	КонецЦикла;
	
	Возврат УзлыОбмена;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ (Переопределяемая часть)

&НаКлиенте
Процедура ПерейтиДалее()
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНазад()
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтатусСессии(Знач Сессия)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат РегистрыСведений.СессииОбменаСообщениямиСистемы.СтатусСессии(Сессия);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаписатьОшибкуВЖурналРегистрации(Знач СтрокаСообщенияОбОшибке, Знач Событие)
	
	ЗаписьЖурналаРегистрации(Событие, УровеньЖурналаРегистрации.Ошибка,,, СтрокаСообщенияОбОшибке);
	
КонецПроцедуры

&НаСервере
Функция НоваяСессия()
	
	Сессия = РегистрыСведений.СессииОбменаСообщениямиСистемы.НоваяСессия();
	
	Возврат Сессия;
КонецФункции

&НаСервере
Процедура УстановитьСценарийПолученияНастроекСинхронизации()
	
	СценарийПолученияНастроекСинхронизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьНастройкуСинхронизацииДанных(Знач ТекущиеДанные)
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ТекущиеДанные.СинхронизацияНастроена Тогда
			
			ПоказатьЗначение(, ТекущиеДанные.Корреспондент);
			
		ИначеЕсли ТекущиеДанные.НастройкаСинхронизацииВМенеджереСервиса Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Для настройки синхронизации данных перейдите в менеджер сервиса.
				|В менеджере сервиса воспользуйтесь командой ""Синхронизация данных"".'"));
		Иначе
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ИмяПланаОбмена",              ТекущиеДанные.ПланОбмена);
			ПараметрыФормы.Вставить("ОбластьДанныхКорреспондента", ТекущиеДанные.ОбластьДанных);
			ПараметрыФормы.Вставить("НаименованиеКорреспондента",  ТекущиеДанные.НаименованиеПриложения);
			ПараметрыФормы.Вставить("КонечнаяТочкаКорреспондента", ТекущиеДанные.КонечнаяТочкаКорреспондента);
			ПараметрыФормы.Вставить("Префикс",                     ТекущиеДанные.Префикс);
			ПараметрыФормы.Вставить("ПрефиксКорреспондента",       ТекущиеДанные.ПрефиксКорреспондента);
			ПараметрыФормы.Вставить("ВерсияКорреспондента",        ТекущиеДанные.ВерсияКорреспондента);
			
			Уникальность = ТекущиеДанные.ПланОбмена + Формат(ТекущиеДанные.ОбластьДанных, "ЧЦ=7; ЧВН=; ЧГ=0");
			
			ОткрытьФорму("Обработка.ПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете.Форма.Форма",
				ПараметрыФормы, ЭтотОбъект, Уникальность,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьМонитор()
	
	УстановитьСценарийПолученияНастроекСинхронизации();
	
	ПорядковыйНомерПерехода = 0;
	
	// Позиционируемся на втором шаге помощника
	УстановитьПорядковыйНомерПерехода(2);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкиСинхронизацииДанных()
	
	КоличествоПроблем = 0;
	
	// Получение статусов синхронизации для таблицы настроек
	СтатусыСинхронизации = ОбменДаннымиВМоделиСервиса.СтатусыСинхронизацииДанных();
	
	Для Каждого Настройка Из НастройкиСинхронизацииДанных Цикл
		
		Если Настройка.СинхронизацияНастроена Тогда
			
			СтатусСинхронизации = СтатусыСинхронизации.Найти(Настройка.Корреспондент, "Приложение");
			
			Если СтатусСинхронизации <> Неопределено Тогда
				
				Настройка.СтатусСинхронизации = СтатусСинхронизации.Статус;
				
				Если СтатусСинхронизации.Статус = 1 Тогда // Требуется вмешательство администратора сервиса
					
					Настройка.Состояние = НСтр("ru = 'Ошибки при синхронизации данных'");
					
				ИначеЕсли СтатусСинхронизации.Статус = 2 Тогда // Пользователь может разрешить проблемы самостоятельно
					
					Настройка.Состояние = НСтр("ru = 'Проблемы при синхронизации данных'");
					
					КоличествоПроблем = КоличествоПроблем + СтатусСинхронизации.КоличествоПроблем;
					
				ИначеЕсли СтатусСинхронизации.Статус = 3 Тогда
					
					Настройка.Состояние = НСтр("ru = 'Синхронизация данных настроена'");
					
				КонецЕсли;
				
			Иначе
				Настройка.Состояние = НСтр("ru = 'Синхронизация данных настроена'");
				Настройка.СтатусСинхронизации = 3;
			КонецЕсли;
			
		Иначе
			
			Настройка.Описание = НСтр("ru = 'Синхронизация данных не настроена'");
			Настройка.СтатусСинхронизации = 0;
			
		КонецЕсли;
		
	КонецЦикла;
		
	// Отображение проблем синхронизации в шапке монитора
	СтруктураЗаголовка = ОбменДаннымиСервер.СтруктураЗаголовкаГиперссылкиМонитораПроблем(МассивИспользуемыхУзлов(НастройкиСинхронизацииДанных));
	ЗаполнитьЗначенияСвойств(Элементы.ПерейтиККонфликтам, СтруктураЗаголовка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий переходов

// Страница 1 (ожидание): Получение настроек синхронизации
//
&НаКлиенте
Функция Подключаемый_ОжиданиеПолученияДанных_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ЗапроситьНастройкиСинхронизацииДанных(Отказ);
	
КонецФункции

// Страница 1 (ожидание): Получение настроек синхронизации
//
&НаКлиенте
Функция Подключаемый_ОжиданиеПолученияДанныхДлительнаяОперация_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ПерейтиДалее = Ложь;
	
	ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
	
КонецФункции

// Страница 1 (ожидание): Получение настроек синхронизации
//
&НаКлиенте
Функция Подключаемый_ОжиданиеПолученияДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ПрочитатьНастройкиСинхронизацииДанных(Отказ);
	
КонецФункции

// Страница 1 (ожидание): Получение настроек синхронизации
//
&НаСервере
Процедура ЗапроситьНастройкиСинхронизацииДанных(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		// Отправляем сообщение в МС
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияАдминистрированиеОбменаДаннымиУправлениеИнтерфейс.СообщениеПолучитьНастройкиСинхронизацииДанных());
		Сообщение.Body.Zone = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		Сообщение.Body.SessionId = НоваяСессия();
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(Сообщение,
			РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса(), Истина);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			СобытиеЖурналаРегистрацииМониторСинхронизацииДанных);
		Отказ = Истина;
		Возврат;
	КонецПопытки;
	
	СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

// Страница 1 (ожидание): Получение настроек синхронизации
//
&НаСервере
Процедура ПрочитатьНастройкиСинхронизацииДанных(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		НастройкиСинхронизацииИзМенеджераСервиса = РегистрыСведений.СессииОбменаСообщениямиСистемы.ПолучитьДанныеСессии(Сессия).Получить();
		
		Если НастройкиСинхронизацииИзМенеджераСервиса.Количество() = 0 Тогда
			
			СценарийОтсутствияНастроекСинхронизации();
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ЕстьПрефикс              = НастройкиСинхронизацииИзМенеджераСервиса.Колонки.Найти("Префикс") <> Неопределено;
		ЕстьВерсияКорреспондента = НастройкиСинхронизацииИзМенеджераСервиса.Колонки.Найти("ВерсияКорреспондента") <> Неопределено;
		
		// Заполняем таблицу НастройкиСинхронизацииДанных по данным, полученным из Менеджера сервиса
		НастройкиСинхронизацииДанных.Очистить();
		
		СинхронизацияНастроена = Ложь;
		
		Для Каждого НастройкаИзМенеджераСервиса Из НастройкиСинхронизацииИзМенеджераСервиса Цикл
			
			Настройка = НастройкиСинхронизацииДанных.Добавить();
			
			Настройка.ПланОбмена                              = НастройкаИзМенеджераСервиса.ПланОбмена;
			Настройка.ОбластьДанных                           = НастройкаИзМенеджераСервиса.ОбластьДанных;
			Настройка.НаименованиеПриложения                  = НастройкаИзМенеджераСервиса.НаименованиеПриложения;
			Настройка.СинхронизацияНастроена                  = НастройкаИзМенеджераСервиса.СинхронизацияНастроена;
			Настройка.НастройкаСинхронизацииВМенеджереСервиса = НастройкаИзМенеджераСервиса.НастройкаСинхронизацииВМенеджереСервиса;
			
			// Заполняем поле "КонечнаяТочкаКорреспондента"
			Настройка.КонечнаяТочкаКорреспондента = ПланыОбмена.ОбменСообщениями.НайтиПоКоду(НастройкаИзМенеджераСервиса.КонечнаяТочкаКорреспондента);
			
			Если Настройка.КонечнаяТочкаКорреспондента.Пустая() Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не найдена конечная точка корреспондента с кодом ""%1"".'"),
					НастройкаИзМенеджераСервиса.КонечнаяТочкаКорреспондента);
			КонецЕсли;
			
			Если Настройка.СинхронизацияНастроена Тогда
				
				СинхронизацияНастроена = Истина;
				
				// Заполняем поле "Корреспондент" для существующих настроек
				Настройка.Корреспондент = ПланыОбмена[Настройка.ПланОбмена].НайтиПоКоду(
					ОбменДаннымиВМоделиСервиса.КодУзлаПланаОбменаВСервисе(Настройка.ОбластьДанных));
				
				Настройка.Описание = ОбменДаннымиСервер.ОписаниеПравилСинхронизацииДанных(Настройка.Корреспондент);
				
			КонецЕсли;
			
			Если ЕстьПрефикс Тогда
				Настройка.Префикс               = НастройкаИзМенеджераСервиса.Префикс;
				Настройка.ПрефиксКорреспондента = НастройкаИзМенеджераСервиса.ПрефиксКорреспондента;
			Иначе
				Настройка.Префикс               = "";
				Настройка.ПрефиксКорреспондента = "";
			КонецЕсли;
			
			Если ЕстьВерсияКорреспондента Тогда
				Настройка.ВерсияКорреспондента = НастройкаИзМенеджераСервиса.ВерсияКорреспондента;
			Иначе
				Настройка.ВерсияКорреспондента = "";
			КонецЕсли;
			
		КонецЦикла;
		
		Элементы.ПанельСинхронизацииДанных.Видимость = СинхронизацияНастроена;
		
	Исключение
		
		ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			СобытиеЖурналаРегистрацииМониторСинхронизацииДанных);
		Отказ = Истина;
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

//

// Страница 2: Работа со списком настроек синхронизации
//
&НаКлиенте
Функция Подключаемый_НастройкаСинхронизацииДанных_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	НастройкаСинхронизацииДанных_ПриОткрытии(Отказ);
	
КонецФункции

// Страница 2: Работа со списком настроек синхронизации
//
&НаСервере
Процедура НастройкаСинхронизацииДанных_ПриОткрытии(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		Элементы.ГруппаМонитораСинхронизации.Доступность = Истина;
		
		// Получаем представление даты успешной синхронизации
		Элементы.ПредставлениеДатыСинхронизации.Заголовок = ОбменДаннымиСервер.ПредставлениеДатыСинхронизации(
			ОбменДаннымиВМоделиСервиса.ДатаПоследнейУспешнойЗагрузкиДляВсехУзловИнформационнойБазы());
		
		ОбновитьНастройкиСинхронизацииДанных();
		
	Исключение
		ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			СобытиеЖурналаРегистрацииМониторСинхронизацииДанных);
		Отказ = Истина;
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

//

// Страница 3 (ожидание): Выполнение синхронизации
//
&НаКлиенте
Функция Подключаемый_ВыполнениеСинхронизации_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ПротолкнутьСинхронизациюДанных(Отказ);
	
КонецФункции

// Страница 3 (ожидание): Выполнение синхронизации
//
&НаКлиенте
Функция Подключаемый_ВыполнениеСинхронизацииДлительнаяОперация_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ПерейтиДалее = Ложь;
	
	ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
	
КонецФункции

// Страница 3 (ожидание): Выполнение синхронизации
//
&НаКлиенте
Функция Подключаемый_ВыполнениеСинхронизацииДлительнаяОперацияОкончание_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	Отказ = Истина; // Возвращается обратно на страницу монитора (страница 2)
	
	// Обновляем все открытые динамические списки
	ОбменДаннымиКлиент.ОбновитьВсеОткрытыеДинамическиеСписки();
	
КонецФункции

// Страница 3 (ожидание): Выполнение синхронизации
//
&НаСервере
Процедура ПротолкнутьСинхронизациюДанных(Отказ)
	
	Элементы.ГруппаМонитораСинхронизации.Доступность = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		// Отправляем сообщение в МС
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияАдминистрированиеОбменаДаннымиУправлениеИнтерфейс.СообщениеПротолкнутьСинхронизацию());
		Сообщение.Body.Zone = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		Сообщение.Body.SessionId = НоваяСессия();
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(Сообщение,
			РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса(), Истина);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			СобытиеЖурналаРегистрацииМониторСинхронизацииДанных);
		Отказ = Истина;
		Возврат;
	КонецПопытки;
	
	СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Инициализация переходов помощника

&НаСервере
Процедура СценарийПолученияНастроекСинхронизации()
	
	ТаблицаПереходов.Очистить();
	
	ТаблицаПереходовНоваяСтрока(1, "ОшибкаПолученияДанных");
	
	// Получение настроек синхронизации
	ТаблицаПереходовНоваяСтрока(2, "ОжиданиеПолученияДанных",,,,,, Истина, "ОжиданиеПолученияДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(3, "ОжиданиеПолученияДанных",,,,,, Истина, "ОжиданиеПолученияДанныхДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(4, "ОжиданиеПолученияДанных",,,,,, Истина, "ОжиданиеПолученияДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	
	// Работа со списком настроек синхронизации
	ТаблицаПереходовНоваяСтрока(5, "НастройкаСинхронизацииДанных",, "СостояниеСинхронизации", "НастройкаСинхронизацииДанных_ПриОткрытии");
	
	// Выполнение синхронизации
	ТаблицаПереходовНоваяСтрока(6, "НастройкаСинхронизацииДанных",, "ВыполнениеСинхронизации",,,, Истина, "ВыполнениеСинхронизации_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(7, "НастройкаСинхронизацииДанных",, "ВыполнениеСинхронизации",,,, Истина, "ВыполнениеСинхронизацииДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(8, "НастройкаСинхронизацииДанных",, "ВыполнениеСинхронизации",,,, Истина, "ВыполнениеСинхронизацииДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	
КонецПроцедуры

&НаСервере
Процедура СценарийОтсутствияНастроекСинхронизации()
	
	ТаблицаПереходов.Очистить();
	
	ТаблицаПереходовНоваяСтрока(1, "НетПриложенийДляСинхронизации");
	ТаблицаПереходовНоваяСтрока(2, "ОжиданиеПолученияДанных",,,,,, Истина, "ОжиданиеПолученияДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(3, "ОжиданиеПолученияДанных",,,,,, Истина, "ОжиданиеПолученияДанныхДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(4, "ОжиданиеПолученияДанных",,,,,, Истина, "ОжиданиеПолученияДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	
КонецПроцедуры