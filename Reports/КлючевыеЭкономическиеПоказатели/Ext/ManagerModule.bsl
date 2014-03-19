﻿
Функция СформироватьОтчет(ПериодОтчета, СписокПодразделений, ВидОтчета) Экспорт
	
	Перем Область;
	Перем ТЗСтатьи;
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ФиксацияСверху = 1;
	ТабДок.ФиксацияСлева = 1;
	
	Макет = Отчеты.КлючевыеЭкономическиеПоказатели.ПолучитьМакет("Макет");
	ОбластьШапкаСтатья = Макет.ПолучитьОбласть("Шапка|Статья");
	ОбластьШапкаКолонкаЗеленая = Макет.ПолучитьОбласть("Шапка|КолонкаЗеленая");
	ОбластьШапкаКолонкаКрасная = Макет.ПолучитьОбласть("Шапка|КолонкаКрасная");
	ОбластьШапкаКолонкаСиняя = Макет.ПолучитьОбласть("Шапка|КолонкаСиняя");
	ОбластьСтрокаСтатья = Макет.ПолучитьОбласть("Строка|Статья");
	ОбластьСтрокаКолонкаЗеленая = Макет.ПолучитьОбласть("Строка|КолонкаЗеленая");
	ОбластьСтрокаКолонкаКрасная = Макет.ПолучитьОбласть("Строка|КолонкаКрасная");
	ОбластьСтрокаКолонкаСиняя = Макет.ПолучитьОбласть("Строка|КолонкаСиняя");
	
	Таблица = ЗаполнитьТаблицу(ПериодОтчета, СписокПодразделений, ВидОтчета, ТЗСтатьи);
	
	//////////////////////////////////////
	// ШАПКА
	ПерваяКолонка = Истина;
	Для каждого Колонка Из Таблица.Колонки Цикл
		
		Если ПерваяКолонка Тогда
			ТабДок.Вывести(ОбластьШапкаСтатья);
			ПерваяКолонка = Ложь;
			Продолжить;
		КонецЕсли;
		
		Цвет = ОпределитьЦветКолонки(Колонка, ТЗСтатьи);
		Выполнить("Область = ОбластьШапкаКолонка" + Цвет);
		
		Область.Параметры.Статья = Колонка.Заголовок;
		ТабДок.Присоединить(Область);
		
	КонецЦикла;
	
	//////////////////////////////////////
	// СТРОКИ
	Для каждого Строка Из Таблица Цикл
		
		ОбластьСтрокаСтатья.Параметры.Период = Строка.Период;
		ТабДок.Вывести(ОбластьСтрокаСтатья);
		
		ПерваяКолонка = Истина;
		
		Для каждого Колонка Из Таблица.Колонки Цикл
			
			Если ПерваяКолонка Тогда
				ПерваяКолонка = Ложь;
				Продолжить;
			КонецЕсли;
			
			Цвет = ОпределитьЦветКолонки(Колонка, ТЗСтатьи);
			Выполнить("Область = ОбластьСтрокаКолонка" + Цвет);
			
			Если Строка.Период = "Итого" ИЛИ Найти(Строка.Период, "%") > 0 Тогда
				Область.ТекущаяОбласть.Шрифт = Новый Шрифт(,, Истина);
			КонецЕсли;
			
			Если Найти(Строка.Период, "%") > 0 Тогда
				Область.ТекущаяОбласть.Формат = "ЧДЦ = 2";
			КонецЕсли;
			
			СтрокаСтатья = ТЗСтатьи.Найти(Колонка.Имя, "ИмяПредопределенного");
			Если СтрокаСтатья <> Неопределено Тогда
				Статья = СтрокаСтатья.Ссылка;
			Иначе
				Статья = Колонка.Имя;
			КонецЕсли;
			
			Область.Параметры.Сумма = Строка[Колонка.Имя];
			Область.Параметры.Расшифровка = Новый Структура("Период, Статья", Строка.Период, Статья);
			ТабДок.Присоединить(Область);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Функция ЗаполнитьТаблицу(ПериодОтчета, СписокПодразделений, ВидОтчета, ТЗСтатьи)
	
	ТЗСтатьи = Новый ТаблицаЗначений;
	ТЗСтатьи.Колонки.Добавить("Ссылка");
	ТЗСтатьи.Колонки.Добавить("ВидСтатьи");
	ТЗСтатьи.Колонки.Добавить("ИмяПредопределенного");
	ТЗСтатьи.Колонки.Добавить("Цвет");
	
	ТЗ = Новый ТаблицаЗначений;
	
	///////////////////////////////////////////////////
	// создаём колонки таблицы
	
	ЗапросГруппы= Новый Запрос;
	ЗапросГруппы.Текст =
	"ВЫБРАТЬ
	|	Статьи.Ссылка,
	|	Статьи.ВидСтатьи,
	|	Статьи.Наименование,
	|	ВЫБОР
	|		КОГДА Статьи.ВидСтатьи = ЗНАЧЕНИЕ(Перечисление.ВидыСтатейДДС.Выплата)
	|				ИЛИ Статьи.ВидСтатьи = ЗНАЧЕНИЕ(Перечисление.ВидыСтатейДР.Расход)
	|			ТОГДА ""Красная""
	|		ИНАЧЕ ""Зеленая""
	|	КОНЕЦ КАК Цвет
	|ИЗ
	|	Справочник.СтатьиДвиженияДенежныхСредств КАК Статьи
	|ГДЕ
	|	Статьи.ЭтоГруппа
	|	И НЕ Статьи.МеждуСчетами
	|	И Статьи.Предопределенный
	|
	|УПОРЯДОЧИТЬ ПО
	|	Статьи.НомерКолонки";
	
	Если ВидОтчета = "Касса" Тогда
		Счет = ПланыСчетов.Управленческий.ДенежныеСредства;
		СпрСтатьи = Справочники.СтатьиДвиженияДенежныхСредств;
	Иначе
		ЗапросГруппы.Текст = СтрЗаменить(ЗапросГруппы.Текст, "Справочник.СтатьиДвиженияДенежныхСредств", "Справочник.СтатьиДоходовРасходов");
		СпрСтатьи = Справочники.СтатьиДоходовРасходов;
		Счет = ПланыСчетов.Управленческий.ПрибыльУбытки;
	КонецЕсли;
	
	Результат = ЗапросГруппы.Выполнить();
	ВыборкаГруппы = Результат.Выбрать();
	ТЗ.Колонки.Добавить("Период",, "Период");
	ТЗ.Колонки.Добавить("Продажи",,"Продажи");
	Пока ВыборкаГруппы.Следующий() Цикл
		
		ИмяПредопределенного = СпрСтатьи.ПолучитьИмяПредопределенного(ВыборкаГруппы.Ссылка);
		
		НоваяСтрока = ТЗСтатьи.Добавить();
		НоваяСтрока.Ссылка = ВыборкаГруппы.Ссылка;
		НоваяСтрока.ВидСтатьи = ВыборкаГруппы.ВидСтатьи;
		НоваяСтрока.ИмяПредопределенного = ИмяПредопределенного;
		НоваяСтрока.Цвет = ВыборкаГруппы.Цвет;
		
		ТЗ.Колонки.Добавить(ИмяПредопределенного,,ВыборкаГруппы.Наименование);
		
	КонецЦикла;
	
	ТЗ.Колонки.Добавить("Итог",,"Итог");
	
	///////////////////////////////////////////////////
	// запрос для данных отчета
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ПериодОтчета.ДатаОкончания);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОбороты.Период КАК Период,
	|	ВЫРАЗИТЬ(УправленческийОбороты.Субконто1 КАК Справочник.СтатьиДвиженияДенежныхСредств).Родитель КАК Статья,
	|	ISNULL(УправленческийОбороты.СуммаОборот, 0) КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			День,
	|			Счет В ИЕРАРХИИ (&Счет),
	|			,
	|			Подразделение В (&СписокПодразделений)
	|				И ВЫРАЗИТЬ(Субконто1 КАК Справочник.СтатьиДвиженияДенежныхСредств).МеждуСчетами = ЛОЖЬ,
	|			,
	|			) КАК УправленческийОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	Период ПЕРИОДАМИ(ДЕНЬ, &НачалоПериода, &КонецПериода),
	|	Статья";
	
	Если ВидОтчета <> "Касса" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Субконто1 КАК Справочник.СтатьиДвиженияДенежныхСредств)", "Субконто1 КАК Справочник.СтатьиДоходовРасходов)");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "УправленческийОбороты.СуммаОборот", "-УправленческийОбороты.СуммаОборот");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	// заполнение строк
	
	ВыборкаПериод = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ПЕРИОД" ,"ВСЕ");
	Пока ВыборкаПериод.Следующий() Цикл
		
		ИтогПоСтроке = 0;
		
		НоваяСтрока = ТЗ.Добавить();
		НоваяСтрока.Период =ВыборкаПериод.Период;
		ВыборкаСтатья = ВыборкаПериод.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "СТАТЬЯ" ,"ВСЕ");
		Пока ВыборкаСтатья.Следующий() Цикл
			ИмяПоля = СпрСтатьи.ПолучитьИмяПредопределенного(ВыборкаСтатья.Статья);
			НоваяСтрока[ИмяПоля] = ВыборкаСтатья.Сумма;
			
			Если (ВыборкаСтатья.Статья.ВидСтатьи = Перечисления.ВидыСтатейДДС.Выплата
				ИЛИ ВыборкаСтатья.Статья.ВидСтатьи = Перечисления.ВидыСтатейДР.Расход) И ТипЗнч(ВыборкаСтатья.Сумма) <> Тип("NULL") Тогда
				ИтогПоСтроке = ИтогПоСтроке + ВыборкаСтатья.Сумма;
			КонецЕсли;
			
		КонецЦикла;
		
		НоваяСтрока.Итог = ИтогПоСтроке;
		
	КонецЦикла;
	
	///////////////////////////////////////////////////////
	// заполнение колонки Продажи
	
	// договоры и доп. соглашения
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ПериодОтчета.ДатаОкончания);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОбороты.Период КАК Период,
	|	УправленческийОбороты.СуммаОборот КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			День,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|			,
	|			Подразделение В (&СписокПодразделений)
	|				И Субконто1 = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.СтоимостьЗаключенныхДоговоров),
	|			,
	|			) КАК УправленческийОбороты
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(Спецификация.Дата, ДЕНЬ),
	|	Спецификация.СуммаДокумента
	|ИЗ
	|	Документ.Спецификация КАК Спецификация
	|ГДЕ
	|	Спецификация.Проведен
	|	И Спецификация.Изделие = ЗНАЧЕНИЕ(Справочник.Изделия.Детали)
	|	И Спецификация.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И Спецификация.Подразделение В (&СписокПодразделений)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	Период ПЕРИОДАМИ(ДЕНЬ, &НачалоПериода, &КонецПериода)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ПЕРИОД" ,"ВСЕ");
	
	Для каждого Строка Из ТЗ Цикл
		Выборка.Следующий();
		Строка.Продажи = Выборка.Сумма;
	КонецЦикла;
	
	//////////////////////////////////////
	// ИТОГИ
	ВсегоЗеленых = 0;
	СтрокаИтоги = ТЗ.Добавить();
	Для каждого Колонка ИЗ ТЗ.Колонки Цикл
		
		Сумма = ТЗ.Итог(Колонка.Имя);
		СтрокаИтоги[Колонка.Имя] = Сумма;
		
		Строка = ТЗСтатьи.Найти(Колонка.Имя, "ИмяПредопределенного");
		
		Если Строка <> Неопределено И (Строка.ВидСтатьи = Перечисления.ВидыСтатейДДС.Поступление ИЛИ Строка.ВидСтатьи = Перечисления.ВидыСтатейДР.Доход ) Тогда
			ВсегоЗеленых = ВсегоЗеленых + Сумма;
		КонецЕсли;
		
	КонецЦикла;
	СтрокаИтоги.Период = "Итого";
	
	//////////////////////////////////////
	// ПРОЦЕНТЫ
	СтрокаПроцент = ТЗ.Добавить();
	Для каждого Колонка Из ТЗ.Колонки Цикл
		
		Если ВсегоЗеленых <> 0 Тогда
			Сумма = ТЗ.Итог(Колонка.Имя) / 2 / ВсегоЗеленых * 100;
		Иначе
			Сумма = 0;
		КонецЕсли;
		
		Сумма = ?(Сумма > 0, Сумма, - Сумма);
		СтрокаПроцент[Колонка.Имя] = Сумма;
	КонецЦикла;
	СтрокаПроцент.Период = "% к зеленым";
	
	Возврат ТЗ;
	
КонецФункции

Функция ОпределитьЦветКолонки(Колонка, ТЗСтатьи)
	
	Строка = ТЗСтатьи.Найти(Колонка.Имя, "ИмяПредопределенного");
	Если Строка = Неопределено Тогда
		Цвет = "Синяя";
	Иначе
		Цвет = Строка.Цвет;
	КонецЕсли;
	
	Возврат Цвет;
	
КонецФункции