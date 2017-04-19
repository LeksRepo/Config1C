﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СохранитьПараметрыОткрытия(Параметры);
	Взаимодействия.ОбработатьНеобходимостьОтображенияГруппПользователей(ЭтаФорма);
	Взаимодействия.ДобавитьСтраницыФормыПодбораКонтактов(ЭтаФорма);
	
	// Заполним контакты по предмету
	Взаимодействия.ЗаполнитьКонтактыПоПредмету(Элементы, Параметры.Предмет, КонтактыПоПредмету, Ложь);
	
	// Получим информацию об индексе ППД
	Взаимодействия.ОбновитьИнформациюОбАктуальностиИндексаППД(ИнформацияОбАктуальностиИндексаППД, ППДВключен, ИндексАктуален);
	
	// Заполним список вариантов поиска и осуществим первый поиск
	ВсеСпискиПоиска = Взаимодействия.ПолучитьСписокДоступныхПоисков(ППДВключен, Параметры, Элементы, Ложь);
	ВыполнитьПервыйПоиск();
	
	// Если заполнен контакт, установим нужной текущую страницу и спозиционируемся на нем
	Если ЗначениеЗаполнено(Параметры.Контакт) Тогда
		УстановитьТекущимКонтакт(Параметры.Контакт)
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьСписокВыбораВСтрокеПоиска(Ложь);
	УправлениеДоступностью();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НайденныеКонтактыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Оповестить("ВыбранКонтакт", ПараметрыОповещения(Элемент.ТекущиеДанные.Ссылка));
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура СписокСправочникаВыбор(Элемент, ВыбраннаяСтрока,Поле , СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено  Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеКонтакта = Новый Структура;
	
	МассивОписанийКонтакта = ВзаимодействияКлиентСервер.ПолучитьМассивОписанияВозможныхКонтактов();
	Для Каждого ЭлементМассива Из  МассивОписанийКонтакта Цикл
		Если ТипЗнч(ТекущиеДанные.Ссылка) = ЭлементМассива.Тип Тогда
			ОписаниеКонтакта = ЭлементМассива;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ОписаниеКонтакта.Свойство("Иерархический")И ОписаниеКонтакта.Иерархический Тогда
		ЭтоГруппа = ЭтоГруппа(ТекущиеДанные.Ссылка);
	Иначе
		ЭтоГруппа = Ложь;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		Оповестить("ВыбранКонтакт", ПараметрыОповещения(ТекущиеДанные.Ссылка));
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактыПоПредметуВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Оповестить("ВыбранКонтакт", ПараметрыОповещения(Элемент.ТекущиеДанные.Ссылка));
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантыПоискаПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбораВСтрокеПоиска(Истина);
	
КонецПроцедуры 

&НаКлиенте
Процедура Подключаемый_СписокКонтактыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоследнийАктивизированныйКонтакт = ТекущиеДанные.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокВладелецПриАктивизацииСтроки(Элемент)
	
	ВзаимодействияКлиент.КонтактВладелецПриАктивизацииСтроки(Элемент, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПриАктивизацииСтроки(Элемент)
	
	СписокПользователей.Параметры.УстановитьЗначениеПараметра("ГруппаПользователей", Элементы.ГруппыПользователей.ТекущаяСтрока);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

//Инициирует процесс поиска контактов.
//
&НаКлиенте
Процедура КомандаНайтиВыполнить()
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		Предупреждение(НСтр("ru = 'Не задана строка поиска!'"));
		Возврат;
	КонецЕсли;
	
	Результат = "";
	НайденныеКонтакты.Очистить();
	
	Если ВариантыПоиска = "ПоEmail" Тогда
		НайтиПоEmail(Ложь);
	ИначеЕсли ВариантыПоиска = "ПоДомену" Тогда
		НайтиПоEmail(Истина);
	ИначеЕсли ВариантыПоиска = "ПоТелефону" Тогда
		НайтиПоТелефону();
	ИначеЕсли ВариантыПоиска = "ПоСтроке" Тогда
		Результат = НайтиПоСтроке();
	ИначеЕсли ВариантыПоиска = "НачинаетсяС" Тогда
		НайтиПоНачалуНаименования();
	КонецЕсли;
	
	Если Не ПустаяСтрока(Результат) Тогда
		Предупреждение(Результат);
	КонецЕсли;
	
КонецПроцедуры

//Обновляет индекс полнотекстового поиска. 
// 
&НаКлиенте
Процедура КомандаОбновитьИндексППДВыполнить()
	
	ВзаимодействияКлиент.КомандаОбновитьИндексППДВыполнить(
		ИнформацияОбАктуальностиИндексаППД, ППДВключен, ИндексАктуален);
	УправлениеДоступностью();
	
КонецПроцедуры

//Выполняет позиционирование в соответствующем динамическом списке на текущем контакте из 
//списка "Найденные контакты".
//
&НаКлиенте
Процедура НайтиВСпискеИзСпискаНайденныхВыполнить()
	
	Если Элементы.НайденныеКонтакты.ТекущиеДанные <> Неопределено Тогда
		УстановитьТекущимКонтакт(Элементы.НайденныеКонтакты.ТекущиеДанные.Ссылка);
	КонецЕсли;

КонецПроцедуры

//Выполняет позиционирование в соответствующем динамическом списке на текущем контакте
//из списка "Контакты по предмету".
//
&НаКлиенте
Процедура НайтиВСпискеИзСпискаПредметовВыполнить()
	
	Если Элементы.КонтактыПоПредмету.ТекущиеДанные <> Неопределено Тогда
		УстановитьТекущимКонтакт(Элементы.КонтактыПоПредмету.ТекущиеДанные.Ссылка);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	Если Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПоискКонтактов Тогда
		
		ТекущиеДанные = Элементы.НайденныеКонтакты.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			Оповестить("ВыбранКонтакт", ПараметрыОповещения(ТекущиеДанные.Ссылка));
			Закрыть();
		КонецЕсли;
		
		Возврат;
		
	ИначеЕсли Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаВсеКонтактыПоПредмету Тогда
		
		ТекущиеДанные = Элементы.КонтактыПоПредмету.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			Оповестить("ВыбранКонтакт", ПараметрыОповещения(ТекущиеДанные.Ссылка));
			Закрыть();
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	КонтактДляВыбора = Неопределено;
	
	Для инд = 0 По Элементы.СтраницыСписки.ТекущаяСтраница.ПодчиненныеЭлементы.Количество() -1 Цикл
		
		ТекущиеДанные = Элементы.СтраницыСписки.ТекущаяСтраница.ПодчиненныеЭлементы[инд].ТекущиеДанные;
		Если ТекущиеДанные = Неопределено  Тогда
			Продолжить;
		Иначе
			Если ТекущиеДанные.Ссылка = ПоследнийАктивизированныйКонтакт Тогда
				КонтактДляВыбора = ПоследнийАктивизированныйКонтакт;
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если КонтактДляВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ОписаниеКонтакта = Новый Структура;
	
	МассивОписанийКонтакта = ВзаимодействияКлиентСервер.ПолучитьМассивОписанияВозможныхКонтактов();
	Для Каждого ЭлементМассива Из  МассивОписанийКонтакта Цикл
		Если ТипЗнч(КонтактДляВыбора) = ЭлементМассива.Тип Тогда
			ОписаниеКонтакта = ЭлементМассива;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ОписаниеКонтакта.Свойство("Иерархический")И ОписаниеКонтакта.Иерархический Тогда
		ЭтоГруппа = ЭтоГруппа(КонтактДляВыбора);
	Иначе
		ЭтоГруппа = Ложь;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		Оповестить("ВыбранКонтакт", ПараметрыОповещения(ТекущиеДанные.Ссылка));
		Закрыть(КонтактДляВыбора);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОСУЩЕСТВЛЕНИЯ ПОИСКА

// Формирует список значений строк, по которым будет осуществляться поиск по текущему варианту поиска.
//
// Возвращаемое значение:
//   СписокЗначений   - список строк, по которым будет осуществляться поиск.
//
&НаСервере
Функция СписокСтрокПоискаПоВарианту()

	СписокСтрок = Новый СписокЗначений;
	
	Значения = Неопределено;
	ВсеСпискиПоиска.Свойство(ВариантыПоиска, Значения);
	
	Если ТипЗнч(Значения) = Тип("Строка") Тогда
		СписокСтрок.Добавить(Значения);
	ИначеЕсли ТипЗнч(Значения) = Тип("СписокЗначений") Тогда
		Для Каждого Элемент Из Значения Цикл
			СписокСтрок.Добавить(Элемент.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СписокСтрок;

КонецФункции

// Выполняет первый поиск по всем возможным вариантам поиска согласно переданным параметрам.
//
&НаСервере
Процедура ВыполнитьПервыйПоиск()
	
	ВариантыПоиска = "ПоСтроке";
	Если ПустаяСтрока(Параметры.Адрес) И ПустаяСтрока(Параметры.Представление) Тогда
		Возврат;
	КонецЕсли;

	// Попробуем поискать по email
	ВариантыПоиска = "ПоEmail";
	Для Каждого Вариант Из СписокСтрокПоискаПоВарианту() Цикл
		СтрокаПоиска = Вариант.Значение;
		Если ПустаяСтрока(СтрокаПоиска) Тогда
			Продолжить;
		КонецЕсли;
		Если НайтиПоEmail(Ложь) Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	// Попробуем поискать по телефону
	ВариантыПоиска = "ПоТелефону";
	Для Каждого Вариант Из СписокСтрокПоискаПоВарианту() Цикл
		СтрокаПоиска = Вариант.Значение;
		Если ПустаяСтрока(СтрокаПоиска) Тогда
			Продолжить;
		КонецЕсли;
		Если НайтиПоТелефону() Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;

	// Если индекс ППД не включен то дальше не ищем
	Если НЕ ППДВключен Тогда
		ВариантыПоиска = "ПоEmail";
		Возврат;
	КонецЕсли;

	// Попробуем поискать по адресу и представлению
	ВариантыПоиска = "ПоСтроке";
	Для Каждого Вариант Из СписокСтрокПоискаПоВарианту() Цикл
		СтрокаПоиска = Вариант.Значение;
		Если ПустаяСтрока(СтрокаПоиска) Тогда
			Продолжить;
		КонецЕсли;
		НайтиПоСтроке();
		Если НайденныеКонтакты.Количество() > 0 Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

//Осуществляет поиск контактов по доменному имени или по адресу электронной почты.
//
&НаСервере
Функция НайтиПоEmail(ПоДомену)

	Возврат Взаимодействия.НайтиПоEmail(СтрокаПоиска, ПоДомену, ЭтаФорма);

КонецФункции

//Осуществляет поиск контактов по телефону.
//
&НаСервере
Функция НайтиПоТелефону()
	
	Возврат Взаимодействия.ПолучитьВсеКонтактыПоТелефону(СтрокаПоиска, ЭтаФорма);
	
КонецФункции

//Осуществляет поиск контактов по строке
//
&НаСервере
Функция НайтиПоСтроке()
	
	Возврат Взаимодействия.ОсуществитьПоискКонтактовПоСтроке(ЭтаФорма);
	
КонецФункции

// Осуществляет поиск контактов по началу наименования
//
&НаСервере
Функция НайтиПоНачалуНаименования()

	ТаблицаКонтактов = Взаимодействия.ПолучитьВсеКонтактыПоНачалуНаименования(СтрокаПоиска);

	Если ТаблицаКонтактов = Неопределено ИЛИ ТаблицаКонтактов.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Взаимодействия.ЗаполнитьНайденныеКонтакты(ТаблицаКонтактов, НайденныеКонтакты);
	Возврат Истина;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Устанавливает текущим контакт в соответствующем динамическом списке.
//
// Параметры
//  Контакт  - СправочникСсылка - контакт, на котором необходимо спозиционироваться.
// 
&НаСервере
Процедура УстановитьТекущимКонтакт(Контакт)

	Взаимодействия.УстановитьТекущимКонтакт(Контакт, ЭтаФорма );

КонецПроцедуры

&НаСервере
Процедура СохранитьПараметрыОткрытия(Параметры)
	
	ПараметрыФормы.Добавить( Параметры.Адрес,                             "Адрес");
	ПараметрыФормы.Добавить( Параметры.Контакт,                           "Контакт");
	ПараметрыФормы.Добавить( Параметры.Предмет,                           "Предмет");
	ПараметрыФормы.Добавить( Параметры.Представление,                     "Представление");
	ПараметрыФормы.Добавить( Параметры.ТолькоEmail,                       "ТолькоEmail");
	ПараметрыФормы.Добавить( Параметры.ТолькоТелефон,                     "ТолькоТелефон");
	ПараметрыФормы.Добавить( Параметры.ДляФормыУточненияКонтактов,        "ДляФормыУточненияКонтактов");
	ПараметрыФормы.Добавить( Параметры.ЗаменятьПустыеАдресИПредставление, "ЗаменятьПустыеАдресИПредставление");
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыОповещения(ВыбранныйКонтакт)

	ПараметрыОповещения = Новый Структура;
	
	Для каждого ЭлементСписка Из ПараметрыФормы Цикл
	
		ПараметрыОповещения.Вставить(ЭлементСписка.Представление, ЭлементСписка.Значение);
	
	КонецЦикла;
	
	ПараметрыОповещения.Вставить("ВыбранныйКонтакт", ВыбранныйКонтакт);
	
	Возврат ПараметрыОповещения;

КонецФункции 


&НаКлиенте
Процедура ЗаполнитьСписокВыбораВСтрокеПоиска(ИзменятьСтрокуПоиска)

	СписокВариантовПоиска = Неопределено;
	ВсеСпискиПоиска.Свойство(ВариантыПоиска, СписокВариантовПоиска);
	
	ЭтоСписок = Ложь;
	Если ТипЗнч(СписокВариантовПоиска) = Тип("СписокЗначений") Тогда
		Количество = СписокВариантовПоиска.Количество();
		Если Количество = 0 Тогда
			СписокВариантовПоиска = "";
		ИначеЕсли Количество = 1 Тогда
			СписокВариантовПоиска = СписокВариантовПоиска.Получить(0).Значение;
		Иначе
			ЭтоСписок = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83БезРежимаСовместимости() Тогда
		ИмяКнопки = "КнопкаВыпадающегоСписка";
	Иначе
		ИмяКнопки = "КнопкаСпискаВыбора";
	КонецЕсли;
	Элементы.СтрокаПоиска[ИмяКнопки] = ЭтоСписок;
	
	Если ЭтоСписок Тогда
		Элементы.СтрокаПоиска.СписокВыбора.Очистить();
		Для Каждого ЭлементВарианта Из СписокВариантовПоиска Цикл
			Элементы.СтрокаПоиска.СписокВыбора.Добавить(ЭлементВарианта.Значение);
		КонецЦикла;
		Если ИзменятьСтрокуПоиска Тогда
			СтрокаПоиска = СписокВариантовПоиска.Получить(0).Значение;
		КонецЕсли;
	ИначеЕсли ИзменятьСтрокуПоиска Тогда
		СтрокаПоиска = СписокВариантовПоиска;
	КонецЕсли;

КонецПроцедуры

// Управляет доступностью элементов формы
&НаКлиенте
Процедура УправлениеДоступностью()

	Элементы.КомандаОбновитьИндексППД.Доступность = Не ИндексАктуален;

КонецПроцедуры 

&НаСервере
Функция ЭтоГруппа(СсылкаНаОбъект)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаОбъект, "ЭтоГруппа");
КонецФункции
