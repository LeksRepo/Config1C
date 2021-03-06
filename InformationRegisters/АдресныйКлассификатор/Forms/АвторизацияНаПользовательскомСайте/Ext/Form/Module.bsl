﻿
#Область ОбработчикиСобытийФормы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	АдресныйКлассификатор.ПолучитьПараметрыАутентификации(КодПользователя, Пароль);
	ЗапомнитьПароль = ? (ПустаяСтрока(Пароль), Ложь, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
//

&НаКлиенте
Процедура ПерейтиКРегистрацииНаСайтеНажатие(Элемент)
	ЗапуститьПриложение("http://users.v8.1c.ru/");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
//

// Кнопка "Продолжить", выполнение выбора.
//
//    Результат выбора: Неопределено, если пользователь отказался от ввода пароля, или структура с полями:
//        Статус - истина или ложь в зависимости от успеха вызова
//        КодПользователя - строка кода пользователя, имеет смысл только если Статус=Истина
//        Пароль          - строка пароля, имеет смысл только если Статус=Истина
&НаКлиенте
Процедура СохранитьДанныеАутентификацииИПродолжитьВыполнить()
	
	СохраняемыйПароль = ?(ЗапомнитьПароль, Пароль, Неопределено);
	СохранитьДанныеАутентификации(КодПользователя, СохраняемыйПароль);
	
	Результат = Новый Структура("Статус, КодПользователя ,Пароль", Истина, КодПользователя, Пароль);
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//

&НаСервереБезКонтекста
Процедура СохранитьДанныеАутентификации(Код, Пароль)
	АдресныйКлассификатор.СохранитьПараметрыАутентификации(Код, Пароль);
КонецПроцедуры

#КонецОбласти
