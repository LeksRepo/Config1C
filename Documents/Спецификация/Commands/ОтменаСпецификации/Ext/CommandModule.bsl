﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//RonEXI:Пока задача отменена.
	//Если Вопрос("Вы уверены что хотите отменить спецификацию?", РежимДиалогаВопрос.ДаНет, 0) = КодВозвратаДиалога.Нет Тогда
	//	Возврат;
	//КонецЕсли;

	//Спецификация = ПараметрКоманды;
	//
	//УдалитьИзНаряда(Спецификация);
	//ОтменитьПроведениеИСтатус(Спецификация);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьИзНаряда(Ссылка)
	
	Статус = Документы.Спецификация.ПолучитьСтатусСпецификации(Ссылка);
	
	Если Статус = Перечисления.СтатусыСпецификации.ПереданВЦех Тогда
		Документы.НарядЗадание.УдалитьСпецификациюИзНаряда(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПроведениеИСтатус(Ссылка)
	
	Документы.Спецификация.УстановитьСтатусСпецификации(Ссылка, Перечисления.СтатусыСпецификации.Сохранен);
	
	Если Ссылка.Проведен Тогда
		
		Документ = Ссылка.ПолучитьОбъект();
		Документ.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		
	КонецЕсли;
	
КонецПроцедуры