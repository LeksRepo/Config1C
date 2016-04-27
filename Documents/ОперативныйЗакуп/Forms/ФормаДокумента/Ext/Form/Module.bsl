﻿
&НаКлиенте
Процедура ТаблицаРасшифровкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.ТаблицаРасшифровки.ТекущиеДанные.Спецификация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаполнитьНаСервере()
	
	Если Объект.СписокНоменклатуры.Количество() > 0 Тогда
		
		Ответ = Вопрос("Данные введенные вручную будут утеряны. Продолжить?",РежимДиалогаВопрос.ДаНет);
		
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьНаСервере();
	Объект.СуммаДокумента = 0;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Объект.Подразделение.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ОсновнойСклад = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Подразделение, "ОсновнойСклад");
	
	#Область Запрос
	
	Если ЗначениеЗаполнено(Объект.Дата) Тогда
		ДеньВыборки = Объект.Дата;
	Иначе
		ДеньВыборки = ТекущаяДата();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("ТекущаяДата", ДеньВыборки);
	Запрос.УстановитьПараметр("Склад", ОсновнойСклад);
	Запрос.УстановитьПараметр("ТекущийДокумент", Объект.Ссылка);
	Запрос.УстановитьПараметр("Поставщик", Объект.Поставщик);
	
	Наряды = Объект.НарядЗадания.Выгрузить(Неопределено, "Наряд"); 
	Запрос.УстановитьПараметр("НарядЗадания", ?(Наряды.Количество()>0, Наряды, NULL));
	
	Запрос.УстановитьПараметр("ТекущийДокумент", Объект.Ссылка);
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Спец.Ссылка КАК СпецификацияСсылка
	|ПОМЕСТИТЬ втСпецификации
	|ИЗ
	|	Документ.Спецификация КАК Спец
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НарядЗадание.СписокСпецификаций КАК Наряд
	|		ПО Спец.Ссылка = Наряд.Спецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпец
	|		ПО Спец.Ссылка = СтатусСпец.Спецификация
	|ГДЕ
	|	ВЫБОР
	|			КОГДА НЕ &НарядЗадания ЕСТЬ NULL 
	|				ТОГДА Наряд.Ссылка В (&НарядЗадания)
	|			ИНАЧЕ СтатусСпец.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен), ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ПереданВЦех))
	|					И Спец.Подразделение = &Подразделение
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Список.Номенклатура КАК Номенклатура,
	|	СУММА(Список.КоличествоАвансовый + Список.КоличествоПоставщик) КАК Количество
	|ПОМЕСТИТЬ номОперЗакупы
	|ИЗ
	|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК Список
	|ГДЕ
	|	Список.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&ТекущаяДата, ДЕНЬ) И КОНЕЦПЕРИОДА(&ТекущаяДата, ДЕНЬ)
	|	И ВЫБОР
	|			КОГДА &ТекущийДокумент <> ЗНАЧЕНИЕ(Документ.ОперативныйЗакуп.ПустаяСсылка)
	|				ТОГДА Список.Ссылка <> &ТекущийДокумент
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И (Список.КоличествоАвансовый > 0
	|			ИЛИ Список.КоличествоПоставщик > 0)
	|	И Список.Ссылка.Подразделение = &Подразделение
	|
	|СГРУППИРОВАТЬ ПО
	|	Список.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА УправленческийОстатки.Субконто2 ЕСТЬ NULL 
	|			ТОГДА ОперЗакупы.Номенклатура
	|		ИНАЧЕ УправленческийОстатки.Субконто2
	|	КОНЕЦ КАК Номенклатура,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоРазвернутыйОстатокДт, 0) + ЕСТЬNULL(ОперЗакупы.Количество, 0) КАК Количество
	|ПОМЕСТИТЬ втОстаткиРегистр
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|			,
	|			Подразделение = &Подразделение
	|				И Субконто1 = &Склад) КАК УправленческийОстатки
	|		ПОЛНОЕ СОЕДИНЕНИЕ номОперЗакупы КАК ОперЗакупы
	|		ПО ((ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Справочник.Номенклатура)) = ОперЗакупы.Номенклатура)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА втОстаткиРегистр.Номенклатура.Базовый
	|			ТОГДА втОстаткиРегистр.Номенклатура
	|		ИНАЧЕ втОстаткиРегистр.Номенклатура.БазоваяНоменклатура
	|	КОНЕЦ КАК Номенклатура,
	|	СУММА(ВЫБОР
	|			КОГДА втОстаткиРегистр.Номенклатура.Базовый
	|				ТОГДА втОстаткиРегистр.Количество
	|			ИНАЧЕ втОстаткиРегистр.Количество * втОстаткиРегистр.Номенклатура.КоэффициентБазовых
	|		КОНЕЦ) КАК Количество
	|ПОМЕСТИТЬ втОстаткиНаСкладе
	|ИЗ
	|	втОстаткиРегистр КАК втОстаткиРегистр
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА втОстаткиРегистр.Номенклатура.Базовый
	|			ТОГДА втОстаткиРегистр.Номенклатура
	|		ИНАЧЕ втОстаткиРегистр.Номенклатура.БазоваяНоменклатура
	|	КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РезервныйЗапас.Номенклатура КАК Номенклатура,
	|	РезервныйЗапас.Количество КАК Количество
	|ПОМЕСТИТЬ втРезервныйЗапас
	|ИЗ
	|	РегистрСведений.РезервныйЗапасМатериалов.СрезПоследних(
	|			,
	|			Подразделение = &Подразделение
	|				И Склад = &Склад) КАК РезервныйЗапас
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТРезервныйЗапас.Номенклатура КАК Номенклатура,
	|	ВТРезервныйЗапас.Количество КАК Количество
	|ПОМЕСТИТЬ втДокупитьНаСклад
	|ИЗ
	|	втРезервныйЗапас КАК ВТРезервныйЗапас
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстаткиНаСкладе КАК ВТОстаткиНаСкладе
	|		ПО (ВТОстаткиНаСкладе.Номенклатура = ВТРезервныйЗапас.Номенклатура)
	|ГДЕ
	|	ЕСТЬNULL(ВТОстаткиНаСкладе.Количество, 0) < ВТРезервныйЗапас.Количество
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпецификацияСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СУММА(СпецификацияСписокНоменклатуры.Количество) КАК КоличествоВсегоТребуется,
	|	СУММА(ВЫБОР
	|			КОГДА СтатусСпецификацииСрезПоследних.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен), ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ПереданВЦех))
	|				ТОГДА СпецификацияСписокНоменклатуры.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоСрочно
	|ПОМЕСТИТЬ втТребуетсяПоСпецификациям
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО СпецификацияСписокНоменклатуры.Ссылка = СтатусСпецификацииСрезПоследних.Спецификация
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В
	|			(ВЫБРАТЬ
	|				т.СпецификацияСсылка
	|			ИЗ
	|				втСпецификации КАК т)
	|	И СпецификацияСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|	И НЕ СпецификацияСписокНоменклатуры.ПредоставитЗаказчик
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
	|	ВТТребуетсяПоСпецификациям.КоличествоВсегоТребуется - ЕСТЬNULL(ВТОстаткиНаСкладе.Количество, 0) КАК Количество
	|ПОМЕСТИТЬ втДокупитьНаЦех
	|ИЗ
	|	втТребуетсяПоСпецификациям КАК ВТТребуетсяПоСпецификациям
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстаткиНаСкладе КАК ВТОстаткиНаСкладе
	|		ПО ВТТребуетсяПоСпецификациям.Номенклатура = ВТОстаткиНаСкладе.Номенклатура
	|ГДЕ
	|	ВТТребуетсяПоСпецификациям.КоличествоВсегоТребуется - ЕСТЬNULL(ВТОстаткиНаСкладе.Количество, 0) > 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ВТДокупитьНаСклад.Номенклатура, ВТДокупитьНаЦех.Номенклатура) КАК Номенклатура,
	|	ЕСТЬNULL(ВТДокупитьНаСклад.Количество, 0) + ЕСТЬNULL(ВТДокупитьНаЦех.Количество, 0) КАК Количество,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ВТДокупитьНаСклад.Количество, 0) > 0
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СработалРезерв
	|ПОМЕСТИТЬ втМатериалыДляЗакупа
	|ИЗ
	|	втДокупитьНаСклад КАК ВТДокупитьНаСклад
	|		ПОЛНОЕ СОЕДИНЕНИЕ втДокупитьНаЦех КАК ВТДокупитьНаЦех
	|		ПО ВТДокупитьНаСклад.Номенклатура = ВТДокупитьНаЦех.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА НомПодразделений.ОсновнаяПоСкладу ЕСТЬ NULL 
	|				ИЛИ НомПодразделений.ОсновнаяПоСкладу = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			ТОГДА втМатериалыДляЗакупа.Номенклатура
	|		ИНАЧЕ НомПодразделений.ОсновнаяПоСкладу
	|	КОНЕЦ КАК Номенклатура,
	|	ВЫРАЗИТЬ(втМатериалыДляЗакупа.Количество / ЕСТЬNULL(НомПодразделений.ОсновнаяПоСкладу.КоэффициентБазовых, 1) + 0.49999 КАК ЧИСЛО(15, 0)) КАК Количество,
	|	ВЫБОР
	|		КОГДА втТребуетсяПоСпецификациям.КоличествоСрочно > 0
	|			ТОГДА ВЫБОР
	|					КОГДА втТребуетсяПоСпецификациям.КоличествоСрочно < втМатериалыДляЗакупа.Количество
	|						ТОГДА ВЫРАЗИТЬ(втТребуетсяПоСпецификациям.КоличествоСрочно / ЕСТЬNULL(НомПодразделений.ОсновнаяПоСкладу.КоэффициентБазовых, 1) + 0.49999 КАК ЧИСЛО(15, 0))
	|					ИНАЧЕ ВЫРАЗИТЬ(втМатериалыДляЗакупа.Количество / ЕСТЬNULL(НомПодразделений.ОсновнаяПоСкладу.КоэффициентБазовых, 1) + 0.49999 КАК ЧИСЛО(15, 0))
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КоличествоСрочно,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная, 0) * ЕСТЬNULL(НомПодразделений.ОсновнаяПоСкладу.КоэффициентБазовых, 1) КАК Цена,
	|	втМатериалыДляЗакупа.СработалРезерв,
	|	ЦеныНоменклатурыСрезПоследних.Поставщик
	|ПОМЕСТИТЬ втМатериалыСоСтоимостью
	|ИЗ
	|	втМатериалыДляЗакупа КАК втМатериалыДляЗакупа
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(, Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО втМатериалыДляЗакупа.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений.СрезПоследних(&Период, Подразделение = &Подразделение) КАК НомПодразделений
	|		ПО втМатериалыДляЗакупа.Номенклатура = НомПодразделений.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ втТребуетсяПоСпецификациям КАК втТребуетсяПоСпецификациям
	|		ПО втМатериалыДляЗакупа.Номенклатура = втТребуетсяПоСпецификациям.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТМатериалыСоСтоимостью.Номенклатура КАК Номенклатура,
	|	ВТМатериалыСоСтоимостью.Цена,
	|	ВТМатериалыСоСтоимостью.Количество,
	|	ВТМатериалыСоСтоимостью.КоличествоСрочно,
	|	ВТМатериалыСоСтоимостью.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	НоменклатураПодразделений.ЗакупОптом КАК ЗакупОптом,
	|	ВТМатериалыСоСтоимостью.СработалРезерв,
	|	ВТМатериалыСоСтоимостью.Поставщик,
	|	НоменклатураПодразделений.ПодЗаказ
	|ПОМЕСТИТЬ втПолныйНаборДанных
	|ИЗ
	|	втМатериалыСоСтоимостью КАК ВТМатериалыСоСтоимостью
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений.СрезПоследних(&Период, Подразделение = &Подразделение) КАК НоменклатураПодразделений
	|		ПО (ВЫБОР
	|				КОГДА ВТМатериалыСоСтоимостью.Номенклатура.Базовый
	|					ТОГДА ВТМатериалыСоСтоимостью.Номенклатура = НоменклатураПодразделений.Номенклатура
	|				ИНАЧЕ ВТМатериалыСоСтоимостью.Номенклатура.БазоваяНоменклатура = НоменклатураПодразделений.Номенклатура
	|			КОНЕЦ)
	|ГДЕ
	|	НЕ НоменклатураПодразделений.ПодЗаказ
	|	И ВЫБОР
	|			КОГДА &Поставщик = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ &Поставщик = ВТМатериалыСоСтоимостью.Поставщик
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таб.Номенклатура КАК Номенклатура,
	|	Таб.Цена,
	|	Таб.Количество,
	|	Таб.КоличествоСрочно,
	|	Таб.ЕдиницаИзмерения,
	|	Таб.ЗакупОптом,
	|	Таб.СработалРезерв,
	|	Таб.Поставщик КАК Поставщик,
	|	Таб.ПодЗаказ
	|ИЗ
	|	втПолныйНаборДанных КАК Таб
	|
	|УПОРЯДОЧИТЬ ПО
	|	Поставщик,
	|	Номенклатура";
	
	#КонецОбласти
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	Объект.СписокНоменклатуры.Загрузить(ТЗ);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Поставщик", Объект.Поставщик);
	
	Наряды = Объект.НарядЗадания.Выгрузить(Неопределено, "Наряд"); 
	Запрос.УстановитьПараметр("НарядЗадания", ?(Наряды.Количество()>0, Наряды, NULL));
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Спец.Ссылка КАК СпецификацияСсылка
	|ПОМЕСТИТЬ втСпецификации
	|ИЗ
	|	Документ.Спецификация КАК Спец
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НарядЗадание.СписокСпецификаций КАК Наряд
	|		ПО Спец.Ссылка = Наряд.Спецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпец
	|		ПО Спец.Ссылка = СтатусСпец.Спецификация
	|ГДЕ
	|	ВЫБОР
	|			КОГДА НЕ &НарядЗадания ЕСТЬ NULL 
	|				ТОГДА Наряд.Ссылка В (&НарядЗадания)
	|			ИНАЧЕ СтатусСпец.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен), ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ПереданВЦех))
	|					И Спец.Подразделение = &Подразделение
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА НомПодразделений.ОсновнаяПоСкладу ЕСТЬ NULL 
	|				ИЛИ НомПодразделений.ОсновнаяПоСкладу = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			ТОГДА Спец.Номенклатура
	|		ИНАЧЕ НомПодразделений.ОсновнаяПоСкладу
	|	КОНЕЦ КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА НомПодразделений.ОсновнаяПоСкладу ЕСТЬ NULL 
	|				ИЛИ НомПодразделений.ОсновнаяПоСкладу = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			ТОГДА Спец.Номенклатура.КоэффициентБазовых
	|		ИНАЧЕ НомПодразделений.ОсновнаяПоСкладу.КоэффициентБазовых
	|	КОНЕЦ КАК Коэффициент,
	|	Спец.Количество,
	|	Спец.Цена,
	|	Спец.Поставщик,
	|	Спец.Ссылка КАК Спецификация,
	|	Спец.Комментарий,
	|	Остатки.Количество КАК ОстаткиНаСкладе
	|ПОМЕСТИТЬ втМатериалы
	|ИЗ
	|	Документ.Спецификация.СписокМатериаловПодЗаказ КАК Спец
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений.СрезПоследних(&Период, Подразделение = &Подразделение) КАК НомПодразделений
	|		ПО Спец.Номенклатура = НомПодразделений.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ВЫБОР
	|				КОГДА УпрОстатки.Субконто2.Базовый
	|					ТОГДА УпрОстатки.Субконто2
	|				ИНАЧЕ УпрОстатки.Субконто2.БазоваяНоменклатура
	|			КОНЕЦ КАК Номенклатура,
	|			СУММА(ВЫБОР
	|					КОГДА УпрОстатки.Субконто2.Базовый
	|						ТОГДА УпрОстатки.КоличествоОстаток
	|					ИНАЧЕ УпрОстатки.КоличествоОстаток * УпрОстатки.Субконто2.КоэффициентБазовых
	|				КОНЕЦ) КАК Количество
	|		ИЗ
	|			РегистрБухгалтерии.Управленческий.Остатки(
	|					&Период,
	|					Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|					,
	|					Субконто1.ОсновнойСклад = ИСТИНА
	|						И Подразделение = &Подразделение) КАК УпрОстатки
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ВЫБОР
	|				КОГДА УпрОстатки.Субконто2.Базовый
	|					ТОГДА УпрОстатки.Субконто2
	|				ИНАЧЕ УпрОстатки.Субконто2.БазоваяНоменклатура
	|			КОНЕЦ) КАК Остатки
	|		ПО Спец.Номенклатура = Остатки.Номенклатура
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &Поставщик <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|				ТОГДА Спец.Поставщик = &Поставщик
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И Спец.Ссылка В
	|			(ВЫБРАТЬ
	|				т.СпецификацияСсылка
	|			ИЗ
	|				втСпецификации КАК т)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Материалы.Номенклатура КАК Номенклатура,
	|	Материалы.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВЫРАЗИТЬ(Материалы.Количество / Материалы.Коэффициент + 0.4999 КАК ЧИСЛО(15, 0)) КАК Количество,
	|	ВЫРАЗИТЬ(Материалы.Цена * Материалы.Коэффициент КАК ЧИСЛО(15, 0)) КАК Цена,
	|	Материалы.Поставщик,
	|	Материалы.Спецификация,
	|	Материалы.Комментарий,
	|	Материалы.ОстаткиНаСкладе / Материалы.Коэффициент КАК ОстаткиНаСкладе
	|ИЗ
	|	втМатериалы КАК Материалы
	|
	|УПОРЯДОЧИТЬ ПО
	|	Материалы.Номенклатура.Наименование";
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	Объект.НоменклатураПодЗаказ.Загрузить(ТЗ);	
	
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
	
	Наряды = Объект.НарядЗадания.Выгрузить(Неопределено, "Наряд"); 
	Запрос.УстановитьПараметр("НарядЗадания", ?(Наряды.Количество()>0, Наряды, NULL));
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Спец.Ссылка КАК СпецификацияСсылка
	|ПОМЕСТИТЬ втСпецификации
	|ИЗ
	|	Документ.Спецификация КАК Спец
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НарядЗадание.СписокСпецификаций КАК Наряд
	|		ПО Спец.Ссылка = Наряд.Спецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпец
	|		ПО Спец.Ссылка = СтатусСпец.Спецификация
	|ГДЕ
	|	ВЫБОР
	|			КОГДА НЕ &НарядЗадания ЕСТЬ NULL 
	|				ТОГДА Наряд.Ссылка В (&НарядЗадания)
	|			ИНАЧЕ СтатусСпец.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен), ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ПереданВЦех))
	|					И Спец.Подразделение = &Подразделение
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпецификацияСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СУММА(СпецификацияСписокНоменклатуры.Количество) КАК Количество,
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
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Комплектация КАК Комплектация
	|		ПО СпецификацияСписокНоменклатуры.Ссылка = Комплектация.Спецификация
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В
	|			(ВЫБРАТЬ
	|				т.СпецификацияСсылка
	|			ИЗ
	|				втСпецификации КАК т)
	|	И СпецификацияСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Номенклатура,
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
	|		КОГДА НомПодразделений.ОсновнаяПоСкладу ЕСТЬ NULL 
	|				ИЛИ НомПодразделений.ОсновнаяПоСкладу = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			ТОГДА Список.Номенклатура
	|		ИНАЧЕ НомПодразделений.ОсновнаяПоСкладу
	|	КОНЕЦ КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА Список.Номенклатура.Базовый
	|			ТОГДА Список.Номенклатура
	|		ИНАЧЕ Список.Номенклатура.БазоваяНоменклатура
	|	КОНЕЦ КАК БазоваяНом,
	|	Список.Количество,
	|	Список.Ссылка КАК Спецификация,
	|	Список.ДатаИзготовления,
	|	Список.Скомплектован
	|ИЗ
	|	Список КАК Список
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений.СрезПоследних(&Период, Подразделение = &Подразделение) КАК НомПодразделений
	|		ПО Список.Номенклатура = НомПодразделений.Номенклатура";
	
	Результат = Запрос.Выполнить();
	ТаблицаРасшифровки.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ПередЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	ПередЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПриАктивизацииСтроки(Элемент)
	
	УстановитьОтборРасшифровки();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	//RonEXI: Разрешить добавление руками. Лайн Д.В 18 апреля 2016
	//Отказ = Истина;
	Заглушка = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПодЗаказПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПодЗаказПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставщикПриИзменении(Элемент)
	
	ПередЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыКоличествоАваносвыйПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	ТекущиеДанные.Стоимость = ТекущиеДанные.Цена * ТекущиеДанные.КоличествоАвансовый;
	
	Объект.СуммаДокумента = Объект.СписокНоменклатуры.Итог("Стоимость") + Объект.НоменклатураПодЗаказ.Итог("Стоимость")
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПолучитьРасшифровку();
	УстановитьОтборРасшифровки();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоступлениеМатериаловУслуг(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	Контрагенты = ОпределитьКонтрагента();
	КонтрагентПоступления = Неопределено;
	
	Если Контрагенты.Количество() = 1 Тогда
		
		КонтрагентПоступления = Контрагенты[0];
		
	Иначе
		
		СписокКонтрагентов = Новый СписокЗначений;
		СписокКонтрагентов.ЗагрузитьЗначения(Контрагенты);
		ВыбЭлемент = СписокКонтрагентов.ВыбратьЭлемент("Выберите контрагента");
		Если ВыбЭлемент <> Неопределено Тогда
			КонтрагентПоступления = ВыбЭлемент.Значение;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КонтрагентПоступления) Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Контрагент", КонтрагентПоступления);
		ДополнительныеПараметры.Вставить("Ссылка", Объект.Ссылка);
		
		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("Основание", ДополнительныеПараметры);
		
		ОткрытьФорму("Документ.ПоступлениеМатериаловУслуг.ФормаОбъекта", ДанныеЗаполнения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОпределитьКонтрагента()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Таб.Поставщик КАК Контрагент
	|ПОМЕСТИТЬ вТаб
	|ИЗ
	|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК Таб
	|ГДЕ
	|	Таб.КоличествоПоставщик > 0
	|	И Таб.Поставщик <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	И Таб.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Таб.Поставщик КАК Контрагент
	|ИЗ
	|	Документ.ОперативныйЗакуп.НоменклатураПодЗаказ КАК Таб
	|ГДЕ
	|	Таб.КоличествоПоставщик > 0
	|	И Таб.Поставщик <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	И Таб.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Т.Контрагент КАК Контрагент
	|ИЗ
	|	вТаб КАК Т";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Контрагент");
	
КонецФункции

&НаКлиенте
Процедура НоменклатураПодЗаказПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПодЗаказПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПодЗаказПриАктивизацииСтроки(Элемент)
	
	УстановитьОтборРасшифровки();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборРасшифровки()
	
	ПодЗаказ = Ложь;
	
	Если Элементы.ГруппаТаблицы.ТекущаяСтраница.Имя = "ГруппаСтраницаПодЗаказ" Тогда
		Данные = Элементы.НоменклатураПодЗаказ.ТекущиеДанные;
		ПодЗаказ = Истина;
	ИначеЕсли Элементы.ГруппаТаблицы.ТекущаяСтраница.Имя = "ГруппаСтраницаСписокНоменклатуры" Тогда
		Данные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	КонецЕсли;
	
	Если Данные <> Неопределено Тогда
		
		НомДанные = ДанныеНоменклатуры(Данные.Номенклатура);
		НомСсылка = Данные.Номенклатура;
		
		Если НЕ НомДанные.Базовый Тогда
			НомСсылка = НомДанные.БазоваяНоменклатура;	
		Иначе
			
		КонецЕсли;
		
		Если ПодЗаказ Тогда
			ОтборСтрок = Новый ФиксированнаяСтруктура("Спецификация, БазоваяНом", Данные.Спецификация, НомСсылка);
		Иначе
			ОтборСтрок = Новый ФиксированнаяСтруктура("Номенклатура", НомСсылка);
		КонецЕсли;
		
	Иначе
		
		ОтборСтрок = Новый ФиксированнаяСтруктура("Номенклатура", ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
		
	КонецЕсли;
	
	Элементы.ТаблицаРасшифровки.ОтборСтрок = ОтборСтрок;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеНоменклатуры(Ссылка)
	
	Стр = Новый Структура;
	Стр.Вставить("Базовый",Ссылка.Базовый);
	Стр.Вставить("БазоваяНоменклатура",Ссылка.БазоваяНоменклатура);
	
	Возврат Стр;
	
КонецФункции

&НаКлиенте
Процедура НоменклатураПодЗаказКоличествоКупитьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.НоменклатураПодЗаказ.ТекущиеДанные;
	ТекущиеДанные.Стоимость = ТекущиеДанные.Цена * ТекущиеДанные.КоличествоКупить;
	
	Объект.СуммаДокумента = Объект.СписокНоменклатуры.Итог("Стоимость") + Объект.НоменклатураПодЗаказ.Итог("Стоимость")
	
КонецПроцедуры

&НаКлиенте
Процедура НарядЗаданияНарядПриИзменении(Элемент)
	ПередЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ГруппаТаблицыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УстановитьОтборРасшифровки();
		
КонецПроцедуры
