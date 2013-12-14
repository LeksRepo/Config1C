﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Управленческий.Записать();
	Ошибки = Неопределено;
	
	// { Васильев Александр Леонидович [18.10.2013]
	// Блокировку
	// } Васильев Александр Леонидович [18.10.2013]
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МИНИМУМ(ТребованиеНакладнаяСписокНоменклатуры.НомерСтроки) КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.Базовый
	|			ТОГДА ТребованиеНакладнаяСписокНоменклатуры.Номенклатура
	|		ИНАЧЕ ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.БазоваяНоменклатура
	|	КОНЕЦ КАК Номенклатура,
	|	СУММА(ВЫБОР
	|			КОГДА ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.Базовый
	|				ТОГДА ТребованиеНакладнаяСписокНоменклатуры.Отпущено
	|			ИНАЧЕ ТребованиеНакладнаяСписокНоменклатуры.Отпущено * ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.КоэффициентБазовых
	|		КОНЕЦ) КАК Количество
	|ПОМЕСТИТЬ СписокНоменклатуры
	|ИЗ
	|	Документ.ТребованиеНакладная.СписокНоменклатуры КАК ТребованиеНакладнаяСписокНоменклатуры
	|ГДЕ
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.Базовый
	|			ТОГДА ТребованиеНакладнаяСписокНоменклатуры.Номенклатура
	|		ИНАЧЕ ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.БазоваяНоменклатура
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокНоменклатуры.Номенклатура,
	|	ВЫБОР
	|		КОГДА СписокНоменклатуры.Номенклатура.Базовый
	|			ТОГДА СписокНоменклатуры.Количество + ЕСТЬNULL(ОстаткиВЦеху.КоличествоРазвернутыйОстатокДт, 0)
	|		ИНАЧЕ СписокНоменклатуры.Количество * СписокНоменклатуры.Номенклатура.КоэффициентБазовых + ЕСТЬNULL(ОстаткиВЦеху.КоличествоРазвернутыйОстатокДт, 0)
	|	КОНЕЦ КАК КоличествоТребуемых,
	|	ЕСТЬNULL(БазовыйЛимитЦехаСрезПоследних.Количество, 0) + ЕСТЬNULL(ДополнительныйЛимитЦеха.КоличествоОстаток, 0) КАК КоличествоРазрешенных,
	|	СписокНоменклатуры.НомерСтроки
	|ИЗ
	|	СписокНоменклатуры КАК СписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.БазовыйЛимитЦеха.СрезПоследних(
	|				&МоментВремени,
	|				Подразделение = &Подразделение
	|					И Номенклатура В
	|						(ВЫБРАТЬ
	|							СписокНоменклатуры.Номенклатура
	|						ИЗ
	|							СписокНоменклатуры КАК СписокНоменклатуры)) КАК БазовыйЛимитЦехаСрезПоследних
	|		ПО СписокНоменклатуры.Номенклатура = БазовыйЛимитЦехаСрезПоследних.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				&МоментВремени,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ОсновноеПроизводство),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто1 В
	|						(ВЫБРАТЬ
	|							СписокНоменклатуры.Номенклатура
	|						ИЗ
	|							СписокНоменклатуры КАК СписокНоменклатуры)) КАК ОстаткиВЦеху
	|		ПО СписокНоменклатуры.Номенклатура = ОстаткиВЦеху.Субконто1
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				&МоментВремени,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ДополнительныйЛимитЦеха),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто1 В
	|						(ВЫБРАТЬ
	|							СписокНоменклатуры.Номенклатура
	|						ИЗ
	|							СписокНоменклатуры КАК СписокНоменклатуры)) КАК ДополнительныйЛимитЦеха
	|		ПО СписокНоменклатуры.Номенклатура = ДополнительныйЛимитЦеха.Субконто1";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.КоличествоТребуемых > Выборка.КоличествоРазрешенных Тогда
			
			Поле = "СписокНоменклатуры[" +Строка(Выборка.НомерСтроки-1) + "].Количество";
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 превышение лимита на %2 "+ Выборка.Номенклатура.ЕдиницаИзмерения, 
			Выборка.Номенклатура, Выборка.КоличествоТребуемых - Выборка.КоличествоРазрешенных);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстСообщения);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если Ошибки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		Возврат;
		
	КонецЕсли;
	
	Нехватка = ЛексСервер.ПеремещениеМатериаловСЛогистики(Ссылка, Движения);
	
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
	
	СебестоимостьМатериалов = Движения.Управленческий.Итог("Сумма") / 2;
	
	Если ЗначениеЗаполнено(Виновный) Тогда
		
		// удержим с сотрудника за материалы
		
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.Сумма = СебестоимостьМатериалов;
		Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Виновный;
		Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ПустаяСсылка() ; // удержания
		
	КонецЕсли;
	
	СуммаДокумента = СебестоимостьМатериалов;
	Движения.Управленческий.Записывать = Истина;
	Записать(РежимЗаписиДокумента.Запись);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.НарядЗадание") Тогда
		
		Подразделение = ДанныеЗаполнения.Подразделение;
		Склад = Подразделение.ОсновнойСклад;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	спрНоменклатура.БазоваяНоменклатура,
		|	спрНоменклатура.Ссылка,
		|	спрНоменклатура.ОсновнаяПоСкладу,
		|	спрНоменклатура.КоэффициентБазовых
		|ПОМЕСТИТЬ Список
		|ИЗ
		|	Справочник.Номенклатура КАК спрНоменклатура
		|ГДЕ
		|	спрНоменклатура.ОсновнаяПоСкладу
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА Список.Ссылка ЕСТЬ NULL 
		|			ТОГДА табНарядЗаданиеСписокНоменклатуры.Номенклатура
		|		ИНАЧЕ Список.Ссылка
		|	КОНЕЦ КАК Номенклатура,
		|	ВЫРАЗИТЬ(ВЫБОР
		|			КОГДА Список.Ссылка ЕСТЬ NULL 
		|				ТОГДА табНарядЗаданиеСписокНоменклатуры.Затребовано
		|			ИНАЧЕ табНарядЗаданиеСписокНоменклатуры.Затребовано / ЕСТЬNULL(Список.КоэффициентБазовых, 1)
		|		КОНЕЦ + 0.5 КАК ЧИСЛО(15, 0)) КАК Затребовано,
		|	"""""""" КАК Содержание
		|ИЗ
		|	Документ.НарядЗадание.СписокНоменклатуры КАК табНарядЗаданиеСписокНоменклатуры
		|		ЛЕВОЕ СОЕДИНЕНИЕ Список КАК Список
		|		ПО табНарядЗаданиеСписокНоменклатуры.Номенклатура = Список.БазоваяНоменклатура
		|ГДЕ
		|	табНарядЗаданиеСписокНоменклатуры.Ссылка = &Ссылка";
		
		СписокНоменклатуры.Загрузить(Запрос.Выполнить().Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры
