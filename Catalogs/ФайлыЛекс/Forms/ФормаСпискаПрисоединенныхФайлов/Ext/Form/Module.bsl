﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ЗаголовокФормы") Тогда 
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;
	
	Если Параметры.Свойство("ВладелецФайла") Тогда 
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Параметры.ВладелецФайла);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Просмотр(Команда)
	
	ТекДанные = Элементы.Список.ТекущиеДанные;	
	ЛексКлиент.ОткрытьФайл(ТекДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ВладелецФайла = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
	ВладелецФайла = ВладелецФайла.Значение;

	СоздатьФайл(ВладелецФайла);
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьФайл(ВладелецФайла)
		
	СтруктураФайла = ЛексКлиент.ВыбратьФайл(ЭтаФорма);
	
	Если ТипЗнч(СтруктураФайла) = Тип("Структура") Тогда
		
		СтруктураФайла.Вставить("ВладелецФайла", ВладелецФайла);
		
		НовыйФайл = ЛексСервер.СоздатьФайл(СтруктураФайла);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", НовыйФайл);

		ОткрытьФорму("Справочник.ФайлыЛекс.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
		
	КонецЕсли;
				
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	
	ЛексКлиент.ОткрытьФайл(ТекДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры
