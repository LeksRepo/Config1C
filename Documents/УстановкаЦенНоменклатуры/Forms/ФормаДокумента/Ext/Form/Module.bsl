﻿
&НаКлиенте
Процедура ЗаполнитьГруппой(Команда)
	
	Группа = ОткрытьФормуМодально("Справочник.Номенклатура.ФормаВыбораГруппы");
	
	Если ЗначениеЗаполнено(Группа) Тогда
		
		Если Объект.СписокНоменклатуры.Количество() > 0 
			И КодВозвратаДиалога.Нет = Вопрос("Табличная часть будет очищена. Продолжить?", РежимДиалогаВопрос.ДаНет, 0) Тогда
			
			Возврат;
			
		КонецЕсли;
		
		Объект.СписокНоменклатуры.Очистить();
		ЗаполнитьСписок(Группа);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСписок(ГруппаНоменклатуры)
	
	Если ГруппаНоменклатуры = Неопределено Тогда
		ГруппаНоменклатуры = Справочники.Номенклатура.ПустаяСсылка();
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Родитель", ГруппаНоменклатуры);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Номенклатура,
	|	ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная,
	|	ЦеныНоменклатурыСрезПоследних.Внутренняя,
	|	ЦеныНоменклатурыСрезПоследних.Розничная,
	|	ЦеныНоменклатурыСрезПоследних.Поставщик
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(&Период, Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО (ЦеныНоменклатурыСрезПоследних.Номенклатура = СпрНоменклатура.Ссылка)
	|ГДЕ
	|	НЕ СпрНоменклатура.ЭтоГруппа
	|	И СпрНоменклатура.Базовый
	|	И СпрНоменклатура.Родитель В ИЕРАРХИИ(&Родитель)
	|	И НЕ СпрНоменклатура.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	СпрНоменклатура.Наименование";
	
	Результат = Запрос.Выполнить();
	Объект.СписокНоменклатуры.Загрузить(Результат.Выгрузить());
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПустыми(Команда)
	
	Если Объект.СписокНоменклатуры.Количество() > 0
		И КодВозвратаДиалога.Нет = Вопрос("Табличная часть будет очищена. Продолжить?", РежимДиалогаВопрос.ДаНет, 0) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьПустымиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПустымиНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регион", Объект.Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Номенклатура,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная, 0) КАК ПлановаяЗакупочная,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Внутренняя, 0) КАК Внутренняя,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Розничная, 0) КАК Розничная
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(, Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО (ЦеныНоменклатурыСрезПоследних.Номенклатура = СпрНоменклатура.Ссылка)
	|ГДЕ
	|	НЕ СпрНоменклатура.ЭтоГруппа
	|	И СпрНоменклатура.Базовый
	|	И НЕ СпрНоменклатура.ПометкаУдаления
	|	И ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная, 0) + ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Внутренняя, 0) + ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Розничная, 0) = 0
	|	И НЕ СпрНоменклатура.МатериалЗаказчика
	|	И СпрНоменклатура.НоменклатурнаяГруппа <> ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.Гравировка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СпрНоменклатура.Наименование";
	
	Результат = Запрос.Выполнить();
	Объект.СписокНоменклатуры.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	НеЗаполнено = Ложь;
	Индекс = 0;
	
	
	Для Каждого Элемент Из Объект.СписокНоменклатуры Цикл
		Если Элемент.ПлановаяЗакупочная = 0
			ИЛИ Элемент.Розничная = 0 Тогда
			
			НеЗаполнено = Истина;
			
			// { Васильев Александр Леонидович [25.09.2014]
			// Переделать сообщения на:
			// ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю();
			// } Васильев Александр Леонидович [25.09.2014]
			
			Если Элемент.ПлановаяЗакупочная = 0 Тогда
				СообщитьНеЗаполнено(Индекс, "ПлановаяЗакупочная", Элемент);
			КонецЕсли;
			
			Если Элемент.Розничная = 0 Тогда
				СообщитьНеЗаполнено(Индекс, "Розничная", Элемент);
			КонецЕсли;
			
		КонецЕсли;
		
		Индекс = Индекс+1;
		
	КонецЦикла;
	
	Если НеЗаполнено И КодВозвратаДиалога.Нет = Вопрос("В документе есть незаполненные цены."+Символы.ПС+"Вы уверены что хотите продолжить?", РежимДиалогаВопрос.ДаНет, 0) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СообщитьНеЗаполнено(Индекс, Поле, Элемент)
	
	Сообщение = Новый СообщениеПользователю();
	Сообщение.Текст = Строка(Элемент.Номенклатура)+": "+Поле; 
	Сообщение.Поле = "Объект.СписокНоменклатуры["+Индекс+"]."+Поле;
	Сообщение.УстановитьДанные(Объект.СписокНоменклатуры);
	Сообщение.Сообщить();
	
КонецФункции

&НаКлиенте
Процедура УмножитьПлановую(Команда)
	
	Множитель = ПолучитьМножитель();
	УмножитьЦену(Множитель, "ПлановаяЗакупочная");
	
КонецПроцедуры

&НаКлиенте
Процедура УмножитьРозничную(Команда)
	
	Множитель = ПолучитьМножитель();
	УмножитьЦену(Множитель, "Розничная");
	
КонецПроцедуры

&НаСервере
Функция УмножитьЦену(Множитель, Поле)
	
	Для каждого Строка Из Объект.СписокНоменклатуры Цикл
		Строка[Поле] = Строка[Поле] * Множитель;
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Функция ПолучитьМножитель()
	
	Множитель = 1.00;
	ВвестиЧисло(Множитель, "Введите множитель", 5, 2);
	
	Возврат Множитель;
	
КонецФункции

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
		
		Если ТекущийОбъект.Подразделение= Справочники.Подразделения.НайтиПоКоду("000000004") Тогда
			
			ТекущийОбъект.Регион = Справочники.Регионы.НайтиПоКоду("000000001");
			
		ИначеЕсли ТекущийОбъект.Подразделение= Справочники.Подразделения.НайтиПоКоду("000000005") Тогда
			
			ТекущийОбъект.Регион = Справочники.Регионы.НайтиПоКоду("000000002");
			
		КонецЕсли;
	
КонецПроцедуры
