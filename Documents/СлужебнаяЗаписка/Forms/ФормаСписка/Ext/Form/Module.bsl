﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		Элементы.СтраницаSMART.Видимость = Ложь;
		Элементы.ВАрхив.Видимость = Ложь;

	КонецЕсли;
	
	Активные.Параметры.УстановитьЗначениеПараметра("Пользователь", ТПользователь);
	
КонецПроцедуры
