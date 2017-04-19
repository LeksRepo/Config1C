﻿
///////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВыполнятьЭкспортДанных = ВыполнятьРегламентноеЗадание();
	КаталогиЭкспортаПараметрЗадания = КаталогиЭкспортаОценкиПроизводительности();
	Если ТипЗнч(КаталогиЭкспортаПараметрЗадания) <> Тип("Структура") 
		ИЛИ 
		 КаталогиЭкспортаПараметрЗадания.Количество() = 0
	Тогда
		Возврат;
	КонецЕсли;	
	
	КлючЗаданияВЭлементы = Новый Структура;
	FTPЭлементы = Новый Массив;
	FTPЭлементы.Добавить("ВыполнятьЭкспортНаFTP");
	FTPЭлементы.Добавить("FTPКаталогЭкспорта");
	
	ЛокальныйЭлементы = Новый Массив;
	ЛокальныйЭлементы.Добавить("ВыполнятьЭкспортВЛокальныйКаталог");
	ЛокальныйЭлементы.Добавить("ЛокальныйКаталогЭкспорта");
		
	КлючЗаданияВЭлементы.Вставить(ОценкаПроизводительностиКлиентСервер.FTPКаталогЭкспортаКлючЗадания(), FTPЭлементы);
	КлючЗаданияВЭлементы.Вставить(ОценкаПроизводительностиКлиентСервер.ЛокальныйКаталогЭкспортаКлючЗадания(), ЛокальныйЭлементы);
	ВыполнятьЭкспорт = Ложь;
	Для Каждого ИмяКлючаЭлементы Из КлючЗаданияВЭлементы Цикл		
		ИмяКлюча = ИмяКлючаЭлементы.Ключ;
		ЭлементыНаРедактирование = ИмяКлючаЭлементы.Значение;
		НомерЭлемента = 0;
		Для Каждого ЭлементИмя Из ЭлементыНаРедактирование Цикл
			Значение = КаталогиЭкспортаПараметрЗадания[ИмяКлюча][НомерЭлемента];
			ЭтаФорма[ЭлементИмя] = Значение; //КаталогиЭкспортаПараметрЗадания[ИмяКлюча][НомерЭлемента];
			Если НомерЭлемента = 0 Тогда 
				ВыполнятьЭкспорт = ВыполнятьЭкспорт ИЛИ Значение;	
			КонецЕсли;	
			НомерЭлемента = НомерЭлемента + 1;
		КонецЦикла;		
	КонецЦикла;	 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнятьЭкспортПриИзменении(Элемент)
	ЭкспортРазрешен = ВыполнятьЭкспорт;
	ВыполнятьЭкспортВЛокальныйКаталог = ЭкспортРазрешен;
	ВыполнятьЭкспортНаFTP = ЭкспортРазрешен;
КонецПроцедуры	

&НаКлиенте
Процедура ВыполнятьЭкспортВКаталогПриИзменении(Элемент)
	ВыполнятьЭкспорт = ВыполнятьЭкспортВЛокальныйКаталог ИЛИ ВыполнятьЭкспортНаFTP;
КонецПроцедуры	
	
&НаКлиенте
Процедура ЛокальныйКаталогФайловЭкспортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбранныйКаталог = "";
	РезультатВызова = ОценкаПроизводительностиКлиент.ВызватьДиалогРаботыСФайлами(
		РежимДиалогаВыбораФайла.ВыборКаталога, 
		ВыбранныйКаталог);
	
	Если Не РезультатВызова Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйКаталог <> Неопределено Тогда
		ЛокальныйКаталогЭкспорта = ВыбранныйКаталог;
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработкаПроверкиЗаполненияНаСервере()
	ЭлементыНаКонтроле = Новый Соответствие;
	ЭлементыНаКонтроле.Вставить(Элементы.ВыполнятьЭкспортВЛокальныйКаталог, Элементы.ЛокальныйКаталогЭкспорта);
	ЭлементыНаКонтроле.Вставить(Элементы.ВыполнятьЭкспортНаFTP, Элементы.FTPКаталогЭкспорта);
	
	ОшибокНет = Истина;	
	Для Каждого ФлажокПуть Из ЭлементыНаКонтроле Цикл
		Выполнять = ЭтаФорма[ФлажокПуть.Ключ.ПутьКДанным];
		ПутьЭлемент = ФлажокПуть.Значение;
		Если Выполнять И ПустаяСтрока(СокрЛП(ЭтаФорма[ПутьЭлемент.ПутьКДанным])) Тогда
			СообщениеТекст = НСтр("ru = 'Поле ""%1"" не заполнено'");
			СообщениеТекст = СтрЗаменить(СообщениеТекст, "%1", ПутьЭлемент.Заголовок);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СообщениеТекст,
				,
				ПутьЭлемент.Имя,
				ПутьЭлемент.ПутьКДанным);
			ОшибокНет = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОшибокНет;	
КонецФункции

&НаСервере
Процедура СохранитьНаСервере()
    ВыполнятьЛокальныйКаталог = Новый Массив;
	ВыполнятьЛокальныйКаталог.Добавить(ВыполнятьЭкспортВЛокальныйКаталог);
	ВыполнятьЛокальныйКаталог.Добавить(СокрЛП(ЭтаФорма.ЛокальныйКаталогЭкспорта));
	
	ВыполнятьFTPКаталог = Новый Массив;
	ВыполнятьFTPКаталог.Добавить(ВыполнятьЭкспортНаFTP);
	ВыполнятьFTPКаталог.Добавить(СокрЛП(ЭтаФорма.FTPКаталогЭкспорта));
	
	УстановитьКаталогЭкспорта(ВыполнятьЛокальныйКаталог, ВыполнятьFTPКаталог);  

	УстановитьИспользованиеРегламентногоЗадания(ВыполнятьЭкспорт);
		
КонецПроцедуры


///////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД

&НаКлиенте
Процедура НастроитьРасписаниеЭкспорта(Команда)
	
	РасписаниеРегламентногоЗадания = РасписаниеЭкспортаОценкиПроизводительности();
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	
	Если Не Диалог.ОткрытьМодально() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьРасписание(Диалог.Расписание);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Функция КаталогиЭкспортаОценкиПроизводительности()
	
	Задание = РегламентноеЗаданиеЭкспортаОценкиПроизводительности();
	Каталоги = Новый Структура;
	Если Задание.Параметры.Количество() > 0 Тогда
		Каталоги = Задание.Параметры[0];
	КонецЕсли;
	
	Возврат Каталоги;
	
КонецФункции

// Изменяет каталог экспорта данных
//
// Параметры:
//  КаталогЭкспорта - Строка, новый каталог экспорта
//
&НаСервереБезКонтекста
Процедура УстановитьКаталогЭкспорта(ВыполнятьЛокальныйКаталогЭкспорта, ВыполнятьFTPКаталогЭкспорта)
	
	Задание = РегламентноеЗаданиеЭкспортаОценкиПроизводительности();
	
	
	Каталоги = Новый Структура();
	Каталоги.Вставить(ОценкаПроизводительностиКлиентСервер.ЛокальныйКаталогЭкспортаКлючЗадания(), ВыполнятьЛокальныйКаталогЭкспорта);
	Каталоги.Вставить(ОценкаПроизводительностиКлиентСервер.FTPКаталогЭкспортаКлючЗадания(), ВыполнятьFTPКаталогЭкспорта);
	
	ПараметрыЗадания = Новый Массив;	
	ПараметрыЗадания.Добавить(Каталоги);
	Задание.Параметры = ПараметрыЗадания;
	ЗафиксироватьРегламентноеЗадание(Задание);
	
	
КонецПроцедуры

// Возвращает признак использования регламентного задания
//
// Возвращаемое значение:
//  Булево - 
//  	Истина, регламентное задание выполняется
//  	Ложь, регламентное задание не выполняется
//
&НаСервереБезКонтекста
Функция ВыполнятьРегламентноеЗадание()
	
	Задание = РегламентноеЗаданиеЭкспортаОценкиПроизводительности();
	Возврат Задание.Использование;
	
КонецФункции

// Изменяет признак использования регламентного задания
//
// Параметры:
//  НовоеЗначение - Булево, новое значение использования
//
// Возвращаемое значение:
//  Булево - состояние до изменения (предыдущее состояние)
//
&НаСервереБезКонтекста
Функция УстановитьИспользованиеРегламентногоЗадания(НовоеЗначение)
	
	Задание = РегламентноеЗаданиеЭкспортаОценкиПроизводительности();
	ТекущееСостояние = Задание.Использование;
	Если ТекущееСостояние <> НовоеЗначение Тогда
		Задание.Использование = НовоеЗначение;
		ЗафиксироватьРегламентноеЗадание(Задание);
	КонецЕсли;
	
	Возврат ТекущееСостояние;
	
КонецФункции

// Возвращает текущее расписание регламентного задания
//
// Возвращаемое значение:
//  РасписаниеРегламентногоЗадания - текущее расписание
//
&НаСервереБезКонтекста
Функция РасписаниеЭкспортаОценкиПроизводительности()
	
	Задание = РегламентноеЗаданиеЭкспортаОценкиПроизводительности();
	Возврат Задание.Расписание;
	
КонецФункции

// Устанавливает новое расписание регламентному заданию
//
// Параметры:
//  НовоеРасписание - РасписаниеРегламентногоЗадания, которое надо установить
//
&НаСервереБезКонтекста
Процедура УстановитьРасписание(Знач НовоеРасписание)
	
	Задание = РегламентноеЗаданиеЭкспортаОценкиПроизводительности();
	Задание.Расписание = НовоеРасписание;
	ЗафиксироватьРегламентноеЗадание(Задание);
	
КонецПроцедуры

// Находит и возвращает регламентное задание
//
// Возвращаемое значение:
//  РегламентноеЗадание - РегламентноеЗадание.ЭкспортОценкиПроизводительности, найденное задание
//
&НаСервереБезКонтекста
Функция РегламентноеЗаданиеЭкспортаОценкиПроизводительности()
	
	УстановитьПривилегированныйРежим(Истина);
	Задания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(
		Новый Структура("Метаданные", "ЭкспортОценкиПроизводительности"));
	Если Задания.Количество() = 0 Тогда
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(
			Метаданные.РегламентныеЗадания.ЭкспортОценкиПроизводительности);
		Задание.Записать();
		Возврат Задание;
	Иначе
		Возврат Задания[0];
	КонецЕсли;
		
КонецФункции

// Сохраняет настройки регламентного задания
//
// Параметры:
//  Задание - РегламентноеЗадание.ЭкспортОценкиПроизводительности
//
&НаСервереБезКонтекста
Процедура ЗафиксироватьРегламентноеЗадание(Задание)
	
	УстановитьПривилегированныйРежим(Истина);
	Задание.Записать();
	
КонецПроцедуры


&НаКлиенте
Процедура СохранитьНастройки(Команда)
	Если ОбработкаПроверкиЗаполненияНаСервере() Тогда 	
		СохранитьНаСервере();
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура СохранитьЗакрыть(Команда)
	Если ОбработкаПроверкиЗаполненияНаСервере() Тогда 	
		СохранитьНаСервере();
	    ЭтаФорма.Закрыть();	
	КонецЕсли;
КонецПроцедуры

