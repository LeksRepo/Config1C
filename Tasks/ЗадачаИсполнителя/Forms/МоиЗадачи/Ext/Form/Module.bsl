﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	Список.Параметры.УстановитьЗначениеПараметра("НезаполненнаяДата", Дата(1,1,1));
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоказыватьВыполненные", ПоказыватьВыполненные);	
	УстановитьОтбор(ПараметрыОтбора);	
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	Элементы.ДатаНачала.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	Элементы.Дата.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ПометкаУдаления", Ложь, ВидСравненияКомпоновкиДанных.Равно, , ,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	СгруппироватьПоКолонкеНаСервере(Настройки["РежимГруппировки"]);
	УстановитьОтбор(Настройки);	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" Тогда
		ОбновитьСписокЗадачНаСервере();
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СгруппироватьПоВажности(Команда)
	СгруппироватьПоКолонке("Важность");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоБезГруппировки(Команда)
	СгруппироватьПоКолонке("");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоТочкеМаршрута(Команда)
	СгруппироватьПоКолонке("ТочкаМаршрута");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоАвтору(Команда)
	СгруппироватьПоКолонке("Автор");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоПредмету(Команда)
	СгруппироватьПоКолонке("ПредметСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьВыполненныеПриИзменении(Элемент)
	
	УстановитьОтборНаКлиенте();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	БизнесПроцессыИЗадачиКлиент.СписокЗадачПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, 
		Родитель, Группа);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ПринятьЗадачиКИсполнению(Элементы.Список.ВыделенныеСтроки);
		
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОтменитьПринятиеЗадачКИсполнению(Элементы.Список.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокЗадач(Команда)
	
	ОбновитьСписокЗадачНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура СгруппироватьПоКолонке(Знач ИмяКолонкиРеквизита)
	РежимГруппировки = ИмяКолонкиРеквизита;
	Если НЕ ПустаяСтрока(РежимГруппировки) Тогда
		ПоказыватьВыполненные = Ложь;
		УстановитьОтборНаКлиенте();
	КонецЕсли;
	Список.Группировка.Элементы.Очистить();
	Если НЕ ПустаяСтрока(ИмяКолонкиРеквизита) Тогда
		ПолеГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(ИмяКолонкиРеквизита);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СгруппироватьПоКолонкеНаСервере(Знач ИмяКолонкиРеквизита)
	РежимГруппировки = ИмяКолонкиРеквизита;
	Если НЕ ПустаяСтрока(РежимГруппировки) Тогда
		ПоказыватьВыполненные = Ложь;
		ПараметрыОтбора = Новый Соответствие();
		ПараметрыОтбора.Вставить("ПоказыватьВыполненные", ПоказыватьВыполненные);	
		УстановитьОтбор(ПараметрыОтбора);	
	КонецЕсли;
	Список.Группировка.Элементы.Очистить();
	Если НЕ ПустаяСтрока(ИмяКолонкиРеквизита) Тогда
		ПолеГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(ИмяКолонкиРеквизита);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборНаКлиенте()
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоказыватьВыполненные", ПоказыватьВыполненные);	
	УстановитьОтбор(ПараметрыОтбора);	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор(ПараметрыОтбора)
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Выполнена");
	
	Если ПараметрыОтбора["ПоказыватьВыполненные"] Тогда
		СгруппироватьПоКолонкеНаСервере("");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Выполнена", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗадачНаСервере()
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список);
	Элементы.Список.Обновить();
	
КонецПроцедуры
