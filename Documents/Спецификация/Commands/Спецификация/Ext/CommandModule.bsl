﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Для Каждого Документ Из ПараметрКоманды Цикл
		
		Массив = Новый Массив;
		Массив.Добавить(Документ);
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ФиксированныйКомплект", Ложь); 
		ПараметрыПечати.Вставить("ПереопределитьПользовательскиеНастройкиКоличества", Истина);
		СписокМакетов = ОпределитьМакеты(Документ);
		Если ЗначениеЗаполнено(СписокМакетов) Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Спецификация", СписокМакетов, Массив, ПараметрыВыполненияКоманды.Источник, ПараметрыПечати);
		Иначе
			Предупреждение("Документы на печать отсутствуют!");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры 

&НаСервере
Функция ОпределитьМакеты (Документ)
	
	СписокМакетов = "";
	
	Если Документ.СписокМатериалы.Количество() > 0 или Документ.СписокЯщики.Количество() > 0 или Документ.СписокНоменклатуры.Количество() > 0 Тогда
		
		СписокМакетов = СписокМакетов + "Спецификация";
		
		Для Каждого Элемент Из Документ.СписокМатериалы Цикл
			
			Если Элемент.Материал = "ФасадСтеклянныйЗакругленный" Тогда
				
				СписокМакетов = СписокМакетов + ",СтеклянныеФасады";
				
				Прервать;
			КонецЕсли;
			
			//Если Элемент.Материал = "ФасадАГТ" или Элемент.Материал = "ФасадАГТ" Тогда
			//	
			//	СписокМакетов = СписокМакетов + ",Фасады";
			//	
			//КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Документ.СписокДверей.Количество() > 0 Тогда
		СписокМакетов = СписокМакетов + ?(ЗначениеЗаполнено(СписокМакетов), ",Дверь", "Дверь");
	КонецЕсли;
	
	Если Документ.СписокИзделийПоКаталогу.Количество() > 0 Тогда
		СписокМакетов = СписокМакетов + ?(ЗначениеЗаполнено(СписокМакетов), ",ИзделиеПоКаталогу", "ИзделиеПоКаталогу");
	КонецЕсли;
	
	Возврат СписокМакетов;
	
КонецФункции
