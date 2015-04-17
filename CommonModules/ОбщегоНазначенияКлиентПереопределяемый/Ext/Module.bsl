﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// В этом модуле содержится реализация обработчиков модуля приложения. 
//
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Выполняется перед интерактивном началом работы пользователя с областью данных.
// Соответствует обработчику ПередНачаломРаботыСистемы
//
// Параметры:
// Отказ - Булево - отказ в от начала работы. Если параметр установить в Истина,
// начало работы с областью осуществлено не будет.
//
Процедура ПередНачаломРаботыСистемы(Отказ) Экспорт
	
КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных.
// Соответствует обработчику ПриНачалеРаботыСистемы
//
// Параметры
//  ОбрабатыватьПараметрыЗапуска - Булево - Истина, если обработчик вызван при 
//  непосредственном входе пользователя в систему и должен обработать параметры
//  запуска (если это предусмотрено его логикой). Иначе обработчика вызван
//  при интерактивном входе неразделенного пользователя в область данных и
//  обрабатывать параметры запуска не следует.
//
Процедура ПриНачалеРаботыСистемы(Знач ОбрабатыватьПараметрыЗапуска = Ложь) Экспорт
	
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		ОповещениеСообщенияДилерам();
		
	Иначе
		
		Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
		ОтображатьИмяБазы = ЛексСервер.ПолучитьЗначениеНастройкиПользователя(Пользователь, ПредопределенноеЗначение("ПланВидовХарактеристик.НастройкиПользователей.ОтображатьИмяБазы"));
		
		Если ЗначениеЗаполнено(ОтображатьИмяБазы) И ОтображатьИмяБазы Тогда
		
			Стр = СтрокаСоединенияИнформационнойБазы();
			
			Если Найти(Стр, "Ref") > 0 Тогда
				
				ИмяБазы = "База: " + СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаСоединенияИнформационнойБазы(), """")[3];
				Заголовок = ИмяБазы +" / "+ Пользователь;
				
				
			Иначе
				
				ИмяБазы = "База: Рабочая";
				Заголовок = ИмяБазы +" / "+ Пользователь;
	
			КонецЕсли;
			
			УстановитьЗаголовокКлиентскогоПриложения(Заголовок);

		КонецЕсли;

		ОповещениеСлужебныхЗаписок();
		ПодключитьОбработчикОжидания("ОповещениеСлужебныхЗаписок", 900);
		
	КонецЕсли;
	
	#Если ТонкийКлиент Тогда
		
		СистемнаяИнформация = Новый СистемнаяИнформация;
		ТекущийТипПлатформы = СистемнаяИнформация.ТипПлатформы;
		
		Если ТекущийТипПлатформы = ТипПлатформы.Windows_x86 или ТекущийТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		
			ФСО=Новый COMОбъект("Scripting.FileSystemObject");
			ФСО_Диск=ФСО.GetDrive("C");
			СерийникДискаС = ФСО_Диск.SerialNumber;
			
		КонецЕсли;
			
	#Иначе
		
		СерийникДискаС = "ВебКлиент";
		
	#КонецЕсли
	
	ЛексСервер.ЗаписатьВходПользователя(СерийникДискаС);
	
КонецПроцедуры

// Обработать параметры запуска программы.
// Реализация функции может быть расширена для обработки новых параметров.
//
// Параметры
//  ЗначениеПараметраЗапуска - Строка - первое значение параметра запуска, 
//                                      до первого символа ";"
//  ПараметрыЗапуска  – Строка – параметр запуска, переданный в конфигурацию 
//                               с помощью ключа командной строки /C.
//
// Возвращаемое значение:
//   Булево   – Истина, если необходимо прервать выполнение процедуры ПриНачалеРаботыСистемы.
//
Функция ОбработатьПараметрыЗапуска(ЗначениеПараметраЗапуска, ПараметрыЗапуска) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Соответствует обработчику ПередЗавершениемРаботыСистемы.
//
Процедура ПередЗавершениемРаботыСистемы(Отказ) Экспорт
	
КонецПроцедуры

Процедура ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация, Организация, ВключатьОбособленныеПодразделения) Экспорт
	
	Если Не ЗначениеЗаполнено(ПолеОрганизация) Тогда 
		Организация                       = Неопределено;
		ВключатьОбособленныеПодразделения = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка, ПолеОрганизация, СоответствиеОрганизаций) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ПолеОрганизация) Тогда
		Если СоответствиеОрганизаций.Свойство(ПолеОрганизация) Тогда
			Значение = СоответствиеОрганизаций[ПолеОрганизация];
			Если ТипЗнч(Значение) = Тип("Структура") Тогда				
				ОткрытьЗначение(Значение.Организация);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, СоответствиеОрганизаций,
	Организация, ВключатьОбособленныеПодразделения) Экспорт 
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Значение = СоответствиеОрганизаций[ВыбранноеЗначение];
		Если ТипЗнч(Значение) = Тип("Структура") Тогда 
			Организация = Значение.Организация;
			ВключатьОбособленныеПодразделения = Значение.ВключатьОбособленныеПодразделения;
		Иначе
			Организация = Неопределено;
			ВключатьОбособленныеПодразделения = Неопределено;
		КонецЕсли;
	Иначе
		Организация = Неопределено;
		ВключатьОбособленныеПодразделения = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает Истина, если при изменении даты документа требуется перечитать 
// настройки из базы данных на сервере.
//
Функция ТребуетсяВызовСервераПриИзмененииДатыДокумента(НоваяДата, ПредыдущаяДата,
	ВалютаДокумента = Неопределено, ВалютаРегламентированногоУчета = Неопределено) Экспорт
	
	Результат = Ложь;
	
	Если НачалоДня(НоваяДата) = НачалоДня(ПредыдущаяДата) Тогда
		// Ничего не изменилось либо изменилось только время, от которого ничего не зависит
		Возврат Ложь;
	КонецЕсли;
	
	Если НачалоМесяца(НоваяДата) <> НачалоМесяца(ПредыдущаяДата) Тогда
		// Учетная политика задается с периодичностью до месяца,
		// поэтому в пределах месяца изменения даты не учитываем.
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ОповещениеСообщенияДилерам() Экспорт
	
	Данные = ЛексСервер.ПолучитьСписокНеОзнакомленныхСообщенийДилерам();
	
	Если Данные.Количество > 0 Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("АдресТаблицы", Данные.АдресТаблицы);
		
		ОткрытьФорму("ОбщаяФорма.ФормаНеОзнакомленныхСообщенийДилерам", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры
