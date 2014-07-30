﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Предмет") Тогда 
		Объект.Предмет = Параметры.Предмет;
	КонецЕсли;
	
	Элементы.Предмет.Заголовок = Объект.ПредставлениеПредмета;
	
	Элементы.Предмет.Гиперссылка = ЗначениеЗаполнено(Объект.Предмет);
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Автор = Пользователи.ТекущийПользователь();
		ФорматированныйТекст = Параметры.ЗначениеКопирования.Содержание.Получить();
		
		Элементы.ДатаЗаметки.Заголовок = НСтр("ru = 'Не записано'")
	Иначе
		Элементы.ДатаЗаметки.Заголовок = НСтр("ru = 'Записано'") + ": " + Формат(Объект.ДатаИзменения, "ДЛФ=DDT");
	КонецЕсли;
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ФизЛицо = Пользователь.ФизическоеЛицо;
	ФизЛицоСтрока = ФизЛицо.Фамилия + " " + Лев(ФизЛицо.Имя, 1) + "." + Лев(ФизЛицо.Отчество, 1) + ".";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ФизЛицо" ,ФизЛицо);
	//RonEXI edit
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФизическиеЛица.Должность КАК Должность
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Ссылка = &ФизЛицо";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	ДолжностьФизЛица = Выборка.Должность;
	Выборка.Сбросить();
	
	
	//УстановитьВидимость();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ФорматированныйТекст = ТекущийОбъект.Содержание.Получить();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Содержание = Новый ХранилищеЗначения(ФорматированныйТекст, Новый СжатиеДанных(9));
	
	ТекстHTML = "";
	Вложения = Новый Структура;
	ФорматированныйТекст.ПолучитьHTML(ТекстHTML, Вложения);
	
	ТекущийОбъект.ТекстСодержания = СтроковыеФункцииКлиентСервер.ИзвлечьТекстИзHTML(ТекстHTML);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Элементы.ДатаЗаметки.Заголовок = НСтр("ru = 'Записано'") + ": " + Формат(Объект.ДатаИзменения, "ДЛФ=DDT");
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ЗаписатьТекст();
	
КонецПроцедуры
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПредметНажатие(Элемент)
	ОткрытьЗначение(Объект.Предмет);
КонецПроцедуры

&НаКлиенте
Процедура АвторНажатие(Элемент)
	ОткрытьЗначение(Объект.Автор);
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	ЗаписатьТекст();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТекст()
	
	Если ЗначениеЗаполнено(ТекстПользователя) Тогда
		
		НашТекстОтвета = Символы.ПС + Формат(ТекущаяДата(), "ДЛФ=DT") + "  (" + ДолжностьФизЛица + ") " + ФизЛицоСтрока + ": "+ ТекстПользователя;
		
		Если ЗначениеЗаполнено(ФорматированныйТекст.ПолучитьТекст()) Тогда
			ФорматированныйТекст.Добавить(Символы.ПС + НашТекстОтвета);
		Иначе
			ФорматированныйТекст.Добавить(НашТекстОтвета);
		КонецЕсли;
		
		ТекстПользователя = "";
		
	КонецЕсли;
		
КонецПроцедуры // ЗаписатьТекст()


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

