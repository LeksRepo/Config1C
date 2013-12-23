﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиенте
Функция ЗаполнитьСписокНоменклатуры()
	
	Если Объект.СписокНоменклатуры.Количество() > 0 Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос("Табличная часть будет очищена." + Символы.ВК + "Продолжить?", Режим, 0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьСписокНоменклатурыОстатками();
	
КонецФункции

&НаСервере
Функция СформироватьЗапросЛогистика()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.Субконто2 КАК Номенклатура,
	|	УправленческийОстатки.СуммаОстаток КАК СтоимостьУчетная,
	|	УправленческийОстатки.КоличествоОстаток КАК КоличествоУчетное,
	|	-УправленческийОстатки.КоличествоОстаток КАК Отклонение,
	|	УправленческийОстатки.Субконто2.Родитель КАК НоменклатураРодитель
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
	
	Возврат Запрос;
	
КонецФункции

Функция СформироватьЗапросПроизводство()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("ГруппаНоменклатуры", ГруппаНоменклатуры);
	Запрос.УстановитьПараметр("Регион", Объект.Подразделение.Регион);
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.Субконто1 КАК Номенклатура,
	|	УправленческийОстатки.КоличествоОстаток КАК КоличествоУчетное,
	|	-УправленческийОстатки.КоличествоОстаток КАК Отклонение,
	|	УправленческийОстатки.Субконто1.Родитель КАК НоменклатураРодитель,
	|	УправленческийОстатки.КоличествоОстаток * ЦеныНоменклатурыСрезПоследних.Внутренняя КАК СтоимостьУчетная
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			&Период,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ОсновноеПроизводство),
	|			,
	|			Подразделение = &Подразделение
	|				И ВЫБОР
	|					КОГДА &ГруппаНоменклатуры = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ Субконто1 В ИЕРАРХИИ (&ГруппаНоменклатуры)
	|				КОНЕЦ) КАК УправленческийОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Период, Регион = &Регион) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО УправленческийОстатки.Субконто1 = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	УправленческийОстатки.Субконто1.Родитель.Наименование,
	|	УправленческийОстатки.Субконто1.Наименование";
	
	Возврат Запрос;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокНоменклатурыОстатками()
	
	Объект.СписокНоменклатуры.Очистить();
	
	Если Объект.Подразделение = Справочники.Подразделения.Логистика Тогда
		Запрос = СформироватьЗапросЛогистика();
	Иначе
		Запрос = СформироватьЗапросПроизводство();
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.СписокНоменклатуры.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		Если НоваяСтрока.КоличествоУчетное <> 0 И НоваяСтрока.СтоимостьУчетная <> 0 Тогда
			НоваяСтрока.Цена = НоваяСтрока.СтоимостьУчетная / НоваяСтрока.КоличествоУчетное;
		Иначе
			НоваяСтрока.Цена = -1;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

Функция ОбновитьДоступностьЭлементов()
	
	Если Объект.Подразделение = ПредопределенноеЗначение("Справочник.Подразделения.Логистика") Тогда
		Элементы.Склад.Доступность = Истина;
	Иначе
		Элементы.Склад.Доступность = Ложь;
		Объект.Склад = Неопределено;
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ЗаполнитьОстаткамиПоСкладу(Команда)
	
	ГруппаНоменклатуры = Неопределено;
	ЗаполнитьСписокНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФактическиеДанныеУчетными(Команда)
	
	Для каждого ы Из Объект.СписокНоменклатуры Цикл
		
		Ы.КоличествоФакт = Ы.КоличествоУчетное;
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

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ СПИСОК НОМЕНКЛАТУРЫ

&НаКлиенте
Процедура СписокНоменклатурыКоличествоФактПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	ТекущиеДанные.Отклонение = ТекущиеДанные.КоличествоФакт - ТекущиеДанные.КоличествоУчетное;
	
КонецПроцедуры

