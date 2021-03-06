﻿
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт
	
	ЛексСервер.ПолучитьПредставлениеДокумента(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

Функция ПечатьПеремещениеМатериалов(МассивДокументов, ОбъектыПечати) Экспорт
	
	ТабДок 										= Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати 	= "ПараметрыПечати_РасходныйКассовыйОрдер";
	ТабДок.АвтоМасштаб 					= Истина;
	ТабДок.ОтображатьСетку 			= Ложь;
	ТабДок.Защита 							= Истина;
	ТабДок.ТолькоПросмотр 				= Истина;
	ТабДок.ОтображатьЗаголовки 		= Ложь;
	ФормСтрока 								= "Л = ru_RU; ДП = Истина";
	ПарПредмета 								= "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
	
	Макет 				= Документы.ПеремещениеМатериалов.ПолучитьМакет("ПечатьПеремещениеМатериалов");
	Запрос 				= Новый Запрос;
	Запрос.Текст 		=
	"ВЫБРАТЬ
	|	ПеремещениеМатериалов.Ссылка,
	|	ПеремещениеМатериалов.Автор,
	|	ПеремещениеМатериалов.Дата,
	|	ПеремещениеМатериалов.Номер,
	|	ПеремещениеМатериалов.Подразделение,
	|	ПеремещениеМатериалов.Склад,
	|	ПеремещениеМатериалов.СкладПолучатель,
	|	ПеремещениеМатериалов.СуммаДокумента,
	|	ПеремещениеМатериалов.СписокНоменклатуры.(
	|		НомерСтроки,
	|		Номенклатура,
	|		Количество,
	|		Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|	),
	|	ПеремещениеМатериалов.Склад.МОЛ,
	|	ПеремещениеМатериалов.СкладПолучатель.МОЛ
	|ИЗ
	|	Документ.ПеремещениеМатериалов КАК ПеремещениеМатериалов
	|ГДЕ
	|	ПеремещениеМатериалов.Проведен
	|	И ПеремещениеМатериалов.Ссылка В(&МассивДокументов)";
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	Выборка 										= Запрос.Выполнить().Выбрать();
	ОбластьЗаголовок 							= Макет.ПолучитьОбласть("Заголовок");
	Шапка 											= Макет.ПолучитьОбласть("Шапка");
	Подвал 											= Макет.ПолучитьОбласть("Подвал");
	ОбластьМатериалыОтгруженоШапка 	= Макет.ПолучитьОбласть("МатериалыОтгруженоШапка");
	ОбластьМатериалыОтгружено 			= Макет.ПолучитьОбласть("МатериалыОтгружено");
	ТабДок.Очистить();
	
	ВставлятьРазделительСтраниц = Ложь;
	
	Пока Выборка.Следующий() Цикл
		
		НомерСтрокиНачало 	= ТабДок.ВысотаТаблицы + 1;
		СуммаМатериалов 		= 0;
		
		Если ВставлятьРазделительСтраниц Тогда
			
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ТабДок.Вывести(ОбластьЗаголовок);
		
		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());
		
		ТабДок.Вывести(ОбластьМатериалыОтгруженоШапка);
		
		ВыборкаМатериалыОтгружено = Выборка.СписокНоменклатуры.Выбрать();
		
		Пока ВыборкаМатериалыОтгружено.Следующий() Цикл
			
			ОбластьМатериалыОтгружено.Параметры.Заполнить(ВыборкаМатериалыОтгружено);
			ТабДок.Вывести(ОбластьМатериалыОтгружено, ВыборкаМатериалыОтгружено.Уровень());
			
		КонецЦикла;
		
		Подвал.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Подвал);
		
		ВставлятьРазделительСтраниц = Истина;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПодготовитьПечатнуюФорму("ПечатьПеремещениеМатериалов", "Перемещение материалов", "Документ.ПеремещениеМатериалов.ПечатьПеремещениеМатериалов",
	МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	ТабДок = ПечатьПеремещениеМатериалов(МассивОбъектов, ОбъектыПечати); 
	
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета, 
	ПредставлениеМакета, ТабДок, , ПолныйПутьКМакету);
	
КонецПроцедуры
