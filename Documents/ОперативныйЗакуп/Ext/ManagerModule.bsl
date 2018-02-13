﻿
#Область ОБРАБОТЧИКИ_СОБЫТИЙ

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ПЕЧАТЬ

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьОперативныйЗакуп") Тогда
		ПодготовитьПечатнуюФорму("ПечатьОперативныйЗакуп", "Оперативный закуп", "Документ.ОперативныйЗакуп.ПечатьОперативныйЗакуп",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьЗаявкаПоставщику") Тогда
		ПодготовитьПечатнуюФорму("ПечатьЗаявкаПоставщику", "Заявка поставщику", "Документ.ОперативныйЗакуп.ЗаявкаПоставщику",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	Если ИмяМакета = "ПечатьОперативныйЗакуп" Тогда
		ТабДок = ПечатьОперативныйЗакуп(МассивОбъектов, ОбъектыПечати);
	ИначеЕсли ИмяМакета = "ПечатьЗаявкаПоставщику" Тогда
		ТабДок = ПечатьЗаявкаПоставщику(МассивОбъектов, ОбъектыПечати);
	КонецЕсли;
	
	Если ТабДок <> Неопределено Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета,
		ПредставлениеМакета, ТабДок,, ПолныйПутьКМакету);
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьОперативныйЗакуп(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ОперативныйЗакуп";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылки", МассивОбъектов);
	Запрос.Текст = ПолучитьТекстЗапроса("ОперативныйЗакуп");
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ВыборкаПоДокументам = РезультатЗапроса[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	тзКомплекты = РезультатЗапроса[2].Выгрузить();
	тзСпецификации = РезультатЗапроса[3].Выгрузить();
	
	Макет = Документы.ОперативныйЗакуп.ПолучитьМакет("ПечатьОперативныйЗакуп");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьКонтрагент = Макет.ПолучитьОбласть("Контрагент");
	ОбластьСоставЗаголовок = Макет.ПолучитьОбласть("СоставЗаголовок");
	ОбластьСоставШапка = Макет.ПолучитьОбласть("СоставШапка");
	ОбластьСоставСтрока = Макет.ПолучитьОбласть("СоставСтрока");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрокаОбычная = Макет.ПолучитьОбласть("Строка");
	ОбластьСтрокаПодЗаказ = Макет.ПолучитьОбласть("СтрокаПодЗаказ");
	
	ОбластиСостав = Новый Структура;
	ОбластиСостав.Вставить("ОбластьСоставЗаголовок", ОбластьСоставЗаголовок);
	ОбластиСостав.Вставить("ОбластьСоставШапка", ОбластьСоставШапка);
	ОбластиСостав.Вставить("ОбластьСоставСтрока", ОбластьСоставСтрока);
	
	Логотип = ЛексСервер.ПолучитьЛоготипПоСсылке(МассивОбъектов[0].Подразделение.Логотип);
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		СуммаДокумента = 0;
		
		МассивНоменклатурыЕстьСостав = Новый Массив;
		
		Если ТипЗнч(Логотип) = Тип("ДвоичныеДанные") Тогда
			ОбластьШапка.Рисунки.D1.Картинка = Новый Картинка(Логотип);
			ОбластьШапка.Рисунки.D1.ВыводитьНаПечать = Истина;
		КонецЕсли;
		
		ОбластьШапка.Параметры.Подразделение = ВыборкаПоДокументам.Подразделение;
		ОбластьШапка.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаПоДокументам.НомерОперативногоЗакупа);
		ОбластьШапка.Параметры.ДатаДокумента = Формат(ВыборкаПоДокументам.Дата, "ДФ=dd.MM.yyyy");
		ТабДок.Вывести(ОбластьШапка);
		ТабДок.Вывести(ОбластьШапкаТаблицы);
		
		НомерСтроки = 1;
		
		ВыборкаКонтрагенты = ВыборкаПоДокументам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаКонтрагенты.Следующий() Цикл
			
			ОбластьКонтрагент.Параметры.Поставщик = ВыборкаКонтрагенты.Поставщик;
			Если ЗначениеЗаполнено(ВыборкаКонтрагенты.Поставщик.ПочтовыйАдрес) Тогда
				ОбластьКонтрагент.Параметры.АдресПоставщика = ВыборкаКонтрагенты.Поставщик.ПочтовыйАдрес;
			Иначе
				ОбластьКонтрагент.Параметры.АдресПоставщика = ВыборкаКонтрагенты.Поставщик.ЮридическийАдрес;
			КонецЕсли;
			
			ТабДок.Вывести(ОбластьКонтрагент);
			
			ВыборкаНоменклатура = ВыборкаКонтрагенты.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаНоменклатура.Следующий() Цикл
				
				Если ВыборкаНоменклатура.ПодЗаказ Тогда
					ОбластьСтрока = ОбластьСтрокаПодЗаказ;
				Иначе
					ОбластьСтрока = ОбластьСтрокаОбычная;
				КонецЕсли;
				
				ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
				ОбластьСтрока.Параметры.Заполнить(ВыборкаНоменклатура);
				ОбластьСтрока.Параметры.НоменклатураКод = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(
				ВыборкаНоменклатура.НоменклатураКод);
				
				ОбластьСтрока.Параметры.Номенклатура = СформироватьСтрокуНоменклатуры(
				ВыборкаНоменклатура.Номенклатура, ВыборкаНоменклатура.Комментарий);
				
				НомераСпецификаций = "";
				Если ВыборкаНоменклатура.Номенклатура.Базовый Тогда
					ОтборНоменклатура = ВыборкаНоменклатура.Номенклатура;
				Иначе
					ОтборНоменклатура = ВыборкаНоменклатура.Номенклатура.БазоваяНоменклатура;
				КонецЕсли;
				Отбор = Новый Структура();
				Отбор.Вставить("Номенклатура", ОтборНоменклатура);
				
				Строки = тзСпецификации.НайтиСтроки(Отбор);
				
				Для Каждого Стр ИЗ Строки Цикл
					
					НомераСпецификаций = НомераСпецификаций + ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Стр.Номер) + " / ";
					
				КонецЦикла;
				
				Если НомераСпецификаций <> "" Тогда
					НомераСпецификаций = Лев(НомераСпецификаций, СтрДлина(НомераСпецификаций) - 3);
				КонецЕсли;
				
				ОбластьСтрока.Параметры.НомераСпецификаций = НомераСпецификаций;
				
				ТабДок.Вывести(ОбластьСтрока);
				
				СуммаДокумента = СуммаДокумента + ВыборкаНоменклатура.Стоимость;
				НомерСтроки = НомерСтроки + 1;
				
				Если ВыборкаНоменклатура.Номенклатура.ЕстьОписаниеСостава Тогда
					МассивНоменклатурыЕстьСостав.Добавить(ВыборкаНоменклатура.Номенклатура);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
		Подвал.Параметры.ИтогСтоимость = СуммаДокумента;
		Подвал.Параметры.ИтогСтоимостьПрописью = ЧислоПрописью(СуммаДокумента, СтрокиСообщений.ФормСтрока(), СтрокиСообщений.ПарПредмета());
		ТабДок.Вывести(Подвал);
		
		Если МассивНоменклатурыЕстьСостав.Количество() > 0 Тогда
			ПечатьСостава(ТабДок, МассивНоменклатурыЕстьСостав, ОбластиСостав, тзКомплекты);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьЗаявкаПоставщику(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ЗаявкаПоставщику";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = Документы.ОперативныйЗакуп.ПолучитьМакет("ПечатьЗаявкаПоставщику");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьСоставЗаголовок = Макет.ПолучитьОбласть("СоставЗаголовок");
	ОбластьСоставШапка = Макет.ПолучитьОбласть("СоставШапка");
	ОбластьСоставСтрока = Макет.ПолучитьОбласть("СоставСтрока");
	
	ОбластиСостав = Новый Структура;
	ОбластиСостав.Вставить("ОбластьСоставЗаголовок", ОбластьСоставЗаголовок);
	ОбластиСостав.Вставить("ОбластьСоставШапка", ОбластьСоставШапка);
	ОбластиСостав.Вставить("ОбластьСоставСтрока", ОбластьСоставСтрока);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылки", МассивОбъектов);
	Запрос.Текст = ПолучитьТекстЗапроса("Поставщик");
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	тзКомплекты = РезультатЗапроса[2].Выгрузить();
	ВыборкаПоДокументам = РезультатЗапроса[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		// Здесь требуется выводить общую шапку по оперативному закупу
		// но её как бы нет :)
		
		ВыборкаПоставщик = ВыборкаПоДокументам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоставщик.Следующий() Цикл
			
			МассивНоменклатурыЕстьСостав = Новый Массив;
			
			ОбластьЗаголовок.Параметры.Заполнить(ВыборкаПоставщик);
			ОбластьЗаголовок.Параметры.ТекущаяДата = Формат(ТекущаяДата(), "ДЛФ=DD");
			ОбластьЗаголовок.Параметры.НомерОперативногоЗакупа = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(
			ВыборкаПоставщик.НомерОперативногоЗакупа);
			ТабДок.Вывести(ОбластьЗаголовок);
			
			ОбластьПодвал.Параметры.Стоимость = ВыборкаПоставщик.Стоимость;
			
			ВыборкаНоменклатура = ВыборкаПоставщик.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаНоменклатура.Следующий() Цикл
				
				ОбластьСтрока.Параметры.Заполнить(ВыборкаНоменклатура);
				ОбластьСтрока.Параметры.Номенклатура = СформироватьСтрокуНоменклатуры(
				ВыборкаНоменклатура.Номенклатура, ВыборкаНоменклатура.Комментарий);
				
				Если ВыборкаНоменклатура.Номенклатура.ЕстьОписаниеСостава
					И МассивНоменклатурыЕстьСостав.Найти(ВыборкаНоменклатура.Номенклатура) = Неопределено Тогда
					МассивНоменклатурыЕстьСостав.Добавить(ВыборкаНоменклатура.Номенклатура);
				КонецЕсли;
				
				ТабДок.Вывести(ОбластьСтрока);
				
			КонецЦикла;
			
			ТабДок.Вывести(ОбластьПодвал);
			
			Если МассивНоменклатурыЕстьСостав.Количество() > 0 Тогда
				ПечатьСостава(ТабДок, МассивНоменклатурыЕстьСостав, ОбластиСостав, тзКомплекты);
			КонецЕсли;
			
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

#КонецОбласти

Функция ПолучитьТекстЗапроса(Режим)
	
	Результат =
	"ВЫБРАТЬ
	|	ОперативныйЗакупСписокНоменклатуры.Ссылка,
	|	ОперативныйЗакупСписокНоменклатуры.Поставщик КАК Поставщик,
	|	ОперативныйЗакупСписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	ОперативныйЗакупСписокНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ОперативныйЗакупСписокНоменклатуры.Номенклатура.Код КАК НоменклатураКод,
	|	ОперативныйЗакупСписокНоменклатуры.Цена КАК Цена,
	|	ОперативныйЗакупСписокНоменклатуры.КоличествоПоставщик КАК КоличествоПоставщик,
	|	ОперативныйЗакупСписокНоменклатуры.КоличествоКупить КАК КоличествоКупить,
	|	ОперативныйЗакупСписокНоменклатуры.Стоимость КАК Стоимость,
	|	ОперативныйЗакупСписокНоменклатуры.Комментарий КАК Комментарий,
	|	ОперативныйЗакупСписокНоменклатуры.ПодЗаказ
	|ПОМЕСТИТЬ втСписокНоменклатуры
	|ИЗ
	|	Документ.ОперативныйЗакуп.СписокНоменклатуры КАК ОперативныйЗакупСписокНоменклатуры
	|ГДЕ
	|	ОперативныйЗакупСписокНоменклатуры.Ссылка В(&Ссылки)
	|	И &УсловиеПоКоличеству
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокНоменклатуры.Ссылка КАК Ссылка,
	|	СписокНоменклатуры.Ссылка.Дата КАК Дата,
	|	СписокНоменклатуры.Ссылка.Подразделение КАК Подразделение,
	|	СписокНоменклатуры.Ссылка.Номер КАК НомерОперативногоЗакупа,
	|	СписокНоменклатуры.Поставщик КАК Поставщик,
	|	СписокНоменклатуры.Номенклатура,
	|	СписокНоменклатуры.НоменклатураКод КАК НоменклатураКод,
	|	СписокНоменклатуры.ПодЗаказ,
	|	&ПолеКоличество КАК Количество,
	|	СписокНоменклатуры.Цена КАК Цена,
	|	СписокНоменклатуры.Стоимость КАК Стоимость,
	|	СписокНоменклатуры.Поставщик.Телефон КАК Телефон,
	|	ВЫРАЗИТЬ(СписокНоменклатуры.Поставщик.ЮридическийАдрес КАК СТРОКА(100)) КАК Адрес,
	|	СписокНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВЫРАЗИТЬ(СписокНоменклатуры.Комментарий КАК СТРОКА(100)) КАК Комментарий
	|ИЗ
	|	втСписокНоменклатуры КАК СписокНоменклатуры
	|ИТОГИ
	|	МАКСИМУМ(Подразделение),
	|	МАКСИМУМ(НомерОперативногоЗакупа),
	|	СУММА(Стоимость)
	|ПО
	|	Ссылка,
	|	Поставщик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НоменклатураОписаниеСостава.Ссылка КАК Номенклатура,
	|	НоменклатураОписаниеСостава.НомерСтроки,
	|	НоменклатураОписаниеСостава.Ингридиент,
	|	НоменклатураОписаниеСостава.Количество
	|ИЗ
	|	Справочник.Номенклатура.ОписаниеСостава КАК НоменклатураОписаниеСостава
	|ГДЕ
	|	НоменклатураОписаниеСостава.Ссылка В
	|			(ВЫБРАТЬ
	|				т.Номенклатура
	|			ИЗ
	|				втСписокНоменклатуры КАК т)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НарядЗаданиеСписокНоменклатурыПоСпецификациям.Номенклатура КАК Номенклатура,
	|	НарядЗаданиеСписокНоменклатурыПоСпецификациям.Спецификация.Номер КАК Номер
	|ИЗ
	|	Документ.НарядЗадание.СписокНоменклатурыПоСпецификациям КАК НарядЗаданиеСписокНоменклатурыПоСпецификациям
	|ГДЕ
	|	НарядЗаданиеСписокНоменклатурыПоСпецификациям.Ссылка В
	|			(ВЫБРАТЬ
	|				ОперативныйЗакупНарядЗадания.Наряд
	|			ИЗ
	|				Документ.ОперативныйЗакуп.НарядЗадания КАК ОперативныйЗакупНарядЗадания
	|			ГДЕ
	|				ОперативныйЗакупНарядЗадания.Ссылка В (&Ссылки))";
	
	Если Режим = "Поставщик" Тогда
		
		Результат = СтрЗаменить(Результат, "&УсловиеПоКоличеству", "ОперативныйЗакупСписокНоменклатуры.КоличествоПоставщик > 0");
		Результат = СтрЗаменить(Результат, "&ПолеКоличество", "СписокНоменклатуры.КоличествоПоставщик");
		
	ИначеЕсли Режим = "ОперативныйЗакуп" Тогда
		
		Результат = СтрЗаменить(Результат, "&УсловиеПоКоличеству", "ОперативныйЗакупСписокНоменклатуры.КоличествоКупить > 0");
		Результат = СтрЗаменить(Результат, "&ПолеКоличество", "СписокНоменклатуры.КоличествоКупить");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПечатьСостава(ТабДок, МассивНоменклатуры, ОбластиСостав, тзКомплекты)
	
	ТабДок.Вывести(ОбластиСостав.ОбластьСоставЗаголовок);
	
	Для Каждого Номенклатура Из МассивНоменклатуры Цикл
		
		ОбластиСостав.ОбластьСоставШапка.Параметры.Номенклатура = Номенклатура;
		ТабДок.Вывести(ОбластиСостав.ОбластьСоставШапка);
		
		Отбор = Новый Структура;
		Отбор.Вставить("Номенклатура", Номенклатура);
		
		НайденныеСтроки = тзКомплекты.НайтиСтроки(Отбор);
		
		Для Каждого Строка Из НайденныеСтроки Цикл
			
			ОбластиСостав.ОбластьСоставСтрока.Параметры.Заполнить(Строка);
			ТабДок.Вывести(ОбластиСостав.ОбластьСоставСтрока);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецФункции

Функция СформироватьСтрокуНоменклатуры(Номенклатура, Комментарий)
	
	Перем Результат;
	
	Если СокрЛП(Комментарий) <> "" Тогда
		Результат = "%1%2 ( %3 )";
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Результат,
		Строка(Номенклатура),
		Символы.ПС,
		Комментарий);
	Иначе
		Результат = Строка(Номенклатура);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
