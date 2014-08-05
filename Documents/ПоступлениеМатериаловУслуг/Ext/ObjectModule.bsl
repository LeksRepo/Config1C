﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем
СчетКт,
СчетМатериалы,
СчетВзаиморасчетыСПоставщиками,
СчетРасходы,
ПВХСклад,
ПВХКонтрагент,
ПВХОфисы,
ПВХСтатьиДР,
Запрос;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Функция ИнициализироватьПеременныеМодуля()
	
	//Если ВидОперации = Перечисления.ХозяйственнаяОперация.ОприходованиеКладовщиком Тогда
	//	СчетКт = ПланыСчетов.Управленческий.ПромежуточныеВзаиморасчетыСПоставщиками;
	//Иначе
	//	СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПоставщиками;
	//КонецЕсли;
	
	СчетМатериалы = ПланыСчетов.Управленческий.МатериалыНаСкладе;
	СчетВзаиморасчетыСПоставщиками = ПланыСчетов.Управленческий.ВзаиморасчетыСПоставщиками;
	СчетРасходы = ЛексСервер.ПолучитьЗатратныйСчетПодразделения(Подразделение);
	
	ПВХСклад = ПланыВидовХарактеристик.ВидыСубконто.Склады;
	ПВХКонтрагент = ПланыВидовХарактеристик.ВидыСубконто.Контрагенты;
	ПВХОфисы = ПланыВидовХарактеристик.ВидыСубконто.Офисы;
	ПВХСтатьиДР = ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
КонецФункции

Функция СформироватьДвиженияМатериалы(фСчетКт)
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(ПоступлениеМатериаловУслугМатериалы.НомерСтроки) КАК НомерСтроки,
	|	ПоступлениеМатериаловУслугМатериалы.Номенклатура,
	|	СУММА(ПоступлениеМатериаловУслугМатериалы.Количество) КАК Количество,
	|	СУММА(ПоступлениеМатериаловУслугМатериалы.Сумма) КАК Сумма,
	|	МИНИМУМ(ПоступлениеМатериаловУслугМатериалы.Содержание) КАК Содержание
	|ИЗ
	|	Документ.ПоступлениеМатериаловУслуг.Материалы КАК ПоступлениеМатериаловУслугМатериалы
	|ГДЕ
	|	ПоступлениеМатериаловУслугМатериалы.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеМатериаловУслугМатериалы.Номенклатура";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.Сумма = Выборка.Сумма;
		Проводка.СчетДт = СчетМатериалы;
		Проводка.СубконтоДт[ПВХСклад] = Склад;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Выборка.Номенклатура;
		Проводка.КоличествоДт = Выборка.Количество;
		Проводка.СчетКТ = фСчетКт;
		
		Если фСчетКт = ПланыСчетов.Управленческий.Доходы Тогда
			Проводка.СубконтоКт[ПВХСтатьиДР] = Справочники.СтатьиДоходовРасходов.ОприходованиеМатериалов;
		Иначе
			Проводка.СубконтоКт[ПВХКонтрагент] = Контрагент;
		КонецЕсли;
		
		Проводка.Содержание = Выборка.Содержание;
		
	КонецЦикла;
	
КонецФункции

Функция СформироватьДвиженияУслуги()
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоступлениеМатериаловУслугУслуги.Номенклатура,
	|	СУММА(ПоступлениеМатериаловУслугУслуги.Сумма) КАК Сумма,
	|	МИНИМУМ(ПоступлениеМатериаловУслугУслуги.Содержание) КАК Содержание,
	|	ПоступлениеМатериаловУслугУслуги.Офис,
	|	ПоступлениеМатериаловУслугУслуги.Номенклатура.СтатьяДоходаРасхода СтатьяДоходаРасхода
	|ИЗ
	|	Документ.ПоступлениеМатериаловУслуг.Услуги КАК ПоступлениеМатериаловУслугУслуги
	|ГДЕ
	|	ПоступлениеМатериаловУслугУслуги.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеМатериаловУслугУслуги.Номенклатура,
	|	ПоступлениеМатериаловУслугУслуги.Офис";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.Сумма = Выборка.Сумма;
		Проводка.СчетДт = СчетРасходы;
		Проводка.СубконтоДт[ПВХСтатьиДР] = Выборка.СтатьяДоходаРасхода;
		
		// субконто Офис есть только у счета РасходыРозничнойСети
		
		Если ЗначениеЗаполнено(Выборка.Офис) И СчетРасходы = ПланыСчетов.Управленческий.РасходыРозничнойСети Тогда
			Проводка.СубконтоДт[ПВХОфисы] = Выборка.Офис;
		КонецЕсли;
		
		Проводка.СчетКТ = СчетВзаиморасчетыСПоставщиками;
		Проводка.СубконтоКт[ПВХКонтрагент] = Контрагент;
		Проводка.Содержание = Выборка.Содержание;
		
	КонецЦикла;
	
КонецФункции

Функция СформироватьДвиженияОсновныеСредства()
	
	// сюда бы контроль повторного оприходования ОС
	// и здесь же добавить проводки для начисления амортизации
	
	Для каждого СтрокаОС Из ОсновныеСредства Цикл
		
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.Сумма = СтрокаОС.Стоимость;
		Проводка.СчетДт = ПланыСчетов.Управленческий.ПервоначальнаяСтоимостьОС;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ОсновныеСредства] = СтрокаОС.ОсновноеСредство;
		Проводка.КоличествоДт = 1;
		
		Проводка.СчетКТ = СчетВзаиморасчетыСПоставщиками;
		Проводка.СубконтоКт[ПВХКонтрагент] = Контрагент;
		Проводка.Содержание = СтрокаОС.Содержание;
		
	КонецЦикла;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если РольДоступна("ВводОприходованияКладовщиком") Тогда
		
		ВидОперации = Перечисления.ХозяйственнаяОперация.ОприходованиеКладовщиком;
		
	Иначе
		
		ВидОперации = Перечисления.ХозяйственнаяОперация.ЗакупкаУПоставщика;
		
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ИнвентаризацияМатериалов") Тогда
		
		ВидОперации = Перечисления.ХозяйственнаяОперация.ОприходованиеБухгалтером;
		Подразделение = ДанныеЗаполнения.Подразделение;
		Склад = ДанныеЗаполнения.Склад;
		
		Для каждого Строка Из ДанныеЗаполнения.СписокНоменклатуры Цикл
			Если Строка.Отклонение > 0 Тогда
				НоваяСтрока = Материалы.Добавить();
				НоваяСтрока.Номенклатура = Строка.Номенклатура;
				НоваяСтрока.Количество = Строка.Отклонение;
				НоваяСтрока.Цена = Строка.Цена;
				НоваяСтрока.Сумма = Строка.Цена * НоваяСтрока.Количество;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Управленческий.Записывать = Истина;
	ИнициализироватьПеременныеМодуля();
	
	Если ВидОперации = Перечисления.ХозяйственнаяОперация.ЗакупкаУПоставщика Тогда
		// оприходование бухгалтером
		// по полной программе
		
		СформироватьДвиженияМатериалы(ПланыСчетов.Управленческий.ВзаиморасчетыСПоставщиками);
		СформироватьДвиженияУслуги();
		СформироватьДвиженияОсновныеСредства();
		
	ИначеЕсли ВидОперации = Перечисления.ХозяйственнаяОперация.ОприходованиеКладовщиком Тогда
		
		// оприходование кладовщиком
		// принимаем только материалы на временный счет
		СформироватьДвиженияМатериалы(ПланыСчетов.Управленческий.ПромежуточныеВзаиморасчетыСПоставщиками);
		
	ИначеЕсли ВидОперации = Перечисления.ХозяйственнаяОперация.ОприходованиеБухгалтером Тогда
		
		// оприходование бухгалтером
		// принимаем материалы ниоткуда (сразу прибыль)
		СформироватьДвиженияМатериалы(ПланыСчетов.Управленческий.Доходы);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	// реквизит Склад не всегда должен быть заполнен
	// Получаем только основные средства или только услуги
	Если Материалы.Количество() = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ВидОперации = Неопределено;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	СуммаДокумента = Материалы.Итог("Сумма") + Услуги.Итог("Сумма") + ОсновныеСредства.Итог("Стоимость");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
