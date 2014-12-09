﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция УстановитьПараметрыЗапроса(НачалоПериода, КонецПериода)
	
	Список.Параметры.УстановитьЗначениеПараметра("НачалоПериода", НачалоПериода);
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода", КонецПериода);
	
КонецФункции // УстановитьПараметрыЗапроса()

&НаСервере
Функция УстановитьОтборПоПериоду(Текущий, НомерДокумента = Неопределено)
	
	// Текущий -- булево,
	// истина - 5 дней, ложь - все время
	
	СекундВСутках = 86400;
	Если Текущий Тогда
		НачалоПериода = НачалоДня(ТекущаяДата()) - СекундВСутках * 2;
		КонецПериода = КонецДня(ТекущаяДата()) + СекундВСутках * 2;
	Иначе

		НачалоПериода = Дата('00010101');
		КонецПериода = Дата('39990101');
		
	КонецЕсли;
	
	УстановитьПараметрыЗапроса(НачалоПериода, КонецПериода);
	
	// позиционируемся на документе с указанным номером
	Если ЗначениеЗаполнено(НомерДокумента) Тогда
		ВведенныйНомерСНулями = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НомерДокумента, 11, "0", "Слева");
		// пользователь может ввести номер документа, к которому у него нет доступа
		
		НайденнаяСпецификация = ПолучитьСпецификациюПоНомеру(ВведенныйНомерСНулями);
		
		Если ЗначениеЗаполнено(НайденнаяСпецификация) Тогда
			Элементы.Список.ТекущаяСтрока = НайденнаяСпецификация;
		Иначе
			ТекстСообщения = "Спецификация № %1 не найдена";
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НомерДокумента);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
		//Попытка
		//	СсылкаНаДокумент = Документы.Спецификация.НайтиПоНомеру(ВведенныйНомерСНулями, ТекущаяДата());
		//	Если СсылкаНаДокумент.Пустая() Тогда
		//		СсылкаНаДокумент = Документы.Спецификация.НайтиПоНомеру(ВведенныйНомерСНулями, ДобавитьМесяц(ТекущаяДата(), -12));
		//	КонецЕсли;
		//Исключение
		//	СсылкаНаДокумент = Неопределено;
		//КонецПопытки;
		//
		//Если ЗначениеЗаполнено(СсылкаНаДокумент) Тогда

		//Иначе
		//КонецЕсли;
		
	КонецЕсли;
	
КонецФункции // УстановитьПараметрыЗапроса()

&НаСервере
Функция ПолучитьСпецификациюПоНомеру(НомерСпецификации)
	
	СпецификацияСсылка = Документы.Спецификация.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НомерСпецификации", НомерСпецификации);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДокументСпецификация.Ссылка
	|ИЗ
	|	Документ.Спецификация КАК ДокументСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО (СтатусСпецификацииСрезПоследних.Спецификация = ДокументСпецификация.Ссылка)
	|ГДЕ
	|	(СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен)
	|			ИЛИ СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ПереданВЦех)
	|			ИЛИ СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Изготовлен))
	|	И ДокументСпецификация.Номер = &НомерСпецификации";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		СпецификацияСсылка = Выборка.Ссылка;
		
	КонецЕсли;
	
	Возврат СпецификацияСсылка;
	
КонецФункции


&НаСервереБезКонтекста
Функция СохранитьВДокументРедактированнуюСтроку(СсылкаСпецификация, СтрокаРедактированнаяФлэш) 
	
	Если ЗначениеЗаполнено(СсылкаСпецификация) Тогда
		УстановитьПривилегированныйРежим(Истина);
		ДокОбъект = СсылкаСпецификация.ПолучитьОбъект();
		ДокОбъект.СтрокаПечатьЭтикеток = СтрокаРедактированнаяФлэш;
		ДокОбъект.Записать();
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция СохранитьСтрокуЭтикеток(СсылкаСпецификация, СтрокаРедактированнаяФлэш) 
	
	Если ЗначениеЗаполнено(СсылкаСпецификация) Тогда
		УстановитьПривилегированныйРежим(Истина);
		
		НаборЗаписей = РегистрыСведений.РаскройДеталей.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(СсылкаСпецификация);
		
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() = 1 Тогда                  
			НаборЗаписей[0].СтрокаЭтикеток = СтрокаРедактированнаяФлэш;
			НаборЗаписей.Записать();
		КонецЕсли;                                              
		
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗначенияРеквизитовОбъекта(Ссылка, Реквизит)
	
	Возврат Ссылка[Реквизит];
	
КонецФункции

&НаСервереБезКонтекста
Функция НайтиНовуюСтрокуФлэш(Спецификация, Команда, Данные = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Объект", Спецификация);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РаскройДеталей.СтрокаРаскрой,
	|	РаскройДеталей.СтрокаЭтикеток,
	|	РаскройДеталей.ТекущаяСтрокаРаскроя,
	|	РаскройДеталей.ТаблицаДеталей
	|ИЗ
	|	РегистрСведений.РаскройДеталей КАК РаскройДеталей
	|ГДЕ
	|	РаскройДеталей.Объект = &Объект";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	Если Команда = "init" Тогда
		
		НашаСтрокаРаскроя = ?(ЗначениеЗаполнено(Выборка.ТекущаяСтрокаРаскроя), Выборка.ТекущаяСтрокаРаскроя, Выборка.СтрокаРаскрой);
		
		Возврат НашаСтрокаРаскроя + "♥" + Выборка.СтрокаЭтикеток;
		
	ИначеЕсли Команда = "new" Тогда
		
		СтруктураРаскроя = РегистрыСведений.РаскройДеталей.ПолучитьСтрокуРаскроя(Спецификация);
		
		ЗаписатьНовыйРаскрой(Спецификация, СтруктураРаскроя.ДанныеДляРаскроя, СтруктураРаскроя.ТаблицаДеталей, "");
		
		Возврат СтруктураРаскроя.ДанныеДляРаскроя;
		
	ИначеЕсли Команда = "recr" Тогда
		
		ТЗ = Выборка.ТаблицаДеталей.Получить();
		МассивИД = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Данные, ",");
		
		Для Каждого Элемент Из МассивИД Цикл
			
			НашаСтрока = ТЗ.Найти(Число(Элемент), "ИД");
			Если НашаСтрока <> Неопределено Тогда 
				ТЗ.Удалить(НашаСтрока);
			КонецЕсли;
			
		КонецЦикла;
		
		СтруктураРаскроя = РегистрыСведений.РаскройДеталей.ПолучитьСтрокуРаскроя(Спецификация, ТЗ);
		
		ЗаписатьНовыйРаскрой(Спецификация, СтруктураРаскроя.ДанныеДляРаскроя, СтруктураРаскроя.ТаблицаДеталей, "");
		
		Возврат СтруктураРаскроя.ДанныеДляРаскроя;
		
	КонецЕсли;
	
КонецФункции // НайтиНовуюСтрокуФлэш()

&НаСервереБезКонтекста
Процедура ЗаписатьНовыйРаскрой(Спецификация, ТекущаяСтрокаРаскроя, ТаблицаДеталей, СтрокаЭтикеток)
	
	НаборЗаписей = РегистрыСведений.РаскройДеталей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Спецификация);
	
	НаборЗаписей.Прочитать();
	Запись = НаборЗаписей[0];
	
	Запись.СтрокаЭтикеток = СтрокаЭтикеток;	
	Запись.ТекущаяСтрокаРаскроя = ТекущаяСтрокаРаскроя;
	Запись.ТаблицаДеталей = ТаблицаДеталей;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры	

&НаКлиенте
Функция ДобавитьЛоготип(СтрокаФлэш)
	
	СтрокаФлэш = СтрЗаменить(СтрокаФлэш, "%ЛОГОТИП%", ЛексКлиент.ПолучитьЛоготип(Элементы.Список.ТекущиеДанные.Ссылка));
	Возврат СтрокаФлэш;
	
КонецФункции // ДобавитьЛоготип()

&НаКлиенте
Функция ОбновитьFlash()
	
	new_url = ЛексКлиент.ПутьHTML(ИмяНовойHTML);
	
	Попытка
		Элементы.КнопкаПоказатьНовыйРаскрой.Документ.url = new_url;
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		Отказ = Истина;
	КонецПопытки;
	
КонецФункции
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отказ = ОбновитьFlash();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьОтборПоПериоду(Истина);
	ИмяНовойHTML = ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.НовыеЭтикеткиHtml);
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаПоказатьНовыйРаскройПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ПолученнаяСтрока = Элементы.КнопкаПоказатьНовыйРаскрой.Документ.getElementById("output").tag;
	ДанныеФлэш = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолученнаяСтрока, "☻");
	
	Элементы.КнопкаПоказатьНовыйРаскрой.Документ.getElementById("output").tag = "";
	
	Если ДанныеФлэш.Количество() = 0 Тогда // получена пустая строка (без разделителей)
		Элементы.КнопкаПоказатьНовыйРаскрой.Документ.body.scroll = "no";
		Возврат;
	КонецЕсли;
	
	КомандаФлэш = ДанныеФлэш[0];
	ЭлементФлэш = Элементы.КнопкаПоказатьНовыйРаскрой.Документ.getElementById("input");
	
	Если КомандаФлэш = "init" Тогда
		
		Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
			
			СсылкаСпецификация = Элементы.Список.ТекущиеДанные.Ссылка;
			
			НоваяСтрока = НайтиНовуюСтрокуФлэш(СсылкаСпецификация, КомандаФлэш);
			
			ЭлементФлэш.tag = ДобавитьЛоготип(НоваяСтрока);
			
		КонецЕсли;
		
	ИначеЕсли КомандаФлэш = "new" Тогда
		
		Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
			
			СсылкаСпецификация = Элементы.Список.ТекущиеДанные.Ссылка;
			
			НоваяСтрока = НайтиНовуюСтрокуФлэш(СсылкаСпецификация, КомандаФлэш);
			
			ЭлементФлэш.tag = ДобавитьЛоготип(НоваяСтрока);
			ЭлементФлэш.click();
			
		КонецЕсли;
		
	ИначеЕсли КомандаФлэш = "recr" Тогда
		
		Если Элементы.Список.ТекущиеДанные <> Неопределено И ДанныеФлэш.Количество() = 2 Тогда
			
			СсылкаСпецификация = Элементы.Список.ТекущиеДанные.Ссылка;
			
			НоваяСтрока = НайтиНовуюСтрокуФлэш(СсылкаСпецификация, КомандаФлэш, ДанныеФлэш[1]);
			
			ЭлементФлэш.tag = ДобавитьЛоготип(НоваяСтрока);
			ЭлементФлэш.click();
			
		КонецЕсли;
		
	ИначеЕсли КомандаФлэш = "print" Тогда
		
		Данные = Base64Значение(ДанныеФлэш[1]);
		
		Картинка = Новый Картинка(Данные);
		
		ТабДок = Новый ТабличныйДокумент;
		
		Рисунок = ТабДок.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
		Рисунок.Верх = 0;
		Рисунок.Лево = 0;
		Рисунок.Высота = 50;	//60
		Рисунок.Ширина = 50;	//49
		Рисунок.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.НетЛинии);
		Рисунок.Картинка = Картинка;
		Рисунок.РазмерКартинки = РазмерКартинки.Пропорционально;
		
		ТабДок.РазмерКолонтитулаСверху = 0;
		ТабДок.РазмерКолонтитулаСнизу = 0;
		ТабДок.ПолеСлева = 0;
		ТабДок.ПолеСверху = 0;
		ТабДок.ПолеСправа = 0;
		ТабДок.ПолеСнизу = 0;
		
		ТабДок.Напечатать();
		
		СтрокаРедактированнаяФлэш = ДанныеФлэш[2];
		
		Если ЗначениеЗаполнено(СтрокаРедактированнаяФлэш) Тогда
			СсылкаСпецификация = Элементы.Список.ТекущиеДанные.Ссылка;
			СохранитьСтрокуЭтикеток(СсылкаСпецификация, СтрокаРедактированнаяФлэш);
		КонецЕсли;
		
	ИначеЕсли КомандаФлэш = "exit" Тогда
		
		СтрокаРедактированнаяФлэш = ДанныеФлэш[1];
		
		Если ЗначениеЗаполнено(СтрокаРедактированнаяФлэш) Тогда
			СсылкаСпецификация = Элементы.Список.ТекущиеДанные.Ссылка;
			СохранитьСтрокуЭтикеток(СсылкаСпецификация, СтрокаРедактированнаяФлэш);
		КонецЕсли; 
		
		ОбновитьFlash();		
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьТекущие(Команда)
	
	УстановитьОтборПоПериоду(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВсе(Команда)
	
	УстановитьОтборПоПериоду(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоНомеру(Команда)
	
	ВведенныйНомер = ОткрытьФормуМодально("ОбщаяФорма.ВводЧисла");
	Если ЗначениеЗаполнено(ВведенныйНомер) Тогда
		УстановитьОтборПоПериоду(Ложь, Строка(ВведенныйНомер));
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ СПИСОК

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

