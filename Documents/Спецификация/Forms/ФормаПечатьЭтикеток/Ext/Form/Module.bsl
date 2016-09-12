﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция УстановитьПараметрыЗапроса(НачалоПериода, КонецПериода)
	
	Список.Параметры.УстановитьЗначениеПараметра("НачалоПериода", НачалоПериода);
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода", КонецПериода);
	СписокНарядов.Параметры.УстановитьЗначениеПараметра("НачалоПериода", НачалоПериода);
	СписокНарядов.Параметры.УстановитьЗначениеПараметра("КонецПериода", КонецПериода);
	
КонецФункции // УстановитьПараметрыЗапроса()

&НаСервере
Функция УстановитьОтборПоПериоду(Текущий, НомерДокумента = Неопределено, Наряды = Ложь)
	
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
		
		НайденныйДокумент = ПолучитьДокументПоНомеру(ВведенныйНомерСНулями, Наряды);
		
		Если ЗначениеЗаполнено(НайденныйДокумент) Тогда
			Если Наряды Тогда
				Элементы.СписокНарядов.ТекущаяСтрока = НайденныйДокумент;
			Иначе
				Элементы.Список.ТекущаяСтрока = НайденныйДокумент;
			КонецЕсли;
		Иначе
			ТекстСообщения = ?(Наряды, "Наряд задание № %1 не найден", "Спецификация № %1 не найдена");
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
Функция ПолучитьДокументПоНомеру(НомерДокумента, Наряды)
	
	Если Наряды Тогда
		
		НарядСсылка = Документы.Спецификация.ПустаяСсылка();
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НомерДокумента", НомерДокумента);
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НарядЗадание.Ссылка
		|ИЗ
		|	Документ.НарядЗадание КАК НарядЗадание
		|ГДЕ
		|	НарядЗадание.Номер = &НомерДокумента
		|	И НарядЗадание.Проведен";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			НарядСсылка = Выборка.Ссылка;
			
		КонецЕсли;
		
		Возврат НарядСсылка;
		
	Иначе
		
		СпецификацияСсылка = Документы.Спецификация.ПустаяСсылка();
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НомерДокумента", НомерДокумента);
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
		|	И ДокументСпецификация.Номер = &НомерДокумента";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			СпецификацияСсылка = Выборка.Ссылка;
			
		КонецЕсли;
		
		Возврат СпецификацияСсылка;
		
	КонецЕсли;
	
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
Функция СохранитьСтрокуЭтикеток(СсылкаДокумента, СтрокаРедактированнаяФлэш)
	
	Если ЗначениеЗаполнено(СсылкаДокумента) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		НаборЗаписей = РегистрыСведений.РаскройДеталей.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(СсылкаДокумента);
		
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() = 1 Тогда
			НаборЗаписей[0].СтрокаЭтикеток = СтрокаРедактированнаяФлэш;
			НаборЗаписей.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция НайтиНовуюСтрокуФлэш(Документ, Команда, Данные = Неопределено, Наряды = Ложь)
	
	Отбор = Новый Структура("Объект", Документ);
	Выборка = РегистрыСведений.РаскройДеталей.Выбрать(Отбор);
	Выборка.Следующий();
	
	Если Команда = "init" Тогда
		
		НашаСтрокаРаскроя = ?(ЗначениеЗаполнено(Выборка.ТекущаяСтрокаРаскроя), Выборка.ТекущаяСтрокаРаскроя, Выборка.СтрокаРаскрой);
		
		Если НЕ ЗначениеЗаполнено(НашаСтрокаРаскроя) Тогда
			Возврат "";
		КонецЕсли;
		
		Возврат НашаСтрокаРаскроя + "♥" + Выборка.СтрокаЭтикеток;
		
	ИначеЕсли Команда = "new" Тогда
		
		СтруктураРаскроя = РегистрыСведений.РаскройДеталей.СформироватьРаскрой(Документ);
		
		ЗаписатьНовыйРаскрой(Документ, СтруктураРаскроя.ДанныеДляРаскроя, СтруктураРаскроя.ТаблицаДеталей, "");
		
		Возврат СтруктураРаскроя.ДанныеДляРаскроя;
		
	ИначеЕсли Команда = "recr" Тогда
		
		ТЗ = Выборка.ТаблицаДеталей.Получить();
		Если ТЗ.Колонки.Найти("GUID") = Неопределено Тогда
			ТЗ.Колонки.Добавить("GUID", Новый ОписаниеТипов("Строка"));
		КонецЕсли;
		МассивИД = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Данные, ",");
		
		Для Каждого Элемент Из МассивИД Цикл
			
			НашаСтрока = ТЗ.Найти(Число(Элемент), "ИД");
			Если НашаСтрока <> Неопределено Тогда 
				ТЗ.Удалить(НашаСтрока);
			КонецЕсли;
			
		КонецЦикла;
		
		СтруктураРаскроя = РегистрыСведений.РаскройДеталей.СформироватьРаскрой(Документ, ТЗ, , Наряды);
		
		ЗаписатьНовыйРаскрой(Документ, СтруктураРаскроя.ДанныеДляРаскроя, СтруктураРаскроя.ТаблицаДеталей, "");
		
		Возврат СтруктураРаскроя.ДанныеДляРаскроя;
		
	КонецЕсли;
	
КонецФункции // НайтиНовуюСтрокуФлэш()

&НаСервереБезКонтекста
Процедура ЗаписатьНовыйРаскрой(Документ, ТекущаяСтрокаРаскроя, ТаблицаДеталей, СтрокаЭтикеток)
	
	НаборЗаписей = РегистрыСведений.РаскройДеталей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Документ);
	
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
	
	url = ЛексКлиент.ПутьHTML(ИмяHTML)+"?"+ЛексКлиент.ПутьHTML(ИмяSWF);
	
	Попытка
		Элементы.КнопкаПоказатьНовыйРаскрой.Документ.url = url;
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
	
	ИмяHTML = Справочники.Файлы.ContainerHtml.Наименование + "." + Справочники.Файлы.ContainerHtml.ТекущаяВерсия.Расширение;
	ИмяSWF = Справочники.Файлы.ЭтикеткиFlash.Наименование + "." + Справочники.Файлы.ЭтикеткиFlash.ТекущаяВерсия.Расширение;
	
	ИмяФормированиеРаскрояHTML = ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.ФормированиеРаскрояHTML);
	//СпецификацииНаряды = СпецификацииНаряды.СписокСпецификаций;
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаПоказатьНовыйРаскройПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ПолученнаяСтрока = Элементы.КнопкаПоказатьНовыйРаскрой.Документ.getElementById("forw").tag;
	ДанныеФлэш = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолученнаяСтрока, "☻");
	
	Элементы.КнопкаПоказатьНовыйРаскрой.Документ.getElementById("forw").tag = "";
	
	Если ДанныеФлэш.Количество() = 0 Тогда // получена пустая строка (без разделителей)
		Элементы.КнопкаПоказатьНовыйРаскрой.Документ.body.scroll = "no";
		Возврат;
	КонецЕсли;
	
	КомандаФлэш = ДанныеФлэш[0];
	ЭлементФлэш = Элементы.КнопкаПоказатьНовыйРаскрой.Документ.getElementById("back");
	
	Если КомандаФлэш = "init" Тогда
		
		Если Наряды Тогда
			
			Если Элементы.СписокНарядов.ТекущиеДанные <> Неопределено Тогда
				СсылкаНаряд = Элементы.СписокНарядов.ТекущиеДанные.СсылкаНаряда;
				НоваяСтрока = НайтиНовуюСтрокуФлэш(СсылкаНаряд, КомандаФлэш, , Наряды);
				ЭлементФлэш.tag = НоваяСтрока;
			КонецЕсли;
			
		Иначе
			
			Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
				
				СсылкаСпецификация = Элементы.Список.ТекущиеДанные.Ссылка;
				
				НоваяСтрока = НайтиНовуюСтрокуФлэш(СсылкаСпецификация, КомандаФлэш);
				
				ЭлементФлэш.tag = ДобавитьЛоготип(НоваяСтрока);
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли КомандаФлэш = "new" Тогда
		
		Если Наряды Тогда
			Если Элементы.СписокНарядов.ТекущиеДанные <> Неопределено Тогда
				Элементы.КнопкаПоказатьНовыйРаскрой.Документ.url = ЛексКлиент.ПутьHTML(ИмяФормированиеРаскрояHTML);
				Элементы.КнопкаПоказатьНовыйРаскрой.Документ.body.scroll = "no";
				ПодключитьОбработчикОжидания("ВыполнитьВернутьВсеДетали",1,Истина);
			КонецЕсли;
		Иначе
			
			Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
				
				Элементы.КнопкаПоказатьНовыйРаскрой.Документ.url = ЛексКлиент.ПутьHTML(ИмяФормированиеРаскрояHTML);
				Элементы.КнопкаПоказатьНовыйРаскрой.Документ.body.scroll = "no";
				
				ПодключитьОбработчикОжидания("ВыполнитьВернутьВсеДетали",1,Истина);
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли КомандаФлэш = "recr" Тогда
		
		Если Наряды Тогда
			Если Элементы.СписокНарядов.ТекущиеДанные <> Неопределено И ДанныеФлэш.Количество() = 2 Тогда
				Элементы.КнопкаПоказатьНовыйРаскрой.Документ.url = ЛексКлиент.ПутьHTML(ИмяФормированиеРаскрояHTML);
				Элементы.КнопкаПоказатьНовыйРаскрой.Документ.body.scroll = "no";
				ДанныеОтФлэш = ДанныеФлэш[1];
				ПодключитьОбработчикОжидания("ВыполнитьПерераскрой",1,Истина);
			КонецЕсли;
		Иначе
			
			Если Элементы.Список.ТекущиеДанные <> Неопределено И ДанныеФлэш.Количество() = 2 Тогда
				
				Элементы.КнопкаПоказатьНовыйРаскрой.Документ.url = ЛексКлиент.ПутьHTML(ИмяФормированиеРаскрояHTML);
				Элементы.КнопкаПоказатьНовыйРаскрой.Документ.body.scroll = "no";
				
				ДанныеОтФлэш = ДанныеФлэш[1];
				
				ПодключитьОбработчикОжидания("ВыполнитьПерераскрой",1,Истина);
				
			КонецЕсли;
			
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
			СсылкаДокумента = ?(Наряды, Элементы.СписокНарядов.ТекущиеДанные.СсылкаНаряда, Элементы.Список.ТекущиеДанные.Ссылка);
			СохранитьСтрокуЭтикеток(СсылкаДокумента, СтрокаРедактированнаяФлэш);
		КонецЕсли;
		
	ИначеЕсли КомандаФлэш = "exit" Тогда
		
		СтрокаРедактированнаяФлэш = ДанныеФлэш[1];
		
		Если ЗначениеЗаполнено(СтрокаРедактированнаяФлэш) Тогда
			СсылкаДокумента = ?(Наряды, Элементы.СписокНарядов.ТекущиеДанные.СсылкаНаряда, Элементы.Список.ТекущиеДанные.Ссылка);
			СохранитьСтрокуЭтикеток(СсылкаДокумента, СтрокаРедактированнаяФлэш);
		КонецЕсли; 
		
		ОбновитьFlash();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВернутьВсеДетали()
	
	СсылкаДокумента = ?(Наряды, Элементы.СписокНарядов.ТекущиеДанные.СсылкаНаряда, Элементы.Список.ТекущиеДанные.Ссылка);
	ДанныеОтФлэш = НайтиНовуюСтрокуФлэш(СсылкаДокумента, "new");
	
	url = ЛексКлиент.ПутьHTML(ИмяHTML)+"?"+ЛексКлиент.ПутьHTML(ИмяSWF);
	Элементы.КнопкаПоказатьНовыйРаскрой.Документ.url = url;
	
	//ПодключитьОбработчикОжидания("ПереоткрытьФлэш",2,Истина);
	
КонецПроцедуры

//&НаКлиенте
//Процедура ПереоткрытьФлэш()
//	
//	ЭлементФлэш = Элементы.КнопкаПоказатьНовыйРаскрой.Документ.getElementById("redo");
//		
//	СсылкаСпецификация = Элементы.Список.ТекущиеДанные.Ссылка;
//			
//	НоваяСтрока = НайтиНовуюСтрокуФлэш(СсылкаСпецификация, "init");
//									
//	ЭлементФлэш.tag = ДобавитьЛоготип(НоваяСтрока);
//	
//	ЭлФ = Элементы.КнопкаПоказатьНовыйРаскрой.Документ.getElementById("Flash");
//	ЭлФ.click();
//	
//	//ЭлементФлэш.click();

//КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПерераскрой()
	
	СсылкаДокумента = ?(Наряды, Элементы.СписокНарядов.ТекущиеДанные.СсылкаНаряда, Элементы.Список.ТекущиеДанные.Ссылка);
	ДанныеОтФлэш = НайтиНовуюСтрокуФлэш(СсылкаДокумента, "recr", ДанныеОтФлэш, Наряды);
	
	url = ЛексКлиент.ПутьHTML(ИмяHTML)+"?"+ЛексКлиент.ПутьHTML(ИмяSWF);
	Элементы.КнопкаПоказатьНовыйРаскрой.Документ.url = url;
	
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
		УстановитьОтборПоПериоду(Ложь, Строка(ВведенныйНомер), Наряды);
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

&НаКлиенте
Процедура СпецификацииНаряды(Команда)
	
	Наряды = Не Наряды;
	Элементы.Страницы.ТекущаяСтраница = ?(Наряды, Элементы.Наряды, Элементы.Спецификации);
	Элементы.Спецификации.Видимость = НЕ Наряды;
	Элементы.Наряды.Видимость = Наряды;

КонецПроцедуры

&НаКлиенте
Процедура СписокНарядовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

