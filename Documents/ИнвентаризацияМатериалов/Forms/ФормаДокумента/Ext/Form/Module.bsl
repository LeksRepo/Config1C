﻿
&НаКлиенте
Функция ЗаполнитьСписокНоменклатуры()
	
	ТекстВопроса = "Табличная часть будет очищена.";
	
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
	
	Объект.СписокНоменклатуры.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.УстановитьПараметр("ГруппаНоменклатуры", ГруппаНоменклатуры);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.Субконто2 КАК Номенклатура,
	|	0 КАК КоличествоФакт,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстаток, 0) КАК КоличествоУчетное,
	|	ЕСТЬNULL(УправленческийОстатки.СуммаОстаток, 0) КАК СтоимостьУчетная,
	|	ВЫБОР
	|		КОГДА УправленческийОстатки.Субконто2.Базовый
	|			ТОГДА ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная
	|		ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * УправленческийОстатки.Субконто2.КоэффициентБазовых
	|	КОНЕЦ КАК ПлановаяЦена
	|ПОМЕСТИТЬ втНоменклатураОстатки
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
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(&Период, Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО (УправленческийОстатки.Субконто2 = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|				ИЛИ УправленческийОстатки.Субконто2.БазоваяНоменклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура)
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

&НаСервере
Функция ПерезаполнитьУчетныеДанныеСервер()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("тз", Объект.СписокНоменклатуры.Выгрузить());
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	тзСписокНоменклатуры.КоличествоФакт,
	|	тзСписокНоменклатуры.Номенклатура
	|ПОМЕСТИТЬ втСписокНоменклатуры
	|ИЗ
	|	&тз КАК тзСписокНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втСписокНоменклатуры.Номенклатура,
	|	ВЫБОР
	|		КОГДА УправленческийОстатки.КоличествоОстатокДт <> 0
	|			ТОГДА УправленческийОстатки.СуммаОстатокДт / УправленческийОстатки.КоличествоОстатокДт * втСписокНоменклатуры.КоличествоФакт
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СтоимостьФакт,
	|	УправленческийОстатки.КоличествоОстатокДт КАК КоличествоУчетное,
	|	втСписокНоменклатуры.КоличествоФакт,
	|	УправленческийОстатки.СуммаОстатокДт КАК СтоимостьУчетная,
	|	ВЫБОР
	|		КОГДА УправленческийОстатки.КоличествоОстатокДт <> 0
	|			ТОГДА УправленческийОстатки.СуммаОстатокДт / УправленческийОстатки.КоличествоОстатокДт
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Цена,
	|	втСписокНоменклатуры.КоличествоФакт - УправленческийОстатки.КоличествоОстатокДт КАК Отклонение
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
	|		ПО втСписокНоменклатуры.Номенклатура = УправленческийОстатки.Субконто2";
	
	РезультатЗапроса = Запрос.Выполнить();
	Объект.СписокНоменклатуры.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецФункции

&НаКлиенте
Процедура ПерезаполнитьУчетныеДанные(Команда)
	
	Отказ = Ложь;
	
	Если Объект.СписокНоменклатуры.Количество() > 0 Тогда
		
		ТекстВопроса = "Учетные данные будут перезаполнены.";
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос(ТекстВопроса + Символы.ВК + "Продолжить?", Режим, 0);
		
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Отказ = Истина;
		КонецЕсли;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Табличная часть пуста, нечего перезаполнять");
		Отказ = Истина;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ПерезаполнитьУчетныеДанныеСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьУчетнымиДанными(Команда)
	
	ГруппаНоменклатуры = Неопределено;
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
		ЗаполнитьСписокНоменклатуры();
	КонецЕсли;
	
КонецПроцедуры

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
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(&Период, Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних
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
