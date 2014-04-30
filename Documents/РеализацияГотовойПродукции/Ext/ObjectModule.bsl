﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Записать();
	СчетГотоваяПродукция = ПланыСчетов.Управленческий.ГотоваяПродукция;
	МассивСпецификацийРозничныеПроводки = Новый Массив;
	Управление = Константы.Управление.Получить();
	ПроцентСЗаказаУправлению = ЛексСервер.ПолучитьНастройкуПодразделения(Подразделение, Перечисления.ВидыНастроекПодразделений.ПроцентСЗаказаУправлению, Дата);
	СуммаУправлению = 0;
	
	//////////////////////////
	// БЛОКИРОВКА
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", МоментВремени());
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияГотовойПродукцииСписокСпецификаций.Спецификация,
	|	РеализацияГотовойПродукцииСписокСпецификаций.Спецификация.Изделие КАК Изделие,
	|	ЕСТЬNULL(УправленческийОстатки.СуммаОстатокДт, 0) КАК СуммаОстатокДт,
	|	ЕСТЬNULL(УправленческийОстатки.КоличествоОстатокДт, 0) КАК КоличествоОстатокДт,
	|	СтатусСпецификацииСрезПоследних.Статус КАК СтатусСпецификации,
	|	ВЫБОР
	|		КОГДА РеализацияГотовойПродукцииСписокСпецификаций.Спецификация.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК УслугаМонтаж,
	|	РеализацияГотовойПродукцииСписокСпецификаций.Спецификация.Подразделение.СвоиМонтажи КАК СвоиМонтажи
	|ИЗ
	|	Документ.РеализацияГотовойПродукции.СписокСпецификаций КАК РеализацияГотовойПродукцииСписокСпецификаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(&Дата, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.СкладГотовойПродукции), , Подразделение = &Подразделение) КАК УправленческийОстатки
	|		ПО (РеализацияГотовойПродукцииСписокСпецификаций.Спецификация = (ВЫРАЗИТЬ(УправленческийОстатки.Субконто1 КАК Документ.Спецификация)))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних(, ) КАК СтатусСпецификацииСрезПоследних
	|		ПО РеализацияГотовойПродукцииСписокСпецификаций.Спецификация = СтатусСпецификацииСрезПоследних.Спецификация
	|ГДЕ
	|	РеализацияГотовойПродукцииСписокСпецификаций.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		КоличествоОстаток = Выборка.КоличествоОстатокДт;
		Себестомость = Выборка.СуммаОстатокДт;
		
		Если КоличествоОстаток <> 1 Тогда
			Текст = "" + Выборка.Спецификация + " не числится на счете 'Склад готовой продукции'";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,"Объект.СписокСпецификаций");
			Отказ = Истина;
			Продолжить;
		КонецЕсли;
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		// Статус
		// поменять бы всем сразу...
		Если Выборка.СтатусСпецификации = Перечисления.СтатусыСпецификации.Изготовлен Тогда
			Документы.Спецификация.УстановитьСтатусСпецификации(Выборка.Спецификация, Перечисления.СтатусыСпецификации.Отгружен);
		КонецЕсли;
		
		СвойстваСпецификации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.Спецификация, "Контрагент, Подразделение, СуммаДокумента, ВнутренняяСтоимостьСпецификации, Автор, Дилерский");
		
		Если ЗначениеЗаполнено(Управление) И ЗначениеЗаполнено(ПроцентСЗаказаУправлению) Тогда
			СуммаУправлению = СуммаУправлению + СвойстваСпецификации.ВнутренняяСтоимостьСпецификации * 0.01 * ПроцентСЗаказаУправлению;
		КонецЕсли;
		
		Проводка = СоздатьПроводку(Подразделение, Себестомость);
		Проводка.СчетКт = ПланыСчетов.Управленческий.СкладГотовойПродукции;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.Спецификация;
		Проводка.КоличествоКт = 1;
		
		Если Выборка.Изделие = Справочники.Изделия.Переделка Тогда
			Продолжить;
		КонецЕсли;
		
		Если Выборка.УслугаМонтаж И НЕ Выборка.СвоиМонтажи Тогда
			
			// заказ с монтажем, оприходуем на временный счет
			
			Проводка = СоздатьПроводку(Подразделение, Себестомость);
			Проводка.СчетДт = ПланыСчетов.Управленческий.ИзделияУКлиента;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.Спецификация;
			Проводка.КоличествоДт = 1;
			
		Иначе
			
			// заказ без монтажа, оприходуем прибыль по отгрузке
			
			Если СвойстваСпецификации.Подразделение.БрендДилер Тогда
				СтатьяДоходаПроизводства = Справочники.СтатьиДоходовРасходов.ДоходыПроизводстваОтБрендДилера;
			Иначе
				СтатьяДоходаПроизводства = Справочники.СтатьиДоходовРасходов.ДоходыПроизводстваОтРозницы;
			КонецЕсли;
			
			Проводка = СоздатьПроводку(Подразделение, СвойстваСпецификации.ВнутренняяСтоимостьСпецификации);
			Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПодразделениями;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Подразделения] = СвойстваСпецификации.Подразделение;
			
			Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = СтатьяДоходаПроизводства;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.Спецификация;
			
			МассивСпецификацийРозничныеПроводки.Добавить(Выборка.Спецификация);
			
		КонецЕсли;
		
		//Если НЕ СвойстваСпецификации.Дилерский Тогда
		//	
		//	ПроводкаПоИзделию = Движения.РеализованныеИзделия.Добавить();
		//	ПроводкаПоИзделию.Дизайнер = СвойстваСпецификации.Автор.ФизическоеЛицо;
		//	ПроводкаПоИзделию.Период = Дата;
		//	ПроводкаПоИзделию.ВидИзделия = Выборка.Изделие.ВидИзделия;
		//	ПроводкаПоИзделию.Подразделение = СвойстваСпецификации.Подразделение;
		//	СуммаДокумента = СвойстваСпецификации.СуммаДокумента;
		//	
		//	Если СуммаДокумента < 25000 Тогда
		//		
		//		ЦеноваяКатегория = Перечисления.ЦеноваяКатегория.До25000;
		//		
		//	ИначеЕсли СуммаДокумента < 75000 Тогда
		//		
		//		ЦеноваяКатегория = Перечисления.ЦеноваяКатегория.Между25000_75000;
		//		
		//	Иначе
		//		
		//		ЦеноваяКатегория = Перечисления.ЦеноваяКатегория.Свыше75000;
		//		
		//	КонецЕсли;
		//	
		//	ПроводкаПоИзделию.ЦеноваяКатегория = ЦеноваяКатегория;
		//	ПроводкаПоИзделию.Количество = 1;
		//	
		//КонецЕсли;
		
	КонецЦикла; // цикл по спецификациям
	
	ЛексСервер.РеализацияИзделийРозничныеПроводки(МассивСпецификацийРозничныеПроводки, Дата, Движения);
	
	Если СуммаУправлению > 0 Тогда
		ЛексСервер.НачислитьСуммуУправлению(Подразделение, Движения, СуммаУправлению, Дата);
	КонецЕсли;
	
	Движения.Управленческий.Записывать = Истина;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Изменение статуса спецификации
	Для Каждого Элемент Из СписокСпецификаций Цикл
		
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Элемент.Спецификация) = Перечисления.СтатусыСпецификации.Отгружен Тогда
			
			Документы.Спецификация.УстановитьСтатусСпецификации(Элемент.Спецификация, Перечисления.СтатусыСпецификации.Изготовлен);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВыпускПродукции") Тогда
		
		СписокСпецификаций.Загрузить(ЛексСервер.ПолучитьСпецификацииПоСтатусу(Подразделение, Перечисления.СтатусыСпецификации.Изготовлен));
		ЭтотОбъект.Подразделение	= ДанныеЗаполнения.Подразделение;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеализацияГотовойПродукцииСписокСпецификаций.Спецификация
	|ИЗ
	|	Документ.РеализацияГотовойПродукции.СписокСпецификаций КАК РеализацияГотовойПродукцииСписокСпецификаций
	|ГДЕ
	|	НЕ РеализацияГотовойПродукцииСписокСпецификаций.Спецификация В (&МассивСпецификаций)
	|	И РеализацияГотовойПродукцииСписокСпецификаций.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Выборка.Спецификация) = Перечисления.СтатусыСпецификации.Отгружен Тогда
			Документы.Спецификация.УстановитьСтатусСпецификации(Выборка.Спецификация, Перечисления.СтатусыСпецификации.Изготовлен);
		КонецЕсли;
	КонецЦикла;
	
	// проверка повторного ввода спецификаций
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияГотовойПродукцииСписокСпецификаций.Ссылка
	|ИЗ
	|	Документ.РеализацияГотовойПродукции.СписокСпецификаций КАК РеализацияГотовойПродукцииСписокСпецификаций
	|ГДЕ
	|	РеализацияГотовойПродукцииСписокСпецификаций.Спецификация В(&МассивСпецификаций)
	|	И РеализацияГотовойПродукцииСписокСпецификаций.Ссылка <> &Ссылка";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Уже есть Реализация изделия к некоторым спецификациям", ЭтотОбъект, "Номер");
	КонецЕсли;
	
КонецПроцедуры

Функция СоздатьПроводку(фПодразделение, фСумма)
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = Дата;
	Проводка.Подразделение = фПодразделение;
	Проводка.Сумма = фСумма;
	
	Возврат Проводка;
	
КонецФункции
