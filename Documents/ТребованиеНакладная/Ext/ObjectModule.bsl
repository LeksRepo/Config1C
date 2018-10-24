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
	
	ПроверитьТребованияНакладные(Ошибки);
	
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
	|	И НЕ ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.Неноменклатурный
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
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если НЕ Отказ Тогда
		Стоимости = ПолучитьСуммыДокумента();
		СуммаДокумента = Стоимости.СтоимостьРозничная;
		Себестоимость = Структура.Себестоимость;
		Движения.Управленческий.Записывать = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьТребованияНакладные(Ошибки);
	
	Если НЕ ЗначениеЗаполнено(НарядЗадание) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("СсылкаТребованиеНакладная", Ссылка);
	Запрос.УстановитьПараметр("СсылкаНарядЗадание", НарядЗадание);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТребованиеНакладнаяСписокНоменклатуры.НомерСтроки - 1 КАК НомерСтроки,
	|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ втТребованиеНакладная
	|ИЗ
	|	Документ.ТребованиеНакладная.СписокНоменклатуры КАК ТребованиеНакладнаяСписокНоменклатуры
	|ГДЕ
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка = &СсылкаТребованиеНакладная
	|	И ТребованиеНакладнаяСписокНоменклатуры.Отпущено > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НарядЗаданиеСписокНоменклатурыПоСпецификациям.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ втНарядЗадание
	|ИЗ
	|	Документ.НарядЗадание.СписокНоменклатурыПоСпецификациям КАК НарядЗаданиеСписокНоменклатурыПоСпецификациям
	|ГДЕ
	|	НарядЗаданиеСписокНоменклатурыПоСпецификациям.Ссылка = &СсылкаНарядЗадание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втТребованиеНакладная.Номенклатура КАК ТребованиеНоменклатура,
	|	втТребованиеНакладная.НомерСтроки КАК НомерСтроки,
	|	втНарядЗадание.Номенклатура КАК НарядНоменклатура
	|ИЗ
	|	втТребованиеНакладная КАК втТребованиеНакладная
	|		ЛЕВОЕ СОЕДИНЕНИЕ втНарядЗадание КАК втНарядЗадание
	|		ПО (втТребованиеНакладная.Номенклатура = втНарядЗадание.Номенклатура
	|				ИЛИ втТребованиеНакладная.Номенклатура.БазоваяНоменклатура = втНарядЗадание.Номенклатура
	|				ИЛИ втТребованиеНакладная.Номенклатура = втНарядЗадание.Номенклатура.БазоваяНоменклатура)
	|ГДЕ
	|	втНарядЗадание.Номенклатура ЕСТЬ NULL";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 не используется в наряд задании %2",
		Выборка.ТребованиеНоменклатура,
		НарядЗадание);
		
		Поле = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Объект.СписокНоменклатуры[%1].Номенклатура", Выборка.НомерСтроки);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстСообщения);
		
	КонецЦикла;
	
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
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
	
	НомГруппыРамки = Новый Массив();
	НомГруппыРамки.Добавить(Справочники.НоменклатурныеГруппы.РамкаВерхняя);
	НомГруппыРамки.Добавить(Справочники.НоменклатурныеГруппы.РамкаНижняя);
	НомГруппыРамки.Добавить(Справочники.НоменклатурныеГруппы.РамкаСредняяБезКрепления);
	НомГруппыРамки.Добавить(Справочники.НоменклатурныеГруппы.РамкаСредняяСКреплением);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", НарядЗадание);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("НомГруппыРамки", НомГруппыРамки);
	Запрос.УстановитьПараметр("ТЗ", ТЗ);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Список.Номенклатура КАК Номенклатура,
	|	Список.Затребовано КАК Затребовано,
	|	Список.Спецификация КАК Спецификация,
	|	ВЫРАЗИТЬ(Список.Содержание КАК СТРОКА(100)) КАК Содержание
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
	|	НастройкиНоменклатуры.ОсновнаяПоСкладу КАК ОсновнаяПоСкладу,
	|	СписокНом.Спецификация,
	|	СписокНом.Содержание
	|ПОМЕСТИТЬ втНом
	|ИЗ
	|	втСписокНом КАК СписокНом
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(, Подразделение = &Подразделение) КАК НастройкиНоменклатуры
	|		ПО СписокНом.Номенклатура = НастройкиНоменклатуры.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Список.ОсновнаяПоСкладу ЕСТЬ NULL
	|				ИЛИ Список.ОсновнаяПоСкладу = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|				ИЛИ ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура).НоменклатурнаяГруппа В (&НомГруппыРамки)
	|			ТОГДА Список.Затребовано
	|		ИНАЧЕ ВЫРАЗИТЬ(Список.Затребовано / Список.ОсновнаяПоСкладу.КоэффициентБазовых + 0.4999 КАК ЧИСЛО(15, 0))
	|	КОНЕЦ КАК Затребовано,
	|	ВЫБОР
	|		КОГДА Список.ОсновнаяПоСкладу ЕСТЬ NULL
	|				ИЛИ Список.ОсновнаяПоСкладу = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|				ИЛИ ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура).НоменклатурнаяГруппа В (&НомГруппыРамки)
	|			ТОГДА Список.Затребовано
	|		ИНАЧЕ ВЫРАЗИТЬ(Список.Затребовано / Список.ОсновнаяПоСкладу.КоэффициентБазовых + 0.4999 КАК ЧИСЛО(15, 0))
	|	КОНЕЦ КАК Отпущено,
	|	ВЫБОР
	|		КОГДА Список.ОсновнаяПоСкладу ЕСТЬ NULL
	|				ИЛИ Список.ОсновнаяПоСкладу = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|				ИЛИ ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура).НоменклатурнаяГруппа В (&НомГруппыРамки)
	|			ТОГДА Список.Номенклатура
	|		ИНАЧЕ Список.ОсновнаяПоСкладу
	|	КОНЕЦ КАК Номенклатура,
	|	ВЫРАЗИТЬ(Список.Спецификация КАК Документ.Спецификация) КАК Спецификация,
	|	Список.Содержание
	|ИЗ
	|	втНом КАК Список
	|ГДЕ
	|	ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура).МестоОбработки = ЗНАЧЕНИЕ(Перечисление.МестоОбработки.Цех)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура).НоменклатурнаяГруппа.ВидМатериала,
	|	ВЫРАЗИТЬ(Список.Спецификация КАК Документ.Спецификация).Номер,
	|	Список.Наименование";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПолучитьСуммыДокумента()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТЗ", СписокНоменклатуры.Выгрузить());
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СписокНом.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	СписокНом.Отпущено КАК Отпущено
	|ПОМЕСТИТЬ втНом
	|ИЗ
	|	&ТЗ КАК СписокНом
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокНом.Номенклатура,
	|	ВЫБОР
	|		КОГДА СписокНом.Номенклатура.Базовый
	|			ТОГДА СписокНом.Отпущено * ЕСТЬNULL(ЦеныНом.Розничная, 0)
	|		ИНАЧЕ СписокНом.Номенклатура.КоэффициентБазовых * СписокНом.Отпущено * ЕСТЬNULL(ЦеныНом.Розничная, 0)
	|	КОНЕЦ КАК СтоимостьРозничная
	|ИЗ
	|	втНом КАК СписокНом
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(&Период, Подразделение = &Подразделение) КАК ЦеныНом
	|		ПО (СписокНом.Номенклатура = ЦеныНом.Номенклатура
	|				ИЛИ СписокНом.Номенклатура.БазоваяНоменклатура = ЦеныНом.Номенклатура)
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
	
	Если ЗначениеЗаполнено(НарядЗадание) И (НЕ НарядЗадание.Проведен ИЛИ НЕ РаскройНаНарядСформирован()) Тогда
		
		 ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Наряд не проведен или раскрой на наряд не сформирован. Запись документа запрещена.");
		 Отказ = Истина;
		 
	ИначеЕсли НЕ ПометкаУдаления И ЗначениеЗаполнено(НарядЗадание) И НЕ НарядЗадание.ЗапретРедактирования Тогда
		
		Попытка
			ОбНаряд = НарядЗадание.ПолучитьОбъект();
			ОбНаряд.ЗапретРедактирования = Истина;
			ОбНаряд.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось перезаписать наряд.");
		 	Отказ = Истина;
		КонецПопытки;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		ДатаСоздания = ТекущаяДата();	
	КонецЕсли;
	
	Если НЕ Проведен И (РежимЗаписи = РежимЗаписиДокумента.Проведение) Тогда
		Дата = ТекущаяДата();	
	КонецЕсли;
	
	Стоимости = ПолучитьСуммыДокумента();
	СуммаДокумента = Стоимости.СтоимостьРозничная;
	
КонецПроцедуры

Функция РаскройНаНарядСформирован()
		
	ПроверятьРаскрой = Ложь;
	Сформирован = Ложь;
	
	СтатусПереданВЦех = Перечисления.СтатусыСпецификации.ПереданВЦех;
	
	Для Каждого Стр ИЗ НарядЗадание.СписокСпецификаций Цикл
	
		СтатусСпецификации = Документы.Спецификация.ПолучитьСтатусСпецификации(Стр.Спецификация);
		
		Если СтатусСпецификации = СтатусПереданВЦех Тогда
			 ПроверятьРаскрой = Истина;
			 Прервать;
		КонецЕсли;
		
	КонецЦикла;
		
	Если НЕ ПроверятьРаскрой Тогда
		Сформирован = Истина;
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НарядЗадание", НарядЗадание);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫРАЗИТЬ(РаскройДеталей.Объект КАК Документ.НарядЗадание) КАК Ссылка,
		|	РаскройДеталей.СтрокаРаскрой КАК Раскрой
		|ИЗ
		|	РегистрСведений.РаскройДеталей КАК РаскройДеталей
		|ГДЕ
		|	РаскройДеталей.Объект = &НарядЗадание";

		Выборка = Запрос.Выполнить().Выбрать();

		Если Выборка.Количество() > 0 Тогда
			
			Сформирован = Истина;
					
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Сформирован;
	
КонецФункции

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
