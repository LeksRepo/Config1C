﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Не ОбщегоНазначения.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	Если ТипЗнч(ТекущийПользователь) <> Тип("СправочникСсылка.ВнешниеПользователи") Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.ИнформацияДляПользователя;
	Иначе	
		Объект.Респондент = ВнешниеПользователи.ПолучитьОбъектАвторизацииВнешнегоПользователя(ТекущийПользователь);
		ПолучитьТаблицуАнкетРеспондента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Анкета" ИЛИ ИмяСобытия = "Проведение_Анкета" Тогда
		ПолучитьТаблицуАнкетРеспондента();
	КонецЕсли;
	
КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ДеревоАнкетПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.ТаблицаАнкет.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.АнкетаОпрос) = Тип("ДокументСсылка.Анкета") Тогда
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Ключ",ТекущиеДанные.АнкетаОпрос);
		СтруктураПараметров.Вставить("ТолькоФормаЗаполнения",Истина);
		Если ТекущиеДанные.Статус = "Отвеченные анкеты" Тогда
			СтруктураПараметров.Вставить("ТолькоПросмотр",Истина);
		КонецЕсли;
		
		ОткрытьФорму("Документ.Анкета.Форма.ФормаДокумента",СтруктураПараметров,Элемент);
		
	ИначеЕсли ТипЗнч(ТекущиеДанные.АнкетаОпрос) = Тип("ДокументСсылка.НазначениеОпросов") Тогда
		
		СтруктураПараметров = Новый Структура;
		ЗначенияЗаполнения 	= Новый Структура;
		
		ЗначенияЗаполнения.Вставить("Респондент",Объект.Респондент);
		ЗначенияЗаполнения.Вставить("Опрос",ТекущиеДанные.АнкетаОпрос);
		СтруктураПараметров.Вставить("ЗначенияЗаполнения",ЗначенияЗаполнения);
		СтруктураПараметров.Вставить("ТолькоФормаЗаполнения",Истина);
		
		ОткрытьФорму("Документ.Анкета.Форма.ФормаДокумента",СтруктураПараметров,Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура АрхивАнкет(Команда)
	
	ОткрытьФорму("Обработка.СписокРеспондента.Форма.АрхивАнкет",Новый Структура("Респондент",Объект.Респондент),ЭтотОбъект);
	
КонецПроцедуры 

&НаКлиенте
Процедура Обновить(Команда)
	
	ПолучитьТаблицуАнкетРеспондента();
	
КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПолучитьТаблицуАнкетРеспондента()
	
	ТаблицаАнкет.Очистить();
	
	ПолученнаяТаблицаАнкет = Анкетирование.ПолучитьТаблицуДоступныхРеспондентуАнкет(Объект.Респондент);
	
	Если ПолученнаяТаблицаАнкет <> Неопределено Тогда
		
		Для каждого СтрокаТаблицы Из ПолученнаяТаблицаАнкет Цикл
			
			НоваяСтрока = ТаблицаАнкет.Добавить();
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.АнкетаОпрос) Тогда
				
				НоваяСтрока.Представление = СтрокаТаблицы.Статус;
				НоваяСтрока.Статус        = СтрокаТаблицы.Статус;
				
			Иначе
				
				НоваяСтрока.Статус        = СтрокаТаблицы.Статус;
				НоваяСтрока.АнкетаОпрос   = СтрокаТаблицы.АнкетаОпрос;
				НоваяСтрока.Представление = ПолучитьПредставлениеСтрокиДереваАнкеты(СтрокаТаблицы);
				
			КонецЕсли;
			
		КонецЦикла;
		
		НоваяСтрока.КодКартинки = ?(СтрокаТаблицы.Статус = "Опросы",0,1);
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует представление строки для дерева анкет
//
// Параметры
//  СтрокаДерева  - СтрокаДереваЗначений - на основании ее формируется представление 
//                 анкет и опросов в дереве 
&НаСервере
Функция ПолучитьПредставлениеСтрокиДереваАнкеты(СтрокаДерева)
	
	СтрокаВозврата = "";
	
	ЕстьОграниченияПоСроку = ЗначениеЗаполнено(СтрокаДерева.ДатаОкончания);
	Закончился = ?(ЗначениеЗаполнено(СтрокаДерева.ДатаОкончания),
		?(ТекущаяДатаСеанса() <= СтрокаДерева.ДатаОкончания, Ложь, Истина), Ложь);
	
	Если ТипЗнч(СтрокаДерева.АнкетаОпрос) = Тип("ДокументСсылка.НазначениеОпросов") Тогда
		СтрокаВозврата = СтрокаВозврата + НСтр("ru = 'Анкета'") + " '" + СтрокаДерева.Наименование + "'";
	ИначеЕсли ТипЗнч(СтрокаДерева.АнкетаОпрос) = Тип("ДокументСсылка.Анкета") Тогда
		СтрокаВозврата = СтрокаВозврата + НСтр("ru = 'Анкета'") + " '" + СтрокаДерева.Наименование + 
			"', " + НСтр("ru = 'последний раз редактировавшаяся'") + " " + Формат(СтрокаДерева.ДатаАнкеты, "ДФ=dd.MM.yyyy");
	Иначе	
		Возврат СтрокаВозврата;
	КонецЕсли;
	
	Если ЕстьОграниченияПоСроку Тогда
			СтрокаВозврата = СтрокаВозврата + ", " + НСтр("ru = 'к заполнению до'") + " " + Формат(НачалоДня(КонецДня(СтрокаДерева.ДатаОкончания) + 1),"ДФ=dd.MM.yyyy");
	КонецЕсли;
		
	СтрокаВозврата = СтрокаВозврата + ".";
	
	Возврат СтрокаВозврата;
	
КонецФункции

