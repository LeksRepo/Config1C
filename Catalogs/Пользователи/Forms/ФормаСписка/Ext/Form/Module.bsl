﻿////////////////////////////////////////////////////////////////////////////////
//                          ИСПОЛЬЗОВАНИЕ ФОРМЫ                               //
//
// Дополнительные параметры открытия формы подбора:
//
// РасширенныйПодбор - Булево - если Истина - открывается расширенная форма
//  подбора пользователей. Используется вместе с параметром
//  ПараметрыРасширеннойФормыПодбора.
// ПараметрыРасширеннойФормыПодбора - Строка - ссылка на структуру,
//  содержащую параметры расширенной формы подбора во
//  временном хранилище.
//  Параметры структуры:
//    ЗаголовокФормыПодбора - Строка - заголовок формы подбора.
//    ВыбранныеПользователи - Массив - массив уже выбранных пользователей.
//

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если ОбщегоНазначения.ПриСозданииФормыНаСервере(ЭтаФорма, СтандартнаяОбработка, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
	// Начальное значение настройки до загрузки данных из настроек.
	ВыбиратьИерархически = Истина;
	
	ЗаполнитьХранимыеПараметры();
	ЗаполнитьПараметрыДинамическихСписков();
	
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	// Скрытие пользователей с пустым идентификатором, если значение параметра Истина.
	Если Параметры.ДоступКИнформационнойБазеРазрешен Тогда
		
		Если Параметры.ДоступКИнформационнойБазеРазрешен = Ложь Тогда
			ВидСравненияКД = ВидСравненияКомпоновкиДанных.Равно;
		Иначе
			ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеРавно;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ПользователиСписок,
			"ИдентификаторПользователяИБ",
			Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"),
			ВидСравненияКД);
		
	КонецЕсли;
	
	// Скрытие служебных пользователей.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ПользователиСписок, "Служебный", Ложь, , , Истина);
	
	// Скрытие переданного пользователя из формы выбора пользователей.
	Если ТипЗнч(Параметры.СкрываемыеПользователи) = Тип("СписокЗначений") Тогда
		
		ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеВСписке;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ПользователиСписок,
			"Ссылка",
			Параметры.СкрываемыеПользователи,
			ВидСравненияКД);
		
	КонецЕсли;
	
	ОформитьИСкрытьНедействительныхПользователей();
	
	НастроитьПорядокГруппыВсеПользователи(ГруппыПользователей);
	
	ХранимыеПараметры.Вставить("РасширенныйПодбор", Параметры.РасширенныйПодбор);
	Элементы.ВыбранныеПользователиИГруппы.Видимость = ХранимыеПараметры.РасширенныйПодбор;
	ХранимыеПараметры.Вставить(
		"ИспользоватьГруппы", ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей"));
	
	Если НЕ ПравоДоступа("Добавление", Метаданные.Справочники.Пользователи) Тогда
		Элементы.СоздатьПользователя.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
	
		Если Элементы.Найти("ПользователиИБ") <> Неопределено Тогда
			Элементы.ПользователиИБ.Видимость = Ложь;
		КонецЕсли;
		
		// Отбор не помеченных на удаление.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ПользователиСписок, "ПометкаУдаления", Ложь, , , Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		
		Элементы.ПользователиСписок.РежимВыбора = Истина;
		Элементы.ГруппыПользователей.РежимВыбора = ХранимыеПараметры.ВыборГруппПользователей;
		// Отключение перетаскивания пользователя в формах выбора и подбора пользователей.
		Элементы.ПользователиСписок.РазрешитьНачалоПеретаскивания = Ложь;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Элементы.ПользователиСписок.МножественныйВыбор = Истина;
			
			Если ХранимыеПараметры.РасширенныйПодбор Тогда
				ЭтаФорма.КлючСохраненияПоложенияОкна = "РасширенныйПодборПользователей";
				ИзменитьПараметрыРасширеннойФормыПодбора();
			Иначе
				ЭтаФорма.КлючСохраненияПоложенияОкна = "РежимПодбораПользователей";
			КонецЕсли;
			
			Если ХранимыеПараметры.ВыборГруппПользователей Тогда
				Элементы.ГруппыПользователей.МножественныйВыбор = Истина;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.ВыбратьПользователя.Видимость = Ложь;
		Элементы.ВыбратьГруппуПользователей.Видимость = Ложь;
	КонецЕсли;
	
	ХранимыеПараметры.Вставить("ГруппаВсеПользователи", Справочники.ГруппыПользователей.ВсеПользователи);
	ХранимыеПараметры.Вставить("ТекущаяСтрока", Параметры.ТекущаяСтрока);
	НастроитьФормуПоИспользованиюГруппПользователей();
	ХранимыеПараметры.Удалить("ТекущаяСтрока");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_ГруппыПользователей")
	   И Источник = Элементы.ГруппыПользователей.ТекущаяСтрока Тогда
		
		Элементы.ПользователиСписок.Обновить();
		
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("Запись_ИспользоватьГруппыПользователей") Тогда
		
		ПодключитьОбработчикОжидания("ПриИзмененииИспользованияГруппПользователей", 0.1, Истина);
		
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("РазмещениеПользователейВГруппах") Тогда
		
		Элементы.ПользователиСписок.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ТипЗнч(Настройки["ВыбиратьИерархически"]) = Тип("Булево") Тогда
		ВыбиратьИерархически = Настройки["ВыбиратьИерархически"];
	КонецЕсли;
	
	Если НЕ ВыбиратьИерархически Тогда
		ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ХранимыеПараметры.РасширенныйПодбор
		Или Не СписокВыбранныхПользователейИзменен Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Список выбранных пользователей был изменен. Сохранить изменения?'");
	КнопкиВопроса = Новый СписокЗначений;
	КнопкиВопроса.Добавить(НСтр("ru='Да'"));
	КнопкиВопроса.Добавить(НСтр("ru='Нет'"));
	КнопкиВопроса.Добавить(НСтр("ru='Отмена'"));
	Ответ = Вопрос(ТекстВопроса, КнопкиВопроса,, КнопкиВопроса[0].Значение);
	
	Если Ответ = КнопкиВопроса[0].Значение Тогда
		МассивПользователей = РезультатВыбора();
		ОповеститьОВыборе(МассивПользователей);
	ИначеЕсли Ответ = КнопкиВопроса[2].Значение Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВыбиратьИерархическиПриИзменении(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ГруппыПользователей

&НаКлиенте
Процедура ГруппыПользователейПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ГруппыПользователейПослеАктивизацииСтроки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ХранимыеПараметры.РасширенныйПодбор Тогда
		ОповеститьОВыборе(Значение);
	Иначе
		
		ПолучитьКартинкиИЗаполнитьСписокВыбранных(Значение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ Копирование Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура;
		
		Если ЗначениеЗаполнено(Элементы.ГруппыПользователей.ТекущаяСтрока) Тогда
			ПараметрыФормы.Вставить(
				"ЗначенияЗаполнения",
				Новый Структура("Родитель", Элементы.ГруппыПользователей.ТекущаяСтрока));
		КонецЕсли;
		
		ОткрытьФорму(
			"Справочник.ГруппыПользователей.ФормаОбъекта",
			ПараметрыФормы,
			Элементы.ГруппыПользователей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбиратьИерархически Тогда
		Предупреждение(НСтр("ru = 'Для перетаскивания пользователя в группы необходимо отключить
			|флажок ""Показывать пользователей дочерних групп"".'"));
		Возврат;
	КонецЕсли;
	
	Если Элементы.ГруппыПользователей.ТекущаяСтрока = Строка
		Или Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение Тогда
		Перемещение = Истина;
	Иначе
		Перемещение = Ложь;
	КонецЕсли;
	
	ГруппаПомеченаНаУдаление = Элементы.ГруппыПользователей.ДанныеСтроки(Строка).ПометкаУдаления;
	КоличествоПользователей = ПараметрыПеретаскивания.Значение.Количество();
	
	ДействиеИсключитьПользователя = (ХранимыеПараметры.ГруппаВсеПользователи = Строка);
	
	ДействиеСПользователем = ?((ХранимыеПараметры.ГруппаВсеПользователи = Элементы.ГруппыПользователей.ТекущаяСтрока),
		НСтр("ru = 'Включить'"),
		?(Перемещение, НСтр("ru = 'Переместить'"), НСтр("ru = 'Скопировать'")));
	
	Если ГруппаПомеченаНаУдаление Тогда
		ШаблонДействия = ?(Перемещение, НСтр("ru = 'Группа ""%1"" помечена на удаление. %2'"), 
			НСтр("ru = 'Группа ""%1"" помечена на удаление. %2'"));
		ДействиеСПользователем = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонДействия, Строка(Строка), ДействиеСПользователем);
	КонецЕсли;
	
	Если КоличествоПользователей = 1 Тогда
		
		Если ДействиеИсключитьПользователя Тогда
			ШаблонВопроса = НСтр("ru = 'Исключить пользователя ""%2"" из группы ""%4""?'");
		ИначеЕсли Не ГруппаПомеченаНаУдаление Тогда
			ШаблонВопроса = НСтр("ru = '%1 пользователя ""%2"" в группу ""%3""?'");
		Иначе
			ШаблонВопроса = НСтр("ru = '%1 пользователя ""%2"" в эту группу?'");
		КонецЕсли;
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонВопроса, ДействиеСПользователем, Строка(ПараметрыПеретаскивания.Значение[0]),
			Строка(Строка), Строка(Элементы.ГруппыПользователей.ТекущаяСтрока));
		
	Иначе
		
		Если ДействиеИсключитьПользователя Тогда
			ШаблонВопроса = НСтр("ru = 'Исключить пользователей (%2) из группы ""%4""?'");
		ИначеЕсли Не ГруппаПомеченаНаУдаление Тогда
			ШаблонВопроса = НСтр("ru = '%1 пользователей (%2) в группу ""%3""?'");
		Иначе
			ШаблонВопроса = НСтр("ru = '%1 пользователей (%2) в эту группу?'");
		КонецЕсли;
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонВопроса, ДействиеСПользователем, КоличествоПользователей,
			Строка(Строка), Строка(Элементы.ГруппыПользователей.ТекущаяСтрока));
		
	КонецЕсли;
	
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СообщениеПользователю = ПеремещениеПользователяВНовуюГруппу(
		ПараметрыПеретаскивания.Значение, Строка, Перемещение);
	
	Если СообщениеПользователю.Сообщение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СообщениеПользователю.ЕстьОшибки = Ложь Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Перемещение пользователей'"), , СообщениеПользователю.Сообщение, БиблиотекаКартинок.Информация32);
	Иначе
		Предупреждение(СообщениеПользователю.Сообщение);
	КонецЕсли;
	
	Оповестить("Запись_ГруппыВнешнихПользователей");
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ПользователиСписок

&НаКлиенте
Процедура ПользователиСписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ХранимыеПараметры.РасширенныйПодбор Тогда
		ОповеститьОВыборе(Значение);
	Иначе
		
		ПолучитьКартинкиИЗаполнитьСписокВыбранных(Значение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ГруппаНовогоПользователя", Элементы.ГруппыПользователей.ТекущаяСтрока);
	
	Если Копирование
	   И Элемент.ТекущиеДанные <> Неопределено Тогда
		
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Пользователи.ФормаОбъекта", ПараметрыФормы, Элементы.ПользователиСписок);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиСписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокВыбранныхПользователейИГрупп

&НаКлиенте
Процедура СписокВыбранныхПользователейИГруппВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	УдалитьИзСпискаВыбранных();
	СписокВыбранныхПользователейИзменен = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьГруппуПользователей(Команда)
	
	Элементы.ГруппыПользователей.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныхПользователей(Команда)
	
	Элементы.ПоказыватьНедействительныхПользователей.Пометка =
		НЕ Элементы.ПоказыватьНедействительныхПользователей.Пометка;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ПользователиСписок, "Недействителен", Ложь, , ,
		НЕ Элементы.ПоказыватьНедействительныхПользователей.Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура НазначитьГруппы(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователи", Элементы.ПользователиСписок.ВыделенныеСтроки);
	ПараметрыФормы.Вставить("ВнешниеПользователи", Ложь);
	
	ОткрытьФорму("ОбщаяФорма.ГруппыПользователей", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьИЗакрыть(Команда)
	
	Если ХранимыеПараметры.РасширенныйПодбор Тогда
		МассивПользователей = РезультатВыбора();
		ОповеститьОВыборе(МассивПользователей);
		СписокВыбранныхПользователейИзменен = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователяКоманда(Команда)
	
	МассивПользователей = Элементы.ПользователиСписок.ВыделенныеСтроки;
	ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивПользователей);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыборПользователяИлиГруппы(Команда)
	
	УдалитьИзСпискаВыбранных();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСписокВыбранныхПользователейИГрупп(Команда)
	
	УдалитьИзСпискаВыбранных(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьГруппу(Команда)
	
	МассивГрупп = Элементы.ГруппыПользователей.ВыделенныеСтроки;
	ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивГрупп);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьХранимыеПараметры()
	
	ХранимыеПараметры = Новый Структура;
	ХранимыеПараметры.Вставить("ВыборГруппПользователей", Параметры.ВыборГруппПользователей);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыДинамическихСписков()
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ПользователиСписок,
		"ПустойУникальныйИдентификатор",
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
КонецПроцедуры

&НаСервере
Процедура ОформитьИСкрытьНедействительныхПользователей()
	
	// Оформление.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.НедоступныеДанныеЦвет.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ПользователиСписок.Недействителен");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("ПользователиСписок");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	// Скрытие.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ПользователиСписок, "Недействителен", Ложь, , , Истина);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПорядокГруппыВсеПользователи(Список)
	
	Перем Порядок;
	
	// Порядок.
	Если ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83БезРежимаСовместимости() Тогда
		Порядок = Список.КомпоновщикНастроек.Настройки.Порядок;
		Порядок.ИдентификаторПользовательскойНастройки = "ОсновнойПорядок";
	Иначе
		Порядок = Список.Порядок;
	КонецЕсли;
	
	Порядок.Элементы.Очистить();
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Предопределенный");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьИзСпискаВыбранных(УдалитьВсех = Ложь)
	
	Если УдалитьВсех Тогда
		ВыбранныеПользователиИГруппы.Очистить();
		ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
		Возврат;
	КонецЕсли;
	
	МассивЭлементовСписка = Элементы.СписокВыбранныхПользователейИГрупп.ВыделенныеСтроки;
	Для Каждого ЭлементСписка Из МассивЭлементовСписка Цикл
		ВыбранныеПользователиИГруппы.Удалить(ВыбранныеПользователиИГруппы.НайтиПоИдентификатору(ЭлементСписка));
	КонецЦикла;
	
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивВыбранныхЭлементов)
	
	ВыбранныеЭлементыИКартинки = Новый Массив;
	Для Каждого ВыбранныйЭлемент Из МассивВыбранныхЭлементов Цикл
		
		Если ТипЗнч(ВыбранныйЭлемент) = Тип("СправочникСсылка.Пользователи") Тогда
			НомерКартинки = Элементы.ПользователиСписок.ДанныеСтроки(ВыбранныйЭлемент).НомерКартинки;
		Иначе
			НомерКартинки = Элементы.ГруппыПользователей.ДанныеСтроки(ВыбранныйЭлемент).НомерКартинки;
		КонецЕсли;
		
		ВыбранныеЭлементыИКартинки.Добавить(
			Новый Структура("ВыбранныйЭлемент, НомерКартинки", ВыбранныйЭлемент, НомерКартинки));
	КонецЦикла;
	
	ЗаполнитьСписокВыбранныхПользователейИГрупп(ВыбранныеЭлементыИКартинки);
	
КонецПроцедуры

&НаСервере
Функция РезультатВыбора()
	
	ВыбранныеПользователиТаблицаЗначений = ВыбранныеПользователиИГруппы.Выгрузить( , "Пользователь");
	МассивПользователей = ВыбранныеПользователиТаблицаЗначений.ВыгрузитьКолонку("Пользователь");
	Возврат МассивПользователей;
	
КонецФункции

&НаСервере
Процедура ИзменитьПараметрыРасширеннойФормыПодбора()
	
	// Загрузка списка выбранных пользователей
	ПараметрыРасширеннойФормыПодбора = ПолучитьИзВременногоХранилища(Параметры.ПараметрыРасширеннойФормыПодбора);
	ВыбранныеПользователиИГруппы.Загрузить(ПараметрыРасширеннойФормыПодбора.ВыбранныеПользователи);
	Пользователи.ЗаполнитьНомераКартинокПользователей(ВыбранныеПользователиИГруппы, "Пользователь", "НомерКартинки");
	ХранимыеПараметры.Вставить("ЗаголовокФормыПодбора", ПараметрыРасширеннойФормыПодбора.ЗаголовокФормыПодбора);
	// Установка параметров расширенной формы подбора.
	Элементы.ЗавершитьИЗакрыть.Видимость                      = Истина;
	Элементы.ГруппаВыбратьПользователя.Видимость              = Истина;
	// Включение видимости списка выбранных пользователей.
	Элементы.ВыбранныеПользователиИГруппы.Видимость     = Истина;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей") Тогда
		Элементы.ГруппыИПользователи.Группировка                 = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		Элементы.ГруппыИПользователи.ШиринаПодчиненныхЭлементов  = ШиринаПодчиненныхЭлементовФормы.Одинаковая;
		ЭтаФорма.Высота                                          = 25;
		Элементы.ГруппаВыбратьГруппу.Видимость                   = Истина;
		// Включение отображения заголовков списков ПользователиСписок и ГруппыПользователей.
		Элементы.ГруппыПользователей.ПоложениеЗаголовка          = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ПользователиСписок.ПоложениеЗаголовка           = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ПользователиСписок.Заголовок                    = НСтр("ru = 'Пользователи в группе'");
		Если ПараметрыРасширеннойФормыПодбора.Свойство("ПодборГруппНевозможен") Тогда
			Элементы.ВыбратьГруппу.Видимость                     = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ОтменитьВыборПользователя.Видимость             = Истина;
		Элементы.ОчиститьСписокВыбранных.Видимость               = Истина;
	КонецЕсли;
	
	// Добавление количества выбранных пользователей в заголовке выбранных пользователей и групп.
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп()
	
	Если ХранимыеПараметры.ИспользоватьГруппы Тогда
		ЗаголовокВыбранныеПользователиИГруппы = НСтр("ru = 'Выбранные пользователи и группы (%1)'");
	Иначе
		ЗаголовокВыбранныеПользователиИГруппы = НСтр("ru = 'Выбранные пользователи (%1)'");
	КонецЕсли;
	
	КоличествоПользователей = ВыбранныеПользователиИГруппы.Количество();
	Если КоличествоПользователей <> 0 Тогда
		Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ЗаголовокВыбранныеПользователиИГруппы, КоличествоПользователей);
	Иначе
		
		Если ХранимыеПараметры.ИспользоватьГруппы Тогда
			Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = НСтр("ru = 'Выбранные пользователи и группы'");
		Иначе
			Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = НСтр("ru = 'Выбранные пользователи'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбранныхПользователейИГрупп(ВыбранныеЭлементыИКартинки)
	
	Для Каждого СтрокаМассива Из ВыбранныеЭлементыИКартинки Цикл
		
		ВыбранныйПользовательИлиГруппа = СтрокаМассива.ВыбранныйЭлемент;
		НомерКартинки = СтрокаМассива.НомерКартинки;
		
		ПараметрыОтбора = Новый Структура("Пользователь", ВыбранныйПользовательИлиГруппа);
		Найденный = ВыбранныеПользователиИГруппы.НайтиСтроки(ПараметрыОтбора);
		Если Найденный.Количество() = 0 Тогда
			
			СтрокаВыбранныеПользователи = ВыбранныеПользователиИГруппы.Добавить();
			СтрокаВыбранныеПользователи.Пользователь = ВыбранныйПользовательИлиГруппа;
			СтрокаВыбранныеПользователи.НомерКартинки = НомерКартинки;
			СписокВыбранныхПользователейИзменен = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ВыбранныеПользователиИГруппы.Сортировать("Пользователь Возр");
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИспользованияГруппПользователей()
	
	НастроитьФормуПоИспользованиюГруппПользователей();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоИспользованиюГруппПользователей()
	
	Если ХранимыеПараметры.Свойство("ТекущаяСтрока") Тогда
		
		Если ТипЗнч(ХранимыеПараметры.ТекущаяСтрока) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
			
			Если ХранимыеПараметры.ИспользоватьГруппы Тогда
				Элементы.ГруппыПользователей.ТекущаяСтрока = ХранимыеПараметры.ТекущаяСтрока;
			Иначе
				Параметры.ТекущаяСтрока = Неопределено;
			КонецЕсли;
		Иначе
			ТекущийЭлемент = Элементы.ПользователиСписок;
			Элементы.ГруппыПользователей.ТекущаяСтрока = Справочники.ГруппыПользователей.ВсеПользователи;
		КонецЕсли;
	Иначе
		Если НЕ ХранимыеПараметры.ИспользоватьГруппы
		   И Элементы.ГруппыПользователей.ТекущаяСтрока
		     <> Справочники.ГруппыПользователей.ВсеПользователи Тогда
			
			Элементы.ГруппыПользователей.ТекущаяСтрока = Справочники.ГруппыПользователей.ВсеПользователи;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаПоказыватьПользователейДочернихГрупп.Видимость = ХранимыеПараметры.ИспользоватьГруппы;
	
	Если ХранимыеПараметры.РасширенныйПодбор Тогда
		Элементы.НазначитьГруппы.Видимость = Ложь;
	Иначе
		Элементы.НазначитьГруппы.Видимость = ХранимыеПараметры.ИспользоватьГруппы;
	КонецЕсли;
	
	Элементы.СоздатьГруппуПользователей.Видимость =
		ПравоДоступа("Добавление", Метаданные.Справочники.ГруппыПользователей)
		И ХранимыеПараметры.ИспользоватьГруппы;
	
	ВыборГруппПользователей = ХранимыеПараметры.ВыборГруппПользователей
	                        И ХранимыеПараметры.ИспользоватьГруппы
	                        И Параметры.РежимВыбора;
	
	Если Параметры.РежимВыбора Тогда
		
		Элементы.ВыбратьГруппуПользователей.Видимость  = 
			?(ХранимыеПараметры.РасширенныйПодбор, Ложь, ВыборГруппПользователей);
		Элементы.ВыбратьПользователя.КнопкаПоУмолчанию =
			?(ХранимыеПараметры.РасширенныйПодбор, Ложь, Не ВыборГруппПользователей);
		Элементы.ВыбратьПользователя.Видимость         = Не ХранимыеПараметры.РасширенныйПодбор;
		АвтоЗаголовок = Ложь;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			
			Если ВыборГруппПользователей Тогда
				
				Если ХранимыеПараметры.РасширенныйПодбор Тогда
					Заголовок = ХранимыеПараметры.ЗаголовокФормыПодбора;
				Иначе
					Заголовок = НСтр("ru = 'Подбор пользователей и групп'");
				КонецЕсли;
				
				Элементы.ВыбратьПользователя.Заголовок =
					НСтр("ru = 'Выбрать пользователей'");
				
				Элементы.ВыбратьГруппуПользователей.Заголовок =
					НСтр("ru = 'Выбрать группы'");
			Иначе
				
				Если ХранимыеПараметры.РасширенныйПодбор Тогда
					Заголовок = ХранимыеПараметры.ЗаголовокФормыПодбора;
				Иначе
					Заголовок = НСтр("ru = 'Подбор пользователей'");
				КонецЕсли;
				
			КонецЕсли;
		Иначе
			// Режим выбора.
			Если ВыборГруппПользователей Тогда
				
				Заголовок = НСтр("ru = 'Выбор пользователя или группы'");
				
				Элементы.ВыбратьПользователя.Заголовок = НСтр("ru = 'Выбрать пользователя'");
			Иначе
				Заголовок = НСтр("ru = 'Выбор пользователя'");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПослеАктивизацииСтроки()
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция ПеремещениеПользователяВНовуюГруппу(МассивПользователей, НоваяГруппаВладелец, Перемещение)
	
	Если НоваяГруппаВладелец = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекущаяГруппаВладелец = Элементы.ГруппыПользователей.ТекущаяСтрока;
	СообщениеПользователю = ПользователиСлужебный.ПеремещениеПользователяВНовуюГруппу(
		МассивПользователей, ТекущаяГруппаВладелец, НоваяГруппаВладелец, Перемещение);
	
	Элементы.ПользователиСписок.Обновить();
	Элементы.ГруппыПользователей.Обновить();
	
	Возврат СообщениеПользователю;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСодержимоеФормыПриИзмененииГруппы(Форма)
	
	Элементы = Форма.Элементы;
	
	Если НЕ Форма.ХранимыеПараметры.ИспользоватьГруппы
	 ИЛИ Элементы.ГруппыПользователей.ТекущаяСтрока = ПредопределенноеЗначение(
	         "Справочник.ГруппыПользователей.ВсеПользователи") Тогда
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(
			Форма.ПользователиСписок, "ВыбиратьИерархически", Истина);
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(
			Форма.ПользователиСписок, "ГруппаПользователей", ПредопределенноеЗначение(
				"Справочник.ГруппыПользователей.ВсеПользователи"));
	Иначе
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(
			Форма.ПользователиСписок, "ВыбиратьИерархически", Форма.ВыбиратьИерархически);
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(
			Форма.ПользователиСписок,
			"ГруппаПользователей",
			Элементы.ГруппыПользователей.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначениеПараметраКомпоновкиДанных(Знач ВладелецПараметров,
                                                    Знач ИмяПараметра,
                                                    Знач ЗначениеПараметра)
	
	Для каждого Параметр Из ВладелецПараметров.Параметры.Элементы Цикл
		Если Строка(Параметр.Параметр) = ИмяПараметра Тогда
			
			Если Параметр.Использование
			   И Параметр.Значение = ЗначениеПараметра Тогда
				Возврат;
			КонецЕсли;
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	
	ВладелецПараметров.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры



