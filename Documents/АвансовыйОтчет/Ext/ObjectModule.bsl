﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	ОприходованиеБухгалтером = ВидОперации = Перечисления.ХозяйственнаяОперация.ОприходованиеБухгалтером;
	
	Если ОприходованиеБухгалтером Тогда
		СчетКт = ПланыСчетов.Управленческий.Подотчет;
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
	
	Для Каждого ТекСтрокаСписокНоменклатуры Из СписокНоменклатуры Цикл
		Движение = Движения.Управленческий.Добавить();
		Движение.Подразделение = Подразделение;
		Движение.Период = Дата;
		Движение.Сумма = ТекСтрокаСписокНоменклатуры.Сумма;
		Движение.Содержание = ТекСтрокаСписокНоменклатуры.Комментарий;
		
		Движение.СчетДт = ПланыСчетов.Управленческий.МатериалыНаСкладе;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = Склад;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = ТекСтрокаСписокНоменклатуры.Номенклатура;
		Движение.КоличествоДт = ТекСтрокаСписокНоменклатуры.Количество;
		
		Движение.СчетКт = СчетКт;
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = ФизЛицо;
		Если ОприходованиеБухгалтером Тогда
			// мнения разделились
			//Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДДС] = ТекСтрокаСписокНоменклатуры.Номенклатура.СтатьяДвиженияДенежныхСредств;
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДДС] = Справочники.СтатьиДвиженияДенежныхСредств.ПлатежиЗаОперативныйЗакуп;
		КонецЕсли;
		
	КонецЦикла;
	
	Движения.Управленческий.Записывать = Истина;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	СуммаДокумента = СписокПлатежей.Итог("Сумма") + СписокНоменклатуры.Итог("Сумма");
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
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
		|ПОМЕСТИТЬ Материалы
		|ИЗ
		|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК СписокНом
		|ГДЕ
		|  СписокНом.Ссылка = &Документ 
		|  И СписокНом.РучнойВвод > 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СписокНомПодЗаказ.Номенклатура КАК Номенклатура,
		|	СписокНомПодЗаказ.Поставщик КАК Контрагент
		|ИЗ
		|	Документ.ОперативныйЗакуп.СписокНоменклатурыПодЗаказ КАК СписокНомПодЗаказ
		|ГДЕ
		|  СписокНомПодЗаказ.Ссылка = &Документ
		|  И СписокНомПодЗаказ.РучнойВвод > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Материалы.Номенклатура КАК Номенклатура,
		|	Материалы.Контрагент КАК Контрагент
		|ИЗ
		|	Материалы КАК Материалы
		|
		|СГРУППИРОВАТЬ ПО
		|	Материалы.Номенклатура,
		|	Материалы.Контрагент";
		
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



