﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем
СчетКт,
СчетМатериалы,
СчетВзаиморасчетыСПоставщиками,
ПВХСклад,
ПВХКонтрагент,
ПВХОфисы,
ПВХСтатьиДР,
Запрос;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Функция ИнициализироватьПеременныеМодуля()
	
	СчетМатериалы = ПланыСчетов.Управленческий.МатериалыНаСкладе;
	СчетВзаиморасчетыСПоставщиками = ПланыСчетов.Управленческий.ВзаиморасчетыСПоставщиками;
	СчетРасходы = ПланыСчетов.Управленческий.Расходы;
	
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
	|	ВЫБОР
	|		КОГДА ПоступлениеМатериаловУслугМатериалы.Номенклатура.Базовый
	|			ТОГДА ПоступлениеМатериаловУслугМатериалы.Номенклатура
	|		ИНАЧЕ ПоступлениеМатериаловУслугМатериалы.Номенклатура.БазоваяНоменклатура
	|	КОНЕЦ КАК БазоваяНоменклатура,
	|	ПоступлениеМатериаловУслугМатериалы.Номенклатура,
	|	ПоступлениеМатериаловУслугМатериалы.Количество * ПоступлениеМатериаловУслугМатериалы.Номенклатура.КоэффициентБазовых КАК КоличествоВБазовых,
	|	ПоступлениеМатериаловУслугМатериалы.Количество КАК Количество,
	|	ПоступлениеМатериаловУслугМатериалы.Сумма КАК Сумма
	|ПОМЕСТИТЬ Подг
	|ИЗ
	|	Документ.ПоступлениеМатериаловУслуг.Материалы КАК ПоступлениеМатериаловУслугМатериалы
	|ГДЕ
	|	ПоступлениеМатериаловУслугМатериалы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Подг.БазоваяНоменклатура КАК БазоваяНоменклатура,
	|	Подг.Номенклатура КАК Номенклатура,
	|	Подг.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА Подг.КоличествоВБазовых <> 0
	|			ТОГДА Подг.Сумма / Подг.КоличествоВБазовых
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ЦенаВБазовых,
	|	Подг.Сумма КАК Сумма
	|ИЗ
	|	Подг КАК Подг
	|ИТОГИ
	|	СРЕДНЕЕ(ЦенаВБазовых)
	|ПО
	|	БазоваяНоменклатура";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока Выборка.Следующий() Цикл
		
		Проводка = Движения.ЦеныПоставщиков.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.Сумма =Выборка.ЦенаВБазовых;
		Проводка.Номенклатура = Выборка.БазоваяНоменклатура;
		Проводка.Поставщик = Контрагент;
		
		ВыборкаПоНоменклатуре = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПоНоменклатуре.Следующий() Цикл
			
			Проводка = Движения.Управленческий.Добавить();
			Проводка.Период = Дата;
			Проводка.Подразделение = Подразделение;
			Проводка.Сумма = ВыборкаПоНоменклатуре.Сумма;
			Проводка.СчетДт = СчетМатериалы;
			Проводка.СубконтоДт[ПВХСклад] = Склад;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = ВыборкаПоНоменклатуре.Номенклатура;
			Проводка.КоличествоДт = ВыборкаПоНоменклатуре.Количество;
			Проводка.СчетКТ = фСчетКт;
			
			Если фСчетКт = ПланыСчетов.Управленческий.Доходы Тогда
				Проводка.СубконтоКт[ПВХСтатьиДР] = Справочники.СтатьиДоходовРасходов.ОприходованиеМатериалов;
			Иначе
				Проводка.СубконтоКт[ПВХКонтрагент] = Контрагент;
			КонецЕсли;
			
			Проводка.Содержание = "";
			
		КонецЦикла;
		
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
		Проводка.СчетДт = ПланыСчетов.Управленческий.Расходы;
		Проводка.СубконтоДт[ПВХСтатьиДР] = Выборка.СтатьяДоходаРасхода;
		
		Проводка.СчетКТ = СчетВзаиморасчетыСПоставщиками;
		Проводка.СубконтоКт[ПВХКонтрагент] = Контрагент;
		Проводка.Содержание = Выборка.Содержание;
		
	КонецЦикла;
	
КонецФункции

Функция СформироватьДвиженияОсновныеСредства(фСчетКт, Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	тзОсновныеСредства.ОсновноеСредство КАК ОсновноеСредство,
	|	тзОсновныеСредства.НомерСтроки
	|ПОМЕСТИТЬ втОсновныеСредства
	|ИЗ
	|	Документ.ПоступлениеМатериаловУслуг.ОсновныеСредства КАК тзОсновныеСредства
	|ГДЕ
	|	тзОсновныеСредства.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втОсновныеСредства.ОсновноеСредство,
	|	втОсновныеСредства.НомерСтроки
	|ИЗ
	|	втОсновныеСредства КАК втОсновныеСредства
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеОсновныхСредств.СрезПоследних(
	|				&МоментВремени,
	|				ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						т.ОсновноеСредство
	|					ИЗ
	|						втОсновныеСредства КАК т)) КАК СостояниеОсновныхСредствСрезПоследних
	|		ПО втОсновныеСредства.ОсновноеСредство = СостояниеОсновныхСредствСрезПоследних.ОсновноеСредство
	|ГДЕ
	|	НЕ СостояниеОсновныхСредствСрезПоследних.ПринятоКУчету ЕСТЬ NULL ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Ошибки = Неопределено;
	ПолеОшибки = "Объект.ОсновныеСредства[%1].ОсновноеСредство";
	ТекстГруппыОшибок = "ОС в строке %1 уже числится на балансе предприятия";
	ТекстОшибки = "ОС уже числится на балансе предприятия";
	
	Пока Выборка.Следующий() Цикл
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, ПолеОшибки, ТекстОшибки, 1,Выборка.НомерСтроки - 1, ТекстГруппыОшибок);
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если Отказ Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для каждого СтрокаОС Из ОсновныеСредства Цикл
		
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		Проводка.Сумма = СтрокаОС.Стоимость;
		
		Проводка.СчетДт = ПланыСчетов.Управленческий.ПервоначальнаяСтоимостьОС;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ОсновныеСредства] = СтрокаОС.ОсновноеСредство;
		
		Проводка.СчетКТ = фСчетКт;
		Если фСчетКт = ПланыСчетов.Управленческий.Доходы Тогда
			Проводка.СубконтоКт[ПВХСтатьиДР] = Справочники.СтатьиДоходовРасходов.ОприходованиеМатериалов;
		Иначе
			Проводка.СубконтоКт[ПВХКонтрагент] = Контрагент;
		КонецЕсли;
		
		Проводка.Содержание = СтрокаОС.Содержание;
		
		Проводка = Движения.СостояниеОсновныхСредств.Добавить();
		Проводка.Период = Дата;
		Проводка.ОсновноеСредство = СтрокаОС.ОсновноеСредство;
		Проводка.ПервоначальнаяСтоимость = СтрокаОС.Стоимость;
		Проводка.СрокАмортизации = СтрокаОС.Срок;
		Проводка.МОЛ = СтрокаОС.МОЛ;
		Проводка.НачислятьАмортизацию = СтрокаОС.НачислятьАмортизацию;
		Проводка.ПринятоКУчету = Истина;
		
	КонецЦикла;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ВидОперации = ЛексСервер.ПолучитьВидОперацииПоРоли();
	
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
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("Контрагент")
		И ДанныеЗаполнения.Свойство("Ссылка") Тогда
		
		Подразделение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.Ссылка, "Подразделение");
		Склад = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Подразделение, "ОсновнойСклад");
		Контрагент = ДанныеЗаполнения.Контрагент;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.Ссылка);
		Запрос.УстановитьПараметр("Контрагент", Контрагент);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СписокНом.Номенклатура,
		|	СписокНом.КоличествоПоставщик КАК Количество,
		|	СписокНом.Спецификация.Номер КАК СпецНомер,
		|	СписокНом.Комментарий КАК Комментарий
		|ИЗ
		|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК СписокНом
		|ГДЕ
		|	СписокНом.Ссылка = &Ссылка
		|	И СписокНом.КоличествоПоставщик > 0
		|	И СписокНом.Поставщик = &Контрагент";
		
		ТЗ = Запрос.Выполнить().Выгрузить();
		
		Для Каждого Стр ИЗ ТЗ Цикл
			
			 НоваяСтрока = Материалы.Добавить();
			 НоваяСтрока.Номенклатура = Стр.Номенклатура;
			 НоваяСтрока.Количество = Стр.Количество;
			 
			 Если ЗначениеЗаполнено(Стр.СпецНомер) Тогда
				НомерСпец = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(Стр.СпецНомер);
			 	НоваяСтрока.Содержание = " Спец: " + НомерСпец + Стр.Комментарий;
			 КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИнициализироватьПеременныеМодуля();
	
	Если ВидОперации = Перечисления.ХозяйственнаяОперация.ЗакупкаУПоставщика Тогда
		// оприходование бухгалтером
		// по полной программе
		
		СформироватьДвиженияМатериалы(ПланыСчетов.Управленческий.ВзаиморасчетыСПоставщиками);
		СформироватьДвиженияУслуги();
		СформироватьДвиженияОсновныеСредства(ПланыСчетов.Управленческий.ВзаиморасчетыСПоставщиками, Отказ)
		
	ИначеЕсли ВидОперации = Перечисления.ХозяйственнаяОперация.ОприходованиеКладовщиком Тогда
		// оприходование кладовщиком
		// принимаем только материалы на временный счет
		
		СформироватьДвиженияМатериалы(ПланыСчетов.Управленческий.ПромежуточныеВзаиморасчетыСПоставщиками);
		
	ИначеЕсли ВидОперации = Перечисления.ХозяйственнаяОперация.ОприходованиеБухгалтером Тогда
		// оприходование бухгалтером
		// принимаем ниоткуда (сразу прибыль)
		
		СформироватьДвиженияМатериалы(ПланыСчетов.Управленческий.Доходы);
		СформироватьДвиженияОсновныеСредства(ПланыСчетов.Управленческий.Доходы, Отказ)
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		Движения.Управленческий.Записывать = Истина;
		Движения.ЦеныПоставщиков.Записывать = Истина;
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
	
	ВидОперации = ЛексСервер.ПолучитьВидОперацииПоРоли();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	СуммаДокумента = Материалы.Итог("Сумма") + Услуги.Итог("Сумма") + ОсновныеСредства.Итог("Стоимость");
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		ДатаСоздания = ТекущаяДата();	
	КонецЕсли;	
	
КонецПроцедуры

Функция УстановитьВидОперацииПоРоли()
	
	
КонецФункции
