﻿
Функция ПолучитьСчетаПоВидуОперации(ВидОперации) Экспорт
	
	Если ВидОперации = Перечисления.ВидыОпераций.ОплатаОтПокупателяВОперационнуюКассу Тогда //Приход
		
		СчетДт = ПланыСчетов.Управленческий.ОперационнаяКасса;
		СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОпераций.ОплатаПоставщику Тогда //Расход
		
		СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПоставщиками;
		СчетКт = ПланыСчетов.Управленческий.Касса;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОпераций.ВозвратКонтрагентуСОперационнойКассы Тогда //Расход
		
		СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
		СчетКт = ПланыСчетов.Управленческий.ОперационнаяКасса;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОпераций.ВозвратОтПодотчетногоЛица Тогда //Приход
		
		СчетДт = ПланыСчетов.Управленческий.Касса;
		СчетКт = ПланыСчетов.Управленческий.Подотчет;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОпераций.БезналичныйРасчетПокупателя Тогда //Приход
		
		СчетДт = ПланыСчетов.Управленческий.РасчетныйСчет;
		СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОпераций.ВыдачаПодотчетномуЛицу Тогда //Расход
		
		СчетДт = ПланыСчетов.Управленческий.Подотчет;
		СчетКт = ПланыСчетов.Управленческий.Касса;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОпераций.ВыплатаЗаработнойПлатыРаботнику Тогда  //Расход
		
		СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
		СчетКт = ПланыСчетов.Управленческий.Касса;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОпераций.ПрочийПриход ИЛИ
		ВидОперации = Перечисления.ВидыОпераций.ПрочийРасход Тогда //Приход - Расход
		
		СчетДт = ПланыСчетов.Управленческий.ПустаяСсылка();
		СчетКт = ПланыСчетов.Управленческий.ПустаяСсылка();
		
	КонецЕсли;
	
	СтруктураСчетов = Новый Структура;
	СтруктураСчетов.Вставить("СчетДт", СчетДт);
	СтруктураСчетов.Вставить("СчетКт", СчетКт);
	
	Возврат СтруктураСчетов;
	
КонецФункции

// Возвращает остаток по выбранному счету и субконто.
// 
// Параметры:
//  Счет
//  Субконто1
//  Измерение - Подразделение
//
// Возвращаемое значение:
//  Остаток - сумма остатка.
//
Функция ПолучитьОстатокПоСчету(Счет, Субконто1, Измерение) Экспорт
	
	ТЗОстаток = РегистрыБухгалтерии.Управленческий.Остатки( , , Новый Структура("Счет, Субконто1, Подразделение", Счет, Субконто1, Измерение));
	Если ТЗОстаток.Количество() = 1 Тогда
		Остаток = ТЗОстаток[0].СуммаОстатокКт;
	КонецЕсли;
	
	Возврат Остаток;	
	
КонецФункции

Процедура ПроведениеДенежныхСредств(Ссылка, Движения) Экспорт
	
	Движения.Управленческий.Записывать = Истина;
	
	Движение = Движения.Управленческий.Добавить();
	Движение.Период = Ссылка.Дата;
	Движение.СчетДт = Ссылка.СчетДт;
	Движение.СчетКт = Ссылка.СчетКт;
	Движение.Подразделение = Ссылка.Подразделение;
	
	Для Каждого Элемент Из Ссылка.СчетДт.ВидыСубконто Цикл
		Движение.СубконтоДт[Элемент.ВидСубконто] = Ссылка["Субконто" +Элемент.НомерСтроки+ "Дт"];
	КонецЦикла;
	
	Для Каждого Элемент Из Ссылка.СчетКт.ВидыСубконто Цикл
		
		СубконтоКт = Ссылка["Субконто" +Элемент.НомерСтроки+ "Кт"];
		
		// По пустой спецификации платеж не принимаем.
		// Обязательно скидываем как аванс в счёт будущих спецификаций.
		
		Если СубконтоКт = Документы.Спецификация.ПустаяСсылка() Тогда
			СубконтоКт = Неопределено;
		КонецЕсли;
		
		Движение.СубконтоКт[Элемент.ВидСубконто] = СубконтоКт;
		
	КонецЦикла;
	
	Движение.Сумма = Ссылка.СуммаДокумента;
	Движение.Содержание = Ссылка.Комментарий;
	
КонецПроцедуры
