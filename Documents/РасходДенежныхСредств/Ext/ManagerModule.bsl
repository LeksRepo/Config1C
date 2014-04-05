﻿Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,
	ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РасходныйКассовыйОрдер") Тогда
			
		ПодготовитьПечатнуюФорму("РасходныйКассовыйОрдер", "Расходный кассовый ордер", "Документ.РасходДенежныхСредств.РасходныйКассовыйОрдер",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
		
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета);
	Если НужноПечататьМакет Тогда
		Если ИмяМакета = "РасходныйКассовыйОрдер" Тогда
			ТабДок = ПечатьКассовыйОрдер(МассивОбъектов, ОбъектыПечати); 
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета,
		ПредставлениеМакета, ТабДок,, ПолныйПутьКМакету);
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьКассовыйОрдер(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_РасходныйКассовыйОрдер";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Очистить();
	
	Для каждого Объект Из МассивОбъектов Цикл
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("Ссылка", Объект);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РасходДенежныхСредств.Подразделение КАК ПредставлениеПодразделения,
		|	РасходДенежныхСредств.Подразделение.Организация КАК ПредставлениеОрганизации,
		|	РасходДенежныхСредств.Номер КАК НомерДокумента,
		|	РасходДенежныхСредств.Дата КАК ДатаДокумента,
		|	РасходДенежныхСредств.Подразделение.Код,
		|	РасходДенежныхСредств.Субконто1Дт,
		|	РасходДенежныхСредств.Субконто1Кт КАК Основание,
		|	РасходДенежныхСредств.Субконто2Дт,
		|	РасходДенежныхСредств.Субконто2Кт,
		|	РасходДенежныхСредств.Субконто3Дт,
		|	РасходДенежныхСредств.Субконто3Кт,
		|	РасходДенежныхСредств.Сумма,
		|	РасходДенежныхСредств.Подразделение,
		|	РасходДенежныхСредств.Подразделение.Организация.ФИОДолжностногоЛица,
		|	РасходДенежныхСредств.СчетДт.Код КАК СубСчет,
		|	РасходДенежныхСредств.СчетКт.Код КАК КредитСубСчет,
		|	РасходДенежныхСредств.Ссылка,
		|	ДокументыФизическихЛицСрезПоследних.Серия,
		|	ДокументыФизическихЛицСрезПоследних.Номер,
		|	ДокументыФизическихЛицСрезПоследних.ДатаВыдачи,
		|	ДокументыФизическихЛицСрезПоследних.КемВыдан,
		|	ДокументыФизическихЛицСрезПоследних.ВидДокумента,
		|	РасходДенежныхСредств.Комментарий,
		|	РасходДенежныхСредств.Подразделение.Кассир КАК ФИОКассира
		|ИЗ
		|	Документ.РасходДенежныхСредств КАК РасходДенежныхСредств
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц.СрезПоследних КАК ДокументыФизическихЛицСрезПоследних
		|		ПО (ВЫБОР
		|				КОГДА ТИПЗНАЧЕНИЯ(РасходДенежныхСредств.Субконто1Дт) = ТИП(Справочник.ФизическиеЛица)
		|					ТОГДА РасходДенежныхСредств.Субконто1Дт = ДокументыФизическихЛицСрезПоследних.Физлицо
		|				КОГДА ТИПЗНАЧЕНИЯ(РасходДенежныхСредств.Субконто2Дт) = ТИП(Справочник.ФизическиеЛица)
		|					ТОГДА РасходДенежныхСредств.Субконто2Дт = ДокументыФизическихЛицСрезПоследних.Физлицо
		|			КОНЕЦ)
		|ГДЕ
		|	РасходДенежныхСредств.Ссылка В(&Ссылка)
		|	И РасходДенежныхСредств.Проведен";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Макет = Документы.РасходДенежныхСредств.ПолучитьМакет("РасходныйКассовыйОрдер");
		Шапка = Макет.ПолучитьОбласть("Шапка");
		ОбластьОтчетПоСотруднику = Макет.ПолучитьОбласть("ОтчетПоСотруднику");
		ОбластьШапкаТаблицыПоСотруднику = Макет.ПолучитьОбласть("ШапкаТаблицыПоСотруднику");
		
		ВставлятьРазделительСтраниц = Ложь;
		
		Пока Выборка.Следующий() Цикл
			
			Если ВставлятьРазделительСтраниц Тогда
				
				ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
				
			КонецЕсли;
			
			НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
			
			ФормСтрока = "Л = ru_RU; ДП = Истина";
			ПарПредмета = "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
			СуммаПрописью = ЧислоПрописью(Выборка.Сумма, ФормСтрока, ПарПредмета);
			
			ДатаПрописью = ЛексКлиентСервер.ДатаПрописью(Выборка.ДатаДокумента);
			
			Если ТипЗнч(Выборка.Субконто1Дт) = Тип("СправочникСсылка.Контрагенты") ИЛИ ТипЗнч(Выборка.Субконто1Дт) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
				
				Сотрудник = Выборка.Субконто1Дт;
				
			ИначеЕсли ТипЗнч(Выборка.Субконто2Дт) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
				
				Сотрудник = Выборка.Субконто2Дт;
				
			Иначе
				
				Сотрудник = Неопределено;
				
			КонецЕсли;
			
			Шапка.Параметры.Заполнить(Выборка);
			
			Шапка.Параметры.Сотрудник = Сотрудник;
			Шапка.Параметры.СуммаПрописью = СуммаПрописью;
			Шапка.Параметры.РеквизитыДокументаУдостоверяющегоЛичность = ?(ТипЗнч(Сотрудник) = Тип("СправочникСсылка.ФизическиеЛица"), Строка(Выборка.ВидДокумента) + " " + 
			"Серия " + Строка(Выборка.Серия) + " " +
			"Номер " + Строка(Выборка.Номер) + " " +
			"Выдан " + Строка(Формат(Выборка.ДатаВыдачи, "ДЛФ=Д")) + " " +
			Строка(Выборка.КемВыдан), "");
			
			ТабДок.Вывести(Шапка);
			
			ВставлятьРазделительСтраниц = Истина;
			
			НужноПечататьДопТаблицу = Сотрудник <> Неопределено и ТипЗнч(Сотрудник) <> Тип("СправочникСсылка.Контрагенты");
			
			Если НужноПечататьДопТаблицу Тогда
				
				ОбластьШапкаТаблицыПоСотруднику.Параметры.ПредставлениеПодразделения = Выборка.ПредставлениеПодразделения;
				ТабДок.Вывести(ОбластьШапкаТаблицыПоСотруднику);
				Запрос = Новый Запрос;
				СписокСчетов = Новый Массив;
				СписокСчетов.Добавить(ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками);
				СписокСчетов.Добавить(ПланыСчетов.Управленческий.ОперационнаяКасса);
				СписокСчетов.Добавить(ПланыСчетов.Управленческий.Подотчет);
				Запрос.УстановитьПараметр("ВидСубконтоСотрудник", ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица);
				Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
				Запрос.УстановитьПараметр("СписокСчетов", СписокСчетов);
				
				Запрос.Текст =
				"ВЫБРАТЬ
				|	Счета.Счет КАК Счет,
				|	УправленческийОстатки.Субконто1 КАК Субконто1,
				|	ЕСТЬNULL(УправленческийОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
				|	УправленческийОстатки.Подразделение КАК Подразделение
				|ИЗ
				|	РегистрБухгалтерии.Управленческий.Остатки(, Счет В (&СписокСчетов), &ВидСубконтоСотрудник, ) КАК Счета
				|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(, Счет В (&СписокСчетов), &ВидСубконтоСотрудник, (ВЫРАЗИТЬ(Субконто1 КАК Справочник.ФизическиеЛица)) = &Сотрудник) КАК УправленческийОстатки
				|		ПО Счета.Счет = УправленческийОстатки.Счет
				|ИТОГИ
				|	СУММА(СуммаОстаток)
				|ПО
				|	Счет";
				
				РезультатЗапроса = Запрос.Выполнить();
				
				ВыборкаПоГруппам = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока ВыборкаПоГруппам.Следующий() Цикл
					
					ДетальнаяВыборка = ВыборкаПоГруппам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					ОбластьОтчетПоСотруднику.Параметры.Счет = ВыборкаПоГруппам.Счет;
					ОбластьОтчетПоСотруднику.Параметры.ЗначениеПоВсемПодразделениям = ВыборкаПоГруппам.СуммаОстаток;
					
					Пока ДетальнаяВыборка.Следующий() Цикл
						
						ОбластьОтчетПоСотруднику.Параметры.ЗначениеПодразделения = ДетальнаяВыборка.СуммаОстаток;
					
					КонецЦикла;
					
					ТабДок.Вывести(ОбластьОтчетПоСотруднику);
					
				КонецЦикла;
				
			КонецЕсли;
			
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
			
		КонецЦикла;
			
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры
