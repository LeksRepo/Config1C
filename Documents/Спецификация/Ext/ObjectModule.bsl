﻿
#Область Общего_назначения

Функция ПроверитьНаличиеДоговора(Ошибки)
	
	Если Изделие = Справочники.Изделия.Переделка
		ИЛИ Изделие =Справочники.Изделия.ДопСоглашение
		ИЛИ Изделие = Справочники.Изделия.ГарантийноеОбслуживание
		ИЛИ Изделие.Серийное Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Договор = Документы.Спецификация.ПолучитьДоговор(Ссылка);
	
	Если НЕ Договор.Проведен Тогда
		
		ТекстСообщения = "Размещение изделия '" + Изделие + "' разрешено только с проведеным договором";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Изделие", ТекстСообщения);
		
	КонецЕсли;
	
КонецФункции

Функция ОпределитьСрочностьСпецификации()
	
	ДокументПлановыйЛимит = Документы.ПлановыйЛимит.ПолучитьДокументЗаПериод(Подразделение, ДатаОтгрузки, Истина);
	
	Если НЕ ЗначениеЗаполнено(ДокументПлановыйЛимит) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Срочный = Ложь;
	
	Если Изделие = Справочники.Изделия.Детали
		ИЛИ Дилерский Тогда
		
		ДнейНаИзготовление = 2 + ДваДняИзготовление;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДатаДокумента", Дата);
		Запрос.УстановитьПараметр("ДатаОтгрузки", ДатаОтгрузки);
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЦеховойЛимит.Период КАК Период
		|ИЗ
		|	РегистрНакопления.ЦеховойЛимит КАК ЦеховойЛимит
		|ГДЕ
		|	ЦеховойЛимит.СтоимостьУслуг > 0
		|	И ЦеховойЛимит.Период < &ДатаОтгрузки
		|	И ЦеховойЛимит.Период > &ДатаДокумента
		|	И ЦеховойЛимит.Подразделение = &Подразделение";
		
		РабочихДнейДоОтгрузки = Запрос.Выполнить().Выбрать().Количество();
		
		Если ЗначениеЗаполнено(Подразделение.ВремяПриемаСрочных) И Час(Подразделение.ВремяПриемаСрочных-1) < Час(ТекущаяДата()) Тогда
			РабочихДнейДоОтгрузки = РабочихДнейДоОтгрузки - 1; 	
		КонецЕсли;

		Срочный = РабочихДнейДоОтгрузки < ДнейНаИзготовление;
		
	КонецЕсли;
	
	Возврат Срочный;
	
КонецФункции

Функция ДобавитьУслугуСрочность()
	
	Строка = СписокНоменклатуры.Найти(Справочники.Номенклатура.СрочностьЗаказа);
	Если Строка <> Неопределено Тогда
		
		// Срочность уже заполнена, будем считать что правильная.
		Возврат Истина;
		
	КонецЕсли;
	
	КоэффициентЗаСрочность = Подразделение.КоэффициентЗаСрочность;
	Если КоэффициентЗаСрочность = 0 Тогда
		КоэффициентЗаСрочность = 1;
	КонецЕсли;
	
	Структура = Документы.Спецификация.ПолучитьСтоимостьУслугБезВнешних(СписокНоменклатуры);
	
	Если Структура.РозничнаяСтоимость > 0 Тогда
		Строка = СписокНоменклатуры.Добавить();
		Строка.Номенклатура = Справочники.Номенклатура.СрочностьЗаказа;
		//Строка.ЕдиницаИзмерения = Строка.Номенклатура.ЕдиницаИзмерения;
		Строка.Количество = 1;
		Строка.ЗарплатаЦеха = Структура.ЗарплатаЦеха;
		Строка.РозничнаяСтоимость = Структура.РозничнаяСтоимость * КоэффициентЗаСрочность;
		Строка.Цена = Структура.РозничнаяСтоимость * КоэффициентЗаСрочность;
		Строка.ЧерезСклад = Ложь;
	КонецЕсли;
	
КонецФункции

Функция ВзаиморасчетыПроводки(Ошибки)
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрБухгалтерии.Управленческий");
	ЭлементБлокировки.УстановитьЗначение("Подразделение", Подразделение);
	ЭлементБлокировки.УстановитьЗначение("Счет", ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями);
	ЭлементБлокировки.УстановитьЗначение("Субконто1", Контрагент);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();
	
	Если Дилерский Тогда
		СуммаАванса = ЛексСервер.ПолучитьАвансДилера(Контрагент, Подразделение, МоментВремени());
	Иначе
		СуммаАванса = ЛексСервер.ПолучитьАвансПоДокументу(Контрагент, Подразделение, МоментВремени(), Ссылка);
	КонецЕсли;
	
	Если СуммаАванса < СуммаДокумента Тогда // аванс недостаточен
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		СтрокиСообщений.АвансНедостаточен(),
		СуммаАванса,
		СуммаДокумента);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Контрагент", ТекстСообщения);
		
	Иначе
		
		Если Дилерский Тогда
			
			ЛексСервер.ЗачестьАвансДилера(Движения, Контрагент, Подразделение, Дата, Ссылка, СуммаДокумента);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

Функция СтатусВышеРассчитывается(СпецификацияСсылка)
	
	Результат = Ложь;
	
	СтатусыДляПроведения = Новый Массив;
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Изготовлен);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Рассчитывается);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Отгружен);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.ПереданВЦех);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Размещен);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Установлен);
	
	СтатусСпецификации = Документы.Спецификация.ПолучитьСтатусСпецификации(СпецификацияСсылка);
	
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
		
		ВсегоКоробов = ФактКоробов + КоличествоКоробов;
		
		Если ВсегоКоробов > НормативКоробов Тогда
			
			ПревышениеКоробов = ВсегоКоробов - НормативКоробов; 
			
		КонецЕсли;
		
	КонецЕсли;
	
	Ответ = Новый Структура;
	Ответ.Вставить("ПревышениеНаряда", ПревышениеНаряда);
	Ответ.Вставить("ПревышениеКоробов", ПревышениеКоробов);
	
	Возврат Ответ;
	
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

#КонецОбласти

#Область Обработчики_событий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Если ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоОфиса Тогда
		АдресМонтажа = Офис.Адрес;
	КонецЕсли;
	
	ПодпискиНаСобытия.ПередЗаписьюДокументаИлиСправочника(ЭтотОбъект);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Проведен Тогда
		Срочный = ОпределитьСрочностьСпецификации();
		Если Срочный Тогда
			ДобавитьУслугуСрочность();
		КонецЕсли;
	КонецЕсли;
	
	//////////////////////////////////////////////////////////
	//ПРЕВЫШЕНИЕ ЛИМИТА
	
	Если НЕ Проведен
		И ЗначениеЗаполнено(ДатаИзготовления)
		И (Изделие = Справочники.Изделия.Детали ИЛИ Дилерский) Тогда
		
		ДокументПлановыйЛимит = Документы.ПлановыйЛимит.ПолучитьДокументЗаПериод(Подразделение, ДатаИзготовления, Истина);
		
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
	
	СуммаНарядаСпецификации = Документы.Спецификация.ПолучитьЗарплатуЦеха(СписокНоменклатуры.Выгрузить());
	СуммаДокумента = СписокНоменклатуры.Итог("РозничнаяСтоимость");
	СуммаДокументаБезНаценкиОфиса = СписокНоменклатуры.Итог("СуммаБезНаценкиОфиса");
	
	Если СписокВиновных.Количество() = 1 Тогда
		
		Строка = СписокВиновных[0];
		Строка.Сумма = СуммаДокумента;
		
	КонецЕсли;
	
	КомплектацияЦех = 0;
	КомплектацияСклад = 0;
	Для каждого Строка Из СкладГотовойПродукции Цикл
		КомплектацияЦех = КомплектацияЦех + Число(Строка.КоличествоЦех > 0);
		КомплектацияСклад = КомплектацияСклад + Число(Строка.КоличествоСклад > 0);
	КонецЦикла;
	
	Если Изделие = Справочники.Изделия.Переделка
		И ЗначениеЗаполнено(ДокументОснование) Тогда
		АдресМонтажа = ДокументОснование.АдресМонтажа;
	КонецЕсли;
	
	// { Васильев Александр Леонидович [12.04.2016]
	// Для хранения на счетах Склад готовой продукции,
	// Изделия у клиента.
	
	ЗабалансоваяСтоимость = 0;
	
	Для каждого Строка Из СписокНоменклатуры Цикл
		
		Если Строка.Номенклатура = Справочники.Номенклатура.ТарифЗаСборку
			ИЛИ Строка.Номенклатура = Справочники.Номенклатура.ТарифЗаСборкуКухни
			ИЛИ Строка.Номенклатура = Справочники.Номенклатура.СборкаИзделия Тогда
			Продолжить;
		Иначе
			ЗабалансоваяСтоимость = ЗабалансоваяСтоимость + Строка.РозничнаяСтоимость;
		КонецЕсли;
		
	КонецЦикла;
	
	// } Васильев Александр Леонидович [12.04.2016]
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Документы.Спецификация.ПолучитьСтатусСпецификации(Ссылка)) Тогда
		
		Документы.Спецификация.УстановитьСтатусСпецификации(Ссылка, Перечисления.СтатусыСпецификации.Сохранен);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ДатаСоздания = ТекущаяДата();
	
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
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Отказ = Истина;
		Возврат;	
	КонецЕсли;
	
	Если НЕ СтатусВышеРассчитывается(Ссылка) Тогда
		ТекстСообщения = "Проведение разрешено только для размещенных документов";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,, ТекстСообщения);
	КонецЕсли;
	
	СуммаУдержания = СписокВиновных.Итог("Сумма");
	
	Если (Изделие = Справочники.Изделия.Переделка)
		И (СуммаУдержания <> СуммаДокумента) Тогда
		ТекстСообщения = "Сумма удержания (%1) не совпадает с суммой документа (%2)";
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СуммаУдержания, СуммаДокумента);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.СписокВиновных", ТекстСообщения);
	КонецЕсли;
	
	Если Изделие = Справочники.Изделия.Детали
		ИЛИ (Дилерский И СтатусВышеРассчитывается(Ссылка)) Тогда
		
		ВзаиморасчетыПроводки(Ошибки);
		
	Иначе
		
		ПроверитьНаличиеДоговора(Ошибки);
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
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
	
	//////////////////////////////////////////
	// РАБОЧИЕ ДНИ МОНТАЖНИКОВ
	Если ЗначениеЗаполнено(Монтажник)
		И ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж Тогда
		
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
				
				Проводка = Движения.Управленческий.Добавить();
				Проводка.Период = Дата;
				Проводка.Подразделение = Подразделение;
				Проводка.Содержание = Содержание;
				
				Проводка.Сумма = Строка.Сумма;
				
				Проводка.СчетДт = ПланыСчетов.Управленческий.ПоказателиСотрудника;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Строка.Виновный;
				Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.ВидыПоказателейСотрудников] = Перечисления.ВидыПоказателейСотрудников.УщербОтПеределок;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если НЕ Отказ Тогда
		Движения.РабочиеДниМонтажников.Записывать = Истина;
		Движения.Управленческий.Записывать = Истина;
		Движения.ОшибкиСотрудников.Записывать = Истина;
		Движения.РеализованныеИзделийПоКаталогу.Записывать = Истина;
	КонецЕсли;
	
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
			Если НЕ ЗначениеЗаполнено(ДокументОснование)
				ИЛИ ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ДополнительноеСоглашение") Тогда
				
				ТекстСообщения = "Укажите дополнительное соглашение";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДокументОснование", ТекстСообщения);
				
			КонецЕсли;
		КонецЕсли;
		
		Если Изделие = Справочники.Изделия.Детали И Контрагент = Справочники.Контрагенты.ЧастноеЛицо Тогда
			ПроверяемыеРеквизиты.Добавить("Телефон");
		КонецЕсли;
		
		Если Изделие = Справочники.Изделия.Переделка Тогда
			
			ПроверяемыеРеквизиты.Добавить("СписокВиновных");
			ПроверяемыеРеквизиты.Добавить("ЗамечанияИнженера");
			
			Если НЕ ЗначениеЗаполнено(ДокументОснование)
				ИЛИ ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.Спецификация") Тогда
				ТекстСообщения = "Укажите спецификацию для которой вводится переделка";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДокументОснование", ТекстСообщения);
			КонецЕсли;
			
			Если ПакетУслуг <> Перечисления.ПакетыУслуг.СамовывозОтПроизводителя Тогда
				ТекстСообщения = "Переделки только самовывозом";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ПакетУслуг", ТекстСообщения);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж
		И Изделие = Справочники.Изделия.Детали Тогда
		ТекстСообщения = "На детали монтаж не устанавливаем";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ПакетУслуг", ТекстСообщения);
	КонецЕсли;
	
	//////////////////////////////////////////////////////////
	//ПРОВЕРКА ЛИСТОВОЙ И НЕ БАЗОВОЙ НОМЕНКЛАТУРЫ В КОМПЛЕКТАЦИИ
	
	Для Каждого Строка Из Комплектация Цикл
		
		Номенклатура = Строка.Номенклатура;
		
		Если Номенклатура.НоменклатурнаяГруппа.ВидМатериала = Перечисления.ВидыМатериалов.Листовой Тогда
			ТекстСообщения = "Листовой материал необходимо указывать в закладке 'Детали'";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Комплектация[" + (Строка.НомерСтроки -1) + "].Номенклатура", ТекстСообщения);
		КонецЕсли;
		
		Если НЕ Номенклатура.Базовый Тогда
			ТекстСообщения = "Разрешен ввод только базовой номенклатуры";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Комплектация[" + (Строка.НомерСтроки -1) + "].Номенклатура", ТекстСообщения);
		КонецЕсли;
		
	КонецЦикла;
	
	ПроверитьДатуОтгрузки(Ошибки);
	ПроверитьЯщики(Ошибки);
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Процедура ПроверитьДатуОтгрузки(Ошибки)
	
	Если ДатаОтгрузки < НачалоДня(Дата) Тогда
		ТекстСообщения = "Укажите корректную дату отгузки";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДатаОтгрузки", ТекстСообщения);
	КонецЕсли;
	
	ДокументПлановыйЛимит = Документы.ПлановыйЛимит.ПолучитьДокументЗаПериод(Подразделение, ДатаОтгрузки, Истина);
	
	Если ЗначениеЗаполнено(ДокументПлановыйЛимит) Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДатаОтгрузки", ДатаОтгрузки);
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЦеховойЛимит.Период КАК Период
		|ИЗ
		|	РегистрНакопления.ЦеховойЛимит КАК ЦеховойЛимит
		|ГДЕ
		|	ЦеховойЛимит.СтоимостьУслуг > 0
		|	И ЦеховойЛимит.Период = &ДатаОтгрузки
		|	И ЦеховойЛимит.Подразделение = &Подразделение";
		
		ДатаОтгрузкиРабочийДень = Запрос.Выполнить().Выбрать().Количество();
		
		Если ДатаОтгрузкиРабочийДень = 0 Тогда
			
			ТекстСообщения = "В выходные изделия не отгружаем. Выберите другой день.";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДатаОтгрузки", ТекстСообщения);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЯщики(Ошибки)
	
	Для Каждого Ящик ИЗ СписокЯщики Цикл
		
		Если НЕ ЗначениеЗаполнено(Ящик.НаправляющиеНоменклатура) Тогда
			
			Поле = "Объект.СписокЯщики["+Строка(Ящик.НомерСтроки-1)+"].СхемаЯщика";
			ТекстСообщения = "Направляющие не заполнены. Ящик номер "+Ящик.НомерСтроки;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,Поле, ТекстСообщения);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СписокДверей.Очистить();
	Дилерский = РольДоступна("ДилерскийДоступКСпецификации");
	
КонецПроцедуры

#КонецОбласти
