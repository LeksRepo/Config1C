﻿// Необязательные параметры формы:
//
//    УпрощенныйРежим – Булево - флаг того, что будет отчет будет формироваться в упрощенном виде
//

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ФормаНастройкиОтчета.Видимость = Ложь;
	
	ЭтаОбработка = ЭтотОбъект();
	Если ПустаяСтрока(Параметры.АдресОбъекта) Тогда
		ОбъектИсточник = ЭтаОбработка.ИнициализироватьЭтотОбъект(Параметры.НастройкиОбъекта);
	Иначе
		ОбъектИсточник = ЭтаОбработка.ИнициализироватьЭтотОбъект(Параметры.АдресОбъекта) 
	КонецЕсли;
	
	// Корректируем отбор по сценарию узла, имитируем общий отбор
	Если ОбъектИсточник.ВариантВыгрузки=3 Тогда
		ОбъектИсточник.ВариантВыгрузки = 2;
		
		ОбъектИсточник.КомпоновщикОтбораВсехДокументов = Неопределено;
		ОбъектИсточник.ПериодОтбораВсехДокументов      = Неопределено;
		
		ОбменДаннымиСервер.ЗаполнитьТаблицуЗначений(ОбъектИсточник.ДополнительнаяРегистрация, ОбъектИсточник.ДополнительнаяРегистрацияСценарияУзла);
	КонецЕсли;
	ОбъектИсточник.ДополнительнаяРегистрацияСценарияУзла.Очистить();
		
	ЭтотОбъект(ОбъектИсточник);
	
	Если Не ЗначениеЗаполнено(Объект.УзелИнформационнойБазы) Тогда
		Текст = НСтр("ru='Настройка обмена данными не найдена.'");
		ОбменДаннымиСервер.СообщитьОбОшибке(Текст, Отказ);
		Возврат;
	КонецЕсли;
	
	Заголовок = Заголовок + " (" + Объект.УзелИнформационнойБазы + ")";
	БазовоеИмяДляФормы = ЭтаОбработка.БазовоеИмяДляФормы();
	
	Параметры.Свойство("УпрощенныйРежим", УпрощенныйРежим);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗапуститьАнимациюФормирования();
	СформироватьТабличныйДокументСервер();
	Подключаемый_ОжиданиеФормированияОтчета();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ПриЗакрытииНаСервере();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ
//

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыРасшифровки = ПараметрыРасшифровкиПервогоУровня(Расшифровка);
	Если ПараметрыРасшифровки <> Неопределено Тогда
		Если ПараметрыРасшифровки.ИмяМетаданныхОбъектаРегистрации = ПараметрыРасшифровки.ПолноеИмяМетаданных Тогда
			ТипРасшифровки = ТипЗнч(ПараметрыРасшифровки.ОбъектРегистрации);
			
			Если ТипРасшифровки = Тип("Массив") Или ТипРасшифровки = Тип("СписокЗначений") Тогда
				// Расшифровка списка
				ПараметрыРасшифровки.Вставить("АдресОбъекта", АдресЭтогоОбъекта());
				ПараметрыРасшифровки.Вставить("УпрощенныйРежим", УпрощенныйРежим);
				
				ОткрытьФорму(БазовоеИмяДляФормы + "Форма.СоставВыгрузки", ПараметрыРасшифровки);
				Возврат;
			КонецЕсли;
			
			// Расшифровка объекта
			ПараметрыФормы = Новый Структура("Ключ", ПараметрыРасшифровки.ОбъектРегистрации);
			ОткрытьФорму(ПараметрыРасшифровки.ПолноеИмяМетаданных + ".ФормаОбъекта", ПараметрыФормы);

		ИначеЕсли Не ПустаяСтрока(ПараметрыРасшифровки.ПредставлениеСписка) Тогда
			// Открываем себя же с новыми параметрами
			ПараметрыРасшифровки.Вставить("АдресОбъекта", АдресЭтогоОбъекта());
			ПараметрыРасшифровки.Вставить("УпрощенныйРежим", УпрощенныйРежим);
			
			ОткрытьФорму(БазовоеИмяДляФормы + "Форма.СоставВыгрузки", ПараметрыРасшифровки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
//

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	ЗапуститьАнимациюФормирования();
	СформироватьТабличныйДокументСервер();
	Подключаемый_ОжиданиеФормированияОтчета();
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОтчета(Команда)
	Элементы.ФормаНастройкиОтчета.Пометка = Не Элементы.ФормаНастройкиОтчета.Пометка;
	Элементы.КомпоновщикНастроекПользовательскиеНастройки.Видимость = Элементы.ФормаНастройкиОтчета.Пометка;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

&НаКлиенте
Процедура Подключаемый_ОжиданиеФормированияОтчета()
	Если ЗагрузитьРезультатОтчета() Тогда
		ОстановитьАнимациюФормирования();
	Иначе
		ПодключитьОбработчикОжидания("Подключаемый_ОжиданиеФормированияОтчета", 3, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЭтотОбъект(НовыйОбъект=Неопределено)
	Если НовыйОбъект=Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	ЗначениеВРеквизитФормы(НовыйОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Процедура ОстановитьАнимациюФормирования()
	ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
	ОтображениеСостояния.Видимость = Ложь;
	ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьАнимациюФормирования()
	ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
	ОтображениеСостояния.Видимость                      = Истина;
	ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	ОтображениеСостояния.Картинка                       = БиблиотекаКартинок.ДлительнаяОперация48;
	ОтображениеСостояния.Текст                          = НСтр("ru = 'Отчет формируется...'");
КонецПроцедуры    

&НаСервере
Процедура СформироватьТабличныйДокументСервер()
	
	ОстановитьФормированиеОтчета();
	
	// Запускаем новое, следить будем из обработки ожидания
	АдресРезультатаФоновогоЗадания = ПоместитьВоВременноеХранилище(Неопределено, ЭтаФорма.УникальныйИдентификатор);
	ИдентификаторФоновогоЗадания = ЭтотОбъект().ФоновоеФормированиеТабличногоДокументаПользователя(АдресРезультатаФоновогоЗадания, Параметры.ПолноеИмяМетаданных, Параметры.ПредставлениеСписка, УпрощенныйРежим);
	Если ОбменДаннымиСервер.ФоновоеЗаданиеЗавершено(ИдентификаторФоновогоЗадания) Тогда
		ЗагрузитьРезультатОтчета();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОстановитьФормированиеОтчета()
	
	ОбменДаннымиСервер.ОтменитьФоновоеЗадание(ИдентификаторФоновогоЗадания);
	Если Не ПустаяСтрока(АдресРезультатаФоновогоЗадания) Тогда
		УдалитьИзВременногоХранилища(АдресРезультатаФоновогоЗадания);
	КонецЕсли;
	
	АдресРезультатаФоновогоЗадания = "";
	ИдентификаторФоновогоЗадания   = Неопределено;
КонецПроцедуры

&НаСервере
Функция ЗагрузитьРезультатОтчета()
	
	Если Не ОбменДаннымиСервер.ФоновоеЗаданиеЗавершено(ИдентификаторФоновогоЗадания) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДанныеОтчета = Неопределено;
	Если Не ПустаяСтрока(АдресРезультатаФоновогоЗадания) Тогда
		ДанныеОтчета = ПолучитьИзВременногоХранилища(АдресРезультатаФоновогоЗадания);
		УдалитьИзВременногоХранилища(АдресРезультатаФоновогоЗадания);
	КонецЕсли;
	
	ОстановитьФормированиеОтчета();
	
	Если ТипЗнч(ДанныеОтчета)<>Тип("Структура") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Результат = ДанныеОтчета.ТабличныйДокумент;
	
	ОчиститьРасшифровку();
	АдресДанныхРасшифровки = ПоместитьВоВременноеХранилище(ДанныеОтчета.Расшифровка, Новый УникальныйИдентификатор);
	АдресСхемыКомпоновки   = ПоместитьВоВременноеХранилище(ДанныеОтчета.СхемаКомпоновки, Новый УникальныйИдентификатор);
	
	Возврат Истина;
КонецФункции

&НаСервере
Процедура ПриЗакрытииНаСервере()
	ОстановитьФормированиеОтчета();
	ОчиститьРасшифровку();
КонецПроцедуры

&НаСервере
Процедура ОчиститьРасшифровку()
	
	Если Не ПустаяСтрока(АдресДанныхРасшифровки) Тогда
		УдалитьИзВременногоХранилища(АдресДанныхРасшифровки);
	КонецЕсли;
	Если Не ПустаяСтрока(АдресСхемыКомпоновки) Тогда
		УдалитьИзВременногоХранилища(АдресСхемыКомпоновки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыРасшифровкиПервогоУровня(Расшифровка)
	
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(
		АдресДанныхРасшифровки,
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновки));
	
	ПолеИмяМетаданных = Новый ПолеКомпоновкиДанных("ПолноеИмяМетаданных");
	Настройки = ОбработкаРасшифровки.Расшифровать(Расшифровка, ПолеИмяМетаданных);
	
	ПараметрыРасшифровки = Новый Структура("ПолноеИмяМетаданных, ПредставлениеСписка, ОбъектРегистрации, ИмяМетаданныхОбъектаРегистрации");
	АнализГруппыУровняРасшифровки(Настройки.Отбор, ПараметрыРасшифровки);
	
	Если ПустаяСтрока(ПараметрыРасшифровки.ПолноеИмяМетаданных) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПараметрыРасшифровки;
КонецФункции

&НаСервере
Процедура АнализГруппыУровняРасшифровки(Отбор, ПараметрыРасшифровки)
	
	ПолеИмяМетаданных = Новый ПолеКомпоновкиДанных("ПолноеИмяМетаданных");
	ПолеПредставление = Новый ПолеКомпоновкиДанных("ПредставлениеСписка");
	ПолеОбъект        = Новый ПолеКомпоновкиДанных("ОбъектРегистрации");
	
	Для Каждого Элемент Из Отбор.Элементы Цикл
		Если ТипЗнч(Элемент)=Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			АнализГруппыУровняРасшифровки(Элемент, ПараметрыРасшифровки);
			
		ИначеЕсли Элемент.ЛевоеЗначение=ПолеИмяМетаданных Тогда
			ПараметрыРасшифровки.ПолноеИмяМетаданных = Элемент.ПравоеЗначение;
			
		ИначеЕсли Элемент.ЛевоеЗначение=ПолеПредставление Тогда
			ПараметрыРасшифровки.ПредставлениеСписка = Элемент.ПравоеЗначение;
			
		ИначеЕсли Элемент.ЛевоеЗначение=ПолеОбъект Тогда
			ОбъектРегистрации = Элемент.ПравоеЗначение;
			ПараметрыРасшифровки.ОбъектРегистрации = ОбъектРегистрации;
			
			Если ТипЗнч(ОбъектРегистрации) = Тип("Массив") И ОбъектРегистрации.Количество()>0 Тогда
				Вариант = ОбъектРегистрации[0];
			ИначеЕсли ТипЗнч(ОбъектРегистрации) = Тип("СписокЗначений") И ОбъектРегистрации.Количество()>0 Тогда
				Вариант = ОбъектРегистрации[0].Значение;
			Иначе
				Вариант = ОбъектРегистрации;
			КонецЕсли;
			
			Мета = Метаданные.НайтиПоТипу(ТипЗнч(Вариант));
			ПараметрыРасшифровки.ИмяМетаданныхОбъектаРегистрации = ?(Мета = Неопределено, Неопределено, Мета.ПолноеИмя());
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция АдресЭтогоОбъекта() 
	Возврат ЭтотОбъект().СохранитьЭтотОбъект(УникальныйИдентификатор);
КонецФункции

