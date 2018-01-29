﻿
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Если открыли данную форму из формы документа, то там надо поменять текст
	Если НЕ ВладелецФормы = Неопределено Тогда
		
		Если ТипЗнч(ВладелецФормы) = Тип("УправляемаяФорма") Тогда 
			
			ЗакрыватьПриВыборе = Ложь;
			ОповеститьОВыборе(Объект.Ссылка);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.Ссылка.Пустая()
		И Объект.Договор.Спецификация.ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж Тогда
		
		СтрокаВопроса = "Вы уверены, что %1 по адресу %2 %3%4 устанавливал %5?";
		Спецификация = ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.Договор, "Спецификация");
		СвойстваСпецификации = ЛексСервер.ЗначенияРеквизитовОбъекта(Спецификация, "ДатаМонтажа, АдресМонтажа, Монтажник, Изделие");
		СтрокаВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаВопроса,
		СвойстваСпецификации.Изделие, // %1
		СвойстваСпецификации.АдресМонтажа, // %2
		Символы.ПС, // %3
		Формат(СвойстваСпецификации.ДатаМонтажа, "ДЛФ=DD"), // %4
		СвойстваСпецификации.Монтажник); // %5
		
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос(СтрокаВопроса, Режим, 0);
		
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			
			Предупреждение("Измените монтаж в Спецификации перед проведением акта");
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
