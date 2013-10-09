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
	
	УстановитьВидимость();
	
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

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьВидимость()
	Элементы.Автор.Заголовок = Объект.Автор;
	ОткрытаАвтором = Объект.Автор = Пользователи.ТекущийПользователь();
	Элементы.ПараметрыОтображения.Видимость = ОткрытаАвтором;
	Элементы.ИнформацияОбАвторе.Видимость = Не ОткрытаАвтором;
	
	ТолькоПросмотр = Не ОткрытаАвтором;
	Элементы.Содержание.ТолькоПросмотр = Не ОткрытаАвтором;
	Элементы.КоманднаяПанельРедактирования.Видимость = ОткрытаАвтором;
КонецПроцедуры



