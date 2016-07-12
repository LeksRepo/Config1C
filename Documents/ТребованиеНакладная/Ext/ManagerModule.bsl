﻿
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

Функция ПечатьТребованиеНакладная(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета ="рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 0";
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПечатьНарядЗадания";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	ВидыСубконто = Новый Массив;
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура);
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивОбъектов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка КАК Ссылка,
	|	ТребованиеНакладнаяСписокНоменклатуры.НомерСтроки,
	|	ТребованиеНакладнаяСписокНоменклатуры.Затребовано,
	|	ТребованиеНакладнаяСписокНоменклатуры.Отпущено,
	|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура,
	|	ТребованиеНакладнаяСписокНоменклатуры.Содержание,
	|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.ЦеховаяЗона КАК ЦеховаяЗона,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Автор,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Дата,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Номер,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Комментарий,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.СуммаДокумента,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Склад,
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка.Подразделение,
	|	ТребованиеНакладнаяСписокНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|ИЗ
	|	Документ.ТребованиеНакладная.СписокНоменклатуры КАК ТребованиеНакладнаяСписокНоменклатуры
	|ГДЕ
	|	ТребованиеНакладнаяСписокНоменклатуры.Ссылка В(&МассивОбъектов)
	|ИТОГИ ПО
	|	Ссылка,
	|	ЦеховаяЗона";
	
	ВыборкаДокументы = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Макет = Документы.ТребованиеНакладная.ПолучитьМакет("ПечатьТребованиеНакладная");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСписокНоменклатурыШапка = Макет.ПолучитьОбласть("СписокНоменклатурыШапка");
	ОбластьСписокНоменклатуры = Макет.ПолучитьОбласть("СписокНоменклатуры");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	
	ВставлятьРазделительСтраниц = Ложь;
	
	Пока ВыборкаДокументы.Следующий() Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		ОбластьЗаголовок.Параметры.Номер = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(ВыборкаДокументы.Номер, "0");
		ОбластьЗаголовок.Параметры.Дата = Формат(ВыборкаДокументы.Дата, "ДЛФ=DD");
		ТабДок.Вывести(ОбластьЗаголовок);
		
		Шапка.Параметры.Заполнить(ВыборкаДокументы);
		ТабДок.Вывести(Шапка, ВыборкаДокументы.Уровень());
		
		ВыборкаЦеховаяЗона = ВыборкаДокументы.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаЦеховаяЗона.Следующий() Цикл
			
			ОбластьСписокНоменклатурыШапка.Параметры.Заполнить(ВыборкаЦеховаяЗона);
			ТабДок.Вывести(ОбластьСписокНоменклатурыШапка);
			
			ВыборкаСписокНоменклатуры = ВыборкаЦеховаяЗона.Выбрать();
			
			Пока ВыборкаСписокНоменклатуры.Следующий() Цикл
				
				ОбластьСписокНоменклатуры.Параметры.Заполнить(ВыборкаСписокНоменклатуры);
				ТабДок.Вывести(ОбластьСписокНоменклатуры, ВыборкаСписокНоменклатуры.Уровень());
				
			КонецЦикла;
			
		КонецЦикла;
		
		Подвал.Параметры.Заполнить(ВыборкаДокументы);
		Подвал.Параметры.СуммаДокументаПрописью = ЧислоПрописью(ВыборкаДокументы.СуммаДокумента, ФормСтрока, ПарПредмета);
		
		ТабДок.Вывести(Подвал, ВыборкаДокументы.Уровень());
		
		//ВывестиКонтрольРасходаМатериалов(ТабДок, ВыборкаДокументы.Дата, ВыборкаДокументы.Подразделение);
		
		ВставлятьРазделительСтраниц = Истина;
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументы.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьТребованиеНакладная") Тогда
		ПодготовитьПечатнуюФорму("ПечатьТребованиеНакладная", "Печать требование акладной", "Документ.ТребованиеНакладная.ПечатьТребованиеНакладная",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета);
	
	Если НужноПечататьМакет Тогда
		
		Если ИмяМакета = "ПечатьТребованиеНакладная" Тогда
			
			ТабДок = ПечатьТребованиеНакладная(МассивОбъектов, ОбъектыПечати);
			
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета,
		ПредставлениеМакета, ТабДок,, ПолныйПутьКМакету);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьТаблицуМатериалов(НарядЗадание) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НарядЗадание", НарядЗадание);
	Запрос.УстановитьПараметр("Подразделение", НарядЗадание.Подразделение);
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НарядЗаданиеСписокНоменклатуры.КоличествоТребуется КАК Затребовано,
	|	НарядЗаданиеСписокНоменклатуры.Номенклатура
	|ИЗ
	|	Документ.НарядЗадание.СписокНоменклатуры КАК НарядЗаданиеСписокНоменклатуры
	|ГДЕ
	|	НарядЗаданиеСписокНоменклатуры.Ссылка = &НарядЗадание";
	
	тз = Запрос.Выполнить().Выгрузить();
	тз.Колонки.Добавить("Содержание");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НарядЗаданиеРаскройХлыстов.Номенклатура,
	|	НарядЗаданиеРаскройХлыстов.Количество,
	|	НарядЗаданиеРаскройХлыстов.НомерХлыста,
	|	НарядЗаданиеРаскройХлыстов.Остаток,
	|	НарядЗаданиеРаскройХлыстов.РазмерХлыста
	|ПОМЕСТИТЬ втХлысты
	|ИЗ
	|	Документ.НарядЗадание.РаскройХлыстов КАК НарядЗаданиеРаскройХлыстов
	|ГДЕ
	|	НарядЗаданиеРаскройХлыстов.Ссылка = &НарядЗадание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НоменклатураПодразделений.Номенклатура,
	|	НоменклатураПодразделений.ОсновнаяПоСкладу
	|ПОМЕСТИТЬ втНомПодразделений
	|ИЗ
	|	РегистрСведений.НоменклатураПодразделений.СрезПоследних(&Период, Подразделение = &Подразделение) КАК НоменклатураПодразделений
	|ГДЕ
	|	НоменклатураПодразделений.Номенклатура В
	|			(ВЫБРАТЬ
	|				т.Номенклатура
	|			ИЗ
	|				втХлысты КАК т)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втХлысты.Номенклатура КАК Номенклатура,
	|	втХлысты.Количество КАК Количество,
	|	втХлысты.НомерХлыста КАК НомерХлыста,
	|	ВЫБОР
	|		КОГДА втХлысты.Остаток
	|			ТОГДА втХлысты.Количество
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РазмерОстатка,
	|	втХлысты.РазмерХлыста КАК РазмерХлыста,
	|	втНомПодразделений.ОсновнаяПоСкладу КАК ОсновнаяПоСкладу,
	|	втНомПодразделений.ОсновнаяПоСкладу.КоэффициентБазовых * 1000 КАК РазмерЦелогоХлыста
	|ИЗ
	|	втХлысты КАК втХлысты
	|		ЛЕВОЕ СОЕДИНЕНИЕ втНомПодразделений КАК втНомПодразделений
	|		ПО втХлысты.Номенклатура = втНомПодразделений.Номенклатура
	|ИТОГИ
	|	СУММА(Количество),
	|	МАКСИМУМ(РазмерОстатка),
	|	МАКСИМУМ(РазмерХлыста),
	|	МАКСИМУМ(ОсновнаяПоСкладу),
	|	МАКСИМУМ(РазмерЦелогоХлыста)
	|ПО
	|	Номенклатура,
	|	НомерХлыста";
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаНоменклатура = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаНоменклатура.Следующий() Цикл
		
		КоличествоЦелыхХлыстов = 0;
		
		ВыборкаХлысты = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаХлысты.Следующий() Цикл
			
			ИзОстатка = ВыборкаХлысты.РазмерЦелогоХлыста <> ВыборкаХлысты.РазмерХлыста;
			
			Если ВыборкаХлысты.РазмерОстатка > 0 ИЛИ ИзОстатка Тогда
				
				НоваяСтрока = тз.Добавить();
				НоваяСтрока.Номенклатура = ВыборкаХлысты.Номенклатура;
				НоваяСтрока.Затребовано = (ВыборкаХлысты.Количество - ВыборкаХлысты.РазмерОстатка) / 1000 ;
				Если ИзОстатка Тогда
					Содержание = "Из остатка размером " + ВыборкаХлысты.РазмерХлыста;
				Иначе
					Содержание = "Хлыст № " + ВыборкаХлысты.НомерХлыста + " Оставить " + ВыборкаХлысты.РазмерОстатка;
				КонецЕсли;
				НоваяСтрока.Содержание = Содержание;
				
			Иначе
				
				КоличествоЦелыхХлыстов = КоличествоЦелыхХлыстов + 1;
				
			КонецЕсли;
			
		КонецЦикла; // ВыборкаХлысты.Следующий()
		
		Если КоличествоЦелыхХлыстов > 0 Тогда
			
			НоваяСтрока = тз.Добавить();
			НоваяСтрока.Номенклатура = ВыборкаНоменклатура.ОсновнаяПоСкладу;
			НоваяСтрока.Затребовано = КоличествоЦелыхХлыстов;
			
		КонецЕсли;
		
	КонецЦикла; // ВыборкаНоменклатура
	
	Возврат тз;
	
КонецФункции