﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с почтовыми сообщениями".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму создания нового письма.
//
// Параметры:
//  ПараметрыОтправки - Структура - параметры для заполнения в форме отправки нового письма (все необязательные):
//    * Отправитель - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись, с которой может
//                    быть отправлено почтовое сообщение;
//                  - СписокЗначений - список учетных записей, доступных для выбора в форме:
//                      ** Представление - Строка- наименование учетной записи;
//                      ** Значение - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись.
//    
//    * Получатель - список почтовых адресов
//        - Строка - список адресов в формате:
//            [ПредставлениеПолучателя1] <Адрес1>; [[ПредставлениеПолучателя2] <Адрес2>;...]
//        - СписокЗначений - Список адресов
//            ** Представление - Строка - представление получателя,
//            ** Значение      - Строка - почтовый адрес.
//    
//    * Тема - Строка - тема письма.
//    
//    * Текст - Строка - тело письма.
//    
//    * Вложения - Массив - файлы, которые необходимо приложить к письму (описания в виде структур):
//        ** Структура - описание вложения:
//             *** Представление - Строка - имя файла вложения;
//             *** АдресВоВременномХранилище - Строка - адрес двоичных данных вложения во временном хранилище.
//             *** Кодировка - Строка - кодировка вложения (используется, если отличается от кодировки письма).
//    
//    * УдалятьФайлыПослеОтправки - Булево - удалять временные файлы после отправки сообщения.
//  
//  ОповещениеОЗакрытииФормы - ОписаниеОповещения - процедура, в которую необходимо передать управление после закрытия
//                           формы отправки письма.
//
Процедура СоздатьНовоеПисьмо(ПараметрыОтправки = Неопределено, ОповещениеОЗакрытииФормы = Неопределено) Экспорт
	
	Если ПараметрыОтправки = Неопределено Тогда
		ПараметрыОтправки = Новый Структура;
	КонецЕсли;
	ПараметрыОтправки.Вставить("ОповещениеОЗакрытииФормы", ОповещениеОЗакрытииФормы);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьНовоеПисьмоПроверкаУчетнойЗаписиВыполнена", ЭтотОбъект, ПараметрыОтправки);
	ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);
	
КонецПроцедуры

// Если у пользователя нет настроенной учетной записи для отправки писем, то в зависимости от прав либо показывает
// помощник настройки новой учетной записи, либо выводит сообщение о невозможности отправки.
// Предназначена для сценариев, в которых требуется выполнить настройку учетной записи перед запросом дополнительных
// параметров отправки.
//
// Параметры:
//  ОбработчикРезультата - ОписаниеОповещение - процедура, в которую необходимо передать выполнение кода после проверки.
//
Процедура ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОбработчикРезультата) Экспорт
	Если РаботаСПочтовымиСообщениямиВызовСервера.ЕстьДоступныеУчетныеЗаписиДляОтправки() Тогда
		ВыполнитьОбработкуОповещения(ОбработчикРезультата, Истина);
	Иначе
		Если РаботаСПочтовымиСообщениямиВызовСервера.ДоступноПравоДобавленияУчетныхЗаписей() Тогда
			ОткрытьФорму("Справочник.УчетныеЗаписиЭлектроннойПочты.Форма.ПомощникНастройкиУчетнойЗаписи", 
				Новый Структура("КонтекстныйРежим", Истина), , , , , ОбработчикРезультата);
		Иначе	
			ТекстСообщения = НСтр("ru = 'Для отправки письма требуется настройка учетной записи электронной почты.'");
			ПоказатьПредупреждение(ОбработчикРезультата, ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// УСТАРЕВШИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Устарела. Следует использовать СоздатьНовоеПисьмо.
//
// Интерфейсная клиентская функция, поддерживающая упрощенный вызов формы редактирования
// нового письма.
// Параметры
// Отправитель*  - СписокЗначений, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - 
//                 учетная запись ,с которой может быть отправлено
//                 почтовое сообщение. Если тип список значений, тогда
//                   представление - наименование учетной записи,
//                   значение - ссылка на учетную запись
//
// Получатель      - СписокЗначений, Строка:
//                   если список значений, то представление - имя получателя
//                                            значение      - почтовый адрес
//                   если строка то список почтовых адресов,
//                   в формате правильного e-mail адреса*
//
// Тема            - Строка - тема письма
// Текст           - Строка - тело письма
//
// Вложения        - СписокЗначений, где
//                   представление - строка - наименование вложения
//                   значение      - ДвоичныеДанные - двоичные данные вложения
//                                 - Строка - адрес файла во временном хранилище
//                                 - Строка - путь к файлу на клиенте
//
// УдалятьФайлыПослеОтправки - булево - удалять временные файлы после отправки сообщения
// ПисьмоДолжноСохраняться   - булево - должно ли письмо сохраняться (используется только
//                                      если встроена подсистема Взаимодействия)
//
Процедура ОткрытьФормуОтправкиПочтовогоСообщения(Знач Отправитель = Неопределено, Знач Получатель = Неопределено, Знач Тема = "",
	Знач Текст = "", Знач Вложения = Неопределено, Знач УдалятьФайлыПослеОтправки = Ложь, Знач ПисьмоДолжноСохраняться = Истина) Экспорт
	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("Отправитель", Отправитель);
	ПараметрыОтправки.Вставить("Получатель", Получатель);
	ПараметрыОтправки.Вставить("Тема", Тема);
	ПараметрыОтправки.Вставить("Текст", Текст);
	ПараметрыОтправки.Вставить("Вложения", Вложения);
	ПараметрыОтправки.Вставить("УдалятьФайлыПослеОтправки", УдалятьФайлыПослеОтправки);
	ПараметрыОтправки.Вставить("ПисьмоДолжноСохраняться", ПисьмоДолжноСохраняться);
	
	СоздатьНовоеПисьмо(ПараметрыОтправки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Продолжение процедуры СоздатьНовоеПисьмо.
Процедура СоздатьНовоеПисьмоПроверкаУчетнойЗаписиВыполнена(УчетнаяЗаписьНастроена, ПараметрыОтправки) Экспорт
	Перем Отправитель, Получатель, Вложения, Тема, Текст, УдалятьФайлыПослеОтправки;
	
	Если УчетнаяЗаписьНастроена <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтправки.Свойство("Отправитель", Отправитель);
	ПараметрыОтправки.Свойство("Получатель", Получатель);
	ПараметрыОтправки.Свойство("Тема", Тема);
	ПараметрыОтправки.Свойство("Текст", Текст);
	ПараметрыОтправки.Свойство("Вложения", Вложения);
	ПараметрыОтправки.Свойство("УдалятьФайлыПослеОтправки", УдалятьФайлыПослеОтправки);
	
	ОповещениеОЗакрытииФормы = ПараметрыОтправки.ОповещениеОЗакрытииФормы;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") 
		И СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИспользоватьПочтовыйКлиент Тогда
			МодульВзаимодействияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВзаимодействияКлиент");
			МодульВзаимодействияКлиент.ОткрытьФормуОтправкиПочтовогоСообщения(Отправитель,
				Получатель, Тема, Текст, Вложения, ОповещениеОЗакрытииФормы);
	Иначе
		ОткрытьПростуюФормуОтправкиПочтовогоСообщения(Отправитель, Получатель,
			Тема,Текст, Вложения, УдалятьФайлыПослеОтправки, ОповещениеОЗакрытииФормы);
	КонецЕсли;
	
КонецПроцедуры

// Интерфейсная клиентская функция, поддерживающая упрощенный вызов простой
// формы редактирования нового письма. При отправке письма через простую
// форму сообщения не сохраняются в информационной базе.
//
// Параметры см. в описании функции СоздатьНовоеПисьмо.
//
Процедура ОткрытьПростуюФормуОтправкиПочтовогоСообщения(Отправитель,
			Получатель, Тема,Текст, СписокФайлов, УдалятьФайлыПослеОтправки, ОписаниеОповещенияОЗакрытии)
	
	ПараметрыПисьма = Новый Структура;
	
	ПараметрыПисьма.Вставить("УчетнаяЗапись", Отправитель);
	ПараметрыПисьма.Вставить("Кому", Получатель);
	ПараметрыПисьма.Вставить("Тема", Тема);
	ПараметрыПисьма.Вставить("Тело", Текст);
	ПараметрыПисьма.Вставить("Вложения", СписокФайлов);
	ПараметрыПисьма.Вставить("УдалятьФайлыПослеОтправки", УдалятьФайлыПослеОтправки);
	
	ОткрытьФорму("ОбщаяФорма.ОтправкаСообщения", ПараметрыПисьма, , , , , ОписаниеОповещенияОЗакрытии);
КонецПроцедуры

// Выполняет проверку учетной записи.
//
// Параметры
// УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись,
//					которую нужно проверить.
//
Процедура ПроверитьУчетнуюЗапись(Знач УчетнаяЗапись) Экспорт
	
	ОчиститьСообщения();
	
	Состояние(НСтр("ru = 'Проверка учетной записи'"),,НСтр("ru = 'Выполняется проверка учетной записи. Подождите...'"));
	
	Если РаботаСПочтовымиСообщениямиВызовСервера.ПарольЗадан(УчетнаяЗапись) Тогда
		ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(Неопределено, УчетнаяЗапись, Неопределено);
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("УчетнаяЗапись", УчетнаяЗапись);
		ПараметрыФормы.Вставить("ПроверитьВозможностьОтправкиИПолучения", Истина);
		ОткрытьФорму("ОбщаяФорма.ПодтверждениеПароляУчетнойЗаписи", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

// Проверка учетной записи электронной почты.
//
// см. описание процедуры РаботаСПочтовымиСообщениямиСлужебный.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты.
//
Процедура ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(ОбработчикРезультата, УчетнаяЗапись, ПарольПараметр) Экспорт
	
	СообщениеОбОшибке = "";
	ДополнительноеСообщение = "";
	РаботаСПочтовымиСообщениямиВызовСервера.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, ПарольПараметр, СообщениеОбОшибке, ДополнительноеСообщение);
	
	Если ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
		ПоказатьПредупреждение(ОбработчикРезультата, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Проверка параметров учетной записи завершилась с ошибками:
					   |%1'"), СообщениеОбОшибке ),,
			НСтр("ru = 'Проверка учетной записи'"));
	Иначе
		ПоказатьПредупреждение(ОбработчикРезультата, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Проверка параметров учетной записи завершилась успешно. %1'"),
			ДополнительноеСообщение),,
			НСтр("ru = 'Проверка учетной записи'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
