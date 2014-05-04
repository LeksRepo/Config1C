﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Управленческий.Записать();
	Ошибки = Неопределено;
	
	// { Васильев Александр Леонидович [18.10.2013]
	// Блокировку
	// } Васильев Александр Леонидович [18.10.2013]
	
	Если Дата > '2014.05.01' Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура,
		|	СУММА(ТребованиеНакладнаяСписокНоменклатуры.Отпущено) КАК Количество,
		|	МИНИМУМ(ТребованиеНакладнаяСписокНоменклатуры.НомерСтроки) КАК НомерСтроки
		|ИЗ
		|	Документ.ТребованиеНакладная.СписокНоменклатуры КАК ТребованиеНакладнаяСписокНоменклатуры
		|
		|СГРУППИРОВАТЬ ПО
		|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура";
		
		ТаблицаМатериалов = Запрос.Выполнить().Выгрузить();
		
		ЛексСервер.ПеремещениеМатериаловВПроизводство(ТаблицаМатериалов, Подразделение, Склад, Движения, МоментВремени());
		
	Иначе
		Нехватка = ЛексСервер.ПеремещениеМатериаловСЛогистики(Ссылка, Движения);
	КонецЕсли;
	
	Для каждого СтрокаНехватки Из Нехватка Цикл
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%5 На складе %1 недостаточно свободного материала '%2'. Из требуемых %3 есть только %4", 
		Склад,
		СтрокаНехватки.Номенклатура, 
		СтрокаНехватки.КоличествоТребуется,
		СтрокаНехватки.КоличествоОстаток,
		Ссылка);
		Поле = "СписокНоменклатуры[" +Строка(СтрокаНехватки.НомерСтроки-1) + "].Количество";
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
	
	Если ЗначениеЗаполнено(Виновный) Тогда
		
		// удержим с сотрудника за материалы
		
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.Сумма = Стоимости.СтоимостьРозничная;
		Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Виновный;
		Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыПрочие ; // удержания
		
	КонецЕсли;
	
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
	Запрос.УстановитьПараметр("Регион", Подразделение.Регион);
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
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Период, Регион = &Регион) КАК ЦеныНоменклатурыСрезПоследних
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
	|	втМатериалы.Номенклатура,
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
	|	втМатериалы.Затребовано > 0";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции
