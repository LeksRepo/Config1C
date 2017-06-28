﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОшибкаЗагрузкиДляОС = Ложь;
	
	АдресныеОбъектыПереданные = ?(Параметры.Свойство("АдресныеОбъекты"), Параметры.АдресныеОбъекты, Неопределено);
	
	ЗаполнитьТаблицуАдресныхОбъектов(АдресныеОбъектыПереданные);
	
	ИсточникДанныхДляЗагрузки = 0;
	ПутьКФайламДанныхНаДиске = "";
	ДискИТС = "";
	
	Если АдресныеОбъектыПереданные = Неопределено Тогда
		ЗагрузитьСохраненныеПараметрыЗагрузки();
	Иначе
		ИсточникДанныхДляЗагрузки = 1;
	КонецЕсли;
	
	ОшибкаЗагрузкиДляОС = ПроверитьОшибкуЗагрузкиДляОС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
#Если ВебКлиент Тогда
	Отказ = Истина;
	ПоказатьПредупреждение(, НСтр("ru = 'Загрузка адресного классификатора не доступна в веб-клиенте.'"));
#Иначе
	Если ОшибкаЗагрузкиДляОС Тогда 
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru = 'Загрузка адресного классификатора не доступна на сервере под управлением Linux/x86-64.'"));
	КонецЕсли;
#КонецЕсли
	
	Если Не Отказ Тогда
		УстановитьИзмененияВИнтерфейсе();
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	Если ИдентификаторЗадания<>Неопределено Тогда
		ОтменитьПроцессЗагрузки(ИдентификаторЗадания);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

// Обработчик события НачалоВыбора поля ввода формы ПутьКФайламДанныхНаДиске.
// Вызывает диалог выбора  директории, после выбора проверяет, существуют
// ли в выбранной директории файлы данных.
//
&НаКлиенте
Процедура ПутьКФайламДанныхНаДискеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
#Если Не ВебКлиент Тогда
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выбор каталога с файлами адресных сведений'");
	ДиалогОткрытияФайла.Каталог = Элементы.ПутьКФайламДанныхНаДиске.ТекстРедактирования;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ПутьКФайламДанныхНаДиске = ДиалогОткрытияФайла.Каталог;
		
		ОчиститьСообщения();
		
		Если АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловДанныхВКаталоге(ПутьКФайламДанныхНаДиске) Тогда
			УстановитьИзмененияВИнтерфейсе ();
		Иначе
			СообщениеПользователю = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Файлы адресных сведений не найдены в каталоге ""%1"".'"),
				ПутьКФайламДанныхНаДиске);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "ПутьКФайламДанныхНаДиске");
		КонецЕсли;
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

// Обработчик события НачалоВыбора поля ввода формы ДискИТС.
// Вызывает диалог выбора директории, после выбора проверяет, существуют
// ли в выбранной директории файлы архивов данных.
//
&НаКлиенте
Процедура ДискИТСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
#Если Не ВебКлиент Тогда
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выбор пути к диску 1С:ИТС'");
	ДиалогОткрытияФайла.Каталог = ДискИТС;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ДискИТС = ДиалогОткрытияФайла.Каталог;
		
		ФайлыСуществуют = АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловНаДискеИТС(ДискИТС);
		
		ОчиститьСообщения();
		
		Если ФайлыСуществуют Тогда
			УстановитьИзмененияВИнтерфейсе();
		Иначе
			СообщениеПользователю = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Файлы адресных сведений не найдены: ""%1"".
			               |Проверьте правильность указанного пути к диску 1С:ИТС.'"),
				ДискИТС);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "ДискИТС");
		КонецЕсли;
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

// Обработчик события выбора поля таблицы "ЭлементАдресныйОбъект"
// Изменяет статус загрузки адресного объекта поля на противоположный
//
&НаКлиенте
Процедура ТаблицаАдресныхОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Элемент.ТекущиеДанные.Пометка = Не Элемент.ТекущиеДанные.Пометка;
	ОтметитьОбязательные(ЭтотОбъект);
	ВыбраноРегионовДляЗагрузки = КоличествоОтмеченныхАдресныхОбъектов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаАдресныхОбъектовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОтметитьОбязательные(ЭтотОбъект);
	ВыбраноРегионовДляЗагрузки = КоличествоОтмеченныхАдресныхОбъектов();
	
КонецПроцедуры

// Обработчик события ПриИзменении поля переключателя ИсточникДанныхДляЗагрузки
// Устанавливает параметры видимости элементов (параметров вида загрузки) 
// в зависимости от значения переключателя.
//
&НаКлиенте
Процедура СпособЗагрузкиПриИзменении(Элемент)
	
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьВсе()
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъектыДляЗагрузки Цикл
		ЭлементАдресныйОбъект.Пометка = Истина;
	КонецЦикла;
	
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметкуСоВсех()
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъектыДляЗагрузки Цикл
		ЭлементАдресныйОбъект.Пометка = Ложь;
	КонецЦикла;
	
	ОтметитьОбязательные(ЭтотОбъект);
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВыполнить()
	ОчиститьСообщения();
	
	УстановитьДоступностьКнопокПриЗагрузке(Ложь);
	
	// Подготавливаем массив адресных объектов для загрузки
	ОбъектыЗагрузки = ВыбранныеОбъектыЗагрузки();
	
	// Смотрим на источник данных
	Если ИсточникДанныхДляЗагрузки = 1 Тогда
		// Загрузка с сайта
		Аутентификация = СохраненныеДанныеАутентификацииСервер();
		Если Аутентификация = Неопределено Тогда
			// Нет сохраненных данных, проходим через форму авторизации
			Оповещение = Новый ОписаниеОповещения("ЗагрузитьФайлыКЛАДРСайтПодтверждениеАутентификации", ЭтотОбъект, Новый Структура);
			Оповещение.ДополнительныеПараметры.Вставить("ОбъектыЗагрузки", ОбъектыЗагрузки);
			
			ОткрытьФорму("РегистрСведений.АдресныйКлассификатор.Форма.АвторизацияНаПользовательскомСайте",,ЭтаФорма,,,,
				Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс
			);
			Возврат;
		КонецЕсли;
		ЗагрузитьФайлыКЛАДРСайт(ОбъектыЗагрузки, Аутентификация);
		
	ИначеЕсли ИсточникДанныхДляЗагрузки=2 Тогда
		// Загрузка с диска ИТС
#Если ВебКлиент Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'В веб-клиенте загрузка с диска ИТС недоступна.'"));
		Возврат;
#Иначе
		ЗагрузитьФайлыКЛАДРДискИТС(ОбъектыЗагрузки);
#КонецЕсли
		
	ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
		// Загрузка с файловой системы клиента
		ЗагрузитьФайлыКЛАДРДиск(ОбъектыЗагрузки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлыКЛАДРСайтПодтверждениеАутентификации(Знач РезультатЗакрытия, Знач ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьФайлыКЛАДРСайт(ДополнительныеПараметры.ОбъектыЗагрузки, РезультатЗакрытия);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлыКЛАДРСайт(Знач ОбъектыЗагрузки, Знач Аутентификация) 
	Перем ПутьКДанным;
	
	// Первый файл есть всегда, там сокращения
	Результат = АдресныйКлассификаторКлиент.ЗагрузитьКЛАДРСВебСервера(ОбъектыЗагрузки[0], Аутентификация, ПутьКДанным);
	Если Не Результат.Статус Тогда
		// Ошибка загрузки первого файла, возможно некорректная аутентификация, выводим на вопрос
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Ошибка загрузки файлов КЛАДР с сайта 1С.
			         |%1'"), 
			Результат.СообщениеОбОшибке));
			
		Оповещение = Новый ОписаниеОповещения("ЗагрузитьФайлыКЛАДРСайтПодтверждениеАутентификации", ЭтотОбъект, Новый Структура);
		Оповещение.ДополнительныеПараметры.Вставить("ОбъектыЗагрузки", ОбъектыЗагрузки);
		
		ОткрытьФорму("РегистрСведений.АдресныйКлассификатор.Форма.АвторизацияНаПользовательскомСайте",,ЭтаФорма,,,,
			Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс
		);
		
		УдалитьЗагруженныеФайлы(ПутьКДанным);
		Возврат;
	КонецЕсли;
	
	// Теперь ПутьКДанным указывает каталог, куда будут загружены файлы на клиенте
	
	// Загружаем остальные файлы
	Для Позиция=1 По ОбъектыЗагрузки.ВГраница() Цикл
		ОбъектЗагрузки = ОбъектыЗагрузки[Позиция];
		УстановитьСтатусЗагрузки(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Загрузка файлов адресных сведений с веб-сервера: регион %1'"), ОбъектЗагрузки
		));
		
		Результат = АдресныйКлассификаторКлиент.ЗагрузитьКЛАДРСВебСервера(ОбъектЗагрузки, Аутентификация, ПутьКДанным);
		Если Не Результат.Статус Тогда
			Текст = Новый ФорматированнаяСтрока(
				НСтр("ru='Ошибка загрузки файлов КЛАДР с сайта 1С.
				         |Подробности в'"), " ",
				Новый ФорматированнаяСтрока(
					НСтр("ru='журнале регистрации'"),,,,"e1cib/app/Обработка.ЖурналРегистрации"
				)
			);
			УстановитьСтатусЗагрузки("");
			ПоказатьПредупреждение(, Текст);
			
			УдалитьЗагруженныеФайлы(ПутьКДанным);
			Возврат;
		КонецЕсли;
	КонецЦикла;
	УстановитьСтатусЗагрузки("");
	
	// Передаем файлы на сервер и продолжаем загрузку
	ЗагрузитьФайлыКЛАДР(ПутьКДанным, ОбъектыЗагрузки, 1);
КонецПроцедуры

&НаКлиенте 
Процедура УдалитьЗагруженныеФайлы(Путь)
	Попытка
		УдалитьФайлы(Путь);
	Исключение
		// Будут удалены при перезапуске сеанса, обработка не требуется
	КонецПопытки;
КонецПроцедуры

// Параметры:
//     КаталогКлиента     - Строка - путь на клиенте, где расположены исходные файлы
//     ОбъектыДляЗагрузки - Массив - регионы для загрузки
//     ИсточникДанных     - Число  - код источника данных: 1 - сайт 2 - ИТС, 3 - диск
&НаКлиенте
Процедура ЗагрузитьФайлыКЛАДР(Знач КаталогКлиента, Знач ОбъектыЗагрузки, Знач ИсточникДанных)
	
	// Передаем файлы на сервер
	Путь = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(СокрЛП(КаталогКлиента));
	
	УстановитьСтатусЗагрузки(НСтр("ru = 'Передача файлов адресных сведений на сервер приложения.'"));
	ПереданныеФайлы = Новый Массив;
	Попытка
		Если Не ПоместитьФайлы( , ПереданныеФайлы, Путь + "*.*", Ложь, ЭтотОбъект.УникальныйИдентификатор) Тогда
			ПереданныеФайлы = "";
		КонецЕсли;
	Исключение
		// Получаем строковое описание ошибки
		ПереданныеФайлы = ЗаписьИнформацииОбОшибке( ИнформацияОбОшибке() );
	КонецПопытки;
	
	Если ТипЗнч(ПереданныеФайлы)<>Тип("Массив") Тогда
		Текст = Новый ФорматированнаяСтрока(
			НСтр("ru='Ошибка передачи файлов КЛАДР на сервер.'"), Символы.ПС,
			ПереданныеФайлы, Символы.ПС,
			НСтр("ru='Подробности в'"), " ", Новый ФорматированнаяСтрока(
				НСтр("ru='журнале регистрации'"),,,,"e1cib/app/Обработка.ЖурналРегистрации"
			)
		);
		ПоказатьПредупреждение(, Текст);
		
		УстановитьСтатусЗагрузки("");
		Возврат;
	КонецЕсли;
	
	// И запускаем загрузку на сервере в фоновом задании
	УстановитьСтатусЗагрузки(НСтр("ru = 'Загрузка адресных сведений в программу.'"));
	
	Результат = ЗагрузитьФайлыКЛАДРСервер(ОбъектыЗагрузки, ПереданныеФайлы, ИсточникДанных);
	Если Результат.ЗаданиеВыполнено Тогда
		// Готово
		ИдентификаторЗадания = Неопределено;
		УстановитьСтатусЗагрузки("");
	Иначе
		// Ожидаем выполнения 
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	КонецЕсли;
	
	ОбновитьСодержание(Результат);
КонецПроцедуры

&НаСервере 
Функция ЗагрузитьФайлыКЛАДРСервер(Знач ОбъектыЗагрузки, Знач ПереданныеФайлы, Знач ИсточникДанных)
	
	Возврат АдресныйКлассификатор.ОбработатьФайлыКЛАДР(ОбъектыЗагрузки, ПереданныеФайлы, ИсточникДанных, ЭтотОбъект.УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Функция ЗаписьИнформацииОбОшибке(Знач Информация)
	ЗаписьЖурналаРегистрации(АдресныйКлассификатор.СобытиеЖурналаРегистрации(), 
		УровеньЖурналаРегистрации.Ошибка, , ПодробноеПредставлениеОшибки(Информация));
		
	Возврат КраткоеПредставлениеОшибки(Информация);
КонецФункции

&НаКлиенте
Процедура ЗагрузитьФайлыКЛАДРДискИТС(Знач ОбъектыЗагрузки) 
	// На ИТС сейчас поставляются *.exe, представляющие собой самораспаковывающийся RAR
	// В целях безопасности запускаем их на клиенте
	
#Если Не ВебКлиент Тогда
	КаталогКлиента = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла());
	СоздатьКаталог(КаталогКлиента);
	
	КаталогИТС = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ДискИТС) 
	           + АдресныйКлассификаторКлиент.ПутьККаталогуСДаннымиКЛАДРНаДискеИТС(ДискИТС);
	Для Каждого Файл Из НайтиФайлы(КаталогИТС, "*.exe", Ложь) Цикл
		Команда = """" + Файл.ПолноеИмя + """ -s -d """ + КаталогКлиента + """";
		ЗапуститьПриложение(Команда, КаталогКлиента, Истина);
	КонецЦикла;
	
	ЗагрузитьФайлыКЛАДР(КаталогКлиента, ОбъектыЗагрузки,  2)
#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлыКЛАДРДиск(Знач ОбъектыЗагрузки) 
	ЗагрузитьФайлыКЛАДР(ПутьКФайламДанныхНаДиске, ОбъектыЗагрузки,  3)
КонецПроцедуры

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ОчиститьСообщения();
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборАдресныхОбъектов Тогда
		Если КоличествоОтмеченныхАдресныхОбъектов() = 0 Тогда
			СообщениеПользователю = НСтр("ru = 'Необходимо выбрать хотя бы один регион для загрузки адресных сведений.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "АдресныеОбъектыДляЗагрузки");
			Возврат;
		КонецЕсли;
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
		УстановитьИзмененияВИнтерфейсе();
		
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника Тогда
		Если ИсточникДанныхДляЗагрузки = 2
			И (ПустаяСтрока(ДискИТС) Или Не АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловНаДискеИТС(ДискИТС)) 
		Тогда
			СообщениеПользователю = НСтр("ru = 'Проверьте правильность указания пути к диску 1С:ИТС.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "ДискИТС");
			Возврат;
			
		ИначеЕсли ИсточникДанныхДляЗагрузки = 3
				И (ПустаяСтрока(ПутьКФайламДанныхНаДиске) Или Не АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловДанныхВКаталоге(ПутьКФайламДанныхНаДиске))
		Тогда
			СообщениеПользователю = НСтр("ru = 'Проверьте правильность указания пути, а также состав файлов КЛАДР.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "ПутьКФайламДанныхНаДиске");
			Возврат;
		КонецЕсли;
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагрузка;
		УстановитьИзмененияВИнтерфейсе();
		
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагрузка Тогда
		ЗагрузитьВыполнить();

	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаУспех Тогда
		
		Закрыть(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборАдресныхОбъектов;
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагрузка Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
	КонецЕсли;
	
	УстановитьИзмененияВИнтерфейсе();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПерейтиНаСтраницуВыбораИсточника()
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
	УстановитьИзмененияВИнтерфейсе();
КонецПроцедуры

&НаСервере
Функция ПроверитьОшибкуЗагрузкиДляОС()
	
	ИнформацияОСервере = Новый СистемнаяИнформация;
	Если ИнформацияОСервере.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда 
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступностьКнопокПриЗагрузке(Флаг = Истина)
	
	Элементы.Назад.Видимость = Флаг;
	Элементы.Далее.Видимость = Флаг;
	
	ОбновитьИнтерфейс();
КонецПроцедуры

&НаСервере
Процедура СохранитьПараметрыЗагрузки()
	
	МассивЗагружаемыхАО = Новый Массив;
	
	Для Каждого ЭлементАО Из АдресныеОбъектыДляЗагрузки Цикл
		Если ЭлементАО.Пометка Тогда
			МассивЗагружаемыхАО.Добавить(Лев(ЭлементАО.НаименованиеАдресногоОбъекта, 2));
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ПараметрыЗагрузкиАдресногоКлассификатора", "ЗагружаемыеРегионы", МассивЗагружаемыхАО);
	
	ИсточникКЛАДР = Новый Структура("ИсточникДанныхДляЗагрузки");
	ИсточникКЛАДР.ИсточникДанныхДляЗагрузки = ИсточникДанныхДляЗагрузки;
	
	Если ИсточникДанныхДляЗагрузки = 2 Тогда
		ИсточникКЛАДР.Вставить("ДискИТС", ДискИТС);
	ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
		ИсточникКЛАДР.Вставить("ПутьКФайламДанныхНаДиске", ПутьКФайламДанныхНаДиске);
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ПараметрыЗагрузкиАдресногоКлассификатора", "ИсточникКЛАДР", ИсточникКЛАДР);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСохраненныеПараметрыЗагрузки()
	
	ИсточникКЛАДР = ЗагрузитьНастройкуЗагрузкиКЛАДР("ИсточникКЛАДР");
	
	Если ИсточникКЛАДР <> Неопределено Тогда
		ИсточникДанныхДляЗагрузки = ИсточникКЛАДР.ИсточникДанныхДляЗагрузки;
		Если ИсточникДанныхДляЗагрузки = 2 Тогда
			ДискИТС = ИсточникКЛАДР.ДискИТС;
		ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
			ПутьКФайламДанныхНаДиске = ИсточникКЛАДР.ПутьКФайламДанныхНаДиске;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Получает значение из системного хранилища настроек ИБ
//
&НаСервереБезКонтекста
Функция ЗагрузитьНастройкуЗагрузкиКЛАДР(КлючНастроек)
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПараметрыЗагрузкиАдресногоКлассификатора", КлючНастроек);
	
КонецФункции

// Устанавливает текст статус загрузки
//
&НаКлиенте
Процедура УстановитьСтатусЗагрузки(Знач Сообщение = "")
	
	СтатусЗагрузки = НСтр("ru = 'Пожалуйста, подождите...'") + Символы.ПС + Сообщение;
	СтраницаСтатусаЗагрузки = ?(ПустаяСтрока(Сообщение), Элементы.ГруппаПустаяГруппа, Элементы.СтраницаСтатусЗагрузки);
	Элементы.СтраницыЗагрузки.ТекущаяСтраница = СтраницаСтатусаЗагрузки;
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагрузка Тогда
		СостояниеЗагрузки = СостояниеЗадания(ИдентификаторЗадания);
		Если СостояниеЗагрузки = 0 Тогда
			// Выполнено успешно
			ИдентификаторЗадания = Неопределено;
			ОбновитьСодержание(Новый Структура("РезультатЗагрузки", ПолучитьИзВременногоХранилища(АдресХранилища)) );
			
		ИначеЕсли СостояниеЗагрузки < 0 Тогда
			// Завершено аварийно, сообщения показаны
			ИдентификаторЗадания = Неопределено;
			ПерейтиНаСтраницуВыбораИсточника();
			
		Иначе
			// Процесс продолжается
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры	

// Возвращаемое значение:
//     -1, если завершено с ошибкой
//      0, если завершено или отменено
//      1, если все еще работает
//
&НаСервереБезКонтекста
Функция СостояниеЗадания(ИдентификаторЗадания)
	
	// Оставим запись в логах
	Попытка
		ФлагВыполнения = ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания)
	Исключение
		// Запись в журнал регистрации уже сделана
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат -1;
	КонецПопытки;
	
	Если Не ФлагВыполнения Тогда
		Возврат 1
	КонецЕсли;
	
	// Проверим дополнительно
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если Задание=Неопределено Тогда
		Возврат 0;
	ИначеЕсли Задание.Состояние=СостояниеФоновогоЗадания.Отменено Тогда
		Возврат 0;
	ИначеЕсли Задание.Состояние=СостояниеФоновогоЗадания.Завершено Тогда
		Возврат 0;
	ИначеЕсли Задание.Состояние=СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		Возврат -1;
	КонецЕсли;
	
	Возврат 1;
КонецФункции

&НаКлиенте
Процедура ОбновитьСодержание(Результат)
	
	Если Не Результат.Свойство("РезультатЗагрузки") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьДоступностьКнопокПриЗагрузке();
	
	ОбщегоНазначенияКлиентСервер.УдалитьКаталогСФайлами(Результат.РезультатЗагрузки.ПутьКДанным);
	ПутьКДаннымНаСервере = Результат.РезультатЗагрузки.ПутьКДаннымНаСервере;
	
	Если Не ПустаяСтрока(Результат.РезультатЗагрузки.СообщениеПользователю) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.РезультатЗагрузки.СообщениеПользователю);
	КонецЕсли;
	
	Если Результат.РезультатЗагрузки.СтатусВыполнения Тогда 
		// Успешно загружено
		Оповестить("Запись_АдресныйКлассификатор", Новый Структура("Событие", "Загрузить"));
		
		СохранитьПараметрыЗагрузки();
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаУспех;
		УстановитьИзмененияВИнтерфейсе();
		
		ОчиститьСообщения();
	КонецЕсли;
	
КонецПроцедуры

// Заполняет переданную таблицу значений по значениям таблицы адресных объектов.
// Выбирается код, наименование и сокращение типа объекта.
//
&НаСервере
Процедура ЗаполнитьТаблицуАдресныхОбъектов(ЗаданныеРегионыДляЗагрузки)
	
	МассивЗагружаемыхАО = ЗагрузитьНастройкуЗагрузкиКЛАДР("ЗагружаемыеРегионы");
	
	АдресныеОбъектыДляЗагрузки.Очистить();
	
	КлассификаторАдресныхОбъектовXML =
	РегистрыСведений.АдресныйКлассификатор.ПолучитьМакет("КлассификаторАдресныхОбъектовРоссии").ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторАдресныхОбъектовXML).Данные;
	
	Для Каждого АдресныйОбъект Из КлассификаторТаблица Цикл
		
		Наименование = СокрЛП(Лев(АдресныйОбъект.Code, 2) + " - " + АдресныйОбъект.Name + " " + АдресныйОбъект.Socr);
		
		НоваяСтрока = АдресныеОбъектыДляЗагрузки.Добавить();
		НоваяСтрока.НаименованиеАдресногоОбъекта = Наименование;
		
		Если ЗаданныеРегионыДляЗагрузки <> Неопределено Тогда
			//
			Если ЗаданныеРегионыДляЗагрузки.Найти(Лев(АдресныйОбъект.Code, 2)) <> Неопределено Тогда
				НоваяСтрока.Пометка = Истина;
			Иначе
				НоваяСтрока.Пометка = Ложь;
			КонецЕсли;
			//
		ИначеЕсли МассивЗагружаемыхАО <> Неопределено Тогда
			//
			Если МассивЗагружаемыхАО.Найти(Лев(АдресныйОбъект.Code, 2)) <> Неопределено Тогда
				НоваяСтрока.Пометка = Истина;
			Иначе
				НоваяСтрока.Пометка = Ложь;
			КонецЕсли;
		Иначе
			НоваяСтрока.Пометка = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗаданныеРегионыДляЗагрузки <> Неопределено Тогда
		//
		Если ЗаданныеРегионыДляЗагрузки.Найти("AL") <> Неопределено Тогда
			АдресныйОбъект = АдресныйКлассификатор.ИнформацияПоАдресномуОбъекту("AL");
			НоваяСтрока = АдресныеОбъектыДляЗагрузки.Добавить();
			НоваяСтрока.НаименованиеАдресногоОбъекта = СокрЛП(Лев(АдресныйОбъект.КодАдресногоОбъекта, 2) + " - " + АдресныйОбъект.Наименование);
			НоваяСтрока.Пометка = Истина;
			ОбязательныеАдресныеОбъекты.Добавить(НоваяСтрока.ПолучитьИдентификатор());
		КонецЕсли;
		//
		Если ЗаданныеРегионыДляЗагрузки.Найти("SO") <> Неопределено Тогда
			АдресныйОбъект = АдресныйКлассификатор.ИнформацияПоАдресномуОбъекту("SO");
			НоваяСтрока = АдресныеОбъектыДляЗагрузки.Добавить();
			НоваяСтрока.НаименованиеАдресногоОбъекта = СокрЛП(Лев(АдресныйОбъект.КодАдресногоОбъекта, 2) + " - " + АдресныйОбъект.Наименование);
			НоваяСтрока.Пометка = Истина;
			ОбязательныеАдресныеОбъекты.Добавить(НоваяСтрока.ПолучитьИдентификатор());
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает количество помеченных адресных объектов
//
&НаКлиенте
Функция КоличествоОтмеченныхАдресныхОбъектов()
	
	КоличествоОтмеченныхАдресныхОбъектов = 0;
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъектыДляЗагрузки Цикл
		Если ЭлементАдресныйОбъект.Пометка Тогда
			КоличествоОтмеченныхАдресныхОбъектов = КоличествоОтмеченныхАдресныхОбъектов + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат КоличествоОтмеченныхАдресныхОбъектов;
	
КонецФункции

// В зависимости от текущей страницы устанавливает доступность тех или иных полей для пользователя
//
&НаКлиенте
Процедура УстановитьИзмененияВИнтерфейсе()
	
	ИсточникДанныхДляЗагрузкиВыбран = ИсточникДанныхДляЗагрузкиВыбран();
	ВыбраноРегионовДляЗагрузки = КоличествоОтмеченныхАдресныхОбъектов();
	
	Элементы.Далее.Заголовок = НСтр("ru = 'Далее >'");
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборАдресныхОбъектов Тогда
		Элементы.Назад.Видимость = Ложь;
		Элементы.Далее.Доступность = Истина;
		
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника Тогда
		Элементы.Назад.Видимость = Истина;
		Элементы.Назад.Доступность = Истина;
		Элементы.Далее.Доступность = Истина;
		
		Если ИсточникДанныхДляЗагрузки = 0 Тогда
			ИсточникДанныхДляЗагрузки = 1;
		КонецЕсли;
		
		Если ИсточникДанныхДляЗагрузки = 2 Тогда
			Элементы.СтраницыСпособаЗагрузки.ТекущаяСтраница = Элементы.СтраницаЗагрузкаСДискаИТС;
		ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
			Элементы.СтраницыСпособаЗагрузки.ТекущаяСтраница = Элементы.СтраницаЗагрузкаФайлов;
		Иначе
			Элементы.СтраницыСпособаЗагрузки.ТекущаяСтраница = Элементы.ПустаяСтраница;
		КонецЕсли;
		
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагрузка Тогда
		Элементы.Назад.Доступность = Истина;
		Элементы.Далее.Доступность = Истина;
		
		Элементы.Далее.Заголовок = НСтр("ru = 'Загрузить'");
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаУспех Тогда
		Элементы.Назад.Видимость = Ложь;
		Элементы.Далее.Видимость = Истина;
		Элементы.Далее.Доступность = Истина;
		Элементы.Отмена.Видимость = Ложь;
		
		Элементы.Далее.Заголовок = НСтр("ru = 'Закрыть'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ИсточникДанныхДляЗагрузкиВыбран()
	
	ИсточникВыбран = Ложь;
	
	Если ИсточникДанныхДляЗагрузки = 1 Тогда
		ИсточникВыбран = Истина;
	ИначеЕсли ИсточникДанныхДляЗагрузки = 2 Тогда
		Если АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловНаДискеИТС(ДискИТС) Тогда
			ИсточникВыбран = Истина;
		КонецЕсли;
	ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
		Если АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловДанныхВКаталоге(ПутьКФайламДанныхНаДиске) Тогда
			ИсточникВыбран = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИсточникВыбран;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОтметитьОбязательные(Контекст)
	
	Для каждого Описание Из Контекст.ОбязательныеАдресныеОбъекты Цикл
		Контекст.АдресныеОбъектыДляЗагрузки.НайтиПоИдентификатору(Описание.Значение).Пометка = Истина;
	КонецЦикла
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьПроцессЗагрузки(ИдентификаторЗадания)
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
КонецПроцедуры

&НаКлиенте
Функция ВыбранныеОбъектыЗагрузки()
	Результат = Новый Массив;
	
	// Первыми всегда идут сокращения
	ИмяСокращений = "SO";
	Результат.Добавить(ИмяСокращений);
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъектыДляЗагрузки Цикл
		Идентификатор = ВРег(Лев(ЭлементАдресныйОбъект.НаименованиеАдресногоОбъекта, 2));
		Если ЭлементАдресныйОбъект.Пометка И Идентификатор<>ИмяСокращений Тогда
			Результат.Добавить(Идентификатор);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаСервере
Функция СохраненныеДанныеАутентификацииСервер()
	Перем КодПользователя, Пароль;
	
	АдресныйКлассификатор.ПолучитьПараметрыАутентификации(КодПользователя, Пароль);
	
	Возврат Новый Структура("КодПользователя, Пароль", КодПользователя, Пароль);
КонецФункции
