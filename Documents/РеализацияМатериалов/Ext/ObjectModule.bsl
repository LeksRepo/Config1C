﻿
#Область События

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Перем Ошибки;
	
	СкладскойУчет = ЛексСервер.ПолучитьНастройкуПодразделения(Подразделение, Перечисления.ВидыНастроекПодразделений.СкладскойУчет);
	
	Движения.Управленческий.Записывать = Истина;
	Движения.Управленческий.Записать();
	
	Если СкладскойУчет Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
		Запрос.УстановитьПараметр("Склад", Склад);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	МИНИМУМ(тчОбъединение.НомерСтроки) КАК НомерСтроки,
		|	тчОбъединение.Номенклатура,
		|	СУММА(тчОбъединение.Количество) КАК Количество,
		|	СУММА(тчОбъединение.Сумма) КАК Сумма
		|ПОМЕСТИТЬ тчДок
		|ИЗ
		|	(ВЫБРАТЬ
		|		РеализацияМатериаловСписокНоменклатуры.НомерСтроки - 1 КАК НомерСтроки,
		|		РеализацияМатериаловСписокНоменклатуры.Номенклатура КАК Номенклатура,
		|		РеализацияМатериаловСписокНоменклатуры.Количество КАК Количество,
		|		РеализацияМатериаловСписокНоменклатуры.Сумма КАК Сумма
		|	ИЗ
		|		Документ.РеализацияМатериалов.СписокНоменклатуры КАК РеализацияМатериаловСписокНоменклатуры
		|	ГДЕ
		|		РеализацияМатериаловСписокНоменклатуры.Ссылка = &Ссылка
		|		И (РеализацияМатериаловСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
		|				ИЛИ РеализацияМатериаловСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Комплект))
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		0,
		|		РеализацияМатериаловОбрезкиХлыстовогоМатериала.Номенклатура,
		|		1,
		|		РеализацияМатериаловОбрезкиХлыстовогоМатериала.Сумма
		|	ИЗ
		|		Документ.РеализацияМатериалов.ОбрезкиХлыстовогоМатериала КАК РеализацияМатериаловОбрезкиХлыстовогоМатериала
		|	ГДЕ
		|		РеализацияМатериаловОбрезкиХлыстовогоМатериала.Ссылка = &Ссылка
		|		И НЕ РеализацияМатериаловОбрезкиХлыстовогоМатериала.Номенклатура.Базовый) КАК тчОбъединение
		|
		|СГРУППИРОВАТЬ ПО
		|	тчОбъединение.Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	тчДок.НомерСтроки,
		|	тчДок.Номенклатура,
		|	тчДок.Количество,
		|	тчДок.Сумма КАК Сумма,
		|	ЕСТЬNULL(УправленческийОстатки.СуммаОстаток, 0) КАК СтоимостьОстаток,
		|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток
		|ИЗ
		|	тчДок КАК тчДок
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
		|				&МоментВремени,
		|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
		|				,
		|				Подразделение = &Подразделение
		|					И Субконто1 = &Склад
		|					И Субконто2 В
		|						(ВЫБРАТЬ
		|							т.Номенклатура
		|						ИЗ
		|							тчДок КАК т)) КАК УправленческийОстатки
		|		ПО тчДок.Номенклатура = УправленческийОстатки.Субконто2";
		
		Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.Количество > Выборка.КоличествоОстаток Тогда
				
				ПолеОшибки = "Объект.СписокНоменклатуры[%1].Количество";
				
				ТекстСообщения = "На складе '%1' недостаточно товара '%2'%3 Из требуемых %4 есть только %5";
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстСообщения,
				Склад,
				Выборка.Номенклатура,
				Символы.ПС,
				Выборка.Количество,
				Выборка.КоличествоОстаток);
				
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, ПолеОшибки, ТекстСообщения, , Выборка.НомерСтроки);
				
				ОстаткиВДругихЕдиницах = ЛексСервер.ПолучитьОстаткиВДругихЕдиницах(Выборка.Номенклатура, Склад, МоментВремени(), Подразделение);
				Для каждого СтрокаОстаток Из ОстаткиВДругихЕдиницах Цикл
					
					ТекстСообщения = "Остаток '%1' в количестве %2";
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстСообщения,
					СтрокаОстаток.Номенклатура,
					СтрокаОстаток.Количество);
					
					ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, ПолеОшибки, ТекстСообщения, , Выборка.НомерСтроки);
					
				КонецЦикла;
				
				Отказ = Истина;
				
			КонецЕсли;
			
			Если Отказ Тогда
				Продолжить;
			КонецЕсли;
			
			Если Выборка.КоличествоОстаток > 0 Тогда
				Себестоимость = Выборка.Количество / Выборка.КоличествоОстаток * Выборка.СтоимостьОстаток;
			Иначе
				Себестоимость = 0;
			КонецЕсли;
			
			Проводки = Движения.Управленческий.Добавить();
			Проводки.Период = Дата;
			Проводки.Подразделение = Подразделение;
			
			Счет = ПланыСчетов.Управленческий.Расходы;
			Проводки.СчетДт =Счет;
			Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходыСебестоимостьРеализованногоМатериала;
			Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Выборка.Номенклатура;
			Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = Ссылка.Склад;
			
			Проводки.СчетКт = ПланыСчетов.Управленческий.МатериалыНаСкладе;
			Проводки.КоличествоКт = Выборка.Количество;
			Проводки.Сумма = Себестоимость;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных;
	ЗаблокироватьОбрезкиХлыстовогоМатериала(Блокировка);
	Блокировка.Заблокировать();
	
	ПроверитьПлановуюЦену(Ошибки, Отказ);
	ПроверитьОстаткиОбрезков(Ошибки, Отказ);
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если НЕ Отказ Тогда
		
		ДвиженияОбрезкиХлыстовогоМатериала(Отказ);
		ДвиженияВзаиморасчеты(Отказ);
		ДвиженияПоказателиСотрудников();
		ДвиженияДоходы();
		ДвиженияПродажиФакт();
		
		Движения.Управленческий.Записывать = Истина;
		Движения.ПродажиФакт.Записывать = Истина;
		Движения.ОбрезкиХлыстовойМатериал.Записывать = Истина;
		Движения.ОбрезкиЛистовойМатериал.Записывать = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	СуммаДокумента = СписокНоменклатуры.Итог("Сумма") + ОбрезкиХлыстовогоМатериала.Итог("Сумма");
	
	Дилерский = ТипЗнч(Автор) = Тип("СправочникСсылка.ВнешниеПользователи");
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Дата = ТекущаяДата();
	КонецЕсли;
	
	Если НЕ Проведен И (РежимЗаписи = РежимЗаписиДокумента.Проведение) Тогда
		Дата = ТекущаяДата();	
	КонецЕсли;
	
	Если ПакетУслуг <> Перечисления.ПакетыУслуг.СамовывозОтПроизводителя
		И НЕ ЗначениеЗаполнено(ДатаОтгрузки) Тогда
		ДатаОтгрузки = ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		Контрагент = ПользователиКлиентСервер.ТекущийВнешнийПользователь().ОбъектАвторизации;
		Подразделение = Контрагент.Подразделение;
		Склад = Подразделение.ОсновнойСклад;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Отказ = ЛексСервер.ДоступнаОтменаПроведения(Ссылка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Ошибки;
	
	Если ПакетУслуг <> Перечисления.ПакетыУслуг.СамовывозОтПроизводителя И АдресДоставки = "Введите адрес" Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.АдресДоставки", "Не указан адрес");
		
		// Проверка на отгрузку в выходной
		СтруктураНорматива = Документы.Спецификация.ПолучитьСтруктуруНорматива(ДатаОтгрузки, Подразделение);
		Норматив = СтруктураНорматива.СтоимостьУслугПлан;
		
		Если Норматив = 0 Тогда
			ТекстСообщения = "" +Формат(ДатаОтгрузки, "ДФ=dd.MM.yyyy") + " - выходной. Выберите другой день отгрузки.";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДатаОтгрузки", ТекстСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область Движения

Функция ДвиженияПродажиФакт()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияМатериаловСписокНоменклатуры.Номенклатура,
	|	РеализацияМатериаловСписокНоменклатуры.Номенклатура.Серийная КАК Серийная,
	|	СУММА(РеализацияМатериаловСписокНоменклатуры.Сумма) КАК Сумма,
	|	СУММА(РеализацияМатериаловСписокНоменклатуры.Количество) КАК Количество
	|ИЗ
	|	Документ.РеализацияМатериалов.СписокНоменклатуры КАК РеализацияМатериаловСписокНоменклатуры
	|ГДЕ
	|	РеализацияМатериаловСписокНоменклатуры.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	РеализацияМатериаловСписокНоменклатуры.Номенклатура,
	|	РеализацияМатериаловСписокНоменклатуры.Номенклатура.Серийная";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Проводка = Движения.ПродажиФакт.Добавить();
		
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		
		Если Выборка.Серийная Тогда
			Проводка.ВидПродажи = Перечисления.ВидыПродаж.СерийнаяМебель;
		Иначе
			Проводка.ВидПродажи = Перечисления.ВидыПродаж.Материалы;
		КонецЕсли;
		
		Если ТипЗнч(Автор) = Тип("СправочникСсылка.Пользователи") Тогда
			Проводка.Сотрудник = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Автор, "ФизическоеЛицо");
		КонецЕсли;
		
		Проводка.Контрагент = Контрагент;
		Проводка.Офис = Офис;
		Проводка.Номенклатура = Выборка.Номенклатура;
		Проводка.Количество = Выборка.Количество;
		Проводка.Сумма = Выборка.Сумма;
		
	КонецЦикла;
	
КонецФункции

Функция СоздатьПроводкуПоказатель(Сотрудник, Показатель)
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = Дата;
	Проводка.Подразделение = Подразделение;
	Проводка.СчетДт = ПланыСчетов.Управленческий.ПоказателиСотрудника;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ВидыПоказателейСотрудников] = Показатель;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Сотрудник;
	Проводка.Сумма = СуммаДокумента;
	
КонецФункции

Функция ДвиженияПоказателиСотрудников()
	
	Если ТипЗнч(Автор) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		Сотрудник = Автор.ОбъектАвторизации.Супервайзер;
	Иначе
		Сотрудник = Автор.ФизическоеЛицо;
	КонецЕсли;
	
КонецФункции

Функция ДвиженияДоходы()
	
	Проводки = Движения.Управленческий.Добавить();
	Проводки.Период = Дата;
	Проводки.Подразделение = Подразделение;
	Проводки.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
	Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = Контрагент;
	Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ДокументВзаиморасчетов] = Ссылка;
	
	Проводки.СчетКт = ПланыСчетов.Управленческий.Доходы;
	Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыОтРеализацииМатериалов;
	Проводки.Сумма = СуммаДокумента;
	
КонецФункции

Функция ДвиженияВзаиморасчеты(Отказ)
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Контрагент.Дилер Тогда
		
		СуммаОплаты = ЛексСервер.ПолучитьАвансДилера(Контрагент, Подразделение, МоментВремени());
		
	Иначе
		
		СуммаОплаты = ЛексСервер.ПолучитьАвансПоДокументу(Контрагент, Подразделение, Дата, Ссылка);
		
	КонецЕсли;
	
	Если СуммаОплаты >= СуммаДокумента ИЛИ Контрагент.РеализацияБезПредоплаты Тогда
		
		Если Контрагент.Дилер Тогда
			ЛексСервер.ЗачестьАвансДилера(Движения, Контрагент, Подразделение, Дата, Ссылка, СуммаДокумента);
		КонецЕсли;
		
	Иначе
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		СтрокиСообщений.АвансНедостаточен(),
		СуммаОплаты,
		СуммаДокумента);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.СуммаДокумента",, Отказ);
		
	КонецЕсли;
	
КонецФункции

Функция ДвиженияОбрезкиХлыстовогоМатериала(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.НомерСтроки,
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.Номенклатура,
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.Номенклатура.Базовый КАК Базовый,
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.РазмерХлыста,
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.РазмерЗаготовки
	|ИЗ
	|	Документ.РеализацияМатериалов.ОбрезкиХлыстовогоМатериала КАК РеализацияМатериаловОбрезкиХлыстовогоМатериала
	|ГДЕ
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Базовый Тогда
			
			ДобавитьДвижениеОбрезкиХлыстовогоМатериала(Выборка, Выборка.РазмерХлыста, ВидДвиженияНакопления.Расход);
			
		КонецЕсли;
		
		ОстатокОтХлыста = Выборка.РазмерХлыста - Выборка.РазмерЗаготовки;
		Если ОстатокОтХлыста > 0 Тогда
			ДобавитьДвижениеОбрезкиХлыстовогоМатериала(Выборка, ОстатокОтХлыста, ВидДвиженияНакопления.Приход);
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

Функция ЗаблокироватьОбрезкиХлыстовогоМатериала(Блокировка)
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ОбрезкиХлыстовойМатериал");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ОбрезкиХлыстовогоМатериала;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Размер", "РазмерХлыста");
	ЭлементБлокировки.УстановитьЗначение("Подразделение", Подразделение);
	
КонецФункции

Функция ДобавитьДвижениеОбрезкиХлыстовогоМатериала(фнВыборка, фнРазмер, фнВидДвижения)
	
	Проводка = Движения.ОбрезкиХлыстовойМатериал.Добавить();
	Проводка.ВидДвижения = фнВидДвижения;
	Проводка.Период = Дата;
	Проводка.Подразделение = Подразделение;
	
	Если фнВыборка.Номенклатура.Базовый Тогда 
		Проводка.Номенклатура = фнВыборка.Номенклатура;
	Иначе
		Проводка.Номенклатура = фнВыборка.Номенклатура.БазоваяНоменклатура;
	КонецЕсли;
	
	Проводка.Размер = фнРазмер;
	Проводка.Количество = 1;
	
КонецФункции

#КонецОбласти

#Область Проверки

Функция ПроверитьОстаткиОбрезков(Ошибки, Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(РеализацияМатериаловОбрезкиХлыстовогоМатериала.НомерСтроки) КАК НомерСтроки,
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.Номенклатура,
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.РазмерХлыста,
	|	СУММА(1) КАК Количество
	|ПОМЕСТИТЬ втСписокОбрезков
	|ИЗ
	|	Документ.РеализацияМатериалов.ОбрезкиХлыстовогоМатериала КАК РеализацияМатериаловОбрезкиХлыстовогоМатериала
	|ГДЕ
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.Номенклатура,
	|	РеализацияМатериаловОбрезкиХлыстовогоМатериала.РазмерХлыста
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втСписокОбрезков.НомерСтроки,
	|	втСписокОбрезков.Номенклатура,
	|	втСписокОбрезков.Номенклатура.Базовый КАК Базовый,
	|	втСписокОбрезков.РазмерХлыста,
	|	ЕСТЬNULL(ОбрезкиХлыстовойМатериалОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток
	|ИЗ
	|	втСписокОбрезков КАК втСписокОбрезков,
	|	РегистрНакопления.ОбрезкиХлыстовойМатериал.Остатки(
	|			&МоментВремени,
	|			(Номенклатура, Размер) В
	|				(ВЫБРАТЬ
	|					т.Номенклатура,
	|					т.РазмерХлыста
	|				ИЗ
	|					втСписокОбрезков КАК т)) КАК ОбрезкиХлыстовойМатериалОстатки";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		
		
	КонецЦикла;
	
КонецФункции

Процедура ПроверитьПлановуюЦену(Ошибки, Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	Список.Цена КАК Цена,
	|	Список.НомерСтроки
	|ПОМЕСТИТЬ втСписокНом
	|ИЗ
	|	&СписокНоменклатуры КАК Список
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокНом.Номенклатура,
	|	СписокНом.НомерСтроки,
	|	СписокНом.Цена,
	|	ЕСТЬNULL(Настройки.ПлановаяЗакупочная, 0) КАК ПлановаяЦена
	|ИЗ
	|	втСписокНом КАК СписокНом
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(&Период, Подразделение = &Подразделение) КАК Настройки
	|		ПО (СписокНом.Номенклатура = Настройки.Номенклатура
	|				ИЛИ СписокНом.Номенклатура.БазоваяНоменклатура = Настройки.Номенклатура)
	|ГДЕ
	|	ВЫБОР
	|			КОГДА СписокНом.Номенклатура.Базовый
	|				ТОГДА СписокНом.Цена < ЕСТЬNULL(Настройки.ПлановаяЗакупочная, 0)
	|			ИНАЧЕ СписокНом.Цена < ЕСТЬNULL(Настройки.ПлановаяЗакупочная, 0) * СписокНом.Номенклатура.КоэффициентБазовых
	|		КОНЕЦ";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"%1: Цена реализации %3 %2, не должна быть ниже плановой цены %4",
			Выборка.НомерСтроки,
			Выборка.Номенклатура,
			Выборка.Цена,
			Выборка.ПлановаяЦена);
			
			ПолеОшибки = "Объект.СписокНоменклатуры[" + (Выборка.НомерСтроки - 1) + "].Цена";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, ПолеОшибки, ТекстСообщения);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

