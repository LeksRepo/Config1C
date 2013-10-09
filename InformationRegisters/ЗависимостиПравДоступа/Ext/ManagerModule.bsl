﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура обновляет данные регистра, если прикладной разработчик
// изменил зависимости в переопределяемом модуле.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьДанныеРегистра(ЕстьИзменения = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗависимостиПравДоступа = РегистрыСведений.ЗависимостиПравДоступа.СоздатьНаборЗаписей();
	
	Таблица = ЗависимостиПравДоступа.Выгрузить();
	Таблица.Колонки.Удалить("ПодчиненнаяТаблица");
	Таблица.Колонки.Добавить("ПодчиненнаяТаблица",
		Новый ОписаниеТипов("Строка, СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	
	СтандартныеПодсистемыПереопределяемый.ЗаполнитьЗависимостиПравДоступа(Таблица);
	УправлениеДоступомПереопределяемый.ЗаполнитьЗависимостиПравДоступа(Таблица);
	
	Для каждого Строка Из Таблица Цикл
		Если ТипЗнч(Строка.ПодчиненнаяТаблица) = Тип("Строка") Тогда
			Строка.ПодчиненнаяТаблица = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
				Строка.ПодчиненнаяТаблица);
		КонецЕсли;
	КонецЦикла;
	
	ЗависимостиПравДоступа.Загрузить(Таблица);
	
	ИсправитьЗависимости(ЗависимостиПравДоступа);
	
	ТекстЗапросовВременныхТаблиц =
	"ВЫБРАТЬ
	|	НовыеДанные.ПодчиненнаяТаблица,
	|	НовыеДанные.ТипВедущейТаблицы,
	|	НовыеДанные.ОтключитьПроверкуПравВедущейТаблицы,
	|	НовыеДанные.ПриПроверкеПраваЧтение,
	|	НовыеДанные.ПриПроверкеПраваДобавление,
	|	НовыеДанные.ПриПроверкеПраваИзменение,
	|	НовыеДанные.ПриПроверкеПраваУдаление
	|ПОМЕСТИТЬ НовыеДанные
	|ИЗ
	|	&ЗависимостиПравДоступа КАК НовыеДанные";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НовыеДанные.ПодчиненнаяТаблица,
	|	НовыеДанные.ТипВедущейТаблицы,
	|	НовыеДанные.ОтключитьПроверкуПравВедущейТаблицы,
	|	НовыеДанные.ПриПроверкеПраваЧтение,
	|	НовыеДанные.ПриПроверкеПраваДобавление,
	|	НовыеДанные.ПриПроверкеПраваИзменение,
	|	НовыеДанные.ПриПроверкеПраваУдаление,
	|	&ПодстановкаПоляВидИзмененияСтроки
	|ИЗ
	|	НовыеДанные КАК НовыеДанные";
	
	// Подготовка выбираемых полей с необязательным отбором.
	Поля = Новый Массив;
	Поля.Добавить(Новый Структура("ПодчиненнаяТаблица"));
	Поля.Добавить(Новый Структура("ТипВедущейТаблицы"));
	Поля.Добавить(Новый Структура("ОтключитьПроверкуПравВедущейТаблицы"));
	Поля.Добавить(Новый Структура("ПриПроверкеПраваЧтение"));
	Поля.Добавить(Новый Структура("ПриПроверкеПраваДобавление"));
	Поля.Добавить(Новый Структура("ПриПроверкеПраваИзменение"));
	Поля.Добавить(Новый Структура("ПриПроверкеПраваУдаление"));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗависимостиПравДоступа", ЗависимостиПравДоступа);
	
	Запрос.Текст = УправлениеДоступомСлужебный.ТекстЗапросаВыбораИзменений(
		ТекстЗапроса, Поля, "РегистрСведений.ЗависимостиПравДоступа", ТекстЗапросовВременныхТаблиц);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Константа.ПараметрыОграниченияДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗависимостиПравДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Изменения = Запрос.Выполнить().Выгрузить();
		
		УправлениеДоступомСлужебный.ОбновитьРегистрСведений(
			РегистрыСведений.ЗависимостиПравДоступа, Изменения, ЕстьИзменения);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ИсправитьЗависимости(НаборЗаписей) Экспорт
	
	ВозможныеПрава = Новый Соответствие;
	ВозможныеПрава.Вставить(ПланыВидовХарактеристик.ВидыДоступа.ПравоЧтения,     Истина);
	ВозможныеПрава.Вставить(ПланыВидовХарактеристик.ВидыДоступа.ПравоДобавления, Истина);
	ВозможныеПрава.Вставить(ПланыВидовХарактеристик.ВидыДоступа.ПравоИзменения,  Истина);
	
	Для каждого Запись Из НаборЗаписей Цикл
		
		Если ВозможныеПрава[Запись.ПриПроверкеПраваЧтение] = Неопределено Тогда
			Запись.ПриПроверкеПраваЧтение = ПланыВидовХарактеристик.ВидыДоступа.ПравоЧтения;
		КонецЕсли;
		
		Если ВозможныеПрава[Запись.ПриПроверкеПраваДобавление] = Неопределено Тогда
			Запись.ПриПроверкеПраваДобавление = ПланыВидовХарактеристик.ВидыДоступа.ПравоИзменения;
		КонецЕсли;
		
		Если ВозможныеПрава[Запись.ПриПроверкеПраваИзменение] = Неопределено Тогда
			Запись.ПриПроверкеПраваИзменение = ПланыВидовХарактеристик.ВидыДоступа.ПравоИзменения;
		КонецЕсли;
		
		Если ВозможныеПрава[Запись.ПриПроверкеПраваУдаление] = Неопределено Тогда
			Запись.ПриПроверкеПраваЧтение = ПланыВидовХарактеристик.ВидыДоступа.ПравоИзменения;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


#КонецЕсли