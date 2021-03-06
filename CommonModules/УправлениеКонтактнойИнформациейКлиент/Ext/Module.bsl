﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контактная информация".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик события ПриИзменении поля формы контактной информации.
// Вызывается из подключаемых действий при внедрении подсистемы "Контактная информация"
//
// Параметры:
//     Форма             - УправляемаяФорма - Форма владельца контактной информации
//     Элемент           - ПолеФормы        - Элемент формы, содержащий представление контактной информации
//     ЭтоТабличнаяЧасть - Булево           - Флаг того, что элемент является частью таблицы формы
//
Процедура ПредставлениеПриИзменении(Форма, Элемент, ЭтоТабличнаяЧасть = Ложь) Экспорт
	
	ЭтоТабличнаяЧасть = ЭтоТабличнаяЧасть(Элемент);
	
	Если ЭтоТабличнаяЧасть Тогда
		ДанныеЗаполнения = Форма.Элементы[Форма.ТекущийЭлемент.Имя].ТекущиеДанные;
		Если ДанныеЗаполнения = Неопределено Тогда
			Возврат;
		КонецЕсли;
	Иначе
		ДанныеЗаполнения = Форма;
	КонецЕсли;
	
	// Если это очистка, то сбрасываем представление
	ДанныеСтроки = ПолучитьСтрокуДополнительныхЗначений(Форма, Элемент, ЭтоТабличнаяЧасть);
	Если ДанныеСтроки = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Текст = Элемент.ТекстРедактирования;
	Если ПустаяСтрока(Текст) Тогда
		ДанныеЗаполнения[Элемент.Имя] = "";
		Если ЭтоТабличнаяЧасть Тогда
			ДанныеЗаполнения[Элемент.Имя + "ЗначенияПолей"] = "";
		КонецЕсли;
		ДанныеСтроки.Представление = "";
		ДанныеСтроки.ЗначенияПолей = Неопределено;
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки.ЗначенияПолей = КонтактнаяИнформацияСлужебныйВызовСервера.ПарсингКонтактнойИнформацииXML(Текст, ДанныеСтроки.Вид);
	ДанныеСтроки.Представление = Текст;
	
	Если ЭтоТабличнаяЧасть Тогда
		ДанныеЗаполнения[Элемент.Имя + "ЗначенияПолей"] = ДанныеСтроки.ЗначенияПолей;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события НачалоВыбора поля формы контактной информации.
// Вызывается из подключаемых действий при внедрении подсистемы "Контактная информация"
//
// Параметры:
//     Форма                - УправляемаяФорма - Форма владельца контактной информации
//     Элемент              - ПолеФормы        - Элемент формы, содержащий представление контактной информации
//     Модифицированность   - Булево           - Устанавливаемый флаг модифицированности формы
//     СтандартнаяОбработка - Булево           - Устанавливаемый флаг стандартной обработки события формы
//
Функция ПредставлениеНачалоВыбора(Форма, Элемент, Модифицированность = Истина, СтандартнаяОбработка = Ложь) Экспорт
	СтандартнаяОбработка = Ложь;
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяРеквизита", Элемент.Имя);
	
	ЭтоТабличнаяЧасть = ЭтоТабличнаяЧасть(Элемент);
	
	Если ЭтоТабличнаяЧасть Тогда
		ДанныеЗаполнения = Форма.Элементы[Форма.ТекущийЭлемент.Имя].ТекущиеДанные;
		Если ДанныеЗаполнения = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		ДанныеЗаполнения = Форма;
	КонецЕсли;
	
	ДанныеСтроки = ПолучитьСтрокуДополнительныхЗначений(Форма, Элемент, ЭтоТабличнаяЧасть);
	
	// Если представление было изменено в поле и не соответствует реквизиту, то приводим в соответствие
	Если ДанныеЗаполнения[Элемент.Имя] <> Элемент.ТекстРедактирования Тогда
		ДанныеЗаполнения[Элемент.Имя] = Элемент.ТекстРедактирования;
		ПредставлениеПриИзменении(Форма, Элемент, ЭтоТабличнаяЧасть);
		Форма.Модифицированность = Истина;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ДанныеСтроки.Вид);
	ПараметрыОткрытия.Вставить("ЗначенияПолей", ДанныеСтроки.ЗначенияПолей);
	ПараметрыОткрытия.Вставить("Представление", Элемент.ТекстРедактирования);
	
	Если Не ЭтоТабличнаяЧасть Тогда
		ПараметрыОткрытия.Вставить("Комментарий", ДанныеСтроки.Комментарий);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура);
	Оповещение.ДополнительныеПараметры.Вставить("ДанныеЗаполнения",  ДанныеЗаполнения);
	Оповещение.ДополнительныеПараметры.Вставить("ЭтоТабличнаяЧасть", ЭтоТабличнаяЧасть);
	Оповещение.ДополнительныеПараметры.Вставить("ДанныеСтроки",      ДанныеСтроки);
	Оповещение.ДополнительныеПараметры.Вставить("Элемент",           Элемент);
	Оповещение.ДополнительныеПараметры.Вставить("Результат",         Результат);
	Оповещение.ДополнительныеПараметры.Вставить("Форма",             Форма);
	
	ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, , , , Оповещение);
	
	Возврат Неопределено;
КонецФункции

// Обработчик события Очистка поля формы контактной информации.
// Вызывается из подключаемых действий при внедрении подсистемы "Контактная информация"
//
// Параметры:
//     Форма         - УправляемаяФорма - Форма владельца контактной информации
//     ИмяРеквизита - Строка           - Имя реквизита формы, связанного с представление контактной информации
//
Функция ПредставлениеОчистка(Знач Форма, Знач ИмяРеквизита) Экспорт
	
	Результат = Новый Структура("ИмяРеквизита", ИмяРеквизита);
	НайденнаяСтрока = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Результат)[0];
	НайденнаяСтрока.ЗначенияПолей = "";
	НайденнаяСтрока.Представление = "";
	НайденнаяСтрока.Комментарий   = "";
	
	Форма[ИмяРеквизита] = "";
	Форма.Модифицированность = Истина;
	
	ОбновитьКонтактнуюИнформациюФормы(Форма, Результат);
	Возврат Неопределено;
КонецФункции

// Обработчик команды, связанной с контактной информации (написать письмо, открыть адрес, и т.п.)
// Вызывается из подключаемых действий при внедрении подсистемы "Контактная информация"
//
// Параметры:
//     Форма      - УправляемаяФорма - Форма владельца контактной информации
//     ИмяКоманды - Строка           - Имя автоматически сгенерированной команды действия
//
Функция ПодключаемаяКоманда(Знач Форма, Знач ИмяКоманды) Экспорт
	
	Если ИмяКоманды = "КонтактнаяИнформацияДобавитьПолеВвода" Тогда
		Оповещение = Новый ОписаниеОповещения("КонтактнаяИнформацияДобавитьПолеВводаЗавершение", ЭтотОбъект, Новый Структура);
			
		Оповещение.ДополнительныеПараметры.Вставить("Форма", Форма);
		Форма.ПоказатьВыборИзМеню(Оповещение, Форма.СписокДобавляемыхЭлементовКонтактнойИнформации, Форма.Элементы.КонтактнаяИнформацияДобавитьПолеВвода);
		Возврат Неопределено;
		
	ИначеЕсли Лев(ИмяКоманды, 7) = "Команда" Тогда
		ИмяРеквизита = СтрЗаменить(ИмяКоманды, "Команда", "");
		КомандаКонтекстногоМеню = Ложь;
		
	Иначе
		ИмяРеквизита = СтрЗаменить(ИмяКоманды, "КонтекстноеМеню", "");
		КомандаКонтекстногоМеню = Истина;
		
	КонецЕсли;
	
	Результат = Новый Структура("ИмяРеквизита", ИмяРеквизита);
	НайденнаяСтрока = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Результат)[0];
	ТипКонтактнойИнформации = НайденнаяСтрока.Тип;
	
	Если КомандаКонтекстногоМеню Тогда
		ВвестиКомментарий(Форма, ИмяРеквизита, НайденнаяСтрока, Результат);
		
	ИначеЕсли ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		ЗаполнитьАдрес(Форма, ИмяРеквизита, НайденнаяСтрока, Результат);
		
	ИначеЕсли ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
		АдресПочты = Форма.Элементы[ИмяРеквизита].ТекстРедактирования;
		СоздатьЭлектронноеПисьмо("", АдресПочты, ТипКонтактнойИнформации);
		
	ИначеЕсли ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.ВебСтраница") Тогда
		АдресСсылки = Форма.Элементы[ИмяРеквизита].ТекстРедактирования;
		ПерейтиПоВебСсылке("", АдресСсылки, ТипКонтактнойИнформации);
		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Открытие формы адреса формы контактной информации.
// Вызывается из подключаемых действий при внедрении подсистемы "Контактная информация"
//
// Параметры:
//     Форма     - УправляемаяФорма - Форма владельца контактной информации
//     Результат - Произвольный     - Данные, переданные обработчиком команды
//
Процедура ОткрытьФормуВводаАдреса(Форма, Результат) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		Если Результат.Свойство("ЭлементФормыАдреса") Тогда
			ПредставлениеНачалоВыбора(Форма, Форма.Элементы[Результат.ЭлементФормыАдреса]);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик возможного обновления формы контактной информации
// Вызывается из подключаемых действий при внедрении подсистемы "Контактная информация"
//
// Параметры:
//     Форма     - УправляемаяФорма - Форма владельца контактной информации
//     Результат - Произвольный     - Данные, переданные обработчиком команды
//
Процедура КонтрольОбновленияФормы(Форма, Результат) Экспорт
	
	// Анализ на обратный вызов формы ввода адреса
	ОткрытьФормуВводаАдреса(Форма, Результат);
	
КонецПроцедуры

// Обработчик события ОбработкаВыбора страны мира. 
// Реализует функционал автоматического заведения элемента справочника СтраныМира после выбора.
//
// Параметры:
//     Элемент              - ПолеФормы    - Элемент, содержащий редактируемую страну мира
//     ВыбранноеЗначение    - Произвольный - Значение выбора
//     СтандартнаяОбработка - Булево       - Устанавливаемый флаг стандартной обработки события формы
//
Процедура СтранаМираОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	Если Не СтандартнаяОбработка Тогда 
		Возврат;
	КонецЕсли;
	
	ТипВыбранного = ТипЗнч(ВыбранноеЗначение);
	Если ТипВыбранного = Тип("Массив") Тогда
		СписокПреобразования = Новый Соответствие;
		Для Индекс = 0 По ВыбранноеЗначение.ВГраница() Цикл
			Данные = ВыбранноеЗначение[Индекс];
			Если ТипЗнч(Данные) = Тип("Структура") И Данные.Свойство("Код") Тогда
				СписокПреобразования.Вставить(Индекс, Данные.Код);
			КонецЕсли;
		КонецЦикла;
		
		Если СписокПреобразования.Количество() > 0 Тогда
			КонтактнаяИнформацияСлужебныйВызовСервера.КоллекцияСтранМираПоДаннымКлассификатора(СписокПреобразования);
			Для Каждого КлючЗначение Из СписокПреобразования Цикл
				ВыбранноеЗначение[КлючЗначение.Ключ] = КлючЗначение.Значение;
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ТипВыбранного = Тип("Структура") И ВыбранноеЗначение.Свойство("Код") Тогда
		ВыбранноеЗначение = КонтактнаяИнформацияСлужебныйВызовСервера.СтранаМираПоДаннымКлассификатора(ВыбранноеЗначение.Код);
		
	КонецЕсли;
	
КонецПроцедуры

//  Конструктор для структуры параметров открытия формы контактной информации
//
//  Параметры:
//      ВидКонтактнойИнформации - вид редактируемой информации, СправочникСсылка.ВидыКонтактнойИнформации
//      Значение                - строка с сериализованным значением полей контактной информации
//      Представление           - необязательное представление
//
Функция ПараметрыФормыКонтактнойИнформации(ВидКонтактнойИнформации, Значение, Представление = Неопределено, Комментарий = Неопределено) Экспорт
	Возврат Новый Структура("ВидКонтактнойИнформации, ЗначенияПолей, Представление, Комментарий",
		ВидКонтактнойИнформации, Значение, Представление, Комментарий);
КонецФункции

//  Открывает подходящую форму контактной информации для редактирования или просмотра
//
//  Параметры:
//      Параметры    - результат функции ПараметрыФормыКонтактнойИнформации
//      Владелец     - параметр для открываемой формы
//      Уникальность - параметр для открываемой формы
//      Окно         - параметр для открываемой формы
//      Оповещение   - ОписаниеОповещения - для обработки закрытия формы
//
//  Возвращаемое значение: необходимая форма
//
Функция ОткрытьФормуКонтактнойИнформации(Параметры, Владелец = Неопределено, Уникальность = Неопределено, Окно = Неопределено, Оповещение = Неопределено) Экспорт
	ВидИнформации = Параметры.ВидКонтактнойИнформации;
	
	ИмяОткрываемойФормы = КонтактнаяИнформацияКлиентСерверПовтИсп.ИмяФормыВводаКонтактнойИнформации(ВидИнформации);
	Если ИмяОткрываемойФормы = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не обрабатываемый тип адреса: """ + ВидИнформации + """'");
	КонецЕсли;
	
	Если Не Параметры.Свойство("Заголовок") Тогда
		Параметры.Вставить("Заголовок", Строка(КонтактнаяИнформацияСлужебныйВызовСервера.ТипВидаКонтактнойИнформации(ВидИнформации)));
	КонецЕсли;
	
	Параметры.Вставить("ОткрытаПоСценарию", Истина);
	
	Возврат ОткрытьФорму(ИмяОткрываемойФормы, Параметры, Владелец, Уникальность, Окно, , Оповещение);
КонецФункции

// ИспользованиеМодальности

//  Устарело. Следует использовать ОткрытьФормуКонтактнойИнформации
//
//  Модально открывает подходящую форму контактной информации для редактирования или просмотра
//
//  Параметры:
//      Параметры    - результат функции ПараметрыФормыКонтактнойИнформации
//      Владелец     - параметр для открываемой формы
//      Уникальность - параметр для открываемой формы
//      Окно         - параметр для открываемой формы
//
//  Возвращаемое значение: отредактированный результат или Неопределено при отказе от редактирования
//
Функция ОткрытьФормуКонтактнойИнформацииМодально(Параметры, Владелец = Неопределено, Уникальность = Неопределено, Окно = Неопределено) Экспорт
	
	ВидИнформации = Параметры.ВидКонтактнойИнформации;
	
	ИмяОткрываемойФормы = КонтактнаяИнформацияКлиентСерверПовтИсп.ИмяФормыВводаКонтактнойИнформации(ВидИнформации);
	Если ИмяОткрываемойФормы=Неопределено Тогда
		ВызватьИсключение НСтр("ru='Не обрабатываемый тип адреса: """ + ВидИнформации + """'");
	КонецЕсли;
	
	Если Не Параметры.Свойство("Заголовок") Тогда
		Параметры.Вставить("Заголовок", Строка(КонтактнаяИнформацияСлужебныйВызовСервера.ТипВидаКонтактнойИнформации(ВидИнформации)));
	КонецЕсли;
	
	Параметры.Вставить("ОткрытаПоСценарию", Истина);
	
	Возврат ОткрытьФормуМодально(ИмяОткрываемойФормы, Параметры, Владелец);
КонецФункции

// Конец ИспользованиеМодальности

// Создает письмо по контактной информации
//
//  Параметры:
//    ЗначенияПолей - строка (XML или старый формат ключ-значение), структура, соответствие или список значений,
//                    описывающие контактную информацию.
//    Представление - строка представления. Используется, если невозможно определить представление из параметра 
//                    ЗначенияПолей (отсутствие поля "Представление")
//    ОжидаемыйВид  - ссылка на справочник ВидыКонтактнойИнформации или перечисление ТипыКонтактнойИнформации, 
//                    объект с полем "Тип". Используется для определения типа, если его невозможно вычислить
//                    по полю ЗначенияПолей
//
Процедура СоздатьЭлектронноеПисьмо(Знач ЗначенияПолей, Знач Представление = "", ОжидаемыйВид = Неопределено) Экспорт
	
	КонтактнаяИнформация = КонтактнаяИнформацияСлужебныйВызовСервера.ПривестиКонтактнуюИнформациюXML(
		Новый Структура("ЗначенияПолей, Представление, ВидКонтактнойИнформации", ЗначенияПолей, Представление, ОжидаемыйВид));
	ТипИнформации = КонтактнаяИнформация.ТипКонтактнойИнформации;
	
	Если ТипИнформации <> ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
		ВызватьИсключение СтрЗаменить(НСтр("ru = 'Нельзя создать письмо по контактной информацию с типом ""%1""'"),
			"%1", ТипИнформации);
	КонецЕсли;	
	
	XMLДанные = КонтактнаяИнформация.ДанныеXML;
	
	АдресПочты = КонтактнаяИнформацияСлужебныйВызовСервера.СтрокаСоставаКонтактнойИнформации(XMLДанные);
	Если ТипЗнч(АдресПочты) <> Тип("Строка") Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка получения адреса электронной почты, неверный тип контактной информации'");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
		
		ПараметрыОтправки = Новый Структура("Получатель", АдресПочты);
		МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыОтправки);
		Возврат; 
	КонецЕсли;
	
	// Нет подсистемы почты, запускаем системное
	Оповещение = Новый ОписаниеОповещения("СоздатьПисьмоПоКонтактнойИнформацииЗавершение", ЭтотОбъект, АдресПочты);
	ТекстПредложения = НСтр("ru = 'Для отправки письма необходимо установить расширение для работы с файлами.'");
	ОбщегоНазначенияКлиент.ПроверитьРасширениеРаботыСФайламиПодключено(Оповещение, ТекстПредложения);
КонецПроцедуры

// Открывает ссылку по контактной информации
//
// Параметры:
//    ЗначенияПолей - строка (XML или старый формат ключ-значение), структура, соответствие или список значений,
//                    описывающие контактную информацию.
//    Представление - строка представления. Используется, если невозможно определить представление из параметра 
//                    ЗначенияПолей (отсутствие поля "Представление")
//    ОжидаемыйВид  - ссылка на справочник ВидыКонтактнойИнформации или перечисление ТипыКонтактнойИнформации, 
//                    объект с полем "Тип". Используется для определения типа, если его невозможно вычислить
//                    по полю ЗначенияПолей
//
Процедура ПерейтиПоВебСсылке(Знач ЗначенияПолей, Знач Представление = "", ОжидаемыйВид = Неопределено) Экспорт
	
	КонтактнаяИнформация = КонтактнаяИнформацияСлужебныйВызовСервера.ПривестиКонтактнуюИнформациюXML(
		Новый Структура("ЗначенияПолей, Представление, ВидКонтактнойИнформации", ЗначенияПолей, Представление, ОжидаемыйВид));
	ТипИнформации = КонтактнаяИнформация.ТипКонтактнойИнформации;
	
	Если ТипИнформации <> ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.ВебСтраница") Тогда
		ВызватьИсключение СтрЗаменить(НСтр("ru = 'Нельзя открыть ссылку по контактной информации с типом ""%1""'"),
			"%1", ТипИнформации);
	КонецЕсли;
		
	XMLДанные = КонтактнаяИнформация.ДанныеXML;

	АдресСсылки = КонтактнаяИнформацияСлужебныйВызовСервера.СтрокаСоставаКонтактнойИнформации(XMLДанные);
	Если ТипЗнч(АдресСсылки) <> Тип("Строка") Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка получения ссылки, неверный тип контактной информации'");
	КонецЕсли;
	
	Если Найти(АдресСсылки, "://") > 0 Тогда
		ПерейтиПоНавигационнойСсылке(АдресСсылки);
	Иначе
		ПерейтиПоНавигационнойСсылке("http://" + АдресСсылки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Завершение немодальных диалогов
Процедура ПредставлениеНачалоВыбораЗавершение(Знач РезультатЗакрытия, Знач ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения = ДополнительныеПараметры.ДанныеЗаполнения;
	ДанныеСтроки     = ДополнительныеПараметры.ДанныеСтроки;
	Результат        = ДополнительныеПараметры.Результат;
	Элемент          = ДополнительныеПараметры.Элемент;
	Форма            = ДополнительныеПараметры.Форма;
	
	ТекстПредставления = РезультатЗакрытия.Представление;
	
	Если ДополнительныеПараметры.ЭтоТабличнаяЧасть Тогда
		ДанныеЗаполнения[Элемент.Имя + "ЗначенияПолей"] = РезультатЗакрытия.КонтактнаяИнформация;
		
	Иначе
		Если ПустаяСтрока(ДанныеСтроки.Комментарий) И Не ПустаяСтрока(РезультатЗакрытия.Комментарий) Тогда
			Результат.Вставить("ЭтоДобавлениеКомментария", Истина);
			
		ИначеЕсли Не ПустаяСтрока(ДанныеСтроки.Комментарий) И ПустаяСтрока(РезультатЗакрытия.Комментарий) Тогда
			Результат.Вставить("ЭтоДобавлениеКомментария", Ложь);
			
		Иначе
			Если Не ПустаяСтрока(ДанныеСтроки.Комментарий) Тогда
				Форма.Элементы["Комментарий" + Элемент.Имя].Заголовок = РезультатЗакрытия.Комментарий;
			КонецЕсли;
			
		КонецЕсли;
		
		ДанныеСтроки.Представление = ТекстПредставления;
		ДанныеСтроки.ЗначенияПолей = РезультатЗакрытия.КонтактнаяИнформация;
		ДанныеСтроки.Комментарий   = РезультатЗакрытия.Комментарий;
	КонецЕсли;
	
	ДанныеЗаполнения[Элемент.Имя] = ТекстПредставления;
	
	Форма.Модифицированность = Истина;
	ОбновитьКонтактнуюИнформациюФормы(Форма, Результат);
КонецПроцедуры

// Завершение немодальных диалогов
Процедура КонтактнаяИнформацияДобавитьПолеВводаЗавершение(Знач ВыбранныйЭлемент, Знач ДополнительныеПараметры) Экспорт
	Если ВыбранныйЭлемент = Неопределено Тогда
		// Отказ от выбора
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура("ДобавляемыйВид", ВыбранныйЭлемент.Значение);
	
	ДополнительныеПараметры.Форма.Модифицированность = Истина;
	ОбновитьКонтактнуюИнформациюФормы(ДополнительныеПараметры.Форма, Результат);
КонецПроцедуры

//  Обработчик события НачалоВыбора для улицы
//
//  Параметры:
//      Элемент                            - вызывающий элемент формы
//      КодКлассификатораНаселенногоПункта - ограничение по населенному пункту
//      ТекущееЗначение                    - текущее значение - или код классификатора, или текст
//      ПараметрыФормы                     - необязательная дополнительная структура параметров для формы подбора
//
Процедура НачалоВыбораУлицы(Элемент, КодКлассификатораНаселенногоПункта, ТекущееЗначение, ПараметрыФормы = Неопределено) Экспорт
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	
	Если Вариант = "КЛАДР" Тогда
		НачалоВыбораУлицыКЛАДР(Элемент, КодКлассификатораНаселенногоПункта, ТекущееЗначение, ПараметрыФормы);
	КонецЕсли;
	
	// Нет подсистемы классификатора
КонецПроцедуры

//  Обработчик события НачалоВыбора для элемента адреса (субъект РФ, район, город и т.п.)
//
//  Параметры:
//      Элемент        - вызывающий элемент формы
//      КодЧастиАдреса - идентификатор обрабатываемой части адреса, зависит от классификатора
//      ЧастиАдреса    - значения для других частей адреса, зависит от классификатора
//      ПараметрыФормы - необязательная  дополнительная структура параметров для формы подбора
//
Процедура НачалоВыбораЭлементаАдреса(Элемент, КодЧастиАдреса, ЧастиАдреса, ПараметрыФормы = Неопределено) Экспорт
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	
	Если Вариант = "КЛАДР" Тогда
		НачалоВыбораЭлементаАдресаКЛАДР(Элемент, КодЧастиАдреса, ЧастиАдреса, ПараметрыФормы);
	КонецЕсли;
	
	// Нет подсистемы классификатора
КонецПроцедуры

//  Возвращает полное наименование для населенного пункта. Под населенным пунктом понимается синтетическое 
//  поле, характеризующее все, что больше улицы
//
//  Параметры:
//      ЧастиАдреса - значения для частей адреса, зависит от классификатора
//
Функция НаименованиеНаселенногоПунктаПоЧастямАдреса(ЧастиАдреса) Экспорт
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	
	Если Вариант = "КЛАДР" Тогда
		Возврат НаименованиеНаселенногоПунктаПоЧастямАдресаКЛАДР(ЧастиАдреса)
	КонецЕсли;
	
	// Нет подсистемы классификатора
	Возврат "";
КонецФункции

//  Предлагает загрузить адресный классификатор
//
//  Параметры:
//      Текст - строка с дополнительным текстов предложения
//
Процедура ПредложениеЗагрузкиКлассификатора(Текст = "") Экспорт
	
#Если ВебКлиент Тогда
	Возврат;
#КонецЕсли
	
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	
	Если Вариант <> "КЛАДР" Тогда
		// Нет подсистемы классификатора
		Возврат;
	КонецЕсли;
	
	ТекстЗаголовка = НСтр("ru = 'Подтверждение'");
	ТекстВопроса   = Текст + Символы.ПС + НСтр("ru = 'Загрузить классификатор сейчас?'");
	
	Оповещение = Новый ОписаниеОповещения("ПредложениеЗагрузкиКлассификатораЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ТекстЗаголовка);
КонецПроцедуры

Процедура ПредложениеЗагрузкиКлассификатораЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗагрузитьАдресныйКлассификатор();
	КонецЕсли;
КонецПроцедуры

//  Загружает адресный классификатор
//
Процедура ЗагрузитьАдресныйКлассификатор() Экспорт
#Если ВебКлиент Тогда
	Возврат;
#КонецЕсли
	
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	
	Если Вариант = "КЛАДР" Тогда
		МодульКЛАДР = КлиентскийМодульКЛАДР();
		МодульКЛАДР.ЗагрузитьАдресныйКлассификатор();
	КонецЕсли;
	
	// Нет подсистемы классификатора
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////

// Завершение модального диалога создания письма 
Процедура СоздатьПисьмоПоКонтактнойИнформацииЗавершение(Действие, АдресПочты) Экспорт
	
	ЗапуститьПриложение("mailto:" + АдресПочты);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// Реализация КЛАДР
//

Функция КлиентскийМодульКЛАДР()
	
	Возврат ОбщегоНазначенияКлиент.ОбщийМодуль("АдресныйКлассификаторКлиент");

КонецФункции

Процедура НачалоВыбораУлицыКЛАДР(Элемент, КодКлассификатораНаселенногоПункта, ТекущееЗначение, Параметры = Неопределено)
	ПараметрыФормы = ?(Параметры = Неопределено, Новый Структура, Параметры);
	
	ПараметрыФормы.Вставить("Уровень", 5);
	ПараметрыФормы.Вставить("Улица",   Строка(ТекущееЗначение));
	
	МодульКЛАДР = КлиентскийМодульКЛАДР();
	МодульКЛАДР.ОткрытьФормуВыбораКЛАДР(ПараметрыФормы, Элемент);
КонецПроцедуры

Процедура НачалоВыбораЭлементаАдресаКЛАДР(Элемент, КодЧастиАдреса, ЧастиАдреса, Параметры = Неопределено)
	
	КодРеквизита = ВРег(КодЧастиАдреса);
	Если КодРеквизита = "РЕГИОН" Тогда
		Уровень = 1;
		
	ИначеЕсли КодРеквизита = "РАЙОН" Тогда
		Уровень = 2;
		
	ИначеЕсли КодРеквизита = "ГОРОД" Тогда
		Уровень = 3;
		
	ИначеЕсли КодРеквизита = "НАСЕЛЕННЫЙПУНКТ" Тогда
		Уровень = 4;
		
	ИначеЕсли КодРеквизита = "УЛИЦА" Тогда
		Уровень = 5;
		
	Иначе
		Возврат;
		
	КонецЕсли;
	
	ПараметрыФормы = ?(Параметры = Неопределено, Новый Структура, Параметры);
	
	ПараметрыФормы.Вставить("Регион", ЧастиАдреса.Регион.Значение);
	Если ЧастиАдреса.Регион.Свойство("КодКлассификатора") Тогда
		ПараметрыФормы.Вставить("РегионКодКлассификатора", ЧастиАдреса.Регион.КодКлассификатора);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Район", ЧастиАдреса.Район.Значение);
	Если ЧастиАдреса.Район.Свойство("КодКлассификатора") Тогда
		ПараметрыФормы.Вставить("РайонКодКлассификатора", ЧастиАдреса.Район.КодКлассификатора);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Город", ЧастиАдреса.Город.Значение);
	Если ЧастиАдреса.Город.Свойство("КодКлассификатора") Тогда
		ПараметрыФормы.Вставить("ГородКодКлассификатора", ЧастиАдреса.Город.КодКлассификатора);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("НаселенныйПункт", ЧастиАдреса.НаселенныйПункт.Значение);
	Если ЧастиАдреса.НаселенныйПункт.Свойство("КодКлассификатора") Тогда
		ПараметрыФормы.Вставить("НаселенныйПунктКодКлассификатора", ЧастиАдреса.НаселенныйПункт.КодКлассификатора);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Уровень", Уровень);
	
	МодульКЛАДР = КлиентскийМодульКЛАДР();
	МодульКЛАДР.ОткрытьФормуВыбораКЛАДР(ПараметрыФормы, Элемент);
КонецПроцедуры

Функция НаименованиеНаселенногоПунктаПоЧастямАдресаКЛАДР(ЧастиАдреса)
	Возврат КонтактнаяИнформацияКлиентСервер.ПолноеНаименование(
		ЗначениеИлиНаименование(ЧастиАдреса.НаселенныйПункт), "", 
		ЗначениеИлиНаименование(ЧастиАдреса.Город), "", 
		ЗначениеИлиНаименование(ЧастиАдреса.Район), "", 
		ЗначениеИлиНаименование(ЧастиАдреса.Регион), "", );
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////

Функция ЗначениеИлиНаименование(ЧастьАдреса)
	Если ПустаяСтрока(ЧастьАдреса.Значение) Тогда
		Возврат СокрЛП("" + ЧастьАдреса.Наименование + " " + ЧастьАдреса.Сокращение);
	КонецЕсли;
	Возврат ЧастьАдреса.Значение;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает строку дополнительных значений по имени реквизита.
//
// Параметры:
//    Форма   - Форма - передаваемая форма.
//    Элемент - ДанныеФормыСтруктураСКоллекцией - данные формы.
//
// Возвращаемое значение - Неопределено или СтрокаКоллекции - строка коллекции.
//
Функция ПолучитьСтрокуДополнительныхЗначений(Форма, Элемент, ЭтоТабличнаяЧасть = Ложь)
	
	Отбор = Новый Структура("ИмяРеквизита", Элемент.Имя);
	Строки = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
	ДанныеСтроки = ?(Строки.Количество() = 0, Неопределено, Строки[0]);
	
	Если ЭтоТабличнаяЧасть И ДанныеСтроки <> Неопределено Тогда
		
		ПутьКСтроке = Форма.Элементы[Форма.ТекущийЭлемент.Имя].ТекущиеДанные;
		
		ДанныеСтроки.Представление = ПутьКСтроке[Элемент.Имя];
		ДанныеСтроки.ЗначенияПолей = ПутьКСтроке[Элемент.Имя + "ЗначенияПолей"];
		
	КонецЕсли;
	
	Возврат ДанныеСтроки;
	
КонецФункции

// Формирует строковое представление телефона.
//
// Параметры:
//    КодСтраны     - Строка - код страны.
//    КодГорода     - Строка - код города.
//    НомерТелефона - Строка - номер телефона.
//    Добавочный    - Строка - добавочный номер.
//    Комментарий - Строка - комментарий.
//
// Возвращаемое значение - Строка - представление телефона.
//
Функция СформироватьПредставлениеТелефона(КодСтраны, КодГорода, НомерТелефона, Добавочный, Комментарий) Экспорт
	
	Представление = УправлениеКонтактнойИнформациейКлиентСервер.СформироватьПредставлениеТелефона(
	КодСтраны, КодГорода, НомерТелефона, Добавочный, Комментарий);
	
	Возврат Представление;
	
КонецФункции

// Заполнение адреса другим адресом
Процедура ЗаполнитьАдрес(Знач Форма, Знач ИмяРеквизита, Знач НайденнаяСтрока, Знач Результат)
	
	// Все строки - адреса,
	ВсеСтроки = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
	НайденныеСтроки = ВсеСтроки.НайтиСтроки( Новый Структура("Тип, ЭтоРеквизитТабличнойЧасти", НайденнаяСтрока.Тип, Ложь) );
	НайденныеСтроки.Удалить( НайденныеСтроки.Найти(НайденнаяСтрока) );
	
	ЗначенияПолейДляАнализа = Новый Массив;
	Для Каждого Адрес Из НайденныеСтроки Цикл
		ЗначенияПолейДляАнализа.Добавить(Новый Структура("Идентификатор, Представление, ЗначениеПолей, ВидАдреса",
			Адрес.ПолучитьИдентификатор(), Адрес.Представление, Адрес.ЗначенияПолей, Адрес.Вид));
	КонецЦикла;
	
	АдресаДляЗаполнения = КонтактнаяИнформацияСлужебныйВызовСервера.ДоступныеДляКопированияАдреса(ЗначенияПолейДляАнализа, НайденнаяСтрока.Вид);
		
	Если АдресаДляЗаполнения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьАдресЗавершение", ЭтотОбъект, Новый Структура);
	Оповещение.ДополнительныеПараметры.Вставить("Форма", Форма);
	Оповещение.ДополнительныеПараметры.Вставить("НайденнаяСтрока", НайденнаяСтрока);
	Оповещение.ДополнительныеПараметры.Вставить("ИмяРеквизита",    ИмяРеквизита);
	Оповещение.ДополнительныеПараметры.Вставить("Результат",       Результат);
	
	Форма.ПоказатьВыборИзМеню(Оповещение, АдресаДляЗаполнения, Форма.Элементы["Команда" + ИмяРеквизита]);
КонецПроцедуры

// Завершение немодального диалога
Процедура ЗаполнитьАдресЗавершение(Знач ВыбранныйЭлемент, Знач ДополнительныеПараметры) Экспорт
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВсеСтроки = ДополнительныеПараметры.Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
	СтрокаИсточник = ВсеСтроки.НайтиПоИдентификатору(ВыбранныйЭлемент.Значение);
	Если СтрокаИсточник = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ДополнительныеПараметры.НайденнаяСтрока.ЗначенияПолей = СтрокаИсточник.ЗначенияПолей;
	ДополнительныеПараметры.НайденнаяСтрока.Представление = СтрокаИсточник.Представление;
	ДополнительныеПараметры.НайденнаяСтрока.Комментарий   = СтрокаИсточник.Комментарий;
		
	ДополнительныеПараметры.Форма[ДополнительныеПараметры.ИмяРеквизита] = СтрокаИсточник.Представление;
		
	ДополнительныеПараметры.Форма.Модифицированность = Истина;
	ОбновитьКонтактнуюИнформациюФормы(ДополнительныеПараметры.Форма, ДополнительныеПараметры.Результат);

КонецПроцедуры

// Ввод комментария из контекстного меню
Процедура ВвестиКомментарий(Знач Форма, Знач ИмяРеквизита, Знач НайденнаяСтрока, Знач Результат)
	Комментарий = НайденнаяСтрока.Комментарий;
	
	Оповещение = Новый ОписаниеОповещения("ВвестиКомментарийЗавершение", ЭтотОбъект, Новый Структура);
	Оповещение.ДополнительныеПараметры.Вставить("Форма", Форма);
	Оповещение.ДополнительныеПараметры.Вставить("ИмяРеквизитаКомментария", "Комментарий" + ИмяРеквизита);
	Оповещение.ДополнительныеПараметры.Вставить("НайденнаяСтрока", НайденнаяСтрока);
	Оповещение.ДополнительныеПараметры.Вставить("ПредыдущийКомментарий", Комментарий);
	Оповещение.ДополнительныеПараметры.Вставить("Результат", Результат);
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, Комментарий, 
		НСтр("ru = 'Комментарий'"));
КонецПроцедуры

// Завершение немодального диалога
Процедура ВвестиКомментарийЗавершение(Знач Комментарий, Знач ДополнительныеПараметры) Экспорт
	Если Комментарий = Неопределено Или Комментарий = ДополнительныеПараметры.ПредыдущийКомментарий Тогда
		// Отказ от ввода или нет изменений
		Возврат;
	КонецЕсли;
	
	КомментарийБылПустой  = ПустаяСтрока(ДополнительныеПараметры.ПредыдущийКомментарий);
	КомментарийСталПустой = ПустаяСтрока(Комментарий);
	
	ДополнительныеПараметры.НайденнаяСтрока.Комментарий = Комментарий;
	
	Если КомментарийБылПустой И Не КомментарийСталПустой Тогда
		ДополнительныеПараметры.Результат.Вставить("ЭтоДобавлениеКомментария", Истина);
	ИначеЕсли Не КомментарийБылПустой И КомментарийСталПустой Тогда
		ДополнительныеПараметры.Результат.Вставить("ЭтоДобавлениеКомментария", Ложь);
	Иначе
		Элемент = ДополнительныеПараметры.Форма.Элементы[ДополнительныеПараметры.ИмяРеквизитаКомментария];
		Элемент.Заголовок = Комментарий;
	КонецЕсли;
	
	ДополнительныеПараметры.Форма.Модифицированность = Истина;
	ОбновитьКонтактнуюИнформациюФормы(ДополнительныеПараметры.Форма, ДополнительныеПараметры.Результат)
КонецПроцедуры

// Контекстный вызов
Процедура ОбновитьКонтактнуюИнформациюФормы(Форма, Результат)

	Форма.ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры

Функция ЭтоТабличнаяЧасть(Элемент)
	
	Родитель = Элемент.Родитель;
	
	Пока ТипЗнч(Родитель) <> Тип("УправляемаяФорма") Цикл
		
		Если ТипЗнч(Родитель) = Тип("ТаблицаФормы") Тогда
			Возврат Истина;
		КонецЕсли;
		
		Родитель = Родитель.Родитель;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы

// Открывает форму загрузки адресного классификатора.
//
Процедура ПриЗагрузкеАдресногоКлассификатора() Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
		МодульАдресныйКлассификаторКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("АдресныйКлассификаторКлиент");
		МодульАдресныйКлассификаторКлиент.ЗагрузитьАдресныйКлассификатор();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
