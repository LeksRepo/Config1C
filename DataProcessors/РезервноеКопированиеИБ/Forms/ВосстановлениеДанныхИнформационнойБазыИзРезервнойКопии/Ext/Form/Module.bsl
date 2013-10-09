﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ВызватьИсключение НСтр("ru = 'В клиент-серверном варианте работы резервное копирование следует выполнять сторонними средствами (средствами СУБД).'");
	КонецЕсли;
	
	Элементы.АктивныеПользователи1.Видимость = (ПолучитьСеансыИнформационнойБазы().Количество() > 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ОбработкаЗакрытияФормы() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОтключитьОбработчикОжидания("ИстечениеВремениОжидания");
	ОтключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения");	
	ОтключитьОбработчикОжидания("ЗавершитьРаботуПользователей");

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	АдминистраторИБ = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформацияОПользователе.Имя;
	ИмяФайлаЗапускаПриложенияВРежимеПредприятия = ПолучитьИмяФайлаЗапускаПриложенияВРежимеПредприятия();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПутьККаталогуАрхивов2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОБъект.ФайлЗагрузкиРезервнойКопии = ПолучитьПуть(РежимДиалогаВыбораФайла.Открытие, НСтр("ru = 'Архив резервной копии(*.zip)|*.zip'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьККаталогуАрхивовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбранныйПуть = ПолучитьПуть(РежимДиалогаВыбораФайла.ВыборКаталога);
	Если Не ПустаяСтрока(ВыбранныйПуть) Тогда 
		Объект.КаталогСРезервнымиКопиями = ВыбранныйПуть;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НадписьСписокДействий1Нажатие(Элемент)
	
	ОткрытьФормуМодально("Обработка.АктивныеПользователи.Форма.ФормаСпискаАктивныхПользователей");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПользователейНажатие(Элемент)
	
	ОткрытьФормуМодально("Обработка.АктивныеПользователи.Форма.ФормаСпискаАктивныхПользователей");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроводитьРезервноеКопированиеПриВосстановленииДанныхПриИзменении(Элемент)
	
	Элементы.ГруппаРезервнойКопииПриВосстановлении.Доступность = Объект.ПроводитьРезервноеКопированиеПриВосстановленииДанных;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПерейтиВЖурналРегистрации1Нажатие(Элемент)
	
	ОткрытьФормуМодально("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации");
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.СтраницыЗагрузкиДанных.ТекущаяСтраница = Элементы.СтраницыЗагрузкиДанных.ПодчиненныеЭлементы.СтраницаНастройкиЗагрузки;
	Элементы.Назад.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ОчиститьСообщения();

	ТекстСообщения = "";
	Если Не ПроверитьЗаполнениеРеквизитов(ТекстСообщения) и Не ПустаяСтрока(ТекстСообщения) Тогда 		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если НЕ ПроверитьДоступКИБ()  Тогда
		НоваяСтраницаПомощника = Элементы.СтраницыЗагрузкиДанных.ПодчиненныеЭлементы.ДополнительныеНастройки;
		ПриОткрытииНовойСтраницы(НоваяСтраницаПомощника);
		Возврат;
	КонецЕсли;

	Элементы.СтраницыЗагрузкиДанных.ТекущаяСтраница = Элементы.СтраницыЗагрузкиДанных.ПодчиненныеЭлементы.СтраницаИнформацииИВыполненияРезервногоКопирования; 
	Элементы.Закрыть.Доступность = Истина;
	ОбновитьКоличествоАктивныхПользователей();
	УстановитьЗаголовокКнопкиДалее(Истина);
	Элементы.Готово.Доступность = Ложь;
	
	УстановитьБлокировкуСоединений = Истина;
	Если РезервноеКопированиеИБВызовСервера.ПолучитьКоличествоАктивныхПользователей() = 1 Тогда
		СоединенияИБКлиент.УстановитьПризнакРаботаПользователейЗавершается(УстановитьБлокировкуСоединений);
		ЗавершитьРаботуЭтогоСеанса(Ложь);
		НачатьРезервноеКопирование();
	Иначе
		СоединенияИБКлиент.УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(УстановитьБлокировкуСоединений);
		УстановитьОбработчикОжиданияНачалаРезервногоКопирования();
		УстановитьОбработчикОжиданияИстеченияТаймаутаРезервногоКопирования();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВерсиюКомпоненты(Команда)
	
#Если НЕ ВебКлиент Тогда
	ТекстКоманды = "";
	
	Попытка
		ИмяБатФайла		= ПолучитьИмяВременногоФайла("bat");
		ИмяФайлаЛога	= ПолучитьИмяВременногоФайла("log");
		БатФайл = Новый ЗаписьТекста(ИмяБатФайла);
		ТекстКоманды = "echo off";
		ТекстКоманды = ТекстКоманды + Символы.ПС + """regsvr32.exe"" /s """ + КаталогПрограммы() + "comcntr.dll""";
		ТекстКоманды = ТекстКоманды + Символы.ПС + "echo %errorlevel% >>""" + ИмяФайлаЛога + """";
		БатФайл.ЗаписатьСтроку(ТекстКоманды);
		БатФайл.Закрыть();
		Shell = Новый COMОбъект("WScript.Shell");
		Shell.Run(ИмяБатФайла, 0, Истина); // запуск бат-файла со спрятанным окном (0) и с ожиданием завершения (Истина)
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстСообщения = НСтр("ru = 'Ошибка при регистрации компоненты comcntr.'") + Символы.ПС;
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(), 
			"Ошибка", 
			ТекстСообщения + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ОбщегоНазначенияВызовСервера.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
		Предупреждение(ТекстСообщения + НСтр("ru = 'Подробности см. в Журнале регистрации.'"));
		Возврат;
	КонецПопытки;
	
	СтрокаФайла = "";
	Попытка
		
		УдалитьФайлы(ИмяБатФайла);
		ФайлЛога	= Новый ЧтениеТекста(ИмяФайлаЛога);
		СтрокаФайла	= ФайлЛога.ПрочитатьСтроку();
		ФайлЛога.Закрыть();
		УдалитьФайлы(ИмяФайлаЛога);
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстСообщения = НСтр("ru = 'Ошибка при регистрации компоненты comcntr.'") + Символы.ПС;
		
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(),
			"Ошибка", 
			ТекстСообщения + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
		ОбщегоНазначенияВызовСервера.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
		Предупреждение(ТекстСообщения + НСтр("ru = 'Подробности см. в Журнале регистрации.'"));
		Возврат;
		
	КонецПопытки;
		
	Если СокрЛП(СтрокаФайла) <> "0" Тогда
		ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
		ТекстСообщения = НСтр("ru = 'Ошибка при регистрации компоненты comcntr.'") + Символы.ПС;
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(),
			"Ошибка", 
			Строка(ТекущаяДата) + " " + ТекстСообщения + 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Код ошибки regsvr32: %1.
				| (Код ошибки 5 означает, что недостаточно прав доступа. Выполните командну от имени пользователя с правами администратора на локальной машине.)
			    |
				|Текст команды: 
				|%2'"), СтрокаФайла, ТекстКоманды));
		ОбщегоНазначенияВызовСервера.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
		Предупреждение(ТекстСообщения + НСтр("ru = '
			|Подробности см. в Журнале регистрации.'"));
		Возврат;
		
	КонецЕсли;
	
	Ответ = Вопрос(НСтр("ru = 'Для завершения перерегистрации компоненты comcntr необходимо перезапустить сеанс 1С:Предприятия.
		|Перезапустить сейчас?'"), РежимДиалогаВопрос.ДаНет);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина;
		ЗавершитьРаботуСистемы(Истина, Истина);
	КонецЕсли;
#КонецЕсли

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Функция ПолучитьИмяФайлаЗапускаПриложенияВРежимеПредприятия()
#Если ТонкийКлиент Тогда 
	Возврат "1cv8c.exe";
#Иначе
	Возврат "1cv8.exe";
#КонецЕсли
КонецФункции

// Процедура обработки открытия другой страницы формы восстановления данных.
&НаКлиенте
Процедура ПриОткрытииНовойСтраницы(СтраницаПомощника)
	
	ПодчиненныеСтраницы = Элементы.СтраницыЗагрузкиДанных.ПодчиненныеЭлементы;
	Если СтраницаПомощника = ПодчиненныеСтраницы.ДополнительныеНастройки Тогда
		Элементы.Назад.Видимость = Истина;
	КонецЕсли;	
	Элементы.СтраницыЗагрузкиДанных.ТекущаяСтраница = СтраницаПомощника;
	
КонецПроцедуры

// Устанавливает заговолок кнопки "Далее" в зависимости от текущей страницы помощника
&НаКлиенте
Процедура УстановитьЗаголовокКнопкиДалее(ПараметрЗаголовка)
	
	Если ПараметрЗаголовка Тогда
		Элементы.Готово.Заголовок = НСтр("ru = 'Далее >>'");
	Иначе
		Элементы.Готово.Заголовок = НСтр("ru = 'Готово'");
	КонецЕсли;
	
КонецПроцедуры

// Подключает обработкчик ожидания истечения таймаута перед принудительным стартом резервного копирования/восстановления данных.
&НаКлиенте
Процедура УстановитьОбработчикОжиданияИстеченияТаймаутаРезервногоКопирования()
	
	ПодключитьОбработчикОжидания("ИстечениеВремениОжидания", 300, Истина);
	
КонецПроцедуры

// Подключает обработчик ожидания при отложенном резервном копировании
&НаКлиенте              
Процедура УстановитьОбработчикОжиданияНачалаРезервногоКопирования() 
	
	ПодключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения", 120);
	
КонецПроцедуры

// Процедура обновляет заголовок гиперссылки количества активных пользователей.
&НаКлиенте
Процедура ОбновитьКоличествоАктивныхПользователей()
	
	Элементы.КоличествоАктивныхПользователей.Заголовок = РезервноеКопированиеИБВызовСервера.ПолучитьКоличествоАктивныхПользователей();
	
КонецПроцедуры

// Функция запрашивает у пользователя и возвращает путь к файлу или каталогу.
&НаКлиенте
Функция ПолучитьПуть(РежимДиалога, Фильтр = "")
	
	Режим = РежимДиалога;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	
	Если Не ПустаяСтрока(Фильтр) Тогда
		ДиалогОткрытияФайла.Фильтр = Фильтр;
	КонецЕсли;
		
	Если Режим = РежимДиалогаВыбораФайла.ВыборКаталога Тогда
		ДиалогОткрытияФайла.Заголовок= НСтр("ru = 'Выберите каталог'");
	Иначе
		ДиалогОткрытияФайла.Заголовок= НСтр("ru = 'Выберите файл'");
	КонецЕсли;	
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Если РежимДиалога = РежимДиалогаВыбораФайла.ВыборКаталога тогда
			Возврат ДиалогОткрытияФайла.Каталог;
		Иначе
			Возврат ДиалогОткрытияФайла.ПолноеИмяФайла;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ОбработкаЗакрытияФормы()
	
	ТекущаяСтраница = Элементы.СтраницыЗагрузкиДанных.ТекущаяСтраница;
	Если ТекущаяСтраница = Элементы.СтраницыЗагрузкиДанных.ПодчиненныеЭлементы.СтраницаИнформацииИВыполненияРезервногоКопирования Тогда
		ТекстВопроса		= НСтр("ru = 'Прервать подготовку к восстановлению данных?'");
		ЗаголовокВопроса	= НСтр("ru = 'Отмена резервного копирования.'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет, ЗаголовокВопроса);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	Возврат Истина;
	
КонецФункции

// Проверка заполнения необходимых реквизитов формы.
&НаКлиенте 
Функция ПроверитьЗаполнениеРеквизитов(ТекстСообщения)
	
	Если ПустаяСтрока(Объект.ФайлЗагрузкиРезервнойКопии) Тогда
		ТекстСообщения = НСтр("ru = 'Не выбрана резервная копия для восстановления.'");
		Возврат Ложь;
	КонецЕсли;
	
	Если (Объект.ПроводитьРезервноеКопированиеПриВосстановленииДанных И ПустаяСтрока(Объект.КаталогСРезервнымиКопиями)) Тогда
		ТекстСообщения = НСтр("ru = 'Не выбран каталог для резервной копии.'");	
		Попытка
			ТестовыйФайл = Новый ЗаписьXML;
			ТестовыйФайл.ОткрытьФайл(Объект.КаталогСРезервнымиКопиями + "/test.test1С");
			ТестовыйФайл.ЗаписатьОбъявлениеXML();
			ТестовыйФайл.Закрыть();
		Исключение
			ТекстСообщения = Нстр("ru = 'Нет доступа к каталогу с резервными копиями.'");
		КонецПопытки;
		
		Попытка
			УдалитьФайлы(Объект.КаталогСРезервнымиКопиями, "*.test1С");
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	Если Объект.ПроводитьРезервноеКопированиеПриВосстановленииДанных И НайтиФайлы(Объект.КаталогСРезервнымиКопиями).Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Выбран несуществующий каталог для резервных копий.'");	
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Функция проверяет возможность подключения к информационной базе с текущими параметрами.
&НаКлиенте
Функция ПроверитьДоступКИБ()

	Результат = Истина;
	// В базовых версиях проверку подключения не осуществляем;
	// при некорректном вводе имени и пароля обновление завершится неуспешно.
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
		Возврат Результат;
	КонецЕсли; 
	
	ПараметрыПодключения	= ПолучитьПараметрыАутентификацииАдминистратораОбновления();
	
	
	Попытка
		
		ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель(Ложь);
		ComConnector			= Новый COMОбъект(СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИмяCOMСоединителя);
		СтрокаСоединенияИнформационнойБазы = ПараметрыПодключения.СтрокаСоединенияИнформационнойБазы + ПараметрыПодключения.СтрокаПодключения;
		Соединение = ComConnector.Connect(СтрокаСоединенияИнформационнойБазы);
		
	Исключение
		
		Результат = Ложь;
		Инфо = ИнформацияОбОшибке();
		ОбнаруженнаяОшибкаПодключения = КраткоеПредставлениеОшибки(Инфо);
		
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(),
			"Ошибка", ОбнаруженнаяОшибкаПодключения, , Истина);
		
	КонецПопытки;	
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры обработчиков ожидания

&НаКлиенте                             
Процедура ИстечениеВремениОжидания()
	
	ОтключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения");
	ТекстВопроса		= НСтр("ru = 'Не удалось отключить всех пользователей от базы. Провести резервное копирование? (возможны ошибки при архивации)'");
	ТекстПояснения		= НСтр("ru = 'Не удалось отключить пользователя.'");
    Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет, ТекстПояснения, КодВозвратаДиалога.Нет);
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		НачатьРезервноеКопирование();
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверкаНаЕдинственностьПодключения()
	
	Если РезервноеКопированиеИБВызовСервера.ПолучитьКоличествоАктивныхПользователей() = 1 Тогда
		НачатьРезервноеКопирование();
	КонецЕсли;
	
КонецПроцедуры                 

&НаКлиенте
Процедура НачатьРезервноеКопирование() 
	
	ИмяГлавногоФайлаСкрипта = СформироватьФайлыСкриптаОбновления();
	ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(), 
		"Информация",
		НСтр("ru = 'Выполняется восстановление данных информационной базы:'") + " " + ИмяГлавногоФайлаСкрипта);
	
	ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина;
	ЗавершитьРаботуСистемы(Ложь);
	ЗапуститьПриложение("""" + ИмяГлавногоФайлаСкрипта + """",	РезервноеКопированиеИБКлиент.ПолучитьКаталогФайла(ИмяГлавногоФайлаСкрипта));
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции подготовки восстановления данных

&НаКлиенте
Функция СформироватьФайлыСкриптаОбновления() 
	
	ПараметрыКопирования = РезервноеКопированиеИБКлиент.КлиентскиеПараметрыРезервногоКопирования();
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	СоздатьКаталог(ПараметрыКопирования.КаталогВременныхФайловОбновления);
	
	// Структура параметров необходима для их определения на клиенте и передачи на сервер
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИмяФайлаПрограммы"			, ПараметрыКопирования.ИмяФайлаПрограммы);
	СтруктураПараметров.Вставить("СобытиеЖурналаРегистрации"	, ПараметрыКопирования.СобытиеЖурналаРегистрации);
	СтруктураПараметров.Вставить("ИмяCOMСоединителя"			, ПараметрыРаботыКлиента.ИмяCOMСоединителя);
	СтруктураПараметров.Вставить("ЭтоБазоваяВерсияКонфигурации"	, ПараметрыРаботыКлиента.ЭтоБазоваяВерсияКонфигурации);
	СтруктураПараметров.Вставить("ИнформационнаяБазаФайловая"	, ПараметрыРаботыКлиента.ИнформационнаяБазаФайловая);
	СтруктураПараметров.Вставить("ПараметрыСкрипта"				, ПолучитьПараметрыАутентификацииАдминистратораОбновления());
	
	ИменаМакетов = "ДопФайлРезервногоКопирования";
	ИменаМакетов = ИменаМакетов + ",ЗаставкаВосстановления";
	
	ТекстыМакетов = ПолучитьТекстыМакетов(ИменаМакетов, СтруктураПараметров, СообщенияДляЖурналаРегистрации);
	
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[0]);
	
	ИмяФайлаСкрипта = ПараметрыКопирования.КаталогВременныхФайловОбновления + "main.js";
	ФайлСкрипта.Записать(ИмяФайлаСкрипта, КодировкаТекста.UTF16);
	
	// Вспомогательный файл: helpers.js
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[1]);
	ФайлСкрипта.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "helpers.js", КодировкаТекста.UTF16);
	
	ИмяГлавногоФайлаСкрипта = Неопределено;
	// Вспомогательный файл: splash.png
	БиблиотекаКартинок.ЗаставкаВнешнейОперации.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "splash.png");
	// Вспомогательный файл: splash.ico
	БиблиотекаКартинок.ЗначокЗаставкиВнешнейОперации.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "splash.ico");
	// Вспомогательный файл: progress.gif
	БиблиотекаКартинок.ДлительнаяОперация48.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "progress.gif");
	// Главный файл заставки: splash.hta
	ИмяГлавногоФайлаСкрипта = ПараметрыКопирования.КаталогВременныхФайловОбновления + "splash.hta";
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[2]);
	ФайлСкрипта.Записать(ИмяГлавногоФайлаСкрипта, КодировкаТекста.UTF16);
	
	Возврат ИмяГлавногоФайлаСкрипта;
	
КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыАутентификацииАдминистратораОбновления() 
	
	Результат = Новый Структура("ИмяПользователя,
	|ПарольПользователя,
	|СтрокаПодключения,
	|ПараметрыАутентификации,
	|СтрокаСоединенияИнформационнойБазы",
	Неопределено, "", "", "", "", "");
	
	ТекущиеСоединения = ПолучитьСтрокуСоединенияИИнформациюОСоединениях(СообщенияДляЖурналаРегистрации);
	Результат.СтрокаСоединенияИнформационнойБазы = ТекущиеСоединения.СтрокаСоединенияИнформационнойБазы;
	// Диагностика случая, когда ролевой безопасности в системе не предусмотрено.
	// Т.е. ситуация, когда любой пользователь «может» в системе все.
	Если НЕ ТекущиеСоединения.ЕстьАктивныеПользователи Тогда
		Возврат Результат;
	КонецЕсли;
	
	Пользователь = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформацияОПользователе.Имя;
	
	Результат.ИмяПользователя			= Пользователь;
	Результат.ПарольПользователя		= ПарольАдминистратораИБ;
	Результат.СтрокаПодключения			= "Usr=""" + Пользователь + """;Pwd=""" + ПарольАдминистратораИБ + """;";
	Результат.ПараметрыАутентификации	= "/N""" + Пользователь + """ /P""" + ПарольАдминистратораИБ + """ /WA-";
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьТекстыМакетов(ИменаМакетов, СтруктураПараметров, СообщенияДляЖурналаРегистрации)
	
	// запись накопленных событий ЖР
	
	ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	Результат = Новый Массив();
	Результат.Добавить(ПолучитьТекстСкрипта(СтруктураПараметров));
	
	ИменаМакетовМассив = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаМакетов);
	Для каждого ИмяМакета ИЗ ИменаМакетовМассив Цикл
		Результат.Добавить(Обработки.РезервноеКопированиеИБ.ПолучитьМакет(ИмяМакета).ПолучитьТекст());
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьТекстСкрипта(СтруктураПараметров)
	
	// Файл обновления конфигурации: main.js
	ШаблонСкрипта = Обработки.РезервноеКопированиеИБ.ПолучитьМакет("МакетФайлаЗагрузкаИБ");
	
	Скрипт = ШаблонСкрипта.ПолучитьОбласть("ОбластьПараметров");
	Скрипт.УдалитьСтроку(1);
	Скрипт.УдалитьСтроку(Скрипт.КоличествоСтрок());
	
	Текст = ШаблонСкрипта.ПолучитьОбласть("ОбластьРезервногоКопирования");
	Текст.УдалитьСтроку(1);
	Текст.УдалитьСтроку(Текст.КоличествоСтрок());
	
	Возврат ВставитьПараметрыСкрипта(Скрипт.ПолучитьТекст(), СтруктураПараметров) + Текст.ПолучитьТекст();
	
КонецФункции

&НаСервере
Функция ВставитьПараметрыСкрипта(Знач Текст, Знач СтруктураПараметров)
	
	Результат = Текст;
	
	ИменаФайловОбновления = "";
	ИменаФайловОбновления = "[" + "" + "]";
	
	СтрокаСоединенияИнформационнойБазы = СтруктураПараметров.ПараметрыСкрипта.СтрокаСоединенияИнформационнойБазы +
	СтруктураПараметров.ПараметрыСкрипта.СтрокаПодключения; 
	
	ИмяИсполняемогоФайлаПрограммы = КаталогПрограммы() + СтруктураПараметров.ИмяФайлаПрограммы;
	ИмяФайлаЗапускаПриложенияВРежимеПредприятия = КаталогПрограммы() + ИмяФайлаЗапускаПриложенияВРежимеПредприятия;
	
	// Определение пути к информационной базе.
	ПризнакФайловогоРежима = Неопределено;
	ПутьКИнформационнойБазе = СоединенияИБКлиентСервер.ПутьКИнформационнойБазе(ПризнакФайловогоРежима, 0);
	
	ПараметрПутиКИнформационнойБазе = ?(ПризнакФайловогоРежима, "/F", "/S") + ПутьКИнформационнойБазе; 
	СтрокаПутиКИнформационнойБазе	= ?(ПризнакФайловогоРежима, ПутьКИнформационнойБазе, "");
	
	Результат = СтрЗаменить(Результат, "[ИменаФайловОбновления]"				, ИменаФайловОбновления);
	Результат = СтрЗаменить(Результат, "[ИмяИсполняемогоФайлаПрограммы]"		, ПодготовитьТекст(ИмяИсполняемогоФайлаПрограммы));
	Результат = СтрЗаменить(Результат, "[ИмяФайлаЗапускаПриложенияВРежимеПредприятия]", ПодготовитьТекст(ИмяФайлаЗапускаПриложенияВРежимеПредприятия));
	Результат = СтрЗаменить(Результат, "[ПараметрПутиКИнформационнойБазе]"		, ПодготовитьТекст(ПараметрПутиКИнформационнойБазе));
	Результат = СтрЗаменить(Результат, "[СтрокаПутиКФайлуИнформационнойБазы]"	, ПодготовитьТекст(ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(СтрЗаменить(СтрокаПутиКИнформационнойБазе, """", "")))); 
	Результат = СтрЗаменить(Результат, "[СтрокаПутиКФайлуИнформационнойБазы2]"	, ПодготовитьТекст("1Cv8.1CD"));
	Результат = СтрЗаменить(Результат, "[СтрокаСоединенияИнформационнойБазы]"	, ПодготовитьТекст(СтрокаСоединенияИнформационнойБазы));
	Результат = СтрЗаменить(Результат, "[ПараметрыАутентификацииПользователя]"	, ПодготовитьТекст(СтруктураПараметров.ПараметрыСкрипта.ПараметрыАутентификации));
	Результат = СтрЗаменить(Результат, "[СобытиеЖурналаРегистрации]"			, ПодготовитьТекст(СтруктураПараметров.СобытиеЖурналаРегистрации));
	Результат = СтрЗаменить(Результат, "[АдресЭлектроннойПочты]", 
	"");
	Результат = СтрЗаменить(Результат, "[ИмяАдминистратораОбновления]"			, ПодготовитьТекст(ИмяПользователя()));
	Результат = СтрЗаменить(Результат, "[СоздаватьРезервнуюКопию]"				,"true");
	
	Результат = СтрЗаменить(Результат, "[КаталогРезервнойКопии]",ПодготовитьТекст(Объект.ФайлЗагрузкиРезервнойКопии));				 
	СтрокаКаталога = ПроверитьКаталогНаУказаниеКорневогоЭлемента(Объект.КаталогСРезервнымиКопиями);
	
	Результат = СтрЗаменить(Результат, "[КаталогРезервнойКопии2]"				,ПодготовитьТекст(СтрокаКаталога+"\backup"+СтрокаКаталогаИзДаты()));				 
	Результат = СтрЗаменить(Результат, "[ПроводитьДопРезервноеКопирование]",?(Объект.ПроводитьРезервноеКопированиеПриВосстановленииДанных,"true","false"));
	Результат = СтрЗаменить(Результат, "[ВосстанавливатьИнформационнуюБазу]"	, "false");
	Результат = СтрЗаменить(Результат, "[БлокироватьСоединенияИБ]"				, ?(СтруктураПараметров.ИнформационнаяБазаФайловая, "false", "true"));
	Результат = СтрЗаменить(Результат, "[ИмяCOMСоединителя]"					, ПодготовитьТекст(СтруктураПараметров.ИмяCOMСоединителя));
	Результат = СтрЗаменить(Результат, "[ИспользоватьCOMСоединитель]"			, ?(СтруктураПараметров.ЭтоБазоваяВерсияКонфигурации, "false", "true"));
	Результат = СтрЗаменить(Результат, "[КаталогВременныхФайлов]"				, ПодготовитьТекст(КаталогВременныхФайлов()));
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПроверитьКаталогНаУказаниеКорневогоЭлемента(СтрокаКаталога)
	
	Если Прав(СтрокаКаталога, 2) = ":\" Тогда
		Возврат Лев(СтрокаКаталога, СтрДлина(СтрокаКаталога) - 1) ;
	Иначе
		Возврат СтрокаКаталога;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция СтрокаКаталогаИзДаты()
	
	СтрокаВозврата = "";
	ДатаСейчас = ТекущаяДатаСеанса();
	СтрокаВозврата = Формат(ДатаСейчас, "ДФ = гггг_ММ_дд_ЧЧ_мм_сс");
	Возврат СтрокаВозврата;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПодготовитьТекст(Знач Текст)
	
	Возврат "'" + СтрЗаменить(Текст, "\", "\\") + "'";
	
КонецФункции

&НаСервере
Функция ПолучитьСтрокуСоединенияИИнформациюОСоединениях(СообщенияДляЖурналаРегистрации)
	
	// запись накопленных событий ЖР
	ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	Результат = ПолучитьИнформациюОНаличииСоединений();
	Результат.Вставить("СтрокаСоединенияИнформационнойБазы", 
		СоединенияИБКлиентСервер.ПолучитьСтрокуСоединенияИнформационнойБазы(0));
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИнформациюОНаличииСоединений(СообщенияДляЖурналаРегистрации = Неопределено)
	
	ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Структура("НаличиеАктивныхСоединений, НаличиеCOMСоединений, НаличиеСоединенияКонфигуратором, ЕстьАктивныеПользователи",
								Ложь,
								Ложь,
								Ложь,
								Ложь);
	
	Если ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0 Тогда 
		Результат.ЕстьАктивныеПользователи = Истина;
	КонецЕсли;
	
	МассивСеансов = ПолучитьСеансыИнформационнойБазы();
	Если МассивСеансов.Количество() = 1 Тогда 
		Возврат Результат;
	КонецЕсли;
	
	Результат.НаличиеАктивныхСоединений = Истина;
	
	Для Каждого Сеанс Из МассивСеансов Цикл
		Если ЭтоCOMСоединение(Сеанс) Тогда 
			 Результат.НаличиеCOMСоединений = Истина;
		ИначеЕсли ЭтоСеансКонфигуратором(Сеанс) Тогда 
			Результат.НаличиеСоединенияКонфигуратором = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоСеансКонфигуратором(СеансИнформационнойБазы)
	
	Возврат ВРег(СеансИнформационнойБазы.ИмяПриложения) = ВРег("Designer");
	
КонецФункции 

&НаСервереБезКонтекста
Функция ЭтоCOMСоединение(СеансИнформационнойБазы)
	
	Возврат ВРег(СеансИнформационнойБазы.ИмяПриложения) = ВРег("COMConnection");
	
КонецФункции 
