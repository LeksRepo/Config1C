﻿
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
		
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатнаяФормаДоговора") Тогда
		
		ПодготовитьПечатнуюФорму("ПечатнаяФормаДоговора", "ПечатнаяФормаДоговора", "Документ.ДоговорДилера.ПечатнаяФормаДоговора",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
		
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	Если ИмяМакета = "ПечатнаяФормаДоговора" Тогда
		
		ТабДок = ПечатьДоговораДилера(МассивОбъектов, ОбъектыПечати);
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета, 
		ПредставлениеМакета, ТабДок, , ПолныйПутьКМакету);
				
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьДоговораДилера(МассивОбъектов, ОбъектыПечати) 
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета = "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 0";
	
	ТабДок = Новый ТабличныйДокумент;	
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ПечатнаяФормаДоговора";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = Документы.ДоговорДилера.ПолучитьМакет("ПечатнаяФормаДоговора");
	ОбластьЧасть1 = Макет.ПолучитьОбласть("Часть1");
	ОбластьЧасть3 = Макет.ПолучитьОбласть("Часть3");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорДилера.СуммаДокумента КАК СуммаБезСкидки,
	|	ДоговорДилера.Дата КАК ДатаДоговора,
	|	ДоговорДилера.Номер КАК НомерДоговора,
	|	ДоговорДилера.Автор.ОбъектАвторизации.ПолноеНаименование КАК ПолноеНаименование,
	|	ДоговорДилера.Автор.ОбъектАвторизации.РуководительРодительныйПадеж КАК ФИОДолжностногоЛица,
	|	ДоговорДилера.Автор.ОбъектАвторизации.ДействуетНаОсновании КАК ДейсвтуетНаОсновании,
	|	ДоговорДилера.Автор.ОбъектАвторизации.ОГРН КАК ОГРН,
	|	ДоговорДилера.Заказчик КАК ФИОКлиента,
	|	ДоговорДилера.Изделие КАК Изделие,
	|	ДоговорДилера.Ссылка КАК Договор,
	|	ДоговорДилера.Автор.ОбъектАвторизации.ИНН КАК ИНН,
	|	ДоговорДилера.Автор.ОбъектАвторизации.КПП КАК КПП,
	|	ДоговорДилера.Автор.ОбъектАвторизации.ЮридическийАдрес КАК ЮридическийАдрес,
	|	ДоговорДилера.ДатаМонтажа,
	|	ДоговорДилера.АдресДоговора КАК АдресМонтажа
	|ИЗ
	|	Документ.ДоговорДилера КАК ДоговорДилера
	|ГДЕ
	|	ДоговорДилера.Ссылка В(&МассивОбъектов)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1; 
		
		ОбластьЧасть1.Параметры.Заполнить(Выборка);
		
		ОбластьЧасть1.Параметры.ДатаМонтажа = Формат(Выборка.ДатаМонтажа, "ДЛФ=DD");
		ОбластьЧасть1.Параметры.СуммаПервогоПлатежа = ПолучитьСуммуАванса(Выборка.Договор);
		//ОбластьЧасть1.Параметры.СрокСдачи = Формат(Выборка.СрокСдачи, "ДЛФ=DD");
		//ОбластьЧасть1.Параметры.ДатаДоставки = Формат(Выборка.ДатаМонтажа, "ДЛФ=DD");
		
		ТабДок.Вывести(ОбластьЧасть1);
		ОбластьЧасть3.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(ОбластьЧасть3);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, Выборка.Договор);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Функция ПолучитьСуммуАванса(Договор)
	
	ПервыйПлатеж = 0;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПлатежДилера.СуммаДокумента
	|ИЗ
	|	Документ.ПлатежДилера КАК ПлатежДилера
	|ГДЕ
	|	ПлатежДилера.ДоговорДопСоглашение = &Договор
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПлатежДилера.Дата";
	
	Выборка = Запрос.Выполнить().Выбрать();	
	
	Если Выборка.Количество() > 0 Тогда
		Выборка.Следующий();
		ПервыйПлатеж = Выборка.СуммаДокумента;		
		Выборка.Сбросить();
	КонецЕсли;
	
	Возврат ПервыйПлатеж;
	
КонецФункции
