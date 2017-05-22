﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РежимУдаления = "Полный";
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура РежимУдаленияПриИзменении(Элемент)
	
	ОбновитьДоступностьКнопок();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокПомеченныхНаУдаление

&НаКлиенте
Процедура ПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокПомеченныхНаУдаление.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПометкуВСписке(ТекущиеДанные, ТекущиеДанные.Пометка, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПомеченныхНаУдалениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ОткрытьЗначениеПоТипу(Элемент.ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДеревоОставшихсяОбъектов

&НаКлиенте
Процедура ДеревоОставшихсяОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		ОткрытьЗначениеПоТипу(Элемент.ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОставшихсяОбъектовПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ОткрытьЗначениеПоТипу(Элемент.ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаСписокПомеченныхУстановитьВсе()
	
	ЭлементыСписка = СписокПомеченныхНаУдаление.ПолучитьЭлементы();
	Для Каждого Элемент Из ЭлементыСписка Цикл
		УстановитьПометкуВСписке(Элемент, Истина, Истина);
		Родитель = Элемент.ПолучитьРодителя();
		Если Родитель = Неопределено Тогда
			ПроверитьРодителя(Элемент)
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСписокПомеченныхСнятьВсе()
	
	ЭлементыСписка = СписокПомеченныхНаУдаление.ПолучитьЭлементы();
	Для Каждого Элемент Из ЭлементыСписка Цикл
		УстановитьПометкуВСписке(Элемент, Ложь, Истина);
		Родитель = Элемент.ПолучитьРодителя();
		Если Родитель = Неопределено Тогда
			ПроверитьРодителя(Элемент)
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОбъект(Команда)
	
	Если ТекущийЭлемент = Неопределено Тогда
		Возврат;	
	КонецЕсли;
		
	Если ТекущийЭлемент <> Элементы.СписокПомеченныхНаУдаление И ТекущийЭлемент <> Элементы.ДеревоОставшихсяОбъектов Тогда
		Возврат;	
	КонецЕсли;
	
	Если ТекущийЭлемент.ТекущиеДанные <> Неопределено Тогда
		ОткрытьЗначениеПоТипу(ТекущийЭлемент.ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДалее()
	
	ТекущаяСтраница = Элементы.СтраницыФормы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.ВыборРежимаУдаления Тогда
		
		ОбновитьСписокПомеченныхНаУдаление(Неопределено);
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ПомеченныеНаУдаление;
		ОбновитьДоступностьКнопок();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьНазад()
	
	ТекущаяСтраница = Элементы.СтраницыФормы.ТекущаяСтраница;
	Если ТекущаяСтраница = Элементы.ПомеченныеНаУдаление Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыборРежимаУдаления;
		ОбновитьДоступностьКнопок();
	ИначеЕсли ТекущаяСтраница = Элементы.ПричиныНевозможностиУдаления Тогда
		Если РежимУдаления = "Полный" Тогда
			Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыборРежимаУдаления;
		Иначе
			Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ПомеченныеНаУдаление;
		КонецЕсли;
		ОбновитьДоступностьКнопок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьУдаление()
	
	Перем ТипыУдаленныхОбъектов;
	
	Если РежимУдаления = "Полный" Тогда
		Состояние(НСтр("ru = 'Выполняется поиск и удаление помеченных объектов'"));
	Иначе
		Состояние(НСтр("ru = 'Выполняется удаление выбранных объектов'"));
	КонецЕсли;
	
	Результат = УдалениеВыбранныхНаСервере(ТипыУдаленныхОбъектов);
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ДлительнаяОперация; 
	Иначе
		ОбновитьСодержание(Результат.РезультатУдаления, Результат.СообщениеОбОшибке,
			Результат.РезультатУдаления.ТипыУдаленныхОбъектов);
		ПодключитьОбработчикОжидания("ПереключитьСтраницу", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокПомеченныхНаУдаление(Команда)
	
	Состояние(НСтр("ru = 'Выполняется поиск помеченных на удаление объектов'"));
	
	ЗаполнениеДереваПомеченныхНаУдаление();
	
	Если КоличествоУровнейПомеченныхНаУдаление = 1 Тогда
		Для Каждого Элемент Из СписокПомеченныхНаУдаление.ПолучитьЭлементы() Цикл
			Идентификатор = Элемент.ПолучитьИдентификатор();
			Элементы.СписокПомеченныхНаУдаление.Развернуть(Идентификатор, Ложь);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ЗначениеПоТипу(Значение)
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(Значение));
	
	Если ОбъектМетаданных <> Неопределено
	   И ОбщегоНазначения.ЭтоРегистр(ОбъектМетаданных) Тогда
		
		Список = Новый СписокЗначений;
		Список.Добавить(Значение, ОбъектМетаданных.ПолноеИмя());
		Возврат Список;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьЗначениеПоТипу(Значение)
	
	Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
		ОписаниеЗначения = Значение.Получить(0);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ОписаниеЗначения.Значение);
		
		ОткрытьФорму(ОписаниеЗначения.Представление + ".ФормаЗаписи", ПараметрыФормы, ЭтаФорма);
	Иначе
		ОткрытьЗначение(Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСодержание(Результат, СообщениеОбОшибке, ТипыУдаленныхОбъектов)
	
	Если Результат.Статус Тогда
		Для Каждого ТипУдаленногоОбъекта Из ТипыУдаленныхОбъектов Цикл
			ОповеститьОбИзменении(ТипУдаленногоОбъекта);
		КонецЦикла;
	Иначе
		ИмяСтраницы = "ВыборРежимаУдаления";
		Предупреждение(СообщениеОбОшибке);
		Возврат;
	КонецЕсли;
	
	ОбновитьДеревоПомеченных = Истина;
	Если КоличествоНеУдаленныхОбъектов = 0 Тогда
		Если УдаленныхОбъектов = 0 Тогда
			Текст = НСтр("ru = 'Не помечено на удаление ни одного объекта. Удаление объектов не выполнялось.'");
			ОбновитьДеревоПомеченных = Ложь;
		Иначе
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			             НСтр("ru = 'Удаление помеченных объектов успешно завершено.
			                        |Удалено объектов: %1.'"),
			             УдаленныхОбъектов);
		КонецЕсли;
		ИмяСтраницы = "ВыборРежимаУдаления";
		Предупреждение(Текст);
	Иначе
		ИмяСтраницы = "ПричиныНевозможностиУдаления";
		Для Каждого Элемент Из ДеревоОставшихсяОбъектов.ПолучитьЭлементы() Цикл
			Идентификатор = Элемент.ПолучитьИдентификатор();
			Элементы.ДеревоОставшихсяОбъектов.Развернуть(Идентификатор, Ложь);
		КонецЦикла;
		Предупреждение(СтрокаРезультатов);
	КонецЕсли;
	
	Если ОбновитьДеревоПомеченных Тогда
		ОбновитьСписокПомеченныхНаУдаление(Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПереключитьСтраницу()
	Если ИмяСтраницы <> "" Тогда
		Страница = Элементы.Найти(ИмяСтраницы);
		Если Страница <> Неопределено Тогда
			Элементы.СтраницыФормы.ТекущаяСтраница = Страница;
			ОбновитьДоступностьКнопок();
		КонецЕсли;
		ИмяСтраницы = "";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьКнопок()
	
	ТекущаяСтраница = Элементы.СтраницыФормы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.ВыборРежимаУдаления Тогда
		Элементы.КомандаНазад.Доступность   = Ложь;
		Если РежимУдаления = "Полный" Тогда
			Элементы.КомандаДалее.Доступность   = Ложь;
			Элементы.КомандаУдалить.Доступность = Истина;
		ИначеЕсли РежимУдаления = "Выборочный" Тогда
			Элементы.КомандаДалее.Доступность 	= Истина;
			Элементы.КомандаУдалить.Доступность = Ложь;
		КонецЕсли;
	ИначеЕсли ТекущаяСтраница = Элементы.ПомеченныеНаУдаление Тогда
		Элементы.КомандаНазад.Доступность   = Истина;
		Элементы.КомандаДалее.Доступность   = Ложь;
		Элементы.КомандаУдалить.Доступность = Истина;
	ИначеЕсли ТекущаяСтраница = Элементы.ПричиныНевозможностиУдаления Тогда
		Элементы.КомандаНазад.Доступность   = Истина;
		Элементы.КомандаДалее.Доступность   = Ложь;
		Элементы.КомандаУдалить.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает ветвь дерева в ветви СтрокиДерева по значению Значение.
// Если ветвь не найдена - создается новая.
&НаСервере
Функция НайтиИлиДобавитьВетвьДерева(СтрокиДерева, Значение, Представление, Пометка)
	
	// Попытка найти существующую ветвь в СтрокиДерева без вложенных
	Ветвь = СтрокиДерева.Найти(Значение, "Значение", Ложь);
	
	Если Ветвь = Неопределено Тогда
		// Такой ветки нет, создадим новую
		Ветвь = СтрокиДерева.Добавить();
		Ветвь.Значение      = ЗначениеПоТипу(Значение);
		Ветвь.Представление = Представление;
		Ветвь.Пометка       = Пометка;
	КонецЕсли;
	
	Возврат Ветвь;
	
КонецФункции

&НаСервере
Функция НайтиИлиДобавитьВетвьДереваСКартинкой(СтрокиДерева, Значение, Представление, НомерКартинки)
	
	// Попытка найти существующую ветвь в СтрокиДерева без вложенных
	Ветвь = СтрокиДерева.Найти(Значение, "Значение", Ложь);
	Если Ветвь = Неопределено Тогда
		// Такой ветки нет, создадим новую
		Ветвь = СтрокиДерева.Добавить();
		Ветвь.Значение      = ЗначениеПоТипу(Значение);
		Ветвь.Представление = Представление;
		Ветвь.НомерКартинки = НомерКартинки;
	КонецЕсли;

	Возврат Ветвь;
	
КонецФункции

&НаСервере
Процедура ЗаполнениеДереваПомеченныхНаУдаление()
	
	// Заполнение дерева помеченных на удаление
	ДеревоПомеченных = РеквизитФормыВЗначение("СписокПомеченныхНаУдаление");
	
	ДеревоПомеченных.Строки.Очистить();
	
	// обработка помеченных
	МассивПомеченных = Обработки.УдалениеПомеченныхОбъектов.ПолучитьПомеченныеНаУдаление();
	
	Для Каждого МассивПомеченныхЭлемент Из МассивПомеченных Цикл
		ОбъектМетаданныхЗначение = МассивПомеченныхЭлемент.Метаданные().ПолноеИмя();
		ОбъектМетаданныхПредставление = МассивПомеченныхЭлемент.Метаданные().Представление();
		СтрокаОбъектаМетаданных = НайтиИлиДобавитьВетвьДерева(ДеревоПомеченных.Строки, ОбъектМетаданныхЗначение, ОбъектМетаданныхПредставление, Истина);
		НайтиИлиДобавитьВетвьДерева(СтрокаОбъектаМетаданных.Строки, МассивПомеченныхЭлемент, Строка(МассивПомеченныхЭлемент), Истина);
	КонецЦикла;
	
	ДеревоПомеченных.Строки.Сортировать("Значение", Истина);
	
	Для Каждого СтрокаОбъектаМетаданных Из ДеревоПомеченных.Строки Цикл
		// создать представление для строк, отображающих ветвь объекта метаданных
		СтрокаОбъектаМетаданных.Представление = СтрокаОбъектаМетаданных.Представление + " (" + СтрокаОбъектаМетаданных.Строки.Количество() + ")";
	КонецЦикла;
	
	КоличествоУровнейПомеченныхНаУдаление = ДеревоПомеченных.Строки.Количество();
	
	ЗначениеВРеквизитФормы(ДеревоПомеченных, "СписокПомеченныхНаУдаление");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуВСписке(Данные, Пометка, ПроверятьРодителя)
	
	// Устанавливаем подчиненным
	ЭлементыСтроки = Данные.ПолучитьЭлементы();
	
	Для Каждого Элемент Из ЭлементыСтроки Цикл
		Элемент.Пометка = Пометка;
		УстановитьПометкуВСписке(Элемент, Пометка, Ложь);
	КонецЦикла;
	
	// Проверяем родителя
	Родитель = Данные.ПолучитьРодителя();
	
	Если ПроверятьРодителя И Родитель <> Неопределено Тогда 
		ПроверитьРодителя(Родитель);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьРодителя(Родитель)
	
	ПометкаРодителя = Истина;
		ЭлементыСтроки = Родитель.ПолучитьЭлементы();
		Для Каждого Элемент Из ЭлементыСтроки Цикл
			Если Не Элемент.Пометка Тогда
				ПометкаРодителя = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Родитель.Пометка = ПометкаРодителя;
	
КонецПроцедуры

// Производит попытку удаления выбранных объектов.
// Объекты, которые не были удалены показываются в отдельной таблице.
&НаСервере
Функция УдалениеВыбранныхНаСервере(ТипыУдаленныхОбъектов)
	
	ПараметрыУдаления = Новый Структура("СписокПомеченныхНаУдаление, РежимУдаления, ТипыУдаленныхОбъектов, ", 
		СписокПомеченныхНаУдаление, РежимУдаления, ТипыУдаленныхОбъектов);
											
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	Обработки.УдалениеПомеченныхОбъектов.УдалитьПомеченныеОбъекты(ПараметрыУдаления, АдресХранилища);
	Результат = Новый Структура("ЗаданиеВыполнено", Истина);		
	
	Если Результат.ЗаданиеВыполнено Тогда
		Результат = ЗаполнитьРезультаты(АдресХранилища, Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЗаполнитьРезультаты(АдресХранилища, Результат)
	
	РезультатУдаления = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если Не РезультатУдаления.Статус Тогда 
		Результат.Вставить("РезультатУдаления", РезультатУдаления);
		Результат.Вставить("СообщениеОбОшибке", РезультатУдаления.Значение);
		Возврат Результат;
	КонецЕсли;
	
	Дерево = ЗаполнитьДеревоОставшихсяОбъектов(РезультатУдаления);
	ЗначениеВРеквизитФормы(Дерево, "ДеревоОставшихсяОбъектов");
	
	КоличествоУдаляемых 			= РезультатУдаления.КоличествоУдаляемых;
	КоличествоНеУдаленныхОбъектов 	= РезультатУдаления.КоличествоНеУдаленныхОбъектов;
	ЗаполнитьСтрокуРезультатов(КоличествоУдаляемых);
	
	Если ТипЗнч(РезультатУдаления.Значение) = Тип("Структура") Тогда
		РезультатУдаления.Удалить("Значение");
	КонецЕсли;	
	
	Результат.Вставить("РезультатУдаления", РезультатУдаления);
	Результат.Вставить("СообщениеОбОшибке", "");
    Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ДлительнаяОперация Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				Результат = ЗаполнитьРезультаты(АдресХранилища, Новый Структура);
				ТипыУдаленныхОбъектов = Неопределено;
				ОбновитьСодержание(Результат.РезультатУдаления, Результат.РезультатУдаления.Значение, Результат.РезультатУдаления.ТипыУдаленныхОбъектов);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Функция ЗаполнитьДеревоОставшихсяОбъектов(Результат)
	
	Найденные   = Результат.Значение.Найденные;
	НеУдаленные = Результат.Значение.НеУдаленные;
	
	КоличествоНеУдаленныхОбъектов = НеУдаленные.Количество();
	
	// Создадим таблицу оставшихся (не удаленных) объектов
	ДеревоОставшихсяОбъектов.ПолучитьЭлементы().Очистить();
	
	Дерево = РеквизитФормыВЗначение("ДеревоОставшихсяОбъектов");
	
	Для Каждого Найденный Из Найденные Цикл
		НеУдаленный = Найденный[0];
		Ссылающийся = Найденный[1];
		ОбъектМетаданныхСсылающегося = Найденный[2].Представление();
		ОбъектМетаданныхНеУдаленногоЗначение = НеУдаленный.Метаданные().ПолноеИмя();
		ОбъектМетаданныхНеУдаленногоПредставление = НеУдаленный.Метаданные().Представление();
		//ветвь метаданного
		СтрокаОбъектаМетаданных = НайтиИлиДобавитьВетвьДереваСКартинкой(Дерево.Строки, ОбъектМетаданныхНеУдаленногоЗначение, ОбъектМетаданныхНеУдаленногоПредставление, 0);
		//ветвь не удаленного объекта
		СтрокаСсылкиНаНеУдаленныйОбъектБД = НайтиИлиДобавитьВетвьДереваСКартинкой(СтрокаОбъектаМетаданных.Строки, НеУдаленный, Строка(НеУдаленный), 2);
		//ветвь ссылки на не удаленный объект
		НайтиИлиДобавитьВетвьДереваСКартинкой(СтрокаСсылкиНаНеУдаленныйОбъектБД.Строки, Ссылающийся, Строка(Ссылающийся) + " - " + ОбъектМетаданныхСсылающегося, 1);
	КонецЦикла;
	
	Дерево.Строки.Сортировать("Значение", Истина);
	
	Возврат Дерево;

КонецФункции

&НаСервере
Процедура ЗаполнитьСтрокуРезультатов(КоличествоУдаляемых)
	
	УдаленныхОбъектов = КоличествоУдаляемых - КоличествоНеУдаленныхОбъектов;
	
	Если УдаленныхОбъектов = 0 Тогда
		СтрокаРезультатов = НСтр("ru = 'Не удален ни один из объектов, так как в информационной базе существуют ссылки на удаляемые объекты'");
	Иначе
		СтрокаРезультатов = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Удаление помеченных объектов завершено.
							|Удалено объектов: %1.'"),
							Строка(УдаленныхОбъектов));
	КонецЕсли;
	
	Если КоличествоНеУдаленныхОбъектов > 0 Тогда
		СтрокаРезультатов = СтрокаРезультатов + Символы.ПС +
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалено объектов: %1.
							|Объекты не удалены для сохранения целостности информационной базы, т.к. на них еще имеются ссылки.
							|Нажмите ОК для просмотра списка оставшихся (не удаленных) объектов.'"),
				Строка(КоличествоНеУдаленныхОбъектов));
	КонецЕсли;

КонецПроцедуры
