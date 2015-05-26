﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	ОприходованиеБухгалтером = ВидОперации = Перечисления.ХозяйственнаяОперация.ОприходованиеБухгалтером;
	
	Если ОприходованиеБухгалтером Тогда
		СчетКт = ПланыСчетов.Управленческий.Подотчет;
		СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ПлатежиЗаОперативныйЗакуп;
	Иначе
		СчетКт = ПланыСчетов.Управленческий.ПромежуточныеВзаиморасчетыСПодотчетниками;
	КонецЕсли;
	
	Для Каждого ТекСтрокаСписокПлатежей Из СписокПлатежей Цикл
		
		Движение = Движения.Управленческий.Добавить();
		Движение.Подразделение = Подразделение;
		Движение.Период = Дата;
		Движение.Сумма = ТекСтрокаСписокПлатежей.Сумма;
		Движение.Содержание = ТекСтрокаСписокПлатежей.Комментарий;
		
		Движение.СчетДт = ТекСтрокаСписокПлатежей.СчетУчета;
		Для Каждого Элемент Из Движение.СчетДт.ВидыСубконто Цикл
			Движение.СубконтоДт[Элемент.ВидСубконто] = ТекСтрокаСписокПлатежей["Субконто" +Элемент.НомерСтроки];
		КонецЦикла;
		
		Если Движение.СчетДт.Количественный Тогда
			Движение.КоличествоДт = ТекСтрокаСписокПлатежей.Количество;
		КонецЕсли;
		
		Движение.СчетКт = СчетКт;
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = ФизЛицо;
		Если ОприходованиеБухгалтером Тогда
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДДС] = ТекСтрокаСписокПлатежей.СтатьяДДС;
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА АвансовыйОтчетСписокНоменклатуры.Номенклатура.Базовый
	|			ТОГДА АвансовыйОтчетСписокНоменклатуры.Номенклатура
	|		ИНАЧЕ АвансовыйОтчетСписокНоменклатуры.Номенклатура.БазоваяНоменклатура
	|	КОНЕЦ КАК БазоваяНоменклатура,
	|	АвансовыйОтчетСписокНоменклатуры.Номенклатура,
	|	АвансовыйОтчетСписокНоменклатуры.Количество * АвансовыйОтчетСписокНоменклатуры.Номенклатура.КоэффициентБазовых КАК КоличествоВБазовых,
	|	АвансовыйОтчетСписокНоменклатуры.Количество КАК Количество,
	|	АвансовыйОтчетСписокНоменклатуры.Сумма КАК Сумма,
	|	АвансовыйОтчетСписокНоменклатуры.Контрагент
	|ПОМЕСТИТЬ втНоменклатура
	|ИЗ
	|	Документ.АвансовыйОтчет.СписокНоменклатуры КАК АвансовыйОтчетСписокНоменклатуры
	|ГДЕ
	|	АвансовыйОтчетСписокНоменклатуры.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНоменклатура.БазоваяНоменклатура КАК БазоваяНоменклатура,
	|	втНоменклатура.Номенклатура КАК Номенклатура,
	|	втНоменклатура.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА втНоменклатура.КоличествоВБазовых <> 0
	|			ТОГДА втНоменклатура.Сумма / втНоменклатура.КоличествоВБазовых
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ЦенаВБазовых,
	|	втНоменклатура.Сумма КАК Сумма,
	|	втНоменклатура.Контрагент КАК Контрагент
	|ИЗ
	|	втНоменклатура КАК втНоменклатура
	|ИТОГИ
	|	СРЕДНЕЕ(ЦенаВБазовых),
	|	МАКСИМУМ(Контрагент)
	|ПО
	|	БазоваяНоменклатура";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИтоги = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаИтоги.Следующий() Цикл
		
		Движение = Движения.ЦеныПоставщиков.Добавить();
		Движение.Период = Дата;
		Движение.Подразделение = Подразделение;
		Движение.Сумма = ВыборкаИтоги.ЦенаВБазовых;
		Движение.Номенклатура = ВыборкаИтоги.БазоваяНоменклатура;
		Движение.Поставщик = ВыборкаИтоги.Контрагент;
		
		ВыборкаДетальныеЗаписи = ВыборкаИтоги.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);	
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Движение = Движения.Управленческий.Добавить();
			Движение.Подразделение = Подразделение;
			Движение.Период = Дата;
			Движение.Сумма = ВыборкаДетальныеЗаписи.Сумма;
			
			Движение.СчетДт = ПланыСчетов.Управленческий.МатериалыНаСкладе;
			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = Склад;
			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = ВыборкаДетальныеЗаписи.Номенклатура;
			Движение.КоличествоДт = ВыборкаДетальныеЗаписи.Количество;
			
			Движение.СчетКт = СчетКт;
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = ФизЛицо;
			Если Движение.СчетКт = ПланыСчетов.Управленческий.Подотчет Тогда
				Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДДС] = СтатьяДДС;
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
	Движения.Управленческий.Записывать = Истина;
	Движения.ЦеныПоставщиков.Записывать = Истина;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	СуммаДокумента = СписокПлатежей.Итог("Сумма") + СписокНоменклатуры.Итог("Сумма");
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ВидОперации = ЛексСервер.ПолучитьВидОперацииПоРоли();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОперативныйЗакуп") Тогда
		
		ДокументОснование = ДанныеЗаполнения;
		Подразделение = ДанныеЗаполнения.Подразделение;
		Склад = ДанныеЗаполнения.Подразделение.ОсновнойСклад;
		Комментарий = "Введено на основании " + ДанныеЗаполнения;
		
		Запрос = Новый Запрос;
		Запрос.Параметры.Вставить("Документ", ДанныеЗаполнения);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СписокНом.Номенклатура КАК Номенклатура,
		|	СписокНом.Поставщик КАК Контрагент
		|ИЗ
		|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК СписокНом
		|ГДЕ
		|	СписокНом.Ссылка = &Документ
		|	И СписокНом.КоличествоАвансовый > 0
		|
		|СГРУППИРОВАТЬ ПО
		|	СписокНом.Номенклатура,
		|	СписокНом.Поставщик";
		
		СписокНоменклатуры.Загрузить(Запрос.Выполнить().Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(Склад) И СписокНоменклатуры.Количество() > 0 Тогда
		
		Отказ= Истина;
		ТекстСообщения = "Заполните значение склада";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Склад");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	ДатыЗапретаИзменения. ПроверитьДатуЗапретаИзмененияПередУдалением(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ВидОперации = ЛексСервер.ПолучитьВидОперацииПоРоли();
	
КонецПроцедуры
