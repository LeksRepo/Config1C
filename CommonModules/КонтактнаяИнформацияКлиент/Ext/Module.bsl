﻿////////////////////////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контактная информация"
// 
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

//  Конструктор для структуры параметров открытия формы контактной информации
//
//  Параметры:
//      ВидКонтактнойИнформации - вид редактируемой информации, СправочникСсылка.ВидыКонтактнойИнформации
//      Значение                - строка с сериализованным значением полей контактной информации
//      Представление           - необязательное представление
//
Функция ПараметрыФормыКонтактнойИнформации(ВидКонтактнойИнформации, Значение, Представление=Неопределено) Экспорт
	Возврат Новый Структура("ВидКонтактнойИнформации, ЗначенияПолей, Представление",
	ВидКонтактнойИнформации, Значение, Представление
	);
КонецФункции

//  Открывает подходящую форму контактной информации для редактирования или просмотра
//
//  Параметры:
//      Параметры    - результат функции ПараметрыФормыКонтактнойИнформации
//      Владелец     - параметр для открываемой формы
//      Уникальность - параметр для открываемой формы
//      Окно         - параметр для открываемой формы
//
Процедура ОткрытьФормуКонтактнойИнформации(Параметры, Владелец=Неопределено, Уникальность=Неопределено, Окно=Неопределено) Экспорт
	ОткрытьФормуКонтактнойИнформацииВнутр(Параметры, Владелец, Уникальность, Окно);
КонецПроцедуры

//  Модально открывает подходящую форму контактной информации для редактирования или просмотра
//
//  Параметры:
//      Параметры    - результат функции ПараметрыФормыКонтактнойИнформации
//      Владелец     - параметр для открываемой формы
//      Уникальность - параметр для открываемой формы
//      Окно         - параметр для открываемой формы
//      Таймаут      - параметр для открываемой формы
//
Функция ОткрытьФормуКонтактнойИнформацииМодально(Параметры, Владелец=Неопределено, Уникальность=Неопределено, Окно=Неопределено) Экспорт
	Возврат ОткрытьФормуКонтактнойИнформацииВнутр(Параметры, Владелец, Уникальность, Окно, Истина);
КонецФункции

//  Обработчик события НачалоВыбора для улицы
//
//  Параметры:
//      Элемент                            - вызывающий элемент формы
//      КодКлассификатораНаселенногоПункта - ограничение по населенному пункту
//      ТекущееЗначение                    - текущее значение - или код классификатора, или текст
//      ПараметрыФормы                     - необязательная дополнительная структура параметров для формы подбора
//
Процедура НачалоВыбораУлицы(Элемент, КодКлассификатораНаселенногоПункта, ТекущееЗначение, ПараметрыФормы=Неопределено) Экспорт
	Если КодКлассификатораНаселенногоПункта<=0 Тогда
		Возврат;
	КонецЕсли;
	
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	ИмяПеречисленияКЛАДР = "Перечисление.ВариантыАдресногоКлассификатора.КЛАДР";
	Если Вариант=Неопределено Тогда
		// Нет подсистемы классификатора
		Возврат;
	ИначеЕсли Вариант=ПредопределенноеЗначение(ИмяПеречисленияКЛАДР) Тогда
		НачалоВыбораУлицыКЛАДР(Элемент, КодКлассификатораНаселенногоПункта, ТекущееЗначение, ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры    

//  Обработчик события НачалоВыбора для элемента адреса (субъект РФ, район, город и т.п.)
//
//  Параметры:
//      Элемент        - вызывающий элемент формы
//      КодЧастиАдреса - идентификатор обрабатываемой части адреса, зависит от классификатора
//      ЧастиАдреса    - значения для других частей адреса, зависит от классификатора
//      ПараметрыФормы - необязательная  дополнительная структура параметров для формы подбора
//
Процедура НачалоВыбораЭлементаАдреса(Элемент, КодЧастиАдреса, ЧастиАдреса, ПараметрыФормы=Неопределено) Экспорт
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	ИмяПеречисленияКЛАДР = "Перечисление.ВариантыАдресногоКлассификатора.КЛАДР";
	
	Если Вариант=Неопределено Тогда
		// Нет подсистемы классификатора
		Возврат;
	ИначеЕсли Вариант=ПредопределенноеЗначение(ИмяПеречисленияКЛАДР) Тогда
		НачалоВыбораЭлементаАдресаКЛАДР(Элемент, КодЧастиАдреса, ЧастиАдреса, ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

//  Возвращает полное наименование для населенного пункта. Под населенным пунктом понимается синтетическое 
//  поле, характеризующее все, что больше улицы
//
//  Параметры:
//      ЧастиАдреса - значения для частей адреса, зависит от классификатора
//
Функция НаименованиеНаселенногоПунктаПоЧастямАдреса(ЧастиАдреса) Экспорт
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	ИмяПеречисленияКЛАДР = "Перечисление.ВариантыАдресногоКлассификатора.КЛАДР";
	
	Если Вариант=Неопределено Тогда
		// Нет подсистемы классификатора
		Возврат "";
	ИначеЕсли Вариант=ПредопределенноеЗначение(ИмяПеречисленияКЛАДР) Тогда
		Возврат НаименованиеНаселенногоПунктаПоЧастямАдресаКЛАДР(ЧастиАдреса)
	КонецЕсли;
	
	Возврат "";
КонецФункции    

//  Предлагает загрузить адресный классификатор
//
//  Параметры:
//      Текст - строка с дополнительным текстов предложения
//
Процедура ПредложениеЗагрузкиКлассификатора(Текст="") Экспорт
	
#Если ВебКлиент Тогда
	Возврат;
#КонецЕсли
	
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	ИмяПеречисленияКЛАДР = "Перечисление.ВариантыАдресногоКлассификатора.КЛАДР";
	
	Если Вариант=Неопределено Тогда
		// Нет подсистемы классификатора
		Возврат;
	ИначеЕсли Вариант<>ПредопределенноеЗначение(ИмяПеречисленияКЛАДР) Тогда
		Возврат;    
	КонецЕсли;
	
	ТекстЗаголовка = НСтр("ru='Подтверждение'");
	ТекстВопроса   = Текст + Символы.ПС + НСтр("ru='Загрузить классификатор сейчас?'");
	
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ТекстЗаголовка);
	Если Ответ=КодВозвратаДиалога.Да Тогда
		ЗагрузитьАдресныйКлассификатор();
	КонецЕсли;
	
КонецПроцедуры

//  Загружает адресный классификатор
//
Процедура ЗагрузитьАдресныйКлассификатор() Экспорт
#Если ВебКлиент Тогда
	Возврат;
#КонецЕсли
	
	Вариант = КонтактнаяИнформацияКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	ИмяПеречисленияКЛАДР = "Перечисление.ВариантыАдресногоКлассификатора.КЛАДР";
	
	Если Вариант=Неопределено Тогда
		// Нет подсистемы классификатора
		Возврат;
	ИначеЕсли Вариант=ПредопределенноеЗначение(ИмяПеречисленияКЛАДР) Тогда
		Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
			МодульКЛАДР = Вычислить("АдресныйКлассификаторКлиент");
			МодульКЛАДР.ЗагрузитьАдресныйКлассификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры    

////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

Функция ОткрытьФормуКонтактнойИнформацииВнутр(Параметры, Владелец, Уникальность, Окно, Модально=Ложь) 
	
	Если Не Параметры.Свойство("Заголовок") Тогда
		Параметры.Вставить("Заголовок", Строка(Параметры.ВидКонтактнойИнформации));
	КонецЕсли;
	
	ИмяОткрываемойФормы = КонтактнаяИнформацияКлиентСерверПовтИсп.ИмяФормыВводаКонтактнойИнформации(Параметры.ВидКонтактнойИнформации);
	Если ИмяОткрываемойФормы=Неопределено Тогда
		ВызватьИсключение НСтр("ru='Не обрабатываемый тип адреса: """ + Параметры.ВидКонтактнойИнформации + """'");            
	КонецЕсли;
	
	Если Модально Тогда
		Возврат ОткрытьФормуМодально(ИмяОткрываемойФормы, Параметры, Владелец);
	КонецЕсли;
	
	ОткрытьФорму(ИмяОткрываемойФормы, Параметры, Владелец, Уникальность, Окно);
	Возврат Неопределено;
КонецФункции

// -------------------------------------------------------------------------------------------------
// Реализация КЛАДР
//

Процедура НачалоВыбораУлицыКЛАДР(Элемент, КодКлассификатораНаселенногоПункта, ТекущееЗначение, Параметры=Неопределено)
	ПараметрыФормы = ?(Параметры=Неопределено, Новый Структура, Параметры);
	
	ПараметрыФормы.Вставить("Уровень", 5);
	ПараметрыФормы.Вставить("Улица",   Строка(ТекущееЗначение));
	
	ИмяФормыКЛАДР = "РегистрСведений.АдресныйКлассификатор.Форма.ФормаВыбора";
	ОткрытьФорму(ИмяФормыКЛАДР, ПараметрыФормы, Элемент);
КонецПроцедуры

Процедура НачалоВыбораЭлементаАдресаКЛАДР(Элемент, КодЧастиАдреса, ЧастиАдреса, Параметры=Неопределено)
	
	ПараметрыФормы = ?(Параметры=Неопределено, Новый Структура, Параметры);
	
	ПараметрыФормы.Вставить("Регион", ЧастиАдреса.Регион.Значение);
	ПараметрыФормы.Вставить("Район", ЧастиАдреса.Район.Значение);
	ПараметрыФормы.Вставить("Город", ЧастиАдреса.Город.Значение);
	ПараметрыФормы.Вставить("НаселенныйПункт", ЧастиАдреса.НаселенныйПункт.Значение);
	
	КодРеквизита = ВРег(КодЧастиАдреса);
	Если КодРеквизита="РЕГИОН" Тогда
		Уровень = 1;    
	ИначеЕсли КодРеквизита="РАЙОН" Тогда
		Уровень = 2;    
	ИначеЕсли КодРеквизита="ГОРОД" Тогда
		Уровень = 3;
	ИначеЕсли КодРеквизита="НАСЕЛЕННЫЙПУНКТ" Тогда
		Уровень = 4;
	ИначеЕсли КодРеквизита="УЛИЦА" Тогда
		Уровень = 5;
	Иначе
		Возврат;
	КонецЕсли;        
	ПараметрыФормы.Вставить("Уровень", Уровень);
	
	ИмяФормыКЛАДР = "РегистрСведений.АдресныйКлассификатор.Форма.ФормаВыбора";
	ОткрытьФорму(ИмяФормыКЛАДР, ПараметрыФормы, Элемент);
КонецПроцедуры

Функция НаименованиеНаселенногоПунктаПоЧастямАдресаКЛАДР(ЧастиАдреса)
	Возврат КонтактнаяИнформацияКлиентСервер.ПолноеНаименование(
		ЗначениеИлиНаименование(ЧастиАдреса.НаселенныйПункт), "", 
		ЗначениеИлиНаименование(ЧастиАдреса.Город), "", 
		ЗначениеИлиНаименование(ЧастиАдреса.Район), "", 
		ЗначениеИлиНаименование(ЧастиАдреса.Регион), "", 
	);
КонецФункции

// -------------------------------------------------------------------------------------------------
// Общие служебные методы
//

Функция ЗначениеИлиНаименование(ЧастьАдреса)
	Если ПустаяСтрока(ЧастьАдреса.Значение) Тогда
		Возврат СокрЛП("" + ЧастьАдреса.Наименование + " " + ЧастьАдреса.Сокращение);
	КонецЕсли;
	Возврат ЧастьАдреса.Значение;
КонецФункции

