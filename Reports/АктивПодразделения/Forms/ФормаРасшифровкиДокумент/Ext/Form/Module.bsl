﻿Перем СуммаНач,СуммаКон,СуммаДт,СуммаКт;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СЗСубконто = Параметры.СЗСубконто;
	Счет = Параметры.Счет;
	Подразделение = Параметры.Подразделение;
	НачалоПериода = Параметры.НачалоПериода;
	КонецПериода = Параметры.КонецПериода;
	
КонецПроцедуры

&НаСервере
Функция СформироватьТабличныйДокумент()
	
	СуммаНач = 0;
	СуммаКон = 0;
	СуммаДт = 0;
	СуммаКт = 0;
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДок.Защита = Истина;
	
	Макет = Отчеты.АктивПодразделения.ПолучитьМакет("МакетАктивРасшифровкаДокумент");
	
	ОблШапка = Макет.ПолучитьОбласть("Шапка");
	ОблСтрока = Макет.ПолучитьОбласть("Строка");
	ОблСтрока2 = Макет.ПолучитьОбласть("Строка2");
	ОблПодвал = Макет.ПолучитьОбласть("Подвал");
		
	ОблШапка.Параметры.ПредставлениеПериода = Формат(НачалоПериода, "ДЛФ=DD")+" - "+Формат(КонецПериода, "ДЛФ=DD");
	ОблШапка.Параметры.Подразделение = Подразделение;
	ОблШапка.Параметры.Счет = Счет;
	ТабДок.Вывести(ОблШапка);
	
	Запрос = Новый Запрос;
	
	Если ЗначениеЗаполнено(СЗСубконто[0].Значение) Тогда	
		Запрос.УстановитьПараметр("СубКон1", СЗСубконто[0].Значение);
	КонецЕсли; 
	Если ЗначениеЗаполнено(СЗСубконто[1].Значение) Тогда	
		Запрос.УстановитьПараметр("СубКон2", СЗСубконто[1].Значение);
	КонецЕсли; 
	
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОбороты.СуммаОборотДт КАК СуммаОборотДт,
	|	УправленческийОбороты.СуммаОборотКт КАК СуммаОборотКт,
	|	УправленческийОбороты.Субконто1 КАК Субконто1,
	|	УправленческийОбороты.Субконто2 КАК Субконто2,
	|	УправленческийОбороты.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Регистратор,
	|			Счет В ИЕРАРХИИ (&Счет),
	|			,
	|			Подразделение В (&Подразделение)";
	
	Если ЗначениеЗаполнено(СЗСубконто[0].Значение) Тогда
	Запрос.Текст = Запрос.Текст + "	
	|			И Субконто1 В ИЕРАРХИИ (&СубКон1)";		
	КонецЕсли;

	Если ЗначениеЗаполнено(СЗСубконто[1].Значение) Тогда
	Запрос.Текст = Запрос.Текст + "	
	|			И Субконто2 В ИЕРАРХИИ (&СубКон2)";		
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + "
	|			,
	|			,
	|			) КАК УправленческийОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Субконто1";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Сч = 0;
	
	Пока Выборка.Следующий() Цикл
		  
		  СуммаДт = СуммаДт + Выборка.СуммаОборотДт;
		  СуммаКт = СуммаКт + Выборка.СуммаОборотКт;
		
		  Если Сч%2 = 0 Тогда
		  	Область = ОблСтрока;
		  Иначе
			Область = ОблСтрока2;
		  КонецЕсли; 
		  
		   Область.Параметры.Регистратор = Выборка.Регистратор;
		   Область.Параметры.Приход = Выборка.СуммаОборотДт;
		   Область.Параметры.Расход = Выборка.СуммаОборотКт;

		   ТабДок.Вывести(Область);
		   
		   Сч = Сч + 1;
	КонецЦикла;
	
	 ОблПодвал.Параметры.Приход = Формат(СуммаДт, "ЧДЦ=2");
	 ОблПодвал.Параметры.Расход = Формат(СуммаКт, "ЧДЦ=2");
	 ТабДок.Вывести(ОблПодвал);
	 	
	Возврат ТабДок;	
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТабличныйДокумент = СформироватьТабличныйДокумент();
КонецПроцедуры

&НаКлиенте
Процедура ТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры


