﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Переделки
	//МассивПеределки = ЛексСервер.НайтиПодчиненныеДокументы(Объект.Ссылка, "Документ.Переделка", "Монтаж");
	//Если МассивПеределки.Количество() = 1 Тогда
	//	Переделки = МассивПеределки[0];
	//ИначеЕсли МассивПеределки.Количество() = 0 Тогда
	//	Переделки = "Ввести Переделку";
	//Иначе
	//	Переделки = "Ошибка связи документа Переделки с Графиком монтажа";
	//КонецЕсли;
	
	Если Параметры.Свойство("Спецификация") Тогда
		
		Спецификация 				= Параметры.Спецификация;
		Объект.Подразделение 	= ОбщегоНазначения.ПолучитьЗначениеРеквизита(Спецификация, "Подразделение");
		Объект.Спецификация 	= Спецификация;
		Объект.ДатаМонтажа 		= ОбщегоНазначения.ПолучитьЗначениеРеквизита(Спецификация, "ДатаМонтажа");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	//Если ИсточникВыбора.ИмяФормы = "Документ.Переделка.Форма.ФормаДокумента" Тогда
	//	
	//	Переделки = ВыбранноеЗначение;
	//	
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеречитатьИзделия(Команда)
	
	 ПеречитатьИзделияСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПеречитатьИзделияСервер()

	ДокументОбъект = РеквизитФормыВЗначение("Объект", Тип("ДокументОбъект.Монтаж"));
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	Объект.ДатаМонтажа = ДокументОбъект.Спецификация.ДатаМонтажа;
	
КонецПроцедуры //ПеречитатьИзделияСервер ()

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	//ПодпискиНаСобытия.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СпецификацияПриИзменении(Элемент)
	
	ПеречитатьИзделия(Объект.Спецификация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если НЕ ВладелецФормы = Неопределено Тогда
		
		ЗакрыватьПриВыборе = Ложь;
		ОповеститьОВыборе(Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры
