﻿
Функция СформироватьОтчет(ПараметрыОтчета) Экспорт
	
	ТабДокВРаботе = Новый ТабличныйДокумент;
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.АвтоМасштаб = Истина;
	ТЗПросроченные = ПолучитьТЗ(ПараметрыОтчета.ПериодОтчета.ДатаНачала, ПараметрыОтчета.Подразделение, ПараметрыОтчета.Сотрудник);
	
	Макет = Отчеты.ОтчетСупервайзера.ПолучитьМакет("Макет");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрокаСотрудник = Макет.ПолучитьОбласть("СтрокаСотрудник");
	ОбластьШапкаВстречи = Макет.ПолучитьОбласть("ШапкаВстречи");
	ОбластьСтрокаВстречи = Макет.ПолучитьОбласть("СтрокаВстречи");
	ОбластьШапкаПланФакт = Макет.ПолучитьОбласть("ШапкаПланФакт");
	ОбластьШапкаДокРаб = Макет.ПолучитьОбласть("ШапкаДокРаб");
	ОбластьСтрокаДокРаб = Макет.ПолучитьОбласть("СтрокаДокРаб");
	ОбластьШапкаПросроченных = Макет.ПолучитьОбласть("ШапкаПросроченных");
	ОбластьСтрокаПросроченных = Макет.ПолучитьОбласть("СтрокаПросроченных");
	ОбластьШапкаЗамеров = Макет.ПолучитьОбласть("ШапкаЗамеров");
	ОбластьСтрокаЗамеров = Макет.ПолучитьОбласть("СтрокаЗамеров");
	
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
	Запрос.Текст =	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫРАЗИТЬ(УправленческийОбороты.Субконто2 КАК Справочник.ФизическиеЛица) КАК Сотрудник,
	|	0 КАК ПланВыручка,
	|	СУММА(ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.ВыручкаПоДоговорам)
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
	|	NULL КАК Агент
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&ДатаНачала,
	|			&ДатаОкончания,
	|			Регистратор,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|			,
	|			((ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.ВыручкаПоДоговорам)
	|				ИЛИ (ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗамеров)
	|				ИЛИ (ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров))
	|				И ВЫБОР
	|					КОГДА &Сотрудник = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|						ТОГДА ВЫРАЗИТЬ(Субконто2 КАК Справочник.ФизическиеЛица).Подразделение = &Подразделение
	|					ИНАЧЕ (ВЫРАЗИТЬ(Субконто2 КАК Справочник.ФизическиеЛица)) = &Сотрудник
	|				КОНЕЦ,
	|			,
	|			) КАК УправленческийОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫРАЗИТЬ(УправленческийОбороты.Субконто2 КАК Справочник.ФизическиеЛица)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПлановыеПоказателиДизайнеровОбороты.Дизайнер,
	|	СУММА(ПлановыеПоказателиДизайнеровОбороты.ЗначениеОборот),
	|	0,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL
	|ИЗ
	|	РегистрНакопления.ПлановыеПоказателиДизайнеров.Обороты(
	|			&ДатаНачала,
	|			&ДатаОкончания,
	|			Регистратор,
	|			Показатель = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.ВыручкаПоДоговорам)
	|				И ВЫБОР
	|					КОГДА &Сотрудник = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|						ТОГДА Дизайнер.Подразделение = &Подразделение
	|					ИНАЧЕ Дизайнер = &Сотрудник
	|				КОНЕЦ) КАК ПлановыеПоказателиДизайнеровОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ПлановыеПоказателиДизайнеровОбороты.Дизайнер
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(УправленческийОбороты.Субконто2 КАК Справочник.ФизическиеЛица),
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
	|	NULL
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			,
	|			,
	|			Регистратор,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|			,
	|			(ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.ВстречаСКлиентом)
	|				И ВЫБОР
	|					КОГДА &Сотрудник = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|						ТОГДА ВЫРАЗИТЬ(Субконто2 КАК Справочник.ФизическиеЛица).Подразделение = &Подразделение
	|					ИНАЧЕ (ВЫРАЗИТЬ(Субконто2 КАК Справочник.ФизическиеЛица)) = &Сотрудник
	|				КОНЕЦ,
	|			,
	|			) КАК УправленческийОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК Договор
	|		ПО ((ВЫРАЗИТЬ(ВЫРАЗИТЬ(УправленческийОбороты.Регистратор КАК Документ.ВстречаСКлиентом).Основание КАК Документ.Замер)) = (ВЫРАЗИТЬ(Договор.Спецификация.ДокументОснование.Ссылка КАК Документ.Замер)))
	|			И (Договор.Проведен)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫРАЗИТЬ(УправленческийОбороты.Субконто2 КАК Справочник.ФизическиеЛица)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВстречаСКлиентом.Ответственный,
	|	0,
	|	0,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	МАКСИМУМ(ВстречаСКлиентом.Дата),
	|	МАКСИМУМ(ВстречаСКлиентом.Основание.АдресЗамера),
	|	МАКСИМУМ(ВстречаСКлиентом.Основание.Замерщик),
	|	ВстречаСКлиентом.Основание,
	|	МАКСИМУМ(ВстречаСКлиентом.Основание.Агент)
	|ИЗ
	|	Документ.ВстречаСКлиентом КАК ВстречаСКлиентом
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АктивностьЗамеров КАК АктивностьЗамеров
	|		ПО ВстречаСКлиентом.Основание = АктивностьЗамеров.Замер
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &Сотрудник = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|				ТОГДА ВстречаСКлиентом.Ответственный.Подразделение = &Подразделение
	|			ИНАЧЕ ВстречаСКлиентом.Ответственный = &Сотрудник
	|		КОНЕЦ
	|	И НЕ ВстречаСКлиентом.ПометкаУдаления
	|	И АктивностьЗамеров.Статус
	|
	|СГРУППИРОВАТЬ ПО
	|	ВстречаСКлиентом.Ответственный,
	|	ВстречаСКлиентом.Основание
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
	|	ВТ.Агент КАК Агент,
	|	NULL КАК ДоговорВРаботе,
	|	NULL КАК Контрагент,
	|	NULL КАК АдресМонтажа,
	|	NULL КАК ДатаМонтажа,
	|	ВТ.Сотрудник.Фамилия КАК Фамилия,
	|	ВТ.Замер
	|ИЗ
	|	ВТ КАК ВТ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(УправленческийОбороты.Субконто2 КАК Справочник.ФизическиеЛица),
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
	|			ТОГДА УправленческийОбороты.Регистратор.Спецификация.ДатаМонтажа
	|		ИНАЧЕ NULL
	|	КОНЕЦ,
	|	УправленческийОбороты.Субконто2.Фамилия,
	|	NULL
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			,
	|			,
	|			Регистратор,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|			,
	|			(ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров)
	|				И ВЫБОР
	|					КОГДА &Сотрудник = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|						ТОГДА ВЫРАЗИТЬ(Субконто2 КАК Справочник.ФизическиеЛица).Подразделение = &Подразделение
	|					ИНАЧЕ (ВЫРАЗИТЬ(Субконто2 КАК Справочник.ФизическиеЛица)) = &Сотрудник
	|				КОНЕЦ,
	|			,
	|			) КАК УправленческийОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктВыполненияДоговора КАК АктВыполненияДоговора
	|		ПО УправленческийОбороты.Регистратор = АктВыполненияДоговора.Договор
	|ГДЕ
	|	АктВыполненияДоговора.Ссылка ЕСТЬ NULL 
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
	|	АктивностьЗамеров.Замер.Дата,
	|	АктивностьЗамеров.Замер.АдресЗамера,
	|	АктивностьЗамеров.Замер.Замерщик,
	|	АктивностьЗамеров.Замер.Агент,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL
	|ИЗ
	|	РегистрСведений.АктивностьЗамеров КАК АктивностьЗамеров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВстречаСКлиентом КАК ВстречаСКлиентом
	|		ПО АктивностьЗамеров.Замер = ВстречаСКлиентом.Основание
	|ГДЕ
	|	АктивностьЗамеров.Статус
	|	И ВстречаСКлиентом.Основание ЕСТЬ NULL 
	|	И АктивностьЗамеров.Замер.Подразделение = &Подразделение
	|	И НЕ АктивностьЗамеров.Замер.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Фамилия,
	|	Дата,
	|	ДоговорВРаботе
	|ИТОГИ
	|	СУММА(ПланВыручка),
	|	СУММА(ФактВыручка),
	|	СУММА(ФактЗамеров),
	|	СУММА(ДоговоровЗаПериод),
	|	СУММА(ВсегоЗамеров),
	|	СУММА(ВсегоЭффЗамеры),
	|	КОЛИЧЕСТВО(Дата),
	|	КОЛИЧЕСТВО(ДоговорВРаботе)
	|ПО
	|	Сотрудник";
	
	#КонецОбласти
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.Сотрудник) Тогда
			ТабДокВРаботе.Очистить();
			
			ОбластьСтрокаСотрудник.Параметры.Сотрудник = Выборка.Сотрудник;
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
				
				ВыборкаВстречиДоговора = Выборка.Выбрать();
				Пока ВыборкаВстречиДоговора.Следующий() Цикл
					Если ЗначениеЗаполнено(ВыборкаВстречиДоговора.Дата) Тогда
						ОбластьСтрокаВстречи.Параметры.Заполнить(ВыборкаВстречиДоговора);
						ТабДок.Вывести(ОбластьСтрокаВстречи);
					ИначеЕсли ЗначениеЗаполнено(ВыборкаВстречиДоговора.ДоговорВРаботе) Тогда
						ОбластьСтрокаДокРаб.Параметры.Заполнить(ВыборкаВстречиДоговора);
						ТабДокВРаботе.Вывести(ОбластьСтрокаДокРаб);
					КонецЕсли;	                                          
				КонецЦикла;
				ТабДок.Вывести(ТабДокВРаботе);
			КонецЕсли;
			
			СтрокиПросроченных = ТЗПросроченные.НайтиСтроки(Новый Структура("Автор", Выборка.Сотрудник));
			Если СтрокиПросроченных.Количество() > 0 Тогда
				ТабДок.Вывести(ОбластьШапкаПросроченных);
				Для Каждого Элемент Из СтрокиПросроченных Цикл
					ОбластьСтрокаПросроченных.Параметры.Заполнить(Элемент);
					ТабДок.Вывести(ОбластьСтрокаПросроченных);
				КонецЦикла;	
			КонецЕсли;
		Иначе
			Если Выборка.Дата > 0 Тогда
				ТабДок.Вывести(ОбластьШапкаЗамеров);
				ВыборкаЗамеры = Выборка.Выбрать();
				Пока ВыборкаЗамеры.Следующий() Цикл
					Если ЗначениеЗаполнено(ВыборкаЗамеры.Дата) Тогда
						ОбластьСтрокаЗамеров.Параметры.Заполнить(ВыборкаЗамеры);
						ТабДок.Вывести(ОбластьСтрокаЗамеров);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
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
	|					И УправленческийОбороты.Регистратор.ПричинаОтказа > """"
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Отказы,
	|	NULL КАК Замер
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
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ АктивностьЗамеров.Замер)
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
	|	&Подразделение
	|ИЗ
	|	ВТ КАК ВТ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка;
	
КонецФункции