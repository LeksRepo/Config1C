﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ПолучитьТаблицуМатериалов(МассивСпецификаций)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Склад", Объект.Подразделение.ОсновнойСклад);
	Запрос.УстановитьПараметр("МассивСпецификация", МассивСпецификаций);
	
	Запрос.Текст =
	"ВЫБРАТЬ        
	|	СпецификацияСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СпецификацияСписокНоменклатуры.ПредоставитЗаказчик КАК ПредоставитЗаказчик,
	|	СУММА(СпецификацияСписокНоменклатуры.Количество) КАК ТребуетсяПоСпецификациям
	|ПОМЕСТИТЬ СписокНоменклатуры
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В(&МассивСпецификация)
	|	И НЕ СпецификацияСписокНоменклатуры.ЧерезСклад
	|	И СпецификацияСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Номенклатура,
	|	СпецификацияСписокНоменклатуры.ПредоставитЗаказчик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВЫРАЗИТЬ(ОстаткиНаСкладе.Субконто2 КАК Справочник.Номенклатура).Базовый
	|			ТОГДА ОстаткиНаСкладе.Субконто2
	|		ИНАЧЕ ВЫРАЗИТЬ(ОстаткиНаСкладе.Субконто2 КАК Справочник.Номенклатура).БазоваяНоменклатура
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
	|			Подразделение = &Подразделение
	|				И Субконто1 = &Склад) КАК ОстаткиНаСкладе
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА ВЫРАЗИТЬ(ОстаткиНаСкладе.Субконто2 КАК Справочник.Номенклатура).Базовый
	|			ТОГДА ОстаткиНаСкладе.Субконто2
	|		ИНАЧЕ ВЫРАЗИТЬ(ОстаткиНаСкладе.Субконто2 КАК Справочник.Номенклатура).БазоваяНоменклатура
	|	КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СписокНоменклатуры.Номенклатура,
	|	СписокНоменклатуры.ТребуетсяПоСпецификациям КАК КоличествоТребуется,
	|	СписокНоменклатуры.ПредоставитЗаказчик КАК ПредоставитЗаказчик,
	|	ОстаткиВЦеху.КоличествоОстаток КАК ОстатокВЦеху,
	|	ОстаткиНаСкладе.ОстатокНаСкладе
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
	|
	|УПОРЯДОЧИТЬ ПО
	|	СписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа,
	|	СписокНоменклатуры.Номенклатура.Наименование";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ПолучитьТаблицуЗеркал(СписокСпецификаций) Экспорт
	
	//RonEXI: Функция нигде не используется
	
	//УстановитьПривилегированныйРежим(Истина);
	//
	//Запрос = Новый Запрос;
	//Запрос.УстановитьПараметр("СписокСпецификаций", СписокСпецификаций);
	//Запрос.Текст =
	//"ВЫБРАТЬ
	//|	СпецификацияСписокМатериалы.Номенклатура КАК Номенклатура,
	//|	ВЫБОР
	//|		КОГДА спрНоменклатура.ОсновнаяПоСкладу
	//|			ТОГДА спрНоменклатура.Ссылка
	//|		ИНАЧЕ NULL
	//|	КОНЕЦ КАК НоменклатураОсновнаяПоСкладу,
	//|	СпецификацияСписокМатериалы.ВысотаДетали КАК ВысотаДетали,
	//|	СпецификацияСписокМатериалы.ШиринаДетали КАК ШиринаДетали,
	//|	ИСТИНА КАК Раскрой,
	//|	СпецификацияСписокМатериалы.Количество КАК Количество,
	//|	СпецификацияСписокМатериалы.Комментарий КАК Комментарий,
	//|	СпецификацияСписокМатериалы.Ссылка КАК Спецификация
	//|ИЗ
	//|	Документ.Спецификация.СписокМатериалы КАК СпецификацияСписокМатериалы
	//|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК спрНоменклатура
	//|		ПО СпецификацияСписокМатериалы.Номенклатура = спрНоменклатура.БазоваяНоменклатура
	//|ГДЕ
	//|	СпецификацияСписокМатериалы.Ссылка В(&СписокСпецификаций)
	//|	И СпецификацияСписокМатериалы.Номенклатура.НоменклатурнаяГруппа = ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.Зеркало)
	//|	И спрНоменклатура.ОсновнаяПоСкладу
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	ДвериСписокНоменклатуры.Номенклатура,
	//|	ВЫБОР
	//|		КОГДА спрНоменклатура.ОсновнаяПоСкладу
	//|			ТОГДА спрНоменклатура.Ссылка
	//|		ИНАЧЕ NULL
	//|	КОНЕЦ,
	//|	ДвериСписокНоменклатуры.Длина,
	//|	ДвериСписокНоменклатуры.Ширина,
	//|	Истина,
	//|	ДвериСписокНоменклатуры.Количество,
	//|	NULL,
	//|	СпецификацияСписокДверей.Ссылка
	//|ИЗ
	//|	Документ.Спецификация.СписокДверей КАК СпецификацияСписокДверей
	//|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Двери.СписокНоменклатуры КАК ДвериСписокНоменклатуры
	//|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК спрНоменклатура
	//|			ПО ДвериСписокНоменклатуры.Номенклатура = спрНоменклатура.БазоваяНоменклатура
	//|		ПО СпецификацияСписокДверей.Двери = ДвериСписокНоменклатуры.Ссылка
	//|ГДЕ
	//|	СпецификацияСписокДверей.Ссылка В(&СписокСпецификаций)
	//|	И ДвериСписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа = ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.Зеркало)
	//|	И спрНоменклатура.ОсновнаяПоСкладу";
	//
	//Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	//Объект.СписокЗеркал.Очистить();
	//
	//Пока Выборка.Следующий() Цикл 
	//	
	//	НоваяСтрока = Объект.СписокЗеркал.Добавить();
	//	ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка); 
	//	
	//КонецЦикла; 
	//
	//ПолучитьСписокВыбораЗеркал();
	
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
	|	СУММА(СпецификацияСписокНоменклатуры.Количество * ЕСТЬNULL(ОсновнаяНоменклатура.Ссылка.КоэффициентБазовых, 1)) КАК Количество,
	|	СпецификацияСписокНоменклатуры.ПредоставитЗаказчик КАК ПредоставитЗаказчик
	|ИЗ
	|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОсновнаяНоменклатура КАК ОсновнаяНоменклатура
	|		ПО СпецификацияСписокНоменклатуры.Номенклатура = ОсновнаяНоменклатура.Ссылка.БазоваяНоменклатура
	|ГДЕ
	|	СпецификацияСписокНоменклатуры.Ссылка В(&СписокСпецификаций)
	|	И ЕСТЬNULL(ОсновнаяНоменклатура.Ссылка, СпецификацияСписокНоменклатуры.Номенклатура) В (&Номенклатура)
	|
	|СГРУППИРОВАТЬ ПО
	|	СпецификацияСписокНоменклатуры.Ссылка,
	|	ЕСТЬNULL(ОсновнаяНоменклатура.Ссылка, СпецификацияСписокНоменклатуры.Номенклатура),
	|	СпецификацияСписокНоменклатуры.ПредоставитЗаказчик";
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
	ПроверитьНаличиеКомплектаций(Объект.СписокСпецификаций.Выгрузить().ВыгрузитьКолонку("Спецификация"));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНоменклатуройСервер() Экспорт 
	
	ТаблицаСпецификаций = Объект.СписокСпецификаций.Выгрузить();
	МассивСпецификаций = ТаблицаСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	ТаблицаНоменклатуры = ПолучитьТаблицуМатериалов(МассивСпецификаций);
	Объект.СписокНоменклатуры.Загрузить(ТаблицаНоменклатуры);
	
	//ПолучитьТаблицуЗеркал(СписокСпецификаций);
	
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
			
		КонецЕсли;
	КонецЕсли;
	
	ПроверитьНаличиеКомплектаций(Объект.СписокСпецификаций.Выгрузить().ВыгрузитьКолонку("Спецификация"));
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	ПроверитьНаличиеКомплектаций(Объект.СписокСпецификаций.Выгрузить().ВыгрузитьКолонку("Спецификация"));
	
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

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
	//	
	//	Для Каждого Элемент Из Объект.СписокСпецификаций Цикл
	//		
	//		СтруктураРаскроя = РегистрыСведений.РаскройДеталей.ПолучитьСтрокуРаскроя(Элемент.Спецификация);
	//		
	//		НоваяСтрока = ТаблицаРаскроя.Добавить();
	//		НоваяСтрока.Спецификация =  Элемент.Спецификация;
	//		НоваяСтрока.СтрокаРаскрой = СтруктураРаскроя.ДанныеДляРаскроя;
	//		НоваяСтрока.СтрокаКривогоПила = СтруктураРаскроя.СтрокаКривогоПила;
	//		НоваяСтрока.ТаблицаДеталей = СтруктураРаскроя.ТаблицаДеталей;
	//		НоваяСтрока.АлгоритмРаскроя = СтруктураРаскроя.АлгоритмРаскроя;
	
	//	КонецЦикла;
	//
	//КонецЕсли;
	
	Заглушка = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	//Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
	//	
	//	Для Каждого Элемент Из ТаблицаРаскроя Цикл
	//		
	//		ЗаписатьРисункиРаскроя(Элемент);
	//		
	//	КонецЦикла;
	
	//	ЗаписатьРаскроя();
	//	
	//КонецЕсли;
	
	Заглушка = Истина;
	
КонецПроцедуры

&НаКлиенте
Функция ЗаписатьРисункиРаскроя(ЭлементСпецификации)
	
	Спецификация = ЭлементСпецификации.Спецификация;
	
	Если ЗначениеЗаполнено(ЭлементСпецификации.СтрокаКривогоПила) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Спецификация", Спецификация);
		ПараметрыФормы.Вставить("ХранимыйФайл", "КривойПил");
		ПараметрыФормы.Вставить("СтрокаКривогоПила", ЭлементСпецификации.СтрокаКривогоПила);
		
		Значение = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы);
		
		ЭлементСпецификации.РисунокКривогоПила = Значение;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЭлементСпецификации.СтрокаРаскрой) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Спецификация", Спецификация);
		ПараметрыФормы.Вставить("ХранимыйФайл", "НовыйРаскрой");
		ПараметрыФормы.Вставить("СтрокаНовогоРаскрояЛДСП", ЭлементСпецификации.СтрокаРаскрой);
		ПараметрыФормы.Вставить("ВидОтображения", "1");
		
		Значение = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы);
		
		ЭлементСпецификации.РисунокРаскроя = Значение;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ЗаписатьРаскроя()
	
	Для Каждого Элемент Из ТаблицаРаскроя Цикл 
		
		НаборЗаписей = РегистрыСведений.РаскройДеталей.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(Элемент.Спецификация);
		
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() = 0 Тогда
			Запись = НаборЗаписей.Добавить();
		Иначе
			Запись = НаборЗаписей[0];
		КонецЕсли;
		
		Запись.РисунокРаскроя = ?(Элемент.РисунокРаскроя = "save☻", "", Элемент.РисунокРаскроя);
		Запись.РисунокКривогоПила = ?(Элемент.РисунокКривогоПила = "save☻", "", Элемент.РисунокКривогоПила);
		Запись.СтрокаРаскрой = Элемент.СтрокаРаскрой;
		Запись.СтрокаЭтикеток = "";
		Запись.ТекущаяСтрокаРаскроя = Элемент.СтрокаРаскрой;
		Запись.ТаблицаДеталей = Элемент.ТаблицаДеталей;
		Запись.Объект = Элемент.Спецификация;
		Запись.АлгоритмРаскроя = Элемент.АлгоритмРаскроя;
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецФункции

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
		ПредоставитЗаказчик = Элемент.ТекущиеДанные.ПредоставитЗаказчик;
		
		ОтборСтруктура = Новый Структура;
		ОтборСтруктура.Вставить("ПредоставитЗаказчик",ПредоставитЗаказчик);
		
		Если ЗначениеЗаполнено(Номенклатура) Тогда
			ОтборСтруктура.Вставить("Номенклатура",Номенклатура);
		Иначе
			ОтборСтруктура.Вставить("Номенклатура",ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
		КонецЕсли;
		
		ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтруктура);
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
	ПроверитьНаличиеКомплектаций(Элементы.СписокСпецификаций.ТекущиеДанные.Спецификация);
	
КонецПроцедуры

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

&НаКлиенте
Процедура СписокСпецификацийОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ДокументСсылка.Спецификация") Тогда
		
		ПроверитьНаличиеКомплектаций(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРасшифровкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаРасшифровки.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Спецификация = ТекущиеДанные.Спецификация;
		
		Если ЗначениеЗаполнено(Спецификация) Тогда
			ОткрытьЗначение(Спецификация);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
