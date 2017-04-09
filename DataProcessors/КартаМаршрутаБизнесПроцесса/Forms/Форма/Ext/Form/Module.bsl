﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.БизнесПроцесс) Тогда
		БизнесПроцесс = Параметры.БизнесПроцесс;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьКартуМаршрута();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура БизнесПроцессПриИзменении(Элемент)
	ОбновитьКартуМаршрута();
КонецПроцедуры

&НаКлиенте
Процедура КартаМаршрутаВыбор(Элемент)
	ОткрытьСписокЗадачТочкиМаршрута();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОбновитьВыполнить(Команда)
	ОбновитьКартуМаршрута();   
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиВыполнить(Команда)
	ОткрытьСписокЗадачТочкиМаршрута();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьКартуМаршрута()
	
	Если ЗначениеЗаполнено(БизнесПроцесс) Тогда
		КартаМаршрута = БизнесПроцесс.ПолучитьОбъект().ПолучитьКартуМаршрута();
	ИначеЕсли БизнесПроцесс <> Неопределено Тогда
		КартаМаршрута = БизнесПроцессы[БизнесПроцесс.Метаданные().Имя].ПолучитьКартуМаршрута();
		Возврат;
	Иначе
		КартаМаршрута = Новый ГрафическаяСхема;
		Возврат;
	КонецЕсли;
	
	СвойстваБизнесПроцесса = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		БизнесПроцесс, "Автор,Дата,ДатаЗавершения,Завершен,Стартован" +
		?(БизнесПроцесс.Метаданные().Реквизиты.Найти("Состояние") = Неопределено, "", ",Состояние"));
	ЗаполнитьЗначенияСвойств(ЭтаФорма, СвойстваБизнесПроцесса);
	Если СвойстваБизнесПроцесса.Завершен Тогда
		Статус = НСтр("ru = 'Завершен'");
		Элементы.ГруппаСтатус.ТекущаяСтраница = Элементы.ГруппаЗавершен;
	ИначеЕсли СвойстваБизнесПроцесса.Стартован Тогда
		Статус = НСтр("ru = 'Стартован'");
		Элементы.ГруппаСтатус.ТекущаяСтраница = Элементы.ГруппаНеЗавершен;
	Иначе	
		Статус = НСтр("ru = 'Не стартован'");
		Элементы.ГруппаСтатус.ТекущаяСтраница = Элементы.ГруппаНеЗавершен;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокЗадачТочкиМаршрута()

#Если ВебКлиент Тогда
	Предупреждение(НСтр("ru = 'Данная операция недоступна в веб-клиенте.'"));
	Возврат;
#КонецЕсли
	ОчиститьСообщения();
	ТекЭлемент = Элементы.КартаМаршрута.ТекущийЭлемент;

	Если Не ЗначениеЗаполнено(БизнесПроцесс) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо указать бизнес-процесс.'"),,
			"БизнесПроцесс");
		Возврат;
	КонецЕсли;
	
	Если ТекЭлемент = Неопределено ИЛИ
		НЕ (ТипЗнч(ТекЭлемент) = Тип("ЭлементГрафическойСхемыДействие")
		ИЛИ ТипЗнч(ТекЭлемент) = Тип("ЭлементГрафическойСхемыВложенныйБизнесПроцесс")) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо выбрать точку действия или вложенный бизнес-процесс карты маршрута.'"),,
			"КартаМаршрута");
		Возврат;
	КонецЕсли;

	ЗаголовокФормы = НСтр("ru = 'Задачи по точке маршрута бизнес-процесса'");
	
	ОткрытьФорму("Задача.ЗадачаИсполнителя.ФормаСписка", 
		Новый Структура("Отбор,ЗаголовокФормы,ПоказыватьЗадачи,ВидимостьОтборов,БлокировкаОкнаВладельца,Задача,БизнесПроцесс", 
			Новый Структура("БизнесПроцесс,ТочкаМаршрута", БизнесПроцесс, ТекЭлемент.Значение),
			ЗаголовокФормы,0,Ложь,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца,Строка(ТекЭлемент.Значение),Строка(БизнесПроцесс)),
		ЭтаФорма, БизнесПроцесс);

КонецПроцедуры

