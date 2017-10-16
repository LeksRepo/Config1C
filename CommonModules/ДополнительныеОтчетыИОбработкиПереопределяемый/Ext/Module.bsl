﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет разделы, в которых доступна команда вызова дополнительных обработок.
//
// Параметры:
//   Разделы - Массив - Разделы, в которых размещены команды вызова дополнительных обработок.
//       * ОбъектМетаданных: Подсистема - Метаданные раздела (подсистемы).
//       * Строка - Для рабочего стола.
//
// Описание:
//   В Разделы необходимо добавить метаданные тех разделов,
//   в которых размещены команды вызова.
//
//   Для рабочего стола вместо Метаданных необходимо добавлять 
//   ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола().
//
Процедура ОпределитьРазделыСДополнительнымиОбработками(Разделы) Экспорт
	
	
	
КонецПроцедуры

// Определяет разделы, в которых доступна команда вызова дополнительных отчетов.
//
// Параметры:
//   Разделы - Массив - Разделы, в которых размещены команды вызова дополнительных отчетов.
//       * ОбъектМетаданных: Подсистема - Метаданные раздела (подсистемы).
//       * Строка - Для рабочего стола.
//
// Описание:
//   В Разделы необходимо добавить метаданные тех разделов, 
//   в которых размещены команды вызова.
//
//   Для рабочего стола вместо Метаданных необходимо добавлять 
//   ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола().
//
Процедура ОпределитьРазделыСДополнительнымиОтчетами(Разделы) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
