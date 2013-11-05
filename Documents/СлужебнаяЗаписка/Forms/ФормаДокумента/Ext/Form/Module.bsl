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
	Элементы.Служебное.ТолькоПросмотр = НЕ ДоступностьФормы;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если НЕ ДоступностьФормы И (Объект.Автор <> Пользователь) И (Объект.Адресат <> Пользователь) Тогда
			
			ЭтаФорма.ТолькоПросмотр = Истина;
					
		ИначеЕсли (Объект.Автор = ПараметрыСеанса.ТекущийПользователь) Тогда
			
			Элементы.Ответ.ТолькоПросмотр = Истина;
			Элементы.Ознакомлен.ТолькоПросмотр = Истина;
			Элементы.НеСогласен.ТолькоПросмотр = Истина;
			Элементы.Утверждаю.ТолькоПросмотр = Истина;
			
		ИначеЕсли (Объект.Адресат = ПараметрыСеанса.ТекущийПользователь) Тогда
			
			Элементы.Проблема.ТолькоПросмотр = Истина;	
			Элементы.ДатаКонтроля.ТолькоПросмотр = Истина;
			Элементы.ВидСлужебнойЗаписки.ТолькоПросмотр = Истина;	
			Элементы.Виновный.ТолькоПросмотр = Истина;
			Элементы.Тема.ТолькоПросмотр = Истина;
			Элементы.Утверждаю.ТолькоПросмотр = Истина;
			
		КонецЕсли;
	Иначе
		Элементы.Ответ.ТолькоПросмотр = Истина;
		Элементы.Ознакомлен.ТолькоПросмотр = Истина;
		Элементы.НеСогласен.ТолькоПросмотр = Истина;
		Элементы.Утверждаю.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
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

