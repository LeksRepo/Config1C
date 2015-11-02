﻿
#Область Общего_назначения

&НаКлиентеНаСервереБезКонтекста
Функция ДомножитьДоЦелого(фЧисло)
	
	Пока фЧисло % 1 <> 0 Цикл
		
		фЧисло = фЧисло * 10;
		
	КонецЦикла;
	
	Возврат фЧисло;
	
КонецФункции

// Фильтрует хлыстовой материал и группирует номенклатуру.
//
// Параметры
//  тзНоменклатура  - ТаблицаЗначений - таблица с отобранной номенклатурой
//                 из спецификаций
// Возвращаемое значение:
//   ТаблицаЗначений   - таблица для загрузки в СписокНоменклатуры
&НаСервере
Функция ПолучитьСписокНоменклатуры(тзНоменклатура)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("тзНоменклатура", тзНоменклатура);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(тзНоменклатура.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	тзНоменклатура.Количество,
	|	тзНоменклатура.ПредоставитЗаказчик
	|ПОМЕСТИТЬ втНоменклатура
	|ИЗ
	|	&тзНоменклатура КАК тзНоменклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНоменклатура.Номенклатура,
	|	СУММА(втНоменклатура.Количество) КАК КоличествоТребуется
	|ИЗ
	|	втНоменклатура КАК втНоменклатура
	|ГДЕ
	|	НЕ втНоменклатура.ПредоставитЗаказчик
	|	И втНоменклатура.Номенклатура.НоменклатурнаяГруппа.ВидМатериала <> ЗНАЧЕНИЕ(Перечисление.ВидыМатериалов.Хлыстовой)
	|
	|СГРУППИРОВАТЬ ПО
	|	втНоменклатура.Номенклатура";
	
	тзРезультат = Запрос.Выполнить().Выгрузить();
	
	Возврат тзРезультат;
	
КонецФункции

&НаСервере
Функция ПолучитьТЗНоменклатуры(МассивСпецификаций)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификация", МассивСпецификаций);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпецификацияСписокНоменклатуры.Ссылка КАК Спецификация,
	|	СпецификацияСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СУММА(ВЫБОР
	|			КОГДА СпецификацияСписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа.ВидМатериала = ЗНАЧЕНИЕ(Перечисление.ВидыМатериалов.Хлыстовой)
	|				ТОГДА СпецификацияСписокНоменклатуры.КоличествоТребуется
	|			ИНАЧЕ СпецификацияСписокНоменклатуры.Количество
	|		КОНЕЦ) КАК Количество,
	|	СпецификацияСписокНоменклатуры.ПредоставитЗаказчик
	|ПОМЕСТИТЬ втДанные
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В(&МассивСпецификация)
	|	И НЕ СпецификацияСписокНоменклатуры.ЧерезСклад
	|	И СпецификацияСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Номенклатура,
	|	СпецификацияСписокНоменклатуры.Ссылка,
	|	ВЫБОР
	|		КОГДА СпецификацияСписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа.ВидМатериала = ЗНАЧЕНИЕ(Перечисление.ВидыМатериалов.Хлыстовой)
	|			ТОГДА СпецификацияСписокНоменклатуры.НомерСтроки
	|		ИНАЧЕ 0
	|	КОНЕЦ,
	|	СпецификацияСписокНоменклатуры.ПредоставитЗаказчик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втДанные.Номенклатура
	|ИЗ
	|	втДанные КАК втДанные
	|ГДЕ
	|	втДанные.Номенклатура.НоменклатурнаяГруппа.ВидМатериала = ЗНАЧЕНИЕ(Перечисление.ВидыМатериалов.Хлыстовой)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанные.Спецификация,
	|	втДанные.Номенклатура,
	|	втДанные.Количество,
	|	втДанные.ПредоставитЗаказчик
	|ИЗ
	|	втДанные КАК втДанные
	|ГДЕ
	|	втДанные.Количество > 0";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Ответ = Новый Структура;
	Ответ.Вставить("тзХлыстовойМатериал", РезультатЗапроса[1].Выгрузить());
	Ответ.Вставить("тзНоменклатура", РезультатЗапроса[2].Выгрузить());
	
	Возврат Ответ;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьСпецификации(АдресТаблицы)
	
	Если ЭтоАдресВременногоХранилища(АдресТаблицы) Тогда
		ТЗ = ПолучитьИзВременногоХранилища(АдресТаблицы);
		Объект.СписокСпецификаций.Загрузить(ТЗ);
		ЗаполнитьНоменклатуройСервер();
		ПроверитьНаличиеКомплектаций(Объект.СписокСпецификаций.Выгрузить().ВыгрузитьКолонку("Спецификация"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область События_формы

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПроверитьНаличиеКомплектаций(Объект.СписокСпецификаций.Выгрузить().ВыгрузитьКолонку("Спецификация"));
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	ПроверитьНаличиеКомплектаций(Объект.СписокСпецификаций.Выгрузить().ВыгрузитьКолонку("Спецификация"));
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура ВыбратьСпецификации(Команда)
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Текст = "Табличные части будут изменены." + Символы.ПС + "Продолжить?" ;
	
	Если Объект.СписокСпецификаций.Количество() > 0 
		И Вопрос(Текст, Режим, 0) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ПаараметрыФормы = Новый Структура;
	ПаараметрыФормы.Вставить("Подразделение", Объект.Подразделение);
	ПаараметрыФормы.Вставить("ТЗ", Объект.СписокСпецификаций);
	ПаараметрыФормы.Вставить("Статус", ПредопределенноеЗначение("Перечисление.СтатусыСпецификации.Размещен"));
	ПаараметрыФормы.Вставить("УпорядочитьПоДате", Истина);
	
	АдресТаблицы = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораСпецификации", ПаараметрыФормы, ЭтаФорма);
	Если АдресТаблицы <> Неопределено Тогда
		ПоказатьОповещениеПользователя("Номенклатуры перезаполнена",, "Изменился список спецификаций, табличная часть номенклатуры сформирована заново");
		ЗагрузитьСпецификации(АдресТаблицы);
		ЗаполнитьНоменклатуру(Команда);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНоменклатуру(Команда)
	
	ЗаполнитьНоменклатуройСервер();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНоменклатуройСервер() Экспорт
	
	ТаблицаСпецификаций = Объект.СписокСпецификаций.Выгрузить();
	МассивСпецификаций = ТаблицаСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	Таблицы = ПолучитьТЗНоменклатуры(МассивСпецификаций);
	Объект.СписокНоменклатурыПоСпецификациям.Загрузить(Таблицы.тзНоменклатура);
	Объект.СписокХлыстовыхМатериалов.Загрузить(Таблицы.тзХлыстовойМатериал);
	
	тзНоменклатураОстатки = ПолучитьСписокНоменклатуры(Таблицы.тзНоменклатура);
	Объект.СписокНоменклатуры.Загрузить(тзНоменклатураОстатки);
	
	ПерекроитьВесьХлыстовойМатериал();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьРаскройНаХлысты(Команда)
	
	ТекущиеДанные = Элементы.СписокХлыстовыхМатериалов.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ПерекроитьХлысты(ТекущиеДанные.Номенклатура, Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Таблица_СписокНоменклатуры

&НаКлиенте
Процедура СписокНоменклатурыПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		
		Номенклатура = Элемент.ТекущиеДанные.Номенклатура;
		СвойстваНоменклатуры = ЛексСервер.ЗначенияРеквизитовОбъекта(Номенклатура, "Базовый, БазоваяНоменклатура");
		Если НЕ СвойстваНоменклатуры.Базовый Тогда
			Номенклатура = СвойстваНоменклатуры.БазоваяНоменклатура;
		КонецЕсли;
		
		ОтборСтруктура = Новый Структура;
		
		Если ЗначениеЗаполнено(Номенклатура) Тогда
			ОтборСтруктура.Вставить("Номенклатура", Номенклатура);
		Иначе
			ОтборСтруктура.Вставить("Номенклатура", ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
		КонецЕсли;
		
		ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтруктура);
		Элементы.СписокНоменклатурыПоСпецификациям.ОтборСтрок = ОтборСтрок;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область Таблица_СписокСпецификаций

&НаКлиенте
Процедура СписокСпецификацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.СписокСпецификаций.ТекущиеДанные.Спецификация);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСпецификацийОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ДокументСсылка.Спецификация") Тогда
		
		ПроверитьНаличиеКомплектаций(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСпецификацийСпецификацияПриИзменении(Элемент)
	
	Элементы.СписокСпецификаций.ТекущиеДанные.ОсобыеУслуги = ЛексСервер.ЗначенияРеквизитовОбъекта(Элементы.СписокСпецификаций.ТекущиеДанные.Спецификация, "ОсобыеУслуги").ОсобыеУслуги;
	ПроверитьНаличиеКомплектаций(Элементы.СписокСпецификаций.ТекущиеДанные.Спецификация);
	
КонецПроцедуры

#КонецОбласти

#Область Таблица_СписокНоменклатурыПоСпецификациям

&НаКлиенте
Процедура СписокНоменклатурыПоСпецификациямПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПоСпецификациямПередУдалением(Элемент, Отказ)
	
	Октаз = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПоСпецификациямВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СписокНоменклатурыПоСпецификациям.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ОткрытьЗначение(ТекущиеДанные.Спецификация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Хлыстовой_раскрой

&НаСервере
Функция ОпределитьКоличествоХлыстовогоМатериала(Номенклатура, тзОстатки = Неопределено)
	
	// Заполненная кладовщиком таблица с обрезками хлыстов
	Если тзОстатки = Неопределено Тогда
		тзОстатки = Новый ТаблицаЗначений;
		тзОстатки.Колонки.Добавить("Количество");
	КонецЕсли;
	
	тзОстатки.Сортировать("Количество Возр");
	
	// Для хранения используемых целых хлыстов и обрезков
	тзИспользуемыеХлысты = Новый ТаблицаЗначений;
	тзИспользуемыеХлысты.Колонки.Добавить("Количество");
	
	// Определение размеров хлыста, кратности
	ОсновнаяПоСкладу = ЛексСервер.ПолучитьОсновнуюПоСкладу(Объект.Подразделение, Номенклатура);
	
	ДлинаХлыста = ОсновнаяПоСкладу.КоэффициентБазовых; // Тут вопрос. Брать коэффициент или длину.
	РазмерЦелогоХлыста = ДлинаХлыста * 1000; // И да простит меня Аллах за такое упрощение.
	
	// Сбор отрезков хлыстового материала
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Номенклатура", Номенклатура);
	СтрокиДеталей = Объект.СписокНоменклатурыПоСпецификациям.НайтиСтроки(ПараметрыОтбора);
	
	МассивДеталей = Новый Массив;
	
	тзДетали = Новый ТаблицаЗначений;
	тзДетали.Колонки.Добавить("Спецификация");
	тзДетали.Колонки.Добавить("РазмерОтрезка");
	
	Для каждого Деталь Из СтрокиДеталей Цикл
		
		// { Васильев Александр Леонидович [30.10.2015]
		// Сделать.
		// После установки контроля на размеры в спецификации
		// удалить разбиение детали больше хлыста.
		// } Васильев Александр Леонидович [30.10.2015]
		
		Если Деталь.Количество > ДлинаХлыста Тогда
			
			КоличествоХлыстов = Цел(Деталь.Количество / ДлинаХлыста);
			Для ъ = 1 По КоличествоХлыстов Цикл
				
				НоваяСтрока = тзДетали.Добавить();
				НоваяСтрока.Спецификация = Деталь.Спецификация;
				НоваяСтрока.РазмерОтрезка = ДлинаХлыста;
				
			КонецЦикла;
			
			НоваяСтрока = тзДетали.Добавить();
			НоваяСтрока.Спецификация = Деталь.Спецификация;
			НоваяСтрока.РазмерОтрезка = (Деталь.Количество % ДлинаХлыста) * 1000;
			
		Иначе
			
			НоваяСтрока = тзДетали.Добавить();
			НоваяСтрока.Спецификация = Деталь.Спецификация;
			НоваяСтрока.РазмерОтрезка = Деталь.Количество * 1000;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Распределение отрезков на хлыстах
	НомерХлыста = 1;
	НомерОстатка = 0;
	
	МассивОстатков = Объект.ОстаткиХлыстов.НайтиСтроки(ПараметрыОтбора);
	КоличествоОстатков = МассивОстатков.Количество();
	
	МассивДеталей = тзДетали.ВыгрузитьКолонку("РазмерОтрезка");
	
	Пока МассивДеталей.Количество() > 0 Цикл
		
		// Сначала формируем раскрой на все обрезки
		
		Если КоличествоОстатков > 0
			И КоличествоОстатков > НомерОстатка Тогда
			РазмерХлыста = МассивОстатков[НомерОстатка].Количество;
			НомерОстатка = НомерОстатка + 1;
			ОтрезкиДляРазмещения = ПолучитьЭлементыМенее(МассивДеталей, РазмерХлыста);
			
			// Ни один отрезок не помещается в такой остаток
			Если ОтрезкиДляРазмещения.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			
		Иначе
			
			РазмерХлыста = РазмерЦелогоХлыста;
			ОтрезкиДляРазмещения = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(МассивДеталей);
			
		КонецЕсли;
		
		// Основной алгоритм распределения отрезков на хлысте
		Структура = Раскрой.МаксимальнаяСуммаПодмножеств(ОтрезкиДляРазмещения, РазмерХлыста, 0);
		
		Для каждого РазмещеннаяДеталь Из Структура.Массив Цикл
			
			НоваяСтрока = Объект.РаскройХлыстов.Добавить();
			НоваяСтрока.Количество = РазмещеннаяДеталь;
			НоваяСтрока.Номенклатура = Номенклатура;
			НоваяСтрока.НомерХлыста = НомерХлыста;
			НоваяСтрока.РазмерХлыста = РазмерХлыста;
			НоваяСтрока.Спецификация = ПолучитьСпецификациюПоОтрезку(тзДетали, РазмещеннаяДеталь);
			
			Индекс = МассивДеталей.Найти(РазмещеннаяДеталь);
			МассивДеталей.Удалить(Индекс);
			
		КонецЦикла;
		
		Если Структура.МинимальныйОстаток > Номенклатура.Кратность * 1000 Тогда
			
			НоваяСтрока = Объект.РаскройХлыстов.Добавить();
			НоваяСтрока.Остаток = Истина;
			НоваяСтрока.Количество = Структура.МинимальныйОстаток;
			НоваяСтрока.Номенклатура = Номенклатура;
			НоваяСтрока.НомерХлыста = НомерХлыста;
			НоваяСтрока.РазмерХлыста = РазмерХлыста;
			
		КонецЕсли;
		
		НомерХлыста = НомерХлыста +1;
		
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция ПолучитьСпецификациюПоОтрезку(МассивСтрок, Размер)
	
	Для Итер = 0 По МассивСтрок.Количество() Цикл
		
		Если МассивСтрок[Итер].РазмерОтрезка = Размер Тогда
			
			Спецификация = МассивСтрок[Итер].Спецификация;
			МассивСтрок.Удалить(Итер);
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(Спецификация) Тогда
		
		ВызватьИсключение "Не определена спецификация к отрезку " + Размер;
		
	КонецЕсли;
	
	Возврат Спецификация;
	
КонецФункции

&НаСервере
Функция ПолучитьЭлементыМенее(фнМассив, фнРазмер)
	
	Результат = Новый Массив;
	
	Для каждого Элем Из фнМассив Цикл
		Если Элем <= фнРазмер Тогда
			Результат.Добавить(Элем);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьСтрокуСпискаНоменклатуры(Номенклатура)
	
	Строки = НайтиСтрокуСпискаНоменклатуры(Номенклатура);
	
	Если Строки.Количество() = 1 Тогда
		
		Строка = Строки[0];
		
	Иначе
		
		НоменклатураОтбора = ЛексСервер.ПолучитьОсновнуюПоСкладу(Объект.Подразделение, Номенклатура);
		Строки = НайтиСтрокуСпискаНоменклатуры(НоменклатураОтбора);
		
		Если Строки.Количество() = 1 Тогда
			
			Строка = Строки[0];
			
		Иначе
			
			ВызватьИсключение "Ошибка 295: Номенклатура " + Номенклатура + " не найдена в таблице";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Строка;
	
КонецФункции

&НаСервере
Функция НайтиСтрокуСпискаНоменклатуры(Номенклатура)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Номенклатура", Номенклатура);
	Возврат Объект.СписокНоменклатуры.НайтиСтроки(ПараметрыОтбора);
	
КонецФункции

&НаКлиенте
Процедура СписокХлыстовыхМатериаловПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		
		ОтборСтруктура = Новый Структура;
		
		Номенклатура = Элемент.ТекущиеДанные.Номенклатура;
		ОтборСтруктура.Вставить("Номенклатура", Номенклатура);
		ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтруктура);
		
		Элементы.РаскройХлыстов.ОтборСтрок = ОтборСтрок;
		Элементы.ОстаткиХлыстов.ОтборСтрок = ОтборСтрок;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПерекроитьВесьХлыстовойМатериал()
	
	Объект.РаскройХлыстов.Очистить();
	
	Для каждого Строка Из Объект.СписокХлыстовыхМатериалов Цикл
		
		ПерекроитьХлысты(Строка.Номенклатура, Истина);
		
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция ПерекроитьХлысты(фнНоменклатура, РаскройВсехМатериалов)
	
	Если НЕ РаскройВсехМатериалов Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Номенклатура", фнНоменклатура);
		
		СтрокиКУдалению = Объект.РаскройХлыстов.НайтиСтроки(ПараметрыОтбора);
		
		Для каждого Строка Из СтрокиКУдалению Цикл
			ъ = Объект.РаскройХлыстов.Индекс(Строка);
			Объект.РаскройХлыстов.Удалить(ъ);
		КонецЦикла;
		
	КонецЕсли;
	
	тзОстатки = Объект.ОстаткиХлыстов.Выгрузить();
	ОпределитьКоличествоХлыстовогоМатериала(фнНоменклатура, тзОстатки);
	
КонецФункции

#КонецОбласти

#Область Комплектации

&НаСервереБезКонтекста
Функция ПолучитьКомплектации(МассивСпецификаций)
	
	Результат = Новый Массив;
	
	Для каждого Спецификация Из МассивСпецификаций Цикл
		
		Комплектация = Документы.Комплектация.ПолучитьКомплектацию(Спецификация);
		
		Если ЗначениеЗаполнено(Комплектация) Тогда
			Результат.Добавить(Комплектация);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьКомплектацию(Команда)
	
	МассивСпецификаций = Новый Массив;
	
	Для каждого ЭлементСтроки Из Объект.СписокСпецификаций Цикл
		Идентификатор = ЭлементСтроки.ПолучитьИдентификатор();
		Если Элементы.СписокСпецификаций.ВыделенныеСтроки.Найти(Идентификатор) <> Неопределено Тогда
			МассивСпецификаций.Добавить(ЭлементСтроки.Спецификация);
		КонецЕсли;
	КонецЦикла;
	
	МассивКомплектаций = ПолучитьКомплектации(МассивСпецификаций);
	
	Для каждого Комплектация Из МассивКомплектаций Цикл
		
		ОткрытьФорму("Документ.Комплектация.ФормаОбъекта", Новый Структура("Ключ",Комплектация), Элементы.СписокСпецификаций);
		
	КонецЦикла;
	
	Если МассивКомплектаций.Количество() <> МассивСпецификаций.Количество() Тогда
		
		ПараметрыФормы = Новый Структура;
		
		ТД = Элементы.СписокСпецификаций.ТекущиеДанные;
		Если ТекущаяДата() <> Неопределено Тогда
			ПараметрыФормы.Вставить("Основание", ТД.Спецификация);
		КонецЕсли;
		
		ОткрытьФорму("Документ.Комплектация.ФормаОбъекта", ПараметрыФормы, Элементы.СписокСпецификаций);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьНаличиеКомплектаций(МассивСпецификаций)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Спец.Ссылка КАК Спецификация,
	|	ВЫБОР
	|		КОГДА Компл.Ссылка ЕСТЬ NULL 
	|				И Спец.ТребуетсяКомплектация
	|				Или НЕ Компл.Проведен
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК НеобходимаКомплектация
	|ИЗ
	|	Документ.Спецификация КАК Спец
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Комплектация КАК Компл
	|		ПО (Компл.Спецификация = Спец.Ссылка)
	|ГДЕ
	|	Спец.Ссылка В(&МассивСпецификаций)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Для каждого Строка Из Объект.СписокСпецификаций Цикл
			
			Если Строка.Спецификация = ВыборкаДетальныеЗаписи.Спецификация Тогда
				
				Строка.ЕстьПроведеннаяКомплектация = ВыборкаДетальныеЗаписи.НеобходимаКомплектация;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура ОстаткиХлыстовПриИзменении(Элемент)
	
	тдОстаток = Элементы.ОстаткиХлыстов.ТекущиеДанные;
	тдХлыстовойМатериал = Элементы.СписокХлыстовыхМатериалов.ТекущиеДанные;
	тдОстаток.Номенклатура = тдХлыстовойМатериал.Номенклатура;
	
КонецПроцедуры

&НаКлиенте
Процедура РаскройХлыстовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.РаскройХлыстов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьЗначение(ТекущиеДанные.Спецификация);
	
КонецПроцедуры

#КонецОбласти
