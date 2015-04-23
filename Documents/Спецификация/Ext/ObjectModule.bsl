﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Функция ВзаиморасчетыПроводки()
	
	Отказ = Ложь;
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрБухгалтерии.Управленческий");
	ЭлементБлокировки.УстановитьЗначение("Подразделение", Подразделение);
	ЭлементБлокировки.УстановитьЗначение("Счет", ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями);
	ЭлементБлокировки.УстановитьЗначение("Субконто1", Контрагент);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Субконто1", Контрагент);
	Если Дилерский Тогда
		Запрос.УстановитьПараметр("Субконто2", Неопределено);
	Иначе
		Запрос.УстановитьПараметр("Субконто2", Ссылка);
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.СуммаОстатокКт КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			&МоментВремени,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ВзаиморасчетыСПокупателями),
	|			,
	|			Подразделение = &Подразделение
	|				И Субконто1 = &Субконто1
	|				И Субконто2 = &Субконто2) КАК УправленческийОстатки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТекстСообщения = "";
	Если РезультатЗапроса.Пустой() Тогда // денег нет совсем
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Отсутствует аванса у контрагента %1, для проведения спецификации необходимо %2", Контрагент, СуммаДокумента);
	Иначе
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ОстатокПоСчету = Выборка.Сумма;
		
		Если ОстатокПоСчету < СуммаДокумента Тогда // аванс недостаточен
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Суммы аванса %1 у контрагента %2 недостаточно для проведения спецификации, необходимо %3", ОстатокПоСчету, Контрагент, СуммаДокумента);
		Иначе
			
			Если Дилерский Тогда
				Движение = Движения.Управленческий.Добавить();
				Движение.Период = Дата;
				Движение.Подразделение = Подразделение;
				Движение.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
				Движение.СчетДт = ПланыСчетов.Управленческий.ВспомогательныйСчет;
				Движение.СубконтоКт.Контрагенты = Контрагент;
				Движение.Сумма = -СуммаДокумента;
				Движение.Содержание = "Дилер разместил Спецификацию № " + Строка(Номер);
				
				Движение = Движения.Управленческий.Добавить();
				Движение.Период = Дата;
				Движение.Подразделение = Подразделение;
				Движение.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
				Движение.СчетДт = ПланыСчетов.Управленческий.ВспомогательныйСчет;
				Движение.СубконтоКт.Контрагенты = Контрагент;
				Движение.СубконтоКт.СпецификацияДоговор = Ссылка;
				Движение.Сумма = СуммаДокумента;
				
			КонецЕсли;
		КонецЕсли; // аванс недостаточен
	КонецЕсли; // денег нет совсем
	
	//Если Ссылка.ТребуетсяПриходМатериаловЗаказчика Тогда
	//	
	//	Запрос = Новый Запрос;
	//	Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	ПриходМатериаловЗаказчика.Ссылка
	//	|ИЗ
	//	|	Документ.ПриходМатериаловЗаказчика КАК ПриходМатериаловЗаказчика
	//	|ГДЕ
	//	|	ПриходМатериаловЗаказчика.Спецификация = &Ссылка
	//	|	И ПриходМатериаловЗаказчика.Проведен";
	//	
	//	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	//	
	//	РезультатЗапроса = Запрос.Выполнить();
	//	
	//	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//	
	//	Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
	//		
	//		ТекстСообщения = ТекстСообщения + " Необходим проведенный документ ""приход материалов заказчика""";
	//		
	//	КонецЕсли;
	//	
	//КонецЕсли;
		
	Если ТекстСообщения <> "" Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект);
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

Функция СтатусВышеРассчитывается()
	
	Результат = Ложь;
	
	СтатусыДляПроведения = Новый Массив;
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Изготовлен);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Рассчитывается);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Отгружен);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.ПереданВЦех);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Размещен);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Установлен);
	
	СтатусСпецификации = Документы.Спецификация.ПолучитьСтатусСпецификации(Ссылка);
	
	Для каждого Строка Из СтатусыДляПроведения Цикл
		Если СтатусСпецификации = Строка Тогда
			Результат = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПревышенЛимитНарядов()
	
	СтоимостьУслуг = Документы.Спецификация.ПолучитьСтоимостьУслугБезВнешних(СписокНоменклатуры.Выгрузить());
	СтруктураНорматива = Документы.Спецификация.ПолучитьСтруктуруНорматива(ДатаИзготовления, Подразделение);
	
	НарядВЭтойСпецификации = СтоимостьУслуг.ЗарплатаЦеха;
	
	Норматив = СтруктураНорматива.Норматив;
	НарядовНаДень = СтруктураНорматива.ОборотЗаДень;
	
	НормативКоробов = СтруктураНорматива.НормативКоробов;
	ФактКоробов = СтруктураНорматива.ФактКоробов;
	
	ПревышениеНаряда = 0;
	
	Если НарядВЭтойСпецификации <> 0 Тогда
		Если НарядВЭтойСпецификации + НарядовНаДень > Норматив Тогда
			
			ПревышениеНаряда = НарядВЭтойСпецификации + НарядовНаДень - Норматив;
			
		КонецЕсли;
	КонецЕсли;
	
	ПревышениеКоробов = 0;
	
	Если ЭтоКухня Тогда
		
		КоличествоКоробов = ФактКоробов + КоличествоКоробов;
		
		Если КоличествоКоробов > НормативКоробов Тогда
			
			ПревышениеКоробов = КоличествоКоробов - НормативКоробов; 
			
		КонецЕсли;
		
	КонецЕсли;
	
	Ответ = Новый Структура;
	Ответ.Вставить("ПревышениеНаряда", ПревышениеНаряда);
	Ответ.Вставить("ПревышениеКоробов", ПревышениеКоробов);
	
	Возврат Ответ;
	
КонецФункции

Функция ДобавитьПоказательСотрудника(Физлицо, Показатель, Значение, Подразделение)
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = Дата;
	Проводка.Подразделение = Подразделение;
	Проводка.Сумма = Значение;
	Проводка.СчетДт = ПланыСчетов.Управленческий.ПоказателиСотрудника;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ВидыПоказателейСотрудников] = Показатель;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Физлицо;
	
КонецФункции

Функция БольшоеИзделие()
	
	БольшоеИзделие = Ложь;
	
	КоличествоМетров = ЛексСервер.ПолучитьНастройкуПодразделения(Подразделение, Перечисления.ВидыНастроекПодразделений.БольшойШкаф, Дата);
	
	Если ЗначениеЗаполнено(КоличествоМетров) Тогда
		
		БольшоеИзделие = КоличествоМетровЛДСП > КоличествоМетров;
		
	КонецЕсли;
	
	Возврат БольшоеИзделие;
	
КонецФункции

Функция ПроверитьЗанятостьМонтажника(Дата1, Дата2, Отказ);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата1", Дата1);
	Запрос.УстановитьПараметр("Дата2", Дата2);
	Запрос.УстановитьПараметр("Монтажник", Монтажник);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РабочиеДниМонтажников.Монтажник,
	|	РабочиеДниМонтажников.День
	|ИЗ
	|	РегистрСведений.РабочиеДниМонтажников КАК РабочиеДниМонтажников
	|ГДЕ
	|	РабочиеДниМонтажников.Монтажник = &Монтажник
	|	И (РабочиеДниМонтажников.День = &Дата1
	|			ИЛИ РабочиеДниМонтажников.День = &Дата2)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Отказ = Истина;
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			фДата = Формат(Выборка.День, "ДЛФ=ДД");
			
			Если ЗначениеЗаполнено(Дата2) Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("На установку изделия требуется 2 дня, монтажник %1 уже занят %2", Выборка.Монтажник, фДата);
			Иначе
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 уже занят %2", Выборка.Монтажник, фДата);
			КонецЕсли;
			
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Монтажник");
		
	КонецЕсли;
	
КонецФункции

Функция ЗанятьМонтажника(Период)
	
	Проводка = Движения.РабочиеДниМонтажников.Добавить();
	Проводка.День = Период;
	Проводка.Монтажник = Монтажник;
	Проводка.Спецификация = Ссылка;
	Проводка.Город = Офис.Город;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	ПодпискиНаСобытия.ПередЗаписьюДокументаИлиСправочника(ЭтотОбъект);
	
	Отказ = НЕ ПроверитьЗаполнение();
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	//////////////////////////////////////////////////////////
	//ПРЕВЫШЕНИЕ ЛИМИТА
	
	Если НЕ Проведен И ЗначениеЗаполнено(ДатаИзготовления) И ( (Изделие = Справочники.Изделия.Детали) ИЛИ Дилерский) Тогда
		
		//RonEXI: Нет документа установки лимита, не проверяем лимит. 
		ДокументПлановыйЛимит = Документы.ПлановыйЛимит.ПолучитьДокументЗаПериод(Подразделение, ДатаОтгрузки, Истина);
		
		Если ЗначениеЗаполнено(ДокументПлановыйЛимит) Тогда
		
			Превышение = ПревышенЛимитНарядов();
			
			Если Превышение.ПревышениеНаряда > 0 Тогда
				
				Отказ = Истина;
				
				ТекстСообщения = "На %1 превышен максимум нарядов на изготовление. Сумма превышения %2.Выберите другой день отгрузки.";
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Формат(ДатаИзготовления, "ДЛФ=DD"), Превышение.ПревышениеНаряда);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка);
				
			КонецЕсли;
			
			Если Превышение.ПревышениеКоробов > 0 Тогда
				
				Отказ = Истина;
				
				ТекстСообщения = "На %1 превышено количество коробов. Выберите другой день отгрузки.";
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ДатаИзготовления);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	//ПРЕВЫШЕНИЕ ЛИМИТА
	//////////////////////////////////////////////////////////
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ВнутренняяСтоимостьСпецификации = СписокНоменклатуры.Итог("ВнутренняяСтоимость");
	СуммаНарядаСпецификации = Документы.Спецификация.ПолучитьЗарплатуЦеха(СписокНоменклатуры.Выгрузить());
	СуммаДокумента = СписокНоменклатуры.Итог("РозничнаяСтоимость");
	Если Офис.Коэффициент <> 1 И Офис.Коэффициент <> 0 Тогда
		СуммаДокументаБезНаценкиОфиса = СуммаДокумента * 100 / (Офис.Коэффициент * 100);
	Иначе
		СуммаДокументаБезНаценкиОфиса = СуммаДокумента;
	КонецЕсли;
	
	КомплектацияЦех = 0;
	КомплектацияСклад = 0;
	Для каждого Строка Из СкладГотовойПродукции Цикл
		КомплектацияЦех = КомплектацияЦех + Число(Строка.КоличествоЦех > 0);
		КомплектацияСклад = КомплектацияСклад + Число(Строка.КоличествоСклад > 0);
	КонецЦикла;
	
	Если Изделие = Справочники.Изделия.Переделка Тогда
		АдресМонтажа = ДокументОснование.АдресМонтажа;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Документы.Спецификация.ПолучитьСтатусСпецификации(Ссылка)) Тогда
		
		Если Изделие = Справочники.Изделия.ШкафКупеПоКаталогу Тогда
			
			Документы.Спецификация.УстановитьСтатусСпецификации(Ссылка, Перечисления.СтатусыСпецификации.ПроверенТехнологом);
			
		Иначе
			
			Документы.Спецификация.УстановитьСтатусСпецификации(Ссылка, Перечисления.СтатусыСпецификации.Сохранен);
			
		КонецЕсли;
		
	Иначе
		
		Если ДополнительныеСвойства.Свойство("ПередатьВПроизводство") Тогда
			
			Если ДополнительныеСвойства.ПередатьВПроизводство Тогда
				
				// { Васильев Александр Леонидович [16.08.2014]
				// Тут надо провести документ.
				// } Васильев Александр Леонидович [16.08.2014]
				
				//Если Быстрый Тогда
				//	НовыйСтатус = Перечисления.СтатусыСпецификации.ПереданВЦех;
				//Иначе
				НовыйСтатус = Перечисления.СтатусыСпецификации.Размещен;
				//КонецЕсли;
				
				Документы.Спецификация.УстановитьСтатусСпецификации(Ссылка, НовыйСтатус);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Замер") Тогда
		
		ДокументОснование = ДанныеЗаполнения;
		АдресМонтажа = ДанныеЗаполнения.АдресЗамера;
		Километраж = ДанныеЗаполнения.Километраж;
		Офис = ДанныеЗаполнения.Офис;
		Подразделение = ДанныеЗаполнения.Подразделение;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Спецификация") Тогда
		
		ДокументОснование = ДанныеЗаполнения;
		Офис = ДанныеЗаполнения.Офис;
		Изделие = Справочники.Изделия.Переделка;
		Подразделение = ДанныеЗаполнения.Подразделение;
		АдресМонтажа = ДанныеЗаполнения.АдресМонтажа;
		Контрагент = ДанныеЗаполнения.Контрагент;
		ПакетУслуг = Перечисления.ПакетыУслуг.СамовывозОтПроизводителя;
		Комментарий = "Переделка к " + ДанныеЗаполнения;
		Телефон = ДанныеЗаполнения.Телефон;
		
	КонецЕсли;
	
	Дилерский = РольДоступна("ДилерскийДоступКСпецификации");
	
	Если Дилерский И ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		Контрагент = ПараметрыСеанса.ТекущийВнешнийПользователь.ОбъектАвторизации;
		Подразделение = Контрагент.Подразделение;
		ПакетУслуг = Перечисления.ПакетыУслуг.СамовывозОтПроизводителя;
		
		Изделие = Справочники.Изделия.Детали;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Перем Ошибки;
	
	Если НЕ СтатусВышеРассчитывается() Тогда
		Отказ = Истина;
		ТекстСообщения = "Проведение разрешено только для размещенных документов";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если (Изделие = Справочники.Изделия.Переделка) И (НЕ (СписокВиновных.Выгрузить().Итог("Сумма") = СуммаДокумента)) Тогда
		ТекстСообщения = "Сумма удержания не совпадает с суммой документа";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.СписокВиновных", ТекстСообщения);
	КонецЕсли;
	
	// { Васильев Александр Леонидович [28.08.2014]
	// Теперь хитрее надо проверять.
	// } Васильев Александр Леонидович [28.08.2014]
	
	Если Изделие = Справочники.Изделия.Детали ИЛИ (Дилерский И СтатусВышеРассчитывается()) Тогда
		Отказ = ВзаиморасчетыПроводки();
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	/////////////////////////////
	// ЦЕХОВОЙ ЛИМИТ
	
	Если (Изделие = Справочники.Изделия.Детали) ИЛИ Дилерский Тогда
		
		ПоказательПодразделения = Перечисления.ВидыПоказателейПодразделений.СуммаДетали;	
		
	Иначе
		
		ПоказательПодразделения = Перечисления.ВидыПоказателейПодразделений.СуммаИзделия;
		
	КонецЕсли;
	
	Движения.ЦеховойЛимит.Записывать = Истина;
	Запись = Движения.ЦеховойЛимит.Добавить();
	Запись.Период = НачалоДня(ДатаИзготовления);
	Запись.Подразделение = Подразделение;
	Запись.СтоимостьУслугФакт = СуммаНарядаСпецификации;
	Запись.КоличествоКоробовФакт = КоличествоКоробов;
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = Ссылка.ДатаИзготовления;
	Проводка.Подразделение = Подразделение;
	Проводка.СчетДт = ПланыСчетов.Управленческий.ПоказателиПодразделения;
	Проводка.СубконтоДт.ВидыПоказателейПодразделений = ПоказательПодразделения;
	Проводка.Сумма = СуммаНарядаСпецификации;
	
	// { Васильев Александр Леонидович [16.08.2014]
	// Используется где-нибудь этот регистр?
	
	//RonEXI: Вроде нигде, закрываю.
	
	//Если ЗначениеЗаполнено(Виновный) Тогда
	//	Проводка = Движения.ОшибкиСотрудников.Добавить();
	//	Проводка.Период = Дата;
	//	Проводка.Сотрудник = Виновный;
	//	Проводка.Количество = 1;
	//	Проводка.Сумма = СуммаДокумента;
	//КонецЕсли;
	
	// } Васильев Александр Леонидович [16.08.2014]
	
	Если СписокИзделийПоКаталогу.Количество() > 0 Тогда
		Для Каждого СтрокаСпискаИзделий Из СписокИзделийПоКаталогу Цикл
			Проводка = Движения.РеализованныеИзделийПоКаталогу.Добавить();
			Проводка.Период = Дата;
			Проводка.ИзделиеПоКаталогу = СтрокаСпискаИзделий.Изделие;
			Проводка.Количество = 1;
		КонецЦикла;
	КонецЕсли;
	
	/////////////////////////////
	// ДОПОЛНИТЕЛЬНЫЙ ЛИМИТ ДЛЯ ОПЕРАТИВНОГО ЗАКУПА
	ЕстьНарядЗадание = ЗначениеЗаполнено(Документы.Спецификация.ПолучитьНарядЗадание(Ссылка));
	
	Если Дата < '2014.09.16' И Быстрый И НЕ ЕстьНарядЗадание Тогда
		МассивСпецификаций = Новый Массив;
		МассивСпецификаций.Добавить(Ссылка);
		ЛексСервер.УвеличитьДополнительныйЛимит(МассивСпецификаций, Движения, Дата, Подразделение);
	КонецЕсли;
	
	//////////////////////////////////////////
	// РАБОЧИЕ ДНИ МОНТАЖНИКОВ
	Если ЗначениеЗаполнено(Монтажник)
		И ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж
		И Дата > '2014.09.01' Тогда
		
		ДваДняНаУстановку = ЭтоКухня ИЛИ БольшоеИзделие();
		ДатаМонтажаВторойДень = Неопределено;
		
		Если ДваДняНаУстановку Тогда
			
			ДобавитьДней = 1;
			Если ДеньНедели(ДатаМонтажа) = 6 Тогда
				ДобавитьДней = 2;
			КонецЕсли;
			
			ДатаМонтажаВторойДень = ДатаМонтажа + ДобавитьДней * 86400;
			
		КонецЕсли;
		
		ПроверитьЗанятостьМонтажника(ДатаМонтажа, ДатаМонтажаВторойДень, Отказ);
		
		Если НЕ Отказ Тогда
			
			ЗанятьМонтажника(ДатаМонтажа);
			
			Если ЗначениеЗаполнено(ДатаМонтажаВторойДень) Тогда
				
				ЗанятьМонтажника(ДатаМонтажаВторойДень);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Если Изделие = Справочники.Изделия.Переделка Тогда
			
			Содержание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Удержание за переделку %1", Ссылка);
			
			Для Каждого Строка Из СписокВиновных Цикл
			
				Проводка = Движения.Управленческий.Добавить();
				Проводка.Период = Дата;
				Проводка.Подразделение = Подразделение;
				Проводка.Содержание = Содержание;
				
				Проводка.Сумма = Строка.Сумма;
				
				Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Строка.Виновный;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний] = Справочники.ВидыНачисленийУдержаний.УдержанияЗаПеределки;
				
				Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы ;
				Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыЗаПеределкиИУдержанияОтСотрудников;
				
			КонецЦикла;
				
		КонецЕсли;
		
	КонецЕсли;
	
	Движения.РабочиеДниМонтажников.Записывать = Истина;
	Движения.Управленческий.Записывать = Истина;
	Движения.ОшибкиСотрудников.Записывать = Истина;
	Движения.РеализованныеИзделийПоКаталогу.Записывать = Истина;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Ошибки;
	
	Если Дилерский Тогда
		
		// Дату отгрузки для всех проверять надо...
		
		Если Дата > КонецДня(ДатаОтгрузки) Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Дата отгрузки (%1) не может быть раньше даты размещения (%2)%3Выберите другую дату отгрузки" , Формат(ДатаОтгрузки, "ДЛФ=DD"), Формат(Дата, "ДЛФ=DD"), Символы.ПС);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДатаОтгрузки", ТекстСообщения);
			
		КонецЕсли;
		
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Офис"));
		
	Иначе // не дилерский
		
		Если Изделие = Справочники.Изделия.ДопСоглашение Тогда
			Если НЕ ЗначениеЗаполнено(ДокументОснование) ИЛИ ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ДополнительноеСоглашение") Тогда
				
				ТекстСообщения = "Укажите дополнительное соглашение";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДокументОснование", ТекстСообщения);
				
			КонецЕсли;
		КонецЕсли;
		
		Если Контрагент.Дилер Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , "Запрещено создавать спецификации для дилеров");
		КонецЕсли;
		
		Если Контрагент = Справочники.Контрагенты.ЧастноеЛицо И Изделие = Справочники.Изделия.Детали Тогда
			ПроверяемыеРеквизиты.Добавить("Телефон");
		КонецЕсли;
		
		Если Изделие = Справочники.Изделия.Переделка Тогда
			
			ПроверяемыеРеквизиты.Добавить("СписокВиновных");
			ПроверяемыеРеквизиты.Добавить("ЗамечанияИнженера");
						
			Если НЕ ЗначениеЗаполнено(ДокументОснование) ИЛИ ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.Спецификация") Тогда
				ТекстСообщения = "Укажите спецификацию для которой вводится переделка";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДокументОснование", ТекстСообщения);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Изделие = Справочники.Изделия.Переделка
		И ПакетУслуг <> Перечисления.ПакетыУслуг.СамовывозОтПроизводителя Тогда
		ТекстСообщения = "Переделки только самовывозом";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ПакетУслуг", ТекстСообщения);
	КонецЕсли;
	
	Если ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж И Изделие = Справочники.Изделия.Детали Тогда
		ТекстСообщения = "На детали монтаж не устанавливаем";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ПакетУслуг", ТекстСообщения);
	КонецЕсли;
		
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ПользовательАдминистратор = УправлениеДоступомПереопределяемый.ЕстьДоступКПрофилюГруппДоступа(Пользователь, Справочники.ПрофилиГруппДоступа.Администратор);
	
	// { Васильев Александр Леонидович [16.08.2014]
	// Не вполне понимаю это условие...
	Если НЕ ПользовательАдминистратор И СтатусВышеРассчитывается() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Запрещено отменять проведение документа со статусом выше 'Размещен'");
		Отказ = Истина;
	КонецЕсли;
	// } Васильев Александр Леонидович [16.08.2014]
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СписокДверей.Очистить();
	
КонецПроцедуры
