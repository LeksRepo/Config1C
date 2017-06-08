﻿
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Отказ = ЛексСервер.ДоступнаОтменаПроведения(Ссылка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Управленческий.Записать();
	Ошибки = Неопределено;
	
	// { Васильев Александр Леонидович [18.10.2013]
	// Блокировку
	// } Васильев Александр Леонидович [18.10.2013]
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура,
	|	СУММА(ТребованиеНакладнаяСписокНоменклатуры.Отпущено) КАК Количество,
	|	МИНИМУМ(ТребованиеНакладнаяСписокНоменклатуры.НомерСтроки) КАК НомерСтроки
	|ИЗ
	|	Документ.ТребованиеНакладная.СписокНоменклатуры КАК ТребованиеНакладнаяСписокНоменклатуры
	|ГДЕ
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка = &Ссылка
	|	И ТребованиеНакладнаяСписокНоменклатуры.Отпущено <> 0   
	|
	|СГРУППИРОВАТЬ ПО
	|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура";
	
	ТаблицаМатериалов = Запрос.Выполнить().Выгрузить();
	
	Структура = ЛексСервер.ПеремещениеМатериаловВПроизводство(ТаблицаМатериалов, Подразделение, Склад, Движения, МоментВремени());
	
	Для каждого СтрокаНехватки Из Структура.тзНехватка Цикл
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%5 На складе %1 недостаточно материала '%2'. Из требуемых %3 есть только %4", 
		Склад,
		СтрокаНехватки.Номенклатура,
		СтрокаНехватки.КоличествоТребуется,
		СтрокаНехватки.КоличествоОстаток,
		Ссылка);
		Поле = "Объект.СписокНоменклатуры[" +Строка(СтрокаНехватки.НомерСтроки-1) + "].Отпущено";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстСообщения);
		ОстаткиВДругихЕдиницах = ЛексСервер.ПолучитьОстаткиВДругихЕдиницах(СтрокаНехватки.Номенклатура, Склад, МоментВремени(), Подразделение);
		Для каждого СтрокаОстаток Из ОстаткиВДругихЕдиницах Цикл
			
			ТекстСообщения = "Остаток '%1' в количестве %2";
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения,
			СтрокаОстаток.Номенклатура,
			СтрокаОстаток.Количество);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстСообщения, , СтрокаНехватки.НомерСтроки);
			
		КонецЦикла;
		
	КонецЦикла;
	
	ПроверитьТребованияНакладные(Ошибки, Отказ);
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если НЕ Отказ Тогда
		Стоимости = ПолучитьСуммыДокумента();
		СуммаДокумента = Стоимости.СтоимостьРозничная;
		Себестоимость = Структура.Себестоимость;
		Движения.Управленческий.Записывать = Истина;
		Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьТребованияНакладные(Ошибки, Отказ);
	
	Если ЗначениеЗаполнено(НарядЗадание) Тогда
		
		ТЗ = Документы.ТребованиеНакладная.СформироватьТаблицуМатериалов(НарядЗадание);
		
		Запрос = Новый Запрос();
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("Наряд", НарядЗадание);
		Запрос.УстановитьПараметр("ТабНоменклатура", ТЗ);
		
		Запрос.Текст=
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ТабНом.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура
		|ПОМЕСТИТЬ втСписокНом
		|ИЗ
		|	&ТабНоменклатура КАК ТабНом
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабНом.Номенклатура КАК Номенклатура
		|ПОМЕСТИТЬ втСписокНомНаряд
		|ИЗ
		|	втСписокНом КАК ТабНом
		|
		|СГРУППИРОВАТЬ ПО
		|	ТабНом.Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СписокНом.Номенклатура КАК Номенклатура,
		|	СписокНом.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Документ.ТребованиеНакладная.СписокНоменклатуры КАК СписокНом
		|		ЛЕВОЕ СОЕДИНЕНИЕ втСписокНомНаряд КАК СписокНомНаряд
		|		ПО (СписокНом.Номенклатура = СписокНомНаряд.Номенклатура
		|				ИЛИ СписокНом.Номенклатура.БазоваяНоменклатура = СписокНомНаряд.Номенклатура)
		|ГДЕ
		|	СписокНом.Ссылка = &Ссылка
		|	И СписокНом.Отпущено > 0
		|	И СписокНомНаряд.Номенклатура ЕСТЬ NULL ";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 не используется в наряд задании %2", Выборка.Номенклатура, НарядЗадание);
			Поле = "Объект.СписокНоменклатуры["+(Выборка.НомерСтроки-1)+"].Номенклатура";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстСообщения);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Дата = НачалоДня(ТекущаяДата()) + 36000;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.НарядЗадание") Тогда
		
		Подразделение = ДанныеЗаполнения.Подразделение;
		Склад = Подразделение.ОсновнойСклад;
		НарядЗадание = ДанныеЗаполнения;
		Комментарий = "Введено на основании " + ДанныеЗаполнения;
		
		Таблица = ПолучитьНоменклатуруТребованияНакладные(НарядЗадание, Подразделение);
		СписокНоменклатуры.Загрузить(Таблица);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьНоменклатуруТребованияНакладные(НарядЗадание, Подразделение)
	
	ТЗ = Документы.ТребованиеНакладная.СформироватьТаблицуМатериалов(НарядЗадание);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", НарядЗадание);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ТЗ", ТЗ);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Список.Номенклатура КАК Номенклатура,
	|	Список.Затребовано КАК Затребовано
	|ПОМЕСТИТЬ втСписокНом
	|ИЗ
	|	&ТЗ КАК Список
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокНом.Номенклатура КАК Номенклатура,
	|	ВЫРАЗИТЬ(СписокНом.Номенклатура КАК Справочник.Номенклатура).Наименование КАК Наименование,
	|	СписокНом.Затребовано КАК Затребовано,
	|	НоменклатураПодразделений.ОсновнаяПоСкладу КАК ОсновнаяПоСкладу
	|ПОМЕСТИТЬ втНом
	|ИЗ
	|	втСписокНом КАК СписокНом
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений.СрезПоследних(, Подразделение = &Подразделение) КАК НоменклатураПодразделений
	|		ПО СписокНом.Номенклатура = НоменклатураПодразделений.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Список.ОсновнаяПоСкладу ЕСТЬ NULL 
	|				ИЛИ Список.ОсновнаяПоСкладу = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			ТОГДА Список.Затребовано
	|		ИНАЧЕ ВЫРАЗИТЬ(Список.Затребовано / Список.ОсновнаяПоСкладу.КоэффициентБазовых + 0.4999 КАК ЧИСЛО(15, 0))
	|	КОНЕЦ КАК Затребовано,
	|	ВЫБОР
	|		КОГДА Список.ОсновнаяПоСкладу ЕСТЬ NULL 
	|				ИЛИ Список.ОсновнаяПоСкладу = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			ТОГДА Список.Номенклатура
	|		ИНАЧЕ Список.ОсновнаяПоСкладу
	|	КОНЕЦ КАК Номенклатура
	|ИЗ
	|	втНом КАК Список
	|ГДЕ
	|	ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура).МестоОбработки = ЗНАЧЕНИЕ(Перечисление.МестоОбработки.Цех)
	|	И НЕ ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура).Неноменклатурный
	|
	|УПОРЯДОЧИТЬ ПО
	|	Список.Наименование";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПолучитьСуммыДокумента()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура,
	|	ВЫБОР
	|		КОГДА ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.Базовый
	|			ТОГДА ТребованиеНакладнаяСписокНоменклатуры.Отпущено * ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Внутренняя, 0)
	|		ИНАЧЕ ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.КоэффициентБазовых * ТребованиеНакладнаяСписокНоменклатуры.Отпущено * ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Розничная, 0)
	|	КОНЕЦ КАК СтоимостьРозничная
	|ИЗ
	|	Документ.ТребованиеНакладная.СписокНоменклатуры КАК ТребованиеНакладнаяСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(&Период, Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО (ТребованиеНакладнаяСписокНоменклатуры.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|				ИЛИ ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.БазоваяНоменклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура)
	|ГДЕ
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка = &Ссылка
	|ИТОГИ
	|	СУММА(СтоимостьРозничная)
	|ПО
	|	ОБЩИЕ";
	
	ОбщийИтогВыборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ОбщийИтогВыборка.Следующий();
	
	Структура = Новый Структура;
	Структура.Вставить("СтоимостьРозничная", ОбщийИтогВыборка.СтоимостьРозничная);
	
	Возврат Структура;
	
КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		ДатаСоздания = ТекущаяДата();	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Ошибки = Неопределено;
	
	Для каждого Строка Из СписокНоменклатуры Цикл
		
		Если Строка.Номенклатура.МестоОбработки <> Перечисления.МестоОбработки.Цех Тогда
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 передается документом Комплектация", Строка.Номенклатура);
			Поле = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("СписокНоменклатуры[%1].Номенклатура", Строка.НомерСтроки - 1);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, СтрокаСообщения);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(НарядЗадание) И Строка.Номенклатура.НоменклатурнаяГруппа <> Справочники.НоменклатурныеГруппы.РасходныйМатериал Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 не является расходным материалом. В документ созданный с пустым наряд заданием, разрешено вносить только расходный материал",  Строка.Номенклатура);
			Поле = "Объект.СписокНоменклатуры["+(Строка.НомерСтроки-1)+"].Номенклатура";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстСообщения);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры