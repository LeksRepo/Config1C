﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Управление доступом".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Обслуживание таблиц ВидыДоступа и ЗначенияДоступа в формах редактирования

// Только для внутреннего использования
Функция СформироватьДанныеВыбораПользователя(Знач Текст,
                                             Знач ВключаяГруппы = Истина,
                                             Знач ВключаяВнешнихПользователей = Неопределено,
                                             Знач БезПользователей = Ложь) Экспорт
	
	Возврат Пользователи.СформироватьДанныеВыбораПользователя(
		Текст,
		ВключаяГруппы,
		ВключаяВнешнихПользователей,
		БезПользователей);
	
КонецФункции

// Возвращает список значений доступа не помеченных на удаление.
//  Используется в обработчиках событий ОкончаниеВводаТекста и АвтоПодбор.
//
// Параметры:
//  Текст         - Строка, символы введенные пользователем.
//  ВключаяГруппы - Булево, если Истина, включать группы пользователей и внешних пользователей.
//  ВидДоступа    - Ссылка - пустая ссылка основного типа значения доступа,
//                - Строка - имя вида доступа, значения доступа которого выбираются.
//
Функция СформироватьДанныеВыбораЗначенияДоступа(Знач Текст, Знач ВидДоступа, ВключаяГруппы = Истина) Экспорт
	
	СвойстваВидаДоступа = УправлениеДоступомСлужебный.СвойстваВидаДоступа(ВидДоступа);
	Если СвойстваВидаДоступа = Неопределено Тогда
		Возврат Новый СписокЗначений;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	Запрос.УстановитьПараметр("ВключаяГруппы", ВключаяГруппы);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПредставленияПеречислений.Ссылка,
	|	ПредставленияПеречислений.Наименование КАК Наименование
	|ПОМЕСТИТЬ ПредставленияПеречислений
	|ИЗ
	|	&ПредставленияПеречислений КАК ПредставленияПеречислений
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НЕОПРЕДЕЛЕНО КАК Ссылка,
	|	"""" КАК Наименование
	|ГДЕ
	|	ЛОЖЬ";
	
	ЗапросПредставленийПеречислений = Новый Запрос;
	ЗапросПредставленийПеречислений.Текст =
	"ВЫБРАТЬ
	|	"""" КАК Ссылка,
	|	"""" КАК Наименование
	|ГДЕ
	|	ЛОЖЬ";
	
	Для каждого Тип Из СвойстваВидаДоступа.ТипыВыбираемыхЗначений Цикл
		
		МетаданныеТипа = Метаданные.НайтиПоТипу(Тип);
		
		ПолноеИмяТаблицы = МетаданныеТипа.ПолноеИмя();
		
		Если (     Метаданные.Справочники.Содержит(МетаданныеТипа)
		       ИЛИ Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеТипа) )
		   И МетаданныеТипа.Иерархический
		   И МетаданныеТипа.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов
		   И НЕ ВключаяГруппы Тогда
			
			УсловиеДляГруппы = "НЕ Таблица.ЭтоГруппа";
		Иначе
			УсловиеДляГруппы = "Истина";
		КонецЕсли;
		
		Если Метаданные.Перечисления.Содержит(МетаданныеТипа) Тогда
			//
			ЗапросПредставленийПеречислений.Текст = ЗапросПредставленийПеречислений.Текст + Символы.ПС + Символы.ПС + " ОБЪЕДИНИТЬ ВСЕ "  + Символы.ПС + Символы.ПС;
			ЗапросПредставленийПеречислений.Текст = ЗапросПредставленийПеречислений.Текст + СтрЗаменить(
			"ВЫБРАТЬ
			|	Таблица.Ссылка,
			|	ПРЕДСТАВЛЕНИЕ(Таблица.Ссылка) КАК Наименование
			|ИЗ
			|	&ПолноеИмяТаблицы КАК Таблица", "&ПолноеИмяТаблицы", ПолноеИмяТаблицы);
		Иначе
			Запрос.Текст = Запрос.Текст + Символы.ПС + Символы.ПС + " ОБЪЕДИНИТЬ ВСЕ "  + Символы.ПС + Символы.ПС;
			Запрос.Текст = Запрос.Текст + СтрЗаменить(СтрЗаменить(
			"ВЫБРАТЬ
			|	Таблица.Ссылка,
			|	Таблица.Наименование
			|ИЗ
			|	&ПолноеИмяТаблицы КАК Таблица
			|ГДЕ
			|	(НЕ Таблица.ПометкаУдаления)
			|	И Таблица.Наименование ПОДОБНО &Текст
			|	И &УсловиеДляГруппы", "&ПолноеИмяТаблицы", ПолноеИмяТаблицы), "&УсловиеДляГруппы", УсловиеДляГруппы);
		КонецЕсли;
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ПредставленияПеречислений", ЗапросПредставленийПеречислений.Выполнить().Выгрузить());
	Запрос.Текст = Запрос.Текст + Символы.ПС + Символы.ПС + " ОБЪЕДИНИТЬ ВСЕ "  + Символы.ПС + Символы.ПС;
	Запрос.Текст = Запрос.Текст +
	"ВЫБРАТЬ
	|	ПредставленияПеречислений.Ссылка,
	|	ПредставленияПеречислений.Наименование
	|ИЗ
	|	ПредставленияПеречислений КАК ПредставленияПеречислений
	|ГДЕ
	|	ПредставленияПеречислений.Наименование ПОДОБНО &Текст";
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.Наименование);
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции
