﻿
&НаКлиенте
Процедура ВыборНоменклатурыПередРазворачиванием(Элемент, Строка, Отказ)
	//Сообщить("ВыборНоменклатурыПередРазворачиванием");
	//Сообщить(Строка);
	//
	// ОбновитьСписокНоменклатуры(Строка);
	// 
	// ВыборНоменклатуры.ТекстЗапроса="	
	//|	ВЫБРАТЬ
	//|	Номенклатура.Наименование,
	//|	Номенклатура.ЕдиницаИзмерения
	//|ИЗ
	//|	Справочник.Номенклатура КАК Номенклатура
	//|ГДЕ
	//|	Номенклатура.Родитель.Наименование = "+Строка;
	// 
	// 
	// Элементы.ВыборНоменклатуры.Обновить();
	//Оповестить("ОбновитьТабличныеЧасти"); 
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокНоменклатуры(Строка)
	//Сообщить("ОбновитьСписокНоменклатуры");
	//ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("ТипНоменклатуры", Строка);
	
	//ВыборНоменклатуры.ТекстЗапроса="	
	//|	ВЫБРАТЬ
	//|	Номенклатура.Наименование,
	//|	Номенклатура.ЕдиницаИзмерения
	//|ИЗ
	//|	Справочник.Номенклатура КАК Номенклатура
	//|ГДЕ
	//|	Номенклатура.Родитель.Наименование = "+Строка;

КонецПроцедуры // ОбновитьСписокНоменклатуры()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	//Сообщить("ОбработкаОповещения");
	//Если ИмяСобытия = "ОбновитьТабличныеЧасти" тогда
	//	//ОповеститьОбИзменении(Параметр);
	//	Элементы.ВыборНоменклатуры.Обновить();

	//КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("ТипНоменклатуры", Справочники.Номенклатура.ПустаяСсылка());
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.КаталогНоменклатуры.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ГруппаНоменклатуры = ТекущиеДанные.Ссылка;
		ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("ТипНоменклатуры", ГруппаНоменклатуры);
	КонецЕсли;
	
КонецПроцедуры


