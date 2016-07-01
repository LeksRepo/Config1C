﻿
Процедура ПередЗаписью(Отказ)
	
	Если ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Услуга Тогда
		// { Васильев Александр Леонидович [02.07.2015]
		// Базовый = ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Услуга
		// Так делать нельзя, ибо не услуги бывают базовыми, а бывают нет. :)
		// } Васильев Александр Леонидович [02.07.2015]
		Базовый = Истина;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа И Базовый Тогда
		КоэффициентБазовых = 1;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		ЕстьОписаниеСостава = ОписаниеСостава.Количество() > 0;
	КонецЕсли;
	
	ПодпискиНаСобытия.ПередЗаписьюДокументаИлиСправочника(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Ошибки = Неопределено;
	
	Если ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Материал И НЕ Базовый И БазоваяНоменклатура.Пустая() Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "БазоваяНоменклатура", "Заполните базовую номенклатуру");
		
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		
		Если НЕ Базовый И НЕ БазоваяНоменклатура.Базовый Тогда
			
			ТекстОшибки = "Номенклатура '%1' не является базовой";
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, БазоваяНоменклатура);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, ЭтотОбъект, ТекстОшибки);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НоменклатурнаяГруппа)
			И (НоменклатурнаяГруппа.ПринадлежитЭлементу(Справочники.НоменклатурныеГруппы.Кромка)
			ИЛИ НоменклатурнаяГруппа.ПринадлежитЭлементу(Справочники.НоменклатурныеГруппы.Кант)) Тогда
			
			// { Васильев Александр Леонидович [16.12.2015]
			// Жалуюстся на проверку префикса, отключаем.
			//ПроверитьПрефиксКраткогоНаименования(Ошибки);
			// } Васильев Александр Леонидович [16.12.2015]
			
		КонецЕсли;
		
		Если НоменклатурнаяГруппа.ВидМатериала = Перечисления.ВидыМатериалов.Хлыстовой
			И НЕ ЗначениеЗаполнено(Кратность)
			И НЕ ЗначениеЗаполнено(ПроцентОтхода) Тогда
			
			ТекстОшибки = "Для хлыстового материала укажите 'Кратность' или 'Процент отхода'";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Кратность", ТекстОшибки);
			
		КонецЕсли;
		
		Если НоменклатурнаяГруппа.ВидМатериала <> Перечисления.ВидыМатериалов.Штучный 
			И Кратность > 0
			И ДлинаДетали % (Кратность * 1000) > 0 Тогда
			
			ТекстОшибки = "Деталь не делится ровно на 'Кратность', остаток от деления: " + ДлинаДетали % (Кратность * 1000);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Кратность", ТекстОшибки);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Функция ПроверитьПрефиксКраткогоНаименования(Ошибки)
	
	Если НоменклатурнаяГруппа.ПринадлежитЭлементу(Справочники.НоменклатурныеГруппы.Кромка)
		ИЛИ НоменклатурнаяГруппа.ПринадлежитЭлементу(Справочники.НоменклатурныеГруппы.Кант) Тогда
		
		СтруктураКромок = Новый Структура;
		СтруктураКромок.Вставить("КантАлюминиевый", "AL-");
		СтруктураКромок.Вставить("КантП", "P-");
		СтруктураКромок.Вставить("КантТ", "Т-");
		СтруктураКромок.Вставить("Кромка045_19", "V-");
		СтруктураКромок.Вставить("Кромка2_19", "W-");
		СтруктураКромок.Вставить("Кромка2_35", "Z-");
		СтруктураКромок.Вставить("КромкаМДФ", "ABS-");
		СтруктураКромок.Вставить("Кромка2_42", "Q-");
		СтруктураКромок.Вставить("Кромка2_45", "F-");
		
		ИмяГруппы = Справочники.НоменклатурныеГруппы.ПолучитьИмяПредопределенного(НоменклатурнаяГруппа);
		ПрефиксПлан = СтруктураКромок[ИмяГруппы];
		ДлинаПрефикса = СтрДлина(ПрефиксПлан);
		ПрефиксФакт = Лев(КраткоеНаименование, ДлинаПрефикса);
		
		Если ПрефиксПлан <> ПрефиксФакт Тогда
			
			ТекстСообщения = "Краткое наименование у '%1' должно начинаться с '%2'";
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НоменклатурнаяГруппа, ПрефиксПлан);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.КраткоеНаименование", ТекстСообщения);
			
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Процедура ПриЗаписи(Отказ)
	
	Заглушка = Истина;
	
	//Если НЕ ЭтоГруппа
	//	И (ВидНоменклатуры <> Перечисления.ВидыНоменклатуры.Услуга
	//	ИЛИ НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.Гравировка)
	//	И Базовый Тогда
	//	
	//	УстановитьПривилегированныйРежим(Истина);
	//	
	//	Запрос = Новый Запрос;
	//	Запрос.Текст =
	//	"ВЫБРАТЬ
	//	|	Подразделения.Ссылка
	//	|ИЗ
	//	|	Справочник.Подразделения КАК Подразделения
	//	|ГДЕ
	//	|	Подразделения.ВидПодразделения = ЗНАЧЕНИЕ(Перечисление.ВидыПодразделений.Производство)
	//	|	И Подразделения.Активность";
	//	
	//	Выборка = Запрос.Выполнить().Выбрать();
	//	
	//	Пока Выборка.Следующий() Цикл
	//		
	//		НаборЗаписей = РегистрыСведений.НоменклатураПодразделений.СоздатьНаборЗаписей();
	//		НаборЗаписей.Отбор.Подразделение.Установить(Выборка.Ссылка);
	//		НаборЗаписей.Отбор.Номенклатура.Установить(Ссылка);
	//		НаборЗаписей.Прочитать();
	//		
	//		Если НаборЗаписей.Количество() = 0 Тогда
	//			
	//			НоваяСтрока = НаборЗаписей.Добавить();
	//			НоваяСтрока.Номенклатура = Ссылка;
	//			НоваяСтрока.Подразделение = Выборка.Ссылка;
	//			НоваяСтрока.ПодЗаказ = Истина;
	//			НоваяСтрока.ОкруглятьДоЛистов = Истина;
	//			
	//			НаборЗаписей.Записать(Ложь);
	//			
	//		КонецЕсли;
	//		
	//	КонецЦикла;
	//	
	//КонецЕсли;
	
КонецПроцедуры
