﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// В этом модуле содержится реализация обработчиков модуля приложения. 
//
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Выполняется перед интерактивном началом работы пользователя с областью данных.
// Соответствует обработчику ПередНачаломРаботыСистемы
//
// Параметры:
// Отказ - Булево - отказ в от начала работы. Если параметр установить в Истина,
// начало работы с областью осуществлено не будет.
//
Процедура ПередНачаломРаботыСистемы(Отказ) Экспорт
	
	ПроверкаКомпьютера(Отказ);
	
КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных.
// Соответствует обработчику ПриНачалеРаботыСистемы
//
// Параметры
//  ОбрабатыватьПараметрыЗапуска - Булево - Истина, если обработчик вызван при 
//  непосредственном входе пользователя в систему и должен обработать параметры
//  запуска (если это предусмотрено его логикой). Иначе обработчика вызван
//  при интерактивном входе неразделенного пользователя в область данных и
//  обрабатывать параметры запуска не следует.
//
Процедура ПриНачалеРаботыСистемы(Знач ОбрабатыватьПараметрыЗапуска = Ложь) Экспорт
	
	ЗаполнитьПутьКЛокальномуКэшуФайлов();
	ПодключитьОбработчикиОповещения();
	ЗаголовокСистемы();
	
	#Если НЕ ВебКлиент Тогда
		
		Параметры = Новый Структура;
		Параметры.Вставить("ЗапускПрограммы", Истина);
		ОткрытьФормуМодально("Обработка.СинхронизацияФайлов.Форма", Параметры);
		
	#КонецЕсли
	
КонецПроцедуры

// Обработать параметры запуска программы.
// Реализация функции может быть расширена для обработки новых параметров.
//
// Параметры
//  ЗначениеПараметраЗапуска - Строка - первое значение параметра запуска, 
//                                      до первого символа ";"
//  ПараметрыЗапуска  – Строка – параметр запуска, переданный в конфигурацию 
//                               с помощью ключа командной строки /C.
//
// Возвращаемое значение:
//   Булево   – Истина, если необходимо прервать выполнение процедуры ПриНачалеРаботыСистемы.
//
Функция ОбработатьПараметрыЗапуска(ЗначениеПараметраЗапуска, ПараметрыЗапуска) Экспорт

	Возврат Ложь;

КонецФункции

// Соответствует обработчику ПередЗавершениемРаботыСистемы.
//
Процедура ПередЗавершениемРаботыСистемы(Отказ) Экспорт
	
КонецПроцедуры
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// В этом модуле содержится реализация обработчиков модуля приложения. 
//
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Определение компьютера, фиксация авторизации,
// блокировка работы штатных работников на неодобренных
// компьютерах, запрет работы на компьютере из черного списка.
// Параметры
//  Отказ  - Булево - Блокировка запуска системы
Функция ПроверкаКомпьютера(Отказ)
	
	Если ЛексСервер.НетПользователейВБазе() Тогда
		
		Возврат -1;
		
	КонецЕсли;
	
	СвойстваКомпьютера = ПолучитьСвойстваКомпьютера();
	
	Админ = ЛексСервер.ТекущийПользовательАдминистратор();
	Компьютер = ЛексСервер.ОпределитьКомпьютер(СвойстваКомпьютера.Серийник, СвойстваКомпьютера.ИмяКомпьютера);
	
	// { Васильев Александр Леонидович [21.01.2016]
	// Тут сомнительное условие. Нужно переделать на параметр запуска.
	// } Васильев Александр Леонидович [21.01.2016]
	
	ВидАктивности = ПредопределенноеЗначение("Перечисление.ВидыАктивностиПользователей.ВходВСистему");
	
	Если Компьютер.ЧерныйСписок 
		И НЕ Админ Тогда
		
		Отказ = Истина;
		ВидАктивности = ПредопределенноеЗначение("Перечисление.ВидыАктивностиПользователей.АвторизацияЧерныйСписок");
		
	ИначеЕсли НЕ (Компьютер.Одобренный ИЛИ Админ)
		И НЕ ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		Отказ = Истина;
		ВидАктивности = ПредопределенноеЗначение("Перечисление.ВидыАктивностиПользователей.АвторизацияСНеодобренногоКомпьютера");
		Предупреждение("Попытка несанкционированного доступа зафиксирована." + Символы.ПС + "Свяжитесь со службой поддержки.", 30, "Ошибка авторизации");
		
	КонецЕсли;
	
	ЛексСервер.ЗаписатьДействиеПользователя(Компьютер.Ссылка, ВидАктивности);
	
КонецФункции

Функция ПолучитьСвойстваКомпьютера()
	
	Перем Результат;
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяКомпьютера", "КлиентНеопределен");
	Результат.Вставить("Серийник", "КлиентНеопределен");
	
	#Если ТонкийКлиент Тогда
		
		Результат.ИмяКомпьютера = ИмяКомпьютера();
		
		СистемнаяИнформация = Новый СистемнаяИнформация;
		ТекущийТипПлатформы = СистемнаяИнформация.ТипПлатформы;
		
		Результат.Серийник = "Ошибка получения серийного номера";
		
		Если ТекущийТипПлатформы = ТипПлатформы.Windows_x86
			ИЛИ ТекущийТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
			
			Попытка
				
				ФСО = Новый COMОбъект("Scripting.FileSystemObject");
				ФСО_Диск = ФСО.GetDrive("C");
				Результат.Серийник = ФСО_Диск.SerialNumber;
				
			Исключение
				
				// Лучше не сообщать об ошибке,
				// чтобы не выдавать сведений о том,
				// к чему привязывается серийный номер
				
				//Сообщить(ОписаниеОшибки());
				
			КонецПопытки;
			
		КонецЕсли;
		
	#ИначеЕсли ВебКлиент Тогда
		
		Результат.ИмяКомпьютера = "ВебКлиент";
		Результат.Серийник = "ВебКлиент";
		
	#КонецЕсли
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьПутьКЛокальномуКэшуФайлов() Экспорт
	
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "ПутьКЛокальномуКэшуФайлов");
	Элемент.Вставить("Значение",  ЛексКлиент.ПолучитьПутьКаталогаФайлов());
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "МаксимальныйРазмерЛокальногоКэшаФайлов");
	Элемент.Вставить("Значение", ЛексКлиентСервер.ПолучитьМаксимальныйРазмерКэшаФайлов());
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(МассивСтруктур);
	
КонецПроцедуры

// Оповещения о служебных записках.
// Для дилеров -- один раз при запуске,
// для штатных сотрудинков -- один раз в 15 минут.
Функция ПодключитьОбработчикиОповещения()
		
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		ОповещениеСообщенияДилерам();
		
	Иначе
		
		ОповещениеСлужебныхЗаписок();
		ПодключитьОбработчикОжидания("ОповещениеСлужебныхЗаписок", 900);
		
	КонецЕсли;
	
КонецФункции

// Изменение заголовка системы пользователям
// с включенной настройкой.
Функция ЗаголовокСистемы()
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Настройка = ПредопределенноеЗначение("ПланВидовХарактеристик.НастройкиПользователей.ОтображатьИмяБазы");
	ОтображатьИмяБазы = ЛексСервер.ПолучитьЗначениеНастройкиПользователя(Пользователь, Настройка);
	
	Если ЗначениеЗаполнено(ОтображатьИмяБазы) И ОтображатьИмяБазы Тогда
		
		Стр = СтрокаСоединенияИнформационнойБазы();
		
		Если Найти(Стр, "Ref") > 0 Тогда
			
			ИмяБазы = "База: " + СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Стр, """")[3];
			Заголовок = ИмяБазы +" / "+ Пользователь;
			
		Иначе
			
			ИмяБазы = "База: Рабочая";
			Заголовок = ИмяБазы +" / "+ Пользователь;
			
		КонецЕсли;
		
		УстановитьЗаголовокКлиентскогоПриложения(Заголовок);
		
	КонецЕсли;
	
КонецФункции

Процедура ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация, Организация, ВключатьОбособленныеПодразделения) Экспорт
	
	Если Не ЗначениеЗаполнено(ПолеОрганизация) Тогда 
		Организация = Неопределено;
		ВключатьОбособленныеПодразделения = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка, ПолеОрганизация, СоответствиеОрганизаций) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ПолеОрганизация) Тогда
		Если СоответствиеОрганизаций.Свойство(ПолеОрганизация) Тогда
			Значение = СоответствиеОрганизаций[ПолеОрганизация];
			Если ТипЗнч(Значение) = Тип("Структура") Тогда
				ОткрытьЗначение(Значение.Организация);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, СоответствиеОрганизаций,
	Организация, ВключатьОбособленныеПодразделения) Экспорт 
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Значение = СоответствиеОрганизаций[ВыбранноеЗначение];
		Если ТипЗнч(Значение) = Тип("Структура") Тогда 
			Организация = Значение.Организация;
			ВключатьОбособленныеПодразделения = Значение.ВключатьОбособленныеПодразделения;
		Иначе
			Организация = Неопределено;
			ВключатьОбособленныеПодразделения = Неопределено;
		КонецЕсли;
	Иначе
		Организация = Неопределено;
		ВключатьОбособленныеПодразделения = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает Истина, если при изменении даты документа требуется перечитать 
// настройки из базы данных на сервере.
//
Функция ТребуетсяВызовСервераПриИзмененииДатыДокумента(НоваяДата, ПредыдущаяДата,
	
	ВалютаДокумента = Неопределено, ВалютаРегламентированногоУчета = Неопределено) Экспорт
	
	Результат = Ложь;
	
	Если НачалоДня(НоваяДата) = НачалоДня(ПредыдущаяДата) Тогда
		// Ничего не изменилось либо изменилось только время, от которого ничего не зависит
		Возврат Ложь;
	КонецЕсли;
	
	Если НачалоМесяца(НоваяДата) <> НачалоМесяца(ПредыдущаяДата) Тогда
		// Учетная политика задается с периодичностью до месяца,
		// поэтому в пределах месяца изменения даты не учитываем.
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ОповещениеСообщенияДилерам() Экспорт
	
	Данные = ЛексСервер.ПолучитьСписокНеОзнакомленныхСообщенийДилерам();
	
	Если Данные.Количество > 0 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("АдресТаблицы", Данные.АдресТаблицы);
		
		ОткрытьФорму("ОбщаяФорма.ФормаНеОзнакомленныхСообщенийДилерам", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры
