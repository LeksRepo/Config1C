﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает текущего пользователя или текущего внешнего пользователя,
// в зависимости от того, кто выполнил вход в сеанс.
//  Рекомендуется использовать в коде, который поддерживает работу
// в обоих случаях.
//
// Возвращаемое значение:
//  СправочникСсылка.Пользователи или СправочникСсылка.ВнешниеПользователи.
// 
Функция АвторизованныйПользователь() Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ?(ЗначениеЗаполнено(ПараметрыСеанса.ТекущийПользователь),
	          ПараметрыСеанса.ТекущийПользователь,
	          ПараметрыСеанса.ТекущийВнешнийПользователь);
#Иначе
	Возврат СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске().АвторизованныйПользователь;
#КонецЕсли
	
КонецФункции

// Возвращает текущего пользователя.
//  Рекомендуется использовать в коде, который не поддерживает
// работу с внешними пользователями.
//
//  Если вход в сеанс выполнил внешний пользователь,
// тогда будет вызвано исключение.
//
// Возвращаемое значение:
//  СправочникСсылка.Пользователи
//
Функция ТекущийПользователь() Экспорт
	
	//Определяем любого пользователя (Пользователь И ВнешнийПользователь), без исключения, необходимо для работы с файлами.
	АвторизованныйПользователь = АвторизованныйПользователь();
	
	//Если ТипЗнч(АвторизованныйПользователь) <> Тип("СправочникСсылка.Пользователи") Тогда
	//	ВызватьИсключение
	//		НСтр("ru = 'Невозможно получить текущего пользователя
	//				   |в сеансе внешнего пользователя.'");
	//КонецЕсли;
	
	Возврат АвторизованныйПользователь;
	
КонецФункции

// Возвращает текущего внешнего пользователя.
//  Рекомендуется использовать в коде, который поддерживает
// только внешних пользователей.
//
//  Если вход в сеанс выполнил не внешний пользователь,
// тогда будет вызвано исключение.
//
// Возвращаемое значение:
//  СправочникСсылка.ВнешниеПользователи
//
Функция ТекущийВнешнийПользователь() Экспорт
	
	АвторизованныйПользователь = АвторизованныйПользователь();
	
	Если ТипЗнч(АвторизованныйПользователь) <> Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		ВызватьИсключение
			НСтр("ru = 'Невозможно получить текущего внешнего пользователя
			           |в сеансе пользователя.'");
	КонецЕсли;
	
	Возврат АвторизованныйПользователь;
	
КонецФункции

// Возвращает Истина, если вход в сеанс выполнил внешний пользователь.
Функция ЭтоСеансВнешнегоПользователя() Экспорт
	
	Возврат ТипЗнч(АвторизованныйПользователь())
	      = Тип("СправочникСсылка.ВнешниеПользователи");
	
КонецФункции