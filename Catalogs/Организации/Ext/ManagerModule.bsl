﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Префикс");
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Использование нескольких организаций

// Возвращает организацию по умолчанию.
// Если в ИБ есть только одна организация, которая не помечена на удаление и не является предопределенной,
// то будет возвращена ссылка на нее, иначе будет возвращена пустая ссылка.
//
// Возвращаемое значение:
//	СправочникСсылка.Организации - ссылка на организацию
//
Функция ОрганизацияПоУмолчанию() Экспорт
	
	Организация = Справочники.Организации.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|	И НЕ Организации.Предопределенный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Организация = Выборка.Организация;
	КонецЕсли;
	
	Возврат Организация;

КонецФункции

// Возвращает количество элементов справочника Организации.
// Не учитывает предопределенные и помеченные на удаление элементы.
//
// Возвращаемое значение:
//	Число - количество организаций
//
Функция КоличествоОрганизаций() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Количество = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.Предопределенный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Количество = Выборка.Количество;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Количество;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Вызывается при переходе на версию БСП 2.2.1.12
//
Процедура ЗаполнитьКонстантуИспользоватьНесколькоОрганизаций() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") =
			ПолучитьФункциональнуюОпцию("НеИспользоватьНесколькоОрганизаций") Тогда
		// Опции должны иметь противоположные значения.
		// Если это не так, то значит в ИБ раньше не было этих опций - инициализируем их значения.
		Константы.ИспользоватьНесколькоОрганизаций.Установить(КоличествоОрганизаций() > 1);
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
