﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Спецификация = ПараметрКоманды; 
	СтатусИзменен = ПередатьНаОжидание(Спецификация);
	
	Если СтатусИзменен И ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Документ.Спецификация.Форма.ФормаДокумента" Тогда
		ОповеститьОбИзменении(Спецификация);
		Оповестить("ИзмененСтатусСпецификации", Спецификация);
		ПараметрыВыполненияКоманды.Источник.Прочитать();	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПередатьНаОжидание(СпецификацияСсылка)
	
	СтатусИзменен = Ложь;
	
	ТекущийСтатус = Документы.Спецификация.ПолучитьСтатусСпецификации(СпецификацияСсылка);
	
	Если ТекущийСтатус = Перечисления.СтатусыСпецификации.Рассчитывается Тогда	
		Документы.Спецификация.УстановитьСтатусСпецификации(СпецификацияСсылка, Перечисления.СтатусыСпецификации.ОжиданиеМатериала);
		СтатусИзменен = Истина;
	Иначе
		Сообщить("На ожидание материала передаются только спецификации со статусом ""Рассчитывается""");
	КонецЕсли;
	
	Возврат СтатусИзменен;
	
КонецФункции
