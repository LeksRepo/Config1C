﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Отчет = Параметры.Отчет;
	ИдентификаторРегламентногоЗадания = Параметры.ИдентификаторРегламентногоЗадания;
	Заголовок = Параметры.Заголовок;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
		ПодсистемаРегламентныеЗаданияСуществует = Истина;
		Элементы.ИзменитьРасписание.Видимость = Истина;
	Иначе
		Элементы.ИзменитьРасписание.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтчетОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДатаНачала = Расшифровка.Получить(0);
	ДатаОкончания = Расшифровка.Получить(1);
	СеансРегламентногоЗадания.Очистить();
	СеансРегламентногоЗадания.Добавить(Расшифровка.Получить(2)); 
	ОтборЖурналаРегистрации = Новый Структура("Сеанс, ДатаНачала, ДатаОкончания", СеансРегламентногоЗадания, ДатаНачала, ДатаОкончания);
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ОтборЖурналаРегистрации);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗадания(Команда)
	
	Если ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания) Тогда
		
		Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ПолучитьРасписание());
		
		ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеРегламентногоЗаданияЗавершение", ЭтотОбъект);
		Диалог.Показать(ОписаниеОповещения);
		
	Иначе
		ПоказатьПредупреждение(,НСтр("ru = 'Невозможно получить расписание регламентного задания: регламентное задание было удалено или не указано его наименование.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКЖурналуРегистрации(Команда)
	
	Для Каждого Область Из Отчет.ВыделенныеОбласти Цикл
		Расшифровка = Область.Расшифровка;
		Если Расшифровка = Неопределено
			ИЛИ Область.Верх <> Область.Низ Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Выберите строку или ячейку нужного сеанса задания'"));
			Возврат;
		КонецЕсли;
		ДатаНачала = Расшифровка.Получить(0);
		ДатаОкончания = Расшифровка.Получить(1);
		СеансРегламентногоЗадания.Очистить();
		СеансРегламентногоЗадания.Добавить(Расшифровка.Получить(2));
		ОтборЖурналаРегистрации = Новый Структура("Сеанс, ДатаНачала, ДатаОкончания", СеансРегламентногоЗадания, ДатаНачала, ДатаОкончания);
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ОтборЖурналаРегистрации);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьРасписание()
	
	УстановитьПривилегированныйРежим(Истина);
	
	МодульРегламентныеЗаданияСервер = ОбщегоНазначения.ОбщийМодуль("РегламентныеЗаданияСервер");
	Возврат МодульРегламентныеЗаданияСервер.ПолучитьРасписаниеРегламентногоЗадания(
		ИдентификаторРегламентногоЗадания);
	
КонецФункции

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗаданияЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание <> Неопределено Тогда
		УстановитьРасписаниеРегламентногоЗадания(Расписание);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРасписаниеРегламентногоЗадания(Расписание)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МодульРегламентныеЗаданияСервер = ОбщегоНазначения.ОбщийМодуль("РегламентныеЗаданияСервер");
	МодульРегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(
		ИдентификаторРегламентногоЗадания,
		Расписание);
	
КонецПроцедуры

#КонецОбласти
