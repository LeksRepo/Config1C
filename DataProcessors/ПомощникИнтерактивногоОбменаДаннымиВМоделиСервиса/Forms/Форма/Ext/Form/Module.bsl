﻿////////////////////////////////////////////////////////////////////////////////////////////////////
//  Параметризация формы:
//
//      УзелИнформационнойБазы: (ПланОбменаСсылка)  ссылка на узле плана обмена, для которого 
//  выполняется помощник (корреспондент обмена)
//
//      ЗапретитьВыгрузкуТолькоИзмененного: (Булево)    если установлено, то вариант отправки 
//  только измененного недоступен
//

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = Неопределено;
	Если Не ОбменДаннымиВМоделиСервисаПовтИсп.СинхронизацияДанныхПоддерживается() Тогда
		ТекстОшибки = НСтр("ru='Синхронизация данных для конфигурации не поддерживается!'");
		
	ИначеЕсли Не Параметры.Свойство("УзелИнформационнойБазы", Объект.УзелИнформационнойБазы) Тогда
		ТекстОшибки = НСтр("ru='Обработка не предназначена для непосредственного использования.'");
		
	ИначеЕсли Объект.УзелИнформационнойБазы.Пустая() Тогда
		ТекстОшибки = НСтр("ru='Настройка обмена данными не найдена.'");
		
	КонецЕсли;
	
	Если ТекстОшибки<>Неопределено Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	// Устанавливаем заголовки, зависящие от узла
	УстановитьКорреспондентаВЗаголовок(ЭтотОбъект);
	
	// Устанавливаем таблицу переходов в зависимости от параметров
	ПорядковыйНомерПерехода = 0;
	СценарийПолныйВручную();
	
	// Дополнение выгрузки
	ДополнениеВыгрузкиИнициализировать()
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    ЗакрытьФормуБезусловно = Ложь;    
	// На первый шаг
	УстановитьПорядковыйНомерПерехода(1);
КонецПроцедуры    

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ТекстПодтверждения = НСтр("ru='Прервать синхронизацию данных?'");
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
		ЭтотОбъект, Отказ, ТекстПодтверждения, "ЗакрытьФормуБезусловно");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
//

&НаКлиенте
Процедура КомандаДалее(Команда)
    ПерейтиДалее();
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
    ПерейтиНазад();
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	ЗакрытьФормуБезусловно = Истина;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ДополнениеВыгрузкиОчисткаОбщегоОтбора(Команда)
	ТекстЗаголовка = НСтр("ru='Подтверждение'");
	ТекстВопроса   = НСтр("ru='Очистить общий отбор?'");
	
	Оповещение = Новый ОписаниеОповещения("ДополнениеВыгрузкиОчисткаОбщегоОтбораЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , ,ТекстЗаголовка);
КонецПроцедуры

&НаКлиенте
Процедура ДополнениеВыгрузкиОчисткаДетальногоОтбора(Команда)
	ТекстЗаголовка = НСтр("ru='Подтверждение'");
	ТекстВопроса   = НСтр("ru='Очистить детальный отбор?'");
	
	Оповещение = Новый ОписаниеОповещения("ДополнениеВыгрузкиОчисткаДетальногоОтбораЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , ,ТекстЗаголовка);
КонецПроцедуры

&НаКлиенте
Процедура ДополнениеВыгрузкиСоставВыгрузки(Команда)
    ОткрытьФорму("Обработка.ИнтерактивноеИзменениеВыгрузки.Форма.СоставВыгрузки",
        Новый Структура("АдресОбъекта", ДополнениеВыгрузкиАдресОбъекта() ));
КонецПроцедуры

&НаКлиенте
Процедура ДополнениеВыгрузкиИсторияОтборов(Команда)
	
	// Выбор из меню - списка
	СписокВариантов = ДополнениеВыгрузкиПрочитатьСписокВариантовНастроекСервер();
	
	Текст = НСтр("ru='Сохранить текущую настройку...'");
	СписокВариантов.Добавить(1, Текст, , БиблиотекаКартинок.СохранитьНастройкиОтчета);
	
	Оповещение = Новый ОписаниеОповещения("ДополнениеВыгрузкиИсторияОтборовВыборВарианта", ЭтотОбъект);
	ПоказатьВыборИзМеню(Оповещение, СписокВариантов, Элементы.ДополнениеВыгрузкиИсторияОтборов);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ
//

// Страница "ИзменениеСоставаВыгрузки"

&НаКлиенте
Процедура ДополнениеВыгрузкиВариантВыгрузкиПриИзменении(Элемент)
    ДополнениеВыгрузкиВариантВыгрузкиУстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ДополнениеВыгрузкиОбщийПериодДокументовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение)<>Тип("Структура") Тогда 
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если ВыбранноеЗначение.ДействиеВыбора=1 Тогда
		// Отбор и период всех документов
		ДополнениеВыгрузкиУстановитьПараметрыДополненияВсехДокументов(ВыбранноеЗначение);
		
	ИначеЕсли ВыбранноеЗначение.ДействиеВыбора=2 Тогда
		// Детальная настройка
		ДополнениеВыгрузкиУстановитьПараметрыДополненияДетально(ВыбранноеЗначение);
		
	ИначеЕсли ВыбранноеЗначение.ДействиеВыбора=3 Тогда
		// Обновление настроек
		ДополнениеВыгрузкиПредставлениеНастройки = ВыбранноеЗначение.ПредставлениеНастройки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнениеВыгрузкиОбщийОтборДокументовНажатие(Элемент)
    ДополнениеВыгрузкиОткрытьПодборВсехДокументов();
КонецПроцедуры

&НаКлиенте
Процедура ДополнениеВыгрузкиДетальныйОтборНажатие(Элемент)
    ДополнениеВыгрузкиОткрытьДетальныйПодбор();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

&НаКлиенте
Процедура ДополнениеВыгрузкиИсторияОтборовВыборВарианта(Знач ВыбранныйЭлемент, Знач ДополнительныеПараметры) Экспорт
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеНастройки = ВыбранныйЭлемент.Значение;
	Если ТипЗнч(ПредставлениеНастройки)=Тип("Строка") Тогда
		ТекстЗаголовка = НСтр("ru='Подтверждение'");
		ТекстВопроса   = НСтр("ru='Восстановить настройки ""%1""?'");
		ТекстВопроса   = СтрЗаменить(ТекстВопроса, "%1", ПредставлениеНастройки);
		
		Оповещение = Новый ОписаниеОповещения("ДополнениеВыгрузкиИсторияОтборовВыборВариантаЗавершение", ЭтотОбъект, Новый Структура);
		Оповещение.ДополнительныеПараметры.Вставить("ПредставлениеНастройки", ПредставлениеНастройки);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , ,ТекстЗаголовка);
		
	ИначеЕсли ПредставлениеНастройки=1 Тогда
		// Форма всех настроек
		ОткрытьФорму("Обработка.ИнтерактивноеИзменениеВыгрузки.Форма.РедактированиеСоставаНастроек",
			Новый Структура("ЗакрыватьПриВыборе, ДействиеВыбора, Объект, ПредставлениеТекущейНастройки", 
				Истина, 3, ДополнениеВыгрузки, ДополнениеВыгрузкиПредставлениеНастройки
			), Элементы.ДополнениеВыгрузкиОбщийПериодДокументов);
			
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ДополнениеВыгрузкиИсторияОтборовВыборВариантаЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	ДополнениеВыгрузкиУстановитьНастройкиСервер(ДополнительныеПараметры.ПредставлениеНастройки);
КонецПроцедуры

&НаКлиенте
Процедура ДополнениеВыгрузкиОчисткаОбщегоОтбораЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	ДополнениеВыгрузки.КомпоновщикОтбораВсехДокументов.Настройки.Отбор.Элементы.Очистить();
	ДополнениеВыгрузкиУстановитьОписаниеДополненияОбщегоОтбора();
КонецПроцедуры

&НаКлиенте
Процедура ДополнениеВыгрузкиОчисткаДетальногоОтбораЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	ДополнениеВыгрузки.ДополнительнаяРегистрация.Очистить();
	ДополнениеВыгрузкиУстановитьОписаниеДополненияДетально();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура УстановитьКорреспондентаВЗаголовок(ВладелецЗаголовка)
    ВладелецЗаголовка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ВладелецЗаголовка.Заголовок, Строка(Объект.УзелИнформационнойБазы));
КонецПроцедуры    

////////////////////////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	ОчиститьСообщения();
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	ПорядковыйНомерПерехода = Значение;
	Если ПорядковыйНомерПерехода < 0 Тогда
		ПорядковыйНомерПерехода = 0;
	КонецЕсли;
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура(
        "ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru='Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	// Устанавливаем текущую кнопку по умолчанию
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаДалее");
	
	Если КнопкаДалее <> Неопределено Тогда
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
	Иначе
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаГотово");
		Если КнопкаГотово <> Неопределено Тогда
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов
	Если ЭтоПереходДалее Тогда
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки( Новый Структура(
            "ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		Если СтрокиПерехода.Количество() > 0 Тогда
			СтрокаПерехода = СтрокиПерехода[0];
			// обработчик ПриПереходеДалее
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее) И Не СтрокаПерехода.ДлительнаяОперация Тогда
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
				Отказ = Ложь;
				
				А = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
					Возврат;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	
	Иначе
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура(
			"ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		Если СтрокиПерехода.Количество() > 0 Тогда
			СтрокаПерехода = СтрокиПерехода[0];
			// обработчик ПриПереходеНазад
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад) И Не СтрокаПерехода.ДлительнаяОперация Тогда
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
				Отказ = Ложь;
				
				А = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
					Возврат;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура(
        "ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru='Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		А = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			Возврат;
		ИначеЕсли ПропуститьСтраницу Тогда
			Если ЭтоПереходДалее Тогда
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				Возврат;
			Иначе
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура(
        "ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru='Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// обработчик ОбработкаДлительнойОперации
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		А = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			Возврат;
		ИначеЕсли ПерейтиДалее Тогда
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			Возврат;
		КонецЕсли;
		
	Иначе
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

//
//  Добавляет новую строку в конец текущей таблицы переходов
//
//  Параметры:
//      ПорядковыйНомерПерехода             (Число)     Порядковый номер перехода, который соответствует текущему шагу перехода
//      ИмяОсновнойСтраницы                 (Строка)    Имя страницы панели "ПанельОсновная", которая соответствует текущему номеру перехода
//      ИмяСтраницыНавигации                (Строка)    Имя страницы панели "ПанельНавигации", которая соответствует текущему номеру перехода
//      ИмяСтраницыДекорации                (Строка)    Имя страницы панели "ПанельДекорации", которая соответствует текущему номеру перехода
//      ИмяОбработчикаПриОткрытии           (Строка)    Имя функции-обработчика события открытия текущей страницы помощника
//      ИмяОбработчикаПриПереходеДалее      (Строка)    Имя функции-обработчика события перехода на следующую страницу помощника
//      ИмяОбработчикаПриПереходеНазад      (Строка)    Имя функции-обработчика события перехода на предыдущую страницу помощника
//      ДлительнаяОперация                  (Булево)    Признак отображения страницы длительной операции. Ложь - отображается обычная страница.
//      ИмяОбработчикаДлительнойОперации    (Строка)    Имя функции-обработчика длительной операции
//
&НаСервере
Процедура ТаблицаПереходовНоваяСтрока(ПорядковыйНомерПерехода, ИмяОсновнойСтраницы, ИмяСтраницыНавигации, 
    ИмяСтраницыДекорации = "",
    ИмяОбработчикаПриОткрытии = "", ИмяОбработчикаПриПереходеДалее = "", ИмяОбработчикаПриПереходеНазад = "",
	ДлительнаяОперация = Ложь, ИмяОбработчикаДлительнойОперации = "")

	НоваяСтрока = ТаблицаПереходов.Добавить();
	
	НоваяСтрока.ПорядковыйНомерПерехода = ПорядковыйНомерПерехода;
	НоваяСтрока.ИмяОсновнойСтраницы     = ИмяОсновнойСтраницы;
	НоваяСтрока.ИмяСтраницыДекорации    = ИмяСтраницыДекорации;
	НоваяСтрока.ИмяСтраницыНавигации    = ИмяСтраницыНавигации;
	
	НоваяСтрока.ИмяОбработчикаПриПереходеДалее = ИмяОбработчикаПриПереходеДалее;
	НоваяСтрока.ИмяОбработчикаПриПереходеНазад = ИмяОбработчикаПриПереходеНазад;
	НоваяСтрока.ИмяОбработчикаПриОткрытии      = ИмяОбработчикаПриОткрытии;
	
	НоваяСтрока.ДлительнаяОперация = ДлительнаяОперация;
	НоваяСтрока.ИмяОбработчикаДлительнойОперации = ИмяОбработчикаДлительнойОперации;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент)=Тип("ГруппаФормы") Тогда
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			Если ЭлементФормыПоИмениКоманды<>Неопределено Тогда
				Возврат ЭлементФормыПоИмениКоманды;
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент)=Тип("КнопкаФормы") И Найти(Элемент.ИмяКоманды, ИмяКоманды)>0 Тогда
			Возврат Элемент;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Процедура ПерейтиДалее()
	ИзменитьПорядковыйНомерПерехода(+1);
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНазад()
	ИзменитьПорядковыйНомерПерехода(-1);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
//  Дополнение выгрузки
//

&НаСервере
Процедура ДополнениеВыгрузкиИнициализировать()
	
	ДополнениеВыгрузки.УзелИнформационнойБазы = Объект.УзелИнформационнойБазы;
	ДополнениеВыгрузки.ПериодОтбораВсехДокументов.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяц;
	
	Если Параметры.ЗапретитьВыгрузкуТолькоИзмененного Тогда
		Элементы.ДополнениеВыгрузкиВариантВыгрузки0.Видимость = Ложь;
		ДополнениеВыгрузки.ВариантВыгрузки = 1;
	Иначе
		ДополнениеВыгрузки.ВариантВыгрузки = 0;
	КонецЕсли;
	
	ОбработкаДополнения = РеквизитФормыВЗначение("ДополнениеВыгрузки");
	
	// Компоновщик конструируем по частям
	Данные = ОбработкаДополнения.КомпоновщикНастроекОбщегоОтбора(УникальныйИдентификатор);
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Данные.СхемаКомпоновки));
	Компоновщик.ЗагрузитьНастройки(Данные.Настройки);
	
	ДополнениеВыгрузки.КомпоновщикОтбораВсехДокументов = Компоновщик;
	
	ДополнениеВыгрузкиУстановитьОписаниеДополненияОбщегоОтбора();
	ДополнениеВыгрузкиУстановитьОписаниеДополненияДетально();
	
	ДополнениеВыгрузкиВариантВыгрузкиУстановитьВидимость();
	
	Элементы.ДополнениеВыгрузкиИсторияОтборов.Видимость = ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
КонецПроцедуры

&НаСервере 
Процедура ДополнениеВыгрузкиУстановитьНастройкиСервер(ПредставлениеНастройки)
    
    ОбъектДополнения = РеквизитФормыВЗначение("ДополнениеВыгрузки");
    ОбъектДополнения.ВосстановитьТекущееИзНастроек(
        ПредставлениеНастройки);
    ЗначениеВРеквизитФормы(ОбъектДополнения, "ДополнениеВыгрузки");
    
    // Текущее представление
    ДополнениеВыгрузкиПредставлениеНастройки = ПредставлениеНастройки;
    
    // И обновляем интерфейс
    ДополнениеВыгрузкиУстановитьОписаниеДополненияОбщегоОтбора();
    ДополнениеВыгрузкиУстановитьОписаниеДополненияДетально();
    ДополнениеВыгрузкиВариантВыгрузкиУстановитьВидимость();
КонецПроцедуры

&НаСервере 
Функция ДополнениеВыгрузкиПрочитатьСписокВариантовНастроекСервер() 
    ОбъектДополнения = РеквизитФормыВЗначение("ДополнениеВыгрузки");
    Возврат ОбъектДополнения.ПрочитатьПредставленияСпискаНастроек(Объект.УзелИнформационнойБазы);
КонецФункции

&НаСервере
Функция ДополнениеВыгрузкиАдресОбъекта()
    Возврат ПоместитьВоВременноеХранилище(
        РеквизитФормыВЗначение("ДополнениеВыгрузки"), 
        УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура ДополнениеВыгрузкиВариантВыгрузкиУстановитьВидимость()
    
    Элементы.ГруппаОтборВсеДокументы.Доступность = ДополнениеВыгрузки.ВариантВыгрузки=1;
    Элементы.ГруппаОтборДетальный.Доступность    = ДополнениеВыгрузки.ВариантВыгрузки=2;
    
КонецПроцедуры

&НаСервере
Процедура ДополнениеВыгрузкиУстановитьПараметрыДополненияВсехДокументов(ДанныеВыбора)
    ДополнениеВыгрузки.КомпоновщикОтбораВсехДокументов = ДанныеВыбора.КомпоновщикНастроек;
    ДополнениеВыгрузки.ПериодОтбораВсехДокументов      = ДанныеВыбора.ПериодДанных;
    ДополнениеВыгрузкиУстановитьОписаниеДополненияОбщегоОтбора();
КонецПроцедуры

&НаСервере
Процедура ДополнениеВыгрузкиУстановитьПараметрыДополненияДетально(ДанныеВыбора)
    
    ОбъектВыбора = ПолучитьИзВременногоХранилища(ДанныеВыбора.АдресОбъекта);
    ЗаполнитьЗначенияСвойств(ДополнениеВыгрузки, ОбъектВыбора, , "ДополнительнаяРегистрация");
    ДополнениеВыгрузки.ДополнительнаяРегистрация.Очистить();
    Для Каждого Строка Из ОбъектВыбора.ДополнительнаяРегистрация Цикл
        ЗаполнитьЗначенияСвойств(ДополнениеВыгрузки.ДополнительнаяРегистрация.Добавить(), Строка);
    КонецЦикла;
    
    ДополнениеВыгрузкиУстановитьОписаниеДополненияДетально();
КонецПроцедуры    

&НаСервере
Процедура ДополнениеВыгрузкиУстановитьОписаниеДополненияОбщегоОтбора()
	
	ОбработкаДополнения = РеквизитФормыВЗначение("ДополнениеВыгрузки");
	
	Текст = ОбработкаДополнения.ПредставлениеОтбораВсехДокументов("");
	
	НетОтбора = ПустаяСтрока(Текст);
	Если НетОтбора Тогда
		Текст = НСтр("ru='Все документы'");
	КонецЕсли;
	
	Элементы.ДополнениеВыгрузкиОбщийОтборДокументов.Заголовок = Текст;
	Элементы.ДополнениеВыгрузкиОчисткаОбщегоОтбора.Видимость = Не НетОтбора;
КонецПроцедуры

&НаСервере
Процедура ДополнениеВыгрузкиУстановитьОписаниеДополненияДетально()
	
	ОбработкаДополнения = РеквизитФормыВЗначение("ДополнениеВыгрузки");
	
	Текст = СтрЗаменить(
		СокрЛП(ОбработкаДополнения.ПредставлениеДетальногоОтбора("")),
		Символы.ПС, ", ");
	
	НетОтбора = ПустаяСтрока(Текст);
	Если НетОтбора Тогда
		Текст = НСтр("ru='Дополнительные данные не выбраны'")
	КонецЕсли;
	
	Элементы.ДополнениеВыгрузкиДетальныйОтбор.Заголовок = Текст;
	Элементы.ДополнениеВыгрузкиОчисткаДетальногоОтбора.Видимость = Не НетОтбора;
КонецПроцедуры

&НаСервере 
Процедура ДополнениеВыгрузкиЗарегистрироватьДанные()
	
	Если ДополнениеВыгрузки.ВариантВыгрузки=0 Тогда
		Возврат;
	КонецЕсли;
	
	// Оперируем с объектом, в реквизите остаются текущие настройки!
	ДополнениеВыгрузкиОбъект = РеквизитФормыВЗначение("ДополнениеВыгрузки");    
	Если ДополнениеВыгрузки.ВариантВыгрузки=1 Тогда
		// За период с отбором, очищаем дополнительную
		ДополнениеВыгрузкиОбъект.ДополнительнаяРегистрация.Очистить();
	ИначеЕсли ДополнениеВыгрузки.ВариантВыгрузки=2 Тогда
		// Детально настроено, очищаем общее
		ДополнениеВыгрузкиОбъект.КомпоновщикОтбораВсехДокументов = Неопределено;
		ДополнениеВыгрузкиОбъект.ПериодОтбораВсехДокументов      = Неопределено;
	КонецЕсли;
	
	ДополнениеВыгрузкиОбъект.ЗарегистрироватьДополнительныеИзменения();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнениеВыгрузкиОткрытьПодборВсехДокументов()
	ТекстЗаголовка = НСтр("ru='Добавление документов для отправки'");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",           ТекстЗаголовка);
	ПараметрыФормы.Вставить("ДействиеВыбора",      1);
	ПараметрыФормы.Вставить("ВыборПериода",        Истина);
	ПараметрыФормы.Вставить("КомпоновщикНастроек", ДополнениеВыгрузки.КомпоновщикОтбораВсехДокументов);
	ПараметрыФормы.Вставить("ПериодДанных",        ДополнениеВыгрузки.ПериодОтбораВсехДокументов);
	ПараметрыФормы.Вставить("АдресХранилищаФормы", УникальныйИдентификатор);
	
	ОткрытьФорму("Обработка.ИнтерактивноеИзменениеВыгрузки.Форма.РедактированиеПериодаИОтбора",
		ПараметрыФормы, Элементы.ДополнениеВыгрузкиОбщийПериодДокументов);
КонецПроцедуры

&НаКлиенте
Процедура ДополнениеВыгрузкиОткрытьДетальныйПодбор()
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДействиеВыбора",    2);
	ПараметрыФормы.Вставить("АдресОбъекта",      ДополнениеВыгрузкиАдресОбъекта());
	ПараметрыФормы.Вставить("ОткрытаПоСценарию", Истина);
	ОткрытьФорму("Обработка.ИнтерактивноеИзменениеВыгрузки.Форма", ПараметрыФормы, Элементы.ДополнениеВыгрузкиОбщийПериодДокументов);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// Обработчики событий перехода и вспомогательное
//
Функция Подключаемый_Окончание_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
    
    // Регистрируем все, что выбрано
    ДополнениеВыгрузкиЗарегистрироватьДанные();
    
КонецФункции    

////////////////////////////////////////////////////////////////////////////////////////////////////
// ПЕРЕОПРЕДЕЛЯЕМАЯ ЧАСТЬ: Инициализация переходов помощника
//

&НаСервере
Процедура СценарийПолныйВручную()
	ТаблицаПереходов.Очистить();
    
	ТаблицаПереходовНоваяСтрока(1, "ИзменениеСоставаВыгрузки", "СтраницаНавигацииНачало",
        ,,);
	ТаблицаПереходовНоваяСтрока(2, "Окончание", "СтраницаНавигацииОкончание",,
        "Окончание_ПриОткрытии",);
    
КонецПроцедуры

