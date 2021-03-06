﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
		
	Спецификация = ПараметрКоманды; 
	СтатусИзменен = ПередатьНаРасчет(Спецификация);
	
	Если СтатусИзменен И ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Документ.Спецификация.Форма.ФормаДокумента" Тогда
		ОповеститьОбИзменении(Спецификация);
		Оповестить("ИзмененСтатусСпецификации", Спецификация);
		ПараметрыВыполненияКоманды.Источник.Прочитать();	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПередатьНаРасчет(СпецификацияСсылка)
	
	СтатусИзменен = Ложь;
	
	Если СпецификацияСсылка.Дилерский Тогда
	
		ТекущийСтатус = Документы.Спецификация.ПолучитьСтатусСпецификации(СпецификацияСсылка);
		
		Если ТекущийСтатус = Перечисления.СтатусыСпецификации.Сохранен Тогда	
			
			Если СпецификацияСсылка.Изделие.ЭтоДетали Тогда
				
				Сообщить("Изделие ""Детали"" нельзя передать на расчет инженеру.");
				
			Иначе
				
				ЕстьДоговор = ПолучитьДоговорДилера(СпецификацияСсылка);
				
				Если ЕстьДоговор Тогда
				
					Документы.Спецификация.УстановитьСтатусСпецификации(СпецификацияСсылка, Перечисления.СтатусыСпецификации.Рассчитывается);
					СтатусИзменен = Истина;
				Иначе	
					
					Сообщить("Для передачи спецификации на расчет заполните договор дилера.");
					
				КонецЕсли;
		
			КонецЕсли;
		Иначе
			Сообщить("На расчет передаются только спецификации со статусом ""Сохранен""");
		КонецЕсли;
		
	Иначе
		Сообщить("Спецификация отправляется на расчет при проведении договора.");
	КонецЕсли;
	
	Возврат СтатусИзменен;
	
КонецФункции

&НаСервере
Функция ПолучитьДоговорДилера(Спец)
	
	ЕстьДоговор = Ложь;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Спецификация", Спец);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДоговорДилера.Ссылка
	|ИЗ
	|	Документ.ДоговорДилера КАК ДоговорДилера
	|ГДЕ
	|	ДоговорДилера.Спецификация = &Спецификация
	|	И ДоговорДилера.Проведен";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		ЕстьДоговор = Истина;
		
	КонецЕсли;
	
	Возврат ЕстьДоговор;
	
КонецФункции
