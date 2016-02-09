﻿
&НаКлиенте
Функция ВыполнитьОбновлениеОбязательныхФайлов() Экспорт
	
	//тз = СоздатьТаблицуЗначений();
	////тз.Индексы.Добавить("Имя");
	//
	//тз = Новый ТаблицаЗначений;
	//тз.Колонки.Добавить();
	
	//"required"
	
	// Для всех: флэшк, хтмл
	// Своим: все логотипы, и подразделений и дилеров
	// Дилерам: только свой логотип
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция ПолучитьФайлы()
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция СоздатьТаблицуЗначений()
	
	ВидыФайлов = Новый Массив;
	ВидыФайлов.Добавить(Перечисления.ВидыПрисоединенныхФайлов.ТекстураНоменклатуры);
	ВидыФайлов.Добавить(Перечисления.ВидыПрисоединенныхФайлов.ОсновнаяКартинка);
	ВидыФайлов.Добавить(Перечисления.ВидыПрисоединенныхФайлов.КартинкаЛевая);
	ВидыФайлов.Добавить(Перечисления.ВидыПрисоединенныхФайлов.КартинкаПравая);
	ВидыФайлов.Добавить(Перечисления.ВидыПрисоединенныхФайлов.КрышаЛевая);
	ВидыФайлов.Добавить(Перечисления.ВидыПрисоединенныхФайлов.КрышаПравая);
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя");
	
	Возврат Таблица;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьТаблицуИзКаталога(фнТаблица, ИмяФайла) Экспорт
	
	РабочийКаталог = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
	СоздатьКаталогНаДиске(РабочийКаталог);
	
	Попытка
		
		ФайлДБФ = Новый XBase(РабочийКаталог + ИмяФайла + ".dbf", ИмяФайла + ".cdx");
		
		Если НЕ ФайлДБФ.Открыта() Тогда
			
			СоздатьФайлДБФ(ФайлДБФ, РабочийКаталог, ИмяФайла);
			
		КонецЕсли;
		
	Исключение
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"Ошибка при открытии файла ""%1"":%2""%3"".'",
		ФайлДБФ,
		Символы.ПС,
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение ТекстСообщения;
		
	КонецПопытки;
	
	ФайлДБФ.Первая();
	Пока НЕ ФайлДБФ.ВКонце() Цикл
		
		НоваяСтрока = фнТаблица.Добавить();
		НоваяСтрока.Имя = СокрЛП(ФайлДБФ.NAME);
		НоваяСтрока.ХэшКаталога = ФайлДБФ.SUM;
		
		ФайлДБФ.Следующая();
		
	КонецЦикла;
	
	ФайлДБФ.ЗакрытьФайл();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКаталогНаДиске(фнКаталог) Экспорт
	
	КаталогНаДиске = Новый Файл(фнКаталог);
	Если НЕ КаталогНаДиске.Существует() Тогда
		
		Попытка
			СоздатьКаталог(фнКаталог);
		Исключение
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"Ошибка при создании каталога ""%1"":%2""%3"".'",
			фнКаталог,
			Символы.ПС,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ВызватьИсключение ТекстСообщения;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СоздатьФайлДБФ(ФайлДБФ, фнКаталог, ИмяФайла) Экспорт
	
	ФайлДБФ.Поля.Добавить("NAME", "S", 100);
	ФайлДБФ.Поля.Добавить("SUM", "N", 15);
	ФайлДБФ.индексы.Добавить("NAME", "NAME", Истина);
	
	ФайлДБФ.СоздатьФайл(фнКаталог + ИмяФайла +".dbf", ИмяФайла +".cdx");
	
	// Сделать.
	// Создать индекс и использовать для поиска.
	// А то примитивный перебор сейчас. :(
	//ФайлДБФ.СоздатьИндексныйФайл("hash.cdx");
	
КонецФункции

&НаСервере
Функция ЗаполнитьТаблицуИзБазы(фнТаблица, ВидыФайлов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидыФайлов", ВидыФайлов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Файлы.ВидФайла КАК ВидФайла,
	|	Файлы.ВладелецФайла КАК ВладелецФайла,
	|	Файлы.ТекущаяВерсия КАК ВерсияФайла,
	|	Файлы.ТекущаяВерсияРазмер / 1024 КАК Размер,
	|	ХранимыеФайлыВерсий.Хэш КАК ХэшБазы
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ХранимыеФайлыВерсий КАК ХранимыеФайлыВерсий
	|		ПО Файлы.ТекущаяВерсия = ХранимыеФайлыВерсий.ВерсияФайла
	|ГДЕ
	|	НЕ Файлы.ПометкаУдаления
	|	И Файлы.ВидФайла В(&ВидыФайлов)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Имя = ЛексСервер.ПолучитьИмяПрисоединенногоФайла(Выборка.ВидФайла, Выборка.ВладелецФайла);
		
		НайденныеСтроки = фнТаблица.НайтиСтроки(Новый Структура("Имя", Имя));
		КоличествоСтрок = НайденныеСтроки.Количество();
		Если КоличествоСтрок = 1 Тогда
			
			Строка = НайденныеСтроки[0];
			
			Если Выборка.ХэшБазы = Строка.ХэшКаталога Тогда
				фнТаблица.Удалить(Строка);
			Иначе
				Строка.ХэшБазы = Выборка.ХэшБазы;
				Строка.ВладелецФайла = Выборка.ВладелецФайла;
				Строка.ВерсияФайла = Выборка.ВерсияФайла;
				Строка.Размер = Выборка.Размер;
			КонецЕсли;
			
		ИначеЕсли КоличествоСтрок = 0 Тогда
			
			Строка = фнТаблица.Добавить();
			Строка.Имя = Имя;
			Строка.ХэшБазы = Выборка.ХэшБазы;
			Строка.ВладелецФайла = Выборка.ВладелецФайла;
			Строка.ВерсияФайла = Выборка.ВерсияФайла;
			Строка.Размер = Выборка.Размер;
			
		Иначе
			
			// Ошибка, несколько файлов с одинаковым именем.
			// Обработать, внести инфу в журнал регистрации, сообщить админам.
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция ЗаполнитьТаблицуОбязательныхФайлов(фнТаблица) Экспорт
	
	ЭтоДилер = ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя();
	ВерсияЛоготип = Неопределено;
	Логотипы = Неопределено;
	
	Запрос = Новый Запрос;
	
	ПапкиФайлов = Новый Массив;
	ПапкиФайлов.Добавить(Справочники.ПапкиФайлов.Flash);
	ПапкиФайлов.Добавить(Справочники.ПапкиФайлов.Html);
	
	Если ЭтоДилер Тогда
		ВерсияЛоготип = ПользователиКлиентСервер.ТекущийВнешнийПользователь().ОбъектАвторизации.Логотип.ТекущаяВерсия;
	Иначе
		Логотипы = Перечисления.ВидыПрисоединенныхФайлов.Логотип;
		ПапкиФайлов.Добавить(Справочники.ПапкиФайлов.ЛоготипыПодразделений);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ПапкиФайлов", ПапкиФайлов);
	Запрос.УстановитьПараметр("Логотипы", Логотипы);
	Запрос.УстановитьПараметр("ВерсияЛоготип", ВерсияЛоготип);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Файлы.ВидФайла КАК ВидФайла,
	|	Файлы.ВладелецФайла КАК ВладелецФайла,
	|	Файлы.ТекущаяВерсия КАК ВерсияФайла,
	|	Файлы.ТекущаяВерсияРазмер / 1024 КАК Размер,
	|	ХранимыеФайлыВерсий.Хэш КАК ХэшБазы,
	|	Файлы.ТекущаяВерсия.ПолноеНаименование КАК ПолноеНаименование,
	|	Файлы.ТекущаяВерсия.Расширение КАК Расширение
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ХранимыеФайлыВерсий КАК ХранимыеФайлыВерсий
	|		ПО Файлы.ТекущаяВерсия = ХранимыеФайлыВерсий.ВерсияФайла
	|ГДЕ
	|	НЕ Файлы.ПометкаУдаления
	|	И (Файлы.ВладелецФайла В (&ПапкиФайлов)
	|			ИЛИ Файлы.ВидФайла = &Логотипы
	|			ИЛИ Файлы.ТекущаяВерсия = &ВерсияЛоготип)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если ТипЗнч(Выборка.ВладелецФайла) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
			Имя = Выборка.ПолноеНаименование + "." + Выборка.Расширение;
		Иначе
			Имя = ЛексСервер.ПолучитьИмяПрисоединенногоФайла(Выборка.ВидФайла, Выборка.ВладелецФайла);
		КонецЕсли;
		
		НайденныеСтроки = фнТаблица.НайтиСтроки(Новый Структура("Имя", Имя));
		КоличествоСтрок = НайденныеСтроки.Количество();
		Если КоличествоСтрок = 1 Тогда
			
			Строка = НайденныеСтроки[0];
			
			Если Выборка.ХэшБазы = Строка.ХэшКаталога Тогда
				фнТаблица.Удалить(Строка);
			Иначе
				Строка.ХэшБазы = Выборка.ХэшБазы;
				Строка.ВладелецФайла = Выборка.ВладелецФайла;
				Строка.ВерсияФайла = Выборка.ВерсияФайла;
				Строка.Размер = Выборка.Размер;
			КонецЕсли;
			
		ИначеЕсли КоличествоСтрок = 0 Тогда
			
			Строка = фнТаблица.Добавить();
			Строка.Имя = Имя;
			Строка.ХэшБазы = Выборка.ХэшБазы;
			Строка.ВладелецФайла = Выборка.ВладелецФайла;
			Строка.ВерсияФайла = Выборка.ВерсияФайла;
			Строка.Размер = Выборка.Размер;
			
		Иначе
			
			// Ошибка, несколько файлов с одинаковым именем.
			// Обработать, внести инфу в журнал регистрации, сообщить админам.
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции
