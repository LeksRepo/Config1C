﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Работа с шаблонами офисных документов

// Интерфейс для вызова из клиентских модулей печати форм по макетам офисных документов.
//
// Подробнее - см. описание УправлениеПечатью.ПолучитьМакетыИДанныеОбъектов().
//
Функция ПолучитьМакетыИДанныеОбъектов(знач ИмяМенеджераПечати, знач ИменаМакетов, знач СоставДокументов) Экспорт
	
	Возврат УправлениеПечатью.ПолучитьМакетыИДанныеОбъектов(ИмяМенеджераПечати, ИменаМакетов, СоставДокументов);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Сформировать печатные формы для непосредственного вывода на принтер
//
// Подробнее - см. описание УправлениеПечатью.СформироватьПечатныеФормыДляБыстройПечати().
//
Процедура СформироватьПечатныеФормыДляБыстройПечати(ИмяМенеджераПечати, ИменаМакетов, МассивОбъектов,
	ПараметрыПечати, ТабличныеДокументы, ОбъектыПечати, ПараметрыВывода, Отказ) Экспорт
	
	УправлениеПечатью.СформироватьПечатныеФормыДляБыстройПечати(
		ИмяМенеджераПечати,
		ИменаМакетов,
		МассивОбъектов,
		ПараметрыПечати,
		ТабличныеДокументы,
		ОбъектыПечати,
		ПараметрыВывода,
		Отказ);
	
КонецПроцедуры

// Сформировать печатные формы для непосредственного вывода на принтер в обычном приложении
//
// Подробнее - см. описание УправлениеПечатью.СформироватьПечатныеФормыДляБыстройПечатиОбычноеПриложение().
//
Процедура СформироватьПечатныеФормыДляБыстройПечатиОбычноеПриложение(ИмяМенеджераПечати, ИменаМакетов, МассивОбъектов,
	ПараметрыПечати, Адрес, ОбъектыПечати, ПараметрыВывода, Отказ) Экспорт
	
	УправлениеПечатью.СформироватьПечатныеФормыДляБыстройПечатиОбычноеПриложение(
		ИмяМенеджераПечати,
		ИменаМакетов,
		МассивОбъектов,
		ПараметрыПечати,
		Адрес,
		ОбъектыПечати,
		ПараметрыВывода,
		Отказ);
	
КонецПроцедуры

// Сохраняет во временное хранилище путь к каталогу, который используется при печати.
//
// Подробнее - см. описание УправлениеПечатью.СохранитьЛокальныйКаталогФайловПечати().
//
Процедура СохранитьЛокальныйКаталогФайловПечати(Каталог) Экспорт
	
	УправлениеПечатью.СохранитьЛокальныйКаталогФайловПечати(Каталог);
	
КонецПроцедуры

// Возвращает описание команды по имени элемента формы.
// 
// См. УправлениеПечатью.ОписаниеКомандыПечати
//
Функция ОписаниеКомандыПечати(ИмяКоманды, ИмяФормы) Экспорт
	
	Возврат УправлениеПечатью.ОписаниеКомандыПечати(ИмяКоманды, ИмяФормы);
	
КонецФункции
