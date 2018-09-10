﻿
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЭтоГруппа Тогда
		
		Если (НоменклатурнаяГруппа.ВидМатериала = Перечисления.ВидыМатериалов.Листовой) И (ДлинаБезТорцовки = 0 ИЛИ ШиринаБезТорцовки = 0) Тогда
			 Отказ = Истина;
			 ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните параметры листа ""Длина без торцовки"" и ""Ширина без торцовки"".");
		КонецЕсли;
		
		Если НЕ Базовый И НоменклатурнаяГруппа <> БазоваяНоменклатура.НоменклатурнаяГруппа Тогда
			 НоменклатурнаяГруппа = БазоваяНоменклатура.НоменклатурнаяГруппа; 	
		КонецЕсли;
		
		Если ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Услуга Тогда
			Базовый = Истина;
		КонецЕсли;
	
		Если Базовый Тогда
			БазоваяНоменклатура = Справочники.Номенклатура.ПустаяСсылка();
			КоэффициентБазовых = 1;
		КонецЕсли;
		
		ЕстьОписаниеСостава = ОписаниеСостава.Количество() > 0;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Ошибки = Неопределено;
	
	Если ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Материал
		И НЕ ЗначениеЗаполнено(МестоОбработки) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.МестоОбработки", "Укажите способ передачи");
	КонецЕсли;
	
	Если ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Материал
		И НЕ Базовый
		И БазоваяНоменклатура.Пустая() Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.БазоваяНоменклатура", "Заполните базовую номенклатуру");
		
	КонецЕсли;
	
	Если НЕ Базовый И НЕ БазоваяНоменклатура.Базовый Тогда
		
		ТекстОшибки = "Номенклатура '%1' не является базовой";
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, БазоваяНоменклатура);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, ЭтотОбъект, ТекстОшибки);
		
	КонецЕсли;
	
	Если НоменклатурнаяГруппа.ВидМатериала = Перечисления.ВидыМатериалов.Хлыстовой
		И НЕ ЗначениеЗаполнено(Кратность)
		И НЕ ЗначениеЗаполнено(ПроцентОтхода) Тогда
		
		ТекстОшибки = "Для хлыстового материала укажите 'Кратность' или 'Процент отхода'";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Кратность", ТекстОшибки);
		
	КонецЕсли;
	
	Если НоменклатурнаяГруппа.ВидМатериала <> Перечисления.ВидыМатериалов.Штучный
		И Кратность > 0
		И ДлинаДетали % (Кратность * 1000) > 0 Тогда
		
		ТекстОшибки = "Деталь не делится ровно на 'Кратность', остаток от деления: " + ДлинаДетали % (Кратность * 1000);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Кратность", ТекстОшибки);
		
	КонецЕсли;
	
	Если ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Услуга Тогда
		
		РазрешенныеНоменклатурныеГруппы = Новый Массив;
		РазрешенныеНоменклатурныеГруппы.Добавить(Справочники.НоменклатурныеГруппы.Услуга);
		РазрешенныеНоменклатурныеГруппы.Добавить(Справочники.НоменклатурныеГруппы.Гравировка);
		РазрешенныеНоменклатурныеГруппы.Добавить(Справочники.НоменклатурныеГруппы.Фотопечать);
		
		НоменклатурнаяГруппаКорректна = РазрешенныеНоменклатурныеГруппы.Найти(НоменклатурнаяГруппа) <> Неопределено;
		
		Если НЕ НоменклатурнаяГруппаКорректна Тогда
			ТекстОшибки = "Укажите корректную номенклатурную группу";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.НоменклатурнаяГруппа", ТекстОшибки);
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры
