﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Свойства"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"УправлениеСвойствамиСлужебный");
		
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииИсключенийПоискаСсылок"].Добавить(
		"УправлениеСвойствамиСлужебный");
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.УправлениеДоступом\ПриЗаполненииВидовОграниченийПравОбъектовМетаданных"].Добавить(
			"УправлениеСвойствамиСлужебный");
		
		СерверныеОбработчики["СтандартныеПодсистемы.УправлениеДоступом\ПриЗаполненииСвойствВидаДоступа"].Добавить(
			"УправлениеСвойствамиСлужебный");
	КонецЕсли;
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.6.7";
	Обработчик.Процедура = "УправлениеСвойствамиСлужебный.ОбновитьСписокДополнительныхСвойств";
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Собирает все свойства подчиненных наборов для корневого набора свойств,
// который всегда является группой.
//
// Параметры:
//  Объект       - СправочникОбъект.НаборыДополнительныхРеквизитовИСведений
//                 группа наборов дополнительных свойств.
//
Процедура ПередЗаписьюГруппыНаборовСвойств(Объект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Родитель", Объект.Ссылка);
	
	// Дополнительные реквизиты.
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДополнительныеРеквизиты.Свойство КАК Свойство
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
	|ГДЕ
	|	ДополнительныеРеквизиты.Ссылка.Родитель = &Родитель
	|	И ДополнительныеРеквизиты.Свойство.ЭтоДополнительноеСведение = ЛОЖЬ";
	
	Объект.ДополнительныеРеквизиты.Загрузить(Запрос.Выполнить().Выгрузить());
	
	// Дополнительные сведения.
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДополнительныеСведения.Свойство КАК Свойство
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|ГДЕ
	|	ДополнительныеСведения.Ссылка.Родитель = &Родитель
	|	И ДополнительныеСведения.Свойство.ЭтоДополнительноеСведение = ИСТИНА";
	
	Объект.ДополнительныеСведения.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

// Возвращает таблицу наборов доступных свойств владельца.
//
// Параметры:
//  ВладелецСвойств - Ссылка на владельца свойств.
//                    Объект владельца свойств.
//                    ДанныеФормыСтруктура (по типу объекта владельца свойств).
//
Функция ПолучитьНаборыСвойствОбъекта(Знач ВладелецСвойств) Экспорт
	
	Если ТипЗнч(ВладелецСвойств) = Тип("ДанныеФормыСтруктура") Тогда
		ТипСсылки = ТипЗнч(ВладелецСвойств.Ссылка)
		
	ИначеЕсли ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ВладелецСвойств)) Тогда
		ТипСсылки = ТипЗнч(ВладелецСвойств);
	Иначе
		ТипСсылки = ТипЗнч(ВладелецСвойств.Ссылка)
	КонецЕсли;
	
	ПолучатьОсновнойНабор = Истина;
	
	НаборыСвойств = Новый ТаблицаЗначений;
	НаборыСвойств.Колонки.Добавить("Набор");
	НаборыСвойств.Колонки.Добавить("Высота");
	НаборыСвойств.Колонки.Добавить("Заголовок");
	НаборыСвойств.Колонки.Добавить("Подсказка");
	НаборыСвойств.Колонки.Добавить("РастягиватьПоВертикали");
	НаборыСвойств.Колонки.Добавить("РастягиватьПоГоризонтали");
	НаборыСвойств.Колонки.Добавить("ТолькоПросмотр");
	НаборыСвойств.Колонки.Добавить("ЦветТекстаЗаголовка");
	НаборыСвойств.Колонки.Добавить("Ширина");
	НаборыСвойств.Колонки.Добавить("ШрифтЗаголовка");
	НаборыСвойств.Колонки.Добавить("Группировка");
	НаборыСвойств.Колонки.Добавить("Отображение");
	НаборыСвойств.Колонки.Добавить("ШиринаПодчиненныхЭлементов");
	НаборыСвойств.Колонки.Добавить("Картинка");
	НаборыСвойств.Колонки.Добавить("ОтображатьЗаголовок");
	
	УправлениеСвойствамиПереопределяемый.ЗаполнитьНаборыСвойствОбъекта(ВладелецСвойств, ТипСсылки, НаборыСвойств, ПолучатьОсновнойНабор);
	
	Если НаборыСвойств.Количество() = 0
	   И ПолучатьОсновнойНабор = Истина Тогда
		
		ОсновнойНабор = ПолучитьОсновнойНаборСвойствДляОбъекта(ВладелецСвойств);
		
		Если ЗначениеЗаполнено(ОсновнойНабор) Тогда
			НаборыСвойств.Добавить().Набор = ОсновнойНабор;
		КонецЕсли;
	КонецЕсли;
	
	Возврат НаборыСвойств;
	
КонецФункции

// Возвращает заполненную таблицу значений свойств объекта.
Функция ПолучитьТаблицуЗначенийСвойств(ДополнительныеСвойстваОбъекта, Наборы, ЭтоДополнительноеСведение) Экспорт
	
	Свойства = ДополнительныеСвойстваОбъекта.ВыгрузитьКолонку("Свойство");
	
	НаборыСвойств = Новый ТаблицаЗначений;
	
	НаборыСвойств.Колонки.Добавить(
		"Набор", Новый ОписаниеТипов("СправочникСсылка.НаборыДополнительныхРеквизитовИСведений"));
	
	НаборыСвойств.Колонки.Добавить(
		"ПорядокНабора", Новый ОписаниеТипов("Число"));
	
	Для каждого ЭлементСписка Из Наборы Цикл
		НоваяСтрока = НаборыСвойств.Добавить();
		НоваяСтрока.Набор         = ЭлементСписка.Значение;
		НоваяСтрока.ПорядокНабора = Наборы.Индекс(ЭлементСписка);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Свойства",      Свойства);
	Запрос.УстановитьПараметр("НаборыСвойств", НаборыСвойств);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НаборыСвойств.Набор,
	|	НаборыСвойств.ПорядокНабора
	|ПОМЕСТИТЬ НаборыСвойств
	|ИЗ
	|	&НаборыСвойств КАК НаборыСвойств
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НаборыСвойств.Набор,
	|	НаборыСвойств.ПорядокНабора,
	|	СвойстваНаборов.Свойство,
	|	СвойстваНаборов.ЗаполнятьОбязательно КАК ЗаполнятьОбязательно,
	|	СвойстваНаборов.НомерСтроки КАК ПорядокСвойства
	|ПОМЕСТИТЬ СвойстваНаборов
	|ИЗ
	|	НаборыСвойств КАК НаборыСвойств
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК СвойстваНаборов
	|		ПО (СвойстваНаборов.Ссылка = НаборыСвойств.Набор)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК Свойства
	|		ПО (СвойстваНаборов.Свойство = Свойства.Ссылка)
	|ГДЕ
	|	НЕ Свойства.ПометкаУдаления
	|	И НЕ Свойства.ЭтоГруппа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Свойства.Ссылка КАК Свойство
	|ПОМЕСТИТЬ ЗаполненныеСвойства
	|ИЗ
	|	ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК Свойства
	|ГДЕ
	|	Свойства.Ссылка В(&Свойства)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СвойстваНаборов.Набор,
	|	СвойстваНаборов.ПорядокНабора,
	|	СвойстваНаборов.Свойство,
	|	СвойстваНаборов.ЗаполнятьОбязательно,
	|	СвойстваНаборов.ПорядокСвойства,
	|	ЛОЖЬ КАК Удалено
	|ПОМЕСТИТЬ ВсеСвойства
	|ИЗ
	|	СвойстваНаборов КАК СвойстваНаборов
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Справочник.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка),
	|	0,
	|	ЗаполненныеСвойства.Свойство,
	|	0,
	|	0,
	|	ИСТИНА
	|ИЗ
	|	ЗаполненныеСвойства КАК ЗаполненныеСвойства
	|		ЛЕВОЕ СОЕДИНЕНИЕ СвойстваНаборов КАК СвойстваНаборов
	|		ПО ЗаполненныеСвойства.Свойство = СвойстваНаборов.Свойство
	|ГДЕ
	|	СвойстваНаборов.Свойство ЕСТЬ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВсеСвойства.Набор,
	|	ВсеСвойства.Свойство,
	|	ВЫБОР
	|		КОГДА ВсеСвойства.ЗаполнятьОбязательно = 0
	|			ТОГДА ДополнительныеРеквизитыИСведения.ЗаполнятьОбязательно
	|		КОГДА ВсеСвойства.ЗаполнятьОбязательно = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЗаполнятьОбязательно,
	|	ДополнительныеРеквизитыИСведения.Наименование,
	|	ДополнительныеРеквизитыИСведения.ТипЗначения,
	|	ДополнительныеРеквизитыИСведения.ФорматСвойства,
	|	ДополнительныеРеквизитыИСведения.МногострочноеПолеВвода,
	|	ВсеСвойства.Удалено КАК Удалено
	|ИЗ
	|	ВсеСвойства КАК ВсеСвойства
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК ДополнительныеРеквизитыИСведения
	|		ПО ВсеСвойства.Свойство = ДополнительныеРеквизитыИСведения.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Удалено,
	|	ВсеСвойства.ПорядокНабора,
	|	ВсеСвойства.ПорядокСвойства";
	
	Если ЭтоДополнительноеСведение Тогда
		
		Запрос.Текст = СтрЗаменить(
			Запрос.Текст,
			"Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты",
			"Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеСведения");
		
		Запрос.Текст = СтрЗаменить(
			Запрос.Текст,
			"СвойстваНаборов.ЗаполнятьОбязательно КАК ЗаполнятьОбязательно",
			"0 КАК ЗаполнятьОбязательно");
	КонецЕсли;
	
	ОписаниеСвойств = Запрос.Выполнить().Выгрузить();
	ОписаниеСвойств.Индексы.Добавить("Свойство");
	ОписаниеСвойств.Колонки.Добавить("Значение");
	
	// Удаление дублей свойств в нижестоящих наборах свойств.
	Индекс = ОписаниеСвойств.Количество()-1;
	
	Пока Индекс >= 0 Цикл
		Строка = ОписаниеСвойств[Индекс];
		НайденнаяСтрока = ОписаниеСвойств.Найти(Строка.Свойство);
		
		Если НайденнаяСтрока <> Неопределено
		   И НайденнаяСтрока <> Строка Тогда
			
			ОписаниеСвойств.Удалить(Индекс);
		КонецЕсли;
		
		Индекс = Индекс-1;
	КонецЦикла;
	
	// Заполнение значений свойств.
	Для Каждого Строка Из ДополнительныеСвойстваОбъекта Цикл
		ОписаниеСвойства = ОписаниеСвойств.Найти(Строка.Свойство, "Свойство");
		Если ОписаниеСвойства <> Неопределено Тогда
			// Поддержка строк неограниченной длины.
			Если НЕ ЭтоДополнительноеСведение
			   И ИспользоватьНеограниченнуюСтроку(
			         ОписаниеСвойства.ТипЗначения, ОписаниеСвойства.МногострочноеПолеВвода)
			   И НЕ ПустаяСтрока(Строка.ТекстоваяСтрока) Тогда 
				
				ОписаниеСвойства.Значение = Строка.ТекстоваяСтрока;
			Иначе
				ОписаниеСвойства.Значение = Строка.Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОписаниеСвойств;
	
КонецФункции

// Возвращает значения дополнительных сведений.
Функция ПрочитатьЗначенияСвойствИзРегистраСведений(ВладелецСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДополнительныеСведения.Свойство,
	|	ДополнительныеСведения.Значение
	|ИЗ
	|	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|ГДЕ
	|	ДополнительныеСведения.Объект = &Объект";
	Запрос.УстановитьПараметр("Объект", ВладелецСвойства);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает использование набором дополнительных сведений и реквизитов.
Функция ВидыСвойствНабора(Ссылка) Экспорт
	
	ВидыСвойствНабора = Новый Структура;
	ВидыСвойствНабора.Вставить("ДополнительныеРеквизиты", Ложь);
	ВидыСвойствНабора.Вставить("ДополнительныеСведения",  Ложь);
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат ВидыСвойствНабора;
	КонецЕсли;
	
	СвойстваСсылки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПометкаУдаления, ЭтоГруппа, Предопределенный, Родитель");
	
	Если СвойстваСсылки.ПометкаУдаления Тогда
		Возврат ВидыСвойствНабора;
	КонецЕсли;
	
	Если СвойстваСсылки.ЭтоГруппа Тогда
		СсылкаПредопределенного = Ссылка;
		
	ИначеЕсли СвойстваСсылки.Предопределенный
	        И СвойстваСсылки.Родитель = Справочники.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка() Тогда
		
		СсылкаПредопределенного = Ссылка;
	Иначе
		СсылкаПредопределенного = Ссылка.Родитель;
	КонецЕсли;
	
	ИмяПредопределенного = ОбщегоНазначения.ИмяПредопределенного(СсылкаПредопределенного);
	
	Если НЕ ЗначениеЗаполнено(ИмяПредопределенного) Тогда
		Возврат ВидыСвойствНабора;
	КонецЕсли;
	
	Позиция = Найти(ИмяПредопределенного, "_");
	
	ПерваяЧастьИмени =  Лев(ИмяПредопределенного, Позиция - 1);
	ВтораяЧастьИмени = Прав(ИмяПредопределенного, СтрДлина(ИмяПредопределенного) - Позиция);
	
	ВидыСвойствНабора = Новый Структура;
	
	// Проверка использования дополнительных реквизитов.
	МетаданныеВладельцаСвойств = Метаданные.НайтиПоПолномуИмени(ПерваяЧастьИмени + "." + ВтораяЧастьИмени);
	
	ВидыСвойствНабора.Вставить(
		"ДополнительныеРеквизиты",
		МетаданныеВладельцаСвойств <> Неопределено
		И МетаданныеВладельцаСвойств.ТабличныеЧасти.Найти("ДополнительныеРеквизиты") <> Неопределено );
	
	// Проверка использования дополнительных сведений.
	Тип = Тип(ПерваяЧастьИмени + "Ссылка." + ВтораяЧастьИмени);
	
	ВидыСвойствНабора.Вставить(
		"ДополнительныеСведения",
		      Метаданные.ОбщиеКоманды.Найти("ДополнительныеСведенияКоманднаяПанель") <> Неопределено
		    И Метаданные.ОбщиеКоманды.ДополнительныеСведенияКоманднаяПанель.ТипПараметраКоманды.СодержитТип(Тип)
		ИЛИ   Метаданные.ОбщиеКоманды.Найти("ДополнительныеСведенияПанельНавигации") <> Неопределено
		    И Метаданные.ОбщиеКоманды.ДополнительныеСведенияПанельНавигации.ТипПараметраКоманды.СодержитТип(Тип) );
	
	Возврат ВидыСвойствНабора;
	
КонецФункции

// Определяет, что тип значения содержит тип дополнительных значений свойств.
Функция ТипЗначенияСодержитЗначенияСвойств(ТипЗначения) Экспорт
	
	Возврат ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов"))
	    ИЛИ ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия"));
	
КонецФункции

// Проверяет возможность использования для свойства строки неограниченный длины.
Функция ИспользоватьНеограниченнуюСтроку(ТипЗначенияСвойства, МногострочноеПолеВвода) Экспорт
	
	Если ТипЗначенияСвойства.СодержитТип(Тип("Строка"))
	   И ТипЗначенияСвойства.Типы().Количество() = 1
	   И МногострочноеПолеВвода > 1 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Заполняет массив списком имен объектов метаданных, данные которых могут содержать ссылки на различные объекты метаданных,
// но при этом эти ссылки не должны учитываться в бизнес-логике приложения.
//
// Параметры:
//  Массив       - массив строк, например, "РегистрСведений.ВерсииОбъектов".
//
Процедура ПриДобавленииИсключенийПоискаСсылок(Массив) Экспорт
	
	Массив.Добавить(Метаданные.РегистрыСведений.ДополнительныеСведения.ПолноеИмя());
	
КонецПроцедуры

// Заполняет состав видов доступа, используемых при ограничении прав объектов метаданных.
// Если состав видов доступа не заполнен, отчет "Права доступа" покажет некорректные сведения.
//
// Обязательно требуется заполнить только виды доступа, используемые
// в шаблонах ограничения доступа явно, а виды доступа, используемые
// в наборах значений доступа могут быть получены из текущего состояния
// регистра сведений НаборыЗначенийДоступа.
//
//  Для автоматической подготовки содержимого процедуры следует
// воспользоваться инструментами разработчика для подсистемы
// Управление доступом.
//
// Параметры:
//  Описание     - Строка, многострочная строка формата <Таблица>.<Право>.<ВидДоступа>[.Таблица объекта]
//                 Например, Документ.ПриходнаяНакладная.Чтение.Организации
//                           Документ.ПриходнаяНакладная.Чтение.Контрагенты
//                           Документ.ПриходнаяНакладная.Добавление.Организации
//                           Документ.ПриходнаяНакладная.Добавление.Контрагенты
//                           Документ.ПриходнаяНакладная.Изменение.Организации
//                           Документ.ПриходнаяНакладная.Изменение.Контрагенты
//                           Документ.ЭлектронныеПисьма.Чтение.Объект.Документ.ЭлектронныеПисьма
//                           Документ.ЭлектронныеПисьма.Добавление.Объект.Документ.ЭлектронныеПисьма
//                           Документ.ЭлектронныеПисьма.Изменение.Объект.Документ.ЭлектронныеПисьма
//                           Документ.Файлы.Чтение.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Чтение.Объект.Документ.ЭлектронноеПисьмо
//                           Документ.Файлы.Добавление.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Добавление.Объект.Документ.ЭлектронноеПисьмо
//                           Документ.Файлы.Изменение.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Изменение.Объект.Документ.ЭлектронноеПисьмо
//                 Вид доступа Объект предопределен, как литерал, его нет в предопределенных элементах
//                 ПланыВидовХарактеристик.ВидыДоступа. Этот вид доступа используется в шаблонах ограничений доступа,
//                 как "ссылка" на другой объект, по которому ограничивается таблица.
//                 Когда вид доступа "Объект" задан, также требуется задать типы таблиц, которые используются
//                 для этого вида доступа. Т.е. перечислить типы, которые соответствующие полю,
//                 использованному в шаблоне ограничения доступа в паре с видом доступа "Объект".
//                 При перечислении типов по виду доступа "Объект" нужно перечислить только те типы поля,
//                 которые есть у поля РегистрыСведений.НаборыЗначенийДоступа.Объект, остальные типы лишние.
// 
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	Описание = Описание + 
	"
	|ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Чтение.ДополнительныеСведения
	|РегистрСведений.ДополнительныеСведения.Чтение.ДополнительныеСведения
	|РегистрСведений.ДополнительныеСведения.Изменение.ДополнительныеСведения
	|";
	
КонецПроцедуры

// Заполняет свойства видов доступа, добавленных прикладным разработчиком
// в план видов характеристик ВидыДоступа, как предопределенные элементы.
//
// Параметры:
//  Свойства - Структура со свойствами,
//             описание которых см. в комментарии к функции
//             ПланыВидовХарактеристик.ВидыДоступа.СвойстваВидовДоступа().
//
Процедура ПриЗаполненииСвойствВидаДоступа(Знач Свойства) Экспорт
	
	Если Свойства.ВидДоступа = ПланыВидовХарактеристик["ВидыДоступа"].ДополнительныеСведения Тогда
		Свойства.Таблицы.Добавить("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

// Возвращает основной набор свойств владельца.
//
// Параметры:
//  ВладелецСвойств - Ссылка или Объект владельца свойств.
//
// Возвращаемое значение:
//  СправочникСсылка.НаборыДополнительныхРеквизитовИСведений -
//   когда для типа владельца свойств не задано имя реквизита вида объекта в процедуре
//         УправлениеСвойствамиПереопределяемый.ПолучитьИмяРеквизитаВидаОбъекта(),
//   тогда возвращается предопределенный элемент с именем в формате полное имя
//         объекта метаданных, у которого символ "." заменен символом "_",
//   иначе возвращается значение реквизита НаборСвойств того вида, который
//         содержится в реквизите владельца свойств с именем заданным в
//         переопределяемой процедуре.
//
//  Неопределено - когда владелец свойств - группа элементов справочника или
//                 группа элементов плана видов характеристик.
//  
Функция ПолучитьОсновнойНаборСвойствДляОбъекта(ВладелецСвойств)
	
	ПереданОбъект = Ложь;
	Если ОбщегоНазначения.ЗначениеСсылочногоТипа(ВладелецСвойств) Тогда
		Ссылка = ВладелецСвойств;
	Иначе
		ПереданОбъект = Истина;
		Ссылка = ВладелецСвойств.Ссылка;
	КонецЕсли;
	
	МетаданныеОбъекта = Ссылка.Метаданные();
	ИмяОбъектаМетаданных = МетаданныеОбъекта.Имя;
	
	ВидОбъектаМетаданных = ОбщегоНазначения.ВидОбъектаПоСсылке(Ссылка);
	ИмяРеквизитаВидаВладельцевСвойств = УправлениеСвойствамиПереопределяемый.ПолучитьИмяРеквизитаВидаОбъекта(Ссылка);
	
	Если ИмяРеквизитаВидаВладельцевСвойств = "" Тогда
		Если ВидОбъектаМетаданных = "Справочник" или ВидОбъектаМетаданных = "ПланВидовХарактеристик" Тогда
			Если ОбщегоНазначения.ОбъектЯвляетсяГруппой(ВладелецСвойств) Тогда
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
		ИмяЭлемента = ВидОбъектаМетаданных + "_" + ИмяОбъектаМетаданных;
		Возврат Справочники.НаборыДополнительныхРеквизитовИСведений[ИмяЭлемента];
	Иначе
		Если ПереданОбъект = Истина Тогда
			
			Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				ВладелецСвойств[ИмяРеквизитаВидаВладельцевСвойств], "НаборСвойств");
		Иначе
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ОбъектВладелецСвойств." + ИмяРеквизитаВидаВладельцевСвойств + ".НаборСвойств КАК Набор
			|ИЗ
			|	" + ВидОбъектаМетаданных + "." + ИмяОбъектаМетаданных + " КАК ОбъектВладелецСвойств
			|ГДЕ
			|	ОбъектВладелецСвойств.Ссылка = &Ссылка";
			
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Результат = Запрос.Выполнить();
			
			Если НЕ Результат.Пустой() Тогда
				
				Выборка = Результат.Выбрать();
				Выборка.Следующий();
				
				Если ЗначениеЗаполнено(Выборка.Набор) Тогда
					Возврат Выборка.Набор;
				Иначе
					Возврат Справочники.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка();
				КонецЕсли;
			Иначе
				Возврат Справочники.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Обновляет наборы дополнительных реквизитов и сведений в информационной базе.
// Используется для перехода к новому формату хранения.
//
Процедура ОбновитьСписокДополнительныхСвойств() Экспорт
	
	НаборыДополнительныхРеквизитовИСведений = Справочники.НаборыДополнительныхРеквизитовИСведений.Выбрать();
	
	Пока НаборыДополнительныхРеквизитовИСведений.Следующий() Цикл
		
		ДопСведения = Новый Массив;
		
		НаборСвойствОбъект = НаборыДополнительныхРеквизитовИСведений.Ссылка.ПолучитьОбъект();
		
		Для Каждого Запись Из НаборСвойствОбъект.ДополнительныеРеквизиты Цикл
			Если Запись.Свойство.ЭтоДополнительноеСведение Тогда
				ДопСведения.Добавить(Запись);
			КонецЕсли;
		КонецЦикла;
		
		Если ДопСведения.Количество() > 0 Тогда
			
			Для Каждого ДопСведение Из ДопСведения Цикл
				НоваяСтрока = НаборСвойствОбъект.ДополнительныеСведения.Добавить();
				НоваяСтрока.Свойство = ДопСведение.Свойство;
				НаборСвойствОбъект.ДополнительныеРеквизиты.Удалить(
					НаборСвойствОбъект.ДополнительныеРеквизиты.Индекс(ДопСведение));
				
			КонецЦикла;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборСвойствОбъект);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
