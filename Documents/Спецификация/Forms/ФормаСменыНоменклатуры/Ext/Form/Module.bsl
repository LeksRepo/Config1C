﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Номенклатура.СписокВыбора.ЗагрузитьЗначения(Параметры.СписокНоменклатуры);
	Подразделение = Параметры.Подразделение;
	
	Если Параметры.Свойство("Офис") Тогда
		Офис = Параметры.Офис; 	
	КонецЕсли;
	
	Если Параметры.Свойство("Каталог") И Параметры.Каталог Тогда
		Элементы.ПредупреждениеЯщики.Видимость = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СменяющаяНоменклатура = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиЗамену(Команда)
	
	Режим = РежимДиалогаВопрос.ОКОтмена;
	Текст = "Вы уверены, что хотите завершить замену цвета номенклатуры?";
	Ответ = Вопрос(Текст, Режим, 0);
	
	Если Ответ = КодВозвратаДиалога.ОК  Тогда
		
		Если ЗначениеЗаполнено(Номенклатура) И ЗначениеЗаполнено(СменяющаяНоменклатура) Тогда
			
			СтруктураНоменклатур = Новый Структура;
			СтруктураНоменклатур.Вставить("СтараяНоменклатура", Номенклатура);
			СтруктураНоменклатур.Вставить("НоваяНоменклатура", СменяющаяНоменклатура);
			СтруктураНоменклатур.Вставить("ЗаменаНоменклатуры", "Истина");
			ОповеститьОВыборе(СтруктураНоменклатур);	
			
		Иначе
			
			Сообщить("Заполните номенклатуру для замены.");
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПодбора(НомГруппы, ЭлементФормы)
	
	Пар = Новый Структура();
	Пар.Вставить("НомГруппы", НомГруппы);
	Пар.Вставить("Подразделение", Подразделение);
	Пар.Вставить("Офис",Офис);
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", Пар, ЭлементФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СменяющаяНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
	
		НомГруппы = Новый СписокЗначений;	
		НомГруппы.Добавить(ПолучитьНомГруппуНоменклатуры(Номенклатура));
			
		ОткрытьФормуПодбора(НомГруппы, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНомГруппуНоменклатуры(Номенклатура)
	
	Возврат Номенклатура.НоменклатурнаяГруппа;
	
КонецФункции
