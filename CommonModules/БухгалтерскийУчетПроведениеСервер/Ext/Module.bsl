﻿
Процедура СформироватьПроводкиРеализацииСпецификаций(МассивСпецификаций, МоментВремени, Подразделение, Движения, Ошибки) Экспорт 
	
	Дата = МоментВремени.Дата;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", МоментВремени);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(УправленческийОстатки.СуммаОстатокДт, 0) КАК СуммаОстатокДт,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстатокДт, 0) КАК КоличествоОстатокДт,
	|	ДокСпецификация.Ссылка КАК Спецификация,
	|	ДокСпецификация.Изделие КАК Изделие,
	|	ДокСпецификация.Контрагент,
	|	ДокСпецификация.Подразделение,
	|	ДокСпецификация.СуммаДокумента,
	|	ДокСпецификация.ВнутренняяСтоимостьСпецификации,
	|	ДокСпецификация.Автор,
	|	ДокСпецификация.Дилерский,
	|	ВЫБОР
	|		КОГДА ДокСпецификация.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК УслугаМонтаж,
	|	ДокСпецификация.Подразделение.СвоиМонтажи КАК СвоиМонтажи
	|ИЗ
	|	Документ.Спецификация КАК ДокСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(&Дата, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.СкладГотовойПродукции), , Подразделение = &Подразделение) КАК УправленческийОстатки
	|		ПО (ДокСпецификация.Ссылка = (ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация)))
	|ГДЕ
	|	ДокСпецификация.Ссылка В(&МассивСпецификаций)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		КоличествоОстаток = Выборка.КоличествоОстатокДт;
		Себестомость = Выборка.СуммаОстатокДт;
		
		Если КоличествоОстаток <> 1 Тогда
			Текст = "" + Выборка.Спецификация + " не числится на счете 'Склад готовой продукции'";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.СписокСпецификаций", Текст);
			Продолжить;
		КонецЕсли;
		
		Проводка = СоздатьПроводку(Движения, Дата, Подразделение, Себестомость);
		Проводка.СчетКт = ПланыСчетов.Управленческий.СкладГотовойПродукции;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.Спецификация;
		Проводка.КоличествоКт = 1;
		
		Если Выборка.УслугаМонтаж И НЕ Выборка.СвоиМонтажи И (Выборка.Изделие <> Справочники.Изделия.Переделка) Тогда
			
			// заказ с монтажем, оприходуем на временный счет
			
			Проводка = СоздатьПроводку(Движения, Дата, Выборка.Подразделение, Себестомость);
			Проводка.СчетДт = ПланыСчетов.Управленческий.ИзделияУКлиента;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.Спецификация;
			Проводка.КоличествоДт = 1;
			
		КонецЕсли;
		
	КонецЦикла; 
	
	Если Ошибки <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьПроводкиАктВыполнения(МассивСпецификаций, МоментВремени, Договор, Подразделение, Движения, Ошибки) Экспорт
	
	Дата = МоментВремени.Дата;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Договор.Спецификация,
	|	Договор.Спецификация.Производство,
	|	Договор.Спецификация.ВнутренняяСтоимостьСпецификации,
	|	Договор.Спецификация.Изделие,
	|	Договор.Спецификация.Технолог,
	|	Договор.Спецификация.СуммаДокумента,
	|	Договор.Спецификация.Подразделение,
	|	Договор.Спецификация.Подразделение.СвоиМонтажи
	|ПОМЕСТИТЬ ВТ_Спецификация
	|ИЗ
	|	Документ.Договор КАК Договор
	|ГДЕ
	|	Договор.Ссылка = &Договор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УправленческийОстатки.КоличествоОстатокДт,
	|	УправленческийОстатки.СуммаОстатокДт,
	|	ВТ_Спецификация.Спецификация,
	|	ВТ_Спецификация.СпецификацияПроизводство КАК Производство,
	|	ВТ_Спецификация.СпецификацияВнутренняяСтоимостьСпецификации КАК ВнутренняяСтоимостьСпецификации,
	|	ВТ_Спецификация.СпецификацияИзделие КАК Изделие,
	|	ВТ_Спецификация.СпецификацияТехнолог КАК Технолог,
	|	ВТ_Спецификация.СпецификацияСуммаДокумента КАК СуммаДокумента,
	|	ВТ_Спецификация.СпецификацияПодразделение КАК Подразделение,
	|	ВТ_Спецификация.СпецификацияПодразделениеСвоиМонтажи КАК СвоиМонтажи
	|ИЗ
	|	ВТ_Спецификация КАК ВТ_Спецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(&МоментВремени, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ИзделияУКлиента), , ) КАК УправленческийОстатки
	|		ПО (ВТ_Спецификация.Спецификация = (ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация)))
	|			И ВТ_Спецификация.СпецификацияПодразделение = УправленческийОстатки.Подразделение";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	МассивСпецификаций.Добавить(Выборка.Спецификация);
	
	Если НЕ Выборка.СвоиМонтажи Тогда
		
		Если Выборка.КоличествоОстатокДт <> 1 Тогда
			
			ТекстСообщения = "" + Выборка.Спецификация + " не числится на счете 'Изделия у клиента'";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ТекстСообщения);
			Возврат;
			
		КонецЕсли;
		
		Проводка = СоздатьПроводку(Движения, Дата, Выборка.Подразделение, Выборка.СуммаОстатокДт);
		Проводка.СчетКт = ПланыСчетов.Управленческий.ИзделияУКлиента;
		Проводка.КоличествоКт = 1;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.Спецификация;
		
	КонецЕсли;
	
	Выборка.Сбросить();
	
КонецПроцедуры

// Добавляет к Движениям проводки по доходам подразделения.
// По отгрузке или акту установки, в разрезе статьи дохода номенклатуры спецификации
//
// Параметры
//  СпецификацияСсылка  - ДокументСсылка.Спецификация - Ссылка на спецификацию
//  Движения  - КоллекцияДвижений - Коллекция движений регистратора
//
Функция СформироватьПроводкиПрибыльПроизводства(МассивСпецификаций, Движения, Дата, ВызовИзАкта = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.УстановитьПараметр("ВызовИзАкта", ВызовИзАкта);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(СпецификацияСписокНоменклатуры.ВнутренняяСтоимость) КАК ВнутренняяСтоимость,
	|	СУММА(СпецификацияСписокНоменклатуры.РозничнаяСтоимость) КАК РозничнаяСтоимость,
	|	СпецификацияСписокНоменклатуры.Номенклатура.СтатьяДохода КАК Статья,
	|	СпецификацияСписокНоменклатуры.Ссылка КАК Спецификация,
	|	СпецификацияСписокНоменклатуры.Ссылка.Дата,
	|	СпецификацияСписокНоменклатуры.Ссылка.Производство,
	|	СпецификацияСписокНоменклатуры.Ссылка.Подразделение,
	|	докДоговор.Ссылка КАК Договор,
	|	ЕСТЬNULL(докДоговор.СуммаДокумента - СпецификацияСписокНоменклатуры.Ссылка.СуммаДокумента, 0) КАК Отклонение,
	|	СпецификацияСписокНоменклатуры.Ссылка.Подразделение.БрендДилер КАК ПодразделениеБрендДилер,
	|	ВЫБОР
	|		КОГДА СпецификацияСписокНоменклатуры.Ссылка.Производство = СпецификацияСписокНоменклатуры.Ссылка.Подразделение
	|				ИЛИ СпецификацияСписокНоменклатуры.Ссылка.Производство = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОдноПодразделение,
	|	докДоговор.Контрагент КАК КонтрагентДоговор,
	|	СпецификацияСписокНоменклатуры.Ссылка.Контрагент КАК КонтрагентСпецификация,
	|	СпецификацияСписокНоменклатуры.Ссылка.СуммаДокумента КАК СуммаДокумента,
	|	СпецификацияСписокНоменклатуры.Ссылка.Изделие КАК Изделие
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК докДоговор
	|		ПО СпецификацияСписокНоменклатуры.Ссылка = докДоговор.Спецификация
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В(&МассивСпецификаций)
	|	И СпецификацияСписокНоменклатуры.Ссылка.Изделие <> ЗНАЧЕНИЕ(Справочник.Изделия.Переделка)
	|	И (&ВызовИзАкта
	|				И НЕ СпецификацияСписокНоменклатуры.Ссылка.Подразделение.СвоиМонтажи
	|			ИЛИ НЕ &ВызовИзАкта
	|				И НЕ(СпецификацияСписокНоменклатуры.Ссылка.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж)
	|						И НЕ СпецификацияСписокНоменклатуры.Ссылка.Подразделение.СвоиМонтажи))
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Номенклатура.СтатьяДохода,
	|	СпецификацияСписокНоменклатуры.Ссылка,
	|	СпецификацияСписокНоменклатуры.Ссылка.Дата,
	|	СпецификацияСписокНоменклатуры.Ссылка.Производство,
	|	СпецификацияСписокНоменклатуры.Ссылка.Подразделение,
	|	докДоговор.Ссылка,
	|	ЕСТЬNULL(докДоговор.СуммаДокумента - СпецификацияСписокНоменклатуры.Ссылка.СуммаДокумента, 0),
	|	СпецификацияСписокНоменклатуры.Ссылка.Подразделение.БрендДилер,
	|	докДоговор.Контрагент,
	|	СпецификацияСписокНоменклатуры.Ссылка.Контрагент,
	|	СпецификацияСписокНоменклатуры.Ссылка.СуммаДокумента,
	|	СпецификацияСписокНоменклатуры.Ссылка.Изделие
	|ИТОГИ
	|	МАКСИМУМ(Договор),
	|	МАКСИМУМ(Отклонение),
	|	МАКСИМУМ(ПодразделениеБрендДилер),
	|	МАКСИМУМ(ОдноПодразделение),
	|	МАКСИМУМ(КонтрагентДоговор),
	|	МАКСИМУМ(КонтрагентСпецификация),
	|	МАКСИМУМ(СуммаДокумента),
	|	МАКСИМУМ(Изделие)
	|ПО
	|	Спецификация";
	
	ВыборкаПоСпецификациям = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Управление = Константы.Управление.Получить();
	
	Пока ВыборкаПоСпецификациям.Следующий() Цикл
		
		Если ВыборкаПоСпецификациям.Изделие = Справочники.Изделия.ГарантийноеОбслуживание Тогда
			Прервать;
		КонецЕсли;
		
		ПроцентСЗаказаУправлению = ЛексСервер.ПолучитьНастройкуПодразделения(ВыборкаПоСпецификациям.Подразделение, Перечисления.ВидыНастроекПодразделений.ПроцентСЗаказаУправлению, Дата);
		СуммаУправлению = 0;
		
		Если ЗначениеЗаполнено(Управление) И ЗначениеЗаполнено(ПроцентСЗаказаУправлению) Тогда
			СуммаУправлению = ВыборкаПоСпецификациям.Спецификация.СуммаДокумента * 0.01 * ПроцентСЗаказаУправлению;
			
			Если СуммаУправлению > 0 Тогда
				
				ТекстКомментария = "%1 процента Управлению с заказа %2";
				ТекстКомментария = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстКомментария, ПроцентСЗаказаУправлению, ВыборкаПоСпецификациям.Спецификация);
				ЛексСервер.НачислитьСуммуУправлению(ВыборкаПоСпецификациям.Подразделение, Движения, СуммаУправлению, Дата, ТекстКомментария);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ОдноПодразделение = ВыборкаПоСпецификациям.ОдноПодразделение;
		
		Если ОдноПодразделение Тогда
			
			ЕстьДоговор = ЗначениеЗаполнено(ВыборкаПоСпецификациям.Договор);
			ДокументДоговорИлиСпецификация = ?(ЕстьДоговор, ВыборкаПоСпецификациям.Договор, ВыборкаПоСпецификациям.Спецификация);
			Контрагент = ?(ЕстьДоговор, ВыборкаПоСпецификациям.КонтрагентДоговор, ВыборкаПоСпецификациям.КонтрагентСпецификация);
			
			Если ВыборкаПоСпецификациям.Отклонение > 0 Тогда
				
				Проводка = СоздатьПроводку(Движения, Дата, ВыборкаПоСпецификациям.Подразделение, ВыборкаПоСпецификациям.Отклонение);
				
				Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = Контрагент;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = ДокументДоговорИлиСпецификация;
				
				Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыПоОтклонениям;//(???)
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = ВыборкаПоСпецификациям.Спецификация;
				
			ИначеЕсли ВыборкаПоСпецификациям.Отклонение < 0 Тогда
				
				Проводка = СоздатьПроводку(Движения, Дата, ВыборкаПоСпецификациям.Подразделение, -ВыборкаПоСпецификациям.Отклонение);
				
				Проводка.СчетДт = ПланыСчетов.Управленческий.Расходы;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходыПоОтклонениям;//(???)
				
				Проводка.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = Контрагент;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = ДокументДоговорИлиСпецификация;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Выборка = ВыборкаПоСпецификациям.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если ОдноПодразделение Тогда
				
				Проводка = СоздатьПроводку(Движения, Дата, Выборка.Подразделение, Выборка.РозничнаяСтоимость);
				ЕстьДоговор = ЗначениеЗаполнено(Выборка.Договор);
				ДокументДоговорИлиСпецификация = ?(ЕстьДоговор, Выборка.Договор, Выборка.Спецификация);
				Контрагент = ?(ЕстьДоговор, Выборка.КонтрагентДоговор, Выборка.КонтрагентСпецификация);
				
				Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = Контрагент;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = ДокументДоговорИлиСпецификация;
				
			Иначе
				
				Проводка = СоздатьПроводку(Движения, Дата, Выборка.Производство, Выборка.ВнутренняяСтоимость);
				Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПодразделениями;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Подразделения] = Выборка.Подразделение;
				
			КонецЕсли;
			
			Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
			Если НЕ ЗначениеЗаполнено(Выборка.Статья) Тогда
				СтатьяДохода = Справочники.СтатьиДоходовРасходов.ДоходыПрочие;
			Иначе
				СтатьяДохода = Выборка.Статья;
			КонецЕсли;
			
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = СтатьяДохода;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.Спецификация;
			
		КонецЦикла;
		
	КонецЦикла; //Пока ВыборкаПоСпецификациям.Следующий() Цикл
	
	Возврат Неопределено;
	
КонецФункции

// Формирует проводки по закрытию доп. соглашений (вызывается из ОбработкаПроведения)
//
// Параметры
//  Движения  - КоллекцияДвижений - коллекция движений регистратора
//  ДоговорСсылка  - ДокументСсылка.Договор - ссылка на закрываемый Договор
//
Функция ЗакрытьДопСоглашенияДоговора(МассивСпецификаций, Движения, ДатаПроведения, ВызовИзАкта = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.УстановитьПараметр("ВызовИзАкта", ВызовИзАкта);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	докСпецификация.Ссылка КАК Спецификация,
	|	докДоговор.Ссылка КАК Договор,
	|	докДополнительноеСоглашение.Ссылка КАК ДопСоглашение,
	|	докДополнительноеСоглашение.СуммаДокумента КАК Сумма,
	|	докДоговор.Дата,
	|	докДоговор.Контрагент,
	|	докДоговор.Подразделение,
	|	докДоговор.СуммаДокумента КАК СуммаДоговора,
	|	докСпецификация.Подразделение КАК ПодразделениеРозницы
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК докДоговор
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДополнительноеСоглашение КАК докДополнительноеСоглашение
	|			ПО докДоговор.Ссылка = докДополнительноеСоглашение.Договор
	|		ПО (докДоговор.Спецификация = докСпецификация.Ссылка)
	|ГДЕ
	|	докСпецификация.Ссылка В(&МассивСпецификаций)
	|	И докДополнительноеСоглашение.Проведен
	|	И (&ВызовИзАкта
	|			ИЛИ НЕ &ВызовИзАкта
	|				И НЕ(докСпецификация.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж)
	|						И НЕ докСпецификация.Подразделение.СвоиМонтажи))
	|ИТОГИ
	|	СУММА(Сумма),
	|	МАКСИМУМ(СуммаДоговора),
	|	МАКСИМУМ(ПодразделениеРозницы)
	|ПО
	|	ОБЩИЕ";
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока Выборка.Следующий() Цикл
		
		ОбщаяСумма = Выборка.Сумма;
		СуммаДоговора = Выборка.СуммаДоговора;
		ПодразделениеРозницы = Выборка.ПодразделениеРозницы;
		
		ВыборкаПоСпецификациям = Выборка.Выбрать();
		
		Пока ВыборкаПоСпецификациям.Следующий() Цикл
			Если ВыборкаПоСпецификациям.Сумма > 0 Тогда
				Проводка = СоздатьПроводку(Движения, ДатаПроведения, ВыборкаПоСпецификациям.Подразделение, ВыборкаПоСпецификациям.Сумма);
				Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = ВыборкаПоСпецификациям.Контрагент;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = ВыборкаПоСпецификациям.ДопСоглашение;
				Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыОтДопСоглашений;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = ВыборкаПоСпецификациям.Договор;
			Иначе
				Проводка = СоздатьПроводку(Движения, ДатаПроведения, ВыборкаПоСпецификациям.Подразделение, -ВыборкаПоСпецификациям.Сумма);
				Проводка.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = ВыборкаПоСпецификациям.Контрагент;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = ВыборкаПоСпецификациям.ДопСоглашение;
				Проводка.СчетДт = ПланыСчетов.Управленческий.Расходы;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходыОтДопСоглашений; // ох и сраться будем по этому поводу
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецФункции

Функция РеализацияИзделийРозничныеПроводки(МассивСпецификаций, Движения, Дата, ВызовИзАкта = Ложь) Экспорт
	
	Если МассивСпецификаций.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.УстановитьПараметр("ВызовИзАкта", ВызовИзАкта);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	докСпецификация.Ссылка КАК Спецификация,
	|	докДоговор.Ссылка КАК Договор,
	|	докСпецификация.Контрагент КАК КонтрагентСпецификации,
	|	докСпецификация.Подразделение,
	|	докСпецификация.СуммаДокумента,
	|	докСпецификация.ВнутренняяСтоимостьСпецификации,
	|	докСпецификация.Производство,
	|	докСпецификация.Дилерский,
	|	докДоговор.СуммаДокумента КАК СуммаДокументаДоговор,
	|	докСпецификация.Подразделение.СвоиМонтажи КАК СвоиМонтажи,
	|	ЕСТЬNULL(докДоговор.СуммаДокумента - докСпецификация.СуммаДокумента, 0) КАК Отклонение,
	|	докДоговор.Контрагент КАК КонтрагентДоговора
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК докДоговор
	|		ПО (докДоговор.Спецификация = докСпецификация.Ссылка)
	|ГДЕ
	|	докСпецификация.Ссылка В(&МассивСпецификаций)
	|	И докСпецификация.Изделие <> ЗНАЧЕНИЕ(Справочник.Изделия.Переделка)
	|	И докСпецификация.Изделие <> ЗНАЧЕНИЕ(Справочник.Изделия.ДопСоглашение)
	|	И (&ВызовИзАкта
	|			ИЛИ НЕ &ВызовИзАкта
	|				И НЕ(докСпецификация.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж)
	|						И НЕ докСпецификация.Подразделение.СвоиМонтажи))
	|	И докСпецификация.Подразделение <> докСпецификация.Производство
	|	И докСпецификация.Производство <> ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ЕстьДоговор = ЗначениеЗаполнено(Выборка.Договор);
		ДокументДоговорИлиСпецификация = ?(ЕстьДоговор, Выборка.Договор, Выборка.Спецификация);
		КонтрагентДоговорИлиСпецификация = ?(ЕстьДоговор, Выборка.КонтрагентДоговора, Выборка.КонтрагентСпецификации);
		СуммаВзаиморасчетов = ?(ЕстьДоговор, Выборка.СуммаДокументаДоговор, Выборка.СуммаДокумента);
		
		Если Выборка.Дилерский Тогда
			СтатьяДохода = Справочники.СтатьиДоходовРасходов.ДоходыОтДилеровПоСпецификациям;
			СтатьяРасхода = Справочники.СтатьиДоходовРасходов.РасходПоСпецификациямДилеров;
		ИначеЕсли ЕстьДоговор Тогда
			СтатьяДохода = Справочники.СтатьиДоходовРасходов.ДоходыОтРозничныхКлиентов;
			СтатьяРасхода = Справочники.СтатьиДоходовРасходов.РасходНаПроизводствоМебельногоКомплекта;
		Иначе
			СтатьяДохода = Справочники.СтатьиДоходовРасходов.ДоходыОтЧастныхЛицПоСпецификациям;
			СтатьяРасхода = Справочники.СтатьиДоходовРасходов.РасходПоСпецификациямЧастныхЛиц;
		КонецЕсли;
		
		Если НЕ (Выборка.СвоиМонтажи И ВызовИзАкта) Тогда // на это условие я убил 2 часа :(
			
			// Оприходование изделия от производства
			Проводка = СоздатьПроводку(Движения, Дата, Выборка.Подразделение, Выборка.ВнутренняяСтоимостьСпецификации);
			Проводка.СчетДт = ПланыСчетов.Управленческий.ГотоваяПродукция;//(убрать проводку)
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = ДокументДоговорИлиСпецификация;
			Проводка.КоличествоДт = 1;
			Проводка.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПодразделениями;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Подразделения] = Выборка.Производство;
			
		КонецЕсли;
		
		Если НЕ Выборка.СвоиМонтажи ИЛИ ВызовИзАкта Тогда
			
			// Расходы
			Проводка = СоздатьПроводку(Движения, Дата, Выборка.Подразделение, Выборка.ВнутренняяСтоимостьСпецификации);
			Проводка.СчетДт = ПланыСчетов.Управленческий.Расходы;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = СтатьяРасхода;
			Проводка.СчетКт = ПланыСчетов.Управленческий.ГотоваяПродукция;
			Проводка.КоличествоКт = 1;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = ДокументДоговорИлиСпецификация;
			
			// Доходы
			Проводка = СоздатьПроводку(Движения, Дата, Выборка.Подразделение, СуммаВзаиморасчетов);
			Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = КонтрагентДоговорИлиСпецификация;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = ДокументДоговорИлиСпецификация;
			Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = СтатьяДохода;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = ДокументДоговорИлиСпецификация;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

Функция СформироватьПоказателиМонтажникаИлиВодителя(МассивСпецификаций, Движения, Дата) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпецификацияСписокНоменклатуры.Ссылка,
	|	СпецификацияСписокНоменклатуры.Ссылка.Подразделение,
	|	СпецификацияСписокНоменклатуры.Ссылка.ПакетУслуг,
	|	докСпецификация.Монтажник,
	|	докСпецификация.ДовозОсуществил КАК Экспедитор,
	|	СУММА(ВЫБОР
	|			КОГДА СпецификацияСписокНоменклатуры.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ВыездМастера)
	|				ТОГДА СпецификацияСписокНоменклатуры.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВыездМастера,
	|	СУММА(ВЫБОР
	|			КОГДА СпецификацияСписокНоменклатуры.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ВыездМастераНаСборкуКухни)
	|				ТОГДА СпецификацияСписокНоменклатуры.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВыездМастераНаСборкуКухни,
	|	СУММА(ВЫБОР
	|			КОГДА СпецификацияСписокНоменклатуры.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПроездМонтажникаЗаГородом)
	|				ТОГДА СпецификацияСписокНоменклатуры.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ПроездМонтажникаЗаГородом,
	|	СУММА(ВЫБОР
	|			КОГДА СпецификацияСписокНоменклатуры.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.СборкаИзделия)
	|				ТОГДА СпецификацияСписокНоменклатуры.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК СборкаИзделия,
	|	СУММА(ВЫБОР
	|			КОГДА СпецификацияСписокНоменклатуры.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ДоставкаЗаГородом)
	|				ТОГДА СпецификацияСписокНоменклатуры.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ДоставкаЗаГородом,
	|	АктВыполненияДоговора.ОценкаСупервайзера КАК ОценкаСупервайзера
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация КАК докСпецификация
	|		ПО СпецификацияСписокНоменклатуры.Ссылка = докСпецификация.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктВыполненияДоговора КАК АктВыполненияДоговора
	|		ПО СпецификацияСписокНоменклатуры.Ссылка = АктВыполненияДоговора.Договор.Спецификация
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В(&МассивСпецификаций)
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Ссылка,
	|	СпецификацияСписокНоменклатуры.Ссылка.Подразделение,
	|	СпецификацияСписокНоменклатуры.Ссылка.ПакетУслуг,
	|	докСпецификация.Монтажник,
	|	докСпецификация.ДовозОсуществил,
	|	АктВыполненияДоговора.ОценкаСупервайзера";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	Монтажник = Выборка.Монтажник;
	Подразделение = Выборка.Подразделение;
	Экспедитор = Выборка.Экспедитор;
	
	Если ЗначениеЗаполнено(Монтажник) И (Выборка.ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж) Тогда
		
		ВидыПоказателейСотрудников = Перечисления.ВидыПоказателейСотрудников;
		
		Если Выборка.ОценкаСупервайзера = Перечисления.ОценкаСупервайзера.Неудовлетворительно Тогда
			
			КоличествоУстановленныхИзделий = ВидыПоказателейСотрудников.КоличествоУстановленныхИзделийНеуд;
			КоличествоУстановленныхКухонь = ВидыПоказателейСотрудников.КоличествоУстановленныхКухоньНеуд;
			КоличествоМетровУстановленныхИзделий = ВидыПоказателейСотрудников.КоличествоМетровУстановленныхИзделийНеуд;
			КилометровУдаленныхМонтажей = ВидыПоказателейСотрудников.КилометровУдаленныхМонтажейНеуд;
			
		Иначе
			
			КоличествоУстановленныхИзделий = ВидыПоказателейСотрудников.КоличествоУстановленныхИзделий;
			КоличествоУстановленныхКухонь = ВидыПоказателейСотрудников.КоличествоУстановленныхКухонь;
			КоличествоМетровУстановленныхИзделий = ВидыПоказателейСотрудников.КоличествоМетровУстановленныхИзделий;
			КилометровУдаленныхМонтажей = ВидыПоказателейСотрудников.КилометровУдаленныхМонтажей;
			
		КонецЕсли;
		
		Если Выборка.ВыездМастера <> 0 Тогда
			ДобавитьПоказательСотрудника(Движения, Дата, Монтажник, КоличествоУстановленныхИзделий, Выборка.ВыездМастера, Подразделение)
		КонецЕсли;
		
		Если Выборка.ВыездМастераНаСборкуКухни <> 0 Тогда
			ДобавитьПоказательСотрудника(Движения, Дата, Монтажник, КоличествоУстановленныхКухонь, Выборка.ВыездМастераНаСборкуКухни, Подразделение)
		КонецЕсли;
		
		Если Выборка.СборкаИзделия <> 0 Тогда
			ДобавитьПоказательСотрудника(Движения, Дата, Монтажник, КоличествоМетровУстановленныхИзделий, Выборка.СборкаИзделия, Подразделение)
		КонецЕсли;
		
		Если Выборка.ПроездМонтажникаЗаГородом <> 0 Тогда
			ДобавитьПоказательСотрудника(Движения, Дата, Монтажник, КилометровУдаленныхМонтажей, Выборка.ПроездМонтажникаЗаГородом, Подразделение)
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Экспедитор) И Выборка.ПакетУслуг <> Перечисления.ПакетыУслуг.СамовывозОтПроизводителя Тогда
		
		ДобавитьПоказательСотрудника(Движения, Дата, Экспедитор, Перечисления.ВидыПоказателейСотрудников.КоличествоДоставленныхИзделий, 1, Подразделение);
		
		Если Выборка.ДоставкаЗаГородом <> 0 Тогда
			ДобавитьПоказательСотрудника(Движения, Дата, Экспедитор, Перечисления.ВидыПоказателейСотрудников.КилометровУдаленныхДоставок, Выборка.ДоставкаЗаГородом, Подразделение)
		КонецЕсли;
		
	КонецЕсли;
	
	Выборка.Сбросить();
	
КонецФункции

Функция СоздатьПроводку(фДвижения, фДата, фПодразделение, фСумма)
	
	Проводка = фДвижения.Управленческий.Добавить();
	Проводка.Период = фДата;
	Проводка.Подразделение = фПодразделение;
	Проводка.Сумма = фСумма;
	
	Возврат Проводка;
	
КонецФункции

Функция ДобавитьПоказательСотрудника(фДвижения, фДата, Физлицо, Показатель, Значение, Подразделение)
	
	Проводка = фДвижения.Управленческий.Добавить();
	Проводка.Период = фДата;
	Проводка.Подразделение = Подразделение;
	Проводка.Сумма = Значение;
	Проводка.СчетДт = ПланыСчетов.Управленческий.ПоказателиСотрудника;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ВидыПоказателейСотрудников] = Показатель;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Физлицо;
	
КонецФункции