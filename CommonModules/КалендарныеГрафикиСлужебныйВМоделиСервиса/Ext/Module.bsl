﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Календарные графики в модели сервиса"
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ПоставляемыеДанные") Тогда
		СерверныеОбработчики[
			"СтандартныеПодсистемы.РаботаВМоделиСервиса.ПоставляемыеДанные\ПриОпределенииОбработчиковПоставляемыхДанных"].Добавить(
				"КалендарныеГрафикиСлужебныйВМоделиСервиса");
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
		СерверныеОбработчики[
			"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий\ПриОпределенииПсевдонимовОбработчиков"].Добавить(
				"КалендарныеГрафикиСлужебныйВМоделиСервиса");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ПОЛУЧЕНИЯ ПОСТАВЛЯЕМЫХ ДАННЫХ

// Регистрирует обработчики поставляемых данных за день и за все время
//
Процедура ЗарегистрироватьОбработчикиПоставляемыхДанных(Знач Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ВидДанных = "ПроизвКалендари";
	Обработчик.КодОбработчика = "ДанныеПроизводственныхКалендарей";
	Обработчик.Обработчик = КалендарныеГрафикиСлужебныйВМоделиСервиса;
	
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
	
 	Если Дескриптор.DataType = "ПроизвКалендари" Тогда
		Загружать = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после вызова ДоступныНовыеДанные, позволяет разобрать данные.
//
// Параметры:
//   Дескриптор   - ОбъектXDTO Дескриптор.
//   ПутьКФайлу   - строка. Полное имя извлеченного файла. Файл будет автоматически удален 
//                  после завершения процедуры.
//
Процедура ОбработатьНовыеДанные(Знач Дескриптор, Знач ПутьКФайлу) Экспорт
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ПутьКФайлу);
	ЧтениеXML.ПерейтиКСодержимому();
	Если Не НачалоЭлемента(ЧтениеXML, "CalendarSuppliedData") Тогда
		Возврат;
	КонецЕсли;
	ЧтениеXML.Прочитать();
	Если Не НачалоЭлемента(ЧтениеXML, "Calendars") Тогда
		Возврат;
	КонецЕсли;
	
	// Обновляем список производственных календарей
	ТаблицаКалендарей = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ЧтениеXML).Данные;
	Справочники.ПроизводственныеКалендари.ОбновитьПроизводственныеКалендари(ТаблицаКалендарей);
	
	ЧтениеXML.Прочитать();
	Если Не КонецЭлемента(ЧтениеXML, "Calendars") Тогда
		Возврат;
	КонецЕсли;
	ЧтениеXML.Прочитать();
	Если Не НачалоЭлемента(ЧтениеXML, "CalendarData") Тогда
		Возврат;
	КонецЕсли;
	
	// Обновляем данные производственных календарей
	ТаблицаДанных = Справочники.ПроизводственныеКалендари.ДанныеПроизводственныхКалендарейИзXML(ЧтениеXML);
	
	Справочники.ПроизводственныеКалендари.ОбновитьДанныеПроизводственныхКалендарей(ТаблицаДанных);
	
КонецПроцедуры

// Вызывается при отмене обработки данных в случае сбоя
//
Процедура ОбработкаДанныхОтменена(Знач Дескриптор) Экспорт 
	
	ПоставляемыеДанные.ОбластьОбработана(Дескриптор.FileGUID, "ДанныеПроизводственныхКалендарей", Неопределено);
	
КонецПроцедуры	

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

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

// Заполняет соответствие имен методов их псевдонимам для вызова из очереди заданий
//
// Параметры:
//  СоответствиеИменПсевдонимам - Соответствие
//   Ключ - Псевдоним метода, например ОчиститьОбластьДанных
//   Значение - Имя метода для вызова, например РаботаВМоделиСервиса.ОчиститьОбластьДанных
//    В качестве значения можно указать Неопределено, в этом случае считается что имя 
//    совпадает с псевдонимом
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить("КалендарныеГрафикиСлужебныйВМоделиСервиса.ОбновитьГрафикиРаботы");
	
КонецПроцедуры

// Вызывается при изменении производственных календарей
//
Процедура ЗапланироватьОбновлениеГрафиковРаботы(Знач УсловияОбновления) Экспорт
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(УсловияОбновления);
	ПараметрыМетода.Добавить(Новый УникальныйИдентификатор);

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ИмяМетода"    , "КалендарныеГрафикиСлужебныйВМоделиСервиса.ОбновитьГрафикиРаботы");
	ПараметрыЗадания.Вставить("Параметры"    , ПараметрыМетода);
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
	ПараметрыЗадания.Вставить("ОбластьДанных", -1);
	
	УстановитьПривилегированныйРежим(Истина);
	ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);

КонецПроцедуры

// Процедура для вызова из очереди заданий, помещается туда в ЗапланироватьОбновлениеГрафиковРаботы
// 
// Параметры:
//  УсловияОбновления - ТаблицаЗначений с условиями обновления графиков
//  ИдентификаторФайла - УникальныйИдентификатор файла обрабатываемых курсов
//
Процедура ОбновитьГрафикиРаботы(Знач УсловияОбновления, Знач ИдентификаторОбновления) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрафикиРаботы") Тогда
		
		МодульГрафикиРаботы = ОбщегоНазначения.ОбщийМодуль("ГрафикиРаботы");
		
		// Получение областей данных для обработки
		ОбластиДляОбновления = ПоставляемыеДанные.ОбластиТребующиеОбработки(
			ИдентификаторОбновления, "ДанныеПроизводственныхКалендарей");
			
		// Обновление графиков работы по областям данных
		РаспространитьДанныеПроизводственныхКалендарейПоГрафикамРаботы(УсловияОбновления, ОбластиДляОбновления, 
			ИдентификаторОбновления, "ДанныеПроизводственныхКалендарей", МодульГрафикиРаботы);
			
	КонецЕсли;

КонецПроцедуры

// Заполняет данные графика работы по данным производственного календаря по всем ОД
//
// Параметры
//  ДатаКурсов - Дата или Неопределено. Курсы добавляются за указанную дату либо за все время
//  УсловияОбновления - ТаблицаЗначений с условиями обновления графиков
//  ОбластиДляОбновления - Массив со списком кодов областей
//  ИдентификаторФайла - УникальныйИдентификатор файла обрабатываемых курсов
//  КодОбработчика - Строка, код обработчика
//
Процедура РаспространитьДанныеПроизводственныхКалендарейПоГрафикамРаботы(Знач УсловияОбновления, 
	Знач ОбластиДляОбновления, Знач ИдентификаторФайла, Знач КодОбработчика, Знач МодульГрафикиРаботы)
	
	УсловияОбновления.Свернуть("КодПроизводственногоКалендаря, Год");
	
	Для каждого ОбластьДанных Из ОбластиДляОбновления Цикл
	
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.УстановитьРазделениеСеанса(Истина, ОбластьДанных);
		УстановитьПривилегированныйРежим(Ложь);
		
		НачатьТранзакцию();
		МодульГрафикиРаботы.ОбновитьГрафикиРаботыПоДаннымПроизводственныхКалендарей(УсловияОбновления);
		ПоставляемыеДанные.ОбластьОбработана(ИдентификаторФайла, КодОбработчика, ОбластьДанных);
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Прочие служебные процедуры и функции

Функция НачалоЭлемента(Знач ЧтениеXML, Знач Имя)
	
	Если ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента Или ЧтениеXML.Имя <> Имя Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Календарные графики'", 
			Метаданные.ОсновнойЯзык.КодЯзыка), УровеньЖурналаРегистрации.Ошибка,
			,, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неверный формат файла данных. Ожидается начало элемента %1'"), Имя));
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция КонецЭлемента(Знач ЧтениеXML, Знач Имя)
	
	Если ЧтениеXML.ТипУзла <> ТипУзлаXML.КонецЭлемента Или ЧтениеXML.Имя <> Имя Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Календарные графики'", 
			Метаданные.ОсновнойЯзык.КодЯзыка), УровеньЖурналаРегистрации.Ошибка,
			,, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неверный формат файла данных. Ожидается конец элемента %1'"), Имя));
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции
