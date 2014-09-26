﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элемент=Параметры.ВыбранныйЭлементСсылка.Номенклатура;
	СсылкаНаЭлемент=Элемент;
	СсылкаКод = Элемент.Код;
	СсылкаЕдиницаИзмерения=Элемент.ЕдиницаИзмерения;
	СсылкаКратность=Элемент.Кратность;
	Наименование=Элемент.Наименование;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)	
	 ДобавитьЭлемент();
 КонецПроцедуры
 
 &НаКлиенте
 Процедура ДобавитьЭлемент()
	 
	ЭтаФорма.Закрыть();
	Если Количество<>0 Тогда
		Если СсылкаКратность<>0 Тогда
			Количество = СсылкаКратность*Цел(Количество/СсылкаКратность);	
		КонецЕсли; 
		ЭтаФорма.ВладелецФормы.ВыбранныеДобавитьЭлемент(Количество, СсылкаНаЭлемент, СсылкаЕдиницаИзмерения, СсылкаКратность, СсылкаКод);
	КонецЕсли;
 
 КонецПроцедуры 

&НаКлиенте
Процедура OK(Команда)
	ДобавитьЭлемент();
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры
