﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Резервное копирование ИБ".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// КЛИЕНТСКИЕ ОБРАБОТЧИКИ.
	
	КлиентскиеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПолученииСпискаПредупрежденийЗавершенияРаботы"].Добавить(
			"РезервноеКопированиеИБКлиент");
	
	КлиентскиеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриНачалеРаботыСистемы"].Добавить(
			"РезервноеКопированиеИБКлиент");
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗавершении"].Добавить(
		"РезервноеКопированиеИБСервер");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗапуске"].Добавить(
		"РезервноеКопированиеИБСервер");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистем"].Добавить(
		"РезервноеКопированиеИБСервер");
		
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"РезервноеКопированиеИБСервер");
		
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриВключенииИспользованияПрофилейБезопасности"].Добавить(
		"РезервноеКопированиеИБСервер");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает параметры подсистемы РезервногоКопированияИБ, которые необходимы при завершении работы
// пользователей.
//
// Возвращаемое значение:
//	Структура - параметры.
//
Функция ПараметрыПриЗавершенииРаботы()
	
	НастройкиРезервногоКопирования = НастройкиРезервногоКопирования();
	ВыполнятьПриЗавершенииРаботы = ?(НастройкиРезервногоКопирования = Неопределено, Ложь,
		НастройкиРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование
		И НастройкиРезервногоКопирования.ВариантВыполнения = "ПриЗавершенииРаботы");
	
	ПараметрыПриЗавершении = Новый Структура;
	ПараметрыПриЗавершении.Вставить("ДоступностьРолейОповещения",   ЕстьПраваНаОповещениеОНастройкеРезервногоКопирования());
	ПараметрыПриЗавершении.Вставить("ВыполнятьПриЗавершенииРаботы", ВыполнятьПриЗавершенииРаботы);
	
	Возврат ПараметрыПриЗавершении;
	
КонецФункции

// Возвращает значение периода по заданному интервалу времени.
//
// Параметры:
//	ИнтервалВремени - Число - интервал времени в секундах.
//	
// Возвращаемое значение - Структура с полями:
//	ТипПериода - Строка - тип периода: День, Неделя, Месяц, Год.
//	ЗначениеПериода - Число - длина периода для заданного типа.
//
Функция ЗначениеПериодаПоИнтервалуВремени(ИнтервалВремени)
	
	ВозвращаемаяСтруктура = Новый Структура("ТипПериода, ЗначениеПериода", "Месяц", 1);
	
	Если ИнтервалВремени = Неопределено Тогда 
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;	
	
	Если Цел(ИнтервалВремени / (3600 * 24 * 365)) > 0 Тогда 
		ВозвращаемаяСтруктура.ТипПериода		= "Год";
		ВозвращаемаяСтруктура.ЗначениеПериода	= ИнтервалВремени / (3600 * 24 * 365);
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Если Цел(ИнтервалВремени / (3600 * 24 * 30)) > 0 Тогда 
		ВозвращаемаяСтруктура.ТипПериода		= "Месяц";
		ВозвращаемаяСтруктура.ЗначениеПериода	= ИнтервалВремени / (3600 * 24 * 30);
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Если Цел(ИнтервалВремени / (3600 * 24 * 7)) > 0 Тогда 
		ВозвращаемаяСтруктура.ТипПериода		= "Неделя";
		ВозвращаемаяСтруктура.ЗначениеПериода	= ИнтервалВремени / (3600 * 24 * 7);
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Если Цел(ИнтервалВремени / (3600 * 24)) > 0 Тогда 
		ВозвращаемаяСтруктура.ТипПериода		= "День";
		ВозвращаемаяСтруктура.ЗначениеПериода	= ИнтервалВремени / (3600 * 24);
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции

// Возвращает сохраненные параметры резервного копирования.
//
// Возвращаемое значение - Структура - параметры резервного копирования.
//
Функция ПараметрыРезервногоКопирования() Экспорт
	
	Параметры = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПараметрыРезервногоКопирования");
	Если Параметры = Неопределено Тогда
		Параметры = НачальноеЗаполнениеНастроекРезервногоКопирования();
	Иначе
		ПривестиПараметрыРезервногоКопирования(Параметры);
	КонецЕсли;
	Возврат Параметры;
	
КонецФункции

// Приводит параметры резервного копирования.
// Если в текущих параметрах резервного копирования нет параметра, который есть в 
// функции "НачальноеЗаполнениеНастроекРезервногоКопирования", то он добавляется со значением по умолчанию.
//
// Параметры:
//	ПараметрыРезервногоКопирования - Структура - параметры резервного копирования ИБ.
//
Процедура ПривестиПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования)
	
	ПараметрыИзменены = Ложь;
	
	Параметры = НачальноеЗаполнениеНастроекРезервногоКопирования(Ложь);
	Для Каждого ЭлементСтруктуры Из Параметры Цикл
		НайденноеЗначение = Неопределено;
		Если ПараметрыРезервногоКопирования.Свойство(ЭлементСтруктуры.Ключ, НайденноеЗначение) Тогда
			Если НайденноеЗначение = Неопределено И ЭлементСтруктуры.Значение <> Неопределено Тогда
				ПараметрыРезервногоКопирования.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
				ПараметрыИзменены = Истина;
			КонецЕсли;
		Иначе
			Если ЭлементСтруктуры.Значение <> Неопределено Тогда
				ПараметрыРезервногоКопирования.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
				ПараметрыИзменены = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПараметрыИзменены Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

// Сохраняет параметры резервного копирования.
//
// Параметры:
//	СтруктураПараметров - Структура - параметры резервного копирования.
//
Процедура УстановитьПараметрыРезервногоКопирования(СтруктураПараметров) Экспорт
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПараметрыРезервногоКопирования", , СтруктураПараметров);
КонецПроцедуры

// Проверяет, не настало ли время проводить автоматическое резервное копирование.
//
// Возвращаемое значение:
//   Булево - Истина, если настал момент проведения резервного копирования.
//
Функция НеобходимостьАвтоматическогоРезервногоКопирования() Экспорт
	
	Если Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Параметры = ПараметрыРезервногоКопирования();
	Если Параметры = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	Расписание = Параметры.РасписаниеКопирования;
	Если Расписание = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ПроцессВыполняется") Тогда 
		Если Параметры.ПроцессВыполняется Тогда 
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ДатаПроверки = ТекущаяДатаСеанса();
	Если Параметры.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования > ДатаПроверки Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДатаНачалаПроверки = Параметры.ДатаПоследнегоРезервногоКопирования;
	РасписаниеЗначение = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание);
	Возврат РасписаниеЗначение.ТребуетсяВыполнение(ДатаПроверки, ДатаНачалаПроверки);
	
КонецФункции

// Формирует даты ближайшего следующего автоматического резервного копирования в соответствии с расписанием.
//
// Параметры:
//	НачальнаяНастройка - Булево - признак начальной настройки.
//
Функция СформироватьДатыСледующегоАвтоматическогоКопирования(НачальнаяНастройка = Ложь) Экспорт
	
	Результат = Новый Структура;
	НастройкиРезервногоКопирования = НастройкиРезервногоКопирования();
	
	ТекущаяДата = ТекущаяДатаСеанса();
	Если НачальнаяНастройка Тогда
		Результат.Вставить("МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования", ТекущаяДата);
		Результат.Вставить("ДатаПоследнегоРезервногоКопирования", ТекущаяДата);
	Иначе
		РасписаниеКопирования = НастройкиРезервногоКопирования.РасписаниеКопирования;
		ПериодПовтораВТечениеДня = РасписаниеКопирования.ПериодПовтораВТечениеДня;
		ПериодПовтораДней = РасписаниеКопирования.ПериодПовтораДней;
		
		Если ПериодПовтораВТечениеДня <> 0 Тогда
			Значение = ТекущаяДата + ПериодПовтораВТечениеДня;
		ИначеЕсли ПериодПовтораДней <> 0 Тогда
			Значение = ТекущаяДата + ПериодПовтораДней * 3600 * 24;
		Иначе
			Значение = НачалоДня(КонецДня(ТекущаяДата) + 1);
		КонецЕсли;
		Результат.Вставить("МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования", Значение);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(НастройкиРезервногоКопирования, Результат);
	УстановитьПараметрыРезервногоКопирования(НастройкиРезервногоКопирования);
	
	Возврат Результат;
	
КонецФункции

// Возвращает значение настройки "Статус резервного копирования" в части результата.
// Используется при начале работы системы для показа формы с результатами резервного копирования.
//
Процедура УстановитьРезультатРезервногоКопирования() Экспорт
	
	СтруктураПараметров = НастройкиРезервногоКопирования();
	СтруктураПараметров.ПроведеноКопирование = Ложь;
	УстановитьПараметрыРезервногоКопирования(СтруктураПараметров);
	
КонецПроцедуры

// Устанавливает значение настройки "ДатаПоследнегоРезервногоКопирования".
//
// Параметры: 
//   ДатаКопирования - дата и время последнего резервного копирования.
//
Процедура УстановитьДатуПоследнегоКопирования(ДатаКопирования) Экспорт
	
	СтруктураПараметров = ПараметрыРезервногоКопирования();
	СтруктураПараметров.ДатаПоследнегоРезервногоКопирования = ДатаКопирования;
	УстановитьПараметрыРезервногоКопирования(СтруктураПараметров);
	
КонецПроцедуры

// Возвращает количество работающих с ИБ пользователей.
//
// Параметры: 
//	ТолькоАдминистраторы - Булево - признак того, что учитываются только работающие пользователи с административными правами.
//
// Возвращаемое значение - Число - количество работающих пользователей.
//
Функция КоличествоАктивныхПользователей(ТолькоАдминистраторы = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СеансыИнформационнойБазы  = ПолучитьСеансыИнформационнойБазы();
	Если Не ТолькоАдминистраторы Тогда
		Возврат СеансыИнформационнойБазы.Количество();
	КонецЕсли;
	
	Если ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() = 0 Тогда
		Возврат 1;
	КонецЕсли;
	
	КоличествоАдминистраторов = 0;
	Для Каждого Сеанс Из СеансыИнформационнойБазы Цикл
		
		Если Сеанс.Пользователь = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Сеанс.ИмяПриложения = "Designer" Тогда
			Продолжить;
		КонецЕсли;
		
		Если Сеанс.Пользователь.Роли.Содержит(Метаданные.Роли.ПолныеПрава) Тогда
			КоличествоАдминистраторов = КоличествоАдминистраторов + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КоличествоАдминистраторов;
	
КонецФункции

// Устанавливает дату последнего оповещения пользователя.
//
// Параметры: 
//	ДатаНапоминания - Дата - дата и время последнего оповещения пользователя о необходимости проведения резервного копирования.
//
Процедура УстановитьДатуПоследнегоНапоминания(ДатаНапоминания) Экспорт
	
	ПараметрыОповещений = ПараметрыРезервногоКопирования();
	ПараметрыОповещений.ДатаПоследнегоОповещения = ДатаНапоминания;
	УстановитьПараметрыРезервногоКопирования(ПараметрыОповещений);
	
КонецПроцедуры

// Устанавливает настройку в параметры резервного копирования. 
// 
// Параметры: 
//	ИмяЭлемента - Строка - имя параметра.
// 	ЗначениеЭлемента - Произвольный тип - значение параметра.
//
Процедура УстановитьЗначениеНастройки(ИмяЭлемента, ЗначениеЭлемента) Экспорт
	
	СтруктураНастроек = ПараметрыРезервногоКопирования();
	СтруктураНастроек.Вставить(ИмяЭлемента, ЗначениеЭлемента);
	УстановитьПараметрыРезервногоКопирования(СтруктураНастроек);
	
КонецПроцедуры

// Возвращает структуру с параметрами резервного копирования.
// 
// Параметры: 
//	НачалоРаботы - Булево - признак вызова при начале работы программы.
//
// Возвращаемое значение:
//  Структура - параметры резервного копирования.
//
Функция НастройкиРезервногоКопирования(НачалоРаботы = Ложь) Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Неопределено; // Не выполнен вход в область данных.
	КонецЕсли;
	
	Если Не ЕстьПраваНаОповещениеОНастройкеРезервногоКопирования() Тогда
		Возврат Неопределено; // Текущий пользователь не обладает необходимыми правами.
	КонецЕсли;
	
	Результат = ПараметрыРезервногоКопирования();
	
	ВариантОповещения = ВариантОповещения();
	
	Результат.Вставить("ПараметрОповещения", ВариантОповещения);
	Если Результат.ПроведеноКопирование И Результат.РезультатКопирования  Тогда
		УстановитьДатуПоследнегоКопирования(ТекущаяДатаСеанса());
	КонецЕсли;
	
	Если Результат.ПроведеноВосстановление Тогда
		ОбновитьРезультатВосстановления();
	КонецЕсли;
	
	Если НачалоРаботы И Результат.ПроцессВыполняется Тогда
		Результат.ПроцессВыполняется = Ложь;
		УстановитьЗначениеНастройки("ПроцессВыполняется", Ложь);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обновляет результат восстановления и обновляет структуру параметров резервного копирования. 
//
Процедура ОбновитьРезультатВосстановления()
	
	СтруктураВозврата = ПараметрыРезервногоКопирования();
	СтруктураВозврата.ПроведеноВосстановление = Ложь;
	УстановитьПараметрыРезервногоКопирования(СтруктураВозврата);
	
КонецПроцедуры

// Выбирает, какой вариант оповещения показать пользователю.
// Вызывается из формы помощника резервного копирования для определения стартовой формы.
//
// Возвращаемое значение: 
//   Строка:
//     "Недоступно" - автоматическое резервное копирование недоступно текущему пользователю.
//     "Просрочено" - просрочено автоматическое резервное копирование.
//     "ЕщеНеНастроено" - резервное копирование еще не настроено.
//     "НеОповещать" - не оповещать о необходимости выполнения резервного копирования (например, если выполняется сторонними средствами)
//
Функция ВариантОповещения() Экспорт
	
	Результат = "Недоступно";
	Если Не ЕстьПраваНаОповещениеОНастройкеРезервногоКопирования() Тогда
		Возврат Результат;
	КонецЕсли;
	
	ПараметрыОповещенияОКопировании = ПараметрыРезервногоКопирования();
	ОповещатьОНеобходимостиРезервногоКопирования = ТекущаяДатаСеанса() >= (ПараметрыОповещенияОКопировании.ДатаПоследнегоОповещения + 3600 * 24);
	
	Если ПараметрыОповещенияОКопировании.ВыполнятьАвтоматическоеРезервноеКопирование Тогда
		
		Если НеобходимостьАвтоматическогоРезервногоКопирования() Тогда
			Результат = "Просрочено";
		КонецЕсли;
		
	ИначеЕсли Не ПараметрыОповещенияОКопировании.РезервноеКопированиеНастроено Тогда
		
		Если ОповещатьОНеобходимостиРезервногоКопирования Тогда
			Результат = "ЕщеНеНастроено";
		КонецЕсли;
		
	Иначе
		
		Результат = "НеОповещать";
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает начальное заполнение настроек автоматического резервного копирования.
//
// Параметры:
//	СохранятьПараметры - сохранять или нет параметры в хранилище настроек.
//
// Возвращаемое значение - Структура - начальное заполнение параметров резервного копирования.
//
Функция НачальноеЗаполнениеНастроекРезервногоКопирования(СохранятьПараметры = Истина) Экспорт
	
	Параметры = Новый Структура;
	
	Параметры.Вставить("ВыполнятьАвтоматическоеРезервноеКопирование", Ложь);
	Параметры.Вставить("РезервноеКопированиеНастроено", Ложь);
	
	Параметры.Вставить("ДатаПоследнегоОповещения", '00010101');
	Параметры.Вставить("ДатаПоследнегоРезервногоКопирования", '00010101');
	Параметры.Вставить("МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования", '29990101');
	
	Параметры.Вставить("РасписаниеКопирования", ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Новый РасписаниеРегламентногоЗадания));
	Параметры.Вставить("КаталогХраненияРезервныхКопий", "");
	Параметры.Вставить("ПроведеноКопирование", Ложь);
	Параметры.Вставить("ПроведеноВосстановление", Ложь);
	Параметры.Вставить("РезультатКопирования", Неопределено);
	Параметры.Вставить("ИмяФайлаРезервнойКопии", "");
	Параметры.Вставить("ВариантВыполнения", "ПоРасписанию");
	Параметры.Вставить("ПроцессВыполняется", Ложь);
	Параметры.Вставить("АдминистраторИБ", "");
	Параметры.Вставить("ПарольАдминистратораИБ", "");
	Параметры.Вставить("ПараметрыУдаления", ПараметрыУдаленияРезервныхКопийПоУмолчанию());
	Параметры.Вставить("РучнойЗапускПоследнегоРезервногоКопирования", Истина);
	
	Если СохранятьПараметры Тогда
		УстановитьПараметрыРезервногоКопирования(Параметры);
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

// Возвращает признак наличия у пользователя полных прав.
//
// Возвращаемое значение - Булево - Истина, если это полноправный пользователь.
//
Функция ЕстьПраваНаОповещениеОНастройкеРезервногоКопирования() Экспорт
	Возврат Пользователи.ЭтоПолноправныйПользователь(,Истина);
КонецФункции

// Процедура, вызываемая из скрипта через com-соединение.
// Записывает результат проведенного копирования в настройки.
// 
// Параметры:
//	Результат - Булево - результат копирования.
//	ИмяФайлаРезервнойКопии - Строка - имя файла резервной копии.
//
Процедура ЗавершитьРезервноеКопирование(Результат, ИмяФайлаРезервнойКопии =  "") Экспорт
	
	СтруктураРезультата = НастройкиРезервногоКопирования();
	СтруктураРезультата.ПроведеноКопирование = Истина;
	СтруктураРезультата.РезультатКопирования = Результат;
	СтруктураРезультата.ИмяФайлаРезервнойКопии = ИмяФайлаРезервнойКопии;
	УстановитьПараметрыРезервногоКопирования(СтруктураРезультата);
	
КонецПроцедуры

// Вызывается из скрипта через com-соединение для
// записи результата проведенного восстановления ИБ в настройки.
//
// Параметры:
//	Результат - Булево - результат восстановления.
//
Процедура ЗавершитьВосстановление(Результат) Экспорт
	
	СтруктураРезультата = НастройкиРезервногоКопирования();
	СтруктураРезультата.ПроведеноВосстановление = Истина;
	УстановитьПараметрыРезервногоКопирования(СтруктураРезультата);
	
КонецПроцедуры

// Возвращает текущую настройку резервного копирования строкой
// Два варианта использования функции - или с передачей всех параметров или без параметров
//
Функция ТекущаяНастройкаРезервногоКопирования() Экспорт
	
	НастройкиРезервногоКопирования = НастройкиРезервногоКопирования();
	Если НастройкиРезервногоКопирования = Неопределено Тогда
		Возврат НСтр("ru = 'Для настройки резервного копирования необходимо обратиться к администратору.'");
	КонецЕсли;
	
	ТекущаяНастройка = НСтр("ru = 'Резервное копирование не настроено, информационная база подвергается риску потери данных.'");
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		Если НастройкиРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование Тогда
			
			Если НастройкиРезервногоКопирования.ВариантВыполнения = "ПриЗавершенииРаботы" Тогда
				ТекущаяНастройка = НСтр("ru = 'Резервное копирование выполняется регулярно при завершении работы.'");
			ИначеЕсли НастройкиРезервногоКопирования.ВариантВыполнения = "ПоРасписанию" Тогда // По расписанию
				Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(НастройкиРезервногоКопирования.РасписаниеКопирования);
				Если Не ПустаяСтрока(Расписание) Тогда
					ТекущаяНастройка = НСтр("ru = 'Резервное копирование выполняется регулярно по расписанию: %1'");
					ТекущаяНастройка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекущаяНастройка, Расписание);
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			
			Если НастройкиРезервногоКопирования.РезервноеКопированиеНастроено Тогда
				ТекущаяНастройка = НСтр("ru = 'Резервное копирование не выполняется (организовано сторонними программами).'");
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ТекущаяНастройка = НСтр("ru = 'Резервное копирование не выполняется (организовано средствами СУБД).'");
		
	КонецЕсли;
	
	Возврат ТекущаяНастройка;
	
КонецФункции

Функция ПараметрыУдаленияРезервныхКопийПоУмолчанию()
	
	ПараметрыУдаления = Новый Структура;
	
	ПараметрыУдаления.Вставить("ТипОграничения", "ПоПериоду");
	
	ПараметрыУдаления.Вставить("КоличествоКопий", 10);
	
	ПараметрыУдаления.Вставить("ЕдиницаИзмеренияПериода", "Месяц");
	ПараметрыУдаления.Вставить("ЗначениеВЕдиницахИзмерения", 6);
	
	Возврат ПараметрыУдаления;
	
КонецФункции

// Обновляет настройки резервного копирования
//
Процедура ОбновитьПараметрыРезервногоКопирования_2_2_1_15() Экспорт
	
	ПараметрыРезервногоКопирования = НастройкиРезервногоКопирования();
	
	Если ПараметрыРезервногоКопирования = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПараметрыРезервногоКопирования.Свойство("ПроводитьРезервноеКопированиеПриЗавершенииРаботы")
		Или Не ПараметрыРезервногоКопирования.Свойство("НастроеноПользователем") Тогда
		
		Возврат; // Уже было выполнено обновление
		
	КонецЕсли;
	
	ВыборПунктаНастройки = ПараметрыРезервногоКопирования.ВыборПунктаНастройки;
	
	Если ВыборПунктаНастройки = 3 Тогда
		ВыборПунктаНастройки = 0;
	ИначеЕсли ВыборПунктаНастройки = 2 Тогда
		ВыборПунктаНастройки = 3;
	Иначе
		Если ПараметрыРезервногоКопирования.ПроводитьРезервноеКопированиеПриЗавершенииРаботы Тогда
			ВыборПунктаНастройки = 2;
		ИначеЕсли ПараметрыРезервногоКопирования.НастроеноПользователем И ЗначениеЗаполнено(ПараметрыРезервногоКопирования.РасписаниеКопирования) Тогда
			ВыборПунктаНастройки = 1;
		Иначе
			ВыборПунктаНастройки = 0;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыРезервногоКопирования.ВыборПунктаНастройки = ВыборПунктаНастройки;
	
	МассивУдаляемыхПараметров = Новый Массив;
	МассивУдаляемыхПараметров.Добавить("ЕжечасноеОповещение ");
	МассивУдаляемыхПараметров.Добавить("НастроеноПользователем ");
	МассивУдаляемыхПараметров.Добавить("ПроводитьРезервноеКопированиеПриЗавершенииРаботы");
	МассивУдаляемыхПараметров.Добавить("АвтоматическоеРезервноеКопирование");
	МассивУдаляемыхПараметров.Добавить("ОтложенноеРезервноеКопирование");
	
	Для Каждого УдаляемыйПараметр Из МассивУдаляемыхПараметров Цикл
		
		Если ПараметрыРезервногоКопирования.Свойство(УдаляемыйПараметр) Тогда
			
			ПараметрыРезервногоКопирования.Удалить(УдаляемыйПараметр);
			
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

// Обновляет настройки резервного копирования
//
Процедура ОбновитьПараметрыРезервногоКопирования_2_2_1_33() Экспорт
	
	ПараметрыРезервногоКопирования = НастройкиРезервногоКопирования();
	
	Если ПараметрыРезервногоКопирования = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРезервногоКопирования.Свойство("ПараметрыУдаления") Тогда
		
		Возврат; // Уже было выполнено обновление
		
	КонецЕсли;
	
	ПараметрыУдаления = ПараметрыУдаленияРезервныхКопийПоУмолчанию();
	ПараметрыУдаления.ПроизводитьУдаление = ПараметрыРезервногоКопирования.ПроизводитьУдаление;
	ПараметрыУдаления.ТипОграничения = ?(ПараметрыРезервногоКопирования.УдалятьПоПериоду, "ПоПериоду", "ПоКоличеству");
	
	Если ПараметрыРезервногоКопирования.УдалятьПоПериоду Тогда
		ПараметрыУдаления.ТипОграничения = "ПоПериоду";
		НастройкиЗначенияПериода = ЗначениеПериодаПоИнтервалуВремени(ПараметрыРезервногоКопирования.ЗначениеПараметра);
		ПараметрыУдаления.ЕдиницаИзмеренияПериода = НастройкиЗначенияПериода.ТипПериода;
		ПараметрыУдаления.ЗначениеВЕдиницахИзмерения = НастройкиЗначенияПериода.ЗначениеПериода;
	Иначе
		ПараметрыУдаления.ТипОграничения = "ПоКоличеству";
		ПараметрыУдаления.КоличествоКопий = ПараметрыУдаления.ЗначениеПараметра;
	КонецЕсли;
	
	ПараметрыРезервногоКопирования.Вставить("ПараметрыУдаления", ПараметрыУдаления);
	
	МассивУдаляемыхПараметров = Новый Массив;
	МассивУдаляемыхПараметров.Добавить("ПроизводитьУдаление");
	МассивУдаляемыхПараметров.Добавить("УдалятьПоПериоду ");
	МассивУдаляемыхПараметров.Добавить("ЗначениеПараметра");
	МассивУдаляемыхПараметров.Добавить("ПериодОповещения");
	
	Для Каждого УдаляемыйПараметр Из МассивУдаляемыхПараметров Цикл
		
		Если ПараметрыРезервногоКопирования.Свойство(УдаляемыйПараметр) Тогда
			
			ПараметрыРезервногоКопирования.Удалить(УдаляемыйПараметр);
			
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

// Обновляет настройки резервного копирования
//
Процедура ОбновитьПараметрыРезервногоКопирования_2_2_2_33() Экспорт
	
	ПараметрыРезервногоКопирования = НастройкиРезервногоКопирования();
	
	Если ПараметрыРезервногоКопирования = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРезервногоКопирования.Свойство("ВыполнятьАвтоматическоеРезервноеКопирование") Тогда
		
		Возврат; // Уже было выполнено обновление
		
	КонецЕсли;
	
	Если ПараметрыРезервногоКопирования.ПервыйЗапуск Тогда
		
		ПараметрыРезервногоКопирования.ДатаПоследнегоРезервногоКопирования = Дата(1, 1, 1);
		
	КонецЕсли;
	
	Если ПараметрыРезервногоКопирования.ВыборПунктаНастройки = 2 Тогда
		ВариантВыполнения = "ПриЗавершенииРаботы";
	Иначе
		ВариантВыполнения = "ПоРасписанию";
	КонецЕсли;
	
	ВыполнятьАвтоматическоеРезервноеКопирование = (ПараметрыРезервногоКопирования.ВыборПунктаНастройки = 1 Или ПараметрыРезервногоКопирования.ВыборПунктаНастройки = 2);
	
	ПараметрыРезервногоКопирования.Вставить("ВыполнятьАвтоматическоеРезервноеКопирование", ВыполнятьАвтоматическоеРезервноеКопирование);
	ПараметрыРезервногоКопирования.Вставить("РезервноеКопированиеНастроено", ПараметрыРезервногоКопирования.ВыборПунктаНастройки <> 0);
	ПараметрыРезервногоКопирования.Вставить("ВариантВыполнения", ВариантВыполнения);
	ПараметрыРезервногоКопирования.Вставить("РучнойЗапускПоследнегоРезервногоКопирования", Истина);
	
	МассивУдаляемыхПараметров = Новый Массив;
	МассивУдаляемыхПараметров.Добавить("ВыборПунктаНастройки");
	МассивУдаляемыхПараметров.Добавить("ПервыйЗапуск");
	
	Для Каждого УдаляемыйПараметр Из МассивУдаляемыхПараметров Цикл
		
		Если ПараметрыРезервногоКопирования.Свойство(УдаляемыйПараметр) Тогда
			
			ПараметрыРезервногоКопирования.Удалить(УдаляемыйПараметр);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПараметрыРезервногоКопирования.Свойство("ПараметрыУдаления")
		И ПараметрыРезервногоКопирования.ПараметрыУдаления.Свойство("ПроизводитьУдаление") Тогда
		
		Если Не ПараметрыРезервногоКопирования.ПараметрыУдаления.ПроизводитьУдаление Тогда
			ПараметрыРезервногоКопирования.ПараметрыУдаления.ТипОграничения = "ХранитьВсе";
		КонецЕсли;
		
		ПараметрыРезервногоКопирования.ПараметрыУдаления.Удалить("ПроизводитьУдаление");
		
	КонецЕсли;
	
	УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Заполняет структуру параметров, необходимых для работы клиентского кода
// при завершении работы конфигурации, т.е. в обработчиках:
// - ПередЗавершениемРаботыСистемы,
// - ПриЗавершенииРаботыСистемы
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗавершении(Параметры) Экспорт
	
	Параметры.Вставить("РезервноеКопированиеИБ", ПараметрыПриЗавершенииРаботы());
	
КонецПроцедуры

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации. 
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗапуске(Параметры) Экспорт
	
	Параметры.Вставить("РезервноеКопированиеИБ", НастройкиРезервногоКопирования(Истина));
	
КонецПроцедуры

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации.
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистем(Параметры) Экспорт
	
	Параметры.Вставить("РезервноеКопированиеИБ", НастройкиРезервногоКопирования());
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.2.1.15";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.Процедура = "РезервноеКопированиеИБСервер.ОбновитьПараметрыРезервногоКопирования_2_2_1_15";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.2.1.33";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.Процедура = "РезервноеКопированиеИБСервер.ОбновитьПараметрыРезервногоКопирования_2_2_1_33";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.2.2.33";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.Процедура = "РезервноеКопированиеИБСервер.ОбновитьПараметрыРезервногоКопирования_2_2_2_33";
	
КонецПроцедуры

// Вызывается при включении использования для информационной базы профилей безопасности.
//
Процедура ПриВключенииИспользованияПрофилейБезопасности() Экспорт
	
	ПараметрыРезервногоКопирования = НастройкиРезервногоКопирования();
	
	Если ПараметрыРезервногоКопирования = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРезервногоКопирования.Свойство("ПарольАдминистратораИБ") Тогда
		
		ПараметрыРезервногоКопирования.ПарольАдминистратораИБ = "";
		УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
