﻿
Функция СформироватьОтчет(ПараметрыОтчета) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.АвтоМасштаб = Истина;
	
	Макет = Отчеты.ОтчетСупервайзера.ПолучитьМакет("Макет");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрокаСотрудник = Макет.ПолучитьОбласть("СтрокаСотрудник");
	ОбластьШапкаВстречи = Макет.ПолучитьОбласть("ШапкаВстречи");
	ОбластьСтрокаВстречи = Макет.ПолучитьОбласть("СтрокаВстречи");
	ОбластьШапкаПланФакт = Макет.ПолучитьОбласть("ШапкаПланФакт");
	ОбластьСтрокаПланФакт = Макет.ПолучитьОбласть("СтрокаПланФакт");
	ОбластьШапкаДокРаб = Макет.ПолучитьОбласть("ШапкаДокРаб");
	ОбластьСтрокаДокРаб = Макет.ПолучитьОбласть("СтрокаДокРаб");
	
	ОбластьШапка.Параметры.Подразделение = ПараметрыОтчета.Подразделение;
	ОбластьШапка.Параметры.ПериодОтчета = ПредставлениеПериода(ПараметрыОтчета.ПериодОтчета.ДатаНачала, ПараметрыОтчета.ПериодОтчета.ДатаОкончания);
	ТабДок.Вывести(ОбластьШапка);
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", ПараметрыОтчета.Подразделение);
	Запрос.УстановитьПараметр("Сотрудник", ПараметрыОтчета.Сотрудник);
	Запрос.УстановитьПараметр("ДатаНачала", ПараметрыОтчета.ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ПараметрыОтчета.ПериодОтчета.ДатаОкончания);
	
	# Область Запрос
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УправленческийОбороты.Субконто2 КАК Сотрудник,
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
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДокДоговор.Ссылка) КАК ЭффЗамеры
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&ДатаНачала,
	|			&ДатаОкончания,
	|			Регистратор,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|			,
	|			(ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.ВыручкаПоДоговорам)
	|				ИЛИ (ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗамеров),
	|			,
	|			) КАК УправленческийОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация КАК ДокСпецификация
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК ДокДоговор
	|			ПО ДокСпецификация.Ссылка = ДокДоговор.Спецификация
	|		ПО УправленческийОбороты.Регистратор = ДокСпецификация.ДокументОснование
	|ГДЕ
	|	УправленческийОбороты.Субконто2.Подразделение = &Подразделение
	|
	|СГРУППИРОВАТЬ ПО
	|	УправленческийОбороты.Субконто2
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПлановыеПоказателиДизайнеровОбороты.Дизайнер,
	|	СУММА(ПлановыеПоказателиДизайнеровОбороты.ЗначениеОборот),
	|	0,
	|	NULL,
	|	NULL
	|ИЗ
	|	РегистрНакопления.ПлановыеПоказателиДизайнеров.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор, Показатель = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.ВыручкаПоДоговорам)) КАК ПлановыеПоказателиДизайнеровОбороты
	|ГДЕ
	|	ПлановыеПоказателиДизайнеровОбороты.Дизайнер.Подразделение = &Подразделение
	|
	|СГРУППИРОВАТЬ ПО
	|	ПлановыеПоказателиДизайнеровОбороты.Дизайнер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ.Сотрудник КАК Сотрудник,
	|	ВТ.ПланВыручка КАК ПланВыручка,
	|	ВТ.ФактВыручка КАК ФактВыручка,
	|	ВТ.ФактЗамеров КАК ФактЗамеров,
	|	ВТ.ЭффЗамеры КАК ЭффЗамеры,
	|	NULL КАК Дата,
	|	NULL КАК Адрес,
	|	NULL КАК Замерщик,
	|	NULL КАК Агент,
	|	NULL КАК ДоговорВРаботе
	|ИЗ
	|	ВТ КАК ВТ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВстречаСКлиентом.Ответственный,
	|	0,
	|	0,
	|	NULL,
	|	NULL,
	|	ВстречаСКлиентом.Дата,
	|	ВстречаСКлиентом.Основание.АдресЗамера,
	|	ВстречаСКлиентом.Основание.Замерщик,
	|	ВстречаСКлиентом.Основание.Агент,
	|	NULL
	|ИЗ
	|	Документ.ВстречаСКлиентом КАК ВстречаСКлиентом
	|ГДЕ
	|	ВстречаСКлиентом.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ВстречаСКлиентом.Ответственный.Подразделение = &Подразделение
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	УправленческийОбороты.Субконто2,
	|	0,
	|	0,
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
	|	КОНЕЦ
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(, , Регистратор, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника), , (ВЫРАЗИТЬ(Субконто1 КАК Перечисление.ВидыПоказателейСотрудников)) = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.КоличествоЗаключенныхДоговоров), , ) КАК УправленческийОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктВыполненияДоговора КАК АктВыполненияДоговора
	|		ПО УправленческийОбороты.Регистратор = АктВыполненияДоговора.Договор
	|ГДЕ
	|	УправленческийОбороты.Субконто2.Подразделение = &Подразделение
	|	И АктВыполненияДоговора.Ссылка ЕСТЬ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник,
	|	Дата,
	|	ДоговорВРаботе
	|ИТОГИ
	|	СУММА(ПланВыручка),
	|	СУММА(ФактВыручка),
	|	СУММА(ФактЗамеров),
	|	СУММА(ЭффЗамеры),
	|	КОЛИЧЕСТВО(Дата),
	|	КОЛИЧЕСТВО(ДоговорВРаботе)
	|ПО
	|	Сотрудник";
	
	#КонецОбласти
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		ОбластьСтрокаСотрудник.Параметры.Сотрудник = Выборка.Сотрудник;
		ТабДок.Вывести(ОбластьСтрокаСотрудник);
		
		ТабДок.Вывести(ОбластьШапкаПланФакт);
		ОбластьСтрокаПланФакт.Параметры.Заполнить(Выборка);
		ОбластьСтрокаПланФакт.Параметры.ВыполнениеПлана = ?(Выборка.ПланВыручка = 0, 0, Выборка.ФактВыручка / Выборка.ПланВыручка * 100); 
		ОбластьСтрокаПланФакт.Параметры.Эффективность = ?(ЗначениеЗаполнено(Выборка.ФактЗамеров), Выборка.ЭффЗамеры / Выборка.ФактЗамеров * 100, 0);
		ТабДок.Вывести(ОбластьСтрокаПланФакт);
		
		//Если ЗначениеЗаполнено(Выборка.Дата) ИЛИ ЗначениеЗаполнено(Выборка.ДоговорВРаботе) Тогда
		//	
		//	ВыборкаВстречиДоговора = Выборка.Выбрать();
		//	Пока ВыборкаВстречиДоговора.Следующий() Цикл
		//		//Если ВыборкаВстречиДоговора
		//	КонецЦикла;
		//КонецЕсли;	
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции
