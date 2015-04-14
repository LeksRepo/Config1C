﻿// { Васильев Александр Леонидович [13.04.2015]
// Костыль.
// Теперь можно упростить процедуру.
// Раньше было списание с цеха ещё.
// } Васильев Александр Леонидович [13.04.2015]

Процедура ВыполнитьСписаниеСоСклада(Отказ, Запрос)
	
	ОбщаяСебестоимость = 0;
	
	Движения.Управленческий.Очистить();
	Движения.Записать();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	тчДок.Номенклатура
	|ИЗ
	|	тчДок КАК тчДок";
	
	Результат = Запрос.Выполнить();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрБухгалтерии.Управленческий");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Счет", ПланыСчетов.Управленческий.МатериалыНаСкладе);
	ЭлементБлокировки.ИсточникДанных = Результат.Выгрузить();
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура, "Номенклатура");
	Блокировка.Заблокировать();
	
	ВидыСубконто = Новый Массив;
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Склады);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура);
	
	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	тчДок.Номенклатура,
	|	тчДок.НомерСтроки,
	|	тчДок.Количество,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
	|	ЕСТЬNULL(УправленческийОстатки.СуммаОстаток, 0) КАК СуммаОстаток
	|ИЗ
	|	тчДок КАК тчДок
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				&МоментВремени,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|				&ВидыСубконто,
	|				Подразделение = &Подразделение
	|					И Субконто1 = &Склад
	|					И Субконто2 В
	|						(ВЫБРАТЬ
	|							ТЧДок.Номенклатура
	|						ИЗ
	|							ТЧДок)) КАК УправленческийОстатки
	|		ПО тчДок.Номенклатура = УправленческийОстатки.Субконто2";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Количество > Выборка.КоличествоОстаток Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Недостаточно материла '%1'. Из требуемых %2 есть только %3", Выборка.Номенклатура, Выборка.Количество, Выборка.КоличествоОстаток);
			Поле = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("СписокНоменклатуры[%1].Количество", Выборка.НомерСтроки - 1);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле);
			Отказ = Истина;
			Продолжить;
			
		КонецЕсли;
		
		Если НЕ Отказ Тогда
			Если Выборка.Количество <> 0 Тогда
				Себестоимость = Выборка.Количество / Выборка.КоличествоОстаток * Выборка.СуммаОстаток;
			Иначе
				Себестоимость = 0;
			КонецЕсли;
			
			Проводка = Движения.Управленческий.Добавить();
			Проводка.Подразделение = Подразделение;
			Проводка.Период = Дата;
			Проводка.Сумма = Себестоимость;
			
			Проводка.СчетДт = ПланыСчетов.Управленческий.Расходы ;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходСписаниеМатериалов;
			
			Проводка.СчетКт = ПланыСчетов.Управленческий.МатериалыНаСкладе;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Выборка.Номенклатура;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = Склад;
			Проводка.КоличествоКт = Выборка.Количество;
			
			ОбщаяСебестоимость = ОбщаяСебестоимость + Себестоимость;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СуммаДокумента = ОбщаяСебестоимость;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.Управленческий.Очистить();
	Движения.Управленческий.Записывать = Истина;
	Движения.Управленческий.Записать();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписаниеМатериаловСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	МИНИМУМ(СписаниеМатериаловСписокНоменклатуры.НомерСтроки) КАК НомерСтроки,
	|	СУММА(СписаниеМатериаловСписокНоменклатуры.Количество) КАК Количество
	|ПОМЕСТИТЬ тчДок
	|ИЗ
	|	Документ.СписаниеМатериалов.СписокНоменклатуры КАК СписаниеМатериаловСписокНоменклатуры
	|ГДЕ
	|	СписаниеМатериаловСписокНоменклатуры.Ссылка = &Ссылка
	|	И СписаниеМатериаловСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|
	|СГРУППИРОВАТЬ ПО
	|	СписаниеМатериаловСписокНоменклатуры.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура";
	Запрос.Выполнить();
	
	ВыполнитьСписаниеСоСклада(Отказ, Запрос);
	
	Если НЕ Отказ Тогда
		
		// { Васильев Александр Леонидович [08.04.2015]
		// Удержание с зарплаты по плановым ценам, потому так сложно.
		// } Васильев Александр Леонидович [08.04.2015]
		
		Если ЗначениеЗаполнено(Виновный) Тогда
			Запрос.УстановитьПараметр("Подразделение", Подразделение);
			Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ВЫРАЗИТЬ(тчДок.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
			|	тчДок.Количество
			|ПОМЕСТИТЬ втНоменклатура
			|ИЗ
			|	тчДок КАК тчДок
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВЫБОР
			|		КОГДА втНоменклатура.Номенклатура.Базовый
			|			ТОГДА втНоменклатура.Номенклатура
			|		ИНАЧЕ втНоменклатура.Номенклатура.БазоваяНоменклатура
			|	КОНЕЦ КАК Номенклатура,
			|	ВЫБОР
			|		КОГДА втНоменклатура.Номенклатура.Базовый
			|			ТОГДА втНоменклатура.Количество
			|		ИНАЧЕ втНоменклатура.Количество * втНоменклатура.Номенклатура.КоэффициентБазовых
			|	КОНЕЦ КАК Количество
			|ПОМЕСТИТЬ втБазоваяНоменклатура
			|ИЗ
			|	втНоменклатура КАК втНоменклатура
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ЦеныНоменклатурыСрезПоследних.Розничная * втБазоваяНоменклатура.Количество КАК Сумма
			|ИЗ
			|	РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(
			|			&МоментВремени,
			|			Подразделение = &Подразделение
			|				И Номенклатура В
			|					(ВЫБРАТЬ
			|						т.Номенклатура
			|					ИЗ
			|						втБазоваяНоменклатура КАК т)) КАК ЦеныНоменклатурыСрезПоследних
			|		ЛЕВОЕ СОЕДИНЕНИЕ втБазоваяНоменклатура КАК втБазоваяНоменклатура
			|		ПО ЦеныНоменклатурыСрезПоследних.Номенклатура = втБазоваяНоменклатура.Номенклатура
			|ИТОГИ
			|	СУММА(Сумма)
			|ПО
			|	ОБЩИЕ";
			
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
				
				Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Выборка.Следующий();
				
				СуммаУдержания = Выборка.Сумма;
				
				Если СуммаУдержания <> 0 Тогда
					Проводка = Движения.Управленческий.Добавить();
					Проводка.Период = Дата;
					Проводка.Сумма = СуммаУдержания;
					Проводка.Подразделение = Подразделение;
					Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
					Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Виновный;
					Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний] = Справочники.ВидыНачисленийУдержаний.УдержанияЗаСписаниеМатериалов;
					Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
					Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыЗаПеределкиИУдержанияОтСотрудников;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Движения.Управленческий.Записывать = Истина;
		Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ИнвентаризацияМатериалов") Тогда
		
		Подразделение = ДанныеЗаполнения.Подразделение;
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

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры
