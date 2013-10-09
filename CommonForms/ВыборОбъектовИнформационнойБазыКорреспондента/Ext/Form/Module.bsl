﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РежимПодбора = (Параметры.ЗакрыватьПриВыборе = Ложь);
	ИмяРеквизита = Параметры.ИмяРеквизита;
	
	Если Параметры.ПараметрыВнешнегоСоединения.ТипСоединения = "ВнешнееСоединение" Тогда
		
		СтрокаСообщенияОбОшибке = "";
		
		ВнешнееСоединение = ОбменДаннымиПовтИсп.УстановитьВнешнееСоединение(Параметры.ПараметрыВнешнегоСоединения, СтрокаСообщенияОбОшибке);
		
		Если ВнешнееСоединение = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщенияОбОшибке,,,, Отказ);
			Возврат;
		КонецЕсли;
		
		СвойстваОбъектаМетаданных = ВнешнееСоединение.ОбменДаннымиВнешнееСоединение.СвойстваОбъектаМетаданных(Параметры.ПолноеИмяТаблицыБазыКорреспондента);
		
		Если Параметры.ПараметрыВнешнегоСоединения.ВерсияКорреспондента_2_1_1_7
			ИЛИ Параметры.ПараметрыВнешнегоСоединения.ВерсияКорреспондента_2_0_1_6 Тогда
			
			ТаблицаБазыКорреспондента = ОбщегоНазначения.ЗначениеИзСтрокиXML(ВнешнееСоединение.ОбменДаннымиВнешнееСоединение.ПолучитьОбъектыТаблицы_2_0_1_6(Параметры.ПолноеИмяТаблицыБазыКорреспондента));
			
		Иначе
			
			ТаблицаБазыКорреспондента = ЗначениеИзСтрокиВнутр(ВнешнееСоединение.ОбменДаннымиВнешнееСоединение.ПолучитьОбъектыТаблицы(Параметры.ПолноеИмяТаблицыБазыКорреспондента));
			
		КонецЕсли;
		
	ИначеЕсли Параметры.ПараметрыВнешнегоСоединения.ТипСоединения = "ВебСервис" Тогда
		
		СтрокаСообщенияОбОшибке = "";
		
		Если Параметры.ПараметрыВнешнегоСоединения.ВерсияКорреспондента_2_1_1_7 Тогда
			
			WSПрокси = ОбменДаннымиСервер.ПолучитьWSПрокси_2_1_1_7(Параметры.ПараметрыВнешнегоСоединения, СтрокаСообщенияОбОшибке);
			
		ИначеЕсли Параметры.ПараметрыВнешнегоСоединения.ВерсияКорреспондента_2_0_1_6 Тогда
			
			WSПрокси = ОбменДаннымиСервер.ПолучитьWSПрокси_2_0_1_6(Параметры.ПараметрыВнешнегоСоединения, СтрокаСообщенияОбОшибке);
			
		Иначе
			
			WSПрокси = ОбменДаннымиСервер.ПолучитьWSПрокси(Параметры.ПараметрыВнешнегоСоединения, СтрокаСообщенияОбОшибке);
			
		КонецЕсли;
		
		Если WSПрокси = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщенияОбОшибке,,,, Отказ);
			Возврат;
		КонецЕсли;
		
		Если Параметры.ПараметрыВнешнегоСоединения.ВерсияКорреспондента_2_1_1_7
			ИЛИ Параметры.ПараметрыВнешнегоСоединения.ВерсияКорреспондента_2_0_1_6 Тогда
			
			ДанныеБазыКорреспондента = СериализаторXDTO.ПрочитатьXDTO(WSПрокси.GetIBData(Параметры.ПолноеИмяТаблицыБазыКорреспондента));
			
			СвойстваОбъектаМетаданных = ДанныеБазыКорреспондента.СвойстваОбъектаМетаданных;
			ТаблицаБазыКорреспондента = ОбщегоНазначения.ЗначениеИзСтрокиXML(ДанныеБазыКорреспондента.ТаблицаБазыКорреспондента);
			
		Иначе
			
			ДанныеБазыКорреспондента = ЗначениеИзСтрокиВнутр(WSПрокси.GetIBData(Параметры.ПолноеИмяТаблицыБазыКорреспондента));
			
			СвойстваОбъектаМетаданных = ЗначениеИзСтрокиВнутр(ДанныеБазыКорреспондента.СвойстваОбъектаМетаданных);
			ТаблицаБазыКорреспондента = ЗначениеИзСтрокиВнутр(ДанныеБазыКорреспондента.ТаблицаБазыКорреспондента);
			
		КонецЕсли;
		
	ИначеЕсли Параметры.ПараметрыВнешнегоСоединения.ТипСоединения = "ВременноеХранилище" Тогда
		
		ДанныеБазыКорреспондента = ПолучитьИзВременногоХранилища(
			Параметры.ПараметрыВнешнегоСоединения.АдресВременногоХранилища
		).Получить().Получить(Параметры.ПолноеИмяТаблицыБазыКорреспондента);
		
		СвойстваОбъектаМетаданных = ДанныеБазыКорреспондента.СвойстваОбъектаМетаданных;
		ТаблицаБазыКорреспондента = ОбщегоНазначения.ЗначениеИзСтрокиXML(ДанныеБазыКорреспондента.ТаблицаБазыКорреспондента);
		
	КонецЕсли;
	
	Заголовок = СвойстваОбъектаМетаданных.Синоним;
	
	Элементы.Список.Отображение = ?(СвойстваОбъектаМетаданных.Иерархический = Истина, ОтображениеТаблицы.ИерархическийСписок, ОтображениеТаблицы.Список);
	
	КоллекцияЭлементовДерева = Список.ПолучитьЭлементы();
	КоллекцияЭлементовДерева.Очистить();
	ОбщегоНазначения.ЗаполнитьКоллекциюЭлементовДереваДанныхФормы(КоллекцияЭлементовДерева, ТаблицаБазыКорреспондента);
	
	// Позиционирование курсора в дереве значений
	Если Не ПустаяСтрока(Параметры.НачальноеЗначениеВыбора) Тогда
		
		ИдентификаторСтроки = 0;
		
		ОбщегоНазначенияКлиентСервер.ПолучитьИдентификаторСтрокиДереваПоЗначениюПоля("Идентификатор", ИдентификаторСтроки, КоллекцияЭлементовДерева, Параметры.НачальноеЗначениеВыбора, Ложь);
		
		Элементы.Список.ТекущаяСтрока = ИдентификаторСтроки;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбработкаВыбораЗначения();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьЗначение(Команда)
	
	ОбработкаВыбораЗначения();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработкаВыбораЗначения()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Новый Структура("Представление, Идентификатор");
	
	ЗаполнитьЗначенияСвойств(Данные, ТекущиеДанные);
	
	Данные.Вставить("РежимПодбора", РежимПодбора);
	Данные.Вставить("ИмяРеквизита", ИмяРеквизита);
	
	ОповеститьОВыборе(Данные);
	
КонецПроцедуры
