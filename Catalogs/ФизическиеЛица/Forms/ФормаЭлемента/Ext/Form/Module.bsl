﻿
&НаКлиенте
Процедура АдресРегистрацииНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Реквизит = Элемент.Имя;

	ПараметрыАдреса = Новый Структура;
	ПараметрыАдреса.Вставить("АдресТолькоРоссийский", Истина);
	Если Объект[Реквизит] = "Введите адрес" Тогда
		ЗначенияПолей = "";
		Представление = "";
	Иначе
		ЗначенияПолей = УправлениеКонтактнойИнформациейКлиентСервер.ПреобразоватьСтрокуВСписокПолей(Объект["ЗначенияПолей" + Реквизит]);
		Представление = Объект[Реквизит];
	КонецЕсли;
	ПараметрыАдреса.Вставить("ЗначенияПолей", ЗначенияПолей);
	ПараметрыАдреса.Вставить("Представление", Представление);
	СтруктураАдреса = ОткрытьФормуМодально("ОбщаяФорма.ВводАдреса", ПараметрыАдреса, ЭтаФорма);
	Если ТипЗнч(СтруктураАдреса) = Тип("Структура") Тогда
		Объект[Реквизит] = СтруктураАдреса.Представление;
		Объект["ЗначенияПолей" + Реквизит] = УправлениеКонтактнойИнформациейКлиентСервер.ПреобразоватьСписокПолейВСтроку(СтруктураАдреса.ЗначенияПолей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФИОПриИзменении(Элемент)
	
	Объект.Фамилия = СокрЛП(Объект.Фамилия);
	Объект.Имя = СокрЛП(Объект.Имя);
	Объект.Отчество = СокрЛП(Объект.Отчество);
	
	Объект.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 %2 %3", Объект.Фамилия, Объект.Имя, Объект.Отчество);
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольИнкассатора(Команда)
	
	Объект.ПарольИнкассатора = ОткрытьФормуМодально("Справочник.ФизическиеЛица.Форма.ФормаПарольИнкассатора");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// а тут не глючит если форма только для просмотра открывается?
	// допустим прав нет
	
	Если НЕ ЗначениеЗаполнено(Объект.АдресПроживания) Тогда
		Объект.АдресПроживания = "Введите адрес";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.АдресРегистрации) Тогда
		Объект.АдресРегистрации = "Введите адрес";
	КонецЕсли;
	
	ОбновитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура АктивностьПриИзменении(Элемент)
	
	ОбновитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Функция ОбновитьЭлементыФормы()
	
	Элементы.ГруппаПараметрыРаботы.Доступность = Объект.Активность;
	
КонецФункции


