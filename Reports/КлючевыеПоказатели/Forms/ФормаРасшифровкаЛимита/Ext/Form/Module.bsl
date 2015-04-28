﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачалоПериода = Параметры.НачалоПериода;
	КонецПериода = Параметры.КонецПериода;
	Подразделения = Параметры.Подразделения;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьОтчет();
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчет()
	
	ТабДок.Очистить();
	
	Макет = Отчеты.КлючевыеПоказатели.ПолучитьМакет("МакетРасшифровкаЛимита");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьСтрока2 = Макет.ПолучитьОбласть("Строка2");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ОбластьЗаголовок.Параметры.Период = Формат(НачалоПериода,"ДФ=dd.MM.yy")+" - "+Формат(КонецПериода,"ДФ=dd.MM.yy");
	ОбластьЗаголовок.Параметры.Подразделения = ПолучитьСписокСтрокой(Подразделения);
	
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапка);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("Подразделения", Подразделения);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ЦеховойЛимитОбороты.СтоимостьУслугОборот,0) КАК Лимит,
	|	ЕСТЬNULL(ЦеховойЛимитОбороты.СтоимостьУслугФактОборот,0) КАК Наряд,
	|	ЦеховойЛимитОбороты.Период КАК Период
	|ИЗ
	|	РегистрНакопления.ЦеховойЛимит.Обороты(&НачалоПериода, &КонецПериода, День, Подразделение В (&Подразделения)) КАК ЦеховойЛимитОбороты
	|УПОРЯДОЧИТЬ ПО
	|	Период
	|ИТОГИ
	|   СУММА(Лимит),
	|	СУММА(Наряд)
	|ПО
	|    Период ПЕРИОДАМИ(ДЕНЬ, &НачалоПериода, &КонецПериода);";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Период" ,"ВСЕ");
	
	СуммаЛимит = 0;
	СуммаНаряд = 0;
	СуммаДней = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Лимит = Выборка.Лимит;
		Наряд = Выборка.Наряд;

		Если НЕ ЗначениеЗаполнено(Лимит) Тогда
			Лимит = 0;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Наряд) Тогда
			 Наряд = 0;
		КонецЕсли;

		Если Лимит > 0 Тогда
		
			ОбластьСтрока.Параметры.Дата = Формат(Выборка.Период,"ДФ=dd.MM.yy");
			ОбластьСтрока.Параметры.Норматив = Лимит;
			ОбластьСтрока.Параметры.Наряд = Наряд;
			ТабДок.Вывести(ОбластьСтрока);
					
		Иначе
			
			ОбластьСтрока2.Параметры.Дата = Формат(Выборка.Период,"ДФ=dd.MM.yy");
			ОбластьСтрока.Параметры.Наряд = Наряд;
			ТабДок.Вывести(ОбластьСтрока2);
			
		КонецЕсли;
		
		Если Лимит > 0 Тогда
			СуммаДней = СуммаДней + 1;	
		КонецЕсли;
		
		СуммаЛимит = СуммаЛимит + Лимит;
		СуммаНаряд = СуммаНаряд + Наряд;
		
	КонецЦикла;
	
	Если СуммаДней > 0 Тогда
	
		ОбластьПодвал.Параметры.НормативСреднее = Окр(СуммаЛимит / СуммаДней);
		ОбластьПодвал.Параметры.НарядСреднее = Окр(СуммаНаряд / СуммаДней);
		ТабДок.Вывести(ОбластьПодвал);
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьСписокСтрокой(СписокЗначений)
	
	Результат = "";
	
	Для каждого Элем Из СписокЗначений Цикл
		
		Результат = Результат + Элем.Значение + ";";
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции
