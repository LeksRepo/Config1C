﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ПолучитьТаблицуМатериалов(СписокСпецификаций) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаМатериалов = Документы.Спецификация.ПолучитьТаблицуМатериалов(СписокСпецификаций);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Склад", Объект.Подразделение.ОсновнойСклад);
	Запрос.УстановитьПараметр("ТаблицаМатериалов", ТаблицаМатериалов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТаблицаМатериалов.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ТаблицаМатериалов.Затребовано КАК ТребуетсяПоСпецификациям
	|ПОМЕСТИТЬ СписокНоменклатуры
	|ИЗ
	|	&ТаблицаМатериалов КАК ТаблицаМатериалов
    |;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ОстаткиНаСкладе.Субконто2.Базовый
	|			ТОГДА ОстаткиНаСкладе.Субконто2
	|		ИНАЧЕ ОстаткиНаСкладе.Субконто2.БазоваяНоменклатура
	|	КОНЕЦ КАК Номенклатура,
	|	СУММА(ВЫБОР
	|			КОГДА ОстаткиНаСкладе.Субконто2.Базовый
	|				ТОГДА ОстаткиНаСкладе.КоличествоОстаток
	|			ИНАЧЕ ОстаткиНаСкладе.Субконто2.КоэффициентБазовых * ОстаткиНаСкладе.КоличествоОстаток
	|		КОНЕЦ) КАК ОстатокНаСкладе
	|ПОМЕСТИТЬ ОстаткиНаСкладе
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|			,
	|			Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.Логистика)
	|				И Субконто1 = &Склад) КАК ОстаткиНаСкладе
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА ОстаткиНаСкладе.Субконто2.Базовый
	|			ТОГДА ОстаткиНаСкладе.Субконто2
	|		ИНАЧЕ ОстаткиНаСкладе.Субконто2.БазоваяНоменклатура
	|	КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СписокНоменклатуры.Номенклатура,
	|	СписокНоменклатуры.ТребуетсяПоСпецификациям КАК ТребуетсяПоСпецификациям,
	|	СписокНоменклатуры.ТребуетсяПоСпецификациям КАК Затребовано,
	|	ОстаткиВЦеху.КоличествоОстаток КАК ОстатокВЦеху,
	|	ОстаткиНаСкладе.ОстатокНаСкладе,
	|	ЕСТЬNULL(ДопЛимит.КоличествоОстаток, 0) + ЕСТЬNULL(БазовыйЛимитЦехаСрезПоследних.Количество, 0) - ЕСТЬNULL(ОстаткиВЦеху.КоличествоРазвернутыйОстатокДт, 0) + СписокНоменклатуры.ТребуетсяПоСпецификациям КАК Лимит
	|ИЗ
	|	СписокНоменклатуры КАК СписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ОсновноеПроизводство),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто1 В
	|						(ВЫБРАТЬ
	|							СписокНоменклатуры.Номенклатура
	|						ИЗ
	|							СписокНоменклатуры)) КАК ОстаткиВЦеху
	|		ПО СписокНоменклатуры.Номенклатура = ОстаткиВЦеху.Субконто1
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиНаСкладе КАК ОстаткиНаСкладе
	|		ПО СписокНоменклатуры.Номенклатура = ОстаткиНаСкладе.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.БазовыйЛимитЦеха.СрезПоследних(, Подразделение = &Подразделение) КАК БазовыйЛимитЦехаСрезПоследних
	|		ПО СписокНоменклатуры.Номенклатура = БазовыйЛимитЦехаСрезПоследних.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ДополнительныйЛимитЦеха), , Подразделение = &Подразделение) КАК ДопЛимит
	|		ПО СписокНоменклатуры.Номенклатура = ДопЛимит.Субконто1
	|
	|УПОРЯДОЧИТЬ ПО
	|	СписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа,
	|	СписокНоменклатуры.Номенклатура.Наименование";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ПолучитьТаблицуЗеркал(СписокСпецификаций) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокСпецификаций", СписокСпецификаций);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпецификацияСписокМатериалы.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА спрНоменклатура.ОсновнаяПоСкладу
	|			ТОГДА спрНоменклатура.Ссылка
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК НоменклатураОсновнаяПоСкладу,
	|	СпецификацияСписокМатериалы.ВысотаДетали КАК ВысотаДетали,
	|	СпецификацияСписокМатериалы.ШиринаДетали КАК ШиринаДетали,
	|	ИСТИНА КАК Раскрой,
	|	СпецификацияСписокМатериалы.Количество КАК Количество,
	|	СпецификацияСписокМатериалы.Комментарий КАК Комментарий,
	|	СпецификацияСписокМатериалы.Ссылка КАК Спецификация
	|ИЗ
	|	Документ.Спецификация.СписокМатериалы КАК СпецификацияСписокМатериалы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК спрНоменклатура
	|		ПО СпецификацияСписокМатериалы.Номенклатура = спрНоменклатура.БазоваяНоменклатура
	|ГДЕ
	|	СпецификацияСписокМатериалы.Ссылка В(&СписокСпецификаций)
	|	И СпецификацияСписокМатериалы.Номенклатура.НоменклатурнаяГруппа = ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.Зеркало)
	|	И спрНоменклатура.ОсновнаяПоСкладу
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДвериСписокНоменклатуры.Номенклатура,
	|	ВЫБОР
	|		КОГДА спрНоменклатура.ОсновнаяПоСкладу
	|			ТОГДА спрНоменклатура.Ссылка
	|		ИНАЧЕ NULL
	|	КОНЕЦ,
	|	ДвериСписокНоменклатуры.Длина,
	|	ДвериСписокНоменклатуры.Ширина,
	|	Истина,
	|	ДвериСписокНоменклатуры.Количество,
	|	NULL,
	|	СпецификацияСписокДверей.Ссылка
	|ИЗ
	|	Документ.Спецификация.СписокДверей КАК СпецификацияСписокДверей
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Двери.СписокНоменклатуры КАК ДвериСписокНоменклатуры
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК спрНоменклатура
	|			ПО ДвериСписокНоменклатуры.Номенклатура = спрНоменклатура.БазоваяНоменклатура
	|		ПО СпецификацияСписокДверей.Двери = ДвериСписокНоменклатуры.Ссылка
	|ГДЕ
	|	СпецификацияСписокДверей.Ссылка В(&СписокСпецификаций)
	|	И ДвериСписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа = ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.Зеркало)
	|	И спрНоменклатура.ОсновнаяПоСкладу";
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Объект.СписокЗеркал.Очистить();
	
	Пока Выборка.Следующий() Цикл 
		
		НоваяСтрока = Объект.СписокЗеркал.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка); 
		
	КонецЦикла; 
	
	ПолучитьСписокВыбораЗеркал();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокВыбораЗеркал() Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	//СПИСОК ВЫБОРА ЗЕРКАЛ
	
	Если Объект.СписокЗеркал.Количество() > 0 Тогда
		СписокНоменклатуры = Объект.СписокЗеркал.Выгрузить(,"Номенклатура").ВыгрузитьКолонку("Номенклатура");
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СпрНоменклатура.Ссылка,
		|	СпрНоменклатура.БазоваяНоменклатура КАК БазоваяНоменклатура
		|ИЗ
		|	Справочник.Номенклатура КАК СпрНоменклатура
		|ГДЕ
		|	СпрНоменклатура.НоменклатурнаяГруппа = ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.Зеркало)
		|	И НЕ СпрНоменклатура.Базовый
		|	И СпрНоменклатура.БазоваяНоменклатура В(&СписокНоменклатуры)
		|
		|УПОРЯДОЧИТЬ ПО
		|	СпрНоменклатура.Наименование
		|ИТОГИ ПО
		|	БазоваяНоменклатура";
		
		Результат = Запрос.Выполнить();
		ВыборкаИтоги = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаИтоги.Следующий() Цикл
			
			СписокЗначений = Новый СписокЗначений;
			
			Выборка = ВыборкаИтоги.Выбрать();
			Пока Выборка.Следующий() Цикл
				СписокЗначений.Добавить(Выборка.Ссылка);
			КонецЦикла;
			
			МассивСтрок = Объект.СписокЗеркал.НайтиСтроки(Новый Структура("Номенклатура", ВыборкаИтоги.БазоваяНоменклатура));
			Для Каждого ЭлементМассива Из МассивСтрок Цикл
				ЭлементМассива.СписокВыбора = СписокЗначений;
			КонецЦикла;
		КонецЦикла;			
	КонецЕсли;
	
	//СПИСОК ВЫБОРА ЗЕРКАЛ
	////////////////////////////////////////////////////////////////////////////                                                  
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВыбораНоменклатуры()
	
	МассивНоменклатуры = Объект.СписокНоменклатуры.Выгрузить().ВыгрузитьКолонку("Номенклатура");
	
	//////////////////////Таблица расшифровки//////////////////////
	СписокСпецификаций = Объект.СписокСпецификаций.Выгрузить().ВыгрузитьКолонку("Спецификация");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(Номенклатура.Ссылка) КАК Ссылка
	|ПОМЕСТИТЬ ОсновнаяНоменклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Базовый
	|
	|СГРУППИРОВАТЬ ПО
	|	Номенклатура.БазоваяНоменклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СпецификацияСписокНоменклатуры.Ссылка КАК Спецификация,
	|	ЕСТЬNULL(ОсновнаяНоменклатура.Ссылка, СпецификацияСписокНоменклатуры.Номенклатура) КАК Номенклатура,
	|	СУММА(СпецификацияСписокНоменклатуры.Количество * ЕСТЬNULL(ОсновнаяНоменклатура.Ссылка.КоэффициентБазовых, 1)) КАК Количество
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОсновнаяНоменклатура КАК ОсновнаяНоменклатура
	|		ПО СпецификацияСписокНоменклатуры.Номенклатура = ОсновнаяНоменклатура.Ссылка.БазоваяНоменклатура
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В(&СписокСпецификаций)
	//|	И ЕСТЬNULL(ОсновнаяНоменклатура.Ссылка.ПроцентОтхода, СпецификацияСписокНоменклатуры.Номенклатура.ПроцентОтхода) > 0
	|	И ЕСТЬNULL(ОсновнаяНоменклатура.Ссылка, СпецификацияСписокНоменклатуры.Номенклатура) В (&Номенклатура)
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Ссылка,
	|	ЕСТЬNULL(ОсновнаяНоменклатура.Ссылка, СпецификацияСписокНоменклатуры.Номенклатура)";
	Запрос.УстановитьПараметр("СписокСпецификаций", СписокСпецификаций);
	Запрос.УстановитьПараметр("Номенклатура", МассивНоменклатуры);
	
	ТаблицаРасшифровки.Загрузить(Запрос.Выполнить().Выгрузить());
	////////////////////////////
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСпецификации(АдресТаблицы)
	
	ТЗ = ПолучитьИзВременногоХранилища(АдресТаблицы);
	Объект.СписокСпецификаций.Загрузить(ТЗ);
	ЗаполнитьНоменклатуройСервер();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНоменклатуройСервер() 
	
	ТаблицаСпецификаций = Объект.СписокСпецификаций.Выгрузить();
	СписокСпецификаций = ТаблицаСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	ТаблицаНоменклатуры = ПолучитьТаблицуМатериалов(СписокСпецификаций);
	Объект.СписокНоменклатуры.Загрузить(ТаблицаНоменклатуры);
	
	ПолучитьТаблицуЗеркал(СписокСпецификаций);
	
	ОбновитьСписокВыбораНоменклатуры();
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьСтрокуРаскроя(СтруктураРаскроя)
	
	НаборЗаписей = РегистрыСведений.РаскройДеталей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Объект.Ссылка);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		Запись = НаборЗаписей.Добавить();
	Иначе
		Запись = НаборЗаписей[0];
	КонецЕсли;
	
	Запись.СтрокаРаскрой = СтруктураРаскроя.ДанныеДляРаскроя;
	Запись.Объект = Объект.Ссылка;
	
	НаборЗаписей.Записать();
	
	Возврат Истина;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьСписокВыбораНоменклатуры();
	
	ПолучитьСписокВыбораЗеркал();

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьСписокВыбораНоменклатуры();
	
	Если ТекущийОбъект.СписокЗеркал.Количество() > 0 Тогда
		
		СтруктураРаскроя = РегистрыСведений.РаскройДеталей.ПолучитьСтрокуРаскроя(ТекущийОбъект);
		Если ТипЗнч(СтруктураРаскроя) = Тип("Структура") Тогда
			
			ЗаписатьСтрокуРаскроя(СтруктураРаскроя);
			
		//Иначе
		//	
		//	Отказ = Истина;
		//	Сообщить(?(ЗначениеЗаполнено(СтруктураРаскроя), СтруктураРаскроя, "Ошибка раскроя - ошибка неопределена"), СтатусСообщения.ОченьВажное);
		//	Возврат;
			
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ВыбратьСпецификации(Команда)
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Текст = "Табличные части будут изменены." + Символы.ПС + "Продолжить?" ;
	
	Если Объект.СписокСпецификаций.Количество() > 0 
		И Вопрос(Текст, Режим, 0) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	АдресТаблицы = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораСпецификации", Новый Структура("Подразделение, ТЗ, Статус, УпорядочитьПоДате", Объект.Подразделение, Объект.СписокСпецификаций, ПредопределенноеЗначение("Перечисление.СтатусыСпецификации.Размещен"), Истина), ЭтаФорма);
	Если АдресТаблицы <> Неопределено Тогда
		ЗагрузитьСпецификации(АдресТаблицы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНоменклатуру(Команда)
	
	ЗаполнитьНоменклатуройСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСпецификацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.СписокСпецификаций.ТекущиеДанные.Спецификация);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Номенклатура = Элемент.ТекущиеДанные.Номенклатура;
		Если ЗначениеЗаполнено(Номенклатура) Тогда
			ОтборСтрок = Новый ФиксированнаяСтруктура("Номенклатура", Номенклатура);
		Иначе
			ОтборСтрок = Новый ФиксированнаяСтруктура("Номенклатура", ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
		КонецЕсли;
		Элементы.ТаблицаРасшифровки.ОтборСтрок = ОтборСтрок;
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

&НаКлиенте
Процедура СписокЗеркалПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Элементы.СписокЗеркалНоменклатураОсновнаяПоСкладу.СписокВыбора.ЗагрузитьЗначения(ТекущиеДанные.СписокВыбора.ВыгрузитьЗначения());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСпецификацийСпецификацияПриИзменении(Элемент)
	
	Элементы.СписокСпецификаций.ТекущиеДанные.ОсобыеУслуги = ЛексСервер.ЗначенияРеквизитовОбъекта(Элементы.СписокСпецификаций.ТекущиеДанные.Спецификация, "ОсобыеУслуги").ОсобыеУслуги;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
