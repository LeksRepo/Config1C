﻿
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Если открыли данную форму из формы документа, то там надо поменять текст
	Если НЕ ВладелецФормы = Неопределено Тогда
		Если ТипЗнч(ВладелецФормы) = Тип("УправляемаяФорма") тогда
			ЗакрыватьПриВыборе = Ложь;
			Если Найти(ВладелецФормы.ИмяФормы, "ФормаДокумента") <> 0 И ВладелецФормы.Объект.Ссылка = Объект.Договор Тогда
				ОповеститьОВыборе("ЗаписанИзмененияДоговора");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	//ПодпискиНаСобытия.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	
	
КонецПроцедуры
