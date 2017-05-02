﻿&НаКлиенте
Перем ЗакрытьФормуБезусловно;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользователи.ЭтоНеразделенныйПользователь() Тогда
		ВызватьИсключение НСтр("ru = 'Создать автономное рабочее место можно только от имени разделенного пользователя.
									|Текущий пользователь является неразделенным.'");
	КонецЕсли;
	
	ИмяПланаОбмена = АвтономнаяРаботаСлужебный.ПланОбменаАвтономнойРаботы();
	
	// получаем значения по умолчанию для плана обмена
	МенеджерПланаОбмена = ПланыОбмена[ИмяПланаОбмена];
	
	НастройкаОтборовНаУзле = ОбменДаннымиСервер.НастройкаОтборовНаУзле(ИмяПланаОбмена, "");
	
	Элементы.ОписаниеОграниченийПередачиДанных.Заголовок = ОписаниеОграниченийПередачиДанных(ИмяПланаОбмена, НастройкаОтборовНаУзле);
	
	ИнструкцияПоНастройкеАвтономногоРабочегоМеста = АвтономнаяРаботаСлужебный.ТекстИнструкцииИзМакета("ИнструкцияПоНастройкеАвтономногоРабочегоМеста");
	
	ЗаголовокЭлемента = НСтр("ru = 'Для автономной работы на Вашем компьютере должна быть установлена
							|платформа ""1С:Предприятие 8.2"" версии [ВерсияПлатформы]'");
	ЗаголовокЭлемента = СтрЗаменить(ЗаголовокЭлемента, "[ВерсияПлатформы]", ОбменДаннымиВМоделиСервиса.ТребуемаяВерсияПлатформы());
	Элементы.ПоясняющаяНадписьОВерсииПлатформы.Заголовок = ЗаголовокЭлемента;
	
	Объект.НаименованиеАвтономногоРабочегоМеста = АвтономнаяРаботаСлужебный.СформироватьНаименованиеАвтономногоРабочегоМестаПоУмолчанию();
	
	// Устанавливаем текущую таблицу переходов
	СценарийСозданияАвтономногоРабочегоМеста();
	
	ЗакрытьФормуБезусловно = Ложь;
	
	СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста = АвтономнаяРаботаСлужебный.СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста();
	
	ИмяФайлаПакетаУстановки = АвтономнаяРаботаСлужебный.ИмяФайлаПакетаУстановки();
	
	// Настройка прав пользователей на выполнение синхронизации данных
	
	Элементы.НастройкаПравПользователей.Видимость = Ложь;
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		
		ПользователиСинхронизации.Загрузить(ПользователиСинхронизации());
		
		Элементы.НастройкаПравПользователей.Видимость = ПользователиСинхронизации.Количество() > 1;
		
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Объект.WSURLВебСервиса = АдресПриложенияВИнтернете();
	
	// Позиционируемся на первом шаге помощника
	УстановитьПорядковыйНомерПерехода(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ЗапроситьПодтверждениеЗакрытияФормы(Отказ, , ЗакрытьФормуБезусловно,
		НСтр("ru = 'Отменить создание автономного рабочего места?'"));
	
КонецПроцедуры

// Обработчики ожидания

&НаКлиенте
Процедура ОбработчикОжиданияДлительнойОперации()
	
	Попытка
		
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			
			ДлительнаяОперация = Ложь;
			ДлительнаяОперацияЗавершена = Истина;
			ПерейтиДалее();
			
		Иначе
			ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
		КонецЕсли;
		
	Исключение
		ДлительнаяОперация = Ложь;
		ПерейтиНазад();
		Предупреждение(НСтр("ru = 'Не удалось выполнить операцию.'"));
		
		ЗаписатьОшибкуВЖурналРегистрации(
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста);
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// Поставляемая часть

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
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

// Переопределяемая часть

&НаКлиенте
Процедура НастроитьОграниченияПередачиДанных(Команда)
	
	ИмяФормыНастройкиУзла = "ПланОбмена.[ИмяПланаОбмена].Форма.ФормаНастройкиУзла";
	ИмяФормыНастройкиУзла = СтрЗаменить(ИмяФормыНастройкиУзла, "[ИмяПланаОбмена]", ИмяПланаОбмена);
	
	РезультатОткрытия = ОткрытьФормуМодально(ИмяФормыНастройкиУзла, Новый Структура("НастройкаОтборовНаУзле", НастройкаОтборовНаУзле), ЭтаФорма);
	
	Если РезультатОткрытия <> Неопределено Тогда
		
		Для Каждого НастройкаОтбора ИЗ НастройкаОтборовНаУзле Цикл
			
			НастройкаОтборовНаУзле[НастройкаОтбора.Ключ] = РезультатОткрытия[НастройкаОтбора.Ключ];
			
		КонецЦикла;
		
		Элементы.ОписаниеОграниченийПередачиДанных.Заголовок = ОписаниеОграниченийПередачиДанных(ИмяПланаОбмена, НастройкаОтборовНаУзле);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНачальныйОбразНаКомпьютерПользователя(Команда)
	
	ПолучитьФайл(АдресВременногоХранилищаНачальногоОбраза, ИмяФайлаПакетаУстановки);
	
КонецПроцедуры

&НаКлиенте
Процедура КакУстановитьИлиОбновитьВерсиюПлатформы1СПредприятие(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяМакета", "КакУстановитьИлиОбновитьВерсиюПлатформы1СПредприятие");
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Как установить или обновить версию платформы 1С:Предприятие'"));
	
	ОткрытьФорму("Обработка.ПомощникСозданияАвтономногоРабочегоМеста.Форма.ДополнительноеОписание", ПараметрыФормы, ЭтаФорма, "КакУстановитьИлиОбновитьВерсиюПлатформы1СПредприятие");
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьИнструкции(Команда)
	
	Элементы.ИнструкцияПоНастройкеАвтономногоРабочегоМеста.Документ.execCommand("Print");
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИнструкциюКак(Команда)
	
	Элементы.ИнструкцияПоНастройкеАвтономногоРабочегоМеста.Документ.execCommand("SaveAs");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Поставляемая часть

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
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
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
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеДалее
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
			И Не СтрокаПерехода.ДлительнаяОперация Тогда
			
			ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
			
			Отказ = Ложь;
			
			А = Вычислить(ИмяПроцедуры);
			
			Если Отказ Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеНазад
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
			И Не СтрокаПерехода.ДлительнаяОперация Тогда
			
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
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
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
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
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

&НаСервере
Процедура ТаблицаПереходовНоваяСтрока(ПорядковыйНомерПерехода,
									ИмяОсновнойСтраницы,
									ИмяСтраницыНавигации,
									ИмяСтраницыДекорации = "",
									ИмяОбработчикаПриОткрытии = "",
									ИмяОбработчикаПриПереходеДалее = "",
									ИмяОбработчикаПриПереходеНазад = "",
									ДлительнаяОперация = Ложь,
									ИмяОбработчикаДлительнойОперации = "")
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
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И Найти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть – Служебные процедуры и функции

&НаСервере
Процедура СоздатьНачальныйОбразАвтономногоРабочегоМестаНаСервере(Отказ)
	
	Попытка
		
		ВыбранныеПользователиСинхронизации = ПользователиСинхронизации.Выгрузить(
			Новый Структура("СинхронизацияДанныхРазрешена, РазрешитьСинхронизациюДанных", Ложь, Истина), "Пользователь"
				).ВыгрузитьКолонку("Пользователь");
		
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			
			АдресВременногоХранилищаНачальногоОбраза = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
			АдресВременногоХранилищаИнформацииОПакетеУстановки = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
			
			ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
			
			УстановитьПривилегированныйРежим(Истина);
			
			Попытка
				ОбработкаОбъект.СоздатьНачальныйОбразАвтономногоРабочегоМеста(
							НастройкаОтборовНаУзле,
							ВыбранныеПользователиСинхронизации,
							АдресВременногоХранилищаНачальногоОбраза,
							АдресВременногоХранилищаИнформацииОПакетеУстановки);
			Исключение
				Отказ = Истина;
				Возврат;
			КонецПопытки;
			
			ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
			
			ИнформацияОПакетеУстановки = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаИнформацииОПакетеУстановки);
			РазмерФайлаПакетаУстановки = ИнформацияОПакетеУстановки.РазмерФайлаПакетаУстановки;
			
		Иначе
			
			// Получаем контекст помощника в виде структуры
			КонтекстПомощника = Новый Структура;
			Для Каждого Реквизит Из Метаданные.Обработки.ПомощникСозданияАвтономногоРабочегоМеста.Реквизиты Цикл
				КонтекстПомощника.Вставить(Реквизит.Имя, Объект[Реквизит.Имя]);
			КонецЦикла;
			КонтекстПомощника.Вставить("НастройкаОтборовНаУзле", НастройкаОтборовНаУзле);
			КонтекстПомощника.Вставить("ВыбранныеПользователиСинхронизации", ВыбранныеПользователиСинхронизации);
			
			Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
							УникальныйИдентификатор,
							"АвтономнаяРаботаСлужебный.СоздатьНачальныйОбразАвтономногоРабочегоМеста",
							КонтекстПомощника,
							НСтр("ru = 'Создание начального образа автономного рабочего места'"),
							Истина);
			
			АдресВременногоХранилищаНачальногоОбраза           = Результат.АдресХранилища;
			АдресВременногоХранилищаИнформацииОПакетеУстановки = Результат.АдресХранилищаДополнительный;
			
			Если Результат.ЗаданиеВыполнено Тогда
				
				ИнформацияОПакетеУстановки = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаИнформацииОПакетеУстановки);
				РазмерФайлаПакетаУстановки = ИнформацияОПакетеУстановки.РазмерФайлаПакетаУстановки;
				
			Иначе
				
				ДлительнаяОперация = Истина;
				ИдентификаторЗадания = Результат.ИдентификаторЗадания;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		Отказ = Истина;
		ЗаписатьОшибкуВЖурналРегистрации(
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста);
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОписаниеОграниченийПередачиДанных(Знач ИмяПланаОбмена, НастройкаОтборовНаУзле)
	
	Возврат ОбменДаннымиСервер.ОписаниеОграниченийПередачиДанных(ИмяПланаОбмена, НастройкаОтборовНаУзле, "");
	
КонецФункции

&НаКлиенте
Функция АдресПриложенияВИнтернете()
	
	ПараметрыСоединения = СтроковыеФункцииКлиентСервер.ПолучитьПараметрыИзСтроки(СтрокаСоединенияИнформационнойБазы());
	
	Если Не ПараметрыСоединения.Свойство("ws") Тогда
		ВызватьИсключение НСтр("ru = 'Создать автономное рабочее место можно только в режиме веб-клиента.'");
	КонецЕсли;
	
	Возврат ПараметрыСоединения.ws;
КонецФункции

&НаКлиенте
Процедура ПерейтиДалее()
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНазад()
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьОшибкуВЖурналРегистрации(СтрокаСообщенияОбОшибке, Событие)
	
	ЗаписьЖурналаРегистрации(Событие, УровеньЖурналаРегистрации.Ошибка,,, СтрокаСообщенияОбОшибке);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Функция ПользователиСинхронизации()
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Пользователь"); // Тип: СправочникСсылка.Пользователи
	Результат.Колонки.Добавить("СинхронизацияДанныхРазрешена", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("РазрешитьСинхронизациюДанных", Новый ОписаниеТипов("Булево"));
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Пользователь,
	|	Пользователи.ИдентификаторПользователяИБ КАК ИдентификаторПользователяИБ
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	НЕ Пользователи.ПометкаУдаления
	|	И НЕ Пользователи.Недействителен
	|	И НЕ Пользователи.Служебный
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пользователи.Наименование";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.ИдентификаторПользователяИБ) Тогда
			
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Выборка.ИдентификаторПользователяИБ);
			
			Если ПользовательИБ <> Неопределено Тогда
				
				НастройкиПользователя = Результат.Добавить();
				НастройкиПользователя.Пользователь = Выборка.Пользователь;
				НастройкиПользователя.СинхронизацияДанныхРазрешена = ОбменДаннымиСервер.СинхронизацияДанныхРазрешена(ПользовательИБ);
				НастройкиПользователя.РазрешитьСинхронизациюДанных = НастройкиПользователя.СинхронизацияДанныхРазрешена;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть - Обработчики событий переходов

&НаКлиенте
Функция Подключаемый_НастройкаВыгрузки_ПриПереходеДалее(Отказ)
	
	Если ПустаяСтрока(Объект.НаименованиеАвтономногоРабочегоМеста) Тогда
		
		НСтрока = НСтр("ru = 'Не задано наименование автономного рабочего места.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтрока,,"Объект.НаименованиеАвтономногоРабочегоМеста",, Отказ);
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ОжиданиеСозданияНачальногоОбраза_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ДлительнаяОперация = Ложь;
	ДлительнаяОперацияЗавершена = Ложь;
	ИдентификаторЗадания = Неопределено;
	
	СоздатьНачальныйОбразАвтономногоРабочегоМестаНаСервере(Отказ);
	
	Если Отказ Тогда
		
		//
		
	ИначеЕсли Не ДлительнаяОперация Тогда
		
		Оповестить("Создание_АвтономноеРабочееМесто");
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ОжиданиеСозданияНачальногоОбразаДлительнаяОперация_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	Если ДлительнаяОперация Тогда
		
		ПерейтиДалее = Ложь;
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ОжиданиеСозданияНачальногоОбразаДлительнаяОперацияОкончание_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	Если ДлительнаяОперацияЗавершена Тогда
		
		ИнформацияОПакетеУстановки = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаИнформацииОПакетеУстановки);
		РазмерФайлаПакетаУстановки = ИнформацияОПакетеУстановки.РазмерФайлаПакетаУстановки;
		
		Оповестить("Создание_АвтономноеРабочееМесто");
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_Окончание_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	ЗаголовокЭлемента = "[ИмяФайлаПакетаУстановки] ([РазмерФайлаПакетаУстановки] [ЕдиницаИзмерения])";
	ЗаголовокЭлемента = СтрЗаменить(ЗаголовокЭлемента, "[ИмяФайлаПакетаУстановки]", ИмяФайлаПакетаУстановки);
	ЗаголовокЭлемента = СтрЗаменить(ЗаголовокЭлемента, "[РазмерФайлаПакетаУстановки]", Формат(РазмерФайлаПакетаУстановки, "ЧДЦ=1; ЧГ=3,0"));
	ЗаголовокЭлемента = СтрЗаменить(ЗаголовокЭлемента, "[ЕдиницаИзмерения]", НСтр("ru = 'Мб'"));
	
	Элементы.ЗагрузитьНачальныйОбразНаКомпьютерПользователя.Заголовок = ЗаголовокЭлемента;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть - Инициализация переходов помощника

&НаСервере
Процедура СценарийСозданияАвтономногоРабочегоМеста()
	
	ТаблицаПереходов.Очистить();
	
	ТаблицаПереходовНоваяСтрока(1, "Начало",                           "СтраницаНавигацииНачало");
	ТаблицаПереходовНоваяСтрока(2, "НастройкаВыгрузки",                "СтраницаНавигацииПродолжение",,, "НастройкаВыгрузки_ПриПереходеДалее");
	ТаблицаПереходовНоваяСтрока(3, "ОжиданиеСозданияНачальногоОбраза", "СтраницаНавигацииОжидание",,,,, Истина, "ОжиданиеСозданияНачальногоОбраза_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(4, "ОжиданиеСозданияНачальногоОбраза", "СтраницаНавигацииОжидание",,,,, Истина, "ОжиданиеСозданияНачальногоОбразаДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(5, "ОжиданиеСозданияНачальногоОбраза", "СтраницаНавигацииОжидание",,,,, Истина, "ОжиданиеСозданияНачальногоОбразаДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(6, "Окончание",                        "СтраницаНавигацииОкончание",, "Окончание_ПриОткрытии");
	
КонецПроцедуры
