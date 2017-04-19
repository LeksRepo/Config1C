﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура обновляет общие параметры работы пользователей при изменении конфигурации.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьОбщиеПараметры(ЕстьИзменения = Неопределено, ТолькоПроверка = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТолькоПроверка ИЛИ МонопольныйРежим() Тогда
		СнятьМонопольныйРежим = Ложь;
	Иначе
		СнятьМонопольныйРежим = Истина;
		УстановитьМонопольныйРежим(Истина);
	КонецЕсли;
	
	НеразделенныеДанныеДоступныеДляИзменения = НеразделенныеДанныеДоступныеДляИзменения();
	
	НедоступныеРолиПоТипамПользователей = НедоступныеРолиПоТипамПользователей(
		НеразделенныеДанныеДоступныеДляИзменения.Таблица);
	
	ВсеРоли = ВсеРоли();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Константа.ПараметрыРаботыПользователей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Параметры = ОбновлениеИнформационнойБазы.ПараметрыРаботыПрограммы(
			"ПараметрыРаботыПользователей");
		
		// Проверка и обновление параметра НеразделенныеДанныеДоступныеДляИзменения.
		Сохраненные = Неопределено;
		
		Если Параметры.Свойство("НеразделенныеДанныеДоступныеДляИзменения") Тогда
			Сохраненные = Параметры.НеразделенныеДанныеДоступныеДляИзменения;
			
			Если НЕ ОбщегоНазначения.ДанныеСовпадают(
			          НеразделенныеДанныеДоступныеДляИзменения.ПоРолям, Сохраненные) Тогда
				
				Сохраненные = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		Если Сохраненные = Неопределено Тогда
			ЕстьИзменения = Истина;
			Если ТолькоПроверка Тогда
				ЗафиксироватьТранзакцию();
				Возврат;
			КонецЕсли;
			ОбновлениеИнформационнойБазы.УстановитьПараметрРаботыПрограммы(
				"ПараметрыРаботыПользователей",
				"НеразделенныеДанныеДоступныеДляИзменения",
				НеразделенныеДанныеДоступныеДляИзменения.ПоРолям);
		КонецЕсли;
		
		// Проверка и обновление параметра НедоступныеРолиПоТипамПользователей.
		Сохраненные = Неопределено;
		
		Если Параметры.Свойство("НедоступныеРолиПоТипамПользователей") Тогда
			Сохраненные = Параметры.НедоступныеРолиПоТипамПользователей;
			
			Если НЕ ОбщегоНазначения.ДанныеСовпадают(
			          НедоступныеРолиПоТипамПользователей, Сохраненные) Тогда
				
				Сохраненные = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		Если Сохраненные = Неопределено Тогда
			ЕстьИзменения = Истина;
			Если ТолькоПроверка Тогда
				ЗафиксироватьТранзакцию();
				Возврат;
			КонецЕсли;
			ОбновлениеИнформационнойБазы.УстановитьПараметрРаботыПрограммы(
				"ПараметрыРаботыПользователей",
				"НедоступныеРолиПоТипамПользователей",
				НедоступныеРолиПоТипамПользователей);
		КонецЕсли;
		
		// Проверка и обновление параметра ВсеРоли.
		Сохраненные = Неопределено;
		
		Если Параметры.Свойство("ВсеРоли") Тогда
			Сохраненные = Параметры.ВсеРоли;
			
			Если НЕ ОбщегоНазначения.ДанныеСовпадают(ВсеРоли, Сохраненные) Тогда
				Сохраненные = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		Если Сохраненные = Неопределено Тогда
			ЕстьИзменения = Истина;
			Если ТолькоПроверка Тогда
				ЗафиксироватьТранзакцию();
				Возврат;
			КонецЕсли;
			ОбновлениеИнформационнойБазы.УстановитьПараметрРаботыПрограммы(
				"ПараметрыРаботыПользователей",
				"ВсеРоли",
				ВсеРоли);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Если СнятьМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	Если СнятьМонопольныйРежим Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция НедоступныеРолиПоТипамПользователей(НеразделенныеДанныеДоступныеДляИзменения)
	
	НедоступныеПрава                         = НедоступныеПраваПоТипамПользователей();
	РазрешеноИзменениеОбщихДанных            = РазрешеноИзменениеОбщихДанных();
	
	НедоступныеРолиПоТипамПользователей = Новый Соответствие;
	
	Для каждого ТипПользователей Из Перечисления.ТипыПользователей Цикл
		НедоступныеРоли = Новый Соответствие;
		
		Для каждого Роль Из Метаданные.Роли Цикл
			ИмяРоли = Роль.Имя;
			Итог = Новый Структура;
			НайденныеНедоступныеПрава = Новый Массив;
			Если НедоступныеПрава[ТипПользователей] <> Неопределено Тогда
				Для каждого КлючИЗначение Из НедоступныеПрава[ТипПользователей] Цикл
					Если ПравоДоступа(КлючИЗначение.Ключ, Метаданные, Роль) Тогда
						НайденныеНедоступныеПрава.Добавить(КлючИЗначение.Значение);
					КонецЕсли;
				КонецЦикла;
				Если НайденныеНедоступныеПрава.Количество() > 0 Тогда
					Итог.Вставить("Права", НайденныеНедоступныеПрава);
				КонецЕсли;
			КонецЕсли;
			
			Если РазрешеноИзменениеОбщихДанных[ТипПользователей] <> Истина Тогда
				Отбор = Новый Структура("Роль", ИмяРоли);
				НайденныеСтроки = НеразделенныеДанныеДоступныеДляИзменения.НайтиСтроки(Отбор);
				Если НайденныеСтроки.Количество() > 0 Тогда
					
					ИзменяемыеНеразделенныеДанные =
						НеразделенныеДанныеДоступныеДляИзменения.Скопировать(
							НайденныеСтроки, "Объект, Право");
					
					ИзменяемыеНеразделенныеДанные.Свернуть("Объект, Право");
					Итог.Вставить("ИзменяемыеНеразделенныеДанные", ИзменяемыеНеразделенныеДанные);
				КонецЕсли;
			КонецЕсли;
			
			Если Итог.Количество() > 0 Тогда
				НедоступныеРоли.Вставить(ИмяРоли, Итог);
			КонецЕсли;
		КонецЦикла;
		
		НедоступныеРолиПоТипамПользователей.Вставить(ТипПользователей, НедоступныеРоли);
	КонецЦикла;
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(НедоступныеРолиПоТипамПользователей, Ложь);
	
КонецФункции

// Возвращает таблицу полных имен неразделенных объектов метаданных и
// соответствующих им наборов прав доступа.
//
// Параметры:
// ИмяРоли - Строка.
//
// Возвращаемое значение:
// ТаблицаЗначений с колонками: 
//  Имя   - Строка - Полное имя объекта метаданных.
//  Право - Строка - Имя права доступа.
//
Функция НеразделенныеДанныеДоступныеДляИзменения()
	
	ВидыМетаданных = Новый Массив;
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.ПланыОбмена, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Константы, Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Справочники, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Последовательности, Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Документы, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.ПланыВидовХарактеристик, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.ПланыСчетов, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.ПланыВидовРасчета, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.БизнесПроцессы, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Задачи, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.РегистрыСведений, Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.РегистрыНакопления, Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.РегистрыБухгалтерии, Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.РегистрыРасчета, Ложь));
	
	ПроверяемыеПрава = Новый Массив;
	ПроверяемыеПрава.Добавить(Новый Структура("Имя, Ссылочное", "Изменение",  Ложь));
	ПроверяемыеПрава.Добавить(Новый Структура("Имя, Ссылочное", "Добавление", Истина));
	ПроверяемыеПрава.Добавить(Новый Структура("Имя, Ссылочное", "Удаление",   Истина));
	
	ОбщаяТаблица = Новый ТаблицаЗначений;
	ОбщаяТаблица.Колонки.Добавить("Роль",   Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	ОбщаяТаблица.Колонки.Добавить("Объект", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	ОбщаяТаблица.Колонки.Добавить("Право",  Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	
	ПоРолям = Новый Соответствие;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса") Тогда
		
		МодульРаботаВМоделиСервисаПовтИсп = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РаботаВМоделиСервисаПовтИсп");
		МодельДанных = МодульРаботаВМоделиСервисаПовтИсп.ПолучитьМодельДанныхОбласти();
		
		РазделенныеОбъектыМетаданных = Новый Соответствие();
		Для Каждого ЭлементМоделиДанных Из МодельДанных Цикл
			
			РазделенныеОбъектыМетаданных.Вставить(ЭлементМоделиДанных.Ключ, Истина);
			
		КонецЦикла;
		
		Для каждого Роль Из Метаданные.Роли Цикл
			ИмяРоли = Роль.Имя;
			
			ТаблицаОбъектов = Новый ТаблицаЗначений;
			ТаблицаОбъектов.Колонки.Добавить("Объект", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
			ТаблицаОбъектов.Колонки.Добавить("Право",  Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
			
			Для Каждого ОписаниеВида Из ВидыМетаданных Цикл // По видам метаданных.
				Для Каждого ОбъектМетаданных Из ОписаниеВида.Вид Цикл // По объектам вида.
					
					ПолноеИмяОбъектаМетаданных = ОбъектМетаданных.ПолноеИмя();
					Если РазделенныеОбъектыМетаданных.Получить(ПолноеИмяОбъектаМетаданных) = Неопределено Тогда
						
						Для каждого ОписаниеПрава Из ПроверяемыеПрава Цикл
							Если НЕ ОписаниеПрава.Ссылочное
								ИЛИ ОписаниеВида.Ссылочный Тогда
								
								Если ПравоДоступа(ОписаниеПрава.Имя, ОбъектМетаданных, Роль) Тогда
									// Общая таблица объектов по ролей.
									СтрокаПрава = ОбщаяТаблица.Добавить();
									СтрокаПрава.Роль   = ИмяРоли;
									СтрокаПрава.Объект = ПолноеИмяОбъектаМетаданных;
									СтрокаПрава.Право  = ОписаниеПрава.Имя;
									// Таблица объектов по ролям.
									СтрокаПрава = ТаблицаОбъектов.Добавить();
									СтрокаПрава.Объект = ПолноеИмяОбъектаМетаданных;
									СтрокаПрава.Право  = ОписаниеПрава.Имя;
								КонецЕсли;
								
							КонецЕсли;
						КонецЦикла;
						
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
			Если ТаблицаОбъектов.Количество() > 0 Тогда
				ПоРолям.Вставить(ИмяРоли, ТаблицаОбъектов);
			КонецЕсли;
		КонецЦикла;
		
		
	КонецЕсли;
	
	ОбщаяТаблица.Индексы.Добавить("Роль");
	
	Итог = Новый Структура;
	Итог.Вставить("Таблица", ОбщаяТаблица);
	Итог.Вставить("ПоРолям", ПоРолям);
	
	Возврат Итог;
	
КонецФункции

Функция НедоступныеПраваПоТипамПользователей()
	
	НедоступныеПрава = Новый Соответствие;
	
	Права = Новый Соответствие;
	НедоступныеПрава.Вставить(Перечисления.ТипыПользователей.ВнешнийПользователь, Права);
	Права.Вставить("Администрирование",       НСтр("ru = 'Администрирование'"));
	Права.Вставить("АдминистрированиеДанных", НСтр("ru = 'Администрирование данных'"));
	
	Права = Новый Соответствие;
	НедоступныеПрава.Вставить(Перечисления.ТипыПользователей.ПользовательОбластиДанных, Права);
	Права.Вставить("Администрирование",                     НСтр("ru = 'Администрирование'"));
	Права.Вставить("ОбновлениеКонфигурацииБазыДанных",      НСтр("ru = 'Обновление конфигурации базы данных'"));
	Права.Вставить("МонопольныйРежим",                      НСтр("ru = 'Монопольный режим'"));
	Права.Вставить("ТолстыйКлиент",                         НСтр("ru = 'Толстый клиент'"));
	Права.Вставить("ВнешнееСоединение",                     НСтр("ru = 'Внешнее соединение'"));
	Права.Вставить("Automation",                            НСтр("ru = 'Automation'"));
	Права.Вставить("ИнтерактивноеОткрытиеВнешнихОбработок", НСтр("ru = 'Интерактивное открытие внешних обработок'"));
	Права.Вставить("ИнтерактивноеОткрытиеВнешнихОтчетов",   НСтр("ru = 'Интерактивное открытие внешних отчетов'"));
	Права.Вставить("РежимВсеФункции",                       НСтр("ru = 'Режим все функции'"));
	
	Возврат НедоступныеПрава;
	
КонецФункции

Функция РазрешеноИзменениеОбщихДанных()
	
	Итог = Новый Соответствие;
	
	Итог.Вставить(Перечисления.ТипыПользователей.ВнешнийПользователь,           Истина);
	Итог.Вставить(Перечисления.ТипыПользователей.ПользовательЛокальногоРешения, Истина);
	Итог.Вставить(Перечисления.ТипыПользователей.ПользовательОбластиДанных,     Ложь);
	
	Возврат Итог;
	
КонецФункции

Функция ВсеРоли()
	
	Массив = Новый Массив;
	Соответствие = Новый Соответствие;
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(256)));
	
	Для каждого Роль Из Метаданные.Роли Цикл
		ИмяРоли = Роль.Имя;
		
		Массив.Добавить(ИмяРоли);
		Соответствие.Вставить(ИмяРоли, Истина);
		Таблица.Добавить().Имя = ИмяРоли;
	КонецЦикла;
	
	ВсеРоли = Новый Структура;
	ВсеРоли.Вставить("Массив",       Новый ФиксированныйМассив(Массив));
	ВсеРоли.Вставить("Соответствие", Новый ФиксированноеСоответствие(Соответствие));
	ВсеРоли.Вставить("Таблица",      Таблица);
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ВсеРоли, Ложь);
	
КонецФункции

#КонецЕсли