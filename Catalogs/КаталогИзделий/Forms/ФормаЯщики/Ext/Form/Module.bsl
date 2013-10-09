﻿
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ПолучитьАдресХранилища()
	
	Возврат ПоместитьВоВременноеХранилище(Детали.Выгрузить());
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	Детали.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицы));
	
	Если ЗначениеЗаполнено(Детали) Тогда
		Если Параметры.Свойство("Идентификатор")  Тогда
		Элементы.Детали.ТекущаяСтрока = Параметры.Идентификатор;
		КонецЕсли;
	Иначе
		Стр = Детали.Добавить();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ДобавитьКДокументу(Команда)
	
	Если ПроверитьПередСохранением() Тогда
		
		Модифицированность = Ложь;
		ОповеститьОВыборе(ПолучитьАдресХранилища());
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ СВОЙСТВ И КАТЕГОРИЙ

&НаКлиенте
Функция ПроверитьПередСохранением()
	
	Результат = Истина;	
	                                                               
	Возврат Результат;
	
КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ

&НаКлиенте
Процедура ДеталиПриАктивизацииСтроки(Элемент)
	
	ДеталиВидФасадаПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеталиВидФасадаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	Если Данные <> Неопределено Тогда
		Данные.ВидФасада = ?(ЗначениеЗаполнено(Данные.ВидФасада), Данные.ВидФасада, "Нет");
		Значение = Истина;
		Если Данные.ВидФасада = "Нет" Тогда
			Значение = Ложь;
		КонецЕсли;	
	Элементы.ДеталиВысотаФасада.Доступность = Значение;
	Элементы.ДеталиШиринаФасада.Доступность = Значение;
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

