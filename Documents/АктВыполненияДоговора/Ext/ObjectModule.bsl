﻿//////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Договор") Тогда
		
		Договор = ДанныеЗаполнения.Ссылка;
		Подразделение = ДанныеЗаполнения.Подразделение;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	//Управление = Константы.Управление.Получить();
	//ПроцентСЗаказаУправлениюРозница = ЛексСервер.ПолучитьНастройкуПодразделения(Подразделение, Перечисления.ВидыНастроекПодразделений.ПроцентСЗаказаУправлению, Дата);
	//ПроцентСЗаказаУправлениюПроизводство = ЛексСервер.ПолучитьНастройкуПодразделения(Договор.Спецификация.Производство, Перечисления.ВидыНастроекПодразделений.ПроцентСЗаказаУправлению, Дата);
	//СуммаУправлениюОтРозница = 0;
	//СуммаУправлениюОтПроизводства = 0;
	
	Движения.Записать();
	
	Ошибки = Неопределено;
	
	МассивСпецификаций = Новый Массив;
	
	БухгалтерскийУчетПроведениеСервер.СформироватьПроводкиАктВыполнения(МассивСпецификаций, МоментВремени(), Договор, Подразделение, Движения, Ошибки);
	
	Если Ошибки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		Возврат;
		
	КонецЕсли;
	
	БухгалтерскийУчетПроведениеСервер.СформироватьПроводкиПрибыльПроизводства(МассивСпецификаций, Движения, Истина);
	
	БухгалтерскийУчетПроведениеСервер.ЗакрытьДопСоглашенияДоговора(МассивСпецификаций, Движения, Дата, Истина);	
	
	БухгалтерскийУчетПроведениеСервер.РеализацияИзделийРозничныеПроводки(МассивСпецификаций, Движения, Дата, Истина);	
	
	///////////////////////
	// показатели сотрудников
	Если ЗначениеЗаполнено(ДатаПередачи) Тогда
		
		БухгалтерскийУчетПроведениеСервер.СформироватьПоказателиМонтажникаИлиВодителя(МассивСпецификаций, Движения, ДатаПередачи);
			
	КонецЕсли;
	
	
	
	//// запросом бы...
	//Спецификация = Договор.Спецификация;
	//Производство = Спецификация.Производство;
	//ВнутренняяСтоимостьСпецификации = Спецификация.ВнутренняяСтоимостьСпецификации;
	//СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Спецификация, "Изделие, Технолог, Производство, СуммаДокумента");
	//
	//Если НЕ Спецификация.Подразделение.СвоиМонтажи Тогда
	//	
	//	Себестоимость = ПолучитьПроизводственнуюСебестоимость(Производство, Спецификация);
	//	Если Себестоимость = -1 Тогда
	//		ОшибкаПроведенияНетНаСчете(Отказ, Спецификация);
	//		Возврат;
	//	КонецЕсли;
	//	
	//	Проводка = СоздатьПроводку(Производство, Себестоимость);
	//	Проводка.СчетКт = ПланыСчетов.Управленческий.ИзделияУКлиента;
	//	Проводка.КоличествоКт = 1;
	//	Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СпецификацияДоговор] = Спецификация;
	//	
	//	// Доходы производства
	//	ЛексСервер.СформироватьПроводкиПрибыльПроизводства(Спецификация, Движения);
	//	
	//	//Проводка = СоздатьПроводку(Производство, ВнутренняяСтоимостьСпецификации);
	//	//Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПодразделениями;
	//	//Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Подразделения] = Подразделение;
	//	//Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
	//	//Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыПроизводстваОтРозницы;
	//	
	//	Если ЗначениеЗаполнено(Управление) И ЗначениеЗаполнено(ПроцентСЗаказаУправлениюПроизводство) Тогда
	//		СуммаУправлениюОтПроизводства = ВнутренняяСтоимостьСпецификации * 0.01 * ПроцентСЗаказаУправлениюПроизводство;
	//	КонецЕсли;
	//	
	//КонецЕсли;
	//
	/////////////////////////
	//// показатели сотрудников
	//Если ЗначениеЗаполнено(ДатаПередачи) Тогда
	//	
	//	СформироватьПоказателиМонтажника();
	//	СформироватьПоказателиВодителя();
	//	
	//КонецЕсли;
	//ЛексСервер.ЗакрытьДопСоглашенияДоговора(Движения, Договор, Дата);
	//
	//МассивСпецификаций = Новый Массив;
	//МассивСпецификаций.Добавить(Спецификация);
	//ЛексСервер.РеализацияИзделийРозничныеПроводки(МассивСпецификаций, Дата, Движения, Истина);
	//
	//СуммаДоговораСДопСолгашениями = Документы.Договор.ПолучитьСуммуДопСоглашений(Договор) + Договор.СуммаДокумента;
	//Если ЗначениеЗаполнено(Управление) И ЗначениеЗаполнено(ПроцентСЗаказаУправлениюРозница) Тогда
	//	СуммаУправлениюОтРозница = СуммаДоговораСДопСолгашениями * 0.01 * ПроцентСЗаказаУправлениюПроизводство;
	//	ЛексСервер.НачислитьСуммуУправлению(Подразделение, Движения, СуммаУправлениюОтРозница, Дата);
	//КонецЕсли;
	//
	//Если СуммаУправлениюОтПроизводства <> 0 Тогда
	//	ЛексСервер.НачислитьСуммуУправлению(Производство, Движения, СуммаУправлениюОтПроизводства, Дата);
	//КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Движения.Управленческий.Записывать = Истина;
		
		ЛексСервер.ГрупповаяСменаСтатуса(МассивСпецификаций, Перечисления.СтатусыСпецификации.Установлен, Перечисления.СтатусыСпецификации.Отгружен);
		
		//// Изменение статуса спецификации
		//Если Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация) = Перечисления.СтатусыСпецификации.Отгружен Тогда
		//	Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Установлен);
		//КонецЕсли;
		
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
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
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
			
			// объединить бы уже
			// корявенько выглядит
			
			КоличествоУстановленныхИзделий = ПолучитьКоличествоНоменклатуры(Спецификация, Справочники.Номенклатура.ВыездМастера);
			Если КоличествоУстановленныхИзделий <> 0 Тогда
				ДобавитьПоказательСотрудника(Монтажник, Перечисления.ВидыПоказателейСотрудников.КоличествоУстановленныхИзделий, КоличествоУстановленныхИзделий, Производство)
			КонецЕсли;
			
			КоличествоУстановленныхКухонь = ПолучитьКоличествоНоменклатуры(Спецификация, Справочники.Номенклатура.ВыездМастераНаСборкуКухни);
			Если КоличествоУстановленныхКухонь <> 0 Тогда
				ДобавитьПоказательСотрудника(Монтажник, Перечисления.ВидыПоказателейСотрудников.КоличествоУстановленныхКухонь, КоличествоУстановленныхКухонь, Производство)
			КонецЕсли;
			
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
	Проводка.Период = ДатаПередачи;
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

