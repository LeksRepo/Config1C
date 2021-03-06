﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает XDTO-тип, описывающий разрешения типа, соответствующего элементу кэша.
//
// Возвращаемое значение - ТипОбъектаXDTO.
//
Функция ТипXDTOПредставленияРазрешений() Экспорт
	
	Возврат ФабрикаXDTO.Тип(РаботаВБезопасномРежимеСлужебный.ПакетXDTOПредставленийРазрешений(), "InternetResourceAccess");
	
КонецФункции

// Формирует набор записей текущего регистра кэша из XDTO-представлений разрешения.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка,
//  Владелец - ЛюбаяСсылка,
//  XDTOПредставления - Массив(ОбъектXDTO).
//
// Возвращаемое значение - РегистрСведенийНаборЗаписей.
//
Функция НаборЗаписейИзXDTOПредставления(Знач XDTOПредставления, Знач ВнешнийМодуль, Знач Владелец, Знач ДляУдаления) Экспорт
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.ВнешнийМодуль.Установить(ВнешнийМодуль);
	Набор.Отбор.Владелец.Установить(Владелец);
	
	Если ДляУдаления Тогда
		
		Возврат Набор;
		
	Иначе
		
		Таблица = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ТаблицаРазрешений(СоздатьНаборЗаписей().Метаданные(), Истина);
		
		Для Каждого XDTOПредставление Из XDTOПредставления Цикл
			
			Псевдоним = НРег(XDTOПредставление.Protocol) + ":\\" + НРег(XDTOПредставление.Host) + ":" + Формат(XDTOПредставление.Port, "ЧГ=0");
			
			Ключ = Новый Структура("ВнешнийМодуль,Владелец,Псевдоним", ВнешнийМодуль, Владелец, Псевдоним);
			Если Таблица.НайтиСтроки(Ключ).Количество() = 0 Тогда
				
				Строка = Таблица.Добавить();
				Строка.ВнешнийМодуль = ВнешнийМодуль;
				Строка.Владелец = Владелец;
				Строка.Псевдоним = Псевдоним;
				Строка.Протокол = НРег(XDTOПредставление.Protocol);
				Строка.Адрес = НРег(XDTOПредставление.Host);
				Строка.Порт = НРег(XDTOПредставление.Port);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Набор.Загрузить(Таблица);
		Возврат Набор;
		
	КонецЕсли;
	
КонецФункции

// Заполняет описание профиля безопасности (в нотации программного интерфейса общего модуля
//  АдминистрированиеКластераКлиентСервер) по менеджеру записи текущего элемента кэша.
//
// Параметры:
//  Менеджер - РегистрСведенийМенеджерЗаписи,
//  Профиль - Структура.
//
Процедура ЗаполнитьСвойстваПрофиляБезопасностиВНотацииИнтерфейсаАдминистрирования(Знач Менеджер, Профиль) Экспорт
	
	ИнтернетРесурс = АдминистрированиеКластераКлиентСервер.СвойстваИнтернетРесурса();
	ИнтернетРесурс.Имя = Менеджер.Протокол + "://" + Менеджер.Адрес + ":" + Менеджер.Порт;
	ИнтернетРесурс.Протокол = Менеджер.Протокол;
	ИнтернетРесурс.Адрес = Менеджер.Адрес;
	ИнтернетРесурс.Порт = Менеджер.Порт;
	Профиль.ИнтернетРесурсы.Добавить(ИнтернетРесурс);
	
КонецПроцедуры

// Возвращает текст запроса для получения текущего среза разрешений по данному
//  элементу кэша.
//
// Параметры:
//  СвернутьВладельцев - Булево - флаг необходимости сворачивания результата запроса
//    по владельцам.
//
// Возвращаемое значение - Строка, текст запроса.
//
Функция ЗапросТекущегоСреза(Знач СвернутьВладельцев = Истина) Экспорт
	
	Результат = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	            |	РазрешенныеИнтернетРесурсы.Псевдоним,
	            |	РазрешенныеИнтернетРесурсы.Протокол,
	            |	РазрешенныеИнтернетРесурсы.Адрес,
	            |	РазрешенныеИнтернетРесурсы.Порт,
	            |	РазрешенныеИнтернетРесурсы.Владелец КАК Владелец,
	            |	РазрешенныеИнтернетРесурсы.ВнешнийМодуль
	            |ИЗ
	            |	РегистрСведений.РазрешенныеИнтернетРесурсы КАК РазрешенныеИнтернетРесурсы";
	
	Если СвернутьВладельцев Тогда
		Результат = СтрЗаменить(Результат, "РазрешенныеИнтернетРесурсы.Владелец КАК Владелец,", "");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает текст запроса для получения дельты измения разрешений по данному
//  элементу кэша.
//
// Возвращаемое значение - Строка, текст запроса.
//
Функция ЗапросПолученияДельты() Экспорт
	
	Возврат
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_До.Псевдоним,
		|	ВТ_До.Протокол,
		|	ВТ_До.Адрес,
		|	ВТ_До.Порт,
		|	ВТ_До.ВнешнийМодуль
		|ИЗ
		|	ВТ_До КАК ВТ_До ЛЕВОЕ СОЕДИНЕНИЕ ВТ_После КАК ВТ_После
		|		ПО ВТ_До.ВнешнийМодуль = ВТ_После.ВнешнийМодуль
		|			И ВТ_До.Псевдоним = ВТ_После.Псевдоним
		|ГДЕ
		|	ВТ_После.Псевдоним ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_После.Псевдоним,
		|	ВТ_После.Протокол,
		|	ВТ_После.Адрес,
		|	ВТ_После.Порт,
		|	ВТ_После.ВнешнийМодуль
		|ИЗ
		|	ВТ_После КАК ВТ_После ЛЕВОЕ СОЕДИНЕНИЕ ВТ_До КАК ВТ_До
		|		ПО ВТ_После.ВнешнийМодуль = ВТ_До.ВнешнийМодуль
		|			И ВТ_После.Псевдоним = ВТ_До.Псевдоним
		|ГДЕ
		|	ВТ_До.Псевдоним ЕСТЬ NULL";
	
КонецФункции

#КонецОбласти

#КонецЕсли