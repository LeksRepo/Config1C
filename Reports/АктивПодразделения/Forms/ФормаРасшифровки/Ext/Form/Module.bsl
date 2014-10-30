﻿Перем СуммаНач,СуммаКон,СуммаДт,СуммаКт;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Счет=Параметры.Счет;
	Подразделение=Параметры.Подразделение;
	НачалоПериода=Параметры.НачалоПериода;
	КонецПериода=Параметры.КонецПериода;
	
КонецПроцедуры

&НаСервере
Функция СформироватьТабличныйДокумент()
	
	СуммаНач = 0;
	СуммаКон = 0;
	СуммаДт = 0;
	СуммаКт = 0;
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ОриентацияСтраницы=ОриентацияСтраницы.Ландшафт;
	ТабДок.Защита = Истина;
	
	Макет = Отчеты.АктивПодразделения.ПолучитьМакет("МакетАктивРасшифровка");
	
	ОблШапка = Макет.ПолучитьОбласть("Шапка");
	ОблШапка.АвтоМасштаб = Истина;
	ОблСтрока = Макет.ПолучитьОбласть("Строка");
	ОблСтрока2 = Макет.ПолучитьОбласть("Строка");
	ОблПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ВидСубконто = "";
	
	Для каждого Вид Из Счет.ВидыСубконто Цикл
		ВидСубконто=ВидСубконто+Вид.ВидСубконто+Символы.ПС;
	КонецЦикла; 
	
	ОблШапка.Параметры.ПредставлениеПериода = Формат(НачалоПериода, "ДЛФ=DD")+" - "+Формат(КонецПериода, "ДЛФ=DD");
	ОблШапка.Параметры.Подразделение = Подразделение;
	ОблШапка.Параметры.Счет = Счет;
	ОблШапка.Параметры.Субконто = ВидСубконто;
	ТабДок.Вывести(ОблШапка);
	
	Запрос = Новый Запрос;   Сообщить(Счет);
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстаткиИОбороты.СуммаНачальныйОстаток КАК СуммаНачальныйОстаток,
	|	УправленческийОстаткиИОбороты.СуммаКонечныйОстаток КАК СуммаКонечныйОстаток,
	|	УправленческийОстаткиИОбороты.СуммаОборотДт КАК СуммаОборотДт,
	|	УправленческийОстаткиИОбороты.СуммаОборотКт КАК СуммаОборотКт,
	|	ВЫБОР
	|		КОГДА &Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ДенежныеСредства))
	|			ТОГДА УправленческийОстаткиИОбороты.Субконто2
	|		ИНАЧЕ УправленческийОстаткиИОбороты.Субконто1
	|	КОНЕЦ КАК Субконто,
	|	ВЫБОР
	|		КОГДА &Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ДенежныеСредства))
	|		ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ТипСубконто
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.ОстаткиИОбороты(&НачалоПериода, &КонецПериода, , , Счет В ИЕРАРХИИ (&Счет), , Подразделение В (&Подразделение)) КАК УправленческийОстаткиИОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Субконто
	|ИТОГИ
	|	СУММА(СуммаНачальныйОстаток),
	|	СУММА(СуммаКонечныйОстаток),
	|	СУММА(СуммаОборотДт),
	|	СУММА(СуммаОборотКт)
	|ПО
	|	Субконто";
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	
	ТабДок.НачатьАвтоГруппировкуСтрок();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоГруппировке Тогда
			
		   ТипСубконто = Выборка.ТипСубконто;	
		   Сообщить(Выборка.ТипСубконто);
		   
		   СуммаНач = СуммаНач + Выборка.СуммаНачальныйОстаток;
		   СуммаКон = СуммаКон + Выборка.СуммаКонечныйОстаток;
		   СуммаДт = СуммаДт + Выборка.СуммаОборотДт;
		   СуммаКт = СуммаКт + Выборка.СуммаОборотКт;
		   
		   Если ЗначениеЗаполнено(Выборка.Субконто) Тогда
    		   СубКон = Выборка.Субконто;
    	   Иначе
    		   СубКон = "<...>";
    	   КонецЕсли;
    	   
    	   Если НЕ (Выборка.СуммаОборотДт = 0 И Выборка.СуммаОборотКт = 0) Тогда
    		   ОблСтрока.Параметры.РасПарам = Выборка.Субконто;
    	   Иначе
    		   ОблСтрока.Параметры.РасПарам = Неопределено;
    	   КонецЕсли; 
   
    	   ОблСтрока.Параметры.Субконто = СубКон;
    	   ОблСтрока.Параметры.НачальныйОстаток = Выборка.СуммаНачальныйОстаток;
    	   ОблСтрока.Параметры.Приход = Выборка.СуммаОборотДт;
    	   ОблСтрока.Параметры.Расход = Выборка.СуммаОборотКт;
    	   ОблСтрока.Параметры.КонечныйОстаток = Выборка.СуммаКонечныйОстаток;
		   
		   ТабДок.Вывести(ОблСтрока,0);
		  
		КонецЕсли;    

	 КонецЦикла;
	  
	 ТабДок.ЗакончитьАвтогруппировкуСтрок();  
	 
	 ОблПодвал.Параметры.НачальныйОстаток = Формат(СуммаНач, "ЧДЦ=2");
	 ОблПодвал.Параметры.Приход = Формат(СуммаДт, "ЧДЦ=2");
	 ОблПодвал.Параметры.Расход = Формат(СуммаКт, "ЧДЦ=2");
	 ОблПодвал.Параметры.КонечныйОстаток = Формат(СуммаКон, "ЧДЦ=2");
	 ТабДок.Вывести(ОблПодвал);

	Возврат ТабДок;	
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТабличныйДокумент = СформироватьТабличныйДокумент();
КонецПроцедуры

&НаКлиенте
Процедура ТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	ПараметрыРасшифровки = Новый Структура();
	ПараметрыРасшифровки.Вставить("Субконто",Расшифровка);
	ПараметрыРасшифровки.Вставить("ТипСубконто",ТипСубконто);
	ПараметрыРасшифровки.Вставить("Счет",Счет);
	ПараметрыРасшифровки.Вставить("Подразделение",Подразделение);
	ПараметрыРасшифровки.Вставить("НачалоПериода",НачалоПериода);
	ПараметрыРасшифровки.Вставить("КонецПериода",КонецПериода);
	
	
	ОткрытьФорму("Отчет.АктивПодразделения.Форма.ФормаРасшифровкиДокумент", ПараметрыРасшифровки, ЭтаФорма);
	
КонецПроцедуры


