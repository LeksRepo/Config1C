﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	// { Васильев Александр Леонидович [30.05.2013]
		// Лёх, это зачем такой запрос?
	// } Васильев Александр Леонидович [30.05.2013]
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	УстановкаЦенНоменклатурыНоменклатура.Номенклатура,
	//|	УстановкаЦенНоменклатурыНоменклатура.Цена
	//|ПОМЕСТИТЬ ДокТЧ
	//|ИЗ
	//|	Документ.УстановкаЦенНоменклатуры.Номенклатура КАК УстановкаЦенНоменклатурыНоменклатура
	//|ГДЕ
	//|	УстановкаЦенНоменклатурыНоменклатура.Ссылка = &Ссылка
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ДокТЧ.Номенклатура,
	//|	ДокТЧ.Цена КАК Значение
	//|ИЗ
	//|	ДокТЧ КАК ДокТЧ
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	спрНоменклатура.Ссылка,
	//|	спрНоменклатура.КоэффициентБазовых * ДокТЧ.Цена
	//|ИЗ
	//|	Справочник.Номенклатура КАК спрНоменклатура
	//|		ЛЕВОЕ СОЕДИНЕНИЕ ДокТЧ КАК ДокТЧ
	//|		ПО (ДокТЧ.Номенклатура = спрНоменклатура.БазоваяНоменклатура)
	//|ГДЕ
	//|	спрНоменклатура.БазоваяНоменклатура В
	//|			(ВЫБРАТЬ
	//|				ДокТЧ.Номенклатура
	//|			ИЗ
	//|				ДокТЧ)";
	//
	//Запрос.УстановитьПараметр("Ссылка", Ссылка);
	//
	//Выборка = Запрос.Выполнить().Выбрать();
	
	Для каждого Строка Из СписокНоменклатуры Цикл
		
		Движение = Движения.ЦеныНоменклатуры.Добавить();
		Движение.Период = Дата;
		Движение.Регион = Регион;
		ЗаполнитьЗначенияСвойств(Движение, Строка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры
