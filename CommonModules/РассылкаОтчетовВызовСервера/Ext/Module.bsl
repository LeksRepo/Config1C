﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Рассылка отчетов" (вызов сервера)
// 
// Выполняется на сервере, но может вызываться с клиента.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Для внутреннего использования.
//
Функция СформироватьСписокПолучателейРассылки(Знач Параметры) Экспорт
	ПараметрыЖурнала = Новый Структура("ИмяСобытия, Метаданные, Данные, МассивОшибок, БылиОшибки");
	ПараметрыЖурнала.ИмяСобытия   = НСтр("ru = 'Рассылка отчетов. Формирование списка получателей'");
	ПараметрыЖурнала.МассивОшибок = Новый Массив;
	ПараметрыЖурнала.БылиОшибки   = Ложь;
	ПараметрыЖурнала.Данные       = Параметры.Ссылка;
	ПараметрыЖурнала.Метаданные   = Метаданные.Справочники.РассылкиОтчетов;
	
	Результат = Новый Структура("Получатели, ТекстОшибок", , "");
	Результат.Получатели = РассылкаОтчетов.СформироватьСписокПолучателейРассылки(ПараметрыЖурнала, Параметры);
	
	Если ПараметрыЖурнала.БылиОшибки = Истина Тогда
		Результат.ТекстОшибок = РассылкаОтчетовКлиентСервер.СтрокаСообщенийПользователю(ПараметрыЖурнала.МассивОшибок, Ложь);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Обновляет состояние фонового задания и получает результат его выполнения из временного хранилища.
//
Функция ПроверитьВыполнениеФоновогоЗадания(ИдентификаторЗадания, АдресХранилища) Экспорт
	Результат = Новый Структура("Статус, Детали");
	Попытка
		Если ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			Результат.Статус = "ВыполненоУспешно"; // Не локализуется
			Результат.Детали = ПолучитьИзВременногоХранилища(АдресХранилища);
		Иначе
			Результат.Статус = "Выполняется"; // Не локализуется
		КонецЕсли;
	Исключение
		Результат.Статус = "Исключение"; // Не локализуется
	КонецПопытки;
	Возврат Результат;
КонецФункции
