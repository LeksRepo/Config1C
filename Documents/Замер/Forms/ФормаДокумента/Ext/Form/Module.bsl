﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Объект.АдресЗамера) Тогда
		
		АдресПоЧастям 		= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Объект.АдресЗамера, ", ");
		НаселенныйПункт 	= АдресПоЧастям[0];
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКилометраж(Офис,НаселенныйПункт)
	
	Отбор 							= Новый Структура("ГородВладелец, НаселенныйПункт", Офис.Город, НаселенныйПункт);
	КилометражПоРегистру 	= РегистрыСведений.Адреса.Получить(Отбор).Километраж;
	
	Возврат КилометражПоРегистру;
	
КонецФункции

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если НЕ ВладелецФормы = Неопределено Тогда
		Если ТипЗнч(ВладелецФормы) = Тип("УправляемаяФорма") тогда
			ЗакрыватьПриВыборе = Ложь;
			Если Найти(ВладелецФормы.ИмяФормы, "Обработка.ЗаписьНаЗамер.Форма.Форма") <> 0 Тогда
				ОповеститьОВыборе(1);
			Иначе
				ОповеститьОВыборе(Объект.Ссылка);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Объект.Дата = НачалоЧаса(Объект.Дата);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЭтаФорма.ТолькоПросмотр = НачалоЧаса(Объект.Дата) < ТекущаяДата();
	
КонецПроцедуры

&НаКлиенте
Процедура ЧасВперед(Команда)
	Объект.Дата = Объект.Дата + 3600;	
КонецПроцедуры

&НаКлиенте
Процедура ЧасНазад(Команда)
	Объект.Дата = Объект.Дата - 3600;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтавкуЗаКилометр(Подразделение, Дата)
	
	Отбор = Новый Структура("Регион, Номенклатура", Подразделение.Регион, ПредопределенноеЗначение("Справочник.Номенклатура.ЗамерДалеко"));
	Ставка = РегистрыСведений.ЦеныНоменклатуры.ПолучитьПоследнее(Дата, Отбор).Розничная;
	
	Возврат Ставка;
	
КонецФункции

&НаКлиенте
Процедура АдресНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Офис) Тогда
		
		ТекстСообщения = "Выберите офис!";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Офис", "Объект");
		
	Иначе
		
		ПараметрыАдреса = Новый Структура;
		ПараметрыАдреса.Вставить("Офис", Объект.Офис);
		
		Если Объект.АдресЗамера = "Введите адрес" Тогда
			
			СтарыйАдрес = "";
			
		Иначе
			
			СтарыйАдрес = Объект.АдресЗамера;
			
		КонецЕсли;
		
		ПараметрыАдреса.Вставить("СтарыйАдрес", СтарыйАдрес);
		СтруктураАдреса = ОткрытьФормуМодально("ОбщаяФорма.ФормаВводаАдреса", ПараметрыАдреса, ЭтаФорма);
		
		Если ТипЗнч(СтруктураАдреса) = Тип("Структура") Тогда
			
			Объект.АдресЗамера 	= СтруктураАдреса.Адрес;
			Объект.Километраж		= СтруктураАдреса.Километраж;
			Объект.СуммаОплаты 	= ПолучитьСтавкуЗаКилометр(Объект.Подразделение, Объект.Дата) * СтруктураАдреса.Километраж;
			
		КонецЕсли;
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Подразделение") Тогда
		Объект.Подразделение = Параметры.Подразделение;
	КонецЕсли;
	
	Если Параметры.Свойство("Время") Тогда
		Объект.Дата = Параметры.Время;
	КонецЕсли;
	
	Если Параметры.Свойство("Замерщик") Тогда
		Объект.Замерщик = Параметры.Замерщик;	
	КонецЕсли;
	
	Если Параметры.Свойство("СтруктураЗамера") Тогда
		Объект.ПервыйЗамер = Параметры.СтруктураЗамера.ПервыйЗамер;
		Объект.Подразделение = Параметры.СтруктураЗамера.Подразделение;
		Объект.ИмяЗаказчика = Параметры.СтруктураЗамера.ИмяЗаказчика;
		Объект.ОткудаПришел = Параметры.СтруктураЗамера.ОткудаПришел;
		Объект.АдресЗамера = Параметры.СтруктураЗамера.АдресЗамера;
		Объект.Километраж = Параметры.СтруктураЗамера.Километраж;
		Объект.Замерщик = Параметры.СтруктураЗамера.Замерщик;
		Объект.Телефон = Параметры.СтруктураЗамера.Телефон;
		Объект.Агент = Параметры.СтруктураЗамера.Агент;
		Объект.Офис = Параметры.СтруктураЗамера.Офис;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Подразделение) Тогда
		
		ЛексСервер.НастройкаПользователя(ПараметрыСеанса.ТекущийПользователь, "Подразделение");
		
	КонецЕсли;
	
	СписокСпецификаций.Параметры.УстановитьЗначениеПараметра("Замер", Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСпецификацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.СписокСпецификаций.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НачалоЧаса(ТекущийОбъект.Дата) < ТекущаяДата() Тогда
		
		Отказ 					= Истина;
		ТекстСообщения 	= "Время уже прошло.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ТекущийОбъект, "Дата");
		
	КонецЕсли;
	
КонецПроцедуры

