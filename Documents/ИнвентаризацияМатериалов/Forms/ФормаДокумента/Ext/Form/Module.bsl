﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ЗапросПоНоменклатуреСклад()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("ГруппаНоменклатуры", ГруппаНоменклатуры);
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.Субконто2 КАК Номенклатура,
	|	0 КАК КоличествоФакт
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			&Период,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|			,
	|			Подразделение = &Подразделение
	|				И Субконто1 = &Склад
	|				И ВЫБОР
	|					КОГДА &ГруппаНоменклатуры = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ Субконто2 В ИЕРАРХИИ (&ГруппаНоменклатуры)
	|				КОНЕЦ) КАК УправленческийОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	УправленческийОстатки.Субконто2.Родитель.Наименование,
	|	УправленческийОстатки.Субконто2.Наименование";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаКлиенте
Функция ЗаполнитьСписокНоменклатуры()
	
	Если рфПерезаполнение Тогда
		ТекстВопроса = "Учетные данные будут перезаполнены.";
	Иначе
		ТекстВопроса = "Табличная часть будет очищена.";
	КонецЕсли;
	
	Если Объект.СписокНоменклатуры.Количество() > 0 Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос(ТекстВопроса + Символы.ВК + "Продолжить?", Режим, 0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьСписокНоменклатурыОстатками();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокНоменклатурыОстатками()
	
	Если НЕ рфПерезаполнение Тогда
		
		Объект.СписокНоменклатуры.Очистить();
		тзНоменклатура = ЗапросПоНоменклатуреСклад();
		
	Иначе
		
		тзНоменклатура = Объект.СписокНоменклатуры.Выгрузить();
		тзНоменклатура.Свернуть("Номенклатура", "КоличествоФакт");
		
	КонецЕсли;
	
	// тз номенклатура содержит позиции, которыми нужно заполнить табличную часть.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Регион", Объект.Подразделение.Регион);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.УстановитьПараметр("тзНоменклатура", тзНоменклатура);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(тзНоменклатура.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	тзНоменклатура.КоличествоФакт
	|ПОМЕСТИТЬ втСписокНоменклатуры
	|ИЗ
	|	&тзНоменклатура КАК тзНоменклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	втСписокНоменклатуры.КоличествоФакт,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстаток, 0) КАК КоличествоУчетное,
	|	ЕСТЬNULL(УправленческийОстатки.СуммаОстаток, 0) КАК СтоимостьУчетная,
	|	ВЫБОР
	|		КОГДА втСписокНоменклатуры.Номенклатура.Базовый
	|			ТОГДА ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная
	|		ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * втСписокНоменклатуры.Номенклатура.КоэффициентБазовых
	|	КОНЕЦ КАК ПлановаяЦена
	|ПОМЕСТИТЬ втНоменклатураОстатки
	|ИЗ
	|	втСписокНоменклатуры КАК втСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				&Период,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто1 = &Склад
	|					И Субконто2 В
	|						(ВЫБРАТЬ
	|							т.Номенклатура
	|						ИЗ
	|							втСписокНоменклатуры КАК т)) КАК УправленческийОстатки
	|		ПО втСписокНоменклатуры.Номенклатура = УправленческийОстатки.Субконто2
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Период, Регион = &Регион) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО (втСписокНоменклатуры.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|				ИЛИ втСписокНоменклатуры.Номенклатура.БазоваяНоменклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНоменклатураОстатки.Номенклатура,
	|	втНоменклатураОстатки.КоличествоФакт,
	|	втНоменклатураОстатки.КоличествоУчетное,
	|	втНоменклатураОстатки.СтоимостьУчетная,
	|	втНоменклатураОстатки.ПлановаяЦена,
	|	ВЫБОР
	|		КОГДА втНоменклатураОстатки.КоличествоУчетное = 0
	|			ТОГДА втНоменклатураОстатки.ПлановаяЦена
	|		ИНАЧЕ втНоменклатураОстатки.СтоимостьУчетная / втНоменклатураОстатки.КоличествоУчетное
	|	КОНЕЦ КАК Цена,
	|	втНоменклатураОстатки.КоличествоФакт - втНоменклатураОстатки.КоличествоУчетное КАК Отклонение
	|ИЗ
	|	втНоменклатураОстатки КАК втНоменклатураОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	втНоменклатураОстатки.Номенклатура.Родитель.Наименование,
	|	втНоменклатураОстатки.Номенклатура.Наименование";
	
	Объект.СписокНоменклатуры.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ПерезаполнитьУчетныеДанные(Команда)
	
	ГруппаНоменклатуры = Неопределено;
	рфПерезаполнение = Истина;
	ЗаполнитьСписокНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьУчетнымиДанными(Команда)
	
	ГруппаНоменклатуры = Неопределено;
	рфПерезаполнение = Ложь;
	ЗаполнитьСписокНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФактическиеДанныеУчетными(Команда)
	
	Для каждого ы Из Объект.СписокНоменклатуры Цикл
		
		Ы.КоличествоФакт = Ы.КоличествоУчетное;
		Ы.СтоимостьФакт = ы.СтоимостьУчетная;
		Ы.Отклонение = 0;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьУчетнымиДаннымиГруппой(Команда)
	
	ГруппаНоменклатуры = ОткрытьФормуМодально("Справочник.Номенклатура.ФормаВыбораГруппы");
	Если ЗначениеЗаполнено(ГруппаНоменклатуры) Тогда
		рфПерезаполнение = Ложь;
		ЗаполнитьСписокНоменклатуры();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ СПИСОК НОМЕНКЛАТУРЫ

&НаКлиенте
Процедура СписокНоменклатурыКоличествоФактПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	ТекущиеДанные.Отклонение = ТекущиеДанные.КоличествоФакт - ТекущиеДанные.КоличествоУчетное;
	
	Если ТекущиеДанные.КоличествоФакт = ТекущиеДанные.КоличествоУчетное Тогда
		ТекущиеДанные.СтоимостьФакт = ТекущиеДанные.СтоимостьУчетная;
	Иначе
		ТекущиеДанные.СтоимостьФакт = ТекущиеДанные.КоличествоФакт * ТекущиеДанные.Цена;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыНоменклатураПриИзменении(Элемент)
	
	ТекДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	ПараметрыФункции = Новый Структура;
	ПараметрыФункции.Вставить("Дата", Объект.Дата);
	ПараметрыФункции.Вставить("Подразделение", Объект.Подразделение);
	ПараметрыФункции.Вставить("Склад", Объект.Склад);
	ПараметрыФункции.Вставить("Номенклатура", ТекДанные.Номенклатура);
	
	ЗаполнитьЗначенияСвойств(ТекДанные, ПолучитьОстатокЦену(ПараметрыФункции));
	ТекДанные.Отклонение = ТекДанные.КоличествоФакт - ТекДанные.КоличествоУчетное;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОстатокЦену(ПараметрыФункции)
	
	Структура = Новый Структура;
	Структура.Вставить("Цена");
	Структура.Вставить("КоличествоУчетное");
	Структура.Вставить("СтоимостьУчетная");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", ПараметрыФункции.Подразделение);
	Запрос.УстановитьПараметр("Регион", ПараметрыФункции.Подразделение.Регион);
	Запрос.УстановитьПараметр("Склад", ПараметрыФункции.Склад);
	Запрос.УстановитьПараметр("Период", ПараметрыФункции.Дата);
	Запрос.УстановитьПараметр("Номенклатура", ПараметрыФункции.Номенклатура);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	спрНоменклатура.Ссылка КАК Номенклатура,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстаток, 0) КАК КоличествоУчетное,
	|	ЕСТЬNULL(УправленческийОстатки.СуммаОстаток, 0) КАК СтоимостьУчетная,
	|	ВЫБОР
	|		КОГДА спрНоменклатура.Базовый
	|			ТОГДА ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная
	|		ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * спрНоменклатура.КоэффициентБазовых
	|	КОНЕЦ КАК ПлановаяЦена
	|ПОМЕСТИТЬ втНоменклатураОстатки
	|ИЗ
	|	Справочник.Номенклатура КАК спрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				&Период,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто1 = &Склад
	|					И Субконто2 = &Номенклатура) КАК УправленческийОстатки
	|		ПО спрНоменклатура.Ссылка = УправленческийОстатки.Субконто2
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Период, Регион = &Регион) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО (спрНоменклатура.Ссылка = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|				ИЛИ спрНоменклатура.Ссылка.БазоваяНоменклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура)
	|ГДЕ
	|	спрНоменклатура.Ссылка = &Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНоменклатураОстатки.КоличествоУчетное,
	|	втНоменклатураОстатки.СтоимостьУчетная,
	|	ВЫБОР
	|		КОГДА втНоменклатураОстатки.КоличествоУчетное = 0
	|			ТОГДА втНоменклатураОстатки.ПлановаяЦена
	|		ИНАЧЕ втНоменклатураОстатки.СтоимостьУчетная / втНоменклатураОстатки.КоличествоУчетное
	|	КОНЕЦ КАК Цена
	|ИЗ
	|	втНоменклатураОстатки КАК втНоменклатураОстатки";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(Структура, Выборка);
	КонецЕсли;
	
	Возврат Структура;
	
КонецФункции

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры
