﻿&НаКлиенте
Процедура Обновить(Команда)
	
	СтрокиДляУдаления = ТаблицаЗначений.НайтиСтроки(Новый Структура("Обновить", Ложь));
	Для каждого Строка Из СтрокиДляУдаления Цикл
		ТаблицаЗначений.Удалить(Строка);
	КонецЦикла;
	
	КоличествоОбновить = ТаблицаЗначений.Количество();
	Шаг = Окр((КоличествоОбновить / 10) + 0.5, 0, РежимОкругления.Окр15как20);
	ШагОбновления = Макс(Шаг, 10);
	ШагПрогресса = Мин(Шаг, 10);
	ДатаНачалаПроцесса = ТекущаяДата();
	
	Если КоличествоОбновить > 0 Тогда
		ФайлДБФ = Новый XBase(РабочийКаталог + "Hash.dbf");
		
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
		
	КонецЕсли;
	
	ЭтаФорма.Закрыть();
	
	ПоказатьОповещениеПользователя("Обновление файлов.", , "Обновление файлов прошло успешно.", БиблиотекаКартинок.Информация32);
	
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
	
	ЭтаФорма.Закрыть();
	ПоказатьОповещениеПользователя("Обновление файлов.", , "Обновление файлов отменено.", БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	Для каждого Элемент Из ТаблицаЗначений Цикл
		Элемент.Обновить = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда)
	
	Для каждого Элемент Из ТаблицаЗначений Цикл
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
	
КонецПроцедуры

&НаСервере
Процедура ФайлыНаСервере()
	
	НоваяТаблица = РеквизитФормыВЗначение("ТаблицаЗначений");
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ХранимыеФайлыВерсий.ХранимыйФайл,
	|	ХранимыеФайлыВерсий.ВерсияФайла.Владелец КАК Владелец,
	|	ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ТекущаяВерсияРасширение КАК Расширение,
	|	ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла.Код КАК Код,
	|	ХранимыеФайлыВерсий.ВерсияФайла КАК ВладелецФайла,
	|	ХранимыеФайлыВерсий.ВерсияФайла.Размер КАК Размер,
	|	ХранимыеФайлыВерсий.ВерсияФайла.Владелец.РасположениеКартинки КАК РасположениеКартинки,    
	|	ВЫБОР
	|		КОГДА ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла ССЫЛКА Справочник.Номенклатура
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоНоменклатура,
	|	ХранимыеФайлыВерсий.ВерсияФайла.Владелец.Код КАК КодФайла,
	|	ВЫБОР
	|		КОГДА ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла ССЫЛКА Справочник.КаталогИзделий
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоИзделие
	|ИЗ
	|	РегистрСведений.ХранимыеФайлыВерсий КАК ХранимыеФайлыВерсий
	|ГДЕ
	|	(ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла ССЫЛКА Справочник.Номенклатура
	|			ИЛИ ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла ССЫЛКА Справочник.КаталогИзделий
	|				И ХранимыеФайлыВерсий.ВерсияФайла.Владелец.Основной
	|			ИЛИ ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла = ЗНАЧЕНИЕ(Справочник.ПапкиФайлов.Flash)
	|			ИЛИ ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла = ЗНАЧЕНИЕ(Справочник.ПапкиФайлов.Html))
	|	И ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ТекущаяВерсия.НомерВерсии = ХранимыеФайлыВерсий.ВерсияФайла.НомерВерсии
	|	И НЕ ХранимыеФайлыВерсий.ВерсияФайла.ПометкаУдаления";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ЭтоНоменклатура Тогда
			Имя = СокрЛП(Выборка.Код)+"."+Выборка.Расширение;//только jpg
		ИначеЕсли Выборка.ЭтоИзделие Тогда
			Имя = "Изделие" + Выборка.РасположениеКартинки + СокрЛП(Выборка.Код); //СокрЛП(Выборка.Владелец.ВладелецФайла);//+"."+Выборка.Расширение;
		Иначе
			Имя = СокрЛП(Выборка.Владелец)+"."+Выборка.Расширение;
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
			НоваяСтрока.Размер = Выборка.Размер/1024;
			НоваяСтрока.Обновить = Истина;
			НоваяСтрока.КодФайла = Выборка.КодФайла;
		Иначе
			Если Строка[0].ХэшБазы <> ХэшБазы Тогда
				Строка[0].ХэшБазы = ХэшБазы;
				Строка[0].ВладелецФайла = Выборка.ВладелецФайла;
				Строка[0].Размер = Выборка.Размер/1024;
				Строка[0].Обновить = Истина;
				Строка[0].КодФайла = Выборка.КодФайла;
			Иначе
				НоваяТаблица.Удалить(Строка[0]);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ИтогКоличество = НоваяТаблица.Количество();
	ИтогРазмер = НоваяТаблица.Итог("Размер") / 1024 ;
	ЗначениеВРеквизитФормы(НоваяТаблица, "ТаблицаЗначений");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ПоказатьОповещениеПользователя("Обновление файлов.", , "Обновление файлов отменено.", БиблиотекаКартинок.Информация32);
	
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
