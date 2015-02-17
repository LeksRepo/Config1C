﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Спецификация") Тогда
		
		Подразделение = ДанныеЗаполнения.Производство;
		Склад = Подразделение.ОсновнойСклад;
		Спецификация = ДанныеЗаполнения;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И НЕ Проведен Тогда
		Дата = ТекущаяДата();	
	КонецЕсли;
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	КомплектацияСсылка = Документы.Комплектация.ПолучитьКомплектацию(Спецификация);
	
	Если ЗначениеЗаполнено(КомплектацияСсылка) И Ссылка <> КомплектацияСсылка Тогда
		
		Отказ = Истина;
		ТекстСообщения = "К " + Спецификация + " уже введена " + КомплектацияСсылка;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, КомплектацияСсылка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Управленческий.Записать();
	
	Ошибки = Неопределено;
	СвойстваДокумента = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Ссылка, "Подразделение, Дата");
	
	Если Дата >= '2014.06.01' Тогда
		
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
		
		Нехватка = ЛексСервер.ПеремещениеМатериаловВПроизводство(ТаблицаМатериалов, Подразделение, Склад, Движения, МоментВремени());
		
	Иначе
		
		Нехватка = ЛексСервер.ПеремещениеМатериаловСЛогистики(Ссылка, Движения);
		
	КонецЕсли;
	
	Для каждого СтрокаНехватки Из Нехватка Цикл
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%5 На складе %1 недостаточно материала '%2'. Из требуемых %3 есть только %4", 
		Склад,
		СтрокаНехватки.Номенклатура, 
		СтрокаНехватки.КоличествоТребуется,
		СтрокаНехватки.КоличествоОстаток,
		Ссылка);
		Поле = "Объект.СписокНоменклатуры[" +Строка(СтрокаНехватки.НомерСтроки-1) + "].КоличествоЦех";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстСообщения);
		
	КонецЦикла;
	
	Если Ошибки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		Возврат;
		
	Иначе
		
		Движения.Управленческий.Записывать = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
