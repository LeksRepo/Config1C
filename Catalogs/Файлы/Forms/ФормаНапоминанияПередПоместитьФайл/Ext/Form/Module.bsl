﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	БольшеНеПоказывать = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьВыполнить(Команда)
	
	Если БольшеНеПоказывать = Истина Тогда
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьИОбновитьПовторноИспользуемыеЗначения("НастройкиПрограммы", "ПоказыватьПодсказкиПриРедактированииФайлов", Ложь);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
