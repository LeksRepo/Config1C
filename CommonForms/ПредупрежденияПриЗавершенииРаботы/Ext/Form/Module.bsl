﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
		
	ИнициализироватьЭлементыВФорме(Параметры.Предупреждения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Обработчик нажатия на гиперссылку.
//
&НаКлиенте
Процедура НажатиеНаГиперСсылку(Элемент)
	ИмяЭлемента = Элемент.Имя;
	
	Для Каждого СтрокаВопроса Из МассивСоотношенияЭлементовИПараметров Цикл
		ПараметрыВопроса = Новый Структура("Имя, Форма, ПараметрыФормы");
		
		ЗаполнитьЗначенияСвойств(ПараметрыВопроса, СтрокаВопроса.Значение);
		Если ИмяЭлемента = ПараметрыВопроса.Имя Тогда 
			
			Если ПараметрыВопроса.Форма <> Неопределено Тогда
				ОткрытьФорму(ПараметрыВопроса.Форма, ПараметрыВопроса.ПараметрыФормы, ЭтотОбъект);
			КонецЕсли;
			
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Инициализирует массив будущих задач, которые необходимо выполнить при закрытии.
//
&НаКлиенте 
Процедура ИзменитьМассивБудущихЗадач(Элемент)
	ИмяЭлемента      = Элемент.Имя;
	НайденныйЭлемент = Элементы.Найти(ИмяЭлемента);
	
	Если НайденныйЭлемент = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЗначениеЭлемента = ЭтотОбъект[ИмяЭлемента];
	Если ТипЗнч(ЗначениеЭлемента) <> Тип("Булево") Тогда
		Возврат;
	КонецЕсли;

	ИдентификаторМассива = ИдентификаторМассиваЗадачПоИмени(ИмяЭлемента);
	Если ИдентификаторМассива = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЭлементМассива = МассивЗадачНаВыполнениеПослеЗакрытия.НайтиПоИдентификатору(ИдентификаторМассива);
	
	Использование = Неопределено;
	Если ЭлементМассива.Значение.Свойство("Использование", Использование) Тогда 
		Если ТипЗнч(Использование) = Тип("Булево") Тогда 
			ЭлементМассива.Значение.Использование = ЗначениеЭлемента;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Завершить(Команда)
	
	ВыполнениеЗадачПриЗакрытии();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Создает элементы формы по передаваемым вопросам пользователю.
//
// Параметры:
//     Вопросы - Массив - Содержит структуры с параметрами значений вопросов.
//
&НаСервере
Процедура ИнициализироватьЭлементыВФорме(Знач Предупреждения)
	
	// Добавляем возможно не указанные значения по умолчанию
	ТаблицаПредупреждений = ПреобразоватьМассивСтруктурВТаблицуЗначений(Предупреждения);
	
	Для Каждого ТекущееПредупреждение Из ТаблицаПредупреждений Цикл 
		// Элемент на форму добавляем только если указаны или текст для флага, или текст для гиперссылки, но не одновременно
		НужнаСсылка = Не ПустаяСтрока(ТекущееПредупреждение.ТекстГиперСсылки);
		НуженФлаг   = Не ПустаяСтрока(ТекущееПредупреждение.ТекстФлажка);
		
		Если НужнаСсылка И НуженФлаг Тогда
			Продолжить;
			
		ИначеЕсли НужнаСсылка Тогда
			СоздатьГиперссылкуНаФорме(ТекущееПредупреждение);
			
		ИначеЕсли НуженФлаг Тогда
			СоздатьФлажокНаФорме(ТекущееПредупреждение);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Окончательно располагаем элементы
	ТекстНадписи = НСтр("ru = 'Завершить работу с программой?'");
	
	ИмяНадписи    = ОпределитьИмяНадписиВФорме("НадписьВопроса");
	ГруппаНадписи = СформироватьГруппуЭлементовФормы();
	
	ЭлементПоясняющегоТекста = Элементы.Добавить(ИмяНадписи, Тип("ДекорацияФормы"), ГруппаНадписи);
	ЭлементПоясняющегоТекста.ВертикальноеПоложение = ВертикальноеПоложениеЭлемента.Низ;
	ЭлементПоясняющегоТекста.Заголовок             = ТекстНадписи;
	ЭлементПоясняющегоТекста.Высота                = 2;
	
КонецПроцедуры

&НаСервере
Функция ПреобразоватьМассивСтруктурВТаблицуЗначений(Знач Предупреждения)
	
	// Формируем таблицу, содержащую значения по умолчанию
	ТаблицаПредупреждений = Новый ТаблицаЗначений;
	КолонкиПредупреждений = ТаблицаПредупреждений.Колонки;
	
	КолонкиПредупреждений.Добавить("ПоясняющийТекст");
	
	КолонкиПредупреждений.Добавить("ТекстФлажка");
	КолонкиПредупреждений.Добавить("ДействиеПриУстановленномФлажке");
	
	КолонкиПредупреждений.Добавить("ТекстГиперссылки");
	КолонкиПредупреждений.Добавить("ДействиеПриНажатииГиперссылки");
	
	КолонкиПредупреждений.Добавить("Приоритет");
	КолонкиПредупреждений.Добавить("ВывестиОдноПредупреждение");
	
	КолонкиПредупреждений.Добавить("РасширеннаяПодсказка");
	КолонкиПредупреждений.Добавить("ОтображениеРасширеннойПодсказки");
	
	ОдиночныеПредупреждения = Новый Массив;
	
	Для Каждого ЭлементПредупреждения Из Предупреждения Цикл
		СтрокаТаблицы = ТаблицаПредупреждений.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ЭлементПредупреждения);
		
		Если СтрокаТаблицы.ВывестиОдноПредупреждение = Истина Тогда
			ОдиночныеПредупреждения.Добавить(СтрокаТаблицы);
		КонецЕсли;
	КонецЦикла;
	
	// Если было хоть одно предупреждение, требующее очистки (ВывестиОдноПредупреждение = Истина) то очищаем остальные
	Если ОдиночныеПредупреждения.Количество() > 0 Тогда
		ТаблицаПредупреждений = ТаблицаПредупреждений.Скопировать(ОдиночныеПредупреждения);
	КонецЕсли;
	
	ТаблицаПредупреждений.Сортировать("Приоритет УБЫВ");
	
	Возврат ТаблицаПредупреждений;
КонецФункции

// Формирует на форме группу и возвращает её.
// Является дочерней группой для "ОсновнойГруппы".
//
&НаСервере
Функция СформироватьГруппуЭлементовФормы()
	ИмяГруппы = ОпределитьИмяНадписиВФорме("ГруппаВФорме");
	
	Группа = Элементы.Добавить(ИмяГруппы, Тип("ГруппаФормы"), Элементы.ОсновнаяГруппа);
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	
	Группа.РастягиватьПоГоризонтали = Истина;
	Группа.ОтображатьЗаголовок      = Ложь;
	Группа.Отображение              = ОтображениеОбычнойГруппы.Нет;
	
	Возврат Группа; 
КонецФункции

// Формирует на форме гиперссылку с поясняющим текстом.
//
// Параметры:
//     СтруктураВопроса - Структура - данные вопроса для формирования
//
&НаСервере
Процедура СоздатьГиперСсылкуНаФорме(СтруктураВопроса)
	Группа = СформироватьГруппуЭлементовФормы();
	
	Если СтруктураВопроса.ПоясняющийТекст <> Неопределено Тогда
		Если Не ПустаяСтрока(СтруктураВопроса.ПоясняющийТекст) Тогда 
			ИмяНадписи = ОпределитьИмяНадписиВФорме("НадписьВопроса");
			ТипНадписи = Тип("ДекорацияФормы");
			
			РодительНадписи = Группа;
			
			ЭлементПоясняющегоТекста = Элементы.Добавить(ИмяНадписи, ТипНадписи, РодительНадписи);
			ЭлементПоясняющегоТекста.Заголовок = СтруктураВопроса.ПоясняющийТекст;
		КонецЕсли;
	КонецЕсли;
	
	Если ПустаяСтрока(СтруктураВопроса.ТекстГиперСсылки) Тогда
		Возврат;
	КонецЕсли;
	
	// Конструируем гиперссылку
	ИмяГиперСсылки = ОпределитьИмяНадписиВФорме("НадписьВопроса");
	ТипГиперСсылки = Тип("ДекорацияФормы");
	
	РодительГиперСсылки = Группа;

	ЭлементГиперСсылки = Элементы.Добавить(ИмяГиперСсылки, ТипГиперСсылки, РодительГиперСсылки);
	ЭлементГиперСсылки.Гиперссылка = Истина;
	ЭлементГиперСсылки.Заголовок   = СтруктураВопроса.ТекстГиперСсылки;
	ЭлементГиперСсылки.УстановитьДействие("Нажатие", "НажатиеНаГиперСсылку");
	
	УстановитьРасширеннуюПодсказку(ЭлементГиперСсылки, СтруктураВопроса);
	
	ФормаГиперСсылки    = Неопределено;
	ДействиеГиперСсылки = Неопределено;
	Если СтруктураВопроса.ДействиеПриНажатииГиперссылки <> Неопределено Тогда
		
		СтруктураОбработки = СтруктураВопроса.ДействиеПриНажатииГиперссылки;
		Если СтруктураОбработки.Свойство("Форма", ФормаГиперСсылки) Тогда 
			СтруктураМассива = Новый Структура;
			СтруктураМассива.Вставить("Имя", ИмяГиперСсылки);
			СтруктураМассива.Вставить("Форма", ФормаГиперСсылки);
			
			ПараметрыФормы = Неопределено;
			Если СтруктураОбработки.Свойство("ПараметрыФормы", ПараметрыФормы) Тогда
				Если ТипЗнч(ПараметрыФормы) = Тип("Структура") Тогда 
					ПараметрыФормы.Вставить("ЗавершениеРаботыПрограммы", Истина);
				ИначеЕсли ПараметрыФормы = Неопределено Тогда 
					ПараметрыФормы = Новый Структура;
					ПараметрыФормы.Вставить("ЗавершениеРаботыПрограммы", Истина);
				КонецЕсли;
				СтруктураМассива.Вставить("ПараметрыФормы", ПараметрыФормы);
			КонецЕсли;
			
			МассивСоотношенияЭлементовИПараметров.Добавить(СтруктураМассива);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

// Формирует на форме флажок с поясняющим текстом.
//
// Параметры:
//     СтруктураВопроса - структура передаваемого вопроса.
//
&НаСервере
Процедура СоздатьФлажокНаФорме(СтруктураВопроса)
	ЗначениеПоУмолчанию = Истина;
	Группа  = СформироватьГруппуЭлементовФормы();
	
	Если СтруктураВопроса.ПоясняющийТекст <> Неопределено Тогда
		Если Не ПустаяСтрока(СтруктураВопроса.ПоясняющийТекст) Тогда
			ИмяНадписи = ОпределитьИмяНадписиВФорме("НадписьВопроса");
			ТипНадписи = Тип("ДекорацияФормы");
			
			РодительНадписи = Группа;
			
			ЭлементПоясняющегоТекста = Элементы.Добавить(ИмяНадписи, ТипНадписи, РодительНадписи);
			ЭлементПоясняющегоТекста.Заголовок = СтруктураВопроса.ПоясняющийТекст;
		КонецЕсли;
	КонецЕсли;
	
	Если ПустаяСтрока(СтруктураВопроса.ТекстФлажка) Тогда 
		Возврат;
	КонецЕсли;
	
	// Добавляем реквизита в форму.
	ИмяФлажка = ОпределитьИмяНадписиВФорме("НадписьВопроса");
	ТипФлажка = Тип("ПолеФормы");
	
	РодительФлажка = Группа;
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Булево"));
	Описание = Новый ОписаниеТипов(МассивТипов);
	
	ДобавляемыеРеквизиты = Новый Массив;
	НовыйРеквизит = Новый РеквизитФормы(ИмяФлажка, Описание, , ИмяФлажка, Ложь);
	ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	ЭтотОбъект[ИмяФлажка] = ЗначениеПоУмолчанию;
	
	НовоеПолеФормы = Элементы.Добавить(ИмяФлажка, ТипФлажка, РодительФлажка);
	НовоеПолеФормы.ПутьКДанным = ИмяФлажка;
	
	НовоеПолеФормы.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	НовоеПолеФормы.Заголовок          = СтруктураВопроса.ТекстФлажка;
	НовоеПолеФормы.Вид                = ВидПоляФормы.ПолеФлажка;
	
	УстановитьРасширеннуюПодсказку(НовоеПолеФормы, СтруктураВопроса);
	
	// Инициализация элемента в массиве.
	ФормаЭлемента = Неопределено;
	СтруктураДействия = Неопределено;
	
	Если СтруктураВопроса.ДействиеПриУстановленномФлажке <> Неопределено Тогда
		СтруктураДействия = СтруктураВопроса.ДействиеПриУстановленномФлажке;
		Если СтруктураДействия.Свойство("Форма", ФормаЭлемента) Тогда
			НовоеПолеФормы.УстановитьДействие("ПриИзменении", "ИзменитьМассивБудущихЗадач");
			
			СтруктураМассива = Новый Структура;
			СтруктураМассива.Вставить("Имя", ИмяФлажка);
			СтруктураМассива.Вставить("Форма", ФормаЭлемента);
			СтруктураМассива.Вставить("Использование", ЗначениеПоУмолчанию);
			
			ПараметрыФормы = Неопределено;
			Если СтруктураДействия.Свойство("ПараметрыФормы", ПараметрыФормы) Тогда
				СтруктураМассива.Вставить("ПараметрыФормы", ПараметрыФормы);
			КонецЕсли;
			
			МассивЗадачНаВыполнениеПослеЗакрытия.Добавить(СтруктураМассива);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает расширенную подсказку и ее отображение для элемента
//
&НаСервере
Процедура УстановитьРасширеннуюПодсказку(ЭлементФормы, Знач СтрокаОписания)
	ОписаниеРасширеннойПодсказки = СтрокаОписания.РасширеннаяПодсказка;
	
	Если ОписаниеРасширеннойПодсказки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ОписаниеРасширеннойПодсказки) <> Тип("Строка") Тогда
		// Устанавливаем в расширенную подсказку
		ЗаполнитьЗначенияСвойств(ЭлементФормы.РасширеннаяПодсказка, ОписаниеРасширеннойПодсказки);
		Если СтрокаОписания.ОтображениеРасширеннойПодсказки <> Неопределено Тогда
			ЭлементФормы.ОтображениеПодсказки = ОтображениеПодсказки[СтрокаОписания.ОтображениеРасширеннойПодсказки];
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	// Добавляем как простой поясняющий текст снизу
	ТипУправляемаяФорма = Тип("УправляемаяФорма");
	ФормаТекущегоЭлемента = ЭлементФормы;
	Пока ТипЗнч(ФормаТекущегоЭлемента) <> ТипУправляемаяФорма Цикл
		ФормаТекущегоЭлемента = ФормаТекущегоЭлемента.Родитель;
	КонецЦикла;
	ЭлементыФормы = ФормаТекущегоЭлемента.Элементы;
	ИмяТекущегоЭлемента = ЭлементФормы.Имя;
	
	ГруппаЭлемента = ЭлементыФормы.Добавить(ИмяТекущегоЭлемента + "ГруппаПоясняющийТекст", Тип("ГруппаФормы"), ЭлементФормы.Родитель);
	ГруппаЭлемента.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаЭлемента.РастягиватьПоГоризонтали = Истина;
	ГруппаЭлемента.РастягиватьПоВертикали   = Истина;
	ГруппаЭлемента.ОтображатьЗаголовок      = Ложь;
	ГруппаЭлемента.Отображение              = ОтображениеОбычнойГруппы.Нет;
	ГруппаЭлемента.Группировка              = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	
	ВыравнивающаяГруппа = ЭлементыФормы.Добавить(ИмяТекущегоЭлемента + "ГруппаПоясняющийТекстВыравнивание", Тип("ГруппаФормы"), ГруппаЭлемента);
	ВыравнивающаяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ВыравнивающаяГруппа.РастягиватьПоГоризонтали = Истина;
	ВыравнивающаяГруппа.РастягиватьПоВертикали   = Истина;
	ВыравнивающаяГруппа.ОтображатьЗаголовок      = Ложь;
	ВыравнивающаяГруппа.Отображение              = ОтображениеОбычнойГруппы.Нет;
	ВыравнивающаяГруппа.Группировка              = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	
	ОтступТекста = ЭлементыФормы.Добавить(ИмяТекущегоЭлемента + "ГруппаПоясняющийТекстОтступ", Тип("ДекорацияФормы"), ВыравнивающаяГруппа);
	ОтступТекста.Вид = ВидДекорацииФормы.Надпись;
	ОтступТекста.Ширина = 1;
	
	ПоясняющийТекст = ЭлементыФормы.Добавить(ИмяТекущегоЭлемента + "ПоясняющийТекст", Тип("ДекорацияФормы"), ВыравнивающаяГруппа);
	ПоясняющийТекст.Вид = ВидДекорацииФормы.Надпись;
	ПоясняющийТекст.ЦветТекста = ЦветаСтиля.ПоясняющийТекст;
	ПоясняющийТекст.ВертикальноеПоложение = ВертикальноеПоложениеЭлемента.Верх;
	ПоясняющийТекст.РастягиватьПоВертикали = Истина;
	ПоясняющийТекст.Заголовок = ОписаниеРасширеннойПодсказки;
	
	ЭлементыФормы.Переместить(ЭлементФормы, ГруппаЭлемента, ВыравнивающаяГруппа);
КонецПроцедуры

// Формирует имя надписи в форме по заголовку.
// 
// Параметры:
//     ЗаголовокЭлемента - Строка - заголовок.
//
&НаСервере
Функция ОпределитьИмяНадписиВФорме(ЗаголовокЭлемента)
	Индекс = 0;
	ФлагПоиска = Истина;
	
	Пока ФлагПоиска Цикл 
		ИндексСтрока = Строка(Формат(Индекс, "ЧН=-"));
		ИндексСтрока = СтрЗаменить(ИндексСтрока, "-", "");
		Имя = ЗаголовокЭлемента + ИндексСтрока;
		
		НайденныйЭлемент = Элементы.Найти(Имя);
		Если НайденныйЭлемент = Неопределено Тогда 
			Возврат Имя;
		КонецЕсли;
		
		Индекс = Индекс + 1;
	КонецЦикла;
КонецФункции	

&НаКлиенте
Функция ИдентификаторМассиваЗадачПоИмени(ИмяЭлемента)
	Для каждого ЭлементМассива из МассивЗадачНаВыполнениеПослеЗакрытия цикл
		Наименование = "";
		Если ЭлементМассива.Значение.Свойство("Имя", Наименование) Тогда 
			Если Не ПустаяСтрока(Наименование) и Наименование = ИмяЭлемента тогда
				Возврат ЭлементМассива.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

// Выполняет необходимые задачи.
//
&НаКлиенте
Процедура ВыполнениеЗадачПриЗакрытии(Результат = Неопределено, НачальныйНомерЗадачи = Неопределено) Экспорт
	
	Если НачальныйНомерЗадачи = Неопределено Тогда
		НачальныйНомерЗадачи = 0;
	КонецЕсли;
	
	Для НомерЗадачи = НачальныйНомерЗадачи По МассивЗадачНаВыполнениеПослеЗакрытия.Количество() - 1 Цикл
		
		ЭлементМассива = МассивЗадачНаВыполнениеПослеЗакрытия[НомерЗадачи];
		Использование = Неопределено;
		Если Не ЭлементМассива.Значение.Свойство("Использование", Использование) Тогда 
			Продолжить;
		КонецЕсли;
		Если ТипЗнч(Использование) <> Тип("Булево") Тогда 
			Продолжить;
		КонецЕсли;
		Если Использование <> Истина Тогда 
			Продолжить;
		КонецЕсли;
		
		Форма = Неопределено;
		Если ЭлементМассива.Значение.Свойство("Форма", Форма) Тогда 
			ПараметрыФормы = Неопределено;
			Если ЭлементМассива.Значение.Свойство("ПараметрыФормы", ПараметрыФормы) Тогда 
				Оповещение = Новый ОписаниеОповещения("ВыполнениеЗадачПриЗакрытии", ЭтотОбъект, НомерЗадачи + 1);
				ОткрытьФорму(Форма, СтруктураИзФиксированнойСтруктуры(ПараметрыФормы),,,,,Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Закрыть(Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция СтруктураИзФиксированнойСтруктуры(Источник)
	
	Результат = Новый Структура;
	
	Для Каждого Элемент Из Источник Цикл
		Результат.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

#КонецОбласти
