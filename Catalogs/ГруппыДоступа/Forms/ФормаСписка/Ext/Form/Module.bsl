﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = "ВыборПодбор";
	КонецЕсли;
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	РодительПерсональныхГруппДоступа = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа(Истина);
	
	УпрощенныйИнтерфейсНастройкиПравДоступа = УправлениеДоступомПереопределяемый.УпрощенныйИнтерфейсНастройкиПравДоступа();
	
	Если УпрощенныйИнтерфейсНастройкиПравДоступа Тогда
		Элементы.ФормаСоздать.Видимость = Ложь;
		Элементы.ФормаСкопировать.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюСоздать.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюСкопировать.Видимость = Ложь;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Профиль", Параметры.Профиль);
	Если ЗначениеЗаполнено(Параметры.Профиль) Тогда
		Элементы.Профиль.Видимость = Ложь;
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		Автозаголовок = Ложь;
		
		Заголовок = НСтр("ru = 'Группы доступа'");
		
		Элементы.ФормаСоздатьГруппу.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюСоздатьГруппу.Видимость = Ложь;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.Справочники.ПрофилиГруппДоступа) Тогда
		Элементы.Профиль.Видимость = Ложь;
	КонецЕсли;
	
	Если ПравоДоступа("Просмотр", Метаданные.Справочники.ВнешниеПользователи) Тогда
		Список.ТекстЗапроса = СтрЗаменить(
			Список.ТекстЗапроса,
			"&ОшибкаОбъектНеНайден",
			"ЕстьNULL(ВЫРАЗИТЬ(ГруппыДоступа.Пользователь КАК Справочник.ВнешниеПользователи).Наименование, &ОшибкаОбъектНеНайден)");
	КонецЕсли;
	
	СписокНедоступныхГрупп = Новый СписокЗначений;
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда
		// Скрытие группы доступа Администраторы.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ссылка", Справочники.ГруппыДоступа.Администраторы,
			ВидСравненияКомпоновкиДанных.НеРавно, , Истина);
	КонецЕсли;
	
	РежимВыбора = Параметры.РежимВыбора;
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"ОшибкаОбъектНеНайден",
		НСтр("ru = '<Объект не найден>'"));
	
	Если Параметры.РежимВыбора Тогда
		
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		// Отбор не помеченных на удаление.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь, , , Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		
		Элементы.Список.РежимВыбора = Истина;
		Элементы.Список.ВыборГруппИЭлементов = Параметры.ВыборГруппИЭлементов;
		
		АвтоЗаголовок = Ложь;
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Элементы.Список.МножественныйВыбор = Истина;
			Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
			
			Заголовок = НСтр("ru = 'Подбор групп доступа'");
		Иначе
			Заголовок = НСтр("ru = 'Выбор группы доступа'");
			Элементы.ФормаВыбрать.КнопкаПоУмолчанию = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		ПереносДопустим = НЕ ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.Пользователь)
		                  И Элементы.Список.ТекущиеДанные.Ссылка <> РодительПерсональныхГруппДоступа;
		
		Если Элементы.Найти("ФормаПеренестиЭлемент") <> Неопределено Тогда
			Элементы.ФормаПеренестиЭлемент.Доступность = ПереносДопустим;
		КонецЕсли;
		
		Если Элементы.Найти("СписокКонтекстноеМенюПеренестиЭлемент") <> Неопределено Тогда
			Элементы.СписокКонтекстноеМенюПеренестиЭлемент.Доступность = ПереносДопустим;
		КонецЕсли;
		
		Если Элементы.Найти("СписокПеренестиЭлемент") <> Неопределено Тогда
			Элементы.СписокПеренестиЭлемент.Доступность = ПереносДопустим;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Значение = РодительПерсональныхГруппДоступа Тогда
		СтандартнаяОбработка = Ложь;
		Предупреждение(НСтр("ru = 'Эта группа только для персональных групп доступа.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Родитель = РодительПерсональныхГруппДоступа Тогда
		
		Если Группа Тогда
			Предупреждение(НСтр("ru = 'В этой группе не используются подгруппы.'"));
			
		ИначеЕсли УпрощенныйИнтерфейсНастройкиПравДоступа Тогда
			Предупреждение(НСтр("ru = 'Персональные группы доступа
			                          |создаются только в форме ""Права доступа"".'"));
		Иначе
			Предупреждение(НСтр("ru = 'Персональные группы доступа не используются.'"));
		КонецЕсли;
		
		Отказ = Истина;
		
	ИначеЕсли НЕ Группа
	        И УпрощенныйИнтерфейсНастройкиПравДоступа Тогда
		
		Предупреждение(НСтр("ru = 'Используются только персональные группы доступа,
		                          |которые создаются только в форме ""Права доступа"".'"));
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если Строка = РодительПерсональныхГруппДоступа Тогда
		СтандартнаяОбработка = Ложь;
		Предупреждение(НСтр("ru = 'Эта папка только для персональных групп доступа.'"));
		
	ИначеЕсли ПараметрыПеретаскивания.Значение = РодительПерсональныхГруппДоступа Тогда
		СтандартнаяОбработка = Ложь;
		Предупреждение(НСтр("ru = 'Папка персональных групп доступа не переносится.'"));
	КонецЕсли;
	
КонецПроцедуры
