﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

//Процедура формирует строки списка участников
//
// Параметры
//  Контакты  - Массив - массив структур, описывающих участников взаимодействия
//
Процедура ЗаполнитьКонтакты(Контакты) Экспорт
	
	Взаимодействия.ЗаполнитьКонтактыДляВстречи(Контакты, Адресаты, Перечисления.ТипыКонтактнойИнформации.Телефон);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Взаимодействия.ЗаполнитьРеквизитыПоУмолчанию(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Тема = ВзаимодействияКлиентСервер.ТемаПоТекстуСообщения(ТекстСообщения);
	Взаимодействия.СформироватьСписокУчастников(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	РассмотретьПосле = Неопределено;
	Рассмотрено      = Истина;
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ



#КонецЕсли