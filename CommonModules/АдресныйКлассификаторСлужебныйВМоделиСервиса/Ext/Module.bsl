﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Адресный классификатор в модели сервиса".
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ПоставляемыеДанные") Тогда
		СерверныеОбработчики[
			"СтандартныеПодсистемы.РаботаВМоделиСервиса.ПоставляемыеДанные\ПриОпределенииОбработчиковПоставляемыхДанных"
		].Добавить("АдресныйКлассификаторСлужебныйВМоделиСервиса");
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ВыгрузкаЗагрузкаДанных") Тогда
		СерверныеОбработчики[
			"ТехнологияСервиса.ВыгрузкаЗагрузкаДанных\ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки"
		].Добавить("АдресныйКлассификаторСлужебныйВМоделиСервиса");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ПОЛУЧЕНИЯ ПОСТАВЛЯЕМЫХ ДАННЫХ

// Регистрирует обработчики поставляемых данных за день и за все время
//
Процедура ЗарегистрироватьОбработчикиПоставляемыхДанных(Знач Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ВидДанных = "КЛАДР";
	Обработчик.КодОбработчика = "КЛАДР";
	Обработчик.Обработчик = АдресныйКлассификаторСлужебныйВМоделиСервиса;
	
КонецПроцедуры

// Вызывается при получении уведомления о новых данных.
// В теле следует проверить, необходимы ли эти данные приложению, 
// и если да - установить флажок Загружать
// 
// Параметры:
//   Дескриптор   - ОбъектXDTO Descriptor.
//   Загружать    - булево, возвращаемое
//
Процедура ДоступныНовыеДанные(Знач Дескриптор, Загружать) Экспорт
	
	Если Дескриптор.DataType = "КЛАДР" Тогда
		Загружать = ПроверитьНаличиеНовыхДанных(Дескриптор);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после вызова ДоступныНовыеДанные, позволяет разобрать данные.
//
// Параметры:
//   Дескриптор   - ОбъектXDTO Дескриптор.
//   ПутьКФайлу   - Строка или Неопределено. Полное имя извлеченного файла. Файл будет автоматически удален 
//                  после завершения процедуры. Если в менеджере сервиса не был
//                  указан файл - значение аргумента равно Неопределено.
//
Процедура ОбработатьНовыеДанные(Знач Дескриптор, Знач ПутьКФайлу) Экспорт
	
	Если Дескриптор.DataType = "КЛАДР" Тогда
		ОбработатьКЛАДР(Дескриптор, ПутьКФайлу);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при отмене обработки данных в случае сбоя
//
Процедура ОбработкаДанныхОтменена(Знач Дескриптор) Экспорт 
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДатаКЛАДРа(Знач Дескриптор)
	
	// Получаем значение характеристики "Дата" поставляемых данных. 
	// В штатной ситуации, там лежит строка вида ГГГГММДД. 
	// Если в результате ручного редактирования туда было записано что-то другое, 
	// либо характеристика отсутствует, программа далее считает, что загружать КЛАДР не нужно.
	Для Каждого Характеристика Из Дескриптор.Properties.Property Цикл
		Если Характеристика.Code = "Дата" Тогда
			Попытка
				Возврат Дата(Характеристика.Value);
			Исключение
			КонецПопытки;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПроверитьНаличиеНовыхДанных(Знач Дескриптор)
	
	ДатаНовыхДанных = ДатаКЛАДРа(Дескриптор);
	
	Если ДатаНовыхДанных = Неопределено Тогда 
		Возврат Истина;
	КонецЕсли;
	
	КлассификаторАдресныхОбъектовXML =
	РегистрыСведений.АдресныйКлассификатор.ПолучитьМакет("КлассификаторАдресныхОбъектовРоссии").ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторАдресныхОбъектовXML).Данные;
	ВерсииХранимыхСведений = АдресныйКлассификатор.ВерсииАдресныхОбъектов();
	ТекущиеВерсии = Новый Соответствие;
	Для Каждого ЭлементСписка Из ВерсииХранимыхСведений Цикл
		ТекущиеВерсии.Вставить(ЭлементСписка.Представление, ЭлементСписка.Значение);
	КонецЦикла;
	
	Для Каждого АдресныйОбъект Из КлассификаторТаблица Цикл
		ТекущаяВерсия = ТекущиеВерсии[Лев(АдресныйОбъект.Code, 2)];
		Если Не ЗначениеЗаполнено(ТекущаяВерсия) Или ТекущаяВерсия < ДатаНовыхДанных Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	ТекущаяВерсия = ТекущиеВерсии["SO"];
	Если Не ЗначениеЗаполнено(ТекущаяВерсия) Или ТекущаяВерсия < ДатаНовыхДанных Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура ОбработатьКЛАДР(Знач Дескриптор, Знач ПутьКФайлу)
	Перем ДоступныеВерсии, ИсточникДанныхДляЗагрузки;
	
	ПутьККаталогуНаСервере = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла());
	Попытка
		ЧтениеZIP = Новый ЧтениеZipФайла(ПутьКФайлу);
		ЧтениеZIP.ИзвлечьВсе(ПутьККаталогуНаСервере,
		РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
		ЧтениеZIP.Закрыть();
		
		ФайлВерсий = Новый Файл(ПутьККаталогуНаСервере + "versions.xml");
		Если ФайлВерсий.Существует() Тогда
			
			ТекстовыйДокумент = Новый ТекстовыйДокумент;
			ТекстовыйДокумент.Прочитать(ФайлВерсий.ПолноеИмя);
			ТекстXML = ТекстовыйДокумент.ПолучитьТекст();
			
			ДоступныеВерсии = АдресныйКлассификатор.ПолучитьВерсииАдресныхСведений(ТекстXML);
			ИсточникДанныхДляЗагрузки = 1;
		Иначе
			ВерсияЗагружаемогоКЛАДР =ДатаКЛАДРа(Дескриптор);
			Если ВерсияЗагружаемогоКЛАДР = Неопределено Тогда
				ФайлКЛАДР = Новый Файл(ПутьККаталогуНаСервере + "KLADR.DBF");
				ВерсияЗагружаемогоКЛАДР = НачалоДня(ФайлКЛАДР.ПолучитьВремяИзменения());
			КонецЕсли;	
			
		КонецЕсли;
		
		КлассификаторАдресныхОбъектовXML =
		РегистрыСведений.АдресныйКлассификатор.ПолучитьМакет("КлассификаторАдресныхОбъектовРоссии").ПолучитьТекст();
		
		КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторАдресныхОбъектовXML).Данные;
		
		АдресныеОбъекты = Новый Массив;
		Для Каждого АдресныйОбъект Из КлассификаторТаблица Цикл
			АдресныеОбъекты.Добавить(Лев(АдресныйОбъект.Code, 2));
		КонецЦикла;
		АдресныеОбъекты.Добавить("SO");
		
		ПараметрыЗагрузки = Новый Структура("АдресныеОбъекты, ПутьКДаннымНаСервере, ВерсияЗагружаемогоКЛАДР, ИсточникДанныхДляЗагрузки, ДоступныеВерсии", 
		АдресныеОбъекты, ПутьККаталогуНаСервере, ВерсияЗагружаемогоКЛАДР, ИсточникДанныхДляЗагрузки, ДоступныеВерсии);
		
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено);
		АдресныйКлассификатор.ЗагрузкаАдресныхСведенийИзФайловКЛАДРВРегистрСведений(ПараметрыЗагрузки, АдресХранилища);
		СтруктураВозврата = ПолучитьИзВременногоХранилища(АдресХранилища);
		Если Не СтруктураВозврата.СтатусВыполнения Тогда
			ВызватьИсключение СтруктураВозврата.СообщениеПользователю;
		КонецЕсли;
		
	Исключение
		ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Попытка
			УдалитьФайлы(ПутьККаталогуНаСервере);
		Исключение
		КонецПопытки;
		ВызватьИсключение ОписаниеОшибки;
	КонецПопытки;
	
	Попытка
		УдалитьФайлы(ПутьККаталогуНаСервере);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Зарегистрировать обработчики поставляемых данных
//
// При получении уведомления о доступности новых общих данных, вызывается процедуры
// ДоступныНовыеДанные модулей, зарегистрированных через ПолучитьОбработчикиПоставляемыхДанных.
// В процедуру передается Дескриптор - ОбъектXDTO Descriptor.
// 
// В случае, если ДоступныНовыеДанные устанавливает аргумент Загружать в значение Истина, 
// данные загружаются, дескриптор и путь к файлу с данными передаются в процедуру 
// ОбработатьНовыеДанные. Файл будет автоматически удален после завершения процедуры.
// Если в менеджере сервиса не был указан файл - значение аргумента равно Неопределено.
//
// Параметры: 
//   Обработчики, ТаблицаЗначений - таблица для добавления обработчиков. 
//       Колонки:
//        ВидДанных, строка - код вида данных, обрабатываемый обработчиком
//        КодОбработчика, строка(20) - будет использоваться при восстановлении обработки данных после сбоя
//        Обработчик,  ОбщийМодуль - модуль, содержащий следующие процедуры:
//          ДоступныНовыеДанные(Дескриптор, Загружать) Экспорт  
//          ОбработатьНовыеДанные(Дескриптор, ПутьКФайлу) Экспорт
//          ОбработкаДанныхОтменена(Дескриптор) Экспорт
//
Процедура ПриОпределенииОбработчиковПоставляемыхДанных(Обработчики) Экспорт
	
	ЗарегистрироватьОбработчикиПоставляемыхДанных(Обработчики);
	
КонецПроцедуры

// Заполняет массив типов, исключаемых из выгрузки и загрузки данных.
//
// Параметры:
//  Типы - Массив(Типы).
//
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.АдресныеСокращения);
	Типы.Добавить(Метаданные.РегистрыСведений.АдресныйКлассификатор);
	
КонецПроцедуры

#КонецОбласти
