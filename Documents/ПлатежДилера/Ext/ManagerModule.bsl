﻿Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТоварныйЧек") Тогда
		ПодготовитьПечатнуюФорму("ТоварныйЧек", "Товарный чек", "Документ.ПлатежДилера.ТоварныйЧек",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета);
	Если НужноПечататьМакет Тогда
		Если ИмяМакета = "ТоварныйЧек" Тогда
			ТабДок = ПечатьТоварныйЧек(МассивОбъектов, ОбъектыПечати);
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета,
		ПредставлениеМакета, ТабДок,, ПолныйПутьКМакету);
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьТоварныйЧек(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ТоварныйЧек";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", МассивОбъектов);

    //RonEXI edit	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПлатежДилера.Ссылка КАК Ссылка,
	|	ПлатежДилера.Номер КАК НомерДокумента,
	|	ПлатежДилера.Дата КАК ДатаДокумента,
	|	ПлатежДилера.Автор КАК Автор,
	|	ПлатежДилера.СуммаДокумента КАК Сумма,
	|	ПлатежДилера.ДоговорДопСоглашение.Заказчик КАК Клиент,
	|	ПлатежДилера.ДоговорДопСоглашение.Изделие КАК Изделие,
	|	ПлатежДилера.ДоговорДопСоглашение.Номер КАК НомерДоговора,
	|	ПлатежДилера.ДоговорДопСоглашение.Дата КАК ДатаДоговора,
	|	ПлатежДилера.ДоговорДопСоглашение.Спецификация.Контрагент.ИНН КАК ИНН,
	|	ПлатежДилера.ДоговорДопСоглашение.Спецификация.Контрагент.Телефон КАК Телефон,
	|	ПлатежДилера.ДоговорДопСоглашение.Спецификация.Контрагент КАК Организация,
	|	ПлатежДилера.Автор.ФизическоеЛицо.Должность
	|ИЗ
	|	Документ.ПлатежДилера КАК ПлатежДилера
	|ГДЕ
	|	ПлатежДилера.Ссылка В(&Ссылка)
	|	И ПлатежДилера.Проведен";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Макет = Документы.ПлатежДилера.ПолучитьМакет("ТоварныйЧек");
	Чек = Макет.ПолучитьОбласть("Чек");
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета="рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 0";
	ТабДок.Очистить();
	
	ВставлятьРазделительСтраниц = Ложь;
	
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		Чек.Параметры.Заполнить(Выборка);
		Чек.Параметры.Должность = "Дизайнер";
		Чек.Параметры.ДатаДокумента = Формат(Выборка.ДатаДокумента, "ДЛФ=DD");
		Чек.Параметры.ДатаДоговора = Формат(Выборка.ДатаДоговора, "ДЛФ=DD");
		Чек.Параметры.СуммаПрописью = ЧислоПрописью(Выборка.Сумма, ФормСтрока, ПарПредмета);
		
		ТабДок.Вывести(Чек);
		
		ВставлятьРазделительСтраниц = Истина;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, 
		НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции


