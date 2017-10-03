﻿
// Костыль.
Перем ПроведениеСПКО;

#Область События

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Перем Ошибки;
	
	ПроведениеСПКО = Дата > '2016.03.02';
	
	// { Васильев Александр Леонидович [16.10.2013]
	// блокировку бы...
	// } Васильев Александр Леонидович [16.10.2013]
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(РеализацияМатериаловСписокНоменклатуры.НомерСтроки - 1) КАК НомерСтроки,
	|	РеализацияМатериаловСписокНоменклатуры.Номенклатура,
	|	СУММА(РеализацияМатериаловСписокНоменклатуры.Количество) КАК Количество,
	|	СУММА(РеализацияМатериаловСписокНоменклатуры.Сумма) КАК Сумма
	|ПОМЕСТИТЬ тчДок
	|ИЗ
	|	Документ.РеализацияМатериалов.СписокНоменклатуры КАК РеализацияМатериаловСписокНоменклатуры
	|ГДЕ
	|	РеализацияМатериаловСписокНоменклатуры.Ссылка = &Ссылка
	|	И (РеализацияМатериаловСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|			ИЛИ РеализацияМатериаловСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Комплект))
	|
	|СГРУППИРОВАТЬ ПО
	|	РеализацияМатериаловСписокНоменклатуры.Номенклатура
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
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	
	ДвиженияВзаиморасчеты(Отказ);
	
	Если НЕ Отказ Тогда
		
		ДвиженияПоказателиСотрудников();
		ДвиженияДоходы();
		ДвиженияПродажиФакт();
		Движения.Управленческий.Записывать = Истина;
		Движения.ПродажиФакт.Записывать = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	СуммаДокумента = СписокНоменклатуры.Итог("Сумма");
	
	Дилерский = ТипЗнч(Автор) = Тип("СправочникСсылка.ВнешниеПользователи");
	
	Если ПакетУслуг <> Перечисления.ПакетыУслуг.СамовывозОтПроизводителя
		И НЕ ЗначениеЗаполнено(ДатаОтгрузки) Тогда
		ДатаОтгрузки = ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
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
		Норматив = СтруктураНорматива.Норматив;
		
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
	
	Если Дилерский Тогда
		Сотрудник = Автор.ОбъектАвторизации.Супервайзер;
	Иначе
		Сотрудник = Автор.ФизическоеЛицо;
	КонецЕсли;
	
	Если НЕ ПроведениеСПКО Тогда
		СоздатьПроводкуПоказатель(Сотрудник, Перечисления.ВидыПоказателейСотрудников.ВыручкаЗаДетали);
		СоздатьПроводкуПоказатель(Сотрудник, Перечисления.ВидыПоказателейСотрудников.Выручка);
	КонецЕсли;
	
КонецФункции

Функция ДвиженияДоходы()
	
	Проводки = Движения.Управленческий.Добавить();
	Проводки.Период = Дата;
	Проводки.Подразделение = Подразделение;
	Проводки.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
	Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = Контрагент;
	
	Если ПроведениеСПКО Тогда
		Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ДокументВзаиморасчетов] = Ссылка;
	КонецЕсли;
	
	Проводки.СчетКт = ПланыСчетов.Управленческий.Доходы;
	Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыОтРеализацииМатериалов;
	Проводки.Сумма = СуммаДокумента;
	
КонецФункции

Функция ДвиженияВзаиморасчеты(Отказ)
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ПроведениеСПКО Тогда
		
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
		
	Иначе
		
		// Приходуем деньги в операцинную кассу (Автор документа)
		Проводки = Движения.Управленческий.Добавить();
		Проводки.Период = Дата;
		Проводки.Подразделение = Подразделение;
		Проводки.СчетДт = ПланыСчетов.Управленческий.ОперационнаяКасса;
		Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Автор.ФизическоеЛицо;
		Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДДС] = Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтРеализацииМатериалов;
		Проводки.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
		Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = Контрагент;
		Проводки.Сумма = СуммаДокумента;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

