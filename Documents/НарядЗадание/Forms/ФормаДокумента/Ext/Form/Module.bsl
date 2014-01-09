﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ПолучитьТаблицуМатериалов(СписокСпецификаций) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВидыСубконто = Новый Массив;
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокСпецификаций", СписокСпецификаций);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Склад", Объект.Подразделение.ОсновнойСклад);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпецификацияСписокНоменклатуры.Номенклатура,
	|	СУММА(СпецификацияСписокНоменклатуры.Количество) КАК ТребуетсяПоСпецификациям
	|ПОМЕСТИТЬ СписокНоменклатуры
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В(&СписокСпецификаций)
	|	И НЕ СпецификацияСписокНоменклатуры.ЧерезСклад
	|	И СпецификацияСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ОстаткиНаСкладе.Субконто2.Базовый
	|			ТОГДА ОстаткиНаСкладе.Субконто2
	|		ИНАЧЕ ОстаткиНаСкладе.Субконто2.БазоваяНоменклатура
	|	КОНЕЦ КАК Номенклатура,
	|	СУММА(ВЫБОР
	|			КОГДА ОстаткиНаСкладе.Субконто2.Базовый
	|				ТОГДА ОстаткиНаСкладе.КоличествоОстаток
	|			ИНАЧЕ ОстаткиНаСкладе.Субконто2.КоэффициентБазовых * ОстаткиНаСкладе.КоличествоОстаток
	|		КОНЕЦ) КАК ОстатокНаСкладе
	|ПОМЕСТИТЬ ОстаткиНаСкладе
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|			,
	|			Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.Логистика)
	|				И Субконто1 = &Склад) КАК ОстаткиНаСкладе
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА ОстаткиНаСкладе.Субконто2.Базовый
	|			ТОГДА ОстаткиНаСкладе.Субконто2
	|		ИНАЧЕ ОстаткиНаСкладе.Субконто2.БазоваяНоменклатура
	|	КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СписокНоменклатуры.Номенклатура,
	|	СписокНоменклатуры.ТребуетсяПоСпецификациям КАК ТребуетсяПоСпецификациям,
	|	СписокНоменклатуры.ТребуетсяПоСпецификациям КАК Затребовано,
	|	ОстаткиВЦеху.КоличествоОстаток КАК ОстатокВЦеху,
	|	ОстаткиНаСкладе.ОстатокНаСкладе,
	|	ЕСТЬNULL(ДопЛимит.КоличествоОстаток, 0) + ЕСТЬNULL(БазовыйЛимитЦехаСрезПоследних.Количество, 0) - ЕСТЬNULL(ОстаткиВЦеху.КоличествоРазвернутыйОстатокДт, 0) + СписокНоменклатуры.ТребуетсяПоСпецификациям КАК Лимит
	|ИЗ
	|	СписокНоменклатуры КАК СписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ОсновноеПроизводство),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто1 В
	|						(ВЫБРАТЬ
	|							СписокНоменклатуры.Номенклатура
	|						ИЗ
	|							СписокНоменклатуры)) КАК ОстаткиВЦеху
	|		ПО СписокНоменклатуры.Номенклатура = ОстаткиВЦеху.Субконто1
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиНаСкладе КАК ОстаткиНаСкладе
	|		ПО СписокНоменклатуры.Номенклатура = ОстаткиНаСкладе.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.БазовыйЛимитЦеха.СрезПоследних(, Подразделение = &Подразделение) КАК БазовыйЛимитЦехаСрезПоследних
	|		ПО СписокНоменклатуры.Номенклатура = БазовыйЛимитЦехаСрезПоследних.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ДополнительныйЛимитЦеха), , Подразделение = &Подразделение) КАК ДопЛимит
	|		ПО СписокНоменклатуры.Номенклатура = ДопЛимит.Субконто1
	|
	|УПОРЯДОЧИТЬ ПО
	|	СписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа,
	|	СписокНоменклатуры.Номенклатура.Наименование";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ОбновитьСписокВыбораНоменклатуры()
	
	МассивНоменклатуры = Объект.СписокНоменклатуры.Выгрузить().ВыгрузитьКолонку("Номенклатура");
	
	///////Таблица расшифровки//////////////////////
	СписокСпецификаций = Объект.СписокСпецификаций.Выгрузить().ВыгрузитьКолонку("Спецификация");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(Номенклатура.Ссылка) КАК Ссылка
	|ПОМЕСТИТЬ ОсновнаяНоменклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Базовый
	|
	|СГРУППИРОВАТЬ ПО
	|	Номенклатура.БазоваяНоменклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СпецификацияСписокНоменклатуры.Ссылка КАК Спецификация,
	|	ЕСТЬNULL(ОсновнаяНоменклатура.Ссылка, СпецификацияСписокНоменклатуры.Номенклатура) КАК Номенклатура,
	|	СУММА(СпецификацияСписокНоменклатуры.Количество * ЕСТЬNULL(ОсновнаяНоменклатура.Ссылка.КоэффициентБазовых, 1)) КАК Количество
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОсновнаяНоменклатура КАК ОсновнаяНоменклатура
	|		ПО СпецификацияСписокНоменклатуры.Номенклатура = ОсновнаяНоменклатура.Ссылка.БазоваяНоменклатура
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В(&СписокСпецификаций)
	|	И ЕСТЬNULL(ОсновнаяНоменклатура.Ссылка.ПроцентОтхода, СпецификацияСписокНоменклатуры.Номенклатура.ПроцентОтхода) > 0
	|	И ЕСТЬNULL(ОсновнаяНоменклатура.Ссылка, СпецификацияСписокНоменклатуры.Номенклатура) В (&Номенклатура)
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Ссылка,
	|	ЕСТЬNULL(ОсновнаяНоменклатура.Ссылка, СпецификацияСписокНоменклатуры.Номенклатура)";
	Запрос.УстановитьПараметр("СписокСпецификаций", СписокСпецификаций);
	Запрос.УстановитьПараметр("Номенклатура", МассивНоменклатуры);
	
	ТаблицаРасшифровки.Загрузить(Запрос.Выполнить().Выгрузить());
	////////////////////////////
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСпецификации(АдресТаблицы)
	
	ТЗ = ПолучитьИзВременногоХранилища(АдресТаблицы);
	Объект.СписокСпецификаций.Загрузить(ТЗ);
	ЗаполнитьНоменклатуройСервер();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНоменклатуройСервер() 
	
	ТаблицаСпецификаций = Объект.СписокСпецификаций.Выгрузить();
	СписокСпецификаций = ТаблицаСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	ТаблицаНоменклатуры = ПолучитьТаблицуМатериалов(СписокСпецификаций);
	
	Объект.СписокНоменклатуры.Загрузить(ТаблицаНоменклатуры);
	
	ОбновитьСписокВыбораНоменклатуры();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьСписокВыбораНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И Объект.Дата > ТекущаяДата() Тогда
		Отказ = Истина;
		ТекстСообщения = "Запрещено проводить 'Наряд задание' будущей датой";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Дата", "Объект");
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбновитьСписокВыбораНоменклатуры();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ВыбратьСпецификации(Команда)
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Текст = "Табличные части будут изменены." + Символы.ПС + "Продолжить?" ;
	
	Если Объект.СписокСпецификаций.Количество() > 0 
		И Вопрос(Текст, Режим, 0) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	АдресТаблицы = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораСпецификации", Новый Структура("Подразделение, ТЗ, Статус, УпорядочитьПоДате", Объект.Подразделение, Объект.СписокСпецификаций, ПредопределенноеЗначение("Перечисление.СтатусыСпецификации.Размещен"), Истина), ЭтаФорма);
	Если АдресТаблицы <> Неопределено Тогда
		ЗагрузитьСпецификации(АдресТаблицы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНоменклатуру(Команда)
	
	ЗаполнитьНоменклатуройСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСпецификацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.СписокСпецификаций.ТекущиеДанные.Спецификация);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Номенклатура = Элемент.ТекущиеДанные.Номенклатура;
		Если ЗначениеЗаполнено(Номенклатура) Тогда
			ОтборСтрок = Новый ФиксированнаяСтруктура("Номенклатура", Номенклатура);
		Иначе
			ОтборСтрок = Новый ФиксированнаяСтруктура("Номенклатура", ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
		КонецЕсли;
		Элементы.ТаблицаРасшифровки.ОтборСтрок = ОтборСтрок;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
