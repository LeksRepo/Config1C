﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если ОбщегоНазначения.ПриСозданииФормыНаСервере(ЭтаФорма, СтандартнаяОбработка, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьРазделениеПоОбластямДанных = ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных();
	
	СсылкаПоискаИнформации = "http://its.1c.ru/db/alldb#search:";
	
	Если ИспользоватьРазделениеПоОбластямДанных Тогда // для модели сервиса
		
		// Домашняя страница
		ГлавнаяСтраница                     = Справочники.ИнформационныеСсылкиДляФорм.ДомашняяСтраница;
		ДомашняяСтраница                    = Новый Структура("Имя, Адрес", ГлавнаяСтраница.Наименование, ГлавнаяСтраница.Адрес);
		Элементы.ДомашняяСтраница.Заголовок = ДомашняяСтраница.Имя;
		Элементы.ДомашняяСтраница.Видимость = ?(ПустаяСтрока(ДомашняяСтраница.Адрес), Ложь, Истина);
		
		ИнформационныйЦентрСерверПереопределяемый.ОпределитьСсылкуПоискаИнформации(СсылкаПоискаИнформации);
		
	Иначе // для локального режима
		
		Элементы.ГруппаСтартовыхСтраниц.Видимость    = Ложь;
		Элементы.ГруппаВзаимодействия.Видимость      = Ложь;
		
	КонецЕсли;
	
	ИнформационныйЦентрСервер.ВывестиКонтекстныеСсылки(ЭтаФорма, Элементы.ИнформационныеСсылки, 1, 5, Ложь);
	
	СформироватьСписокНовостей();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НажатиеНаНовость(Элемент)
	
	Фильтр = Новый Структура;
	Фильтр.Вставить("ИмяЭлементаФормы", Элемент.Имя);
	
	МассивСтрок = ТаблицаНовостей.НайтиСтроки(Фильтр);
	Если МассивСтрок.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущееСообщение = МассивСтрок.Получить(0);
	
	Если ТекущееСообщение.ТипИнформации = "Недоступность" Тогда 
		
		Идентификатор = ТекущееСообщение.Идентификатор;
		ВнешняяСсылка = ТекущееСообщение.ВнешняяСсылка;
		
		Если Не ПустаяСтрока(ВнешняяСсылка) Тогда 
			ПерейтиПоНавигационнойСсылке(ВнешняяСсылка);
			Возврат;
		КонецЕсли;
		
		ИнформационныйЦентрКлиент.ПоказатьНовость(Идентификатор);
		
	ИначеЕсли ТекущееСообщение.ТипИнформации = "УведомлениеОПожелании" Тогда 
		
		ИдентификаторПожелания = Строка(ТекущееСообщение.Идентификатор);
		
		ИнформационныйЦентрКлиент.ПоказатьПожелание(ИдентификаторПожелания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НажатиеЕщеСообщения(Элемент)
	
	ИнформационныйЦентрКлиент.ПоказатьВсеСообщения();
	
КонецПроцедуры

&НаКлиенте
Процедура НаписатьВТехПоддержкуНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ОбращенияПользователя");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодатьИдеюНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ПожеланияПользователей");
	
КонецПроцедуры

&НаКлиенте
Процедура ДомашняяСтраницаНажатие(Элемент)
	
	Если Не ДомашняяСтраница.Свойство("Адрес") Тогда 
		Возврат;
	КонецЕсли;
	
	ПерейтиПоНавигационнойСсылке(ДомашняяСтраница.Адрес);
	
КонецПроцедуры

&НаКлиенте
Процедура ФорумНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ОбсужденияНаФоруме");
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура НайтиОтветНаВопрос(Команда)
	
	ПоискОтветаНаВопрос();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Команда)
	
	ИнформационныйЦентрКлиент.НажатиеНаИнформационнуюСсылку(ЭтаФорма, Команда);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура СформироватьСписокНовостей()
	
	УстановитьПривилегированныйРежим(Истина);
	ИнформационныйЦентрСервер.СформироватьСписокНовостейНаРабочийСтол(ТаблицаНовостей);
	
	Если ТаблицаНовостей.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ГруппаНовостей = Элементы.ГруппаНовостей;
	
	Для Итерация = 0 По ТаблицаНовостей.Количество() - 1 Цикл
		
		Наименование = ТаблицаНовостей.Получить(Итерация).СсылкаНаДанные.Наименование;
		
		Если ПустаяСтрока(Наименование) Тогда 
			Продолжить;
		КонецЕсли;
		
		Критичность  = ТаблицаНовостей.Получить(Итерация).СсылкаНаДанные.Критичность;
		Картинка     = ?(Критичность > 5, БиблиотекаКартинок.УведомлениеСервиса, БиблиотекаКартинок.СообщениеСервиса);
		
		ГруппаНовости                     = Элементы.Добавить("ГруппаНовости" + Строка(Итерация), Тип("ГруппаФормы"), ГруппаНовостей);
		ГруппаНовости.Вид                 = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаНовости.ОтображатьЗаголовок = Ложь;
		ГруппаНовости.Группировка         = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		ГруппаНовости.Отображение         = ОтображениеОбычнойГруппы.Нет;
		
		КартинкаНовости                = Элементы.Добавить("КартинкаНовости" + Строка(Итерация), Тип("ДекорацияФормы"), ГруппаНовости);
		КартинкаНовости.Вид            = ВидДекорацииФормы.Картинка;
		КартинкаНовости.Картинка       = Картинка;
		КартинкаНовости.Ширина         = 2;
		КартинкаНовости.Высота         = 1;
		КартинкаНовости.РазмерКартинки = РазмерКартинки.Растянуть;
		
		ИмяНовости                          = Элементы.Добавить("ИмяНовости" + Строка(Итерация), Тип("ДекорацияФормы"), ГруппаНовости);
		ИмяНовости.Вид                      = ВидДекорацииФормы.Надпись;
		ИмяНовости.Заголовок                = Наименование;
		ИмяНовости.РастягиватьПоГоризонтали = Истина;
		ИмяНовости.ВертикальноеПоложение    = ВертикальноеПоложениеЭлемента.Центр;
		ИмяНовости.ВысотаЗаголовка          = 1;
		ИмяНовости.Гиперссылка              = Истина;
		ИмяНовости.УстановитьДействие("Нажатие", "НажатиеНаНовость");
		
		ТаблицаНовостей.Получить(Итерация).ИмяЭлементаФормы = ИмяНовости.Имя;
		ТаблицаНовостей.Получить(Итерация).ТипИнформации    = ТаблицаНовостей.Получить(Итерация).СсылкаНаДанные.ТипИнформации.Наименование;
		ТаблицаНовостей.Получить(Итерация).Идентификатор    = ТаблицаНовостей.Получить(Итерация).СсылкаНаДанные.Идентификатор;
		ТаблицаНовостей.Получить(Итерация).ВнешняяСсылка    = ТаблицаНовостей.Получить(Итерация).СсылкаНаДанные.ВнешняяСсылка;
		
	КонецЦикла;
	
	ЕщеСообщения                          = Элементы.Добавить("ЕщеСообщения", Тип("ДекорацияФормы"), ГруппаНовостей);
	ЕщеСообщения.Вид                      = ВидДекорацииФормы.Надпись;
	ЕщеСообщения.Заголовок                = НСтр("ru = 'Еще сообщения'");
	ЕщеСообщения.РастягиватьПоГоризонтали = Истина;
	ЕщеСообщения.ВертикальноеПоложение    = ВертикальноеПоложениеЭлемента.Центр;
	ЕщеСообщения.Гиперссылка              = Истина;
	ЕщеСообщения.УстановитьДействие("Нажатие", "НажатиеЕщеСообщения");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискОтветаНаВопрос()
	
	ПодключитьОбработчикОжидания("ОбработкаОжиданияПоискаОтветаНаВопрос", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжиданияПоискаОтветаНаВопрос()
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		Возврат;
	КонецЕсли;
	
	ПерейтиПоНавигационнойСсылке(СсылкаПоискаИнформации + СтрокаПоиска);
	
КонецПроцедуры
