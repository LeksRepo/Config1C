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
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Склад", СвойстваПодразделения.ОсновнойСклад);
	Запрос.УстановитьПараметр("Регион", СвойстваПодразделения.Регион);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА УправленческийОстатки.Субконто2.Базовый
	|			ТОГДА УправленческийОстатки.Субконто2
	|		ИНАЧЕ УправленческийОстатки.Субконто2.БазоваяНоменклатура
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
	|			Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.Логистика)
	|				И Субконто1 = &Склад) КАК УправленческийОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА УправленческийОстатки.Субконто2.Базовый
	|			ТОГДА УправленческийОстатки.Субконто2
	|		ИНАЧЕ УправленческийОстатки.Субконто2.БазоваяНоменклатура
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
	|			Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.Логистика)
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
	|	ЕСТЬNULL(ВТРезервныйЗапас.Количество, 0) - ЕСТЬNULL(ВТОстаткиНаСкладе.Количество, 0) КАК Количество,
	|	ЕСТЬNULL(ВТРезервныйЗапас.Количество, 0) КАК КоличествоРезервный,
	|	ЕСТЬNULL(ВТОстаткиНаСкладе.Количество, 0) КАК КоличествоНаСкладе
	|ПОМЕСТИТЬ ВТДокупитьНаСклад
	|ИЗ
	|	ВТОстаткиНаСкладе КАК ВТОстаткиНаСкладе
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТРезервныйЗапас КАК ВТРезервныйЗапас
	|		ПО ВТОстаткиНаСкладе.Номенклатура = ВТРезервныйЗапас.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА БазовыйЛимитЦехаСрезПоследних.Номенклатура ЕСТЬ NULL 
	|			ТОГДА УправленческийОстатки.Субконто1
	|		ИНАЧЕ БазовыйЛимитЦехаСрезПоследних.Номенклатура
	|	КОНЕЦ КАК Номенклатура,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстатокДт, 0) - ЕСТЬNULL(БазовыйЛимитЦехаСрезПоследних.Количество, 0) КАК Количество,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстатокДт, 0) КАК ОстатокПоЦеху,
	|	ЕСТЬNULL(БазовыйЛимитЦехаСрезПоследних.Количество, 0) КАК БазовыйЛимит
	|ПОМЕСТИТЬ ВТЦеховыеОстатки
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ОсновноеПроизводство), , Подразделение = &Подразделение) КАК УправленческийОстатки
	|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.БазовыйЛимитЦеха.СрезПоследних(, Подразделение = &Подразделение) КАК БазовыйЛимитЦехаСрезПоследних
	|		ПО УправленческийОстатки.Субконто1 = БазовыйЛимитЦехаСрезПоследних.Номенклатура
	|ГДЕ
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстатокДт, 0) - ЕСТЬNULL(БазовыйЛимитЦехаСрезПоследних.Количество, 0) > 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпецификацияСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СУММА(СпецификацияСписокНоменклатуры.Количество) КАК Количество
	|ПОМЕСТИТЬ ВТТребуетсяПоСпецификациям
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО СпецификацияСписокНоменклатуры.Ссылка = СтатусСпецификацииСрезПоследних.Спецификация
	|ГДЕ
	|	СтатусСпецификацииСрезПоследних.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Рассчитывается), ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен), ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ПереданВЦех))
	|	И СпецификацияСписокНоменклатуры.Ссылка.Производство = &Подразделение
	|	И СпецификацияСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
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
	|	ЕСТЬNULL(ВТТребуетсяПоСпецификациям.Количество, 0) - ЕСТЬNULL(ВТЦеховыеОстатки.Количество, 0) КАК Количество,
	|	ЕСТЬNULL(ВТТребуетсяПоСпецификациям.Количество, 0) КАК КоличествоТребуеться,
	|	ЕСТЬNULL(ВТЦеховыеОстатки.Количество, 0) КАК РеальныйОстатокНаСкладе,
	|	ВТЦеховыеОстатки.ОстатокПоЦеху,
	|	ВТЦеховыеОстатки.БазовыйЛимит
	|ПОМЕСТИТЬ ВТДокупитьНаЦех
	|ИЗ
	|	ВТТребуетсяПоСпецификациям КАК ВТТребуетсяПоСпецификациям
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЦеховыеОстатки КАК ВТЦеховыеОстатки
	|		ПО ВТТребуетсяПоСпецификациям.Номенклатура = ВТЦеховыеОстатки.Номенклатура
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
	|	ВТДокупитьНаСклад.КоличествоРезервный,
	|	ВТДокупитьНаСклад.КоличествоНаСкладе,
	|	ВТДокупитьНаЦех.КоличествоТребуеться,
	|	ВТДокупитьНаЦех.РеальныйОстатокНаСкладе,
	|	ЕСТЬNULL(ВТДокупитьНаСклад.Количество, 0) + ЕСТЬNULL(ВТДокупитьНаЦех.Количество, 0) КАК Количество,
	|	ВТДокупитьНаЦех.ОстатокПоЦеху,
	|	ВТДокупитьНаЦех.БазовыйЛимит,
	|	ВТДокупитьНаСклад.Количество КАК ДокупитьНаСкладе,
	|	ВТДокупитьНаЦех.Количество КАК ДокупитьВЦех
	|ПОМЕСТИТЬ ВТМатериалыДляЗакупа
	|ИЗ
	|	ВТДокупитьНаСклад КАК ВТДокупитьНаСклад
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТДокупитьНаЦех КАК ВТДокупитьНаЦех
	|		ПО ВТДокупитьНаСклад.Номенклатура = ВТДокупитьНаЦех.Номенклатура
	|ГДЕ
	|	ЕСТЬNULL(ВТДокупитьНаСклад.Количество, 0) + ЕСТЬNULL(ВТДокупитьНаЦех.Количество, 0) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТМатериалыДляЗакупа.Номенклатура КАК Номенклатура,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная, 0) КАК ПлановаяЦена,
	|	ВТМатериалыДляЗакупа.КоличествоТребуеться,
	|	ВТМатериалыДляЗакупа.РеальныйОстатокНаСкладе,
	|	ВТМатериалыДляЗакупа.Количество,
	|	ВТМатериалыДляЗакупа.КоличествоНаСкладе,
	|	ВТМатериалыДляЗакупа.КоличествоРезервный,
	|	ВТМатериалыДляЗакупа.ОстатокПоЦеху,
	|	ВТМатериалыДляЗакупа.БазовыйЛимит,
	|	ВТМатериалыДляЗакупа.ДокупитьНаСкладе,
	|	ВТМатериалыДляЗакупа.ДокупитьВЦех,
	|	ЦеныНоменклатурыСрезПоследних.Поставщик
	|ПОМЕСТИТЬ ВТМатериалыСоСтоимостью
	|ИЗ
	|	ВТМатериалыДляЗакупа КАК ВТМатериалыДляЗакупа
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(, Регион = &Регион) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО ВТМатериалыДляЗакупа.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СпрНоменклатура.Ссылка, ВТМатериалыСоСтоимостью.Номенклатура) КАК Номенклатура,
	|	ЕСТЬNULL(СпрНоменклатура.ЕдиницаИзмерения, ВТМатериалыСоСтоимостью.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмерения,
	|	ВЫРАЗИТЬ(ВТМатериалыСоСтоимостью.Количество / ЕСТЬNULL(СпрНоменклатура.КоэффициентБазовых, 1) + 0.4999999999999 КАК ЧИСЛО(15, 0)) КАК Количество,
	|	(ВЫРАЗИТЬ(ВТМатериалыСоСтоимостью.Количество / ЕСТЬNULL(СпрНоменклатура.КоэффициентБазовых, 1) + 0.4999999999999 КАК ЧИСЛО(15, 0))) * ВТМатериалыСоСтоимостью.ПлановаяЦена * ЕСТЬNULL(СпрНоменклатура.КоэффициентБазовых, 1) КАК Стоимость,
	|	ВТМатериалыСоСтоимостью.КоличествоРезервный,
	|	ВТМатериалыСоСтоимостью.КоличествоНаСкладе,
	|	ВТМатериалыСоСтоимостью.ОстатокПоЦеху,
	|	ВТМатериалыСоСтоимостью.БазовыйЛимит,
	|	ВТМатериалыСоСтоимостью.КоличествоТребуеться,
	|	ВТМатериалыСоСтоимостью.РеальныйОстатокНаСкладе,
	|	ВТМатериалыСоСтоимостью.ДокупитьНаСкладе,
	|	ВТМатериалыСоСтоимостью.ДокупитьВЦех,
	|	ЕСТЬNULL(СпрНоменклатура.КоэффициентБазовых, 1) КАК Коэффициент,
	|	ВТМатериалыСоСтоимостью.Поставщик
	|ИЗ
	|	ВТМатериалыСоСтоимостью КАК ВТМатериалыСоСтоимостью
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО ВТМатериалыСоСтоимостью.Номенклатура = СпрНоменклатура.БазоваяНоменклатура
	|			И (СпрНоменклатура.ОсновнаяПоСкладу)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТМатериалыСоСтоимостью.Номенклатура.Родитель.Наименование,
	|	ВТМатериалыСоСтоимостью.Номенклатура.Наименование";
	#КонецОбласти
	
	Результат = Запрос.Выполнить();
	Объект.СписокНоменклатуры.Загрузить(Результат.Выгрузить());
	Объект.СуммаДокумента = Объект.СписокНоменклатуры.Итог("Стоимость");
	
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
