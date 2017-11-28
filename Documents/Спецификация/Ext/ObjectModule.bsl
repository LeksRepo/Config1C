﻿
#Область Общего_назначения

Функция СтатусВышеРассчитывается(СпецификацияСсылка)
	
	Результат = Ложь;
	
	Если НЕ ЗначениеЗаполнено(СпецификацияСсылка) Тогда
		Возврат Результат;
	КонецЕсли;
	
	СтатусыДляПроведения = Новый Массив;
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Изготовлен);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Рассчитывается);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Отгружен);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.ПереданВЦех);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Размещен);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Установлен);
	СтатусыДляПроведения.Добавить(Перечисления.СтатусыСпецификации.Проверяется);
	
	СтатусСпецификации = Документы.Спецификация.ПолучитьСтатусСпецификации(СпецификацияСсылка);
	
	Для каждого Строка Из СтатусыДляПроведения Цикл
		Если СтатусСпецификации = Строка Тогда
			Результат = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция БольшоеИзделие()
	
	БольшоеИзделие = Ложь;
	
	КоличествоМетров = ЛексСервер.ПолучитьНастройкуПодразделения(Подразделение, Перечисления.ВидыНастроекПодразделений.БольшойШкаф, Дата);
	
	Если ЗначениеЗаполнено(КоличествоМетров) Тогда
		
		БольшоеИзделие = ПлощадьСборкиИзделия > КоличествоМетров;
		
	КонецЕсли;
	
	Возврат БольшоеИзделие;
	
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
	
	Перем Ошибки;
	
	Если НЕ Дилерский
		И НЕ ЗначениеЗаполнено(Офис)
		И НЕ (Изделие = Справочники.Изделия.Переделка
		ИЛИ Изделие = Справочники.Изделия.ГарантийноеОбслуживание) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Офис", "Заполните поле ""Офис""");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		ДатаСоздания = ТекущаяДата();
	КонецЕсли;
	
	Если ПакетУслуг = Перечисления.ПакетыУслуг.ДоставкаДоОфиса Тогда
		АдресМонтажа = Офис.Адрес;
	КонецЕсли;
	
	Если НЕ Проведен Тогда
		Срочный = ОпределитьСрочностьСпецификации();
		Если Срочный Тогда
			ДобавитьУслугуСрочность();
		КонецЕсли;
	КонецЕсли;
	
	//////////////////////////////////////////////////////////
	//ПРЕВЫШЕНИЕ ЛИМИТА
	
	Если НЕ Проведен И НЕ ПометкаУдаления
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
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СуммаНарядаСпецификации = Документы.Спецификация.ПолучитьЗарплатуЦеха(СписокНоменклатуры.Выгрузить());
	
	ЗаполнитьЗабалансовуюСтоимость();
	
	Если Дата >'2016.11.19' Тогда
		СуммаДокумента = Окр(СписокНоменклатуры.Итог("РозничнаяСтоимость") + 0.499);
		СуммаДокументаБезНаценкиОфиса = СписокНоменклатуры.Итог("СуммаБезНаценкиОфиса");
	КонецЕсли;
	
	Если СписокВиновных.Количество() = 1 Тогда
		
		Строка = СписокВиновных[0];
		Строка.Сумма = СуммаДокумента;
		
	КонецЕсли;
	
	УстановитьКоличествоКомплектации();
	
	Если Изделие = Справочники.Изделия.Переделка
		И ЗначениеЗаполнено(ДокументОснование)
		И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.Спецификация") Тогда
		АдресМонтажа = ДокументОснование.АдресМонтажа;
	КонецЕсли;
	
	Организация = Подразделение.ОрганизацияДляФизЛиц;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Документы.Спецификация.ПолучитьСтатусСпецификации(Ссылка)) Тогда
		
		Документы.Спецификация.УстановитьСтатусСпецификации(Ссылка, Перечисления.СтатусыСпецификации.Сохранен);
		
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
		
	КонецЕсли;
	
	Дилерский = РольДоступна("ДилерскийДоступКСпецификации");
	
	Если Дилерский И ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		Контрагент = ПараметрыСеанса.ТекущийВнешнийПользователь.ОбъектАвторизации;
		Подразделение = Контрагент.Подразделение;
		ПакетУслуг = Перечисления.ПакетыУслуг.СамовывозОтПроизводителя;
		
		Изделие = Справочники.Изделия.Детали;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		Контрагент = Справочники.Контрагенты.ЧастноеЛицо;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Перем Ошибки;
	
	Если НЕ СтатусВышеРассчитывается(Ссылка) Тогда
		ТекстСообщения = "Проведение разрешено только для размещенных спецификаций";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,, ТекстСообщения);
	КонецЕсли;
	
	Если Изделие = Справочники.Изделия.Детали
		ИЛИ (Дилерский И СтатусВышеРассчитывается(Ссылка)) Тогда
		
		ДвиженияВзаиморасчеты(Ошибки);
		
	Иначе
		
		ПроверитьНаличиеДоговора(Ошибки);
		
	КонецЕсли;
	
	ДвиженияМонтажники(Ошибки);
	
	ДвиженияОбрезки(Ошибки);
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если НЕ Отказ Тогда
		
		ДвиженияЦеховойЛимит();
		ДвиженияРеализованныеИзделияПоКаталогу();
		ДвиженияПеределка();
		ДвиженияПродажиФакт();
		
		Движения.ЦеховойЛимит.Записывать = Истина;
		Движения.РабочиеДниМонтажников.Записывать = Истина;
		Движения.Управленческий.Записывать = Истина;
		Движения.ОшибкиСотрудников.Записывать = Истина;
		Движения.РеализованныеИзделияПоКаталогу.Записывать = Истина;
		Движения.ПродажиФакт.Записывать = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьСлужебнуюЗаписку(Ошибки)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Документ", Ссылка);
	
	Запрос.Текст=
	"ВЫБРАТЬ
	|	СлужебнаяЗаписка.Ссылка
	|ИЗ
	|	Документ.СлужебнаяЗаписка КАК СлужебнаяЗаписка
	|ГДЕ
	|	СлужебнаяЗаписка.Документ = &Документ
	|	И СлужебнаяЗаписка.Проведен";
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		ТекстСообщения = "Гарантийное обслуживание оформляется на основании проведенной служебной записки.";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект", ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Ошибки;
	
	Если Дата > '2016.09.05'
		И Контрагент = Справочники.Контрагенты.ЧастноеЛицо Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Контрагент", "Заполните поле ""Заказчик""");
	КонецЕсли;
	
	Если Дилерский Тогда
		
		// Дату отгрузки для всех проверять надо...
		
		Если Дата > КонецДня(ДатаОтгрузки) Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Дата отгрузки (%1) не может быть раньше даты размещения (%2)%3Выберите другую дату отгрузки" , Формат(ДатаОтгрузки, "ДЛФ=DD"), Формат(Дата, "ДЛФ=DD"), Символы.ПС);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДатаОтгрузки", ТекстСообщения);
			
		КонецЕсли;
		
	Иначе // не дилерский
		
		Если Изделие = Справочники.Изделия.ДопСоглашение Тогда
			Если НЕ ЗначениеЗаполнено(ДокументОснование)
				ИЛИ ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ДополнительноеСоглашение") Тогда
				
				ТекстСообщения = "Укажите дополнительное соглашение";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДокументОснование", ТекстСообщения);
				
			КонецЕсли;
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
	
	Если ПакетУслуг <> Перечисления.ПакетыУслуг.СамовывозОтПроизводителя
		И АдресМонтажа = "Введите адрес" Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.АдресМонтажа", "Не указан адрес");
	КонецЕсли;
	
	Если Изделие = Справочники.Изделия.ГарантийноеОбслуживание Тогда
		
		ПроверитьСлужебнуюЗаписку(Ошибки);
		
		Если ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.Договор") Тогда
			
			ТекстСообщения = "Гарантийное обслуживание выполняется на основании договора.";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДокументОснование", ТекстСообщения);
			
		КонецЕсли;
		
	ИначеЕсли Изделие = Справочники.Изделия.Переделка Тогда
		
		СуммаУдержания = СписокВиновных.Итог("Сумма");
		
		Если (СуммаУдержания <> СуммаДокумента) Тогда
			ТекстСообщения = "Сумма удержания (%1) не совпадает с суммой документа (%2)";
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СуммаУдержания, СуммаДокумента);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.СписокВиновных", ТекстСообщения);
		КонецЕсли;
		
	ИначеЕсли Изделие = Справочники.Изделия.ДопСоглашение
		И ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ДополнительноеСоглашение") Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ДокументОснование", "Укажите доп. соглашение");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументОснование)
		И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ДополнительноеСоглашение")
		И НЕ Изделие = Справочники.Изделия.ДопСоглашение Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Изделие", 
		"На основании доп. соглашения изделие должно быть 'Доп. соглашение'");
		
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
	
	//RonEXI: Проверка комментария к предоставленому материалу
	
	Если СписокМатериаловЗаказчика.Количество() > 0 Тогда
		
		Для Каждого Стр ИЗ СписокМатериаловЗаказчика Цикл
			
			Если Стр.Комментарий = "" Тогда
				
				ТекстСообщения = "Заполните комментарий для материала заказчика.";
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.СписокМатериаловЗаказчика[" + (Стр.НомерСтроки -1) + "].Комментарий", ТекстСообщения);
	
			КонецЕсли;
			
		КонецЦикла;	
		
	КонецЕсли;
	
	ПроверитьДатуОтгрузки(Ошибки);
	ПроверитьЯщики(Ошибки);
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СписокДверей.Очистить();
	Дилерский = РольДоступна("ДилерскийДоступКСпецификации");
	
КонецПроцедуры

#КонецОбласти

#Область Сохранение_документа

Функция УстановитьКоличествоКомплектации()
	
	КомплектацияЦех = 0;
	КомплектацияСклад = 0;
	Для каждого Строка Из СкладГотовойПродукции Цикл
		КомплектацияЦех = КомплектацияЦех + Число(Строка.КоличествоЦех > 0);
		КомплектацияСклад = КомплектацияСклад + Число(Строка.КоличествоСклад > 0);
	КонецЦикла;
	
КонецФункции

Функция ОпределитьСрочностьСпецификации()
	
	ДокументПлановыйЛимит = Документы.ПлановыйЛимит.ПолучитьДокументЗаПериод(Подразделение, ДатаОтгрузки, Истина);
	
	Если НЕ ЗначениеЗаполнено(ДокументПлановыйЛимит) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Срочный = Ложь;
	
	Если Изделие = Справочники.Изделия.Детали
		ИЛИ Дилерский Тогда
		
		ДнейНаИзготовление = 2 + ?(Изделие.ДнейНаИзготовление > ДнейНаИзготовлениеПоНоменклатуре, Изделие.ДнейНаИзготовление - 1, ДнейНаИзготовлениеПоНоменклатуре);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДатаДокумента", Дата);
		Запрос.УстановитьПараметр("ДатаОтгрузки", ДатаОтгрузки);
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
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
	
	НомСрочность = ЛексСерверПовтИсп.ПолучитьОбщуюНоменклатуру(Справочники.ОбщаяНоменклатура.СрочностьЗаказа, Подразделение);
	
	Строка = СписокНоменклатуры.Найти(НомСрочность);
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
		Строка.Номенклатура = НомСрочность;
		Строка.Количество = 1;
		
		Если ДатаИзготовления > Дата("20160801000000") Тогда
			Строка.ЗарплатаЦеха = 0;
		Иначе
			Строка.ЗарплатаЦеха = Структура.ЗарплатаЦеха;
		КонецЕсли;
		
		Строка.РозничнаяСтоимость = Структура.РозничнаяСтоимость * КоэффициентЗаСрочность;
		Строка.Цена = Структура.РозничнаяСтоимость * КоэффициентЗаСрочность;
		Строка.ЧерезСклад = Ложь;
		
	КонецЕсли;
	
КонецФункции

Функция ЗаполнитьЗабалансовуюСтоимость()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("тз", СписокНоменклатуры);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(тз.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	тз.РозничнаяСтоимость КАК Сумма
	|ПОМЕСТИТЬ втТЗ
	|ИЗ
	|	&тз КАК тз
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втТЗ.Номенклатура,
	|	втТЗ.Сумма КАК Сумма
	|ИЗ
	|	втТЗ КАК втТЗ
	|ГДЕ
	|	НЕ втТЗ.Номенклатура.НеХранитсяНаСкладе
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	ОБЩИЕ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Выборка.Следующий();
	
	ЗабалансоваяСтоимость = Выборка.Сумма;
	
	Если Дилерский Тогда
		
		НаценкаДилера = ПолучитьНаценкуДилера();
		
		Если ЗначениеЗаполнено(НаценкаДилера) И ЗначениеЗаполнено(Выборка.Сумма) Тогда
			
			ЗабалансоваяСтоимость = Выборка.Сумма / НаценкаДилера;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗабалансоваяСтоимость = Окр(ЗабалансоваяСтоимость + 0.499);
	
КонецФункции

Функция ПолучитьНаценкуДилера()
	
	Результат = 0;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПараметрыДилеровСрезПоследних.Наценка
	|ИЗ
	|	РегистрСведений.ПараметрыДилеров.СрезПоследних(&МоментВремени, Контрагент = &Контрагент) КАК ПараметрыДилеровСрезПоследних
	|ГДЕ
	|	ПараметрыДилеровСрезПоследних.Контрагент = &Контрагент";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Результат = Выборка.Наценка;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПроверкиПередСохранением

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
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
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

Функция МонтажникСвободен(Дата1, Дата2, Ошибки);
	
	Результат = Истина;
	
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
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			фДата = Формат(Выборка.День, "ДЛФ=ДД");
			
			Если ЗначениеЗаполнено(Дата2) Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("На установку изделия требуется 2 дня, монтажник %1 уже занят %2", Выборка.Монтажник, фДата);
			Иначе
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 уже занят %2", Выборка.Монтажник, фДата);
			КонецЕсли;
			
		КонецЦикла;
		
		//Ошибки
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Монтажник");
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

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

#КонецОбласти

#Область Движения

Функция ДвиженияВзаиморасчеты(Ошибки)
	
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

Функция ДвиженияЦеховойЛимит()
	
	Запись = Движения.ЦеховойЛимит.Добавить();
	Запись.Период = НачалоДня(ДатаИзготовления);
	Запись.Подразделение = Подразделение;
	Запись.СтоимостьУслугФакт = СуммаНарядаСпецификации;
	Запись.КоличествоКоробовФакт = КоличествоКоробов;
	
КонецФункции

Функция ДвиженияРеализованныеИзделияПоКаталогу()
	
	Если СписокИзделийПоКаталогу.Количество() > 0 Тогда
		Для Каждого СтрокаСпискаИзделий Из СписокИзделийПоКаталогу Цикл
			Проводка = Движения.РеализованныеИзделияПоКаталогу.Добавить();
			Проводка.Период = Дата;
			Проводка.ИзделиеПоКаталогу = СтрокаСпискаИзделий.Изделие;
			Проводка.Количество = 1;
		КонецЦикла;
	КонецЕсли;
	
КонецФункции

Функция ДвиженияМонтажники(Ошибки)
	
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
		
		Если МонтажникСвободен(ДатаМонтажа, ДатаМонтажаВторойДень, Ошибки) Тогда
			
			ЗанятьМонтажника(ДатаМонтажа);
			
			Если ЗначениеЗаполнено(ДатаМонтажаВторойДень) Тогда
				
				ЗанятьМонтажника(ДатаМонтажаВторойДень);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

Функция ДвиженияПеределка()
	
	Если Изделие = Справочники.Изделия.Переделка Тогда
		
		Содержание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Удержание за переделку %1", Ссылка);
		
		ПВХФизическиеЛица = ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица;
		ПВХВидыНачисленийУдержаний = ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний;
		ПВХСтатьиДР = ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР;
		ПВХВидыПоказателейСотрудников = ПланыВидовХарактеристик.ВидыСубконто.ВидыПоказателейСотрудников;
		УдержанияЗаПеределки = Справочники.ВидыНачисленийУдержаний.УдержанияЗаПеределки;
		ДоходыЗаПеределкиИУдержанияОтСотрудников = Справочники.СтатьиДоходовРасходов.ДоходыЗаПеределкиИУдержанияОтСотрудников;
		УщербОтПеределок = Перечисления.ВидыПоказателейСотрудников.УщербОтПеределок;
		
		Для Каждого Строка Из СписокВиновных Цикл
			
			Проводка = Движения.Управленческий.Добавить();
			Проводка.Период = Дата;
			Проводка.Подразделение = Подразделение;
			Проводка.Содержание = Содержание;
			
			Проводка.Сумма = Строка.Сумма;
			
			Проводка.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
			Проводка.СубконтоДт[ПВХФизическиеЛица] = Строка.Виновный;
			Проводка.СубконтоДт[ПВХВидыНачисленийУдержаний] = УдержанияЗаПеределки;
			
			Проводка.СчетКт = ПланыСчетов.Управленческий.Доходы;
			Проводка.СубконтоКт[ПВХСтатьиДР] = ДоходыЗаПеределкиИУдержанияОтСотрудников;
			
			Проводка = Движения.Управленческий.Добавить();
			Проводка.Период = Дата;
			Проводка.Подразделение = Подразделение;
			Проводка.Содержание = Содержание;
			
			Проводка.Сумма = Строка.Сумма;
			
			Проводка.СчетДт = ПланыСчетов.Управленческий.ПоказателиСотрудника;
			Проводка.СубконтоДт[ПВХФизическиеЛица] = Строка.Виновный;
			Проводка.СубконтоДт[ПВХВидыПоказателейСотрудников] = УщербОтПеределок;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции

Функция ДвиженияПродажиФакт()
	
	Перем Сотрудник, ВидПродажи;
	
	Если ЗначениеЗаполнено(Документы.Спецификация.ПолучитьДоговор(Ссылка))
		ИЛИ Изделие = Справочники.Изделия.Переделка
		ИЛИ Изделие = Справочники.Изделия.ДопСоглашение
		ИЛИ Изделие = Справочники.Изделия.ГарантийноеОбслуживание
		ИЛИ Изделие.Серийное Тогда
		
		Возврат 0;
	КонецЕсли;
	
	Если Дилерский Тогда
		Сотрудник = Контрагент.Супервайзер;
		ВидПродажи = Перечисления.ВидыПродаж.Дилеры;
	Иначе
		Сотрудник = Автор.ФизическоеЛицо;
		ВидПродажи = Перечисления.ВидыПродаж.Детали;
	КонецЕсли;
	
	Проводка = Движения.ПродажиФакт.Добавить();
	
	Проводка.Период = Дата;
	Проводка.Подразделение = Подразделение;
	Проводка.ВидПродажи = ВидПродажи;
	Проводка.Сотрудник = Сотрудник;
	Проводка.Контрагент = Контрагент;
	Проводка.Офис = Офис;
	Проводка.Количество = 1;
	Проводка.Сумма = СуммаДокумента;
	
КонецФункции

Процедура ДвиженияОбрезки(Ошибки)
	
	Движения.ОбрезкиМатериалов.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбрезкиЛистовогоМатериала.Номенклатура,
	|	ОбрезкиЛистовогоМатериала.ШиринаОстатка КАК Ширина,
	|	ОбрезкиЛистовогоМатериала.ВысотаОстатка КАК Высота,
	|	&Подразделение КАК Подразделение,
	|	ОбрезкиЛистовогоМатериала.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ втНоменклатура
	|ИЗ
	|	Документ.Спецификация.ОбрезкиЛистовогоМатериала КАК ОбрезкиЛистовогоМатериала
	|ГДЕ
	|	ОбрезкиЛистовогоМатериала.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНоменклатура.Номенклатура,
	|	втНоменклатура.Ширина,
	|	втНоменклатура.Высота,
	|	втНоменклатура.НомерСтроки
	|ИЗ
	|	втНоменклатура КАК втНоменклатура";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Запись = Движения.ОбрезкиМатериалов.ДобавитьРасход();
		Запись.Период = Дата;
		Запись.Подразделение = Подразделение;
		Запись.Номенклатура = Выборка.Номенклатура;
		Запись.Ширина = Выборка.Ширина;
		Запись.Высота = Выборка.Высота;
		Запись.Количество = 1;
		
		Запись = Движения.ОбрезкиМатериалов.ДобавитьПриход();
		Запись.Период = Дата;
		Запись.Подразделение = Подразделение;
		Запись.Номенклатура = Выборка.Номенклатура;
		Запись.Ширина = Выборка.Ширина;
		Запись.Высота = Выборка.Высота;
		Запись.КоличествоРезерв = 1;
		Запись.Спецификация = Ссылка;
		
	КонецЦикла;
	
	Движения.Записать();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	втНоменклатура.Номенклатура,
	|	МИНИМУМ(втНоменклатура.НомерСтроки) КАК НомерСтроки,
	|	втНоменклатура.Ширина,
	|	втНоменклатура.Высота,
	|	втНоменклатура.Подразделение
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	втНоменклатура КАК втНоменклатура
	|
	|СГРУППИРОВАТЬ ПО
	|	втНоменклатура.Номенклатура,
	|	втНоменклатура.Подразделение,
	|	втНоменклатура.Высота,
	|	втНоменклатура.Ширина
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНоменклатура.Номенклатура,
	|	втНоменклатура.НомерСтроки,
	|	-ОбрезкиМатериаловОстатки.КоличествоОстаток КАК Нехватка,
	|	втНоменклатура.Ширина,
	|	втНоменклатура.Высота
	|ИЗ
	|	ВТ КАК втНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОбрезкиМатериалов.Остатки(, ) КАК ОбрезкиМатериаловОстатки
	|		ПО втНоменклатура.Номенклатура = ОбрезкиМатериаловОстатки.Номенклатура
	|			И втНоменклатура.Ширина = ОбрезкиМатериаловОстатки.Ширина
	|			И втНоменклатура.Высота = ОбрезкиМатериаловОстатки.Высота
	|			И втНоменклатура.Подразделение = ОбрезкиМатериаловОстатки.Подразделение
	|ГДЕ
	|	ОбрезкиМатериаловОстатки.КоличествоОстаток < 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		ШаблонСтроки = "%1 (%2х%3) недостаточно %4 шт.";
		ИмяПоляОшибки = "Объект.ОбрезкиЛистовогоМатериала[%1].Номенклатура";
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Движения.ОбрезкиМатериалов.Записывать = Ложь;
			
			СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСтроки,
			Выборка.Номенклатура,
			Выборка.Ширина,
			Выборка.Высота,
			Выборка.Нехватка);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, ИмяПоляОШибки, СтрокаОшибки,, Выборка.НомерСтроки - 1);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
