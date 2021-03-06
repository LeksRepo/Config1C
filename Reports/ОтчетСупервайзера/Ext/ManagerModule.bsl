﻿
Функция СформироватьОтчет(ПараметрыОтчета) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокВРаботе = Новый ТабличныйДокумент;
	ТабДокСЗ = Новый ТабличныйДокумент;
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.АвтоМасштаб = Истина;
	ТЗПросроченные = ПолучитьТЗ(ПараметрыОтчета.ПериодОтчета.ДатаНачала, ПараметрыОтчета.Подразделение, ПараметрыОтчета.Сотрудник);
	
	Макет = Отчеты.ОтчетСупервайзера.ПолучитьМакет("Макет");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрокаСотрудник = Макет.ПолучитьОбласть("СтрокаСотрудник");
	ОбластьСтрокаРуководитель = Макет.ПолучитьОбласть("СтрокаРуководитель");	
	ОбластьШапкаВстречи = Макет.ПолучитьОбласть("ШапкаВстречи");
	ОбластьСтрокаВстречи = Макет.ПолучитьОбласть("СтрокаВстречи");
	ОбластьШапкаПланФакт = Макет.ПолучитьОбласть("ШапкаПланФакт");
	ОбластьШапкаДокРаб = Макет.ПолучитьОбласть("ШапкаДокРаб");
	ОбластьСтрокаДокРаб = Макет.ПолучитьОбласть("СтрокаДокРаб");
	ОбластьСтрокаДокРабЖирн = Макет.ПолучитьОбласть("СтрокаДокРабЖирн");
	ОбластьШапкаПросроченных = Макет.ПолучитьОбласть("ШапкаПросроченных");
	ОбластьСтрокаПросроченных = Макет.ПолучитьОбласть("СтрокаПросроченных");
	ОбластьШапкаЗамеров = Макет.ПолучитьОбласть("ШапкаЗамеров");
	ОбластьСтрокаЗамеров = Макет.ПолучитьОбласть("СтрокаЗамеров");
	ОбластьШапкаСЗ = Макет.ПолучитьОбласть("ШапкаСЗ");
	ОбластьСтрокаСЗ = Макет.ПолучитьОбласть("СтрокаСЗ");
	
	ДанныеШапки = ПолучитьДанныеШапки(ПараметрыОтчета.Подразделение, ПараметрыОтчета.ПериодОтчета);
	ДанныеШапки.Следующий();
	ОбластьШапка.Параметры.Заполнить(ДанныеШапки);
	ОбластьШапка.Параметры.ПериодОтчета = ПредставлениеПериода(ПараметрыОтчета.ПериодОтчета.ДатаНачала, ПараметрыОтчета.ПериодОтчета.ДатаОкончания);
	ТабДок.Вывести(ОбластьШапка);
	ДанныеШапки.Сбросить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", ПараметрыОтчета.Подразделение);
	Запрос.УстановитьПараметр("Сотрудник", ПараметрыОтчета.Сотрудник);
	Запрос.УстановитьПараметр("ДатаНачала", ПараметрыОтчета.ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ПараметрыОтчета.ПериодОтчета.ДатаОкончания);
	
	# Область Запрос
	//RonEXI edit
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка КАК ФизЛицо,
	|	ФизическиеЛица.Активность КАК Работает,
	|	ФизическиеЛица.Руководитель
	|ПОМЕСТИТЬ ВТ_Сотрудники
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Подразделение = &Подразделение
	|	И ВЫБОР
	|			КОГДА &Сотрудник = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ФизическиеЛица.Ссылка = &Сотрудник
	|		КОНЕЦ
	|	И (ФизическиеЛица.Должность = ЗНАЧЕНИЕ(Справочник.Должности.СтаршийДизайнер)
	|			ИЛИ ФизическиеЛица.Должность = ЗНАЧЕНИЕ(Справочник.Должности.ДизайнерКонсультант)
	|			ИЛИ ФизическиеЛица.Должность = ЗНАЧЕНИЕ(Справочник.Должности.Супервайзер))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ_Сотрудники.ФизЛицо КАК Сотрудник,
	|	0 КАК ПланВыручка,
	|	СУММА(ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.Выручка)
	|				ТОГДА УправленческийОбороты.СуммаОборот
	|			ИНАЧЕ NULL
	|		КОНЕЦ) КАК ФактВыручка,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗамеров)
	|				ТОГДА УправленческийОбороты.Регистратор
	|			ИНАЧЕ NULL
	|		КОНЕЦ) КАК ФактЗамеров,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров)
	|				ТОГДА УправленческийОбороты.Регистратор
	|			ИНАЧЕ NULL
	|		КОНЕЦ) КАК ДоговоровЗаПериод,
	|	NULL КАК ВсегоЗамеров,
	|	NULL КАК ВсегоЭффЗамеры,
	|	NULL КАК Дата,
	|	NULL КАК АдресЗамера,
	|	NULL КАК Замерщик,
	|	NULL КАК Замер,
	|	NULL КАК Автор,
	|	NULL КАК ЕстьЗаметка,
	|	ВТ_Сотрудники.Работает,
	|	ВТ_Сотрудники.Руководитель
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	ВТ_Сотрудники КАК ВТ_Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Обороты(
	|				&ДатаНачала,
	|				&ДатаОкончания,
	|				Регистратор,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|				,
	|				(ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.Выручка)
	|					ИЛИ (ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗамеров)
	|					ИЛИ (ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров),
	|				,
	|				) КАК УправленческийОбороты
	|		ПО (ВТ_Сотрудники.ФизЛицо = (ВЫРАЗИТЬ(УправленческийОбороты.Субконто2 КАК Справочник.ФизическиеЛица)))
	|ГДЕ
	|	ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗамеров)
	|				ТОГДА ВЫРАЗИТЬ(УправленческийОбороты.Регистратор КАК Документ.Замер).ПервыйЗамер = ЗНАЧЕНИЕ(Документ.Замер.ПустаяСсылка)
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Сотрудники.ФизЛицо,
	|	ВТ_Сотрудники.Работает,
	|	ВТ_Сотрудники.Руководитель
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_Сотрудники.ФизЛицо,
	|	0,
	|	0,
	|	NULL,
	|	NULL,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.ВстречаСКлиентом)
	|				ТОГДА УправленческийОбороты.Регистратор
	|			ИНАЧЕ NULL
	|		КОНЕЦ),
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Договор.Ссылка),
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_Сотрудники.Работает,
	|	ВТ_Сотрудники.Руководитель
	|ИЗ
	|	ВТ_Сотрудники КАК ВТ_Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Обороты(, , Регистратор, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника), , (ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.ВстречаСКлиентом), , ) КАК УправленческийОбороты
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК Договор
	|			ПО ((ВЫРАЗИТЬ(ВЫРАЗИТЬ(УправленческийОбороты.Регистратор КАК Документ.ВстречаСКлиентом).Основание КАК Документ.Замер)) = (ВЫРАЗИТЬ(Договор.Спецификация.ДокументОснование.Ссылка КАК Документ.Замер)))
	|				И (Договор.Проведен)
	|		ПО (ВТ_Сотрудники.ФизЛицо = (ВЫРАЗИТЬ(УправленческийОбороты.Субконто2 КАК Справочник.ФизическиеЛица)))
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Сотрудники.ФизЛицо,
	|	ВТ_Сотрудники.Работает,
	|	ВТ_Сотрудники.Руководитель
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_Сотрудники.ФизЛицо,
	|	0,
	|	0,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	МАКСИМУМ(ВстречаСКлиентом.Дата),
	|	ВстречаСКлиентом.Основание.АдресЗамера,
	|	ВстречаСКлиентом.Основание.Замерщик,
	|	ВстречаСКлиентом.Основание,
	|	ВстречаСКлиентом.Основание.Автор,
	|	ВЫБОР
	|		КОГДА НаличиеЗаметокПоПредмету.ЕстьЗаметка ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ НаличиеЗаметокПоПредмету.ЕстьЗаметка
	|	КОНЕЦ,
	|	ВТ_Сотрудники.Работает,
	|	ВТ_Сотрудники.Руководитель
	|ИЗ
	|	ВТ_Сотрудники КАК ВТ_Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВстречаСКлиентом КАК ВстречаСКлиентом
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АктивностьЗамеров КАК АктивностьЗамеров
	|			ПО ВстречаСКлиентом.Основание = АктивностьЗамеров.Замер
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеЗаметокПоПредмету КАК НаличиеЗаметокПоПредмету
	|			ПО (ВстречаСКлиентом.Основание = ВЫРАЗИТЬ(НаличиеЗаметокПоПредмету.Предмет КАК Документ.Замер).Ссылка)
	|		ПО ВТ_Сотрудники.ФизЛицо = ВстречаСКлиентом.Ответственный
	|ГДЕ
	|	НЕ ВстречаСКлиентом.ПометкаУдаления
	|	И АктивностьЗамеров.Статус
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Сотрудники.ФизЛицо,
	|	ВТ_Сотрудники.Работает,
	|	ВстречаСКлиентом.Основание,
	|	ВстречаСКлиентом.Основание.Автор,
	|	ВстречаСКлиентом.Основание.АдресЗамера,
	|	ВстречаСКлиентом.Основание.Замерщик,
	|	ВЫБОР
	|		КОГДА НаличиеЗаметокПоПредмету.ЕстьЗаметка ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ НаличиеЗаметокПоПредмету.ЕстьЗаметка
	|	КОНЕЦ,
	|	ВТ_Сотрудники.Руководитель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ.Сотрудник КАК Сотрудник,
	|	ВТ.ПланВыручка КАК ПланВыручка,
	|	ВТ.ФактВыручка КАК ФактВыручка,
	|	ВТ.ФактЗамеров КАК ФактЗамеров,
	|	ВТ.ДоговоровЗаПериод КАК ДоговоровЗаПериод,
	|	ВТ.ВсегоЗамеров КАК ВсегоЗамеров,
	|	ВТ.ВсегоЭффЗамеры КАК ВсегоЭффЗамеры,
	|	ВТ.Дата КАК Дата,
	|	ВТ.АдресЗамера КАК Адрес,
	|	ВТ.Замерщик КАК Замерщик,
	|	ВТ.Автор КАК Автор,
	|	NULL КАК ДоговорВРаботе,
	|	NULL КАК Контрагент,
	|	NULL КАК АдресМонтажа,
	|	NULL КАК ДатаМонтажа,
	|	ВТ.Сотрудник.Фамилия КАК Фамилия,
	|	ВТ.Замер,
	|	ВТ.Сотрудник.ТелефонРабочий КАК ТелефонРабочий,
	|	ВТ.ЕстьЗаметка,
	|	ВТ.Работает КАК Работает,
	|	NULL КАК Служебка,
	|	NULL КАК ВидСЗ,
	|	NULL КАК ТекстСЗ,
	|	NULL КАК ДатаСЗ,
	|	ВТ.Руководитель КАК Руководитель
	|ИЗ
	|	ВТ КАК ВТ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_Сотрудники.ФизЛицо,
	|	0,
	|	0,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров)
	|			ТОГДА УправленческийОбороты.Регистратор
	|		ИНАЧЕ NULL
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров)
	|			ТОГДА УправленческийОбороты.Регистратор.Контрагент
	|		ИНАЧЕ NULL
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров)
	|			ТОГДА УправленческийОбороты.Регистратор.Спецификация.АдресМонтажа
	|		ИНАЧЕ NULL
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров)
	|			ТОГДА Спецификация.ДатаМонтажа
	|		ИНАЧЕ NULL
	|	КОНЕЦ,
	|	ВЫРАЗИТЬ(УправленческийОбороты.Субконто2 КАК Справочник.ФизическиеЛица).Фамилия,
	|	NULL,
	|	ВЫРАЗИТЬ(УправленческийОбороты.Субконто2 КАК Справочник.ФизическиеЛица).ТелефонРабочий,
	|	NULL,
	|	ВТ_Сотрудники.Работает,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_Сотрудники.Руководитель
	|ИЗ
	|	ВТ_Сотрудники КАК ВТ_Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Обороты(, , Регистратор, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника), , (ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров), , ) КАК УправленческийОбороты
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктВыполненияДоговора КАК АктВыполненияДоговора
	|			ПО УправленческийОбороты.Регистратор = АктВыполненияДоговора.Договор
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация КАК Спецификация
	|			ПО УправленческийОбороты.Регистратор.Спецификация = Спецификация.Ссылка
	|		ПО (ВТ_Сотрудники.ФизЛицо = (ВЫРАЗИТЬ(УправленческийОбороты.Субконто2 КАК Справочник.ФизическиеЛица)))
	|ГДЕ
	|	АктВыполненияДоговора.Ссылка ЕСТЬ NULL
	|	И ВЫРАЗИТЬ(УправленческийОбороты.Регистратор КАК Документ.Договор).Спецификация.ПакетУслуг <> ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.СамовывозОтПроизводителя)
	|	И ВЫБОР
	|			КОГДА НЕ ВТ_Сотрудники.Работает
	|					И УправленческийОбороты.Подразделение <> &Подразделение
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	"""",
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	АктивностьЗамеров.Замер.ДатаЗамера,
	|	АктивностьЗамеров.Замер.АдресЗамера,
	|	АктивностьЗамеров.Замер.Замерщик,
	|	АктивностьЗамеров.Замер.Автор,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	АктивностьЗамеров.Замер,
	|	NULL,
	|	ВЫБОР
	|		КОГДА НаличиеЗаметокПоПредмету.ЕстьЗаметка ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ НаличиеЗаметокПоПредмету.ЕстьЗаметка
	|	КОНЕЦ,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	""""
	|ИЗ
	|	РегистрСведений.АктивностьЗамеров КАК АктивностьЗамеров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВстречаСКлиентом КАК ВстречаСКлиентом
	|		ПО АктивностьЗамеров.Замер = ВстречаСКлиентом.Основание
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеЗаметокПоПредмету КАК НаличиеЗаметокПоПредмету
	|		ПО (АктивностьЗамеров.Замер = ВЫРАЗИТЬ(НаличиеЗаметокПоПредмету.Предмет КАК Документ.Замер).Ссылка)
	|ГДЕ
	|	АктивностьЗамеров.Статус
	|	И ВстречаСКлиентом.Основание ЕСТЬ NULL
	|	И АктивностьЗамеров.Замер.Подразделение = &Подразделение
	|	И НЕ АктивностьЗамеров.Замер.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_Сотрудники.ФизЛицо,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_Сотрудники.ФизЛицо.Фамилия,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_Сотрудники.Работает,
	|	СлужебнаяЗаписка.Ссылка,
	|	СлужебнаяЗаписка.ВидСлужебнойЗаписки,
	|	СлужебнаяЗаписка.Проблема,
	|	СлужебнаяЗаписка.Дата,
	|	ВТ_Сотрудники.Руководитель
	|ИЗ
	|	ВТ_Сотрудники КАК ВТ_Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СлужебнаяЗаписка КАК СлужебнаяЗаписка
	|		ПО ВТ_Сотрудники.ФизЛицо = СлужебнаяЗаписка.Адресат.ФизическоеЛицо
	|ГДЕ
	|	НЕ СлужебнаяЗаписка.ПометкаУдаления
	|	И (СлужебнаяЗаписка.ВидСлужебнойЗаписки = ЗНАЧЕНИЕ(Перечисление.ВидыСлужебнойЗаписки.НарушенияВРаботе)
	|			ИЛИ СлужебнаяЗаписка.ВидСлужебнойЗаписки = ЗНАЧЕНИЕ(Перечисление.ВидыСлужебнойЗаписки.Удержание))
	|	И СлужебнаяЗаписка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|УПОРЯДОЧИТЬ ПО
	|	Руководитель,
	|	Фамилия,
	|	Дата,
	|	ДатаМонтажа,
	|	ДоговорВРаботе
	|ИТОГИ
	|	СУММА(ПланВыручка),
	|	СУММА(ФактВыручка),
	|	СУММА(ФактЗамеров),
	|	СУММА(ДоговоровЗаПериод),
	|	СУММА(ВсегоЗамеров),
	|	СУММА(ВсегоЭффЗамеры),
	|	КОЛИЧЕСТВО(Дата),
	|	КОЛИЧЕСТВО(ДоговорВРаботе),
	|	МАКСИМУМ(Работает),
	|	КОЛИЧЕСТВО(Служебка)
	|ПО
	|	Руководитель,
	|	Сотрудник";
	
	#КонецОбласти
	
	ВыборкаРуководитель =Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Руководитель"); 	
	Пока ВыборкаРуководитель.Следующий() Цикл
		Если ЗначениеЗаполнено(ВыборкаРуководитель.Руководитель) Тогда
			ОбластьСтрокаРуководитель.Параметры.Заполнить(ВыборкаРуководитель);
			ТабДок.Вывести(ОбластьСтрокаРуководитель);
			ТабДок.НачатьГруппуСтрок();
		КонецЕсли;
		
		Выборка = ВыборкаРуководитель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока Выборка.Следующий() Цикл
			
			СтрокиПросроченных = ТЗПросроченные.НайтиСтроки(Новый Структура("Автор", Выборка.Сотрудник));
			ВыводСотрудника = Ложь;
			Если ЗначениеЗаполнено(Выборка.Сотрудник) Тогда
				ВыводСотрудника = Выборка.Работает ИЛИ ЗначениеЗаполнено(Выборка.ПланВыручка) ИЛИ ЗначениеЗаполнено(Выборка.ФактВыручка) 
				ИЛИ ЗначениеЗаполнено(Выборка.ФактЗамеров) ИЛИ ЗначениеЗаполнено(Выборка.ДоговоровЗаПериод) ИЛИ ЗначениеЗаполнено(Выборка.ВсегоЗамеров) 
				ИЛИ ЗначениеЗаполнено(Выборка.ВсегоЭффЗамеры) ИЛИ ЗначениеЗаполнено(Выборка.Дата) ИЛИ ЗначениеЗаполнено(Выборка.Служебка)
				ИЛИ ЗначениеЗаполнено(Выборка.ДоговорВРаботе);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Выборка.Сотрудник) И ВыводСотрудника Тогда
				
				ТабДокВРаботе.Очистить();
				ТабДокСЗ.Очистить();
				
				ОбластьСтрокаСотрудник.Параметры.Заполнить(Выборка);
				ТабДок.Вывести(ОбластьСтрокаСотрудник);
				ОбластьШапкаПланФакт.Параметры.Заполнить(Выборка);
				ОбластьШапкаПланФакт.Параметры.ВыполнениеПлана = ?(Выборка.ПланВыручка = 0, 0, Выборка.ФактВыручка / Выборка.ПланВыручка * 100);
				ОбластьШапкаПланФакт.Параметры.ВсегоЭффективность = ?(ЗначениеЗаполнено(Выборка.ВсегоЗамеров), Выборка.ВсегоЭффЗамеры / Выборка.ВсегоЗамеров * 100, 0);
				ОбластьШапкаПланФакт.Параметры.Эффективность = ?(ЗначениеЗаполнено(Выборка.ФактЗамеров), Выборка.ДоговоровЗаПериод / Выборка.ФактЗамеров * 100, 0);
				ТабДок.Вывести(ОбластьШапкаПланФакт);
				
				Если ЗначениеЗаполнено(Выборка.Дата) ИЛИ ЗначениеЗаполнено(Выборка.ДоговорВРаботе) Тогда
					
					Если ЗначениеЗаполнено(Выборка.Дата) Тогда
						ТабДок.Вывести(ОбластьШапкаВстречи);
					КонецЕсли;
					
					Если ЗначениеЗаполнено(Выборка.ДоговорВРаботе) Тогда
						ТабДокВРаботе.Вывести(ОбластьШапкаДокРаб);
					КонецЕсли;
					
					Если ЗначениеЗаполнено(Выборка.Служебка) Тогда
						ТабДокСЗ.Вывести(ОбластьШапкаСЗ);
					КонецЕсли;
					
					ВыборкаВстречиДоговора = Выборка.Выбрать();
					Пока ВыборкаВстречиДоговора.Следующий() Цикл
						Если ЗначениеЗаполнено(ВыборкаВстречиДоговора.Дата) Тогда
							
							ОбластьСтрокаВстречи.Параметры.Заполнить(ВыборкаВстречиДоговора);
							ОбластьСтрокаВстречи.Параметры.Расшифровка = ВыборкаВстречиДоговора.Замер;
							
							Если ВыборкаВстречиДоговора.ЕстьЗаметка Тогда
								ОбластьСтрокаВстречи.Параметры.РасшифровкаЗаметка = Новый Структура("ЕстьЗаметка, Предмет", ВыборкаВстречиДоговора.ЕстьЗаметка, ВыборкаВстречиДоговора.Замер);
							Иначе
								ОбластьСтрокаВстречи.Параметры.РасшифровкаЗаметка = Неопределено;
							КонецЕсли;
							
							ТабДок.Вывести(ОбластьСтрокаВстречи);
							
						ИначеЕсли ЗначениеЗаполнено(ВыборкаВстречиДоговора.ДоговорВРаботе) Тогда
							
							Если ТипЗнч(ВыборкаВстречиДоговора.ДатаМонтажа) = Тип("Дата") И ВыборкаВстречиДоговора.ДатаМонтажа < ТекущаяДата() Тогда
								Обл = ОбластьСтрокаДокРабЖирн;
							Иначе
								Обл = ОбластьСтрокаДокРаб;
							КонецЕсли;
							
							Обл.Параметры.Заполнить(ВыборкаВстречиДоговора);
							Обл.Параметры.Расшифровка = ВыборкаВстречиДоговора.ДоговорВРаботе;
							ТабДокВРаботе.Вывести(Обл);
							
						ИначеЕсли ЗначениеЗаполнено(ВыборкаВстречиДоговора.Служебка) Тогда
							ОбластьСтрокаСЗ.Параметры.Заполнить(ВыборкаВстречиДоговора);
							ОбластьСтрокаСЗ.Параметры.Расшифровка = ВыборкаВстречиДоговора.Служебка;
							ТабДокСЗ.Вывести(ОбластьСтрокаСЗ);
						КонецЕсли;
					КонецЦикла;
					ТабДок.Вывести(ТабДокВРаботе);
					ТабДок.Вывести(ТабДокСЗ);
				КонецЕсли;
				
				Если СтрокиПросроченных.Количество() > 0 Тогда
					ТабДок.Вывести(ОбластьШапкаПросроченных);
					Для Каждого Элемент Из СтрокиПросроченных Цикл
						ОбластьСтрокаПросроченных.Параметры.Заполнить(Элемент);
						ОбластьСтрокаПросроченных.Параметры.Расшифровка = Элемент.Договор;
						ТабДок.Вывести(ОбластьСтрокаПросроченных);
					КонецЦикла;
				КонецЕсли;
			ИначеЕсли НЕ ЗначениеЗаполнено(Выборка.Сотрудник) Тогда
				Если Выборка.Дата > 0 Тогда
					ТабДок.Вывести(ОбластьШапкаЗамеров);
					ВыборкаЗамеры = Выборка.Выбрать();
					Пока ВыборкаЗамеры.Следующий() Цикл
						Если ЗначениеЗаполнено(ВыборкаЗамеры.Дата) Тогда
							ОбластьСтрокаЗамеров.Параметры.Заполнить(ВыборкаЗамеры);
							ОбластьСтрокаЗамеров.Параметры.Расшифровка = ВыборкаЗамеры.Замер;
							
							Если ВыборкаЗамеры.ЕстьЗаметка Тогда
								ОбластьСтрокаЗамеров.Параметры.РасшифровкаЗаметка = Новый Структура("ЕстьЗаметка, Предмет", ВыборкаЗамеры.ЕстьЗаметка, ВыборкаЗамеры.Замер);
							Иначе
								ОбластьСтрокаЗамеров.Параметры.РасшифровкаЗаметка = Неопределено;
							КонецЕсли;
							
							ТабДок.Вывести(ОбластьСтрокаЗамеров);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла; // Пока Выборка.Следующий() Цикл	
		
		Если ЗначениеЗаполнено(ВыборкаРуководитель.Руководитель) Тогда	
			ТабДок.ЗакончитьГруппуСтрок();		
		КонецЕсли;
		
		
	КонецЦикла; // Пока ВыборкаРуководитель.Следующий() Цикл
	
	
	Возврат ТабДок;
	
КонецФункции

Функция ПолучитьТЗ(Дата, Подразделение, Сотрудник) 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяДата", КонецДня(Дата));
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УправленческийОстатки.Субконто2 КАК Договор
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			&ТекущаяДата,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ВзаиморасчетыСПокупателями),
	|			,
	|			Субконто2 ССЫЛКА Документ.Договор
	|				И (ВЫРАЗИТЬ(Субконто2 КАК Документ.Договор)) <> ЗНАЧЕНИЕ(Документ.Договор.ПустаяСсылка) 
	|				И ВЫБОР
	|					КОГДА &Сотрудник = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|						ТОГДА Субконто2.Подразделение = &Подразделение
	|					ИНАЧЕ Субконто2.Автор.ФизическоеЛицо = &Сотрудник
	|				КОНЕЦ) КАК УправленческийОстатки";
	
	Выборка = Запрос.Выполнить().Выгрузить();
	ТЗ = Документы.Договор.РасчетПени(Выборка.ВыгрузитьКолонку("Договор"), КонецДня(Дата));
	
	Возврат ТЗ;
	
КонецФункции

Функция ПолучитьДанныеШапки(Подразделение, Период)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров)
	|				ТОГДА УправленческийОбороты.Регистратор
	|			ИНАЧЕ NULL
	|		КОНЕЦ) КАК ДоговоровЗаПериод,
	|	СУММА(ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗамеров)
	|					И УправленческийОбороты.Регистратор.ПричинаОтказа <> ЗНАЧЕНИЕ(Справочник.ЗамерПричиныОтказа.ПустаяСсылка)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Отказы,
	|	NULL КАК Замер,
	|	СУММА(ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗамеров)
	|					И УправленческийОбороты.Регистратор.ПервыйЗамер = ЗНАЧЕНИЕ(Документ.Замер.ПустаяСсылка)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ЗамеровЗаПериод
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&ДатаНачала,
	|			&ДатаОкончания,
	|			Регистратор,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|			,
	|			(ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров)
	|				ИЛИ (ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗамеров),
	|			,
	|			) КАК УправленческийОбороты
	|ГДЕ
	|	(ВЫРАЗИТЬ(УправленческийОбороты.Регистратор КАК Документ.Договор).Подразделение = &Подразделение
	|			ИЛИ ВЫРАЗИТЬ(УправленческийОбороты.Регистратор КАК Документ.Замер).Подразделение = &Подразделение)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	NULL,
	|	NULL,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ АктивностьЗамеров.Замер),
	|	NULL
	|ИЗ
	|	РегистрСведений.АктивностьЗамеров КАК АктивностьЗамеров
	|ГДЕ
	|	АктивностьЗамеров.Статус
	|	И АктивностьЗамеров.Замер.Подразделение = &Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВТ.ДоговоровЗаПериод) КАК ДоговоровЗаПериод,
	|	СУММА(ВТ.Отказы) КАК Отказы,
	|	СУММА(ВТ.Замер) КАК ЗамерыВРаботе,
	|	&Подразделение,
	|	СУММА(ВТ.ЗамеровЗаПериод) КАК ЗамеровЗаПериод
	|ИЗ
	|	ВТ КАК ВТ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка;
	
КонецФункции
