﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	УстановитьВидимостьРасписания(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПроверятьНаличиеОбновленияПриЗапускеПриИзменении(Элемент)
	
	УстановитьВидимостьРасписания(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьОткрытьРасписаниеНажатие(Элемент)
	
	Если Объект.РасписаниеПроверкиНаличияОбновления = Неопределено Тогда
		Объект.РасписаниеПроверкиНаличияОбновления = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Объект.РасписаниеПроверкиНаличияОбновления);
	Если Диалог.ОткрытьМодально() Тогда
		Объект.РасписаниеПроверкиНаличияОбновления	= Диалог.Расписание;
	КонецЕсли;
	Элементы.НадписьОткрытьРасписание.Заголовок = ТекстНадписиОткрытьРасписание(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ОчиститьСообщения();
	НастройкиИзменены = (Параметры.ПроверятьНаличиеОбновленияПриЗапуске <> Объект.ПроверятьНаличиеОбновленияПриЗапуске
		И (Параметры.ПроверятьНаличиеОбновленияПриЗапуске = 1 ИЛИ Объект.ПроверятьНаличиеОбновленияПриЗапуске = 1))
		ИЛИ Строка(Параметры.РасписаниеПроверкиНаличияОбновления) <> Строка(Объект.РасписаниеПроверкиНаличияОбновления);
		
	Если НастройкиИзменены Тогда
		ПериодПовтораВТечениеДня = Объект.РасписаниеПроверкиНаличияОбновления.ПериодПовтораВТечениеДня;
		Если ПериодПовтораВТечениеДня > 0 И ПериодПовтораВТечениеДня < 60 * 5 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Интервал проверки не может быть задан чаще, чем один раз 5 минут.'"));
			Возврат;
		КонецЕсли;
			
		НастройкиОбновленияКонфигурации.ПроверятьНаличиеОбновленияПриЗапуске = Объект.ПроверятьНаличиеОбновленияПриЗапуске;
		НастройкиОбновленияКонфигурации.РасписаниеПроверкиНаличияОбновления = ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Объект.РасписаниеПроверкиНаличияОбновления);
		ЗаписатьНастройки(НастройкиОбновленияКонфигурации);
		ОбновлениеКонфигурацииКлиент.ПодключитьОтключитьПроверкуПоРасписанию(Объект.ПроверятьНаличиеОбновленияПриЗапуске = 1 И
			Объект.РасписаниеПроверкиНаличияОбновления <> Неопределено);
	КонецЕсли;
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("ПроверятьНаличиеОбновленияПриЗапуске", Объект.ПроверятьНаличиеОбновленияПриЗапуске);
	РезультатВыбора.Вставить("РасписаниеПроверкиНаличияОбновления",  Объект.РасписаниеПроверкиНаличияОбновления);
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьРасписания(Форма)
	
	НадписьОткрытьРасписание = Форма.Элементы.НадписьОткрытьРасписание;
	Если Форма.Объект.ПроверятьНаличиеОбновленияПриЗапуске = 1 Тогда
		НадписьОткрытьРасписание.Доступность = Истина;
		НадписьОткрытьРасписание.Заголовок = ТекстНадписиОткрытьРасписание(Форма);
	Иначе
		НадписьОткрытьРасписание.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстНадписиОткрытьРасписание(Форма)
	
	СтроковоеПредставлениеРасписания = Строка(Форма.Объект.РасписаниеПроверкиНаличияОбновления);
	Возврат ?(Не ПустаяСтрока(СтроковоеПредставлениеРасписания),
		СтроковоеПредставлениеРасписания, НСтр("ru = 'Открыть расписание'"));
		
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗаписатьНастройки(НастройкиОбновленияКонфигурации)
	
	ОбновлениеКонфигурацииВызовСервера.ЗаписатьСтруктуруНастроекПомощника(НастройкиОбновленияКонфигурации);
	ОбновитьПовторноИспользуемыеЗначения(); // сбрасываем кеш для применения настроек
	
КонецФункции

