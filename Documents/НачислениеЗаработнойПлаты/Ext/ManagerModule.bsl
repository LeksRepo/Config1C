﻿
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

Функция ПолучитьПоказателиДизайнера(ДатаНачала, ДатаОкончания, Дизайнер, Подразделение) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УправленческийОбороты.СуммаОборот КАК Сумма,
		|	УправленческийОбороты.Субконто2 КАК Дизайнер,
		|	УправленческийОбороты.Субконто1 КАК Показатель
		|ИЗ
		|	РегистрБухгалтерии.Управленческий.Обороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			,
		|			,
		|			,
		|			Подразделение = &Подразделение
		|				И Субконто2 = &Дизайнер
		|				И ТИПЗНАЧЕНИЯ(Субконто1) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников),
		|			,
		|			) КАК УправленческийОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПлановыеПоказателиДизайнеровОбороты.Дизайнер,
		|	ПлановыеПоказателиДизайнеровОбороты.Показатель КАК Показатель,
		|	ПлановыеПоказателиДизайнеровОбороты.ЗначениеОборот КАК Сумма
		|ИЗ
		|	РегистрНакопления.ПлановыеПоказателиДизайнеров.Обороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			,
		|			Дизайнер = &Дизайнер
		|				И Подразделение = &Подразделение) КАК ПлановыеПоказателиДизайнеровОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РеализованныеИзделияОбороты.ВидИзделия,
		|	РеализованныеИзделияОбороты.КоличествоОборот КАК КоличествоКухонь,
		|	NULL КАК КоличествоШкафов
		|ИЗ
		|	РегистрНакопления.РеализованныеИзделия.Обороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			,
		|			Дизайнер = &Дизайнер
		|				И Подразделение = &Подразделение
		|				И ВидИзделия = ЗНАЧЕНИЕ(Перечисление.ВидыИзделий.Кухня)) КАК РеализованныеИзделияОбороты
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	NULL,
		|	NULL,
		|	РеализованныеИзделияОбороты.КоличествоОборот
		|ИЗ
		|	РегистрНакопления.РеализованныеИзделия.Обороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			,
		|			Дизайнер = &Дизайнер
		|				И Подразделение = &Подразделение
		|				И ВидИзделия <> ЗНАЧЕНИЕ(Перечисление.ВидыИзделий.Кухня)) КАК РеализованныеИзделияОбороты";

	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Дизайнер", Дизайнер);

	МассивЗапросов = Запрос.ВыполнитьПакет();
	МассивВыборок = Новый Массив;
	
	ВыборкаФактическиеПоказатели = МассивЗапросов[0].Выбрать();
	ВыборкаПлановыеПоказатели = МассивЗапросов[1].Выбрать();
	ВыборкаПоВидамИзделий = МассивЗапросов[2].Выбрать();
	СтруктураПоказателей = Новый Структура;
	
	Пока ВыборкаФактическиеПоказатели.Следующий() Цикл
		
		Если ВыборкаФактическиеПоказатели.Показатель = Перечисления.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров Тогда
			
			СтруктураПоказателей.Вставить("КоличествоФактическиЗаключенныхДоговоров", ВыборкаФактическиеПоказатели.Сумма);
			
		ИначеЕсли ВыборкаФактическиеПоказатели.Показатель = Перечисления.ВидыПоказателейСотрудников.КоличествоЗамеров Тогда
			
			СтруктураПоказателей.Вставить("КоличествоФактическихЗамеров", ВыборкаФактическиеПоказатели.Сумма);
			
		ИначеЕсли ВыборкаФактическиеПоказатели.Показатель = Перечисления.ВидыПоказателейСотрудников.СтоимостьЗаключенныхДоговоров Тогда
			
			СтруктураПоказателей.Вставить("СтоимостьФактическиЗаключенныхДоговоров", ВыборкаФактическиеПоказатели.Сумма);
			
		ИначеЕсли ВыборкаФактическиеПоказатели.Показатель = Перечисления.ВидыПоказателейСотрудников.ВыручкаПоДоговорам Тогда
			
			СтруктураПоказателей.Вставить("ФактическаяВыручкаПоДоговорам", ВыборкаФактическиеПоказатели.Сумма);
			
		КонецЕсли;
			
	КонецЦикла;
	
	Пока ВыборкаПлановыеПоказатели.Следующий() Цикл
		
		Если ВыборкаФактическиеПоказатели.Показатель = Перечисления.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров Тогда
			
			СтруктураПоказателей.Вставить("КоличествоПлановыхЗаключенныхДоговоров", ВыборкаФактическиеПоказатели.Сумма);
			
		ИначеЕсли ВыборкаФактическиеПоказатели.Показатель = Перечисления.ВидыПоказателейСотрудников.КоличествоЗамеров Тогда
			
			СтруктураПоказателей.Вставить("КоличествоПлановыхЗамеров", ВыборкаФактическиеПоказатели.Сумма);
			
		ИначеЕсли ВыборкаФактическиеПоказатели.Показатель = Перечисления.ВидыПоказателейСотрудников.СтоимостьЗаключенныхДоговоров Тогда
			
			СтруктураПоказателей.Вставить("СтоимостьПлановоЗаключенныхДоговоров", ВыборкаФактическиеПоказатели.Сумма);
			
		ИначеЕсли ВыборкаФактическиеПоказатели.Показатель = Перечисления.ВидыПоказателейСотрудников.ВыручкаПоДоговорам Тогда
			
			СтруктураПоказателей.Вставить("ПлановаяВыручкаПоДоговорам", ВыборкаФактическиеПоказатели.Сумма);
			
		КонецЕсли;
			
	КонецЦикла;
	
	ВыборкаПоВидамИзделий.Следующий();
	СтруктураПоказателей.Вставить("КоличествоКухонь", ВыборкаПоВидамИзделий.КоличествоКухонь);
	СтруктураПоказателей.Вставить("КоличествоШкафов", ВыборкаПоВидамИзделий.КоличествоШкафов);
	
	Возврат СтруктураПоказателей;
	
КонецФункции