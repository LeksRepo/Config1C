﻿
#Область СОБЫТИЯ_ЭЛЕМЕНТОВ_ФОРМЫ

#КонецОбласти

#Область ОБЩЕГО_НАЗНАЧЕНИЯ

#КонецОбласти

#Область УПРАВЛЕНИЕ_ВНЕШНИМ_ВИДОМ

#КонецОбласти

#Область СОБЫТИЯ_ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьСписокПодразделений();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидПериода = Перечисления.ДоступныеПериодыОтчета.Месяц;
	ОтчетСупервайзера = "Отчет старшего дизайнера";
	АктивПодразделения = "Актив подразделения";
	
КонецПроцедуры

#КонецОбласти

#Область КОМАНДЫ

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьНаСервере();
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ТабДокКасса);
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ТабДокНачисления);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетСупервайзераНажатие(Элемент, СтандартнаяОбработка)
	
	ОтчетСупервайзераНажатиеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОтчетСупервайзераНажатиеНаСервере()
	
	// Вставить содержимое обработчика.
	
КонецПроцедуры

&НаКлиенте
Процедура АктивПодразделенияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Подразделение", СписокПодразделений);
	ПараметрыФормы.Вставить("НачалоПериода", ПериодОтчета.ДатаНачала);
	ПараметрыФормы.Вставить("КонецПериода", ПериодОтчета.ДатаОкончания);
	
	ОткрытьФорму("Отчет.АктивПодразделения.Форма.ФормаОтчета", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СреднийЛимитНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СписокПодразделений.Количество() = 1 И (НЕ СреднийЛимит = "Недоступно") Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Подразделения", СписокПодразделений);
		ПараметрыФормы.Вставить("НачалоПериода", ПериодОтчета.ДатаНачала);
		ПараметрыФормы.Вставить("КонецПериода", ПериодОтчета.ДатаОкончания);
		
		ОткрытьФорму("Отчет.КлючевыеПоказатели.Форма.ФормаРасшифровкаЛимита", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОБРАБОТЧИКИ_СОБЫТИЙ_ТАБЛИЧНЫХ_ПОЛЕЙ

&НаКлиенте
Процедура ТабДокНачисленияОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РасшифроватьЯчейку(Расшифровка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокКассаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РасшифроватьЯчейку(Расшифровка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокЭкономикаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ (Расшифровка.Свойство("ВидРасшифровки") ИЛИ Расшифровка.Свойство("Раздел")) Тогда
		Возврат;
	КонецЕсли;
	
	Если Расшифровка.ВидРасшифровки = "ДР" И Расшифровка.Раздел = "Продажи" Тогда
		РасшифроватьЯчейку(Расшифровка);
		Возврат;
	КонецЕсли;
	
	ПериодРасшифровки = Новый СтандартныйПериод;
	
	Если Расшифровка.ВидРасшифровки = "Шапка" Тогда
		ПериодРасшифровки = ПериодОтчета;
	ИначеЕсли Расшифровка.ВидРасшифровки = "День" ИЛИ Расшифровка.ВидРасшифровки = "ДР" Тогда
		ПериодРасшифровки.ДатаНачала = Расшифровка.Период;
		ПериодРасшифровки.ДатаОкончания = КонецДня(Расшифровка.Период);
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Раздел", Расшифровка.Раздел);
	ПараметрыОтчета.Вставить("Период", ПериодРасшифровки);
	ПараметрыОтчета.Вставить("СписокПодразделений", СписокПодразделений);
	
	ФормаРасшифровки = ПолучитьФорму("Отчет.КлючевыеПоказатели.Форма.ФормаРасшифровкаОтчета");
	ФормаРасшифровки.СформироватьОтчет(ПериодРасшифровки, Расшифровка.Раздел, СписокПодразделений);
	ФормаРасшифровки.Открыть();
	
КонецПроцедуры

Функция ПолучитьОстаткиПоСчету(НачалоПериода, КонецПериода, СписокПодразделений, Счет)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.СуммаОстаток
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(&НачалоПериода, Счет В ИЕРАРХИИ (&Счет), , Подразделение В (&СписокПодразделений)) КАК УправленческийОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УправленческийОстатки.СуммаОстаток
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(&КонецПериода, Счет В ИЕРАРХИИ (&Счет), , Подразделение В (&СписокПодразделений)) КАК УправленческийОстатки";
	
	МассивРезультатовЗапроса = Запрос.ВыполнитьПакет();
	
	Остатки = Новый Структура();
	Остатки.Вставить("ОстатокНаНачалоПериода",0);
	Остатки.Вставить("ОстатокНаКонецПериода",0);
	
	Если НЕ МассивРезультатовЗапроса[0].Пустой() Тогда
		Выборка = МассивРезультатовЗапроса[0].Выбрать();
		Выборка.Следующий();
		Остатки.ОстатокНаНачалоПериода = Выборка.СуммаОстаток; 
	КонецЕсли;
	
	Если НЕ МассивРезультатовЗапроса[1].Пустой() Тогда
		Выборка = МассивРезультатовЗапроса[1].Выбрать();
		Выборка.Следующий();
		Остатки.ОстатокНаКонецПериода = Выборка.СуммаОстаток; 
	КонецЕсли;
	
	Возврат Остатки;
	
КонецФункции

&НаСервере
функция ПолучитьОтклонение(ВидОтклонения, НачалоПериода, КонецПериода, СписокПодразделений)
	
	Если ВидОтклонения = "Касса" Тогда
		Счет = ПланыСчетов.Управленческий.ДенежныеСредства;
	Иначе
		Счет = ПланыСчетов.Управленческий.ПрибыльУбытки;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(УправленческийОбороты.СуммаОборот, 0) КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ),
	|			День,
	|			Счет В ИЕРАРХИИ (&Счет),
	|			,
	|			Подразделение В (&СписокПодразделений)
	|				И НЕ ВЫРАЗИТЬ(Субконто1 КАК Справочник.СтатьиДвиженияДенежныхСредств).МеждуСчетами
	|				И Субконто1 <> ЗНАЧЕНИЕ(Справочник.СтатьиДоходовРасходов.ЗакрытиеДоходовНаФинРезультат)
	|				И Субконто1 <> ЗНАЧЕНИЕ(Справочник.СтатьиДоходовРасходов.ЗакрытиеРасходовНаФинРезультат),
	|			,
	|			) КАК УправленческийОбороты
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	ОБЩИЕ";
	
	Если ВидОтклонения <> "Касса" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Субконто1 КАК Справочник.СтатьиДвиженияДенежныхСредств)", "Субконто1 КАК Справочник.СтатьиДоходовРасходов)");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ЕСТЬNULL(УправленческийОбороты.СуммаОборот", "-ЕСТЬNULL(УправленческийОбороты.СуммаОборот");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	ИтогПоТаблице = 0;
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ИтогПоТаблице = Выборка.Сумма;
	КонецЕсли;
	
	Остатки = ПолучитьОстаткиПоСчету(НачалоПериода, КонецПериода, СписокПодразделений, Счет);
	Отклонение = 0;
	
	Если Окр(Остатки.ОстатокНаНачалоПериода + ИтогПоТаблице) <> Окр(Остатки.ОстатокНаКонецПериода) Тогда
		Отклонение = Окр(Остатки.ОстатокНаНачалоПериода + ИтогПоТаблице) - Окр(Остатки.ОстатокНаКонецПериода);
	КонецЕсли;
	
	Отклонение = Формат(Отклонение, "ЧДЦ=");
	
	Возврат Отклонение;
	
КонецФункции

&НаСервере
Функция ЗаполнитьПоказатели(НачалоПериода, КонецПериода, СписокПодразделений)
	
	ТаблицаПоказателей.Очистить();
	
	ДоходЗаПериод = ПолучитьОборотПоСчету(ПланыСчетов.Управленческий.Доходы, ВидДвиженияБухгалтерии.Кредит);
	РасходЗаПериод = ПолучитьОборотПоСчету(ПланыСчетов.Управленческий.Расходы, ВидДвиженияБухгалтерии.Дебет);
	ПрибыльЗаПериод = ДоходЗаПериод - РасходЗаПериод;
	ОтклонениеПоКассеЗаПериод = ПолучитьОтклонение("Касса", НачалоПериода, КонецПериода, СписокПодразделений);
	
	ДобавитьПоказатель("Доход за период", ДоходЗаПериод);
	ДобавитьПоказатель("Расход за период", РасходЗаПериод);
	ДобавитьПоказатель("Прибыль за период", ПрибыльЗаПериод);
	
	ДДСЗаПериод = ПолучитьОборотыПоДДС();
	ВыплатыЗаПериод = ДДСЗаПериод.ВыплатыЗаПериод;
	ПоступленияЗаПериод = ДДСЗаПериод.ПоступленияЗаПериод;
	
	ДобавитьПоказатель("Поступления за период", ПоступленияЗаПериод);
	ДобавитьПоказатель("Выплаты за период", ВыплатыЗаПериод);
	ДобавитьПоказатель("Отклонение за период по кассе", ОтклонениеПоКассеЗаПериод);
	
	ОстатокДенежныхСредствКонец = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.ДенежныеСредства,, ПериодОтчета.ДатаОкончания);
	ОстатокВКассахКонец = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.Касса,, ПериодОтчета.ДатаОкончания);
	ОстатокВОперационныхКассахКонец = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.ОперационнаяКасса,, ПериодОтчета.ДатаОкончания);
	ОстатокВПодотчетеКонец = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.Подотчет,, ПериодОтчета.ДатаОкончания);
	ОстатокНаРасчетныхСчетахКонец = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.РасчетныйСчет,, ПериодОтчета.ДатаОкончания);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьЛимит()
	
	Если (СписокПодразделений.Количество() = 1) Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НачалоПериода", ПериодОтчета.ДатаНачала);
		Запрос.УстановитьПараметр("КонецПериода", ПериодОтчета.ДатаОкончания);
		Запрос.УстановитьПараметр("Подразделения", СписокПодразделений);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(ЦеховойЛимитОбороты.СтоимостьУслугОборот, 0) КАК Лимит,
		|	ЕСТЬNULL(ЦеховойЛимитОбороты.СтоимостьУслугФактОборот, 0) КАК Наряд,
		|	ЦеховойЛимитОбороты.Период КАК Период
		|ИЗ
		|	РегистрНакопления.ЦеховойЛимит.Обороты(&НачалоПериода, &КонецПериода, День, Подразделение В (&Подразделения)) КАК ЦеховойЛимитОбороты
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период
		|ИТОГИ
		|	СУММА(Лимит),
		|	СУММА(Наряд)
		|ПО
		|	Период ПЕРИОДАМИ(ДЕНЬ, &НачалоПериода, &КонецПериода)";
		
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Период" ,"ВСЕ");
		
		СуммаЛимит = 0;
		СуммаНаряд = 0;
		СуммаДней = 0;
		
		Пока Выборка.Следующий() Цикл
			
			Лимит = Выборка.Лимит;
			Наряд = Выборка.Наряд;
			
			Если НЕ ЗначениеЗаполнено(Лимит) Тогда
				Лимит = 0;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(Наряд) Тогда
				Наряд = 0;
			КонецЕсли;
			
			Если Лимит > 0 Тогда
				СуммаДней = СуммаДней + 1;
			КонецЕсли;
			
			СуммаЛимит = СуммаЛимит + Лимит;
			СуммаНаряд = СуммаНаряд + Наряд;
			
			
		КонецЦикла;
		
		Если СуммаДней > 0 Тогда
			СреднийЛимит = Окр(СуммаЛимит / СуммаДней);
			СреднийНаряд = Окр(СуммаНаряд / СуммаДней);
		Иначе
			СреднийЛимит = "Недоступно";
			СреднийНаряд = "Недоступно";
		КонецЕсли;
		
	Иначе
		
		СреднийЛимит = "Недоступно";
		СреднийНаряд = "Недоступно";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	Если НЕ ЗначениеЗаполнено(ПериодОтчета) Тогда
		ПериодОтчета.ДатаНачала = НачалоМесяца(ТекущаяДата());
		ПериодОтчета.ДатаОкончания = КонецМесяца(ТекущаяДата());
	КонецЕсли;
	
	ЗаполнитьПоказатели(ПериодОтчета.ДатаНачала, ПериодОтчета.ДатаОкончания, СписокПодразделений);
	ЗаполнитьЛимит();
	
	ДанныеПродажи = Отчеты.КлючевыеПоказатели.ЗаполнитьПродажи(ПериодОтчета.ДатаНачала, ПериодОтчета.ДатаОкончания, СписокПодразделений);
	
	ТабДокКасса = Отчеты.КлючевыеПоказатели.СформироватьОтчет(ПериодОтчета.ДатаНачала, ПериодОтчета.ДатаОкончания, СписокПодразделений, "Касса", ДанныеПродажи);
	ТабДокНачисления = Отчеты.КлючевыеПоказатели.СформироватьОтчет(ПериодОтчета.ДатаНачала, ПериодОтчета.ДатаОкончания, СписокПодразделений, "Начисления", ДанныеПродажи);
	ТабДокЭкономика = Отчеты.КлючевыеПоказатели.СформироватьОтчетЭкономика(ПериодОтчета.ДатаНачала, ПериодОтчета.ДатаОкончания, СписокПодразделений, ДанныеПродажи);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОборотПоСчету(Счет, ВидДвижения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ПериодОтчета.ДатаОкончания);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УправленческийОбороты.СуммаОборотДт,
	|	УправленческийОбороты.СуммаОборотКт
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(&НачалоПериода, КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ), , Счет В ИЕРАРХИИ (&Счет), , Подразделение В (&СписокПодразделений), , ) КАК УправленческийОбороты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если ВидДвижения = ВидДвиженияБухгалтерии.Дебет Тогда
		Оборот = Выборка.СуммаОборотДт;
	ИначеЕсли ВидДвижения = ВидДвиженияБухгалтерии.Кредит Тогда
		Оборот = Выборка.СуммаОборотКт;
	КонецЕсли;
	
	Возврат Оборот;
	
КонецФункции

&НаСервере
Функция ПолучитьОборотыПоДДС()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ПериодОтчета.ДатаОкончания);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УправленческийОбороты.СуммаОборотДт,
	|	УправленческийОбороты.СуммаОборотКт
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ДенежныеСредства)),
	|			,
	|			Подразделение В (&СписокПодразделений)
	|				И НЕ Субконто1.Внутрифирменная
	|				И НЕ Субконто1.МеждуСчетами,
	|			,
	|			) КАК УправленческийОбороты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Движения = Новый Структура;
	Движения.Вставить("ВыплатыЗаПериод", Выборка.СуммаОборотКт);
	Движения.Вставить("ПоступленияЗаПериод", Выборка.СуммаОборотДт);
	
	Возврат Движения;
	
КонецФункции

&НаСервере
Функция ПолучитьОстатокПоСчету(Счет, ВидДвижения = Неопределено, Знач Период = Неопределено)
	
	Если День(Период) <> 1 Тогда
		Период = КонецДня(Период) + 1;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УправленческийОстатки.СуммаОстатокДт,
	|	УправленческийОстатки.СуммаОстатокКт,
	|	УправленческийОстатки.СуммаРазвернутыйОстатокДт,
	|	УправленческийОстатки.СуммаРазвернутыйОстатокКт,
	|	УправленческийОстатки.СуммаОстаток
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(&Период, Счет В ИЕРАРХИИ (&Счет), , Подразделение В (&СписокПодразделений)) КАК УправленческийОстатки";
	
	Выборка = Запрос.Выполнить().Выбрать(); // 24%
	Выборка.Следующий();
	
	Если ВидДвижения = ВидДвиженияБухгалтерии.Дебет Тогда
		Остаток = Выборка.СуммаРазвернутыйОстатокДт;
	ИначеЕсли ВидДвижения = ВидДвиженияБухгалтерии.Кредит Тогда
		Остаток = Выборка.СуммаРазвернутыйОстатокКт;
	Иначе
		Остаток = Выборка.СуммаОстаток;
	КонецЕсли;
	
	Возврат Остаток;
	
КонецФункции

&НаСервере
Функция ПолучитьОборотПоСубконто(Счет, Субконто)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ПериодОтчета.ДатаОкончания);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.УстановитьПараметр("Субконто", Субконто);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УправленческийОбороты.СуммаОборот
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ),
	|			,
	|			Счет В ИЕРАРХИИ (&Счет),
	|			,
	|			Подразделение В (&СписокПодразделений)
	|				И Субконто1 = &Субконто,
	|			,
	|			) КАК УправленческийОбороты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Сумма = Выборка.СуммаОборот;
	
	Возврат Сумма;
	
КонецФункции

&НаСервере
Функция ПолучитьРазвернутыйОстатокПоСчету(Счет, ВидДвижения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонецПериода", ПериодОтчета.ДатаОкончания + 1);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УправленческийОстатки.Субконто1,
	|	УправленческийОстатки.Субконто2,
	|	УправленческийОстатки.Субконто3,
	|	УправленческийОстатки.СуммаРазвернутыйОстатокДт КАК СуммаРазвернутыйОстатокДт,
	|	УправленческийОстатки.СуммаРазвернутыйОстатокКт КАК СуммаРазвернутыйОстатокКт
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(&КонецПериода, Счет = &Счет, , Подразделение В (&СписокПодразделений)) КАК УправленческийОстатки
	|ИТОГИ
	|	СУММА(СуммаРазвернутыйОстатокДт),
	|	СУММА(СуммаРазвернутыйОстатокКт)
	|ПО
	|	ОБЩИЕ";
	
	Выборка = Запрос.Выполнить().Выбрать(); //51 %
	Выборка.Следующий();
	
	Если ВидДвижения = ВидДвиженияБухгалтерии.Дебет Тогда
		Остаток = Выборка.СуммаРазвернутыйОстатокДт;
	ИначеЕсли ВидДвижения = ВидДвиженияБухгалтерии.Кредит Тогда
		Остаток = Выборка.СуммаРазвернутыйОстатокКт;
	КонецЕсли;
	
	Возврат Остаток;
	
КонецФункции

&НаКлиенте
Функция РасшифроватьЯчейку(Расшифровка)
	
	ЗаголовокОтчета = "" + Расшифровка.ВидРасшифровки + ": " + Расшифровка.Статья;
	
	Если Расшифровка.ВидРасшифровки = "ДР"
		ИЛИ Расшифровка.ВидРасшифровки = "ДДС"
		ИЛИ Расшифровка.ВидРасшифровки = "Итого" Тогда
		
		ТабДок = СформироватьРасшифровкуДень(Расшифровка);
		ТабДок.ИмяПараметровПечати = "ПараметрыПечати_РасшифровкаКлючевыеПоказатели";
		ТабДок.АвтоМасштаб = Истина;
		ТабДок.ОтображатьСетку = Ложь;
		ТабДок.Защита = Истина;
		ТабДок.ТолькоПросмотр = Истина;
		ТабДок.ОтображатьЗаголовки = Ложь;
		ТабДок.Показать(ЗаголовокОтчета);
		
	ИначеЕсли Расшифровка.ВидРасшифровки = "ШапкаДР"
		ИЛИ Расшифровка.ВидРасшифровки = "ШапкаДДС" Тогда
		
		Если Расшифровка.ВидРасшифровки = "ШапкаДДС" Тогда
			ИмяФормыОтчета = "Отчет.ОтчетПоОборотамДДС.ФормаОбъекта";
		Иначе
			ИмяФормыОтчета = "Отчет.ОтчетПоОборотамДР.ФормаОбъекта";
		КонецЕсли;
		
		ПериодРасшифровки = ПериодОтчета;
		
		ПользовательскиеНастройки = ПолучитьПользовательскиеНастройки(Расшифровка, ПериодРасшифровки, СписокПодразделений);
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
		ПараметрыФормы.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройки);
		ОткрытьФорму(ИмяФормыОтчета, ПараметрыФормы);
		
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПользовательскиеНастройки(Расшифровка, ПериодРасшифровки, СписокПодразделений)
	
	Если Расшифровка.ВидРасшифровки = "ШапкаДДС" Тогда
		ИмяПоляОтбораСтатьи = "СтатьяДДС";
		ОтчетОбъект = Отчеты.ОтчетПоОборотамДДС.Создать();
	Иначе
		ИмяПоляОтбораСтатьи = "СтатьяДР";
		ОтчетОбъект = Отчеты.ОтчетПоОборотамДР.Создать();
	КонецЕсли;
	
	КомпоновщикНастроек = ОтчетОбъект.КомпоновщикНастроек;
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ПериодОтчета", ПериодРасшифровки);
	
	ЭлементОтбора = ПолучитьЭлементОтбора("Подразделение", Настройки);
	Если ЭлементОтбора <> Неопределено Тогда
		ЭлементОтбора.ПравоеЗначение = СписокПодразделений;
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	КонецЕсли;
	
	ЭлементОтбора = ПолучитьЭлементОтбора(ИмяПоляОтбораСтатьи, Настройки);
	Если ЭлементОтбора <> Неопределено Тогда
		ЭлементОтбора.ПравоеЗначение = Расшифровка.Статья;
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
	КонецЕсли;
	
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
	Возврат КомпоновщикНастроек.ПользовательскиеНастройки;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЭлементОтбора(ИмяПоля, Настройки)
	
	Результат = Неопределено;
	
	ПолеКомпоновкиДанных = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Для каждого ЭлементОтбора Из Настройки.Отбор.Элементы Цикл
		
		Если ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновкиДанных Тогда
			Результат = ЭлементОтбора;
			Результат.Использование = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция СформироватьРасшифровкуДень(Расшифровка)
	
	ТабДок = Новый ТабличныйДокумент;
	
	Макет = Отчеты.КлючевыеПоказатели.ПолучитьМакет("МакетРасшифровкиРегистратор");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	Если ТипЗнч(Расшифровка.Период) = Тип("Дата") Тогда
		НачалоПериода = НачалоДня(Расшифровка.Период);
		КонецПериода = КонецДня(Расшифровка.Период);
	Иначе
		НачалоПериода = ПериодОтчета.ДатаНачала;
		КонецПериода = ПериодОтчета.ДатаОкончания;
	КонецЕсли;
	
	ОбластьЗаголовок.Параметры.Статья = Расшифровка.Статья;
	ОбластьЗаголовок.Параметры.Период = ПредставлениеПериода(НачалоПериода, КонецПериода);
	
	ОбластьЗаголовок.Параметры.СписокПодразделений = ПолучитьСписокСтрокой(СписокПодразделений);
	
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапка);
	
	Если ТипЗнч(Расшифровка.Статья) = Тип("СправочникСсылка.СтатьиДвиженияДенежныхСредств") Тогда
		Счет = ПланыСчетов.Управленческий.ДенежныеСредства;
	ИначеЕсли ТипЗнч(Расшифровка.Статья) = Тип("СправочникСсылка.СтатьиДоходовРасходов") Тогда
		Счет = ПланыСчетов.Управленческий.ПрибыльУбытки;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("Статья", Расшифровка.Статья);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.УстановитьПараметр("Счет", Счет);
	
	Если Расшифровка.Статья <> "Продажи" Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УправленческийОбороты.СуммаОборот КАК Сумма,
		|	УправленческийОбороты.Регистратор КАК Документ,
		|	УправленческийОбороты.Регистратор.Комментарий КАК Комментарий,
		|	УправленческийОбороты.Субконто1 КАК Статья
		|ИЗ
		|	РегистрБухгалтерии.Управленческий.Обороты(
		|			&НачалоПериода,
		|			КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ),
		|			Регистратор,
		|			Счет В ИЕРАРХИИ (&Счет),
		|			,
		|			Подразделение В (&СписокПодразделений)
		|				И Субконто1 В ИЕРАРХИИ (&Статья),
		|			,
		|			) КАК УправленческийОбороты
		|
		|УПОРЯДОЧИТЬ ПО
		|	УправленческийОбороты.Регистратор.Дата
		|ИТОГИ
		|	СУММА(Сумма)
		|ПО
		|	ОБЩИЕ";
		
	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Данные.СуммаОборот КАК Сумма,
		|	Данные.Регистратор КАК Документ,
		|	""Продажи"" КАК Статья
		|ИЗ
		|	РегистрНакопления.ПродажиФакт.Обороты(&НачалоПериода, КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ), Регистратор, Подразделение В (&СписокПодразделений)) КАК Данные
		|ИТОГИ
		|	СУММА(Сумма)
		|ПО
		|	ОБЩИЕ";
		
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИтог = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаИтог.Следующий();
	ОбластьПодвал.Параметры.ИтогСумма = ВыборкаИтог.Сумма;
	
	ВыборкаДетальныеЗаписи = ВыборкаИтог.Выбрать();
	
	НомерСтроки = 1;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОбластьСтрока.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
		ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
		ТабДок.Вывести(ОбластьСтрока);
		НомерСтроки = 1 + НомерСтроки;
	КонецЦикла;
	
	ТабДок.Вывести(ОбластьПодвал);
	
	Возврат ТабДок;
	
КонецФункции

&НаСервере
Функция ПолучитьСписокСтрокой(СписокЗначений)
	
	Результат = "";
	
	Для каждого Элем Из СписокЗначений Цикл
		
		Результат = Результат + Элем.Значение + ";";
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	// { Васильев Александр Леонидович [21.03.2014]
	// не уверен, нужна ли такая проверка...
	// } Васильев Александр Леонидович [21.03.2014]
	
	Если ТипЗнч(ИсточникВыбора) = Тип("УправляемаяФорма")
		И ИсточникВыбора.ИмяФормы = "Справочник.Подразделения.Форма.ФормаВыбораНескольких" Тогда
		
		Если НЕ ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(ВыбранноеЗначение, СписокПодразделений) Тогда
			СписокПодразделений = ВыбранноеЗначение;
			ОбновитьСписокПодразделений();
			ТабДокНеАктуальны();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПодразделенийНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("ОригинальныйСписок", СписокПодразделений);
	ОткрытьФорму("Справочник.Подразделения.Форма.ФормаВыбораНескольких", ПараметрыФормы, ЭтаФорма, Неопределено, Неопределено, Неопределено, Неопределено, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Функция ОбновитьСписокПодразделений()
	
	Если СписокПодразделений.Количество() = 0 Тогда
		
		СписокПодразделений.Добавить();
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ТабДокНеАктуальны()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ТабДокКасса, "НеАктуальность");
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ТабДокНачисления, "НеАктуальность");
	
КонецФункции

&НаСервере
Функция ДобавитьПоказатель(Имя, Значение)
	
	Строка = ТаблицаПоказателей.Добавить();
	Строка.Наименование = Имя;
	Строка.Значение = Значение;
	
КонецФункции

#КонецОбласти
