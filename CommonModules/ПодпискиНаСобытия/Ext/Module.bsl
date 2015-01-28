﻿Процедура ПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Источник.Автор) Тогда 
		
		Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
			Источник.Автор = ПользователиКлиентСервер.ТекущийВнешнийПользователь();
		Иначе
			Источник.Автор = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопированииДокумента(Источник, ОбъектКопирования) Экспорт
	
	Источник.Автор = Неопределено;
	
КонецПроцедуры

Процедура ОбработкаЗаполненияДокументов(Источник, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	// утсановим новым документам
	// текущую дату сервера
	Источник.Дата = ТекущаяДата();
	
КонецПроцедуры

Процедура ПередЗаписьюДокументаИлиСправочника(Источник) Экспорт
	
	Если Источник.ПометкаУдаления <> Источник.Ссылка.ПометкаУдаления Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Файлы.Ссылка КАК ФайлЗаметка
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|ГДЕ
		|	Файлы.ВладелецФайла = &Владелец
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Заметки.Ссылка
		|ИЗ
		|	Справочник.Заметки КАК Заметки
		|ГДЕ
		|	Заметки.Предмет = &Владелец";
		
		Запрос.УстановитьПараметр("Владелец", Источник.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			НовыйФайл = ВыборкаДетальныеЗаписи.ФайлЗаметка.ПолучитьОбъект();
			Если ТипЗнч(НовыйФайл) = Тип("СправочникОбъект.Файлы") Тогда
				
				НовыйФайл.Редактирует = Справочники.Пользователи.ПустаяСсылка();
				НовыйФайл.Записать();
				
			КонецЕсли;
			
			НовыйФайл.УстановитьПометкуУдаления(Источник.ПометкаУдаления);
		
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры
