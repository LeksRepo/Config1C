﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	МассивРегламентныхЗаданий = СписокВсехРегламентныхЗаданий();
	СкрытьРегламентныеЗадания = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.ДоступныеПараметры.НайтиПараметр(Новый ПараметрКомпоновкиДанных("СкрытьРегламентныеЗадания"));
	СкрытьРегламентныеЗадания.ДоступныеЗначения.Очистить();
	Для Каждого Элемент Из МассивРегламентныхЗаданий Цикл
		СкрытьРегламентныеЗадания.ДоступныеЗначения.Добавить(Элемент.УИД, Элемент.Наименование);
	КонецЦикла;
	СкрытьРегламентныеЗадания.ДоступныеЗначения.СортироватьПоПредставлению();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ИдентификаторЗадания <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Элемент.ТекущаяОбласть) = Тип("РисунокТабличногоДокумента") Тогда
		
		Если ТипЗнч(Элемент.ТекущаяОбласть.Объект) = Тип("Диаграмма") Тогда
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не НаименованиеТекущегоВарианта = НСтр("ru = 'Продолжительность работы регламентных заданий'") Тогда
		СтандартнаяОбработка = Истина;
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ТипРасшифровки = Расшифровка.Получить(0);
	Если ТипРасшифровки = "РасшифровкаРегламентногоЗадания" Тогда
		
		ВариантРасшифровки = Новый СписокЗначений;
		ВариантРасшифровки.Добавить("СведенияОРегламентномЗадании", НСтр("ru = 'Сведения о регламентном задании'"));
		ВариантРасшифровки.Добавить("ОткрытьЖурналРегистрации", НСтр("ru = 'Перейти к журналу регистрации'"));
		
		ОписаниеОповещения = Новый ОписаниеОповещения("РезультатОбработкаРасшифровкиЗавершение", ЭтотОбъект, Расшифровка);
		ПоказатьВыборИзМеню(ОписаниеОповещения, ВариантРасшифровки);
		
	Иначе
		СведенияОРегламентномЗадании(Расшифровка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Элемент.ТекущаяОбласть) = Тип("РисунокТабличногоДокумента") Тогда
		Если ТипЗнч(Элемент.ТекущаяОбласть.Объект) = Тип("Диаграмма") Тогда
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	ОчиститьСообщения();
	ПараметрыОтчета = ПараметрыОтчета();	
	РезультатВыполнения = СформироватьОтчетСервер(ПараметрыОтчета);
	ПараметрыОбработчикаОжидания = Новый Структура();
	
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура РезультатОбработкаРасшифровкиЗавершение(ВыбранныйВариант, Расшифровка) Экспорт
	
	Если ВыбранныйВариант = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Действие = ВыбранныйВариант.Значение;
	Если Действие = "СведенияОРегламентномЗадании" Тогда
		
		СписокТочек = Результат.Области.ДиаграммаГанта.Объект.Точки;
		Для Каждого ТочкаДиаграммыГанта Из СписокТочек Цикл
			
			РасшифровкаТочки = ТочкаДиаграммыГанта.Расшифровка;
			Если ТочкаДиаграммыГанта.Значение = НСтр("ru = 'Фоновые задания'") Тогда
				Продолжить;
			КонецЕсли;
			
			Если РасшифровкаТочки.Найти(Расшифровка.Получить(2)) <> Неопределено Тогда
				СведенияОРегламентномЗадании(РасшифровкаТочки);
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли Действие = "ОткрытьЖурналРегистрации" Тогда
		
		СеансРегламентногоЗадания.Очистить();
		СеансРегламентногоЗадания.Добавить(Расшифровка.Получить(1));
		ДатаНачала = Расшифровка.Получить(3);
		ДатаОкончания = Расшифровка.Получить(4);
		ОтборЖурналаРегистрации = Новый Структура("Сеанс, ДатаНачала, ДатаОкончания", 
			СеансРегламентногоЗадания, ДатаНачала, ДатаОкончания);
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ОтборЖурналаРегистрации);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Функция СписокВсехРегламентныхЗаданий()
	УстановитьПривилегированныйРежим(Истина);
	СписокРегламентныхЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания();
	МассивРегламентныхЗаданий = Новый Массив;
	Для Каждого Элемент Из СписокРегламентныхЗаданий Цикл
		Если Элемент.Наименование <> "" Тогда
			МассивРегламентныхЗаданий.Добавить(Новый Структура("УИД, Наименование", Элемент.УникальныйИдентификатор, 
																			Элемент.Наименование));
		ИначеЕсли Элемент.Метаданные.Синоним <> "" Тогда
			МассивРегламентныхЗаданий.Добавить(Новый Структура("УИД, Наименование", Элемент.УникальныйИдентификатор,
																			Элемент.Метаданные.Синоним));
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивРегламентныхЗаданий;
КонецФункции

&НаСервере
Функция ПараметрыОтчета()
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Настройки", Отчет.КомпоновщикНастроек.Настройки);
	ПараметрыОтчета.Вставить("ПользовательскиеНастройки", Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);
	ПараметрыОтчета.Вставить("ФиксированныеНастройки", Отчет.КомпоновщикНастроек.ФиксированныеНастройки);
	ПараметрыОтчета.Вставить("ИдентификаторФормы", УникальныйИдентификатор);
	
	Возврат ПараметрыОтчета;
КонецФункции

&НаСервере
Процедура ПолучитьИдентификаторРегламентногоЗадания(НазваниеСобытия, НаименованиеСобытия)
	УстановитьПривилегированныйРежим(Истина);
	ОтборПоРегламентнымЗаданиям = Новый Структура; 	
	МетаданныеРегламентногоЗадания = Метаданные.РегламентныеЗадания.Найти(НазваниеСобытия);
	Если МетаданныеРегламентногоЗадания <> Неопределено Тогда
		ОтборПоРегламентнымЗаданиям.Вставить("Метаданные", МетаданныеРегламентногоЗадания);
		Если НаименованиеСобытия <> Неопределено Тогда
			ОтборПоРегламентнымЗаданиям.Вставить("Наименование", НаименованиеСобытия);
		КонецЕсли;
		РегЗадание = РегламентныеЗадания.ПолучитьРегламентныеЗадания(ОтборПоРегламентнымЗаданиям);
		Если ЗначениеЗаполнено(РегЗадание) Тогда
			ИдентификаторРегламентногоЗадания = РегЗадание[0].УникальныйИдентификатор;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры 					   

&НаКлиенте
Процедура СведенияОРегламентномЗадании(Расшифровка)
	ИдентификаторРегламентногоЗадания = Неопределено;
	РезультатРасшифровка = ОтчетПоРегламентномуЗаданию(Расшифровка);
	ИмяРегламентногоЗадания = Расшифровка.Получить(1);
	НаименованиеСобытия = Расшифровка.Получить(2);
	Если ИмяРегламентногоЗадания <> "" Тогда
		НазваниеСобытия = СтрЗаменить(ИмяРегламентногоЗадания, "РегламентноеЗадание." , "");
		ПолучитьИдентификаторРегламентногоЗадания(НазваниеСобытия, НаименованиеСобытия);
	КонецЕсли;
	ПараметрыФормы = Новый Структура("Отчет, ИдентификаторРегламентногоЗадания, Заголовок", 
		РезультатРасшифровка.Отчет,	ИдентификаторРегламентногоЗадания, Расшифровка.Получить(2));
	ОткрытьФорму("Отчет.АнализЖурналаРегистрации.Форма.СведенияОРегламентномЗадании", ПараметрыФормы);
КонецПроцедуры

&НаСервере
Функция ОтчетПоРегламентномуЗаданию(Расшифровка)
	РезультатФормированияОтчета = Отчеты.АнализЖурналаРегистрации.РасшифровкаРегламентногоЗадания(Расшифровка);
	Возврат РезультатФормированияОтчета;
КонецФункции		

&НаСервере
Функция СформироватьОтчетСервер(ПараметрыОтчета)
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	АдресРасшифровки = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("АдресРасшифровки", АдресРасшифровки);
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Отчеты.АнализЖурналаРегистрации.Сформировать(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Отчеты.АнализЖурналаРегистрации.Сформировать", 
			ПараметрыОтчета, 
			НСтр("ru = 'Выполнение отчета: Анализ журнала регистрации'"));
						
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;		
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат РезультатВыполнения;

КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()  
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()   	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции
