﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭлементОбщаяПроизводительность = ОценкаПроизводительностиСлужебный.ПолучитьЭлементОбщаяПроизводительностьСистемы();
	Если ЗначениеЗаполнено(ЭлементОбщаяПроизводительность) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ссылка", ЭлементОбщаяПроизводительность,
			ВидСравненияКомпоновкиДанных.НеРавно, , ,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
