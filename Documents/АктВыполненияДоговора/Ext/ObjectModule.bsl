﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Договор") Тогда
		
		Договор = ДанныеЗаполнения.Ссылка;
		Подразделение = ДанныеЗаполнения.Подразделение;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Записать();
	
	// запросом бы...
	Спецификация = Договор.Спецификация;
	Производство = Спецификация.Производство;
	ВнутренняяСтоимостьСпецификации = Спецификация.ВнутренняяСтоимостьСпецификации;
	
	// начислить зп монтажникам
	// сделать
	
	// Себестоимость
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Подразделение", Производство);
	Запрос.УстановитьПараметр("ДоговорСпецификация", Спецификация);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УправленческийОстатки.КоличествоОстатокДт,
	|	УправленческийОстатки.СуммаОстатокДт,
	|	УправленческийОстатки.Субконто1.СуммаДокумента КАК СуммаДокумента
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			&МоментВремени,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ИзделияУКлиента),
	|			,
	|			Подразделение = &Подразделение
	|				И Субконто1 = &ДоговорСпецификация) КАК УправленческийОстатки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		ОшибкаПроведенияНетНаСчете(Отказ, Спецификация);
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Если Выборка.КоличествоОстатокДт <> 1 Тогда
			ОшибкаПроведенияНетНаСчете(Отказ, Спецификация);
		Возврат;
	КонецЕсли;
	
	Себестоимость = Выборка.СуммаОстатокДт;
	Проводка = СоздатьПроводку(Подразделение, Себестоимость);
	Проводка.СчетКт = ПланыСчетов.Управленческий.ИзделияУКлиента;
	Проводка.КоличествоКт = 1;
	Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Спецификация;
	Проводка.СчетДт = ПланыСчетов.Управленческий.РасходыПроизводства;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходыНаПроизводственныйМатериал;
	
	// Доходы
	Проводка = СоздатьПроводку(Подразделение, ВнутренняяСтоимостьСпецификации);
	Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
	Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыПроизводстваОтРозницы;
	Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПодразделениями;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Подразделения] = Подразделение;
	
	//Результат = Запрос.Выполнить();
	//Если НЕ Результат.Пустой() Тогда
	//	Выборка = Результат.Выбрать();
	//	Выборка.Следующий();
	//	КоличествоОстаток = Выборка.КоличествоОстатокДт;
	//	Себестомость = Выборка.СуммаОстатокДт;
	//	СуммаДокумента = Выборка.СуммаДокумента;
	//Иначе
	//	КоличествоОстаток = 0;
	//КонецЕсли;
	//
	//Если КоличествоОстаток <> 1 Тогда
	//	Текст = "" + Договор + " не числится на счете готовой продукции";
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,"Объект.Договор");
	//	Отказ = Истина;
	//	Возврат;
	//	
	//КонецЕсли;
	//
	///////////////////////////////////
	//// РАСХОДЫ
	//
	//Проводка 							= Движения.Управленческий.Добавить();
	//Проводка.Период 				= Дата;
	//Проводка.Подразделение 	= Подразделение;
	//Проводка.СчетКт 				= ПланыСчетов.Управленческий.ГотоваяПродукция;
	//Проводка.КоличествоКт 		= 1;
	//Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Договор;
	//
	//Проводка.СчетДт 				= ПланыСчетов.Управленческий.РасходыРозничнойСети;
	//Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходНаПроизводствоМебельногоКомплекта;
	//Проводка.Сумма 				= Себестомость;
	//
	///////////////////////////////////
	//// ДОХОДЫ
	//
	////МассивДопСоглашений = Документы.Договор.ПолучитьМассивДопСоглашений(Договор);
	//
	//Проводка = Движения.Управленческий.Добавить();
	//Проводка.Период = Дата;
	//Проводка.Подразделение = Подразделение;
	//
	//Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
	//Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Договор, "Контрагент");
	//Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Договор;
	//Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
	//Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыОтРозничныхКлиентов;
	//Проводка.Сумма = СуммаДокумента;
	
	// Закрытие дополнительных соглашений
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДополнительноеСоглашение.СуммаДокумента КАК Сумма,
	|	ДополнительноеСоглашение.Ссылка
	|ИЗ
	|	Документ.ДополнительноеСоглашение КАК ДополнительноеСоглашение
	|ГДЕ
	|	ДополнительноеСоглашение.Договор = &Договор
	|	И ДополнительноеСоглашение.Проведен";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Проводка = Движения.Управленческий.Добавить();
		Проводка.Период = Дата;
		Проводка.Подразделение = Подразделение;
		
		Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Договор, "Контрагент");
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.Ссылка;
		Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыОтРозничныхКлиентов;
		Проводка.Сумма = Выборка.Сумма;
		
	КонецЦикла;
	
	МассивСпецификаций = Новый Массив;
	МассивСпецификаций.Добавить(Спецификация);
	ЛексСервер.РеализацияИзделийРозничныеПроводки(МассивСпецификаций, Дата, Движения);
	
	Движения.Управленческий.Записывать = Истина;
	
	// Изменение статуса спецификации
	
	Спецификация  = Договор.Спецификация;
	
	Если Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация) = Перечисления.СтатусыСпецификации.Отгружен Тогда
		
		Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Установлен);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если КонецДня(ТекущаяДата()) <> КонецДня(Константы.ОткрытьДеньДляПроведенияАктов.Получить()) Тогда
		
		Если Дата <> Ссылка.Дата Тогда
			// изменили дату документа
			// или ввели новый
			// необходима проверка периода
			
			Если День(Дата) < 16 Тогда
				
				МожноПроводитьДо = Дата(Год(Дата), Месяц(Дата), 21);
				
			Иначе
				
				ТемпДата 					= ДобавитьМесяц(Дата, 1);
				МожноПроводитьДо 	= Дата(Год(ТемпДата), Месяц(ТемпДата), 6);
				
			КонецЕсли;
			
			Если ТекущаяДата() > МожноПроводитьДо Тогда
				
				Отказ 					= Истина;
				ТекстСообщения 	= "Запрещено проводить акт к договорам прошлых периодов";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Дата");
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Договор.Проведен Тогда
		
		ТекстСобщения = "Запрещено проводить Акт к непроведенному Договору";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСобщения, ЭтотОбъект, "Договор");
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Если Договор.Дата > Дата Тогда
		
		ТекстСобщения = "Вы уверены,что Акт был подписан до договора?";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСобщения, ЭтотОбъект, "Дата");
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	АктВыполнения= Документы.Договор.ПолучитьАктВыполнения(Договор);
	ТекущийДоговор = ЭтотОбъект.Договор;
	
	Если ЗначениеЗаполнено(АктВыполнения) И Ссылка <> АктВыполнения Тогда
		Отказ = Истина;
		ТекстСообщения = "К " + Ссылка + " уже введен " + АктВыполнения;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, АктВыполнения);
	КонецЕсли;
	
	Если ТекущийДоговор <> Ссылка.Договор Тогда
		Спецификация  = Ссылка.Договор.Спецификация;
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация) = Перечисления.СтатусыСпецификации.Установлен Тогда
			
			Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Отгружен);
			
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Изменение статуса спецификации
	
	Спецификация  = Договор.Спецификация;
	
	Если Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация) = Перечисления.СтатусыСпецификации.Установлен Тогда
		
		Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Отгружен);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СоздатьПроводку(фПодразделение, фСумма) 
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = Дата;
	Проводка.Подразделение = фПодразделение;
	Проводка.Сумма = фСумма;
	
	Возврат Проводка;
	
КонецФункции

Функция ОшибкаПроведенияНетНаСчете(Отказ, Спецификация)
	
	Отказ = Истина;
	ТекстСообщения = "" + Спецификация + " не числится на счете 'Изделия у клиента'";
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецФункции