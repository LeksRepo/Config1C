﻿//////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Договор") Тогда
		
		Договор = ДанныеЗаполнения.Ссылка;
		Подразделение = ДанныеЗаполнения.Подразделение;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Записать();
	
	// запросом бы...
	Спецификация = Договор.Спецификация;
	Производство = Спецификация.Производство;
	ВнутренняяСтоимостьСпецификации = Спецификация.ВнутренняяСтоимостьСпецификации;
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Спецификация, "Изделие, Технолог, Производство, СуммаДокумента");
	
	Если НЕ Спецификация.Подразделение.СвоиМонтажи Тогда
		
		Себестоимость = ПолучитьПроизводственнуюСебестоимость(Производство, Спецификация);
		Если Себестоимость = -1 Тогда
			ОшибкаПроведенияНетНаСчете(Отказ, Спецификация);
			Возврат;
		КонецЕсли;
		
		Проводка = СоздатьПроводку(Производство, Себестоимость);
		Проводка.СчетКт = ПланыСчетов.Управленческий.ИзделияУКлиента;
		Проводка.КоличествоКт = 1;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Спецификация;
		
		// Доходы производства
		Проводка = СоздатьПроводку(Производство, ВнутренняяСтоимостьСпецификации);
		Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПодразделениями;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Подразделения] = Подразделение;
		Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыПроизводстваОтРозницы;
		
	КонецЕсли;
	
	///////////////////////
	// показатели сотрудников
	СформироватьПоказателиМонтажника();
	СформироватьПоказателиВодителя();
	
	///////////////////////////////////
	// Закрытие дополнительных соглашений
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДополнительноеСоглашение.СуммаДокумента КАК Сумма,
	|	ДополнительноеСоглашение.Ссылка,
	|	ДополнительноеСоглашение.Договор
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
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Выборка.Договор;
		
		Проводка.Сумма = Выборка.Сумма;
		
	КонецЦикла;
	
	МассивСпецификаций = Новый Массив;
	МассивСпецификаций.Добавить(Спецификация);
	ЛексСервер.РеализацияИзделийРозничныеПроводки(МассивСпецификаций, Дата, Движения, Истина);
	
	Если НЕ Отказ Тогда
		
		Движения.Управленческий.Записывать = Истина;
		
		// Изменение статуса спецификации
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация) = Перечисления.СтатусыСпецификации.Отгружен Тогда
			Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Установлен);
		КонецЕсли;
		
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

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

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

Функция СформироватьПоказателиМонтажника()
	
	Монтажник = Неопределено;
	Спецификация = Договор.Спецификация;
	Производство = Спецификация.Производство;
	Если Спецификация.ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж Тогда
		Монтаж = Документы.Спецификация.ПолучитьМонтаж(Спецификация);
		Если ЗначениеЗаполнено(Монтаж) Тогда
			Монтажник = Монтаж.Монтажник;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Монтажник) Тогда
			
			ДобавитьПоказательСотрудника(Монтажник, Перечисления.ВидыПоказателейСотрудников.КоличествоУстановленныхИзделий, 1, Производство);
			
			КоличествоМетровУстановленныхИзделий = ПолучитьКоличествоНоменклатуры(Спецификация, Справочники.Номенклатура.СборкаИзделия);
			Если КоличествоМетровУстановленныхИзделий <> 0 Тогда
				ДобавитьПоказательСотрудника(Монтажник, Перечисления.ВидыПоказателейСотрудников.КоличествоМетровУстановленныхИзделий, КоличествоМетровУстановленныхИзделий, Производство)
			КонецЕсли;
			
			КилометровУдаленныхМонтажей = ПолучитьКоличествоНоменклатуры(Спецификация, Справочники.Номенклатура.ПроездМонтажникаЗаГородом);
			Если КоличествоМетровУстановленныхИзделий <> 0 Тогда
				ДобавитьПоказательСотрудника(Монтажник, Перечисления.ВидыПоказателейСотрудников.КилометровУдаленныхМонтажей, КилометровУдаленныхМонтажей, Производство)
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

Функция СформироватьПоказателиВодителя()
	
	Экспедитор = Неопределено;
	Спецификация = Договор.Спецификация;
	Производство = Спецификация.Производство;
	Если Спецификация.ПакетУслуг <> Перечисления.ПакетыУслуг.СамовывозОтПроизводителя Тогда
		Монтаж = Документы.Спецификация.ПолучитьМонтаж(Спецификация);
		Если ЗначениеЗаполнено(Монтаж) Тогда
			Экспедитор = Монтаж.Экспедитор;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Экспедитор) Тогда
			
			ДобавитьПоказательСотрудника(Экспедитор, Перечисления.ВидыПоказателейСотрудников.КоличествоДоставленныхИзделий, 1, Производство);
			
			КилометровУдаленныхДоставок = ПолучитьКоличествоНоменклатуры(Спецификация, Справочники.Номенклатура.ДоставкаЗаГородом);
			Если КилометровУдаленныхДоставок <> 0 Тогда
				ДобавитьПоказательСотрудника(Экспедитор, Перечисления.ВидыПоказателейСотрудников.КилометровУдаленныхДоставок, КилометровУдаленныхДоставок, Производство)
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

Функция ДобавитьПоказательСотрудника(Физлицо, Показатель, Значение, Производство)
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = Дата;
	Проводка.Подразделение = Производство;
	Проводка.Сумма = Значение;
	Проводка.СчетДт = ПланыСчетов.Управленческий.ПоказателиСотрудника;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ВидыПоказателейСотрудников] = Показатель;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Физлицо;
	
КонецФункции

Функция ПолучитьКоличествоНоменклатуры(Спецификация, Номенклатура)
	
	Результат = 0;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Номенклатура", Номенклатура);
	НайденныеСтроки = Спецификация.СписокНоменклатуры.НайтиСтроки(ПараметрыОтбора);
	Для каждого Строка Из НайденныеСтроки Цикл
		Результат = Результат + Строка.Количество;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьПроизводственнуюСебестоимость(Производство, Спецификация)
	
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
		Возврат -1;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Если Выборка.КоличествоОстатокДт <> 1 Тогда
		Возврат -1;
	КонецЕсли;
	
	Возврат Выборка.СуммаОстатокДт;
	
КонецФункции

