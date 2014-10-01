﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.Управленческий.Записать();
	
	ИтогСебестоимость =0;
	РазныеПодразделения = Подразделение <> ПодразделениеПолучатель;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПеремещениеМатериаловСписокНоменклатуры.Номенклатура,
	|	СУММА(ПеремещениеМатериаловСписокНоменклатуры.Количество) КАК Количество,
	|	МИНИМУМ(ПеремещениеМатериаловСписокНоменклатуры.НомерСтроки) КАК НомерСтроки
	|ПОМЕСТИТЬ втНоменклатура
	|ИЗ
	|	Документ.ПеремещениеМатериалов.СписокНоменклатуры КАК ПеремещениеМатериаловСписокНоменклатуры
	|ГДЕ
	|	ПеремещениеМатериаловСписокНоменклатуры.Ссылка = &Ссылка
	|	И ПеремещениеМатериаловСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|	И ПеремещениеМатериаловСписокНоменклатуры.Количество <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ПеремещениеМатериаловСписокНоменклатуры.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНоменклатура.Номенклатура
	|ИЗ
	|	втНоменклатура КАК втНоменклатура";
	
	//	блокировка
	
	ТЗНоменклатура = Запрос.Выполнить().Выгрузить();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрБухгалтерии.Управленческий");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Подразделение", Подразделение);
	ЭлементБлокировки.УстановитьЗначение("Счет", ПланыСчетов.Управленческий.МатериалыНаСкладе);
	ЭлементБлокировки.ИсточникДанных = ТЗНоменклатура;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура, "Номенклатура");
	Блокировка.Заблокировать();
	
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("СкладОтправитель", Склад);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	втНоменклатура.Номенклатура,
	|	втНоменклатура.НомерСтроки,
	|	втНоменклатура.Количество КАК КоличествоТребуется,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстатокДт, 0) КАК КоличествоОстаток,
	|	ЕСТЬNULL(УправленческийОстатки.СуммаОстатокДт, 0) КАК СуммаОстаток,
	|	УправленческийОстатки.Субконто1
	|ИЗ
	|	ВТНоменклатура КАК втНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				&МоментВремени,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто2 В
	|						(ВЫБРАТЬ
	|							втНоменклатура.Номенклатура
	|						ИЗ
	|							втНоменклатура)
	|					И Субконто1 = &СкладОтправитель) КАК УправленческийОстатки
	|		ПО втНоменклатура.Номенклатура = УправленческийОстатки.Субконто2";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.КоличествоОстаток <Выборка.КоличествоТребуется Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("На складе %1 недостаточно свободного материала %2. Из требуемых %3 есть только %4", 
			Склад,
			Выборка.Номенклатура, 
			Выборка.КоличествоТребуется,
			Выборка.КоличествоОстаток);
			Поле = "СписокНоменклатуры[" +Строка(Выборка.НомерСтроки-1) + "].Номенклатура";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле);
			Отказ = Истина;
			Продолжить;
		КонецЕсли;
		
		Если Отказ Тогда
		Продолжить;
		КонецЕсли;
			
		Если Выборка.КоличествоОстаток = 0 Тогда
			Себестоимость = 0;
		Иначе
			Себестоимость = Выборка.КоличествоТребуется / Выборка.КоличествоОстаток * Выборка.СуммаОстаток;
		КонецЕсли;
		
		Если РазныеПодразделения Тогда
			
			СформироватьПроводкиРазныеПодразделения(Выборка, Себестоимость);
			
		Иначе // перемещение материалов внутри одного подразделения
			
			СформироватьПроводкиПеремещениеМеждуСкладами(Выборка, Себестоимость);
			
		КонецЕсли;
		
		ИтогСебестоимость = ИтогСебестоимость + Себестоимость;
		
	КонецЦикла;
	
	Если НЕ Отказ Тогда
		
		Движения.Управленческий.Записывать = Истина;
		СуммаДокумента = ИтогСебестоимость;
		Записать(РежимЗаписиДокумента.Запись); // это зачем я так сделал?
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеМатериаловУслуг") Тогда
		
		Для каждого Строка Из ДанныеЗаполнения.Материалы Цикл
			НоваяСтрока = СписокНоменклатуры.Добавить();
			НоваяСтрока.Номенклатура = Строка.Номенклатура;
			НоваяСтрока.Количество = Строка.Количество;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ИнвентаризацияМатериалов") Тогда
		
		Склад = ДанныеЗаполнения.Склад;
		
		Для каждого Строка Из ДанныеЗаполнения.СписокНоменклатуры Цикл
			Если Строка.Отклонение < 0 Тогда
				НоваяСтрока = СписокНоменклатуры.Добавить();
				НоваяСтрока.Номенклатура = Строка.Номенклатура;
				НоваяСтрока.Количество = -Строка.Отклонение;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПроводкиРазныеПодразделения(фВыборка, фСебестоимость)
	
	// расходы продавца
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = Дата;
	Проводка.Подразделение = Подразделение;
	Проводка.Сумма = фСебестоимость;
	Проводка.Содержание = "Реализованы материалы своему подразделению";
	
	Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПодразделениями;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Подразделения] = ПодразделениеПолучатель;
	
	Проводка.СчетКт = ПланыСчетов.Управленческий.МатериалыНаСкладе;
	Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = Склад;
	Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = фВыборка.Номенклатура;
	Проводка.КоличествоКт = фВыборка.КоличествоТребуется;
	
	// оприходование получателем
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = Дата;
	Проводка.Подразделение = ПодразделениеПолучатель;
	Проводка.Сумма = фСебестоимость;
	Проводка.Содержание = "Закуплены материалы у подразделения " + Подразделение;
	
	Проводка.СчетДт = ПланыСчетов.Управленческий.МатериалыНаСкладе;;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = СкладПолучатель;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = фВыборка.Номенклатура;
	Проводка.КоличествоДт = фВыборка.КоличествоТребуется;
	
	Проводка.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПодразделениями;
	Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Подразделения] = Подразделение;
	
КонецФункции

Функция СформироватьПроводкиПеремещениеМеждуСкладами(фВыборка, фСебестоимость)
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = Дата;
	Проводка.Подразделение = Подразделение;
	Проводка.СчетДт = ПланыСчетов.Управленческий.МатериалыНаСкладе;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = СкладПолучатель;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = фВыборка.Номенклатура;
	Проводка.КоличествоДт = фВыборка.КоличествоТребуется;
	
	Проводка.СчетКт = ПланыСчетов.Управленческий.МатериалыНаСкладе;
	Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = Склад;
	Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = фВыборка.Номенклатура;
	Проводка.КоличествоКт = фВыборка.КоличествоТребуется;
	Проводка.Сумма = фСебестоимость;
	
	// сразу спишем себестоимость на расходы
	Если СкладПолучатель.БойБрак Тогда
		
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.СчетДт = ПланыСчетов.Управленческий.Расходы;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходыСебестоимостьМатериалаПроизводство;
		
		Проводка.СчетКт = ПланыСчетов.Управленческий.МатериалыНаСкладе;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = СкладПолучатель;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = фВыборка.Номенклатура;
		Проводка.Сумма = фСебестоимость;
		
	КонецЕсли;
	
КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры
