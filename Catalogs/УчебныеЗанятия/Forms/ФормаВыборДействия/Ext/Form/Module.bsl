﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УчебноеЗанятие = Параметры.Тема;
	
КонецПроцедуры

&НаКлиенте
Процедура ПройтиТест(Команда)
	
	ЛексКлиент.ОбработкаКомандыПройтиТест(УчебноеЗанятие);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	ОткрытьЗначение(УчебноеЗанятие);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры
