﻿
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьНарядЗадания") Тогда
		ПодготовитьПечатнуюФорму("ПечатьНарядЗадания", "Печать наряд задания", "Документ.НарядЗадание.ПечатьНарядЗадания",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьМатериалПоЦеховымЗонам") Тогда
		ПодготовитьПечатнуюФорму("ПечатьМатериалПоЦеховымЗонам", "Печать материал по цеховым зонам", "Документ.НарядЗадание.ПечатьМатериалПоЦеховымЗонам",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РаскройСпецификаций") Тогда
		ПодготовитьПечатнуюФорму("РаскройСпецификаций", "Раскрой спецификаций", "Документ.НарядЗадание.РаскройСпецификаций",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета);
	Если НужноПечататьМакет Тогда
		
		Если ИмяМакета = "ПечатьНарядЗадания" Тогда
			ТабДок = ПечатьНарядЗадания(МассивОбъектов, ОбъектыПечати);
		ИначеЕсли ИмяМакета = "ПечатьМатериалПоЦеховымЗонам" Тогда
			ТабДок = ПечатьМатериалПоЦеховымЗонам(МассивОбъектов, ОбъектыПечати);
		ИначеЕсли ИмяМакета = "РаскройСпецификаций" Тогда
			ТабДок = ПечатьРаскройСпецификаций(МассивОбъектов, ОбъектыПечати);
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета, ПредставлениеМакета, ТабДок,, ПолныйПутьКМакету);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьНарядЗадания(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПечатьНарядЗадания";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	ВидыСубконто = Новый Массив;
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивОбъектов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НарядЗаданиеСписокСпецификаций.Ссылка КАК Ссылка,
	|	НарядЗаданиеСписокСпецификаций.НомерСтроки,
	|	НарядЗаданиеСписокСпецификаций.ДатаИзготовления,
	|	НарядЗаданиеСписокСпецификаций.Спецификация,
	|	НарядЗаданиеСписокСпецификаций.Спецификация.Изделие КАК Изделие,
	|	НарядЗаданиеСписокСпецификаций.Спецификация.Номер КАК НомерСпецификации,
	|	НарядЗаданиеСписокСпецификаций.СуммаНаряда,
	|	НарядЗаданиеСписокСпецификаций.Ссылка.Номер КАК НомерНаряда,
	|	НарядЗаданиеСписокСпецификаций.Ссылка.Дата КАК ДатаНаряда,
	|	НарядЗаданиеСписокСпецификаций.Ссылка.Подразделение,
	|	НарядЗаданиеСписокСпецификаций.Ссылка.СуммаДокумента КАК СуммаДокумента,
	|	НарядЗаданиеСписокСпецификаций.Спецификация.ДатаОтгрузки КАК ДатаОтгрузки,
	|	НарядЗаданиеСписокСпецификаций.Ссылка.ДатаИзготовления КАК ДатаИзготовленияНаряда,
	|	спрЗаметки.ТекстСодержания КАК Заметка,
	|	ВЫБОР
	|		КОГДА Комплектация.Ссылка ЕСТЬ NULL 
	|				ИЛИ НЕ Комплектация.Проведен
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЕстьПроведеннаяКомплектация
	|ИЗ
	|	Документ.НарядЗадание.СписокСпецификаций КАК НарядЗаданиеСписокСпецификаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Заметки КАК спрЗаметки
	|		ПО НарядЗаданиеСписокСпецификаций.Спецификация = спрЗаметки.Предмет
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Комплектация КАК Комплектация
	|		ПО НарядЗаданиеСписокСпецификаций.Спецификация = Комплектация.Спецификация
	|ГДЕ
	|	НарядЗаданиеСписокСпецификаций.Ссылка В(&МассивОбъектов)
	|ИТОГИ ПО
	|	Ссылка";
	
	Макет = Документы.НарядЗадание.ПолучитьМакет("ПечатьНарядЗадания");
	Заголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	СпецификацииШапка = Макет.ПолучитьОбласть("СпецификацииШапка");
	СпецификацииСтрока = Макет.ПолучитьОбласть("СпецификацииСтрока");
	СтрокаЗаметка = Макет.ПолучитьОбласть("СтрокаЗаметка");
	
	ВыборкаДокументы = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВставлятьРазделительСтраниц = Ложь;
	
	МассивСпецификаций=Новый Массив();
	
	Пока ВыборкаДокументы.Следующий() Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		Заголовок.Параметры.НомерНаряда = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(ВыборкаДокументы.НомерНаряда, "0");
		Заголовок.Параметры.ДатаИзготовления = Формат(ВыборкаДокументы.ДатаИзготовленияНаряда, "ДЛФ=DD");
		ТабДок.Вывести(Заголовок);
		
		Шапка.Параметры.Заполнить(ВыборкаДокументы);
		ТабДок.Вывести(Шапка);
		
		ТабДок.Вывести(СпецификацииШапка);
		
		ВыборкаСпецификации = ВыборкаДокументы.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаСпецификации.Следующий() Цикл
			
			МассивСпецификаций.Добавить(ВыборкаСпецификации.Спецификация);
			
			СпецификацииСтрока.Параметры.Заполнить(ВыборкаСпецификации);
			СпецификацииСтрока.Параметры.Изделие = ВыборкаСпецификации.Изделие;
			СпецификацииСтрока.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(ВыборкаСпецификации.НомерСпецификации, "0");
			СпецификацииСтрока.Параметры.КоличествоДверей = Отчеты.ПроизводственныйОтчет.ПосчитатьКоличествоДверей(ВыборкаСпецификации.Спецификация);
			
			Комплектации = Отчеты.ПроизводственныйОтчет.ЕстьКомплектации(ВыборкаСпецификации.Спецификация);
			
			СпецификацииСтрока.Параметры.КомплектацияЦех = Комплектации.Цех;
			СпецификацииСтрока.Параметры.КомплектацияСклад = Комплектации.Склад;
			
			ТабДок.Вывести(СпецификацииСтрока);
			
			Если ЗначениеЗаполнено(ВыборкаСпецификации.Заметка) Тогда
				СтрокаЗаметка.Параметры.Заметка = ВыборкаСпецификации.Заметка;
				СтрокаЗаметка.Параметры.НомерСпецификации = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(ВыборкаСпецификации.НомерСпецификации, "0");
				ТабДок.Вывести(СтрокаЗаметка);
			КонецЕсли;
			
		КонецЦикла;
		
		Отчеты.ПроизводственныйОтчет.ВывестиПроизводственныйОтчет(ТабДок, ВыборкаДокументы.Подразделение, МассивОбъектов, Новый Структура);
		
		ВставлятьРазделительСтраниц = Истина;
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументы.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьМатериалПоЦеховымЗонам(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПечаПечатьМатериалПоЦеховымЗонамтьНарядЗадания";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = Документы.НарядЗадание.ПолучитьМакет("ПечатьМатериалПоЦеховымЗонам");
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивНарядов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НарядЗаданиеСписокНоменклатуры.Номенклатура,
	|	НарядЗаданиеСписокНоменклатуры.Ссылка КАК Ссылка,
	|	0 КАК Затребовано,
	|	НарядЗаданиеСписокНоменклатуры.ОстатокВЦеху,
	|	НарядЗаданиеСписокНоменклатуры.ОстатокНаСкладе,
	|	НарядЗаданиеСписокНоменклатуры.ТребуетсяПоСпецификациям,
	|	НарядЗаданиеСписокНоменклатуры.Номенклатура.ЦеховаяЗона КАК ЦеховаяЗона,
	|	НарядЗаданиеСписокНоменклатуры.НомерСтроки КАК НомерСтроки,
	|	НарядЗаданиеСписокНоменклатуры.Ссылка.Номер КАК НомерДокумента,
	|	НарядЗаданиеСписокНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	НарядЗаданиеСписокНоменклатуры.Ссылка.Дата КАК ДатаДокумента
	|ИЗ
	|	Документ.НарядЗадание.СписокНоменклатуры КАК НарядЗаданиеСписокНоменклатуры
	|ГДЕ
	|	НарядЗаданиеСписокНоменклатуры.Ссылка В(&МассивНарядов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НарядЗаданиеСписокНоменклатуры.Номенклатура.Родитель.Наименование,
	|	НарядЗаданиеСписокНоменклатуры.Номенклатура.Наименование
	|ИТОГИ ПО
	|	Ссылка,
	|	ЦеховаяЗона";
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьСписокНоменклатурыШапка = Макет.ПолучитьОбласть("СписокНоменклатурыШапка");
	ОбластьСписокНоменклатурыСтрока = Макет.ПолучитьОбласть("СписокНоменклатурыСтрока");
	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");
	
	ВставлятьРазделительСтраниц = Ложь;
	
	ВыборкаДокументы = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаДокументы.Следующий() Цикл
		
		ОбластьЗаголовок.Параметры.НомерДокумента = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(ВыборкаДокументы.НомерДокумента, "0");
		ОбластьЗаголовок.Параметры.ДатаДокумента = Формат(ВыборкаДокументы.ДатаДокумента, "ДЛФ=DD");
		ОбластьЗаголовок.Параметры.НомераСпецификаций = СформироватьНомераСпецификаций(ВыборкаДокументы.Ссылка);
		
		ТабДок.Вывести(ОбластьЗаголовок);
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		ВыборкаЦеховаяЗона = ВыборкаДокументы.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаЦеховаяЗона.Следующий() Цикл
			
			ОбластьСписокНоменклатурыШапка.Параметры.ЦеховаяЗона = ВыборкаЦеховаяЗона.ЦеховаяЗона;
			
			ТабДок.Вывести(ОбластьСписокНоменклатурыШапка);
			
			ВыборкаНоменклатура = ВыборкаЦеховаяЗона.Выбрать();
			
			Пока ВыборкаНоменклатура.Следующий() Цикл
				
				ОбластьСписокНоменклатурыСтрока.Параметры.Заполнить(ВыборкаНоменклатура);
				ТабДок.Вывести(ОбластьСписокНоменклатурыСтрока);
				
			КонецЦикла;
			
			ТабДок.Вывести(ОбластьПустаяСтрока);
			ТабДок.Вывести(ОбластьПустаяСтрока);
			ТабДок.Вывести(ОбластьПустаяСтрока);
			
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументы.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьРаскройСпецификаций(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет = Документы.НарядЗадание.ПолучитьМакет("РаскройСпецификаций");
	ОбластьКартинка = Макет.ПолучитьОбласть("Картинка");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Объект", МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РаскройДеталей.РисунокРаскроя,
	|	РаскройДеталей.Объект КАК Ссылка,
	|	РаскройДеталей.РисунокКривогоПила
	|ИЗ
	|	РегистрСведений.РаскройДеталей КАК РаскройДеталей
	|ГДЕ
	|	РаскройДеталей.Объект В(&Объект)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		МассивПараметров = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрЗаменить(Выборка.РисунокРаскроя,"save☻", ""), "☺");
		МассивПараметровКривогоПила = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрЗаменить(Выборка.РисунокКривогоПила,"save☻", ""), "☺");
		
		Для Каждого Строка Из МассивПараметровКривогоПила Цикл
			
			ДанныеКривогоПила = Base64Значение(Строка);
			
			ОбластьКартинка.Рисунки.D1.Картинка = Новый Картинка(ДанныеКривогоПила);
			ТабДок.Вывести(ОбластьКартинка);
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЦикла;
		
		Для Каждого Элемент Из МассивПараметров Цикл
			
			Данные = Base64Значение(Элемент);
			
			ОбластьКартинка.Рисунки.D1.Картинка = Новый Картинка(Данные);
			ТабДок.Вывести(ОбластьКартинка);
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
		
КонецФункции

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

Функция СформироватьНомераСпецификаций(Ссылка)
	
	Результат = "";
	
	Для каждого Строка Из Ссылка.СписокСпецификаций Цикл
		
		Номер = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Строка.Спецификация, "Номер");
		Результат = Результат + СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Номер, "0") + ", ";
		
	КонецЦикла;
	
	Если Результат <> "" Тогда
		Результат = Лев(Результат, СтрДлина(Результат) - 2) + "." ;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПолучитьТаблицуЗеркал(СписокСпецификаций, Документ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокСпецификаций", СписокСпецификаций);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпецификацияСписокМатериалы.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА спрНоменклатура.ОсновнаяПоСкладу
	|			ТОГДА спрНоменклатура.Ссылка
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК НоменклатураОсновнаяПоСкладу,
	|	СпецификацияСписокМатериалы.ВысотаДетали КАК ВысотаДетали,
	|	СпецификацияСписокМатериалы.ШиринаДетали КАК ШиринаДетали,
	|	ИСТИНА КАК Раскрой,
	|	СпецификацияСписокМатериалы.Количество КАК Количество,
	|	СпецификацияСписокМатериалы.Комментарий КАК Комментарий,
	|	СпецификацияСписокМатериалы.Ссылка КАК Спецификация
	|ИЗ
	|	Документ.Спецификация.СписокМатериалы КАК СпецификацияСписокМатериалы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК спрНоменклатура
	|		ПО СпецификацияСписокМатериалы.Номенклатура = спрНоменклатура.БазоваяНоменклатура
	|ГДЕ
	|	СпецификацияСписокМатериалы.Ссылка В(&СписокСпецификаций)
	|	И СпецификацияСписокМатериалы.Номенклатура.НоменклатурнаяГруппа = ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.Зеркало)
	|	И спрНоменклатура.ОсновнаяПоСкладу
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДвериСписокНоменклатуры.Номенклатура,
	|	ВЫБОР
	|		КОГДА спрНоменклатура.ОсновнаяПоСкладу
	|			ТОГДА спрНоменклатура.Ссылка
	|		ИНАЧЕ NULL
	|	КОНЕЦ,
	|	ДвериСписокНоменклатуры.Длина,
	|	ДвериСписокНоменклатуры.Ширина,
	|	Истина,
	|	ДвериСписокНоменклатуры.Количество,
	|	NULL,
	|	СпецификацияСписокДверей.Ссылка
	|ИЗ
	|	Документ.Спецификация.СписокДверей КАК СпецификацияСписокДверей
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Двери.СписокНоменклатуры КАК ДвериСписокНоменклатуры
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК спрНоменклатура
	|			ПО ДвериСписокНоменклатуры.Номенклатура = спрНоменклатура.БазоваяНоменклатура
	|		ПО СпецификацияСписокДверей.Двери = ДвериСписокНоменклатуры.Ссылка
	|ГДЕ
	|	СпецификацияСписокДверей.Ссылка В(&СписокСпецификаций)
	|	И ДвериСписокНоменклатуры.Номенклатура.НоменклатурнаяГруппа = ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.Зеркало)
	|	И спрНоменклатура.ОсновнаяПоСкладу";
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Документ.СписокЗеркал.Очистить();
	
	Пока Выборка.Следующий() Цикл 
		
		НоваяСтрока = Документ.СписокЗеркал.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка); 
		
	КонецЦикла; 
	
КонецПроцедуры
