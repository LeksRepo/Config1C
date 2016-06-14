﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Для каждого Строка Из СписокНоменклатуры Цикл
		
		Движение = Движения.ЦеныНоменклатурыПоПодразделениям.Добавить();
		Движение.Период = Дата;
		Движение.Подразделение = Подразделение;
		ЗаполнитьЗначенияСвойств(Движение, Строка);
		
	КонецЦикла;
	
	ЗаполнитьНоменклатуруПодразделений();
	
КонецПроцедуры

Процедура ЗаполнитьНоменклатуруПодразделений()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("тз", СписокНоменклатуры.Выгрузить());
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(тзСписокНоменклатуры.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	тзСписокНоменклатуры.ПодЗаказ,
	|	тзСписокНоменклатуры.ОкруглятьДоЛистов
	|ПОМЕСТИТЬ втСписокНоменклатуры
	|ИЗ
	|	&тз КАК тзСписокНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Список.Номенклатура КАК Номенклатура,
	|	Список.ПодЗаказ КАК ПодЗаказ,
	|	Список.ОкруглятьДоЛистов КАК ОкруглятьДоЛистов,
	|	ЕСТЬNULL(НомПодр.ЗакупОптом, ЛОЖЬ) КАК ЗакупОптом,
	|	ЕСТЬNULL(НомПодр.ДнейНаИзготовление, 0) КАК ДнейНаИзготовление,
	|	ЕСТЬNULL(НомПодр.МожетПредоставитьЗаказчик, ЛОЖЬ) КАК МожетПредоставитьЗаказчик,
	|	НомПодр.АдресХранения КАК АдресХранения,
	|	НомПодр.ОсновнаяПоСкладу КАК ОсновнаяПоСкладу
	|ИЗ
	|	втСписокНоменклатуры КАК Список
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений.СрезПоследних(, Подразделение = &Подразделение) КАК НомПодр
	|		ПО Список.Номенклатура = НомПодр.Номенклатура";
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	Движения.НоменклатураПодразделений.Записывать = Истина;
	
	Для каждого Строка Из ТЗ Цикл
		
		Если Строка.Номенклатура.Базовый Тогда
		
			Движение = Движения.НоменклатураПодразделений.Добавить();
			Движение.Период = Дата;
			Движение.Подразделение = Подразделение;
			ЗаполнитьЗначенияСвойств(Движение, Строка);
			
		Иначе
			
			Сообщить("Позиция не записана: "+Строка.НомерСтроки+". "+Строка.Номенклатура+". Номенклатура не базовая.");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеМатериаловУслуг") Тогда
		
		Док = ДанныеЗаполнения;
		Подразделение = Док.Подразделение; 
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("тз", Док.Материалы.Выгрузить());
		Запрос.УстановитьПараметр("Подразделение", Док.Подразделение);
		Запрос.УстановитьПараметр("Контрагент", Док.Контрагент);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(тзСписокНоменклатуры.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
		|	тзСписокНоменклатуры.Цена КАК Цена
		|ПОМЕСТИТЬ втСписокНоменклатуры
		|ИЗ
		|	&тз КАК тзСписокНоменклатуры
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА Список.Номенклатура.Базовый
		|			ТОГДА Список.Номенклатура
		|		ИНАЧЕ Список.Номенклатура.БазоваяНоменклатура
		|	КОНЕЦ КАК Номенклатура,
		|	ВЫБОР
		|		КОГДА Список.Номенклатура.Базовый
		|			ТОГДА Список.Цена
		|		ИНАЧЕ Список.Цена / Список.Номенклатура.КоэффициентБазовых
		|	КОНЕЦ КАК Цена,
		|	ЕСТЬNULL(НомПодр.ПодЗаказ, ИСТИНА) КАК ПодЗаказ,
		|	ЕСТЬNULL(НомПодр.ОкруглятьДоЛистов, ИСТИНА) КАК ОкруглятьДоЛистов,
		|	&Контрагент КАК Поставщик
		|ИЗ
		|	втСписокНоменклатуры КАК Список
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений.СрезПоследних(, Подразделение = &Подразделение) КАК НомПодр
		|		ПО (Список.Номенклатура = НомПодр.Номенклатура
		|				ИЛИ Список.Номенклатура.БазоваяНоменклатура = НомПодр.Номенклатура)"; 
		
		ТЗ = Запрос.Выполнить().Выгрузить();
		
		Для Каждого Стр ИЗ ТЗ Цикл
			
			НоваяСтрока = СписокНоменклатуры.Добавить();
			НоваяСтрока.Номенклатура = Стр.Номенклатура;
			НоваяСтрока.ПлановаяЗакупочная = Стр.Цена;
			НоваяСтрока.ПодЗаказ = Стр.ПодЗаказ;
			НоваяСтрока.ОкруглятьДоЛистов = Стр.ОкруглятьДоЛистов;
			НоваяСтрока.Поставщик = Стр.Поставщик;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры
