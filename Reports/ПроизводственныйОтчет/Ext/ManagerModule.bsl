﻿
Функция ВывестиПроизводственныйОтчет(ТабДок, Подразделение, Разделы) Экспорт
	
	Макет = ПолучитьМакет("МакетПроизводственныйОтчет");
	
	ВывестиШапкуОтчета(ТабДок, Макет, Подразделение);
	
	Если Разделы.НеПроведенныеНоОплаченные Тогда
		ВывестиНеПроведенныеНоОплаченные(ТабДок, Макет, Подразделение);
	КонецЕсли;
	
	Если Разделы.РазмещенныеИНаПроверке Тогда
		ВывестиРазмещенныеИНаПроверке(ТабДок, Макет, Подразделение);
	КонецЕсли;
	
	Если Разделы.РасчетыИнженеров Тогда
		ВывестиРасчетыИнженеров(ТабДок, Макет, Подразделение);
	КонецЕсли;
	
	Если Разделы.ПросроченноеИзготовление Тогда
		ВывестиПросроченноеИзготовление(ТабДок, Макет, Подразделение);
	КонецЕсли;
	
	Если Разделы.ИзделияНаСкладеГотовойПродукции Тогда
		ВывестиИзделияНаСкладеГотовойПродукции(ТабДок, Макет, Подразделение);
	КонецЕсли;
	
	Если Разделы.Монтажи Тогда
		ВывестиМонтажи(ТабДок, Макет, Подразделение);
	КонецЕсли;
	
КонецФункции

Функция ВывестиШапкуОтчета(ТабДок, Макет, Подразделение)
	
	ШапкаОтчета = Макет.ПолучитьОбласть("ШапкаОтчета");
	ШапкаОтчета.Параметры.Дата = Формат(ТекущаяДата(),"ДЛФ=DT");
	ШапкаОтчета.Параметры.Подразделение = Подразделение;
	ТабДок.Вывести(ШапкаОтчета);
	
КонецФункции

Функция ВывестиМонтажи(ТабДок, Макет, Подразделение)
	
	ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	МонтажиШапка = Макет.ПолучитьОбласть("МонтажиШапка");
	МонтажиСтрока = Макет.ПолучитьОбласть("МонтажиСтрока");
	МонтажиСтрокаКрасная = Макет.ПолучитьОбласть("МонтажиСтрокаКрасная");
	ЗаметкаСтрока = Макет.ПолучитьОбласть("СтрокаЗаметкаМонтаж");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Статусы.Спецификация.Изделие КАК Изделие,
	|	Статусы.Спецификация.АдресМонтажа КАК Адрес,
	|	Статусы.Спецификация.Монтажник КАК Монтажник,
	|	Статусы.Спецификация.ДатаМонтажа КАК ДатаМонтажа,
	|	Статусы.Спецификация.ПервичнаяДатаМонтажа КАК ПервичнаяДатаМонтажа,
	|	ВЫРАЗИТЬ(Статусы.Спецификация.ДокументОснование КАК Документ.Замер).Замерщик КАК Замерщик,
	|	Статусы.Спецификация КАК РасшифровкаСпецификация,
	|	Заметки.Ссылка КАК Заметка,
	|	Статусы.Спецификация.ПакетУслуг КАК ПакетУслуг,
	|	Статусы.Спецификация.Упаковка КАК Упаковка,
	|	Статусы.Спецификация.ТребуетсяПроверка КАК ТребуетсяПроверка,
	|	ЕСТЬNULL(Проверка.Проверен, ЛОЖЬ) КАК Проверен
	|ИЗ
	|	РегистрСведений.СтатусСпецификации.СрезПоследних КАК Статусы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Заметки КАК Заметки
	|		ПО Статусы.Спецификация = Заметки.Предмет
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроверкаСпецификации.СрезПоследних КАК Проверка
	|		ПО Статусы.Спецификация = Проверка.Спецификация
	|ГДЕ
	|	Статусы.Спецификация.Подразделение = &Подразделение
	|	И Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Отгружен)
	|	И Статусы.Спецификация.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж)
	|	И Статусы.Спецификация.Монтажник <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаМонтажа";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		ЗаголовокТаблицы.Параметры.ЗаголовокТаблицы = "Монтаж изделий";
		ТабДок.Вывести(ЗаголовокТаблицы);
		ТабДок.Вывести(МонтажиШапка);
		
		НомерСтроки = 1;
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ДатаМонтажа < ТекущаяДата() Тогда
				ТекСтрока = Макет.ПолучитьОбласть("МонтажиСтрокаКрасная");
			Иначе
				ТекСтрока = Макет.ПолучитьОбласть("МонтажиСтрока");
			КонецЕсли;
			
			ТекСтрока.Параметры.НомерСтроки = НомерСтроки;
			ЗаполнитьЗначенияСвойств(ТекСтрока.Параметры, Выборка);
			ТекСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.РасшифровкаСпецификация.Номер, "0");
			
			Если ЗначениеЗаполнено(Выборка.ПервичнаяДатаМонтажа) И (Выборка.ДатаМонтажа <> Выборка.ПервичнаяДатаМонтажа) Тогда
				 ТекСтрока.Параметры.ПереносМонтажа = "ПЕРЕНОС МОНТАЖА";
			КонецЕсли;
			
			ТекСтрока.Параметры.Монтажник = Выборка.Монтажник.Фамилия + " " + Лев(Выборка.Монтажник.Имя, 1) + ". " + Лев(Выборка.Монтажник.Отчество, 1) + ".";
			
			Если ЗначениеЗаполнено(Выборка.Замерщик) Тогда
				ТекСтрока.Параметры.Замерщик = Выборка.Замерщик.Фамилия + " " + Лев(Выборка.Замерщик.Имя, 1) + ". " + Лев(Выборка.Замерщик.Отчество, 1) + ".";
			КонецЕсли;
			
			Если Выборка.ПакетУслуг = Перечисления.ПакетыУслуг.СамовывозОтПроизводителя Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D1);					 	
			КонецЕсли;
			
			Если НЕ Выборка.Упаковка Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D2);
			КонецЕсли;
			
			Если НЕ Выборка.Проверен Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D3);
			КонецЕсли;
			
			Если НЕ Выборка.ТребуетсяПроверка Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D4);
			КонецЕсли;
	
			ТабДок.Вывести(ТекСтрока);
			
			Если ЗначениеЗаполнено(Выборка.Заметка) Тогда
				
				ЗаметкаСтрока.Параметры.Заметка = Выборка.Заметка.ТекстСодержания;
				ЗаметкаСтрока.Параметры.РасшифровкаЗаметка = Выборка.Заметка;
				ТабДок.Вывести(ЗаметкаСтрока);
				
			КонецЕсли;
			
			НомерСтроки = 1 + НомерСтроки;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции

Функция ВывестиРасчетыИнженеров(ТабДок, Макет, Подразделение)
	
	ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	РасчетыШапка = Макет.ПолучитьОбласть("РасчетыШапка");
	РасчетыСтрока = Макет.ПолучитьОбласть("РасчетыСтрока");
	РасчетыСтрокаКрасная = Макет.ПолучитьОбласть("РасчетыСтрокаКрасная");
	ЗаметкаСтрока = Макет.ПолучитьОбласть("СтрокаЗаметкаРасчеты"); 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтатусСпецификацииСрезПоследних.Спецификация КАК Спецификация,
	|	ЕСТЬNULL(Договор.Ссылка, ""Дилерская спец."") КАК Договор,
	|	СтатусСпецификацииСрезПоследних.Спецификация.ДатаИзготовления КАК ДатаИзготовления,
	|	СтатусСпецификацииСрезПоследних.Спецификация.АдресМонтажа КАК Адрес,
	|	СтатусСпецификацииСрезПоследних.Спецификация.Изделие КАК Изделие,
	|	Заметки.Ссылка КАК Заметка,
	|	СтатусСпецификацииСрезПоследних.Период КАК ППППП,
	|	РАЗНОСТЬДАТ(НАЧАЛОПЕРИОДА(СтатусСпецификацииСрезПоследних.Период, ДЕНЬ), НАЧАЛОПЕРИОДА(&ТекущаяДата, ДЕНЬ), ДЕНЬ) КАК ДнейРасчет,
	|	СтатусСпецификацииСрезПоследних.Спецификация.ПакетУслуг КАК ПакетУслуг,
	|	СтатусСпецификацииСрезПоследних.Спецификация.Упаковка КАК Упаковка,
	|	СтатусСпецификацииСрезПоследних.Спецификация.ДатаМонтажа КАК ДатаМонтажа,
	|	СтатусСпецификацииСрезПоследних.Спецификация.ПервичнаяДатаМонтажа КАК ПервичнаяДатаМонтажа,
	|	СтатусСпецификацииСрезПоследних.Спецификация.ТребуетсяПроверка КАК ТребуетсяПроверка,
	|	ЕСТЬNULL(Проверка.Проверен, ЛОЖЬ) КАК Проверен
	|ИЗ
	|	РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК Договор
	|		ПО СтатусСпецификацииСрезПоследних.Спецификация = Договор.Спецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Заметки КАК Заметки
	|		ПО СтатусСпецификацииСрезПоследних.Спецификация = Заметки.Предмет
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроверкаСпецификации.СрезПоследних КАК Проверка
	|		ПО СтатусСпецификацииСрезПоследних.Спецификация = Проверка.Спецификация
	|ГДЕ
	|	СтатусСпецификацииСрезПоследних.Спецификация.Подразделение = &Подразделение
	|	И СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Рассчитывается)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаИзготовления";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		ЗаголовокТаблицы.Параметры.ЗаголовокТаблицы = "Расчеты инженеров";
		ТабДок.Вывести(ЗаголовокТаблицы);
		ТабДок.Вывести(РасчетыШапка);
		
		НомерСтроки = 1;
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ДнейРасчет > 2 
			 ИЛИ ?(ЗначениеЗаполнено(Выборка.ДатаМонтажа), Выборка.ДатаМонтажа < ТекущаяДата(), Ложь)  Тогда
				ТекСтрока = Макет.ПолучитьОбласть("РасчетыСтрокаКрасная");
			Иначе
				ТекСтрока = Макет.ПолучитьОбласть("РасчетыСтрока");
			КонецЕсли;
			
			ТекСтрока.Параметры.НомерСтроки = НомерСтроки;
			ЗаполнитьЗначенияСвойств(ТекСтрока.Параметры, Выборка);
			
			Если ЗначениеЗаполнено(Выборка.ПервичнаяДатаМонтажа) И (Выборка.ДатаМонтажа <> Выборка.ПервичнаяДатаМонтажа) Тогда
				 ТекСтрока.Параметры.ПереносМонтажа = "ПЕРЕНОС МОНТАЖА";
			КонецЕсли;
			
			ТекСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.Спецификация.Номер, "0");
			
			Если Выборка.ПакетУслуг = Перечисления.ПакетыУслуг.СамовывозОтПроизводителя Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D1);					 	
			КонецЕсли;
			
			Если НЕ Выборка.Упаковка Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D2);
			КонецЕсли;
			
			Если НЕ Выборка.Проверен Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D3);
			КонецЕсли;
			
			Если НЕ Выборка.ТребуетсяПроверка Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D4);
			КонецЕсли;
			
			ТабДок.Вывести(ТекСтрока);
			
			Если ЗначениеЗаполнено(Выборка.Заметка) Тогда
				
				ЗаметкаСтрока.Параметры.Заметка = Выборка.Заметка.ТекстСодержания;
				ЗаметкаСтрока.Параметры.РасшифровкаЗаметка = Выборка.Заметка;
				ТабДок.Вывести(ЗаметкаСтрока);
				
			КонецЕсли;
			
			НомерСтроки = 1 + НомерСтроки;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции

Функция ВывестиНеПроведенныеНоОплаченные(ТабДок, Макет, Подразделение)
	
	ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	СпецификацииНеПроведенныеШапка = Макет.ПолучитьОбласть("СпецификацииНеПроведенныеШапка");
	СпецификацииНеПроведенныеСтрока = Макет.ПолучитьОбласть("СпецификацииНеПроведенныеСтрока");
	СпецификацииНеПроведенныеСтрокаКрасная = Макет.ПолучитьОбласть("СпецификацииНеПроведенныеСтрокаКрасная");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	докСпецификация.Ссылка КАК Спецификация,
	|	докСпецификация.ДатаИзготовления КАК ДатаИзготовления,
	|	докСпецификация.Изделие КАК Изделие,
	|	докСпецификация.СуммаДокумента КАК СуммаДокумента,
	|	ВЫБОР
	|		КОГДА докСпецификация.АдресМонтажа <> ""Введите адрес""
	|			ТОГДА докСпецификация.АдресМонтажа
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Адрес,
	|	ЕСТЬNULL(Остатки.СуммаОстатокКт, 0) КАК Сумма,
	|	докСпецификация.ПакетУслуг КАК ПакетУслуг,
	|	докСпецификация.Упаковка КАК Упаковка,
	|	докСпецификация.ДатаМонтажа,
	|	докСпецификация.ПервичнаяДатаМонтажа,
	|	докСпецификация.ТребуетсяПроверка КАК ТребуетсяПроверка,
	|	ЕСТЬNULL(Проверка.Проверен, ЛОЖЬ) КАК Проверен
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(&ТекущаяДата, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ВзаиморасчетыСПокупателями), , Подразделение = &Подразделение) КАК Остатки
	|		ПО (Остатки.Субконто2 = докСпецификация.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроверкаСпецификации.СрезПоследних КАК Проверка
	|		ПО докСпецификация.Ссылка = Проверка.Спецификация
	|ГДЕ
	|	докСпецификация.Подразделение = &Подразделение
	|	И НЕ докСпецификация.Проведен
	|	И ЕСТЬNULL(Остатки.СуммаОстатокКт, 0) > 0
	|	И докСпецификация.СуммаДокумента > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	докСпецификация.Срочный УБЫВ,
	|	докСпецификация.ДатаИзготовления";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		ЗаголовокТаблицы.Параметры.ЗаголовокТаблицы = "Не проведенные, но оплаченные спецификации";
		ТабДок.Вывести(ЗаголовокТаблицы);
		ТабДок.Вывести(СпецификацииНеПроведенныеШапка);
		НомерСтроки = 1;
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.Спецификация.Срочный
			 ИЛИ ?(ЗначениеЗаполнено(Выборка.ДатаМонтажа), Выборка.ДатаМонтажа < ТекущаяДата(), Ложь) Тогда
				ТекСтрока = Макет.ПолучитьОбласть("СпецификацииНеПроведенныеСтрокаКрасная");;
			Иначе
				ТекСтрока = Макет.ПолучитьОбласть("СпецификацииНеПроведенныеСтрока");
			КонецЕсли;
			
			ТекСтрока.Параметры.НомерСтроки = НомерСтроки;
			ЗаполнитьЗначенияСвойств(ТекСтрока.Параметры, Выборка);
			
			Если ЗначениеЗаполнено(Выборка.ПервичнаяДатаМонтажа) И (Выборка.ДатаМонтажа <> Выборка.ПервичнаяДатаМонтажа) Тогда
				 ТекСтрока.Параметры.ПереносМонтажа = "ПЕРЕНОС МОНТАЖА";
			КонецЕсли;
			
			ТекСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.Спецификация.Номер, "0");
			
			Если Выборка.ПакетУслуг = Перечисления.ПакетыУслуг.СамовывозОтПроизводителя Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D1);					 	
			КонецЕсли;
			
			Если НЕ Выборка.Упаковка Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D2);
			КонецЕсли;
			
			Если НЕ Выборка.Проверен Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D3);
			КонецЕсли;
			
			Если НЕ Выборка.ТребуетсяПроверка Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D4);
			КонецЕсли;
			
			ТабДок.Вывести(ТекСтрока);
			НомерСтроки = 1 + НомерСтроки;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции

Функция ВывестиРазмещенныеИНаПроверке(ТабДок, Макет, Подразделение)
	
	ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	Шапка = Макет.ПолучитьОбласть("СпецификацииНеПроведенныеШапка");
	Строка = Макет.ПолучитьОбласть("СпецификацииНеПроведенныеСтрока");
	СтрокаКрасная = Макет.ПолучитьОбласть("СпецификацииНеПроведенныеСтрокаКрасная");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	докСпецификация.Ссылка КАК Спецификация,
	|	докСпецификация.ДатаИзготовления КАК ДатаИзготовления,
	|	докСпецификация.Изделие КАК Изделие,
	|	докСпецификация.СуммаДокумента КАК СуммаДокумента,
	|	ВЫБОР
	|		КОГДА докСпецификация.АдресМонтажа <> ""Введите адрес""
	|			ТОГДА докСпецификация.АдресМонтажа
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Адрес,
	|	Статусы.Статус КАК Статус,
	|	докСпецификация.ДатаМонтажа КАК ДатаМонтажа,
	|	докСпецификация.ПакетУслуг КАК ПакетУслуг,
	|	докСпецификация.Упаковка КАК Упаковка,
	|	докСпецификация.ПервичнаяДатаМонтажа,
	|	докСпецификация.ТребуетсяПроверка КАК ТребуетсяПроверка,
	|	ЕСТЬNULL(Проверка.Проверен, ЛОЖЬ) КАК Проверен
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних(&ТекущаяДата, ) КАК Статусы
	|		ПО докСпецификация.Ссылка = Статусы.Спецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроверкаСпецификации.СрезПоследних КАК Проверка
	|		ПО докСпецификация.Ссылка = Проверка.Спецификация
	|ГДЕ
	|	докСпецификация.Подразделение = &Подразделение
	|	И (Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Проверяется)
	|			ИЛИ Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен)
	|			ИЛИ Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ОжиданиеМатериала))
	|
	|УПОРЯДОЧИТЬ ПО
	|	докСпецификация.Срочный УБЫВ,
	|	докСпецификация.ДатаИзготовления
	|ИТОГИ ПО
	|	Статус";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		ВыборкаСтатус = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Статус");
		
		Пока ВыборкаСтатус.Следующий() Цикл
			
			Если ВыборкаСтатус.Статус = Перечисления.СтатусыСпецификации.Проверяется Тогда
				ЗаголовокТаблицы.Параметры.ЗаголовокТаблицы = "Спецификации на проверке";
			ИначеЕсли ВыборкаСтатус.Статус = Перечисления.СтатусыСпецификации.Размещен Тогда 
				ЗаголовокТаблицы.Параметры.ЗаголовокТаблицы = "Размещенные спецификации";
			Иначе
				ЗаголовокТаблицы.Параметры.ЗаголовокТаблицы = "Ожидание материала";
			КонецЕсли;
			
			ТабДок.Вывести(ЗаголовокТаблицы);
			ТабДок.Вывести(Шапка);
			
			ВыборкаСпецификация = ВыборкаСтатус.Выбрать();
			
			НомерСтроки = 1;
			
			Пока ВыборкаСпецификация.Следующий() Цикл
				
				Если ВыборкаСпецификация.Спецификация.Срочный
				 ИЛИ ?(ЗначениеЗаполнено(ВыборкаСпецификация.ДатаМонтажа), ВыборкаСпецификация.ДатаМонтажа < ТекущаяДата(), Ложь) Тогда
					ТекСтрока = Макет.ПолучитьОбласть("СпецификацииНеПроведенныеСтрокаКрасная");
				Иначе
					ТекСтрока = Макет.ПолучитьОбласть("СпецификацииНеПроведенныеСтрока");
				КонецЕсли;
				
				ТекСтрока.Параметры.НомерСтроки = НомерСтроки;
				ТекСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(ВыборкаСпецификация.Спецификация.Номер, "0");
				ЗаполнитьЗначенияСвойств(ТекСтрока.Параметры, ВыборкаСпецификация);
				
				Если ЗначениеЗаполнено(ВыборкаСпецификация.ПервичнаяДатаМонтажа) И (ВыборкаСпецификация.ДатаМонтажа <> ВыборкаСпецификация.ПервичнаяДатаМонтажа) Тогда
					 ТекСтрока.Параметры.ПереносМонтажа = "ПЕРЕНОС МОНТАЖА";
				КонецЕсли;
				
				Если ВыборкаСпецификация.ПакетУслуг = Перечисления.ПакетыУслуг.СамовывозОтПроизводителя Тогда
					ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D1);					 	
				КонецЕсли;
				
				Если НЕ ВыборкаСпецификация.Упаковка Тогда
					ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D2);
				КонецЕсли;
				
				Если НЕ ВыборкаСпецификация.Проверен Тогда
					ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D3);
				КонецЕсли;
				
				Если НЕ ВыборкаСпецификация.ТребуетсяПроверка Тогда
					ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D4);
				КонецЕсли;
				
				ТабДок.Вывести(ТекСтрока);
				НомерСтроки = 1 + НомерСтроки;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции

Функция ВывестиПросроченноеИзготовление(ТабДок, Макет, Подразделение)
	
	СпецификацииШапка = Макет.ПолучитьОбласть("СпецификацииШапка");
	СпецификацииСтрока = Макет.ПолучитьОбласть("СпецификацииСтрока");
	СпецификацииСтрокаКрасная = Макет.ПолучитьОбласть("СпецификацииСтрокаКрасная");
	ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	Наряд = Макет.ПолучитьОбласть("Наряд");
	СтрокаЗаметка = Макет.ПолучитьОбласть("СтрокаЗаметка");
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДокСпецификация.Ссылка КАК Спецификация,
	|	ДокСпецификация.Номер КАК НомерСпецификации,
	|	ДокСпецификация.Изделие,
	|	ДокСпецификация.ДатаИзготовления КАК ДатаИзготовления,
	|	ДокСпецификация.Срочный,
	|	ДокСпецификация.ДатаОтгрузки,
	|	ДокСпецификация.ПакетУслуг КАК ПакетУслуг,
	|	ДокСпецификация.Упаковка КАК Упаковка,
	|	ДокСпецификация.ДатаМонтажа,
	|	ДокСпецификация.ПервичнаяДатаМонтажа,
	|	ДокСпецификация.АдресМонтажа КАК Адрес,
	|	НарядЗаданиеСписокСпецификаций.Ссылка КАК НарядЗадание,
	|	спрЗаметки.Ссылка КАК Заметка,
	|	ДокСпецификация.ТребуетсяПроверка КАК ТребуетсяПроверка,
	|	ЕСТЬNULL(Проверка.Проверен, ЛОЖЬ) КАК Проверен
	|ИЗ
	|	Документ.Спецификация КАК ДокСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО (СтатусСпецификацииСрезПоследних.Спецификация = ДокСпецификация.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Заметки КАК спрЗаметки
	|		ПО ДокСпецификация.Ссылка = спрЗаметки.Предмет
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НарядЗадание.СписокСпецификаций КАК НарядЗаданиеСписокСпецификаций
	|		ПО (НарядЗаданиеСписокСпецификаций.Спецификация = ДокСпецификация.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроверкаСпецификации.СрезПоследних КАК Проверка
	|		ПО ДокСпецификация.Ссылка = Проверка.Спецификация
	|ГДЕ
	|	СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ПереданВЦех)
	|	И ДокСпецификация.Подразделение = &Подразделение
	|
	|УПОРЯДОЧИТЬ ПО
	|	НарядЗаданиеСписокСпецификаций.Ссылка.Дата,
	|	ДокСпецификация.Срочный УБЫВ,
	|	ДатаИзготовления
	|ИТОГИ ПО
	|	НарядЗадание";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		
		ЗаголовокТаблицы.Параметры.ЗаголовокТаблицы = "Спецификации в цеху";
		ТабДок.Вывести(ЗаголовокТаблицы);
		ТабДок.Вывести(СпецификацииШапка);
		
		НомерСтроки = 1;
		
		ВыборкаНаряды = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаНаряды.Следующий() Цикл
			
			НомерНаряда = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаНаряды.НарядЗадание.Номер);
			ДатаИзготовления = Формат(ВыборкаНаряды.НарядЗадание.ДатаИзготовления, "ДЛФ=DD");
			СтрокаНаряда = "Наряд № %1 на %2";
			СтрокаНаряда = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаНаряда, НомерНаряда, ДатаИзготовления);
			Наряд.Параметры.НарядСсылка = ВыборкаНаряды.НарядЗадание;
			Наряд.Параметры.Наряд = СтрокаНаряда;
			ТабДок.Вывести(Наряд);
			
			Выборка = ВыборкаНаряды.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока Выборка.Следующий() Цикл
				
				Если Выборка.Срочный
				 ИЛИ ?(ЗначениеЗаполнено(Выборка.ДатаМонтажа), Выборка.ДатаМонтажа < ТекущаяДата(), Ложь) Тогда
					ТекСтрока = Макет.ПолучитьОбласть("СпецификацииСтрокаКрасная");
				Иначе
					ТекСтрока = Макет.ПолучитьОбласть("СпецификацииСтрока");
				КонецЕсли;
				
				ТекСтрока.Параметры.Заполнить(Выборка);
				
				Если ЗначениеЗаполнено(Выборка.ПервичнаяДатаМонтажа) И (Выборка.ДатаМонтажа <> Выборка.ПервичнаяДатаМонтажа) Тогда
					 ТекСтрока.Параметры.ПереносМонтажа = "ПЕРЕНОС МОНТАЖА";
				КонецЕсли;
				
				ТекСтрока.Параметры.НомерСтроки = НомерСтроки;
				ТекСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.НомерСпецификации, "0");
				ТекСтрока.Параметры.Спецификация = Выборка.Спецификация;
				
				Если Выборка.ПакетУслуг = Перечисления.ПакетыУслуг.СамовывозОтПроизводителя Тогда
					ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D1);					 	
				КонецЕсли;
				
				Если НЕ Выборка.Упаковка Тогда
					ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D2);
				КонецЕсли;
				
				Если НЕ Выборка.Проверен Тогда
					ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D3);
				КонецЕсли;
				
				Если НЕ Выборка.ТребуетсяПроверка Тогда
					ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D4);
				КонецЕсли;
				
				ТабДок.Вывести(ТекСтрока);
				
				Если ЗначениеЗаполнено(Выборка.Заметка) Тогда
				
					СтрокаЗаметка.Параметры.Заметка = Выборка.Заметка.ТекстСодержания;
					СтрокаЗаметка.Параметры.РасшифровкаЗаметка = Выборка.Заметка;
					СтрокаЗаметка.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.НомерСпецификации, "0");
					ТабДок.Вывести(СтрокаЗаметка);
					
				КонецЕсли;
				
				НомерСтроки = 1 + НомерСтроки;
				
			КонецЦикла; // выборка по спецификациям
			
		КонецЦикла; // выборка по нарядам
		
	КонецЕсли;
	
КонецФункции

Функция ВывестиИзделияНаСкладеГотовойПродукции(ТабДок, Макет, Подразделение)
	
	ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ИзделияНаСкладеШапка = Макет.ПолучитьОбласть("ИзделияНаСкладеШапка");
	ИзделияНаСкладеСтрока = Макет.ПолучитьОбласть("ИзделияНаСкладеСтрока");
	ИзделияНаСкладеСтрокаКрасная = Макет.ПолучитьОбласть("ИзделияНаСкладеСтрокаКрасная");
	СтрокаЗаметка = Макет.ПолучитьОбласть("СтрокаЗаметка");
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация) КАК Спецификация,
	|	ВЫБОР
	|		КОГДА ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация).АдресМонтажа <> ""Введите адрес""
	|			ТОГДА ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация).АдресМонтажа
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Адрес,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация).Контрагент КАК Контрагент,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация).Контрагент.Город КАК Город,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация).Изделие КАК Изделие,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация).Номер КАК Номер,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация).Срочный КАК Срочный,
	|	УправленческийОстатки.СуммаОстатокДт КАК СуммаДокумента,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация).ДатаОтгрузки КАК ДатаОтгрузки,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация).ПакетУслуг КАК ПакетУслуг,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация).Упаковка КАК Упаковка,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация).ДатаМонтажа КАК ДатаМонтажа,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация).ПервичнаяДатаМонтажа КАК ПервичнаяДатаМонтажа,
	|	спрЗаметки.Ссылка КАК Заметка,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация).ТребуетсяПроверка КАК ТребуетсяПроверка,
	|	ЕСТЬNULL(Проверка.Проверен, ЛОЖЬ) КАК Проверен
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.СкладГотовойПродукции), , Подразделение = &Подразделение) КАК УправленческийОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Заметки КАК спрЗаметки
	|		ПО УправленческийОстатки.Субконто1 = спрЗаметки.Предмет
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроверкаСпецификации.СрезПоследних КАК Проверка
	|		ПО УправленческийОстатки.Субконто1 = Проверка.Спецификация
	|
	|УПОРЯДОЧИТЬ ПО
	|	Срочный УБЫВ,
	|	ДатаОтгрузки
	|ИТОГИ
	|	СУММА(СуммаДокумента)
	|ПО
	|	ОБЩИЕ";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		ВыборкаИтоги = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		ВыборкаИтоги.Следующий();
		
		ЗаголовокТаблицы.Параметры.ЗаголовокТаблицы = "Изделия на складе готовой продукции на сумму " + ВыборкаИтоги.СуммаДокумента;
		ТабДок.Вывести(ЗаголовокТаблицы);
		ТабДок.Вывести(ИзделияНаСкладеШапка);
		
		НомерСтроки = 1;
		Выборка = ВыборкаИтоги.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.Срочный
			 ИЛИ ?(ЗначениеЗаполнено(Выборка.ДатаМонтажа), Выборка.ДатаМонтажа < ТекущаяДата(), Ложь) Тогда
				ТекСтрока = Макет.ПолучитьОбласть("ИзделияНаСкладеСтрокаКрасная");
			Иначе
				ТекСтрока = Макет.ПолучитьОбласть("ИзделияНаСкладеСтрока");
			КонецЕсли;
			
			ТекСтрока.Параметры.Заполнить(Выборка);
			
			Если ЗначениеЗаполнено(Выборка.Город) Тогда
				ТекСтрока.Параметры.Контрагент = Строка(Выборка.Город) + ", " + Выборка.Контрагент;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Выборка.ПервичнаяДатаМонтажа) И (Выборка.ДатаМонтажа <> Выборка.ПервичнаяДатаМонтажа) Тогда
				 ТекСтрока.Параметры.ПереносМонтажа = "ПЕРЕНОС МОНТАЖА";
			КонецЕсли;
			
			ТекСтрока.Параметры.НомерСтроки = НомерСтроки;
			ТекСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.Номер, "0");
			ТекСтрока.Параметры.Спецификация = Выборка.Спецификация;
			
			Если Выборка.ПакетУслуг = Перечисления.ПакетыУслуг.СамовывозОтПроизводителя Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D1);					 	
			КонецЕсли;
			
			Если НЕ Выборка.Упаковка Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D2);
			КонецЕсли;
			
			Если НЕ Выборка.Проверен Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D3);
			КонецЕсли;
			
			Если НЕ Выборка.ТребуетсяПроверка Тогда
				ТекСтрока.Рисунки.Удалить(ТекСтрока.Рисунки.D4);
			КонецЕсли;
			
			ТабДок.Вывести(ТекСтрока);
			
			НомерСтроки = 1 + НомерСтроки;
			
			Если ЗначениеЗаполнено(Выборка.Заметка) Тогда
				
				СтрокаЗаметка.Параметры.Заметка = Выборка.Заметка.ТекстСодержания;
				СтрокаЗаметка.Параметры.РасшифровкаЗаметка = Выборка.Заметка;
				СтрокаЗаметка.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.Спецификация.Номер, "0");
				ТабДок.Вывести(СтрокаЗаметка);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции
