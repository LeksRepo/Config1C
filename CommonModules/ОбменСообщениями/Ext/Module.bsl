﻿////////////////////////////////////////////////////////////////////////////////
// ОбменСообщениями: механизм обмена сообщениями.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Выполняет отправку сообщения в адресный канал сообщений.
// Соответствует типу отправки "Конечная точка/Конечная точка".
//
// Параметры:
//  КаналСообщений                 – Строка. Идентификатор адресного канала сообщений.
//  ТелоСообщения (необязательный) – Произвольный. Тело сообщения системы, которое необходимо отправить.
//  Получатель (необязательный)    – Неопределено; ПланОбменаСсылка.ОбменСообщениями; Массив.
//   Неопределено – получатель сообщения не указан. Сообщение будет отправлено конечным точкам, 
//   которые определяются настройками текущей информационной системы:
//   в обработчике ОбменСообщениямиПереопределяемый.ПолучателиСообщения (программно)
//   и в регистре сведений НастройкиОтправителя (настройка системы).
//   ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, который соответствует конечной точке,
//   для которой предназначено сообщение. Сообщение будет отправлено только этой конечной точке.
//   Массив – массив получателей сообщения; элементы массива должны иметь тип ПланОбменаСсылка.ОбменСообщениями.
//   Сообщение будет отправлено всем конечным точкам, указанным в массиве.
//   Значение по умолчанию: Неопределено.
//
Процедура ОтправитьСообщение(КаналСообщений, ТелоСообщения = Неопределено, Получатель = Неопределено) Экспорт
	
	ОтправитьСообщениеВКаналСообщений(КаналСообщений, ТелоСообщения, Получатель);
	
КонецПроцедуры

// Выполняет отправку быстрого сообщения в адресный канал сообщений.
// Соответствует типу отправки "Конечная точка/Конечная точка".
//
// Параметры:
//  КаналСообщений                 – Строка. Идентификатор адресного канала сообщений.
//  ТелоСообщения (необязательный) – Произвольный. Тело сообщения системы, которое необходимо отправить.
//  Получатель (необязательный)    – Неопределено; ПланОбменаСсылка.ОбменСообщениями; Массив.
//   Неопределено – получатель сообщения не указан. Сообщение будет отправлено конечным точкам, 
//   которые определяются настройками текущей информационной системы:
//   в обработчике ОбменСообщениямиПереопределяемый.ПолучателиСообщения (программно)
//   и в регистре сведений НастройкиОтправителя (настройка системы).
//   ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, который соответствует конечной точке,
//   для которой предназначено сообщение. Сообщение будет отправлено только этой конечной точке.
//   Массив – массив получателей сообщения; элементы массива должны иметь тип ПланОбменаСсылка.ОбменСообщениями.
//   Сообщение будет отправлено всем конечным точкам, указанным в массиве.
//   Значение по умолчанию: Неопределено.
//
Процедура ОтправитьСообщениеСейчас(КаналСообщений, ТелоСообщения = Неопределено, Получатель = Неопределено) Экспорт
	
	ОтправитьСообщениеВКаналСообщений(КаналСообщений, ТелоСообщения, Получатель, Истина);
	
КонецПроцедуры

// Выполняет отправку сообщения в широковещательный канал сообщений.
// Соответствует типу отправки "Публикация/Подписка".
// Сообщение будет доставлено конечным точкам, которые подписаны на широковещательный канал.
// Настройка подписок на широковещательный канал выполняется через регистр сведений ПодпискиПолучателей.
//
// Параметры:
//  КаналСообщений                 – Строка. Идентификатор широковещательного канала сообщений.
//  ТелоСообщения (необязательный) – Произвольный. Тело сообщения системы, которое необходимо отправить.
//
Процедура ОтправитьСообщениеПодписчикам(КаналСообщений, ТелоСообщения = Неопределено) Экспорт
	
	ОтправитьСообщениеПодписчикамВКаналСообщений(КаналСообщений, ТелоСообщения);
	
КонецПроцедуры

// Выполняет отправку быстрого сообщения в широковещательный канал сообщений.
// Соответствует типу отправки "Публикация/Подписка".
// Сообщение будет доставлено конечным точкам, которые подписаны на широковещательный канал.
// Настройка подписок на широковещательный канал выполняется через регистр сведений ПодпискиПолучателей.
//
// Параметры:
//  КаналСообщений                 – Строка. Идентификатор широковещательного канала сообщений.
//  ТелоСообщения (необязательный) – Произвольный. Тело сообщения системы, которое необходимо отправить.
//
Процедура ОтправитьСообщениеПодписчикамСейчас(КаналСообщений, ТелоСообщения = Неопределено) Экспорт
	
	ОтправитьСообщениеПодписчикамВКаналСообщений(КаналСообщений, ТелоСообщения, Истина);
	
КонецПроцедуры

// Выполняет немедленную отправку быстрых сообщений из общей очереди сообщений.
// Отправка сообщений выполняется в цикле до тех пор, пока из очереди сообщений не будут отправлены все быстрые сообщения.
// На время отправки сообщений блокируется немедленная отправка сообщений из других сеансов.
//
Процедура ДоставитьСообщения() Экспорт
	
	Если ТранзакцияАктивна() Тогда
		ВызватьИсключение НСтр("ru = 'Доставка быстрых сообщений системы не может выполняться в активной транзакции.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не НачатьОтправкуБыстрыхСообщений() Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = "";
	СправочникиСообщений = ОбменСообщениямиПовтИсп.ПолучитьСправочникиСообщений();
	Для Каждого СправочникСообщений Из СправочникиСообщений Цикл
		
		ЭтоПервыйФрагмент = ПустаяСтрока(ТекстЗапроса);
		
		Если Не ЭтоПервыйФрагмент Тогда
			
			ТекстЗапроса = ТекстЗапроса + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|"
			
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса +
			"ВЫБРАТЬ
			|	ТаблицаИзменений.Узел КАК КонечнаяТочка,
			|	ТаблицаИзменений.Ссылка КАК Сообщение
			|[ПОМЕСТИТЬ]
			|ИЗ
			|	[СправочникСообщений].Изменения КАК ТаблицаИзменений
			|ГДЕ
			|	ТаблицаИзменений.Ссылка.ЭтоБыстроеСообщение
			|	И ТаблицаИзменений.НомерСообщения ЕСТЬ NULL
			|	И НЕ ТаблицаИзменений.Узел В (&НедоступныеКонечныеТочки)";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[СправочникСообщений]", СправочникСообщений.ПустаяСсылка().Метаданные().ПолноеИмя());
		Если ЭтоПервыйФрагмент Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПОМЕСТИТЬ]", "ПОМЕСТИТЬ ВТ_Изменения");
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПОМЕСТИТЬ]", "");
		КонецЕсли;		
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Изменения.КонечнаяТочка КАК КонечнаяТочка,
	|	ВТ_Изменения.Сообщение
	|ИЗ
	|	ВТ_Изменения КАК ВТ_Изменения
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТ_Изменения.Сообщение.Код
	|ИТОГИ ПО
	|	КонечнаяТочка";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	НедоступныеКонечныеТочки = Новый Массив;
	
	Попытка
		
		Пока Истина Цикл
			
			Запрос.УстановитьПараметр("НедоступныеКонечныеТочки", НедоступныеКонечныеТочки);
			
			РезультатЗапроса = ОбщегоНазначения.ВыполнитьЗапросВнеТранзакции(Запрос);
			
			Если РезультатЗапроса.Пустой() Тогда
				Прервать;
			КонецЕсли;
			
			Группы = РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
			
			Для Каждого Группа Из Группы.Строки Цикл
				
				Сообщения = Группа.Строки.ВыгрузитьКолонку("Сообщение");
				
				Попытка
					
					ДоставитьСообщенияПолучателю(Группа.КонечнаяТочка, Сообщения);
					
					УдалитьРегистрациюИзменений(Группа.КонечнаяТочка, Сообщения);
					
				Исключение
					
					НедоступныеКонечныеТочки.Добавить(Группа.КонечнаяТочка);
					
					ЗаписьЖурналаРегистрации(ОбменСообщениямиВнутренний.СобытиеЖурналаРегистрацииЭтойПодсистемы(),
											УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				КонецПопытки;
				
			КонецЦикла;
			
		КонецЦикла;
		
	Исключение
		ОтменитьОтправкуБыстрыхСообщений();
		ВызватьИсключение;
	КонецПопытки;
	
	ЗавершитьОтправкуБыстрыхСообщений();
	
КонецПроцедуры

// Выполняет подключение конечной точки.
// Перед подключением конечной точки выполняется проверка установки соединения 
// отправителя к получателю и получателя к отправителю. 
// Также проверяется то, что настройки подключения получателя указывают на текущего отправителя.
//
// Параметры:
//  Отказ (обязательный). Тип: Булево. Флаг выполнения операции; поднимается в случае ошибок при подключении конечной точки.
//  URLВебСервисаПолучателя (обязательный). Тип: Строка. Веб-адрес подключаемой конечной точки.
//  ИмяПользователяПолучателя (обязательный). Тип: Строка. Пользователь для аутентификации в подключаемой конечной точке 
//                                              при работе через web-сервис подсистемы обмена сообщениями.
//  ПарольПолучателя (обязательный). Тип: Строка. Пароль пользователя в подключаемой конечной точке.
//  URLВебСервисаОтправителя (обязательный). Тип: Строка. Веб-адрес этой информационной базы со стороны подключаемой конечной точки.
//  ИмяПользователяОтправителя (обязательный). Тип: Строка. Пользователь для аутентификации в этой информационной базе 
//                                              при работе через web-сервис подсистемы обмена сообщениями.
//  ПарольОтправителя (обязательный). Тип: Строка. Пароль пользователя в этой информационной базе.
//  КонечнаяТочка (необязательный). Тип: ПланОбменаСсылка.ОбменСообщениями; Неопределено. Если подключение конечной точки завершилось успешно,
//                                  то в этот параметр возвращается ссылка на узел плана обмена, который соответствует подключенной конечной точке.
//                                  Если подключить конечную точку не удалось, то возвращается Неопределено.
//  НаименованиеКонечнойТочкиПолучателя (необязательный). Тип: Строка (150). Наименование подключаемой конечной точки. Если значение не задано,
//                                  то в качестве наименования используется синоним конфигурации подключаемой конечной точки.
//  НаименованиеКонечнойТочкиОтправителя (необязательный). Тип: Строка (150). Наименование конечной точки, которая соответствует этой информационной базе.
//                                  Если значение не задано, то в качестве наименования используется синоним конфигурации этой информационной базы.
//
Процедура ПодключитьКонечнуюТочку(Отказ,
									URLВебСервисаПолучателя,
									ИмяПользователяПолучателя,
									ПарольПолучателя,
									URLВебСервисаОтправителя,
									ИмяПользователяОтправителя,
									ПарольОтправителя,
									КонечнаяТочка = Неопределено,
									НаименованиеКонечнойТочкиПолучателя = "",
									НаименованиеКонечнойТочкиОтправителя = ""
	) Экспорт
	
	НастройкиПодключенияОтправителя = ОбменДаннымиСервер.СтруктураПараметровWS();
	НастройкиПодключенияОтправителя.WSURLВебСервиса              = URLВебСервисаПолучателя;
	НастройкиПодключенияОтправителя.WSИмяПользователя            = ИмяПользователяПолучателя;
	НастройкиПодключенияОтправителя.WSПароль                     = ПарольПолучателя;
	
	НастройкиПодключенияПолучателя = ОбменДаннымиСервер.СтруктураПараметровWS();
	НастройкиПодключенияПолучателя.WSURLВебСервиса              = URLВебСервисаОтправителя;
	НастройкиПодключенияПолучателя.WSИмяПользователя            = ИмяПользователяОтправителя;
	НастройкиПодключенияПолучателя.WSПароль                     = ПарольОтправителя;
	
	ОбменСообщениямиВнутренний.ВыполнитьПодключениеКонечнойТочкиНаСторонеОтправителя(Отказ, 
														НастройкиПодключенияОтправителя,
														НастройкиПодключенияПолучателя,
														КонечнаяТочка,
														НаименованиеКонечнойТочкиПолучателя,
														НаименованиеКонечнойТочкиОтправителя);
	
КонецПроцедуры

// Выполняет обновление настроек подключения для конечной точки.
// Обновляются настройки подключения этой информационной базы к указанной конечной точке
// и настройки подключения конечной точки к этой информационной базе.
// Перед применением настроек выполняется проверка подключения на правильность задания настроек.
// Также проверяется то, что настройки подключения получателя указывают на текущего отправителя.
//
// Параметры:
//  Отказ (обязательный). Тип: Булево. Флаг выполнения операции; поднимается в случае ошибок.
//  КонечнаяТочка (обязательный). Тип: ПланОбменаСсылка.ОбменСообщениями. Ссылка на узел плана обмена, который соответствует конечной точке.
//  URLВебСервисаПолучателя (обязательный). Тип: Строка. Веб-адрес конечной точки.
//  ИмяПользователяПолучателя (обязательный). Тип: Строка. Пользователь для аутентификации в конечной точке 
//                                            при работе через web-сервис подсистемы обмена сообщениями.
//  ПарольПолучателя (обязательный). Тип: Строка. Пароль пользователя в конечной точке.
//  URLВебСервисаОтправителя (обязательный). Тип: Строка. Веб-адрес этой информационной базы со стороны конечной точки.
//  ИмяПользователяОтправителя (обязательный). Тип: Строка. Пользователь для аутентификации в этой информационной базе 
//                                            при работе через web-сервис подсистемы обмена сообщениями.
//  ПарольОтправителя (обязательный). Тип: Строка. Пароль пользователя в этой информационной базе.
//
Процедура ОбновитьНастройкиПодключенияКонечнойТочки(Отказ,
									КонечнаяТочка,
									URLВебСервисаПолучателя,
									ИмяПользователяПолучателя,
									ПарольПолучателя,
									URLВебСервисаОтправителя,
									ИмяПользователяОтправителя,
									ПарольОтправителя
	) Экспорт
	
	НастройкиПодключенияОтправителя = ОбменДаннымиСервер.СтруктураПараметровWS();
	НастройкиПодключенияОтправителя.WSURLВебСервиса              = URLВебСервисаПолучателя;
	НастройкиПодключенияОтправителя.WSИмяПользователя            = ИмяПользователяПолучателя;
	НастройкиПодключенияОтправителя.WSПароль                     = ПарольПолучателя;
	
	НастройкиПодключенияПолучателя = ОбменДаннымиСервер.СтруктураПараметровWS();
	НастройкиПодключенияПолучателя.WSURLВебСервиса              = URLВебСервисаОтправителя;
	НастройкиПодключенияПолучателя.WSИмяПользователя            = ИмяПользователяОтправителя;
	НастройкиПодключенияПолучателя.WSПароль                     = ПарольОтправителя;
	
	ОбменСообщениямиВнутренний.ВыполнитьОбновлениеНастроекПодключенияКонечнойТочки(Отказ, КонечнаяТочка, НастройкиПодключенияОтправителя, НастройкиПодключенияПолучателя);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Объявляет события подсистемы РаботаВМоделиСервиса.ОбменСообщениями:
//
// Серверные события:
//
//   ПриОпределенииОбработчиковКаналовСообщений,
//   ПриОпределенииПолучателейСообщения,
//   ПриОтправкеСообщения,
//   ПриПолученииСообщения.
//
// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия) Экспорт
	
	// СЕРВЕРНЫЕ СОБЫТИЯ.
	
	// Получает список обработчиков сообщений, которые обрабатывают подсистемы библиотеки.
	// 
	// Параметры:
	//  Обработчики - ТаблицаЗначений - состав полей см. в ОбменСообщениями.НоваяТаблицаОбработчиковСообщений
	//
	// Синтаксис:
	// Процедура ПриОпределенииОбработчиковКаналовСообщений(Обработчики) Экспорт
	//
	// Для использования в других библиотеках.
	//
	// (То же, что ОбменСообщениямиПереопределяемый.ПолучитьОбработчикиКаналовСообщений).
	//
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменСообщениями\ПриОпределенииОбработчиковКаналовСообщений");
	
	// Обработчик получения динамического списка конечных точек сообщений
	//
	// Параметры:
	//  КаналСообщений – Строка. Идентификатор канала сообщений, для которого необходимо определить конечные точки.
	//  Получатели     – Массив. Массив конечных точек, в которые следует адресовать сообщение.
	//                   Массив должен быть заполнен элементами типа ПланОбменаСсылка.ОбменСообщениями.
	//                   Этот параметр необходимо определить в теле обработчика.
	//
	// Синтаксис:
	// Процедура ПриОпределенииПолучателейСообщения(Знач КаналСообщений, Получатели) Экспорт
	//
	// (То же, что ОбменСообщениямиПереопределяемый.ПолучателиСообщения).
	//
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменСообщениями\ПриОпределенииПолучателейСообщения");
	
	// Обработчик события при отправке сообщения.
	// Обработчик данного события вызывается перед помещением сообщения в XML-поток.
	// Обработчик вызывается для каждого отправляемого сообщения.
	//
	//  Параметры:
	// КаналСообщений (только чтение) Тип: Строка. Идентификатор канала сообщений, в который отправляется сообщение.
	// ТелоСообщения (чтение и запись) Тип: Произвольный. Тело отправляемого сообщения.
	// В обработчике события тело сообщения может быть изменено, например, дополнено информацией.
	//
	// Синтаксис:
	// Процедура ПриОтправкеСообщения(КаналСообщений, ТелоСообщения) Экспорт
	//
	// (То же, что ОбменСообщениямиПереопределяемый.ПриОтправкеСообщения).
	//
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменСообщениями\ПриОтправкеСообщения");
	
	// Обработчик события при получении сообщения.
	// Обработчик данного события вызывается при получении сообщения из XML-потока.
	// Обработчик вызывается для каждого получаемого сообщения.
	//
	//  Параметры:
	// КаналСообщений (только чтение) Тип: Строка. Идентификатор канала сообщений, из которого получено сообщение.
	// ТелоСообщения (чтение и запись) Тип: Произвольный. Тело полученного сообщения.
	// В обработчике события тело сообщения может быть изменено, например, дополнено информацией.
	//
	// Синтаксис:
	// Процедура ПриПолученииСообщения(КаналСообщений, ТелоСообщения) Экспорт
	//
	// (То же, что ОбменСообщениямиПереопределяемый.ПриПолученииСообщения).
	//
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменСообщениями\ПриПолученииСообщения");
	
КонецПроцедуры

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"ОбменСообщениямиВнутренний");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.ОбменДанными\ПриВыгрузкеДанныхСлужебный"].Добавить(
			"ОбменСообщениями");
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.ОбменДанными\ПриЗагрузкеДанныхСлужебный"].Добавить(
			"ОбменСообщениями");
	КонецЕсли;
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов"].Добавить(
		"ОбменСообщениями");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ВыгрузкаЗагрузкаДанных") Тогда
		СерверныеОбработчики["ТехнологияСервиса.ВыгрузкаЗагрузкаДанных\ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки"].Добавить(
			"ОбменСообщениями");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ОтправитьСообщениеВКаналСообщений(КаналСообщений, ТелоСообщения, Получатель, ЭтоБыстроеСообщение = Ложь)
	
	Если ТипЗнч(Получатель) = Тип("ПланОбменаСсылка.ОбменСообщениями") Тогда
		
		ОтправитьСообщениеПолучателю(КаналСообщений, ТелоСообщения, Получатель, ЭтоБыстроеСообщение);
		
	ИначеЕсли ТипЗнч(Получатель) = Тип("Массив") Тогда
		
		Для Каждого Элемент Из Получатель Цикл
			
			Если ТипЗнч(Элемент) <> Тип("ПланОбменаСсылка.ОбменСообщениями") Тогда
				
				ВызватьИсключение НСтр("ru = 'Указан неправильный получатель для метода ОбменСообщениями.ОтправитьСообщение().'");
				
			КонецЕсли;
			
			ОтправитьСообщениеПолучателю(КаналСообщений, ТелоСообщения, Элемент, ЭтоБыстроеСообщение);
			
		КонецЦикла;
		
	ИначеЕсли Получатель = Неопределено Тогда
		
		ОтправитьСообщениеПолучателям(КаналСообщений, ТелоСообщения, ЭтоБыстроеСообщение);
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Указан неправильный получатель для метода ОбменСообщениями.ОтправитьСообщение().'");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтправитьСообщениеПодписчикамВКаналСообщений(КаналСообщений, ТелоСообщения, ЭтоБыстроеСообщение = Ложь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Получатели = РегистрыСведений.ПодпискиПолучателей.ПодписчикиКаналаСообщений(КаналСообщений);
	
	// Отправка сообщения получателю (конечной точке)
	Для Каждого Получатель Из Получатели Цикл
		
		ОтправитьСообщениеПолучателю(КаналСообщений, ТелоСообщения, Получатель, ЭтоБыстроеСообщение);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтправитьСообщениеПолучателям(КаналСообщений, ТелоСообщения, ЭтоБыстроеСообщение)
	Перем ДинамическиПодключенныеПолучатели;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Получатели сообщения из регистра
	Получатели = РегистрыСведений.НастройкиОтправителя.ПодписчикиКаналаСообщений(КаналСообщений);
	
	// Получатели сообщения из кода
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменСообщениями\ПриОпределенииПолучателейСообщения");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОпределенииПолучателейСообщения(КаналСообщений, ДинамическиПодключенныеПолучатели);
	КонецЦикла;
	
	ОбменСообщениямиПереопределяемый.ПолучателиСообщения(КаналСообщений, ДинамическиПодключенныеПолучатели);
	
	// Получаем массив уникальных получателей из двух массивов. 
	// Для этого используем временную таблицу значений.
	ТаблицаПолучателей = Новый ТаблицаЗначений;
	ТаблицаПолучателей.Колонки.Добавить("Получатель");
	Для Каждого Получатель Из Получатели Цикл
		ТаблицаПолучателей.Добавить().Получатель = Получатель;
	КонецЦикла;
	
	Если ТипЗнч(ДинамическиПодключенныеПолучатели) = Тип("Массив") Тогда
		
		Для Каждого Получатель Из ДинамическиПодключенныеПолучатели Цикл
			ТаблицаПолучателей.Добавить().Получатель = Получатель;
		КонецЦикла;
		
	КонецЕсли;
	
	ТаблицаПолучателей.Свернуть("Получатель");
	
	Получатели = ТаблицаПолучателей.ВыгрузитьКолонку("Получатель");
	
	// Отправка сообщения получателю (конечной точке)
	Для Каждого Получатель Из Получатели Цикл
		
		ОтправитьСообщениеПолучателю(КаналСообщений, ТелоСообщения, Получатель, ЭтоБыстроеСообщение);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтправитьСообщениеПолучателю(КаналСообщений, ТелоСообщения, Получатель, ЭтоБыстроеСообщение)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ТранзакцияАктивна() Тогда
		
		ВызватьИсключение НСтр("ru = 'Отправка сообщений может выполняться только в транзакции.'");
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КаналСообщений) Тогда
		
		ВызватьИсключение НСтр("ru = 'Не задано значение параметра ""КаналСообщений"" для метода ОбменСообщениями.ОтправитьСообщение.'");
		
	ИначеЕсли СтрДлина(КаналСообщений) > 150 Тогда
		
		ВызватьИсключение НСтр("ru = 'Длина имени канала сообщений не должна превышать 150 символов.'");
		
	ИначеЕсли Не ЗначениеЗаполнено(Получатель) Тогда
		
		ВызватьИсключение НСтр("ru = 'Не задано значение параметра ""Получатель"" для метода ОбменСообщениями.ОтправитьСообщение.'");
		
	ИначеЕсли ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Получатель, "Заблокирована") Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Попытка отправки сообщения заблокированной конечной точке ""%1"".'"),
			Строка(Получатель));
	КонецЕсли;
	
	СправочникДляСообщения = Справочники.СообщенияСистемы;
	СтандартнаяОбработка = Истина;
	
	Если ОбщегоНазначенияПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		МодульСообщенияВМоделиСервисаРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервисаРазделениеДанных");
		ПереопределенныйСправочник = МодульСообщенияВМоделиСервисаРазделениеДанных.ПриВыбореСправочникаДляСообщения(ТелоСообщения);
		Если ПереопределенныйСправочник <> Неопределено Тогда
			СправочникДляСообщения = ПереопределенныйСправочник;
		КонецЕсли;
	КонецЕсли;
	
	НовоеСообщение = СправочникДляСообщения.СоздатьЭлемент();
	НовоеСообщение.Наименование = КаналСообщений;
	НовоеСообщение.Код = 0;
	НовоеСообщение.КоличествоПопытокОбработкиСообщения = 0;
	НовоеСообщение.Заблокировано = Ложь;
	НовоеСообщение.ТелоСообщения = Новый ХранилищеЗначения(ТелоСообщения);
	НовоеСообщение.Отправитель = ОбменСообщениямиВнутренний.ЭтотУзел();
	НовоеСообщение.ЭтоБыстроеСообщение = ЭтоБыстроеСообщение;
	
	Если Получатель = ОбменСообщениямиВнутренний.ЭтотУзел() Тогда
		
		НовоеСообщение.Получатель = ОбменСообщениямиВнутренний.ЭтотУзел();
		
	Иначе
		
		НовоеСообщение.ОбменДанными.Получатели.Добавить(Получатель);
		НовоеСообщение.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
		
		НовоеСообщение.Получатель = Получатель;
		
	КонецЕсли;
	
	СтандартнаяОбработкаЗаписи = Истина;
	Если ОбщегоНазначенияПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		МодульСообщенияВМоделиСервисаРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервисаРазделениеДанных");
		МодульСообщенияВМоделиСервисаРазделениеДанных.ПередЗаписьюСообщения(НовоеСообщение, СтандартнаяОбработкаЗаписи);
	КонецЕсли;
	
	Если СтандартнаяОбработкаЗаписи Тогда
		НовоеСообщение.Записать();
	КонецЕсли;
	
КонецПроцедуры

Функция НачатьОтправкуБыстрыхСообщений()
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.БлокировкаОтправкиБыстрыхСообщений");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		БлокировкаОтправкиБыстрыхСообщений = Константы.БлокировкаОтправкиБыстрыхСообщений.Получить();
		
		// метод ТекущаяДатаСеанса() использовать нельзя.
		// Текущая дата сервера в данном случае используется в качестве ключа уникальности.
		Если БлокировкаОтправкиБыстрыхСообщений >= ТекущаяДата() Тогда
			ЗафиксироватьТранзакцию();
			Возврат Ложь;
		КонецЕсли;
		
		Константы.БлокировкаОтправкиБыстрыхСообщений.Установить(ТекущаяДата() + 60 * 5);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

Процедура ЗавершитьОтправкуБыстрыхСообщений()
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.БлокировкаОтправкиБыстрыхСообщений");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Константы.БлокировкаОтправкиБыстрыхСообщений.Установить(Дата('00010101'));
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ОтменитьОтправкуБыстрыхСообщений()
	
	ЗавершитьОтправкуБыстрыхСообщений();
	
КонецПроцедуры

Процедура УдалитьРегистрациюИзменений(КонечнаяТочка, Знач Сообщения)
	
	Для Каждого Сообщение Из Сообщения Цикл
		
		ПланыОбмена.УдалитьРегистрациюИзменений(КонечнаяТочка, Сообщение);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДоставитьСообщенияПолучателю(КонечнаяТочка, Знач Сообщения)
	
	Поток = "";
	
	ОбменСообщениямиВнутренний.СериализоватьДанныеВПоток(Сообщения, Поток);
	
	ОбменСообщениямиПовтИсп.WSПроксиКонечнойТочки(КонечнаяТочка, 10).DeliverMessages(ОбменСообщениямиВнутренний.КодЭтогоУзла(), Новый ХранилищеЗначения(Поток, Новый СжатиеДанных(9)));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий подсистем БСП

// Обработчик при выгрузке данных.
// Используется для переопределения стандартной обработки выгрузки данных.
// В данном обработчике должна быть реализована логика выгрузки данных:
// выборка данных для выгрузки, сериализация данных в файл сообщения или сериализация данных в поток.
// После выполнения обработчика выгруженные данные будут отправлены получателю подсистемой обмена данными.
// Формат сообщения для выгрузки может быть произвольным.
// В случае ошибок при отправке данных следует прерывать выполнение обработчика
// методом ВызватьИсключение с описанием ошибки.
//
// Параметры:
//
// СтандартнаяОбработка. Тип: Булево.
// В данный параметр передается признак выполнения стандартной (системной) обработки события.
// Если в теле процедуры-обработчика установить данному параметру значение Ложь, стандартная
// обработка события производиться не будет. Отказ от стандартной обработки не отменяет действие.
// Значение по умолчанию: Истина.
//
// Получатель (только для чтения). Тип: ПланОбменаСсылка.
// Узел плана обмена, для которого выполняется выгрузка данных.
//
// ИмяФайлаСообщения (только для чтения). Тип: Строка.
// Имя файла, в который необходимо выполнить выгрузку данных. Если этот параметр заполнен, то система ожидает,
// что данные будут выгружены в файл. После выгрузки система выполнит отправку данных из этого файла.
// Если параметр пустой, то система ожидает, что данные будут выгружены в параметр ДанныеСообщения.
//
// ДанныеСообщения. Тип: Произвольный.
// Если параметр ИмяФайлаСообщения пустой, то система ожидает, что данные будут выгружены в этот параметр.
//
// КоличествоЭлементовВТранзакции (только для чтения). Тип: Число.
// Определяет максимальное число элементов данных, которые помещаются в сообщение в рамках одной транзакции базы данных.
// При необходимости в обработчике следует реализовать логику установки транзакционных блокировок на выгружаемые данные.
// Значение параметра задается в настройках подсистемы обмена данными.
//
// ИмяСобытияЖурналаРегистрации (только для чтения). Тип: Строка.
// Имя события журнала регистрации текущего сеанса обмена данными. Используется для записи в журнал регистрации 
// данных (ошибок, предупреждений, информации) с заданным именем события.
// Соответствует параметру ИмяСобытия метода глобального контекста ЗаписьЖурналаРегистрации.
//
// КоличествоОтправленныхОбъектов. Тип: Число.
// Счетчик отправленных объектов. Используется для определения количества отправленных объектов
// для последующей фиксации в протоколе обмена.
//
Процедура ПриВыгрузкеДанныхСлужебный(СтандартнаяОбработка,
								Получатель,
								ИмяФайлаСообщения,
								ДанныеСообщения,
								КоличествоЭлементовВТранзакции,
								ИмяСобытияЖурналаРегистрации,
								КоличествоОтправленныхОбъектов
	) Экспорт
	
	ОбменСообщениямиВнутренний.ПриВыгрузкеДанных(СтандартнаяОбработка,
								Получатель,
								ИмяФайлаСообщения,
								ДанныеСообщения,
								КоличествоЭлементовВТранзакции,
								ИмяСобытияЖурналаРегистрации,
								КоличествоОтправленныхОбъектов);
	
КонецПроцедуры

// Обработчик при загрузке данных.
// Используется для переопределения стандартной обработки загрузки данных.
// В данном обработчике должна быть реализована логика загрузки данных:
// необходимые проверки перед загрузкой данных, сериализация данных из файла сообщения или сериализация данных из потока.
// Формат сообщения для загрузки может быть произвольным.
// В случае ошибок при получении данных следует прерывать выполнение обработчика
// методом ВызватьИсключение с описанием ошибки.
//
// Параметры:
//
// СтандартнаяОбработка. Тип: Булево.
// В данный параметр передается признак выполнения стандартной (системной) обработки события.
// Если в теле процедуры-обработчика установить данному параметру значение Ложь, стандартная обработка события производиться не будет.
// Отказ от стандартной обработки не отменяет действие.
// Значение по умолчанию: Истина.
//
// Отправитель (только для чтения). Тип: ПланОбменаСсылка.
// Узел плана обмена, для которого выполняется загрузка данных.
//
// ИмяФайлаСообщения (только для чтения). Тип: Строка.
// Имя файла, из которого требуется выполнить загрузку данных. Если параметр не заполнен, то данные для загрузки
// передаются через параметр ДанныеСообщения.
//
// ДанныеСообщения. Тип: Произвольный.
// Параметр содержит данные, которые необходимо загрузить. Если параметр ИмяФайлаСообщения пустой,
// то данные для загрузки передаются через этот параметр.
//
// КоличествоЭлементовВТранзакции (только для чтения). Тип: Число.
// Определяет максимальное число элементов данных, которые читаются из сообщения и записываются в базу данных
// в рамках одной транзакции. При необходимости в обработчике следует реализовать логику записи данных в транзакции.
// Значение параметра задается в настройках подсистемы обмена данными.
//
// ИмяСобытияЖурналаРегистрации (только для чтения). Тип: Строка.
// Имя события журнала регистрации текущего сеанса обмена данными. Используется для записи в журнал регистрации
// данных (ошибок, предупреждений, информации) с заданным именем события.
// Соответствует параметру ИмяСобытия метода глобального контекста ЗаписьЖурналаРегистрации.
//
// КоличествоПолученныхОбъектов. Тип: Число.
// Счетчик полученных объектов. Используется для определения количества загруженных объектов
// для последующей фиксации в протоколе обмена.
//
Процедура ПриЗагрузкеДанныхСлужебный(СтандартнаяОбработка,
								Отправитель,
								ИмяФайлаСообщения,
								ДанныеСообщения,
								КоличествоЭлементовВТранзакции,
								ИмяСобытияЖурналаРегистрации,
								КоличествоПолученныхОбъектов
	) Экспорт
	
	ОбменСообщениямиВнутренний.ПриЗагрузкеДанных(СтандартнаяОбработка,
								Отправитель,
								ИмяФайлаСообщения,
								ДанныеСообщения,
								КоличествоЭлементовВТранзакции,
								ИмяСобытияЖурналаРегистрации,
								КоличествоПолученныхОбъектов);
	
КонецПроцедуры

// Заполняет структуру массивами поддерживаемых версий всех подлежащих версионированию подсистем,
// используя в качестве ключей названия подсистем.
// Обеспечивает функциональность Web-сервиса InterfaceVersion.
// При внедрении надо поменять тело процедуры так, чтобы она возвращала актуальные наборы версий (см. пример.ниже).
//
// Параметры:
// СтруктураПоддерживаемыхВерсий - Структура: 
//	- Ключи = Названия подсистем. 
//	- Значения = Массивы названий поддерживаемых версий.
//
// Пример реализации:
//
//	// СервисПередачиФайлов
//	МассивВерсий = Новый Массив;
//	МассивВерсий.Добавить("1.0.1.1");	
//	МассивВерсий.Добавить("1.0.2.1"); 
//	СтруктураПоддерживаемыхВерсий.Вставить("СервисПередачиФайлов", МассивВерсий);
//	// Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(Знач СтруктураПоддерживаемыхВерсий) Экспорт
	
	МассивВерсий = Новый Массив;
	МассивВерсий.Добавить("2.0.1.6");
	МассивВерсий.Добавить("2.1.1.7");
	МассивВерсий.Добавить("2.1.1.8");
	СтруктураПоддерживаемыхВерсий.Вставить("ОбменСообщениями", МассивВерсий);
	
КонецПроцедуры

// Заполняет массив типов, исключаемых из выгрузки и загрузки данных.
//
// Параметры:
//  Типы - Массив(Типы).
//
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	МассивСправочников = ОбменСообщениямиПовтИсп.ПолучитьСправочникиСообщений();
	Для Каждого СправочникСообщений Из МассивСправочников Цикл
		Типы.Добавить(СправочникСообщений.ПустаяСсылка().Метаданные());
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы

// Обработчик события при отправке сообщения.
// Обработчик данного события вызывается перед помещением сообщения в XML-поток.
// Обработчик вызывается для каждого отправляемого сообщения.
//
//  Параметры:
// КаналСообщений (только чтение) Тип: Строка. Идентификатор канала сообщений, в который отправляется сообщение.
// ТелоСообщения (чтение и запись) Тип: Произвольный. Тело отправляемого сообщения.
// В обработчике события тело сообщения может быть изменено, например, дополнено информацией.
//
Процедура ПриОтправкеСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		
		МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
		МодульСообщенияВМоделиСервиса.ПриОтправкеСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события при получении сообщения.
// Обработчик данного события вызывается при получении сообщения из XML-потока.
// Обработчик вызывается для каждого получаемого сообщения.
//
//  Параметры:
// КаналСообщений (только чтение) Тип: Строка. Идентификатор канала сообщений, из которого получено сообщение.
// ТелоСообщения (чтение и запись) Тип: Произвольный. Тело полученного сообщения.
// В обработчике события тело сообщения может быть изменено, например, дополнено информацией.
//
Процедура ПриПолученииСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
		МодульСообщенияВМоделиСервиса.ПриПолученииСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения);
	КонецЕсли;
	
КонецПроцедуры
