﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьОтборЖурналаРегистрацииПоУмолчанию();
	ОтборЖурналаРегистрации = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ОтборЖурналаРегистрацииПоУмолчанию);
	
	КоличествоПоказываемыхСобытий = 200;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекущийСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ИдентификаторЗадания <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ЖурналВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЖурналРегистрацииКлиент.СобытияВыбор(Элементы.Журнал.ТекущиеДанные, Поле, ИнтервалДат, ОтборЖурналаРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПоказываемыхСобытийПриИзменении(Элемент)
	
#Если ВебКлиент Тогда
	КоличествоПоказываемыхСобытий = ?(КоличествоПоказываемыхСобытий > 1000, 1000, КоличествоПоказываемыхСобытий);
#КонецЕсли
	
	ОбновитьТекущийСписок();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОбновитьТекущийСписок() 
	 	
	Элементы.Страницы.ТекущаяСтраница = Элементы.ИндикаторДлительныхОпераций;
	
	РезультатВыполнения = ПрочитатьЖурнал(ОтборЖурналаРегистрации);
	
	ПараметрыОбработчикаОжидания = Новый Структура;
	
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "ФормированиеОтчета");
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ПозиционированиеВКонецСписка();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтбор()
	
	ОтборЖурналаРегистрации = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ОтборЖурналаРегистрацииПоУмолчанию);
	ОбновитьТекущийСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрТекущегоСобытияВОтдельномОкне()
	
	ЖурналРегистрацииКлиент.ПросмотрТекущегоСобытияВОтдельномОкне(Элементы.Журнал.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалДатДляПросмотра()
	
	Если ЖурналРегистрацииКлиент.УстановитьИнтервалДатДляПросмотра(ИнтервалДат, ОтборЖурналаРегистрации) Тогда
		ОбновитьТекущийСписок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоЗначениюВТекущейКолонке()
	
	// Для установки отбора по значению в текущей колонке, 
	// отбор по умолчанию сначала отключается, а затем восстанавливается
	
	УдалитьИзОтбораЗначенияПоУмолчанию();
	
	КолонкиИсключения = Новый Массив;
	КолонкиИсключения.Добавить("Дата");
	КолонкиИсключения.Добавить("СведенияОСобытии");
	
	ОбновлятьСписок = ЖурналРегистрацииКлиент.УстановитьОтборПоЗначениюВТекущейКолонке(Элементы.Журнал.ТекущиеДанные, Элементы.Журнал.ТекущийЭлемент, ОтборЖурналаРегистрации, КолонкиИсключения);
	
	ДополнитьОтборЗначениямиПоУмолчанию();
	
	Если ОбновлятьСписок Тогда
		ОбновитьТекущийСписок();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОтчета(ОтборЖурналаНаКлиенте)
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Журнал", РеквизитФормыВЗначение("Журнал"));
	ПараметрыОтчета.Вставить("ОтборЖурналаРегистрации", ОтборЖурналаНаКлиенте);
	ПараметрыОтчета.Вставить("КоличествоПоказываемыхСобытий", КоличествоПоказываемыхСобытий);
	ПараметрыОтчета.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("МенеджерВладельца", Обработки.ЗащитаПерсональныхДанных);
	ПараметрыОтчета.Вставить("ДобавлятьДополнительныеКолонки", Истина);
	
	Возврат ПараметрыОтчета;
КонецФункции

&НаСервере
Функция ЗаполнитьОтборЖурналаРегистрацииПоУмолчанию()
	
	ОтборЖурналаРегистрацииПоУмолчанию = Новый Структура;
	ОтборЖурналаРегистрацииПоУмолчанию.Вставить("Событие",			ЗащитаПерсональныхДанныхПовтИсп.СписокКонтролируемыхСобытий152ФЗ());
	ОтборЖурналаРегистрацииПоУмолчанию.Вставить("ИмяПриложения", 	ЗащитаПерсональныхДанныхПовтИсп.СписокКонтролируемыхПриложений152ФЗ());
	
КонецФункции

&НаСервере
Функция ПрочитатьЖурнал(ОтборЖурналаНаКлиенте)
	
	ПараметрыОтчета = ПараметрыОтчета(ОтборЖурналаНаКлиенте);
	
	ИБФайловая = Неопределено;
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	Если ИБФайловая = Неопределено Тогда
		ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "НеИспользовать");
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		ЖурналРегистрации.ПрочитатьСобытияЖурналаРегистрации(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"ЖурналРегистрации.ПрочитатьСобытияЖурналаРегистрации", 
			ПараметрыОтчета, 
			НСтр("ru = 'Защита персональных данных'"));
						
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;		
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	ЖурналРегистрации.СформироватьПредставлениеОтбора(ПредставлениеОтбора, ОтборЖурналаНаКлиенте, ОтборЖурналаРегистрацииПоУмолчанию);
	
	Возврат РезультатВыполнения;
КонецФункции

&НаКлиенте
Процедура ДополнитьОтборЗначениямиПоУмолчанию()
	
	Для Каждого ЭлементОтбора Из ОтборЖурналаРегистрацииПоУмолчанию Цикл
		ЗначениеОтбораПоУмолчанию = ЭлементОтбора.Значение;
		Если НЕ ОтборЖурналаРегистрации.Свойство(ЭлементОтбора.Ключ) Тогда
			// Отбор не был установлен
			Если ТипЗнч(ЗначениеОтбораПоУмолчанию) = Тип("СписокЗначений") Тогда
				ОтборЖурналаРегистрации.Вставить(ЭлементОтбора.Ключ, ЗначениеОтбораПоУмолчанию.Скопировать());
			Иначе
				ОтборЖурналаРегистрации.Вставить(ЭлементОтбора.Ключ, ЗначениеОтбораПоУмолчанию);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзОтбораЗначенияПоУмолчанию()
	
	Для Каждого ЭлементОтбораПоУмолчанию Из ОтборЖурналаРегистрацииПоУмолчанию Цикл
		ЗначениеОтбора = "";
		Если ОтборЖурналаРегистрации.Свойство(ЭлементОтбораПоУмолчанию.Ключ, ЗначениеОтбора) Тогда
			// Отбор удаляется только в случае, если он в точности соответствует значению отбора по умолчанию
			Если ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") Тогда
				УдалятьОтбор = ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(ЗначениеОтбора, ЭлементОтбораПоУмолчанию.Значение);
			Иначе	
				УдалятьОтбор = ЭлементОтбораПоУмолчанию.Значение = ЗначениеОтбора;
			КонецЕсли;
			Если УдалятьОтбор Тогда
				ОтборЖурналаРегистрации.Удалить(ЭлементОтбораПоУмолчанию.Ключ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	СобытияЖурнала       = РезультатВыполнения.СобытияЖурнала;
	
	ЖурналРегистрации.ПоместитьДанныеВоВременноеХранилище(СобытияЖурнала, УникальныйИдентификатор);
	
	ЗначениеВДанныеФормы(СобытияЖурнала, Журнал);
	ИдентификаторЗадания = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()  
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "НеИспользовать");
			Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
			ПозиционированиеВКонецСписка();
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "НеИспользовать");
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ПозиционированиеВКонецСписка();
		ВызватьИсключение;
	КонецПопытки;	
КонецПроцедуры

&НаКлиенте
Процедура ПозиционированиеВКонецСписка()
	Если Журнал.Количество() > 0 Тогда
		Элементы.Журнал.ТекущаяСтрока = Журнал[Журнал.Количество() - 1].ПолучитьИдентификатор();
	КонецЕсли;
КонецПроцедуры 

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

