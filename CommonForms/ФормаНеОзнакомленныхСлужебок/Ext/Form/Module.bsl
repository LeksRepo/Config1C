﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСтроки(Параметры);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтроки(Данные)
	
	СписокСлужебок.Очистить();
	
	Если Данные.Свойство("МассивОбращений") Тогда
		
		Для Каждого Обращение Из Данные.МассивОбращений Цикл
			
			ДобавитьСтрокуВФорму(Обращение);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Данные.Свойство("МассивСлужебок") Тогда
		
		Для Каждого Записка Из Данные.МассивСлужебок Цикл
			
			ДобавитьСтрокуВФорму(Записка);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Данные.Свойство("МассивПеределокИСрочек") Тогда
		
		Для Каждого Спецификация Из Данные.МассивПеределокИСрочек Цикл
			
			ДобавитьСтрокуВФорму(Спецификация);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСлужебокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		
		ОткрытьЗначение(Элемент.ТекущиеДанные.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуВФорму(Документ)
	
	НоваяСтрока = СписокСлужебок.Добавить();
	НоваяСтрока.Номер = Формат(Документ.Номер, "ЧГ=0");
	
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.Обращение") Тогда 
		
		НоваяСтрока.Дата = Документ.ДатаКонтроля;
		НоваяСтрока.Вид = Документ.ВидОбращения;
		НоваяСтрока.Тема = "" + Документ.ОткудаУзнали + " / " + Документ.КонтактыЗаказчика;
		
		ФизЛицо = Документ.Автор.ФизическоеЛицо;
		НоваяСтрока.Автор = Строка(ФизЛицо.Фамилия)+" "+Лев(Строка(ФизЛицо.Имя),1)+". "+Лев(Строка(ФизЛицо.Отчество),1)+". ";
		
	Иначе
		
		НоваяСтрока.Дата = Документ.Дата;
		
		ДилерскаяСпец = Ложь;
		
		Если ТипЗнч(Документ) = Тип("ДокументСсылка.Спецификация") Тогда
			
			ДилерскаяСпец = Документ.Дилерский;
			
			Если Документ.Срочный Тогда
				
				НоваяСтрока.Вид = "Срочная спецификация";
				НоваяСтрока.Тема = "Срочная спецификация";
				
			Иначе
				
				НоваяСтрока.Вид = "Переделка";
				НоваяСтрока.Тема = "Переделка не изготовлена";
				
			КонецЕсли; 
			
			
		Иначе
			
			НоваяСтрока.Вид = Документ.ВидСлужебнойЗаписки;
			НоваяСтрока.Тема = Документ.Тема;
			
		КонецЕсли;
		
		Если ДилерскаяСпец ИЛИ ТипЗнч(Документ.Автор) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		
			Автор = Документ.Автор.Наименование;
			
		Иначе
		
			ФизЛицо = Документ.Автор.ФизическоеЛицо;
			Автор = Строка(ФизЛицо.Фамилия)+" "+Лев(Строка(ФизЛицо.Имя),1)+". "+Лев(Строка(ФизЛицо.Отчество),1)+". ";
		
		КонецЕсли;
		
		НоваяСтрока.Автор = Автор;
		
	КонецЕсли;
			
	НоваяСтрока.Ссылка = Документ.Ссылка;
	
КонецПроцедуры // ДобавитьСтрокуВФорму()

&НаКлиенте
Процедура ОбновитьСписок()
	
	Данные = ПолучитьДанныеОповещений();
	
	Если ЗначениеЗаполнено(Данные) Тогда
		ЗаполнитьСтроки(Данные);
	Иначе
		СписокСлужебок.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьСписок", 600);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	ОтключитьОбработчикОжидания ("ОбновитьСписок");
КонецПроцедуры
