﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДокументСсылка = ПараметрКоманды;
	
	Если РедактированиеЗапрещено(ДокументСсылка) Тогда
		 ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Редактирование наряда запрещено.");
		 Возврат;
	КонецЕсли;	
	
	Состояние("Формирование раскроя, это может занять длительное время");
	
	ОтменитьПроведениеНаряда(ДокументСсылка);
		
	ЗаполнитьОстатки(ДокументСсылка);

	Элемент = ОбновитьРаскройНаСервере(ДокументСсылка);
	
	ОтнятьОстатки(ДокументСсылка);
	
	Если Элемент <> Неопределено Тогда	
		ЗаписатьРаскрой(Элемент);
	КонецЕсли;
	
	ПерепровестиНаряд(ДокументСсылка);	
	
	Если ПараметрыВыполненияКоманды.Источник.ВладелецФормы <> Неопределено Тогда
		ПараметрыВыполненияКоманды.Источник.Прочитать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция РедактированиеЗапрещено(Наряд)
	
	Возврат Наряд.ЗапретРедактирования;
	
КонецФункции

&НаСервере
Процедура ОтменитьПроведениеНаряда(Наряд)
	
	НарядОб = Наряд.ПолучитьОбъект();
	НарядОб.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	
КонецПроцедуры


&НаСервере
Процедура ПерепровестиНаряд(Наряд)
	
	НарядОб = Наряд.ПолучитьОбъект();
	НарядОб.Дата = ТекущаяДата();
	НарядОб.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры

&НаСервере
Функция ОбновитьРаскройНаСервере(НарядЗадание)
	
	Структура = РегистрыСведений.РаскройДеталей.СформироватьРаскрой(НарядЗадание);
	
	Если Структура <> Неопределено Тогда
	
		СтруктураПередачи = Новый Структура;
		СтруктураПередачи.Вставить("СтрокаКривогоПилаФРС", Структура.СтрокаКривогоПилаФРС);
		СтруктураПередачи.Вставить("СтрокаКривогоПилаСтеколка", Структура.СтрокаКривогоПилаСтеколка);
		СтруктураПередачи.Вставить("ТекущаяСтрокаРаскроя", Структура.ДанныеДляРаскроя);
		СтруктураПередачи.Вставить("СтрокаРаскрой", Структура.ДанныеДляРаскроя);
		СтруктураПередачи.Вставить("ТаблицаДеталей", Структура.ТаблицаДеталей);
		СтруктураПередачи.Вставить("КоличествоДеталей", Структура.КоличествоДеталей);
		СтруктураПередачи.Вставить("СтрокаPTX", Структура.СтрокаPTX);
		
		Попытка
			СтруктураПередачи.Вставить("ЛучшийПроцентОтхода", Структура.ЛучшийПроцентОтхода);
			СтруктураПередачи.Вставить("ВремяФормирования", Структура.ВремяФормирования);
		Исключение
			
		КонецПопытки;
		
		СтруктураПередачи.Вставить("АлгоритмРаскроя", Структура.АлгоритмРаскроя);
		СтруктураПередачи.Вставить("НарядЗадание", НарядЗадание);
		СтруктураПередачи.Вставить("РисунокКривогоПилаФРС", "");
		СтруктураПередачи.Вставить("РисунокКривогоПилаСтеколка", "");
		СтруктураПередачи.Вставить("РисунокРаскроя", "");
		ОбъектНарядЗадание = НарядЗадание.ПолучитьОбъект();
		
		ЗаполнитьЛистовойМатериал(ОбъектНарядЗадание,Структура.ТаблицаЛистовНоменклатуры);

		ОбъектНарядЗадание.ОстаткиЛистовогоМатериала.Загрузить(ОбновитьТЧ(ОбъектНарядЗадание.ОстаткиЛистовогоМатериала.Выгрузить(), Структура.МассивНомеровИспользуемыхОстатков));
		ОбъектНарядЗадание.ДополнительныеСвойства.Вставить("НеОчищатьСтрокуРаскроя", Истина);
		ОбъектНарядЗадание.Записать();
		
	Иначе
		
		СтруктураПередачи = Неопределено;
		
	КонецЕсли;
	
	Возврат СтруктураПередачи;
	
КонецФункции

&НаСервере
Функция ОбновитьТЧ(ТЧ, МассивНомеровСтрок)
	
	ОставшиесяСтроки = ТЧ.СкопироватьКолонки();
	
	Для  каждого СтрокаТЧ Из ТЧ Цикл
		Если МассивНомеровСтрок.Найти(СтрокаТЧ.НомерСтроки) <> Неопределено Тогда
			НоваяСтрока = ОставшиесяСтроки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		КонецЕсли;
	КонецЦикла;
	
Возврат  ОставшиесяСтроки;

КонецФункции

&НаСервере
Функция ЗаписатьРаскрой(Элемент)
	
	НаборЗаписей = РегистрыСведений.РаскройДеталей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Элемент.НарядЗадание);
	
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 1 Тогда
		Запись = НаборЗаписей[0];
	Иначе
		Запись = НаборЗаписей.Добавить();
		Запись.Объект = Элемент.НарядЗадание;
	КонецЕсли;
	
	Запись.СтрокаРаскрой = Элемент.СтрокаРаскрой;
	Запись.ТекущаяСтрокаРаскроя = Элемент.ТекущаяСтрокаРаскроя;	
	Запись.РисунокРаскроя = Элемент.РисунокРаскроя;
	
	Запись.РисунокКривогоПилаФРС = Элемент.РисунокКривогоПилаФРС;
	Запись.РисунокКривогоПилаСтеколка = Элемент.РисунокКривогоПилаСтеколка;
	
	Запись.СтрокаКривогоПилаФРС = Элемент.СтрокаКривогоПилаФРС;
	Запись.СтрокаКривогоПилаСтеколка = Элемент.СтрокаКривогоПилаСтеколка;
	
	Запись.КоличествоДеталей = Элемент.КоличествоДеталей;
	
	Запись.СтрокаPTX = Элемент.СтрокаPTX;
	
	Попытка
		Запись.ИдеальныйПроцентОтхода = Элемент.ЛучшийПроцентОтхода;
		Запись.ВремяФормирования = Элемент.ВремяФормирования;
	Исключение
		
	КонецПопытки;
	
	Запись.ТаблицаДеталей = Элемент.ТаблицаДеталей;
	Запись.АлгоритмРаскроя = Элемент.АлгоритмРаскроя;
	
	НаборЗаписей.Записать();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьОстатки(Наряд)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Наряд", Наряд);
	Запрос.УстановитьПараметр("СписокСпецификаций", Наряд.СписокСпецификаций.ВыгрузитьКолонку("Спецификация"));
	Запрос.УстановитьПараметр("Подразделение", Наряд.Подразделение);
	Запрос.УстановитьПараметр("тзНоменклатура", Наряд.СписокНоменклатуры.Выгрузить(, "Номенклатура"));
	Запрос.УстановитьПараметр("ВидМатериала", Перечисления.ВидыМатериалов.Листовой);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура
	|ПОМЕСТИТЬ втНоменклатура
	|ИЗ
	|	Документ.НарядЗадание.СписокНоменклатуры КАК Список
	|ГДЕ
	|	Список.Ссылка = &Наряд
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНоменклатура.Номенклатура
	|ПОМЕСТИТЬ втИспользуемаяНоменклатура
	|ИЗ
	|	втНоменклатура КАК втНоменклатура
	|ГДЕ
	|	втНоменклатура.Номенклатура.НоменклатурнаяГруппа.ВидМатериала = &ВидМатериала
	|
	|СГРУППИРОВАТЬ ПО
	|	втНоменклатура.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Обрезки.Номенклатура КАК Номенклатура,
	|	Обрезки.Высота КАК ВысотаОстатка,
	|	Обрезки.Ширина КАК ШиринаОстатка,
	|	Обрезки.КоличествоОстаток КАК Количество,
	|	0 КАК КоличествоРезерв,
	|	ЗНАЧЕНИЕ(Документ.Спецификация.ПустаяСсылка) КАК Спецификация
	|ИЗ
	|	РегистрНакопления.ОбрезкиЛистовойМатериал.Остатки(
	|			,
	|			Подразделение = &Подразделение
	|				И Номенклатура В
	|					(ВЫБРАТЬ
	|						Ном.Номенклатура
	|					ИЗ
	|						втИспользуемаяНоменклатура КАК Ном)) КАК Обрезки
	|ГДЕ
	|	Обрезки.КоличествоОстаток > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОбрезкиРезерв.Номенклатура,
	|	ОбрезкиРезерв.Высота,
	|	ОбрезкиРезерв.Ширина,
	|	0,
	|	ОбрезкиРезерв.КоличествоРезервОстаток,
	|	ОбрезкиРезерв.Спецификация
	|ИЗ
	|	РегистрНакопления.ОбрезкиЛистовойМатериал.Остатки(
	|			,
	|			Подразделение = &Подразделение
	|				И Спецификация В (&СписокСпецификаций)) КАК ОбрезкиРезерв
	|ГДЕ
	|	ОбрезкиРезерв.КоличествоРезервОстаток > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	ВысотаОстатка";
	
	Результат = Запрос.Выполнить();
	
	НарядОбъект = Наряд.ПолучитьОбъект();
	НарядОбъект.ОстаткиЛистовогоМатериала.Очистить();
	
	Если НЕ Результат.Пустой() Тогда
		
		ТаблицаИсключаемых = НарядОбъект.СписокИсключаемыхОстатков.Выгрузить(); 
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
	
			Отбор = Новый Структура;
			Отбор.Вставить("Номенклатура", Выборка.Номенклатура);
			Отбор.Вставить("Высота", Выборка.ВысотаОстатка);
			Отбор.Вставить("Ширина", Выборка.ШиринаОстатка);
			Отбор.Вставить("Резерв", Выборка.Спецификация);
			
			Мас = Новый Массив();
			Мас.Добавить(Выборка.Количество);
			Мас.Добавить(Выборка.КоличествоРезерв);
			
			Для Каждого Количество ИЗ Мас Цикл
			
				Кол = 0;
				
				Пока Кол < Количество Цикл
					
					МассивИсключаемых = ТаблицаИсключаемых.НайтиСтроки(Отбор);
					
					Если МассивИсключаемых.Количество() = 0 Тогда
					
						Строка = НарядОбъект.ОстаткиЛистовогоМатериала.Добавить();
						
						Строка.Номенклатура = Выборка.Номенклатура; 
						Строка.ВысотаОстатка = Выборка.ВысотаОстатка;
						Строка.ШиринаОстатка = Выборка.ШиринаОстатка;

					Иначе
						
						ТаблицаИсключаемых.Удалить(МассивИсключаемых[0]);
						
					КонецЕсли;
					
					Кол = Кол + 1;
					
				КонецЦикла;
				
			КонецЦикла;
					
		КонецЦикла;
		
	КонецЕсли;
	
	НарядОбъект.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ОтнятьОстатки(Наряд)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Наряд", Наряд);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(ВЫРАЗИТЬ(Остатки.ВысотаОстатка * Остатки.ШиринаОстатка / (1000 * 1000) КАК ЧИСЛО(15, 3))) КАК Количество,
	|	Остатки.Номенклатура
	|ПОМЕСТИТЬ втОстатки
	|ИЗ
	|	Документ.НарядЗадание.ОстаткиЛистовогоМатериала КАК Остатки
	|ГДЕ
	|	Остатки.Ссылка = &Наряд
	|
	|СГРУППИРОВАТЬ ПО
	|	Остатки.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Список.Номенклатура КАК Номенклатура,
	|	Список.КоличествоНачальное КАК КоличествоНачальное,
	|	Список.КоличествоНачальное - ЕСТЬNULL(Остатки.Количество, 0) КАК КоличествоТребуется
	|ИЗ
	|	Документ.НарядЗадание.СписокНоменклатуры КАК Список
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстатки КАК Остатки
	|		ПО Список.Номенклатура = Остатки.Номенклатура
	|ГДЕ
	|	Список.Ссылка = &Наряд
	|	И Список.КоличествоНачальное - ЕСТЬNULL(Остатки.Количество, 0) > 0";
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	НарядОбъект = Наряд.ПолучитьОбъект();
	НарядОбъект.СписокНоменклатуры.Очистить();
	НарядОбъект.СписокНоменклатуры.Загрузить(ТЗ);
	
	НарядОбъект.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЛистовойМатериал(Объект, Таблица)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокИзРаскроя", Таблица);
	Запрос.УстановитьПараметр("СписокИзНаряда", Объект.СписокЛистовНоменклатуры.Выгрузить());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	рСписок.Номенклатура КАК Номенклатура,
	|	рСписок.Количество КАК Количество
	|ПОМЕСТИТЬ втСписокРаскрой
	|ИЗ
	|	&СписокИзРаскроя КАК рСписок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	нСписок.Номенклатура КАК Номенклатура,
	|	нСписок.Количество КАК Количество,
	|	нСписок.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ втСписокНаряд
	|ИЗ
	|	&СписокИзНаряда КАК нСписок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	рНом.Номенклатура КАК Номенклатура,
	|	рНом.Количество КАК Количество,
	|	ЕСТЬNULL(нНом.НомерСтроки, 0) КАК НомерСтроки
	|ИЗ
	|	втСписокРаскрой КАК рНом
	|		ЛЕВОЕ СОЕДИНЕНИЕ втСписокНаряд КАК нНом
	|		ПО рНом.Номенклатура = нНом.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЕСТЬNULL(нНом.НомерСтроки, 0)";
	
	Объект.СписокЛистовНоменклатуры.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры
