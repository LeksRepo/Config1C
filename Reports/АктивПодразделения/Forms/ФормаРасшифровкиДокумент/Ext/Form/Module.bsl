﻿Перем СуммаНач,СуммаКон,СуммаДт,СуммаКт;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Субконто = Параметры.Субконто;
	ТипСубконто = Параметры.ТипСубконто;
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
	
	ОблШапка.Параметры.Субконто = Субконто; 
	
	ТабДок.Вывести(ОблШапка);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("СубКон", Субконто);
	Запрос.УстановитьПараметр("ТипСубКон", ТипСубконто);
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОбороты.СуммаОборотДт КАК СуммаОборотДт,
	|	УправленческийОбороты.СуммаОборотКт КАК СуммаОборотКт,
	|	УправленческийОбороты.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Регистратор,
	|			Счет В ИЕРАРХИИ (&Счет),
	|			,
	|			Подразделение В (&Подразделение)
	|				И ВЫБОР
	|					КОГДА &ТипСубКон = 1
	|					ТОГДА Субконто1 В ИЕРАРХИИ (&СубКон)
	|					ИНАЧЕ Субконто2 В ИЕРАРХИИ (&СубКон)
	|				КОНЕЦ,
	|			,
	|			) КАК УправленческийОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор.Дата";
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
		   Область.Параметры.РасПарам = Выборка.Регистратор;  
		   
		  
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


