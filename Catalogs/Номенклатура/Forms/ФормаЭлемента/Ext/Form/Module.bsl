﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Базовый", Объект.Базовый);
	СтруктураПараметров.Вставить("Комплект", Объект.ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Комплект);
	ОбновитьЭлементыФормы(ЭтаФорма, СтруктураПараметров);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОбновитьЭлементыФормы(лФорма, лПараметры)
	
	Если ТипЗнч(лПараметры) <> Тип("Структура") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Элементы = лФорма.Элементы;
	
	Если лПараметры.Свойство("Базовый") Тогда
		Элементы.ТехническиеХарактеристикиГруппа.Доступность = лПараметры.Базовый;
	КонецЕсли;
	
	Если лПараметры.Свойство("Комплект") Тогда
		Элементы.Состав.Доступность = лПараметры.Комплект;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура БазовыйПриИзменении(Элемент)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Базовый", Объект.Базовый);
	ОбновитьЭлементыФормы(ЭтаФорма, СтруктураПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Комплект", Объект.ВидНоменклатуры = ПредопределенноеЗначение("Перечисление.ВидыНоменклатуры.Комплект"));
	ОбновитьЭлементыФормы(ЭтаФорма, СтруктураПараметров);
	
КонецПроцедуры

