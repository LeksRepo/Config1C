﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	СчетКт = ПланыСчетов.Управленческий.Подотчет;
	СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ПлатежиЗаОперативныйЗакуп;
	
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
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДДС] = ТекСтрокаСписокПлатежей.СтатьяДДС;
		
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
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		ДатаСоздания = ТекущаяДата();	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Дата = НачалоДня(ТекущаяДата()) + 32400;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОперативныйЗакуп") Тогда
		
		ДокументОснование = ДанныеЗаполнения;
		Подразделение = ДанныеЗаполнения.Подразделение;
		Склад = ДанныеЗаполнения.Подразделение.ОсновнойСклад;
		Комментарий = "Введено на основании " + ДанныеЗаполнения;
		
		Запрос = Новый Запрос;
		Запрос.Параметры.Вставить("Документ", ДанныеЗаполнения);
		Запрос.Параметры.Вставить("Подразделение", Подразделение);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СписокНом.Номенклатура КАК Номенклатура,
		|	СписокНом.Номенклатура.Наименование КАК НоменклатураНаименование,
		|	СписокНом.Поставщик КАК Контрагент,
		|	СписокНом.Спецификация.Номер КАК СпецНомер,
		|	СписокНом.Комментарий КАК Комментарий,
		|	ВЫБОР
		|		КОГДА СписокНом.Номенклатура.Базовый
		|			ТОГДА ЕСТЬNULL(Цены.ПлановаяЗакупочная, 0)
		|		ИНАЧЕ ЕСТЬNULL(Цены.ПлановаяЗакупочная, 0) * СписокНом.Номенклатура.КоэффициентБазовых
		|	КОНЕЦ КАК ПлановаяЦена
		|ИЗ
		|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК СписокНом
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(, Подразделение = &Подразделение) КАК Цены
		|		ПО (СписокНом.Номенклатура = Цены.Номенклатура
		|				ИЛИ СписокНом.Номенклатура.БазоваяНоменклатура = Цены.Номенклатура)
		|ГДЕ
		|	СписокНом.Ссылка = &Документ
		|	И СписокНом.КоличествоКупить > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НоменклатураНаименование";
		
		ТЗ = Запрос.Выполнить().Выгрузить();
		
		Для Каждого Стр ИЗ ТЗ Цикл
			
			НоваяСтрока = СписокНоменклатуры.Добавить();
			НоваяСтрока.Номенклатура = Стр.Номенклатура;
			НоваяСтрока.Контрагент = Стр.Контрагент;
			НоваяСтрока.ПлановаяЦена = Стр.ПлановаяЦена;
			
			Если ЗначениеЗаполнено(Стр.СпецНомер) Тогда
				НомерСпец = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(Стр.СпецНомер);
				НоваяСтрока.Комментарий = " Спец: " + НомерСпец + Стр.Комментарий;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(Склад) И СписокНоменклатуры.Количество() > 0 Тогда
		
		Отказ= Истина;
		ТекстСообщения = "Укажите склад";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Склад");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	ДатыЗапретаИзменения. ПроверитьДатуЗапретаИзмененияПередУдалением(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Отказ = ЛексСервер.ДоступнаОтменаПроведения(Ссылка);
	
КонецПроцедуры