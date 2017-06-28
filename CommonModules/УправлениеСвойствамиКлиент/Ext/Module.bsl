﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Свойства"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Открывает форму редактирования набора дополнительных реквизитов.
//
// Параметры:
//  Форма        - УправляемаяФорма, предварительно настроенная в процедуре
//                 УправлениеСвойствами.ПриСозданииНаСервере()
//
Процедура РедактироватьСоставСвойств(Форма, Ссылка = Неопределено) Экспорт
	
	Наборы = Форма.Свойства_НаборыДополнительныхРеквизитовОбъекта;
	
	Если Наборы.Количество() = 0
	 ИЛИ НЕ ЗначениеЗаполнено(Наборы[0].Значение) Тогда
		
		ПоказатьПредупреждение(,
			НСтр("ru = 'Не удалось получить наборы дополнительных реквизитов объекта.
			           |
			           |Возможно у объекта не заполнены необходимые реквизиты.'"));
	
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("КлючНазначенияИспользования", "НаборыДополнительныхРеквизитов");
		
		ОткрытьФорму("Справочник.НаборыДополнительныхРеквизитовИСведений.ФормаСписка", ПараметрыФормы);
		
		ПараметрыПерехода = Новый Структура;
		ПараметрыПерехода.Вставить("Набор", Наборы[0].Значение);
		ПараметрыПерехода.Вставить("Свойство", Неопределено);
		ПараметрыПерехода.Вставить("ЭтоДополнительноеСведение", Ложь);
		
		ДлинаНачала = СтрДлина("ДополнительныйРеквизитЗначение_");
		Если ВРег(Лев(Форма.ТекущийЭлемент.Имя, ДлинаНачала)) = ВРег("ДополнительныйРеквизитЗначение_") Тогда
			
			ИдентификаторНабора   = СтрЗаменить(Сред(Форма.ТекущийЭлемент.Имя, ДлинаНачала +  1, 36), "x","-");
			ИдентификаторСвойства = СтрЗаменить(Сред(Форма.ТекущийЭлемент.Имя, ДлинаНачала + 38, 36), "x","-");
			
			Если СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(НРег(ИдентификаторНабора)) Тогда
				ПараметрыПерехода.Вставить("Набор", ИдентификаторНабора);
			КонецЕсли;
			
			Если СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(НРег(ИдентификаторСвойства)) Тогда
				ПараметрыПерехода.Вставить("Свойство", ИдентификаторСвойства);
			КонецЕсли;
		КонецЕсли;
		
		Оповестить("Переход_НаборыДополнительныхРеквизитовИСведений", ПараметрыПерехода);
	КонецЕсли;
	
КонецПроцедуры

// Определяет, что указанное событие - это событие об изменении набора свойств.
// 
// Возвращаемое значение:
//  Булево - если Истина, тогда это оповещение об изменении набора свойств и
//           его нужно обработать в форме.
//
Функция ОбрабатыватьОповещения(Форма, ИмяСобытия, Параметр) Экспорт
	
	Если НЕ Форма.Свойства_ИспользоватьСвойства
	 ИЛИ НЕ Форма.Свойства_ИспользоватьДопРеквизиты Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_НаборыДополнительныхРеквизитовИСведений" Тогда
		Возврат Форма.Свойства_НаборыДополнительныхРеквизитовОбъекта.НайтиПоЗначению(Параметр.Ссылка) <> Неопределено;
		
	ИначеЕсли ИмяСобытия = "Запись_ДополнительныеРеквизитыИСведения" Тогда
		Отбор = Новый Структура("Свойство", Параметр.Ссылка);
		Возврат Форма.Свойства_ОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор).Количество() > 0;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции
