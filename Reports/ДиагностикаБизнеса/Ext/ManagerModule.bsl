﻿
Функция СформироватьОтчет(ПараметрыОтчета) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДокСлужебок = Новый ТабличныйДокумент;
	
	ТабДок.АвтоМасштаб = Истина;
	
	Макет = Отчеты.ДиагностикаБизнеса.ПолучитьМакет("Макет");
	
	Тело = Макет.ПолучитьОбласть("Тело|КолонкиТело");
	СтрокаПодразделение = Макет.ПолучитьОбласть("СтрокаПодразделение|КолонкиТело");
	
	ОбластьМонтаж = Макет.ПолучитьОбласть("ОбластьМонтаж|КолонкиТело");
	ОбластьАкт = Макет.ПолучитьОбласть("ОбластьАкт|КолонкиТело");
	ОбластьЦех = Макет.ПолучитьОбласть("ОбластьЦех|КолонкиТело");
	ОбластьОтгружено = Макет.ПолучитьОбласть("ОбластьОтгружено|КолонкиТело");
	ОбластьРассчитано = Макет.ПолучитьОбласть("ОбластьРассчитано|КолонкиТело");
	ОбластьЗамер = Макет.ПолучитьОбласть("ОбластьЗамер|КолонкиТело");
	ОбластьДоговора = Макет.ПолучитьОбласть("ОбластьДоговора|КолонкиТело");
	
	СтрокаДоговор = Макет.ПолучитьОбласть("ШапкаДоговор|КолонкиДоговор");
	СтрокаАкт = Макет.ПолучитьОбласть("ШапкаАкт|КолонкиАкт");
	ШапкаСлужебок = Макет.ПолучитьОбласть("ШапкаСлужебок|КолонкиСлужебок");
	СтрокаСлужебок = Макет.ПолучитьОбласть("СтрокаСлужебок|КолонкиСлужебок"); 
	ШапкаСпецификации = Макет.ПолучитьОбласть("ШапкаСпецификация|КолонкиВыпуска");
	ШапкаВыпуска = Макет.ПолучитьОбласть("ШапкаВыпуск|КолонкиВыпуска");
	
	ШапкаТаблицыАкт = Макет.ПолучитьОбласть("ШапкаТаблицыАкт|КолонкиТаблицы");
	СтрокаТаблицыАкт = Макет.ПолучитьОбласть("СтрокаТаблицыАкт|КолонкиТаблицы");	
	ШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкиТаблицы");
	СтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкиТаблицы");
	ШапкаТаблицыДоговора = Макет.ПолучитьОбласть("ШапкаТаблицыДоговора|КолонкиТаблицы");
	СтрокаТаблицыДоговора = Макет.ПолучитьОбласть("СтрокаТаблицыДоговора|КолонкиТаблицы");

	#Область Запрос_отчета
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаОтчета", ПараметрыОтчета.Дата);
	Запрос.УстановитьПараметр("Подразделение", ПараметрыОтчета.Подразделение);
	Запрос.УстановитьПараметр("Дата", ТекущаяДата() - 7*86400);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	спрСпецификация.ДатаМонтажа КАК ДатаМонтажа,
	|	докДоговор.Спецификация,
	|	докДоговор.Номер КАК НомерДоговора,
	|	спрСпецификация.Номер КАК НомерСпецификации,
	|	спрСпецификация.Изделие КАК ВидИзделия,
	|	спрСпецификация.Монтажник.Фамилия + "" "" + ПОДСТРОКА(спрСпецификация.Монтажник.Имя, 1, 1) + "". "" + ПОДСТРОКА(спрСпецификация.Монтажник.Отчество, 1, 1) + ""."" КАК Монтажник,
	|	спрСпецификация.ДовозОсуществил.Фамилия + "" "" + ПОДСТРОКА(спрСпецификация.ДовозОсуществил.Имя, 1, 1) + "". "" + ПОДСТРОКА(спрСпецификация.ДовозОсуществил.Отчество, 1, 1) + ""."" КАК Экспедитор,
	|	докДоговор.Автор.ФизическоеЛицо.Фамилия + "" "" + ПОДСТРОКА(докДоговор.Автор.ФизическоеЛицо.Имя, 1, 1) + "". "" + ПОДСТРОКА(докДоговор.Автор.ФизическоеЛицо.Отчество, 1, 1) + ""."" КАК Дизайнер,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(спрСпецификация.ДокументОснование КАК Документ.Замер)) = ЗНАЧЕНИЕ(Документ.Замер.ПустаяСсылка)
	|			ТОГДА """"
	|		ИНАЧЕ ВЫРАЗИТЬ(спрСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Фамилия + "" "" + ПОДСТРОКА(ВЫРАЗИТЬ(спрСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Имя, 1, 1) + "". "" + ПОДСТРОКА(ВЫРАЗИТЬ(спрСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Отчество, 1, 1) + "".""
	|	КОНЕЦ КАК Замерщик,
	|	спрСпецификация.АдресМонтажа КАК Адрес,
	|	спрСпецификация.Подразделение КАК Подразделение,
	|	докДоговор.Ссылка КАК Договор,
	|	ВЫБОР
	|		КОГДА докАктВыполненияДоговора.Ссылка ЕСТЬ NULL 
	|			ТОГДА 2
	|		ИНАЧЕ 6
	|	КОНЕЦ КАК Порядок,
	|	докАктВыполненияДоговора.Номер КАК НомерАкта,
	|	докАктВыполненияДоговора.Ссылка КАК Акт,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаИзготовления,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаОтгрузки,
	|	докДоговор.Спецификация.Контрагент.Наименование КАК Контрагент,
	|	докДоговор.Спецификация.Контрагент.Телефон + "", "" + докДоговор.Спецификация.Контрагент.ТелефонДополнительный КАК Телефон,
	|	докАктВыполненияДоговора.Автор.ФизическоеЛицо.Фамилия + "" "" + ПОДСТРОКА(докАктВыполненияДоговора.Автор.ФизическоеЛицо.Имя, 1, 1) + "". "" + ПОДСТРОКА(докАктВыполненияДоговора.Автор.ФизическоеЛицо.Отчество, 1, 1) + ""."" КАК АвторАкта,
	|	спрСпецификация.Номер КАК Количество,
	|	NULL КАК ДатаДоговора
	|ПОМЕСТИТЬ ВТ_Доки
	|ИЗ
	|	Документ.Договор КАК докДоговор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктВыполненияДоговора КАК докАктВыполненияДоговора
	|		ПО (докАктВыполненияДоговора.Договор = докДоговор.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация КАК спрСпецификация
	|		ПО докДоговор.Спецификация = спрСпецификация.Ссылка
	|ГДЕ
	|	спрСпецификация.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж)
	|	И спрСпецификация.ДатаМонтажа <= &ДатаОтчета
	|	И (докАктВыполненияДоговора.Дата ЕСТЬ NULL 
	|			ИЛИ докАктВыполненияДоговора.ДатаПередачи = ДАТАВРЕМЯ(1, 1, 1)
	|				И докАктВыполненияДоговора.Дата <= &ДатаОтчета)
	|	И докДоговор.Проведен
	|	И ВЫБОР
	|			КОГДА &Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ спрСпецификация.Подразделение = &Подразделение
	|		КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	докСпецификация.ДатаМонтажа,
	|	докСпецификация.Ссылка,
	|	NULL,
	|	докСпецификация.Номер,
	|	докСпецификация.Изделие,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер)) = ЗНАЧЕНИЕ(Документ.Замер.ПустаяСсылка)
	|			ТОГДА """"
	|		ИНАЧЕ ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Фамилия + "" "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Имя, 1, 1) + "". "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Отчество, 1, 1) + "".""
	|	КОНЕЦ,
	|	докСпецификация.АдресМонтажа,
	|	докСпецификация.Подразделение,
	|	NULL,
	|	3,
	|	NULL,
	|	NULL,
	|	докСпецификация.ДатаИзготовления,
	|	NULL,
	|	докСпецификация.Контрагент.Наименование,
	|	докСпецификация.Контрагент.Телефон + "", "" + докСпецификация.Контрагент.ТелефонДополнительный,
	|	NULL,
	|	докСпецификация.Номер,
	|	NULL
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВыпускПродукции.СписокСпецификаций КАК ВыпускПродукцииСписокСпецификаций
	|		ПО (ВыпускПродукцииСписокСпецификаций.Спецификация = докСпецификация.Ссылка)
	|ГДЕ
	|	докСпецификация.ДатаИзготовления <= &ДатаОтчета
	|	И ВыпускПродукцииСписокСпецификаций.Ссылка ЕСТЬ NULL 
	|	И докСпецификация.Проведен
	|	И ВЫБОР
	|			КОГДА &Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ докСпецификация.Подразделение = &Подразделение
	|		КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	докСпецификация.ДатаМонтажа,
	|	докСпецификация.Ссылка,
	|	NULL,
	|	докСпецификация.Номер,
	|	докСпецификация.Изделие,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер)) = ЗНАЧЕНИЕ(Документ.Замер.ПустаяСсылка)
	|			ТОГДА """"
	|		ИНАЧЕ ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Фамилия + "" "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Имя, 1, 1) + "". "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Отчество, 1, 1) + "".""
	|	КОНЕЦ,
	|	докСпецификация.АдресМонтажа,
	|	докСпецификация.Подразделение,
	|	NULL,
	|	5,
	|	NULL,
	|	NULL,
	|	NULL,
	|	докСпецификация.ДатаОтгрузки,
	|	докСпецификация.Контрагент.Наименование,
	|	докСпецификация.Контрагент.Телефон + "", "" + докСпецификация.Контрагент.ТелефонДополнительный,
	|	NULL,
	|	докСпецификация.Номер,
	|	NULL
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияГотовойПродукции.СписокСпецификаций КАК РеализацияГотовойПродукцииСписокСпецификаций
	|		ПО (РеализацияГотовойПродукцииСписокСпецификаций.Спецификация = докСпецификация.Ссылка)
	|ГДЕ
	|	докСпецификация.ДатаОтгрузки <= &ДатаОтчета
	|	И РеализацияГотовойПродукцииСписокСпецификаций.Ссылка ЕСТЬ NULL 
	|	И докСпецификация.Проведен
	|	И ВЫБОР
	|			КОГДА &Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ докСпецификация.Подразделение = &Подразделение
	|		КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	докСпецификация.ДатаМонтажа,
	|	докСпецификация.Ссылка,
	|	NULL,
	|	докСпецификация.Номер,
	|	докСпецификация.Изделие,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер)) = ЗНАЧЕНИЕ(Документ.Замер.ПустаяСсылка)
	|			ТОГДА """"
	|		ИНАЧЕ ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Фамилия + "" "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Имя, 1, 1) + "". "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Отчество, 1, 1) + "".""
	|	КОНЕЦ,
	|	докСпецификация.АдресМонтажа,
	|	докСпецификация.Подразделение,
	|	NULL,
	|	4,
	|	NULL,
	|	NULL,
	|	докСпецификация.ДатаИзготовления,
	|	докСпецификация.ДатаОтгрузки,
	|	докСпецификация.Контрагент.Наименование,
	|	докСпецификация.Контрагент.Телефон + "", "" + докСпецификация.Контрагент.ТелефонДополнительный,
	|	NULL,
	|	докСпецификация.Номер,
	|	NULL
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО (СтатусСпецификацииСрезПоследних.Спецификация = докСпецификация.Ссылка)
	|ГДЕ
	|	СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Рассчитывается)
	|	И РАЗНОСТЬДАТ(докСпецификация.ДатаИзготовления, &ДатаОтчета, ДЕНЬ) > 2
	|	И ВЫБОР
	|			КОГДА &Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ докСпецификация.Подразделение = &Подразделение
	|		КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	NULL,
	|	докДоговор.Спецификация,
	|	докДоговор.Номер,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	докДоговор.Автор.ФизическоеЛицо.Фамилия + "" "" + ПОДСТРОКА(докДоговор.Автор.ФизическоеЛицо.Имя, 1, 1) + "". "" + ПОДСТРОКА(докДоговор.Автор.ФизическоеЛицо.Отчество, 1, 1) + ""."",
	|	ВЫБОР
	|		КОГДА докЗамер.Замерщик = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|			ТОГДА """"
	|		ИНАЧЕ докЗамер.Замерщик.Фамилия + "" "" + ПОДСТРОКА(докЗамер.Замерщик.Имя, 1, 1) + "". "" + ПОДСТРОКА(докЗамер.Замерщик.Отчество, 1, 1) + "".""
	|	КОНЕЦ,
	|	докЗамер.АдресЗамера,
	|	докДоговор.Подразделение,
	|	докДоговор.Ссылка,
	|	1,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	докДоговор.Дата
	|ИЗ
	|	Документ.Договор КАК докДоговор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Замер КАК докЗамер
	|		ПО ((ВЫРАЗИТЬ(докДоговор.Спецификация.ДокументОснование КАК Документ.Замер)) = докЗамер.Ссылка)
	|ГДЕ
	|	докДоговор.Дата > &Дата
	|	И ДЕНЬГОДА(докДоговор.Дата) = ДЕНЬГОДА(докЗамер.ДатаЗамера)
	|	И ВЫБОР
	|			КОГДА &Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ докДоговор.Подразделение = &Подразделение
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Доки.Спецификация КАК Спецификация,
	|	ВТ_Доки.НомерДоговора,
	|	ВТ_Доки.НомерСпецификации,
	|	ВТ_Доки.ВидИзделия,
	|	ВТ_Доки.Дизайнер,
	|	ВТ_Доки.Замерщик,
	|	ВЫБОР
	|		КОГДА ВТ_Доки.Адрес = ""Введите адрес""
	|				И ВТ_Доки.Спецификация.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.СамовывозОтПроизводителя)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.СамовывозОтПроизводителя)
	|		КОГДА ВТ_Доки.Адрес = ""Введите адрес""
	|				И ВТ_Доки.Спецификация.ПакетУслуг <> ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.СамовывозОтПроизводителя)
	|			ТОГДА ""Адрес не указан""
	|		ИНАЧЕ ВТ_Доки.Адрес
	|	КОНЕЦ КАК Адрес,
	|	ВТ_Доки.Подразделение КАК Подразделение,
	|	ВТ_Доки.Договор КАК Договор,
	|	ВТ_Доки.Порядок КАК Порядок,
	|	ВТ_Доки.НомерАкта,
	|	ВТ_Доки.Акт,
	|	ВТ_Доки.ДатаИзготовления КАК ДатаИзготовления,
	|	СлужебнаяЗаписка.Ссылка КАК СЗ,
	|	Заметки.ТекстСодержания КАК Текст,
	|	ВТ_Доки.Контрагент,
	|	ВТ_Доки.Телефон,
	|	ВТ_Доки.АвторАкта,
	|	ВТ_Доки.ДатаМонтажа,
	|	ВТ_Доки.Монтажник,
	|	ВТ_Доки.Экспедитор,
	|	ВТ_Доки.Количество КАК Количество,
	|	ВТ_Доки.ДатаОтгрузки,
	|	ВТ_Доки.ДатаДоговора
	|ИЗ
	|	ВТ_Доки КАК ВТ_Доки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Заметки КАК Заметки
	|		ПО (ВЫБОР
	|				КОГДА ВТ_Доки.Порядок > 1
	|						И ВТ_Доки.Порядок <= 4
	|					ТОГДА ВТ_Доки.Спецификация = (ВЫРАЗИТЬ(Заметки.Предмет КАК Документ.Спецификация))
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СлужебнаяЗаписка КАК СлужебнаяЗаписка
	|		ПО (ВЫБОР
	|				КОГДА ВТ_Доки.Порядок > 1
	|						И ВТ_Доки.Порядок <= 4
	|					ТОГДА ВТ_Доки.Договор = СлужебнаяЗаписка.Документ
	|							ИЛИ ВТ_Доки.Спецификация = СлужебнаяЗаписка.Документ
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	ДатаИзготовления
	|ИТОГИ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Количество)
	|ПО
	|	Подразделение,
	|	Порядок,
	|	Спецификация";
		
	#КонецОбласти
	
	ВыборкаПоПодразделениям = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоПодразделениям.Следующий() Цикл
		
		СтрокаПодразделение.Параметры.Заполнить(ВыборкаПоПодразделениям);				
		ТабДок.Вывести(СтрокаПодразделение);	
		ТабДок.НачатьГруппуСтрок();	
		
		ТабДок.Вывести(ОбластьЗамер);
		ТабДок.НачатьГруппуСтрок();
		ТабДокЗамеров = Отчеты.ОтчетСтаршегоДизайнера.СформироватьОтчет(Новый Структура("Подразделение", ВыборкаПоПодразделениям.Подразделение), Ложь);
		ТабДок.Вывести(ТабДокЗамеров);
		ТабДок.ЗакончитьГруппуСтрок();

		ВыборкаПоПорядку = ВыборкаПоПодразделениям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПоПорядку.Следующий() Цикл
			
			Если ВыборкаПоПорядку.Порядок = 1 Тогда
				//ОбластьДоговора.Параметры.Заполнить(ВыборкаПоПорядку);
				ТабДок.Вывести(ОбластьДоговора);
			ИначеЕсли ВыборкаПоПорядку.Порядок = 2 Тогда
				ОбластьМонтаж.Параметры.Заполнить(ВыборкаПоПорядку);
				ТабДок.Вывести(ОбластьМонтаж);
			ИначеЕсли ВыборкаПоПорядку.Порядок = 3 Тогда
				ОбластьЦех.Параметры.Заполнить(ВыборкаПоПорядку);
				ТабДок.Вывести(ОбластьЦех);
			ИначеЕсли ВыборкаПоПорядку.Порядок = 4 Тогда
				ОбластьРассчитано.Параметры.Заполнить(ВыборкаПоПорядку);
				ТабДок.Вывести(ОбластьРассчитано);
			ИначеЕсли ВыборкаПоПорядку.Порядок = 5 Тогда
				ОбластьОтгружено.Параметры.Заполнить(ВыборкаПоПорядку);
				ТабДок.Вывести(ОбластьОтгружено);
			ИначеЕсли ВыборкаПоПорядку.Порядок = 6 Тогда
				ОбластьАкт.Параметры.Заполнить(ВыборкаПоПорядку);
				ТабДок.Вывести(ОбластьАкт);
			КонецЕсли;
						
			ТабДок.НачатьГруппуСтрок();
			
			ВыборкаПоСпецификациям = ВыборкаПоПорядку.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			ВыводШапкиТаблицы = Истина;
			
			Пока ВыборкаПоСпецификациям.Следующий() Цикл
				
				Выборка = ВыборкаПоСпецификациям.Выбрать();
				
				Выборка.Следующий();
				
				Если Выборка.Порядок = 1  Тогда
												
					Если ВыводШапкиТаблицы Тогда
						ТабДок.Вывести(ШапкаТаблицыДоговора);
						ВыводШапкиТаблицы = Ложь;
					КонецЕсли;
					
					СтрокаТаблицыДоговора.Параметры.Заполнить(Выборка);
					СтрокаТаблицыДоговора.Параметры.НомерДоговора = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(Выборка.НомерДоговора);
					СтрокаТаблицыДоговора.Параметры.РасшифровкаДоговора = Новый Структура("Договор", Выборка.Договор);
					ТабДок.Вывести(СтрокаТаблицыДоговора);
					
					Выборка.Сбросить();
					
				ИначеЕсли Выборка.Порядок > 1 И Выборка.Порядок <= 4 Тогда
					Тело.Параметры.Заполнить(Выборка);
					ТестОбластиТело = СтрЗаменить(Выборка.Текст, Символы.ПС + Символы.ПС + Символы.ПС, Символы.ПС);
					Тело.Параметры.Текст = СтрЗаменить(ТестОбластиТело, Символы.ПС + Символы.ПС, Символы.ПС);
					Тело.Параметры.НомерСпецификации = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(Выборка.НомерСпецификации);
					Тело.Параметры.РасшифровкаСпецификация = Новый Структура("Спецификация", Выборка.Спецификация);									
					ТабДок.Вывести(Тело);
					
					
					ШапкаСлужебок.Параметры.Расшифровка = Новый Структура("Ссылка, Текст", Выборка.Спецификация, Выборка.Текст);
					
					Выборка.Сбросить();
					
					ТабДокСлужебок.Очистить();
					ТабДокСлужебок.Вывести(ШапкаСлужебок);
					
					Пока Выборка.Следующий() Цикл
						
						СтрокаСлужебок.Параметры.Заполнить(Выборка);
						СтрокаСлужебок.Параметры.РасшифровкСЗ = Новый Структура("Служебка", Выборка.СЗ);
						ТабДокСлужебок.Вывести(СтрокаСлужебок);
						
					КонецЦикла;
					
					ТабДок.Присоединить(ТабДокСлужебок);
					
				Иначе
										
					НашаШапка = ?(Выборка.Порядок = 4, ШапкаТаблицы, ШапкаТаблицыАкт);
					НашаСтрока = ?(Выборка.Порядок = 4, СтрокаТаблицы, СтрокаТаблицыАкт);
										
					Если ВыводШапкиТаблицы Тогда
						ТабДок.Вывести(НашаШапка);
						ВыводШапкиТаблицы = Ложь;
					КонецЕсли;
					
					НашаСтрока.Параметры.Заполнить(Выборка);
					НашаСтрока.Параметры.НомерСпецификации = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(Выборка.НомерСпецификации);
					НашаСтрока.Параметры.РасшифровкаСпецификация = Новый Структура("Спецификация", Выборка.Спецификация);
					ТабДок.Вывести(НашаСтрока);
					
					Выборка.Сбросить();
					
				КонецЕсли;
				
			КонецЦикла;
			
			ТабДок.ЗакончитьГруппуСтрок();
			
		КонецЦикла;
		
		ТабДок.ЗакончитьГруппуСтрок();
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции       
