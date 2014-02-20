﻿
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция ПолучитьНоменклатурнуюГруппу(ЗначениеНоменклатуры)
	
	Возврат ЗначениеНоменклатуры.НоменклатурнаяГруппа;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВернутьЗначениеСвойства(ВидСвойства, Элемент)
	
	Если ЗначениеЗаполнено(Элемент[ВидСвойства]) Тогда
		Возврат Элемент[ВидСвойства];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ДобавитьДопГруппы() 
	
	Кромка 	= Новый Массив;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кромка045_19 Цикл
		Кромка.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кромка2_19 Цикл
		Кромка.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кромка2_35 Цикл
		Кромка.Добавить(Элемент);
	КонецЦикла;
	МассивыНоменклатурныхГрупп.Вставить("Кромка", Кромка);
	
	КромкаФасад = Новый Массив;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кромка Цикл
		КромкаФасад.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.КромкаМДФ Цикл
		КромкаФасад.Добавить(Элемент);
	КонецЦикла;
	МассивыНоменклатурныхГрупп.Вставить("КромкаФасад", КромкаФасад);
	
	ФасадыКЯщикам = Новый Массив;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.ЛДСП16 Цикл
		ФасадыКЯщикам.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.МДФ18 Цикл
		ФасадыКЯщикам.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.МДФ8 Цикл
		ФасадыКЯщикам.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.АГТПанель Цикл
		ФасадыКЯщикам.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.ЛДСП10 Цикл
		ФасадыКЯщикам.Добавить(Элемент);
	КонецЦикла;
	МассивыНоменклатурныхГрупп.Вставить("ФасадыКЯщикам", ФасадыКЯщикам);
	
	ЛДСП_ДВП = Новый Массив;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.ДВП Цикл
		ЛДСП_ДВП.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.ЛДСП10 Цикл
		ЛДСП_ДВП.Добавить(Элемент);
	КонецЦикла;
	МассивыНоменклатурныхГрупп.Вставить("ЛДСП_ДВП", ЛДСП_ДВП);
	
	Направляющие = Новый Массив;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.НаправляющиеРоликовые Цикл
		Направляющие.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.НаправляющиеШариковые35 Цикл
		Направляющие.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.НаправляющиеШариковые45 Цикл
		Направляющие.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.НаправляющиеШариковыеСДоводчиком Цикл
		Направляющие.Добавить(Элемент);
	КонецЦикла;
	МассивыНоменклатурныхГрупп.Вставить("Направляющие", Направляющие);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

&НаСервере
Функция ПолучитьАдресХранилища()
	
	Возврат ПоместитьВоВременноеХранилище(Детали.Выгрузить());
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	Детали.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицы));
	
	Подразделение = Параметры.Подразделение;
	
	Если ЗначениеЗаполнено(Детали) Тогда
		Если Параметры.Свойство("Идентификатор")  Тогда
		Элементы.Детали.ТекущаяСтрока = Параметры.Идентификатор;
		КонецЕсли;
	Иначе
		Стр = Детали.Добавить();
	КонецЕсли;
	
	СписокНоменклатурныхГрупп = Новый СписокЗначений;
	
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ЛДСП16);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ЛДСП10);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кромка045_19);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кромка2_19);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кромка2_35);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ДВП);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Ручка);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.АГТПанель);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.АГТПрофиль);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Зеркало);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Стекло);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.КромкаМДФ);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.МДФ18);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.МДФ8);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.НаправляющиеРоликовые);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.НаправляющиеШариковые35);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.НаправляющиеШариковые45);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.НаправляющиеШариковыеСДоводчиком);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Тандембокс);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Метабокс);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ЩитМебельный);
	
	МассивыНоменклатурныхГрупп = ЛексСервер.ОтборНоменклатурныхГрупп(СписокНоменклатурныхГрупп, Подразделение);
	ДобавитьДопГруппы();
	
	Элементы.Наименование.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ЛДСП16);
	Элементы.Кромка.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Кромка);
	Элементы.НаименованиеФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ФасадыКЯщикам);	
	Элементы.Ручка.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Ручка);
		
	ШапкаОсновныхНастроек = Новый Структура;
	
	ШапкаОсновныхНастроек.Вставить("ВидЯщика",Перечисления.ВидыЯщика.Обычный);
	ШапкаОсновныхНастроек.Вставить("Номенклатура","");
	ШапкаОсновныхНастроек.Вставить("КромкаНоменклатура","");
	ШапкаОсновныхНастроек.Вставить("ВидФасада","Внутр");
	ШапкаОсновныхНастроек.Вставить("КоличествоРучек",1);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ДобавитьКДокументу(Команда)
	
	Если ПроверитьПередСохранением() Тогда
		
		Модифицированность = Ложь;
		ОповеститьОВыборе(ПолучитьАдресХранилища());
		
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ СВОЙСТВ И КАТЕГОРИЙ

//Проверки на все элементы заполнения, а то забудут ввести какая Ручка
&НаКлиенте
Функция ПроверитьПередСохранением()
	
	Результат = Истина;
	
	Для каждого Строка Из Детали Цикл
		
		Если НЕ ЗначениеЗаполнено(Строка.Номенклатура) Тогда
			
			Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Текст = "Укажите номенклатуру ЛДСП";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.Номенклатура");
			Результат = Ложь;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.КромкаНоменклатура) Тогда
			
			Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Текст = "Укажите кромку";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.КромкаНоменклатура");
			Результат = Ложь;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.НаправляющиеНоменклатура) 
			И Строка.ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Обычный") И НЕ Строка.БезНаправляющих  Тогда
			
			Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Текст = "Укажите направляющие для ящика";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.НаправляющиеНоменклатура");
			Результат = Ложь;
			
		КонецЕсли;
		
		Если Строка.ПроемЯщика = 0 Тогда
			
			Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Текст = "Укажите проем ящика";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ПроемЯщика");
			Результат = Ложь;
			
		КонецЕсли;
		
		Если Строка.ВысотаЯщика = 0 Тогда
			
			Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Текст = "Укажите высоту ящика";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ВысотаЯщика");
			Результат = Ложь;
			
		КонецЕсли;
		
		Если Строка.ГлубинаЯщика = 0 Тогда
			
			Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Текст = "Укажите длину ящика";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ГлубинаЯщика");
			Результат = Ложь;
			
		КонецЕсли;
		
		Если Строка.КоличествоЯщиков = 0 Тогда
			
			Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Текст = "Количество ящиков не может быть равно нулю, укажите значение";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.КоличествоЯщиков");
			Результат = Ложь;
			
		КонецЕсли;
		
		Если Строка.ВидФасада <> "Нет" И НЕ ЗначениеЗаполнено(Строка.ФасадНоменклатура)  Тогда
			
			Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Текст = "Укажите номенклатуру фасада";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ФасадНоменклатура");
			Результат = Ложь;
			
		КонецЕсли;
		
		Если Строка.ВидФасада <> "Нет" И НЕ ЗначениеЗаполнено(Строка.КромкаФасадНоменклатура)  Тогда
			
			Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Текст = "Укажите кромку фасада";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.КромкаФасадНоменклатура");
			Результат = Ложь;
			
		КонецЕсли;
		
		
		Если НЕ ЗначениеЗаполнено(Строка.РучкаНоменклатура) И Строка.КоличествоРучек <> 0  Тогда
			Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Текст = "Укажите вид ручки";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.РучкаНоменклатура");
			Результат = Ложь;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.ДноНоменклатура) Тогда
			Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Текст = "Укажите вид дна ящика";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ДноНоменклатура");
			Результат = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ДеталиПриАктивизацииСтроки(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	Если Данные <> Неопределено Тогда
		
		Если НЕ ЗначениеЗаполнено(Данные.ВидЯщика) И ЗначениеЗаполнено(ШапкаОсновныхНастроек.ВидЯщика) Тогда			
			Данные.ВидЯщика = ШапкаОсновныхНастроек.ВидЯщика;		
		ИначеЕсли ЗначениеЗаполнено(Данные.ВидЯщика) Тогда
			ШапкаОсновныхНастроек.Вставить("ВидЯщика", Данные.ВидЯщика);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Данные.Номенклатура) И ЗначениеЗаполнено(ШапкаОсновныхНастроек.Номенклатура) Тогда
			Данные.Номенклатура = ШапкаОсновныхНастроек.Номенклатура;
			Если Данные.ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Метабокс") 
				ИЛИ Данные.ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Тандембокс") Тогда
				Данные.ДноНоменклатура = Данные.Номенклатура;
			КонецЕсли;
		ИначеЕсли ЗначениеЗаполнено(Данные.Номенклатура) Тогда
			ШапкаОсновныхНастроек.Вставить("Номенклатура", Данные.Номенклатура);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Данные.КромкаНоменклатура) И ЗначениеЗаполнено(ШапкаОсновныхНастроек.КромкаНоменклатура) Тогда		
			Данные.КромкаНоменклатура = ШапкаОсновныхНастроек.КромкаНоменклатура;	
		ИначеЕсли ЗначениеЗаполнено(Данные.КромкаНоменклатура) Тогда	
			ШапкаОсновныхНастроек.Вставить("КромкаНоменклатура", Данные.КромкаНоменклатура);		
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Данные.ВидФасада) И ЗначениеЗаполнено(ШапкаОсновныхНастроек.ВидФасада) Тогда		
			Данные.ВидФасада = ШапкаОсновныхНастроек.ВидФасада;	
		ИначеЕсли ЗначениеЗаполнено(Данные.ВидФасада) Тогда	
			ШапкаОсновныхНастроек.Вставить("ВидФасада", Данные.ВидФасада);		
		КонецЕсли;
		
		Если Данные.ВидФасада = "Нет" Тогда
			Данные.ФасадНоменклатура = Неопределено;
			Данные.КромкаФасадНоменклатура = Неопределено;
			Данные.КоличествоРучек = 0;
		Иначе
			Если НЕ ЗначениеЗаполнено(Данные.ФасадНоменклатура) Тогда
				Данные.КоличествоРучек = ШапкаОсновныхНастроек.КоличествоРучек;
			КонецЕсли;
		КонецЕсли;
		
		ЕстьРебро = ЗначениеЗаполнено(Данные.ДлинаРебро);	
		
		Если Данные.КоличествоЯщиков = 0 Тогда
			Данные.КоличествоЯщиков = 1;
		КонецЕсли;		
	КонецЕсли;
	
	ДоступностьНастроек();

КонецПроцедуры

//Процедура ограничивающая доступность при изменении Вида ящиков
&НаКлиенте
Процедура ДоступностьНастроек()
	
	Данные = Элементы.Детали.ТекущиеДанные;
	Если Данные <> Неопределено Тогда
		ВидЯщика = Данные.ВидЯщика;
		//Элементы.Детали.ТекущиеДанные.КоличествоРучек = 0;
		Если ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Обычный") Тогда
			Элементы.ГлубинаЯщика.ТолькоПросмотр = Ложь;
			Элементы.ЕстьРебро.Доступность = Истина;
			Элементы.Направляющие.СписокВыбора.Очистить();
			Элементы.Направляющие.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Направляющие);
			Элементы.ДеталиБезНаправляющих.Доступность = Истина;
			Элементы.Дно.Доступность = Истина;
			Элементы.Дно.СписокВыбора.Очистить();
			Элементы.Дно.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ЛДСП_ДВП);
		ИначеЕсли ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Тандембокс")
			ИЛИ ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Метабокс") Тогда
			Элементы.ГлубинаЯщика.ТолькоПросмотр = Истина;
			Элементы.ЕстьРебро.Доступность = Ложь;
			Элементы.ДеталиБезНаправляющих.Доступность = Ложь;
			Элементы.Дно.Доступность = Ложь;
			Элементы.Дно.СписокВыбора.Очистить();
			Элементы.Дно.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ЛДСП16);
			Если ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Тандембокс") Тогда
				Элементы.Направляющие.СписокВыбора.Очистить();
				Элементы.Направляющие.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Тандембокс);
			Иначе
				Элементы.Направляющие.СписокВыбора.Очистить();
				Элементы.Направляющие.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Метабокс);
			КонецЕсли;
		КонецЕсли;
		
		ЕстьФасад = Элементы.Детали.ТекущиеДанные.ВидФасада <> "Нет";
		
		Элементы.НаименованиеФасада.Доступность = ЕстьФасад;
		Элементы.КромкаФасада.Доступность = ЕстьФасад;
		Элементы.ШиринаФасада.Доступность = ЕстьФасад;
		Элементы.ВысотаФасада.Доступность = ЕстьФасад;
		
		Если ЕстьФасад И ЗначениеЗаполнено(Данные.ФасадНоменклатура) Тогда
			НоменклатурнаяГруппа = ПолучитьНоменклатурнуюГруппу(Данные.ФасадНоменклатура);	
			Элементы.КромкаФасада.СписокВыбора.Очистить();
			Если НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ЛДСП16") Тогда
				Элементы.КромкаФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.КромкаФасад);
			ИначеЕсли НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.МДФ18") Тогда
				Элементы.КромкаФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.КромкаМДФ);
			Иначе 
				Элементы.КромкаФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.АГТПрофиль);	
			КонецЕсли;	
		КонецЕсли;
		
		ДеталиБезНаправляющихПриИзменении();
		КоличествоРучекПриИзменении();
	КонецЕсли;	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ

&НаКлиенте
Процедура ВидЯщикаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	ВидЯщика = Данные.ВидЯщика;
	Данные.КоличествоРучек = 1;
	
	ШапкаОсновныхНастроек.Вставить("ВидЯщика", ВидЯщика);
	
	Данные.НаправляющиеНоменклатура = Неопределено;
	
	Если ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Обычный") Тогда
		Данные.ВысотаЯщика = 150;
		ВысотаЯщикаПриИзменении(Элемент);
	ИначеЕсли ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Тандембокс") 
		ИЛИ ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Метабокс") Тогда
		Данные.БезНаправляющих = Ложь;
		Если НЕ ЗначениеЗаполнено(Данные.НаправляющиеНоменклатура) Тогда
			Данные.ВысотаЯщика = 0; 
			Данные.ГлубинаЯщика = 0;
		КонецЕсли;
		ЕстьРебро = Ложь;
		Данные.ДноНоменклатура = Данные.Номенклатура;
	КонецЕсли;
	
	ДоступностьНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидФасадаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные; 
	
	ВидФасада = Данные.ВидФасада;
	ШапкаОсновныхНастроек.Вставить("ВидФасада", ВидФасада);
	
	БезФасада = ВидФасада = "Нет";
	
	Элементы.НаименованиеФасада.Доступность = НЕ БезФасада;
	Элементы.КромкаФасада.Доступность = НЕ БезФасада;
	Элементы.ШиринаФасада.Доступность = НЕ БезФасада;
	Элементы.ВысотаФасада.Доступность = НЕ БезФасада;
	
	Если БезФасада Тогда
		Данные.ФасадНоменклатура = Неопределено;
		Данные.КромкаФасадНоменклатура = Неопределено;
		Данные.КоличествоРучек = 0;
		Данные.РучкаНоменклатура = Неопределено;
		КоличествоРучекПриИзменении(Элемент);
	КонецЕсли;	
	
	УстановитьРазмерыФасада(Данные, ВидФасада);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроемЯщикаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	ВидЯщика = Данные.ВидЯщика;
	Проем = Данные.ПроемЯщика;
	
	Если Проем > 0 Тогда
		Если ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Обычный") Тогда
			Если Проем >= 150 Тогда
				
				Если ЗначениеЗаполнено(Данные.НаправляющиеНоменклатура) Тогда
					НоменклатурнаяГруппа = ПолучитьНоменклатурнуюГруппу(Данные.НаправляющиеНоменклатура); 
					
					Если НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.НаправляющиеШариковыеСДоводчиком") Тогда
						Данные.ШиринаБоковойСтороны = Проем - 60; 
						Данные.ШиринаДно = Проем - 30;
					Иначе
						Данные.ШиринаБоковойСтороны = Проем - 58;
						Данные.ШиринаДно = Проем - 28;
					КонецЕсли;
					
				Иначе
					Текст = "Укажите направляюще";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.НаправляющиеНоменклатура");
					
					// { Васильев Александр Леонидович [03.12.2013]
					// пиздец конечно, но разрешили без направляющих -- получите
					// } Васильев Александр Леонидович [03.12.2013]
					
					Данные.ШиринаБоковойСтороны = Проем - 58;
					Данные.ШиринаДно = Проем - 28;
					
				КонецЕсли;
				
			Иначе
				Текст = "Укажите проем ящика больше 150 мм.";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ПроемЯщика");
			КонецЕсли;
		ИначеЕсли ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Тандембокс") Тогда
			Если Проем >= 279 Тогда
				Данные.ШиринаБоковойСтороны = Проем - 97;
				Данные.ШиринаДно = Проем - 87;
			Иначе
				Текст = "Укажите проем ящика больше 279 мм.";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ПроемЯщика");
			КонецЕсли;
		ИначеЕсли ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Метабокс") Тогда
			Если Проем >= 213 Тогда
				Данные.ШиринаБоковойСтороны = Проем - 30; 
				Данные.ШиринаДно = Проем - 30;
			Иначе
				Текст = "Укажите проем ящика больше 213 мм.";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ПроемЯщика");
			КонецЕсли;
		КонецЕсли;
		УстановитьРазмерыФасада(Данные, Данные.ВидФасада);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВысотаЯщикаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	ВидЯщика = Данные.ВидЯщика;
	ВысотаЯщика = Данные.ВысотаЯщика;
	
	Если ВысотаЯщика > 0 Тогда
		Если ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Обычный") Тогда
			Данные.ВысотаБоковойСтороны = ВысотаЯщика; 
		ИначеЕсли ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Тандембокс") Тогда
			
			Если ВысотаЯщика > 86 И ВысотаЯщика < 151 Тогда 
				Данные.ВысотаБоковойСтороны = 70;
			ИначеЕсли ВысотаЯщика > 150 И ВысотаЯщика < 201 Тогда 
				Данные.ВысотаБоковойСтороны = 130;
			ИначеЕсли ВысотаЯщика > 200 Тогда 
				Данные.ВысотаБоковойСтороны = 190;
			ИначеЕсли ВысотаЯщика < 86 Тогда
				Текст = "Укажите высоту ящика больше 86 мм.";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ВысотаЯщика");	
			КонецЕсли;
			
		ИначеЕсли ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Метабокс") Тогда
			
			Если ВысотаЯщика > 86 И ВысотаЯщика < 151 Тогда 
				Данные.ВысотаБоковойСтороны = 80; 
			ИначеЕсли ВысотаЯщика > 150 И ВысотаЯщика < 201 Тогда 
				Данные.ВысотаБоковойСтороны = 120; 
			ИначеЕсли ВысотаЯщика > 200 Тогда 
				Данные.ВысотаБоковойСтороны = 200; 
			ИначеЕсли ВысотаЯщика < 86 Тогда
				Текст = "Укажите высоту ящика больше 86 мм.";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ВысотаЯщика");
			КонецЕсли;
			
		КонецЕсли;
		УстановитьРазмерыФасада(Данные, Данные.ВидФасада);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ГлубинаЯщикаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	ВидЯщика = Данные.ВидЯщика;
	ГлубинаЯщика = Данные.ГлубинаЯщика;
	
	Если ГлубинаЯщика > 0 Тогда
		Если ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Обычный") Тогда
			Данные.ДлинаБоковойСтороны = ГлубинаЯщика;
			Данные.ДлинаДно = ГлубинаЯщика - 2;
			ЕстьРеброПриИзменении(Элемент);
		ИначеЕсли ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Тандембокс") ИЛИ 
			ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Метабокс") Тогда
			Данные.ДлинаБоковойСтороны = 0;
			Данные.ДлинаДно = ГлубинаЯщика - 5;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	НоменклатураМатериала = Данные.Номенклатура;
	Если НЕ ЗначениеЗаполнено(Данные.ФасадНоменклатура) Тогда
		Данные.ФасадНоменклатура = НоменклатураМатериала;
		НаименованиеФасадаПриИзменении(Элемент);
	КонецЕсли;
	
	ШапкаОсновныхНастроек.Вставить("Номенклатура", НоменклатураМатериала);
	
	ВидЯщика = Данные.ВидЯщика;
	
	Если ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Метабокс") 
		ИЛИ ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Тандембокс") Тогда
		Данные.ДноНоменклатура = НоменклатураМатериала;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КромкаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	ШапкаОсновныхНастроек.Вставить("КромкаНоменклатура", Данные.КромкаНоменклатура);
	
	Если НЕ ЗначениеЗаполнено(Данные.КромкаФасадНоменклатура) Тогда	
		Данные.КромкаФасадНоменклатура = Данные.КромкаНоменклатура;
		КромкаФасадаПриИзменении(Элемент);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НаправляющиеПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	Направляющие = Данные.НаправляющиеНоменклатура;
	ВидЯщика = Данные.ВидЯщика;
	
	Если ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Обычный") Тогда
		Данные.ГлубинаЯщика = ВернутьЗначениеСвойства("ДлинаДетали", Направляющие);
		ПроемЯщикаПриИзменении(Элемент);
	ИначеЕсли ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Тандембокс") ИЛИ 
		ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Метабокс") Тогда
		Данные.ГлубинаЯщика = ВернутьЗначениеСвойства("ДлинаДетали", Направляющие);
		//Данные.ВысотаЯщика = ВернутьЗначениеСвойства("ДлинаДетали", Направляющие);
	КонецЕсли;
	
	ГлубинаЯщикаПриИзменении(Элемент);
	ВысотаЯщикаПриИзменении(Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ЕстьРеброПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	Данные.ДлинаРебро = ?(ЕстьРебро, Данные.ГлубинаЯщика - 32, 0); //Высота Ребро = ВысотаЯщика
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеФасадаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;	
	УстановитьРазмерыФасада(Данные, Данные.ВидФасада);
	
КонецПроцедуры

&НаКлиенте
Процедура КромкаФасадаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	СвойствоКромки = ВернутьЗначениеСвойства("ГлубинаДетали", Данные.КромкаФасадНоменклатура);
	
	Если СвойствоКромки <> Неопределено Тогда                                                                    
		УстановитьРазмерыФасада(Данные, Данные.ВидФасада);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРазмерыФасада(Данные, ВидФасада)
	
	Если ЗначениеЗаполнено(Данные.ВысотаЯщика) И ЗначениеЗаполнено(Данные.ПроемЯщика) И  ВидФасада <> "Нет" Тогда
		НоменклатурнаяГруппа = ПолучитьНоменклатурнуюГруппу(Данные.ФасадНоменклатура);		
		Если ЗначениеЗаполнено(НоменклатурнаяГруппа) Тогда
			Элементы.КромкаФасада.СписокВыбора.Очистить();
			Если НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ЛДСП16") Тогда
				Элементы.КромкаФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.КромкаФасад);
			ИначеЕсли НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.МДФ18") Тогда
				Элементы.КромкаФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.КромкаМДФ);
			Иначе 
				Элементы.КромкаФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.АГТПрофиль);	
			КонецЕсли;	
		КонецЕсли;
		
		Проем = Данные.ПроемЯщика;		
		Если ЗначениеЗаполнено(Проем) Тогда
			Если ВидФасада = "Внутр" Тогда
				Данные.ШиринаФасад = Проем  - ?(НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ЛДСП16"), 8, 6);	
			ИначеЕсли ВидФасада = "Наруж" Тогда	
				Данные.ШиринаФасад = Проем + ?(НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ЛДСП16"), 24, 26);	
			КонецЕсли;	
		КонецЕсли;	
		Данные.ВысотаФасад = Данные.ВысотаЯщика + 50;
	Иначе
		Данные.ШиринаФасад = 0;
		Данные.ВысотаФасад = 0;		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоРучекПриИзменении(Элемент = Неопределено)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	Элементы.Ручка.Доступность = Данные.КоличествоРучек <> 0;
	
	Если Данные.КоличествоРучек = 0 Тогда
		Данные.РучкаНоменклатура = Неопределено;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДеталиБезНаправляющихПриИзменении(Элемент = Неопределено)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	ВидЯщика = Данные.ВидЯщика;
	Элементы.Направляющие.Доступность = НЕ Данные.БезНаправляющих;
	
	Если Данные.БезНаправляющих И ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Обычный") Тогда
		
		Данные.НаправляющиеНоменклатура = Неопределено;
				
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
