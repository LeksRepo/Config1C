﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Список.Параметры.УстановитьЗначениеПараметра("Сообщение", Параметры.Сообщение);
	Список.Параметры.УстановитьЗначениеПараметра("Подразделение", Параметры.Сообщение.Подразделение);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииЯчейки(Элемент)
	Элементы.Список.ВыделенныеСтроки.Очистить();
КонецПроцедуры
