﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	ПользовательАдминистратор = УправлениеДоступомПереопределяемый.ЕстьДоступКПрофилюГруппДоступа(Пользователь, Справочники.ПрофилиГруппДоступа.Администратор);
	ПользовательКадроваяСлужба = УправлениеДоступомПереопределяемый.ЕстьДоступКПрофилюГруппДоступа(Пользователь, Справочники.ПрофилиГруппДоступа.КадроваяСлужба);
	
	ДоступностьФормы = ПользовательКадроваяСлужба ИЛИ ПользовательАдминистратор;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если НЕ ДоступностьФормы И (Объект.Автор <> Пользователь) И (Объект.Адресат <> Пользователь) ИЛИ (Объект.СтатусСлужебнойЗаписки = Перечисления.СтатусыСлужебныхЗаписок.Выполнена) Тогда
			
			ЭтаФорма.ТолькоПросмотр = Истина;
						
		ИначеЕсли (Объект.Автор = ПараметрыСеанса.ТекущийПользователь) Тогда
			
			Элементы.Ответ.ТолькоПросмотр = Истина;
			
		ИначеЕсли (Объект.Адресат = ПараметрыСеанса.ТекущийПользователь) И НЕ (Объект.СтатусСлужебнойЗаписки = Перечисления.СтатусыСлужебныхЗаписок.Выполнена) Тогда
			
			Элементы.Дата.ТолькоПросмотр = Истина;
			Элементы.Проблема.ТолькоПросмотр = Истина;	
			Элементы.ДатаКонтроля.ТолькоПросмотр = Истина;
			Элементы.ВидСлужебнойЗаписки.ТолькоПросмотр = Истина;	
			Элементы.СтатусСлужебнойЗаписки.ТолькоПросмотр = Истина;
			Элементы.Виновный.ТолькоПросмотр = Истина;
			Элементы.Тема.ТолькоПросмотр = Истина;
			
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

