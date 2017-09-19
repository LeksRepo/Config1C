﻿
&НаСервере
Функция ЗаполнитьСписокВыборкаЗамерщики()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГородРабочий", ПараметрыСеанса.ТекущийКонтрагент.Город);
	Запрос.УстановитьПараметр("Подразделение", ПараметрыСеанса.ТекущееПодразделение);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФизическиеЛица.Ссылка
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Активность
	|	И ФизическиеЛица.ЗамерыИВстречи
	|	И ФизическиеЛица.ГородРабочий = &ГородРабочий
	|	И ФизическиеЛица.Подразделение = &Подразделение";
	
	РезультатЗапроса = Запрос.Выполнить();
	МассивЗамерщиков = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	Элементы.Замерщик.СписокВыбора.ЗагрузитьЗначения(МассивЗамерщиков);
	
КонецФункции

&НаКлиенте
Процедура ЧасВперед(Команда)
	Объект.ДатаЗамера = Объект.ДатаЗамера + 3600;	
КонецПроцедуры

&НаКлиенте
Процедура ЧасНазад(Команда)
	Объект.ДатаЗамера = Объект.ДатаЗамера - 3600;
КонецПроцедуры

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
	
	Если НЕ ЗначениеЗаполнено(Объект.Подразделение) Тогда
		Объект.Подразделение = ПараметрыСеанса.ТекущийКонтрагент.Подразделение;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Дилер) Тогда
		Объект.Дилер = ПараметрыСеанса.ТекущийКонтрагент;
	КонецЕсли;
	
	ЗаполнитьСписокВыборкаЗамерщики();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ВладелецФормы <> Неопределено Тогда
		Если ТипЗнч(ВладелецФормы) = Тип("УправляемаяФорма") Тогда
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
Процедура ДатаПриИзменении(Элемент)
	
	Объект.ДатаЗамера = НачалоЧаса(Объект.ДатаЗамера);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыАдреса = Новый Структура;
	ПараметрыАдреса.Вставить("Подразделение", Объект.Подразделение);
	
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
		
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры
