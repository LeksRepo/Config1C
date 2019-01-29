﻿&НаКлиенте
Перем ДанныеСхемы;

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
	
	РазмерыЯщикаДоступны = ЗначениеЗаполнено(Данные.Номенклатура) И ЗначениеЗаполнено(Данные.КромкаНоменклатура) И ЗначениеЗаполнено(Данные.НаправляющиеНоменклатура);
	
	Элементы.ПроемЯщика.Доступность = РазмерыЯщикаДоступны;
	Элементы.ВысотаЯщика.Доступность = РазмерыЯщикаДоступны;
	
	Данные.ПроемЯщика = ?(РазмерыЯщикаДоступны, Данные.ПроемЯщика, 0);
	Данные.ВысотаЯщика = ?(РазмерыЯщикаДоступны, Данные.ВысотаЯщика, 0);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

&НаСервере
Функция ПолучитьАдресХранилища()
	
	Возврат ПоместитьВоВременноеХранилище(Детали.Выгрузить());
	
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
	
	Детали.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицы));
	
	Подразделение = Параметры.Подразделение;
	
	Если Параметры.Свойство("Дилерский") И Параметры.Дилерский И Параметры.Свойство("Контрагент") Тогда
		Контрагент = Параметры.Контрагент;
	КонецЕсли;
	
	Если Параметры.Свойство("Офис") Тогда
		Офис = Параметры.ОФис;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Детали) Тогда
		Если Параметры.Свойство("Идентификатор") Тогда
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
	
	ШапкаОсновныхНастроек = Новый Структура;
	
	ШапкаОсновныхНастроек.Вставить("СхемаЯщика","");
	ШапкаОсновныхНастроек.Вставить("Номенклатура","");
	ШапкаОсновныхНастроек.Вставить("КромкаНоменклатура","");
	ШапкаОсновныхНастроек.Вставить("ВидФасада","Внутр");
	ШапкаОсновныхНастроек.Вставить("КоличествоРучек",1);
	ШапкаОсновныхНастроек.Вставить("ПодходящаяНом", Новый Структура);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ДобавитьКДокументу(Команда)
	
	Если ПроверитьПередСохранением() Тогда
		
		Структура = Новый Структура;
		Структура.Вставить("АдресХранИЛИща", ПолучитьАдресХранилища());
		Структура.Вставить("Модифицированность", Модифицированность);

		Модифицированность = Ложь;
		
		ОповеститьОВыборе(Структура);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ СВОЙСТВ И КАТЕГОРИЙ

&НаСервере
Функция ПроверитьПередСохранением()
	
	Ошибки = Неопределено;
	
	Для каждого Строка Из Детали Цикл
		
		Индекс = Детали.Индекс(Строка) + 1;
		
		ПараметрыСхемы = ПолучитьДанныеСхемы(Строка.СхемаЯщика);
		
		Если НЕ ЗначениеЗаполнено(Строка.Номенклатура) Тогда
			
			Текст = "Укажите номенклатуру ЛДСП ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.Номенклатура", Текст,,1);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.КромкаНоменклатура) Тогда
			
			Текст = "Укажите кромку ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.КромкаНоменклатура", Текст);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.НаправляющиеНоменклатура) И НЕ Строка.БезНаправляющих Тогда
			
			Текст = "Укажите направляющие для ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.НаправляющиеНоменклатура", Текст);
			
		КонецЕсли;
		
		МинПроем = 0;
		Выполнить("МинПроем =" + ЛексКлиентСервер.ПодставитьОбъектВФормулуЯщика("Строка", ПараметрыСхемы.МинПроем));
		
		Если Строка.ПроемЯщика = 0 Тогда
			
			Текст = "Укажите проем ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.ПроемЯщика", Текст);
			
		КонецЕсли;
		
		Если Строка.ПроемЯщика < МинПроем Тогда
			Текст = "Укажите проем ящика № "+Индекс+" : "+МинПроем+" мм. или больше.";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.ПроемЯщика", Текст);
		КонецЕсли;
		
		МинВысота = 0;
		Выполнить("МинВысота =" + ЛексКлиентСервер.ПодставитьОбъектВФормулуЯщика("Строка", ПараметрыСхемы.МинВысота));
		
		Если Строка.ВысотаЯщика = 0 Тогда
			
			Текст = "Укажите высоту ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.ВысотаЯщика", Текст);
			
		КонецЕсли;
		
		Если Строка.ВысотаЯщика < МинВысота Тогда
			Текст = "Укажите высоту ящика № "+Индекс+" : "+МинВысота+" мм. или больше.";
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
		
		Если Строка.ВидФасада <> "Нет" И НЕ ЗначениеЗаполнено(Строка.ФасадНоменклатура) Тогда
			
			Текст = "Укажите номенклатуру фасада ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.ФасадНоменклатура", Текст);
			
		КонецЕсли;
		
		ЭтоПленочныйФасад = Ложь;
		
		Если ЗначениеЗаполнено(Строка.ФасадНоменклатура) И Строка.ФасадНоменклатура.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ФасадМДФПленочный Тогда 
		    ЭтоПленочныйФасад = Истина;
		КонецЕсли;
				
		Если НЕ ЭтоПленочныйФасад И (Строка.ВидФасада <> "Нет" И НЕ ЗначениеЗаполнено(Строка.КромкаФасадНоменклатура)) Тогда
			
			Текст = "Укажите кромку фасада ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.КромкаФасадНоменклатура", Текст);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.РучкаНоменклатура) И Строка.КоличествоРучек <> 0 Тогда
			
			Текст = "Укажите вид ручки ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.РучкаНоменклатура", Текст);
			
		КонецЕсли;
		
		Если ПараметрыСхемы.ПолеДно И НЕ ЗначениеЗаполнено(Строка.ДноНоменклатура) Тогда
			
			Текст = "Укажите вид дна ящика № " + Индекс;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.ДноНоменклатура", Текст);
			
		КонецЕсли;
		
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
	
	Если (Данные <> Неопределено) Тогда
		
		Если ЗначениеЗаполнено(Данные.СхемаЯщика) Тогда 
			
			ДанныеСхемы = ПолучитьДанныеСхемы(Данные.СхемаЯщика);
			ЗаполнитьШапкуОсновныхНастроек(Данные);
			УстановитьШиринуЯщика(Данные);
			
		Иначе
			
			Данные.ШиринаЯщика = 0;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДоступностьНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьШиринуЯщика(Данные)
	
	Элементы.ШиринаЯщика.Видимость = ДанныеСхемы.ПоказыватьШирину;
	Элементы.ШиринаЯщика.Доступность = ДанныеСхемы.ПоказыватьШирину;
	
	Если Данные.ПроемЯщика > 0 И ЗначениеЗаполнено(Данные.НаправляющиеНоменклатура) Тогда
		
		UID = Новый УникальныйИдентификатор;
		Данные.uid = UID;
		
		Данные.ШиринаЯщика = ПолучитьЗначениеФормулы(ДанныеСхемы.ШиринаЯщика, UID);
		
	КонецЕсли;
	
КонецПроцедуры

//Процедура ограничивающая доступность при изменении Вида ящиков
&НаКлиенте
Процедура ДоступностьНастроек()
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	Если Данные <> Неопределено Тогда
		
		Если ЗначениеЗаполнено(Данные.СхемаЯщика) Тогда
			
			ДоступностьВсеЭлементы(Истина);
			
			Элементы.ЕстьРебро.Доступность = ДанныеСхемы.ПолеРебро;
			Элементы.Дно.Доступность = ДанныеСхемы.ПолеДно;
			Элементы.ДеталиБезНаправляющих.Доступность = ДанныеСхемы.ПолеБезНаправляющих;
			
			ОпределитьДоступностьРазмеровЯщика(Данные);
			
			Элементы.Фасад.Доступность = Элементы.ПроемЯщика.Доступность;
			
			ЕстьФасад = Элементы.Детали.ТекущиеДанные.ВидФасада <> "Нет";
			РазмерыФасадаДоступны = ЗначениеЗаполнено(Данные.ФасадНоменклатура) И ЗначениеЗаполнено(Данные.КромкаФасадНоменклатура);
			
			Элементы.НаименованиеФасада.Доступность = ЕстьФасад;
			Элементы.КромкаФасада.Доступность = ЕстьФасад;
			Элементы.ШиринаФасада.Доступность = ЕстьФасад И РазмерыФасадаДоступны;
			Элементы.ВысотаФасада.Доступность = ЕстьФасад И РазмерыФасадаДоступны;
			
			Элементы.КоличествоРучек.Доступность = ЕстьФасад;
			Элементы.Ручка.Доступность = Данные.КоличествоРучек <> 0;
						
			Если Данные.КоличествоРучек = 0 Тогда
				Данные.РучкаНоменклатура = Неопределено;
			КонецЕсли;
			
			Элементы.КриволинейныйВыпилПодРучку.Доступность = ДанныеСхемы.КриволинейныйВыпилПодРучку И ЕстьФасад;
			Элементы.РучкаЩель.Доступность = ДанныеСхемы.РучкаЩель И ЕстьФасад;
			
			Если Данные.КриволинейныйВыпилПодРучку ИЛИ Данные.РучкаЩель Тогда
				Элементы.КоличествоРучек.Доступность = Ложь;
				Элементы.Ручка.Доступность = Ложь;
			КонецЕсли;
			
		Иначе
			
			ДоступностьВсеЭлементы(Ложь);
			
		КонецЕсли;
	Иначе
		ДоступностьВсеЭлементы(Ложь);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ

&НаКлиенте
Процедура ВидФасадаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные; 
	
	Если (Данные.ВидФасада = "Нет") И ДанныеСхемы.ФасадОбязательно Тогда
		
		 Данные.ВидФасада = "Внутр";
		 Сообщить("Данный вид ящика доступен только с фасадом.");
		
	КонецЕсли;
	
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
		
		Элементы.КоличествоРучек.Доступность=Ложь;
		Данные.КриволинейныйВыпилПодРучку = Ложь;
		Данные.РучкаЩель = Ложь;
	
	Иначе
		
		Элементы.КоличествоРучек.Доступность=Истина;
		НаименованиеПриИзменении(Элемент);
		
	КонецЕсли;
	
	УстановитьРазмерыФасада(Данные);
	ДоступностьНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроемЯщикаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	ПроемЯщика = Данные.ПроемЯщика;
	ВысотаЯщика = Данные.ВысотаЯщика;
	
	Если ПроемЯщика > 0 Тогда
		
		УстановитьРазмерыФасада(Данные);
		УстановитьГлубинуЯщика();
		УстановитьШиринуЯщика(Данные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВысотаЯщикаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	ВысотаЯщика = Данные.ВысотаЯщика;
	ПроемЯщика = Данные.ПроемЯщика;
	
	Если ВысотаЯщика > 0 Тогда
		
		УстановитьРазмерыФасада(Данные);
		УстановитьГлубинуЯщика();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГлубинаЯщикаПриИзменении(Элемент)
	
	Заглушка = Истина;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПодставляемуюНоменклатуру(Поле, Материал, ПодходящаяНом)
	
	ИменаНомГрупп = ПолучитьНомГруппы(Поле, Материал, Истина);
	НужнаяНом = Неопределено;
	
	Для Каждого Гр ИЗ ИменаНомГрупп Цикл
		
		Имя = Гр.Значение;
		
		Если ПодходящаяНом.Свойство(Имя) И ЗначениеЗаполнено(ПодходящаяНом[Имя]) Тогда
			 НужнаяНом = ПодходящаяНом[Имя];
			 Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НужнаяНом;
	
КонецФункции

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	НоменклатураМатериала = Данные.Номенклатура;
	НомГруппаМатериал = ПолучитьНоменклатурнуюГруппу(НоменклатураМатериала);
	
	ШапкаОсновныхНастроек.Вставить("Номенклатура", НоменклатураМатериала);
	
	ПодходящаяНом =  ЛексСервер.ПолучитьСтруктуруПодставляемойНоменклатурыПоЦветуЛДСП(НоменклатураМатериала, Подразделение);
	ШапкаОсновныхНастроек.Вставить("ПодходящаяНом", ПодходящаяНом);
		
	НужнаяНом = ПолучитьПодставляемуюНоменклатуру("ЯщикКромка", НомГруппаМатериал, ПодходящаяНом);	
	
	Данные.КромкаНоменклатура = ?(ЗначениеЗаполнено(НужнаяНом), НужнаяНом, Неопределено);
	ШапкаОсновныхНастроек.Вставить("КромкаНоменклатура", Данные.КромкаНоменклатура);
	
	Если НЕ ЗначениеЗаполнено(Данные.ФасадНоменклатура) И (Данные.ВидФасада <> "Нет") Тогда
		
		НомГруппыФасад = ПолучитьНомГруппы("ФасадМатериал");
		Подходит = Ложь;
		
		Для Каждого Гр ИЗ НомГруппыФасад Цикл
			
			Если Гр.Значение = НомГруппаМатериал Тогда
				Подходит = Истина;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если Подходит Тогда
		
			Данные.ФасадНоменклатура = НоменклатураМатериала;
			
			НужнаяНом = ПолучитьПодставляемуюНоменклатуру("ФасадКромка", НомГруппаМатериал, ПодходящаяНом);

			Данные.КромкаФасадНоменклатура = ?(ЗначениеЗаполнено(НужнаяНом), НужнаяНом, Неопределено);
			
			НаименованиеФасадаПриИзменении(Элемент);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДоступностьНастроек();
	
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
	
	ДоступностьНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура НаправляющиеПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	Направляющие = Данные.НаправляющиеНоменклатура;
	
	УстановитьГлубинуЯщика();
	УстановитьШиринуЯщика(Данные);
	
	ДоступностьНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ЕстьРеброПриИзменении(Элемент)
	
	Заглушка = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеФасадаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	НомГруппаМатериал = ПолучитьНоменклатурнуюГруппу(Данные.ФасадНоменклатура);
	
	ПодходящаяНом =  ЛексСервер.ПолучитьСтруктуруПодставляемойНоменклатурыПоЦветуЛДСП(Данные.ФасадНоменклатура, Подразделение);
	ШапкаОсновныхНастроек.Вставить("ПодходящаяНом", ПодходящаяНом);
	
	НужнаяНом = ПолучитьПодставляемуюНоменклатуру("ФасадКромка", НомГруппаМатериал, ПодходящаяНом);
	
	Данные.КромкаФасадНоменклатура = НужнаяНом;
	
	УстановитьРазмерыФасада(Данные);
	ДоступностьНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура КромкаФасадаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	СвойствоКромки = ВернутьЗначениеСвойства("ГлубинаДетали", Данные.КромкаФасадНоменклатура);
	
	Если СвойствоКромки <> Неопределено Тогда
		УстановитьРазмерыФасада(Данные);
	КонецЕсли;
	
	ДоступностьНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРазмерыФасада(Данные)
	
	Если ЗначениеЗаполнено(Данные.ФасадНоменклатура) Тогда
		НоменклатурнаяГруппа = ПолучитьНоменклатурнуюГруппу(Данные.ФасадНоменклатура);
	КонецЕсли;
	
	РассчитатьФасад = Истина;
	
	Если ЗначениеЗаполнено(Данные.НомерИзделия) И ЗначениеЗаполнено(Данные.ШиринаФасад) И ЗначениеЗаполнено(Данные.ВысотаФасад) Тогда
		
		Ответ = Вопрос("Размеры фасада рассчитанные по каталогу могут быть изменены, оставить текущие размеры?", РежимДиалогаВопрос.ДаНет,,);
		РассчитатьФасад = Ответ = КодВозвратаДиалога.Нет;
		
	КонецЕсли;
	
	Если РассчитатьФасад Тогда
		Если ЗначениеЗаполнено(Данные.ВысотаЯщика) И ЗначениеЗаполнено(Данные.ПроемЯщика) И Данные.ВидФасада <> "Нет" Тогда
			
			UID = Новый УникальныйИдентификатор;
			Данные.uid = UID;
			
			Данные.ВысотаФасад = ПолучитьЗначениеФормулы(ДанныеСхемы.ВысотаФасада, UID);
			Данные.ШиринаФасад = ПолучитьЗначениеФормулы(ДанныеСхемы.ШиринаФасада, UID);
			
		Иначе
			
			Данные.ШиринаФасад = 0;
			Данные.ВысотаФасад = 0;
			
		КонецЕсли;
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
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПодбора(НомГруппы, ЭлементФормы)
	
	Пар = Новый Структура();
	Пар.Вставить("НомГруппы", НомГруппы);
	Пар.Вставить("Подразделение", Подразделение);
	Пар.Вставить("Офис",Офис);
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		Пар.Вставить("Контрагент", Контрагент);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", Пар, ЭлементФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура РучкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомГруппы = ПолучитьНомГруппы("Ручка");
	
	ОткрытьФормуПодбора(НомГруппы, Элементы.Ручка);
	
КонецПроцедуры

&НаКлиенте
Процедура КромкаФасадаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НоменклатураФасада = Элементы.Детали.ТекущиеДанные.ФасадНоменклатура;
	
	Если ЗначениеЗаполнено(НоменклатураФасада) Тогда
	
		НомГруппы = ПолучитьНомГруппы("ФасадКромка", ПолучитьНоменклатурнуюГруппу(НоменклатураФасада)); 
		Если НомГруппы.Количество() > 0 Тогда
			ОткрытьФормуПодбора(НомГруппы, Элементы.КромкаФасада);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДноНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомГруппы = ПолучитьНомГруппы("Дно");
	
	ОткрытьФормуПодбора(НомГруппы, Элементы.Дно);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеФасадаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомГруппы = ПолучитьНомГруппы("ФасадМатериал");
	
	ОткрытьФормуПодбора(НомГруппы, Элементы.НаименованиеФасада);
	
КонецПроцедуры

&НаКлиенте
Процедура НаправляющиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомГруппы = ПолучитьНомГруппы("Направляющие");
	
	ОткрытьФормуПодбора(НомГруппы, Элементы.Направляющие);
	
КонецПроцедуры

&НаКлиенте
Процедура КромкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НоменклатураМатериала = Элементы.Детали.ТекущиеДанные.Номенклатура;
	
	Если ЗначениеЗаполнено(НоменклатураМатериала) Тогда
	
		НомГруппы = ПолучитьНомГруппы("ЯщикКромка", ПолучитьНоменклатурнуюГруппу(НоменклатураМатериала)); 
		ОткрытьФормуПодбора(НомГруппы, Элементы.Кромка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомГруппы = ПолучитьНомГруппы("ЯщикМатериал");
	
	ОткрытьФормуПодбора(НомГруппы, Элементы.Наименование);
	
КонецПроцедуры

&НаКлиенте
Процедура СхемаЯщикаПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	ОчиститьТекущиеДанные(Данные);
	
	Схема = Данные.СхемаЯщика;
	ДанныеСхемы = ПолучитьДанныеСхемы(Схема);
	
	ПодставитьДанныеИзШапкиОсновныхНастроек(Данные);
	
	ДоступностьНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступностьВсеЭлементы(Статус)
	
	Элементы.Наименование.Доступность=Статус;
	Элементы.Кромка.Доступность=Статус;
	Элементы.Направляющие.Доступность=Статус;
	Элементы.ПроемЯщика.Доступность=Статус;
	Элементы.ВысотаЯщика.Доступность=Статус;
	Элементы.ГлубинаЯщика.Доступность=Статус;
	Элементы.КоличествоЯщиков.Доступность=Статус;
	Элементы.ВидФасада.Доступность=Статус;
	Элементы.НаименованиеФасада.Доступность=Статус;
	Элементы.КромкаФасада.Доступность=Статус;
	Элементы.ШиринаФасада.Доступность=Статус;
	Элементы.ВысотаФасада.Доступность=Статус;
	Элементы.КоличествоРучек.Доступность=Статус;
	Элементы.Ручка.Доступность=Статус;
	Элементы.ЕстьРебро.Доступность=Статус;
	Элементы.Дно.Доступность=Статус;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеСхемы(Схема)
	
	Стр = Новый Структура;
	
	Стр.Вставить("ГлубинаЯщика", Схема.ГлубинаЯщика);
	Стр.Вставить("ШиринаФасада", Схема.ШиринаФасада);
	Стр.Вставить("ВысотаФасада", Схема.ВысотаФасада);
	Стр.Вставить("ПоказыватьШирину", Схема.ПоказыватьШирину);
	Стр.Вставить("Схема", Схема);
	Стр.Вставить("МинПроем", Схема.МинимальныйПроем);
	Стр.Вставить("МинВысота", Схема.МинимальнаяВысота);
	Стр.Вставить("ШиринаЯщика", Схема.ШиринаЯщика);
	
	Стр.Вставить("ПолеДно", Схема.АктивностьПоляДно);
	Стр.Вставить("ПолеРебро", Схема.АктивностьПоляРебро);
	Стр.Вставить("ПолеБезНаправляющих", Схема.АктивностьПоляБезНаправляющих);
	
	Стр.Вставить("ФасадОбязательно", Схема.ФасадОбязательно);
	Стр.Вставить("КриволинейныйВыпилПодРучку", Схема.КриволинейныйВыпилПодРучку);
	Стр.Вставить("РучкаЩель", Схема.РучкаЩель);
	
	НомГруппы = Новый СписокЗначений;
	
	Для Каждого Эл Из Схема.НоменклатурныеГруппы Цикл
		
		Стр2 = Новый Структура;
		Стр2.Вставить("ПолеВыбора", Эл.ПолеВыбора);
		Стр2.Вставить("Группа", Эл.Группа);
		Стр2.Вставить("Материал", Эл.Материал);
		Стр2.Вставить("ИмяГруппы", Справочники.НоменклатурныеГруппы.ПолучитьИмяПредопределенного(Эл.Группа));
		
		НомГруппы.Добавить(Стр2);
		
	КонецЦикла;
	
	Стр.Вставить("НомГруппы", НомГруппы);
	
	Возврат Стр;
	
КонецФункции

&НаКлиенте
Функция ПолучитьНомГруппы(ПолеВыбора, МатериалНомГруппа = Неопределено, ПолучитьИмя = Ложь)
	
	НомГруппы = Новый СписокЗначений;
	
	Для Каждого Эл Из ДанныеСхемы.НомГруппы Цикл
		
		Подходит = Ложь;
		
		Если ЗначениеЗаполнено(МатериалНомГруппа) Тогда
			Если Эл.Значение.ПолеВыбора = ПолеВыбора И Эл.Значение.Материал = МатериалНомГруппа Тогда
				
				Подходит = Истина;
	
			КонецЕсли;
		Иначе
			Если Эл.Значение.ПолеВыбора = ПолеВыбора Тогда
				
				Подходит = Истина;
					
			КонецЕсли;
		КонецЕсли;
		
		Если Подходит Тогда
			
			Если ПолучитьИмя Тогда
				НомГруппы.Добавить(Эл.Значение.ИмяГруппы);
			Иначе
				НомГруппы.Добавить(Эл.Значение.Группа);
			КонецЕсли;
	
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НомГруппы;
	
КонецФункции

&НаКлиенте
Процедура УстановитьГлубинуЯщика()
	
	Данные = Элементы.Детали.ТекущиеДанные;

	Если Данные.ПроемЯщика > 0 И Данные.ВысотаЯщика > 0 Тогда
		
		UID = Новый УникальныйИдентификатор;
		Данные.uid = UID;
		
		Данные.ГлубинаЯщика = ПолучитьЗначениеФормулы(ДанныеСхемы.ГлубинаЯщика, UID);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЗначениеФормулы(Формула, UID)
	
	Перем Значение;
	
	Данные = Детали.НайтиСтроки(Новый Структура("uid", UID))[0];
	
	Выполнить("Значение =" + ЛексКлиентСервер.ПодставитьОбъектВФормулуЯщика("Данные", Формула));
	
	Возврат Значение;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьШапкуОсновныхНастроек(Данные)
	
	Если (ЗначениеЗаполнено(Данные.СхемаЯщика)) И (НЕ ЗначениеЗаполнено(ШапкаОсновныхНастроек.СхемаЯщика)) Тогда
		ШапкаОсновныхНастроек.СхемаЯщика = Данные.СхемаЯщика;
	КонецЕсли;
	
	Если (ЗначениеЗаполнено(Данные.Номенклатура)) И (НЕ ЗначениеЗаполнено(ШапкаОсновныхНастроек.Номенклатура)) Тогда
		ШапкаОсновныхНастроек.Номенклатура = Данные.Номенклатура;
	КонецЕсли;
	
	Если (ЗначениеЗаполнено(Данные.КромкаНоменклатура)) И (НЕ ЗначениеЗаполнено(ШапкаОсновныхНастроек.КромкаНоменклатура)) Тогда
		ШапкаОсновныхНастроек.КромкаНоменклатура = Данные.КромкаНоменклатура;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодставитьДанныеИзШапкиОсновныхНастроек(Данные)
	
	Если (НЕ ЗначениеЗаполнено(Данные.Номенклатура)) И ЗначениеЗаполнено(ШапкаОсновныхНастроек.Номенклатура) Тогда
		
		Данные.Номенклатура = ШапкаОсновныхНастроек.Номенклатура;
		
	КонецЕсли;
	
	Если (НЕ ЗначениеЗаполнено(Данные.КромкаНоменклатура)) И ЗначениеЗаполнено(ШапкаОсновныхНастроек.КромкаНоменклатура) Тогда
		Данные.КромкаНоменклатура = ШапкаОсновныхНастроек.КромкаНоменклатура;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЯщиковПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	Если Данные.КоличествоЯщиков = 0 Тогда
		Данные.КоличествоЯщиков = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТекущиеДанные(Данные)
	
	Данные.НаправляющиеНоменклатура = Неопределено;
	Данные.БезНаправляющих = Ложь;
	Данные.ПроемЯщика = 0;
	Данные.ВысотаЯщика = 0;
	Данные.ГлубинаЯщика = 0;
	Данные.ВидФасада = "Внутр";
	Данные.ШиринаФасад = 0;
	Данные.ВысотаФасад = 0;
	Данные.ФасадНоменклатура = Неопределено;
	Данные.КромкаФасадНоменклатура = Неопределено;
	Данные.РучкаНоменклатура = Неопределено;
	Данные.КоличествоРучек = 1;
	Данные.ЕстьРебро = Ложь;
	Данные.ДноНоменклатура = Неопределено;
	Данные.КоличествоЯщиков = 1;
	Данные.КриволинейныйВыпилПодРучку = Ложь;
	Данные.РучкаЩель = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеталиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ДоступностьНастроек();
КонецПроцедуры

&НаКлиенте
Процедура СхемаЯщикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Отбор = Новый Структура("Активность, Подразделение", Истина, Подразделение);
	ПараметрыФормы = Новый Структура("Отбор",Отбор);
	
	ОткрытьФорму("Справочник.СхемыЯщиков.ФормаВыбора",ПараметрыФормы,Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеталиКриволинейныйВыпилПодРучкуПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	Данные.КоличествоРучек = 0;
	Данные.РучкаНоменклатура = Неопределено;
	
	ДоступностьНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаменитьНоменклатуру(Команда)
	
	ВладелецПодобра = Элементы.Детали;
	СписокНоменклатуры = Новый Массив;
	
	Для каждого Строка ИЗ Детали Цикл
		
		МассивНоменклатур = Новый Массив;
		МассивНоменклатур.Добавить(Строка.Номенклатура);
		МассивНоменклатур.Добавить(Строка.КромкаНоменклатура);
		МассивНоменклатур.Добавить(Строка.НаправляющиеНоменклатура);
		МассивНоменклатур.Добавить(Строка.ФасадНоменклатура);
		МассивНоменклатур.Добавить(Строка.КромкаФасадНоменклатура);
		МассивНоменклатур.Добавить(Строка.РучкаНоменклатура);
		МассивНоменклатур.Добавить(Строка.ДноНоменклатура);
		
		Для Каждого ЭлементМассива ИЗ МассивНоменклатур Цикл
			
			ПроверитьНаличие = СписокНоменклатуры.Найти(ЭлементМассива);
			
			Если ПроверитьНаличие = Неопределено И ЗначениеЗаполнено(ЭлементМассива) Тогда
				
				СписокНоменклатуры.Добавить(ЭлементМассива);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ПараметрыПодбора = Новый Структура;
	
	ПараметрыПодбора.Вставить("СписокНоменклатуры", СписокНоменклатуры);
	ПараметрыПодбора.Вставить("Подразделение", Подразделение);
	ПараметрыПодбора.Вставить("Офис",Офис);
	ПараметрыПодбора.Вставить("Контрагент", Контрагент);
	
	ОткрытьФорму("Документ.Спецификация.Форма.ФормаСменыНоменклатуры", ПараметрыПодбора, ВладелецПодобра);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеталиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		СтараяНоменклатура = ВыбранноеЗначение.Стараяноменклатура;
		НоваяНоменклатура = ВыбранноеЗначение.НоваяНоменклатура;
		Счетчик= 0;
		
		ПроверяемыеПоля = Новый Массив();
		ПроверяемыеПоля.Добавить("Номенклатура");
		ПроверяемыеПоля.Добавить("КромкаНоменклатура");
		ПроверяемыеПоля.Добавить("НаправляющиеНоменклатура");
		ПроверяемыеПоля.Добавить("ФасадНоменклатура");
		ПроверяемыеПоля.Добавить("КромкаФасадНоменклатура");
		ПроверяемыеПоля.Добавить("РучкаНоменклатура");
		ПроверяемыеПоля.Добавить("ДноНоменклатура");
		
		Для Каждого Строка ИЗ Детали Цикл
		
			Для Каждого Поле ИЗ ПроверяемыеПоля Цикл
				
				Если Строка[Поле] = СтараяНоменклатура Тогда
					Строка[Поле] = НоваяНоменклатура;
					Счетчик = Счетчик +1;
				КонецЕсли;
	
			КонецЦикла;
						
		КонецЦикла;
		
		Сообщить("Изменено " + Счетчик + " значений.", СтатусСообщения.Важное);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РучкаЩельПриИзменении(Элемент)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	Данные.КоличествоРучек = 0;
	Данные.РучкаНоменклатура = Неопределено;
	
	ДоступностьНастроек();
	
КонецПроцедуры
