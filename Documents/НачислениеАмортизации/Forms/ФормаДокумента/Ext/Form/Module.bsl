﻿
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Объект.Дата = КонецМесяца(Объект.Дата);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПодпискиНаСобытия.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры
