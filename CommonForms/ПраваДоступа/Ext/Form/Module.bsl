﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Установка заголовка формы.
	Заголовок = НСтр("ru = 'Права доступа'");
	
	ПользовательИБПолноправный = Пользователи.ЭтоПолноправныйПользователь();
	СвойДоступ = Параметры.Пользователь = Пользователи.АвторизованныйПользователь();
	
	ПользовательИБОтветственный =
		НЕ ПользовательИБПолноправный
		И ПравоДоступа("Редактирование", Метаданные.Справочники.ГруппыДоступа);
	
	
	Элементы.ГруппыДоступаКонтекстноеМенюИзменитьГруппу.Видимость =
		ПользовательИБПолноправный
		ИЛИ ПользовательИБОтветственный;
	
	Элементы.ФормаОтчетПраваДоступа.Видимость =
		ПользовательИБПолноправный
		ИЛИ Параметры.Пользователь = Пользователи.ТекущийПользователь();
	
	// Настройка команд для неполноправного пользователя
	Элементы.ФормаВключитьВГруппу.Видимость   = ПользовательИБОтветственный;
	Элементы.ФормаИсключитьИзГруппы.Видимость = ПользовательИБОтветственный;
	Элементы.ФормаИзменитьГруппу.Видимость    = ПользовательИБОтветственный;
	
	// Настройка команд для полноправного пользователя
	Элементы.ГруппыДоступаВключитьВГруппу.Видимость   = ПользовательИБПолноправный;
	Элементы.ГруппыДоступаИсключитьИзГруппы.Видимость = ПользовательИБПолноправный;
	Элементы.ГруппыДоступаИзменитьГруппу.Видимость    = ПользовательИБПолноправный;
	
	// Настройка отображения закладок страниц
	Элементы.ГруппыДоступаИРоли.ОтображениеСтраниц =
		?(ПользовательИБПолноправный,
		  ОтображениеСтраницФормы.ЗакладкиСверху,
		  ОтображениеСтраницФормы.Нет);
	
	// Настройка отображения командной панели для полноправного пользователя
	Элементы.ГруппыДоступа.ПоложениеКоманднойПанели =
		?(ПользовательИБПолноправный,
		  ПоложениеКоманднойПанелиЭлементаФормы.Верх,
		  ПоложениеКоманднойПанелиЭлементаФормы.Нет);
	
	// Настройка отображения ролей для полноправного пользователя
	Элементы.ОтображениеРолей.Видимость = ПользовательИБПолноправный;
	
	Если ПользовательИБПолноправный
	 ИЛИ ПользовательИБОтветственный
	 ИЛИ СвойДоступ Тогда
		
		ВывестиГруппыДоступа();
	Иначе
		// Обычному пользователю запрещено просматривать любые настройки чужого доступа
		Элементы.ГруппыДоступаВключитьВГруппу.Видимость   = Ложь;
		Элементы.ГруппыДоступаИсключитьИзГруппы.Видимость = Ложь;
		
		Элементы.ГруппыДоступаИРоли.Видимость         = Ложь;
		Элементы.НедостаточноПравНаПросмотр.Видимость = Истина;
	КонецЕсли;
	
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриСозданииФормы");
	ОбработатьИнтерфейсРолей("УстановитьТолькоПросмотрРолей", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_ГруппыДоступа")
	 ИЛИ ВРег(ИмяСобытия) = ВРег("Запись_ПрофилиГруппДоступа")
	 ИЛИ ВРег(ИмяСобытия) = ВРег("Запись_ГруппыПользователей")
	 ИЛИ ВРег(ИмяСобытия) = ВРег("Запись_ГруппыВнешнихПользователей") Тогда
		
		ВывестиГруппыДоступа();
		ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриЗагрузкеНастроек", Настройки);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ГруппыДоступа

&НаКлиенте
Процедура ГруппыДоступаПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные   = Элементы.ГруппыДоступа.ТекущиеДанные;
	ТекущийРодитель = Элементы.ГруппыДоступа.ТекущийРодитель;
	
	Если ТекущиеДанные = Неопределено Тогда
		
		ГруппаДоступаИзменена = ЗначениеЗаполнено(ТекущаяГруппаДоступа);
		ТекущаяГруппаДоступа  = Неопределено;
	Иначе
		НоваяГруппаДоступа    = ?(ТекущийРодитель = Неопределено, ТекущиеДанные.ГруппаДоступа, ТекущийРодитель.ГруппаДоступа);
		ГруппаДоступаИзменена = ТекущаяГруппаДоступа <> НоваяГруппаДоступа;
		ТекущаяГруппаДоступа  = НоваяГруппаДоступа;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыДоступаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ГруппыДоступа.НайтиПоИдентификатору(ВыбраннаяСтрока) <> Неопределено Тогда
		
		Если Элементы.ФормаИзменитьГруппу.Видимость
		 ИЛИ Элементы.ГруппыДоступаИзменитьГруппу.Видимость Тогда
			
			ИзменитьГруппу(Элементы.ФормаИзменитьГруппу);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВключитьВГруппу(Команда)
	
	ПараметрыФормы = Новый Структура;
	Выбранные = Новый Массив;
	
	Для каждого ОписаниеГруппыДоступа Из ГруппыДоступа Цикл
		Выбранные.Добавить(ОписаниеГруппыДоступа.ГруппаДоступа);
	КонецЦикла;
	
	ПараметрыФормы.Вставить("Выбранные",         Выбранные);
	ПараметрыФормы.Вставить("ПользовательГрупп", Параметры.Пользователь);
	
	НоваяГруппаДоступаПользователя = ОткрытьФормуМодально(
		"Справочник.ГруппыДоступа.Форма.ВыборПоОтветственному", ПараметрыФормы);
	
	Если ТипЗнч(НоваяГруппаДоступаПользователя) = Тип("СправочникСсылка.ГруппыДоступа")
	   И ЗначениеЗаполнено(НоваяГруппаДоступаПользователя) Тогда
		
		ОписаниеОшибки = "";
		ИзменитьСоставГруппы(НоваяГруппаДоступаПользователя, Истина, ОписаниеОшибки);
		Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
			
			Предупреждение(ОписаниеОшибки);
		Иначе
			ОповеститьОбИзменении(НоваяГруппаДоступаПользователя);
			Оповестить("Запись_ГруппыДоступа", Новый Структура, НоваяГруппаДоступаПользователя);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьИзГруппы(Команда)
	
	Если НЕ ЗначениеЗаполнено(ТекущаяГруппаДоступа) Тогда
		Предупреждение(НСтр("ru = 'Группа доступа не выбрана.'"));
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	ИзменитьСоставГруппы(ТекущаяГруппаДоступа, Ложь, ОписаниеОшибки);
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		
		Предупреждение(ОписаниеОшибки);
	Иначе
		ОповеститьОбИзменении(ТекущаяГруппаДоступа);
		Оповестить("Запись_ГруппыДоступа", Новый Структура, ТекущаяГруппаДоступа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьГруппу(Команда)
	
	ПараметрыФормы = Новый Структура;
	
	Если НЕ ЗначениеЗаполнено(ТекущаяГруппаДоступа) Тогда
		Предупреждение(НСтр("ru = 'Группа доступа не выбрана.'"));
		Возврат;
		
	ИначеЕсли ПользовательИБПолноправный
	      ИЛИ ПользовательИБОтветственный
	          И РазрешеноИзменениеСоставаПользователейГруппы(ТекущаяГруппаДоступа) Тогда
		
		ПараметрыФормы.Вставить("Ключ", ТекущаяГруппаДоступа);
		ОткрытьФорму("Справочник.ГруппыДоступа.ФормаОбъекта", ПараметрыФормы);
	Иначе
		Предупреждение(НСтр("ru = 'Невозможно изменить группу доступа,
		                          |так как текущий пользователь
		                          |не ответственный за участников группы доступа и
		                          |не полноправный администратор.'"));
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ВывестиГруппыДоступа();
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПоПравамДоступа(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователь", Параметры.Пользователь);
	
	ОткрытьФорму("Отчет.ПраваДоступа.Форма", ПараметрыФормы);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаКлиенте
Процедура ГруппировкаРолейПоПодсистемам(Команда)
	
	ОбработатьИнтерфейсРолей("ГруппировкаПоПодсистемам");
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ВывестиГруппыДоступа()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Если ПользовательИБПолноправный ИЛИ СвойДоступ Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ГруппыДоступа.Ссылка
	|ПОМЕСТИТЬ РазрешенныеГруппыДоступа
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа";
	Запрос.Выполнить();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РазрешенныеГруппыДоступа.Ссылка
	|ИЗ
	|	РазрешенныеГруппыДоступа КАК РазрешенныеГруппыДоступа
	|ГДЕ
	|	(НЕ РазрешенныеГруппыДоступа.Ссылка.ПометкаУдаления)
	|	И (НЕ РазрешенныеГруппыДоступа.Ссылка.Профиль.ПометкаУдаления)";
	РазрешенныеГруппыДоступа = Запрос.Выполнить().Выгрузить();
	РазрешенныеГруппыДоступа.Индексы.Добавить("Ссылка");
	
	Запрос.УстановитьПараметр("Пользователь", Параметры.Пользователь);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка КАК ГруппаДоступа,
	|	ГруппыДоступа.Ссылка.Наименование КАК Наименование,
	|	ГруппыДоступа.Ссылка.Профиль.Наименование КАК ПрофильНаименование,
	|	ГруппыДоступа.Ссылка.Описание КАК Описание,
	|	ГруппыДоступа.Ссылка.Ответственный КАК Ответственный
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ГруппыДоступа.Ссылка КАК Ссылка
	|	ИЗ
	|		Справочник.ГруппыДоступа КАК ГруппыДоступа
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ПользователиГруппДоступа
	|			ПО (ПользователиГруппДоступа.Пользователь В
	|					(ВЫБРАТЬ
	|						&Пользователь
	|				
	|					ОБЪЕДИНИТЬ ВСЕ
	|				
	|					ВЫБРАТЬ
	|						СоставыГруппПользователей.ГруппаПользователей
	|					ИЗ
	|						РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|					ГДЕ
	|						СоставыГруппПользователей.Пользователь = &Пользователь))
	|				И ГруппыДоступа.Ссылка = ПользователиГруппДоступа.Ссылка
	|				И (НЕ ГруппыДоступа.ПометкаУдаления)
	|				И (НЕ ГруппыДоступа.Профиль.ПометкаУдаления)) КАК ГруппыДоступа
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГруппыДоступа.Ссылка.Наименование";
	
	ВсеГруппыДоступа = Запрос.Выполнить().Выгрузить();
	
	// Установка представления для группы доступа.
	// Удаление текущего пользователя из группы доступа, если он входит в нее только непосредственно.
	ЕстьЗапрещенныеГруппы = Ложь;
	Индекс = ВсеГруппыДоступа.Количество()-1;
	
	Пока Индекс >= 0 Цикл
		Строка = ВсеГруппыДоступа[Индекс];
		
		Если РазрешенныеГруппыДоступа.Найти(Строка.ГруппаДоступа, "Ссылка") = Неопределено Тогда
			ВсеГруппыДоступа.Удалить(Индекс);
			ЕстьЗапрещенныеГруппы = Истина;
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ВсеГруппыДоступа, "ГруппыДоступа");
	Элементы.ПредупреждениеЕстьСкрытыеГруппыДоступа.Видимость = ЕстьЗапрещенныеГруппы;
	
	Если НЕ ЗначениеЗаполнено(ТекущаяГруппаДоступа) Тогда
		
		Если ГруппыДоступа.Количество() > 0 Тогда
			ТекущаяГруппаДоступа = ГруппыДоступа[0].ГруппаДоступа;
		КонецЕсли;
	КонецЕсли;
	
	Для каждого ОписаниеГруппыДоступа Из ГруппыДоступа Цикл
		
		Если ОписаниеГруппыДоступа.ГруппаДоступа = ТекущаяГруппаДоступа Тогда
			Элементы.ГруппыДоступа.ТекущаяСтрока = ОписаниеГруппыДоступа.ПолучитьИдентификатор();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПользовательИБПолноправный Тогда
		ЗаполнитьРоли();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьСоставГруппы(Знач ГруппаДоступа, Знач Добавить, ОписаниеОшибки = "")
	
	Если НЕ РазрешеноИзменениеСоставаПользователейГруппы(ГруппаДоступа) Тогда
		Если Добавить Тогда
			ОписаниеОшибки = НСтр("ru = 'Невозможно включить пользователя в группу доступа,
			                            |так как текущий пользователь
			                            |не ответственный за участников группы доступа и
			                            |не полноправный администратор.'");
		Иначе
			ОписаниеОшибки = НСтр("ru = 'Невозможно исключить пользователя из группы доступа,
			                            |так как текущий пользователь
			                            |не ответственный за участников группы доступа и
			                            |не полноправный администратор.'");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если НЕ Добавить И НЕ ПользовательВключенВГруппуДоступа(ТекущаяГруппаДоступа) Тогда
		ОписаниеОшибки =  НСтр("ru = 'Невозможно исключить пользователя из группы доступа,
		                             |так как он включен в нее косвенно.'");
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ГруппаДоступаОбъект = ГруппаДоступа.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ГруппаДоступаОбъект.Ссылка, ГруппаДоступаОбъект.ВерсияДанных);
	Если Добавить Тогда
		Если ГруппаДоступаОбъект.Пользователи.Найти(Параметры.Пользователь, "Пользователь") = Неопределено Тогда
			ГруппаДоступаОбъект.Пользователи.Добавить().Пользователь = Параметры.Пользователь;
		КонецЕсли;
	Иначе
		СтрокаТЧ = ГруппаДоступаОбъект.Пользователи.Найти(Параметры.Пользователь, "Пользователь");
		Если СтрокаТЧ <> Неопределено Тогда
			ГруппаДоступаОбъект.Пользователи.Удалить(СтрокаТЧ);
		КонецЕсли;
	КонецЕсли;
	
	Если ГруппаДоступаОбъект.Ссылка = Справочники.ГруппыДоступа.Администраторы Тогда
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Изменение состава администраторов выполняется
			           |непосредственно в группе доступа %1.'"),
			ГруппаДоступаОбъект.Наименование);
	Иначе
		ГруппаДоступаОбъект.Записать();
	КонецЕсли;
	
	РазблокироватьДанныеДляРедактирования(ГруппаДоступаОбъект.Ссылка);
	
	ТекущаяГруппаДоступа = ГруппаДоступаОбъект.Ссылка;
	
КонецПроцедуры

&НаСервере
Функция РазрешеноИзменениеСоставаПользователейГруппы(ГруппаДоступа)
	
	Если ПользовательИБПолноправный Тогда
		Возврат Истина;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГруппаДоступа",              ГруппаДоступа);
	Запрос.УстановитьПараметр("АвторизованныйПользователь", Пользователи.АвторизованныйПользователь());
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|		ПО (СоставыГруппПользователей.Пользователь = &АвторизованныйПользователь)
	|			И (СоставыГруппПользователей.ГруппаПользователей = ГруппыДоступа.Ответственный)
	|			И (ГруппыДоступа.Ссылка = &ГруппаДоступа)";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Функция ПользовательВключенВГруппуДоступа(ГруппаДоступа)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГруппаДоступа", ГруппаДоступа);
	Запрос.УстановитьПараметр("Пользователь", Параметры.Пользователь);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|ГДЕ
	|	ГруппыДоступаПользователи.Ссылка = &ГруппаДоступа
	|	И ГруппыДоступаПользователи.Пользователь = &Пользователь";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции


&НаСервере
Процедура ЗаполнитьРоли()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Параметры.Пользователь);
	
	Если ТипЗнч(Параметры.Пользователь) = Тип("СправочникСсылка.Пользователи")
	 ИЛИ ТипЗнч(Параметры.Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ 
		|	Роли.Роль.Имя КАК Роль
		|ИЗ
		|	Справочник.ПрофилиГруппДоступа.Роли КАК Роли
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|			ПО (СоставыГруппПользователей.Пользователь = &Пользователь)
		|				И (СоставыГруппПользователей.ГруппаПользователей = ГруппыДоступаПользователи.Пользователь)
		|				И (НЕ ГруппыДоступаПользователи.Ссылка.ПометкаУдаления)
		|		ПО Роли.Ссылка = ГруппыДоступаПользователи.Ссылка.Профиль
		|			И (НЕ Роли.Ссылка.ПометкаУдаления)";
	Иначе
		// Группа пользователей или Группа внешних пользователей.
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Роли.Роль.Имя КАК Роль
		|ИЗ
		|	Справочник.ПрофилиГруппДоступа.Роли КАК Роли
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|		ПО (ГруппыДоступаПользователи.Пользователь = &Пользователь)
		|			И (НЕ ГруппыДоступаПользователи.Ссылка.ПометкаУдаления)
		|			И Роли.Ссылка = ГруппыДоступаПользователи.Ссылка.Профиль
		|			И (НЕ Роли.Ссылка.ПометкаУдаления)";
	КонецЕсли;
	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(), "ПрочитанныеРоли");
	
	Отбор = Новый Структура("Роль", "ПолныеПрава");
	Если ПрочитанныеРоли.НайтиСтроки(Отбор).Количество() > 0 Тогда
		
		Отбор = Новый Структура("Роль", "АдминистраторСистемы");
		Если ПрочитанныеРоли.НайтиСтроки(Отбор).Количество() > 0 Тогда
			
			ПрочитанныеРоли.Очистить();
			ПрочитанныеРоли.Добавить().Роль = "ПолныеПрава";
			ПрочитанныеРоли.Добавить().Роль = "АдминистраторСистемы";
		Иначе
			ПрочитанныеРоли.Очистить();
			ПрочитанныеРоли.Добавить().Роль = "ПолныеПрава";
		КонецЕсли;
	КонецЕсли;
	
	ОбработатьИнтерфейсРолей("ОбновитьДеревоРолей");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаСервере
Процедура ОбработатьИнтерфейсРолей(Действие, ОсновнойПараметр = Неопределено)
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("ОсновнойПараметр", ОсновнойПараметр);
	ПараметрыДействия.Вставить("Форма",            ЭтаФорма);
	ПараметрыДействия.Вставить("КоллекцияРолей",   ПрочитанныеРоли);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ПараметрыДействия.Вставить("ТипПользователей",
			Перечисления.ТипыПользователей.ПользовательОбластиДанных);
	Иначе
		ПараметрыДействия.Вставить("ТипПользователей",
			Перечисления.ТипыПользователей.ПользовательЛокальногоРешения);
	КонецЕсли;
	
	ПользователиСлужебный.ОбработатьИнтерфейсРолей(Действие, ПараметрыДействия);
	
КонецПроцедуры
