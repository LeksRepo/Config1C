﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Получение логина (для модели сервиса) текущего пользователя
	УстановитьПривилегированныйРежим(Истина);
	Логин = Строка(ПараметрыСеанса.ТекущийПользователь.ИдентификаторПользователяСервиса);
	УстановитьПривилегированныйРежим(Ложь);
	
	ЦветГиперссылки = Новый Цвет(24, 52, 161);
	
	// Формирование элементов страницы
	Результат = СформироватьЭлементыСтраницы("Popular", 1);
	Если Не Результат Тогда
		ВызватьИсключение НСтр("ru = 'Сервис по отображению пожеланий пользователей временно не доступен.
								|Пожалуйста, повторите попытку позже'");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеПожелания" Тогда
		СформироватьЭлементыСтраницы(ТекущаяГруппа, ТекущаяСтраница);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НажатиеНаГруппуПожелания(Элемент)
	
	ЗаполнитьФормуПожеланиями(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НажатиеНаПожелание(Элемент)
	
	Строки = ТаблицаПожеланий.НайтиСтроки(Новый Структура("ИмяЭлементаФормы", Элемент.Имя));
	ИдентификаторПожелания = Строки.Получить(0).Идентификатор;
	ПараметрыФормы = Новый Структура("ИдентификаторПожелания", ИдентификаторПожелания);
	
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.Пожелание", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура НажатиеНаНомерСтраницы(Элемент)
	
	ИмяСсылки = Элемент.Имя;
	
	Если ИмяСсылки = НСтр("ru = 'Следующие'") Тогда 
		НомерСтраницы = ТекущаяСтраница + 1;
	ИначеЕсли ИмяСсылки = НСтр("ru = 'Предыдущие'") Тогда 
		НомерСтраницы = ТекущаяСтраница - 1;
	Иначе
		НомерСтраницы = СтрЗаменить(Элемент.Имя, "с", "");
		Попытка
			НомерСтраницы = Число(НомерСтраницы);
		Исключение
			НомерСтраницы = ТекущаяСтраница;
		КонецПопытки;
	КонецЕсли;
	
	// Формирование элементов страницы
	Результат = СформироватьЭлементыСтраницы(ТекущаяГруппа, НомерСтраницы, Ложь);
	Если Не Результат Тогда
		ВызватьИсключение НСтр("ru = 'Сервис по отображению пожеланий пользователей временно не доступен.
								|Пожалуйста, повторите попытку позже'");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииЗначениеФильтра(Элемент)
	
	ИзменениеЗначенияФильтра(Элемент.Имя);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура НайтиПожелания(Команда)
	
	Если ПустаяСтрока(Поиск) Тогда 
		Предупреждение(НСтр("ru = 'Введенный текст некорректен.'"));
		Возврат;
	КонецЕсли;
	
	СформироватьЭлементыСтраницы("Search", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура Проголосовать(Команда)
	
	ВыполнитьДействиеПоГолосованию(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура НаписатьПожелание(Команда)
	
	Параметрыформы = Новый Структура("Логин", Логин);
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ДобавлениеПожелания", Параметрыформы);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ВыполнитьДействиеПоГолосованию(ИмяКоманды)
	
	ИдентификаторПожелания = "";
	
	Для Каждого ЭлементСписка из СписокКоманд Цикл
		Если ЭлементСписка.ИмяКоманды = ИмяКоманды Тогда 
			ИдентификаторПожелания = ЭлементСписка.ИдентификаторПожелания;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ГолосДобавлен = ПроголосоватьЗаПожеланиеСервер(1, ИдентификаторПожелания);
	Если Не ГолосДобавлен Тогда 
		Предупреждение(НСтр("ru = 'К сожалению Ваш голос не добавлен.
								|Попробуйте проголосовать позднее."));
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Ваш голос принят.'"));
	
	ПараметрыФормы = Новый Структура("Логин, ИдентификаторПожелания", Логин, ИдентификаторПожелания);
	ОткрытьФормуМодально("Обработка.ИнформационныйЦентр.Форма.ДобавлениеКомментария", ПараметрыФормы);
	
	// Формирование элементов страницы
	Результат = СформироватьЭлементыСтраницы(ТекущаяГруппа, ТекущаяСтраница);
	Если Не Результат Тогда
		Предупреждение(НСтр("ru = 'Сервис по отображению пожеланий пользователей временно не доступен.
								|Пожалуйста, повторите попытку позже'"));
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменениеЗначенияФильтра(знач ИмяЭлемента)
	
	Для Каждого Фильтр из СписокФильтров Цикл
		Если Фильтр.Наименование = ИмяЭлемента Тогда 
			Фильтр.Выбран = ЭтаФорма[ИмяЭлемента];
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	// Формирование элементов страницы
	Результат = СформироватьЭлементыСтраницы(ТекущаяГруппа, 1, Ложь);
	Если Не Результат Тогда
		ВызватьИсключение НСтр("ru = 'Сервис по отображению пожеланий пользователей временно не доступен.
								|Пожалуйста, повторите попытку позже'");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьЭлементыСтраницы(ТипГруппы, НомерСтраницы, СбрасыватьФильтры = Истина)
	
	ГруппаПожеланий = ПолучитьГруппуПожеланий(ТипГруппы, НомерСтраницы, СбрасыватьФильтры);
	Если ГруппаПожеланий = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Определение видимости гиперссылок фильтрации
	СформироватьЗаголовкиГруппПожеланий(ГруппаПожеланий.ParametersForForm, ТипГруппы);
	
	// Формирование фильтров
	СформироватьФильтры(ГруппаПожеланий.ParametersForForm.ObjectSuggestion.ObjectSuggestion, СбрасыватьФильтры);
	
	// Определение текущей группы
	ТекущаяГруппа = ТипГруппы;
	
	// Формирование элементов формы пожеланий
	СформироватьЭлементыДляПожеланий(ГруппаПожеланий.MaxAmountOnPage, ГруппаПожеланий.Suggestions);
	
	// Формирование подвала
	СформироватьПодвал(ГруппаПожеланий);
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура СформироватьЗаголовкиГруппПожеланий(СписокПараметровДляФормы, ТипГруппы)
	
	// Определение элементов заголовка групп
	ОпределитьЭлементыЗаголовкаГруппПожеланий(СписокПараметровДляФормы, ТипГруппы);
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьЭлементыЗаголовкаГруппПожеланий(СписокПараметровДляФормы, ТипГруппы)
	
	СброситьПараметрыДляЭлементовЗаголовковГрупп();
	
	Если ТипГруппы = "Popular" Тогда 
		Элементы.Обсуждаемые.Гиперссылка          = Ложь;
		Элементы.Обсуждаемые.Шрифт                = Новый Шрифт(,, Истина);
		Элементы.КоличествоОбсуждаемых.ЦветТекста = Новый Цвет;
	ИначеЕсли ТипГруппы = "My" Тогда
		Элементы.МоиПредложения.Гиперссылка           = Ложь;
		Элементы.МоиПредложения.Шрифт                 = Новый Шрифт(,, Истина);
		Элементы.КоличествоМоихПредложений.ЦветТекста = Новый Цвет;
	ИначеЕсли ТипГруппы = "Made" Тогда
		Элементы.Выполненные.Гиперссылка          = Ложь;
		Элементы.Выполненные.Шрифт                = Новый Шрифт(,, Истина);
		Элементы.КоличествоВыполненных.ЦветТекста = Новый Цвет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СброситьПараметрыДляЭлементовЗаголовковГрупп()
	
	Элементы.Обсуждаемые.Гиперссылка    = Истина;
	Элементы.Выполненные.Гиперссылка    = Истина;
	Элементы.МоиПредложения.Гиперссылка = Истина;
	
	Элементы.Обсуждаемые.Шрифт    = Новый Шрифт();
	Элементы.Выполненные.Шрифт    = Новый Шрифт();
	Элементы.МоиПредложения.Шрифт = Новый Шрифт();
	
	Элементы.КоличествоОбсуждаемых.Заголовок     = "";
	Элементы.КоличествоВыполненных.Заголовок     = "";
	Элементы.КоличествоМоихПредложений.Заголовок = "";
	
	Элементы.КоличествоОбсуждаемых.ЦветТекста     = ЦветГиперссылки;
	Элементы.КоличествоВыполненных.ЦветТекста     = ЦветГиперссылки;
	Элементы.КоличествоМоихПредложений.ЦветТекста = ЦветГиперссылки;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьФильтры(СписокПараметровДляФормы, СбрасыватьФильтры)
	
	// Удаление элементов формы
	УдалитьЭлементыФормыДляФильтров();
	
	// Удаление реквизитов формы
	УдалитьРеквизитыФормыДляФильтров();
	
	// Создание новых реквизитов
	СоздатьРеквизитыФормыДляФильтров(СписокПараметровДляФормы, СбрасыватьФильтры);
	
	// Создание новых элементов формы
	СоздатьЭлементыФормыДляФильтров(СписокПараметровДляФормы);
	
КонецПроцедуры

&НаСервере
Процедура СоздатьЭлементыФормыДляФильтров(СписокПараметровДляФормы)
	
	СписокФильтров.Очистить();
	
	Итерация = 0;
	
	КоличествоФильтровВГруппе = СписокПараметровДляФормы.Количество() / 3;
	
	КоличествоФильтровВГруппе = ?(Цел(КоличествоФильтровВГруппе) < КоличествоФильтровВГруппе, Цел(КоличествоФильтровВГруппе) + 1, Цел(КоличествоФильтровВГруппе));
	
	Для Каждого ПараметрФормы из СписокПараметровДляФормы Цикл 
		
		Если Итерация = 0 или Итерация%КоличествоФильтровВГруппе = 0 Тогда 
			ИмяЭлементаФормы                            = "ГруппаФильтра" + Строка(Итерация);
			РодительскаяГруппа                          = Элементы.Добавить(ИмяЭлементаФормы, Тип("ГруппаФормы"), Элементы.ГруппаФильтров);
			РодительскаяГруппа.Вид                      = ВидГруппыФормы.ОбычнаяГруппа;
			РодительскаяГруппа.ОтображатьЗаголовок      = Ложь;
			РодительскаяГруппа.Группировка              = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
			РодительскаяГруппа.Отображение              = ОтображениеОбычнойГруппы.Нет;
			СписокГруппФильтров.Добавить(ИмяЭлементаФормы);
		КонецЕсли;
		
		ИмяЭлементаФормы                             = "ГруппаОдногоФильтра" + Строка(Итерация);
		ГруппаОдногоФильтра                          = Элементы.Добавить(ИмяЭлементаФормы, Тип("ГруппаФормы"), РодительскаяГруппа);
		ГруппаОдногоФильтра.Вид                      = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаОдногоФильтра.ОтображатьЗаголовок      = Ложь;
		ГруппаОдногоФильтра.Группировка              = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		ГруппаОдногоФильтра.Отображение              = ОтображениеОбычнойГруппы.Нет;
		
		Итерация    = Итерация + 1;
		ИмяЭлемента = "Фильтр" + Строка(Итерация);
		
		ПолеФормы                          = Элементы.Добавить(ИмяЭлемента, Тип("ПолеФормы"), ГруппаОдногоФильтра);
		ПолеФормы.Вид                      = ВидПоляФормы.ПолеФлажка;
		ПолеФормы.ПутьКДанным              = ИмяЭлемента;
		ПолеФормы.ПоложениеЗаголовка       = ПоложениеЗаголовкаЭлементаФормы.Нет;
		ПолеФормы.Заголовок                = ПараметрФормы.Name;
		ПолеФормы.УстановитьДействие("ПриИзменении", "ПриИзмененииЗначениеФильтра");
		
		ЭлементСписка = СписокФильтров.Добавить();
		ЭлементСписка.Наименование = ИмяЭлемента;
		ЭлементСписка.Выбран       = ЭтаФорма[ИмяЭлемента];
		
		ИмяОчередногоЭлемента            = "ЗаголовокФильтра" + Строка(Итерация);
		Элемент                          = Элементы.Добавить(ИмяОчередногоЭлемента, Тип("ДекорацияФормы"), ГруппаОдногоФильтра);
		Элемент.Вид                      = ВидДекорацииФормы.Надпись;
		Элемент.Заголовок                = ПараметрФормы.Name;
		Элемент.РастягиватьПоГоризонтали = Истина;
		
		ЗаголовкиФильтров.Добавить(ИмяОчередногоЭлемента);
		
		ИмяОчередногоЭлемента                             = "ПустаяСтрокаПослеФильтра" + Строка(Итерация);
		ПустаяСтрокаПослеФильтра                          = Элементы.Добавить(ИмяОчередногоЭлемента, Тип("ДекорацияФормы"), ГруппаОдногоФильтра);
		ПустаяСтрокаПослеФильтра.Вид                      = ВидДекорацииФормы.Надпись;
		ПустаяСтрокаПослеФильтра.Заголовок                = "";
		ПустаяСтрокаПослеФильтра.РастягиватьПоГоризонтали = Истина;
		
		ЗаголовкиФильтров.Добавить(ИмяОчередногоЭлемента);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьРеквизитыФормыДляФильтров(СписокПараметровДляФормы, СбрасыватьФильтры)
	
	// Добавление новых реквизитов
	МассивДобавляемыхРеквизитов = Новый Массив;
	Итерация = 0;
	Для Каждого ПараметрФормы из СписокПараметровДляФормы Цикл
		Итерация = Итерация + 1;
		НовыйРеквизит = Новый РеквизитФормы("Фильтр" + Строка(Итерация), Новый ОписаниеТипов("Булево"));
		МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизит);
	КонецЦикла;
	
	Если МассивДобавляемыхРеквизитов.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);
	
	Итерация = 0;
	Для Каждого ПараметрФормы из СписокПараметровДляФормы Цикл
		Итерация = Итерация + 1;
		ЭтаФорма["Фильтр" + Строка(Итерация)] = Истина;
	КонецЦикла;
	
	Если Не СбрасыватьФильтры Тогда 
		Для Каждого ЭлементСписка из СписокФильтров Цикл
			Попытка
				ЭтаФорма[ЭлементСписка.Наименование] = ЭлементСписка.Выбран;
			Исключение
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРеквизитыФормыДляФильтров()
	
	МассивУдаляемыхРеквизитов = Новый Массив;
	Для Каждого Фильтр из СписокФильтров Цикл
		МассивУдаляемыхРеквизитов.Добавить(Фильтр.Наименование);
	КонецЦикла;
	
	Если МассивУдаляемыхРеквизитов.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ИзменитьРеквизиты( , МассивУдаляемыхРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЭлементыФормыДляФильтров()
	
	Для Каждого Фильтр из СписокФильтров Цикл
		
		ЭлементФормы = Элементы.Найти(Фильтр.Наименование);
		Если ЭлементФормы = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		Элементы.Удалить(ЭлементФормы);
		
	КонецЦикла;
	
	Для Каждого ГруппаФильтра из СписокГруппФильтров Цикл
		
		ЭлементФормы = Элементы.Найти(ГруппаФильтра.Значение);
		Если ЭлементФормы = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		Элементы.Удалить(ЭлементФормы);
		
	КонецЦикла;
	
	Для Каждого ЗаголовокФильтра из ЗаголовкиФильтров Цикл
		
		ЭлементФормы = Элементы.Найти(ЗаголовокФильтра.Значение);
		Если ЭлементФормы = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		Элементы.Удалить(ЭлементФормы);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПодвал(ГруппаПожеланий)
	
	// Удаление старых страниц и элементов
	УдалитьСтраницыПодвала();
	
	// Определение массива имен ссылок
	МассивИменСсылок = ПолучитьМассивИменСсылокСтраниц(ГруппаПожеланий);
	
	// Создание элементов подвала
	СоздатьЭлементыПодвала(МассивИменСсылок);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСтраницыПодвала()
	
	Для Каждого ЭлементСписка из СписокЭлементовПодвала Цикл 
		
		НайденныйЭлемент = Элементы.Найти(ЭлементСписка.Значение);
		Если НайденныйЭлемент = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		Элементы.Удалить(НайденныйЭлемент);
		
	КонецЦикла;
	
	СписокЭлементовПодвала.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура СоздатьЭлементыПодвала(МассивИменСсылок)
	
	Если МассивИменСсылок.Количество() = 0 Тогда 
		ИмяОчередногоЭлемента            = "пусто";
		Элемент                          = Элементы.Добавить(ИмяОчередногоЭлемента, Тип("ДекорацияФормы"), Элементы.Подвал);
		Элемент.Вид                      = ВидДекорацииФормы.Надпись;
		Элемент.Заголовок                = "";
		Элемент.РастягиватьПоВертикали   = Истина;
		СписокЭлементовПодвала.Добавить(ИмяОчередногоЭлемента);
		Возврат;
	КонецЕсли;
	
	ИмяОчередногоЭлемента            = "Пусто1";
	Элемент                          = Элементы.Добавить(ИмяОчередногоЭлемента, Тип("ДекорацияФормы"), Элементы.Подвал);
	Элемент.Вид                      = ВидДекорацииФормы.Надпись;
	Элемент.РастягиватьПоГоризонтали = Истина;
	Элемент.Заголовок                = "";
	
	СписокЭлементовПодвала.Добавить(ИмяОчередногоЭлемента);
	
	Итерация = 0;
	
	Для Каждого ИмяСсылки из МассивИменСсылок Цикл 
		
		Итерация = Итерация + 1;
		
		Если ИмяСсылки = "..." Тогда 
			ИмяОчередногоЭлемента            = "многоточие" + Строка(Итерация);
			Элемент                          = Элементы.Добавить(ИмяОчередногоЭлемента, Тип("ДекорацияФормы"), Элементы.Подвал);
			Элемент.Вид                      = ВидДекорацииФормы.Надпись;
			Элемент.Заголовок                = Строка(ИмяСсылки);
			СписокЭлементовПодвала.Добавить(ИмяОчередногоЭлемента);
			Продолжить;
		КонецЕсли;
		
		Если ИмяСсылки = НСтр("ru = 'Следующие'") или ИмяСсылки = НСтр("ru = 'Предыдущие'") Тогда 
			ИмяОчередногоЭлемента            = ИмяСсылки;
			Элемент                          = Элементы.Добавить(ИмяОчередногоЭлемента, Тип("ДекорацияФормы"), Элементы.Подвал);
			Элемент.Вид                      = ВидДекорацииФормы.Надпись;
			Элемент.Заголовок                = Строка(ИмяСсылки);
			Элемент.Гиперссылка = Истина;
			Элемент.УстановитьДействие("Нажатие", "НажатиеНаНомерСтраницы");
			СписокЭлементовПодвала.Добавить(ИмяОчередногоЭлемента);
			Продолжить;
		КонецЕсли;
		
		ИмяОчередногоЭлемента            = "с" + Строка(ИмяСсылки);
		Элемент                          = Элементы.Добавить(ИмяОчередногоЭлемента, Тип("ДекорацияФормы"), Элементы.Подвал);
		Элемент.Вид                      = ВидДекорацииФормы.Надпись;
		Элемент.Заголовок                = Строка(ИмяСсылки);
		СписокЭлементовПодвала.Добавить(ИмяОчередногоЭлемента);
		
		Если Число(ИмяСсылки) = ТекущаяСтраница Тогда 
			Продолжить;
		КонецЕсли;
		
		Элемент.Гиперссылка = Истина;
		Элемент.УстановитьДействие("Нажатие", "НажатиеНаНомерСтраницы");
		
	КонецЦикла;
	
	ИмяОчередногоЭлемента            = "Пусто2";
	Элемент                          = Элементы.Добавить(ИмяОчередногоЭлемента, Тип("ДекорацияФормы"), Элементы.Подвал);
	Элемент.Вид                      = ВидДекорацииФормы.Надпись;
	Элемент.РастягиватьПоГоризонтали = Истина;
	Элемент.Заголовок                = "";
	СписокЭлементовПодвала.Добавить(ИмяОчередногоЭлемента);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивИменСсылокСтраниц(ГруппаПожеланий)
	
	МассивИменСсылок = Новый Массив;
	
	// Текущая страница пожеланий
	ТекущаяСтраница = ГруппаПожеланий.CurrentPage;
	
	Если ТекущаяСтраница > 1 Тогда 
		МассивИменСсылок.Добавить(НСтр("ru = 'Предыдущие'"));
	КонецЕсли;
	
	Если ТекущаяСтраница >=1 Тогда 
		МассивИменСсылок.Добавить(ТекущаяСтраница);
	КонецЕсли;
	
	Если ГруппаПожеланий.Suggestions.Количество() > ГруппаПожеланий.MaxAmountOnPage Тогда 
		МассивИменСсылок.Добавить(НСтр("ru = 'Следующие'"));
	КонецЕсли;
	
	Если МассивИменСсылок.Количество() = 1 Тогда 
		МассивИменСсылок.Очистить();
	КонецЕсли;
	
	Возврат МассивИменСсылок;
	
КонецФункции

&НаСервере
Функция ПолучитьСписокПредметовПожеланий(ФабрикаXDTOВебСервиса)
	
	ТипСпискаГрупп      = ФабрикаXDTOВебСервиса.Тип("http://www.1c.ru/SaaS/1.0/XMLSchema/ManageInfoCenter", "ObjectSuggestionList");
	ОписаниеСпискаГрупп = ФабрикаXDTOВебСервиса.Создать(ТипСпискаГрупп);
	
	ТипГруппы      = ФабрикаXDTOВебСервиса.Тип("http://www.1c.ru/SaaS/1.0/XMLSchema/ManageInfoCenter", "ObjectSuggestionListElement");
	
	Для Каждого ЭлементСписка из СписокФильтров Цикл 
		
		Если Не ЭлементСписка.Выбран Тогда 
			Продолжить;
		КонецЕсли;
		
		НайденныйЭлемент = Элементы.Найти(ЭлементСписка.Наименование);
		Если НайденныйЭлемент = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		ОписаниеГруппы        = ФабрикаXDTOВебСервиса.Создать(ТипГруппы);
		ОписаниеГруппы.Name   = НайденныйЭлемент.Заголовок;
		ОписаниеСпискаГрупп.ObjectSuggestion.Добавить(ОписаниеГруппы);
		
	КонецЦикла;
	
	Возврат ОписаниеСпискаГрупп;
	
КонецФункции

&НаСервере
Функция ПолучитьГруппуПожеланий(ТипГруппы, НомерСтраницы, СбрасыватьФильтры)
	
	Попытка
		Прокси = ИнформационныйЦентрСервер.ПолучитьПроксиИнформационногоЦентра();
		Предметы = ПолучитьСписокПредметовПожеланий(Прокси.ФабрикаXDTO);
		Возврат Прокси.GetGroupSuggestion(ТипГруппы, НомерСтраницы, Логин, Предметы, Поиск, СбрасыватьФильтры);
	Исключение
		ИмяСобытия = ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

&НаСервере
Процедура УдалитьЭлементыФормПожеланий(ДеревоЭлементов)
	
	Для Каждого СтрокаДерева из ДеревоЭлементов.Строки Цикл 
		
		Если СтрокаДерева.Строки.Количество() <> 0 Тогда 
			УдалитьЭлементыФормПожеланий(СтрокаДерева);
		КонецЕсли;
		
		// Удаление элемента формы
		ИмяЭлементаФормы = СтрокаДерева.ИмяЭлемента;
		ЭлементФормы = Элементы.Найти(ИмяЭлементаФормы);
		Если ЭлементФормы = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		Элементы.Удалить(ЭлементФормы);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЭлементыДляПожеланий(МаксимальноеЧислоНастранице, Пожелания)
	
	// Удаление старых элементов формы
	УдалитьЭлементы();
	
	// Удаление команд формы
	УдалитьКоманды();
	
	ТаблицаПожеланий.Очистить();
	ТаблицаСоответвияПожеланийИНравитсяНеНравится.Очистить();
	
	ОсновнаяГруппа = Элементы.ГруппаПожеланий;
	
	ДеревоЭлементов = РеквизитФормыВЗначение("ДеревоЭлементовПожеланий", Тип("ДеревоЗначений"));
	Итерация = 0;
	Для каждого Пожелание из Пожелания Цикл 
		
		Итерация = Итерация + 1;
		
		Если Итерация > МаксимальноеЧислоНастранице Тогда 
			Прервать;
		КонецЕсли;
		
		ГруппаДляПожелания = СформироватьГруппуДляПожелания(Пожелание, ОсновнаяГруппа, Итерация, ДеревоЭлементов);
		
	КонецЦикла;
	ЗначениеВРеквизитФормы(ДеревоЭлементов, "ДеревоЭлементовПожеланий");
	
КонецПроцедуры

&НаСервере
Процедура УдалитьКоманды()
	
	Для Каждого ЭлементСписка из СписокКоманд Цикл 
		НайденнаяКоманда = Команды.Найти(ЭлементСписка.ИмяКоманды);
		Если НайденнаяКоманда <> Неопределено Тогда 
			Команды.Удалить(НайденнаяКоманда);
		КонецЕсли;
	КонецЦикла;
	
	СписокКоманд.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЭлементы()
	
	ДеревоЭлементов = РеквизитФормыВЗначение("ДеревоЭлементовПожеланий", Тип("ДеревоЗначений"));
	
	УдалитьЭлементыФормПожеланий(ДеревоЭлементов);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Строка"));
	ОписаниеСтрока = Новый ОписаниеТипов(МассивТипов);
	ДеревоЭлементов = Новый ДеревоЗначений;
	ДеревоЭлементов.Колонки.Добавить("ИмяЭлемента", ОписаниеСтрока);
	
	ЗначениеВРеквизитФормы(ДеревоЭлементов, "ДеревоЭлементовПожеланий");
	
КонецПроцедуры

&НаСервере
Функция ПроголосоватьЗаПожеланиеСервер(Голос, Идентификатор)
	
	Попытка
		ПроксиИнформационногоЦентра = ИнформационныйЦентрСервер.ПолучитьПроксиИнформационногоЦентра();
		Возврат ПроксиИнформационногоЦентра.AddVote(Идентификатор, Логин, Голос);
	Исключение
		Возврат Ложь
	КонецПопытки;
	
КонецФункции

&НаСервере
Функция СформироватьГруппуДляПожелания(Пожелание, ОсновнаяГруппа, Итерация, ДеревоЭлементов)
	
	ИмяЭлементаФормы                         = "ГруппаПожелания" + Строка(Итерация);
	ГруппаПожелания                          = Элементы.Добавить(ИмяЭлементаФормы, Тип("ГруппаФормы"), ОсновнаяГруппа);
	ГруппаПожелания.Вид                      = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаПожелания.ОтображатьЗаголовок      = Ложь;
	ГруппаПожелания.Группировка              = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	ГруппаПожелания.Отображение              = ОтображениеОбычнойГруппы.Линия;
	ГруппаПожелания.РастягиватьПоГоризонтали = Истина;
	
	СтрокаДерева = ДеревоЭлементов.Строки.Добавить();
	СтрокаДерева.ИмяЭлемента = ИмяЭлементаФормы;
	
	// Формирование подчиненных элементов
	СформироватьГруппуРейтингаПожелания(Пожелание, Итерация, ГруппаПожелания, СтрокаДерева);
	СформироватьГруппуСодержанияДляПожелания(Пожелание, Итерация, ГруппаПожелания, СтрокаДерева);
	
КонецФункции

&НаСервере
Процедура СформироватьГруппуРейтингаПожелания(Пожелание, Итерация, РодительскаяГруппа, РодительскаяСтрокаДерева)
	
	ШиринаЭлементовГруппы = 7;
	
	ИмяГруппы                           = "ГруппаРейтинга" + Строка(Итерация);
	ГруппаРейтинга                      = Элементы.Добавить(ИмяГруппы, Тип("ГруппаФормы"), РодительскаяГруппа);
	ГруппаРейтинга.Вид                  = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаРейтинга.ОтображатьЗаголовок  = Ложь;
	ГруппаРейтинга.Группировка          = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаРейтинга.Отображение          = ОтображениеОбычнойГруппы.Нет;
	
	СтрокаГруппы             = РодительскаяСтрокаДерева.Строки.Добавить();
	СтрокаГруппы.ИмяЭлемента = ИмяГруппы;
	
	РейтингТекущегоПожелания = Пожелание.Rating;
	РейтингТекущегоПожелания = ?(РейтингТекущегоПожелания = 0, "0", Формат(Пожелание.Rating, "ЧГ=0"));
	
	ИмяЭлементаРейтингаПожелания = "Рейтинг" + + Строка(Итерация);
	РейтингПожелания             = Элементы.Добавить(ИмяЭлементаРейтингаПожелания, Тип("ДекорацияФормы"), ГруппаРейтинга);
	РейтингПожелания.Вид         = ВидДекорацииФормы.Надпись;
	РейтингПожелания.Заголовок   = РейтингТекущегоПожелания;
	РейтингПожелания.Шрифт       = Новый Шрифт( , 18);
	РейтингПожелания.Ширина      = ШиринаЭлементовГруппы;
	РейтингПожелания.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Центр;
	
	СтрокаДерева             = СтрокаГруппы.Строки.Добавить();
	СтрокаДерева.ИмяЭлемента = ИмяЭлементаРейтингаПожелания;
	
	Если Пожелание.ClosingDate <> '00010101' Тогда 
		
		ИмяЭлементаВыполненно            = "Выполненно" + Строка(Итерация);
		ИмяЭлементаВыполненно            = Элементы.Добавить(ИмяЭлементаВыполненно, Тип("ДекорацияФормы"), ГруппаРейтинга);
		ИмяЭлементаВыполненно.Заголовок  = НСтр("ru = 'сделано
		                                          |'") + Строка(Формат(Пожелание.ClosingDate, "ДЛФ=D"));
		ИмяЭлементаВыполненно.Высота     = 2;
		ИмяЭлементаВыполненно.Ширина     = ШиринаЭлементовГруппы;
		ИмяЭлементаВыполненно.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Центр;
		
		СтрокаДерева             = СтрокаГруппы.Строки.Добавить();
		СтрокаДерева.ИмяЭлемента = ИмяЭлементаВыполненно;
		
		Возврат;
		
	КонецЕсли;
	
	Если Пожелание.Vote = 0 Тогда
		
		ИмяЭлементаКнопкиПроголосовать = "Проголосовать" + Строка(Итерация);
		ИмяКоманды = "Команда" + ИмяЭлементаКнопкиПроголосовать;
		
		Команда = Команды.Добавить(ИмяКоманды);
		Команда.Действие = "Проголосовать";
		
		ЭлементСписка = СписокКоманд.Добавить();
		ЭлементСписка.ИмяКоманды             = ИмяКоманды;
		ЭлементСписка.ИдентификаторПожелания = Пожелание.Ref;
		
		КнопкаПроголосовать            = Элементы.Добавить(ИмяЭлементаКнопкиПроголосовать, Тип("КнопкаФормы"), ГруппаРейтинга);
		КнопкаПроголосовать.Заголовок  = "+1";
		КнопкаПроголосовать.ИмяКоманды = Команда.Имя;
		КнопкаПроголосовать.Шрифт      = Новый Шрифт("Tahoma", 10, Истина);
		КнопкаПроголосовать.ЦветТекста = Новый Цвет(5, 177, 4);
		КнопкаПроголосовать.Ширина     = ШиринаЭлементовГруппы - 1;
		
		СтрокаДерева             = СтрокаГруппы.Строки.Добавить();
		СтрокаДерева.ИмяЭлемента = ИмяЭлементаКнопкиПроголосовать;
		
	Иначе
		
		ИмяЭлементаСВашим            = "СВашим" + Строка(Итерация);
		ИмяЭлементаСВашим            = Элементы.Добавить(ИмяЭлементаСВашим, Тип("ДекорацияФормы"), ГруппаРейтинга);
		ИмяЭлементаСВашим.Заголовок  = НСтр("ru = 'c вашим
		                                          |голосом'");
		ИмяЭлементаСВашим.ЦветТекста = Новый Цвет(5, 177, 4);
		ИмяЭлементаСВашим.Высота     = 2;
		ИмяЭлементаСВашим.Ширина     = ШиринаЭлементовГруппы;
		ИмяЭлементаСВашим.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Центр;
		
		СтрокаДерева             = СтрокаГруппы.Строки.Добавить();
		СтрокаДерева.ИмяЭлемента = ИмяЭлементаСВашим;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьГруппуСодержанияДляПожелания(Пожелание, Итерация, РодительскаяГруппа, РодительскаяСтрокаДерева)
	
	ИмяГруппы                                     = "ГруппаСодержания" + Строка(Итерация);
	ГруппаСодержанияПожелания                     = Элементы.Добавить(ИмяГруппы, Тип("ГруппаФормы"), РодительскаяГруппа);
	ГруппаСодержанияПожелания.Вид                 = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаСодержанияПожелания.ОтображатьЗаголовок = Ложь;
	ГруппаСодержанияПожелания.Отображение         = ОтображениеОбычнойГруппы.Нет;
	
	СтрокаГруппы             = РодительскаяСтрокаДерева.Строки.Добавить();
	СтрокаГруппы.ИмяЭлемента = ИмяГруппы;
	
	ИмяЭлементаЗаголовкаПожелания                 = "ЗаголовокПожелания" + Строка(Итерация);
	ЗаголовокПожелания                            = Элементы.Добавить(ИмяЭлементаЗаголовкаПожелания, Тип("ДекорацияФормы"), ГруппаСодержанияПожелания);
	ЗаголовокПожелания.Вид                        = ВидДекорацииФормы.Надпись;
	ЗаголовокПожелания.Заголовок                  = Пожелание.Title;
	ЗаголовокПожелания.Гиперссылка                = Истина;
	ЗаголовокПожелания.Шрифт                      = Новый Шрифт(, 11, Истина);
	ЗаголовокПожелания.ЦветТекста                 = Новый Цвет(51, 51, 51);
	ЗаголовокПожелания.РастягиватьПоГоризонтали   = Истина;
	ЗаголовокПожелания.ВертикальноеПоложение      = ВертикальноеПоложениеЭлемента.Верх;
	ЗаголовокПожелания.УстановитьДействие("Нажатие", "НажатиеНаПожелание");
	
	СтрокаДерева             = СтрокаГруппы.Строки.Добавить();
	СтрокаДерева.ИмяЭлемента = ИмяЭлементаЗаголовкаПожелания;
	
	ЭлементТаблицы = ТаблицаПожеланий.Добавить();
	ЭлементТаблицы.ИмяЭлементаФормы   = ИмяЭлементаЗаголовкаПожелания;
	ЭлементТаблицы.Идентификатор      = Пожелание.Ref;
	
	Если Пожелание.AmountComments = 0 Тогда 
		ЗаголовокКомментариев = НСтр("ru = 'Оставить комментарий'");
	Иначе
		ЗаголовокКомментариев = НСтр("ru = 'Комментарии'") + " (" + Строка(Пожелание.AmountComments) + ")";
	КонецЕсли;
	
	ИмяГруппы                                           = "ГруппаПодвалаПожелания"+ Строка(Итерация);
	ГруппаПодвалаПожелания                              = Элементы.Добавить(ИмяГруппы, Тип("ГруппаФормы"), ГруппаСодержанияПожелания);
	ГруппаПодвалаПожелания.Вид                          = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаПодвалаПожелания.ОтображатьЗаголовок          = Ложь;
	ГруппаПодвалаПожелания.Группировка                  = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	ГруппаПодвалаПожелания.Отображение                  = ОтображениеОбычнойГруппы.Нет;
	
	СтрокаГруппы             = РодительскаяСтрокаДерева.Строки.Добавить();
	СтрокаГруппы.ИмяЭлемента = ИмяГруппы;
	
	ИмяЗаголовкаКомментария                       = "ЗаголовокКомментария" + Строка(Итерация);
	ЗаголовокКомментария                          = Элементы.Добавить(ИмяЗаголовкаКомментария, Тип("ДекорацияФормы"), ГруппаПодвалаПожелания);
	ЗаголовокКомментария.Вид                      = ВидДекорацииФормы.Надпись;
	ЗаголовокКомментария.Заголовок                = ЗаголовокКомментариев;
	ЗаголовокКомментария.Гиперссылка              = Истина;
	ЗаголовокКомментария.РастягиватьПоГоризонтали = Истина;
	ЗаголовокКомментария.ВертикальноеПоложение    = ВертикальноеПоложениеЭлемента.Низ;
	ЗаголовокКомментария.РастягиватьПоВертикали   = Истина;
	ЗаголовокКомментария.УстановитьДействие("Нажатие", "НажатиеНаПожелание");
	
	СтрокаДерева             = СтрокаГруппы.Строки.Добавить();
	СтрокаДерева.ИмяЭлемента = ЗаголовокКомментария;
	
	ИмяПредметаПожелания                                = "ПредметПожелания" + РодительскаяГруппа.Имя + Строка(Итерация);
	ПредметПожелания                                    = Элементы.Добавить(ИмяПредметаПожелания, Тип("ДекорацияФормы"), ГруппаПодвалаПожелания);
	ПредметПожелания.Вид                                = ВидДекорацииФормы.Надпись;
	ПредметПожелания.Шрифт                              = Новый Шрифт( ,9);
	ПредметПожелания.РастягиватьПоГоризонтали           = Истина;
	ПредметПожелания.РастягиватьПоВертикали             = Истина;
	ПредметПожелания.ГоризонтальноеПоложение            = ГоризонтальноеПоложениеЭлемента.Право;
	ПредметПожелания.ВертикальноеПоложение              = ВертикальноеПоложениеЭлемента.Низ;
	ПредметПожелания.Заголовок                          = Пожелание.Subject;
	
	СтрокаДерева             = СтрокаГруппы.Строки.Добавить();
	СтрокаДерева.ИмяЭлемента = ИмяПредметаПожелания;
	
	ЭлементТаблицы = ТаблицаПожеланий.Добавить();
	ЭлементТаблицы.ИмяЭлементаФормы   = ИмяЗаголовкаКомментария;
	ЭлементТаблицы.Идентификатор      = Пожелание.Ref;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФормуПожеланиями(Элемент)
	
	Если Элемент.Имя = "МоиПредложения" Тогда
		ТипГруппы = "My";
	ИначеЕсли Элемент.Имя = "Выполненные" Тогда
		ТипГруппы = "Made";
	Иначе
		ТипГруппы = "Popular";
	КонецЕсли;
	
	
	Результат = СформироватьЭлементыСтраницы(ТипГруппы, 1);
	Если Не Результат Тогда
		Предупреждение(НСтр("ru = 'Сервис по отображению пожеланий пользователей временно не доступен.
								|Пожалуйста, повторите попытку позже'"));
	КонецЕсли;
	
КонецПроцедуры
