﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	МожноОбновлятьКлассификатор =
		Не ОбщегоНазначенияПовтИсп.РазделениеВключено() // В модели сервиса обновляется автоматически.
		И Не ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ()   // В узле РИБ обновляется автоматически.
		И ПравоДоступа("Изменение", Метаданные.Справочники.КлассификаторБанковРФ); // Пользователь с необходимыми правами.

	Элементы.ФормаЗагрузитьКлассификатор.Видимость = МожноОбновлятьКлассификатор;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗагрузитьКлассификатор(Команда)
	ПараметрыФормы = Новый Структура("ОткрытиеИзСписка");
	ОткрытьФорму("Справочник.КлассификаторБанковРФ.Форма.ЗагрузкаКлассификатора", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры
