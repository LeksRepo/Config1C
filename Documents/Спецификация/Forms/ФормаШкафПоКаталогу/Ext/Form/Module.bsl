﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ДобавитьДопГруппы() 
	
	Кромка2 = Новый Массив;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кромка2_19 Цикл
		Кромка2.Добавить(Элемент);
	КонецЦикла;
	//Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кромка2_35 Цикл
	//	Кромка2.Добавить(Элемент);
	//КонецЦикла;
	МассивыНоменклатурныхГрупп.Вставить("Кромка2мм", Кромка2);
	
	Кромка 	= Новый Массив;
	//Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кромка045_19 Цикл
	//	Кромка.Добавить(Элемент);
	//КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кромка2мм Цикл
		Кромка.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.КантТ Цикл
		Кромка.Добавить(Элемент);
	КонецЦикла;
	МассивыНоменклатурныхГрупп.Вставить("Кромка", Кромка);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузкаАдресаПредопределенных() 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КаталогИзделий.Ссылка КАК Изделие,
	|	ВЫБОР
	|		КОГДА КаталогИзделий.Ссылка = ЗНАЧЕНИЕ(Справочник.КаталогИзделий.ПраваяСтена)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент)
	|		ИНАЧЕ КаталогИзделий.ВидИзделия
	|	КОНЕЦ КАК ВидИзделия,
	|	НесовместимостьИзделийПоКаталогу.НесовместимостимоеИзделие КАК НесовместимостимоеИзделие
	|ИЗ
	|	Справочник.КаталогИзделий КАК КаталогИзделий
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НесовместимостьИзделийПоКаталогу КАК НесовместимостьИзделийПоКаталогу
	|		ПО (НесовместимостьИзделийПоКаталогу.Изделие = КаталогИзделий.Ссылка)
	|ГДЕ
	|	(КаталогИзделий.Ссылка = ЗНАЧЕНИЕ(Справочник.КаталогИзделий.ЗадняяСтенаЗаказчика)
	|			ИЛИ КаталогИзделий.Ссылка = ЗНАЧЕНИЕ(Справочник.КаталогИзделий.ЛеваяСтена)
	|			ИЛИ КаталогИзделий.Ссылка = ЗНАЧЕНИЕ(Справочник.КаталогИзделий.ПолЗаказчика)
	|			ИЛИ КаталогИзделий.Ссылка = ЗНАЧЕНИЕ(Справочник.КаталогИзделий.ПотолокЗаказчика)
	|			ИЛИ КаталогИзделий.Ссылка = ЗНАЧЕНИЕ(Справочник.КаталогИзделий.ПраваяСтена))
	|ИТОГИ ПО
	|	Изделие";
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = АдресаПредопределенных.Добавить();
		НоваяСтрока.Изделие = Выборка.Изделие;
		НоваяСтрока.ВидИзделия = Выборка.ВидИзделия;
		
		ВыборкаПоИзделиям = Выборка.Выбрать();
		Пока ВыборкаПоИзделиям.Следующий() Цикл
			НоваяСтрока.СписокНесовместимых.Добавить(ВыборкаПоИзделиям.НесовместимостимоеИзделие);
		КонецЦикла;
		НоваяСтрока.АдресИзделия = ПолучитьАдрес(НоваяСтрока.Изделие, НоваяСтрока.ВидИзделия);
	КонецЦикла;	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьАдрес(Изделие, ВидИзделия) 
	
	Если ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент Тогда
		Расположение = Строка(Перечисления.РасположениеКартинки.Левая);
	ИначеЕсли ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент Тогда
		Расположение = Строка(Перечисления.РасположениеКартинки.Правая);
	Иначе
		Расположение = "";
	КонецЕсли;
	
	Возврат "Изделие" + Расположение + Изделие.Код;
	
КонецФункции

&НаСервере
Функция ПолучитьСписокСтенок() 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КаталогИзделий.Ссылка
	|ИЗ
	|	Справочник.КаталогИзделий КАК КаталогИзделий
	|ГДЕ
	|	КаталогИзделий.ВидИзделия = ЗНАЧЕНИЕ(Перечисление.ВидыИзделийПоКаталогу.ЗадняяСтенка)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаСервере
Процедура ПолучитьИтоговыеРазмеры(ВысотаОсновного, ШиринаОсновного)
	
	ШиринаИтог = ШиринаОсновного;
	ВысотаИтог = ВысотаОсновного;
	
	Для Каждого Строка Из Детали Цикл
		Если (Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Крыша 
			ИЛИ Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Пол) И НЕ Строка.НеВлияетНаОсновной Тогда
			ВысотаИтог = ВысотаИтог + Строка.ВысотаИзделия;	 	
		ИначеЕсли (Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент
			ИЛИ Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент) И НЕ Строка.НеВлияетНаОсновной Тогда
			ШиринаИтог = ШиринаИтог + Строка.ШиринаИзделия;	
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьИУстановитьРазмерыПередСохранением(РазмерыОсновного)
	
	Ошибки = Неопределено;
	
	ЕстьКрыша = Ложь;
	ЕстьКрышаНаВсе = Ложь;
	ЕстьПол = Ложь;
	ЕстьЛевыйБоковой = Ложь;
	ЕстьПравыйБоковой = Ложь;
	
	НеВлияетНаОсновнойСнизу = Ложь;
	НеВлияетНаОсновнойСверху = Ложь;
	НеВлияетНаОсновнойСлева = Ложь;
	НеВлияетНаОсновнойСправа = Ложь;
	
	Для Каждого Строка Из Детали Цикл
		
		Если Строка.Предопределенный Тогда
			Продолжить;
		КонецЕсли;
		
		Строка.ГлубинаИзделия = ГлубинаИтог;
		Строка.Ручка = РучкиЯщиков;
		
		Если Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Крыша Тогда 
			
			Если Строка.Изделие.НаВсеИзделие Тогда
				ЕстьКрышаНаВсе = Истина;
				Строка.ШиринаИзделия = ШиринаИтог;
			Иначе
				ЕстьКрыша = Истина;
				Строка.ШиринаИзделия = РазмерыОсновного.Ширина;
			КонецЕсли;
			НеВлияетНаОсновнойСверху = Строка.Изделие.НеВлияетНаОсновной;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Пол Тогда
			Строка.ШиринаИзделия = РазмерыОсновного.Ширина;
			ЕстьПол = Истина;
			НеВлияетНаОсновнойСнизу = Строка.Изделие.НеВлияетНаОсновной;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент Тогда
			Строка.ВысотаИзделия = РазмерыОсновного.ВысотаБоковой;
			ЕстьЛевыйБоковой = Истина;
			НеВлияетНаОсновнойСлева = Строка.Изделие.НеВлияетНаОсновной;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент Тогда
			Строка.ВысотаИзделия = РазмерыОсновного.ВысотаБоковой;
			ЕстьПравыйБоковой = Истина;
			НеВлияетНаОсновнойСправа = Строка.Изделие.НеВлияетНаОсновной;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ОсновнойЭлемент Тогда
			Строка.ШиринаИзделия = РазмерыОсновного.Ширина;
			Строка.ВысотаИзделия = РазмерыОсновного.Высота;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЗадняяСтенка Тогда
			Строка.ШиринаИзделия = РазмерыОсновного.Ширина + 30;
			Строка.ВысотаИзделия = РазмерыОсновного.Высота + 30;
			Если НоменклатураСтенка.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ЛДСП16 Тогда
				Строка.НоменклатураЛДСП = НоменклатураСтенка;
			ИначеЕсли НоменклатураСтенка.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ДВП Тогда
				Строка.НоменклатураДВП = НоменклатураСтенка;
			КонецЕсли;
			НашаСтенка = Строка.Изделие;
			Строка.ШиринаИзделияМакс = НашаСтенка.ШиринаИзделияМакс;
			Строка.ВысотаИзделияМакс = НашаСтенка.ВысотаИзделияМакс;
			Строка.ГлубинаИзделияМакс = НашаСтенка.ГлубинаИзделияМакс;
			Строка.ШиринаИзделияМин = НашаСтенка.ШиринаИзделияМин;
			Строка.ВысотаИзделияМин = НашаСтенка.ВысотаИзделияМин;
			Строка.ГлубинаИзделияМин = НашаСтенка.ГлубинаИзделияМин;
			
			Если НЕ ЗначениеЗаполнено(НоменклатураСтенка) Тогда
				Текст = "Не выбрана номенклатура задней стенки";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "НоменклатураСтенка", Текст);
			КонецЕсли;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.НоменклатураЛДСП) И (Строка.ВидИзделия <> Перечисления.ВидыИзделийПоКаталогу.ЗадняяСтенка) Тогда
			Если ЗначениеЗаполнено(ШапкаОсновныхНастроек.НоменклатураЛДСП) Тогда
				Строка.НоменклатураЛДСП = ШапкаОсновныхНастроек.НоменклатураЛДСП;
			Иначе
				Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
				Текст = "Не выбрана номенклатура ЛДСП у " + Строка.ВидИзделия;
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.НоменклатураЛДСП", Текст);
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.КромкаЛДСП) И (Строка.ВидИзделия <> Перечисления.ВидыИзделийПоКаталогу.ЗадняяСтенка) Тогда
			Если ЗначениеЗаполнено(ШапкаОсновныхНастроек.КромкаЛДСП) Тогда
				Строка.КромкаЛДСП = ШапкаОсновныхНастроек.КромкаЛДСП;
			Иначе
				Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
				Текст = "Не выбрана кромка у " + Строка.ВидИзделия;
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Элементы.Детали.ТекущиеДанные.КромкаЛДСП", Текст);
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(РучкиЯщиков) И Строка.ЕстьЯщики Тогда
			Текст = "Не выбраны ручки у " + Строка.ВидИзделия;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "РучкиЯщиков", Текст);
		КонецЕсли;
		
		Если Строка.ШиринаИзделия > Строка.ШиринаИзделияМакс ИЛИ Строка.ШиринаИзделия < Строка.ШиринаИзделияМин Тогда
			Текст = Строка(Строка.ВидИзделия) + " не подходит по ширине. Ширина изделия = " + Строка.ШиринаИзделия + " (Мин = " + Строка.ШиринаИзделияМин + ", Макс = " + Строка.ШиринаИзделияМакс + ")";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ШиринаИтог", Текст);
		КонецЕсли;
		
		Если Строка.ВысотаИзделия > Строка.ВысотаИзделияМакс ИЛИ Строка.ВысотаИзделия < Строка.ВысотаИзделияМин Тогда
			Текст = Строка(Строка.ВидИзделия) + " не подходит по высоте. Высота изделия = " + Строка.ВысотаИзделия + " (Мин = " + Строка.ВысотаИзделияМин + ", Макс = " + Строка.ВысотаИзделияМакс + ")";
			Текст = "%1 не подходит по высоте. Высота изделия = %2 (Мин = %3, Макс = %4 )";
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, Строка.ВидИзделия, Строка.ВысотаИзделия, Строка.ВысотаИзделияМин, Строка.ВысотаИзделияМакс);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ВысотаИтог", Текст);
		КонецЕсли;
		
		Если Строка.ГлубинаИзделия > Строка.ГлубинаИзделияМакс ИЛИ Строка.ГлубинаИзделия < Строка.ГлубинаИзделияМин Тогда
			Текст = Строка(Строка.ВидИзделия) + " не подходит по глубине. Глубина изделия = " + Строка.ГлубинаИзделия + " (Мин = " + Строка.ГлубинаИзделияМин + ", Макс = " + Строка.ГлубинаИзделияМакс + ")";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ГлубинаИтог", Текст);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Ошибки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		Возврат Неопределено;
	КонецЕсли;
	
	# Область СозданиеСтрокиПрипусков
	
	Для Каждого Элемент Из Детали Цикл
		
		Элемент.СтрокаПрипусков = "";
		
		Если Элемент.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Крыша 
			ИЛИ Элемент.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Пол Тогда
			
			Если НЕ ЕстьЛевыйБоковой ИЛИ НеВлияетНаОсновнойСлева Тогда
				Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСлева";
			КонецЕсли;
			Если НЕ ЕстьПравыйБоковой ИЛИ НеВлияетНаОсновнойСправа Тогда
				Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСправа";
			КонецЕсли;
			
		ИначеЕсли Элемент.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент
			ИЛИ Элемент.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент Тогда
			
			Если НЕ ЕстьКрышаНаВсе Тогда
				Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСверху";
			КонецЕсли;
			Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСнизу";
			
		ИначеЕсли Элемент.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ОсновнойЭлемент Тогда
			
			Если (НЕ ЕстьКрыша И НЕ ЕстьКрышаНаВсе) ИЛИ НеВлияетНаОсновнойСверху Тогда
				Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСверху";
			КонецЕсли;
			Если НЕ ЕстьЛевыйБоковой ИЛИ НеВлияетНаОсновнойСлева Тогда
				Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСлева";
			КонецЕсли;
			Если НЕ ЕстьПол ИЛИ НеВлияетНаОсновнойСнизу Тогда
				Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСнизу";
			КонецЕсли;
			Если НЕ ЕстьПравыйБоковой ИЛИ НеВлияетНаОсновнойСправа Тогда
				Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСправа";
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	# КонецОбласти
	
	Структура = Новый Структура;
	Структура.Вставить("Детали", Детали.Выгрузить());
	Структура.Вставить("Двери", Двери);
	//Структура.Вставить("ПодставляемыеЗначенияИзРеквизита", СтруктураПодставляяемойНоменклатуры);
	
	Возврат ПоместитьВоВременноеХранилище(Структура);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруИзделия(Изделие, ВидИзделия)
	
	ЕстьЯщики = Изделие.СписокЯщики.Количество() > 0;
	АдресЭлемента = ПолучитьАдрес(Изделие, ВидИзделия);
	
	Структура = Новый Структура;
	Структура.Вставить("АдресЭлемента", АдресЭлемента);
	Структура.Вставить("ВысотаИзделия", Изделие.ВысотаИзделия);
	Структура.Вставить("ШиринаИзделия", Изделие.ШиринаИзделия);
	Структура.Вставить("ГлубинаИзделия", Изделие.ГлубинаИзделия);
	Структура.Вставить("ВысотаИзделияМин", Изделие.ВысотаИзделияМин);
	Структура.Вставить("ШиринаИзделияМин", Изделие.ШиринаИзделияМин);
	Структура.Вставить("ГлубинаИзделияМин", Изделие.ГлубинаИзделияМин);
	Структура.Вставить("ВысотаИзделияМакс", Изделие.ВысотаИзделияМакс);
	Структура.Вставить("ШиринаИзделияМакс", Изделие.ШиринаИзделияМакс);
	Структура.Вставить("ГлубинаИзделияМакс", Изделие.ГлубинаИзделияМакс);
	Структура.Вставить("ЕстьЯщики", ЕстьЯщики);
	Структура.Вставить("НаВсеИзделие", Изделие.НаВсеИзделие);
	Структура.Вставить("НеВлияетНаОсновной", Изделие.НеВлияетНаОсновной);
	
	Возврат Структура;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьМатериалСтенки(ЗадняяСтенка)
	
	//Изделие по каталогу Задняя стенка должна иметь 1 деталь - саму стенку, определяем ее материал
	Если ЗначениеЗаполнено(ЗадняяСтенка) Тогда
		Если ЗадняяСтенка.СписокМатериалы.Количество() > 0 Тогда
			Возврат ЗадняяСтенка.СписокМатериалы[0].Материал;
		КонецЕсли;
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция ПолучитьРазмерыОсновногоЭлемента()
	
	НашОсновнойЭлемент = Детали.НайтиСтроки(Новый Структура("ВидИзделия", ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ОсновнойЭлемент")));
	ЕстьОсновной = НашОсновнойЭлемент.Количество() > 0;
	Если ЕстьОсновной Тогда
		Размеры = Новый Структура;
		Размеры.Вставить("Глубина", ГлубинаИтог);
		
		ШиринаОсновногоЭлемента = ШиринаИтог;
		ВысотаОсновногоЭлемента = ВысотаИтог;
		ВысотаКрыша = 0;
		
		Для Каждого Строка Из Детали Цикл
			Если Строка.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.Крыша") Тогда
				Если Строка.НаВсеИзделие Тогда
					ВысотаКрыша = Строка.ВысотаИзделия;
				КонецЕсли;
				Если НЕ Строка.НеВлияетНаОсновной Тогда
					ВысотаОсновногоЭлемента = ВысотаОсновногоЭлемента - Строка.ВысотаИзделия;	
				КонецЕсли;
			ИначеЕсли Строка.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.Пол") И НЕ Строка.НеВлияетНаОсновной Тогда
				ВысотаОсновногоЭлемента = ВысотаОсновногоЭлемента - Строка.ВысотаИзделия;
			ИначеЕсли (Строка.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент")
				ИЛИ Строка.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент"))
				И НЕ Строка.НеВлияетНаОсновной Тогда
				ШиринаОсновногоЭлемента = ШиринаОсновногоЭлемента - Строка.ШиринаИзделия;	
			КонецЕсли;	
		КонецЦикла;                                                      
		
		Размеры.Вставить("Ширина", ШиринаОсновногоЭлемента);
		Размеры.Вставить("Высота", ВысотаОсновногоЭлемента);
		Размеры.Вставить("ВысотаБоковой", ВысотаИтог - ВысотаКрыша);
		
		Возврат Размеры;
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Выберите основной элемент", , "ОсновнойЭлемент");
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступность(ВидИзделия)
	
	СтрокаДетали = Детали.НайтиСтроки(Новый Структура("ВидИзделия", ВидИзделия));
	
	Если (СтрокаДетали.Количество() = 1) И (ВидИзделия <> ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЗадняяСтенка")) Тогда
		Флаг = НЕ СтрокаДетали[0].Предопределенный;
		ЕстьЯщики = ?(СтрокаДетали[0].Предопределенный, Ложь, СтрокаДетали[0].ЕстьЯщики);
	Иначе
		Флаг = Ложь;
		ЕстьЯщики = Ложь;
	КонецЕсли;
	
	Элементы.ДеталиНоменклатураЛДСП.Доступность = Флаг;
	Элементы.ДеталиКромкаЛДСП.Доступность = Флаг;
	Элементы.РучкиЯщиков.Доступность = ЕстьЯщики;
	Элементы.НоменклатураСтенка.Доступность = (ЗадняяСтенка <> ПредопределенноеЗначение("Справочник.КаталогИзделий.ЗадняяСтенаЗаказчика"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьКартинку(АдресЭлемента, ЭлементИзделия)
	
	Если ЗначениеЗаполнено(АдресЭлемента) Тогда
		АдресЭлемента = РабочийКаталог + АдресЭлемента;
		АдресВХранилище = "";
		Если ЗначениеЗаполнено(АдресЭлемента) Тогда
			ИмяФайла = АдресЭлемента;
			ФайлИзображения = Новый Файл(ИмяФайла);
			Если ФайлИзображения.Существует() Тогда
				ПоместитьФайл(АдресВХранилище, ИмяФайла, , Ложь, ЭтаФорма.УникальныйИдентификатор);
			КонецЕсли;
		КонецЕсли;
		
		ЭтаФорма[ЭлементИзделия] = АдресВХранилище;
		
	Иначе
		ВызватьИсключение "Ошибка 735: Критическая ошибка каталога (нет изображения изделия)!!!";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтроку(НашаСтрока, ВидИзделия, Изделие = Неопределено, СтруктураИзделия = Неопределено, ЭлементИзделия = Неопределено)
	
	ЭтоПредопределенный = Ложь;
	Ошибки = Неопределено;
	АдресЭлемента = "";
	
	Если Изделие = Неопределено Тогда
		СтрокаПредопределенных = АдресаПредопределенных.НайтиСтроки(Новый Структура("ВидИзделия", ВидИзделия));
		Если СтрокаПредопределенных.Количество() = 1 Тогда
			ЭтоПредопределенный = Истина;
			
			Изделие	= СтрокаПредопределенных[0].Изделие;
			АдресЭлемента = СтрокаПредопределенных[0].АдресИзделия;
			
			СписокНесовместимых = СтрокаПредопределенных[0].СписокНесовместимых;
			Для Каждого СтрокаДетали Из Детали Цикл
				Если СписокНесовместимых.НайтиПоЗначению(СтрокаДетали.Изделие) <> Неопределено Тогда
					Текст = "Изделие """ + Изделие + """ несовместимо с """ + СтрокаДетали.Изделие + """";
					ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , Текст);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если Ошибки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		Возврат;
	КонецЕсли;
	
	Если Изделие <> Неопределено Тогда
		НашаСтрока.Изделие = Изделие;
		НашаСтрока.ВидИзделия = ВидИзделия;
		Если СтруктураИзделия <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(НашаСтрока, СтруктураИзделия);
		Иначе
			НашаСтрока.ВысотаИзделия = 0;
			НашаСтрока.ШиринаИзделия = 0;
			НашаСтрока.ГлубинаИзделия = 0;
			НашаСтрока.ВысотаИзделияМин = 0;
			НашаСтрока.ШиринаИзделияМин = 0;
			НашаСтрока.ГлубинаИзделияМин = 0;
			НашаСтрока.ВысотаИзделияМакс = 0;
			НашаСтрока.ШиринаИзделияМакс = 0;
			НашаСтрока.ГлубинаИзделияМакс = 0;
			НашаСтрока.ЕстьЯщики = Ложь;
			НашаСтрока.НаВсеИзделие = Ложь;
			НашаСтрока.НеВлияетНаОсновной = Ложь;
		КонецЕсли;
		
		НашаСтрока.Предопределенный = ЭтоПредопределенный;
		
		Элементы.Детали.ТекущаяСтрока = Детали.Индекс(НашаСтрока);
		
		Если ВидИзделия <> ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЗадняяСтенка") Тогда
			АдресЭлемента = ?(СтруктураИзделия <> Неопределено, СтруктураИзделия.АдресЭлемента, АдресЭлемента);
			ОтобразитьКартинку(АдресЭлемента, ЭлементИзделия);
		Иначе
			ЗадняяСтенка = Изделие;
		КонецЕсли;
	Иначе
		Детали.Удалить(НашаСтрока);
		ЭтаФорма[ЭлементИзделия] = "";
	КонецЕсли;
	
	УстановитьДоступность(ВидИзделия);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РабочийКаталог = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
	
	Если ЗначениеЗаполнено(Двери) Тогда		
		РазмерыДвери = ОпределитьРазмерыДвери();
		ВысотаПроемаДвери = РазмерыДвери.ВысотаПроема;
		ШиринаПроемаДвери = РазмерыДвери.ШиринаПроема;
	КонецЕсли;
	
	Если Детали.Количество() > 1 Тогда
		
		Если ЗначениеЗаполнено(Детали[1].НоменклатураЛДСП) Тогда
			
			СтруктураПодставляяемойНоменклатуры = ЛексСервер.ПолучитьСтруктуруПодставляемойНоменклатурыПоЦветуЛДСП(Детали[1].НоменклатураЛДСП, Подразделение);
			
		КонецЕсли;
		
	КонецЕсли;
	
	//Очень криво обращаться по имени, надо чтото придумать
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("Крыша");
	МассивЭлементов.Добавить("ЛевыйБоковойЭлемент");
	МассивЭлементов.Добавить("ОсновнойЭлемент");
	МассивЭлементов.Добавить("Пол");
	МассивЭлементов.Добавить("ПравыйБоковойЭлемент");
	
	Для Каждого Строка Из МассивЭлементов Цикл
		Если ЗначениеЗаполнено(ЭтаФорма[Строка]) Тогда
			ОтобразитьКартинку(ЭтаФорма[Строка], Строка);
		КонецЕсли;	
	КонецЦикла;
	
	УстановитьДоступность(ТекущийЭлементИзделия);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Подразделение = Параметры.Подразделение;
	Спецификация = Параметры.Спецификация;
	
	ЗагрузкаАдресаПредопределенных();
	
	#Область Заполнение_номенклатурных_групп
	СписокНоменклатурныхГрупп = Новый СписокЗначений;
	
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ЛДСП16);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.КантТ);
	//СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кромка045_19);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кромка2_19);
	//СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кромка2_35);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ДВП);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Ручка);
	
	МассивыНоменклатурныхГрупп = ЛексСервер.ОтборНоменклатурныхГрупп(СписокНоменклатурныхГрупп, Подразделение);
	ДобавитьДопГруппы();
	
	Элементы.ДеталиНоменклатураЛДСП.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ЛДСП16);
	Элементы.ДеталиКромкаЛДСП.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Кромка);
	Элементы.РучкиЯщиков.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Ручка);	
	Элементы.ЗадняяСтенка.СписокВыбора.ЗагрузитьЗначения(ПолучитьСписокСтенок());	
	#КонецОбласти
	
	#Область ШапкаОсновныхНастроек
	ШапкаОсновныхНастроек = Новый Структура;
	
	ШапкаОсновныхНастроек.Вставить("НоменклатураЛДСП", "");
	ШапкаОсновныхНастроек.Вставить("КромкаЛДСП", "");
	#КонецОбласти
	
	СтруктураФормы = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицы);
	Двери = СтруктураФормы.Двери;
	Детали.Загрузить(СтруктураФормы.Детали.Выгрузить());
	
	Если Детали.Количество() = 0 Тогда
		Для Каждого ЗначениеЭлемента Из АдресаПредопределенных Цикл
			НоваяСтрока = Детали.Добавить();
			НоваяСтрока.Изделие = ЗначениеЭлемента.Изделие;
			НоваяСтрока.ВидИзделия = ЗначениеЭлемента.ВидИзделия;
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого Строка Из Детали Цикл
		
		Если Строка.ПолучитьИдентификатор() = 0 Тогда
			ТекущийЭлементИзделия = Строка.ВидИзделия;
		КонецЕсли;
		
		НашеИзделие = Строка.Изделие;
		Если Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЗадняяСтенка Тогда
			ЗадняяСтенка = НашеИзделие;
			МатериалСтенки = ПолучитьМатериалСтенки(ЗадняяСтенка);
			
			Если МатериалСтенки = "16 ЛДСП" Тогда
				Элементы.НоменклатураСтенка.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ЛДСП16);
				НоменклатураСтенка = Строка.НоменклатураЛДСП;
			ИначеЕсли МатериалСтенки = "ДВП" Тогда
				Элементы.НоменклатураСтенка.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ДВП);
				НоменклатураСтенка = Строка.НоменклатураДВП;
			Иначе
				Элементы.НоменклатураСтенка.СписокВыбора.Очистить();
			КонецЕсли;
			
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ОсновнойЭлемент Тогда
			ГлубинаИтог = Строка.ГлубинаИзделия;
			ВысотаОсновного = Строка.ВысотаИзделия;
			ШиринаОсновного = Строка.ШиринаИзделия;
			ОсновнойЭлемент = ПолучитьАдрес(НашеИзделие, Строка.ВидИзделия);
			РучкиЯщиков = Строка.Ручка;
			ШапкаОсновныхНастроек.Вставить("НоменклатураЛДСП", Строка.НоменклатураЛДСП);
			ШапкаОсновныхНастроек.Вставить("КромкаЛДСП", Строка.КромкаЛДСП);
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент Тогда
			ЛевыйБоковойЭлемент = ПолучитьАдрес(НашеИзделие, Строка.ВидИзделия);
			РучкиЯщиков = Строка.Ручка;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Пол Тогда
			Пол = ПолучитьАдрес(НашеИзделие, Строка.ВидИзделия);
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент Тогда
			ПравыйБоковойЭлемент = ПолучитьАдрес(НашеИзделие, Строка.ВидИзделия);
			РучкиЯщиков = Строка.Ручка;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Крыша Тогда
			Крыша = ПолучитьАдрес(НашеИзделие, Строка.ВидИзделия);
		КонецЕСли;
		
		Строка.ШиринаИзделияМакс = НашеИзделие.ШиринаИзделияМакс;
		Строка.ВысотаИзделияМакс = НашеИзделие.ВысотаИзделияМакс;
		Строка.ГлубинаИзделияМакс = НашеИзделие.ГлубинаИзделияМакс;
		Строка.ШиринаИзделияМин = НашеИзделие.ШиринаИзделияМин;
		Строка.ВысотаИзделияМин = НашеИзделие.ВысотаИзделияМин;
		Строка.ГлубинаИзделияМин = НашеИзделие.ГлубинаИзделияМин;
		ЕстьЯщики = НашеИзделие.СписокЯщики.Количество() > 0;
		Строка.ЕстьЯщики = ЕстьЯщики;
		Строка.НаВсеИзделие = НашеИзделие.НаВсеИзделие;
		Строка.НеВлияетНаОсновной = НашеИзделие.НеВлияетНаОсновной;
		Строка.Предопределенный = НашеИзделие.Предопределенный;
	КонецЦикла;
	
	ПолучитьИтоговыеРазмеры(ВысотаОсновного, ШиринаОсновного);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Двери") И ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		ДвериПриИзмененииНаКлиенте(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ВыборИзделия(Команда)
	
	ЭлементИзделия = ЭтаФорма.ТекущийЭлемент.Имя;
	ТекущийЭлементИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу." + ЭлементИзделия);
	
	МассивИзделий = Новый Массив;
	Для Каждого Строка Из Детали Цикл
		МассивИзделий.Добавить(Строка.Изделие);
	КонецЦикла;	
	
	Изделие = ОткрытьФормуМодально("Справочник.КаталогИзделий.ФормаВыбора", Новый Структура("ВидИзделия, ИсключитьНесовместимые, МассивИзделий", ТекущийЭлементИзделия, Истина, МассивИзделий), ЭтаФорма);
	
	Если ЗначениеЗаполнено(Изделие) Тогда	
		СтруктураИзделия = ПолучитьСтруктуруИзделия(Изделие, ТекущийЭлементИзделия);
		НашаСтрока = Детали.НайтиСтроки(Новый Структура("ВидИзделия", ТекущийЭлементИзделия));
		
		Если НашаСтрока.Количество() = 1 Тогда
			НоваяСтрока = НашаСтрока[0];
		Иначе
			НоваяСтрока = Детали.Добавить();
		КонецЕсли;
		
		НоваяСтрока.НоменклатураЛДСП = ШапкаОсновныхНастроек.НоменклатураЛДСП;
		НоваяСтрока.КромкаЛДСП = ШапкаОсновныхНастроек.КромкаЛДСП;
		
		ЗаполнитьСтроку(НоваяСтрока, ТекущийЭлементИзделия, Изделие, СтруктураИзделия, ЭлементИзделия);		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	ЭлементИзделия = ЭтаФорма.ТекущийЭлемент.Имя;
	ТекущийЭлементИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу." + ЭлементИзделия);
	НашаСтрока = Детали.НайтиСтроки(Новый Структура("ВидИзделия", ТекущийЭлементИзделия));
	
	Если НашаСтрока.Количество() = 1 Тогда
		ЗаполнитьСтроку(НашаСтрока[0], ТекущийЭлементИзделия,,, ЭлементИзделия);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	РазмерыОсновногоЭлемента = ПолучитьРазмерыОсновногоЭлемента();
	Отказ = Ложь;
	Если РазмерыОсновногоЭлемента <> Неопределено Тогда 
		Модифицированность = Ложь;
		СтруктураФормы = ПроверитьИУстановитьРазмерыПередСохранением(РазмерыОсновногоЭлемента);
		
		Если ЗначениеЗаполнено(Двери) Тогда
			
			Отказ = ПроверкаДвери();
			
		КонецЕсли;
		
		Если (СтруктураФормы <> Неопределено) И (НЕ Отказ) Тогда
			ОповеститьОВыборе(СтруктураФормы);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ СВОЙСТВ И КАТЕГОРИЙ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ИзделиеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Детали.ТекущиеДанные;
	ТекущийЭлементИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу." + ЭтаФорма.ТекущийЭлемент.Имя);	
	НашаСтрока = Детали.НайтиСтроки(Новый Структура("ВидИзделия", ТекущийЭлементИзделия));
	ЭтоПредопределенный = Ложь;
	ЕстьЯщики = Ложь;
	
	Если НашаСтрока.Количество() = 1 Тогда
		
		Элементы.Детали.ТекущаяСтрока = Детали.Индекс(НашаСтрока[0]);
		СтрокаПредопределенных = АдресаПредопределенных.НайтиСтроки(Новый Структура("Изделие",  ТекущиеДанные.Изделие));
		ЭтоПредопределенный = СтрокаПредопределенных.Количество() <> 0;
		
		Если НЕ ЭтоПредопределенный Тогда
			ЕстьЯщики = ТекущиеДанные.ЕстьЯщики;
			Если НЕ ЗначениеЗаполнено(ТекущиеДанные.НоменклатураЛДСП) И ЗначениеЗаполнено(ШапкаОсновныхНастроек.НоменклатураЛДСП) Тогда
				ТекущиеДанные.НоменклатураЛДСП = ШапкаОсновныхНастроек.НоменклатураЛДСП;
			ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.НоменклатураЛДСП) Тогда
				ШапкаОсновныхНастроек.Вставить("НоменклатураЛДСП", ТекущиеДанные.НоменклатураЛДСП);
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(ТекущиеДанные.КромкаЛДСП) И ЗначениеЗаполнено(ШапкаОсновныхНастроек.КромкаЛДСП) Тогда
				ТекущиеДанные.КромкаЛДСП = ШапкаОсновныхНастроек.КромкаЛДСП;
			ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.КромкаЛДСП) Тогда
				ШапкаОсновныхНастроек.Вставить("КромкаЛДСП", ТекущиеДанные.КромкаЛДСП);
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.Детали.ТекущаяСтрока = Неопределено;
	КонецЕсли;
	
	УстановитьДоступность(ТекущийЭлементИзделия);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадняяСтенкаПриИзменении(Элемент)
	
	ТекущийЭлементИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЗадняяСтенка");
	
	УстановитьДоступность(ТекущийЭлементИзделия);
	
	Если ЗначениеЗаполнено(ЗадняяСтенка) Тогда
		
		МатериалСтенки = ПолучитьМатериалСтенки(ЗадняяСтенка);
		
		Если МатериалСтенки = "16 ЛДСП" Тогда
			Элементы.НоменклатураСтенка.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ЛДСП16);
		ИначеЕсли МатериалСтенки = "ДВП" Тогда
			Элементы.НоменклатураСтенка.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ДВП);
		Иначе
			Элементы.НоменклатураСтенка.СписокВыбора.Очистить();
		КонецЕсли;
		
		Стенка = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЗадняяСтенка");
		НашаСтрока = Детали.НайтиСтроки(Новый Структура("ВидИзделия", Стенка));
		
		Если НашаСтрока.Количество() = 1 Тогда
			НоваяСтрока = НашаСтрока[0];
		Иначе
			НоваяСтрока = Детали.Добавить();
		КонецЕсли;
		
		НоваяСтрока.Изделие = ЗадняяСтенка;
		НоваяСтрока.ВидИзделия = Стенка;
		НоменклатураСтенка = Неопределено;
	Иначе
		НоменклатураСтенка = Неопределено;
		Элементы.НоменклатураСтенка.СписокВыбора.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадняяСтенкаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЭлементИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЗадняяСтенка");
	НашаСтрока = Детали.НайтиСтроки(Новый Структура("ВидИзделия", ЭлементИзделия));
	Если НашаСтрока.Количество() = 1 Тогда
		ЗаполнитьСтроку(НашаСтрока[0], ЭлементИзделия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураСтенкаПриИзменении(Элемент)
	
	ТекущийЭлементИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЗадняяСтенка");
	УстановитьДоступность(ТекущийЭлементИзделия);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеталиНоменклатураЛДСППриИзменении(Элемент)
	
	ЛДСП = Элементы.Детали.ТекущиеДанные.НоменклатураЛДСП;
	ШапкаОсновныхНастроек.Вставить("НоменклатураЛДСП", ЛДСП);
	СтруктураПодставляяемойНоменклатуры = ЛексСервер.ПолучитьСтруктуруПодставляемойНоменклатурыПоЦветуЛДСП(ЛДСП, Подразделение);
	Кромка = ?(СтруктураПодставляяемойНоменклатуры.Свойство("Кромка2_19"), СтруктураПодставляяемойНоменклатуры.Кромка2_19, Неопределено);
	
	Если ЗначениеЗаполнено(Кромка) Тогда
		
		Элементы.Детали.ТекущиеДанные.КромкаЛДСП = Кромка;
		ШапкаОсновныхНастроек.Вставить("КромкаЛДСП", Кромка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеталиКромкаЛДСППриИзменении(Элемент)
	
	ШапкаОсновныхНастроек.Вставить("КромкаЛДСП", Элементы.Детали.ТекущиеДанные.КромкаЛДСП);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ ДВЕРИ

&НаКлиенте
Функция ПроверкаДвери()
	
	Отказ = Ложь;
	
	РазмерыДвери = ОпределитьРазмерыДвери();
	
	Если ВысотаПроемаДвери <> РазмерыДвери.ВысотаПроема ИЛИ ШиринаПроемаДвери <> РазмерыДвери.ШиринаПроема Тогда
		
		СписокКнопок = Новый СписокЗначений;	
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, "Редактировать");
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, "Отмена");
		
		Ответ = Вопрос("Размеры двери не совпадают с размерами изделия.", СписокКнопок,,);
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			ПараметрыФормы = Новый Структура("Ключ", Двери);
			ПараметрыФормы.Вставить("ВысотаПроема", РазмерыДвери.ВысотаПроема);
			ПараметрыФормы.Вставить("ШиринаПроема", РазмерыДвери.ШиринаПроема);
			ПараметрыФормы.Вставить("Редактирование", Истина);
			Форма = ПолучитьФорму("Справочник.Двери.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма);
			Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
			Форма.Открыть();
			
		КонецЕсли;
		
		Отказ = Истина;
		
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

&НаКлиенте
Процедура ДвериНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РазмерыДвери = ОпределитьРазмерыДвери();
	Если РазмерыДвери.ВысотаПроема > 0 И РазмерыДвери.ШиринаПроема > 0  Тогда
		
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, "Создать");
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, "Выбрать");
		СписокКнопок.Добавить(КодВозвратаДиалога.Отмена, "Отмена");
		
		Ответ = Вопрос("Создать новую или выбрать существующую дверь?",СписокКнопок,,);
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ВысотаПроема", РазмерыДвери.ВысотаПроема);
			ПараметрыФормы.Вставить("ШиринаПроема", РазмерыДвери.ШиринаПроема);
			ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура("Спецификация", Спецификация));
			
			Форма = ПолучитьФорму("Справочник.Двери.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма);
			Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
			Форма.Открыть();
			
		ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
			           
			ПараметрыФормы = Новый Структура("ШиринаПроема", РазмерыДвери.ШиринаПроема);
			ПараметрыФормы.Вставить("ВысотаПроема", РазмерыДвери.ВысотаПроема);
			ПараметрыФормы.Вставить("Спецификация", Спецификация);
			Форма = ПолучитьФорму("Справочник.Двери.Форма.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
			Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
			Форма.Открыть();
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДвериПриИзменении(Элемент)
	
	ДвериПриИзмененииНаКлиенте(Двери);
	
КонецПроцедуры

&НаКлиенте
Процедура ДвериПриИзмененииНаКлиенте(Значение)
	
	Если ЗначениеЗаполнено(Значение) Тогда
		РазмерыДвери = ПолучитьРазмерыВыбраннойДвери(Значение);
		РазмерыПроема = ОпределитьРазмерыДвери();
		
		Если РазмерыПроема.ВысотаПроема = РазмерыДвери.ВысотаПроема И РазмерыПроема.ШиринаПроема = РазмерыДвери.ШиринаПроема Тогда
			
			Двери = Значение;
			ВысотаПроемаДвери = РазмерыПроема.ВысотаПроема;
			ШиринаПроемаДвери = РазмерыПроема.ШиринаПроема;
			
		Иначе
			
			Двери = Неопределено;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Двери не подходят по размерам", , "Двери");
			
		КонецЕсли;
		
	Иначе
		
		Двери = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

//Размеры двери при выборе уже существующей двери
&НаСервереБезКонтекста
Функция ПолучитьРазмерыВыбраннойДвери(Дверь)
	
	Структура = Новый Структура;
	
	Структура.Вставить("ВысотаПроема", Дверь.ВысотаПроема);
	Структура.Вставить("ШиринаПроема", Дверь.ШиринаПроема);
	
	Возврат Структура;
	
КонецФункции

//Размеры двери с учетом размеров элементов шкафа-купе
&НаКлиенте
Функция ОпределитьРазмерыДвери()
	
	ВысотаПроема = 0;
	ШиринаПроема = 0;
	
	РазмерыОсновногоЭлемента = ПолучитьРазмерыОсновногоЭлемента();
	Если РазмерыОсновногоЭлемента <> Неопределено Тогда
		
		ВысотаПроема = РазмерыОсновногоЭлемента.Высота;
		ШиринаПроема = РазмерыОсновногоЭлемента.Ширина;
		
		Если ВысотаПроема > 0 И ШиринаПроема > 0  Тогда
			Для Каждого Элемент Из Детали Цикл
				
				Если Элемент.НеВлияетНаОсновной И 
					(Элемент.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент") ИЛИ
					Элемент.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент")) Тогда
					
					ШиринаПроема = ШиринаПроема - Элемент.ШиринаИзделия;
					
				ИначеЕсли Элемент.НеВлияетНаОсновной И 
					(Элемент.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.Крыша") ИЛИ
					Элемент.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.Пол")) Тогда
					
					ВысотаПроема = ВысотаПроема - Элемент.ВысотаИзделия;
					
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Структура = Новый Структура;
	
	Структура.Вставить("ВысотаПроема", ВысотаПроема);
	Структура.Вставить("ШиринаПроема", ШиринаПроема);
	
	Возврат Структура;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ


