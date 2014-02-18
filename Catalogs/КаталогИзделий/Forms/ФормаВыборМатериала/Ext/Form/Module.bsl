﻿
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ОтборНоменклатурныхГрупп(СписокНоменклатурныхГрупп)
	
	СтруктураМассивов = Новый Структура;
	Для каждого НоменклатурнаяГруппа Из СписокНоменклатурныхГрупп Цикл
		ИмяГруппы = Справочники.НоменклатурныеГруппы.ПолучитьИмяПредопределенного(НоменклатурнаяГруппа.Значение);
		СтруктураМассивов.Вставить(ИмяГруппы, Новый Массив);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокНоменклатурныхГрупп", СписокНоменклатурныхГрупп);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка,
	|	СпрНоменклатура.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|ГДЕ
	|	СпрНоменклатура.НоменклатурнаяГруппа В(&СписокНоменклатурныхГрупп)
	|	И СпрНоменклатура.Базовый
	|ИТОГИ ПО
	|	НоменклатурнаяГруппа";
	
	Результат = Запрос.Выполнить();
	ВыборкаИтоги = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаИтоги.Следующий() Цикл
		
		Выборка = ВыборкаИтоги.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		ИмяГруппы = Справочники.НоменклатурныеГруппы.ПолучитьИмяПредопределенного(ВыборкаИтоги.НоменклатурнаяГруппа);
		
		Пока Выборка.Следующий() Цикл
			
			СтруктураМассивов[ИмяГруппы].Добавить(Выборка.Ссылка);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат СтруктураМассивов;
	
КонецФункции // ОтборНоменклатурныхГрупп()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

&НаСервере
Функция ПолучитьАдресХранилища()
	
	Возврат ПоместитьВоВременноеХранилище(Детали.Выгрузить());
	
КонецФункции

&НаКлиенте
Процедура ОбновитьДоступность()
	
	ТекущиеДанные = Элементы.Детали.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Материал = ТекущиеДанные.Материал;
		Столешница = Материал = "Столешница";
		Стекла = Материал = "Стекло";
		СтеклянныйФасад = Материал = "ФасадСтеклянный";
		ГнутыйСтФасад = Материал = "ФасадСтеклянныйЗакругленный";
		Фасад = ГнутыйСтФасад ИЛИ СтеклянныйФасад ИЛИ Материал = "ФасадАГТ" ИЛИ Материал = "ФасадЛДСП" ИЛИ Материал = "ФасадМДФ" ИЛИ Материал = "ФасадАлюминиевый";
		
		Элементы.ЗаполнитьОтверстия.Доступность = НЕ Стекла И НЕ Столешница; 
		Элементы.РадиусЛевоВерх.Доступность = НЕ Фасад;
		Элементы.РадиусЛевоНиз.Доступность = НЕ Фасад;
		Элементы.РадиусПравоВерх.Доступность = НЕ Фасад;
		Элементы.РадиусПравоНиз.Доступность = НЕ Фасад;
		Элементы.Срез.Доступность = НЕ Фасад;
		Элементы.РасположениеПазов.Доступность = Фасад;
		Элементы.Петли.Доступность = Фасад;
		Элементы.Петли.СписокВыбора.Очистить();
		Если СтеклянныйФасад Тогда
			Элементы.Петли.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ПетлиДляСтекол);
		ИначеЕсли ГнутыйСтФасад Тогда	
			Элементы.Петли.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ПетлиПоворотные);
		Иначе
			Элементы.Петли.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Петли);
		КонецЕсли;
		Элементы.ДеталиКоличествоПетель.Доступность = Фасад;
		Элементы.ДеталиДиаметрПазов.Доступность = Фасад;
		Элементы.ДеталиПоложениеРучки.Доступность = Фасад;
		Элементы.ДеталиДемпфер.Доступность = Фасад;
		Элементы.ДеталиМеханизмФасада.Доступность = Фасад;
		Элементы.ДеталиКоличествоДемпфер.Доступность = Фасад;
		Элементы.ДеталиКоличествоМеханизмФасада.Доступность = Фасад;
		Элементы.ДеталиОбтачивать.Доступность = Стекла;
		Элементы.ДеталиСкругление.Доступность = Столешница;
		
		ЗагрузитьСписокВыбораНоменклатуры(Материал);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция  ЗагрузитьСтруктураОтверстий(АдресТаблицы)
	
	Возврат ПолучитьИзВременногоХранилища(АдресТаблицы);
		
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ДобавитьКДокументу(Команда)
	
	Модифицированность = Ложь;
	ОповеститьОВыборе(ПолучитьАдресХранилища());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОтверстия(Команда)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	Структура = Новый Структура;
	Структура.Вставить("ТаблицаОтверстий", Данные.СтруктураОтверстий);
	
	АдресСтруктурыОтверстий = ОткрытьФормуМодально("ОбщаяФорма.ФормаРедактораОтверстий", Структура, ЭтаФорма);
	Если АдресСтруктурыОтверстий <> Неопределено Тогда
		Данные.СтруктураОтверстий = АдресСтруктурыОтверстий;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ СВОЙСТВ И КАТЕГОРИЙ

&НаКлиенте
Процедура ДеталиПриАктивизацииСтроки(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	Если Данные <> Неопределено Тогда
		
		Если НЕ ЗначениеЗаполнено(Данные.Материал) И ЗначениеЗаполнено(ШапкаОсновныхНастроек.Материал) Тогда			
			Данные.Материал = ШапкаОсновныхНастроек.Материал;		
		ИначеЕсли ЗначениеЗаполнено(Данные.Материал) Тогда
			ШапкаОсновныхНастроек.Вставить("Материал", Данные.Материал);
		КонецЕсли;
		
	КонецЕсли;
	
	ОбновитьДоступность();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	Детали.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицы));
	Если ЗначениеЗаполнено(Детали) Тогда
		Если Параметры.Свойство("Идентификатор")  Тогда
			Элементы.Детали.ТекущаяСтрока = Параметры.Идентификатор;
		КонецЕсли;
	Иначе
		Стр = Детали.Добавить();
	КонецЕсли;
	
	ШапкаОсновныхНастроек = Новый Структура;
	
	ШапкаОсновныхНастроек.Вставить("Материал", "16 ЛДСП");
	
	МассивПодразделений = Новый Массив;
	
	СписокНоменклатурныхГрупп = Новый СписокЗначений;
	
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ПетлиБезДоводчика);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ПетлиСДоводчиком);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ПетлиДляСтеколБезДоводчика);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ПетлиДляСтеколСДоводчиком);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ПетлиПоворотные);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Зеркало);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Стекло);
	
	МассивыНоменклатурныхГрупп = ОтборНоменклатурныхГрупп(СписокНоменклатурныхГрупп);
	
	Петли = Новый Массив;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.ПетлиБезДоводчика Цикл
		Петли.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.ПетлиСДоводчиком Цикл
		Петли.Добавить(Элемент);
	КонецЦикла;	
	МассивыНоменклатурныхГрупп.Вставить("Петли", Петли);
	
	ПетлиДляСтекол = Новый Массив;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.ПетлиДляСтеколБезДоводчика Цикл
		ПетлиДляСтекол.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.ПетлиДляСтеколСДоводчиком Цикл
		ПетлиДляСтекол.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.ПетлиПоворотные Цикл
		ПетлиДляСтекол.Добавить(Элемент);
	КонецЦикла;
	МассивыНоменклатурныхГрупп.Вставить("ПетлиДляСтекол", ПетлиДляСтекол);
	
	Зеркало_Стекло = Новый Массив;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Зеркало Цикл
		Зеркало_Стекло.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Стекло Цикл
		Зеркало_Стекло.Добавить(Элемент);
	КонецЦикла;	
	МассивыНоменклатурныхГрупп.Вставить("Зеркало_Стекло", Зеркало_Стекло);
	
КонецПроцедуры

&НаКлиенте
Функция ЗагрузитьСписокВыбораНоменклатуры(Материал)
	
	Если Материал = "Стекло" Тогда
		
		Элементы.ДеталиНоменклатура.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Зеркало_Стекло);
		
	Иначе 
		
		Элементы.ДеталиНоменклатура.СписокВыбора.Очистить();
		
	КонецЕсли;
	
КонецФункции 

&НаКлиенте
Процедура МатериалПриИзменении(Элемент)
	
	ТекущиеДанные	= Элементы.Детали.ТекущиеДанные;
	Материал 			= ТекущиеДанные.Материал;
	ШапкаОсновныхНастроек.Вставить("Материал", Материал);
		
	ТекущиеДанные.ВысотаДетали	= "";
	ТекущиеДанные.ШиринаДетали = "";
	ТекущиеДанные.Демпфер = Неопределено;
	ТекущиеДанные.ДеталиМеханизмФасада = Неопределено;
	ТекущиеДанные.ДеталиКоличествоДемпфер = 0;
	ТекущиеДанные.ДеталиКоличествоМеханизмФасада = 0;
	ТекущиеДанные.Номенклатура	= Неопределено;
	ТекущиеДанные.ПоложениеРучки	= Неопределено;
	ТекущиеДанные.Петли	= Неопределено;
	ТекущиеДанные.КоличествоПетель = 0;
	ТекущиеДанные.ДиаметрПазов	= 0;
	ТекущиеДанные.РасположениеПазов	= Неопределено;
	ТекущиеДанные.РадиусЛевоВерх = 0;
	ТекущиеДанные.РадиусЛевоНиз = 0;
	ТекущиеДанные.РадиусПравоВерх = 0;
	ТекущиеДанные.РадиусПравоНиз = 0;
	ТекущиеДанные.Срез = Ложь;
	ТекущиеДанные.Обтачивать	= Ложь;
	ТекущиеДанные.Скругление	= Ложь;
	ТекущиеДанные.СтруктураОтверстий = "";
	ОбновитьДоступность();
	
	Если Материал = "ФасадАГТ" Тогда
		
		ТекущиеДанные.КоличествоПетель = 2;
		
	Иначе
		
		ТекущиеДанные.КоличествоПетель = 0;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура РадиусЛевоВерхПриИзменении(Элемент)
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
