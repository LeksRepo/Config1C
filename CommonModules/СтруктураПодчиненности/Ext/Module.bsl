﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Структура подчиненности".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Объявление событий, к которым можно добавлять обработчики.

// Объявляет служебные события подсистемы СтруктураПодчиненности:
//
// Серверные события:
//   ПриФормированииМассиваДополнительныхРеквизитовДокумента,
//   ПриПолученииПредставленияДокументаДляПечати.
//
// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия) Экспорт
	
	// СЕРВЕРНЫЕ СОБЫТИЯ.
	
	// Формирует массив реквизитов документа. 
	// 
	// Параметры: 
	// ИмяДокумента - Строка - имя документа.
	// МассивДопРеквизитов - Массив наименований реквизитов документа.
	//
	// Синтаксис:
	// Процедура ПриФормированииМассиваДополнительныхРеквизитовДокумента(ИмяДокумента, МассивДопРеквизитов) Экспорт
	//
	// (То же, что СтруктураПодчиненностиПереопределяемый.МассивДополнительныхРеквизитовДокумента).
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.СтруктураПодчиненности\ПриФормированииМассиваДополнительныхРеквизитовДокумента");
	
	// Получает представление документа для печати
	//
	// Параметры
	//  Выборка  - КоллекцияДанных - структура или выборка из результатов запроса
	//                 в которой содержатся дополнительные реквизиты, на основании
	//                 которых можно сформировать переопределенное представление до-
	//                 кумента для вывода в отчет "Структура подчиненности"
	//  ПредставлениеДокумента - Строка, Неопределено. Переопределенное представление документа, или Неопределено,
	//                           если для данного типа документов такое не задано.
	//
	// Синтаксис:
	// Процедура ПриПолученииПредставленияДокументаДляПечати(Выборка, ПредставлениеДокумента) Экспорт
	//
	// (То же, что СтруктураПодчиненностиПереопределяемый.ПолучитьПредставлениеДокументаДляПечати).
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.СтруктураПодчиненности\ПриПолученииПредставленияДокументаДляПечати");
	
КонецПроцедуры

