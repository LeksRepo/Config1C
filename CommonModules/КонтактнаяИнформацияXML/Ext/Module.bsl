﻿////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контактная информация"
// 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС
//

// Сравнивает два XML и возвращает результат в виде таблицы значений.
//
// Параметры:
//    Текст1, Текст2 - строки с XML данными
//
// Возвращает таблица значений с колонками:
//   - Путь      - строка - XPath путь к месту различия
//   - Значение1 - строка - значение в XML из параметра Текст1
//   - Значение2 - строка - значение в XML из параметра Текст2
//
Функция РазличияXML(Знач Текст1, Знач Текст2) Экспорт
	Возврат ЗначениеИзСтрокиXML( XSLT_ТаблицаЗначенийРазличияXML(Текст1, Текст2) );
КонецФункции

// Возвращает соответствующее значение перечисления "ТипыКонтактнойИнформации" по строке XML
//
// Параметры:
//    XMLСтрока - строка, описывающая контактную информацию
//
Функция ТипКонтактнойИнформации(Знач XMLСтрока) Экспорт
	Возврат ЗначениеИзСтрокиXML( XSLT_ТипКонтактнойИнформацииПоСтрокеXML(XMLСтрока) );
КонецФункции

// Читает строку состава из значения контактной информации
// Если значение состава сложного типа, то возвращает неопределено
//
// Параметры:
//    Текст  XML строка контактной информации. Может быть модифицирован
//
Функция СтрокаСоставаКонтактнойИнформации(Знач Текст, Знач НовоеЗначение = Неопределено) Экспорт
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Текст);
	ОбъектXDTO= ФабрикаXDTO.ПрочитатьXML(Чтение, 
		ФабрикаXDTO.Тип(КонтактнаяИнформацияКлиентСерверПовтИсп.ПространствоИмен(), "КонтактнаяИнформация"));
	
	Состав = ОбъектXDTO.Состав;
	Если Состав <> Неопределено 
		И Состав.Свойства().Получить("Значение") <> Неопределено
		И ТипЗнч(Состав.Значение) = Тип("Строка") 
	Тогда
		Возврат Состав.Значение;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Преобразует строку пар ключ = значение (см старый формат адреса) в структуру.
//
// Параметры:
//    Текст - строка пар ключ = значение, разделенные переносом строки
//
Функция СтрокаКлючЗначениеВСтруктуру(Знач Текст) Экспорт
	Возврат ЗначениеИзСтрокиXML( XSLT_СтрокаКлючЗначениеВСтруктуру(Текст) );
КонецФункции

// Преобразует строку пар ключ-значение (см старый формат адреса) в список значений.
// В возвращаемом списке значений представление - исходный ключ, значение - исходное значение
//
// Параметры:
//    Текст - строка пар ключ = значение, разделенные переносом строки
//
Функция СтрокаКлючЗначениеВСписокЗначений(Знач Текст, Знач УникальностьПолей = Истина) Экспорт
	Если УникальностьПолей Тогда
		Возврат ЗначениеИзСтрокиXML( XSLT_УникальныеПоПредставлениюВСписке(XSLT_СтрокаКлючЗначениеВСписокЗначений(Текст)) );
	КонецЕсли;
	Возврат ЗначениеИзСтрокиXML( XSLT_СтрокаКлючЗначениеВСписокЗначений(Текст) );
КонецФункции

// Преобразует структуру в строку пар ключ-значение, разделенный запятыми
//
// Параметры:
//    Структура - исходная структура
//
Функция СтруктураВСтрокуКлючЗначение(Знач Структура) Экспорт
	Возврат XSLT_СтруктураВСтрокуКлючЗначение( ЗначениеВСтрокуXML(Структура) );
КонецФункции

// Преобразует список значений в строку пар ключ-значение, разделенный запятыми
//
// Параметры:
//    Список - список значений
//
Функция СписокЗначенийВСтрокуКлючЗначение(Знач Список) Экспорт
	Возврат XSLT_СписокЗначенийВСтрокуКлючЗначение( ЗначениеВСтрокуXML(Список) );
КонецФункции

// Преобразует структуру в список значений. Ключ преобразуется в представление.
//
// Параметры:
//    Структура - исходная структура
//
Функция СтруктураВСписокЗначений(Знач Структура) Экспорт
	Возврат ЗначениеИзСтрокиXML( XSLT_СтруктураВСписокЗначений( ЗначениеВСтрокуXML(Структура) ) );
КонецФункции

// Преобразует список значений в структуру. Представление преобразуется в ключ.
//
// Параметры:
//    Структура - исходная структура
//
Функция СписокЗначенийВСтруктуру(Знач Список) Экспорт
	Возврат ЗначениеИзСтрокиXML( XSLT_СписокЗначенийВСтруктуру( ЗначениеВСтрокуXML(Список) ) );
КонецФункции

// Сравнивает два экземпляра контактной инфромации.
//
// Параметры:
//    Данные1, Данные2 - данные экземпляров контактной информации. Каждый параметр независимо может принимать 
//    значения следующих типов:
//        - ОбъектXTDO. Рассматривается как объект с контактной информацией
//        - Строка. Рассматривается как контактная информация в формате XML
//        - Структура, описывающие контактную информацию. Ожидаются поля:
//            ЗначенияПолей           - строка (XML или старый формат ключ-значение), структура, список значений, 
//                                      соответствие. Если в этом поле передана строка XML, то остальные поля 
//                                      структуры игнорируются.
//            Представление           - строка представления. Используется в случае, если не удалось вычислить 
//                                      представление из ЗначенияПолей (отсутствие в них поля Представление)
//            ВидКонтактнойИнформации - ссылка на справочник ВидыКонтактнойИнформации или значение перечисления 
//                                      ТипыКонтактнойИнформации. Используется в случае, если не удалось вычислить 
//                                      тип из ЗначенияПолей
//            Комментарий             - строка комментария. Используется в случае, если не удалось вычислить 
//                                      комментарий из ЗначенияПолей
//
// Возвращает таблицу отличающихся полей со следующими колонками:
//    Путь      - строка XPath, идентифицирующая различающееся значение. Значение "ТипКонтактнойИнформации" означает,
//                что переданные экземпляры контактной информации различаются типом.
//    Описание  - строка описания отличающегося реквизита в терминах предметной области
//    Значение1 - строка значения, соответствующая объекту, переданному в параметре Данные1
//    Значение2 - строка значения, соответствующая объекту, переданному в параметре Данные2
//
Функция РазличияКонтактнойИнформации(Знач Данные1, Знач Данные2) Экспорт
	ДанныеКИ1 = ПривестиКонтактнуюИнформациюXML(Данные1);
	ДанныеКИ2 = ПривестиКонтактнуюИнформациюXML(Данные2);
	
	ТипКонтактнойИнформации = ДанныеКИ1.ТипКонтактнойИнформации;
	Если ТипКонтактнойИнформации <> ДанныеКИ2.ТипКонтактнойИнформации Тогда
		// Различные типы, дальше не сравниваем
		Результат = Новый ТаблицаЗначений;
		Колонки   = Результат.Колонки;
		СтрокаРезультата = Результат.Добавить();
		СтрокаРезультата[Колонки.Добавить("Путь").Имя]      = "ТипКонтактнойИнформации";
		СтрокаРезультата[Колонки.Добавить("Значение1").Имя] = ДанныеКИ1.ТипКонтактнойИнформации;
		СтрокаРезультата[Колонки.Добавить("Значение2").Имя] = ДанныеКИ2.ТипКонтактнойИнформации;
		СтрокаРезультата[Колонки.Добавить("Описание").Имя]  = НСтр("ru = 'Различные типы контактной информации'");
		Возврат Результат;
	КонецЕсли;
	
	ТекстРазличияXML = XSLT_ТаблицаЗначенийРазличияXML(ДанныеКИ1.ДанныеXML, ДанныеКИ2.ДанныеXML);
	
	// Отдаем интерпретацию в зависимости от типа
	Возврат ЗначениеИзСтрокиXML( XSLT_ИнтерпретацияРазличияXMLКонтактнойИнформации(
			ТекстРазличияXML, ТипКонтактнойИнформации));
	
КонецФункции

// Преобразует контактную информацию в вид XML
//
// Параметры:
//    Данные - строка XML, объект XTDO или структура, описывающие контактную информацию.
//       В структуре ожидаются поля:
//           "ЗначенияПолей" - строка (XML или старый формат ключ-значение) или структура или список значений.
//           Если в этом поле передана строка XML, то остальные поля игнорируются
//           "ВидКонтактнойИнформации" - СправочникСсылка.ВидыКонтактнойИнформации 
//                                       или Перечисление.ТипыКонтактнойИнформации
//           "Представление" - строка представления
//           "Комментарий" - необязательная строка комментария
//
// Возвращаемое значение - структура с полями:
//    ТипКонтактнойИнформации - Перечисление.ТипыКонтактнойИнформации
//    ДанныеXML               - строка с текстом XML
//
Функция ПривестиКонтактнуюИнформациюXML(Знач Данные) Экспорт
	Если ЭтоСтрокаXML(Данные) Тогда
		Возврат Новый Структура("ДанныеXML, ТипКонтактнойИнформации",
			Данные, ЗначениеИзСтрокиXML( XSLT_ТипКонтактнойИнформацииПоСтрокеXML(Данные) ));
		
	ИначеЕсли ТипЗнч(Данные) = Тип("ОбъектXDTO") Тогда
		ДанныеXML = КонтактнаяИнформацияСлужебный.СериализацияКонтактнойИнформации(Данные);
		Возврат Новый Структура("ДанныеXML, ТипКонтактнойИнформации",
			ДанныеXML, ЗначениеИзСтрокиXML( XSLT_ТипКонтактнойИнформацииПоСтрокеXML(ДанныеXML) ));
		
	КонецЕсли;
	// Ожидаем структуру
	
	Комментарий = Неопределено;
	Данные.Свойство("Комментарий", Комментарий);
	
	ЗначенияПолей = Данные.ЗначенияПолей;
	Если ЭтоСтрокаXML(ЗначенияПолей) Тогда 
		// Возможно необходимо переопределить комментарий
		Если Не ПустаяСтрока(Комментарий) Тогда
			КонтактнаяИнформацияСлужебный.КомментарийКонтактнойИнформации(ЗначенияПолей, Комментарий);
		КонецЕсли;
		Возврат Новый Структура("ДанныеXML, ТипКонтактнойИнформации",
			ЗначенияПолей, ЗначениеИзСтрокиXML( XSLT_ТипКонтактнойИнформацииПоСтрокеXML(ЗначенияПолей) ));
		
	КонецЕсли;
	
	// Разбираем по ЗначенияПолей, ВидКонтактнойИнформации, Представление
	ТипЗначенийПолей = ТипЗнч(ЗначенияПолей);
	Если ТипЗначенийПолей = Тип("Строка") Тогда
		// Текст из пар ключ-значение
		СтрокаXMLСтруктуры = XSLT_СтрокаКлючЗначениеВСтруктуру(ЗначенияПолей)
	ИначеЕсли ТипЗначенийПолей = Тип("СписокЗначений") Тогда
		// Список значений
		СтрокаXMLСтруктуры = XSLT_СписокЗначенийВСтруктуру( ЗначениеВСтрокуXML(ЗначенияПолей) );
	ИначеЕсли ТипЗначенийПолей = Тип("Соответствие") Тогда
		// Соответствие
		СтрокаXMLСтруктуры = XSLT_СоответствиеВСтруктуру( ЗначениеВСтрокуXML(ЗначенияПолей) );
	Иначе
		// Ожидаем структуру
		СтрокаXMLСтруктуры = ЗначениеВСтрокуXML(ЗначенияПолей);
	КонецЕсли;
	
	// Разбираем по ВидКонтактнойИнформации
	ТипКонтактнойИнформации = УправлениеКонтактнойИнформацией.ТипВидаКонтактнойИнформации(
		Данные.ВидКонтактнойИнформации);
	Результат = Новый Структура("ТипКонтактнойИнформации, ДанныеXML", ТипКонтактнойИнформации);
	
	ВсеТипы = Перечисления.ТипыКонтактнойИнформации;
	Если ТипКонтактнойИнформации = ВсеТипы.Адрес Тогда
		Результат.ДанныеXML = XSLT_СтруктураВАдрес(СтрокаXMLСтруктуры, Данные.Представление, Комментарий);
		
	ИначеЕсли ТипКонтактнойИнформации = ВсеТипы.АдресЭлектроннойПочты Тогда
		Результат.ДанныеXML = XSLT_СтруктураВАдресЭлектроннойПочты(СтрокаXMLСтруктуры, Данные.Представление, Комментарий);
		
	ИначеЕсли ТипКонтактнойИнформации = ВсеТипы.ВебСтраница Тогда
		Результат.ДанныеXML = XSLT_СтруктураВВебСтраницу(СтрокаXMLСтруктуры, Данные.Представление, Комментарий);
		
	ИначеЕсли ТипКонтактнойИнформации = ВсеТипы.Телефон Тогда
		Результат.ДанныеXML = XSLT_СтруктураВТелефон(СтрокаXMLСтруктуры, Данные.Представление, Комментарий);
		
	ИначеЕсли ТипКонтактнойИнформации = ВсеТипы.Факс Тогда
		Результат.ДанныеXML = XSLT_СтруктураВФакс(СтрокаXMLСтруктуры, Данные.Представление, Комментарий);
		
	ИначеЕсли ТипКонтактнойИнформации = ВсеТипы.Другое Тогда
		Результат.ДанныеXML = XSLT_СтруктураВДругое(СтрокаXMLСтруктуры, Данные.Представление, Комментарий);
		
	Иначе
		ВызватьИсключение НСтр("ru = 'Ошибка параметров преобразования, не определен тип контактной информации'");
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

// Преобразует список значений, оставляя из него только последние значения пар ключ-значение по ключу-представлению.
//
// Параметры:
//    Текст - сериализованный список значений
//
// Возвращаемое значение - строка XML сериализованного списка значений
//
Функция XSLT_УникальныеПоПредставлениюВСписке(Знач Текст)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_УникальныеПоПредставлениюВСписке();
	Возврат Преобразователь.ПреобразоватьИзСтроки(Текст);
КонецФункции

// Производит проверку двух строк XML - параметра и текущего
//    Результат преобразования - сериализованый ValueTable (http://v8.1c.ru/8.1/data/core), в котором три колонки:
//       - Путь      - строка - путь к месту различия
//       - Значение1 - строка - значение в XML из параметра Текст1
//       - Значение2 - строка - значение в XML из параметра Текст2
//
//    Проверяем только строки и атрибуты, без пробельных, CDATA и т.п. Порядок важен.
//
Функция XSLT_ТаблицаЗначенийРазличияXML(Текст1, Текст2)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_ТаблицаЗначенийРазличияXML();
	
	Построитель = Новый ТекстовыйДокумент;
	Построитель.ДобавитьСтроку("<dn><f>");
	Построитель.ДобавитьСтроку( XSLT_УдалитьОписаниеXML(Текст1) );
	Построитель.ДобавитьСтроку("</f><s>");
	Построитель.ДобавитьСтроку( XSLT_УдалитьОписаниеXML(Текст2) );
	Построитель.ДобавитьСтроку("</s></dn>");
	
	Возврат Преобразователь.ПреобразоватьИзСтроки( Построитель.ПолучитьТекст() );
КонецФункции

// Преобразует текст с парами Ключ = Значение, разделенных переносами строк (см формат адреса) в XML.
// В случае повторных ключей все включаются в результат, но при десериализации будет использован 
// последний (особенность работы сериализатора платформы)
//
// Параметры:
//    Текст - строка с парами Ключ = Значение
//
// Возвращаемое значение - строка XML сериализованной структуры
//
Функция XSLT_СтрокаКлючЗначениеВСтруктуру(Знач Текст) 
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_СтрокаКлючЗначениеВСтруктуру();
	Возврат Преобразователь.ПреобразоватьИзСтроки( XSLT_УзелСтрокиПараметра(Текст) );
КонецФункции

// Преобразует текст с парами Ключ = Значение, разделенных переносами строк (см формат адреса) в XML.
// В случае повторных ключей все включаются в результат
//
// Параметры:
//    Текст - строка с парами Ключ = Значение
//
// Возвращаемое значение - строка XML сериализованного списка значений
//
Функция XSLT_СтрокаКлючЗначениеВСписокЗначений(Знач Текст)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_СтрокаКлючЗначениеВСписокЗначений();
	Возврат Преобразователь.ПреобразоватьИзСтроки( XSLT_УзелСтрокиПараметра(Текст) );
КонецФункции

// Преобразует список значений в строку пар ключ = значение, разделенных переносом строки
//
// Параметры:
//    Текст - сериализованный список значений
//
// Возвращаемое значение - строка результата
//
Функция XSLT_СписокЗначенийВСтрокуКлючЗначение(Знач Текст)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_СписокЗначенийВСтрокуКлючЗначение();
	Возврат Преобразователь.ПреобразоватьИзСтроки(Текст);
КонецФункции

// Преобразует структуру в строку пар ключ = значение, разделенных переносом строки
//
// Параметры:
//    Текст - сериализованная структура
//
// Возвращаемое значение - строка результата
//
Функция XSLT_СтруктураВСтрокуКлючЗначение(Знач Текст)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_СтруктураВСтрокуКлючЗначение();
	Возврат Преобразователь.ПреобразоватьИзСтроки(Текст);
КонецФункции

// Преобразует список значений в структур. Представление преобразуется в ключ
//
// Параметры:
//    Текст - сериализованный список значений
//
// Возвращаемое значение - сериализованная структура
//
Функция XSLT_СписокЗначенийВСтруктуру(Текст)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_СписокЗначенийВСтруктуру();
	Возврат Преобразователь.ПреобразоватьИзСтроки(Текст);
КонецФункции

// Преобразует структуру в список значений. Ключ преобразуется в представление.
//
// Параметры:
//    Текст - сериализованная структура
//
// Возвращаемое значение - сериализованный список значений
//
Функция XSLT_СтруктураВСписокЗначений(Текст)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_СтруктураВСписокЗначений();
	Возврат Преобразователь.ПреобразоватьИзСтроки(Текст);
КонецФункции

// Преобразует соответсвие в структуру. Ключ преобразуется в ключ, значение - в значение.
//
// Параметры:
//    Текст - сериализованное соответствие
//
// Возвращаемое значение - сериализованная структура
//
Функция XSLT_СоответствиеВСтруктуру(Текст)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_СоответствиеВСтруктуру();
	Возврат Преобразователь.ПреобразоватьИзСтроки(Текст);
КонецФункции

// Анализирует таблицу Путь-Значение1-Значение2 для указанного вида контактной информации
//
// Параметры:
//    Текст - строка XML с ValueTable из результата сравнения XML. Ожидаются колонки 
//            "Путь", "Значение1", "Значение2".
//    ТипКонтактнойИнформации - значение перечисления типа
//
// Возвращает сериализованную таблицу значений отличающихся полей с колонками
// "Путь", "Описание", "Значение1", "Значение2".
//
Функция XSLT_ИнтерпретацияРазличияXMLКонтактнойИнформации(Знач Текст, Знач ТипКонтактнойИнформации) 
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_ИнтерпретацияРазличияXMLКонтактнойИнформации(
		ТипКонтактнойИнформации);
	Возврат Преобразователь.ПреобразоватьИзСтроки(Текст);
КонецФункции

// Преобразует структуру в XML контакной информации
//
// Параметры:
//    Текст         - сериализованная структура
//    Представление - необязательное представление. Используется, только если в структуре нет поля представления
//    Комментарий   - необязательный комментарий. Используется, только если в структуре нет поля комментария
//
// Возвращаемое значение - XML контактной информации
//
Функция XSLT_СтруктураВАдрес(Знач Текст, Знач Представление = Неопределено, Знач Комментарий = Неопределено)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_СтруктураВАдрес();
	Возврат XSLT_КонтрольПредставленияИКомментария(
		Преобразователь.ПреобразоватьИзСтроки(Текст),
		Представление, Комментарий);
КонецФункции

// Преобразует структуру в XML контакной информации
//
// Параметры:
//    Текст         - сериализованная структура
//    Представление - необязательное представление. Используется, только если в структуре нет поля представления
//    Комментарий   - необязательный комментарий. Используется, только если в структуре нет поля комментария
//
// Возвращаемое значение - XML контактной информации
//
Функция XSLT_СтруктураВАдресЭлектроннойПочты(Знач Текст, Знач Представление = Неопределено, Знач Комментарий = Неопределено)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_СтруктураВАдресЭлектроннойПочты();
	
	Возврат XSLT_КонтрольПредставленияИКомментария(
		XSLT_КонтрольСтроковогоЗначенияПростогоТипа( Преобразователь.ПреобразоватьИзСтроки(Текст), Представление),
		Представление, Комментарий);
КонецФункции

// Преобразует структуру в XML контакной информации
//
// Параметры:
//    Текст         - сериализованная структура
//    Представление - необязательное представление. Используется, только если в структуре нет поля представления
//    Комментарий   - необязательный комментарий. Используется, только если в структуре нет поля комментария
//
// Возвращаемое значение - XML контактной информации
//
Функция XSLT_СтруктураВВебСтраницу(Знач Текст, Знач Представление = Неопределено, Знач Комментарий = Неопределено)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_СтруктураВВебСтраницу();
	
	Возврат XSLT_КонтрольПредставленияИКомментария(
		XSLT_КонтрольСтроковогоЗначенияПростогоТипа( Преобразователь.ПреобразоватьИзСтроки(Текст), Представление),
		Представление, Комментарий);
КонецФункции

// Преобразует структуру в XML контакной информации
//
// Параметры:
//    Текст         - сериализованная структура
//    Представление - необязательное представление. Используется, только если в структуре нет поля представления
//    Комментарий   - необязательный комментарий. Используется, только если в структуре нет поля комментария
//
// Возвращаемое значение - XML контактной информации
//
Функция XSLT_СтруктураВТелефон(Знач Текст, Знач Представление = Неопределено, Знач Комментарий = Неопределено)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_СтруктураВТелефон();
	Возврат XSLT_КонтрольПредставленияИКомментария(
		Преобразователь.ПреобразоватьИзСтроки(Текст),
		Представление, Комментарий);
КонецФункции

// Преобразует структуру в XML контакной информации
//
// Параметры:
//    Текст         - сериализованная структура
//    Представление - необязательное представление. Используется, только если в структуре нет поля представления
//    Комментарий   - необязательный комментарий. Используется, только если в структуре нет поля комментария
//
// Возвращаемое значение - XML контактной информации
//
Функция XSLT_СтруктураВФакс(Знач Текст, Знач Представление = Неопределено, Знач Комментарий = Неопределено)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_СтруктураВФакс();
	Возврат XSLT_КонтрольПредставленияИКомментария(
		Преобразователь.ПреобразоватьИзСтроки(Текст),
		Представление, Комментарий);
КонецФункции

// Преобразует структуру в XML контакной информации
//
// Параметры:
//    Текст         - сериализованная структура
//    Представление - необязательное представление. Используется, только если в структуре нет поля представления
//    Комментарий   - необязательный комментарий. Используется, только если в структуре нет поля комментария
//
// Возвращаемое значение - XML контактной информации
//
Функция XSLT_СтруктураВДругое(Знач Текст, Знач Представление = Неопределено, Знач Комментарий = Неопределено)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_СтруктураВДругое();
	
	Возврат XSLT_КонтрольПредставленияИКомментария(
		XSLT_КонтрольСтроковогоЗначенияПростогоТипа( Преобразователь.ПреобразоватьИзСтроки(Текст), Представление),
		Представление, Комментарий);
КонецФункции

// Устанавливает в контактной информации представление и комментарий, если они не заполнены
//
// Параметры:
//    Текст         - XML контактной информации
//    Представление - необязательное устанавливаемое представление.
//    Комментарий   - необязательный устанавливаемый комментарий.
//
// Возвращаемое значение - XML контактной информации
//
Функция XSLT_КонтрольПредставленияИКомментария(Знач Текст, Знач Представление = Неопределено, Знач Комментарий = Неопределено)
	Если Представление = Неопределено И Комментарий = Неопределено Тогда
		Возврат Текст;
	КонецЕсли;
	
	XSLT_Текст = Новый ТекстовыйДокумент;
	XSLT_Текст.ДобавитьСтроку("
		|<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""
		|  xmlns:tns=""http://www.v8.1c.ru/ssl/contactinfo""
		|>
		|  <xsl:output method=""xml"" omit-xml-declaration=""yes"" indent=""yes"" encoding=""utf-8""/>
		|
		|  <xsl:template match=""node() | @*"">
		|    <xsl:copy>
		|      <xsl:apply-templates select=""node() | @*"" />
		|    </xsl:copy>
		|  </xsl:template>
		|");
		
	Если Представление <> Неопределено Тогда
		XSLT_Текст.ДобавитьСтроку("
		|  <xsl:template match=""tns:КонтактнаяИнформация/@Представление"">
		|    <xsl:attribute name=""Представление"">
		|      <xsl:choose>
		|        <xsl:when test="".=''"">" + МногострочнаяСтрокаXML(Представление) + "</xsl:when>
		|        <xsl:otherwise>
		|          <xsl:value-of select="".""/>
		|        </xsl:otherwise>
		|      </xsl:choose>
		|    </xsl:attribute>
		|  </xsl:template>
		|");
	КонецЕсли;
	
	Если Комментарий <> Неопределено Тогда
		XSLT_Текст.ДобавитьСтроку("
		|  <xsl:template match=""tns:КонтактнаяИнформация/tns:Комментарий"">
		|    <xsl:element name=""Комментарий"">
		|      <xsl:choose>
		|        <xsl:when test=""text()=''"">" + МногострочнаяСтрокаXML(Комментарий) + "</xsl:when>
		|        <xsl:otherwise>
		|          <xsl:value-of select="".""/>
		|        </xsl:otherwise>
		|      </xsl:choose>
		|    </xsl:attribute>
		|  </xsl:template>
		|");
	КонецЕсли;
		XSLT_Текст.ДобавитьСтроку("
		|</xsl:stylesheet>
		|");
		
	Преобразователь = Новый ПреобразованиеXSL;
	Преобразователь.ЗагрузитьИзСтроки( XSLT_Текст.ПолучитьТекст() );
	
	Возврат Преобразователь.ПреобразоватьИзСтроки(Текст);
КонецФункции

// Устанавливает в контактной информации Состав.Значение на переданное представление
//
// Параметры:
//    Текст         - XML контактной информации
//    Представление - устанавливаемое представление.
//
// Если Представление равно неопределено, то никаких действий не производит. Иначе проверяет на пустоту
// Состав. Если там ничего нет и атрибут "Состав.Значение" пуст, то ставим в состав значение представления
//
Функция XSLT_КонтрольСтроковогоЗначенияПростогоТипа(Знач Текст, Знач Представление)
	Если Представление = Неопределено Тогда
		Возврат Текст;
	КонецЕсли;
	
	Преобразователь = Новый ПреобразованиеXSL;
	Преобразователь.ЗагрузитьИзСтроки("
		|<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""
		|  xmlns:tns=""http://www.v8.1c.ru/ssl/contactinfo""
		|>
		|  <xsl:output method=""xml"" omit-xml-declaration=""yes"" indent=""yes"" encoding=""utf-8""/>
		|  
		|  <xsl:template match=""node() | @*"">
		|    <xsl:copy>
		|      <xsl:apply-templates select=""node() | @*"" />
		|    </xsl:copy>
		|  </xsl:template>
		|  
		|  <xsl:template match=""tns:КонтактнаяИнформация/tns:Состав/@Значение"">
		|    <xsl:attribute name=""Значение"">
		|      <xsl:choose>
		|        <xsl:when test="".=''"">" + МногострочнаяСтрокаXML(Представление) + "</xsl:when>
		|        <xsl:otherwise>
		|          <xsl:value-of select="".""/>
		|        </xsl:otherwise>
		|      </xsl:choose>
		|    </xsl:attribute>
		|  </xsl:template>
		|
		|</xsl:stylesheet>
		|");
	
	Возврат Преобразователь.ПреобразоватьИзСтроки(Текст);
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Возвращает фрагмент XML для подстановки строки в виде <Узел>Строка<Узел>
//
// Параметры:
//    - Текст       - строка, вставляемая в XML
//    - ИмяЭлемента - необязательное имя для внешнего узла
//
Функция XSLT_УзелСтрокиПараметра(Знач Текст, Знач ИмяЭлемента = "ExternalParamNode")
	// Через запись xml для маскировки спецсимволов
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	Запись.ЗаписатьНачалоЭлемента(ИмяЭлемента);
	Запись.ЗаписатьТекст(Текст);
	Запись.ЗаписатьКонецЭлемента();
	Возврат Запись.Закрыть();
КонецФункции

// Возвращает XML без описания <?xml...> для включения внутрь другого XML
//
// Параметры:
//    - Текст - исходный XML
//
Функция XSLT_УдалитьОписаниеXML(Знач Текст)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_УдалитьОписаниеXML();
	Возврат Преобразователь.ПреобразоватьИзСтроки(СокрЛ(Текст));
КонецФункции

// Преобразует текст XML контактной информации в перечисление типа
//
// Параметры:
//    - Текст - исходный XML
//
// Возвращаемое значение - сериализованное значение перечисления ТипыКонтактнойИнформации
//
Функция XSLT_ТипКонтактнойИнформацииПоСтрокеXML(Знач Текст)
	Преобразователь = КонтактнаяИнформацияСлужебныйПовтИсп.XSLT_ТипКонтактнойИнформацииПоСтрокеXML();
	Возврат Преобразователь.ПреобразоватьИзСтроки(СокрЛ(Текст));
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//  Возвращает признак того, является ли текст XML
//
//  Параметры:
//      Текст - проверяемый текст
//
Функция ЭтоСтрокаXML(Текст)
	Возврат ТипЗнч(Текст) = Тип("Строка") И Лев(СокрЛ(Текст),1) = "<";
КонецФункции

// Десериализатор известных платформе типов
Функция ЗначениеИзСтрокиXML(Знач Текст)
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(Текст);
	Возврат СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
КонецФункции

// Сериализатор известных платформе типов
Функция ЗначениеВСтрокуXML(Знач Значение)
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку(Новый ПараметрыЗаписиXML(, , Ложь, Ложь, ""));
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Значение, НазначениеТипаXML.Явное);
	// Платформенный сериализатор позволяет записать в значение атрибутов перенос строки
	Возврат СтрЗаменить(ЗаписьXML.Закрыть(), Символы.ПС, "&#10;");
КонецФункции

// Для работы с атрибутами содержащими переносы строк
Функция МногострочнаяСтрокаXML(Знач Текст)
	Возврат СтрЗаменить(Текст, Символы.ПС, "&#10;");
КонецФункции
