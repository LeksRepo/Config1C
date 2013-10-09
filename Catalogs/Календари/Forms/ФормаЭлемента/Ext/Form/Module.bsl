﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Если Параметры.Свойство("ПроизводственныйКалендарь") Тогда
			Объект.ПроизводственныйКалендарь = Параметры.ПроизводственныйКалендарь;
		КонецЕсли;
		
		Если Параметры.Свойство("ВидКалендаря") Тогда
			Объект.ВидКалендаря = Параметры.ВидКалендаря;
		КонецЕсли;
		
		ЗаполнитьФормуПоОбъекту(Параметры.Свойство("ПроизводственныйКалендарь"), Параметры.ЗначениеКопирования);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Если ТипЗнч(РезультатВыбора) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	РезультатВыбора.Свойство("ПроизводственныйКалендарь", Объект.ПроизводственныйКалендарь);
	РезультатВыбора.Свойство("ВидКалендаря", Объект.ВидКалендаря);
	
	// Производственный календарь теперь известен - можно заполнять
	ЗаполнитьФормуПоОбъекту(Истина);
	
	Элементы.Календарь.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьФормуПоОбъекту();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Перем НомерГода;
	
	Если Не ПараметрыЗаписи.Свойство("НомерГода", НомерГода) Тогда
		НомерГода = НомерТекущегоГода;
	КонецЕсли;
	
	ЗаписатьФлагРучногоИзменения(ТекущийОбъект.Ссылка);	
	ЗаписатьКалендарныйГрафик(НомерГода, ТекущийОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура НомерТекущегоГодаПриИзменении(Элемент)
	
	Если НомерТекущегоГода < 1900 Тогда
		НомерТекущегоГода = НомерПредыдущегоГода;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Записать измененные данные за %1 год?'"), 
							Формат(НомерПредыдущегоГода, "ЧГ=0"));
		
		Если Вопрос(ТекстСообщения, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			Если Объект.Ссылка.Пустая() Тогда
				Записать(Новый Структура("НомерГода", НомерПредыдущегоГода));
			Иначе
				ЗаписатьКалендарныйГрафик(НомерПредыдущегоГода);
			КонецЕсли;
		КонецЕсли;
		ЗаписатьФлагРучногоИзменения(Объект.Ссылка);
	КонецЕсли;
	
	ЗаполнитьФормуПоОбъекту();
	
	Модифицированность = Ложь;
	
	Элементы.Календарь.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура КалендарьПриВыводеПериода(Элемент, ОформлениеПериода)
	
	Для Каждого СтрокаОформленияПериода Из ОформлениеПериода.Даты Цикл
		СтрокаТаблицыРегистра = ТаблицаРегистра.НайтиПоЗначению(СтрокаОформленияПериода.Дата);
		
		Если СтрокаТаблицыРегистра = Неопределено Тогда
			СтрокаОформленияПериода.ЦветТекста = ОбщегоНазначенияКлиент.ЦветСтиля("ВидДняНеУказанЦвет");
		Иначе
			СтрокаОформленияПериода.ЦветТекста = ОбщегоНазначенияКлиент.ЦветСтиля("ВидДняРабочийЦвет");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КалендарьВыбор(Элемент, ВыбраннаяДата)
	
	Если РучноеИзменение = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицыРегистра = ТаблицаРегистра.НайтиПоЗначению(ВыбраннаяДата);
	
	Если СтрокаТаблицыРегистра = Неопределено Тогда
		ТаблицаРегистра.Добавить(ВыбраннаяДата);
	Иначе
		ТаблицаРегистра.Удалить(СтрокаТаблицыРегистра);
	КонецЕсли;
	
	Если Не Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
	Элемент.Обновить();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаполнитьПоКалендарю(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.ПроизводственныйКалендарь) 
		Или Не ЗначениеЗаполнено(Объект.ВидКалендаря) Тогда
		// Производственный календарь не указан, пытаемся уточнить у пользователя способ заполнения
		ОткрытьФорму("Справочник.Календари.Форма.НастройкаНовогоКалендаря", , ЭтаФорма);
		Возврат;
	КонецЕсли;
	
	// Производственный календарь указан, а значит известно как заполнять
	ЗаполнитьФормуПоОбъекту(Истина);
	
	Элементы.Календарь.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	Текст = НСтр("ru = 'Поставляемые данные обновляются автоматически.
		|После ручного изменения автоматическое обновление этого элемента производиться не будет.
		|Продолжить с изменением?'");
	Результат = Вопрос(Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Модифицированность = Истина;
		РучноеИзменение = Истина;
		УстановитьСвойстваЭлементовФормы();

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзШаблона(Команда)
	
	Текст = НСтр("ru = 'Данные элемента поставляемых данных будут заменены общими данными.
		|Все ручные изменения будут потеряны. Продолжить?'");
	Результат = Вопрос(Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Модифицированность = Истина;
		РучноеИзменение = Ложь;
		
		ОбновитьИзШаблонаНаСервере();
		
		ЗаполнитьФормуПоОбъекту();
		Модифицированность = Ложь;
		Элементы.Календарь.Обновить();
		
		УстановитьСвойстваЭлементовФормы();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура Перечитать(Команда)
	
	ЭтаФорма.Прочитать();
	Элементы.Календарь.Обновить();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаписатьКалендарныйГрафик(Знач НомерГода, Знач ТекущийОбъект = Неопределено)
	
	// Запись данных календарного графика за указанный год
	
	Если ТекущийОбъект = Неопределено Тогда
		ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	
	Справочники.Календари.ЗаписатьДанныеГрафикаВРегистр(ТекущийОбъект.Ссылка, НомерГода, ТаблицаРегистра);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуПоОбъекту(ЗаполнятьПоДаннымПроизводственногоКалендаря = Ложь, ЗначениеКопирования = Неопределено)
	
	Если НомерТекущегоГода = 0 Тогда
		НомерТекущегоГода = Год(ТекущаяДатаСеанса());
	КонецЕсли;
	НомерПредыдущегоГода = НомерТекущегоГода;
	
	Элементы.Календарь.НачалоПериодаОтображения	= Дата(НомерТекущегоГода, 1, 1);
	Элементы.Календарь.КонецПериодаОтображения	= Дата(НомерТекущегоГода, 12, 31);
	
	Если ЗаполнятьПоДаннымПроизводственногоКалендаря Тогда
		ТаблицаРегистра.ЗагрузитьЗначения(Справочники.Календари.ЗаполнитьПоДаннымПроизводственногоКалендаря(
			Объект.ПроизводственныйКалендарь, НомерТекущегоГода, Объект.ВидКалендаря));
		РучноеИзменение = Ложь;
	Иначе
		Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
			СсылкаНаКалендарь = ЗначениеКопирования;
		Иначе
			СсылкаНаКалендарь = Объект.Ссылка;
		КонецЕсли;
		ТаблицаРегистра.ЗагрузитьЗначения(Справочники.Календари.ПрочитатьДанныеГрафикаИзРегистра(СсылкаНаКалендарь, НомерТекущегоГода));		
	КонецЕсли;
	
	СчитатьФлагРучногоИзменения();
	
КонецПроцедуры

&НаСервере
Процедура СчитатьФлагРучногоИзменения()
	
	Если Не Объект.Ссылка.Пустая() Тогда
		РучноеИзменение = СтандартныеПодсистемыПереопределяемый.СчитатьРучноеИзменениеКалендаря(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьФлагРучногоИзменения(Знач Календарь)
	
	Если РучноеИзменение <> Неопределено Тогда
		СтандартныеПодсистемыПереопределяемый.УстановитьРучноеРедактированиеКалендаря(Календарь, РучноеИзменение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСвойстваЭлементовФормы()
	
	ОбработатьФлагРучногоИзменения();
	
	Если РучноеИзменение <> Неопределено И НЕ РучноеИзменение Тогда
		СпособРедактированияПоясняющийТекст = ""; 
		Элементы.ЗаполнитьПоКалендарю.Доступность = Ложь;
	Иначе
		СпособРедактированияПоясняющийТекст = НСтр("ru = 'Для редактирования рабочих и выходных дней календаря используйте двойной щелчок левой кнопкой мыши'");
		Элементы.ЗаполнитьПоКалендарю.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьФлагРучногоИзменения()
	
	Если РучноеИзменение = Неопределено Тогда
		ТекстРучногоИзменения = НСтр("ru = 'Элемент создан вручную. Автоматическое обновление не возможно.'");
		
		Элементы.ФормаОбновитьИзШаблона.Доступность = Ложь;
		Элементы.ФормаИзменить.Доступность = Ложь;
	ИначеЕсли РучноеИзменение = Истина Тогда
		ТекстРучногоИзменения = НСтр("ru = 'Автоматическое обновление элемента отключено.'");
		
		Элементы.ФормаОбновитьИзШаблона.Доступность = Истина;
		Элементы.ФормаИзменить.Доступность = Ложь;
	Иначе
		ТекстРучногоИзменения = НСтр("ru = 'Элемент обновляется автоматически.'");
		
		Элементы.ФормаОбновитьИзШаблона.Доступность = Ложь;
		Элементы.ФормаИзменить.Доступность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьИзШаблонаНаСервере()
	
	КалендарьОбъект = РеквизитФормыВЗначение("Объект");
	КалендарьОбъект.СформироватьПоДаннымПроизводственногоКалендаря();

КонецПроцедуры
