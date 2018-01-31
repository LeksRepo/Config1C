﻿Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если ТипЗнч(МассивОбъектов) = Тип("Структура") Тогда		
		ДоговорДилера = ТипЗнч(МассивОбъектов.МассивОбъектов[0]) = Тип("ДокументСсылка.ДоговорДилера");
		Выборка = Документы.Договор.Запрос(МассивОбъектов.МассивОбъектов, ДоговорДилера);		
	Иначе		
		ДоговорДилера = ТипЗнч(МассивОбъектов[0]) = Тип("ДокументСсылка.ДоговорДилера");
		Выборка = Документы.Договор.Запрос(МассивОбъектов, ДоговорДилера);		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Договор") Тогда
		
		Документы.Договор.ПодготовитьПечатнуюФорму("Договор", "Договор", "Документ.Договор.Договор",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ДоговорДилера") Тогда
		
		Документы.Договор.ПодготовитьПечатнуюФорму("ДоговорДилера", "Договор", "Документ.ДоговорДилера.ПечатнаяФормаДоговора",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "УсловияДоставкиВыписка") Тогда
		
		Документы.Договор.ПодготовитьПечатнуюФорму("УсловияДоставкиВыписка", "Условия доставки и сборки", "Документ.Договор.УсловияДоставкиВыписка",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТитульныйЛистТПМК") Тогда
		
		Документы.Договор.ПодготовитьПечатнуюФорму("ТитульныйЛистТПМК", "Технический паспорт мебельного комплекта", "Документ.Договор.ТитульныйЛистТПМК",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "УсловияДоставкиИСборки") Тогда
		
		Документы.Договор.ПодготовитьПечатнуюФорму("УсловияДоставкиИСборки", "Условия доставки и сборки", "Документ.Договор.УсловияДоставкиИСборки",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИнструкцияПоСборкеШкаф") Тогда
		
		Документы.Договор.ПодготовитьПечатнуюФорму("ИнструкцияПоСборкеШкаф", "Инструкция по сборке", "Документ.Договор.ИнструкцияПоСборкеШкаф",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИнструкцияПоСборкеКухня") Тогда
		
		Документы.Договор.ПодготовитьПечатнуюФорму("ИнструкцияПоСборкеКухня", "Печать инструкция по сборке", "Документ.Договор.ИнструкцияПоСборкеШкаф",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИнструкцияПоСборкеКорпуснаяМебель") Тогда
		
		Документы.Договор.ПодготовитьПечатнуюФорму("ИнструкцияПоСборкеКорпуснаяМебель", "Инструкция по сборке", "Документ.Договор.ИнструкцияПоСборкеШкаф",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЭскизнаяЗаявка") Тогда

		Документы.Договор.ПодготовитьПечатнуюФорму("ЭскизнаяЗаявка", "Эскизная заявка", "Документ.Договор.ЭскизнаяЗаявка",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИспользуемыеМатериалы") Тогда
		
		Документы.Договор.ПодготовитьПечатнуюФорму("ИспользуемыеМатериалы", "Используемые материалы", "Документ.Договор.ИспользуемыеМатериалы",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПоКаталогу") Тогда
		
		Документы.Договор.ПодготовитьПечатнуюФорму("ПоКаталогу", "По каталогу", "Документ.Договор.ПоКаталогу",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ШкафПоКаталогу") Тогда
		
		Документы.Договор.ПодготовитьПечатнуюФорму("ШкафПоКаталогу", "Шкаф по каталогу", "Документ.Договор.ШкафПоКаталогу",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктПередачи") Тогда
		
		Документы.Договор.ПодготовитьПечатнуюФорму("АктПередачи", "Акт передачи мебельного комплекта", "",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
			
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "УведомлениеОЗадолженности") Тогда
		
		Документы.Договор.ПодготовитьПечатнуюФорму("УведомлениеОЗадолженности", "Уведомление о задолженности", "",
		МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЧертежДвери") Тогда
		
		Параметры = Новый Структура;
		Параметры.Вставить("КартинкиДвери", ПараметрыПечати.КартинкиДвери);
		Параметры.Вставить("Договор", ПараметрыПечати.Договор);
		
		Документы.Договор.ПодготовитьПечатнуюФорму("ЧертежДвери", "Чертеж двери", "",
		Параметры, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, Выборка);
		
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

Функция ПолучитьАктВыполнения(ДоговорСсылка) Экспорт
	
	МассивДокументов = ЛексСервер.НайтиПодчиненныеДокументы(ДоговорСсылка, "Документ.АктВыполненияДоговораДилера", "Договор");
	Если МассивДокументов.Количество() = 1 Тогда
		Возврат МассивДокументов[0];
	ИначеЕсли МассивДокументов.Количество() = 0 Тогда
		Возврат Документы.Договор.ПустаяСсылка();
	Иначе
		ВызватьИсключение "Ошибка 817: Нарушена связь документов 'Договор дилера' и 'Акта выполнения дилера'";
	КонецЕсли;
	
КонецФункции

