﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Не УчитыватьПраздники Тогда
		// Если график работы не учитывает праздники, то нужно удалить интервалы предпраздничного дня
		РасписаниеПредпраздничногоДня = РасписаниеРаботы.НайтиСтроки(Новый Структура("НомерДня", 0));
		Для Каждого СтрокаРасписания Из РасписаниеПредпраздничногоДня Цикл
			РасписаниеРаботы.Удалить(СтрокаРасписания);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	// Если дата окончания не указана, она будет подобрана по производственному календарю
	ДатаОкончанияЗаполнения = ДатаОкончания;
	
	ДниВключенныеВГрафик = Справочники.Календари.ДниВключенныеВГрафик(
									ДатаНачала, 
									СпособЗаполнения, 
									ШаблонЗаполнения, 
									РасписаниеРаботы,
									ДатаОкончанияЗаполнения,
									ПроизводственныйКалендарь, 
									УчитыватьПраздники, 
									ДатаОтсчета);
									
	Справочники.Календари.ЗаписатьДанныеГрафикаВРегистр(
		Ссылка, ДниВключенныеВГрафик, ДатаНачала, ДатаОкончанияЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли