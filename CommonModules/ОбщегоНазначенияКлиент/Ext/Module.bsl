﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Клиентские процедуры и функции общего назначения:
// - для работы со списками в формах;
// - для работы с журналом регистрации;
// - для обработки действий пользователя в процессе редактирования
//   многострочного текста, например комментария в документах;
// - прочее.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Функции работы со списками в формах

// Проверяет, что в параметре команды Параметр передан объект ожидаемого типа ОжидаемыйТип.
// В противном случае, выдает стандартное сообщение и возвращает Ложь.
// Такая ситуация возможна, например, если в списке выделена строка группировки.
//
// Для использования в командах, работающих с элементами динамических списков в формах.
// Пример использования:
// 
//   Если НЕ ПроверитьТипПараметраКоманды(Элементы.Список.ВыделенныеСтроки, 
//      Тип("ЗадачаСсылка.ЗадачаИсполнителя")) Тогда
//      Возврат;
//   КонецЕсли;
//   ...
// 
// Параметры:
//  Параметр     - Массив или ссылочный тип - параметр команды.
//  ОжидаемыйТип - Тип                      - ожидаемый тип параметра.
//
// Возвращаемое значение:
//  Булево - Истина, если параметр ожидаемого типа.
//
Функция ПроверитьТипПараметраКоманды(Знач Параметр, Знач ОжидаемыйТип) Экспорт
	
	Если Параметр = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	
	Если ТипЗнч(Параметр) = Тип("Массив") Тогда
		// Если в массиве один элемент и он неправильного типа...
		Результат = НЕ (Параметр.Количество() = 1 И ТипЗнч(Параметр[0]) <> ОжидаемыйТип);
	Иначе
		Результат = ТипЗнч(Параметр) = ОжидаемыйТип;
	КонецЕсли;
	
	Если НЕ Результат Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Действие не может быть выполнено для выбранного элемента.'"));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Клиентские процедуры общего назначения

// Возвращает текущую дату, приведенную к часовому поясу сеанса.
//
// Функция возвращает время, близкое к результату функции ТекущаяДатаСеанса() в серверном контексте.
// Погрешность обусловлена временем выполнения серверного вызова.
// Предназначена для использования вместо функции ТекущаяДата().
//
Функция ДатаСеанса() Экспорт
	Возврат ТекущаяДата() + СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ПоправкаКВремениСеанса;
КонецФункции

// Возвращает универсальную дату сеанса, получаемую из текущей даты сеанса.
//
// Функция возвращает время, близкое к результату функции УниверсальноеВремя() в серверном контексте.
// Погрешность обусловлена временем выполнения серверного вызова.
// Предназначена для использования вместо функции УниверсальноеВремя().
//
Функция ДатаУниверсальная() Экспорт
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	ДатаСеанса = ТекущаяДата() + ПараметрыРаботыКлиента.ПоправкаКВремениСеанса;
	Возврат ДатаСеанса + ПараметрыРаботыКлиента.ПоправкаКУниверсальномуВремени;
КонецФункции

// Предлагает пользователю установить расширение работы с файлами в веб-клиенте.
//
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами.
// Например:
//
//    Оповещение = Новый ОписаниеОповещения("ПечатьДокументаЗавершение", ЭтотОбъект);
//    ТекстСообщения = НСтр("ru = 'Для печати документа необходимо установить расширение работы с файлами.'");
//    ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстСообщения);
//
//    Процедура ПечатьДокументаЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
//      Если РасширениеПодключено Тогда
//        // код печати документа, рассчитывающий на то, что расширение подключено
//        //...
//      Иначе
//        // код печати документа, который работает без подключенного расширения
//        //...
//      КонецЕсли;
//
// Параметры:
//   ОписаниеОповещенияОЗакрытии    - ОписаниеОповещения - описание процедуры,
//                                    которая будет вызвана после закрытия формы со следующими параметрами:
//                                      РасширениеПодключено    - Булево - Истина, если расширение было подключено.
//                                      ДополнительныеПараметры - Произвольный - параметры, заданные в ОписаниеОповещенияОЗакрытии.
//   ТекстПредложения                - Строка - текст сообщения. Если не указан, то выводится текст по умолчанию.
//   ВозможноПродолжениеБезУстановки - Булево - если Истина, будет показана кнопка ПродолжитьБезУстановки,
//                                              если Ложь, будет показана кнопка Отмена.
//
Процедура ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещенияОЗакрытии, ТекстПредложения = "", 
	ВозможноПродолжениеБезУстановки = Истина) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ОписаниеОповещенияОЗакрытии);
#Если Не ВебКлиент Тогда
	// В тонком и толстом клиентах расширение подключено всегда.
	ВыполнитьОбработкуОповещения(Оповещение);
	Возврат;
#КонецЕсли
	
	// Если расширение и так уже подключено, незачем про него спрашивать.
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	Если РасширениеПодключено Тогда 
		ВыполнитьОбработкуОповещения(Оповещение);
		Возврат;
	КонецЕсли;
	
	ПервоеОбращениеЗаСеанс = (ПредлагатьУстановкуРасширенияРаботыСФайлами = Неопределено);
	Если ПервоеОбращениеЗаСеанс Тогда
		ПредлагатьУстановкуРасширенияРаботыСФайлами = ПредлагатьУстановкуРасширенияРаботыСФайлами();
	КонецЕсли;
	
	Если ВозможноПродолжениеБезУстановки И Не ПредлагатьУстановкуРасширенияРаботыСФайлами Тогда
		ВыполнитьОбработкуОповещения(Оповещение);
		Возврат;
	КонецЕсли;
	
	Если НЕ ВозможноПродолжениеБезУстановки ИЛИ ПервоеОбращениеЗаСеанс Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТекстПредложения", ТекстПредложения);
		ПараметрыФормы.Вставить("ВозможноПродолжениеБезУстановки", ВозможноПродолжениеБезУстановки);
		ОткрытьФорму("ОбщаяФорма.ВопросОбУстановкеРасширенияРаботыСФайлами", ПараметрыФормы,,,,,Оповещение);
	Иначе
		ВыполнитьОбработкуОповещения(Оповещение);
	КонецЕсли;
	
КонецПроцедуры

// Предлагает пользователю подключить расширение работы с файлами в веб-клиенте,
// и в случае отказа выдает предупреждение о невозможности продолжения операции.
//
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами
// только при подключенном расширении.
// Например:
//
//    Оповещение = Новый ОписаниеОповещения("ПечатьДокументаЗавершение", ЭтотОбъект);
//    ТекстСообщения = НСтр("ru = 'Для печати документа необходимо установить расширение работы с файлами.'");
//    ОбщегоНазначенияКлиент.ПроверитьРасширениеРаботыСФайламиПодключено(Оповещение, ТекстСообщения);
//
//    Процедура ПечатьДокументаЗавершение(Результат, ДополнительныеПараметры) Экспорт
//        // код печати документа, рассчитывающий на то, что расширение подключено
//        //...
//
// Параметры
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - описание процедуры, которая будет вызвана, если расширение подключено со следующими параметрами:
//                                                      Результат               - Булево - всегда Истина
//                                                      ДополнительныеПараметры - Неопределено
//  ТекстПредложения    - Строка - текст с предложением подключить расширение работы с файлами. 
//                                 Если не указан, то выводится текст по умолчанию.
//  ТекстПредупреждения - Строка - текст предупреждения о невозможности продолжения операции. 
//                                 Если не указан, то выводится текст по умолчанию.
//
// Возвращаемое значение:
//  Булево - Истина, если расширение подключено.
//   
Процедура ПроверитьРасширениеРаботыСФайламиПодключено(ОписаниеОповещенияОЗакрытии, Знач ТекстПредложения = "", 
	Знач ТекстПредупреждения = "") Экспорт
	
	Параметры = Новый Структура("ОписаниеОповещенияОЗакрытии,ТекстПредупреждения", 
		ОписаниеОповещенияОЗакрытии, ТекстПредупреждения, );
	Оповещение = Новый ОписаниеОповещения("РасширениеРаботыСФайламиПодключеноЗавершение", ЭтотОбъект, Параметры);
	ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстПредложения);
	
КонецПроцедуры

// Возвращает пользовательскую настройку "Предлагать установку расширения работы с файлами".
//
// Возвращаемое значение:
//   Булево
//
Функция ПредлагатьУстановкуРасширенияРаботыСФайлами() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	Возврат ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента, Истина);
		
КонецФункции	
	
// Выполняет регистрацию компоненты "comcntr.dll" для текущей версии платформы.
// В случае успешной регистрации, предлагает пользователю перезапустить клиентский сеанс 
// для того чтобы регистрация вступила в силу.
//
// Вызывается перед клиентским кодом, который использует менеджер COM-соединений (V83.COMConnector)
// и инициируется интерактивными действиями пользователя. Например:
// 
// ЗарегистрироватьCOMСоединитель();
//   // далее идет код, использующий менеджер COM-соединений (V83.COMConnector)
//   // ...
//
Процедура ЗарегистрироватьCOMСоединитель(Знач ВыполнитьПерезагрузкуСеанса = Истина) Экспорт
	
#Если Не ВебКлиент Тогда
	
	ТекстКоманды = "regsvr32.exe /n /i:user /s comcntr.dll";
	
	КодВозврата = Неопределено;
	ЗапуститьПриложение(ТекстКоманды, КаталогПрограммы(), Истина, КодВозврата);
	
	Если КодВозврата = Неопределено Или КодВозврата > 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Ошибка при регистрации компоненты comcntr.'") + Символы.ПС
			+ НСтр("ru = 'Код ошибки regsvr32:'") + " " + КодВозврата;
			
		Если КодВозврата = 5 Тогда
			ТекстСообщения = ТекстСообщения + " " + НСтр("ru = 'Недостаточно прав доступа.'");
		КонецЕсли;
		
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			НСтр("ru = 'Регистрация компоненты comcntr'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "Ошибка", ТекстСообщения);
		ЖурналРегистрацииВызовСервера.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
		ПоказатьПредупреждение(,ТекстСообщения + Символы.ПС + НСтр("ru = 'Подробности см. в Журнале регистрации.'"));
	ИначеЕсли ВыполнитьПерезагрузкуСеанса Тогда
		Оповещение = Новый ОписаниеОповещения("ЗарегистрироватьCOMСоединительЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Для завершения перерегистрации компоненты comcntr необходимо перезапустить программу.
			|Перезапустить сейчас?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
#КонецЕсли
	
КонецПроцедуры

// Возвращает Истина, если клиентское приложение подключено к базе через веб-сервер.
//
Функция КлиентПодключенЧерезВебСервер() Экспорт
	
	Возврат Найти(Врег(СтрокаСоединенияИнформационнойБазы()), "WS=") = 1;
	
КонецФункции

// Задает вопрос о продолжении действия, влекущего к потере изменений.
// Для использования в обработчиках события ПередЗакрытием модулей форм.
//
// Параметры:
//  ОповещениеСохранитьИЗакрыть  - ОписаниеОповещения - содержит имя процедуры, вызываемой при нажатии на кнопку OK.
//  Отказ                        - Булево - возвращаемый параметр, признак отказа от выполняемого действия.
//  ТекстПредупреждения          - Строка - переопределяемый текст предупреждения, выводимый пользователю.
//
// Пример: 
//  Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
//  ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
//  
//  &НаКлиенте
//  Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
//     // записываем данные формы 
//     // ...
//     Модифицированность = Ложь; // не выводить подтверждение о закрытии формы еще раз
//     Закрыть(<РезультатВыбораВФорме>);
//  КонецПроцедуры
//
Процедура ПоказатьПодтверждениеЗакрытияФормы(ОповещениеСохранитьИЗакрыть, Отказ, ТекстПредупреждения = "") Экспорт
	
	Форма = ОповещениеСохранитьИЗакрыть.Модуль;
	Если Не Форма.Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Параметры = Новый Структура();
	Параметры.Вставить("ОповещениеСохранитьИЗакрыть", ОповещениеСохранитьИЗакрыть);
	Параметры.Вставить("ТекстПредупреждения", ТекстПредупреждения);
	ПараметрыПодтвержденияЗакрытияФормы = Параметры;
	
	ПодключитьОбработчикОжидания("ПодтвердитьЗакрытиеФормыСейчас", 0.1, Истина);
	
КонецПроцедуры

// Задает вопрос о продолжении действия, ведущего к закрытию формы.
// Для использования в обработчиках события ПередЗакрытием модулей форм.
//
// Параметры:
//  Форма                        - УправляемаяФорма - форма, которая вызывает диалог предупреждения.
//  Отказ                        - Булево - возвращаемый параметр, признак отказа от выполняемого действия.
//  ТекстПредупреждения          - Строка - текст предупреждения, выводимый пользователю.
//  ИмяРеквизитаЗакрытьФормуБезПодтверждения - Строка - имя реквизита, содержащего в себе признак того, нужно
//                                 выводить предупреждение или нет.
//  ОписаниеОповещенияЗакрыть    - ОписаниеОповещения - содержит имя процедуры, вызываемой при нажатии на кнопку да.
//
// Пример: 
//  ТекстПредупреждения = НСтр("ru = 'Закрыть помощник?'");
//  ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
//      ЭтотОбъект, Отказ, ТекстПредупреждения, "ЗакрытьФормуБезПодтверждения");
//
Процедура ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(Форма, Отказ, ТекстПредупреждения,
	ИмяРеквизитаЗакрытьФормуБезПодтверждения, ОписаниеОповещенияЗакрыть = Неопределено) Экспорт
	
	Если Форма[ИмяРеквизитаЗакрытьФормуБезПодтверждения] Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Параметры = Новый Структура();
	Параметры.Вставить("Форма", Форма);
	Параметры.Вставить("ТекстПредупреждения", ТекстПредупреждения);
	Параметры.Вставить("ИмяРеквизитаЗакрытьФормуБезПодтверждения", ИмяРеквизитаЗакрытьФормуБезПодтверждения);
	Параметры.Вставить("ОписаниеОповещенияЗакрыть", ОписаниеОповещенияЗакрыть);
	ПараметрыПодтвержденияЗакрытияФормы = Параметры;
	
	ПодключитьОбработчикОжидания("ПодтвердитьЗакрытиеПроизвольнойФормыСейчас", 0.1, Истина);
	
КонецПроцедуры

// Функция получает цвет стиля по имени элемента стиля
//
// Параметры:
//	ИмяЦветаСтиля - строка с именем элемента
//
// Возвращаемое значение - цвет стиля
//
Функция ЦветСтиля(ИмяЦветаСтиля) Экспорт
	
	Возврат ОбщегоНазначенияКлиентПовтИсп.ЦветСтиля(ИмяЦветаСтиля);
	
КонецФункции

// Функция получает шрифт стиля по имени элемента стиля
//
// Параметры:
//	ИмяШрифтаСтиля - строка с именем элемента
//
// Возвращаемое значение - шрифт стиля
//
Функция ШрифтСтиля(ИмяШрифтаСтиля) Экспорт
	
	Возврат ОбщегоНазначенияКлиентПовтИсп.ШрифтСтиля(ИмяШрифтаСтиля);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для обработки событий и вызова необязательных подсистем.

// Возвращает Истина, если подсистема существует в конфигурации.
//
// Параметры:
//  ПолноеИмяПодсистемы - Строка. Полное имя объекта метаданных подсистема без слов "Подсистема.".
//                        Например: "СтандартныеПодсистемы.БазоваяФункциональность".
//
// Пример вызова необязательной подсистемы:
//
//  Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
//  	МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
//  	МодульУправлениеДоступом.<Имя метода>();
//  КонецЕсли;
//
// Возвращаемое значение:
//  Булево.
//
Функция ПодсистемаСуществует(ПолноеИмяПодсистемы) Экспорт
	
	ИменаПодсистем = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске().ИменаПодсистем;
	Возврат ИменаПодсистем.Получить(ПолноеИмяПодсистемы) <> Неопределено;
	
КонецФункции

// Возвращает ссылку на общий модуль по имени.
//
// Параметры:
//  Имя          - Строка - имя общего модуля, например:
//                 "ОбщегоНазначения",
//                 "ОбщегоНазначенияКлиент".
//
// Возвращаемое значение:
//  ОбщийМодуль.
//
Функция ОбщийМодуль(Имя) Экспорт
	
	Модуль = Вычислить(Имя);
	
#Если НЕ ВебКлиент Тогда
	ОбщегоНазначенияКлиентСервер.Проверить(ТипЗнч(Модуль) = Тип("ОбщийМодуль"),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Общий модуль ""%1"" не найден.'"), Имя));
#КонецЕсли
	
	Возврат Модуль;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции для обработки действий пользователя в процессе редактирования
// многострочного текста, например комментария в документах.

// Открывает форму редактирования произвольного многострочного текста.
//
// Параметры:
//  ОповещениеОЗакрытии     - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана 
//                            после закрытия формы ввода текста с теми же параметрами, что и для метода ПоказатьВводСтроки.
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать;
//  Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы.
//
// Пример:
//
//   Оповещение = Новый ОписаниеОповещения("КомментарийЗавершениеВвода", ЭтотОбъект);
//   ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, Элемент.ТекстРедактирования);
//
//   &НаКлиенте
//   Процедура КомментарийЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
//      Если ВведенныйТекст = Неопределено Тогда
//		   Возврат;
//   	КонецЕсли;	
//	
//	   Объект.МногострочныйКомментарий = ВведенныйТекст;
//	   Модифицированность = Истина;
//   КонецПроцедуры
//
Процедура ПоказатьФормуРедактированияМногострочногоТекста(Знач ОповещениеОЗакрытии, 
	Знач МногострочныйТекст, Знач Заголовок = Неопределено) Экспорт
	
	Если Заголовок = Неопределено Тогда
		ПоказатьВводСтроки(ОповещениеОЗакрытии, МногострочныйТекст,,, Истина);
	Иначе
		ПоказатьВводСтроки(ОповещениеОЗакрытии, МногострочныйТекст, Заголовок,, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму редактирования многострочного комментария.
//
// Параметры:
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать
//  ФормаВладелец 			- УправляемаяФорма - форма, в поле которой выполняется ввод комментария
//  ИмяРеквизита            - Строка - имя реквизита формы, в который будет помещен введенный пользователем комментарий. 
//  Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы.
//                                     По умолчанию: "Комментарий".
//
// Пример использования:
//
//	 ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
//
Процедура ПоказатьФормуРедактированияКомментария(Знач МногострочныйТекст, Знач ФормаВладелец, Знач ИмяРеквизита, 
	Знач Заголовок = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура("ФормаВладелец,ИмяРеквизита", ФормаВладелец, ИмяРеквизита);
	Оповещение = Новый ОписаниеОповещения("КомментарийЗавершениеВвода", ЭтотОбъект, ДополнительныеПараметры);
	ЗаголовокФормы = ?(Заголовок <> Неопределено, Заголовок, НСтр("ru='Комментарий'"));
	ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, МногострочныйТекст, ЗаголовокФормы);
	
КонецПроцедуры

// ИспользованиеМодальности

////////////////////////////////////////////////////////////////////////////////
// Устаревшие процедуры и функции, использующие модальные окна.

// Устарела. Следует использовать ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами.
// Предлагает пользователю установить расширение работы с файлами в веб-клиенте.
// При этом инициализирует параметр сеанса ПредлагатьУстановкуРасширенияРаботыСФайлами.
//
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами.
// Например:
//
//    ПредложитьУстановкуРасширенияРаботыСФайлами("Для печати документа необходимо установить расширение работы с файлами.");
//    // далее располагается код печати документа
//    //...
//
// Параметры
//  Сообщение  - Строка - текст сообщения. Если не указан, то выводится текст по умолчанию.
//   
// Возвращаемое значение:
//  Строка - возможные значения:
//           Подключено                - расширение подключено
//           НеПодключено              - пользователь отказался от подключения 
//           НеподдерживаемыйВебКлиент - расширение не может быть подключено, так как не поддерживается в Веб-клиенте
//   
Функция ПредложитьУстановкуРасширенияРаботыСФайлами(ТекстПредложения = Неопределено) Экспорт
	
#Если ВебКлиент Тогда
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	Если РасширениеПодключено Тогда
		Возврат "Подключено"; // если расширение и так уже есть, незачем про него спрашивать
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	ПервоеОбращениеЗаСеанс = Ложь;
	
	Если ПредлагатьУстановкуРасширенияРаботыСФайлами = Неопределено Тогда
		
		ПервоеОбращениеЗаСеанс = Истина;
		ПредлагатьУстановкуРасширенияРаботыСФайлами = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента);
		Если ПредлагатьУстановкуРасширенияРаботыСФайлами = Неопределено Тогда
			ПредлагатьУстановкуРасширенияРаботыСФайлами = Истина;
			ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
				"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента,
				ПредлагатьУстановкуРасширенияРаботыСФайлами);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПредлагатьУстановкуРасширенияРаботыСФайлами = Ложь Тогда
		Возврат ?(РасширениеПодключено, "Подключено", "НеПодключено");
	КонецЕсли;
	
	Если ПервоеОбращениеЗаСеанс Тогда
		ПараметрыФормы = Новый Структура("Сообщение,ВозможноПродолжениеБезУстановки", ТекстПредложения, Истина);
		КодВозврата = ОткрытьФормуМодально("ОбщаяФорма.ВопросОбУстановкеРасширенияРаботыСФайлами", ПараметрыФормы);
		Если КодВозврата = Неопределено Тогда
			КодВозврата = Истина;
		КонецЕсли;
		
		ПредлагатьУстановкуРасширенияРаботыСФайлами = КодВозврата;
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
			"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента,
			ПредлагатьУстановкуРасширенияРаботыСФайлами);
	КонецЕсли;
	Возврат ?(ПодключитьРасширениеРаботыСФайлами(), "Подключено", "НеПодключено");
	
#Иначе
	Возврат "Подключено";
#КонецЕсли
	
КонецФункции

// Устарела. Следует использовать ПроверитьРасширениеРаботыСФайламиПодключено.
// Предлагает пользователю подключить расширение работы с файлами в веб-клиенте,
// и в случае отказа выдает предупреждение о невозможности продолжения операции.
//
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами
// только при подключенном расширении.
// Например:
//
//    Если Не РасширениеРаботыСФайламиПодключено("Для печати документа необходимо установить расширение работы с файлами.") Тогда
//      Возврат;
//    КонецЕсли; 
//    // далее располагается код печати документа
//    //...
//
// Параметры
//  ТекстПредложения    - Строка - текст с предложением подключить расширение работы с файлами. 
//                                 Если не указан, то выводится текст по умолчанию.
//  ТекстПредупреждения - Строка - текст предупреждения о невозможности продолжения операции. 
//                                 Если не указан, то выводится текст по умолчанию.
//
// Возвращаемое значение:
//  Булево - Истина, если расширение подключено.
//   
Функция РасширениеРаботыСФайламиПодключено(ТекстПредложения = Неопределено, ТекстПредупреждения = Неопределено) Экспорт
	
	Результат = ПредложитьУстановкуРасширенияРаботыСФайлами(ТекстПредложения);
	ТекстСообщения = "";
	Если Результат = "НеПодключено" Тогда
		Если ТекстПредупреждения <> Неопределено Тогда
			ТекстСообщения = ТекстПредупреждения;
		Иначе
			ТекстСообщения = НСтр("ru = 'Действие недоступно, так как не подключено расширение работы с файлами в Веб-клиенте.'")
		КонецЕсли;
	КонецЕсли;
	Если Не ПустаяСтрока(ТекстСообщения) Тогда
		ПоказатьПредупреждение(,ТекстСообщения);
	КонецЕсли;
	Возврат Результат = "Подключено";
	
КонецФункции

// Устарела. Следует использовать ПоказатьПодтверждениеЗакрытияФормы или ПоказатьПодтверждениеЗакрытияПроизвольнойФормы.
// Задает вопрос о продолжении действия, влекущего к потере изменений.
//
// Параметры:
//  Отказ               - Булево - возвращаемый параметр, признак отказа от выполняемого действия;
//  Модифицированность  - Булево - признак модифицированности формы, из которой вызывается данная процедура;
//  ДействиеВыбрано     - Булево - признак выбора пользователем действия, приводящего к закрытию формы;
//  ТекстПредупреждения - Строка - текст диалога с пользователем.
//
Процедура ЗапроситьПодтверждениеЗакрытияФормы(Отказ, Модифицированность = Истина, ДействиеВыбрано = Ложь, ТекстПредупреждения = "") Экспорт
	
	Если ДействиеВыбрано = Истина Или Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = ?(ПустаяСтрока(ТекстПредупреждения), 
		НСтр("ru = 'Данные были изменены, внесенные изменения будут отменены.
				   |Отменить и закрыть?'"),
		ТекстПредупреждения);
	Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, 
		НСтр("ru = 'Отмена изменений'"));
		
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Устарела.
// Позволяет выбрать время из выпадающего списка.
//
// Параметры:
//  Форма - управляемая форма / форма - форма, на которой располагается элемент,
//                                      для которого будет выбираться время
//  ПолеВводаФормы -  ПолеФормы - элемент-владелец списка, у которого будет
//                                показан выпадающий список значений времен
//  ТекущееЗначение - Дата - значение, на которое будет спозиционирован выпадающий список
//  Интервал - число - интервал времени (в секундах), с которым необходимо заполнить список, по умолчанию час
//
// Возвращаемое значение:
//   Число - значение времени в секундах. Либо Неопределено, если пользователь отказался от выбора.
//
Функция ВыбратьВремя(Форма, ПолеВводаФормы, Знач ТекущееЗначение, Интервал = 3600) Экспорт
	
	НачалоРабочегоДня      = '00010101000000';
	ОкончаниеРабочегоДня   = '00010101235959';
	
	СписокВремен = Новый СписокЗначений;
	НачалоРабочегоДня = НачалоЧаса(НачалоДня(ТекущееЗначение) +
		Час(НачалоРабочегоДня) * 3600 +
		Минута(НачалоРабочегоДня)*60);
	ОкончаниеРабочегоДня = КонецЧаса(НачалоДня(ТекущееЗначение) +
		Час(ОкончаниеРабочегоДня) * 3600 +
		Минута(ОкончаниеРабочегоДня)*60);
	
	ВремяСписка = НачалоРабочегоДня;
	
	Пока НачалоЧаса(ВремяСписка) <= НачалоЧаса(ОкончаниеРабочегоДня) Цикл
		
		Если НЕ ЗначениеЗаполнено(ВремяСписка) Тогда
			ПредставлениеВремени = "00:00";
		Иначе
			ПредставлениеВремени = Формат(ВремяСписка,"ДФ=ЧЧ:мм");
		КонецЕсли;
		
		СписокВремен.Добавить(ВремяСписка, ПредставлениеВремени);
		
		ВремяСписка = ВремяСписка + Интервал;
		
	КонецЦикла;
	
	НачальноеЗначение = СписокВремен.НайтиПоЗначению(ТекущееЗначение);
	
	Если НачальноеЗначение = Неопределено Тогда
		ВыбранноеВремя = Форма.ВыбратьИзСписка(СписокВремен, ПолеВводаФормы);
	Иначе
		ВыбранноеВремя = Форма.ВыбратьИзСписка(СписокВремен, ПолеВводаФормы, НачальноеЗначение);
	КонецЕсли;
	
	Если ВыбранноеВремя = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ВыбранноеВремя.Значение;
	
КонецФункции

// Устарела. Следует использовать ПоказатьФормуРедактированияМногострочногоТекста.
// Открывает форму редактирования произвольного многострочного текста модально.
//
// Параметры:
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать;
//  РезультатРедактирования - Строка - в этот параметр будет помещен результат редактирования;
//  Модифицированность      - Строка - флаг модифицированности формы;
//  Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы.
//
Процедура ОткрытьФормуРедактированияМногострочногоТекста(Знач МногострочныйТекст, РезультатРедактирования, Модифицированность = Ложь, 
		Знач Заголовок = Неопределено) Экспорт
	
	Если Заголовок = Неопределено Тогда
		ТекстВведен = ВвестиСтроку(МногострочныйТекст,,, Истина);
	Иначе
		ТекстВведен = ВвестиСтроку(МногострочныйТекст, Заголовок,, Истина);
	КонецЕсли;
	
	Если Не ТекстВведен Тогда
		Возврат;
	КонецЕсли;
		
	РезультатРедактирования = МногострочныйТекст;
	Если Не Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Устарела. Следует использовать ПоказатьФормуРедактированияКомментария.
// Открывает форму редактирования многострочного комментария модально.
//
// Параметры:
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать
//  РезультатРедактирования - Строка - переменная, в которую будет помещен результат редактирования
//  Модифицированность       - Строка - флаг модифицированности формы
//
// Пример использования:
//  ОткрытьФормуРедактированияКомментария(Элемент.ТекстРедактирования, Объект.Комментарий, Модифицированность);
//
Процедура ОткрытьФормуРедактированияКомментария(Знач МногострочныйТекст, РезультатРедактирования,
	Модифицированность = Ложь) Экспорт
	
	ОткрытьФормуРедактированияМногострочногоТекста(МногострочныйТекст, РезультатРедактирования, Модифицированность, 
		НСтр("ru='Комментарий'"));
	
КонецПроцедуры

// Конец ИспользованиеМодальности

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Получение обработчиков клиентских событий.

// Возвращает обработчики указанного клиентского события.
//
// Параметры:
//  Событие  - Строка, например,
//             "СтандартныеПодсистемы.БазоваяФункциональность\ПриНачалеРаботыСистемы".
//
// Возвращаемое значение:
//  ФиксированныйМассив со значениями типа
//    ФиксированнаяСтруктура со свойствами:
//      Версия - Строка      - версия обработчика, например, "2.1.3.4". Пустая строка, если не указана.
//      Модуль - ОбщийМодуль - серверный общий модуль.
// 
Функция ОбработчикиСобытия(Событие) Экспорт
	
	Возврат СтандартныеПодсистемыКлиентПовтИсп.ОбработчикиКлиентскогоСобытия(Событие, Ложь);
	
КонецФункции

// Возвращает обработчики указанного клиентского служебного события.
//
// Параметры:
//  Событие  - Строка, например,
//             "СтандартныеПодсистемы.БазоваяФункциональность\ПриОпределенииФормыАктивныхПользователей".
//
// Возвращаемое значение:
//  ФиксированныйМассив со значениями типа
//    ФиксированнаяСтруктура со свойствами:
//      Версия - Строка      - версия обработчика, например, "2.1.3.4". Пустая строка, если не указана.
//      Модуль - ОбщийМодуль - серверный общий модуль.
// 
Функция ОбработчикиСлужебногоСобытия(Событие) Экспорт
	
	Возврат СтандартныеПодсистемыКлиентПовтИсп.ОбработчикиКлиентскогоСобытия(Событие, Истина);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиЗавершение(Действие, ОповещениеОЗакрытии) Экспорт
	
#Если ВебКлиент Тогда
	Если Действие = "БольшеНеПредлагать" Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация();
		ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
		ПредлагатьУстановкуРасширенияРаботыСФайлами = Ложь;
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
			"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента,
			ПредлагатьУстановкуРасширенияРаботыСФайлами);
	КонецЕсли;
#КонецЕсли
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, ПодключитьРасширениеРаботыСФайлами());
	
КонецПроцедуры	

Процедура РасширениеРаботыСФайламиПодключеноЗавершение(Действие, Параметры) Экспорт
	
	ТекстСообщения = "";
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещенияОЗакрытии);
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Параметры.ТекстПредупреждения) Тогда
		ТекстСообщения = НСтр("ru = 'Действие недоступно, так как не установлено расширение работы с файлами.'")
	Иначе
		ТекстСообщения = Параметры.ТекстПредупреждения;
	КонецЕсли;
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

Процедура КомментарийЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	РеквизитФормы = ДополнительныеПараметры.ФормаВладелец;
	
	ПутьКРеквизитуФормы = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ДополнительныеПараметры.ИмяРеквизита, ".");
	// Если реквизит вида "Объект.Комментарий" и т.п.
	Если ПутьКРеквизитуФормы.Количество() > 1 Тогда
		Для Индекс = 0 По ПутьКРеквизитуФормы.Количество() - 2 Цикл 
			РеквизитФормы = РеквизитФормы[ПутьКРеквизитуФормы[Индекс]];
		КонецЦикла;
	КонецЕсли;	
	
	РеквизитФормы[ПутьКРеквизитуФормы[ПутьКРеквизитуФормы.Количество() - 1]] = ВведенныйТекст;
	ДополнительныеПараметры.ФормаВладелец.Модифицированность = Истина;
	
КонецПроцедуры

Процедура ЗарегистрироватьCOMСоединительЗавершение(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина;
		ЗавершитьРаботуСистемы(Истина, Истина);
	КонецЕсли;

КонецПроцедуры

Процедура ПодтвердитьЗакрытиеФормы() Экспорт
	
	Параметры = ПараметрыПодтвержденияЗакрытияФормы;
	Если Параметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПараметрыПодтвержденияЗакрытияФормы = Неопределено;
	
	Оповещение = Новый ОписаниеОповещения("ПодтвердитьЗакрытиеФормыЗавершение", ЭтотОбъект, Параметры);
	Если ПустаяСтрока(Параметры.ТекстПредупреждения) Тогда
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
	Иначе
		ТекстВопроса = Параметры.ТекстПредупреждения;
	КонецЕсли;
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, ,
		КодВозвратаДиалога.Нет);
	
КонецПроцедуры

Процедура ПодтвердитьЗакрытиеФормыЗавершение(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеСохранитьИЗакрыть);
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Форма = Параметры.ОповещениеСохранитьИЗакрыть.Модуль;
		Форма.Модифицированность = Ложь;
		Форма.Закрыть();
	Иначе
		Форма = Параметры.ОповещениеСохранитьИЗакрыть.Модуль;
		Форма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодтвердитьЗакрытиеПроизвольнойФормы() Экспорт
	
	Параметры = ПараметрыПодтвержденияЗакрытияФормы;
	Если Параметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПараметрыПодтвержденияЗакрытияФормы = Неопределено;
	РежимВопроса = РежимДиалогаВопрос.ДаНет;
	
	Оповещение = Новый ОписаниеОповещения("ПодтвердитьЗакрытиеПроизвольнойФормыЗавершение", ЭтотОбъект, Параметры);
	
	ПоказатьВопрос(Оповещение, Параметры.ТекстПредупреждения, РежимВопроса);
	
КонецПроцедуры

Процедура ПодтвердитьЗакрытиеПроизвольнойФормыЗавершение(Ответ, Параметры) Экспорт
	
	Форма = Параметры.Форма;
	Если Ответ = КодВозвратаДиалога.Да
		Или Ответ = КодВозвратаДиалога.ОК Тогда
		Форма[Параметры.ИмяРеквизитаЗакрытьФормуБезПодтверждения] = Истина;
		Если Параметры.ОписаниеОповещенияЗакрыть <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещенияЗакрыть);
		КонецЕсли;
		Форма.Закрыть();
	Иначе
		Форма[Параметры.ИмяРеквизитаЗакрытьФормуБезПодтверждения] = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
