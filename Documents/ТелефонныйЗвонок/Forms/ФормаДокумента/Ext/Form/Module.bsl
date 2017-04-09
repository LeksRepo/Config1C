﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Взаимодействия.УстановитьПредметПоДаннымЗаполнения(Параметры,Предмет);
	КонецЕсли;
	Взаимодействия.ЗаполнитьСписокВыбораДляРассмотретьПосле(Элементы.РассмотретьПосле.СписокВыбора);
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Входящий = НЕ (Параметры.Свойство("Основание") И 
		НЕ (Параметры.Основание = Ложь ИЛИ
		Параметры.Основание = Неопределено));
	КонецЕсли;
	
	//Определим типы контактов, которые можно создать
	СписокИнтерактивноСоздаваемыхКонтактов = Взаимодействия.СоздатьСписокЗначенийИнтерактивноСоздаваемыхКонтактов();
	Элементы.СоздатьКонтакт.Видимость      = СписокИнтерактивноСоздаваемыхКонтактов.Количество() > 0;

	// подготовить оповещения взаимодействий
	Взаимодействия.ПодготовитьОповещения(ЭтаФорма,Параметры);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, , "СтраницаДополнительныеРеквизиты");
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Параметры.Свойство("ДанныеУчастника") И Объект.АбонентКонтакт <> Параметры.ДанныеУчастника.Контакт Тогда
		ЗаполнитьНаОснованииУчастника(Параметры.ДанныеУчастника);
	КонецЕсли;
	
	ПриСозданииИПриЧтенииНаСервере();
	
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтаФорма, "ТелефонныйЗвонок");

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ПриСозданииИПриЧтенииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если Не ВебКлиент Тогда
		ПроверитьДоступностьСозданияКонтакта();
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, РежимЗаписи, РежимПроведения)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	Взаимодействия.ПередЗаписьюВзаимодействияИзФормы(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Взаимодействия.ПриЗаписиВзаимодействияИзФормы(ТекущийОбъект, Предмет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ВзаимодействияКлиент.ВзаимодействиеПредметПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи, "ТелефонныйЗвонок");
	ПроверитьДоступностьСозданияКонтакта();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ВзаимодействияКлиент.ОтработатьОповещение(ЭтаФорма,ИмяСобытия, Параметр, Источник);
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтаФорма, "ТелефонныйЗвонок");

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначения.ПолучитьКартинкуКомментария(Объект.Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура КонтактНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ВзаимодействияКлиент.ВыбратьКонтакт(Предмет, Объект.АбонентКакСвязаться,
			Объект.АбонентПредставление, Объект.АбонентКонтакт, Ложь, Ложь, Истина) Тогда
		ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект,ЭтаФорма,"ТелефонныйЗвонок");
		Модифицированность = Истина;
		ПроверитьДоступностьСозданияКонтакта();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеКонтактаПриИзменении(Элемент)
	
	ПроверитьДоступностьСозданияКонтакта();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактПриИзменении(Элемент)
	
	ВзаимодействияВызовСервера.ПолучитьПредставлениеИВсюКонтактнуюИнформациюКонтакта(Объект.АбонентКонтакт, Объект.АбонентПредставление, Объект.АбонентКакСвязаться);
	ПроверитьДоступностьСозданияКонтакта();
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект,ЭтаФорма,"ТелефонныйЗвонок");
	
КонецПроцедуры

&НаКлиенте
Процедура РассмотретьПослеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВзаимодействияКлиент.ОбработатьВыборВПолеРассмотретьПосле(Объект.РассмотретьПосле, 
		ВыбранноеЗначение, СтандартнаяОбработка, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура РассмотреноПриИзменении(Элемент)
	
	Элементы.РассмотретьПосле.Доступность = НЕ Объект.Рассмотрено;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьКонтактВыполнить()

	ВзаимодействияКлиент.СоздатьКонтакт(
		Объект.АбонентПредставление, Объект.АбонентКакСвязаться, Объект.Ссылка, СписокИнтерактивноСоздаваемыхКонтактов
	);

КонецПроцедуры

&НаКлиенте
Процедура СвязанныеВзаимодействияВыполнить()

	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Предмет", Объект.Предмет);

	ОткрытьФорму("ЖурналДокументов.Взаимодействия.ФормаСписка", ПараметрыОтбора, ЭтаФорма, , Окно);

КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьНаОснованииУчастника(ДанныеУчастника)
	
	Объект.АбонентКонтакт = ДанныеУчастника.Контакт;
	Если ПустаяСтрока(ДанныеУчастника.КакСвязаться) Тогда
		
		Объект.АбонентКакСвязаться = "";
		Взаимодействия.ДозаполнитьПоляКонтактов(Объект.АбонентКонтакт,
			Объект.АбонентПредставление,
			Объект.АбонентКакСвязаться,
			Перечисления.ТипыКонтактнойИнформации.Телефон);
		
	Иначе
		
		Объект.АбонентКакСвязаться = ДанныеУчастника.КакСвязаться;
		
		
	КонецЕсли;
	
	Объект.АбонентПредставление = ДанныеУчастника.Представление;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииИПриЧтенииНаСервере()
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Предмет = Взаимодействия.ПолучитьЗначениеПредмета(Объект.Ссылка);
	КонецЕсли;
	Элементы.РассмотретьПосле.Доступность = НЕ Объект.Рассмотрено;
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначения.ПолучитьКартинкуКомментария(Объект.Комментарий);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ПроверитьДоступностьСозданияКонтакта()
	
	Элементы.СоздатьКонтакт.Доступность = (НЕ Объект.Ссылка.Пустая()) И
		(Не ЗначениеЗаполнено(Объект.АбонентКонтакт)) И 
		(Не ПустаяСтрока(Объект.АбонентПредставление));
	
КонецПроцедуры
