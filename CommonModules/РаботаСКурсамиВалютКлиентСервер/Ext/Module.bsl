﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Валюты"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Пересчитывает Сумму из Текущей валюты в Новую валюту по параметрам их курсов. 
//   Параметры курсов валют можно получить воспользовавшись функцией 
//   РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, ДатаКурса).
// 
// Параметры:
//   Сумма                  (Число)     Сумма, которую следует пересчитать
//   ПараметрыТекущегоКурса (Структура) Параметры курса валюты, из которой надо пересчитать
//       |- Валюта    (СправочникСсылка.Валюты)
//       |- Курс      (Число)
//       |- Кратность (Число)
//   ПараметрыНовогоКурса   (Структура) Параметры курса валюты, в  которую надо пересчитать
//       |- Валюта    (СправочникСсылка.Валюты)
//       |- Курс      (Число)
//       |- Кратность (Число)
// 
// Возвращаемое значение: 
//   (Число) Сумма, пересчитанная в другую валюту
// 
Функция ПересчитатьПоКурсу(Сумма, ПараметрыТекущегоКурса, ПараметрыНовогоКурса) Экспорт
	Если ПараметрыТекущегоКурса.Валюта = ПараметрыНовогоКурса.Валюта
		ИЛИ (
			ПараметрыТекущегоКурса.Курс = ПараметрыНовогоКурса.Курс 
			И ПараметрыТекущегоКурса.Кратность = ПараметрыНовогоКурса.Кратность
		) Тогда
		
		Возврат Сумма;
		
	КонецЕсли;
	
	Если ПараметрыТекущегоКурса.Курс = 0
		ИЛИ ПараметрыТекущегоКурса.Кратность = 0
		ИЛИ ПараметрыНовогоКурса.Курс = 0
		ИЛИ ПараметрыНовогоКурса.Кратность = 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При пересчете в валюту %1 сумма %2 установлена в нулевое значение, т.к. курс валюты не задан.'"), 
				ПараметрыНовогоКурса.Валюта, 
				Формат(Сумма, "ЧДЦ=2; ЧН=0")));
		
		Возврат 0;
		
	КонецЕсли;
	
	Возврат Окр((Сумма * ПараметрыТекущегоКурса.Курс * ПараметрыНовогоКурса.Кратность) / (ПараметрыНовогоКурса.Курс * ПараметрыТекущегоКурса.Кратность), 2);
КонецФункции

// Устарела: Следует использовать функцию ПересчитатьПоКурсу
// 
// Пересчитывает сумму из валюты ВалютаНач по курсу ПоКурсуНач 
// в валюту ВалютаКон по курсу ПоКурсуКон.
// 
// Параметры:
//   Сумма          (Число) Сумма, которую следует пересчитать
//   ВалютаНач      (СправочникСсылка.Валюты) Валюта, из которой надо пересчитать
//   ВалютаКон      (СправочникСсылка.Валюты) Валюта, в  которую надо пересчитать
//   ПоКурсуНач     (Число) Курс, из которого надо пересчитать
//   ПоКурсуКон     (Число) Курс, в  который  надо пересчитать
//   ПоКратностьНач (Число) Кратность, из которой надо пересчитать (по умолчанию = 1)
//   ПоКратностьКон (Число) Кратность, в  которую надо пересчитать (по умолчанию = 1)
// 
// Возвращаемое значение: 
//   (Число) Сумма, пересчитанная в другую валюту
// 
Функция ПересчитатьИзВалютыВВалюту(Сумма, ВалютаНач, ВалютаКон, ПоКурсуНач, ПоКурсуКон, 
	ПоКратностьНач = 1, ПоКратностьКон = 1) Экспорт
	
	Возврат ПересчитатьПоКурсу(
		Сумма, 
		Новый Структура("Валюта, Курс, Кратность", ВалютаНач, ПоКурсуНач, ПоКратностьНач),
		Новый Структура("Валюта, Курс, Кратность", ВалютаКон, ПоКурсуКон, ПоКратностьКон));
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура для загрузки курсов валют по определенному периоду.
//
// Параметры
// Валюты		- Любая коллекция - со следующими полями:
//					КодВалюты - числовой код валюты
//					Валюта - ссылка на валюту
// НачалоПериодаЗагрузки	- Дата - начало периода загрузки курсов
// ОкончаниеПериодаЗагрузки	- Дата - окончание периода загрузки курсов
//
// Возвращаемое значение:
// Массив состояния загрузки  - каждый элемент - структура с полями
//		Валюта - загружаемая валюта
//		СтатусОперации - завершилась ли загрузка успешно
//		Сообщение - пояснение о загрузке (текст сообщения об ошибке или поясняющее сообщение)
//
Функция ЗагрузитьКурсыВалютПоПараметрам(знач Валюты, знач НачалоПериодаЗагрузки, знач ОкончаниеПериодаЗагрузки, 
	ПриЗагрузкеВозниклиОшибки = Ложь) Экспорт
	
	СостояниеЗагрузки = Новый Массив;
	
	ПриЗагрузкеВозниклиОшибки = Ложь;
	
	СерверИсточник = "cbrates.rbc.ru";
	
	Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
		Адрес = "tsv/";
		ТМП   = Формат(ОкончаниеПериодаЗагрузки, "ДФ=/yyyy/MM/dd"); // Не локализуется - путь к файлу на сервере
	Иначе
		Адрес = "tsv/cb/";
		ТМП   = "";
	КонецЕсли;
	
	Для Каждого Валюта Из Валюты Цикл
		ФайлНаВебСервере = "http://" + СерверИсточник + "/" + Адрес + Прав(Валюта.КодВалюты, 3) + ТМП + ".tsv";
		
		#Если Клиент Тогда
			Результат = ПолучениеФайловИзИнтернетаКлиент.СкачатьФайлНаКлиенте(ФайлНаВебСервере);
		#Иначе
			Результат = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(ФайлНаВебСервере);
		#КонецЕсли
		
		Если Результат.Статус Тогда
			#Если Клиент Тогда
				ДвоичныеДанные = Новый ДвоичныеДанные(Результат.Путь);
				АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
				ПоясняющееСообщение = РаботаСКурсамиВалютВызовСервера.ЗагрузитьКурсВалютыИзФайла(Валюта.Валюта, АдресВоВременномХранилище, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки) + Символы.ПС;
			#Иначе
				ПоясняющееСообщение = РаботаСКурсамиВалют.ЗагрузитьКурсВалютыИзФайла(Валюта.Валюта, Результат.Путь, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки) + Символы.ПС;
			#КонецЕсли
			УдалитьФайлы(Результат.Путь);
			СтатусОперации = Истина;
		Иначе
			ПоясняющееСообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно получить файл данных с курсами валюты (%1 - %2):
				|%3
				|Возможно, нет доступа к веб сайту с курсами валют, либо указана несуществующая валюта.'"),
				Валюта.КодВалюты,
				Валюта.Валюта,
				Результат.СообщениеОбОшибке);
			СтатусОперации = Ложь;
			ПриЗагрузкеВозниклиОшибки = Истина;
		КонецЕсли;
		
		СостояниеЗагрузки.Добавить(Новый Структура("Валюта,СтатусОперации,Сообщение", Валюта.Валюта, СтатусОперации, ПоясняющееСообщение));
		
	КонецЦикла;
	
	
	Возврат СостояниеЗагрузки;
	
КонецФункции

