﻿
&НаКлиенте
Процедура АдресНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыАдреса = Новый Структура;
	ПараметрыАдреса.Вставить("АдресТолькоРоссийский", Истина);
	Если Объект.Адрес = "Введите адрес" Тогда
		ЗначенияПолей = "";
		Представление = "";
	Иначе
		ЗначенияПолей = УправлениеКонтактнойИнформациейКлиентСервер.ПреобразоватьСтрокуВСписокПолей(Объект.ЗначениеПоляАдрес);
		Представление = Объект.Адрес;
	КонецЕсли;
	ПараметрыАдреса.Вставить("ЗначенияПолей", ЗначенияПолей);
	ПараметрыАдреса.Вставить("Представление", Представление);
	СтруктураАдреса = ОткрытьФормуМодально("ОбщаяФорма.ВводАдреса", ПараметрыАдреса, ЭтаФорма);
	Если ТипЗнч(СтруктураАдреса) = Тип("Структура") Тогда
		Объект.Адрес = СтруктураАдреса.Представление;
		Объект.ЗначениеПоляАдрес = УправлениеКонтактнойИнформациейКлиентСервер.ПреобразоватьСписокПолейВСтроку(СтруктураАдреса.ЗначенияПолей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбора = Новый Структура;
	СтруктураНаселенногоПункта = Новый Структура;
	ПараметрыВыбора.Вставить("Подразделение", Объект.Владелец);
	СтруктураНаселенногоПункта = ОткрытьФормуМодально("РегистрСведений.Адреса.Форма.ФормаВыбораНаселенногоПункта", ПараметрыВыбора, Объект.НаселенныйПункт);
	
	//Если ТипЗнч(СтруктураНаселенногоПункта) = Тип("Структура") Тогда
	//	Объект.НаселенныйПункт = СтруктураНаселенногоПункта.НаселенныйПункт;
	//Иначе
	//	Возврат;
	//КонецЕсли;
	
КонецПроцедуры

