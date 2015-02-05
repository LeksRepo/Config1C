﻿
&НаКлиенте
Процедура Обновить(Команда = Неопределено)
		
	Для Каждого ВидимаяСтрока Из ВидимаяТаблица Цикл
		
		Если ВидимаяСтрока.Тип = 1 И (НЕ ВидимаяСтрока.Обновить) Тогда
			
			 Стр = Новый Структура();
			 
			 Если ВидимаяСтрока.Группа = "Без группы" Тогда
				 Стр.Вставить("Группа", ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ПустаяСсылка"));	 
			 Иначе
				 Стр.Вставить("Группа", ВидимаяСтрока.Группа);
		     КонецЕсли;
			 
			 Стр.Вставить("Тип", 1);
			 
			 СтрокиДляУдаления = ТаблицаЗначений.НайтиСтроки(Стр);
			
			 Для каждого Строка Из СтрокиДляУдаления Цикл
			 	ТаблицаЗначений.Удалить(Строка);
			 КонецЦикла;
			
		 КонецЕсли;
		 
		 Если ВидимаяСтрока.Тип = 2 И (НЕ ВидимаяСтрока.Обновить) Тогда
			
			 СтрокиДляУдаления = ТаблицаЗначений.НайтиСтроки(Новый Структура("Тип", 2));
			
			 Для каждого Строка Из СтрокиДляУдаления Цикл
			 	ТаблицаЗначений.Удалить(Строка);
			 КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	КоличествоОбновить = ТаблицаЗначений.Количество();
	Шаг = Окр((КоличествоОбновить / 10) + 0.5, 0, РежимОкругления.Окр15как20);
	ШагОбновления = Макс(Шаг, 10);
	ШагПрогресса = Мин(Шаг, 10);
	ДатаНачалаПроцесса = ТекущаяДата();
	
	Если КоличествоОбновить > 0 Тогда
		
		ФайлДБФ = Новый XBase(РабочийКаталог + "Hash.dbf");
		
		ТекстСостояния = НСтр("ru = 'Выполняется синхронизация файлов.'");
		Состояние(ТекстСостояния, 0, "Оценка времени загрузки", БиблиотекаКартинок.Синхронизация);
		
		Для Индекс = 1 по ШагПрогресса Цикл
			
			Если ТаблицаЗначений.Количество() > 0 Тогда
				
				ОбработатьСтрок = Мин(ШагОбновления, ТаблицаЗначений.Количество());
				
				ЗагрузкаДанныхПоЧастям(ОбработатьСтрок);
				СохранитьНаКлиенте(ФайлДБФ);
				
				ОбработкаПрерыванияПользователя();
				
				ПрошлоВремени = ТекущаяДата() - ДатаНачалаПроцесса;
				Осталось = ПрошлоВремени * (КоличествоОбновить / Мин(ОбработатьСтрок * Индекс, КоличествоОбновить) - 1);
				Часов = Цел(Осталось / 3600);
				Осталось = Осталось - (Часов * 3600);
				Минут = Цел(Осталось / 60);
				Секунд = Цел(Цел(Осталось - (Минут * 60)));
				ОсталосьВремени = Формат(Часов, "ЧЦ=2; ЧН=00; ЧВН=") + ":" + Формат(Минут, "ЧЦ=2; ЧН=00; ЧВН=") + ":" + Формат(Секунд, "ЧЦ=2; ЧН=00; ЧВН=");
				ТекстОсталось = "Осталось: ~" + ОсталосьВремени;
				ТекстСостояния = НСтр("ru = 'Выполняется синхронизация файлов.'");
				Состояние(ТекстСостояния, (100 * Индекс) / ШагПрогресса, ТекстОсталось, БиблиотекаКартинок.Синхронизация);
			КонецЕсли;
		КонецЦикла;
		
		ФайлДБФ.ЗакрытьФайл();
		
		ПоказатьОповещениеПользователя("Обновление файлов.", , "Обновление файлов прошло успешно.", БиблиотекаКартинок.Информация32);

	КонецЕсли;
	
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузкаДанныхПоЧастям(ОбработатьСтрок)
	
	Для Индекс = 0 По ОбработатьСтрок - 1 Цикл
		Элемент = ТаблицаЗначений[Индекс];
		Элемент.Данные = РегистрыСведений.ХранимыеФайлыВерсий.Получить(Новый Структура("ВерсияФайла", Элемент.ВладелецФайла)).ХранимыйФайл.Получить();
		Элемент.Обновить = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаКлиенте(ФайлДБФ) 
	
	СтрокиДляУдаления = ТаблицаЗначений.НайтиСтроки(Новый Структура("Обновить", Ложь));
	Для каждого Элемент Из СтрокиДляУдаления Цикл
		
		Путь = РабочийКаталог + Элемент.Имя;
		
		ФайлДБФ.Первая();
		Пока Не ФайлДБФ.ВКонце() Цикл
			Если СокрЛП(ФайлДБФ.NAME) = Элемент.Имя Тогда
				ФайлДБФ.Удалить();
				Прервать;
			КонецЕсли;
			ФайлДБФ.Следующая();
		КонецЦикла;
		
		Если Элемент.Размер > 0 Тогда
			ФайлВКаталоге = Новый Файл(Путь);
			Если ФайлВКаталоге.Существует() Тогда
				ФайлВКаталоге.УстановитьТолькоЧтение(Ложь);
			КонецЕсли;
			Элемент.Данные.Записать(Путь);
			Если ЗначениеЗаполнено(Найти(Элемент.Имя, "HTML")) Тогда
				
				ТекстHTML = Новый ТекстовыйДокумент;
				ТекстHTML.Прочитать(Путь);
				Текст = ТекстHTML.ПолучитьТекст();
				
				ИмяКаталога = СтрЗаменить(РабочийКаталог, "\", "\\");
				
				Текст = СтрЗаменить(Текст, "%ЛОКАЛЬНЫЙ_ПУТЬ_К_ФАЙЛУ%", ИмяКаталога);
				ТекстHTML.УстановитьТекст(Текст);
				ПутьНовыйHTML = РабочийКаталог + "Рабочий_" + Элемент.Имя;
				ТекстHTML.Записать(ПутьНовыйHTML);
				
			КонецЕсли;
			ФайлДБФ.Добавить();
			ФайлДБФ.NAME = Элемент.Имя;
			ФайлДБФ.SUM = Элемент.ХэшБазы;
			
		КонецЕсли;
		
		ТаблицаЗначений.Удалить(Элемент);
		ФайлДБФ.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Пропустить(Команда)
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Текст = Новый ФорматированнаяСтрока("          Файлы не обновлены!" 
	+ Символы.ПС + "Возможны сбои в работе программы" 
	+ Символы.ПС + "                  Обновить?", Новый Шрифт("Arial", 20,Истина), WebЦвета.Красный);
	
	Если Вопрос(Текст, Режим, 0) = КодВозвратаДиалога.Да Тогда
		ВыделитьВсе();
	Иначе
		ОтменитьВсе();
	КонецЕсли;
	
	Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда = Неопределено)
	
	Для каждого Элемент Из ВидимаяТаблица Цикл
		Элемент.Обновить = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда = Неопределено)
	
	Для каждого Элемент Из ВидимаяТаблица Цикл
		Элемент.Обновить = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВсегдаОткрывать = Параметры.ВсегдаОткрывать;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РабочийКаталог = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
	СоздатьКаталогНаДиске();
	
	ОбработкаДБФ();
	
	Если ТаблицаЗначений.Количество() = 0 И НЕ ВсегдаОткрывать Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Элементы.ТаблицаЗначений.Видимость = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ФайлыНаСервере()
	
	НоваяТаблица = РеквизитФормыВЗначение("ТаблицаЗначений");
	ВидимаяТаб = РеквизитФормыВЗначение("ВидимаяТаблица");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ХранимыеФайлыВерсий.ХранимыйФайл,
	|	ХранимыеФайлыВерсий.ВерсияФайла КАК ВладелецФайла,
	|	ХранимыеФайлыВерсий.ВерсияФайла.Размер КАК Размер,
	|	ХранимыеФайлыВерсий.ВерсияФайла.Владелец КАК Владелец,
	|	ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ТекущаяВерсияРасширение КАК Расширение,
	|	ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла.Код КАК Код,
	|	ХранимыеФайлыВерсий.ВерсияФайла.Владелец.Код КАК КодФайла,
	|	ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВидФайла КАК ВидФайла,
	|	ВЫБОР
	|		КОГДА ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла ССЫЛКА Справочник.Номенклатура
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоНоменклатура,
	|	ВЫБОР
	|		КОГДА ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла ССЫЛКА Справочник.КаталогИзделий
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоИзделие,
	|	ВЫБОР
	|		КОГДА ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла ССЫЛКА Справочник.Номенклатура
	|			ТОГДА ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла.НоменклатурнаяГруппа
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК Группа
	|ИЗ
	|	РегистрСведений.ХранимыеФайлыВерсий КАК ХранимыеФайлыВерсий
	|ГДЕ
	|	(ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла ССЫЛКА Справочник.Номенклатура
	|			ИЛИ ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла ССЫЛКА Справочник.КаталогИзделий
	|				И (ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВидФайла = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.ОсновнаяКартинка)
	|					ИЛИ ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВидФайла = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.КартинкаЛевая)
	|					ИЛИ ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВидФайла = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.КартинкаПравая)
	|					ИЛИ ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВидФайла = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.КрышаЛевая)
	|					ИЛИ ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВидФайла = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.КрышаПравая))
	|			ИЛИ ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла = ЗНАЧЕНИЕ(Справочник.ПапкиФайлов.Flash)
	|			ИЛИ ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла = ЗНАЧЕНИЕ(Справочник.ПапкиФайлов.Html))
	|	И ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ТекущаяВерсия.НомерВерсии = ХранимыеФайлыВерсий.ВерсияФайла.НомерВерсии
	|	И НЕ ХранимыеФайлыВерсий.ВерсияФайла.ПометкаУдаления
	|	И НЕ ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ЭтоНоменклатура Тогда
			Имя = СокрЛП(Выборка.Код);
		ИначеЕсли Выборка.ЭтоИзделие Тогда
			Имя = Строка(Выборка.ВидФайла) + СокрЛП(Выборка.Код);
		Иначе
			Имя = СокрЛП(Выборка.Владелец) + "." + Выборка.Расширение;
		КонецЕсли;
		
		ДвоичныеДанныеВБазе = Выборка.ХранимыйФайл.Получить();
		
		Хеш = Новый ХешированиеДанных(ХешФункция.CRC32);
		Хеш.Добавить(ДвоичныеДанныеВБазе);
		ХэшБазы =  Хеш.ХешСумма;
		
		Строка = НоваяТаблица.НайтиСтроки(Новый Структура("Имя", Имя));
		
		Если НЕ ЗначениеЗаполнено(Строка) Тогда
			
			НоваяСтрока = НоваяТаблица.Добавить();
			НоваяСтрока.Имя = Имя;
			НоваяСтрока.ХэшБазы = ХэшБазы;
			НоваяСтрока.ВладелецФайла = Выборка.ВладелецФайла;
			НоваяСтрока.Размер = Выборка.Размер;
			НоваяСтрока.Обновить = Истина;
			НоваяСтрока.КодФайла = Выборка.КодФайла;
			НоваяСтрока.Группа = Выборка.Группа;
			
			Если Выборка.ЭтоНоменклатура Тогда
				НоваяСтрока.Тип = 1;
			ИначеЕсли Выборка.ЭтоИзделие Тогда
				НоваяСтрока.Тип = 2;
			Иначе
				НоваяСтрока.Тип = 3;
			КонецЕсли;	
			
		Иначе
			Если Строка[0].ХэшБазы <> ХэшБазы Тогда
				Строка[0].ХэшБазы = ХэшБазы;
				Строка[0].ВладелецФайла = Выборка.ВладелецФайла;
				Строка[0].Размер = Выборка.Размер;
				Строка[0].Обновить = Истина;
				Строка[0].КодФайла = Выборка.КодФайла;
				Строка[0].Группа = Выборка.Группа;
				Если Выборка.ЭтоНоменклатура Тогда
					Строка[0].Тип = 1;
				ИначеЕсли Выборка.ЭтоИзделие Тогда
					Строка[0].Тип = 2;
				Иначе
					Строка[0].Тип = 3;
				КонецЕсли;
			Иначе
				НоваяТаблица.Удалить(Строка[0]);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Таб", НоваяТаблица);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таб.Группа,
	|	Таб.Размер,
	|	Таб.КодФайла,
	|	Таб.Тип
	|ПОМЕСТИТЬ Та
	|ИЗ
	|	&Таб КАК Таб
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Т.Группа,
	|	СУММА(Т.Размер) КАК Размер,
	|	КОЛИЧЕСТВО(*) КАК Количество,
	|	Т.Тип
	|ИЗ
	|	Та КАК Т
	|ГДЕ
	|	Т.Тип < 3
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Группа,
	|	Т.Тип
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Т.Тип = 2
	|			ТОГДА ""Файлы изделий""
	|		КОГДА Т.Тип = 1 И Т.Группа = ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.ПустаяСсылка)
	|			ТОГДА ""Без группы""
	|		ИНАЧЕ Т.Группа
	|	КОНЕЦ КАК Группа,
	|	СУММА(Т.Размер) / (1024 * 1024) КАК Размер,
	|	КОЛИЧЕСТВО(*) КАК Количество,
	|	Т.Тип КАК Тип
	|ИЗ
	|	Та КАК Т
	|ГДЕ
	|	Т.Тип < 3
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Группа,
	|	Т.Тип
	|
	|УПОРЯДОЧИТЬ ПО
	|	Группа";
	
	Таб = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Строка Из  Таб Цикл
		
		НоваяСтрока = ВидимаяТаб.Добавить();
		НоваяСтрока.Группа = Строка.Группа;
		НоваяСтрока.Количество = Строка.Количество;
		НоваяСтрока.Размер = Строка.Размер;
		НоваяСтрока.Обновить = Истина;
		НоваяСтрока.Тип = Строка.Тип;
		
	КонецЦикла;
	
	ИтогКоличество = НоваяТаблица.Количество();
	ИтогРазмер = НоваяТаблица.Итог("Размер") / (1024*1024);
	
	ЗначениеВРеквизитФормы(НоваяТаблица, "ТаблицаЗначений");
	ЗначениеВРеквизитФормы(ВидимаяТаб, "ВидимаяТаблица");
		
КонецПроцедуры

&НаКлиенте
Процедура ПолноеОбновление(Команда)
	
	МассивФайлов = НайтиФайлы(РабочийКаталог, "*", Истина);
	Для Каждого Файл Из МассивФайлов Цикл
		Файл.УстановитьТолькоЧтение(Ложь);
	КонецЦикла;
	
	УдалитьФайлы(РабочийКаталог);
	
	СоздатьКаталогНаДиске();
	ТаблицаЗначений.Очистить();
	
	ОбработкаДБФ();
	
	Обновить(Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаДБФ()
	
	ФайлДБФ = Новый XBase(РабочийКаталог+"Hash.dbf");
	
	Если НЕ ФайлДБФ.Открыта() Тогда
		ФайлДБФ.поля.Добавить("NAME", "S", 100);
		ФайлДБФ.поля.Добавить("SUM", "N", 15);
		ФайлДБФ.СоздатьФайл(РабочийКаталог+"Hash.dbf");
	КонецЕсли;
	
	ФайлДБФ.Первая();
	Пока Не ФайлДБФ.ВКонце() Цикл
		НоваяСтрока = ТаблицаЗначений.Добавить();
		НоваяСтрока.Имя = СокрЛП(ФайлДБФ.NAME);
		НоваяСтрока.ХэшБазы = ФайлДБФ.SUM;
		НоваяСтрока.Обновить = Истина;
		
		ФайлДБФ.Следующая();
	КонецЦикла;
	
	ФайлыНаСервере();
	
	ФайлДБФ.ЗакрытьФайл();
	
	Если ВидимаяТаблица.Количество() = 0 И ВсегдаОткрывать = Ложь Тогда 
		 Обновить();	
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКаталогНаДиске()
	
	КаталогНаДиске = Новый Файл(РабочийКаталог);
	Если НЕ КаталогНаДиске.Существует() Тогда
		Попытка
			СоздатьКаталог(РабочийКаталог);
		Исключение
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при создании каталога ""%1"":
			|""%2"".'"),
			РабочийКаталог,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()) );
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидимаяТаблицаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВидимаяТаблицаПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры
