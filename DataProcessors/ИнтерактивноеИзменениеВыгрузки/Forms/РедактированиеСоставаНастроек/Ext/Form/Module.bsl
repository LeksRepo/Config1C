﻿////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
    ЗаполнитьЗначенияСвойств(Объект, Параметры.Объект , , "ДополнительнаяРегистрация");
    Для Каждого Строка Из Параметры.Объект.ДополнительнаяРегистрация Цикл
        ЗаполнитьЗначенияСвойств(Объект.ДополнительнаяРегистрация.Добавить(), Строка);
    КонецЦикла;
    
    ПредставлениеТекущейНастройки = Параметры.ПредставлениеТекущейНастройки;
    ПрочитатьСохраненныеНастройки();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ВариантыНастроек
//

&НаКлиенте
Процедура ВариантыНастроекВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    ТекущиеДанные = ВариантыНастроек.НайтиПоИдентификатору(ВыбраннаяСтрока);
    Если ТекущиеДанные<>Неопределено Тогда
        ПредставлениеТекущейНастройки = ТекущиеДанные.Представление;
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВариантыНастроекПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
    Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВариантыНастроекПередУдалением(Элемент, Отказ)
    ПредставлениеНастройки = Элемент.ТекущиеДанные.Представление;
    
    ТекстЗаголовка = НСтр("ru='Подтверждение'");
    ТекстВопроса   = НСтр("ru='Удалить настройку ""%1""?'");
    
    ТекстВопроса = СтрЗаменить(ТекстВопроса, "%1", ПредставлениеНастройки);
    Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ТекстЗаголовка);
    Отказ = Ответ<>КодВозвратаДиалога.Да;
    Если Не Отказ Тогда
        УдалитьНастройкуСервер(ПредставлениеНастройки);
        // Форму перестраиваем сами
        ПрочитатьСохраненныеНастройки();
        Отказ = Истина;
    КонецЕсли;
    
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
//

&НаКлиенте
Процедура СохранитьНастройку(Команда)
    
    Если Не ПустаяСтрока(ПредставлениеТекущейНастройки) Тогда
        Если ВариантыНастроек.НайтиПоЗначению(ПредставлениеТекущейНастройки)<>Неопределено Тогда
            ТекстЗаголовка = НСтр("ru='Подтверждение'");
            ТекстВопроса   = НСтр("ru='Перезаписать существующую настройку ""%1""?'");
            ТекстВопроса = СтрЗаменить(ТекстВопроса, "%1", ПредставлениеТекущейНастройки);
            Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ТекстЗаголовка);
            Если Ответ<>КодВозвратаДиалога.Да Тогда
                Возврат;
            КонецЕсли;        
        КонецЕсли;            
        СохранитьТекущиеНастройки();
        ПрочитатьСохраненныеНастройки();
        
        ЗакрыватьПриВыборе = Истина;
        ВыполнитьВыбор(ПредставлениеТекущейНастройки);
        Возврат;
    КонецЕсли;
    
    ТекстОшибки = НСтр("ru='Не заполнено имя для текущей настройки.'");
    
    Ошибка = Новый СообщениеПользователю;
    Ошибка.УстановитьДанные(ЭтаФорма);
    Ошибка.Поле = "ПредставлениеТекущейНастройки";
    Ошибка.Текст = ТекстОшибки;
    Ошибка.Сообщить();
КонецПроцедуры

&НаКлиенте
Процедура ПроизвестиВыбор(Команда)
    ВыполнитьВыбор(ПредставлениеТекущейНастройки);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

&НаСервере
Функция ЭтотОбъект(НовыйОбъект=Неопределено)
    Если НовыйОбъект=Неопределено Тогда
        Возврат РеквизитФормыВЗначение("Объект");
    КонецЕсли;
    ЗначениеВРеквизитФормы(НовыйОбъект, "Объект");
    Возврат Неопределено;
КонецФункции    

&НаСервере
Процедура УдалитьНастройкуСервер(ПредставлениеНастройки)
    ЭтотОбъект().УдалитьВариантНастроек(ПредставлениеНастройки);
КонецПроцедуры    

&НаСервере
Процедура ПрочитатьСохраненныеНастройки()
    ЭтотОбъект = ЭтотОбъект();
    ВариантыНастроек = ЭтотОбъект.ПрочитатьПредставленияСпискаНастроек(Объект.УзелИнформационнойБазы);
    ЭлементСписка = ВариантыНастроек.НайтиПоЗначению(ПредставлениеТекущейНастройки);
    Элементы.ВариантыНастроек.ТекущаяСтрока = ?(ЭлементСписка=Неопределено, Неопределено, ЭлементСписка.ПолучитьИдентификатор())
КонецПроцедуры    

&НаСервере
Процедура СохранитьТекущиеНастройки()
    ЭтотОбъект().СохранитьТекущееВНастройки(ПредставлениеТекущейНастройки);
КонецПроцедуры    

&НаКлиенте
Процедура ВыполнитьВыбор(Представление)
    Если ВариантыНастроек.НайтиПоЗначению(Представление)<>Неопределено И ЗакрыватьПриВыборе Тогда 
        ОповеститьОВыборе(
            Новый Структура("ДействиеВыбора, ПредставлениеНастройки", 3, Представление)
        );        
    КонецЕсли;
КонецПроцедуры    

