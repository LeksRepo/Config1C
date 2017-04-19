﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		УстановитьПредставлениеРасписания(ЭтаФорма);
		ПараметрыМетода = ОбщегоНазначения.ЗначениеВСтрокуXML(Новый Массив);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Идентификатор = Объект.Ссылка.УникальныйИдентификатор();
	
	Расписание = ТекущийОбъект.Расписание.Получить();
	УстановитьПредставлениеРасписания(ЭтаФорма);
	
	ПараметрыМетода = ОбщегоНазначения.ЗначениеВСтрокуXML(ТекущийОбъект.Параметры.Получить());
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Расписание = Новый ХранилищеЗначения(Расписание);
	ТекущийОбъект.Параметры = Новый ХранилищеЗначения(ОбщегоНазначения.ЗначениеИзСтрокиXML(ПараметрыМетода));
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Идентификатор = Объект.Ссылка.УникальныйИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеРасписанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаблокироватьДанныеФормыДляРедактирования();
	
	Если Расписание = Неопределено Тогда
		РедактируемоеРасписание = Новый РасписаниеРегламентногоЗадания;
	Иначе
		РедактируемоеРасписание = Расписание;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РедактируемоеРасписание);
	Если НЕ Диалог.ОткрытьМодально() Тогда
		Возврат;
	КонецЕсли;
	
	Расписание = Диалог.Расписание;
	Модифицированность = Истина;
	УстановитьПредставлениеРасписания(ЭтаФорма);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Перепланирование'"), , НСтр("ru = 'Новое расписание будет учтено при
		|следующем выполнении задания'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеРасписанияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаблокироватьДанныеФормыДляРедактирования();
	
	Расписание = Неопределено;
	Модифицированность = Истина;
	УстановитьПредставлениеРасписания(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеРасписания(Знач Форма)
	
	Расписание = Форма.Расписание;
	
	Если Расписание <> Неопределено Тогда
		Форма.ПредставлениеРасписания = Строка(Расписание);
	Иначе
		Форма.ПредставлениеРасписания = НСтр("ru = '<Не задано>'");
	КонецЕсли;
	
КонецПроцедуры

