﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Настройки видимости при запуске
	Элементы.ГруппаРезервноеКопированиеИВосстановление.Видимость = РежимРаботы.Локальный;
	Элементы.ГруппаОбновлениеКонфигурации.Видимость              = РежимРаботы.Локальный;
	Элементы.ГруппаКлассификаторы.Видимость                      = РежимРаботы.Локальный;
	
	// Обновление состояния элементов
	УстановитьДоступность();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура РезервноеКопированиеПрограммыНажатие(Элемент)
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаРезервногоКопированияНажатие(Элемент)
	
	ОткрытьФорму("Обработка.НастройкаРезервногоКопированияИБ.Форма", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановлениеИзРезервнойКопииНажатие(Элемент)
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.ВосстановлениеДанныхИнформационнойБазыИзРезервнойКопии", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнятьЗамерыПроизводительностиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗагрузитьКурсыВалют(Команда)
	
	ОткрытьФорму("Обработка.ЗагрузкаКурсовВалют.Форма");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлассификаторБанков(Команда)
	
	ОткрытьФорму("Справочник.КлассификаторБанковРФ.Форма.ЗагрузкаКлассификатора");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьАдресныйКлассификатор(Команда)
	
	ОткрытьФорму("РегистрСведений.АдресныйКлассификатор.Форма.ЗагрузкаАдресногоКлассификатора");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаУправлениеПолнотекстовымПоиском(Команда)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.УправлениеПолнотекстовымПоискомИИзвлечениемТекстов", , ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Процедура ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РежимРаботы.ЭтоАдминистраторСистемы Тогда
		
		Если РеквизитПутьКДанным = "НаборКонстант.ВыполнятьЗамерыПроизводительности" ИЛИ РеквизитПутьКДанным = "" Тогда
			Элементы.ОбработкаОценкаПроизводительности.Доступность = НаборКонстант.ВыполнятьЗамерыПроизводительности;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

