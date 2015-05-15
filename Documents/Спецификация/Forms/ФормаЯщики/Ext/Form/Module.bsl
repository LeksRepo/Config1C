﻿
&НаСервереБезКонтекста
Функция ПолучитьНоменклатурнуюГруппу(ЗначениеНоменклатуры)
	
	Возврат ЗначениеНоменклатуры.НоменклатурнаяГруппа;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьРазмерыЛиста(Номенклатура)
	
	Структура = Новый Структура;
	Структура.Вставить("ВысотаЛиста", Номенклатура.ДлинаДетали);             
	Структура.Вставить("ШиринаЛиста", Номенклатура.ШиринаДетали);
	
	Возврат Структура;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВернутьЗначениеСвойства(ВидСвойства, Элемент)
	
	Если ЗначениеЗаполнено(Элемент[ВидСвойства]) Тогда
		Возврат Элемент[ВидСвойства];
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ДобавитьДопГруппы()
	
	Кромка = Новый Массив;
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
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кожа Цикл
		ФасадыКЯщикам.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.ЩитМебельный Цикл
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

&НаКлиенте
Процедура ОпределитьДоступностьРазмеровЯщика(Данные)
	
	РазмерыЯщикаДоступны = ЗначениеЗаполнено(Данные.Номенклатура) И ЗначениеЗаполнено(Данные.КромкаНоменклатура);
	Элементы.ПроемЯщика.Доступность = РазмерыЯщикаДоступны;
	Элементы.ВысотаЯщика.Доступность = РазмерыЯщикаДоступны;
	
	Данные.ПроемЯщика = ?(РазмерыЯщикаДоступны, Данные.ПроемЯщика, 0);
	Данные.ВысотаЯщика = ?(РазмерыЯщикаДоступны, Данные.ВысотаЯщика, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьДоступностьРазмеровФасада(Данные)
	
	РазмерыФасадаДоступны = ЗначениеЗаполнено(Данные.ПроемЯщика) И ЗначениеЗаполнено(Данные.ВысотаЯщика) И ЗначениеЗаполнено(Данные.ГлубинаЯщика) И
	ЗначениеЗаполнено(Данные.ФасадНоменклатура) И ЗначениеЗаполнено(Данные.КромкаФасадНоменклатура) И (Данные.ВидФасада <> "Нет");
	
	Элементы.ШиринаФасада.Доступность = РазмерыФасадаДоступны;
	Элементы.ВысотаФасада.Доступность = РазмерыФасадаДоступны;
	
	Данные.ШиринаФасад = ?(РазмерыФасадаДоступны, Данные.ШиринаФасад, 0);
	Данные.ВысотаФасад = ?(РазмерыФасадаДоступны, Данные.ВысотаФасад, 0);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

&НаСервере
Функция ПолучитьАдресХранилища()
	
	Табличка = Детали.Выгрузить();
	
	Если ОткрытоИз3дРедактора Тогда
		
		Структурка = Новый Структура;
		Структурка.Вставить("Редактор3д", "Редактор3д");
		Структурка.Вставить("Строка3дРедактора", ВыборЯщикаИзКаталога.Строка3дРедактора);
		Структурка.Вставить("АдресТаблицы", ПоместитьВоВременноеХранилище(Табличка));
		Возврат Структурка;
		
	Иначе
		
		Возврат ПоместитьВоВременноеХранилище(Табличка);
		
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьМассивЯщиков()
	
	МассивНазванийЯщиков = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	
	"ВЫБРАТЬ
	|	КаталогИзделий.Ссылка
	|ИЗ
	|	Справочник.КаталогИзделий КАК КаталогИзделий
	|ГДЕ
	|	КаталогИзделий.ВидИзделияПоКаталогу = ЗНАЧЕНИЕ(Справочник.ВидыИзделийПоКаталогу.Ящик)
	|	И НЕ КаталогИзделий.ПометкаУдаления
	|	И КаталогИзделий.Активный";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		МассивНазванийЯщиков.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		
	КонецЦикла;
	
	Возврат МассивНазванийЯщиков;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОткрытоИз3дРедактора = Ложь;
	
	Если Параметры.Свойство("Редактор3д") Тогда
		
		Элементы.ВыборЯщикаИзКаталога.Видимость = Истина;
		Элементы.ВидЯщика.Видимость = Ложь;
		Элементы.ВыборЯщикаИзКаталога.СписокВыбора.ЗагрузитьЗначения(ПолучитьМассивЯщиков());
		Элементы.Детали.Доступность = Ложь;
		Элементы.КоличествоЯщиков.Доступность = Ложь;
		
		ОткрытоИз3дРедактора = Истина;
		СтруктураТЗ = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицы);
		
		Если СтруктураТЗ.Количество() > 0 Тогда
			
			Детали.Загрузить(СтруктураТЗ.Ящики);
			СтрокаЯщика = СтруктураТЗ.ИмяЯщика;
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	КаталогИзделий.Ссылка
			|ИЗ
			|	Справочник.КаталогИзделий КАК КаталогИзделий
			|ГДЕ
			|	КаталогИзделий.Строка3дРедактора ПОДОБНО &Строка3дРедактора";
			
			Запрос.УстановитьПараметр("Строка3дРедактора", СтрокаЯщика);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
				ВыборЯщикаИзКаталога = ВыборкаДетальныеЗаписи.Ссылка;
				
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		
		Детали.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицы));
		
	КонецЕсли;
	
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
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кожа);
	
	МассивыНоменклатурныхГрупп = ЛексСервер.ОтборНоменклатурныхГрупп(СписокНоменклатурныхГрупп, Подразделение);
	ДобавитьДопГруппы();
	
	Элементы.Наименование.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ЛДСП16);
	Элементы.Кромка.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Кромка045_19); // МассивыНоменклатурныхГрупп.Кромка
	Элементы.НаименованиеФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ФасадыКЯщикам);	
	Элементы.Ручка.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Ручка);
	
	ШапкаОсновныхНастроек = Новый Структура;
	
	ШапкаОсновныхНастроек.Вставить("ВидЯщика",Перечисления.ВидыЯщика.Обычный);
	ШапкаОсновныхНастроек.Вставить("Номенклатура","");
	ШапкаОсновныхНастроек.Вставить("КромкаНоменклатура","");
	ШапкаОсновныхНастроек.Вставить("ВидФасада","Внутр");
	ШапкаОсновныхНастроек.Вставить("КоличествоРучек",1);
	ШапкаОсновныхНастроек.Вставить("СтруктураПодставляяемойНоменклатуры", Новый Структура);
	
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

&НаСервере
Функция ПроверитьПередСохранением()
	
	Ошибки = Неопределено;
	
	Для каждого Строка Из Детали Цикл
		
		Индекс = Детали.Индекс(Строка) + 1;
		
		Если НЕ ЗначениеЗаполнено(Строка.Номенклатура) Тогда
			
			Текст = "Укажите номенклатуру ЛДСП ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.Номенклатура", Текст,,1);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.КромкаНоменклатура) Тогда
			
			Текст = "Укажите кромку ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.КромкаНоменклатура", Текст);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.НаправляющиеНоменклатура) 
			И Строка.ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Обычный") И НЕ Строка.БезНаправляющих  Тогда
			
			Текст = "Укажите направляющие для ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.НаправляющиеНоменклатура", Текст);
			
		КонецЕсли;
		
		Если Строка.ПроемЯщика = 0 Тогда
			
			Текст = "Укажите проем ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.ПроемЯщика", Текст);
			
		КонецЕсли;
		
		Если Строка.ВысотаЯщика = 0 Тогда
			
			Текст = "Укажите высоту ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.ВысотаЯщика", Текст);
			
		КонецЕсли;
		
		Если Строка.ГлубинаЯщика = 0 Тогда
			
			Текст = "Укажите глубину ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.ГлубинаЯщика", Текст);
			
		КонецЕсли;
		
		Если Строка.КоличествоЯщиков = 0 Тогда
			
			Текст = "Укажите количество ящиков № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.КоличествоЯщиков", Текст);
			
		КонецЕсли;
		
		Если Строка.ВидФасада <> "Нет" И НЕ ЗначениеЗаполнено(Строка.ФасадНоменклатура)  Тогда
			
			Текст = "Укажите номенклатуру фасада ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.ФасадНоменклатура", Текст);
			
		КонецЕсли;
		
		Если Строка.ВидФасада <> "Нет" И НЕ ЗначениеЗаполнено(Строка.КромкаФасадНоменклатура)  Тогда
			
			Текст = "Укажите кромку фасада ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.КромкаФасадНоменклатура", Текст);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.РучкаНоменклатура) И Строка.КоличествоРучек <> 0  Тогда
			
			Текст = "Укажите вид ручки ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.РучкаНоменклатура", Текст);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.ДноНоменклатура) Тогда
			
			Текст = "Укажите вид дна ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.ДноНоменклатура", Текст);
			
		КонецЕсли;
		
		СтруктураПараметровЯщика = Документы.Спецификация.ПолучитьПараметрыЯщика(Строка, Строка.ЕстьРебро);
		
	КонецЦикла;
	
	Если Ошибки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
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
			ШапкаОсновныхНастроек.Вставить("СтруктураПодставляяемойНоменклатуры", ЛексСервер.ПолучитьСтруктуруПодставляемойНоменклатурыПоЦветуЛДСП(Данные.Номенклатура, Подразделение));
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
		
		Данные.ЕстьРебро = Данные.ЕстьРебро ИЛИ ЗначениеЗаполнено(Данные.ДлинаРебро);	
		
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
		
		ОпределитьДоступностьРазмеровЯщика(Данные);
		
		ЕстьФасад = Элементы.Детали.ТекущиеДанные.ВидФасада <> "Нет";
		РазмерыФасадаДоступны = ЗначениеЗаполнено(Данные.ФасадНоменклатура) И ЗначениеЗаполнено(Данные.КромкаФасадНоменклатура);
		
		Элементы.НаименованиеФасада.Доступность = ЕстьФасад;
		Элементы.КромкаФасада.Доступность = ЕстьФасад;
		Элементы.ШиринаФасада.Доступность = ЕстьФасад И РазмерыФасадаДоступны;
		Элементы.ВысотаФасада.Доступность = ЕстьФасад И РазмерыФасадаДоступны;
		
		Если ЕстьФасад И ЗначениеЗаполнено(Данные.ФасадНоменклатура) Тогда
			
			//НоменклатурнаяГруппа = ПолучитьНоменклатурнуюГруппу(Данные.ФасадНоменклатура);	
			
			//RonEXI: Устарел список
			//Элементы.КромкаФасада.СписокВыбора.Очистить();
			//						
			//Если НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ЛДСП16") Тогда
			//	Элементы.КромкаФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.КромкаФасад);
			//ИначеЕсли НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.МДФ18") Тогда
			//	Элементы.КромкаФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.КромкаМДФ);
			//Иначе 
			//	Элементы.КромкаФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.АГТПрофиль);	
			//КонецЕсли;
					
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
Процедура ОбновитьВидЯщика(Элемент)
	
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
					
					//НоменклатурнаяГруппа = ПолучитьНоменклатурнуюГруппу(Данные.НаправляющиеНоменклатура); 
					//
					//Если НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.НаправляющиеШариковыеСДоводчиком") Тогда
					//	Данные.ШиринаБоковойСтороны = Проем - 60; 
					//	Данные.ШиринаДно = Проем - 30;
					//Иначе
					//	Данные.ШиринаБоковойСтороны = Проем - 58;
					//	Данные.ШиринаДно = Проем - 28;
					//КонецЕсли;
					
				Иначе
					
					Текст = "Укажите направляюще";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.НаправляющиеНоменклатура");
					
					// { Васильев Александр Леонидович [03.12.2013]
					// пиздец конечно, но разрешили без направляющих -- получите
					// } Васильев Александр Леонидович [03.12.2013]
					
					//Данные.ШиринаБоковойСтороны = Проем - 58;
					//Данные.ШиринаДно = Проем - 28;
					
				КонецЕсли;
				
			Иначе
				Текст = "Укажите проем ящика больше 150 мм.";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ПроемЯщика");
			КонецЕсли;
		ИначеЕсли ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Тандембокс") Тогда
			Если Проем >= 279 Тогда
				//Данные.ШиринаБоковойСтороны = Проем - 97;
				//Данные.ШиринаДно = Проем - 87;
			Иначе
				Текст = "Укажите проем ящика больше 279 мм.";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ПроемЯщика");
			КонецЕсли;
		ИначеЕсли ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Метабокс") Тогда
			Если Проем >= 213 Тогда
				//Данные.ШиринаБоковойСтороны = Проем - 30; 
				//Данные.ШиринаДно = Проем - 30;
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
		//Если ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Обычный") Тогда
		//	Данные.ВысотаБоковойСтороны = ВысотаЯщика; 
		//Иначе
		Если ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Тандембокс") Тогда
			
			//Если ВысотаЯщика > 86 И ВысотаЯщика < 151 Тогда 
			//	Данные.ВысотаБоковойСтороны = 70;
			//ИначеЕсли ВысотаЯщика > 150 И ВысотаЯщика < 201 Тогда 
			//	Данные.ВысотаБоковойСтороны = 130;
			//ИначеЕсли ВысотаЯщика > 200 Тогда 
			//	Данные.ВысотаБоковойСтороны = 190;
			//Иначе
			Если ВысотаЯщика < 86 Тогда
				Текст = "Укажите высоту ящика больше 86 мм.";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ВысотаЯщика");	
			КонецЕсли;
			
		ИначеЕсли ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Метабокс") Тогда
			
			//Если ВысотаЯщика > 86 И ВысотаЯщика < 151 Тогда 
			//	Данные.ВысотаБоковойСтороны = 80; 
			//ИначеЕсли ВысотаЯщика > 150 И ВысотаЯщика < 201 Тогда 
			//	Данные.ВысотаБоковойСтороны = 120; 
			//ИначеЕсли ВысотаЯщика > 200 Тогда 
			//	Данные.ВысотаБоковойСтороны = 200; 
			//Иначе
			Если ВысотаЯщика < 86 Тогда
				Текст = "Укажите высоту ящика больше 86 мм.";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.ВысотаЯщика");
			КонецЕсли;
			
		КонецЕсли;
		УстановитьРазмерыФасада(Данные, Данные.ВидФасада);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ГлубинаЯщикаПриИзменении(Элемент)
	
	Заглушка = Истина;
	//Данные = Элементы.Детали.ТекущиеДанные;
	//
	//ВидЯщика = Данные.ВидЯщика;
	//ГлубинаЯщика = Данные.ГлубинаЯщика;
	//
	//Если ГлубинаЯщика > 0 Тогда
	//	Если ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Обычный") Тогда
	//		Данные.ДлинаБоковойСтороны = ГлубинаЯщика;
	//		Данные.ДлинаДно = ГлубинаЯщика - 2;
	//		ЕстьРеброПриИзменении(Элемент);
	//	ИначеЕсли ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Тандембокс") ИЛИ 
	//		ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Метабокс") Тогда
	//		Данные.ДлинаБоковойСтороны = 0;
	//		Данные.ДлинаДно = ГлубинаЯщика - 5;
	//	КонецЕсли;
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	НоменклатураМатериала = Данные.Номенклатура;
	ШапкаОсновныхНастроек.Вставить("Номенклатура", НоменклатураМатериала);	
	
	ШапкаОсновныхНастроек.Вставить("СтруктураПодставляяемойНоменклатуры", ЛексСервер.ПолучитьСтруктуруПодставляемойНоменклатурыПоЦветуЛДСП(НоменклатураМатериала, Подразделение));
	Данные.КромкаНоменклатура = ?(ШапкаОсновныхНастроек.СтруктураПодставляяемойНоменклатуры.Свойство("Кромка045_19"), ШапкаОсновныхНастроек.СтруктураПодставляяемойНоменклатуры.Кромка045_19, Неопределено);
	ШапкаОсновныхНастроек.Вставить("КромкаНоменклатура", Данные.КромкаНоменклатура);
	
	Если НЕ ЗначениеЗаполнено(Данные.ФасадНоменклатура) Тогда
		Данные.ФасадНоменклатура = НоменклатураМатериала;
		Данные.КромкаФасадНоменклатура = ?(ШапкаОсновныхНастроек.СтруктураПодставляяемойНоменклатуры.Свойство("Кромка2_19"), ШапкаОсновныхНастроек.СтруктураПодставляяемойНоменклатуры.Кромка2_19, Неопределено);
		НаименованиеФасадаПриИзменении(Элемент);
	КонецЕсли;
	
	ВидЯщика = Данные.ВидЯщика;
	
	Если ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Метабокс") 
		ИЛИ ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Тандембокс") Тогда
		Данные.ДноНоменклатура = НоменклатураМатериала;
	КонецЕсли;
	
	ОпределитьДоступностьРазмеровЯщика(Данные);
	
КонецПроцедуры

&НаКлиенте
Процедура КромкаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	ОпределитьДоступностьРазмеровЯщика(Данные);
	
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
	
	Заглушка = Истина;
	//Данные = Элементы.Детали.ТекущиеДанные;
	//Данные.ДлинаРебро = ?(ЕстьРебро, Данные.ГлубинаЯщика - 32, 0); //Высота Ребро = ВысотаЯщика
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеФасадаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;	
	//УстановитьРазмерыФасада(Данные, Данные.ВидФасада);
	Данные.КромкаФасадНоменклатура = ?(ШапкаОсновныхНастроек.СтруктураПодставляяемойНоменклатуры.Свойство("Кромка2_19"), 
	ШапкаОсновныхНастроек.СтруктураПодставляяемойНоменклатуры.Кромка2_19, Неопределено);
	
	СвойствоКромки = ВернутьЗначениеСвойства("ГлубинаДетали", Данные.КромкаФасадНоменклатура);
	
	//Если СвойствоКромки <> Неопределено Тогда
	
	УстановитьРазмерыФасада(Данные, Данные.ВидФасада);
	
	//КонецЕсли;
	
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
	
	Если ЗначениеЗаполнено(Данные.ФасадНоменклатура) Тогда
		НоменклатурнаяГруппа = ПолучитьНоменклатурнуюГруппу(Данные.ФасадНоменклатура);		
		Если ЗначениеЗаполнено(НоменклатурнаяГруппа) Тогда
			//RonEXI: Устарел список
			//Данные.КромкаФасадНоменклатура = Неопределено;
			//Элементы.КромкаФасада.СписокВыбора.Очистить();
			//Если НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ЛДСП16") Тогда
			//	Элементы.КромкаФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.КромкаФасад);
			//ИначеЕсли НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.МДФ18") Тогда
			//	Элементы.КромкаФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.КромкаМДФ);
			//Иначе
			//	Элементы.КромкаФасада.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.АГТПрофиль);	
			//КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	РассчитатьФасад = Истина;
	
	Если ЗначениеЗаполнено(Данные.НомерИзделия) И ЗначениеЗаполнено(Данные.ШиринаФасад) И ЗначениеЗаполнено(Данные.ВысотаФасад) Тогда
		
		Ответ = Вопрос("Размеры фасада рассчитанные по каталогу могут быть изменены, оставить текущие размеры?", РежимДиалогаВопрос.ДаНет,,);
		РассчитатьФасад = Ответ = КодВозвратаДиалога.Нет;
		
	КонецЕсли;
	
	Если РассчитатьФасад Тогда
		Если ЗначениеЗаполнено(Данные.ВысотаЯщика) И ЗначениеЗаполнено(Данные.ПроемЯщика) И Данные.ВидФасада <> "Нет" Тогда
			
			Данные.ВысотаФасад = Данные.ВысотаЯщика + 50;
			Проем = Данные.ПроемЯщика;
			
			Если ЗначениеЗаполнено(Проем) Тогда
				
				Если ВидФасада = "Внутр" Тогда
					Данные.ШиринаФасад = Проем  - ?(НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ЛДСП16"), 8, 6);
				ИначеЕсли ВидФасада = "Наруж" Тогда	
					Данные.ШиринаФасад = Проем + ?(НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ЛДСП16"), 24, 26);
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			
			Данные.ШиринаФасад = 0;
			Данные.ВысотаФасад = 0;
			
		КонецЕсли;
	КонецЕсли;
	
	ОпределитьДоступностьРазмеровФасада(Данные);
	
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
	Элементы.ГлубинаЯщика.ТолькоПросмотр = НЕ Данные.БезНаправляющих;
	
	Если Данные.БезНаправляющих И ВидЯщика = ПредопределенноеЗначение("Перечисление.ВидыЯщика.Обычный") Тогда
		Данные.НаправляющиеНоменклатура = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборЯщикаИзКаталогаПриИзменении(Элемент)
	ВыборЯщикаИзКаталогаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыборЯщикаИзКаталогаПриИзмененииНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Заглушка = Истина;
	//Если ОткрытоИз3дРедактора Тогда
	//	
	//	Детали.КоличествоЯщиков = 1;
	//	
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПодбора(НомГруппы, ЭлементФормы)
	
	Пар = Новый Структура();
	Пар.Вставить("НомГруппы", НомГруппы);
	Пар.Вставить("Подразделение", Подразделение);
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", Пар, ЭлементФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура РучкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомГруппы = Новый СписокЗначений;
	НомГруппы.Добавить(ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.Ручка"));
	
	ОткрытьФормуПодбора(НомГруппы, Элементы.Ручка);
	
КонецПроцедуры

&НаКлиенте
Процедура КромкаФасадаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомГруппы = ПолучитьНомГруппыКромкаФасад(Элементы.Детали.ТекущиеДанные.ФасадНоменклатура);
	
	ОткрытьФормуПодбора(НомГруппы, Элементы.КромкаФасада);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНомГруппыКромкаФасад(Номенклатура)
	
	НоменклатурнаяГруппа = Номенклатура.НоменклатурнаяГруппа;
	
	НомГруппы = Новый СписокЗначений;	
	
	Если НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ЛДСП16 Тогда
		
		НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.Кромка045_19);
		НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.Кромка2_19);
		НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.Кромка2_35);
		НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.КромкаМДФ);
		
	ИначеЕсли НоменклатурнаяГруппа =Справочники.НоменклатурныеГруппы.МДФ18 Тогда
		НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.КромкаМДФ);
	ИначеЕсли НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ЛДСП10 Тогда
		НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.Кромка045_19);
	Иначе
		НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.АГТПрофиль);
	КонецЕсли;
	
	Возврат НомГруппы;
	
КонецФункции

&НаКлиенте
Процедура ДноНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомГруппы = Новый СписокЗначений;
	НомГруппы.Добавить(ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ДВП"));
	НомГруппы.Добавить(ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ЛДСП10"));
	
	ОткрытьФормуПодбора(НомГруппы, Элементы.Дно);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеФасадаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомГруппы = ПолучитьНомГруппыНаименованиеФасада();
	ОткрытьФормуПодбора(НомГруппы, Элементы.НаименованиеФасада);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНомГруппыНаименованиеФасада()
	
	НомГруппы = Новый СписокЗначений;
	
	НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.ЛДСП16);
	НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.МДФ18);
	НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.АГТПанель);	
	
	// { Васильев Александр Леонидович [20.04.2015]
	// Лайн Д.В. сказал только эти материалы для фасада на ящики.
	// } Васильев Александр Леонидович [20.04.2015]	
	
	//НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.МДФ8);
	//НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.ЛДСП10); // можно для вставки в АГТпрофиль с фрезеровкой
	//НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.Кожа);
	//НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.ЩитМебельный);
	
	Возврат НомГруппы;
	
КонецФункции

&НаКлиенте
Процедура НаправляющиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомГруппы = ПолучитьНомГруппыНаправляющие(Элементы.Детали.ТекущиеДанные.ВидЯщика);
	
	ОткрытьФормуПодбора(НомГруппы, Элементы.Направляющие);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНомГруппыНаправляющие(ВидЯщика)
	
	НомГруппы = Новый СписокЗначений;
	
	Если ВидЯщика = Перечисления.ВидыЯщика.Обычный Тогда
		
		НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.НаправляющиеРоликовые);
		НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.НаправляющиеШариковые35);
		НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.НаправляющиеШариковые45);
		НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.НаправляющиеШариковыеСДоводчиком);
		
	ИначеЕсли ВидЯщика = Перечисления.ВидыЯщика.Тандембокс Тогда
		
		НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.Тандембокс);
		
	ИначеЕсли ВидЯщика = Перечисления.ВидыЯщика.Метабокс Тогда
		
		НомГруппы.Добавить(Справочники.НоменклатурныеГруппы.Метабокс);
		
	КонецЕсли;
	
	Возврат НомГруппы;
	
КонецФункции

&НаКлиенте
Процедура КромкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомГруппы = Новый СписокЗначений;
	НомГруппы.Добавить(ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.Кромка045_19"));
	
	ОткрытьФормуПодбора(НомГруппы, Элементы.Кромка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомГруппы = Новый СписокЗначений;
	НомГруппы.Добавить(ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ЛДСП16"));
	
	ОткрытьФормуПодбора(НомГруппы, Элементы.Наименование);
	
КонецПроцедуры

&НаКлиенте
Процедура СхемаЯщикаПриИзменении(Элемент)
	
	Схема = Элементы.Детали.ТекущиеДанные.СхемаЯщика;
	Вид = ЛексСервер.ЗначениеРеквизитаОбъекта(Схема, "Вид");
	Элементы.Детали.ТекущиеДанные.ВидЯщика = Вид;
	
	ОбновитьВидЯщика(Элемент);
	
КонецПроцедуры
