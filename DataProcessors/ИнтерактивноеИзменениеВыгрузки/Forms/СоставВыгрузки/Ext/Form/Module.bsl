﻿////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
    Элементы.ФормаНастройкиОтчета.Видимость = Ложь;
    
    ЭтотОбъект = ЭтотОбъект();
    Если Не ПустаяСтрока(Параметры.АдресОбъекта) Тогда
        ЭтотОбъект( ЭтотОбъект.ИнициализироватьЭтотОбъект(Параметры.АдресОбъекта) );
    КонецЕсли;
    
    Если Не ЗначениеЗаполнено(Объект.УзелИнформационнойБазы) Тогда
        Текст = НСтр("ru='Настройка обмена данными не найдена.'");
        ОбменДаннымиСервер.СообщитьОбОшибке(Текст, Отказ);
        Возврат;
    КонецЕсли;                
    
    Заголовок = Заголовок + " (" + Объект.УзелИнформационнойБазы + ")";
    БазовоеИмяДляФормы = ЭтотОбъект.БазовоеИмяДляФормы();
    
    
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

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ
//

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
    СтандартнаяОбработка = Ложь;
    
    ПараметрыРасшифровки = ПараметрыРасшифровкиПервогоУровня(Расшифровка);
    Если ПараметрыРасшифровки<>Неопределено Тогда
        Если ПараметрыРасшифровки.ИмяМетаданныхОбъектаРегистрации=ПараметрыРасшифровки.ПолноеИмяМетаданных Тогда
            ОткрытьФорму(ПараметрыРасшифровки.ПолноеИмяМетаданных + ".ФормаОбъекта",
                Новый Структура("Ключ", ПараметрыРасшифровки.ОбъектРегистрации)
            );
        ИначеЕсли Не ПустаяСтрока(ПараметрыРасшифровки.ПредставлениеСписка) Тогда
            ПараметрыРасшифровки.Вставить("АдресОбъекта", АдресЭтогоОбъекта());
            ОткрытьФорму(БазовоеИмяДляФормы + "Форма.СоставВыгрузки", ПараметрыРасшифровки);
        КонецЕсли;            
    КонецЕсли;
    
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
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

////////////////////////////////////////////////////////////////////////////////////////////////////
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
    ИдентификаторФоновогоЗадания = ЭтотОбъект().ФоновоеФормированиеТабличногоДокументаПользователя(АдресРезультатаФоновогоЗадания, Параметры.ПолноеИмяМетаданных, Параметры.ПредставлениеСписка);
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
        Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновки)
    );
    
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
            АнализГруппыУровняРасшифровки(Элемент, ПараметрыРасшифровки)
        ИначеЕсли Элемент.ЛевоеЗначение=ПолеИмяМетаданных Тогда
            ПараметрыРасшифровки.ПолноеИмяМетаданных = Элемент.ПравоеЗначение;
        ИначеЕсли Элемент.ЛевоеЗначение=ПолеПредставление Тогда
            ПараметрыРасшифровки.ПредставлениеСписка = Элемент.ПравоеЗначение;
        ИначеЕсли Элемент.ЛевоеЗначение=ПолеОбъект Тогда
            ОбъектРегистрации = Элемент.ПравоеЗначение;
            ПараметрыРасшифровки.ОбъектРегистрации = ОбъектРегистрации;
            Если ЗначениеЗаполнено(ОбъектРегистрации) Тогда
                ПараметрыРасшифровки.ИмяМетаданныхОбъектаРегистрации = ОбъектРегистрации.Метаданные().ПолноеИмя();
            Иначе                 
                ПараметрыРасшифровки.ИмяМетаданныхОбъектаРегистрации = Неопределено;
            КонецЕсли;
        КонецЕсли;
    КонецЦикла;
КонецПроцедуры    
    
&НаСервере
Функция АдресЭтогоОбъекта() 
    Возврат ПоместитьВоВременноеХранилище(
        ЭтотОбъект(), 
        УникальныйИдентификатор
    );
КонецФункции

