﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ОбработкаКоманды(МассивВариантов, ПараметрыВыполненияКоманды)
	КоличествоВариантов = МассивВариантов.Количество();
	Если КоличествоВариантов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЕстьПользовательскиеНастройкиСервер(МассивВариантов) Тогда
		Предупреждение(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Пользовательские настройки выбранных вариантов отчетов (%1 шт) не заданы или уже сброшены.'"),
				Формат(КоличествоВариантов, "ЧГ=")));
		Возврат;
	КонецЕсли;
	
	ТекстВопроса =
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Внимание, операция ""Сбросить настройки пользователей"" необратима.
		|
		|Нажмите ""Продолжить"" что бы сбросить пользовательские настройки
		|быстрого доступа и видимости выбранных вариантов отчетов (%1 шт).'"),
		Формат(КоличествоВариантов, "ЧГ="));
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(1, НСтр("ru = 'Продолжить'"));
	Кнопки.Добавить(КодВозвратаДиалога.Отмена);
	
	Ответ = Вопрос(ТекстВопроса, Кнопки, , КодВозвратаДиалога.Отмена);
	Если Ответ <> 1 Тогда
		Возврат;
	КонецЕсли;
	
	СброситьНастройкиПользователейСервер(МассивВариантов);
	Если КоличествоВариантов = 1 Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Сброшены пользовательские настройки варианта отчета'"),
			ПолучитьНавигационнуюСсылку(МассивВариантов[0]),
			Строка(МассивВариантов[0]));
	Иначе
		ПоказатьОповещениеПользователя(
			,
			,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сброшены пользовательские настройки
				|вариантов отчетов (%1 шт.).'"),
				Формат(МассивВариантов.Количество(), "ЧН=0; ЧГ=0")));
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция СброситьНастройкиПользователейСервер(МассивВариантов)
	НачатьТранзакцию();
	Для Каждого ВариантСсылка Из МассивВариантов Цикл
		РегистрыСведений.НастройкиВариантовОтчетов.СброситьНастройкиВариантаОтчета(ВариантСсылка);
	КонецЦикла;
	ЗафиксироватьТранзакцию();
КонецФункции

&НаСервере
Функция ЕстьПользовательскиеНастройкиСервер(МассивВариантов)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивВариантов", МассивВариантов);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК Поле1
	|ИЗ
	|	РегистрСведений.НастройкиВариантовОтчетов КАК Настройки
	|ГДЕ
	|	Настройки.Вариант В(&МассивВариантов)";
	
	ЕстьПользовательскиеНастройки = НЕ Запрос.Выполнить().Пустой();
	Возврат ЕстьПользовательскиеНастройки;
КонецФункции

