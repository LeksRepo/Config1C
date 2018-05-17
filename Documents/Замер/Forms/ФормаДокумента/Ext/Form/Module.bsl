﻿
#Область ОБРАБОТЧИКИ_СОБЫТИЙ_ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("Подразделение") Тогда
		Объект.Подразделение = Параметры.Подразделение;
	КонецЕсли;
	
	Если Параметры.Свойство("Время") Тогда
		Объект.ДатаЗамера = Параметры.Время;
	КонецЕсли;
	
	Если Параметры.Свойство("Замерщик") Тогда
		Объект.Замерщик = Параметры.Замерщик;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресЗамера") Тогда
		Объект.АдресЗамера = Параметры.АдресЗамера;
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
		Объект.Офис = ДокументОснование.Офис;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Подразделение) Тогда
		
		ЛексСервер.НастройкаПользователя(ПараметрыСеанса.ТекущийПользователь, "Подразделение");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Дизайнер = ПолучитьДизайнераПоВстрече(Объект.Ссылка);
	КонецЕсли;
	
	СписокСпецификаций.Параметры.УстановитьЗначениеПараметра("Замер", Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДизайнераПоВстрече(Замер)
	
	Дизайнер = Неопределено;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Замер", Замер);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВстречаСКлиентом.Ответственный КАК Дизайнер
	|ИЗ
	|	Документ.ВстречаСКлиентом КАК ВстречаСКлиентом
	|ГДЕ
	|	ВстречаСКлиентом.Основание = &Замер
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВстречаСКлиентом.Дата УБЫВ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() > 0 Тогда
		
		Выборка.Следующий();
		Дизайнер = Выборка.Дизайнер;
		
	КонецЕсли;
	
	Возврат Дизайнер; 
	
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

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если НЕ Документы.Замер.РольДоступняДляРедактирования() Тогда
		ЭтаФорма.ТолькоПросмотр = НачалоЧаса(Объект.ДатаЗамера) < ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ Документы.Замер.РольДоступняДляРедактирования() Тогда
		Если НачалоЧаса(ТекущийОбъект.ДатаЗамера) < ТекущаяДата() Тогда
			
			Отказ = Истина;
			ТекстСообщения = "Время уже прошло.";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ТекущийОбъект, "ДатаЗамера");
			
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Элементы.СписокСпецификаций.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область КОМАНДЫ

&НаСервереБезКонтекста
Функция ПолучитьСтавкуЗаКилометр(Подразделение, Дата)
	
	ОбщаяНоменклатура = ЛексСерверПовтИсп.ПолучитьОбщуюНоменклатуруПолностью(Подразделение);
	Отбор = Новый Структура("Подразделение, Номенклатура", Подразделение, ОбщаяНоменклатура.ЗамерДалеко);
	Ставка = РегистрыСведений.НастройкиНоменклатуры.ПолучитьПоследнее(Дата, Отбор).Розничная;
	
	Возврат Ставка;
	
КонецФункции

&НаКлиенте
Процедура ЧасВперед(Команда)
	Объект.ДатаЗамера = Объект.ДатаЗамера + 3600;	
КонецПроцедуры

&НаКлиенте
Процедура ЧасНазад(Команда)
	Объект.ДатаЗамера = Объект.ДатаЗамера - 3600;
КонецПроцедуры

&НаКлиенте
Процедура СписокСпецификацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.СписокСпецификаций.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ПРОЦЕДУРЫ_ОБРАБОТЧИКИ_СОБЫТИЙ_РЕКВИЗИТОВ_ШАПКИ

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Объект.ДатаЗамера = НачалоЧаса(Объект.ДатаЗамера);
	
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
		ПараметрыАдреса.Вставить("Километраж", Объект.Километраж);
		СтруктураАдреса = ОткрытьФормуМодально("ОбщаяФорма.ФормаВводаАдреса", ПараметрыАдреса, ЭтаФорма);
		
		Если ТипЗнч(СтруктураАдреса) = Тип("Структура") Тогда
			
			Объект.АдресЗамера = СтруктураАдреса.Адрес;
			Объект.Километраж = СтруктураАдреса.Километраж;
			Объект.СуммаОплаты = ПолучитьСтавкуЗаКилометр(Объект.Подразделение, Объект.ДатаЗамера) * СтруктураАдреса.Километраж;
			
		КонецЕсли;
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
