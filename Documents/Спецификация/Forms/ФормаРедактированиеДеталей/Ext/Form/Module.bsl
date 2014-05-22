﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиенте
Процедура ОтправитьВФлэш(ОтветОтФлэш)
	
	Клик = Ложь;
	Элемент = Элементы.Флэш.Документ.getElementById("back");
	Если Элемент <> Неопределено Тогда
		Элемент.tag = ОтветОтФлэш;
		Элемент.click();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтрокуОтФлэш()
	
	Результат = Новый Структура;
	
	ПолученоОтФлэш = Элементы.Флэш.Документ.getElementById("forw").tag;
	Результат.Вставить("Команда" ,Лев(ПолученоОтФлэш, 4));
	Результат.Вставить("ПолученоОтФлэш", Прав(ПолученоОтФлэш, СтрДлина(ПолученоОтФлэш)-5));
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьСтрокуКантов(ВидМебельнойКромки)
	
	СписокНоменклатурныхГрупп 	= Новый СписокЗначений;
	Строка 									= "";
	Справочник 							= Справочники.НоменклатурныеГруппы;
	
	Если ВидМебельнойКромки = "Кромка2мм" Тогда
		
		СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кромка2_19);
		СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кромка2_35);
		
	ИначеЕсли ВидМебельнойКромки = "Кромка2*19мм" Тогда
		
		СписокНоменклатурныхГрупп.Добавить(Справочник.Кромка2_19);
		
	ИначеЕсли ВидМебельнойКромки = "Кромка045мм" Тогда
		
		СписокНоменклатурныхГрупп.Добавить(Справочник.Кромка045_19);
		
	ИначеЕсли ВидМебельнойКромки = "Т-образный кант" Тогда
		
		СписокНоменклатурныхГрупп.Добавить(Справочник.КантТ);
		
	ИначеЕсли ВидМебельнойКромки = "Кромка для столешниц" Тогда
		
		СписокНоменклатурныхГрупп.Добавить(Справочник.Кромка2_45);
		СписокНоменклатурныхГрупп.Добавить(Справочник.Кромка2_42);
		
	ИначеЕсли ВидМебельнойКромки = "Кромка МДФ" Тогда
		
		СписокНоменклатурныхГрупп.Добавить(Справочник.КромкаМДФ);
		
	КонецЕсли;
	
	МассивыНоменклатурныхГрупп = ЛексСервер.ОтборНоменклатурныхГрупп(СписокНоменклатурныхГрупп, Подразделение);
	
	Для каждого Массив Из МассивыНоменклатурныхГрупп Цикл
	
		Для каждого Элемент Из Массив.Значение Цикл
		
			Строка = Строка + Элемент.КраткоеНаименование + "@" + Элемент.Наименование + "_" + Элемент.Код + "|";
		
		КонецЦикла;
	
	КонецЦикла;
	
	Строка = Лев(Строка,СтрДлина(Строка)-1);
	
	Возврат Строка;
	
КонецФункции

&НаСервере
Функция ПолучитьНазванияГравировок(Родитель)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Родитель.Наименование = &Родитель";
	
	Строка = "";
	Запрос.Параметры.Вставить("Родитель", Родитель);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Строка = Строка + Выборка.Ссылка.Наименование + "@" + Выборка.Ссылка.Код + ".jpg" + "|";
		
	КонецЦикла;
	
	Строка = Лев(Строка,СтрДлина(Строка)-1);
	
	Возврат Строка;
	
КонецФункции // ПолучитьНазванияГравировок()

&НаСервере
Функция ПолучитьНазванияПапокГравировок()
	
	Строка 			= "";
	Запрос 			= Новый Запрос;
	Запрос.Текст 	= 
	"ВЫБРАТЬ
	|	Номенклатура.Родитель.Наименование КАК Родитель
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.НоменклатурнаяГруппа = ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.Гравировка)
	|
	|СГРУППИРОВАТЬ ПО
	|	Номенклатура.Родитель.Наименование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Родитель";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Строка = Строка + Выборка.Родитель + "|";
		
	КонецЦикла;
	
	Строка = Лев(Строка,СтрДлина(Строка)-1);
	
	Возврат Строка;
	
КонецФункции // ПолучитьНазванияПапокГравировок()

&НаКлиенте
Функция ПолучитьСтрокуШаблонов(Строка)
	
	СтрокаШаблонов 	= "";
	НомСтр 					= Лев(Строка,СтрДлина(Строка)-1);
	
	Для Каждого Деталь Из СписокДеталей Цикл
		
		Если ЗначениеЗаполнено(Деталь.СтрокаДляФлэш) Тогда
			
			Если Деталь.ПолучитьИдентификатор() = Число(НомСтр) Тогда 
				
					СтрокаШаблонов = Деталь.СтрокаДляФлэш;
					
			КонецЕсли;
			
		КонецЕсли;
			
	КонецЦикла;
	
	Возврат СтрокаШаблонов;
	
КонецФункции

&НаКлиенте
Функция ВернутьСписокДеталей()
	
	СтрокаДеталей = "";
	
	Для каждого Деталь Из СписокДеталей Цикл
		
		Если ЗначениеЗаполнено(Деталь.СтрокаДляФлэш) Тогда
			
			СтрокаДеталей = СтрокаДеталей + Строка(Деталь.ПолучитьИдентификатор()) + "L_" + Деталь.ШиринаДетали + " x " + Деталь.ВысотаДетали + "|";
			
		КонецЕсли;
		
	КонецЦикла;
	
	// удаление последнего символа
	СтрокаДеталей = Лев(СтрокаДеталей, СтрДлина(СтрокаДеталей)-1);
	
	Возврат СтрокаДеталей;
	
КонецФункции

&НаКлиенте
Процедура ПредупредитьНаКлиенте() 
	Строка = Новый ФорматированнаяСтрока("Обновите справочник файлов!",,,,"e1cib/command/ОбщаяКоманда.СинхронизацияФайлов");
	Предупреждение(Строка);	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтаФорма.Модифицированность = Истина;
	
	//Попытка
	//	Элементы.Флэш.Документ.url = "file://" + ЛексКлиент.ПолучитьПутьHTML(ХранимыйФайлРедактор, ХранимыйФайлРедакторHTML) +"?str="+СтрокаДляФлэш; 	
	//Исключение                       
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	//	Отказ = Истина;
	//КонецПопытки;
	
	url = ЛексКлиент.ПутьHTML(ИмяHTML);

	Если url <> "" Тогда
		Попытка
			Элементы.Флэш.Документ.url = url;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Отказ = Истина;
		КонецПопытки;
	Иначе
		ПредупредитьНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если Параметры.Свойство("АдресТаблицы") И ЭтоАдресВременногоХранилища(Параметры.АдресТаблицы) Тогда
		СписокДеталей.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицы));
	КонецЕсли;
	
	ЗакрыватьПриВыборе = Ложь;
	
	СтрокаДляФлэш 	= Параметры.СтрокаДляРедактирования;
	Подразделение 	= Параметры.Подразделение;
	Материал 			= Параметры.Материал;
	//СписокДеталей.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицы));
	//ХранимыйФайлРедактор = Справочники.ХранимыеФайлы.Редактор;
	//ХранимыйФайлРедакторHTML = Справочники.ХранимыеФайлы.РедакторHTML;
	ИмяHTML = ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.РедакторHtml);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	//ОтФлэшСтруктура 	= ПолучитьСтрокуОтФлэш();
	//ПолученоОтФлэш 	= ОтФлэшСтруктура.ПолученоОтФлэш;
	//
	//Если Модифицированность Тогда
		
		Режим 	= РежимДиалогаВопрос.ДаНетОтмена;
		Текст 	= "Сохранить изменения?";
		Ответ 	= Вопрос(Текст, Режим, 0);
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			ОтправитьВФлэш("save");
			ОтФлэшСтруктура 	= ПолучитьСтрокуОтФлэш();
			ПолученоОтФлэш 	= ОтФлэшСтруктура.ПолученоОтФлэш;
			
			Если ПолученоОтФлэш = "error☻" Тогда
				
				Режим 	= РежимДиалогаВопрос.ОКОтмена;
				Текст 	= "Изменения не могут быть сохранены. Закрыть форму?";
				Ответ 	= Вопрос(Текст, Режим, 0);
				
				Если Ответ = КодВозвратаДиалога.Отмена Тогда
					
					Отказ = Истина;
					
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
			
			Модиицированность 		= Ложь;
			СтандартнаяОбработка 	= Ложь;
			
		ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
			
			Отказ = Истина;
			
		КонецЕсли;
		
	//КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ СВОЙСТВ И КАТЕГОРИЙ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура ФлэшПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	
	ОтФлэшСтруктура 	= ПолучитьСтрокуОтФлэш();
	Команда 				= ОтФлэшСтруктура.Команда;
	ПолученоОтФлэш 	= ОтФлэшСтруктура.ПолученоОтФлэш;
	ЛДСП						= Материал = "10 ЛДСП" Или Материал = "16 ЛДСП" Или Материал = "10 ЛДСП+10 ЛДСП" Или  Материал = "16 ЛДСП+10 ЛДСП" 
		Или Материал = "16 ЛДСП+16 ЛДСП";
	Стекло 					= Материал = "Стекло" или Материал = "ФасадСтеклянный" ИЛИ Материал = "ФасадСтеклянныйЗакругленный";
	
	Если Команда = "kant" Тогда
		
		Если ЛДСП или Материал = "ФасадЛДСП" Тогда
			
			ОтправитьВФлэш("kant☻Кромка2мм|Кромка045мм|Т-образный кант|Кромка МДФ");
			
		ИначеЕсли Материал = "МДФ" или Материал = "ФасадМДФ" Тогда
			
			ОтправитьВФлэш("kant☻Кромка МДФ");
			
		ИначеЕсли Материал = "Столешница" Тогда
			
			ОтправитьВФлэш("kant☻Кромка для столешниц");
			
		ИначеЕсли Материал = "Пристенок" Тогда
			
			ОтправитьВФлэш("kant☻Кромка2*19мм|Кромка045мм");
			
		КонецЕсли;
			
	ИначеЕсли Команда = "knam" Тогда
		
		Если ПолученоОтФлэш = "Кромка2мм" Тогда
			
			ОтправитьВФлэш("knam☻"+ПолучитьСтрокуКантов("Кромка2мм"));
			
		ИначеЕсли ПолученоОтФлэш = "Кромка2*19мм" Тогда
			
			ОтправитьВФлэш("knam☻"+ПолучитьСтрокуКантов("Кромка2*19мм"));
			
		ИначеЕсли ПолученоОтФлэш = "Кромка045мм" Тогда
			
			ОтправитьВФлэш("knam☻"+ПолучитьСтрокуКантов("Кромка045мм"));
			
		//ИначеЕсли ПолученоОтФлэш = "Кромка045*19мм" Тогда
		//	
		//	ОтправитьВФлэш("knam☻"+ПолучитьСтрокуКантов("Кромка045*19мм"));
			
		ИначеЕсли ПолученоОтФлэш = "Т-образный кант" Тогда
			
			ОтправитьВФлэш("knam☻"+ПолучитьСтрокуКантов("Т-образный кант"));
			
		ИначеЕсли ПолученоОтФлэш = "Кромка для столешниц" Тогда
			
			ОтправитьВФлэш("knam☻"+ПолучитьСтрокуКантов("Кромка для столешниц"));
			
		ИначеЕсли ПолученоОтФлэш = "Кромка МДФ" Тогда
			
			ОтправитьВФлэш("knam☻"+ПолучитьСтрокуКантов("Кромка МДФ"));
			
		КонецЕсли;
		
	ИначеЕсли Команда = "load" Тогда
		
		ОтправитьВФлэш("load☻"+СтрокаДляФлэш);
			
	ИначеЕсли Команда = "grav" и Стекло Тогда
		
		НазванияПапок = ПолучитьНазванияПапокГравировок();
		ОтправитьВФлэш("grav☻"+ НазванияПапок);
		
	ИначеЕсли Команда = "gnam" Тогда
			
		ОтправитьВФлэш("gnam☻"+ПолучитьНазванияГравировок(ПолученоОтФлэш));
			
	ИначеЕсли Команда = "list" Тогда
			
		ОтправитьВФлэш("list☻" + ВернутьСписокДеталей());
		
	ИначеЕсли Команда = "getd" Тогда
		
		ОтправитьВФлэш("getd☻" + ПолучитьСтрокуШаблонов(ПолученоОтФлэш));
		
	ИначеЕсли Команда = "save" Тогда
		
		Модифицированность = Ложь;
		ОповеститьОВыборе(ПолученоОтФлэш);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ 

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

