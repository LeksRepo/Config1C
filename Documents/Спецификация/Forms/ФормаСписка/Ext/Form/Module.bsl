﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоДилер = РольДоступна("ДилерскийДоступКСпецификации");
	
	Если ЭтоДилер Тогда
		
		Элементы.ДатаИзготовления.Видимость = Ложь;
		Элементы.Контрагент.Видимость = Ложь;
		Элементы.Подразделение.Видимость = Ложь;
		Элементы.Автор.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

