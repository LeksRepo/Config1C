﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Взаимодействия"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


//Открывает вложенный файл электронного письма
//
//Параметры
//  Ссылка  - СправочникСсылка.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы,
//            СправочникСсылка.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы - ссылка на файл, который необходимо открыть
//
Процедура ОткрытьВложение(Ссылка, УникальныйИдентификаторФормы) Экспорт

	ПрисоединенныеФайлыКлиент.ОткрытьФайл(
		ПрисоединенныеФайлыКлиент.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификаторФормы));

КонецПроцедуры

//Возвращает массив, содержащий структуры с информацией о контактах взаимодействия
//или участниках предмета взаимодействия
//Параметры:
//  ТаблицаКонтактов - Документ.ТабличнаяЧасть - содержащая описания и ссылки на контакты взаимодействия
//                                               или участников предмета взаимодействия
//
Функция ТаблицуКонтактовВМассив(ТаблицаКонтактов) Экспорт
	
	Результат = Новый Массив;
	Для Каждого СтрокаТаблицы Из ТаблицаКонтактов Цикл
		Контакт = ?(ТипЗнч(СтрокаТаблицы.Контакт) = Тип("Строка"), Неопределено, СтрокаТаблицы.Контакт);
		Запись = Новый Структура(
		"Адрес, Представление, Контакт", СтрокаТаблицы.Адрес, СтрокаТаблицы.Представление, Контакт
		);
		Результат.Добавить(Запись);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

//Выполнить получение почты по всем доступным учетным записям
//Параметры
//  ЭлементСписок - ЭлементФормы - Элемент формы, который необходимо обновить, после получения писем.
//
Процедура ОтправитьЗагрузитьПочтуПользователя(ЭлементСписок = Неопределено) Экспорт

	ПолученоПисем = 0;
	ДоступноУчетныхЗаписей = 0;
	ЕстьОшибки = Ложь;
	
	Состояние(НСтр("ru = 'Идет отправка и получение электронной почты ...'"));
	ВзаимодействияВызовСервера.ОтправитьЗагрузитьПочтуПользователя(ПолученоПисем, ДоступноУчетныхЗаписей, ЕстьОшибки);
	Состояние();
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Получено писем: %1'"), ПолученоПисем);
	Если ДоступноУчетныхЗаписей > 1 Тогда
		ТекстСообщения = ТекстСообщения + " " +
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '(учетных записей: %1)'"),
			                                                        ДоступноУчетныхЗаписей);
	КонецЕсли;
	
	Если ЭлементСписок <> Неопределено Тогда
		ЭлементСписок.Обновить();
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстСообщения);
	
	Если ЕстьОшибки Тогда
	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'При получении почты были ошибки. Подробности см. в журнале регистрации'"));
	
	КонецЕсли;
	
КонецПроцедуры

//Возвращает полное представление почтового адреса
//
//Параметры
//  Адрес  - Строка - адрес электронной почты
//  Представление  - Строка - представление контакта
//
Функция ПолучитьПолноеПредставлениеПоАдресуИПредставлению(Адрес, Представление) Экспорт
	
	Если ПустаяСтрока(Представление) Тогда
		Возврат Адрес;
	ИначеЕсли ПустаяСтрока(Адрес) Тогда
		Возврат Представление;
	Иначе
		Возврат Представление + " <" + Адрес + ">";
	КонецЕсли;
	
КонецФункции

// По адресу и представлению ищет в соответствии контакт.
//
//Параметры
//  Адрес          - Строка - адрес электронной почты.
//  Представление  - Строка - представление контакта.
//  Контакт        - СправочникСсылка - контакт, значение которого будет изменено, если будет 
//                                     найдено по адресу и представлению значение в соответствии.
//  соотвКонтактов - Соответствие - соответствие в котором будет происходить поиск.
//
Процедура ИсправитьКонтакт(Адрес, Представление, Контакт, соотвКонтактов) Экспорт
	
	ЗначениеКонтакта = соотвКонтактов.Получить(
		ПолучитьПолноеПредставлениеПоАдресуИПредставлению(Адрес, Представление));
	Если ЗначениеКонтакта <> Неопределено Тогда
		Контакт = ЗначениеКонтакта;
	КонецЕсли;
	
КонецПроцедуры
