﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Спецификация") Тогда
		
		Подразделение = ДанныеЗаполнения.Подразделение;
		Склад = Подразделение.ОсновнойСклад;
		Спецификация = ДанныеЗаполнения;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	СуммаДокумента = ПолучитьСуммуКомплектации();
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		ДатаСоздания = ТекущаяДата();
		Дата = ТекущаяДата();
	КонецЕсли;
	
	Если НЕ Проведен И (РежимЗаписи = РежимЗаписиДокумента.Проведение) Тогда
		Дата = ТекущаяДата();	
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСуммуКомплектации()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СписокНоменклатуры.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ВЫРАЗИТЬ(СписокНоменклатуры.КоличествоСклад КАК ЧИСЛО(15, 2)) КАК КоличествоСклад,
	|	ВЫРАЗИТЬ(СписокНоменклатуры.КоличествоЦех КАК ЧИСЛО(15, 2)) КАК КоличествоЦех
	|ПОМЕСТИТЬ СписокНоменклатуры
	|ИЗ
	|	&МассивНоменклатуры КАК СписокНоменклатуры
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
	|	СписокНоменклатуры.КоличествоСклад * ЦеныНоменклатурыСрезПоследних.Розничная + СписокНоменклатуры.КоличествоСклад * ЦеныНоменклатурыСрезПоследних.Розничная КАК Стоимость
	|ПОМЕСТИТЬ СтоимостьНоменклатуры
	|ИЗ
	|	СписокНоменклатуры КАК СписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиНоменклатуры.СрезПоследних(
	|				&Дата,
	|				Подразделение = &Подразделение
	|					И Номенклатура В
	|						(ВЫБРАТЬ
	|							СписокНоменклатуры.Номенклатура
	|						ИЗ
	|							СписокНоменклатуры КАК СписокНоменклатуры)) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО СписокНоменклатуры.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(СтоимостьНоменклатуры.Стоимость) КАК ОбщаяСумма
	|ИЗ
	|	СтоимостьНоменклатуры КАК СтоимостьНоменклатуры";
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("МассивНоменклатуры", СписокНоменклатуры);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ОбщаяСумма = 0;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ОбщаяСумма =ВыборкаДетальныеЗаписи.ОбщаяСумма;
		
	КонецЦикла;
	
	Возврат ОбщаяСумма;
	
КонецФункции // ПолучитьСуммуКомплектации()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Управленческий.Записать();
	
	Ошибки = Неопределено;
	СвойстваДокумента = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Ссылка, "Подразделение, Дата");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КомплектацияСписокНоменклатуры.Номенклатура,
	|	МИНИМУМ(КомплектацияСписокНоменклатуры.НомерСтроки) КАК НомерСтроки,
	|	СУММА(КомплектацияСписокНоменклатуры.КоличествоСклад + КомплектацияСписокНоменклатуры.КоличествоЦех) КАК Количество
	|ИЗ
	|	Документ.Комплектация.СписокНоменклатуры КАК КомплектацияСписокНоменклатуры
	|ГДЕ
	|	КомплектацияСписокНоменклатуры.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	КомплектацияСписокНоменклатуры.Номенклатура";
	
	ТаблицаМатериалов = Запрос.Выполнить().Выгрузить();
	
	Структура = ЛексСервер.ПеремещениеМатериаловВПроизводство(ТаблицаМатериалов, Подразделение, Склад, Движения, МоментВремени());
	
	Для каждого СтрокаНехватки Из Структура.тзНехватка Цикл
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%5 На складе %1 недостаточно материала '%2'. Из требуемых %3 есть только %4", 
		Склад,
		СтрокаНехватки.Номенклатура, 
		СтрокаНехватки.КоличествоТребуется,
		СтрокаНехватки.КоличествоОстаток,
		Ссылка);
		Поле = "Объект.СписокНоменклатуры[" +Строка(СтрокаНехватки.НомерСтроки-1) + "].КоличествоСклад"; // Обычно эта колонка заполнена
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстСообщения);
		
	КонецЦикла;
	
	Если Дата > Дата("20160601000000") Тогда
		
		Если ПроверитьПревышениеКомплектацииСпецификаций(Ошибки) Тогда
			СписатьМатериалыСоСчетаКомплектацииСпецификаций(Ссылка);
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если НЕ Отказ Тогда
		Движения.Управленческий.Записывать = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьПревышениеКомплектацииСпецификаций(Ошибки);
	
	Проходит = Истина;
	
	Если Дата < Дата("20160705000000") Тогда
		Возврат Проходит;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Спецификация) Тогда
		
		Запрос = Новый Запрос();
		
		Запрос.УстановитьПараметр("Документ", Ссылка);
		Запрос.УстановитьПараметр("Спецификация", Спецификация);
		Запрос.УстановитьПараметр("Период", МоментВремени());
		
		Запрос.Текст=
		"ВЫБРАТЬ
		|	Список.Номенклатура КАК Номенклатура,
		|	СУММА(Список.КоличествоСклад + Список.КоличествоЦех) КАК Количество,
		|	МИНИМУМ(Список.НомерСтроки) КАК НомерСтроки
		|ПОМЕСТИТЬ втНом
		|ИЗ
		|	Документ.Комплектация.СписокНоменклатуры КАК Список
		|ГДЕ
		|	Список.Ссылка = &Документ
		|
		|СГРУППИРОВАТЬ ПО
		|	Список.Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Остатки.Субконто2 КАК Номенклатура,
		|	СУММА(Остатки.КоличествоОстаток) КАК Количество
		|ПОМЕСТИТЬ втОстатки
		|ИЗ
		|	РегистрБухгалтерии.Управленческий.Остатки(&Период, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.КомплектацииСпецификаций), , Субконто1 = &Спецификация) КАК Остатки
		|
		|СГРУППИРОВАТЬ ПО
		|	Остатки.Субконто2
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Список.Номенклатура КАК Номенклатура,
		|	Список.НомерСтроки,
		|	ЕСТЬNULL(Остатки.Количество, 0) - ЕСТЬNULL(Список.Количество, 0) КАК Количество
		|ИЗ
		|	втНом КАК Список
		|		ЛЕВОЕ СОЕДИНЕНИЕ втОстатки КАК Остатки
		|		ПО Список.Номенклатура = Остатки.Номенклатура
		|ГДЕ
		|	ЕСТЬNULL(Остатки.Количество, 0) - ЕСТЬNULL(Список.Количество, 0) < 0";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.Количество < 0 Тогда
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 превышение количества требуемого по спецификации на %2", Выборка.Номенклатура, Выборка.Количество*-1);
				Поле = "Объект.СписокНоменклатуры[" +Строка(Выборка.НомерСтроки-1) + "].НомерСтроки";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстСообщения);
				
				Проходит = Ложь;
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Проходит = Ложь;
		
	КонецЕсли;
	
	Возврат Проходит;
	
КонецФункции

Функция СписатьМатериалыСоСчетаКомплектацииСпецификаций(Документ)
	
	Если ЗначениеЗаполнено(Документ.Спецификация) Тогда
		
		Счет = ПланыСчетов.Управленческий.КомплектацииСпецификаций;
		
		ПВХМестоОбработки = ПланыВидовХарактеристик.ВидыСубконто.МестоОбработки;
		ПВХСпецификации = ПланыВидовХарактеристик.ВидыСубконто.Спецификации;
		ПВХНоменклатура = ПланыВидовХарактеристик.ВидыСубконто.Номенклатура;
		
		Для Каждого Стр ИЗ Документ.СписокНоменклатуры Цикл
			
			Если Стр.КоличествоСклад > 0 Тогда
				
				Проводка = Движения.Управленческий.Добавить();
				Проводка.Период = Дата;
				Проводка.Подразделение = Подразделение;
				Проводка.СчетКт = Счет;
				
				Проводка.СубконтоКт[ПВХМестоОбработки] = Перечисления.МестоОбработки.Отгрузка;
				Проводка.СубконтоКт[ПВХСпецификации] = Документ.Спецификация;
				Проводка.СубконтоКт[ПВХНоменклатура] = Стр.Номенклатура;
				Проводка.КоличествоКт = Стр.КоличествоСклад;
				
			КонецЕсли;
			
			Если Стр.КоличествоЦех > 0 Тогда
				
				Проводка = Движения.Управленческий.Добавить();
				Проводка.Период = Дата;
				Проводка.Подразделение = Подразделение;
				Проводка.СчетКт = Счет;
				
				Проводка.СубконтоКт[ПВХМестоОбработки] = Перечисления.МестоОбработки.Цех;
				Проводка.СубконтоКт[ПВХСпецификации] = Документ.Спецификация;
				Проводка.СубконтоКт[ПВХНоменклатура] = Стр.Номенклатура;
				Проводка.КоличествоКт = Стр.КоличествоЦех;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ Спецификация.Проведен Тогда
		
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Запрещено проводить комплектацию к непроведенной спецификации");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Отказ = ЛексСервер.ДоступнаОтменаПроведения(Ссылка);
	
КонецПроцедуры