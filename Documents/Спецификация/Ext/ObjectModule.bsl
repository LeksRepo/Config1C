﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Функция ВернутьОтступ(Сторона)
	
	Если Сторона > 1800 Тогда
		
		Возврат 150;
		
	ИначеЕсли Сторона > 900 Тогда
		
		Возврат 120;
		
	ИначеЕсли Сторона > 600 Тогда
		
		Возврат 70;
		
	ИначеЕсли Сторона > 300 Тогда
		
		Возврат 64;
		
	ИначеЕсли Сторона > 200 Тогда
		
		Возврат 50;
		
	Иначе
		
		Возврат 45;
		
	КонецЕсли;
	
КонецФункции

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

Функция СтатусВышеРазмещен()
	
	СтатусыДляПроведения = Новый Массив;
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Изготовлен);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Отгружен);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.ПереданВЦех);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Размещен);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Установлен);
	
	СтатусСпецификации = Документы.Спецификация.ПолучитьСтатусСпецификации(Ссылка);
	Проводить = Ложь;
	
	Для каждого Строка Из СтатусыДляПроведения Цикл
		Если СтатусСпецификации = Строка Тогда
			Проводить = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Проводить;
	
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
	
	Если НЕ Проведен И ЗначениеЗаполнено(ДатаИзготовления) Тогда
		
		Если Изделие = Справочники.Изделия.Детали Тогда
			
			СуммаПревышенияНаряда = ПревышенЛимитНарядов();
			
			Если СуммаПревышенияНаряда > 0 Тогда
				Отказ = Истина;
				
				ТекстСообщения = "На %1 превышен максимум нарядов на изготовление. Сумма превышения %2.Выберите другой день отгрузки.";
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Формат(ДатаИзготовления, "ДЛФ=DD"), СуммаПревышенияНаряда);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка);
				
			КонецЕсли;
			
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
				Если Быстрый Тогда
					НовыйСтатус = Перечисления.СтатусыСпецификации.ПереданВЦех;
				Иначе
					НовыйСтатус = Перечисления.СтатусыСпецификации.Размещен;
				КонецЕсли;
				
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
		Офис = Подразделение.ОсновнойОфис;
		Изделие = Справочники.Изделия.Детали;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("День", ДатаМонтажа);
	Запрос.УстановитьПараметр("Монтажник", Монтажник);
	
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
		Пока Выборка.Следующий() Цикл
			ТекстСообщения = Строка(Выборка.Монтажник) + " уже занят " + Строка(Формат(Выборка.День, "ДЛФ=ДД"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.Монтажник");
			Возврат;
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ СтатусВышеРазмещен() Тогда
		Отказ = Истина;
		ТекстСообщения = "Проведение разрешено только для размещенных документов";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Движения.Записать();
	
	Если Изделие = Справочники.Изделия.ДопСоглашение Тогда
		Если НЕ ЗначениеЗаполнено(ДокументОснование) ИЛИ ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ДополнительноеСоглашение") Тогда
			Отказ = Истина;
			ТекстСообщения = "Укажите дополнительное соглашение";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.ДокументОснование");
		КонецЕсли;
	КонецЕсли;
	
	Если Изделие = Справочники.Изделия.Детали Тогда
		
		Отказ = ВзаиморасчетыПроводки();
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
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
	
	Если ЗначениеЗаполнено(Виновный) Тогда
		
		Проводка = Движения.ОшибкиСотрудников.Добавить();
		Проводка.Период = Дата;
		Проводка.Сотрудник = Виновный;
		Проводка.Количество = 1;
		Проводка.Сумма = СуммаДокумента;
		
	КонецЕсли;
	
	ЕстьНарядЗадание = ЗначениеЗаполнено(Документы.Спецификация.ПолучитьНарядЗадание(Ссылка));
	
	Если Быстрый И НЕ ЕстьНарядЗадание Тогда
		МассивСпецификаций = Новый Массив;
		МассивСпецификаций.Добавить(Ссылка);
		ЛексСервер.УвеличитьДополнительныйЛимит(МассивСпецификаций, Движения, Дата, Производство);
	КонецЕсли;
	
	// балы технологов
	КоличествоБалов = Изделие.БалСложности;
	
	Если ЗначениеЗаполнено(Технолог) И КоличествоБалов > 0 Тогда
		
		ДобавитьПоказательСотрудника(Технолог, Перечисления.ВидыПоказателейСотрудников.БаллыТехнологов, КоличествоБалов, Производство);
		ДобавитьПоказательСотрудника(Технолог, Перечисления.ВидыПоказателейСотрудников.СуммаРазмещенныхЗаказов, СуммаДокумента, Производство);
		
	КонецЕсли;
	
	//Движение по регистру РабочиеДниМонтажников
	Если ЗначениеЗаполнено(Монтажник) И ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж Тогда
		
		Проводка = Движения.РабочиеДниМонтажников.Добавить();
		Проводка.День = ДатаМонтажа;
		Проводка.Монтажник = Монтажник;
		Проводка.Спецификация = Ссылка;
		Проводка.Город = Офис.Город;
		
	КонецЕсли;
	
	Движения.РабочиеДниМонтажников.Записывать = Истина;
	Движения.Управленческий.Записывать = Истина;
	Движения.ОшибкиСотрудников.Записывать = Истина;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// { Васильев Александр Леонидович [08.06.2014]
	// Переделать все ошибки на "СообщитьОшибкиПользователю".
	// } Васильев Александр Леонидович [08.06.2014]
	
	Если Дилерский Тогда
		
		// Дату отгрузки для всех проверять надо...
		
		Если Дата > КонецДня(ДатаОтгрузки) Тогда
			
			Отказ = Истина;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Дата отгрузки (%1) не может быть раньше даты размещения (%2)%3Выберите другую дату отгрузки" , Формат(ДатаОтгрузки, "ДЛФ=DD"), Формат(Дата, "ДЛФ=DD"), Символы.ПС);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.ДатаОтгрузки");
			
		КонецЕсли;
		
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Офис"));
		Если ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Для дилеров услуга монтажа не доступна",,"Объект.ПакетУслуг");
		КонецЕсли;
		
	Иначе // не дилерский
		
		// { Васильев Александр Леонидович [07.08.2014]
		// Обождем
		// } Васильев Александр Леонидович [07.08.2014]
		
		//Если ЗначениеЗаполнено(Изделие.УслугаРасчет) Тогда
		//	ПроверяемыеРеквизиты.Добавить("Технолог");
		//КонецЕсли;
		
		Если Контрагент.Дилер Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Запрещено создавать спецификации для дилеров");
		КонецЕсли;
		
		Если Контрагент = Справочники.Контрагенты.ЧастноеЛицо И Изделие = Справочники.Изделия.Детали Тогда
			
			ПроверяемыеРеквизиты.Добавить("Телефон");
			
		КонецЕсли;
		
		Если Изделие = Справочники.Изделия.Переделка Тогда
			
			// только инженер отдела качества может создавать переделки
			
			ПроверяемыеРеквизиты.Добавить("Виновный");
			ПроверяемыеРеквизиты.Добавить("ЗамечанияИнженера");
			
			Если НЕ ЗначениеЗаполнено(ДокументОснование) ИЛИ ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.Спецификация") Тогда
				Отказ = Истина;
				ТекстСообщения = "Укажите спецификацию для которой вводится переделка";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ДокументОснование");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДеньНедели(ДатаОтгрузки) = 7 Тогда
		
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("В воскресенье изделия не отгружаем. Выберите другой день",,"Объект.ДатаОтгрузки");
		
	КонецЕсли;
	
	Если ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж И Изделие = Справочники.Изделия.Детали Тогда
		
		Отказ = Истина;
		ТекстСообщения = "На детали монтаж не устанавливаем";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.ПакетУслуг");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ПользовательАдминистратор = УправлениеДоступомПереопределяемый.ЕстьДоступКПрофилюГруппДоступа(Пользователь, Справочники.ПрофилиГруппДоступа.Администратор);
	
	Если НЕ ПользовательАдминистратор И СтатусВышеРазмещен() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Запрещено отменять проведение документа со статусом выше 'Размещен'");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СписокДверей.Очистить();
	
КонецПроцедуры
