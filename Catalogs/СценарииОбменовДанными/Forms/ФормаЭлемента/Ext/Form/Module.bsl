﻿&НаКлиенте
Перем НомерОбрабатываемойСтроки;

&НаКлиенте
Перем КоличествоСтрок;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = (Объект.Ссылка.Пустая());
	
	УзелИнформационнойБазы = Неопределено;
	
	Если ЭтоНовый
		И Параметры.Свойство("УзелИнформационнойБазы", УзелИнформационнойБазы)
		И УзелИнформационнойБазы <> Неопределено Тогда
		
		Справочники.СценарииОбменовДанными.ДобавитьЗагрузкуВСценарииОбменаДанными(Объект, УзелИнформационнойБазы);
		Справочники.СценарииОбменовДанными.ДобавитьВыгрузкуВСценарииОбменаДанными(Объект, УзелИнформационнойБазы);
		
		Наименование = НСтр("ru = 'Сценарий синхронизации для %1'");
		Объект.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Наименование, Строка(УзелИнформационнойБазы));
		
		РасписаниеРегламентногоЗадания = Справочники.СценарииОбменовДанными.РасписаниеРегламентногоЗаданияПоУмолчанию();
		
		Объект.ИспользоватьРегламентноеЗадание = Истина;
		
	Иначе
		
		// получаем расписание из самого регламентного задания
		// если РЗ не задано, то расписание = Неопределено и будет создано на клиенте в момент редактирования расписания
		РасписаниеРегламентногоЗадания = Справочники.СценарииОбменовДанными.ПолучитьРасписаниеВыполненияОбменаДанными(Объект.Ссылка);
		
	КонецЕсли;
	
	Если Не ЭтоНовый Тогда
		
		ОбновитьСостоянияОбменовДанными();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьПредставлениеРасписания();
	
	УстановитьДоступностьГиперСсылкиНастройкиРасписания();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	
	Справочники.СценарииОбменовДанными.ОбновитьДанныеРегламентногоЗадания(Отказ, РасписаниеРегламентногоЗадания, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_СценарииОбменовДанными", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ИспользоватьРегламентноеЗаданиеПриИзменении(Элемент)
	
	УстановитьДоступностьГиперСсылкиНастройкиРасписания();
	
КонецПроцедуры

&НаКлиенте
Процедура СоставРасписанияПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокВыбораВидаТранспортаОбмена(Элемент.ПодчиненныеЭлементы.НастройкиОбменаВидТранспортаОбмена.СписокВыбора, Элемент.ТекущиеДанные.УзелИнформационнойБазы);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаУзелИнформационнойБазыПриИзменении(Элемент)
	
	Элементы.СоставРасписания.ТекущиеДанные.ВидТранспортаОбмена = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, 
		ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ НастройкиОбмена

&НаКлиенте
Процедура НастройкиОбменаВидТранспортаОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СоставРасписания.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ЗаполнитьСписокВыбораВидаТранспортаОбмена(Элемент.СписокВыбора, ТекущиеДанные.УзелИнформационнойБазы);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ЭтоНовый = (Объект.Ссылка.Пустая());
	
	Если Модифицированность ИЛИ ЭтоНовый Тогда
		
		Записать();
		
	КонецЕсли;
	
	НомерОбрабатываемойСтроки     = 1;
	КоличествоСтрок = Объект.НастройкиОбмена.Количество();
	
	ПодключитьОбработчикОжидания("ВыполнитьОбменДаннымиНаКлиенте", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗадания(Команда)
	
	РедактированиеРасписанияРегламентногоЗадания();
	
	ОбновитьПредставлениеРасписания();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТранспорта(Команда)
	
	ТекущиеДанные = Элементы.СоставРасписания.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(ТекущиеДанные.УзелИнформационнойБазы) Тогда
		Возврат;
	КонецЕсли;
	
	Отбор              = Новый Структура("Узел", ТекущиеДанные.УзелИнформационнойБазы);
	ЗначенияЗаполнения = Новый Структура("Узел", ТекущиеДанные.УзелИнформационнойБазы);
	
	ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор, ЗначенияЗаполнения, "НастройкиТранспортаОбмена", ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрации(Команда)
	
	ТекущиеДанные = Элементы.СоставРасписания.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиКлиент.ПерейтиВЖурналРегистрацииСобытийДанныхМодально(ТекущиеДанные.УзелИнформационнойБазы,
																	ЭтотОбъект,
																	ТекущиеДанные.ВыполняемоеДействие);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура РедактированиеРасписанияРегламентногоЗадания()
	
	// если расписание не инициализировано в форме на сервере, то создаем новое
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
		
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	
	// открываем диалог для редактирования Расписания
	ОписаниеОповещения = Новый ОписаниеОповещения("РедактированиеРасписанияРегламентногоЗаданияЗавершение", ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеРасписанияРегламентногоЗаданияЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание <> Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = Расписание;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставлениеРасписания()
	
	ПредставлениеРасписания = Строка(РасписаниеРегламентногоЗадания);
	
	Если ПредставлениеРасписания = Строка(Новый РасписаниеРегламентногоЗадания) Тогда
		
		ПредставлениеРасписания = НСтр("ru = 'Расписание не задано'");
		
	КонецЕсли;
	
	Элементы.НастроитьРасписаниеРегламентногоЗадания.Заголовок = ПредставлениеРасписания;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьГиперСсылкиНастройкиРасписания()
	
	Элементы.НастроитьРасписаниеРегламентногоЗадания.Доступность = Объект.ИспользоватьРегламентноеЗадание;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбменДаннымиНаКлиенте()
	
	Если НомерОбрабатываемойСтроки > КоличествоСтрок Тогда // выход из рекурсии
		ВыводитьСостояние = (КоличествоСтрок > 1);
		Состояние(НСтр("ru = 'Данные синхронизированы.'"), ?(ВыводитьСостояние, 100, Неопределено));
		Возврат; // выходим
	КонецЕсли;
	
	ТекущиеДанные = Объект.НастройкиОбмена[НомерОбрабатываемойСтроки - 1];
	
	ВыводитьСостояние = (КоличествоСтрок > 1);
	
	СтрокаСообщения = НСтр("ru = 'Выполняется %1 для %2'");
	СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, 
							Строка(ТекущиеДанные.ВыполняемоеДействие),
							Строка(ТекущиеДанные.УзелИнформационнойБазы));
	//
	Прогресс = Окр(100 * (НомерОбрабатываемойСтроки -1) / ?(КоличествоСтрок = 0, 1, КоличествоСтрок));
	Состояние(СтрокаСообщения, ?(ВыводитьСостояние, Прогресс, Неопределено));
	
	// запускаем выполнение обмена по строке настройки
	ВыполнитьОбменДаннымиПоСтрокеНастройки(НомерОбрабатываемойСтроки);
	
	ОбработкаПрерыванияПользователя();
	
	НомерОбрабатываемойСтроки = НомерОбрабатываемойСтроки + 1;
	
	// рекурсивно вызываем эту процедуру
	ПодключитьОбработчикОжидания("ВыполнитьОбменДаннымиНаКлиенте", 0.1, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСостоянияОбменовДанными()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы,
	|	СценарииОбменовДаннымиНастройкиОбмена.ВидТранспортаОбмена,
	|	СценарииОбменовДаннымиНастройкиОбмена.ВыполняемоеДействие,
	|	СценарииОбменовДаннымиНастройкиОбмена.КоличествоЭлементовВТранзакции,
	|	ВЫБОР
	|	КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена ЕСТЬ NULL
	|	ТОГДА 0
	|	КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.Предупреждение_СообщениеОбменаБылоРанееПринято)
	|	ТОГДА 2
	|	КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.ВыполненоСПредупреждениями)
	|	ТОГДА 2
	|	КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.Выполнено)
	|	ТОГДА 0
	|	ИНАЧЕ 1
	|	КОНЕЦ КАК РезультатВыполненияОбмена
	|ИЗ
	|	Справочник.СценарииОбменовДанными.НастройкиОбмена КАК СценарииОбменовДаннымиНастройкиОбмена
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОбменовДанными КАК СостоянияОбменовДанными
	|	ПО СостоянияОбменовДанными.УзелИнформационнойБазы = СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы
	|	 И СостоянияОбменовДанными.ДействиеПриОбмене      = СценарииОбменовДаннымиНастройкиОбмена.ВыполняемоеДействие
	|ГДЕ
	|	СценарииОбменовДаннымиНастройкиОбмена.Ссылка = &Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	СценарииОбменовДаннымиНастройкиОбмена.НомерСтроки ВОЗР
	|";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Объект.НастройкиОбмена.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьОбменДаннымиПоСтрокеНастройки(Знач Индекс)
	
	Отказ = Ложь;
	
	// запускаем выполнение обмена
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, Объект.Ссылка, Индекс);
	
	// обновляем данных табличной части сценария обмена
	ОбновитьСостоянияОбменовДанными();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораВидаТранспортаОбмена(СписокВыбора, УзелИнформационнойБазы)
	
	СписокВыбора.Очистить();
	
	Если ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
		
		Для Каждого Элемент Из ИспользуемыеТранспортыСообщенийОбмена(УзелИнформационнойБазы) Цикл
			
			СписокВыбора.Добавить(Элемент, Строка(Элемент));
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИспользуемыеТранспортыСообщенийОбмена(Знач УзелИнформационнойБазы)
	
	Возврат ОбменДаннымиПовтИсп.ИспользуемыеТранспортыСообщенийОбмена(УзелИнформационнойБазы);
	
КонецФункции

