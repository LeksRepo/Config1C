﻿
&НаКлиенте
Процедура ТаблицаРасшифровкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.ТаблицаРасшифровки.ТекущиеДанные.Спецификация);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Если Объект.Подразделение.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	СвойстваПодразделения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Подразделение, "ОсновнойСклад, Регион");
	УстановитьПривилегированныйРежим(Истина);
	
	#Область Запрос
	
	Если Объект.Дата >= '2014.06.01' Тогда
		ПодразделениеСклад = Объект.Подразделение;
	Иначе
		ПодразделениеСклад = Справочники.Подразделения.Логистика;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("ПодразделениеСклад", ПодразделениеСклад);
	Запрос.УстановитьПараметр("Склад", СвойстваПодразделения.ОсновнойСклад);
	Запрос.УстановитьПараметр("Регион", СвойстваПодразделения.Регион);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА УправленческийОстатки.Субконто2.Базовый
	|			ТОГДА ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Справочник.Номенклатура)
	|		ИНАЧЕ ВЫРАЗИТЬ(УправленческийОстатки.Субконто2.БазоваяНоменклатура КАК Справочник.Номенклатура)
	|	КОНЕЦ КАК Номенклатура,
	|	СУММА(ВЫБОР
	|			КОГДА УправленческийОстатки.Субконто2.Базовый
	|				ТОГДА УправленческийОстатки.КоличествоОстатокДт
	|			ИНАЧЕ УправленческийОстатки.КоличествоОстатокДт * УправленческийОстатки.Субконто2.КоэффициентБазовых
	|		КОНЕЦ) КАК Количество
	|ПОМЕСТИТЬ ВТОстаткиНаСкладе
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|			,
	|			Подразделение = &ПодразделениеСклад
	|				И Субконто1 = &Склад
	|				И НЕ Субконто2.МатериалЗаказчика) КАК УправленческийОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА УправленческийОстатки.Субконто2.Базовый
	|			ТОГДА ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Справочник.Номенклатура)
	|		ИНАЧЕ ВЫРАЗИТЬ(УправленческийОстатки.Субконто2.БазоваяНоменклатура КАК Справочник.Номенклатура)
	|	КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УправленческийОстатки.Субконто2 КАК Номенклатура,
	|	УправленческийОстатки.КоличествоОстатокДт КАК Количество
	|ПОМЕСТИТЬ ВТРезервныйЗапас
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.РезервныйЗапасМатериалов),
	|			,
	|			Подразделение = &ПодразделениеСклад
	|				И Субконто1 = &Склад) КАК УправленческийОстатки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВТОстаткиНаСкладе.Номенклатура ЕСТЬ NULL 
	|			ТОГДА ВТРезервныйЗапас.Номенклатура
	|		ИНАЧЕ ВТОстаткиНаСкладе.Номенклатура
	|	КОНЕЦ КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ВТРезервныйЗапас.Количество, 0) - ЕСТЬNULL(ВТОстаткиНаСкладе.Количество, 0) > 0
	|			ТОГДА ЕСТЬNULL(ВТРезервныйЗапас.Количество, 0) - ЕСТЬNULL(ВТОстаткиНаСкладе.Количество, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Количество,
	|	ЕСТЬNULL(ВТОстаткиНаСкладе.Количество, 0) КАК ОстатокНаСкладе
	|ПОМЕСТИТЬ ВТДокупитьНаСклад
	|ИЗ
	|	ВТОстаткиНаСкладе КАК ВТОстаткиНаСкладе
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТРезервныйЗапас КАК ВТРезервныйЗапас
	|		ПО ВТОстаткиНаСкладе.Номенклатура = ВТРезервныйЗапас.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиВЦеху.Субконто1 КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(БазовыйЛимитЦехаСрезПоследних.Количество, 0) > ОстаткиВЦеху.КоличествоОстатокДт
	|			ТОГДА 0
	|		ИНАЧЕ ОстаткиВЦеху.КоличествоОстатокДт - ЕСТЬNULL(БазовыйЛимитЦехаСрезПоследних.Количество, 0)
	|	КОНЕЦ КАК ОстатокВЦехуСУчетомЛимита
	|ПОМЕСТИТЬ ВТЦеховыеОстатки
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ОсновноеПроизводство), , Подразделение = &Подразделение) КАК ОстаткиВЦеху
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.БазовыйЛимитЦеха.СрезПоследних(, Подразделение = &Подразделение) КАК БазовыйЛимитЦехаСрезПоследних
	|		ПО ОстаткиВЦеху.Субконто1 = БазовыйЛимитЦехаСрезПоследних.Номенклатура
	|ГДЕ
	|	ЕСТЬNULL(ОстаткиВЦеху.КоличествоОстатокДт, 0) - ЕСТЬNULL(БазовыйЛимитЦехаСрезПоследних.Количество, 0) > 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпецификацияСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СУММА(СпецификацияСписокНоменклатуры.Количество) КАК КоличествоВсегоТребуется,
	|	СУММА(ВЫБОР
	|			КОГДА СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Рассчитывается)
	|				ТОГДА СпецификацияСписокНоменклатуры.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоРассчитывается
	|ПОМЕСТИТЬ ВТТребуетсяПоСпецификациям
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО СпецификацияСписокНоменклатуры.Ссылка = СтатусСпецификацииСрезПоследних.Спецификация
	|ГДЕ
	|	СтатусСпецификацииСрезПоследних.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Рассчитывается), ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен), ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ПереданВЦех))
	|	И СпецификацияСписокНоменклатуры.Ссылка.Производство = &Подразделение
	|	И СпецификацияСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|	И НЕ СпецификацияСписокНоменклатуры.Номенклатура.МатериалЗаказчика
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТТребуетсяПоСпецификациям.Номенклатура КАК Номенклатура,
	|	ВТТребуетсяПоСпецификациям.КоличествоВсегоТребуется - ЕСТЬNULL(ВТЦеховыеОстатки.ОстатокВЦехуСУчетомЛимита, 0) КАК Количество
	|ПОМЕСТИТЬ ВТДокупитьНаЦех
	|ИЗ
	|	ВТТребуетсяПоСпецификациям КАК ВТТребуетсяПоСпецификациям
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЦеховыеОстатки КАК ВТЦеховыеОстатки
	|		ПО ВТТребуетсяПоСпецификациям.Номенклатура = ВТЦеховыеОстатки.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОстаткиНаСкладе КАК ВТОстаткиНаСкладе
	|		ПО ВТТребуетсяПоСпецификациям.Номенклатура = ВТОстаткиНаСкладе.Номенклатура
	|ГДЕ
	|	ВТТребуетсяПоСпецификациям.КоличествоВсегоТребуется - ЕСТЬNULL(ВТЦеховыеОстатки.ОстатокВЦехуСУчетомЛимита, 0) > ЕСТЬNULL(ВТОстаткиНаСкладе.Количество, 0)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВТДокупитьНаСклад.Номенклатура ЕСТЬ NULL 
	|			ТОГДА ВТДокупитьНаЦех.Номенклатура
	|		ИНАЧЕ ВТДокупитьНаСклад.Номенклатура
	|	КОНЕЦ КАК Номенклатура,
	|	ЕСТЬNULL(ВТДокупитьНаСклад.Количество, 0) + ЕСТЬNULL(ВТДокупитьНаЦех.Количество, 0) - ЕСТЬNULL(ВТДокупитьНаСклад.ОстатокНаСкладе, 0) КАК Количество
	|ПОМЕСТИТЬ ВТМатериалыДляЗакупа
	|ИЗ
	|	ВТДокупитьНаСклад КАК ВТДокупитьНаСклад
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТДокупитьНаЦех КАК ВТДокупитьНаЦех
	|		ПО ВТДокупитьНаСклад.Номенклатура = ВТДокупитьНаЦех.Номенклатура
	|ГДЕ
	|	ЕСТЬNULL(ВТДокупитьНаСклад.Количество, 0) + ЕСТЬNULL(ВТДокупитьНаЦех.Количество, 0) - ЕСТЬNULL(ВТДокупитьНаСклад.ОстатокНаСкладе, 0) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(спрНоменклатура.Ссылка, ВТМатериалыДляЗакупа.Номенклатура) КАК Номенклатура,
	|	ВЫРАЗИТЬ(ВТМатериалыДляЗакупа.Количество / ЕСТЬNULL(спрНоменклатура.КоэффициентБазовых, 1) + 0.4999999999999 КАК ЧИСЛО(15, 0)) КАК Количество,
	|	ВЫБОР
	|		КОГДА ВТМатериалыДляЗакупа.Количество > ВТТребуетсяПоСпецификациям.КоличествоРассчитывается
	|			ТОГДА ВЫРАЗИТЬ((ВТМатериалыДляЗакупа.Количество - ВТТребуетсяПоСпецификациям.КоличествоРассчитывается) / ЕСТЬNULL(спрНоменклатура.КоэффициентБазовых, 1) + 0.4999999999999 КАК ЧИСЛО(15, 0))
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КоличествоСрочно,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная, 0) * ЕСТЬNULL(спрНоменклатура.КоэффициентБазовых, 1) КАК Цена,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Поставщик, """") КАК Поставщик
	|ПОМЕСТИТЬ ВТМатериалыСоСтоимостью
	|ИЗ
	|	ВТМатериалыДляЗакупа КАК ВТМатериалыДляЗакупа
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(, Регион = &Регион) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО ВТМатериалыДляЗакупа.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК спрНоменклатура
	|		ПО ВТМатериалыДляЗакупа.Номенклатура = спрНоменклатура.БазоваяНоменклатура
	|			И (спрНоменклатура.ОсновнаяПоСкладу)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТребуетсяПоСпецификациям КАК ВТТребуетсяПоСпецификациям
	|		ПО ВТМатериалыДляЗакупа.Номенклатура = ВТТребуетсяПоСпецификациям.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТМатериалыСоСтоимостью.Номенклатура КАК Номенклатура,
	|	ВТМатериалыСоСтоимостью.Поставщик,
	|	ВТМатериалыСоСтоимостью.Количество,
	|	ВТМатериалыСоСтоимостью.Количество * ВТМатериалыСоСтоимостью.Цена КАК Стоимость,
	|	ВТМатериалыСоСтоимостью.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВТМатериалыСоСтоимостью.КоличествоСрочно,
	|	ВТМатериалыСоСтоимостью.КоличествоСрочно * ВТМатериалыСоСтоимостью.Цена КАК СтоимостьСрочно
	|ИЗ
	|	ВТМатериалыСоСтоимостью КАК ВТМатериалыСоСтоимостью
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТМатериалыСоСтоимостью.Номенклатура.Родитель.Наименование,
	|	ВТМатериалыСоСтоимостью.Номенклатура.Наименование";
	
	#КонецОбласти
	
	Результат = Запрос.Выполнить();
	Объект.СписокНоменклатуры.Загрузить(Результат.Выгрузить());
	Объект.СуммаДокумента = Объект.СписокНоменклатуры.Итог("Стоимость");
	Объект.СуммаДокументаСрочно = Объект.СписокНоменклатуры.Итог("СтоимостьСрочно");
	
	// Необходимо докупить на склад = Резервный остаток по складу - Остаток на складе (если сумма положительная -- купить, если отрицательная -- у нас запас)
	// Реальный остаток на складе = Остаток в цеху - Базовый лимит цеха (берем только положительные)
	// Необходимо докупить по цеху = Требуется по спецификациям - Реальный остаток на складе (берем только положительные)
	
	// итоговая формула:
	// Оперативный закуп = Необходимо докупить на склад + Необходимо докупить по цеху (берем только положительные)
	
	ПолучитьРасшифровку();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьРасшифровку()
	
	Если Объект.Подразделение.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпецификацияСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СУММА(СпецификацияСписокНоменклатуры.Количество) КАК Количество,
	|	СтатусСпецификацииСрезПоследних.Статус,
	|	СпецификацияСписокНоменклатуры.Ссылка,
	|	СпецификацияСписокНоменклатуры.Ссылка.ДатаИзготовления,
	|	ВЫБОР
	|		КОГДА Комплектация.Ссылка ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Скомплектован
	|ПОМЕСТИТЬ Список
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО СпецификацияСписокНоменклатуры.Ссылка = СтатусСпецификацииСрезПоследних.Спецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Комплектация КАК Комплектация
	|		ПО СпецификацияСписокНоменклатуры.Ссылка = Комплектация.Спецификация
	|ГДЕ
	|	СтатусСпецификацииСрезПоследних.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Рассчитывается), ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен), ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ПереданВЦех))
	|	И СпецификацияСписокНоменклатуры.Ссылка.Производство = &Подразделение
	|	И СпецификацияСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Номенклатура,
	|	СтатусСпецификацииСрезПоследних.Статус,
	|	СпецификацияСписокНоменклатуры.Ссылка,
	|	ВЫБОР
	|		КОГДА Комплектация.Ссылка ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	СпецификацияСписокНоменклатуры.Ссылка.ДатаИзготовления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА спрНоменклатура.Ссылка <> НЕОПРЕДЕЛЕНО
	|			ТОГДА спрНоменклатура.Ссылка
	|		ИНАЧЕ Список.Номенклатура
	|	КОНЕЦ КАК Номенклатура,
	|	Список.Количество,
	|	Список.Ссылка КАК Спецификация,
	|	Список.Статус,
	|	Список.ДатаИзготовления,
	|	Список.Скомплектован
	|ИЗ
	|	Список КАК Список
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК спрНоменклатура
	|		ПО (спрНоменклатура.ОсновнаяПоСкладу)
	|			И Список.Номенклатура = спрНоменклатура.БазоваяНоменклатура";
	
	Результат = Запрос.Выполнить();
	ТаблицаРасшифровки.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ЗаполнитьНаСервере();
		
	КонецЕсли;
	
	ПолучитьРасшифровку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ЗаполнитьНаСервере();
		
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПриАктивизацииСтроки(Элемент)
	
	Данные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	
	Если Данные <> Неопределено Тогда
		Номенклатура = Данные.Номенклатура;
		Если ЗначениеЗаполнено(Номенклатура) Тогда
			ОтборСтрок = Новый ФиксированнаяСтруктура("Номенклатура", Номенклатура);
		Иначе
			ОтборСтрок = Новый ФиксированнаяСтруктура("Номенклатура", ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
		КонецЕсли;
		Элементы.ТаблицаРасшифровки.ОтборСтрок = ОтборСтрок;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры
