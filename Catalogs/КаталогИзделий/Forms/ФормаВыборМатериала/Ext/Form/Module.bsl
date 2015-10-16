﻿
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

&НаКлиенте
Перем ДанныеДетали;

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
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

&НаСервере
Функция ПолучитьАдресХранилища()
	
	Возврат ПоместитьВоВременноеХранилище(Детали.Выгрузить());
	
КонецФункции

&НаКлиенте
Функция ПолучитьНомГруппы(МассивВидов)
	
	МассивГрупп = Новый Массив;
	
	Для Каждого Поле Из МассивВидов Цикл
		Для Каждого Стр Из ДанныеДетали.НомГруппы Цикл
			Если Стр.Значение.ПолеВыбора = Поле Тогда
			 	МассивГрупп.Добавить(Стр.Значение.Группа);
		 	КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат МассивГрупп;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьДоступность()
	
	ТекущиеДанные = Элементы.Детали.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
				
		Дос = ДанныеДетали.ДоступностьПолей;
				
		Если НЕ (ДанныеДетали.ЭтоФасад ИЛИ ДанныеДетали.ЭтоСтолешница ИЛИ ДанныеДетали.ЭтоСтекло) Тогда
			Элементы.ДеталиВторойЦвет.Доступность = Истина;
		Иначе
			Элементы.ДеталиВторойЦвет.Доступность = Ложь;
		КонецЕсли;
		
		Элементы.ЗаполнитьОтверстия.Доступность = Дос.ДоступностьПоляЗаполнитьОтверстия; 

		Элементы.ДеталиКромкаСверху.Доступность = Дос.ДоступностьПоляКромкаВерх;
		Элементы.ДеталиКромкаСнизу.Доступность = Дос.ДоступностьПоляКромкаНиз;
		Элементы.ДеталиКромкаСлева.Доступность = Дос.ДоступностьПоляКромкаЛево;
		Элементы.ДеталиКромкаСправа.Доступность = Дос.ДоступностьПоляКромкаПраво;
		
		Элементы.РадиусЛевоВерх.Доступность = Дос.ДоступностьПоляR1;
		Элементы.РадиусЛевоНиз.Доступность = Дос.ДоступностьПоляR4;
		Элементы.РадиусПравоВерх.Доступность = Дос.ДоступностьПоляR2;
		Элементы.РадиусПравоНиз.Доступность = Дос.ДоступностьПоляR3;
		Элементы.Срез.Доступность = Дос.ДоступностьПоляСрез;
		
		Элементы.ДеталиРасположениеПазовИРучкиНаФасадах.Доступность = Дос.ДоступностьПоляРасположениеПазов;

		Элементы.Петли.Доступность = Дос.ДоступностьПоляПетли;		
		Элементы.ДеталиКоличествоПетель.Доступность = Дос.ДоступностьПоляКоличествоПетель;
		Элементы.ДеталиДиаметрПазов.Доступность = Дос.ДоступностьПоляДиаметрПазов;
		
		Элементы.ДеталиДемпфер.Доступность = ДанныеДетали.ЭтоФасад;
		Элементы.ДеталиМеханизмФасада.Доступность = ДанныеДетали.ЭтоФасад;
		Элементы.ДеталиКоличествоДемпфер.Доступность = ДанныеДетали.ЭтоФасад;
		Элементы.ДеталиКоличествоМеханизмФасада.Доступность = ДанныеДетали.ЭтоФасад;
		
		Элементы.ДеталиОбтачивать.Доступность = ДанныеДетали.ЭтоСтекло;
		Элементы.ДеталиПостформинг.Доступность = ДанныеДетали.ЭтоСтолешница;

		ПустаяСсылка = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ПустаяСсылка");
		
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
			
			ТекущиеДанные.ВидКромкиСверху = ПустаяСсылка;
			ТекущиеДанные.ВидКромкиСнизу = ПустаяСсылка;
			ТекущиеДанные.ВидКромкиСлева = ПустаяСсылка;
			ТекущиеДанные.ВидКромкиСправа = ПустаяСсылка;
			
			Элементы.Кромки.Доступность = Ложь;
			Элементы.Радиусы.Доступность = Ложь;
			Элементы.ГруппаКромкаРедактор.Доступность = Истина;
			
			Элементы.ДеталиВидКромкиРедактор.Доступность = Дос.ДоступностьПоляРедактироватьДеталь И ТекущиеДанные.КромкаРедактор;
	
		Иначе
			
			ТекущиеДанные.КромкаРедактор = Ложь;
			
			Элементы.Кромки.Доступность = Истина;
			Элементы.Радиусы.Доступность = Истина;
			Элементы.ГруппаКромкаРедактор.Доступность = Ложь;
			
			Элементы.ДеталиВидКромкиРедактор.Доступность = Ложь;
			Элементы.ДеталиВидКромкиСверху.Доступность = Дос.ДоступностьПоляКромкаВерх И ТекущиеДанные.КромкаСверху;		
			Элементы.ДеталиВидКромкиСлева.Доступность = Дос.ДоступностьПоляКромкаЛево И ТекущиеДанные.КромкаСлева;			
			Элементы.ДеталиВидКромкиСнизу.Доступность = Дос.ДоступностьПоляКромкаНиз И ТекущиеДанные.КромкаСнизу;
			Элементы.ДеталиВидКромкиСправа.Доступность = Дос.ДоступностьПоляКромкаПраво И ТекущиеДанные.КромкаСправа;
						
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
	Структура.Вставить("Обновлять", Ложь);
	
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
		
		Если НЕ ЗначениеЗаполнено(Данные.ВидДетали) И ЗначениеЗаполнено(ШапкаОсновныхНастроек.ВидДетали) Тогда			
			Данные.ВидДетали = ШапкаОсновныхНастроек.ВидДетали;		
		ИначеЕсли ЗначениеЗаполнено(Данные.ВидДетали) Тогда
			ШапкаОсновныхНастроек.Вставить("ВидДетали", Данные.ВидДетали);
		КонецЕсли;
		
		ДанныеДетали = ПолучитьДанныеДетали(Данные.ВидДетали);
		
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
	
	Для Каждого Строка Из Детали Цикл
		
		Если НЕ ЗначениеЗаполнено(Строка.ВидДетали) И ЗначениеЗаполнено(Строка.Материал) Тогда
			Строка.ВидДетали = Справочники.ВидыДеталей.НайтиПоНаименованию(Строка.Материал);
		КонецЕсли;
		
	КонецЦикла;
	
	ШапкаОсновныхНастроек = Новый Структура;
	ШапкаОсновныхНастроек.Вставить("ВидДетали", Справочники.ВидыДеталей.НайтиПоНаименованию("16 ЛДСП"));
	
	СписокНоменклатурныхГрупп = Новый СписокЗначений;
	
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ГазовыйЛифт);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кронштейн);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Демпфер);
	
	МассивНоменклатурыПоГруппам = ОтборНоменклатурныхГрупп(СписокНоменклатурныхГрупп);
	
	Механизм = Новый Массив;
	Для каждого Элемент Из МассивНоменклатурыПоГруппам.ГазовыйЛифт Цикл
		Механизм.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивНоменклатурыПоГруппам.Кронштейн Цикл
		Механизм.Добавить(Элемент);
	КонецЦикла;	
	МассивНоменклатурыПоГруппам.Вставить("Механизм", Механизм);
	
	Элементы.ДеталиМеханизмФасада.СписокВыбора.ЗагрузитьЗначения(МассивНоменклатурыПоГруппам.Механизм);
	Элементы.ДеталиДемпфер.СписокВыбора.ЗагрузитьЗначения(МассивНоменклатурыПоГруппам.Демпфер);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДеталиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Детали.ТекущиеДанные;
	ВидДетали = ТекущиеДанные.ВидДетали;
	ШапкаОсновныхНастроек.Вставить("ВидДетали", ВидДетали);
	ДанныеДетали = ПолучитьДанныеДетали(ВидДетали);
	Фасад = ДанныеДетали.ЭтоФасад;

	ТекущиеДанные.ВысотаДетали	= "";
	ТекущиеДанные.ШиринаДетали = "";
	ТекущиеДанные.Демпфер = Неопределено;
	ТекущиеДанные.МеханизмФасада = Неопределено;
	ТекущиеДанные.КоличествоДемпфер = 0;
	ТекущиеДанные.КоличествоМеханизмФасада = 0;
	ТекущиеДанные.Номенклатура	= Неопределено;
	ТекущиеДанные.РасположениеПазовИРучкиНаФасадах = Неопределено;
	ТекущиеДанные.Петли	= Неопределено;
	ТекущиеДанные.КоличествоПетель = 0;
	ТекущиеДанные.ДиаметрПазов	= 0;
	ТекущиеДанные.РадиусЛевоВерх = 0;
	ТекущиеДанные.РадиусЛевоНиз = 0;
	ТекущиеДанные.РадиусПравоВерх = 0;
	ТекущиеДанные.РадиусПравоНиз = 0;
	ТекущиеДанные.Срез = Ложь;
	ТекущиеДанные.Обтачивать = Ложь;
	ТекущиеДанные.Постформинг = Ложь;
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
		
КонецПроцедуры

&НаКлиенте
Процедура ДеталиКромкаПриИзменении(Элемент)
	
	ТекущиеДанные	= Элементы.Детали.ТекущиеДанные;
	Дос = ДанныеДетали.ДоступностьПолей;
	
	Если Элемент = Элементы.ДеталиКромкаСверху Тогда
		Элементы.ДеталиВидКромкиСверху.Доступность = Дос.ДоступностьПоляКромкаВерх И ТекущиеДанные.КромкаСверху;	
	ИначеЕсли Элемент = Элементы.ДеталиКромкаСлева Тогда
		Элементы.ДеталиВидКромкиСлева.Доступность = Дос.ДоступностьПоляКромкаЛево И ТекущиеДанные.КромкаСлева;	
	ИначеЕсли Элемент = Элементы.ДеталиКромкаСнизу Тогда
		Элементы.ДеталиВидКромкиСнизу.Доступность = Дос.ДоступностьПоляКромкаНиз И ТекущиеДанные.КромкаСнизу;	
	ИначеЕсли Элемент = Элементы.ДеталиКромкаСправа Тогда
		Элементы.ДеталиВидКромкиСправа.Доступность = Дос.ДоступностьПоляКромкаПраво И ТекущиеДанные.КромкаСправа;
	ИначеЕсли Элемент = Элементы.ДеталиКромкаРедактор Тогда
		Элементы.ДеталиВидКромкиРедактор.Доступность = Дос.ДоступностьПоляРедактироватьДеталь И ТекущиеДанные.КромкаРедактор
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
	
	Параметр = Новый Структура;
	
	Параметр.Вставить("СтрокаДляРедактирования", СтрокаДляРедактирования);
	Параметр.Вставить("Подразделение", Неопределено);
	Параметр.Вставить("ВидДетали", ДанныеДетали.ВидДетали);
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

&НаКлиенте
Процедура ФормулаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура("Формула, ИмяПеременной, Режим", Элемент.ТекстРедактирования, Элемент.Имя, "Каталог");
	Форма = ПолучитьФорму("ОбщаяФорма.РедакторФомул", ПараметрыФормы, Элемент);
	Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Форма.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеталиРасположениеФасадаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Форма = ПолучитьФорму("Справочник.КаталогИзделий.Форма.ФормаРасположенияФасадов", , Элемент);
	Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Форма.Открыть();	
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

&НаСервереБезКонтекста
Функция ПолучитьДанныеДетали(ТипДетали)
	
	Стр = Новый Структура;
	
	НомГруппы = Новый СписокЗначений;
	
	Для Каждого Эл Из ТипДетали.НоменклатурныеГруппы Цикл
		
		Стр2 = Новый Структура;
		Стр2.Вставить("ПолеВыбора", Эл.ПолеВыбора);
		Стр2.Вставить("Группа", Эл.Группа);

		НомГруппы.Добавить(Стр2);	
		
	КонецЦикла;
	
	Стр.Вставить("НомГруппы", НомГруппы);
	
	СтрДоступность = Новый Структура;
	
	Для Каждого Рек Из Метаданные.Справочники.ВидыДеталей.Реквизиты Цикл

		Если Лев(Рек.Имя,15) = "ДоступностьПоля" Тогда
			
			СтрДоступность.Вставить(Рек.Имя,ТипДетали[Рек.Имя]);
			
		КонецЕсли;
		
	КонецЦикла;

	Стр.Вставить("ДоступностьПолей", СтрДоступность);
	
	СтрОбязательныеПоля = Новый Структура;
	
	Стр.Вставить("ВидДетали", ТипДетали);
	Стр.Вставить("Клееная", ТипДетали.Клееная);
	Стр.Вставить("ОбтачиватьПоУмолчанию", ТипДетали.ОбтачиватьПоУмолчанию);
	Стр.Вставить("СпецФасад", ТипДетали.СпецФасад);
	Стр.Вставить("ПрипускСклейка", ТипДетали.ПрипускСклейка);
	Стр.Вставить("ПрипускПостформинг", ТипДетали.ПрипускПостформинг);
	Стр.Вставить("ЭтоФасад", ТипДетали.ЭтоФасад);
	Стр.Вставить("ЭтоСтолешница", ТипДетали.ЭтоСтолешница);
	Стр.Вставить("ЭтоСтекло", ТипДетали.ЭтоСтекло);

	Возврат Стр;
	
КонецФункции

&НаКлиенте
Процедура ДеталиВидКромкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Элемент.СписокВыбора.Очистить();
	
	Если НЕ ЗначениеЗаполнено(Элементы.Детали.ТекущиеДанные.СтрокаДляФлэш) Тогда
	
		МасТипов = Новый Массив();
		МасТипов.Добавить("КантК");
		МасТипов.Добавить("Кромка045");
		МасТипов.Добавить("Кромка2");
		МасТипов.Добавить("Окантовка");
		
		МассивГрупп = ПолучитьНомГруппы(МасТипов);
			
		Элемент.СписокВыбора.ЗагрузитьЗначения(МассивГрупп);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеталиНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Элементы.ДеталиНоменклатура.СписокВыбора.Очистить();
	
	МасТипов = Новый Массив();
	МасТипов.Добавить("Текстура");
	МассивГрупп = ПолучитьНомГруппы(МасТипов);
	
	СписокГрупп = Новый СписокЗначений;
	
	Для Каждого Гр Из МассивГрупп Цикл
		СписокГрупп.Добавить(Гр);	
	КонецЦикла;
		
	МассивНоменклатурыПоГруппам = ОтборНоменклатурныхГрупп(СписокГрупп);
	
	Для Каждого Гр Из МассивНоменклатурыПоГруппам Цикл
		Элементы.ДеталиНоменклатура.СписокВыбора.ЗагрузитьЗначения(Гр.Значение);	
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ДеталиВидКромкиРедакторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Элемент.СписокВыбора.Очистить();
	
	МасТипов = Новый Массив();
	МасТипов.Добавить("КантК");
	МасТипов.Добавить("Кромка045");
	МасТипов.Добавить("Кромка2");
	МасТипов.Добавить("Окантовка");
	
	МассивГрупп = ПолучитьНомГруппы(МасТипов);
		
	Элемент.СписокВыбора.ЗагрузитьЗначения(МассивГрупп);

КонецПроцедуры
