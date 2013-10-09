﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НастройкиРезервногоКопирования = РезервноеКопированиеИБСервер.ПолучитьНастройкиРезервногоКопирования();
	Объект.КодТипаРезервногоКопирования = НастройкиРезервногоКопирования.ВыборПунктаНастройки;
	Если НастройкиРезервногоКопирования.ПроводитьРезервноеКопированиеПриЗавершенииРаботы Тогда	
    	Объект.ВариантПроведенияРезервногоКопирования = 2;
	Иначе
		Объект.ВариантПроведенияРезервногоКопирования = 1;
	КонецЕсли;
	Объект.КодТипаИнтерактивногоРезервногоКопирования = 1;	
	Объект.ОчисткаКаталогаСРезервнымиКопиямиПриПереполнении = НастройкиРезервногоКопирования.ПроизводитьУдаление;
	Объект.ПериодХраненияРезервныхКопий = 1;
	Объект.ЕдиницаИзмеренияПериодаХраненияРезервныхКопий = "Месяц";
	Объект.ПериодОтложенногоОповещения = 1;
	Объект.ЕдиницаИзмеренияПериодаОповещения = "День";
	Объект.ЕдиницаИзмеренияПериодаОтложенногоОповещения = "Час";
	Объект.ПериодОповещения = 1;
	Объект.НажатиеГиперссылки = Ложь;
	Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(НастройкиРезервногоКопирования.РасписаниеКопирования);
	Объект.СтрокаРасписания = Строка(Расписание);
	Элементы.СтраницыПомощника.ТекущаяСтраница = ОпределитьСтраницуПоПравамИАрхитектуре();
	Если Параметры.Свойство("ТипВызова") Тогда
		
		Если Параметры.ТипВызова = 1 Тогда
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы[Параметры.ТекущаяСтраница];
			Элементы.НадписьВремяОжиданияРезервногоКопирования.Заголовок = Параметры.ЗаголовокНадписи;
		КонецЕсли;
		
		Если Параметры.ТипВызова = 2 Тогда
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы[Параметры.ТекущаяСтраница];
		КонецЕсли;
		
	КонецЕсли;
	
	Объект.КаталогСРезервнымиКопиями = РезервноеКопированиеИБСервер.ПолучитьНастройкиРезервногоКопирования().КаталогХраненияРезервныхКопий;
	ТекстЗаголовка = НСтр("ru = 'В последний раз резервное копирование проводилось: %1'"); 
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Формат(НастройкиРезервногоКопирования.ДатаПоследнегоРезервногоКопирования, "ДЛФ=ДДВ"));
	ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, МассивПараметров);
	
	Если Элементы.ВариантРасписанияРезервногоКопирования.СписокВыбора.Количество() > 3 Тогда
		Элементы.ВариантРасписанияРезервногоКопирования.СписокВыбора.Удалить(3);
	КонецЕсли;
	
	Элементы.ВариантРасписанияРезервногоКопирования.СписокВыбора.Добавить("0", Расписание);
    Объект.ВариантРасписанияРезервногоКопирования = "0";
	Элементы.ГруппаНастройкиРасписанияКопирования.Доступность = (Объект.ВариантПроведенияРезервногоКопирования = 1);

	// Заполнение настроек по хранению старых копий.
	Элементы.ГруппаВыбораТипаОчистки.Доступность = НастройкиРезервногоКопирования.ПроизводитьУдаление;
	Если НастройкиРезервногоКопирования.ПроизводитьУдаление Тогда 
		Если НастройкиРезервногоКопирования.УдалятьПоПериоду Тогда 
			НастройкиЗначенияПериода = РезервноеКопированиеИБСервер.ПолучитьПоИнтервалуВремениЗначениеПериода(НастройкиРезервногоКопирования.ЗначениеПараметра);
            Объект.ТипОграниченияКаталогаСРезервнымиКопиями = Элементы.ТипОграниченияКаталогаСРезервнымиКопиями.СписокВыбора.НайтиПоЗначению("ПоПериоду").Значение;
			Объект.ЕдиницаИзмеренияПериодаХраненияРезервныхКопий	= НастройкиЗначенияПериода.ТипПериода;
			Объект.ПериодХраненияРезервныхКопий						= НастройкиЗначенияПериода.ЗначениеПериода;
		Иначе
			Объект.ТипОграниченияКаталогаСРезервнымиКопиями = Элементы.ТипОграниченияКаталогаСРезервнымиКопиями.СписокВыбора.НайтиПоЗначению("МаксКопий").Значение;
			Объект.КоличествоКопийВКаталоге = НастройкиРезервногоКопирования.ЗначениеПараметра;
		КонецЕсли;	
	КонецЕсли;
	
	// Определение надписи заголовка формы.
	ОпределениеНадписиВнимание(НастройкиРезервногоКопирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	АдминистраторИБ = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформацияОПользователе.Имя;
	
	ПриОткрытииНовойСтраницы(Элементы.СтраницыПомощника.ТекущаяСтраница);
	КодПереключателя = Объект.КодТипаРезервногоКопирования;
	
	Если КодПереключателя = 1 Тогда
		УстановитьЗаголовокКнопкиДалее(Истина);
	Иначе
		УстановитьЗаголовокКнопкиДалее(Ложь);
	КонецЕсли;
	
	УстановитьСтраницуПараметровОтложенногоОповещения(КодПереключателя);
	УстановитьТекстПоясняющейНадписи(КодПереключателя);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаСервере
Процедура ЗапомнитьПараметрыАдминистратора(АдминистраторИБ, ПарольАдминистратораИБ, ПараметрыРезервногоКопированияИБНаКлиенте)
	
	ПараметрыРезервногоКопирования							= РезервноеКопированиеИБСервер.ПолучитьПараметрыРезервногоКопирования();
	
	Если ПараметрыРезервногоКопирования.Свойство("АдминистраторИБ") Тогда 
		ПараметрыРезервногоКопирования.АдминистраторИБ 			= АдминистраторИБ;
		ПараметрыРезервногоКопирования.ПарольАдминистратораИБ	= ПарольАдминистратораИБ;
	Иначе
		ПараметрыРезервногоКопирования.Вставить("АдминистраторИБ", АдминистраторИБ);
		ПараметрыРезервногоКопирования.Вставить("ПарольАдминистратораИБ", ПарольАдминистратораИБ);
	КонецЕсли;
	
	ПараметрыРезервногоКопированияИБНаКлиенте 				= ПараметрыРезервногоКопирования;
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьККаталогуАрхивов2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбранныйПуть = ПолучитьПуть(РежимДиалогаВыбораФайла.ВыборКаталога);
	Если Не ПустаяСтрока(ВыбранныйПуть) Тогда 
		Объект.КаталогСРезервнымиКопиями = ВыбранныйПуть;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик перехода к журналу регистрации.
&НаКлиенте
Процедура НадписьПерейтиВЖурналРегистрации1Нажатие(Элемент)
	ОткрытьФормуМодально("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации");
КонецПроцедуры

&НаКлиенте
Процедура ВариантПроведенияРезервногоКопированияПриИзменении(Элемент)
	Элементы.ГруппаНастройкиРасписанияКопирования.Доступность = (Объект.ВариантПроведенияРезервногоКопирования = 1);
КонецПроцедуры

&НаКлиенте
Процедура ПереключательКодТипаРезервногоКопированияПриИзменении(Элемент)
	КодПереключателя = Объект.КодТипаРезервногоКопирования;
	
	Если КодПереключателя = 1 Тогда
		УстановитьЗаголовокКнопкиДалее(Истина);
	Иначе
		УстановитьЗаголовокКнопкиДалее(Ложь);
	КонецЕсли;
	
	УстановитьСтраницуПараметровОтложенногоОповещения(КодПереключателя);
	УстановитьТекстПоясняющейНадписи(КодПереключателя);
КонецПроцедуры

&НаКлиенте
Процедура ОчисткаКаталогаСРезервнымиКопиямиПриПереполнении1ПриИзменении(Элемент)
	
	Элементы.ГруппаВыбораТипаОчистки.Доступность = Объект.ОчисткаКаталогаСРезервнымиКопиямиПриПереполнении;
	
КонецПроцедуры

// Обработчик выбора из списка или изменения расписания проведения резервного копирования.
&НаКлиенте
Процедура ВариантРасписанияРезервногоКопированияПриИзменении(Элемент)
	РасписаниеРезервногоКопирования = Новый РасписаниеРегламентногоЗадания;
	Если Объект.ВариантРасписанияРезервногоКопирования = "1" Тогда
		
		РасписаниеРезервногоКопирования.ПериодНедель = 1;
		РасписаниеРезервногоКопирования.ПериодПовтораДней = 1;
		МассивДнейНедели = Новый Массив;
		МассивДнейНедели.Добавить(5);
		РасписаниеРезервногоКопирования.ДниНедели = МассивДнейНедели;
		РасписаниеРезервногоКопирования.ВремяНачала = Дата(2010, 01, 01, 23, 30, 00);
		
	ИначеЕсли Объект.ВариантРасписанияРезервногоКопирования = "2" Тогда
		
		РасписаниеРезервногоКопирования.ПериодПовтораДней = 1;
		РасписаниеРезервногоКопирования.ВремяНачала = Дата(2010, 01, 01, 23, 30, 00);
		
	ИначеЕсли Объект.ВариантРасписанияРезервногоКопирования = "3" Тогда 
		
		РасписаниеРезервногоКопирования.ПериодПовтораДней = 1;
		МассивДнейНедели = Новый Массив;
		МассивДнейНедели.Добавить(2);
		МассивДнейНедели.Добавить(4);
		РасписаниеРезервногоКопирования.ДниНедели = МассивДнейНедели;
		РасписаниеРезервногоКопирования.ВремяНачала = Дата(2010, 01, 01, 23 ,30, 00);
		
	КонецЕсли;
	Объект.СтрокаРасписания = Строка(РасписаниеРезервногоКопирования);
	РасписаниеСтруктура = ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(РасписаниеРезервногоКопирования);
	ПоместитьРасписаниеВНастройку(РасписаниеСтруктура, ПараметрыРезервногоКопированияИБ);
КонецПроцедуры

&НаКлиенте
Процедура ПереключательКодТипаРезервногоКопированияКСПриИзменении(Элемент)
	
	Если Объект.КодТипаРезервногоКопирования = 3 Тогда
		Элементы.СтраницыПараметровОтложенногоОповещения1.ТекущаяСтраница = Элементы.СтраницаПараметровОтложенногоОповещения1;
	ИначеЕсли Объект.КодТипаРезервногоКопирования = 2 Тогда
		Элементы.СтраницыПараметровОтложенногоОповещения1.ТекущаяСтраница = Элементы.ПустаяСтраница1;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Далее(Команда)
	ОчиститьСообщения();	
	ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ТекущаяСтраница;
	
	Если ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаНачальногоОповещения 
		ИЛИ ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаНачальногоОповещенияКлиентСервер Тогда
		ОбработатьНачальнуюНастройкуПомощника();
	ИначеЕсли ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаНастройкиПараметровРезервногоКопирования 
		ИЛИ  ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ДополнительныеНастройки Тогда

		ИнформацияОбОшибке = "";
		Если Не ПроверитьЗаполнениеРеквизитов(ИнформацияОбОшибке) и Не ПустаяСтрока(ИнформацияОбОшибке) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ИнформацияОбОшибке);
			Возврат;
		КонецЕсли;	
		
		Если НЕ ПроверитьДоступКИБ()  Тогда
			НоваяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ДополнительныеНастройки;
			ПриОткрытииНовойСтраницы(НоваяСтраницаПомощника);
			Возврат;
		КонецЕсли;
		
		ЗапомнитьПараметрыАдминистратора(АдминистраторИБ, ПарольАдминистратораИБ, ПараметрыРезервногоКопированияИБ);
		ПриПереходеНаАвтоматическийРежимКопирования();
		ПриИзмененииВремениОповещения(-1, "", ПараметрыРезервногоКопированияИБ);
		УстановитьПутьАрхиваСКопиями(Объект.КаталогСРезервнымиКопиями, ПараметрыРезервногоКопированияИБ);
			
		Если Объект.ВыполнитьРезервноеКопированиеСейчас Тогда
			
			ПараметрыФормы = Новый Структура("ТипВызова, ТекущаяСтраница, ЗаголовокНадписи", 
						1, "СтраницаИнформацииИВыполненияРезервногоКопирования", "");
					
			ФормаОбработки = ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеИнформационнойБазы", ПараметрыФормы);
		
		КонецЕсли;		
	Иначе
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ДатаОтложенногоРезервногоКопирования = Дата('00010101');
	Закрыть();
	
КонецПроцедуры

// Вызывает стандартную форму настройки расписания регламентного задания, 
// заполняя его текущими настройками расписания резервного копирования.
&НаКлиенте
Процедура ИзменитьРасписание(Команда)
	
	Расписание = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ПараметрыРезервногоКопированияИБ.РасписаниеКопирования;
	Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание);
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	Если НЕ ДиалогРасписания.ОткрытьМодально() Тогда
		Возврат;
	КонецЕсли;
	
	Расписание = ДиалогРасписания.Расписание;
	Если Элементы.ВариантРасписанияРезервногоКопирования.СписокВыбора.Количество() > 3 Тогда
		Элементы.ВариантРасписанияРезервногоКопирования.СписокВыбора.Удалить(3);
	КонецЕсли;
	Элементы.ВариантРасписанияРезервногоКопирования.СписокВыбора.Добавить("0", Расписание);
	Объект.ВариантРасписанияРезервногоКопирования = "0";
	Объект.СтрокаРасписания = Строка(Расписание);
	РасписаниеСтруктура = ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Расписание);
	ПоместитьРасписаниеВНастройку(РасписаниеСтруктура, ПараметрыРезервногоКопированияИБ);
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ТекущаяСтраница;
	Если  ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаНастройкиПараметровРезервногоКопирования Тогда
		ПриОткрытииНовойСтраницы(Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаНачальногоОповещения);
	ИначеЕсли 	ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаНачальногоОповещения Тогда
		ПриОткрытииНовойСтраницы(Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаВыполненияРезервногоКопирования);
	ИначеЕсли ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ДополнительныеНастройки Тогда
		ПриОткрытииНовойСтраницы(Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаНастройкиПараметровРезервногоКопирования);
	КонецЕсли;
	
КонецПроцедуры

// Процедура обновления компоненты comcntr.
&НаКлиенте
Процедура ОбновитьВерсиюКомпоненты(Команда)
	
	ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОпределениеНадписиВнимание(НастройкиРезервногоКопирования)
	
	НадписьПоУмолчанию = НСтр("ru = 'Внимание! Данные информационной базы подвергаются риску, так как не выполняется их резервное копирование.'");;
	
	Если Объект.КодТипаРезервногоКопирования = 3 Тогда 
		Элементы.НадписьВнимание.Заголовок = НадписьПоУмолчанию;
	ИначеЕсли Объект.КодТипаРезервногоКопирования = 2 Тогда 
		Элементы.НадписьВнимание.Заголовок = НСтр("ru = 'Резервное копирование настроено сторонними средствами.'");
	Иначе
		Если НастройкиРезервногоКопирования.ПроводитьРезервноеКопированиеПриЗавершенииРаботы Тогда 
			Элементы.НадписьВнимание.Заголовок = НСтр("ru = 'Резервное копирование настроено по завершению работы'");
		Иначе
			Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(НастройкиРезервногоКопирования.РасписаниеКопирования);
			Если Не ПустаяСтрока(Расписание) Тогда
				Элементы.НадписьВнимание.Заголовок = НСтр("ru = 'Резервное копирование настроено:'") + " " + Строка(Расписание);
			Иначе
				Элементы.НадписьВнимание.Заголовок = НадписьПоУмолчанию;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеРеквизитов(ИнформацияОбОшибке)
	
	Если ПустаяСтрока(Объект.КаталогСРезервнымиКопиями) Тогда
		ИнформацияОбОшибке = Нстр("ru = 'Не выбран каталог для резервной копии.'");
		Возврат Ложь;
	КонецЕсли;
	
	Если НайтиФайлы(Объект.КаталогСРезервнымиКопиями).Количество() = 0 Тогда
		ИнформацияОбОшибке = Нстр("ru = 'Указан несуществующий каталог.'");
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		ТестовыйФайл = Новый ЗаписьXML;
		ТестовыйФайл.ОткрытьФайл(Объект.КаталогСРезервнымиКопиями + "/test.test1С");
		ТестовыйФайл.ЗаписатьОбъявлениеXML();
		ТестовыйФайл.Закрыть();
	Исключение
		ИнформацияОбОшибке = Нстр("ru = 'Нет доступа к каталогу с резервными копиями.'");
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		УдалитьФайлы(Объект.КаталогСРезервнымиКопиями, "*.test1С");
	Исключение
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции	

// Возвращает страницу, которая должна быть показана пользователю при открытии окна помощника.
// Если ПолныеПрава - тогда попадаем на функциональную страницу. 
// Если нет - тогда на информационную страницу с просьбой обратиться к сис. администратору.
// Состав элементов функциональной страницы зависит от архитектуры информационной базы.
&НаСервере
Функция ОпределитьСтраницуПоПравамИАрхитектуре()
	
	СтраницыПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	СтартоваяСтраница = Неопределено;
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		
		СтрокаСоединенияСБД = СтрокаСоединенияИнформационнойБазы();
		ЭтоФайловаяБаза = ОбщегоНазначения.ИнформационнаяБазаФайловая(СтрокаСоединенияСБД);

		Если ЭтоФайловаяБаза Тогда
			СтартоваяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаНачальногоОповещения;		
		Иначе
			
			СтартоваяСтраница = СтраницыПомощника.СтраницаНачальногоОповещенияКлиентСервер;
			Элементы.Далее.Заголовок = НСтр("ru = 'Готово'");
			
		КонецЕсли;
	Иначе	
		СтартоваяСтраница = СтраницыПомощника.СтраницаДляПользователяБезПрав;
	КонецЕсли;
	Возврат СтартоваяСтраница;	
	
КонецФункции

// Устанавливает текущую страницу при отложенном резервном копировании в зависимости от начального выбора пользователя.
&НаКлиенте
Процедура УстановитьСтраницуПараметровОтложенногоОповещения(ПозицияПереключателя)
	
	Если ПозицияПереключателя = 3 Тогда
		Элементы.СтраницыПараметровОтложенногоОповещения.ТекущаяСтраница = Элементы.СтраницыПараметровОтложенногоОповещения.ПодчиненныеЭлементы.СтраницаПараметровОтложенногоОповещения;
	Иначе
		Элементы.СтраницыПараметровОтложенногоОповещения.ТекущаяСтраница = Элементы.СтраницыПараметровОтложенногоОповещения.ПодчиненныеЭлементы.ПустаяСтраница;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает значение поясняющей надписи в зависимости от текущего выбора пользователя.
&НаКлиенте
Процедура УстановитьТекстПоясняющейНадписи(Знач ЗначениеПереключателя)
	
	ПоясняющаяНадпись = Элементы.ИнформационнаяНадпись;
	ТекстНадписи = "";
	
	Если ЗначениеПереключателя  = 1 Тогда
		ТекстНадписи = НСтр("ru = 'Нажмите ""Далее"" для перехода к настройке расписания автоматического резервного копирования.'");
	ИначеЕсли ЗначениеПереключателя = 2 Тогда
		ТекстНадписи = НСтр("ru = 'Более подробно о выполнении резервного копирования можно узнать из документации к используемой СУБД или специализированным средствам резервного копирования. Нажмите ""Готово"", чтобы закрыть помощник.'");
	ИначеЕсли ЗначениеПереключателя = 3 Тогда
		ТекстНадписи = НСтр("ru = 'Нажмите ""Готово"", чтобы отложить оповещение на выбранный срок.'");
	КонецЕсли;
	ПоясняющаяНадпись.Заголовок = ТекстНадписи;	
	
КонецПроцедуры

// Устанавливает заголовок кнопки "Далее" в зависимости от текущего выбора пользователя.
&НаКлиенте
Процедура УстановитьЗаголовокКнопкиДалее(ПараметрЗаголовка)
	
	Если ПараметрЗаголовка Тогда
		Элементы.Далее.Заголовок = НСтр("ru = 'Далее >>'");
	Иначе
		Элементы.Далее.Заголовок = НСтр("ru = 'Готово'");
	КонецЕсли;
	
КонецПроцедуры

// Запрашивает у пользователя путь к файлу или каталогу.
&НаКлиенте
Функция ПолучитьПуть(РежимДиалога)
	
	Режим = РежимДиалога;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	
	Если Режим = РежимДиалогаВыбораФайла.ВыборКаталога Тогда
		ДиалогОткрытияФайла.Заголовок= НСтр("ru = 'Выберите каталог'");
	Иначе
		ДиалогОткрытияФайла.Заголовок= НСтр("ru = 'Выберите файл'");
	КонецЕсли;	
		
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Если РежимДиалога = РежимДиалогаВыбораФайла.ВыборКаталога тогда
			Возврат ДиалогОткрытияФайла.Каталог;
		Иначе
			Возврат ДиалогОткрытияФайла.ПолноеИмяФайла;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Устанавливает новые параметры резервного копирования при изменении времени оповещения.
&НаСервереБезКонтекста
Процедура ПриИзмененииВремениОповещения(ПараметрКоличества, ПараметрТипа, ПараметрыРезервногоКопированияИБНаКлиенте)	
	
	ПараметрыОповещенияОРезервномКопировании = РезервноеКопированиеИБСервер.ПолучитьНастройкиРезервногоКопирования();
	ТекущаяДата = ТекущаяДатаСеанса();
	Если ПараметрКоличества = -1 Тогда // если пользователь отказался от оповещений
		
		ОстановитьСервисОповещенияОРезервномКопировании(ПараметрыРезервногоКопированияИБНаКлиенте);
		ПараметрыОповещенияОРезервномКопировании.НастроеноПользователем = Истина;

	ИначеЕсли ПараметрКоличества = 0 Тогда // если пользователь отказался от копирования, но хочет получать оповещения
		ПараметрыОповещенияОРезервномКопировании.ДатаПоследнегоОповещения = ТекущаяДата;			
	Иначе	
		ПараметрыОповещенияОРезервномКопировании.ДатаПоследнегоОповещения = ТекущаяДата;
		ПараметрыОповещенияОРезервномКопировании.ПериодОповещения = ПараметрКоличества * 
			?(ПараметрТипа = "Месяц", 
				(ДобавитьМесяц(ТекущаяДата, ПараметрКоличества) - ТекущаяДата), 
				РезервноеКопированиеИБСервер.ПолучитьВременнойПараметрПоСтроке(ПараметрТипа));
	КонецЕсли;
    ПараметрыРезервногоКопированияИБНаКлиенте = ПараметрыОповещенияОРезервномКопировании;
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(ПараметрыОповещенияОРезервномКопировании);	
	
КонецПроцедуры

// Останавливает работу сервиса резервного копирования.
&НаСервереБезКонтекста
Процедура ОстановитьСервисОповещенияОРезервномКопировании(ПараметрыРезервногоКопированияИБНаКлиенте)
	
	ПараметрыОповещенияОРезервномКопировании= РезервноеКопированиеИБСервер.ПолучитьНастройкиРезервногоКопирования();
	ПараметрыОповещенияОРезервномКопировании.ДатаПоследнегоОповещения = Дата('00010101');
	ПараметрыОповещенияОРезервномКопировании.ПериодОповещения = 0;
	ПараметрыРезервногоКопированияИБНаКлиенте = ПараметрыОповещенияОРезервномКопировании;
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(ПараметрыОповещенияОРезервномКопировании);	
	
КонецПроцедуры

// Записывает параметры настройки удаления резервных копий из каталога.
&НаСервереБезКонтекста
Процедура УстановитьНастройкиУдаленияУстаревшихКопий(ТипУдаления, ПараметрЗначения, ПараметрыРезервногоКопированияИБНаКлиенте)
	
	СтруктураНастроек = РезервноеКопированиеИБСервер.ПолучитьНастройкиРезервногоКопирования();
	СтруктураНастроек.ПроизводитьУдаление = Истина;
	СтруктураНастроек.УдалятьПоПериоду = ТипУдаления;
	СтруктураНастроек.ЗначениеПараметра = ПараметрЗначения;
	ПараметрыРезервногоКопированияИБНаКлиенте = СтруктураНастроек;
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(СтруктураНастроек);
	
КонецПроцедуры

// Записывает настройку - путь к каталогу с резервными копиями.
&НаСервереБезКонтекста
Процедура УстановитьПутьАрхиваСКопиями(Путь, ПараметрыРезервногоКопированияИБНаКлиенте)
	
	НастройкиПути = РезервноеКопированиеИБСервер.ПолучитьНастройкиРезервногоКопирования();
	НастройкиПути.КаталогХраненияРезервныхКопий = Путь;
	ПараметрыРезервногоКопированияИБНаКлиенте = НастройкиПути;
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(НастройкиПути);
	
КонецПроцедуры

// Записывает настройку - расписание проведения резервного копирования.
&НаСервереБезКонтекста
Процедура ПоместитьРасписаниеВНастройку(НовоеРасписаниеКопирования, ПараметрыРезервногоКопированияИБНаКлиенте)
	
	Параметры = РезервноеКопированиеИБСервер.ПолучитьНастройкиРезервногоКопирования();
	Параметры.РасписаниеКопирования = НовоеРасписаниеКопирования;
	ПараметрыРезервногоКопированияИБНаКлиенте = Параметры;
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(Параметры);
	ОбновитьПовторноИспользуемыеЗначения();  // сбрысываем кеш для применения настроек
	
КонецПроцедуры

// Показывает оповещение пользователю с заданным текстом.
&НаКлиенте
Процедура ОповещениеПользователю(ТекстОповещения)
	
	ПоказатьОповещениеПользователя("Резервное копирование", , ТекстОповещения)
	
КонецПроцедуры

// Показывает оповещение пользователю при завершении работы с формой настройки резервного копирования.
&НаКлиенте
Процедура ПриЗавершенииРаботыПомощника(РезультатРаботыПомощника)
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Работа помощника завершена.'"), "e1cib/app/Обработка.НастройкаРезервногоКопированияИБ", РезультатРаботыПомощника);
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

// Обработчик значения переключателя "Код типа резервного копирования" при нажатии на кнопку "Далее".
&НаКлиенте
Процедура ОбработатьНачальнуюНастройкуПомощника()
	
	РезервноеКопированиеИБВызовСервера.ОстановитьАвтоматическоеРезервноеКопирование(ПараметрыРезервногоКопированияИБ);
	КодПереключателя = Объект.КодТипаРезервногоКопирования;
	РезервноеКопированиеИБВызовСервера.УстановитьКодВыбора(КодПереключателя, ПараметрыРезервногоКопированияИБ);
	НоваяСтраницаПомощника = Неопределено;

	Если КодПереключателя = 1 Тогда // Настройка автоматического резервного копирования.
		НоваяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаНастройкиПараметровРезервногоКопирования;	
	ИначеЕсли КодПереключателя = 2 Тогда // Копирование сторонними средствами.
		ОповещениеПользователю(НСтр("ru ='Работа помощника завершена. С этого момента оповещения о резервном копировании поступать не будут.'"));
		РезервноеКопированиеИБВызовСервера.ОстановитьСервисОповещения(ПараметрыРезервногоКопированияИБ);
	ИначеЕсли КодПереключателя = 3 Тогда // Отложенное копирование.
		ПриИзмененииВремениОповещения(Объект.ПериодОповещения, Объект.ЕдиницаИзмеренияПериодаОповещения, ПараметрыРезервногоКопированияИБ);			
		ОповещениеПользователю(НСтр("ru ='Был изменен период оповещений о резервном копировании.'"));
	КонецЕсли;
	ПриОткрытииНовойСтраницы(НоваяСтраницаПомощника);
	
КонецПроцедуры

// Обработчик изменения страницы помощника. Открывает новую страницу и выполняет необходимые действия.
// Параметры :
// НоваяСтраницаПомощника  - страница , которую необходимо открыть в данный момент.
&НаКлиенте
Процедура ПриОткрытииНовойСтраницы(НоваяСтраница, ТекстПути = "")
	
	ПодчиненныеСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;	
	Если НоваяСтраница  = ПодчиненныеСтраницы.СтраницаНачальногоОповещения Тогда
		
		Элементы.Назад.Видимость = Объект.НажатиеГиперссылки;
		УстановитьЗаголовокКнопкиДалее(Истина);
		
	ИначеЕсли НоваяСтраница = ПодчиненныеСтраницы.СтраницаНастройкиПараметровРезервногоКопирования Тогда
		
		УстановитьЗаголовокКнопкиДалее(Ложь);
		Элементы.Назад.Видимость = Истина;
		                      
	ИначеЕсли НоваяСтраница = ПодчиненныеСтраницы.СтраницаНачальногоОповещенияКлиентСервер Тогда	
		
		УстановитьЗаголовокКнопкиДалее(Ложь);
		
	ИначеЕсли НоваяСтраница = ПодчиненныеСтраницы.ДополнительныеНастройки Тогда
		
		Элементы.Назад.Видимость = Истина;
		АдминистраторИБ = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформацияОПользователе.Имя;

	КонецЕсли;	

	Если НоваяСтраница = Неопределено Тогда
		Закрыть();
	Иначе
		Элементы.СтраницыПомощника.ТекущаяСтраница = НоваяСтраница;
	КонецЕсли;
	
КонецПроцедуры
 
&НаКлиенте
Функция ПроверитьДоступКИБ()

	Результат = Истина;
	// В базовых версиях проверку подключения не осуществляем;
	// при некорректном вводе имени и пароля обновление завершится неуспешно.
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
		Возврат Результат;
	КонецЕсли; 
	ПараметрыПодключения	= ПолучитьПараметрыАутентификацииАдминистратораОбновления();
	
	Попытка
		ComConnector			= Новый COMОбъект(СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИмяCOMСоединителя);
		СтрокаСоединенияИнформационнойБазы = ПараметрыПодключения.СтрокаСоединенияИнформационнойБазы + ПараметрыПодключения.СтрокаПодключения;
		Соединение = ComConnector.Connect(СтрокаСоединенияИнформационнойБазы);
	Исключение
		Результат = Ложь;
		Инфо = ИнформацияОбОшибке();
		ОбнаруженнаяОшибкаПодключения = КраткоеПредставлениеОшибки(Инфо);
		
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(),"Ошибка", ОбнаруженнаяОшибкаПодключения, , Истина);
			
	КонецПопытки;	
	
	Возврат Результат;
	
КонецФункции

// Обработчик перехода на автоматическое резервное копирование.
&НаКлиенте
Процедура ПриПереходеНаАвтоматическийРежимКопирования()
	
	Если ПроверитьЗаполнение() Тогда
		
		СохранитьНастройкиПоОчисткеКаталогаСРезервнымиКопиями(ПараметрыРезервногоКопированияИБ);
		
		Если Объект.ВариантПроведенияРезервногоКопирования = 1 Тогда	
			ОповещатьОРезервномКопированииПриЗавершенииСеанса = Ложь;
			РезервноеКопированиеИБВызовСервера.УстановитьДатуСледующегоАвтоматическогоКопирования(ПараметрыРезервногоКопированияИБ, Истина);
		Иначе
			ОповещатьОРезервномКопированииПриЗавершенииСеанса = Истина;
			РезервноеКопированиеИБВызовСервера.ОстановитьАвтоматическоеРезервноеКопирование(ПараметрыРезервногоКопированияИБ, Истина);
		КонецЕсли;	
		ПриЗавершенииРаботыПомощника(НСтр("ru = 'Настройка расписания резервного копирования прошла успешно.'"));
		ОстановитьСервисОповещенияОРезервномКопировании(ПараметрыРезервногоКопированияИБ);
	КонецЕсли;
	
КонецПроцедуры

 &НаСервере
Процедура СохранитьНастройкиПоОчисткеКаталогаСРезервнымиКопиями(ПараметрыРезервногоКопированияИБНаКлиенте)
	
	РезервноеКопированиеИБСервер.УстановитьЗначениеНастройки("ПроизводитьУдаление", Объект.ОчисткаКаталогаСРезервнымиКопиямиПриПереполнении, ПараметрыРезервногоКопированияИБНаКлиенте);
	Если Объект.ОчисткаКаталогаСРезервнымиКопиямиПриПереполнении Тогда
		Если Объект.ТипОграниченияКаталогаСРезервнымиКопиями = "ПоПериоду" Тогда
			ЗаданныйПериод = Объект.ЕдиницаИзмеренияПериодаХраненияРезервныхКопий;
			Если ЗаданныйПериод = "Год" Тогда 
				ПериодВСекундах = 3600 * 24 * 365;
			ИначеЕсли ЗаданныйПериод = "Месяц" Тогда 
				ПериодВСекундах = 3600 * 24 * 30;
			Иначе
				ПериодВСекундах = РезервноеКопированиеИБСервер.ПолучитьВременнойПараметрПоСтроке(ЗаданныйПериод);
			КонецЕсли;
			ПараметрЗначенияОграничения = Объект.ПериодХраненияРезервныхКопий * ПериодВСекундах;
		Иначе
			ПараметрЗначенияОграничения = Объект.КоличествоКопийВКаталоге;
		КонецЕсли;	
		УстановитьНастройкиУдаленияУстаревшихКопий(?(Объект.ТипОграниченияКаталогаСРезервнымиКопиями = "ПоПериоду", Истина, Ложь), ПараметрЗначенияОграничения, ПараметрыРезервногоКопированияИБНаКлиенте);
		УстановитьПутьАрхиваСКопиями(Объект.КаталогСРезервнымиКопиями, ПараметрыРезервногоКопированияИБНаКлиенте);
	Иначе
		ПараметрЗначенияОграничения = 0;
		УстановитьНастройкиУдаленияУстаревшихКопий(Ложь, 0, ПараметрыРезервногоКопированияИБНаКлиенте);
	КонецЕсли;
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции проведения резервного копирования

 &НаСервере
Функция ПолучитьСтрокуСоединенияИИнформациюОСоединениях(СообщенияДляЖурналаРегистрации)
	
	// запись накопленных событий ЖР
	ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	Результат = ПолучитьИнформациюОНаличииСоединений();
	Результат.Вставить("СтрокаСоединенияИнформационнойБазы", 
	СоединенияИБКлиентСервер.ПолучитьСтрокуСоединенияИнформационнойБазы(0));
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыАутентификацииАдминистратораОбновления() 
	
	Результат = Новый Структура("ИмяПользователя,
	|ПарольПользователя,
	|СтрокаПодключения,
	|ПараметрыАутентификации,
	|СтрокаСоединенияИнформационнойБазы",
	Неопределено, "", "", "", "", "");
	
	ТекущиеСоединения = ПолучитьСтрокуСоединенияИИнформациюОСоединениях(СообщенияДляЖурналаРегистрации);
	Результат.СтрокаСоединенияИнформационнойБазы = ТекущиеСоединения.СтрокаСоединенияИнформационнойБазы;
	// Диагностика случая, когда ролевой безопасности в системе не предусмотрено.
	// Т.е. ситуация, когда любой пользователь «может» в системе все.
	Если НЕ ТекущиеСоединения.ЕстьАктивныеПользователи Тогда
		Возврат Результат;
	КонецЕсли;
	
	Пользователь = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформацияОПользователе.Имя;
	
	Результат.ИмяПользователя			= Пользователь;
	Результат.ПарольПользователя		= ПарольАдминистратораИБ;
	Результат.СтрокаПодключения			= "Usr=""" + Пользователь + """;Pwd=""" + ПарольАдминистратораИБ + """;";
	Результат.ПараметрыАутентификации	= "/N""" + Пользователь + """ /P""" + ПарольАдминистратораИБ + """ /WA-";
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИнформациюОНаличииСоединений(СообщенияДляЖурналаРегистрации = Неопределено)
	
	ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Структура("НаличиеАктивныхСоединений, НаличиеCOMСоединений, НаличиеСоединенияКонфигуратором, ЕстьАктивныеПользователи",
								Ложь,
								Ложь,
								Ложь,
								Ложь);
	
	Если ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0 Тогда 
		Результат.ЕстьАктивныеПользователи = Истина;
	КонецЕсли;
	
	МассивСеансов = ПолучитьСеансыИнформационнойБазы();
	Если МассивСеансов.Количество() = 1 Тогда 
		Возврат Результат;
	КонецЕсли;
	
	Результат.НаличиеАктивныхСоединений = Истина;
	
	Для Каждого Сеанс Из МассивСеансов Цикл
		Если ЭтоCOMСоединение(Сеанс) Тогда 
			 Результат.НаличиеCOMСоединений = Истина;
		ИначеЕсли ЭтоСеансКонфигуратором(Сеанс) Тогда 
			Результат.НаличиеСоединенияКонфигуратором = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоСеансКонфигуратором(СеансИнформационнойБазы)
	
	Возврат ВРег(СеансИнформационнойБазы.ИмяПриложения) = ВРег("Designer");
	
КонецФункции 

&НаСервереБезКонтекста
Функция ЭтоCOMСоединение(СеансИнформационнойБазы)
	
	Возврат ВРег(СеансИнформационнойБазы.ИмяПриложения) = ВРег("COMConnection");
	
КонецФункции 
