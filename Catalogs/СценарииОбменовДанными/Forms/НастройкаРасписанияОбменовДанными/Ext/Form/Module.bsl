﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Список.Параметры.Элементы[0].Значение = Параметры.УзелИнформационнойБазы;
	Список.Параметры.Элементы[0].Использование = Истина;
	
	Заголовок = НСтр("ru = 'Сценарии синхронизации данных для: [УзелИнформационнойБазы]'");
	Заголовок = СтрЗаменить(Заголовок, "[УзелИнформационнойБазы]", Строка(Параметры.УзелИнформационнойБазы));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СценарииОбменовДанными" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Список.ДанныеСтроки(ВыбраннаяСтрока);
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.ФлагИспользованияЗагрузки Тогда
		
		ВключитьОтключитьЗагрузкуНаСервере(ТекущиеДанные.ФлагИспользованияЗагрузки, ТекущиеДанные.Ссылка);
		
	ИначеЕсли Поле = Элементы.ФлагИспользованияВыгрузки Тогда
		
		ВключитьОтключитьВыгрузкуНаСервере(ТекущиеДанные.ФлагИспользованияВыгрузки, ТекущиеДанные.Ссылка);
		
	ИначеЕсли Поле = Элементы.Наименование Тогда
		
		ИзменитьСценарийОбменаДанными(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	ПараметрыФормы = Новый Структура("УзелИнформационнойБазы", Параметры.УзелИнформационнойБазы);
	
	ОткрытьФорму("Справочник.СценарииОбменовДанными.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСценарийОбменаДанными(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Справочник.СценарииОбменовДанными.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтключитьРегламентноеЗадание(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВключитьОтключитьРегламентноеЗаданиеНаСервере(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтключитьВыгрузку(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВключитьОтключитьВыгрузкуНаСервере(ТекущиеДанные.ФлагИспользованияВыгрузки, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтключитьЗагрузку(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВключитьОтключитьЗагрузкуНаСервере(ТекущиеДанные.ФлагИспользованияЗагрузки, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтключитьЗагрузкуВыгрузку(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВключитьОтключитьЗагрузкуВыгрузкуНаСервере(ТекущиеДанные.ФлагИспользованияЗагрузки ИЛИ ТекущиеДанные.ФлагИспользованияВыгрузки, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСценарий(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Сообщение = НСтр("ru = 'Синхронизируются данные по сценарию ""%1""...'");
	Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Сообщение, Строка(ТекущиеДанные.Ссылка));
	
	Состояние(Сообщение);
	
	Отказ = Ложь;
	
	// запускаем выполнение обмена
	ОбменДаннымиВызовСервера.ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, ТекущиеДанные.Ссылка);
	
	Если Отказ Тогда
		Сообщение = НСтр("ru = 'Сценарий синхронизации выполнен с ошибками.'");
		Картинка = БиблиотекаКартинок.Ошибка32;
	Иначе
		Сообщение = НСтр("ru = 'Сценарий синхронизации успешно выполнен.'");
		Картинка = Неопределено;
	КонецЕсли;
	
	Состояние(Сообщение,,, Картинка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВключитьОтключитьРегламентноеЗаданиеНаСервере(Ссылка)
	
	НастройкаОбъект = Ссылка.ПолучитьОбъект();
	НастройкаОбъект.ИспользоватьРегламентноеЗадание = Не НастройкаОбъект.ИспользоватьРегламентноеЗадание;
	НастройкаОбъект.Записать();
	
	// обновляем данные списка
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ВключитьОтключитьВыгрузкуНаСервере(Знач ФлагИспользованияВыгрузки, Знач СценарийОбменаДанными)
	
	Если ФлагИспользованияВыгрузки Тогда
		
		Справочники.СценарииОбменовДанными.УдалитьВыгрузкуВСценарииОбменаДанными(СценарийОбменаДанными, Параметры.УзелИнформационнойБазы);
		
	Иначе
		
		Справочники.СценарииОбменовДанными.ДобавитьВыгрузкуВСценарииОбменаДанными(СценарийОбменаДанными, Параметры.УзелИнформационнойБазы);
		
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ВключитьОтключитьЗагрузкуНаСервере(Знач ФлагИспользованияЗагрузки, Знач СценарийОбменаДанными)
	
	Если ФлагИспользованияЗагрузки Тогда
		
		Справочники.СценарииОбменовДанными.УдалитьЗагрузкуВСценарииОбменаДанными(СценарийОбменаДанными, Параметры.УзелИнформационнойБазы);
		
	Иначе
		
		Справочники.СценарииОбменовДанными.ДобавитьЗагрузкуВСценарииОбменаДанными(СценарийОбменаДанными, Параметры.УзелИнформационнойБазы);
		
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ВключитьОтключитьЗагрузкуВыгрузкуНаСервере(Знач ФлагИспользования, Знач СценарийОбменаДанными)
	
	ВключитьОтключитьЗагрузкуНаСервере(ФлагИспользования, СценарийОбменаДанными);
	
	ВключитьОтключитьВыгрузкуНаСервере(ФлагИспользования, СценарийОбменаДанными);
	
КонецПроцедуры

#КонецОбласти
