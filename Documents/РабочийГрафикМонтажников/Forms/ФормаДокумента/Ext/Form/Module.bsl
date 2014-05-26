﻿
&НаКлиенте
Процедура ЗаполнитьТабель(Команда)
	
	ЗаполнитьТабельНаСервере();
	ОбновитьКоличествоМонтажей();
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьТабельНаСервере()

	Объект.Табель.Очистить();
	
	ДокОбъект = РеквизитФормыВЗначение("Объект");
	ДокОбъект.ЗаполнитьТабель(Объект.Дата);
	
	ЗначениеВРеквизитФормы(ДокОбъект, "Объект");
    
	
КонецФункции // ЗаполнитьТабель()

&НаКлиенте
Процедура ТабельПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабельПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаСервере
Функция ОбновитьКоличествоМонтажей()
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = "";
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода",НачалоМесяца(Объект.Дата) );
	Запрос.УстановитьПараметр("КонецПериода",КонецМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("Город",Объект.Город);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СвободныеМонтажникиОбороты.Период КАК Дата,
	|	СвободныеМонтажникиОбороты.КоличествоМонтажейОборот КАК КоличествоМонтажей
	|ИЗ
	|	РегистрНакопления.СвободныеМонтажники.Обороты(&НачалоПериода, &КонецПериода, День, Город = &Город) КАК СвободныеМонтажникиОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	СвободныеМонтажникиОбороты.Период
	|ИТОГИ
	|	СУММА(КоличествоМонтажей)
	|ПО
	|	Дата ПЕРИОДАМИ(ДЕНЬ, &НачалоПериода, &КонецПериода)";
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Дата", "ВСЕ");
	
	Для каждого Строка Из Объект.Табель Цикл
		
		Выборка.Следующий();
		
		Строка.КоличествоМонтажей = Выборка.КоличествоМонтажей; 
		
	КонецЦикла;
	
КонецФункции // ОбновитьСостояниеМонтажей()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	 ОбновитьКоличествоМонтажей();
	
КонецПроцедуры
