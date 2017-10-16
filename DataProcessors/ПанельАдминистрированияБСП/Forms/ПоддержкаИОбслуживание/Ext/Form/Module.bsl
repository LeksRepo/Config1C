﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Настройки видимости при запуске
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	Элементы.ГруппаУдалениеПомеченныхОбъектовПоРасписанию.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	Если РежимРаботы.ЭтоАдминистраторСистемы Тогда
		РегламентноеЗадание = РегламентныеЗаданияНайтиПредопределенное("УдалениеПомеченных");
		Если РегламентноеЗадание <> Неопределено Тогда
			УдалениеПомеченныхИдентификатор = РегламентноеЗадание.УникальныйИдентификатор;
			УдалениеПомеченныхИспользование = РегламентноеЗадание.Использование;
			УдалениеПомеченныхРасписание    = РегламентноеЗадание.Расписание;
		КонецЕсли;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.РегламентныеЗадания
	Элементы.ГруппаОбработкаРегламентныеИФоновыеЗадания.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.РегламентныеЗадания
	
	// СтандартныеПодсистемы.УправлениеИтогамиИАгрегатами
	Элементы.ГруппаОбработкаУправлениеИтогамиИАгрегатамиОткрыть.Видимость = РежимРаботы.ЭтоАдминистраторПрограммы;
	// Конец СтандартныеПодсистемы.УправлениеИтогамиИАгрегатами
	
	// СтандартныеПодсистемы.ПолнотекстовыйПоиск
	Элементы.ГруппаУправлениеПолнотекстовымПоискомИИзвлечениемТекстов.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ПолнотекстовыйПоиск
	
	// СтандартныеПодсистемы.РезервноеКопированиеИБ
	ПоддержкаРезервногоКопированияВМоделиСервиса = Истина;
	// СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	ПоддержкаРезервногоКопированияВМоделиСервиса = РезервноеКопированиеОбластейДанных.РезервноеКопированиеИспользуется();
	// Конец СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	Элементы.ГруппаРезервноеКопированиеИВосстановление.Видимость        = ((РежимРаботы.Локальный Или РежимРаботы.Автономный) И РежимРаботы.ЭтоАдминистраторСистемы
		И Не РежимРаботы.ЭтоВебКлиент) ИЛИ (РежимРаботы.МодельСервиса И РежимРаботы.ЭтоАдминистраторПрограммы И ПоддержкаРезервногоКопированияВМоделиСервиса);
	ОбновитьНастройкиРезервногоКопирования();
	Элементы.ГруппаВосстановлениеРезервнойКопии.Видимость               = (РежимРаботы.Локальный Или РежимРаботы.Автономный) И РежимРаботы.ЭтоАдминистраторСистемы;
	Элементы.ГруппаВосстановлениеРезервнойКопииВМоделиСервиса.Видимость = РежимРаботы.МодельСервиса И РежимРаботы.ЭтоАдминистраторПрограммы 
		И ПоддержкаРезервногоКопированияВМоделиСервиса;
	// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Элементы.ГруппаОценкаПроизводительности.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	Элементы.ГруппаКлассификаторы.Видимость = РежимРаботы.Локальный Или РежимРаботы.Автономный;
	
	// СтандартныеПодсистемы.АдресныйКлассификатор
	Элементы.ГруппаРегистрСведенийАдресныйКлассификатор.Видимость = РежимРаботы.Локальный Или РежимРаботы.Автономный;
	// Конец СтандартныеПодсистемы.АдресныйКлассификатор
	
	// СтандартныеПодсистемы.Валюты
	Элементы.ГруппаОбработкаЗагрузкаКурсовВалют.Видимость = РежимРаботы.Локальный;
	// Конец СтандартныеПодсистемы.Валюты
	
	// СтандартныеПодсистемы.Банки
	Элементы.ГруппаЗагрузитьКлассификаторБанков.Видимость = РежимРаботы.Локальный И РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.Банки
	
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	Элементы.ГруппаОткрытьНастройкиРегистрацииСобытийДоступаКПерсональнымДанным.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
	// СтандартныеПодсистемы.ОбновлениеКонфигурации
	Элементы.ГруппаОбработкаОбновлениеКонфигурации.Видимость = РежимРаботы.Локальный И РежимРаботы.ЭтоАдминистраторСистемы И Не РежимРаботы.ЭтоLinuxКлиент;
	Элементы.ГруппаНастройкиОбновленияПрограммы.Видимость = РежимРаботы.Локальный И РежимРаботы.ЭтоАдминистраторСистемы И Не РежимРаботы.ЭтоLinuxКлиент;
	ОбновитьНастройкиОбновленияКонфигурации();
	// Конец СтандартныеПодсистемы.ОбновлениеКонфигурации
	
	// СтандартныеПодсистемы.ОбновлениеВерсииИБ
	Элементы.ГруппаДетализироватьОбновлениеИБВЖурналеРегистрации.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	Элементы.ГруппаОбработкаГрупповоеИзменениеОбъектов.Видимость = РежимРаботы.ЭтоАдминистраторПрограммы;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	Элементы.ГруппаДополнительныеОтчетыПоАдминистрированию.Видимость = НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки;
	Элементы.ГруппаДополнительныеОбработкиПоАдминистрированию.Видимость = НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	
	// Обновление состояния элементов
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.РезервноеКопированиеИБ
	Если ИмяСобытия = "ЗакрытаФормаНастройкиРезервногоКопирования" Тогда
		ОбновитьНастройкиРезервногоКопирования();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ
	
	// СтандартныеПодсистемы.ОбновлениеКонфигурации
	Если ИмяСобытия = "ЗакрытаФормаНастройкиОбновленияКонфигурации" Тогда
		ОбновитьНастройкиОбновленияКонфигурации();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОбновлениеКонфигурации
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// СтандартныеПодсистемы.БазоваяФункциональность
&НаКлиенте
Процедура УдалениеПомеченныхИспользованиеПриИзменении(Элемент)
	РегламентныеЗаданияИспользованиеПриИзменении("УдалениеПомеченных");
КонецПроцедуры
// Конец СтандартныеПодсистемы.БазоваяФункциональность

// СтандартныеПодсистемы.РезервноеКопированиеИБ
&НаКлиенте
Процедура РезервноеКопированиеПрограммыНажатие(Элемент)
	
	// СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	Если РежимРаботы.МодельСервиса Тогда
		ОткрытьФорму("ОбщаяФорма.СозданиеРезервнойКопии", , ЭтотОбъект);
		Возврат;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаРезервногоКопированияНажатие(Элемент)
	
	// СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	Если РежимРаботы.МодельСервиса Тогда
		ОткрытьФорму("Обработка.НастройкаРезервногоКопированияПриложения.Форма", , ЭтотОбъект);
		Возврат;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	
	ОткрытьФорму(РезервноеКопированиеИБКлиент.ИмяФормыНастроекРезервногоКопирования(),, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановлениеИзРезервнойКопииНажатие(Элемент)
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.ВосстановлениеДанныхИзРезервнойКопии", , ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ

// СтандартныеПодсистемы.ОценкаПроизводительности
&НаКлиенте
Процедура ВыполнятьЗамерыПроизводительностиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ОценкаПроизводительности

// СтандартныеПодсистемы.ОбновлениеВерсииИБ
&НаКлиенте
Процедура ДетализироватьОбновлениеИБВЖурналеРегистрацииПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.БазоваяФункциональность
&НаКлиенте
Процедура УдалениеПомеченныхНастроитьРасписание(Команда)
	РегламентныеЗаданияГиперссылкаНажатие("УдалениеПомеченных");
КонецПроцедуры
// Конец СтандартныеПодсистемы.БазоваяФункциональность

// СтандартныеПодсистемы.БазоваяФункциональность
&НаКлиенте
Процедура ПоискИУдалениеДублей(Команда)
	
	ОткрытьФорму("Обработка.ПоискИУдалениеДублей.Форма.ПоискДублей");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.БазоваяФункциональность

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура ДополнительныеОтчетыПоАдминистрированию(Команда)
	ФормаПараметры = Новый Структура;
	ФормаПараметры.Вставить("ИмяРаздела", "Администрирование");
	ФормаПараметры.Вставить("ОбъектыНазначения", Новый СписокЗначений);
	ФормаПараметры.Вставить("Вид", ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительныйОтчет());
	ФормаПараметры.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ФормаПараметры.Вставить("Заголовок", НСтр("ru = 'Дополнительные отчеты по администрированию'"));
	ОткрытьФорму("ОбщаяФорма.ДополнительныеОтчетыИОбработки", ФормаПараметры, ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура ДополнительныеОбработкиПоАдминистрированию(Команда)
	ФормаПараметры = Новый Структура;
	ФормаПараметры.Вставить("ИмяРаздела", "Администрирование");
	ФормаПараметры.Вставить("ОбъектыНазначения", Новый СписокЗначений);
	ФормаПараметры.Вставить("Вид", ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка());
	ФормаПараметры.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ФормаПараметры.Вставить("Заголовок", НСтр("ru = 'Дополнительные обработки по администрированию'"));
	ОткрытьФорму("ОбщаяФорма.ДополнительныеОтчетыИОбработки", ФормаПараметры, ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Валюты
&НаКлиенте
Процедура ОбработкаЗагрузкаКурсовВалют(Команда)
	
	ОткрытьФорму("Обработка.ЗагрузкаКурсовВалют.Форма");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Валюты

// СтандартныеПодсистемы.Банки
&НаКлиенте
Процедура ЗагрузитьКлассификаторБанков(Команда)
	
	ОткрытьФорму("Справочник.КлассификаторБанковРФ.Форма.ЗагрузкаКлассификатора");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Банки

// СтандартныеПодсистемы.АдресныйКлассификатор
&НаКлиенте
Процедура ОткрытьАдресныйКлассификатор(Команда)
	
	ОткрытьФорму("РегистрСведений.АдресныйКлассификатор.Форма.АдресныйКлассификатор");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.АдресныйКлассификатор

// СтандартныеПодсистемы.ПолнотекстовыйПоиск
&НаКлиенте
Процедура ОбработкаУправлениеПолнотекстовымПоиском(Команда)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.УправлениеПолнотекстовымПоискомИИзвлечениемТекстов", , ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПолнотекстовыйПоиск

// СтандартныеПодсистемы.ОбновлениеВерсииИБ
&НаКлиенте
Процедура ОтложеннаяОбработкаДанных(Команда)
	ПараметрыФормы = Новый Структура("ОткрытиеИзПанелиАдминистрирования", Истина);
	ОткрытьФорму("Обработка.ОбновлениеИнформационнойБазы.Форма.ИндикацияХодаОтложенногоОбновленияИБ", ПараметрыФормы);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

// СтандартныеПодсистемы.ОбновлениеКонфигурации
&НаКлиенте
Процедура НастройкаОбновленияПрограммы(Команда)
	
	ОткрытьФорму("Обработка.ОбновлениеКонфигурации.Форма.НастройкаРасписания");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ОбновлениеКонфигурации

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтотОбъект, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияИспользованиеПриИзменении(ПрефиксРеквизитов)
	ИмяРеквизитаИспользование = ПрефиксРеквизитов + "Использование";
	Идентификатор = ЭтотОбъект[ПрефиксРеквизитов + "Идентификатор"];
	Если ЭтотОбъект[ИмяРеквизитаИспользование] Тогда
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("Идентификатор", Идентификатор);
		ПараметрыВыполнения.Вставить("ИмяРеквизитаРасписание", ПрефиксРеквизитов + "Расписание");
		ПараметрыВыполнения.Вставить("ИмяРеквизитаИспользование", ИмяРеквизитаИспользование);
		
		РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения);
	Иначе
		Изменения = Новый Структура("Использование", Ложь);
		РегламентныеЗаданияСохранить(Идентификатор, Изменения, ИмяРеквизитаИспользование);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияГиперссылкаНажатие(ПрефиксРеквизитов)
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("Идентификатор", ЭтотОбъект[ПрефиксРеквизитов + "Идентификатор"]);
	ПараметрыВыполнения.Вставить("ИмяРеквизитаРасписание", ПрефиксРеквизитов + "Расписание");
	
	РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения)
	Обработчик = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект, ПараметрыВыполнения);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание]);
	Диалог.Показать(Обработчик);
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	Если Расписание = Неопределено Тогда
		Если ПараметрыВыполнения.Свойство("ИмяРеквизитаИспользование") Тогда
			ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаИспользование] = Ложь;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание] = Расписание;
	
	Изменения = Новый Структура("Расписание", Расписание);
	Если ПараметрыВыполнения.Свойство("ИмяРеквизитаИспользование") Тогда
		ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаИспользование] = Истина;
		Изменения.Вставить("Использование", Истина);
	КонецЕсли;
	РегламентныеЗаданияСохранить(ПараметрыВыполнения.Идентификатор, Изменения, ПараметрыВыполнения.ИмяРеквизитаРасписание);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура РегламентныеЗаданияСохранить(УникальныйИдентификатор, Изменения, РеквизитПутьКДанным)
	РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(УникальныйИдентификатор);
	ЗаполнитьЗначенияСвойств(РегламентноеЗадание, Изменения);
	РегламентноеЗадание.Записать();
	
	Если РеквизитПутьКДанным <> Неопределено Тогда
		УстановитьДоступность(РеквизитПутьКДанным);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		СтандартныеПодсистемыКлиентСервер.РезультатВыполненияДобавитьОповещениеОткрытыхФорм(Результат, "Запись_НаборКонстант", Новый Структура, КонстантаИмя);
		// СтандартныеПодсистемы.ВариантыОтчетов
		ВариантыОтчетов.ДобавитьОповещениеПриИзмененииЗначенияКонстанты(Результат, КонстантаМенеджер);
		// Конец СтандартныеПодсистемы.ВариантыОтчетов
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РежимРаботы.ЭтоАдминистраторСистемы Тогда
		
		// СтандартныеПодсистемы.ОценкаПроизводительности
		Если РеквизитПутьКДанным = "НаборКонстант.ВыполнятьЗамерыПроизводительности"
			Или РеквизитПутьКДанным = "" Тогда
			Элементы.ОбработкаОценкаПроизводительности.Доступность = НаборКонстант.ВыполнятьЗамерыПроизводительности;
		КонецЕсли;
		// Конец СтандартныеПодсистемы.ОценкаПроизводительности
		
		// СтандартныеПодсистемы.БазоваяФункциональность
		Если РеквизитПутьКДанным = "УдалениеПомеченныхРасписание"
			Или РеквизитПутьКДанным = "УдалениеПомеченныхИспользование"
			Или РеквизитПутьКДанным = "" Тогда
			Элементы.УдалениеПомеченныхНастроитьРасписание.Доступность = УдалениеПомеченныхИспользование;
			Элементы.ПояснениеУдалениеПомеченныхОбъектовПоРасписанию.Видимость = УдалениеПомеченныхИспользование;
			Если УдалениеПомеченныхИспользование Тогда
				РасписаниеПредставление = Строка(УдалениеПомеченныхРасписание);
				Представление = ВРег(Лев(РасписаниеПредставление, 1)) + Сред(РасписаниеПредставление, 2);
			Иначе
				Представление = НСтр("ru = '<Отключено>'");
			КонецЕсли;
			Элементы.ПояснениеУдалениеПомеченныхОбъектовПоРасписанию.Заголовок = Представление;
		КонецЕсли;
		// Конец СтандартныеПодсистемы.БазоваяФункциональность
		
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.РезервноеКопированиеИБ
&НаСервере
Процедура ОбновитьНастройкиРезервногоКопирования()
	
	Если (РежимРаботы.Локальный Или РежимРаботы.Автономный) И РежимРаботы.ЭтоАдминистраторСистемы Тогда
		Элементы.ПояснениеНастройкаРезервногоКопирования.Заголовок = РезервноеКопированиеИБСервер.ТекущаяНастройкаРезервногоКопирования();
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ

// СтандартныеПодсистемы.ОбновлениеКонфигурации
&НаСервере
Процедура ОбновитьНастройкиОбновленияКонфигурации()
	
	НастройкиОбновленияКонфигурации = ОбновлениеКонфигурации.ПолучитьСтруктуруНастроекПомощника();
	
	ЗаголовокОбновленияПрограммы = НСтр("ru = 'Автоматическая проверка обновлений отключена.'");
	Если НастройкиОбновленияКонфигурации.ПроверятьНаличиеОбновленияПриЗапуске = 2 Тогда
		ЗаголовокОбновленияПрограммы = НСтр("ru = 'Автоматическая проверка обновлений выполняется при каждом запуске программы.'");
	ИначеЕсли НастройкиОбновленияКонфигурации.ПроверятьНаличиеОбновленияПриЗапуске = 1 Тогда
		ЗаголовокОбновленияПрограммы = НСтр("ru = 'Автоматическая проверка обновлений выполняется по расписанию: %1.'");
		Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(НастройкиОбновленияКонфигурации.РасписаниеПроверкиНаличияОбновления);
		ЗаголовокОбновленияПрограммы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокОбновленияПрограммы, Расписание);
	КонецЕсли;
	
	Элементы.ПояснениеНастройкаОбновленияПрограммы.Заголовок = ЗаголовокОбновленияПрограммы;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ОбновлениеКонфигурации

&НаСервере
Функция РегламентныеЗаданияНайтиПредопределенное(ИмяПредопределенного)
	МетаданныеПредопределенного = Метаданные.РегламентныеЗадания.Найти(ИмяПредопределенного);
	Если МетаданныеПредопределенного = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		Возврат РегламентныеЗадания.НайтиПредопределенное(МетаданныеПредопределенного);
	КонецЕсли;
КонецФункции

#КонецОбласти
