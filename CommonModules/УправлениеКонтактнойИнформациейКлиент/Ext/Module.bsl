﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контактная информация".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Событие ПриИзменении в колонке Представление таблицы контактной информации
Процедура ПредставлениеПриИзменении(Форма, Элемент, КИТабличнойЧасти = Ложь) Экспорт
	
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
	Если ДанныеСтроки=Неопределено Тогда 
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

// Событие НачалоВыбора в колонке Представление таблицы контактной информации
Функция ПредставлениеНачалоВыбора(Форма, Элемент, Модифицированность = Истина, СтандартнаяОбработка = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Результат = Новый Структура;
	Результат.Вставить("ИмяРеквизита", Элемент.Имя);
	
	ЭтоТабличнаяЧасть = ЭтоТабличнаяЧасть(Элемент);
	
	Если ЭтоТабличнаяЧасть Тогда
		ДанныеЗаполнения = Форма.Элементы[Форма.ТекущийЭлемент.Имя].ТекущиеДанные;
		Если ДанныеЗаполнения = Неопределено Тогда
			Возврат Результат;
		КонецЕсли;
	Иначе
		ДанныеЗаполнения = Форма;
	КонецЕсли;
	
	ДанныеСтроки = ПолучитьСтрокуДополнительныхЗначений(Форма, Элемент, ЭтоТабличнаяЧасть);
	
	// Если представление было изменено в поле и не соответствует реквизиту, то приводим в соответствие
	Если ДанныеЗаполнения[Элемент.Имя]<>Элемент.ТекстРедактирования Тогда
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
	
	РезультатОткрытияФормы = ОткрытьФормуКонтактнойИнформацииМодально(ПараметрыОткрытия);
	Если ТипЗнч(РезультатОткрытияФормы)<>Тип("Структура") Тогда
		Возврат Результат;
	КонецЕсли;
	
	ТекстПредставления = РезультатОткрытияФормы.Представление;
	
	Если ЭтоТабличнаяЧасть Тогда
		ДанныеЗаполнения[Элемент.Имя + "ЗначенияПолей"] = РезультатОткрытияФормы.КонтактнаяИнформация;
		
	Иначе
		Если ПустаяСтрока(ДанныеСтроки.Комментарий) И Не ПустаяСтрока(РезультатОткрытияФормы.Комментарий) Тогда
			Результат.Вставить("ЭтоДобавлениеКомментария", Истина);
			
		ИначеЕсли Не ПустаяСтрока(ДанныеСтроки.Комментарий) И ПустаяСтрока(РезультатОткрытияФормы.Комментарий) Тогда
			Результат.Вставить("ЭтоДобавлениеКомментария", Ложь);
			
		Иначе
			Если Не ПустаяСтрока(ДанныеСтроки.Комментарий) Тогда
				Форма.Элементы["Комментарий" + Элемент.Имя].Заголовок = РезультатОткрытияФормы.Комментарий;
			КонецЕсли;
			
		КонецЕсли;
		
		ДанныеСтроки.Представление = ТекстПредставления;
		ДанныеСтроки.ЗначенияПолей = РезультатОткрытияФормы.КонтактнаяИнформация;
		ДанныеСтроки.Комментарий   = РезультатОткрытияФормы.Комментарий;
	КонецЕсли;
	
	ДанныеЗаполнения[Элемент.Имя] = ТекстПредставления;
	
	Форма.Модифицированность = Истина;
	
	Возврат Результат;
КонецФункции

// Событие Очистка в колонке Представление таблицы контактной информации
Функция ПредставлениеОчистка(Форма, ИмяРеквизита) Экспорт
	
	Результат = Новый Структура("ИмяРеквизита", ИмяРеквизита);
	НайденнаяСтрока = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Результат)[0];
	НайденнаяСтрока.ЗначенияПолей = "";
	НайденнаяСтрока.Представление = "";
	
	Если ЗначениеЗаполнено(НайденнаяСтрока.Комментарий) Тогда
		Результат.Вставить("ЭтоДобавлениеКомментария", Ложь);
	КонецЕсли;
	НайденнаяСтрока.Комментарий = "";
	
	Форма[ИмяРеквизита] = "";
	Форма.Модифицированность = Истина;
	
	Возврат Результат;
	
КонецФункции

// Событие ОбработкаВыбора в поле ввода страны мира
Процедура СтранаМираОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	Если Не СтандартнаяОбработка Тогда 
		Возврат;
	КонецЕсли;
	
	ТипВыбранного = ТипЗнч(ВыбранноеЗначение);
	Если ТипВыбранного=Тип("Массив") Тогда
		СписокПреобразования = Новый Соответствие;
		Для Индекс=0 По ВыбранноеЗначение.ВГраница() Цикл
			Данные = ВыбранноеЗначение[Индекс];
			Если ТипЗнч(Данные)=Тип("Структура") И Данные.Свойство("Код") Тогда
				СписокПреобразования.Вставить(Индекс, Данные.Код);
			КонецЕсли;
		КонецЦикла;
		
		Если СписокПреобразования.Количество()>0 Тогда
			КонтактнаяИнформацияСлужебныйВызовСервера.КоллекцияСтранМираПоДаннымКлассификатора(СписокПреобразования);
			Для Каждого КлючЗначение Из СписокПреобразования Цикл
				ВыбранноеЗначение[КлючЗначение.Ключ] = КлючЗначение.Значение;
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ТипВыбранного=Тип("Структура") И ВыбранноеЗначение.Свойство("Код") Тогда
		ВыбранноеЗначение = КонтактнаяИнформацияСлужебныйВызовСервера.СтранаМираПоДаннымКлассификатора(ВыбранноеЗначение.Код);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик дополнительной команды (копирование, активация и.т.п) контактной информации
Функция ПодключаемаяКоманда(Форма, Знач ИмяКоманды) Экспорт
	
	Результат = Новый Структура;
	
	Если ИмяКоманды = "КонтактнаяИнформацияДобавитьПолеВвода" Тогда
		
		ВыбраннаяСтрока = Форма.ВыбратьИзМеню(Форма.СписокДобавляемыхЭлементовКонтактнойИнформации, Форма.Элементы.КонтактнаяИнформацияДобавитьПолеВвода);
		
		Если ВыбраннаяСтрока <> Неопределено Тогда
			Результат.Вставить("ДобавляемыйВид", ВыбраннаяСтрока.Значение);
			Форма.Модифицированность = Истина;
		КонецЕсли;
		
		Возврат Результат;
		
	ИначеЕсли Лев(ИмяКоманды, 7) = "Команда" Тогда
		ИмяРеквизита = СтрЗаменить(ИмяКоманды, "Команда", "");
		КомандаКонтекстногоМеню = Ложь;
	Иначе
		ИмяРеквизита = СтрЗаменить(ИмяКоманды, "КонтекстноеМеню", "");
		КомандаКонтекстногоМеню = Истина;
	КонецЕсли;
	
	Результат.Вставить("ИмяРеквизита", ИмяРеквизита);
	НайденнаяСтрока = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Результат)[0];
	ТипКонтактнойИнформации = НайденнаяСтрока.Тип;
	
	Если КомандаКонтекстногоМеню Тогда
		
		ВвестиКомментарий(Форма, ИмяРеквизита, НайденнаяСтрока, Результат);
		
	Иначе
		
		Если ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
			
			ЗаполнитьАдрес(Форма, ИмяРеквизита, НайденнаяСтрока, Результат);
			
		ИначеЕсли ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
			
			НаписатьПисьмо(Форма, ИмяРеквизита);
			
		ИначеЕсли ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.ВебСтраница") Тогда
			
			ПерейтиПоСсылке(Форма, ИмяРеквизита);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обработчик открытия формы адреса
Процедура ОткрытьФормуВводаАдреса(Форма, Результат) Экспорт
	
	Если Результат.Свойство("ЭлементФормыАдреса") Тогда
		ПредставлениеНачалоВыбора(Форма, Форма.Элементы[Результат.ЭлементФормыАдреса]);
	КонецЕсли;
	
КонецПроцедуры

//  Конструктор для структуры параметров открытия формы контактной информации
//
//  Параметры:
//      ВидКонтактнойИнформации - вид редактируемой информации, СправочникСсылка.ВидыКонтактнойИнформации
//      Значение                - строка с сериализованным значением полей контактной информации
//      Представление           - необязательное представление
//
Функция ПараметрыФормыКонтактнойИнформации(ВидКонтактнойИнформации, Значение, Представление=Неопределено, Комментарий=Неопределено) Экспорт
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
//
//  Возвращаемое значение: необходимая форма
//
Функция ОткрытьФормуКонтактнойИнформации(Параметры, Владелец=Неопределено, Уникальность=Неопределено, Окно=Неопределено) Экспорт
	Возврат ОткрытьФормуКонтактнойИнформацииВнутр(Параметры, Владелец, Уникальность, Окно);
КонецФункции

//  Модально открывает подходящую форму контактной информации для редактирования или просмотра
//
//  Параметры:
//      Параметры    - результат функции ПараметрыФормыКонтактнойИнформации
//      Владелец     - параметр для открываемой формы
//      Уникальность - параметр для открываемой формы
//      Окно         - параметр для открываемой формы
//
//  Возвращаемое значение: необходимая форма
//
Функция ОткрытьФормуКонтактнойИнформацииМодально(Параметры, Владелец=Неопределено, Уникальность=Неопределено, Окно=Неопределено) Экспорт
	Возврат ОткрытьФормуКонтактнойИнформацииВнутр(Параметры, Владелец, Уникальность, Окно, Истина);
КонецФункции

//  Производит действие для экземпляра контактной информации по его типу
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
Процедура АктивироватьКонтактнуюИнформацию(Знач ЗначенияПолей, Знач Представление="", ОжидаемыйВид=Неопределено) Экспорт
	
	КонтактнаяИнформация = КонтактнаяИнформацияСлужебныйВызовСервера.ПривестиКонтактнуюИнформациюXML(
		Новый Структура("ЗначенияПолей, Представление, ВидКонтактнойИнформации", ЗначенияПолей, Представление, ОжидаемыйВид));
	ТипИнформации = КонтактнаяИнформация.ТипКонтактнойИнформации;
	
	ВсеВиды = "Перечисление.ТипыКонтактнойИнформации.";
	Если ТипИнформации=ПредопределенноеЗначение(ВсеВиды + "АдресЭлектроннойПочты") Тогда
		СоздатьПисьмоПоКонтактнойИнформации(КонтактнаяИнформация.ДанныеXML);
	
	ИначеЕсли ТипИнформации=ПредопределенноеЗначение(ВсеВиды + "ВебСтраница") Тогда
		ОткрытьСсылкуПоКонтактнойИнформации(КонтактнаяИнформация.ДанныеXML);
		
	Иначе
		ВызватьИсключение СтрЗаменить(НСтр("ru='Нельзя активировать контактную информацию с типом ""%1""'"),
			"%1", ТипИнформации);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

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

Процедура НаписатьПисьмо(Форма, ИмяРеквизита)
	
	АдресПочты = Форма.Элементы[ИмяРеквизита].ТекстРедактирования;
	
	МодульПочты = МодульКлиентаПочты();
	Если МодульПочты=Неопределено Тогда
		// Нет подсистемы почты
		ЗапуститьПриложение("mailto:" + АдресПочты);
	Иначе        
		// Используем встроенную
		МодульПочты.ОткрытьФормуОтправкиПочтовогоСообщения(, АдресПочты);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПерейтиПоСсылке(Форма, ИмяРеквизита)
	
	АдресСсылки = Форма.Элементы[ИмяРеквизита].ТекстРедактирования;
	
	Попытка
		ПерейтиПоНавигационнойСсылке(АдресСсылки);
	Исключение
		Попытка
			АдресСсылкиHttp = "http://" + АдресСсылки;
			ПерейтиПоНавигационнойСсылке(АдресСсылкиHttp);
		Исключение
			ПерейтиПоНавигационнойСсылке(АдресСсылки);
		КонецПопытки;
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗаполнитьАдрес(Форма, ИмяРеквизита, НайденнаяСтрока, Результат)
	
	Отбор = Новый Структура("Тип, ЭтоРеквизитТабличнойЧасти", НайденнаяСтрока.Тип, Ложь);
	НайденныеСтроки = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
	
	НайденныеСтроки.Удалить(НайденныеСтроки.Найти(НайденнаяСтрока));
	
	АдресаДляЗаполнения = Новый СписокЗначений;
	
	Для Каждого Адрес Из НайденныеСтроки Цикл
		
		Если ПустаяСтрока(Адрес.Представление) Тогда
			Продолжить;
		КонецЕсли;
		
		АдресаДляЗаполнения.Добавить(Адрес, Строка(Адрес.Вид) + ": " + Адрес.Представление);
		
	КонецЦикла;
	
	КоличествоАдресов = АдресаДляЗаполнения.Количество();
	
	Если КоличествоАдресов = 1 Тогда
		
		ВыбранныйАдрес = АдресаДляЗаполнения[0];
		
	ИначеЕсли КоличествоАдресов > 1 Тогда
		
		ВыбранныйАдрес = Форма.ВыбратьИзМеню(АдресаДляЗаполнения, Форма.Элементы["Команда" + ИмяРеквизита]);
		
	Иначе
		
		ВыбранныйАдрес = Неопределено;
		
	КонецЕсли;
	
	Если ВыбранныйАдрес <> Неопределено Тогда
		
		СтрокаДляКопирования = ВыбранныйАдрес.Значение;
		
		Если ПустаяСтрока(НайденнаяСтрока.Комментарий) И Не ПустаяСтрока(СтрокаДляКопирования.Комментарий) Тогда
			Результат.Вставить("ЭтоДобавлениеКомментария", Истина);
		ИначеЕсли Не ПустаяСтрока(НайденнаяСтрока.Комментарий) И ПустаяСтрока(СтрокаДляКопирования.Комментарий) Тогда
			Результат.Вставить("ЭтоДобавлениеКомментария", Ложь);
		КонецЕсли;
		
		НайденнаяСтрока.ЗначенияПолей = СтрокаДляКопирования.ЗначенияПолей;
		НайденнаяСтрока.Представление = СтрокаДляКопирования.Представление;
		НайденнаяСтрока.Комментарий = СтрокаДляКопирования.Комментарий;
		
		Форма[ИмяРеквизита] = СтрокаДляКопирования.Представление;
		
		Форма.Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВвестиКомментарий(Форма, ИмяРеквизита, НайденнаяСтрока, Результат)
	
	ИмяКомментарияРеквизита = НСтр("ru='Комментарий'") + ИмяРеквизита;
	
	Комментарий = НайденнаяСтрока.Комментарий;
	
	КомментарийБылПустой = ПустаяСтрока(Комментарий);
	
	КомментарийИзменился = Ложь;
	ОбщегоНазначенияКлиент.ОткрытьФормуРедактированияКомментария(Комментарий, Комментарий, КомментарийИзменился);
	
	КомментарийСталПустой = ПустаяСтрока(Комментарий);
	
	ТребуетсяПерерисовка = Ложь;
	
	Если КомментарийИзменился Тогда
		
		Форма.Модифицированность = Истина;
		НайденнаяСтрока.Комментарий = Комментарий;
		
		Если КомментарийБылПустой И Не КомментарийСталПустой Тогда
			Результат.Вставить("ЭтоДобавлениеКомментария", Истина);
		ИначеЕсли Не КомментарийБылПустой И КомментарийСталПустой Тогда
			Результат.Вставить("ЭтоДобавлениеКомментария", Ложь);
		Иначе
			
			КомментарийЭлемента = Форма.Элементы[ИмяКомментарияРеквизита];
			КомментарийЭлемента.Заголовок = Комментарий;
			
		КонецЕсли;
		
	КонецЕсли;
	
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
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
		МодульАдресныйКлассификаторКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("АдресныйКлассификаторКлиент");
		МодульАдресныйКлассификаторКлиент.ЗагрузитьАдресныйКлассификатор();
	КонецЕсли;
	
КонецПроцедуры

// Проверяет возможность изменения заблокированных реквизитов формы
//
Процедура ПриРазрешенииРедактированияРеквизитовОбъекта(Форма, РедактированиеРазрешено) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
		МодульЗапретРедактированияРеквизитовОбъектовКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектовКлиент");
		РедактированиеРазрешено = МодульЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(Форма);
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает доступность элементов формы
//
Процедура ПриУстановкеДоступностиЭлементовФормы(Форма) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
		МодульЗапретРедактированияРеквизитовОбъектовКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектовКлиент");
		МодульЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(Форма);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет использование подсистемы "Работа с почтовыми сообщениями", возвращает клиентский модуль для работы
//
Функция МодульКлиентаПочты()
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		Возврат ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

//  Обработчик события НачалоВыбора для улицы
//
//  Параметры:
//      Элемент                            - вызывающий элемент формы
//      КодКлассификатораНаселенногоПункта - ограничение по населенному пункту
//      ТекущееЗначение                    - текущее значение - или код классификатора, или текст
//      ПараметрыФормы                     - необязательная дополнительная структура параметров для формы подбора
//
Процедура НачалоВыбораУлицы(Элемент, КодКлассификатораНаселенногоПункта, ТекущееЗначение, ПараметрыФормы=Неопределено) Экспорт
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	ИмяПеречисленияКЛАДР = "Перечисление.ВариантыАдресногоКлассификатора.КЛАДР";
	
	Если Вариант=Неопределено Тогда
		// Нет подсистемы классификатора
		Возврат;
	ИначеЕсли Вариант=ПредопределенноеЗначение(ИмяПеречисленияКЛАДР) Тогда
		НачалоВыбораУлицыКЛАДР(Элемент, КодКлассификатораНаселенногоПункта, ТекущееЗначение, ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры    

//  Обработчик события НачалоВыбора для элемента адреса (субъект РФ, район, город и т.п.)
//
//  Параметры:
//      Элемент        - вызывающий элемент формы
//      КодЧастиАдреса - идентификатор обрабатываемой части адреса, зависит от классификатора
//      ЧастиАдреса    - значения для других частей адреса, зависит от классификатора
//      ПараметрыФормы - необязательная  дополнительная структура параметров для формы подбора
//
Процедура НачалоВыбораЭлементаАдреса(Элемент, КодЧастиАдреса, ЧастиАдреса, ПараметрыФормы=Неопределено) Экспорт
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	ИмяПеречисленияКЛАДР = "Перечисление.ВариантыАдресногоКлассификатора.КЛАДР";
	
	Если Вариант=Неопределено Тогда
		// Нет подсистемы классификатора
		Возврат;
	ИначеЕсли Вариант=ПредопределенноеЗначение(ИмяПеречисленияКЛАДР) Тогда
		НачалоВыбораЭлементаАдресаКЛАДР(Элемент, КодЧастиАдреса, ЧастиАдреса, ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

//  Возвращает полное наименование для населенного пункта. Под населенным пунктом понимается синтетическое 
//  поле, характеризующее все, что больше улицы
//
//  Параметры:
//      ЧастиАдреса - значения для частей адреса, зависит от классификатора
//
Функция НаименованиеНаселенногоПунктаПоЧастямАдреса(ЧастиАдреса) Экспорт
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	ИмяПеречисленияКЛАДР = "Перечисление.ВариантыАдресногоКлассификатора.КЛАДР";
	
	Если Вариант=Неопределено Тогда
		// Нет подсистемы классификатора
		Возврат "";
	ИначеЕсли Вариант=ПредопределенноеЗначение(ИмяПеречисленияКЛАДР) Тогда
		Возврат НаименованиеНаселенногоПунктаПоЧастямАдресаКЛАДР(ЧастиАдреса)
	КонецЕсли;
	
	Возврат "";
КонецФункции    

//  Предлагает загрузить адресный классификатор
//
//  Параметры:
//      Текст - строка с дополнительным текстов предложения
//
Процедура ПредложениеЗагрузкиКлассификатора(Текст="") Экспорт
	
#Если ВебКлиент Тогда
	Возврат;
#КонецЕсли
	
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	ИмяПеречисленияКЛАДР = "Перечисление.ВариантыАдресногоКлассификатора.КЛАДР";
	
	Если Вариант=Неопределено Тогда
		// Нет подсистемы классификатора
		Возврат;
	ИначеЕсли Вариант<>ПредопределенноеЗначение(ИмяПеречисленияКЛАДР) Тогда
		Возврат;    
	КонецЕсли;
	
	ТекстЗаголовка = НСтр("ru='Подтверждение'");
	ТекстВопроса   = Текст + Символы.ПС + НСтр("ru='Загрузить классификатор сейчас?'");
	
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ТекстЗаголовка);
	Если Ответ=КодВозвратаДиалога.Да Тогда
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
	ИмяПеречисленияКЛАДР = "Перечисление.ВариантыАдресногоКлассификатора.КЛАДР";
	
	Если Вариант=Неопределено Тогда
		// Нет подсистемы классификатора
		Возврат;
	ИначеЕсли Вариант=ПредопределенноеЗначение(ИмяПеречисленияКЛАДР) Тогда
		Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
			МодульКЛАДР = Вычислить("АдресныйКлассификаторКлиент");
			МодульКЛАДР.ЗагрузитьАдресныйКлассификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры    

////////////////////////////////////////////////////////////////////////////////////////////////////

Функция ОткрытьФормуКонтактнойИнформацииВнутр(Параметры, Владелец, Уникальность, Окно, Модально=Ложь) 
	
	ВидИнформации = Параметры.ВидКонтактнойИнформации;
	
	ИмяОткрываемойФормы = КонтактнаяИнформацияКлиентСерверПовтИсп.ИмяФормыВводаКонтактнойИнформации(ВидИнформации);
	Если ИмяОткрываемойФормы=Неопределено Тогда
		ВызватьИсключение НСтр("ru='Не обрабатываемый тип адреса: """ + ВидИнформации + """'");
	КонецЕсли;
	
	Если Не Параметры.Свойство("Заголовок") Тогда
		Параметры.Вставить("Заголовок", Строка(КонтактнаяИнформацияСлужебныйВызовСервера.ТипВидаКонтактнойИнформации(ВидИнформации)));
	КонецЕсли;
	
	Параметры.Вставить("ОткрытаПоСценарию", Истина);
	
	Если Модально Тогда
		Возврат ОткрытьФормуМодально(ИмяОткрываемойФормы, Параметры, Владелец);
	КонецЕсли;
	
	Возврат ОткрытьФорму(ИмяОткрываемойФормы, Параметры, Владелец, Уникальность, Окно);
КонецФункции

Процедура СоздатьПисьмоПоКонтактнойИнформации(Знач XMLДанные)
	АдресПочты = КонтактнаяИнформацияСлужебныйВызовСервера.СтрокаСоставаКонтактнойИнформации(XMLДанные);
	Если ТипЗнч(АдресПочты)<>Тип("Строка") Тогда
		ВызватьИсключение НСтр("ru='Ошибка получения адреса электронной почты, неверный тип контактной информации'");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		// Используем встроенную почту
		МодульПочты = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
		МодульПочты.ОткрытьФормуОтправкиПочтовогоСообщения(, АдресПочты);
		Возврат; 
	КонецЕсли;
	
	 // Нет подсистемы почты, запускаем системное
#Если ВебКлиент Тогда
	ТекстПредложения = НСтр("ru='Для отправки почты из веб-клиента необходимо установить расширение для работы с файлами.'");
	Если Не ОбщегоНазначенияКлиент.РасширениеРаботыСФайламиПодключено(ТекстПредложения) Тогда
		Возврат;
	КонецЕсли;
#КонецЕсли

	ЗапуститьПриложение("mailto:" + АдресПочты);
КонецПроцедуры

Процедура ОткрытьСсылкуПоКонтактнойИнформации(Знач XMLДанные)
	АдресСсылки = КонтактнаяИнформацияСлужебныйВызовСервера.СтрокаСоставаКонтактнойИнформации(XMLДанные);
	Если ТипЗнч(АдресСсылки)<>Тип("Строка") Тогда
		ВызватьИсключение НСтр("ru='Ошибка получения ссылки, неверный тип контактной информации'");
	КонецЕсли;
	
	Если Найти(АдресСсылки, "://")>0 Тогда
		ПерейтиПоНавигационнойСсылке(АдресСсылки);
	Иначе
		ПерейтиПоНавигационнойСсылке("http://" + АдресСсылки);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// Реализация КЛАДР
//

Процедура НачалоВыбораУлицыКЛАДР(Элемент, КодКлассификатораНаселенногоПункта, ТекущееЗначение, Параметры=Неопределено)
	ПараметрыФормы = ?(Параметры=Неопределено, Новый Структура, Параметры);
	
	ПараметрыФормы.Вставить("Уровень", 5);
	ПараметрыФормы.Вставить("Улица",   Строка(ТекущееЗначение));
	
	ИмяФормыКЛАДР = "РегистрСведений.АдресныйКлассификатор.Форма.ФормаВыбора";
	ОткрытьФорму(ИмяФормыКЛАДР, ПараметрыФормы, Элемент);
КонецПроцедуры

Процедура НачалоВыбораЭлементаАдресаКЛАДР(Элемент, КодЧастиАдреса, ЧастиАдреса, Параметры=Неопределено)
	
	ПараметрыФормы = ?(Параметры=Неопределено, Новый Структура, Параметры);
	
	ПараметрыФормы.Вставить("Регион", ЧастиАдреса.Регион.Значение);
	ПараметрыФормы.Вставить("Район", ЧастиАдреса.Район.Значение);
	ПараметрыФормы.Вставить("Город", ЧастиАдреса.Город.Значение);
	ПараметрыФормы.Вставить("НаселенныйПункт", ЧастиАдреса.НаселенныйПункт.Значение);
	
	КодРеквизита = ВРег(КодЧастиАдреса);
	Если КодРеквизита="РЕГИОН" Тогда
		Уровень = 1;    
	ИначеЕсли КодРеквизита="РАЙОН" Тогда
		Уровень = 2;    
	ИначеЕсли КодРеквизита="ГОРОД" Тогда
		Уровень = 3;
	ИначеЕсли КодРеквизита="НАСЕЛЕННЫЙПУНКТ" Тогда
		Уровень = 4;
	ИначеЕсли КодРеквизита="УЛИЦА" Тогда
		Уровень = 5;
	Иначе
		Возврат;
	КонецЕсли;        
	ПараметрыФормы.Вставить("Уровень", Уровень);
	
	ИмяФормыКЛАДР = "РегистрСведений.АдресныйКлассификатор.Форма.ФормаВыбора";
	ОткрытьФорму(ИмяФормыКЛАДР, ПараметрыФормы, Элемент);
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

