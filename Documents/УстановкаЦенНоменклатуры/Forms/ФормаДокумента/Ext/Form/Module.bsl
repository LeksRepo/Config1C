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
	|	ЦеныНоменклатурыСрезПоследних.Поставщик,
	|	НоменклатураПодразделений.ПодЗаказ КАК ПодЗаказ
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(&Период, Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО (ЦеныНоменклатурыСрезПоследних.Номенклатура = СпрНоменклатура.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений КАК НоменклатураПодразделений
	|		ПО (НоменклатураПодразделений.Номенклатура = СпрНоменклатура.Ссылка)
	|			И (НоменклатураПодразделений.Подразделение = &Подразделение)
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
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Номенклатура,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная, 0) КАК ПлановаяЗакупочная,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Внутренняя, 0) КАК Внутренняя,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Розничная, 0) КАК Розничная,
	|	НоменклатураПодразделений.ПодЗаказ КАК ПодЗаказ
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(, Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО (ЦеныНоменклатурыСрезПоследних.Номенклатура = СпрНоменклатура.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений КАК НоменклатураПодразделений
	|		ПО (НоменклатураПодразделений.Номенклатура = СпрНоменклатура.Ссылка)
	|			И (НоменклатураПодразделений.Подразделение = &Подразделение)
	|ГДЕ
	|	НЕ СпрНоменклатура.ЭтоГруппа
	|	И СпрНоменклатура.Базовый
	|	И НЕ СпрНоменклатура.ПометкаУдаления
	|	И ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная, 0) + ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Внутренняя, 0) + ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Розничная, 0) = 0
	|	И НЕ СпрНоменклатура.НоменклатурнаяГруппа.ИгнорироватьВОтчетах
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
	
	Перем Ошибки;
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	НеЗаполнено = Ложь;
	ЛимитВыводимыхОшибок = 10; // Думаю достаточно
	Индекс = 0;
	ШаблонТекстОшибки = "%1 не заполнена %2 цена";
	
	Для Каждого Элемент Из Объект.СписокНоменклатуры Цикл
		Если Элемент.ПлановаяЗакупочная = 0
			ИЛИ Элемент.Розничная = 0 Тогда
			
			НеЗаполнено = Истина;
			
			Если Элемент.ПлановаяЗакупочная = 0 Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстОшибки, Элемент.Номенклатура, "плановая");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ПлановаяЗакупочная", ТекстОшибки,,Элемент.НомерСтроки);
			КонецЕсли;
			
			Если Элемент.Розничная = 0 Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстОшибки, Элемент.Номенклатура, "розничная");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Розничная", ТекстОшибки,,Элемент.НомерСтроки);
			КонецЕсли;
			
			Индекс = Индекс+1;
			
			Если Индекс > ЛимитВыводимыхОшибок Тогда
				Прервать;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если Индекс > ЛимитВыводимыхОшибок Тогда
		ТекстВопроса = "В документе более " + ЛимитВыводимыхОшибок + " строк с незаполненной ценой.";
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		ТекстВопроса = "В документе есть номенклатура с незаполненной ценой.";
	КонецЕсли;
	ТекстВопроса = ТекстВопроса  + Символы.ПС + "Вы уверены что хотите продолжить?";
	
	Если НеЗаполнено И КодВозвратаДиалога.Нет = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

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
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.СписокНоменклатуры.Доступность = ЗначениеЗаполнено(Объект.Подразделение);
	ЗаполнитьКолонкуПодЗаказ();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыНоменклатураПриИзменении(Элемент)
	
	Данные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	Данные.ПодЗаказ = ПроверитьНоменклатуруПодЗаказ(Данные.Номенклатура,Объект.Подразделение);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьНоменклатуруПодЗаказ(Номенклатура, Подразделение)
	
	ПодЗаказ = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Данные.ПодЗаказ КАК ПодЗаказ
	|ИЗ
	|	РегистрСведений.НоменклатураПодразделений КАК Данные
	|ГДЕ
	|	Данные.Подразделение = &Подразделение
	|	И Данные.Номенклатура = &Номенклатура";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ПодЗаказ = Выборка.ПодЗаказ;
	КонецЕсли;
	
	Возврат ПодЗаказ;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКолонкуПодЗаказ()
	
	Таблица = Объект.СписокНоменклатуры;
	
	Если Таблица.Количество() > 0 Тогда
		
		// { Васильев Александр Леонидович [30.03.2016]
		// Тут было бы правильнее передать всю таблицу в запрос,
		// и потом целиком её загрузить, чтобы поиском не обрабатывать.
		// } Васильев Александр Леонидович [30.03.2016]
		
		СписокНоменклатуры = Таблица.Выгрузить(,"Номенклатура").ВыгрузитьКолонку("Номенклатура");
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
		Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Данные.Номенклатура КАК Номенклатура,
		|	Данные.ПодЗаказ КАК ПодЗаказ
		|ИЗ
		|	РегистрСведений.НоменклатураПодразделений КАК Данные
		|ГДЕ
		|	Данные.Подразделение = &Подразделение
		|	И Данные.Номенклатура В (&СписокНоменклатуры)";
		
		Результат = Запрос.Выполнить().Выгрузить();
		
		Для Каждого Строка ИЗ Таблица Цикл
			Строка.ПодЗаказ = Результат.Найти(Строка.Номенклатура, "Номенклатура").ПодЗаказ;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Элементы.СписокНоменклатуры.Доступность = ЗначениеЗаполнено(Объект.Подразделение);
	
КонецПроцедуры
