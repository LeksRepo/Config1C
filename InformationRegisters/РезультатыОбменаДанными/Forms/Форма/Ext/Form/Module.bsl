﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнформационнаяБаза = Параметры.УзелИнформационнойБазы;
	
	Если ЗначениеЗаполнено(Параметры.ОткрываемаяСтраница) Тогда
		
		Элементы.РезультатыОбменаДанными.ТекущаяСтраница = Элементы.РезультатыОбменаДанными.ПодчиненныеЭлементы[Параметры.ОткрываемаяСтраница];
		
	КонецЕсли;
	
	ИспользуетсяГрупповоеИзменение = Ложь;
	СтандартныеПодсистемыПереопределяемый.ИспользуетсяГрупповоеИзменениеОбъектов(ИспользуетсяГрупповоеИзменение);
	
	Если Не ИспользуетсяГрупповоеИзменение Тогда
		
		Элементы.НепроведенныеДокументыИзменитьВыделенныеДокументы.Видимость = Ложь;
		Элементы.НезаполненныеРеквизитыИзменитьВыделенныеОбъекты.Видимость = Ложь;
		
	КонецЕсли;
	
	ИспользуетсяДатыЗапретаИзменения = Ложь;
	СтандартныеПодсистемыПереопределяемый.ИспользуетсяДатыЗапретаИзменения(ИспользуетсяДатыЗапретаИзменения);
	
	СтандартныеПодсистемыПереопределяемый.ИспользуетсяВерсионирование(ИспользуетсяВерсионирование);
	
	Если Не ИспользуетсяВерсионирование Тогда
		
		Коллизии.ТекстЗапроса = "";
		НепринятыеПоДате.ТекстЗапроса = "";
		Элементы.СтраницаКоллизии.Видимость = Ложь;
		Элементы.СтраницаНепринятыеПоДатеЗапрета.Видимость = Ложь;
		
	ИначеЕсли Не ИспользуетсяДатыЗапретаИзменения Тогда
		
		НепринятыеПоДате.ТекстЗапроса = "";
		Элементы.СтраницаНепринятыеПоДатеЗапрета.Видимость = Ложь;
		
	КонецЕсли;
	
	ЗаполнитьСписокУзлов();
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Оповестить("ЗакрытаФормаРезультатовОбменаДанными");
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбновитьОтборПоПериоду(Ложь);
	ОбновитьОтборПоУзлу(Ложь);
	ОбновитьОтборПоПричине(Ложь);
	ПоказатьПроигнорированные(Ложь);
	ОбновитьНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ОбновитьОтборПоПричине();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ОбновитьОтборПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура УзелИнформационнойБазыОчистка(Элемент, СтандартнаяОбработка)
	
	УзелИнформационнойБазы = Неопределено;
	ОбновитьОтборПоУзлу();
	
КонецПроцедуры

&НаКлиенте
Процедура УзелИнформационнойБазыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Не Элементы.УзелИнформационнойБазы.РежимВыбораИзСписка Тогда
		
		СтандартнаяОбработка = Ложь;
		
		УзелИнформационнойБазы = ОткрытьФормуМодально("ОбщаяФорма.ВыборУзловПлановОбмена");
		
		ОбновитьОтборПоУзлу();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УзелИнформационнойБазыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УзелИнформационнойБазы = ВыбранноеЗначение;
	
	ОбновитьОтборПоУзлу();
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатыОбменаДаннымиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если Элемент.ПодчиненныеЭлементы.СтраницаКоллизии = ТекущаяСтраница Тогда
		Элементы.СтрокаПоиска.Доступность = Ложь;
	Иначе
		Элементы.СтрокаПоиска.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ НепроведенныеДокументы

&НаКлиенте
Процедура НепроведенныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьОбъект(Элементы.НепроведенныеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура НепроведенныеДокументыПередНачаломИзменения(Элемент, Отказ)
	
	ИзменениеОбъекта();
	Отказ = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ НезаполненныеРеквизиты

&НаКлиенте
Процедура НезаполненныеРеквизитыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьОбъект(Элементы.НезаполненныеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура НезаполненныеРеквизитыПередНачаломИзменения(Элемент, Отказ)
	
	ИзменениеОбъекта();
	Отказ = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Коллизии

&НаКлиенте
Процедура КоллизииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Коллизии.ТекущиеДанные;
	
	Если Поле.Родитель.Имя = "КоллизииГруппаВерсияЭтойПрограммы" Тогда
		
		ОткрытьОбъектИлиВерсию(Элементы.Коллизии, ТекущиеДанные.ЭтаВерсияПринята, ТекущиеДанные.НомерЭтойВерсии);
		
	ИначеЕсли Поле.Родитель.Имя = "КоллизииГруппаВерсияДругойПрограммы" Тогда
		
		ОткрытьОбъектИлиВерсию(Элементы.Коллизии, ТекущиеДанные.ДругаяВерсияПринята, ТекущиеДанные.НомерДругойВерсии);
		
	Иначе
		
		ОткрытьОбъект(Элементы.Коллизии);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбъектИлиВерсию(Элемент, ВерсияПринята, Версия)
	
	Если ВерсияПринята Тогда
		
		ОткрытьОбъект(Элемент);
		
	Иначе
		
		ОткрытьВерсиюНаКлиенте(Элемент.ТекущиеДанные, Версия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КоллизииПередНачаломИзменения(Элемент, Отказ)
	
	ИзменениеОбъекта();
	Отказ = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ НепринятыеПоДате

&НаКлиенте
Процедура НепринятыеПоДатеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.НепринятыеПоДате.ТекущиеДанные;
	
	Если Поле.Родитель.Имя = "НепринятыеПоДатеГруппаНепринятаяВерсия" Тогда
		
		ОткрытьВерсиюНаКлиенте(ТекущиеДанные, ТекущиеДанные.НомерДругойВерсии);
		
	Иначе
		
		ОткрытьОбъект(Элементы.НепринятыеПоДате);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НепринятыеПоДатеПередНачаломИзменения(Элемент, Отказ)
	
	ИзменениеОбъекта();
	Отказ = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Изменить(Команда)
	
	ИзменениеОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ИгнорироватьДокумент(Команда)
	
	Игнорировать(Элементы.НепроведенныеДокументы.ВыделенныеСтроки, Истина, "НепроведенныеДокументы");
	
КонецПроцедуры

&НаКлиенте
Процедура НеИгнорироватьДокумент(Команда)
	
	Игнорировать(Элементы.НепроведенныеДокументы.ВыделенныеСтроки, Ложь, "НепроведенныеДокументы");
	
КонецПроцедуры

&НаКлиенте
Процедура НеИгнорироватьОбъект(Команда)
	
	Игнорировать(Элементы.НезаполненныеРеквизиты.ВыделенныеСтроки, Ложь, "НезаполненныеРеквизиты");
	
КонецПроцедуры

&НаКлиенте
Процедура ИгнорироватьОбъект(Команда)
	
	Игнорировать(Элементы.НезаполненныеРеквизиты.ВыделенныеСтроки, Истина, "НезаполненныеРеквизиты");
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенныеДокументы(Команда)
	
	СтандартныеПодсистемыКлиентПереопределяемый.ПриИзмененииВыделенныхОбъектов(Элементы.НепроведенныеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОчиститьСообщения();
	ПровестиДокументы(Элементы.НепроведенныеДокументы.ВыделенныеСтроки);
	ОбновитьНаСервере("НепроведенныеДокументы");
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенныеОбъекты(Команда)
	
	СтандартныеПодсистемыКлиентПереопределяемый.ПриИзмененииВыделенныхОбъектов(Элементы.НезаполненныеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтличияНепринятые(Команда)
	
	ПоказатьОтличия(Элементы.НепринятыеПоДате);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюНепринятые(Команда)
	
	Если Элементы.НепринятыеПоДате.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СравниваемыеВерсии = Новый Массив;
	СравниваемыеВерсии.Добавить(Элементы.НепринятыеПоДате.ТекущиеДанные.НомерДругойВерсии);
	СтандартныеПодсистемыКлиентПереопределяемый.ПриОткрытииФормыОтчетаПоВерсии(Элементы.НепринятыеПоДате.ТекущиеДанные.Ссылка, СравниваемыеВерсии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюКоллизии(Команда)
	
	ТекущиеДанные = Элементы.Коллизии.ТекущиеДанные;
	
	Если ТекущиеДанные.ЭтаВерсияПринята Тогда
		Версия = ТекущиеДанные.НомерДругойВерсии;
	Иначе
		Версия = ТекущиеДанные.НомерЭтойВерсии;
	КонецЕсли;
	
	ОткрытьВерсиюНаКлиенте(Элементы.Коллизии.ТекущиеДанные, Версия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтличияКоллизии(Команда)
	
	ПоказатьОтличия(Элементы.Коллизии);
	
КонецПроцедуры

// Открывает параметры версионирования объектов
//
&НаКлиенте
Процедура ВключитьВерсионирование(Команда)
	
	СтандартныеПодсистемыКлиентПереопределяемый.ПриОткрытииФормыПараметровВерсионирования();
	
КонецПроцедуры

&НаКлиенте
Процедура ИгнорироватьКонфликт(Команда)
	
	ИгнорироватьВерсию(Элементы.Коллизии.ВыделенныеСтроки, Истина, "Коллизии");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаВерсиюКонфликта(Команда)
	
	ТекущиеДанные = Элементы.Коллизии.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтаВерсияПринята Тогда
		ВерсияДляПерехода = ТекущиеДанные.НомерДругойВерсии;
	Иначе
		ВерсияДляПерехода = ТекущиеДанные.НомерЭтойВерсии;
	КонецЕсли;
	
	Если ВерсияДляПерехода = 0 Тогда
		Сообщить(НСтр("ru = 'Нет версии для перехода.'"));
		Возврат;
	КонецЕсли;
	
	ПерейтиНаВерсиюКоллизииНаСервере(ТекущиеДанные.Ссылка, ВерсияДляПерехода, ТекущиеДанные.НомерДругойВерсии);
	
КонецПроцедуры

&НаКлиенте
Процедура ИгнорироватьНепринятый(Команда)
	
	ИгнорироватьВерсию(Элементы.НепринятыеПоДате.ВыделенныеСтроки, Истина, "НепринятыеПоДате");
	
КонецПроцедуры

&НаКлиенте
Процедура НеИгнорироватьКонфликт(Команда)
	
	ИгнорироватьВерсию(Элементы.Коллизии.ВыделенныеСтроки, Ложь, "Коллизии");
	
КонецПроцедуры

&НаКлиенте
Процедура НеИгнорироватьНепринятый(Команда)
	
	ИгнорироватьВерсию(Элементы.НепринятыеПоДате.ВыделенныеСтроки, Ложь, "НепринятыеПоДате");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПроигнорированные(Команда)
	
	ПоказыватьПроигнорированные = Не ПоказыватьПроигнорированные;
	ПоказатьПроигнорированные();
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьВерсию(Команда)
	
	ТекущиеДанные = Элементы.НепринятыеПоДате.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Или ТекущиеДанные.НомерДругойВерсии = 0 Тогда
		Сообщить(НСтр("ru = 'Нет версии для перехода.'"));
		Возврат;
	КонецЕсли;
	
	Ответ = Вопрос(НСтр("ru = 'Вы действительно хотите загрузить версию несмотря на запрет загрузки?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет); 
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ПерейтиНаНепринятуюВерсиюНаСервере(ТекущиеДанные.Ссылка, ТекущиеДанные.НомерДругойВерсии);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура Игнорировать(Знач ВыделенныеСтроки, Пропустить, ИмяЭлемента)
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
	
		РегистрыСведений.РезультатыОбменаДанными.Игнорировать(ВыделеннаяСтрока.Ссылка, ВыделеннаяСтрока.ТипПроблемы, Пропустить);
	
	КонецЦикла;
	
	ОбновитьНаСервере(ИмяЭлемента);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьПроигнорированные(Обновлять= Истина)
	
	Элементы.ФормаПоказыватьПроигнорированные.Пометка = ПоказыватьПроигнорированные;
	
	НепроведенныеДокументы.Отбор.Элементы[0].Использование = Не ПоказыватьПроигнорированные;
	НезаполненныеРеквизиты.Отбор.Элементы[0].Использование = Не ПоказыватьПроигнорированные;
	Коллизии.Отбор.Элементы[2].Использование = Не ПоказыватьПроигнорированные;
	НепринятыеПоДате.Отбор.Элементы[3].Использование = Не ПоказыватьПроигнорированные;
	
	Если Обновлять Тогда
		
		ОбновитьНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПровестиДокументы(Знач ВыделенныеСтроки)
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		ДокументОбъект = ВыделеннаяСтрока.Ссылка.ПолучитьОбъект();
		
		Если ДокументОбъект.ПроверитьЗаполнение() Тогда
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокУзлов()
	
	СписокПлановОбмена = ОбменДаннымиПовтИсп.ПланыОбменаБСП();
	
	Для Каждого ИмяПланаОбмена Из СписокПлановОбмена Цикл
		
		Если Не ПравоДоступа("Чтение", ПланыОбмена[ИмяПланаОбмена].ПустаяСсылка().Метаданные()) Тогда
			Продолжить;
		КонецЕсли;	
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена[ИмяПланаОбмена].ЭтотУзел());
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаПланаОбмена.Ссылка,
		|	ТаблицаПланаОбмена.Представление КАК Представление
		|ИЗ
		|	&ТаблицаПланаОбмена КАК ТаблицаПланаОбмена
		|ГДЕ
		|	ТаблицаПланаОбмена.Ссылка <> &ЭтотУзел
		|
		|УПОРЯДОЧИТЬ ПО
		|	Представление";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТаблицаПланаОбмена", "ПланОбмена." + ИмяПланаОбмена);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Элементы.УзелИнформационнойБазы.СписокВыбора.Добавить(Выборка.Ссылка, Выборка.Представление);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если Элементы.УзелИнформационнойБазы.СписокВыбора.Количество() >= 7 Тогда
		
		Элементы.УзелИнформационнойБазы.РежимВыбораИзСписка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтборПоУзлу(Обновлять = Истина)
	
	ОтборПоУзлуДокумент = НепроведенныеДокументы.Отбор.Элементы[2];
	ОтборПоУзлуОбъект = НезаполненныеРеквизиты.Отбор.Элементы[2];
	ОтборПоУзлуКоллизии = Коллизии.Отбор.Элементы[0];
	ОтборПоУзлуНепринятые = НепринятыеПоДате.Отбор.Элементы[0];
	
	Если ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
		
		ОтборПоУзлуДокумент.Использование = Истина;
		ОтборПоУзлуДокумент.ПравоеЗначение = УзелИнформационнойБазы;
		
		ОтборПоУзлуОбъект.Использование = Истина;
		ОтборПоУзлуОбъект.ПравоеЗначение = УзелИнформационнойБазы;
		
		ОтборПоУзлуКоллизии.Использование = Истина;
		ОтборПоУзлуКоллизии.ПравоеЗначение = УзелИнформационнойБазы;
		
		ОтборПоУзлуНепринятые.Использование = Истина;
		ОтборПоУзлуНепринятые.ПравоеЗначение = УзелИнформационнойБазы;
		
	Иначе
		
		ОтборПоУзлуДокумент.Использование = Ложь;
		ОтборПоУзлуОбъект.Использование = Ложь;
		ОтборПоУзлуКоллизии.Использование = Ложь;
		ОтборПоУзлуНепринятые.Использование = Ложь;
		
	КонецЕсли;
	
	Если Обновлять Тогда
	
		ОбновитьНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция КоличествоНепринятых()
	
	КоличествоНепринятых = 0;
	СтандартныеПодсистемыПереопределяемый.ПриОбновленииЗаголовковСтраницРезультатовОбменаДанными(КоличествоНепринятых, Ложь,
		ПоказыватьПроигнорированные, УзелИнформационнойБазы, Период, СтрокаПоиска);
		
	Возврат КоличествоНепринятых;
	
КонецФункции

&НаСервере
Функция КоличествоКоллизий()
	
	КоличествоКоллизий = 0;
	СтандартныеПодсистемыПереопределяемый.ПриОбновленииЗаголовковСтраницРезультатовОбменаДанными(КоличествоКоллизий, Истина,
		ПоказыватьПроигнорированные, УзелИнформационнойБазы, Период, СтрокаПоиска);
		
	Возврат КоличествоКоллизий;
		
КонецФункции

&НаСервере
Функция КоличествоНезаполненныхРеквизитов()
	
	Возврат РегистрыСведений.РезультатыОбменаДанными.КоличествоПроблем(Перечисления.ТипыПроблемОбменаДанными.НезаполненныеРеквизиты,
		УзелИнформационнойБазы, ПоказыватьПроигнорированные, Период, СтрокаПоиска);
	
КонецФункции

&НаСервере
Функция КоличествоНепроведенныхДокументов()
	
	Возврат РегистрыСведений.РезультатыОбменаДанными.КоличествоПроблем(Перечисления.ТипыПроблемОбменаДанными.НепроведенныйДокумент,
		УзелИнформационнойБазы, ПоказыватьПроигнорированные, Период, СтрокаПоиска);
	
КонецФункции

&НаСервере
Процедура УстановитьЗаголовокСтраницы(Страница, Заголовок, Количество)
	
	ДобавочнаяСтрока = ?(Количество > 0, " (" + Количество + ")", "");
	Заголовок = Заголовок + ДобавочнаяСтрока;
	Страница.Заголовок = Заголовок;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбъект(Элемент)
	
	Если Элемент.ТекущаяСтрока = Неопределено Или ТипЗнч(Элемент.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Предупреждение(НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	КонецЕсли;
	
	ОткрытьЗначение(Элемент.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеОбъекта()
	
	СтраницыРезультатов = Элементы.РезультатыОбменаДанными;
	
	Если СтраницыРезультатов.ТекущаяСтраница = СтраницыРезультатов.ПодчиненныеЭлементы.СтраницаНепроведенныеДокументы Тогда
		
		ОткрытьОбъект(Элементы.НепроведенныеДокументы); 
		
	ИначеЕсли СтраницыРезультатов.ТекущаяСтраница = СтраницыРезультатов.ПодчиненныеЭлементы.СтраницаНезаполненныеРеквизиты Тогда
		
		ОткрытьОбъект(Элементы.НезаполненныеРеквизиты);
		
	ИначеЕсли СтраницыРезультатов.ТекущаяСтраница = СтраницыРезультатов.ПодчиненныеЭлементы.СтраницаКоллизии Тогда
		
		ОткрытьОбъект(Элементы.Коллизии);
		
	ИначеЕсли СтраницыРезультатов.ТекущаяСтраница = СтраницыРезультатов.ПодчиненныеЭлементы.СтраницаНепринятыеПоДатеЗапрета Тогда
		
		ОткрытьОбъект(Элементы.НепринятыеПоДате);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтличия(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СравниваемыеВерсии = Новый Массив;
	
	Если Элемент.ТекущиеДанные.НомерЭтойВерсии <> 0 Тогда
		СравниваемыеВерсии.Добавить(Элемент.ТекущиеДанные.НомерЭтойВерсии);
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.НомерДругойВерсии <> 0 Тогда
		СравниваемыеВерсии.Добавить(Элемент.ТекущиеДанные.НомерДругойВерсии);
	КонецЕсли;
	
	Если СравниваемыеВерсии.Количество() <> 2 Тогда
		
		Сообщить(НСтр("ru = 'Нет версии для сравнения.'"));
		Возврат;
		
	КонецЕсли;
	
	СтандартныеПодсистемыКлиентПереопределяемый.ПриОткрытииФормыОтчетаПоВерсии(Элемент.ТекущиеДанные.Ссылка, СравниваемыеВерсии);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтборПоПричине(Обновлять = Истина)
	
	СтрокаПоискаЗадана = ЗначениеЗаполнено(СтрокаПоиска);
	
	ОтборПоПричинеДокумент = НепроведенныеДокументы.Отбор.Элементы[3];
	ОтборПоПричинеДокумент.ПравоеЗначение = СтрокаПоиска;
	ОтборПоПричинеДокумент.Использование = ?(СтрокаПоискаЗадана, Истина, Ложь);
	
	ОтборПоПричинеОбъект = НезаполненныеРеквизиты.Отбор.Элементы[3];
	ОтборПоПричинеОбъект.ПравоеЗначение = СтрокаПоиска;
	ОтборПоПричинеОбъект.Использование = ?(СтрокаПоискаЗадана, Истина, Ложь);
	
	ОтборПоПричинеНепринятые = НепринятыеПоДате.Отбор.Элементы[2];
	ОтборПоПричинеНепринятые.ПравоеЗначение = СтрокаПоиска;
	ОтборПоПричинеНепринятые.Использование = ?(СтрокаПоискаЗадана, Истина, Ложь);
	
	Если Обновлять Тогда
		
		ОбновитьНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтборПоПериоду(Обновлять = Истина)
	
	ОтборПоПериодуДокумент = НепроведенныеДокументы.Отбор.Элементы[1];
	ОтборПоПериодуОбъект = НезаполненныеРеквизиты.Отбор.Элементы[1];
	ОтборПоПериодуКоллизии = Коллизии.Отбор.Элементы[1];
	ОтборПоПериодуНепринятые = НепринятыеПоДате.Отбор.Элементы[1];
	
	Если ЗначениеЗаполнено(Период) Тогда
		
		ОтборПоПериодуДокумент.Использование = Истина;
		ОтборПоПериодуДокумент.Элементы[0].ПравоеЗначение = Период.ДатаНачала;
		ОтборПоПериодуДокумент.Элементы[1].ПравоеЗначение = Период.ДатаОкончания;
		
		ОтборПоПериодуОбъект.Использование = Истина;
		ОтборПоПериодуОбъект.Элементы[0].ПравоеЗначение = Период.ДатаНачала;
		ОтборПоПериодуОбъект.Элементы[1].ПравоеЗначение = Период.ДатаОкончания;
		
		ОтборПоПериодуКоллизии.Использование = Истина;
		ОтборПоПериодуКоллизии.Элементы[0].ПравоеЗначение = Период.ДатаНачала;
		ОтборПоПериодуКоллизии.Элементы[1].ПравоеЗначение = Период.ДатаОкончания;
		
		ОтборПоПериодуНепринятые.Использование = Истина;
		ОтборПоПериодуНепринятые.Элементы[0].ПравоеЗначение = Период.ДатаНачала;
		ОтборПоПериодуНепринятые.Элементы[1].ПравоеЗначение = Период.ДатаОкончания;
		
	Иначе
		
		ОтборПоПериодуДокумент.Использование = Ложь;
		ОтборПоПериодуОбъект.Использование = Ложь;
		ОтборПоПериодуКоллизии.Использование = Ложь;
		ОтборПоПериодуНепринятые.Использование = Ложь;
		
	КонецЕсли;
	
	Если Обновлять Тогда
		
		ОбновитьНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИгнорироватьВерсию(Знач ВыделенныеСтроки, Игнорировать, ИмяЭлемента)
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		СтандартныеПодсистемыПереопределяемый.ПриИгнорированииВерсииОбъекта(ВыделеннаяСтрока.Объект, ВыделеннаяСтрока.НомерВерсии, Игнорировать);
		
	КонецЦикла;
	
	ОбновитьНаСервере(ИмяЭлемента);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере(ОбновляемыйЭлемент = "")
	
	ОбновитьСпискиФормы(ОбновляемыйЭлемент);
	ОбновитьЗаголовкиСтраниц();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСпискиФормы(ОбновляемыйЭлемент)
	
	Если ЗначениеЗаполнено(ОбновляемыйЭлемент) Тогда
		
		Элементы[ОбновляемыйЭлемент].Обновить();
		
	Иначе
		
		Элементы.НепроведенныеДокументы.Обновить();
		Элементы.НезаполненныеРеквизиты.Обновить();
		Если ИспользуетсяВерсионирование Тогда
			Элементы.Коллизии.Обновить();
			Элементы.НепринятыеПоДате.Обновить();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовкиСтраниц()
	
	УстановитьЗаголовокСтраницы(Элементы.СтраницаНепроведенныеДокументы, НСтр(" ru= 'Непроведенные документы'"), КоличествоНепроведенныхДокументов());
	УстановитьЗаголовокСтраницы(Элементы.СтраницаНезаполненныеРеквизиты, НСтр(" ru= 'Незаполненные реквизиты'"), КоличествоНезаполненныхРеквизитов());
	
	Если ИспользуетсяВерсионирование Тогда
		УстановитьЗаголовокСтраницы(Элементы.СтраницаКоллизии, НСтр(" ru= 'Конфликты'"), КоличествоКоллизий());
		УстановитьЗаголовокСтраницы(Элементы.СтраницаНепринятыеПоДатеЗапрета, НСтр(" ru= 'Непринятые по дате запрета'"), КоличествоНепринятых());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиНаВерсиюКоллизииНаСервере(Ссылка, ВерсияДляПерехода, ИгнорируемаяВерсия)
	
	СтандартныеПодсистемыПереопределяемый.ПриПереходеНаВерсиюОбъекта(Ссылка, ВерсияДляПерехода, ИгнорируемаяВерсия);
	ОбновитьНаСервере("Коллизии");
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиНаНепринятуюВерсиюНаСервере(Ссылка, НомерВерсии)
	
	СтандартныеПодсистемыПереопределяемый.ПриПереходеНаВерсиюОбъекта(Ссылка, НомерВерсии, НомерВерсии, Истина);
	ОбновитьНаСервере("НепринятыеПоДате");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюНаКлиенте(ТекущиеДанные, Версия)
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СравниваемыеВерсии = Новый Массив;
	СравниваемыеВерсии.Добавить(Версия);
	СтандартныеПодсистемыКлиентПереопределяемый.ПриОткрытииФормыОтчетаПоВерсии(ТекущиеДанные.Ссылка, СравниваемыеВерсии);
	
КонецПроцедуры
