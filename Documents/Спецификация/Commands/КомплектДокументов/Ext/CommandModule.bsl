﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Для Каждого Документ Из ПараметрКоманды Цикл
		
		Массив = Новый Массив;
		Массив.Добавить(Документ);
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ФиксированныйКомплект", Ложь); 
		ПараметрыПечати.Вставить("ПереопределитьПользовательскиеНастройкиКоличества", Истина);
		
		Структура = ОпределитьМакеты(Документ);
		СписокМакетов = Структура.СписокМакетов;
		
		Если ЗначениеЗаполнено(Структура.СтрокаРаскроя) Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ХранимыйФайл", "НовыйРаскрой");
			ПараметрыФормы.Вставить("СтрокаНовогоРаскрояЛДСП", Структура.СтрокаРаскроя);
			ПараметрыФормы.Вставить("СохранитьРаскройВРисунок", Истина);
			
			Значение = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы);
			
		КонецЕсли;
		
		СтруктураПараметров = Новый Структура("МассивДокументов, СтрокаРаскроя", Массив, Значение);
		
		Если ЗначениеЗаполнено(СписокМакетов) Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Спецификация", СписокМакетов, СтруктураПараметров, ПараметрыВыполненияКоманды.Источник, ПараметрыПечати);
		Иначе
			Предупреждение("Документы на печать отсутствуют!");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры 

&НаСервере
Функция ОпределитьМакеты(Документ)
	
	СписокМакетов = "";
	СтрокаРаскроя = "";
	
	Если Документ.СписокМатериалы.Количество() > 0 или Документ.СписокЯщики.Количество() > 0 или Документ.СписокНоменклатуры.Количество() > 0 Тогда
		
		СписокМакетов = СписокМакетов + "АктГотовности,Спецификация";
		СтеклянныеФасады = Ложь;
		АлюминиевыеАГТФасады = Ложь;
		
		Для Каждого Элемент Из Документ.СписокМатериалы Цикл
			
			Если Элемент.Материал = "ФасадСтеклянныйЗакругленный" Тогда
				
				СтеклянныеФасады = Истина;
				
			КонецЕсли;
			
			Если Элемент.Материал = "ФасадАГТ" или Элемент.Материал = "ФасадАлюминиевый" Тогда
				
				АлюминиевыеАГТФасады = Истина;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если Документ.СписокИзделийПоКаталогу.Количество() > 0 Тогда
			
			Если Документ.СписокИзделийПоКаталогу[0].Изделие.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.КухняВерхний
				ИЛИ Документ.СписокИзделийПоКаталогу[0].Изделие.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.КухняНижний Тогда
				СписокМакетов = СписокМакетов + ?(ЗначениеЗаполнено(СписокМакетов), ",ИзделиеПоКаталогу", "ИзделиеПоКаталогу");
			Иначе
				СписокМакетов = СписокМакетов + ?(ЗначениеЗаполнено(СписокМакетов), ",ШкафПоКаталогу", "ШкафПоКаталогу");
			КонецЕсли;
			
		КонецЕсли;
		
		Если СтеклянныеФасады Тогда
			
			СписокМакетов = СписокМакетов + ",СтеклянныеФасады";
			
		КонецЕсли;
		
		Если АлюминиевыеАГТФасады Тогда
			
			СписокМакетов = СписокМакетов + ",Фасады";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Документ.Подразделение.БрендДилер Тогда
		
		СписокМакетов = СписокМакетов + ?(ЗначениеЗаполнено(СписокМакетов), ",ЗаказБрендДилера", "ЗаказБрендДилера");
		
	КонецЕсли;
	
	Если Документ.СписокДверей.Количество() > 0 Тогда
		
		СписокМакетов = СписокМакетов + ?(ЗначениеЗаполнено(СписокМакетов), ",Дверь", "Дверь");
		
	КонецЕсли;
		
	Если Документ.Упаковка Тогда
		
		СписокМакетов = СписокМакетов + ?(ЗначениеЗаполнено(СписокМакетов), ",УпаковочныйЛист", "УпаковочныйЛист");
		
	КонецЕсли;
		
	Дилер = УправлениеДоступомПереопределяемый.ЕстьДоступКПрофилюГруппДоступа(ПользователиКлиентСервер.ТекущийПользователь(), Справочники.ПрофилиГруппДоступа.Дилер);
	
	Если НЕ Дилер ИЛИ (Дилер И Документ.Проведен) Тогда
		
		СтрокаРаскроя = ОпределительРаскроя(Документ);
		
		Если ЗначениеЗаполнено(СтрокаРаскроя) Тогда
			СписокМакетов = СписокМакетов + ?(ЗначениеЗаполнено(СписокМакетов), ",Раскрой", "Раскрой");
		КонецЕсли;
		
	КонецЕсли;
	
	// { Васильев Александр Леонидович [02.07.2014]
	//СписокМакетов = СписокМакетов + ?(ЗначениеЗаполнено(СписокМакетов), ",Торг12", "Торг12");
	// ТОРГ-12 пока не печатаем, ждем команды от главного бухгалтера.
	// } Васильев Александр Леонидович [02.07.2014]
	
	Возврат Новый Структура("СписокМакетов, СтрокаРаскроя", СписокМакетов, СтрокаРаскроя);
	
КонецФункции

&НаСервере
Функция ОпределительРаскроя(Документ)
	
	СтрокаРаскроя = "";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Спецификация", Документ);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫРАЗИТЬ(РаскройДеталей.Объект КАК Документ.Спецификация) КАК Ссылка,
	|	РаскройДеталей.СтрокаРаскрой КАК Раскрой,
	|	ВЫРАЗИТЬ(РаскройДеталей.Объект КАК Документ.Спецификация).СтрокаКривогоПила КАК СтрокаКривогоПила
	|ИЗ
	|	РегистрСведений.РаскройДеталей КАК РаскройДеталей
	|ГДЕ
	|	РаскройДеталей.Объект В(&Спецификация)";
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.Раскрой) Тогда
			СтрокаРаскроя = Выборка.Раскрой;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтрокаРаскроя;
	
КонецФункции