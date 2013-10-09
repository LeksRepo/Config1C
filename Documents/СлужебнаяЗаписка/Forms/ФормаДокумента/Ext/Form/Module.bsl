﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если (Объект.Автор <> ПараметрыСеанса.ТекущийПользователь) И (Объект.Адресат <> ПараметрыСеанса.ТекущийПользователь) Тогда
			
			Элементы.Дата.ТолькоПросмотр = Истина;
			Элементы.Адресат.ТолькоПросмотр = Истина;        
			Элементы.Проблема.ТолькоПросмотр = Истина;
			Элементы.Ответ.ТолькоПросмотр = Истина;
			
			Если НЕ РольДоступна("ПолныеПрава") ИЛИ НЕ РольДоступна("ТолькоПросмотр") Тогда
				Элементы.Документ.ТолькоПросмотр = Истина;
				Элементы.Документ.Доступность = Ложь;
			КонецЕсли;
			
		ИначеЕсли (Объект.Автор = ПараметрыСеанса.ТекущийПользователь) Тогда
			
			Элементы.Ответ.ТолькоПросмотр = Истина;
			
		ИначеЕсли (Объект.Адресат = ПараметрыСеанса.ТекущийПользователь) И НЕ Объект.Завершить Тогда
			
			Элементы.Дата.ТолькоПросмотр = Истина;
			Элементы.Проблема.ТолькоПросмотр = Истина;	
			Элементы.Завершить.ТолькоПросмотр = Истина;
			
		ИначеЕсли (Объект.Адресат = ПараметрыСеанса.ТекущийПользователь) И Объект.Завершить Тогда
			Элементы.Дата.ТолькоПросмотр = Истина;
			Элементы.Адресат.ТолькоПросмотр = Истина;
			Элементы.Проблема.ТолькоПросмотр = Истина;
			Элементы.Ответ.ТолькоПросмотр = Истина;
			Элементы.Завершить.ТолькоПросмотр = Истина;
		КонецЕсли;
	Иначе
		Элементы.Ответ.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ХранимыеФайлыВерсий.ВерсияФайла) КАК Количество
	|ИЗ
	|	РегистрСведений.ХранимыеФайлыВерсий КАК ХранимыеФайлыВерсий
	|ГДЕ
	|	ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла = &ВладелецФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	КоличествоФайлов = Выборка.Количество;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Отказ = НЕ ПроверитьЗаполнение();
	
	Объект.Проблема = СокрЛП(Объект.Проблема);
	Объект.Ответ = СокрЛП(Объект.Ответ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорученияПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтветПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаОтвета) Тогда
		Объект.ДатаОтвета = ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры

