﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Файловые функции в модели сервиса".
//
////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Стандартный программный интерфейс

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.2.4";
	Обработчик.Процедура = "ФайловыеФункцииСлужебныйВМоделиСервиса.ЗаполнитьОчередьИзвлеченияТекста";
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Извлечение текста

// Добавляет и удаляет записи в регистр сведений ОчередьИзвлеченияТекста при изменении
// состояние извлечения текста версий файлов
//
// Параметры:
//	ИсточникТекста - СправочникСсылка.ВерсииФайлов, СправочникСсылка.*ПрисоединенныеФайлы,
//		файл, у которого изменилось состояние извлечения текста
//	СостояниеИзвлеченияТекста - ПеречислениеСсылка.СтатусыИзвлеченияТекстаФайлов, новый
//		статус извлечения текста у файла
//
Процедура ОбновитьСостояниеОчередиИзвлеченияТекста(ИсточникТекста, СостояниеИзвлеченияТекста) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ОчередьИзвлеченияТекста.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОбластьДанных.Установить(ОбщегоНазначения.ЗначениеРазделителяСеанса());
	НаборЗаписей.Отбор.ИсточникТекста.Установить(ИсточникТекста);
	
	Если СостояниеИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.НеИзвлечен
			ИЛИ СостояниеИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.ПустаяСсылка() Тогда
			
		Запись = НаборЗаписей.Добавить();
		Запись.ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		Запись.ИсточникТекста = ИсточникТекста.Ссылка;
			
	КонецЕсли;
		
	НаборЗаписей.Записать();
	
КонецПроцедуры // ОбновитьСостояниеОчередиИзвлеченияТекста()

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Извлечение текста

// Определяет перечень областей данных, в которых требуется извлечение текста и планирует
// для них его выполнение с использованием очереди заданий
//
Процедура ОбработатьОчередьИзвлеченияТекста() Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяРазделенногоМетода = Метаданные.РегламентныеЗадания.ИзвлечениеТекста.ИмяМетода;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОчередьИзвлеченияТекста.ОбластьДанных КАК ОбластьДанных,
	|	ОбластиДанных.ЧасовойПояс КАК ЧасовойПояс
	|ИЗ
	|	РегистрСведений.ОчередьИзвлеченияТекста КАК ОчередьИзвлеченияТекста
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбластиДанных КАК ОбластиДанных
	|		ПО ОчередьИзвлеченияТекста.ОбластьДанных = ОбластиДанных.ОбластьДанных
	|ГДЕ
	|	НЕ ОчередьИзвлеченияТекста.ОбластьДанных В (&ОбрабатываемыеОбластиДанных)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ОбрабатываемыеОбластиДанных", ОчередьЗаданий.ПолучитьТаблицуРегламентныхЗаданий(
				Новый Структура("ИмяМетода", ИмяРазделенногоМетода), Неопределено, Истина));
				
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НовоеЗадание = Новый Структура();
		НовоеЗадание.Вставить("Использование", Истина);
		НовоеЗадание.Вставить("ЗапланированныйМоментЗапуска", МестноеВремя(ТекущаяУниверсальнаяДата(), Выборка.ЧасовойПояс));
		НовоеЗадание.Вставить("ИмяМетода", ИмяРазделенногоМетода);
		ОчередьЗаданий.ДобавитьЗадание(НовоеЗадание, Выборка.ОбластьДанных);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет очередь извлечения текста для текущей области данных. Используется для начального заполнения при обновлении.
Процедура ЗаполнитьОчередьИзвлеченияТекста() Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = "";
	СтандартныеПодсистемыПереопределяемый.ПолучитьТекстЗапросаДляИзвлеченияТекста(ТекстЗапроса, Истина);
	Запрос = Новый Запрос(ТекстЗапроса);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбновитьСостояниеОчередиИзвлеченияТекста(Выборка.Ссылка, Выборка.СтатусИзвлеченияТекста);
	КонецЦикла;
	
КонецПроцедуры

