﻿
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", ТекущийОбъект.Номенклатура);
	Запрос.УстановитьПараметр("Подразделение", ТекущийОбъект.Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЦеныНоменклатурыСрезПоследних.Розничная
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(
	|			,
	|			Номенклатура = &Номенклатура
	|				И Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних";
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если ТекущийОбъект.Доступность Тогда		
		Если НЕ (Результат.Количество() > 0 И Результат[0].Розничная > 0) Тогда
		
			Сообщить("Сначала установите цену.");
			Отказ = Истина;
		Иначе
			
			Если НЕ ТекущийОбъект.ОкруглятьДоЛистов Тогда
			
				ТребоватьПроцентОтхода = ТекущийОбъект.Номенклатура.НоменклатурнаяГруппа.ТребоватьПроцентОтхода;
				Если ТребоватьПроцентОтхода И (ТекущийОбъект.ПроцентОтхода = 0) Тогда
					
					 Сообщить("Установите процент отхода или включите округление до листов.");
					 Отказ = Истина;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОповеститьОВыборе("Ping");
КонецПроцедуры
