﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает XDTO-тип, описывающий разрешения типа, соответствующего элементу кэша.
//
// Возвращаемое значение - ТипОбъектаXDTO.
//
Функция ТипXDTOПредставленияРазрешений() Экспорт
	
	Возврат ФабрикаXDTO.Тип(РаботаВБезопасномРежимеСлужебный.ПакетXDTOПредставленийРазрешений(), "ExternalModulePrivilegedModeAllowed");
	
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
			
			Ключ = Новый Структура("ВнешнийМодуль,Владелец", ВнешнийМодуль, Владелец);
			Если Таблица.НайтиСтроки(Ключ).Количество() = 0 Тогда
				Строка = Таблица.Добавить();
				Строка.ВнешнийМодуль = ВнешнийМодуль;
				Строка.Владелец = Владелец;
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
	
	Профиль.ПолныйДоступКПривилегированномуРежиму = Истина;
	
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
	            |	ИСТИНА КАК РазрешенПереходВПривилегированныйРежим,
	            |	РазрешенияПереходаВПривилегированныйРежим.Владелец КАК Владелец,
	            |	РазрешенияПереходаВПривилегированныйРежим.ВнешнийМодуль КАК ВнешнийМодуль
	            |ИЗ
	            |	РегистрСведений.РазрешенияПереходаВПривилегированныйРежим КАК РазрешенияПереходаВПривилегированныйРежим";
	
	Если СвернутьВладельцев Тогда
		Результат = СтрЗаменить(Результат, "РазрешенияПереходаВПривилегированныйРежим.Владелец КАК Владелец,", "");
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
		|	ИСТИНА КАК РазрешенПереходВПривилегированныйРежим,
		|	ВТ_До.ВнешнийМодуль
		|ИЗ
		|	ВТ_До КАК ВТ_До
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_После КАК ВТ_После
		|		ПО ВТ_До.ВнешнийМодуль = ВТ_После.ВнешнийМодуль
		|ГДЕ
		|	ВТ_После.ВнешнийМодуль ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИСТИНА КАК РазрешенПереходВПривилегированныйРежим,
		|	ВТ_После.ВнешнийМодуль
		|ИЗ
		|	ВТ_После КАК ВТ_После
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_До КАК ВТ_До
		|		ПО ВТ_После.ВнешнийМодуль = ВТ_До.ВнешнийМодуль
		|ГДЕ
		|	ВТ_До.ВнешнийМодуль ЕСТЬ NULL";
	
КонецФункции

#КонецОбласти

#КонецЕсли