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
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("НарядЗадание", Объект.НарядЗадание);
	Запрос.УстановитьПараметр("Склад", ОсновнойСклад);
	Запрос.УстановитьПараметр("Поставщик", Объект.Поставщик);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.Субконто2 КАК Номенклатура,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Справочник.Номенклатура).МатериалЗаказчика КАК МатериалЗаказчика,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Справочник.Номенклатура).Базовый КАК Базовый,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Справочник.Номенклатура).БазоваяНоменклатура КАК БазоваяНоменклатура,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Справочник.Номенклатура).КоэффициентБазовых КАК КоэффициентБазовых,
	|	УправленческийОстатки.КоличествоРазвернутыйОстатокДт КАК Количество
	|ПОМЕСТИТЬ втОстаткиРегистр
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|			,
	|			Подразделение = &Подразделение
	|				И Субконто1 = &Склад) КАК УправленческийОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НарядЗаданиеСписокСпецификаций.Спецификация КАК СпецификацияСсылка
	|ПОМЕСТИТЬ втСпецификации
	|ИЗ
	|	Документ.НарядЗадание.СписокСпецификаций КАК НарядЗаданиеСписокСпецификаций
	|ГДЕ
	|	НарядЗаданиеСписокСпецификаций.Ссылка = &НарядЗадание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА втОстаткиРегистр.Базовый
	|			ТОГДА втОстаткиРегистр.Номенклатура
	|		ИНАЧЕ втОстаткиРегистр.БазоваяНоменклатура
	|	КОНЕЦ КАК Номенклатура,
	|	СУММА(ВЫБОР
	|			КОГДА втОстаткиРегистр.Базовый
	|				ТОГДА втОстаткиРегистр.Количество
	|			ИНАЧЕ втОстаткиРегистр.Количество * втОстаткиРегистр.КоэффициентБазовых
	|		КОНЕЦ) КАК Количество
	|ПОМЕСТИТЬ втОстаткиНаСкладе
	|ИЗ
	|	втОстаткиРегистр КАК втОстаткиРегистр
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА втОстаткиРегистр.Базовый
	|			ТОГДА втОстаткиРегистр.Номенклатура
	|		ИНАЧЕ втОстаткиРегистр.БазоваяНоменклатура
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
	|	ВТРезервныйЗапас.Количество - ЕСТЬNULL(ВТОстаткиНаСкладе.Количество, 0) КАК Количество,
	|	ЕСТЬNULL(ВТОстаткиНаСкладе.Количество, 0) КАК ОстатокНаСкладе
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
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений КАК НомПодразделений
	|		ПО втМатериалыДляЗакупа.Номенклатура = НомПодразделений.Номенклатура
	|			И (НомПодразделений.Подразделение = &Подразделение)
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
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений КАК НоменклатураПодразделений
	|		ПО (ВЫБОР
	|				КОГДА ВТМатериалыСоСтоимостью.Номенклатура.Базовый
	|					ТОГДА ВТМатериалыСоСтоимостью.Номенклатура = НоменклатураПодразделений.Номенклатура
	|				ИНАЧЕ ВТМатериалыСоСтоимостью.Номенклатура.БазоваяНоменклатура = НоменклатураПодразделений.Номенклатура
	|			КОНЕЦ)
	|ГДЕ
	|	НоменклатураПодразделений.Подразделение = &Подразделение
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
	
	ПолучитьРасшифровку();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьРасшифровку()
	
	Если Объект.Подразделение.Пустая()
		ИЛИ Объект.НарядЗадание.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("НарядЗадание", Объект.НарядЗадание);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НарядЗаданиеСписокСпецификаций.Спецификация КАК СпецификацияСсылка
	|ПОМЕСТИТЬ втСпецификации
	|ИЗ
	|	Документ.НарядЗадание.СписокСпецификаций КАК НарядЗаданиеСписокСпецификаций
	|ГДЕ
	|	НарядЗаданиеСписокСпецификаций.Ссылка = &НарядЗадание
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
	|	Список.Количество,
	|	Список.Ссылка КАК Спецификация,
	|	Список.ДатаИзготовления,
	|	Список.Скомплектован
	|ИЗ
	|	Список КАК Список
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений КАК НомПодразделений
	|		ПО (НомПодразделений.Подразделение = &Подразделение)
	|			И Список.Номенклатура = НомПодразделений.Номенклатура";
	
	Результат = Запрос.Выполнить();
	ТаблицаРасшифровки.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ПередЗаполнитьНаСервере();
	ПолучитьРасшифровку();
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	ПередЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Функция ФильтроватьРасшифровку(фНоменклатура = Неопределено)
	
	Если ЗначениеЗаполнено(фНоменклатура) Тогда
		ОтборСтрок = Новый ФиксированнаяСтруктура("Номенклатура", фНоменклатура);
	Иначе
		ОтборСтрок = Новый ФиксированнаяСтруктура("Номенклатура", ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
	КонецЕсли;
	Элементы.ТаблицаРасшифровки.ОтборСтрок = ОтборСтрок;
	
КонецФункции

&НаКлиенте
Процедура СписокНоменклатурыПриАктивизацииСтроки(Элемент)
	
	Данные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	
	Если Данные <> Неопределено Тогда
		
		ФильтроватьРасшифровку(Данные.Номенклатура);
		
	КонецЕсли;
	
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
	
	Отказ = Истина;
	
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
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПолучитьРасшифровку();
	ФильтроватьРасшифровку();
	
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
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таб.Поставщик КАК Контрагент
	|ИЗ
	|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК Таб
	|ГДЕ
	|	Таб.КоличествоПоставщик > 0
	|	И Таб.Поставщик <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	И Таб.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Контрагент");
	
КонецФункции