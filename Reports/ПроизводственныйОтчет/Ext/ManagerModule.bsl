﻿
Функция ВывестиПроизводственныйОтчет(ТабДок, Подразделение, Разделы) Экспорт
	
	Макет = ПолучитьМакет("МакетПроизводственныйОтчет");
	
	ВывестиШапкуОтчета(ТабДок, Макет, Подразделение);
	
	Если Разделы.НеПроведенныеНоОплаченные Тогда
		ВывестиНеПроведенныеНоОплаченные(ТабДок, Макет, Подразделение);
	КонецЕсли;
	
	Если Разделы.РасчетыИнженеров Тогда
		ВывестиРасчетыИнженеров(ТабДок, Макет, Подразделение);
	КонецЕсли;
	
	Если Разделы.РазмещенныеИНаПроверке Тогда
		ВывестиРазмещенныеИНаПроверке(ТабДок, Макет, Подразделение);
	КонецЕсли;
	
	Если Разделы.ПросроченноеИзготовление Тогда
		ВывестиПросроченноеИзготовление(ТабДок, Макет, Подразделение);
	КонецЕсли;
	
	Если Разделы.ИзделияНаСкладеГотовойПродукции Тогда
		ВывестиИзделияНаСкладеГотовойПродукции(ТабДок, Макет, Подразделение);
	КонецЕсли;
	
КонецФункции

Функция ЕстьКомплектации(СпецификацияСсылка)
	
	Результат = Новый Структура("Цех, Склад", Ложь, Ложь);
	
	Для каждого Строка Из СпецификацияСсылка.СкладГотовойПродукции Цикл
		
		Если Строка.КоличествоЦех > 0 Тогда
			Результат.Цех = Истина;
		КонецЕсли;
		
		Если Строка.КоличествоСклад > 0 Тогда
			Результат.Склад = Истина;
		КонецЕсли;
		
		Если Результат.Склад И Результат.Цех Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПосчитатьКоличествоДверей(СпецификацияСсылка)
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета="дверь, двери, двери, ж, копейка, копейки, копеек, ж, 0";
	
	КоличествоДверейПрописью = "";
	КоличествоДверей = 0;
	Для каждого СтрокаДверь Из СпецификацияСсылка.СписокДверей Цикл
		КоличествоДверей = КоличествоДверей + СтрокаДверь.Двери.Количество;
	КонецЦикла;
	
	Если КоличествоДверей > 0 Тогда
		КоличествоДверейПрописью = ЧислоПрописью(КоличествоДверей, ФормСтрока, ПарПредмета);
	КонецЕсли;
	
	Возврат КоличествоДверейПрописью ;
	
КонецФункции

Функция ВывестиШапкуОтчета(ТабДок, Макет, Подразделение)
	
	ШапкаОтчета = Макет.ПолучитьОбласть("ШапкаОтчета");
	ШапкаОтчета.Параметры.Дата = Формат(ТекущаяДата(),"ДЛФ=DT");
	ШапкаОтчета.Параметры.Подразделение = Подразделение;
	ТабДок.Вывести(ШапкаОтчета);
	
КонецФункции

Функция ВывестиРасчетыИнженеров(ТабДок, Макет, Подразделение)
	
	ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	РасчетыШапка = Макет.ПолучитьОбласть("РасчетыШапка");
	РасчетыСтрока = Макет.ПолучитьОбласть("РасчетыСтрока");
	РасчетыСтрокаКрасная = Макет.ПолучитьОбласть("РасчетыСтрокаКрасная");
	
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
	|	Заметки.ТекстСодержания КАК Заметка,
	|	СтатусСпецификацииСрезПоследних.Спецификация.Офис КАК Офис,
	|	РАЗНОСТЬДАТ(НАЧАЛОПЕРИОДА(&ТекущаяДата, ДЕНЬ), НАЧАЛОПЕРИОДА(СтатусСпецификацииСрезПоследних.Спецификация.ДатаОтгрузки, ДЕНЬ), ДЕНЬ) КАК ДнейДоОтгрузки
	|ИЗ
	|	РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК Договор
	|		ПО СтатусСпецификацииСрезПоследних.Спецификация = Договор.Спецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Заметки КАК Заметки
	|		ПО СтатусСпецификацииСрезПоследних.Спецификация = Заметки.Предмет
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
			
			Если Выборка.ДнейДоОтгрузки < 1 Тогда
				ТекСтрока = РасчетыСтрокаКрасная;
			Иначе
				ТекСтрока = РасчетыСтрока;
			КонецЕсли;
			
			ТекСтрока.Параметры.НомерСтроки = НомерСтроки;
			ЗаполнитьЗначенияСвойств(ТекСтрока.Параметры, Выборка);
			ТекСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.Спецификация.Номер, "0");
			
			ТабДок.Вывести(ТекСтрока);
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
	|	ЕСТЬNULL(Остатки.СуммаОстатокКт, 0) КАК Сумма
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(&ТекущаяДата, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ВзаиморасчетыСПокупателями), , Подразделение = &Подразделение) КАК Остатки
	|		ПО (Остатки.Субконто2 = докСпецификация.Ссылка)
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
			
			Если Выборка.Спецификация.Срочный Тогда
				ТекСтрока = СпецификацииНеПроведенныеСтрокаКрасная;
			Иначе
				ТекСтрока = СпецификацииНеПроведенныеСтрока;
			КонецЕсли;
			
			ТекСтрока.Параметры.НомерСтроки = НомерСтроки;
			ЗаполнитьЗначенияСвойств(ТекСтрока.Параметры, Выборка);
			ТекСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.Спецификация.Номер, "0");
			
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
	|	Статусы.Статус КАК Статус
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних(&ТекущаяДата, ) КАК Статусы
	|		ПО докСпецификация.Ссылка = Статусы.Спецификация
	|ГДЕ
	|	докСпецификация.Подразделение = &Подразделение
	|	И (Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Проверяется)
	|			ИЛИ Статусы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен))
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
			Иначе
				ЗаголовокТаблицы.Параметры.ЗаголовокТаблицы = "Размещенные спецификации";
			КонецЕсли;
			
			ТабДок.Вывести(ЗаголовокТаблицы);
			ТабДок.Вывести(Шапка);
			
			ВыборкаСпецификация = ВыборкаСтатус.Выбрать();
			
			НомерСтроки = 1;
			
			Пока ВыборкаСпецификация.Следующий() Цикл
				
				Если ВыборкаСпецификация.Спецификация.Срочный Тогда
					ТекСтрока = СтрокаКрасная;
				Иначе
					ТекСтрока = Строка;
				КонецЕсли;
				
				ТекСтрока.Параметры.НомерСтроки = НомерСтроки;
				ТекСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(ВыборкаСпецификация.Спецификация.Номер, "0");
				ЗаполнитьЗначенияСвойств(ТекСтрока.Параметры, ВыборкаСпецификация);
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
	|	ДокСпецификация.СуммаНарядаСпецификации КАК СуммаНаряда,
	|	ДокСпецификация.ДатаОтгрузки,
	|	ДокСпецификация.Упаковка,
	|	НарядЗаданиеСписокСпецификаций.Ссылка КАК НарядЗадание,
	|	спрЗаметки.ТекстСодержания КАК Заметка,
	|	ВЫБОР
	|		КОГДА Комплект.Ссылка ЕСТЬ NULL
	|				ИЛИ НЕ Комплект.Проведен
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЕстьПроведеннаяКомплектация
	|ИЗ
	|	Документ.Спецификация КАК ДокСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО (СтатусСпецификацииСрезПоследних.Спецификация = ДокСпецификация.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Заметки КАК спрЗаметки
	|		ПО ДокСпецификация.Ссылка = спрЗаметки.Предмет
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НарядЗадание.СписокСпецификаций КАК НарядЗаданиеСписокСпецификаций
	|		ПО (НарядЗаданиеСписокСпецификаций.Спецификация = ДокСпецификация.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Комплектация КАК Комплект
	|		ПО (Комплект.Спецификация = ДокСпецификация.Ссылка)
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
				
				Если Выборка.Срочный Тогда
					ТекСтрока = СпецификацииСтрокаКрасная;
				Иначе
					ТекСтрока = СпецификацииСтрока;
				КонецЕсли;
				
				ТекСтрока.Параметры.Заполнить(Выборка);
				ТекСтрока.Параметры.Изделие = Выборка.Изделие;
				ТекСтрока.Параметры.НомерСтроки = НомерСтроки;
				ТекСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.НомерСпецификации, "0");
				ТекСтрока.Параметры.КоличествоДверей = ПосчитатьКоличествоДверей(Выборка.Спецификация);
				ТекСтрока.Параметры.Спецификация = Выборка.Спецификация;
				
				Комплектации = ЕстьКомплектации(Выборка.Спецификация);
				ТекСтрока.Параметры.КомплектацияЦех = Комплектации.Цех;
				ТекСтрока.Параметры.КомплектацияСклад = Комплектации.Склад;
				
				ТабДок.Вывести(ТекСтрока);
				
				Если ЗначениеЗаполнено(Выборка.Заметка) Тогда
					
					СтрокаЗаметка.Параметры.Заметка = Выборка.Заметка;
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
	|	спрЗаметки.ТекстСодержания КАК Заметка
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.СкладГотовойПродукции), , Подразделение = &Подразделение) КАК УправленческийОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Заметки КАК спрЗаметки
	|		ПО УправленческийОстатки.Субконто1 = спрЗаметки.Предмет
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
			
			Если Выборка.Срочный Тогда
				ТекСтрока = ИзделияНаСкладеСтрокаКрасная;
			Иначе
				ТекСтрока = ИзделияНаСкладеСтрока;
			КонецЕсли;
			
			ТекСтрока.Параметры.Заполнить(Выборка);
			
			Если ЗначениеЗаполнено(Выборка.Город) Тогда
				ТекСтрока.Параметры.Контрагент = Строка(Выборка.Город) + ", " + Выборка.Контрагент;
			КонецЕсли;
			
			ТекСтрока.Параметры.НомерСтроки = НомерСтроки;
			ТекСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.Номер, "0");
			ТекСтрока.Параметры.ЕстьДоставка = Выборка.ПакетУслуг <> Перечисления.ПакетыУслуг.СамовывозОтПроизводителя;
			ТекСтрока.Параметры.Спецификация = Выборка.Спецификация;
			
			ТабДок.Вывести(ТекСтрока);
			
			НомерСтроки = 1 + НомерСтроки;
			
			Если ЗначениеЗаполнено(Выборка.Заметка) Тогда
				
				СтрокаЗаметка.Параметры.Заметка = Выборка.Заметка;
				СтрокаЗаметка.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.Номер, "0");
				ТабДок.Вывести(СтрокаЗаметка);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции
