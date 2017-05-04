﻿
&НаКлиенте
Процедура СписокНоменклатурыНоменклатураИсточникПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	ТекущиеДанные.НоменклатураПолучатель = ЛексСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.НоменклатураИсточник, "БазоваяНоменклатура");
	ЗаполнитьКоличество();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыКоличествоОтправляемоеПриИзменении(Элемент)
	
	ЗаполнитьКоличество();
	
КонецПроцедуры

&НаКлиенте
Функция ЗаполнитьКоличество()
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	КоэффициентБазовых = ЛексСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.НоменклатураИсточник, "КоэффициентБазовых");
	ТекущиеДанные.КоличествоПолучаемое = ТекущиеДанные.КоличествоОтправляемое * КоэффициентБазовых;
	
КонецФункции


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЭтаФорма.ТолькоПросмотр Тогда 
		ЭтаФорма.ТолькоПросмотр = ЛексСервер.ДоступностьФормыСкладскиеДокументы(Объект.Ссылка);
	КонецЕсли;
		
КонецПроцедуры

