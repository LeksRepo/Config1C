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
		
		ЭтоЛДСП = (Материал = "10 ЛДСП" ИЛИ Материал = "16 ЛДСП"); 
		Клееная = (Материал = "10 ЛДСП+10 ЛДСП" ИЛИ Материал = "16 ЛДСП+10 ЛДСП" ИЛИ Материал = "16 ЛДСП+16 ЛДСП");
		ВсеЛДСП = ЭтоЛДСП ИЛИ Клееная;
		
		МассивКромок = Новый Массив;
		Если Клееная Тогда
			МассивКромок.Добавить(ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.Кромка2_35"));
		ИначеЕсли ЭтоЛДСП Тогда
			МассивКромок.Добавить(ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.КантТ"));
			МассивКромок.Добавить(ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.Кромка045_19"));
			МассивКромок.Добавить(ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.Кромка2_19"));
		КонецЕсли;
			
		Столешница = Материал = "Столешница";
		Стекла = Материал = "Стекло";
		СтеклянныйФасад = Материал = "ФасадСтеклянный";
		ГнутыйСтФасад = Материал = "ФасадСтеклянныйЗакругленный";
		Фасад = ГнутыйСтФасад ИЛИ СтеклянныйФасад ИЛИ Материал = "ФасадАГТ" ИЛИ Материал = "ФасадЛДСП" ИЛИ Материал = "ФасадМДФ" ИЛИ Материал = "ФасадАлюминиевый";
		
		Элементы.ДеталиВидКромкиСверху.Доступность = ВсеЛДСП И ТекущиеДанные.КромкаСверху;
		Элементы.ДеталиВидКромкиСверху.СписокВыбора.Очистить();
		Элементы.ДеталиВидКромкиСверху.СписокВыбора.ЗагрузитьЗначения(МассивКромок);
		Элементы.ДеталиВидКромкиСлева.Доступность = ВсеЛДСП И ТекущиеДанные.КромкаСлева;
		Элементы.ДеталиВидКромкиСлева.СписокВыбора.Очистить();
		Элементы.ДеталиВидКромкиСлева.СписокВыбора.ЗагрузитьЗначения(МассивКромок);
		Элементы.ДеталиВидКромкиСнизу.Доступность = ВсеЛДСП И ТекущиеДанные.КромкаСнизу;
		Элементы.ДеталиВидКромкиСнизу.СписокВыбора.Очистить();
		Элементы.ДеталиВидКромкиСнизу.СписокВыбора.ЗагрузитьЗначения(МассивКромок);
		Элементы.ДеталиВидКромкиСправа.Доступность = ВсеЛДСП И ТекущиеДанные.КромкаСправа;
		Элементы.ДеталиВидКромкиСправа.СписокВыбора.Очистить();
		Элементы.ДеталиВидКромкиСправа.СписокВыбора.ЗагрузитьЗначения(МассивКромок);
		Элементы.ДеталиВторойЦвет.Доступность = ВсеЛДСП;
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
		
		Элементы.ДеталиМеханизмФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Механизм);
		Элементы.ДеталиДемпфер.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Демпфер);
		
		ЗагрузитьСписокВыбораНоменклатуры(Материал);
		
				
		Если ЗначениеЗаполнено(ТекущиеДанные.СтрокаДляФлэш) Тогда
			
			ТекущиеДанные.РадиусЛевоВерх = "";
			ТекущиеДанные.РадиусПравоВерх = "";
			ТекущиеДанные.РадиусЛевоНиз = "";
			ТекущиеДанные.РадиусПравоНиз = "";
			ТекущиеДанные.Срез = Ложь;
			
			ТекущиеДанные.КромкаСверху = Ложь;
			ТекущиеДанные.КромкаСнизу = Ложь;
			ТекущиеДанные.КромкаСлева = Ложь;
			ТекущиеДанные.КромкаСправа = Ложь;
			
			ПустаяСсылка = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ПустаяСсылка");
			ТекущиеДанные.ВидКромкиСверху = ПустаяСсылка;
			ТекущиеДанные.ВидКромкиСнизу = ПустаяСсылка;
			ТекущиеДанные.ВидКромкиСлева = ПустаяСсылка;
			ТекущиеДанные.ВидКромкиСправа = ПустаяСсылка;
			
			Элементы.Кромка.Доступность = Ложь;
			Элементы.Радиусы.Доступность = Ложь;
			
		Иначе
			
			Элементы.Кромка.Доступность = Истина;
			Элементы.Радиусы.Доступность = Истина;
			
		КонецЕсли; 
				
	КонецЕсли;
	
КонецПроцедуры

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
		
		Для каждого Строка Из Детали Цикл
		 	Если ЗначениеЗаполнено(Строка.СтрокаДляФлэш) Тогда
				Строка.Редактированная = Истина;
			КонецЕсли; 
		КонецЦикла;
		
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
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ДВП);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ГазовыйЛифт);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кронштейн);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Демпфер);
	
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
	
	Механизм = Новый Массив;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.ГазовыйЛифт Цикл
		Механизм.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кронштейн Цикл
		Механизм.Добавить(Элемент);
	КонецЦикла;	
	МассивыНоменклатурныхГрупп.Вставить("Механизм", Механизм);
	
КонецПроцедуры

&НаКлиенте
Функция ЗагрузитьСписокВыбораНоменклатуры(Материал)
	
	Если Материал = "Стекло" Тогда
		
		Элементы.ДеталиНоменклатура.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Зеркало_Стекло);
		
	ИначеЕсли Материал = "ДВП" Тогда	
		
		Элементы.ДеталиНоменклатура.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ДВП);
		
	Иначе 
		
		Элементы.ДеталиНоменклатура.СписокВыбора.Очистить();
		
	КонецЕсли;
	
КонецФункции 

&НаКлиенте
Процедура МатериалПриИзменении(Элемент)
	
	ТекущиеДанные	= Элементы.Детали.ТекущиеДанные;
	Материал 			= ТекущиеДанные.Материал;
	ШапкаОсновныхНастроек.Вставить("Материал", Материал);
	Фасад = Материал = "ФасадСтеклянныйЗакругленный" 
	ИЛИ Материал = "ФасадСтеклянный" 
	ИЛИ Материал = "ФасадАГТ" 
	ИЛИ Материал = "ФасадЛДСП" 
	ИЛИ Материал = "ФасадМДФ" 
	ИЛИ Материал = "ФасадАлюминиевый";
	
	
	ТекущиеДанные.ВысотаДетали	= "";
	ТекущиеДанные.ШиринаДетали = "";
	ТекущиеДанные.Демпфер = Неопределено;
	ТекущиеДанные.МеханизмФасада = Неопределено;
	ТекущиеДанные.КоличествоДемпфер = 0;
	ТекущиеДанные.КоличествоМеханизмФасада = 0;
	ТекущиеДанные.Номенклатура	= Неопределено;
	//ТекущиеДанные.ПоложениеРучки	= Неопределено;
	ТекущиеДанные.РасположениеПазовИРучкиНаФасадах = Неопределено;
	ТекущиеДанные.Петли	= Неопределено;
	ТекущиеДанные.КоличествоПетель = 0;
	ТекущиеДанные.ДиаметрПазов	= 0;
	//ТекущиеДанные.РасположениеПазов	= Неопределено;
	ТекущиеДанные.РадиусЛевоВерх = 0;
	ТекущиеДанные.РадиусЛевоНиз = 0;
	ТекущиеДанные.РадиусПравоВерх = 0;
	ТекущиеДанные.РадиусПравоНиз = 0;
	ТекущиеДанные.Срез = Ложь;
	ТекущиеДанные.Обтачивать = Ложь;
	ТекущиеДанные.Скругление = Ложь;
	ТекущиеДанные.СтруктураОтверстий = "";
	ТекущиеДанные.КромкаСверху = Фасад;
	ТекущиеДанные.КромкаСлева = Фасад;
	ТекущиеДанные.КромкаСнизу = Фасад;
	ТекущиеДанные.КромкаСправа = Фасад;
	ТекущиеДанные.ВидКромкиСверху = Неопределено;
	ТекущиеДанные.ВидКромкиСлева = Неопределено;
	ТекущиеДанные.ВидКромкиСнизу = Неопределено;
	ТекущиеДанные.ВидКромкиСправа = Неопределено;

	
	ОбновитьДоступность();
	
	Если Материал = "ФасадАГТ" Тогда
		
		ТекущиеДанные.КоличествоПетель = 2;
		
	Иначе
		
		ТекущиеДанные.КоличествоПетель = 0;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ДеталиКромкаПриИзменении(Элемент)
	
	ТекущиеДанные	= Элементы.Детали.ТекущиеДанные;
	Материал = ТекущиеДанные.Материал;
	ЭтоЛДСП = (Материал = "10 ЛДСП" ИЛИ Материал = "16 ЛДСП" ИЛИ Материал = "10 ЛДСП+10 ЛДСП" 
	ИЛИ Материал = "16 ЛДСП+10 ЛДСП" ИЛИ Материал = "16 ЛДСП+16 ЛДСП");
	
	Если Элемент = Элементы.ДеталиКромкаСверху Тогда
		Элементы.ДеталиВидКромкиСверху.Доступность = ЭтоЛДСП И ТекущиеДанные.КромкаСверху;	
	ИначеЕсли Элемент = Элементы.ДеталиКромкаСлева Тогда
		Элементы.ДеталиВидКромкиСлева.Доступность = ЭтоЛДСП И ТекущиеДанные.КромкаСлева;	
	ИначеЕсли Элемент = Элементы.ДеталиКромкаСнизу Тогда
		Элементы.ДеталиВидКромкиСнизу.Доступность = ЭтоЛДСП И ТекущиеДанные.КромкаСнизу;	
	ИначеЕсли Элемент = Элементы.ДеталиКромкаСправа Тогда
		Элементы.ДеталиВидКромкиСправа.Доступность = ЭтоЛДСП И ТекущиеДанные.КромкаСправа;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьДеталь(Команда)
	
	ТекущиеДанные = Элементы.Детали.ТекущиеДанные;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.СтрокаДляФлэш) Тогда
		
		СтрокаДляРедактирования = "newcat☻";
		
	Иначе
		
		СтрокаДляФлэш = ТекущиеДанные.СтрокаДляФлэш;
		МассивСимволов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаДляФлэш, "☻");
		СтрокаДляФлэш = МассивСимволов[8];
		
		СтрокаДляРедактирования = "oldcat☻"+СтрокаДляФлэш;
		
	КонецЕсли;
	
	//АдресТаблицы = ПолучитьАдресТаблицы();
	
	Параметр = Новый Структура;
	
	Параметр.Вставить("СтрокаДляРедактирования", СтрокаДляРедактирования);
	Параметр.Вставить("Подразделение", Неопределено);
	Параметр.Вставить("Материал", Неопределено);
	Параметр.Вставить("АдресТаблицы", Неопределено);
	ОткрытьФорму("Документ.Спецификация.Форма.ФормаРедактированиеДеталей", Параметр, Элементы.Детали);

КонецПроцедуры

&НаКлиенте
Процедура ДеталиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Элементы.Детали.ТекущиеДанные.Редактированная = Истина;
	Элементы.Детали.ТекущиеДанные.СтрокаДляФлэш = ВыбранноеЗначение;
	
	ОбновитьДоступность();
	
	Модифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьРедактированность(Команда)
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Текст = "Редактированный шаблон детали будет удалён." + Символы.ПС + "Продолжить?" ;
	
	Если Вопрос(Текст, Режим, 0) = КодВозвратаДиалога.Да Тогда
		
		ТекущиеДанные = Элементы.Детали.ТекущиеДанные;
		ТекущиеДанные.СтрокаДляФлэш = "";
		ТекущиеДанные.Редактированная = Ложь;
		
		ОбновитьДоступность();
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеталиРасположениеПазовИРучкиНаФасадахОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураРасположенияПазовИРучки = ДеталиРасположениеПазовОбработкаВыбораНаСервере(ВыбранноеЗначение);
	ТекущиеДанные= Элементы.Детали.ТекущиеДанные;
	ТекущиеДанные.РасположениеПазовИРучкиНаФасадах = СтруктураРасположенияПазовИРучки.ЭлементСправочника;
	ПоложениеРучки = СтруктураРасположенияПазовИРучки.ПоложениеРучки;
	ПоложениеПазов = СтруктураРасположенияПазовИРучки.ПоложениеПазов;
	
КонецПроцедуры

&НаСервере
Функция ДеталиРасположениеПазовОбработкаВыбораНаСервере(ЗначениеСправочника)
	
	СтруктураРасположенияПазовИРучки = Новый Структура;
	ЭлементСправочника = Справочники.РасположениеПазовИРучкиНаФасадах.НайтиПоРеквизиту("ИмяКартинки", ЗначениеСправочника);
	СтруктураРасположенияПазовИРучки.Вставить("ПоложениеРучки", ЭлементСправочника.ПоложениеРучки);
	СтруктураРасположенияПазовИРучки.Вставить("ПоложениеПазов", ЭлементСправочника.ПоложениеПазов);
	СтруктураРасположенияПазовИРучки.Вставить("ЭлементСправочника", ЭлементСправочника);
	Возврат СтруктураРасположенияПазовИРучки;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
