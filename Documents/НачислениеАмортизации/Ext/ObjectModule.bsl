﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Ошибки = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоМесяца", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецМесяца", КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НачислениеАмортизации.Ссылка
	|ИЗ
	|	Документ.НачислениеАмортизации КАК НачислениеАмортизации
	|ГДЕ
	|	НачислениеАмортизации.Дата МЕЖДУ &НачалоМесяца И &КонецМесяца
	|	И НачислениеАмортизации.Подразделение = &Подразделение
	|	И НачислениеАмортизации.Ссылка <> &Ссылка";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		фДата = Формат(Дата, "ДФ=ММММ");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("За %1 по подразделению %2 уже есть документ %3", фДата, Подразделение, Выборка.Ссылка);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Дата", ТекстОшибки);
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИтогСумма = 0;
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Управленческий.ПервоначальнаяСтоимостьОС);
	МассивСчетов.Добавить(ПланыСчетов.Управленческий.АмортизацияОС);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("МассивСчетов", МассивСчетов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.Субконто1 КАК ОсновноеСредство,
	|	МАКСИМУМ(СостояниеОС.СрокАмортизации) КАК СрокАмортизации,
	|	СУММА(УправленческийОстатки.СуммаОстаток) КАК СуммаОстаток,
	|	СУММА(ВЫБОР
	|			КОГДА УправленческийОстатки.Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.АмортизацияОС)
	|				ТОГДА УправленческийОстатки.СуммаОстаток
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК АмортизацияСумма,
	|	СУММА(ВЫБОР
	|			КОГДА УправленческийОстатки.Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПервоначальнаяСтоимостьОС)
	|				ТОГДА УправленческийОстатки.СуммаОстаток
	|		КОНЕЦ) КАК СуммаПС
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(&МоментВремени, Счет В (&МассивСчетов), , Подразделение = &Подразделение) КАК УправленческийОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеОсновныхСредств.СрезПоследних КАК СостояниеОС
	|		ПО СостояниеОС.ОсновноеСредство = УправленческийОстатки.Субконто1
	|ГДЕ
	|	СостояниеОС.НачислятьАмортизацию
	|
	|СГРУППИРОВАТЬ ПО
	|	УправленческийОстатки.Субконто1";
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.СуммаОстаток > 0 Тогда
				
				// { Васильев Александр Леонидович [19.11.2014]
				// Тут нужно флаг сбросить, начислять ли амортизацию.
				// } Васильев Александр Леонидович [19.11.2014]
				СуммаАмортизации = Мин(Выборка.СуммаПС / Выборка.СрокАмортизации, Выборка.СуммаОстаток);
				
				Проводка = Движения.Управленческий.Добавить();
				Проводка.Период = Дата;
				Проводка.Подразделение = Подразделение;
				Проводка.Сумма = СуммаАмортизации;
				Проводка.СчетДт = ПланыСчетов.Управленческий.Расходы;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.АмортизацияОС;
				Проводка.СчетКт = ПланыСчетов.Управленческий.АмортизацияОС;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ОсновныеСредства] = Выборка.ОсновноеСредство;
				
				ИтогСумма = СуммаАмортизации + ИтогСумма;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Движения.Управленческий.Записывать = Истина;
		СуммаДокумента = ИтогСумма;
		Записать(РежимЗаписиДокумента.Запись);
		
	КонецЕсли
	
КонецПроцедуры
