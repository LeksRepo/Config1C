﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Управленческий.Записать();
	Ошибки = Неопределено;
	
	// { Васильев Александр Леонидович [18.10.2013]
	// Блокировку
	// } Васильев Александр Леонидович [18.10.2013]
	
	Если Дата >= '2014.06.01' Тогда // костыль
		
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
		
		Нехватка = ЛексСервер.ПеремещениеМатериаловВПроизводство(ТаблицаМатериалов, Подразделение, Склад, Движения, МоментВремени());
		
	Иначе
		Нехватка = ЛексСервер.ПеремещениеМатериаловСЛогистики(Ссылка, Движения);
	КонецЕсли;
	
	Для каждого СтрокаНехватки Из Нехватка Цикл
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%5 На складе %1 недостаточно материала '%2'. Из требуемых %3 есть только %4", 
		Склад,
		СтрокаНехватки.Номенклатура, 
		СтрокаНехватки.КоличествоТребуется,
		СтрокаНехватки.КоличествоОстаток,
		Ссылка);
		Поле = "Объект.СписокНоменклатуры[" +Строка(СтрокаНехватки.НомерСтроки-1) + "].Отпущено";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстСообщения);
		
	КонецЦикла;
	
	Если Ошибки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		Возврат;
		
	КонецЕсли;
	
	Попытка
		СебестоимостьМатериалов = Движения.Управленческий[3].Сумма; // уебанский способ :(
	Исключение
		СебестоимостьМатериалов = 0;
	КонецПопытки;
	
	Стоимости = ПолучитьСуммыДокумента();
	СуммаДокумента = Стоимости.СтоимостьВнутренняя;
	Себестоимость = СебестоимостьМатериалов;
	Движения.Управленческий.Записывать = Истина;
	Записать(РежимЗаписиДокумента.Запись);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанных = ТипЗнч(ДанныеЗаполнения);
	
	ЭтоСпецификация = ТипДанных = Тип("ДокументСсылка.Спецификация");
	ЭтоНаряд = ТипДанных = Тип("ДокументСсылка.НарядЗадание");
	
	Если ЭтоНаряд ИЛИ ЭтоСпецификация Тогда
		
		Если ЭтоНаряд Тогда
			Подразделение = ДанныеЗаполнения.Подразделение;
		ИначеЕсли ЭтоСпецификация Тогда
			Подразделение = ДанныеЗаполнения.Производство;
		КонецЕсли;
		
		Склад = Подразделение.ОсновнойСклад;
		Комментарий = "Введено на основании " + ДанныеЗаполнения;
		
		Таблица = СформироватьТаблицу(ДанныеЗаполнения, ЭтоНаряд);
		СписокНоменклатуры.Загрузить(Таблица);
		
	КонецЕсли;
	
КонецПроцедуры

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
	|		ИНАЧЕ ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.КоэффициентБазовых * ТребованиеНакладнаяСписокНоменклатуры.Отпущено * ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Внутренняя, 0)
	|	КОНЕЦ КАК СтоимостьВнутренняя,
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
	|	СУММА(СтоимостьВнутренняя),
	|	СУММА(СтоимостьРозничная)
	|ПО
	|	ОБЩИЕ";
	
	ОбщийИтогВыборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ОбщийИтогВыборка.Следующий();
	
	Структура = Новый Структура;
	Структура.Вставить("СтоимостьВнутренняя", ОбщийИтогВыборка.СтоимостьВнутренняя);
	Структура.Вставить("СтоимостьРозничная", ОбщийИтогВыборка.СтоимостьРозничная);
	
	Возврат Структура;
	
КонецФункции

Функция СформироватьТаблицу(ДанныеЗаполнения, ЭтоНаряд)
	
	Если ЭтоНаряд Тогда
		ТаблицаТребуемыхМатериалов = ДанныеЗаполнения.СписокНоменклатуры;
	Иначе
		Массив = Новый Массив;
		Массив.Добавить(ДанныеЗаполнения);
		ТаблицаТребуемыхМатериалов = Документы.Спецификация.ПолучитьТаблицуМатериалов(Массив);
	КонецЕсли;
	
	Массив = ТаблицаТребуемыхМатериалов.ВыгрузитьКолонку("Номенклатура");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивНоменклатуры", Массив);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	спрНоменклатура.БазоваяНоменклатура,
	|	спрНоменклатура.Ссылка,
	|	спрНоменклатура.КоэффициентБазовых
	|ПОМЕСТИТЬ Список
	|ИЗ
	|	Справочник.Номенклатура КАК спрНоменклатура
	|ГДЕ
	|	спрНоменклатура.ОсновнаяПоСкладу
	|	И спрНоменклатура.БазоваяНоменклатура В(&МассивНоменклатуры)";
	
	Запрос.Выполнить();
	
	Запрос.УстановитьПараметр("тзМатериалы", ТаблицаТребуемыхМатериалов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(втМатериалы.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	втМатериалы.Затребовано КАК Затребовано
	|ПОМЕСТИТЬ втМатериалы
	|ИЗ
	|	&тзМатериалы КАК втМатериалы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Список.Ссылка ЕСТЬ NULL 
	|			ТОГДА втМатериалы.Номенклатура
	|		ИНАЧЕ Список.Ссылка
	|	КОНЕЦ КАК Номенклатура,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА Список.Ссылка ЕСТЬ NULL 
	|				ТОГДА втМатериалы.Затребовано
	|			ИНАЧЕ втМатериалы.Затребовано / ЕСТЬNULL(Список.КоэффициентБазовых, 1)
	|		КОНЕЦ + 0.4999999999999 КАК ЧИСЛО(15, 0)) КАК Затребовано,
	|	NULL КАК Содержание
	|ИЗ
	|	втМатериалы КАК втМатериалы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Список КАК Список
	|		ПО втМатериалы.Номенклатура = Список.БазоваяНоменклатура
	|ГДЕ
	|	втМатериалы.Затребовано > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	втМатериалы.Номенклатура.ЦеховаяЗона,
	|	втМатериалы.Номенклатура.Родитель.Наименование,
	|	втМатериалы.Номенклатура.Наименование";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Ошибки;
	
	Если Дата > '2014.09.16' Тогда
		
		Для каждого Строка Из СписокНоменклатуры Цикл
			
			Если Строка.Номенклатура.МестоОбработки <> Перечисления.МестоОбработки.Цех Тогда
				СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 передается документом Комплектация", Строка.Номенклатура);
				Поле = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("СписокНоменклатуры[%1].Номенклатура", Строка.НомерСтроки - 1);
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, СтрокаСообщения);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры
