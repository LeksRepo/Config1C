﻿
&НаКлиенте
Процедура СписокПлатежейСчетУчетаПриИзменении(Элемент)
	
	УстановитьДоступностьПолейТЧ();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьПолейТЧ() 
	
	Данные = Элементы.СписокПлатежей.ТекущиеДанные;
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Данные.СчетУчета);
	Данные.Количественный = ДанныеСчета.Количественный;
	Элементы.СписокПлатежейКоличество.ТолькоПросмотр = НЕ Данные.Количественный;
	
	Для Индекс = 1 По 3 Цикл
		
		Если ЗначениеЗаполнено(ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"]) Тогда
			Данные["Субконто" + Индекс] = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"].ПривестиЗначение(Данные["Субконто" + Индекс]);
			Элементы["СписокПлатежейСубконто" + Индекс].ОграничениеТипа = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
			Элементы["СписокПлатежейСубконто" + Индекс].ТолькоПросмотр = Ложь;
			
			// { Васильев Александр Леонидович [11.09.2014]
			// Для статей доходов и расходов установим фильтр по Активности.
			НовыйПараметр = Новый ПараметрВыбора("Отбор.Активность", Истина);
			НовыйМассив = Новый Массив();
			НовыйМассив.Добавить(НовыйПараметр);
			НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
			Элементы["СписокПлатежейСубконто" + Индекс].ПараметрыВыбора = НовыеПараметры; 
			// } Васильев Александр Леонидович [11.09.2014]
			
		Иначе
			
			Элементы["СписокПлатежейСубконто" + Индекс].ТолькоПросмотр = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПлатежейПриАктивизацииСтроки(Элемент)
	
	Если Объект.СписокПлатежей.Количество() > 0 Тогда
		УстановитьДоступностьПолейТЧ();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПлатежейКоличествоЦенаПриИзменении(Элемент)
	
	Данные = Элементы.СписокПлатежей.ТекущиеДанные;
	КоличествоЦенаПриИзменении(Данные);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПлатежейСуммаПриИзменении(Элемент)
	
	Данные = Элементы.СписокПлатежей.ТекущиеДанные;
	СуммаПриИзменении(Данные);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЦенаПриИзменении(Данные)
	
	Если Данные.Количество = 0 Тогда
		Данные.Сумма = Данные.Цена;
	Иначе
		Данные.Сумма = Данные.Количество * Данные.Цена;
	КонецЕсли;
	
	Объект.СуммаДокумента = Объект.СписокНоменклатуры.Итог("Сумма") + Объект.СписокПлатежей.Итог("Сумма");
		
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Данные)
	
	Если Данные.Количество = 0 Тогда
		Данные.Цена = Данные.Сумма;
	Иначе
		Данные.Цена = Окр(Данные.Сумма / Данные.Количество, 2);
	КонецЕсли;
	Объект.СуммаДокумента = Объект.СписокНоменклатуры.Итог("Сумма") + Объект.СписокПлатежей.Итог("Сумма");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыКоличествоЦенаПриИзменении(Элемент)
	
	Данные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	КоличествоЦенаПриИзменении(Данные);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыСуммаПриИзменении(Элемент)
	
	Данные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	СуммаПриИзменении(Данные);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеНажатие(Элемент, СтандартнаяОбработка)
	
	ОткрытьЗначение(Объект.ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьБазовую();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьБазовую()
	
	Таблица = Объект.СписокНоменклатуры;
	
	Для Каждого Стр ИЗ Таблица Цикл
		Стр.Базовая = Стр.Номенклатура.Базовый;		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыНоменклатураПриИзменении(Элемент)
	ЗаполнитьБазовую();
КонецПроцедуры
