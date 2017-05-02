﻿///////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СведенияОбОбновлении = ОбновлениеИнформационнойБазы.СведенияОбОбновленииИнформационнойБазы();
	ВремяНачалаОтложенногоОбновления = СведенияОбОбновлении.ВремяНачалаОтложенногоОбновления;
	ВремяОкончанияОтложенногоОбновления = СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления;
	НомерТекущегоСеанса = СведенияОбОбновлении.НомерСеанса;
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		Элементы.ГруппаПовторныйЗапуск.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ИБФайловая Тогда
		ОбновлениеВыполняется = (СведенияОбОбновлении.ОтложенноеОбновлениеЗавершеноУспешно = Неопределено);
	КонецЕсли;
	
	Если Не РольДоступна("ПросмотрЖурналаРегистрации") Тогда
		Элементы.ГиперссылкаОтложенноеОбновление.Видимость = Ложь;
	КонецЕсли;
	
	ОбновитьТаблицуОтложенныхОбработчиков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбновлениеВыполняется Тогда
		ПодключитьОбработчикОжидания("ОбновитьТаблицуОбработчиков", 15);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьПовторно(Команда)
	Оповестить("ОтложенноеОбновление");
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаОтложенноеОбновлениеНажатие(Элемент)
	
	Если ЗначениеЗаполнено(ВремяНачалаОтложенногоОбновления) И ЗначениеЗаполнено(ВремяОкончанияОтложенногоОбновления) Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ДатаНачала", ВремяНачалаОтложенногоОбновления);
		ПараметрыФормы.Вставить("ДатаОкончания", ВремяОкончанияОтложенногоОбновления);
		ПараметрыФормы.Вставить("Сеанс", НомерТекущегоСеанса);
		
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы);
	Иначе
		
		Если ЗначениеЗаполнено(ВремяНачалаОтложенногоОбновления) Тогда
			ТекстПредупреждения = НСтр("ru = 'Обработка данных еще не завершилась.'");
		Иначе
			ТекстПредупреждения = НСтр("ru = 'Обработка данных еще не выполнялась.'");
		КонецЕсли;
		
		Предупреждение(ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбновитьТаблицуОбработчиков()
	
	ВыполненыВсеОбработчики = Истина;
	ОбновитьТаблицуОтложенныхОбработчиков(ВыполненыВсеОбработчики);
	Если ВыполненыВсеОбработчики Тогда
		ОтключитьОбработчикОжидания("ОбновитьТаблицуОбработчиков");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуОтложенныхОбработчиков(ВыполненыВсеОбработчики = Истина)
	
	ОтложенныеОбработчики.Очистить();
	СведенияОбОбновлении = ОбновлениеИнформационнойБазы.СведенияОбОбновленииИнформационнойБазы();
	
	Для Каждого СтрокаДереваБиблиотека Из СведенияОбОбновлении.ДеревоОбработчиков.Строки Цикл
		Для Каждого СтрокаДереваВерсия Из СтрокаДереваБиблиотека.Строки Цикл
			Для Каждого СтрокаОбработчика Из СтрокаДереваВерсия.Строки Цикл
				
				СтрокаСписка = ОтложенныеОбработчики.Добавить();
				СтрокаСписка.Обработчик = СтрокаОбработчика.ИмяОбработчика;
				Если СтрокаОбработчика.Статус = "Выполнено" Тогда
					СтрокаСписка.ИнформацияОПроцедуреОбновления = 
						НСтр("ru = 'Процедура обработки данных завершилась успешно.'") + Символы.ПС + Символы.ПС + СтрокаОбработчика.Комментарий;
					СтрокаСписка.СтатусОбработчика = НСтр("ru = 'Выполнена'");
					СтрокаСписка.Вес = 1;
					СтрокаСписка.СтатусКартинка = БиблиотекаКартинок.Успешно;
				ИначеЕсли СтрокаОбработчика.Статус = "Ошибка" Тогда
					ВыполненыВсеОбработчики = Ложь;
					СтрокаСписка.ИнформацияОПроцедуреОбновления = СтрокаОбработчика.ИнформацияОбОшибке + Символы.ПС + Символы.ПС + СтрокаОбработчика.Комментарий;
					СтрокаСписка.СтатусОбработчика = НСтр("ru = 'Ошибка'");
					СтрокаСписка.Вес = 3;
					СтрокаСписка.СтатусКартинка = БиблиотекаКартинок.Остановить;
				Иначе
					ВыполненыВсеОбработчики = Ложь;
					СтрокаСписка.СтатусОбработчика = НСтр("ru = 'Не выполнялась'");
					СтрокаСписка.Вес = 2;
					СтрокаСписка.ИнформацияОПроцедуреОбновления = НСтр("ru = 'Процедура обработки данных еще не выполнялась.'") 
						+ Символы.ПС + Символы.ПС + СтрокаОбработчика.Комментарий;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Если ВыполненыВсеОбработчики Или ОбновлениеВыполняется Тогда
		Элементы.ГруппаПовторныйЗапуск.Видимость = Ложь;
	КонецЕсли;
	
	ОтложенныеОбработчики.Сортировать("Вес Убыв");
	
	Элементы.ОбновлениеВыполняется.Видимость = ОбновлениеВыполняется;
	
КонецПроцедуры

