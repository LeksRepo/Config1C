﻿
Процедура СписатьСоСкладаГотовойПродукции(МассивСпецификаций, МоментВремени, Подразделение, Движения, Ошибки) Экспорт
	
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
	|	ДокСпецификация.Автор,
	|	ДокСпецификация.Дилерский,
	|	ВЫБОР
	|		КОГДА ДокСпецификация.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК УслугаМонтаж
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
		
		// { Васильев Александр Леонидович [30.05.2015]
		// Сделать. Переделки теперь только самовывозом.
		// } Васильев Александр Леонидович [30.05.2015]
		
		Если Выборка.УслугаМонтаж И Выборка.Изделие <> Справочники.Изделия.Переделка Тогда
			
			// заказ с монтажем, оприходуем на временный счет
			
			Проводка = СоздатьПроводку(Движения, Дата, Выборка.Подразделение, Себестомость);
			Проводка.СчетДт = ПланыСчетов.Управленческий.ИзделияУКлиента;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.Спецификация;
			Проводка.КоличествоДт = 1;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СписатьИзделияУКлиента(МассивСпецификаций, МоментВремени, Договор, Подразделение, Движения, Ошибки) Экспорт
	
	Дата = МоментВремени.Дата;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени);
	Запрос.УстановитьПараметр("Спецификация", Договор.Спецификация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.КоличествоОстатокДт,
	|	УправленческийОстатки.СуммаОстатокДт,
	|	УправленческийОстатки.Субконто1 КАК Спецификация
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			&МоментВремени,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ИзделияУКлиента),
	|			,
	|			Подразделение = &Подразделение
	|				И Субконто1 = &Спецификация) КАК УправленческийОстатки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Выборка.Следующий();
		
		МассивСпецификаций.Добавить(Выборка.Спецификация);
		
		Если Выборка.КоличествоОстатокДт = 1 Тогда
			Проводка = СоздатьПроводку(Движения, Дата, Подразделение, Выборка.СуммаОстатокДт);
			Проводка.СчетКт = ПланыСчетов.Управленческий.ИзделияУКлиента;
			Проводка.КоличествоКт = 1;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.Спецификация;
		Иначе
			ТекстСообщения = " %1 на счете 'Изделия у клиента' %2 числится %3 штук вместо 1";
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Выборка.Спецификация, Подразделение, Выборка.КоличествоОстатокДт);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ТекстСообщения);
		КонецЕсли;
		
	Иначе
		
		ТекстСообщения = " %1 не числится на счете 'Изделия у клиента' %2";
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Договор.Спецификация, Подразделение);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет к Движениям проводки по доходам подразделения.
// По отгрузке или акту установки, в разрезе статьи дохода номенклатуры спецификации
//
// Параметры
//  СпецификацияСсылка  - ДокументСсылка.Спецификация - Ссылка на спецификацию
//  Движения  - КоллекцияДвижений - Коллекция движений регистратора
//
Функция СформироватьПрибыльПоСпецификациям(МассивСпецификаций, Движения, Дата, ДатаПередачи, ВызовИзАкта = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.УстановитьПараметр("ВызовИзАкта", ВызовИзАкта);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(СпецификацияСписокНоменклатуры.РозничнаяСтоимость) КАК РозничнаяСтоимость,
	|	СпецификацияСписокНоменклатуры.Номенклатура.СтатьяДохода КАК Статья,
	|	СпецификацияСписокНоменклатуры.Ссылка КАК Спецификация,
	|	СпецификацияСписокНоменклатуры.Ссылка.Дата,
	|	СпецификацияСписокНоменклатуры.Ссылка.Производство,
	|	СпецификацияСписокНоменклатуры.Ссылка.Подразделение,
	|	докДоговор.Ссылка КАК Договор,
	|	ЕСТЬNULL(докДоговор.СуммаДокумента - СпецификацияСписокНоменклатуры.Ссылка.СуммаДокумента, 0) КАК Отклонение,
	|	ВЫБОР
	|		КОГДА СпецификацияСписокНоменклатуры.Ссылка.Производство = СпецификацияСписокНоменклатуры.Ссылка.Подразделение
	|				ИЛИ СпецификацияСписокНоменклатуры.Ссылка.Производство = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОдноПодразделение,
	|	докДоговор.Контрагент КАК КонтрагентДоговор,
	|	СпецификацияСписокНоменклатуры.Ссылка.Контрагент КАК КонтрагентСпецификация,
	|	СпецификацияСписокНоменклатуры.Ссылка.СуммаДокумента КАК СуммаДокумента,
	|	СпецификацияСписокНоменклатуры.Ссылка.Изделие КАК Изделие,
	|	СпецификацияСписокНоменклатуры.Ссылка.Дилерский
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК докДоговор
	|		ПО СпецификацияСписокНоменклатуры.Ссылка = докДоговор.Спецификация
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В(&МассивСпецификаций)
	|	И СпецификацияСписокНоменклатуры.Ссылка.Изделие <> ЗНАЧЕНИЕ(Справочник.Изделия.Переделка)
	|	И (&ВызовИзАкта
	|			ИЛИ НЕ &ВызовИзАкта
	|				И НЕ СпецификацияСписокНоменклатуры.Ссылка.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж))
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Номенклатура.СтатьяДохода,
	|	СпецификацияСписокНоменклатуры.Ссылка,
	|	СпецификацияСписокНоменклатуры.Ссылка.Дата,
	|	СпецификацияСписокНоменклатуры.Ссылка.Производство,
	|	СпецификацияСписокНоменклатуры.Ссылка.Подразделение,
	|	докДоговор.Ссылка,
	|	ЕСТЬNULL(докДоговор.СуммаДокумента - СпецификацияСписокНоменклатуры.Ссылка.СуммаДокумента, 0),
	|	докДоговор.Контрагент,
	|	СпецификацияСписокНоменклатуры.Ссылка.Контрагент,
	|	СпецификацияСписокНоменклатуры.Ссылка.СуммаДокумента,
	|	СпецификацияСписокНоменклатуры.Ссылка.Изделие,
	|	СпецификацияСписокНоменклатуры.Ссылка.Дилерский
	|ИТОГИ
	|	МАКСИМУМ(Договор),
	|	МАКСИМУМ(Отклонение),
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
		МаксимумСЗаказаУправлению = ЛексСервер.ПолучитьНастройкуПодразделения(ВыборкаПоСпецификациям.Подразделение, Перечисления.ВидыНастроекПодразделений.МаксимумСЗаказаУправлению, Дата);
		СуммаУправлению = 0;
		
		Если ЗначениеЗаполнено(Управление) И ЗначениеЗаполнено(ПроцентСЗаказаУправлению) Тогда
			
			СуммаУправлению = ВыборкаПоСпецификациям.Спецификация.СуммаДокумента * 0.01 * ПроцентСЗаказаУправлению;
			
			Если ЗначениеЗаполнено(МаксимумСЗаказаУправлению) И (МаксимумСЗаказаУправлению > 0) И (СуммаУправлению > МаксимумСЗаказаУправлению) Тогда
				СуммаУправлению = МаксимумСЗаказаУправлению;	
			КонецЕсли;
			
			Если СуммаУправлению > 0 Тогда
				
				ТекстКомментария = "%1 процента Управлению с заказа %2";
				ТекстКомментария = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстКомментария, ПроцентСЗаказаУправлению, ВыборкаПоСпецификациям.Спецификация);
				ЛексСервер.НачислитьСуммуУправлению(ВыборкаПоСпецификациям.Подразделение, Движения, СуммаУправлению, Дата, ТекстКомментария);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ОдноПодразделение = ВыборкаПоСпецификациям.ОдноПодразделение;
		ОдноПодразделение = Истина; // тест 
		
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
	|	ЕСТЬNULL(докДополнительноеСоглашение.СуммаДокумента, 0) КАК Сумма,
	|	докДоговор.Контрагент,
	|	докДоговор.Подразделение
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК докДоговор
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДополнительноеСоглашение КАК докДополнительноеСоглашение
	|			ПО докДоговор.Ссылка = докДополнительноеСоглашение.Договор
	|		ПО (докДоговор.Спецификация = докСпецификация.Ссылка)
	|ГДЕ
	|	докСпецификация.Ссылка В(&МассивСпецификаций)
	|	И (&ВызовИзАкта
	|				И (докДополнительноеСоглашение.Проведен
	|					ИЛИ докДополнительноеСоглашение.Дата < ДАТАВРЕМЯ(2015, 1, 1))
	|			ИЛИ НЕ &ВызовИзАкта
	|				И НЕ докСпецификация.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж))";
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока Выборка.Следующий() Цикл
		
			Если Выборка.Сумма > 0 Тогда
				Проводка = СоздатьПроводку(Движения, ДатаПроведения, Выборка.Подразделение, Выборка.Сумма);
				Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = Выборка.Контрагент;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.ДопСоглашение;
				Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыОтДопСоглашений;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.Договор;
			ИначеЕсли Выборка.Сумма < 0 Тогда
				Проводка = СоздатьПроводку(Движения, ДатаПроведения, Выборка.Подразделение, -Выборка.Сумма);
				Проводка.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = Выборка.Контрагент;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.ДопСоглашение;
				Проводка.СчетДт = ПланыСчетов.Управленческий.Расходы;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходыОтДопСоглашений; // ох и сраться будем по этому поводу
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
