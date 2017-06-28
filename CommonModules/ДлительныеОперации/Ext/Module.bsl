﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Поддержка работы длительных серверных операций в веб-клиенте.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Запускает выполнение процедуры в фоновом задании.
// 
// Параметры:
//  ИдентификаторФормы     - УникальныйИдентификатор - идентификатор формы, 
//                           из которой выполняется запуск длительной операции. 
//  ИмяЭкспортнойПроцедуры - Строка - имя экспортной процедуры, 
//                           которую необходимо выполнить в фоне.
//  Параметры              - Структура - все необходимые параметры для 
//                           выполнения процедуры ИмяЭкспортнойПроцедуры.
//  НаименованиеЗадания    - Строка - наименование фонового задания. 
//                           Если не задано, то будет равно ИмяЭкспортнойПроцедуры. 
//  ИспользоватьДополнительноеВременноеХранилище – Булево – признак использования
//                           дополнительного временного хранилища для передачи данных
//                           в родительский сеанс из фонового задания. По умолчанию – Ложь.
//
// Возвращаемое значение:
//  Структура              - Возвращает свойства: 
//                             - АдресХранилища - адрес временного хранилища, в которое будет
//                          	 помещен результат работы задания;
//                             - АдресХранилищаДополнительный - адрес дополнительного временного хранилища,
//                               в которое будет помещен результат работы задания (доступно только если 
//                               установлен параметр ИспользоватьДополнительноеВременноеХранилище);
//                             - ИдентификаторЗадания - уникальный идентификатор запущенного
//                               фонового задания;
//                             - ЗаданиеВыполнено - Истина если задание было успешно выполнено 
//                               за время вызова функции.
// 
Функция ЗапуститьВыполнениеВФоне(Знач ИдентификаторФормы, Знач ИмяЭкспортнойПроцедуры, 
	Знач Параметры, Знач НаименованиеЗадания = "", ИспользоватьДополнительноеВременноеХранилище = Ложь) Экспорт
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, ИдентификаторФормы);
	
	Если Не ЗначениеЗаполнено(НаименованиеЗадания) Тогда
		НаименованиеЗадания = ИмяЭкспортнойПроцедуры;
	КонецЕсли;
	
	ПараметрыЭкспортнойПроцедуры = Новый Массив;
	ПараметрыЭкспортнойПроцедуры.Добавить(Параметры);
	ПараметрыЭкспортнойПроцедуры.Добавить(АдресХранилища);
	
	Если ИспользоватьДополнительноеВременноеХранилище Тогда
		АдресХранилищаДополнительный = ПоместитьВоВременноеХранилище(Неопределено, ИдентификаторФормы);
		ПараметрыЭкспортнойПроцедуры.Добавить(АдресХранилищаДополнительный);
	КонецЕсли;
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(ИмяЭкспортнойПроцедуры);
	ПараметрыЗадания.Добавить(ПараметрыЭкспортнойПроцедуры);

	Если ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая Тогда
		ВремяОжидания = 4;
	Иначе
		ВремяОжидания = 2;
	КонецЕсли;
	
	ПараметрыЗадания.Добавить(Неопределено);
	Задание = ФоновыеЗадания.Выполнить("ОбщегоНазначения.ВыполнитьБезопасно", ПараметрыЗадания,, НаименованиеЗадания);
	Попытка
		Задание.ОжидатьЗавершения(ВремяОжидания);
	Исключение
		// Специальная обработка не требуется, возможно исключение вызвано истечением времени ожидания.
	КонецПопытки;
	
	Результат = Новый Структура;
	Результат.Вставить("АдресХранилища",       АдресХранилища);
	Результат.Вставить("ЗаданиеВыполнено",     ЗаданиеВыполнено(Задание.УникальныйИдентификатор));
	Результат.Вставить("ИдентификаторЗадания", Задание.УникальныйИдентификатор);
	
	Если ИспользоватьДополнительноеВременноеХранилище Тогда
		Результат.Вставить("АдресХранилищаДополнительный", АдресХранилищаДополнительный);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Отменяет выполнение фонового задания по переданному идентификатору.
// 
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор фонового задания. 
// 
Процедура ОтменитьВыполнениеЗадания(Знач ИдентификаторЗадания) Экспорт 
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		Возврат;
	КонецЕсли;
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	Если Задание = Неопределено
		ИЛИ Задание.Состояние <> СостояниеФоновогоЗадания.Активно Тогда
		
		Возврат;
	КонецЕсли;
	
	Попытка
		Задание.Отменить();
	Исключение
		// Возможно задание как раз в этот момент закончилось и ошибки нет
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции.Отмена выполнения фонового задания'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Проверяет состояние фонового задания по переданному идентификатору.
// 
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор фонового задания. 
//
// Возвращаемое значение:
//  Булево              - возвращает Истина, если задание успешно выполнено,
//                        Ложь - если выполняется. В иных случаях вызывается исключение.
// 
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания) Экспорт
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	
	Если Задание <> Неопределено
		И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОперацияНеВыполнена = Истина;
	ПоказатьПолныйТекстОшибки = Ложь;
	Если Задание = Неопределено Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции.Фоновое задание не найдено'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , Строка(ИдентификаторЗадания));
	Иначе	
		Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
			ОшибкаЗадания = Задание.ИнформацияОбОшибке;
			Если ОшибкаЗадания <> Неопределено Тогда
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции.Фоновое задание завершено аварийно'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(Задание.ИнформацияОбОшибке));
				ПоказатьПолныйТекстОшибки = Истина;
			Иначе
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Длительные операции.Фоновое задание завершено аварийно'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					,
					,
					НСтр("ru = 'Задание завершилось с неизвестной ошибкой.'"));
			КонецЕсли;
		ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Длительные операции.Фоновое задание отменено администратором'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				НСтр("ru = 'Задание завершилось с неизвестной ошибкой.'"));
		Иначе
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ПоказатьПолныйТекстОшибки Тогда
		ТекстОшибки = КраткоеПредставлениеОшибки(ПолучитьИнформациюОбОшибке(Задание.ИнформацияОбОшибке));
		ВызватьИсключение(ТекстОшибки);
	ИначеЕсли ОперацияНеВыполнена Тогда
		ВызватьИсключение(НСтр("ru = 'Не удалось выполнить данную операцию. 
                                |Подробности см. в Журнале регистрации.'"));
	КонецЕсли;
	
КонецФункции

// Регистрирует в сообщениях информацию о ходе выполнения фонового задания.
//   В дальнейшем эту информацию можно считать с клиента при помощи функции ПрочитатьПрогресс.
//
// Параметры:
//  Процент - Число  - Необязательный. Процент выполнения.
//  Текст   - Строка - Необязательный. Информация о текущей операции.
//  ДополнительныеПараметры - Произвольный - Необязательный. Любая дополнительная информация,
//      которую необходимо передать на клиент. Значение должно быть простым (сериализуемым в XML строку).
//
Процедура СообщитьПрогресс(Знач Процент = Неопределено, Знач Текст = Неопределено, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	ПередаваемоеЗначение = Новый Структура;
	Если Процент <> Неопределено Тогда
		ПередаваемоеЗначение.Вставить("Процент", Процент);
	КонецЕсли;
	Если Текст <> Неопределено Тогда
		ПередаваемоеЗначение.Вставить("Текст", Текст);
	КонецЕсли;
	Если ДополнительныеПараметры <> Неопределено Тогда
		ПередаваемоеЗначение.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	КонецЕсли;
	
	ПередаваемыйТекст = ОбщегоНазначения.ЗначениеВСтрокуXML(ПередаваемоеЗначение);
	
	ПолучитьСообщенияПользователю(Истина); // Удаление предыдущих сообщений.
	Сообщить("{" + ИмяПодсистемы() + "}" + ПередаваемыйТекст);
	
КонецПроцедуры

// Находит фоновое задание и считывает из его сообщений информацию о ходе выполнения.
//
// Возвращаемое значение:
//   Структура - Информация о ходе выполнения фонового задания.
//       Ключи и значения структуры соответствуют именам и значениям параметров процедуры СообщитьПрогресс().
//
Функция ПрочитатьПрогресс(Знач ИдентификаторЗадания) Экспорт
	Перем Результат;
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если Задание = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	МассивСообщений = Задание.ПолучитьСообщенияПользователю(Истина);
	Количество = МассивСообщений.Количество();
	Если Количество = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Номер = 1 По Количество Цикл
		ОбратныйИндекс = Количество - Номер;
		Сообщение = МассивСообщений[ОбратныйИндекс];
		
		Если Лев(Сообщение.Текст, 1) = "{" Тогда
			Позиция = Найти(Сообщение.Текст, "}");
			Если Позиция > 2 Тогда
				ИдентификаторМеханизма = Сред(Сообщение.Текст, 2, Позиция - 2);
				Если ИдентификаторМеханизма = ИмяПодсистемы() Тогда
					ПолученныйТекст = Сред(Сообщение.Текст, Позиция + 1);
					Результат = ОбщегоНазначения.ЗначениеИзСтрокиXML(ПолученныйТекст);
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция НайтиЗаданиеПоИдентификатору(Знач ИдентификаторЗадания)
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	
	Возврат Задание;
	
КонецФункции

Функция ПолучитьИнформациюОбОшибке(ИнформацияОбОшибке)
	
	Результат = ИнформацияОбОшибке;
	Если ИнформацияОбОшибке <> Неопределено Тогда
		Если ИнформацияОбОшибке.Причина <> Неопределено Тогда
			Результат = ПолучитьИнформациюОбОшибке(ИнформацияОбОшибке.Причина);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ВыполнитьПроцедуруМодуляОбъектаОбработки(Параметры, АдресХранилища) Экспорт 
	
	ИмяМетода = Параметры.ИмяМетода;
	ВременнаяСтруктура = Новый Структура;
	Попытка
		ВременнаяСтруктура.Вставить(ИмяМетода);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Безопасное выполнение метода обработки'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Имя метода ""%1"" не соответствует требованиям образования имен переменных.'"),
			ИмяМетода);
	КонецПопытки;
	
	ПараметрыВыполнения = Параметры.ПараметрыВыполнения;
	Если Параметры.ЭтоВнешняяОбработка Тогда
		Если ЗначениеЗаполнено(Параметры.ДополнительнаяОбработкаСсылка) И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
			МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
			Обработка = МодульДополнительныеОтчетыИОбработки.ПолучитьОбъектВнешнейОбработки(Параметры.ДополнительнаяОбработкаСсылка);
		Иначе
			Обработка = ВнешниеОбработки.Создать(Параметры.ИмяОбработки);
		КонецЕсли;
	Иначе
		Обработка = Обработки[Параметры.ИмяОбработки].Создать();
	КонецЕсли;
	
	Выполнить("Обработка." + ИмяМетода + "(ПараметрыВыполнения, АдресХранилища)");
	
КонецПроцедуры

Функция ИмяПодсистемы()
	Возврат "СтандартныеПодсистемы.ДлительныеОперации";
КонецФункции
