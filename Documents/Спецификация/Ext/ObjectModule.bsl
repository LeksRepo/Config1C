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
	
	Ответ = 0;
	
	СтоимостьУслуг = Документы.Спецификация.ПолучитьСтоимостьУслугБезВнешних(СписокНоменклатуры.Выгрузить());
	СтруктураНорматива = Документы.Спецификация.ПолучитьСтруктуруНорматива(ДатаИзготовления, Производство);
	
	НарядВЭтойСпецификации = СтоимостьУслуг.ЗарплатаЦеха;
	
	НормативныйМаксимум = СтруктураНорматива.НормативныйМаксимум;
	НарядовНаДень = СтруктураНорматива.ОборотЗаДень;
	
	Если НарядВЭтойСпецификации <> 0 Тогда
		Если НарядВЭтойСпецификации + НарядовНаДень > НормативныйМаксимум Тогда
			Ответ = НарядВЭтойСпецификации + НарядовНаДень - НормативныйМаксимум;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ответ;
	
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

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Отказ = НЕ ПроверитьЗаполнение();
	
	//////////////////////////////////////////////////////////
	//ПРЕВЫШЕНИЕ ЛИМИТА
	
	Если НЕ Проведен И ЗначениеЗаполнено(ДатаИзготовления) И Изделие = Справочники.Изделия.Детали Тогда
		
		СуммаПревышенияНаряда = ПревышенЛимитНарядов();
		
		Если СуммаПревышенияНаряда > 0 Тогда
			Отказ = Истина;
			
			ТекстСообщения = "На %1 превышен максимум нарядов на изготовление. Сумма превышения %2.Выберите другой день отгрузки.";
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Формат(ДатаИзготовления, "ДЛФ=DD"), СуммаПревышенияНаряда);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка);
			
		КонецЕсли;
		
		Если ЭтоКухня Тогда
			
			УстановитьПривилегированныйРежим(Истина);
			
			// перенести запрос в модуль менеджера
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ДатаИзготовления", ДатаИзготовления);
			Запрос.УстановитьПараметр("Производство", Производство);
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	КОЛИЧЕСТВО(СпецификацияСписокИзделийПоКаталогу.Изделие) КАК Изделие
			|ИЗ
			|	Документ.Спецификация.СписокИзделийПоКаталогу КАК СпецификацияСписокИзделийПоКаталогу
			|ГДЕ
			|	СпецификацияСписокИзделийПоКаталогу.Ссылка.ЭтоКухня
			|	И СпецификацияСписокИзделийПоКаталогу.Ссылка.ДатаИзготовления = &ДатаИзготовления
			|	И СпецификацияСписокИзделийПоКаталогу.Ссылка <> &Ссылка
			|	И СпецификацияСписокИзделийПоКаталогу.Ссылка.Проведен
			|	И СпецификацияСписокИзделийПоКаталогу.Ссылка.Производство = &Производство";
			
			КоличествоКухонь = 0;
			
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
				Выборка = РезультатЗапроса.Выбрать();
				Выборка.Следующий();
				КоличествоКухонь = Выборка.Изделие + СписокИзделийПоКаталогу.Количество();
			КонецЕсли;
			
			Если Число(КоличествоКухонь) > Производство.КоличествоКухонныхКоробов Тогда
				Отказ = Истина;
				ТекстСообщения = "На %1 превышено количество коробов кухонь. Выберите другой день отгрузки.";
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ДатаИзготовления);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка);
			КонецЕсли;
			
		КонецЕсли; //ЭтоКухня
		
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
	Производство = ЛексСервер.ПолучитьОсновноеПроизводство(Подразделение);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Замер") Тогда
		
		ДокументОснование = ДанныеЗаполнения;
		АдресМонтажа = ДанныеЗаполнения.АдресЗамера;
		Километраж = ДанныеЗаполнения.Километраж;
		Офис = ДанныеЗаполнения.Офис;
		Подразделение = ДанныеЗаполнения.Подразделение;
		Производство = ЛексСервер.ПолучитьОсновноеПроизводство(Подразделение);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Спецификация") Тогда
		
		ДокументОснование = ДанныеЗаполнения;
		Офис = ДанныеЗаполнения.Офис;
		Изделие = Справочники.Изделия.Переделка;
		Подразделение = ДанныеЗаполнения.Подразделение;
		Производство = ДанныеЗаполнения.Производство;
		АдресМонтажа = ДанныеЗаполнения.АдресМонтажа;
		Контрагент = ДанныеЗаполнения.Контрагент;
		ПакетУслуг = Перечисления.ПакетыУслуг.СамовывозОтПроизводителя;
		Комментарий = "Переделка к " + ДанныеЗаполнения;
		Телефон = ДанныеЗаполнения.Телефон;
		
	КонецЕсли;
	
	Дилерский = РольДоступна("ДилерскийДоступКСпецификации");
	
	Если Дилерский И ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		Контрагент = ПараметрыСеанса.ТекущийВнешнийПользователь.ОбъектАвторизации;
		ПакетУслуг = Перечисления.ПакетыУслуг.СамовывозОтПроизводителя;

		Изделие = Справочники.Изделия.Детали;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если НЕ СтатусВышеРассчитывается() Тогда
		Отказ = Истина;
		ТекстСообщения = "Проведение разрешено только для размещенных документов";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
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
	
	Если Изделие = Справочники.Изделия.Детали Тогда
		ПоказательПодразделения = Перечисления.ВидыПоказателейПодразделений.СуммаДетали;
	Иначе
		ПоказательПодразделения = Перечисления.ВидыПоказателейПодразделений.СуммаИзделия;
	КонецЕсли;
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = Ссылка.ДатаИзготовления;
	Проводка.Подразделение = Производство;
	Проводка.СчетДт = ПланыСчетов.Управленческий.ПоказателиПодразделения;
	Проводка.СубконтоДт.ВидыПоказателейПодразделений = ПоказательПодразделения;
	Проводка.Сумма = СуммаНарядаСпецификации;
	
	// { Васильев Александр Леонидович [16.08.2014]
	// Используется где-нибудь этот регистр?
	Если ЗначениеЗаполнено(Виновный) Тогда
		Проводка = Движения.ОшибкиСотрудников.Добавить();
		Проводка.Период = Дата;
		Проводка.Сотрудник = Виновный;
		Проводка.Количество = 1;
		Проводка.Сумма = СуммаДокумента;
	КонецЕсли;
	// } Васильев Александр Леонидович [16.08.2014]
	
	/////////////////////////////
	// ДОПОЛНИТЕЛЬНЫЙ ЛИМИТ ДЛЯ ОПЕРАТИВНОГО ЗАКУПА
	ЕстьНарядЗадание = ЗначениеЗаполнено(Документы.Спецификация.ПолучитьНарядЗадание(Ссылка));
	
	Если Дата < '2014.09.16' И Быстрый И НЕ ЕстьНарядЗадание Тогда
		МассивСпецификаций = Новый Массив;
		МассивСпецификаций.Добавить(Ссылка);
		ЛексСервер.УвеличитьДополнительныйЛимит(МассивСпецификаций, Движения, Дата, Производство);
	КонецЕсли;
	
	// { Васильев Александр Леонидович [03.11.2014]
	// Баллы технологов.
	// Больше не используются.
	//КоличествоБалов = Изделие.БалСложности;
	//
	//Если ЗначениеЗаполнено(Технолог) И КоличествоБалов > 0 Тогда
	//	
	//	ДобавитьПоказательСотрудника(Технолог, Перечисления.ВидыПоказателейСотрудников.БаллыТехнологов, КоличествоБалов, Производство);
	//	ДобавитьПоказательСотрудника(Технолог, Перечисления.ВидыПоказателейСотрудников.СуммаРазмещенныхЗаказов, СуммаДокумента, Производство);
	//	
	//КонецЕсли;
	// } Васильев Александр Леонидович [03.11.2014]
	
	//////////////////////////////////////////
	// РАБОЧИЕ ДНИ МОНТАЖНИКОВ
	Если ЗначениеЗаполнено(Монтажник)
		И ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж
		И Дата > '2014.09.01' Тогда
		
		Если ЗанятьМонтажника(ДатаМонтажа) Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		Если ЭтоКухня И Дата > '2014.09.16' Тогда
			
			Если ДеньНедели(ДатаМонтажа + 86400) = 7 Тогда
				Если ЗанятьМонтажника(ДатаМонтажа + 172800) Тогда
					Отказ = Истина;
					Возврат;
				КонецЕсли;
			Иначе
				Если ЗанятьМонтажника(ДатаМонтажа + 86400) Тогда
					Отказ = Истина;
					Возврат;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// { Васильев Александр Леонидович [03.11.2014]
	// С первого нобяря 2014, Управлению начисляем фиксированный
	// процент с каждого размещенного заказа.
	// } Васильев Александр Леонидович [03.11.2014]
	
	Если НЕ Отказ И Дата > '2014.11.01' Тогда // костыль
		
		
		Если Изделие = Справочники.Изделия.Переделка Тогда
			
			Содержание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Удержание за переделку %1");
			
			Проводка = Движения.Управленческий.Добавить();
			//Проводка.Подразделение = Содержание;
			//Проводка.Содержание = Удержание;
			Проводка.Подразделение = Подразделение;
			Проводка.Содержание = Содержание;
			
			Проводка.Сумма = СуммаДокумента;
			
			Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Виновный;
			//Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний] = Справочники.ВидыНачисленийУдержаний.
			Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний] = Справочники.ВидыНачисленийУдержаний.УдержанияЗаПеределки;
			
			Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы ;
			Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ДоходыЗаПеределкиИУдержанияОтСотрудников;
			
		КонецЕсли;
		
		Управление = Константы.Управление.Получить();
		СуммаУправлению = 0;
		ПроцентСЗаказаУправлению = ЛексСервер.ПолучитьНастройкуПодразделения(Подразделение, Перечисления.ВидыНастроекПодразделений.ПроцентСЗаказаУправлению, Дата);
		
		Если ЗначениеЗаполнено(Управление) И ЗначениеЗаполнено(ПроцентСЗаказаУправлению) Тогда
			СуммаУправлению = СуммаДокумента * 0.01 * ПроцентСЗаказаУправлению;
			
			Если СуммаУправлению > 0 Тогда
				
				ТекстКомментария = "%1 процента Управлению с заказа %2";
				ТекстКомментария = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстКомментария, ПроцентСЗаказаУправлению, Ссылка);
				ЛексСервер.НачислитьСуммуУправлению(Подразделение, Движения, СуммаУправлению, Дата, ТекстКомментария);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Движения.РабочиеДниМонтажников.Записывать = Истина;
	Движения.Управленческий.Записывать = Истина;
	Движения.ОшибкиСотрудников.Записывать = Истина;
	
КонецПроцедуры

Функция ПроверитьЗанятостьМонтажника(пДатаМонтажа, пМонтажник);
	
	Отказ = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("День", пДатаМонтажа);
	Запрос.УстановитьПараметр("Монтажник", пМонтажник);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РабочиеДниМонтажников.Монтажник,
	|	РабочиеДниМонтажников.День
	|ИЗ
	|	РегистрСведений.РабочиеДниМонтажников КАК РабочиеДниМонтажников
	|ГДЕ
	|	РабочиеДниМонтажников.Монтажник = &Монтажник
	|	И РабочиеДниМонтажников.День = &День";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Отказ = Истина;
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Если ЭтоКухня Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("На установку кухни требуется 2 дня, монтажник %1 уже занят %2", Выборка.Монтажник, Формат(Выборка.День, "ДЛФ=ДД"));
		Иначе	
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 уже занят %2", Выборка.Монтажник, Формат(Выборка.День, "ДЛФ=ДД"));
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Монтажник");
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

Функция ЗанятьМонтажника(День)
	
	Отказ = ПроверитьЗанятостьМонтажника(День, Монтажник);
	Если НЕ Отказ Тогда
		
		Проводка = Движения.РабочиеДниМонтажников.Добавить();
		Проводка.День = День;
		Проводка.Монтажник = Монтажник;
		Проводка.Спецификация = Ссылка;
		Проводка.Город = Офис.Город;
		
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Ошибки;
	
	Если Дилерский Тогда
		
		// Дату отгрузки для всех проверять надо...
		
		Если Дата > КонецДня(ДатаОтгрузки) Тогда
			
			Отказ = Истина;
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
			
			// { Васильев Александр Леонидович [03.11.2014]
			// Пока повеременим.
			// } Васильев Александр Леонидович [03.11.2014]
			
			//Если НЕ РольДоступна("РазрешенВводПеределок") ИЛИ РольДоступна("ПолныеПрава") Тогда
			//	ТекстСообщения = "Вам запрещено вводить переделки";
			//	ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Изделие", ТекстСообщения);
			//КонецЕсли;
			
			// только инженер отдела качества может создавать переделки
			
			ПроверяемыеРеквизиты.Добавить("Виновный");
			ПроверяемыеРеквизиты.Добавить("ЗамечанияИнженера");
			
			Если НЕ ЗначениеЗаполнено(ДокументОснование) ИЛИ ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.Спецификация") Тогда
				ТекстСообщения = "Укажите спецификацию для которой вводится переделка";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДокументОснование", ТекстСообщения);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДеньНедели(ДатаОтгрузки) = 7 Тогда
		ТекстСообщения = "В воскресенье изделия не отгружаем. Выберите другой день";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДатаОтгрузки", ТекстСообщения);
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
