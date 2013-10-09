﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Резервное копирование ИБ".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Устанавливает настройку в параметры резервного копирования. 
// 
// Параметры: 
//	ИмяЭлемента - Строка - имя параметра.
// 	ЗначениеЭлемента - Произвольный тип - значение параметра.
//
Процедура УстановитьЗначениеНастройки(ИмяЭлемента, ЗначениеЭлемента, ПараметрыРезервногоКопированияИБНаКлиенте) Экспорт
	
	РезервноеКопированиеИБСервер.УстановитьЗначениеНастройки(ИмяЭлемента, ЗначениеЭлемента, ПараметрыРезервногоКопированияИБНаКлиенте);
	
КонецПроцедуры

// Устанавливает значение ближайшего следующего автоматического резервного копирования в соответствии с расписанием.
//
// Параметры:
//	НачальнаяНастройка - Булево - признак начальной настройки.
//	ПараметрыРезервногоКопированияИБНаКлиенте - Структура - параметры резервного копирования.
//
Процедура УстановитьДатуСледующегоАвтоматическогоКопирования(ПараметрыРезервногоКопированияИБНаКлиенте, НачальнаяНастройка = Ложь) Экспорт
	
	РезервноеКопированиеИБСервер.УстановитьДатуСледующегоАвтоматическогоКопирования(ПараметрыРезервногоКопированияИБНаКлиенте, НачальнаяНастройка);
	
КонецПроцедуры

// Устанавливает дату последнего оповещения пользователя.
//
// Параметры: 
//	ДатаНапоминания - Дата - дата и время последнего оповещения пользователя о необходимости проведения резервного копирования.
//
Процедура УстановитьДатуПоследнегоНапоминания(ДатаНапоминания) Экспорт
	
	РезервноеКопированиеИБСервер.УстановитьДатуПоследнегоНапоминания(ДатаНапоминания);
	
КонецПроцедуры

// Возвращает признак доступности роли "ПолучениеНапоминанийОРезервномКопировании".
//
// Возвращаемое значение - Булево - доступность роли.
//
Функция ПолучитьДоступностьРолейОповещения() Экспорт
	
	Возврат РезервноеКопированиеИБСервер.ПолучитьДоступностьРолейОповещения();
	
КонецФункции

// Возвращает количество работающих с ИБ пользователей.
//
// Параметры: 
//	ТолькоАдминистраторы - Булево - признак того, что учитываются только работающие пользователи с административными правами.
//
// Возвращаемое значение - Число - количество работающих пользователей.
//
Функция ПолучитьКоличествоАктивныхПользователей(ТолькоАдминистраторы = Ложь) Экспорт
	
	Возврат РезервноеКопированиеИБСервер.ПолучитьКоличествоАктивныхПользователей(ТолькоАдминистраторы);
	
КонецФункции

// Останавливает механизм автоматического резервного копирования.
// Устанавливает пустое расписание и минимальную дату копирования в будущее время.
//
// Параметры:
//	ПроводитьПриЗавершении - Булево - признак проведения резервного копирования при завершении работы.
//	ПараметрыРезервногоКопированияИБНаКлиенте - Структура - параметры резервного копирования.
//
Процедура ОстановитьАвтоматическоеРезервноеКопирование(ПараметрыРезервногоКопированияИБНаКлиенте, ПроводитьПриЗавершении = Ложь) Экспорт
	
	РезервноеКопированиеИБСервер.ОстановитьАвтоматическоеРезервноеКопирование(ПараметрыРезервногоКопированияИБНаКлиенте, ПроводитьПриЗавершении);
	
КонецПроцедуры

// Устанавливает элемент "Код выбора" настроек резервного копирования.
//
// Параметры:  
//	КодПереключателя - Число - код переключателя. 
//	ПараметрыРезервногоКопированияИБНаКлиенте - Структура - параметры резервного копирования.
//
Процедура УстановитьКодВыбора(КодПереключателя, ПараметрыРезервногоКопированияИБНаКлиенте) Экспорт
	
	РезервноеКопированиеИБСервер.УстановитьКодВыбора(КодПереключателя, ПараметрыРезервногоКопированияИБНаКлиенте);
	
КонецПроцедуры

// Останавливает оповещения о резервном копировании.
//
// Параметры:
//	ПараметрыРезервногоКопированияИБНаКлиенте - Структура - параметры резервного копирования.
//
Процедура ОстановитьСервисОповещения(ПараметрыРезервногоКопированияИБНаКлиенте) Экспорт
	
	РезервноеКопированиеИБСервер.ОстановитьСервисОповещения(ПараметрыРезервногоКопированияИБНаКлиенте);
	
КонецПроцедуры

// Сохраняет параметры резервного копирования.
//
// Параметры:
//	СтруктураПараметров - Структура - параметры резервного копирования.
//
Процедура УстановитьПараметрыРезервногоКопирования(СтруктураПараметров) Экспорт
	
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(СтруктураПараметров);
	
КонецПроцедуры