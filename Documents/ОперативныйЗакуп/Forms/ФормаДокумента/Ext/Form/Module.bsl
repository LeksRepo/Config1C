﻿
#Область ОБЩЕГО_НАЗНАЧЕНИЯ

&НаКлиенте
Функция ПересчитатьСуммыДокумента()
	
	Объект.СуммаПодотчет = 0;
	Объект.СуммаПоставщик = 0;
	
	Для Каждого Строка Из Объект.СписокНоменклатуры Цикл
		
		Объект.СуммаПодотчет = Объект.СуммаПодотчет + Строка.КоличествоКупить * Строка.Цена;
		Объект.СуммаПоставщик = Объект.СуммаПоставщик + Строка.КоличествоПоставщик * Строка.Цена;
		
	КонецЦикла;
	
	Для Каждого Строка Из Объект.НеноменклатурныйМатериал Цикл
		
		Если Строка.Заказано Тогда
			Объект.СуммаПодотчет = Объект.СуммаПодотчет + Строка.КоличествоКупить * Строка.Цена;
			Объект.СуммаПоставщик = Объект.СуммаПоставщик + Строка.КоличествоПоставщик * Строка.Цена;
		КонецЕсли;
			
	КонецЦикла;
	
	Объект.СуммаДокумента = Объект.СуммаПодотчет + Объект.СуммаПоставщик;
	
КонецФункции

#КонецОбласти

#Область СОБЫТИЯ_ФОРМЫ

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтборРасшифровки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаполнитьНаСервере()
	
	Если Объект.Подразделение.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Укажите подразделение",, "Подразделение");
		Возврат;
	КонецЕсли;
	
	Если Объект.СписокНоменклатуры.Количество() > 0 Тогда
		
		Ответ = Вопрос("Данные введенные вручную будут утеряны. Продолжить?", РежимДиалогаВопрос.ДаНет);
		
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область КОМАНДЫ

&НаКлиенте
Процедура Заполнить(Команда)
	
	ПередЗаполнитьНаСервере();
	
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
	|	Таб.Поставщик
	|ИЗ
	|	Документ.ОперативныйЗакуп.НеноменклатурныйМатериал КАК Таб
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
Процедура ОчиститьРегистрНеноменклатурногоМатериала()
	
	Для Каждого Стр ИЗ Объект.НеноменклатурныйМатериал Цикл
		
		НаборЗаписей = РегистрыСведений.ЗаказНеноменклатурногоМатериала.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Спецификация.Установить(Стр.Спецификация);
		НаборЗаписей.Отбор.Номенклатура.Установить(Стр.Номенклатура);
	    НаборЗаписей.Записать();

	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	Объект.СписокНоменклатуры.Очистить();
	
	ОчиститьРегистрНеноменклатурногоМатериала();
	Объект.НеноменклатурныйМатериал.Очистить();
	
	#Область Запрос_заполнения_номенклатуры
	
	Если ЗначениеЗаполнено(Объект.Дата) Тогда
		ДеньВыборки = Объект.Дата;
	Иначе
		ДеньВыборки = ТекущаяДата();
	КонецЕсли;
	
	Объект.СуммаДокумента = 0;
	Объект.СуммаПодотчет = 0;
	Объект.СуммаПоставщик = 0;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("ТекущаяДата", КонецДня(ДеньВыборки));
	Запрос.УстановитьПараметр("ОсновнойСклад", Объект.Подразделение.ОсновнойСклад);
	Запрос.УстановитьПараметр("ТекущийДокумент", Объект.Ссылка);
	Запрос.УстановитьПараметр("НарядЗадания", Объект.НарядЗадания.Выгрузить().ВыгрузитьКолонку("Наряд"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокСпецификаций.Спецификация КАК СпецификацияСсылка
	|ПОМЕСТИТЬ втСпецификации
	|ИЗ
	|	Документ.НарядЗадание.СписокСпецификаций КАК СписокСпецификаций
	|ГДЕ
	|	СписокСпецификаций.Ссылка В(&НарядЗадания)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(Ком.КоличествоСклад + Ком.КоличествоЦех) КАК Количество,
	|	Ком.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ втУжеСкомплектовано
	|ИЗ
	|	Документ.Комплектация.СписокНоменклатуры КАК Ком
	|ГДЕ
	|	Ком.Ссылка.Проведен
	|	И Ком.Ссылка.Спецификация В
	|			(ВЫБРАТЬ
	|				т.СпецификацияСсылка
	|			ИЗ
	|				втСпецификации КАК т)
	|	И (Ком.КоличествоСклад > 0
	|			ИЛИ Ком.КоличествоЦех > 0)
	|
	|СГРУППИРОВАТЬ ПО
	|	Ком.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпецификацияСписокМатериаловПодЗаказ.Номенклатура КАК Номенклатура,
	|	МАКСИМУМ(СпецификацияСписокМатериаловПодЗаказ.Поставщик) КАК Поставщик,
	|	МИНИМУМ(ВЫБОР
	|			КОГДА НастройкиНоменклатурыСрезПоследних.ОсновнаяПоСкладу ЕСТЬ NULL
	|					ИЛИ НастройкиНоменклатурыСрезПоследних.ОсновнаяПоСкладу = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|				ТОГДА СпецификацияСписокМатериаловПодЗаказ.Цена
	|			ИНАЧЕ СпецификацияСписокМатериаловПодЗаказ.Цена * НастройкиНоменклатурыСрезПоследних.ОсновнаяПоСкладу.КоэффициентБазовых
	|		КОНЕЦ) КАК Цена
	|ПОМЕСТИТЬ втПоставщикПодЗаказ
	|ИЗ
	|	Документ.Спецификация.СписокМатериаловПодЗаказ КАК СпецификацияСписокМатериаловПодЗаказ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(&ТекущаяДата, Подразделение = &Подразделение) КАК НастройкиНоменклатурыСрезПоследних
	|		ПО СпецификацияСписокМатериаловПодЗаказ.Номенклатура = НастройкиНоменклатурыСрезПоследних.Номенклатура
	|ГДЕ
	|	СпецификацияСписокМатериаловПодЗаказ.Ссылка В
	|			(ВЫБРАТЬ
	|				т.СпецификацияСсылка
	|			ИЗ
	|				втСпецификации КАК т)
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокМатериаловПодЗаказ.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Список.Номенклатура КАК Номенклатура,
	|	СУММА(Список.КоличествоКупить + Список.КоличествоПоставщик) КАК Количество
	|ПОМЕСТИТЬ втНоменклатураИзДругихОперативныхЗакупов
	|ИЗ
	|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК Список
	|ГДЕ
	|	НЕ Список.Ссылка.ПометкаУдаления
	|	И Список.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&ТекущаяДата, ДЕНЬ) И КОНЕЦПЕРИОДА(&ТекущаяДата, ДЕНЬ)
	|	И ВЫБОР
	|			КОГДА &ТекущийДокумент <> ЗНАЧЕНИЕ(Документ.ОперативныйЗакуп.ПустаяСсылка)
	|				ТОГДА Список.Ссылка <> &ТекущийДокумент
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И (Список.КоличествоКупить > 0
	|			ИЛИ Список.КоличествоПоставщик > 0)
	|	И Список.Ссылка.Подразделение = &Подразделение
	|
	|СГРУППИРОВАТЬ ПО
	|	Список.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(УправленческийОстатки.Субконто2, НоменклатураИзДругихОперативныхЗакупов.Номенклатура) КАК Номенклатура,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоРазвернутыйОстатокДт, 0) + ЕСТЬNULL(НоменклатураИзДругихОперативныхЗакупов.Количество, 0) КАК Количество
	|ПОМЕСТИТЬ втОстаткиРегистр
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			&ТекущаяДата,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|			,
	|			Подразделение = &Подразделение
	|				И Субконто1 = &ОсновнойСклад) КАК УправленческийОстатки
	|		ПОЛНОЕ СОЕДИНЕНИЕ втНоменклатураИзДругихОперативныхЗакупов КАК НоменклатураИзДругихОперативныхЗакупов
	|		ПО ((ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Справочник.Номенклатура)) = НоменклатураИзДругихОперативныхЗакупов.Номенклатура)
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
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РезервныйЗапас.Номенклатура КАК Номенклатура,
	|	РезервныйЗапас.Количество КАК Количество
	|ПОМЕСТИТЬ втРезервныйЗапас
	|ИЗ
	|	РегистрСведений.РезервныйЗапасМатериалов.СрезПоследних(
	|			&ТекущаяДата,
	|			Подразделение = &Подразделение
	|				И Склад = &ОсновнойСклад) КАК РезервныйЗапас
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втРезервныйЗапас.Номенклатура КАК Номенклатура,
	|	ЕСТЬNULL(втОстаткиНаСкладе.Количество, 0) КАК КоличествоОстатокНаСкладе,
	|	втРезервныйЗапас.Количество - ЕСТЬNULL(втОстаткиНаСкладе.Количество, 0) КАК Количество
	|ПОМЕСТИТЬ втДокупитьПоРезерву
	|ИЗ
	|	втРезервныйЗапас КАК втРезервныйЗапас
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстаткиНаСкладе КАК втОстаткиНаСкладе
	|		ПО (втОстаткиНаСкладе.Номенклатура = втРезервныйЗапас.Номенклатура)
	|ГДЕ
	|	ЕСТЬNULL(втОстаткиНаСкладе.Количество, 0) < втРезервныйЗапас.Количество
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НарядЗаданиеСписокЛистовНоменклатуры.Номенклатура КАК Номенклатура,
	|	СУММА(НарядЗаданиеСписокЛистовНоменклатуры.Количество * ЕСТЬNULL(НастройкиНоменклатуры.ОсновнаяПоСкладу.КоэффициентБазовых, 1)) КАК Количество
	|ПОМЕСТИТЬ втТребуетсяЛистовогоПоНаряду
	|ИЗ
	|	Документ.НарядЗадание.СписокЛистовНоменклатуры КАК НарядЗаданиеСписокЛистовНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(&ТекущаяДата, Подразделение = &Подразделение) КАК НастройкиНоменклатуры
	|		ПО НарядЗаданиеСписокЛистовНоменклатуры.Номенклатура = НастройкиНоменклатуры.Номенклатура
	|ГДЕ
	|	НарядЗаданиеСписокЛистовНоменклатуры.Ссылка В(&НарядЗадания)
	|
	|СГРУППИРОВАТЬ ПО
	|	НарядЗаданиеСписокЛистовНоменклатуры.Ссылка.Подразделение,
	|	НарядЗаданиеСписокЛистовНоменклатуры.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпецификацияСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СУММА(СпецификацияСписокНоменклатуры.Количество) КАК КоличествоВсегоТребуется
	|ПОМЕСТИТЬ втТребуетсяПоСпецификациям
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В
	|			(ВЫБРАТЬ
	|				т.СпецификацияСсылка
	|			ИЗ
	|				втСпецификации КАК т)
	|	И СпецификацияСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|	И НЕ СпецификацияСписокНоменклатуры.Номенклатура.Неноменклатурный
	|	И НЕ СпецификацияСписокНоменклатуры.ПредоставитЗаказчик
	|	И СпецификацияСписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа.ВидМатериала <> ЗНАЧЕНИЕ(Перечисление.ВидыМатериалов.Листовой)
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
	|	втТребуетсяПоСпецификациям.Номенклатура КАК Номенклатура,
	|	втОстаткиНаСкладе.Количество КАК КоличествоОстатокНаСкладе,
	|	втТребуетсяПоСпецификациям.КоличествоВсегоТребуется - ЕСТЬNULL(втОстаткиНаСкладе.Количество, 0) КАК Количество
	|ПОМЕСТИТЬ втДокупитьПоСпецификацям
	|ИЗ
	|	втТребуетсяПоСпецификациям КАК втТребуетсяПоСпецификациям
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстаткиНаСкладе КАК втОстаткиНаСкладе
	|		ПО втТребуетсяПоСпецификациям.Номенклатура = втОстаткиНаСкладе.Номенклатура
	|ГДЕ
	|	втТребуетсяПоСпецификациям.КоличествоВсегоТребуется - ЕСТЬNULL(втОстаткиНаСкладе.Количество, 0) > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	втТребуетсяЛистовогоПоНаряду.Номенклатура,
	|	втОстаткиНаСкладе.Количество,
	|	втТребуетсяЛистовогоПоНаряду.Количество - ЕСТЬNULL(втОстаткиНаСкладе.Количество, 0)
	|ИЗ
	|	втТребуетсяЛистовогоПоНаряду КАК втТребуетсяЛистовогоПоНаряду
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстаткиНаСкладе КАК втОстаткиНаСкладе
	|		ПО втТребуетсяЛистовогоПоНаряду.Номенклатура = втОстаткиНаСкладе.Номенклатура
	|ГДЕ
	|	втТребуетсяЛистовогоПоНаряду.Количество - ЕСТЬNULL(втОстаткиНаСкладе.Количество, 0) > 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(втДокупитьПоРезерву.Номенклатура, втДокупитьПоСпецификацям.Номенклатура) КАК Номенклатура,
	|	ЕСТЬNULL(втДокупитьПоРезерву.КоличествоОстатокНаСкладе, втДокупитьПоСпецификацям.КоличествоОстатокНаСкладе) КАК КоличествоОстатокНаСкладе,
	|	ЕСТЬNULL(втДокупитьПоРезерву.Количество, 0) + ЕСТЬNULL(втДокупитьПоСпецификацям.Количество, 0) КАК Количество,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(втДокупитьПоРезерву.Количество, 0) > 0
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СработалРезерв
	|ПОМЕСТИТЬ втМатериалыДляЗакупа
	|ИЗ
	|	втДокупитьПоРезерву КАК втДокупитьПоРезерву
	|		ПОЛНОЕ СОЕДИНЕНИЕ втДокупитьПоСпецификацям КАК втДокупитьПоСпецификацям
	|		ПО втДокупитьПоРезерву.Номенклатура = втДокупитьПоСпецификацям.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(втПоставщикПодЗаказ.Поставщик, НастройкиНоменклатуры.Поставщик) КАК Поставщик,
	|	ВЫБОР
	|		КОГДА НастройкиНоменклатуры.ОсновнаяПоСкладу ЕСТЬ NULL
	|				ИЛИ НастройкиНоменклатуры.ОсновнаяПоСкладу = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			ТОГДА втМатериалыДляЗакупа.Номенклатура
	|		ИНАЧЕ НастройкиНоменклатуры.ОсновнаяПоСкладу
	|	КОНЕЦ КАК Номенклатура,
	|	ВЫРАЗИТЬ(втМатериалыДляЗакупа.Количество / ВЫБОР
	|			КОГДА ЕСТЬNULL(НастройкиНоменклатуры.ОсновнаяПоСкладу.КоэффициентБазовых, 1) = 0
	|				ТОГДА 1
	|			ИНАЧЕ ЕСТЬNULL(НастройкиНоменклатуры.ОсновнаяПоСкладу.КоэффициентБазовых, 1)
	|		КОНЕЦ + 0.49999 - ЕСТЬNULL(УжеСкомплектовано.Количество, 0) КАК ЧИСЛО(15, 0)) КАК Количество,
	|	втМатериалыДляЗакупа.СработалРезерв,
	|	втМатериалыДляЗакупа.КоличествоОстатокНаСкладе КАК ОстаткиНаСкладе,
	|	ЕСТЬNULL(втПоставщикПодЗаказ.Цена, ЕСТЬNULL(НастройкиНоменклатуры.ПлановаяЗакупочная, 0) * ЕСТЬNULL(НастройкиНоменклатуры.ОсновнаяПоСкладу.КоэффициентБазовых, 1)) КАК Цена,
	|	НастройкиНоменклатуры.ПодЗаказ КАК ПодЗаказ,
	|	ЗНАЧЕНИЕ(Документ.Спецификация.ПустаяСсылка) КАК Спецификация,
	|	"""" КАК Комментарий,
	|	ЕСТЬNULL(УжеСкомплектовано.Количество, 0) КАК УжеСкомплектовано
	|ИЗ
	|	втМатериалыДляЗакупа КАК втМатериалыДляЗакупа
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(&ТекущаяДата, Подразделение = &Подразделение) КАК НастройкиНоменклатуры
	|		ПО втМатериалыДляЗакупа.Номенклатура = НастройкиНоменклатуры.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПоставщикПодЗаказ КАК втПоставщикПодЗаказ
	|		ПО втМатериалыДляЗакупа.Номенклатура = втПоставщикПодЗаказ.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ втУжеСкомплектовано КАК УжеСкомплектовано
	|		ПО втМатериалыДляЗакупа.Номенклатура = УжеСкомплектовано.Номенклатура
	|ГДЕ
	|	НЕ втМатериалыДляЗакупа.Номенклатура.Неноменклатурный
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СпецификацияСписокМатериаловПодЗаказ.Поставщик,
	|	СпецификацияСписокМатериаловПодЗаказ.Номенклатура,
	|	ВЫБОР
	|		КОГДА СпецификацияСписокЛистовНоменклатуры.Количество ЕСТЬ NULL
	|			ТОГДА СпецификацияСписокМатериаловПодЗаказ.Количество - ЕСТЬNULL(УжеСкомплектовано.Количество, 0)
	|		ИНАЧЕ СпецификацияСписокЛистовНоменклатуры.Количество
	|	КОНЕЦ,
	|	ЛОЖЬ,
	|	0,
	|	СпецификацияСписокМатериаловПодЗаказ.Цена,
	|	ИСТИНА,
	|	СпецификацияСписокМатериаловПодЗаказ.Ссылка,
	|	СпецификацияСписокМатериаловПодЗаказ.Комментарий,
	|	ЕСТЬNULL(УжеСкомплектовано.Количество, 0)
	|ИЗ
	|	Документ.Спецификация.СписокМатериаловПодЗаказ КАК СпецификацияСписокМатериаловПодЗаказ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СписокЛистовНоменклатуры КАК СпецификацияСписокЛистовНоменклатуры
	|		ПО (СпецификацияСписокЛистовНоменклатуры.Ссылка В
	|				(ВЫБРАТЬ
	|					т.СпецификацияСсылка
	|				ИЗ
	|					втСпецификации КАК т))
	|			И (СпецификацияСписокЛистовНоменклатуры.Ссылка = СпецификацияСписокМатериаловПодЗаказ.Ссылка)
	|			И (СпецификацияСписокЛистовНоменклатуры.Номенклатура = СпецификацияСписокМатериаловПодЗаказ.Номенклатура)
	|		ЛЕВОЕ СОЕДИНЕНИЕ втУжеСкомплектовано КАК УжеСкомплектовано
	|		ПО СпецификацияСписокМатериаловПодЗаказ.Номенклатура = УжеСкомплектовано.Номенклатура
	|ГДЕ
	|	СпецификацияСписокМатериаловПодЗаказ.Ссылка В
	|			(ВЫБРАТЬ
	|				т.СпецификацияСсылка
	|			ИЗ
	|				втСпецификации КАК т)
	|	И НЕ СпецификацияСписокМатериаловПодЗаказ.Номенклатура.Неноменклатурный";
	
	Объект.СписокНоменклатуры.Загрузить(Запрос.Выполнить().Выгрузить());
	
	#КонецОбласти
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("ОперЗакуп", Объект.Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Спец.Номенклатура,
	|	Спец.Поставщик,
	|	Спец.Ссылка КАК Спецификация,
	|	Спец.Количество,
	|	Спец.Комментарий,
	|	Спец.Сумма,
	|	Спец.Цена,
	|	ЛОЖЬ КАК Заказано,
	|	Статусы.Статус КАК Статус,
	|	ВЫБОР
	|		КОГДА Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Проверяется)
	|			ТОГДА 1
	|		КОГДА Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Рассчитывается)
	|			ТОГДА 2
	|		КОГДА Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ОжиданиеМатериала)
	|			ТОГДА 3
	|		КОГДА Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен)
	|			ТОГДА 4
	|	КОНЕЦ КАК Порядок
	|ИЗ
	|	Документ.Спецификация.СписокМатериаловПодЗаказ КАК Спец
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних(, ) КАК Статусы
	|		ПО Спец.Ссылка = Статусы.Спецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаказНеноменклатурногоМатериала КАК Неноменклатурный
	|		ПО Спец.Ссылка = Неноменклатурный.Спецификация
	|			И Спец.Номенклатура = Неноменклатурный.Номенклатура
	|ГДЕ
	|	Спец.Ссылка.Подразделение = &Подразделение
	|	И (Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ОжиданиеМатериала)
	|			ИЛИ Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Проверяется)
	|			ИЛИ Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Рассчитывается)
	|			ИЛИ Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен))
	|	И Спец.Номенклатура.Неноменклатурный
	|	И (НЕ ЕСТЬNULL(Неноменклатурный.Заказано, ЛОЖЬ)
	|			ИЛИ Неноменклатурный.ОперЗакуп = &ОперЗакуп)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	Спец.Ссылка.Номер";
	
	Объект.НеноменклатурныйМатериал.Загрузить(Запрос.Выполнить().Выгрузить());
	
	ПолучитьРасшифровку();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНаряды(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Подразделение", Объект.Подразделение);
	ПараметрыФормы.Вставить("ТЗ", Объект.НарядЗадания);
	
	АдресТаблицы = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораНаряда", ПараметрыФормы, ЭтаФорма);
	
	Если АдресТаблицы <> Неопределено Тогда
		ЗагрузитьНаряды(АдресТаблицы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНаряды(АдресТаблицы)
	
	Если ЭтоАдресВременногоХранилища(АдресТаблицы) Тогда
		ТЗ = ПолучитьИзВременногоХранилища(АдресТаблицы);
		Объект.НарядЗадания.Загрузить(ТЗ);
		ЗаполнитьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СОБЫТИЯ_ЭЛЕМЕНТОВ_ФОРМЫ

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ПередЗаполнитьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ТАБЛИЦА_СПИСОК_НОМЕНКЛАТУРЫ

&НаКлиенте
Процедура СписокНоменклатурыПриАктивизацииСтроки(Элемент)
	
	УстановитьОтборРасшифровки();
	
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
Процедура СписокНоменклатурыКоличествоКупитьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	ТекущиеДанные.КоличествоПоставщик = 0;
	ТекущиеДанные.Стоимость = ТекущиеДанные.КоличествоКупить * ТекущиеДанные.Цена;
	ПересчитатьСуммыДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыКоличествоПоставщикПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	ТекущиеДанные.КоличествоКупить = 0;
	ТекущиеДанные.Стоимость = ТекущиеДанные.КоличествоПоставщик * ТекущиеДанные.Цена;
	ПересчитатьСуммыДокумента();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСвойстваНоменклатуры(фнНоменклатура, фнПодразделение)
	
	Если НЕ фнНоменклатура.Базовый Тогда
		ОтборНоменклатура = фнНоменклатура.БазоваяНоменклатура;
	Иначе
		ОтборНоменклатура = фнНоменклатура;
	КонецЕсли;
	
	КоэффициентДляУмноженияЦены = ?(фнНоменклатура.КоэффициентБазовых <> 0, фнНоменклатура.КоэффициентБазовых, 1);
	Свойства = Новый Структура;
	Свойства.Вставить("ПлановаяЦена", 0);
	Свойства.Вставить("ЕдиницаИзмерения", ОтборНоменклатура.ЕдиницаИзмерения);
	Свойства.Вставить("Поставщик");
	Свойства.Вставить("КоличествоОстаток");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", ОтборНоменклатура);
	Запрос.УстановитьПараметр("Подразделение", фнПодразделение);
	Запрос.УстановитьПараметр("ОсновнойСклад" , ОбщегоНазначения.ЗначениеРеквизитаОбъекта(фнПодразделение, "ОсновнойСклад"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатуры.ПлановаяЗакупочная,
	|	ЦеныНоменклатуры.Поставщик,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоРазвернутыйОстатокДт, 0) КАК КоличествоОстаток
	|ИЗ
	|	РегистрСведений.НастройкиНоменклатуры.СрезПоследних(
	|			,
	|			Подразделение = &Подразделение
	|				И Номенклатура = &Номенклатура) КАК ЦеныНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто1 = &ОсновнойСклад) КАК УправленческийОстатки
	|		ПО ЦеныНоменклатуры.Номенклатура = УправленческийОстатки.Субконто2";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Свойства.ПлановаяЦена = Выборка.ПлановаяЗакупочная*КоэффициентДляУмноженияЦены;
		Свойства.Поставщик = Выборка.Поставщик;
		Свойства.КоличествоОстаток = Выборка.КоличествоОстаток;
		
	КонецЦикла;
	
	Возврат Свойства;
	
КонецФункции

#КонецОбласти

#Область ТАБЛИЦА_РАСШИФРОВКА

&НаКлиенте
Процедура ТаблицаРасшифровкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.ТаблицаРасшифровки.ТекущиеДанные.Спецификация);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьРасшифровку()
	
	Если Объект.Подразделение.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("НарядЗадания", Объект.НарядЗадания.Выгрузить().ВыгрузитьКолонку("Наряд"));
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Спец.Ссылка КАК СпецификацияСсылка
	|ПОМЕСТИТЬ втСпецификации
	|ИЗ
	|	Документ.Спецификация КАК Спец
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НарядЗадание.СписокСпецификаций КАК Наряд
	|		ПО Спец.Ссылка = Наряд.Спецификация
	|ГДЕ
	|	Наряд.Ссылка В(&НарядЗадания)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Комплектация.Спецификация КАК Спецификация
	|ПОМЕСТИТЬ втСписокКомплектаций
	|ИЗ
	|	Документ.Комплектация КАК Комплектация
	|ГДЕ
	|	Комплектация.Спецификация В
	|			(ВЫБРАТЬ
	|				т.СпецификацияСсылка
	|			ИЗ
	|				втСпецификации КАК т)
	|	И Комплектация.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпецификацияСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СУММА(СпецификацияСписокНоменклатуры.Количество) КАК Количество,
	|	СпецификацияСписокНоменклатуры.Ссылка,
	|	СпецификацияСписокНоменклатуры.Ссылка.ДатаИзготовления,
	|	ВЫБОР
	|		КОГДА Комплектация.Спецификация ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Скомплектован
	|ПОМЕСТИТЬ Список
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ втСписокКомплектаций КАК Комплектация
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
	|		КОГДА Комплектация.Спецификация ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	СпецификацияСписокНоменклатуры.Ссылка.ДатаИзготовления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА НастройкиНоменклатуры.ОсновнаяПоСкладу ЕСТЬ NULL
	|				ИЛИ НастройкиНоменклатуры.ОсновнаяПоСкладу = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			ТОГДА Список.Номенклатура
	|		ИНАЧЕ НастройкиНоменклатуры.ОсновнаяПоСкладу
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
	|ПОМЕСТИТЬ Список2
	|ИЗ
	|	Список КАК Список
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(&Период, Подразделение = &Подразделение) КАК НастройкиНоменклатуры
	|		ПО Список.Номенклатура = НастройкиНоменклатуры.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Список2.Номенклатура,
	|	Список2.БазоваяНом,
	|	Список2.Количество,
	|	Список2.Спецификация,
	|	Список2.ДатаИзготовления,
	|	Список2.Скомплектован,
	|	МатПодЗаказ.Комментарий КАК Комментарий
	|ИЗ
	|	Список2 КАК Список2
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СписокМатериаловПодЗаказ КАК МатПодЗаказ
	|		ПО (Список2.Номенклатура = МатПодЗаказ.Номенклатура
	|				ИЛИ Список2.БазоваяНом = МатПодЗаказ.Номенклатура)
	|			И Список2.Спецификация = МатПодЗаказ.Ссылка";
	
	Результат = Запрос.Выполнить();
	Объект.ТаблицаРасшифровки.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборРасшифровки()
	
	Данные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	
	СтруктураОтбор = Новый Структура;
	
	Если Данные <> Неопределено
		И ЗначениеЗаполнено(Данные.Номенклатура) Тогда
		
		Если ЗначениеЗаполнено(Данные.Спецификация) Тогда
			
			СтруктураОтбор.Вставить("Спецификация", Данные.Спецификация);
			
		КонецЕсли;
		
		СвойстваНоменклатуры = ЛексСервер.ЗначенияРеквизитовОбъекта(Данные.Номенклатура, "Базовый, БазоваяНоменклатура");
		
		Если СвойстваНоменклатуры.Базовый Тогда
			НоменклатураСсылка = Данные.Номенклатура;
		Иначе
			НоменклатураСсылка = СвойстваНоменклатуры.БазоваяНоменклатура;
		КонецЕсли;
		
		СтруктураОтбор.Вставить("БазоваяНом", НоменклатураСсылка);
		
	КонецЕсли;
	
	ОтборСтрок = Новый ФиксированнаяСтруктура(СтруктураОтбор);
	Элементы.ТаблицаРасшифровки.ОтборСтрок = ОтборСтрок;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаТаблицыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УстановитьОтборРасшифровки();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(Объект.Подразделение)
		И ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) Тогда
		
		СвойстваНоменклатуры = ПолучитьСвойстваНоменклатуры(ТекущиеДанные.Номенклатура, Объект.Подразделение);
		ТекущиеДанные.Цена = СвойстваНоменклатуры.ПлановаяЦена;
		ТекущиеДанные.Поставщик = СвойстваНоменклатуры.Поставщик;
		ТекущиеДанные.ОстаткиНаСкладе = СвойстваНоменклатуры.КоличествоОстаток;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеноменклатурныйМатериалКоличествоПоставщикПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.НеноменклатурныйМатериал.ТекущиеДанные;
	ТекущиеДанные.КоличествоКупить = 0;
	ТекущиеДанные.Стоимость = ТекущиеДанные.КоличествоПоставщик * ТекущиеДанные.Цена;
	ПересчитатьСуммыДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура НеноменклатурныйМатериалКоличествоКупитьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.НеноменклатурныйМатериал.ТекущиеДанные;
	ТекущиеДанные.КоличествоПоставщик = 0;
	ТекущиеДанные.Стоимость = ТекущиеДанные.КоличествоКупить * ТекущиеДанные.Цена;
	ПересчитатьСуммыДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура НеноменклатурныйМатериалЗаказаноПриИзменении(Элемент)
	ПересчитатьСуммыДокумента();
КонецПроцедуры

&НаКлиенте
Процедура НеноменклатурныйМатериалПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура НеноменклатурныйМатериалПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура НеноменклатурныйМатериалСпецификацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура НеноменклатурныйМатериалСпецификацияИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура НеноменклатурныйМатериалЦенаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.НеноменклатурныйМатериал.ТекущиеДанные;
	ТекущиеДанные.Стоимость = ТекущиеДанные.КоличествоПоставщик * ТекущиеДанные.Цена + ТекущиеДанные.КоличествоКупить * ТекущиеДанные.Цена;
	ПересчитатьСуммыДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура НеноменклатурныйМатериалСпецификацияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	УдалитьНеЗаказаныйНеноменклатурныйМатериал(ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура УдалитьНеЗаказаныйНеноменклатурныйМатериал(ТекущийОбъект)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Заказано", Ложь);
		
	Строки = ТекущийОбъект.НеноменклатурныйМатериал.НайтиСтроки(Отбор);
	
	Для Каждого Стр ИЗ Строки Цикл
		ТекущийОбъект.НеноменклатурныйМатериал.Удалить(Стр);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти
