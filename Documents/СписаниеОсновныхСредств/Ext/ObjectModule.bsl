﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("тзОС", ОсновныеСредства);
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(тзОС.ОсновноеСредство КАК Справочник.ОсновныеСредства) КАК ОсновноеСредство,
	|	тзОС.НомерСтроки
	|ПОМЕСТИТЬ втОС
	|ИЗ
	|	&тзОС КАК тзОС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВЫБОР
	|			КОГДА УправленческийОстатки.Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.АмортизацияОС)
	|				ТОГДА УправленческийОстатки.СуммаОстатокКт
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Амортизация,
	|	СУММА(ВЫБОР
	|			КОГДА УправленческийОстатки.Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПервоначальнаяСтоимостьОС)
	|				ТОГДА УправленческийОстатки.СуммаОстатокДт
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Стоимость,
	|	втОС.ОсновноеСредство,
	|	МАКСИМУМ(втОС.НомерСтроки) КАК НомерСтроки
	|ИЗ
	|	втОС КАК втОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				&МоментВремени,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПервоначальнаяСтоимостьОС)
	|					ИЛИ Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.АмортизацияОС),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто1 В
	|						(ВЫБРАТЬ
	|							Т.ОсновноеСредство
	|						ИЗ
	|							втОС КАК Т)) КАК УправленческийОстатки
	|		ПО втОС.ОсновноеСредство = УправленческийОстатки.Субконто1
	|
	|СГРУППИРОВАТЬ ПО
	|	втОС.ОсновноеСредство
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Результат = Запрос.Выполнить();
	ОсновныеСредства.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.СостояниеОсновныхСредств.Очистить();
	Движения.СостояниеОсновныхСредств.Записать();
	
	Движения.Управленческий.Очистить();
	Движения.Управленческий.Записать();
	
	Ошибки = Неопределено;
	
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Управленческий.ПервоначальнаяСтоимостьОС);
	МассивСчетов.Добавить(ПланыСчетов.Управленческий.АмортизацияОС);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписаниеОСОсновныеСредства.ОсновноеСредство,
	|	СписаниеОСОсновныеСредства.НомерСтроки,
	|	СписаниеОСОсновныеСредства.Амортизация,
	|	СписаниеОСОсновныеСредства.Стоимость
	|ПОМЕСТИТЬ тчДок
	|ИЗ
	|	Документ.СписаниеОсновныхСредств.ОсновныеСредства КАК СписаниеОСОсновныеСредства
	|ГДЕ
	|	СписаниеОСОсновныеСредства.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	тчДок.ОсновноеСредство,
	|	тчДок.НомерСтроки КАК НомерСтроки,
	|	тчДок.Амортизация КАК Амортизация,
	|	тчДок.Стоимость КАК ПервоначальнаяСтоимость,
	|	ЕСТЬNULL(СостояниеОССрезПоследних.ПринятоКУчету, ЛОЖЬ) КАК ПринятоКУчету,
	|	СостояниеОССрезПоследних.СрокАмортизации
	|ИЗ
	|	тчДок КАК тчДок
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеОсновныхСредств.СрезПоследних(
	|				&МоментВремени,
	|				ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						т.ОсновноеСредство
	|					ИЗ
	|						тчДок КАК т)) КАК СостояниеОССрезПоследних
	|		ПО тчДок.ОсновноеСредство = СостояниеОССрезПоследних.ОсновноеСредство";
	
	Выборка = Запрос.Выполнить().Выбрать();
	ПолеОшибки = "Объект.ОсновныеСредства[%1].ОсновноеСредство";
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ Выборка.ПринятоКУчету ИЛИ (Выборка.ПервоначальнаяСтоимость + Выборка.Амортизация) = 0 Тогда
			ТекстГруппыОшибок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Основное средство %1 (строка %%1) по данным управленческого учета не числится", Выборка.ОсновноеСредство);
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Основное средство %1  по данным управленческого учета не числится", Выборка.ОсновноеСредство);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, ПолеОшибки, ТекстОшибки, 1, Выборка.НомерСтроки - 1, ТекстГруппыОшибок);
		КонецЕсли;
		
		Если Ошибки <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Проводки = Движения.СостояниеОсновныхСредств.Добавить();
		Проводки.ОсновноеСредство = Выборка.ОсновноеСредство;
		Проводки.Период = Дата;
		Проводки.ПринятоКУчету = Ложь;
		Проводки.СрокАмортизации = Выборка.СрокАмортизации; // Оставим в РС для печати ОС-4
		
		Если Выборка.Амортизация > 0 Тогда
			Проводки = Движения.Управленческий.Добавить();
			Проводки.Период = Дата;
			Проводки.Подразделение = Подразделение;
			Проводки.Сумма = Выборка.Амортизация;
			
			Проводки.СчетДт = ПланыСчетов.Управленческий.АмортизацияОС;
			Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ОсновныеСредства] = Выборка.ОсновноеСредство;
			
			Проводки.СчетКт = ПланыСчетов.Управленческий.ПервоначальнаяСтоимостьОС;
			Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ОсновныеСредства] = Выборка.ОсновноеСредство;
		КонецЕсли;
		
		ОстаточнаяСтоимость = Выборка.ПервоначальнаяСтоимость - Выборка.Амортизация;
		
		Если ОстаточнаяСтоимость > 0 Тогда
			Проводки = Движения.Управленческий.Добавить();
			Проводки.Период = Дата;
			Проводки.Подразделение = Подразделение;
			Проводки.Сумма = ОстаточнаяСтоимость;
			
			Проводки.СчетДт = ПланыСчетов.Управленческий.Расходы;
			Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходыВыбытиеОсновныхСредств;
			
			Проводки.СчетКт = ПланыСчетов.Управленческий.ПервоначальнаяСтоимостьОС;
			Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ОсновныеСредства] = Выборка.ОсновноеСредство;
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если НЕ Отказ Тогда
		
		Движения.Управленческий.Записывать = Истина;
		Движения.СостояниеОсновныхСредств.Записывать = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
