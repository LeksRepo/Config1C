﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновитьСписокВыбораПлановОбмена();
	
	ОбновитьСписокВыбораМакетаПравил();
	
	ОбновитьИнформациюОПравилах();
	
	ОбновитьИсточникПравил();
	
	УстановитьВидимость();
	
	СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными = ОбменДаннымиСервер.СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ИсточникПравил <> 0 И ПустаяСтрока(Запись.ИмяФайлаПравил) Тогда
		Предупреждение(Нстр("ru = 'Укажите файл правил обмена.'"));
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ИмяПланаОбменаПриИзменении(Элемент)
	
	Запись.ИмяМакетаПравил = "";
	
	// вызов сервера
	ОбновитьСписокВыбораМакетаПравил();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникПравилПриИзменении(Элемент)
	
	// вызов сервера
	УстановитьВидимость();
	
	Запись.РежимОтладки = (ИсточникПравил = 2);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтладкуВыгрузкиПриИзменении(Элемент)
	
	Элементы.ВнешняяОбработкаДляОтладкиВыгрузки.Доступность = Запись.РежимОтладкиВыгрузки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешняяОбработкаДляОтладкиВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайла(Запись, "ИмяФайлаОбработкиДляОтладкиВыгрузки", СтандартнаяОбработка, НСтр("ru = 'Внешняя обработка(*.epf)|*.epf'"), Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешняяОбработкаДляОтладкиЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайла(Запись, "ИмяФайлаОбработкиДляОтладкиЗагрузки", СтандартнаяОбработка, НСтр("ru = 'Внешняя обработка(*.epf)|*.epf'"), Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтладкуЗагрузкиПриИзменении(Элемент)
	
	Элементы.ВнешняяОбработкаДляОтладкиЗагрузки.Доступность = Запись.РежимОтладкиЗагрузки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьПротоколированиеОбменаДаннымиПриИзменении(Элемент)
	
	Элементы.ФайлПротоколаОбмена.Доступность = Запись.РежимПротоколированияОбменаДанными;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлПротоколаОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайла(Запись, "ИмяФайлаПротоколаОбмена", СтандартнаяОбработка, НСтр("ru = 'Текстовый документ(*.txt)|*.txt'"), Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлПротоколаОбменаОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикОткрытияФайлаИлиКаталога(Запись, "ИмяФайлаПротоколаОбмена", СтандартнаяОбработка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗагрузитьПравила(Команда)
	
	Перем АдресВременногоХранилища;
	Перем ВыбранноеИмяФайла;
	
	Отказ = Ложь;
	
	ИмяФайлаПравил = "";
	ЭтоАрхив = Ложь;
	
	Если ИсточникПравил = 1 Или ИсточникПравил = 2 Тогда // из файла

		ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
		
		Если ПодключитьРасширениеРаботыСФайлами()Тогда
			
			// Предложение пользователю выбрать файл правил для загрузки
			Режим = РежимДиалогаВыбораФайла.Открытие;
			ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
			РасширениеФайла = НРег(Прав(Запись.ИмяФайлаПравил, 4));
			ИмяФайлаБезРасширения = СтрЗаменить(Запись.ИмяФайлаПравил, РасширениеФайла, "");
			ДиалогОткрытияФайла.ПолноеИмяФайла = ИмяФайлаБезРасширения;
			Фильтр = НСтр("ru = 'Файлы правил'") + "(*.xml)|*.xml|"
			+ НСтр("ru = 'Архивы ZIP'") + "(*.zip)|*.zip";
			ДиалогОткрытияФайла.Фильтр = Фильтр;
			Если НРег(Прав(Запись.ИмяФайлаПравил, 4)) = ".zip" Тогда
				ДиалогОткрытияФайла.ИндексФильтра = 1;
			Иначе
				ДиалогОткрытияФайла.ИндексФильтра = 0;
			КонецЕсли;
			ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
			ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Укажите из какого файла загрузить правила'");
			
			// Если файл выбран - помещаем его в хранилище для последующей загрузки на сервере
			Если ДиалогОткрытияФайла.Выбрать() Тогда
				ПоместитьФайл(АдресВременногоХранилища, ДиалогОткрытияФайла.ПолноеИмяФайла, , Ложь, УникальныйИдентификатор);
				ИмяФайлаПравил = СтрЗаменить(ДиалогОткрытияФайла.ПолноеИмяФайла, ДиалогОткрытияФайла.Каталог, "");
				РасширениеФайла = НРег(Прав(ДиалогОткрытияФайла.ПолноеИмяФайла, 4));
				ЭтоАрхив = (РасширениеФайла = ".zip");
			Иначе
				Возврат;
			КонецЕсли; 
			
		Иначе
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выполняется загрузка правил в информационную базу...'"));
	
	// загрузка правил на сервере
	ЗагрузитьПравилаНаСервере(Отказ, АдресВременногоХранилища, ИмяФайлаПравил, ЭтоАрхив);
	
	Если Отказ Тогда
		
		НСтрока = НСтр("ru = 'В процессе загрузки правил были обнаружены ошибки.
							|Перейти в журнал регистрации?'"
		);
		
		Ответ = Вопрос(НСтрока, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			Отбор = Новый Структура;
			Отбор.Вставить("СобытиеЖурналаРегистрации", СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными);
			ОткрытьФормуМодально("Обработка.ЖурналРегистрации.Форма", Отбор, ЭтаФорма);
			
		КонецЕсли;
		
	Иначе
		
		Предупреждение(НСтр("ru = 'Правила успешно загружены в информационную базу.'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПравила(Команда)
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		
		// Предложение пользователю выбрать файл правил для сохранения
		Режим = РежимДиалогаВыбораФайла.Сохранение;
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		РасширениеФайла = НРег(Прав(Запись.ИмяФайлаПравил, 4));
		ИмяФайлаБезРасширения = СтрЗаменить(Запись.ИмяФайлаПравил, РасширениеФайла, "");
		ДиалогОткрытияФайла.ПолноеИмяФайла = ?(ПустаяСтрока(ИмяФайлаБезРасширения), "ПравилаДляОбменаДанными", ИмяФайлаБезРасширения);
		Фильтр = НСтр("ru = 'Файлы правил'") + "(*.xml)|*.xml|"
		+ НСтр("ru = 'Архивы ZIP'") + "(*.zip)|*.zip";
		ДиалогОткрытияФайла.Фильтр = Фильтр;
		Если НРег(Прав(Запись.ИмяФайлаПравил, 4)) = ".zip" Тогда
			ДиалогОткрытияФайла.ИндексФильтра = 1;
		Иначе
			ДиалогОткрытияФайла.ИндексФильтра = 0;
		КонецЕсли;
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = "Укажите в какой файл выгрузить правила";
		
		// Если указано куда выгружать файл правил - то сохраняем его в указанное место
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			ИмяФайла = СтрЗаменить(ДиалогОткрытияФайла.ПолноеИмяФайла, ДиалогОткрытияФайла.Каталог, "");
			РасширениеФайла = НРег(Прав(ДиалогОткрытияФайла.ПолноеИмяФайла, 4));
			ИмяФайлаБезРасширения = СтрЗаменить(ИмяФайла, РасширениеФайла, "");
			ЭтоАрхив = (РасширениеФайла = ".zip");
			Если ЭтоАрхив Тогда
				АдресВременногоХранилища = ПолучитьАдресВременногоХранилищаАрхиваПравилНаСервере(ИмяФайлаБезРасширения);
				Если ПустаяСтрока(АдресВременногоХранилища) Тогда
					Возврат;
				Иначе
					ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
					ДвоичныеДанные.Записать(ДиалогОткрытияФайла.ПолноеИмяФайла);				
				КонецЕсли;
			Иначе
				АдресВременногоХранилища = ПолучитьНавигационнуюСсылкуНаСервере();
				ПолучитьФайл(АдресВременногоХранилища, ДиалогОткрытияФайла.ПолноеИмяФайла, Ложь);
			КонецЕсли;
		Иначе
			Возврат;
		КонецЕсли;
		
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьСписокВыбораПлановОбмена()
	
	СписокПлановОбмена = ОбменДаннымиПовтИсп.СписокПлановОбменаБСП();
	
	ЗаполнитьСписок(СписокПлановОбмена, Элементы.ИмяПланаОбмена.СписокВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВыбораМакетаПравил()
	
	Если Запись.ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов Тогда
		
		СписокМакетов = ОбменДаннымиПовтИсп.ПолучитьСписокТиповыхПравилОбмена(Запись.ИмяПланаОбмена);
		
	Иначе // ПравилаРегистрацииОбъектов
		
		СписокМакетов = ОбменДаннымиПовтИсп.ПолучитьСписокТиповыхПравилРегистрации(Запись.ИмяПланаОбмена);
		
	КонецЕсли;
	
	СписокВыбора = Элементы.ИмяМакетаПравил.СписокВыбора;
	СписокВыбора.Очистить();
	
	ЗаполнитьСписок(СписокМакетов, СписокВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписок(СписокИсточник, СписокПриемник)
	
	Для Каждого Элемент ИЗ СписокИсточник Цикл
		
		ЗаполнитьЗначенияСвойств(СписокПриемник.Добавить(), Элемент);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	// если план обмена был ранее задан, то изменять его не даем
	Элементы.ГруппаПланаОбмена.Видимость = ПустаяСтрока(Запись.ИмяПланаОбмена);
	
	ГруппаИсточникиПравил = Элементы.ГруппаИсточникиПравил;
	
	ГруппаИсточникиПравил.ТекущаяСтраница = ?(ИсточникПравил = 0,
											ГруппаИсточникиПравил.ПодчиненныеЭлементы.ИсточникМакетКонфигурации,
											ГруппаИсточникиПравил.ПодчиненныеЭлементы.ИсточникФайл
	);
	
	Элементы.ВнешняяОбработкаДляОтладкиВыгрузки.Доступность = Запись.РежимОтладкиВыгрузки;
	Элементы.ВнешняяОбработкаДляОтладкиЗагрузки.Доступность = Запись.РежимОтладкиЗагрузки;
	Элементы.ФайлПротоколаОбмена.Доступность = Запись.РежимПротоколированияОбменаДанными;
	
	Элементы.ГруппаОтладки.Доступность = ?(ИсточникПравил = 2, Истина, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПравилаНаСервере(Отказ, АдресВременногоХранилища, ИмяФайлаПравил, ЭтоАрхив)
	
	Запись.ИсточникПравил = ?(ИсточникПравил = 0, Перечисления.ИсточникиПравилДляОбменаДанными.МакетКонфигурации, Перечисления.ИсточникиПравилДляОбменаДанными.Файл);
	
	Объект = РеквизитФормыВЗначение("Запись");
	
	РегистрыСведений.ПравилаДляОбменаДанными.ЗагрузитьПравила(Отказ, Объект, АдресВременногоХранилища, ИмяФайлаПравил, , ЭтоАрхив);
	
	Если Не Отказ Тогда
		
		Объект.Записать();
		
		Модифицированность = Ложь;
		
		// кеш открытых сеансов для механизма регистрации стал неактуальным
		ОбменДаннымиВызовСервера.СброситьКэшМеханизмаРегистрацииОбъектов();
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Объект, "Запись");
	
	ОбновитьИнформациюОПравилах();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНавигационнуюСсылкуНаСервере()
	
	Отбор = Новый Структура;
	Отбор.Вставить("ИмяПланаОбмена", Запись.ИмяПланаОбмена);
	Отбор.Вставить("ВидПравил",      Запись.ВидПравил);
	
	КлючЗаписи = РегистрыСведений.ПравилаДляОбменаДанными.СоздатьКлючЗаписи(Отбор);
	
	Возврат ПолучитьНавигационнуюСсылку(КлючЗаписи, "ПравилаXML");
	
КонецФункции

&НаСервере
Функция ПолучитьАдресВременногоХранилищаАрхиваПравилНаСервере(ИмяФайла)
	
	// Создаем временный каталог на сервере и формируем пути к файлам и папкам
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ВременныйФайл = Новый Файл(ИмяВременногоФайла);
	ИмяВременнойПапки = СтрЗаменить(ВременныйФайл.ПолноеИмя, ВременныйФайл.Расширение, "");
	СоздатьКаталог(ИмяВременнойПапки);
	ПутьКФайлу = ИмяВременнойПапки + "\" + ИмяФайла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПравилаДляОбменаДанными.ПравилаXML
	|ИЗ
	|	РегистрСведений.ПравилаДляОбменаДанными КАК ПравилаДляОбменаДанными
	|ГДЕ
	|	ПравилаДляОбменаДанными.ИмяПланаОбмена = &ИмяПланаОбмена
	|	И ПравилаДляОбменаДанными.ВидПравил = &ВидПравил";
	Запрос.УстановитьПараметр("ИмяПланаОбмена", Запись.ИмяПланаОбмена); 
	Запрос.УстановитьПараметр("ВидПравил", Запись.ВидПравил);	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		
		НСтрока = НСтр("ru = 'Не удалось получить правила обмена.'");
		ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока);
		Возврат "";
		
	Иначе
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		// Получаем, сохраняем и архивируем файл правил во временном каталоге
		ДвоичныеДанныеПравил = Выборка.ПравилаXML.Получить();
		ДвоичныеДанныеПравил.Записать(ПутьКФайлу + ".xml");
		ОбменДаннымиСервер.ЗапаковатьВZipФайл(ПутьКФайлу + ".zip", ПутьКФайлу + ".xml");
		
		// Помещаем архив правил в хранилище
		ДвоичныеДанныеАрхиваПравил = Новый ДвоичныеДанные(ПутьКФайлу + ".zip");
		АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанныеАрхиваПравил);
		Возврат АдресВременногоХранилища;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОбновитьИнформациюОПравилах()
	
	Если Запись.ИсточникПравил = Перечисления.ИсточникиПравилДляОбменаДанными.Файл Тогда
		
		ИнформацияОПравилах = НСтр("ru = 'Использование правил, загруженных из файла,
		|может привести к ошибкам при переходе на новую версию программы.
		|
		|[ИнформацияОПравилах]'"
		);
		
		ИнформацияОПравилах = СтрЗаменить(ИнформацияОПравилах, "[ИнформацияОПравилах]", Запись.ИнформацияОПравилах);
		
	Иначе
		
		ИнформацияОПравилах = Запись.ИнформацияОПравилах;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИсточникПравил()
	
	ИсточникПравил = ?(Запись.ИсточникПравил = Перечисления.ИсточникиПравилДляОбменаДанными.МакетКонфигурации, 0, 1);
	
	Если Запись.РежимОтладки Тогда
		
		ИсточникПравил = 2;
		
	КонецЕсли;	
	
КонецПроцедуры
