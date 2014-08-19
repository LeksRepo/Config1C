﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция ПолучитьСтавкуЗаКилометр(Подразделение, Дата)
	
	Отбор = Новый Структура("Регион, Номенклатура", Подразделение.Регион, ПредопределенноеЗначение("Справочник.Номенклатура.ЗамерДалеко"));
	Ставка = РегистрыСведений.ЦеныНоменклатуры.ПолучитьПоследнее(Дата, Отбор).Розничная;
	
	Возврат Ставка;
	
КонецФункции

&НаКлиенте
Процедура ЧасВперед(Команда)
	Объект.Дата = Объект.Дата + 3600;	
КонецПроцедуры

&НаКлиенте
Процедура ЧасНазад(Команда)
	Объект.Дата = Объект.Дата - 3600;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

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
	
	Если Параметры.Свойство("ДокументОснование") Тогда
		ДокументОснование = Параметры.ДокументОснование;
		Объект.ПервыйЗамер = ДокументОснование;
		Объект.Подразделение = ДокументОснование.Подразделение;
		Объект.ИмяЗаказчика = ДокументОснование.ИмяЗаказчика;
		Объект.ОткудаПришел = ДокументОснование.ОткудаПришел;
		Если ЗначениеЗаполнено(ДокументОснование.АдресЗамера) Тогда
			Объект.АдресЗамера = ДокументОснование.АдресЗамера;
		Иначе
			Объект.АдресЗамера = "Введите адрес";
		КонецЕсли;
		Объект.Километраж = ДокументОснование.Километраж;
		Объект.Телефон = ДокументОснование.Телефон;
		Объект.Агент = ДокументОснование.Агент;
		Объект.Офис = ДокументОснование.Офис;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Подразделение) Тогда
		
		ЛексСервер.НастройкаПользователя(ПараметрыСеанса.ТекущийПользователь, "Подразделение");
		
	КонецЕсли;
	
	СписокСпецификаций.Параметры.УстановитьЗначениеПараметра("Замер", Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Объект.АдресЗамера) Тогда
		
		АдресПоЧастям = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Объект.АдресЗамера, ", ");
		НаселенныйПункт = АдресПоЧастям[0];
		
	КонецЕсли;
	
КонецПроцедуры

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

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	Если НЕ Документы.Замер.РольДоступняДляРедактирования() Тогда
		ЭтаФорма.ТолькоПросмотр = НачалоЧаса(Объект.Дата) < ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ Документы.Замер.РольДоступняДляРедактирования() Тогда
		Если НачалоЧаса(ТекущийОбъект.Дата) < ТекущаяДата() Тогда
			
			Отказ = Истина;
			ТекстСообщения = "Время уже прошло.";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ТекущийОбъект, "Дата");
			
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Элементы.СписокСпецификаций.Обновить();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Объект.Дата = НачалоЧаса(Объект.Дата);
	
КонецПроцедуры

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
			
			Объект.АдресЗамера = СтруктураАдреса.Адрес;
			Объект.Километраж = СтруктураАдреса.Километраж;
			Объект.СуммаОплаты = ПолучитьСтавкуЗаКилометр(Объект.Подразделение, Объект.Дата) * СтруктураАдреса.Километраж;
			
		КонецЕсли;
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСпецификацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.СписокСпецификаций.ТекущиеДанные.Ссылка);
	
КонецПроцедуры








