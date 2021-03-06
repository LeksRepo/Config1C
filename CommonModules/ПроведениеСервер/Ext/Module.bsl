﻿///////////////////////////////////////////////////////////////////////////////////
// Процедуры для подготовки и записи движений документа.

// Процедура инициализирует общие структуры, используемые при проведении документов.
// Вызывается из модуля документов при проведении.
//
Процедура ИнициализироватьДополнительныеСвойстваДляПроведения(ДокументСсылка, ДополнительныеСвойства, РежимПроведения = Неопределено) Экспорт

	// В структуре "ДополнительныеСвойства" создаются свойства с ключами "ТаблицыДляДвижений", "ДляПроведения".

	// "ТаблицыДляДвижений" - структура, которая будет содержать таблицы значений с данными для выполнения движений.
	ДополнительныеСвойства.Вставить("ТаблицыДляДвижений", Новый Структура);

	// "ДляПроведения" - структура, содержащая свойства и реквизиты документа, необходимые для проведения.
	ДополнительныеСвойства.Вставить("ДляПроведения", Новый Структура);
	
	// Структура, содержащая ключ с именем "МенеджерВременныхТаблиц", в значении которого хранится менеджер временных таблиц.
	// Содержит для каждой временной таблицы ключ (имя временной таблицы) и значение (признак наличия записей во временной таблице).
	ДополнительныеСвойства.ДляПроведения.Вставить("СтруктураВременныеТаблицы", Новый Структура("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц));
	ДополнительныеСвойства.ДляПроведения.Вставить("РежимПроведения",           РежимПроведения);
	ДополнительныеСвойства.ДляПроведения.Вставить("МетаданныеДокумента",       ДокументСсылка.Метаданные());
	ДополнительныеСвойства.ДляПроведения.Вставить("Ссылка",                    ДокументСсылка);

КонецПроцедуры

Процедура ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства) Экспорт

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();

КонецПроцедуры

// Функция формирует массив имен регистров, по которым документ имеет движения.
// Вызывается при подготовке записей к регистрации движений.
//
Функция ПолучитьМассивИспользуемыхРегистров(Регистратор, Движения, МассивИсключаемыхРегистров = Неопределено) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Регистратор);

	Результат = Новый Массив;
	МаксимумТаблицВЗапросе = 256;

	СчетчикТаблиц   = 0;
	СчетчикДвижений = 0;

	ВсегоДвижений = Движения.Количество();
	ТекстЗапроса  = "";
	Для Каждого Движение Из Движения Цикл

		СчетчикДвижений = СчетчикДвижений + 1;

		ПропуститьРегистр = МассивИсключаемыхРегистров <> Неопределено
							И МассивИсключаемыхРегистров.Найти(Движение.Имя) <> Неопределено;

		Если Не ПропуститьРегистр Тогда

			Если СчетчикТаблиц > 0 Тогда

				ТекстЗапроса = ТекстЗапроса + "
				|ОБЪЕДИНИТЬ ВСЕ
				|";

			КонецЕсли;

			СчетчикТаблиц = СчетчикТаблиц + 1;

			ТекстЗапроса = ТекстЗапроса + 
			"
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|""" + Движение.Имя + """ КАК ИмяРегистра
			|
			|ИЗ " + Движение.ПолноеИмя() + "
			|
			|ГДЕ Регистратор = &Регистратор
			|";

		КонецЕсли;

		Если СчетчикТаблиц = МаксимумТаблицВЗапросе Или СчетчикДвижений = ВсегоДвижений Тогда

			Запрос.Текст  = ТекстЗапроса;
			ТекстЗапроса  = "";
			СчетчикТаблиц = 0;

			Если Результат.Количество() = 0 Тогда

				Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяРегистра");

			Иначе

				Выборка = Запрос.Выполнить().Выбрать();
				Пока Выборка.Следующий() Цикл
					Результат.Добавить(Выборка.ИмяРегистра);
				КонецЦикла;

			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Процедура выполняет пордготовку наборов записей документа к записи движений.
// 1. Очищает наборы записей от "старых записей" (ситуация возможна только в толстом клиенте)
// 2. Взводит флаг записи у наборов, по которым документ имеет движения
// Вызывается из модуля документов при проведении.
//
Процедура ПодготовитьНаборыЗаписейКРегистрацииДвижений(Объект) Экспорт

	Для Каждого НаборЗаписей Из Объект.Движения Цикл

		Если НаборЗаписей.Количество() > 0 Тогда
			НаборЗаписей.Очистить();
		КонецЕсли;

	КонецЦикла;

	Если Не Объект.ДополнительныеСвойства.ЭтоНовый Тогда

		МассивИменРегистров = ПолучитьМассивИспользуемыхРегистров(Объект.Ссылка,
				Объект.ДополнительныеСвойства.ДляПроведения.МетаданныеДокумента.Движения);

		Для Каждого ИмяРегистра Из МассивИменРегистров Цикл
			Объект.Движения[ИмяРегистра].Записывать = Истина;
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

Процедура УстановитьРежимПроведения(ДокументОбъект, РежимЗаписи, РежимПроведения) Экспорт

	Если ДокументОбъект.Проведен И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РежимПроведения = РежимПроведенияДокумента.Неоперативный;
	КонецЕсли;

КонецПроцедуры

// Процедура записывает движения документа. Дополнительно происходит копирование параметров
// в модули наборов записей для выполнения регистрации изменений в движениях.
// Процедура вызывается из модуля документов при проведении.
//
Процедура ЗаписатьНаборыЗаписей(Объект) Экспорт
	Перем РегистрыДляКонтроля;

	// Регистры, для которых будут рассчитаны таблицы изменений движений.
	Если Объект.ДополнительныеСвойства.ДляПроведения.Свойство("РегистрыДляКонтроля", РегистрыДляКонтроля) Тогда
		Для Каждого НаборЗаписей Из РегистрыДляКонтроля Цикл
			Если НаборЗаписей.Записывать Тогда

				// Установка флага регистрации изменений в наборе записей.
				НаборЗаписей.ДополнительныеСвойства.Вставить("РассчитыватьИзменения", Истина);
				НаборЗаписей.ДополнительныеСвойства.Вставить("ЭтоНовый", Объект.ДополнительныеСвойства.ЭтоНовый);

				// Структура для передачи данных в модули наборов записей.
				НаборЗаписей.ДополнительныеСвойства.Вставить("ДляПроведения", 
						Новый Структура("СтруктураВременныеТаблицы", Объект.ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы));

			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Объект.Движения.Записать();

КонецПроцедуры

// Функция проверяет наличие изменений в таблице регистра.
//
Функция ЕстьИзмененияВТаблице(СтруктураДанных, Ключ)
	
	Перем ЕстьИзменения;

	Возврат СтруктураДанных.Свойство(Ключ, ЕстьИзменения) И ЕстьИзменения;

КонецФункции

// Процедура выполняет контроль результатов проведения.
// Процедура вызывается из модуля документов при проведении.
//
Процедура ВыполнитьКонтрольРезультатовПроведения(Объект, Отказ) Экспорт

	Если Объект.ДополнительныеСвойства.ДляПроведения.РегистрыДляКонтроля.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ДанныеТаблиц    = Объект.ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	ПакетЗапросов   = Новый Запрос;
	МассивКонтролей = Новый Массив;
	ТекстЗапроса    = "";

	// Контроль отрицательных остатков ДенежныеСредстваОрганизаций.
	Если ЕстьИзмененияВТаблице(ДанныеТаблиц,"ДенежныеСредстваОрганизаций") Тогда

		МассивКонтролей.Добавить(Врег("ДенежныеСредстваОрганизаций"));
		ПакетЗапросов.УстановитьПараметр("ДанныеТаблиц", ДанныеТаблиц);
	//	ТекстЗапроса = ТекстЗапроса + 
	//	""
	//
	//	|///////////////////////////////////////////////////////////////////
	//	|";
	КонецЕсли;

	Если МассивКонтролей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ПакетЗапросов.Текст = ТекстЗапроса;
	ПакетЗапросов.МенеджерВременныхТаблиц = ДанныеТаблиц.МенеджерВременныхТаблиц;
	МассивРезультатов = ПакетЗапросов.ВыполнитьПакет();

	Итератор = -1;
	Для Каждого Результат Из МассивРезультатов Цикл

		Итератор = Итератор + 1;
		Если Результат.Пустой() Тогда
			Продолжить;
		КонецЕсли;

		ИмяКонтроля = МассивКонтролей[Итератор];

		Если ИмяКонтроля = Врег("ДенежныеСредстваОрганизаций") Тогда

			СообщитьОбОшибкахПроведенияПоРегиструДенежныеСредстваОрганизаций(Объект, Отказ, Результат);

		Иначе

			ВызватьИсключение НСтр("ru = 'Ошибка контроля проведения!'");

		КонецЕсли;
	КонецЦикла;

	Если Отказ Тогда

		Если Объект.ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			ТекстСообщения = НСтр("ru = 'Проведение не выполнено '");
		Иначе
			ТекстСообщения = НСтр("ru = 'Отмена проведения не выполнена '");
		КонецЕсли;

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения + Строка(Объект), Объект);

	КонецЕсли;

КонецПроцедуры

Процедура СообщитьОбОшибкахПроведенияПоРегиструДенежныеСредстваОрганизаций(Объект, Отказ, РезультатЗапроса)

	ШаблонСообщения = НСтр("ru = 'По счету %Счет% 
		|Не хватает средств для  операции!'");

	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл

		ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%Счет%", Строка(Выборка.Счет));

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект, ,, Отказ);

	КонецЦикла;

КонецПроцедуры

Процедура ОтразитьВнутренниеВзаиморасчеты(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаВнутренниеВзаиморасчеты = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаВнутренниеВзаиморасчеты;
	ДвиженияВнутренниеВзаиморасчеты = Движения.ВнутренниеВзаиморасчеты;
	ДвиженияВнутренниеВзаиморасчеты.Записывать = Истина;
	ДвиженияВнутренниеВзаиморасчеты.Загрузить(ТаблицаВнутренниеВзаиморасчеты);

КонецПроцедуры
  
Процедура ОтразитьВзаиморасчетыСКонтрагентами(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаВзаиморасчетыСКонтрагентами = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаВзаиморасчетыСКонтрагентами;
	ДвиженияВзаиморасчетыСКонтрагентами = Движения.ВзаиморасчетыСКонтрагентами;
	ДвиженияВзаиморасчетыСКонтрагентами.Записывать = Истина;
	ДвиженияВзаиморасчетыСКонтрагентами.Загрузить(ТаблицаВзаиморасчетыСКонтрагентами);

КонецПроцедуры
  
Процедура ОтразитьДенежныеСредстваОрганизаций(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаДенежныеСредстваОрганизаций = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДенежныеСредстваОрганизаций;
	ДвиженияДенежныеСредстваОрганизаций = Движения.ДенежныеСредстваОрганизаций;
	ДвиженияДенежныеСредстваОрганизаций.Записывать = Истина;
	ДвиженияДенежныеСредстваОрганизаций.Загрузить(ТаблицаДенежныеСредстваОрганизаций);

КонецПроцедуры

Процедура ОтразитьФинансовыеРезультаты(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаФинансовыеРезультаты = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаФинансовыеРезультаты;
	ДвиженияФинансовыеРезультаты = Движения.ФинансовыеРезультаты;
	ДвиженияФинансовыеРезультаты.Записывать = Истина;
	ДвиженияФинансовыеРезультаты.Загрузить(ТаблицаФинансовыеРезультаты);

КонецПроцедуры
  
Процедура ОтразитьВзаиморасчетыСФизЛицами(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаВзаиморасчетыСФизЛицами = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаВзаиморасчетыСФизЛицами;
	ДвиженияВзаиморасчетыСФизЛицами = Движения.ВзаиморасчетыСФизЛицами;
	ДвиженияВзаиморасчетыСФизЛицами.Записывать = Истина;
	ДвиженияВзаиморасчетыСФизЛицами.Загрузить(ТаблицаВзаиморасчетыСФизЛицами);

КонецПроцедуры
  
Процедура ОтразитьМатериалыНаСкладах(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаМатериалыНаСкладах = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаМатериалыНаСкладах;
	ДвиженияМатериалыНаСкладах = Движения.МатериалыНаСкладах;
	ДвиженияМатериалыНаСкладах.Записывать = Истина;
	ДвиженияМатериалыНаСкладах.Загрузить(ТаблицаМатериалыНаСкладах);

КонецПроцедуры
  
Процедура ОтразитьОприходованиеНаСклад(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаОприходованиеНаСклад = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОприходованиеНаСклад;
	ДвиженияОприходованиеНаСклад = Движения.ОприходованиеНаСклад;
	ДвиженияОприходованиеНаСклад.Записывать = Истина;
	ДвиженияОприходованиеНаСклад.Загрузить(ТаблицаОприходованиеНаСклад);

КонецПроцедуры

Процедура ОтразитьЦеныПоставщиков(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаЦеныПоставщиков = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаЦеныПоставщиков;
	ДвиженияЦеныПоставщиков = Движения.ЦеныПоставщиков;
	ДвиженияЦеныПоставщиков.Записывать = Истина;
	ДвиженияЦеныПоставщиков.Загрузить(ТаблицаЦеныПоставщиков);

КонецПроцедуры

Процедура ОтразитьРаботникиПодразделений(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаРаботникиПодразделений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРаботникиПодразделений;
	ДвиженияРаботникиПодразделений = Движения.РаботникиПодразделений;
	ДвиженияРаботникиПодразделений.Записывать = Истина;
	ДвиженияРаботникиПодразделений.Загрузить(ТаблицаРаботникиПодразделений);

КонецПроцедуры

