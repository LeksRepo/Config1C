﻿
&НаСервере
Функция ОбновитьСчетаИСубконто()
	
	СтруктураСчетов = БухгалтерскийУчетСервер.ПолучитьСчетаПоВидуОперации(Объект.ВидОперации);
	Объект.СчетДт = СтруктураСчетов.СчетДт;
	Объект.СчетКт = СтруктураСчетов.СчетКт;
	
	Если Объект.ВидОперации = Перечисления.ВидыОпераций.ВозвратОтПодотчетногоЛица Тогда
		
		Объект.Субконто1Дт = Справочники.СтатьиДвиженияДенежныхСредств.ПеремещениеДенежныхСредств;
		Объект.Субконто1Кт = Справочники.СтатьиДвиженияДенежныхСредств.ПеремещениеДенежныхСредств;
		
	КонецЕсли;
	
	ЛексВызовСервера.ОбновитьДоступностьЭлементов(Элементы, Объект.ВидОперации);
	
	ЛексВызовСервера.ЗаполнитьТипыСубконто(Элементы, "Дт", Объект);
	ЛексВызовСервера.ЗаполнитьТипыСубконто(Элементы, "Кт", Объект);
	
КонецФункции

#Область СОБЫТИЯ_ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ЛексВызовСервера.ОбновитьДоступностьЭлементов(Элементы, Объект.ВидОперации);
		
		ЛексВызовСервера.ЗаполнитьТипыСубконто(Элементы, "Дт", Объект);
		ЛексВызовСервера.ЗаполнитьТипыСубконто(Элементы, "Кт", Объект);
		
	Иначе
		
		ОбновитьСчетаИСубконто();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОбИзменении(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СОБЫТИЯ_ЭЛЕМЕНТОВ

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	ВидОперацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ВидОперацииПриИзмененииНаСервере()
	
	ОбновитьСчетаИСубконто();
	
КонецФункции

&НаКлиенте
Процедура СчетДтПриИзменении(Элемент)
	
	СчетДтПриИзмененииНаСервере();
	
КонецПроцедуры

Функция СчетДтПриИзмененииНаСервере()
	
	ЛексВызовСервера.ЗаполнитьТипыСубконто(Элементы, "Дт", Объект);
	
КонецФункции

&НаКлиенте
Процедура СчетКтПриИзменении(Элемент)
	
	СчетКтПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Функция СчетКтПриИзмененииНаСервере()
	
	ЛексВызовСервера.ЗаполнитьТипыСубконто(Элементы, "Кт", Объект);
	
КонецФункции

&НаКлиенте
Процедура Субконто2ДтНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТипСубконто = ТипЗнч(Объект.Субконто2Дт);
	
	Если ТипСубконто = Тип("СправочникСсылка.Счета")
		ИЛИ ТипСубконто = Тип("СправочникСсылка.Кассы") Тогда
		
		СтандартнаяОбработка = Ложь;
		ЛексКлиент.ВыборСчетаКассы("Субконто2Дт", Объект);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Отказ = ЛексКлиент.ПредупредитьОПовторномПроведении(Объект)
	
КонецПроцедуры

#КонецОбласти
