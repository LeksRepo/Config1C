﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ИспользованиеРазделителяСеанса() Тогда 
		ВызватьИсключение(НСтр("ru = 'Не установлено значение разделителя'"));
	КонецЕсли;
	
	ПереключитьСтраницу(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьКопиюОбласти(Команда)
	
	Попытка
		Результат = СоздатьКопиюОбластиНаСервере();
	Исключение	
		ПереключитьСтраницу(ЭтаФорма, "СтраницаПослеВыгрузкиОшибка");
	КонецПопытки;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ОбработатьРезультатВыполненияЗадания();
	Иначе
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				ОбработатьРезультатВыполненияЗадания();
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ПереключитьСтраницу(ЭтаФорма, "СтраницаПослеВыгрузкиОшибка");
		ЗаписатьИсключениеНаСервере(ПредставлениеОшибки);	
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатВыполненияЗадания()
	
	Если Не ПустаяСтрока(АдресХранилища) Тогда
		УдалитьИзВременногоХранилища(АдресХранилища);
		АдресХранилища = "";
		// Перейти на страницу результата
		ПереключитьСтраницу(ЭтаФорма, "СтраницаПослеВыгрузкиУспех");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПереключитьСтраницу(Форма, Знач ИмяСтраницы = "СтраницаДоВыгрузки")
	
	Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница = Форма.Элементы[ИмяСтраницы];
	
	Если ИмяСтраницы = "СтраницаДоВыгрузки" Тогда
		Форма.Элементы.ФормаСоздатьКопиюОбласти.Доступность = Истина;
	Иначе
		Форма.Элементы.ФормаСоздатьКопиюОбласти.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаписатьИсключениеНаСервере(Знач ПредставлениеОшибки)
	
	Событие = РезервноеКопированиеОбластейДанныхПовтИсп.НаименованиеФоновогоРезервногоКопирования();
	ЗаписьЖурналаРегистрации(Событие, УровеньЖурналаРегистрации.Ошибка, , , ПредставлениеОшибки);
	СообщениеОбОшибке = ПредставлениеОшибки;
	
КонецПроцедуры

&НаСервере
Функция СоздатьКопиюОбластиНаСервере()
	
	ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
	
	ПараметрыЗадания = РезервноеКопированиеОбластейДанных.СоздатьПустыеПараметрыВыгрузки();
	ПараметрыЗадания.ОбластьДанных = ОбластьДанных;
	ПараметрыЗадания.ИДКопии = Новый УникальныйИдентификатор;
	ПараметрыЗадания.Принудительно = Истина;
	ПараметрыЗадания.ПоТребованию = Истина;
	
	Попытка
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			РезервноеКопированиеОбластейДанныхПовтИсп.ИмяМетодаФоновогоРезервногоКопирования(),
			ПараметрыЗадания, 
			РезервноеКопированиеОбластейДанныхПовтИсп.НаименованиеФоновогоРезервногоКопирования());
		
	Исключение
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьИсключениеНаСервере(ПредставлениеОшибки);
	КонецПопытки;
	
	АдресХранилища = Результат.АдресХранилища;
	ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции
