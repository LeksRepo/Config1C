﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Управленческий.Очистить();
	Движения.Управленческий.Записать();
	
	Ошибки = Неопределено;
	
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	БухгалтерскийУчетПроведениеСервер.СписатьСоСкладаГотовойПродукции(МассивСпецификаций, МоментВремени(), Подразделение, Движения, Ошибки);
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если НЕ Отказ Тогда
		
		Движения.Управленческий.Записывать = Истина;
		ЛексСервер.ГрупповаяСменаСтатуса(МассивСпецификаций, Перечисления.СтатусыСпецификации.Отгружен, Перечисления.СтатусыСпецификации.Изготовлен);
		БухгалтерскийУчетПроведениеСервер.СформироватьПрибыльПоСпецификациям(МассивСпецификаций, Движения, Дата);
		// Костыль. Удалить после свертки базы.
		ЗакрытьДопСоглашения(МассивСпецификаций);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ЗакрытьДопСоглашения(МассивСпецификаций)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДополнительноеСоглашение.Ссылка,
	|	ДополнительноеСоглашение.Договор.Спецификация КАК Спецификация
	|ИЗ
	|	Документ.ДополнительноеСоглашение КАК ДополнительноеСоглашение
	|ГДЕ
	|	ДополнительноеСоглашение.Проведен
	|	И ДополнительноеСоглашение.Договор.Дата < ДАТАВРЕМЯ(2017, 7, 1)
	|	И ДополнительноеСоглашение.Договор.Спецификация В(&МассивСпецификаций)";
	
	РезультатЗапроса = Запрос.Выполнить();
	МассивСпецификацийСДопСоглашениями = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Спецификация");
	
	БухгалтерскийУчетПроведениеСервер.ЗакрытьДопСоглашенияДоговора(МассивСпецификацийСДопСоглашениями, Движения, Дата);
	
КонецФункции

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Изменение статуса спецификаций
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	ЛексСервер.ГрупповаяСменаСтатуса(МассивСпецификаций, Перечисления.СтатусыСпецификации.Изготовлен, Перечисления.СтатусыСпецификации.Отгружен);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВыпускПродукции") Тогда
		
		СписокСпецификаций.Загрузить(ЛексСервер.ПолучитьСпецификацииПоСтатусу(Подразделение, Перечисления.СтатусыСпецификации.Изготовлен));
		Подразделение = ДанныеЗаполнения.Подразделение;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	Ошибки = Неопределено;
	МассивСпецификаций = СписокСпецификаций.ВыгрузитьКолонку("Спецификация");
	
	// проверка повторного ввода спецификаций
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияГотовойПродукцииСписокСпецификаций.Ссылка КАК РеализацияГотовойПродукции,
	|	РеализацияГотовойПродукцииСписокСпецификаций.Спецификация КАК Спецификация
	|ИЗ
	|	Документ.РеализацияГотовойПродукции.СписокСпецификаций КАК РеализацияГотовойПродукцииСписокСпецификаций
	|ГДЕ
	|	РеализацияГотовойПродукцииСписокСпецификаций.Спецификация В(&МассивСпецификаций)
	|	И РеализацияГотовойПродукцииСписокСпецификаций.Ссылка <> &Ссылка";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 уже отгружена документом %2",
		Выборка.Спецификация,
		Выборка.РеализацияГотовойПродукции);
		Поле = "";//Объект.СписокНоменклатуры[" +Строка(СтрокаНехватки.НомерСтроки-1) + "].Отпущено";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстСообщения);
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если НЕ Отказ Тогда
		
		// { Васильев Александр Леонидович [15.05.2015]
		// На случай, если какие-то строки были удалены
		// и документ заново проводится.
		// } Васильев Александр Леонидович [15.05.2015]
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("МассивСпецификаций", МассивСпецификаций);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РеализацияГотовойПродукцииСписокСпецификаций.Спецификация
		|ИЗ
		|	Документ.РеализацияГотовойПродукции.СписокСпецификаций КАК РеализацияГотовойПродукцииСписокСпецификаций
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
		|		ПО РеализацияГотовойПродукцииСписокСпецификаций.Спецификация = СтатусСпецификацииСрезПоследних.Спецификация
		|ГДЕ
		|	НЕ РеализацияГотовойПродукцииСписокСпецификаций.Спецификация В (&МассивСпецификаций)
		|	И РеализацияГотовойПродукцииСписокСпецификаций.Ссылка = &Ссылка
		|	И СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Отгружен)";
		
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			
			Спец = Результат.Выгрузить().ВыгрузитьКолонку("Спецификация");
			ЛексСервер.ГрупповаяСменаСтатуса(Спец, Перечисления.СтатусыСпецификации.Изготовлен, Перечисления.СтатусыСпецификации.Отгружен);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция СоздатьПроводку(фПодразделение, фСумма)
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = Дата;
	Проводка.Подразделение = фПодразделение;
	Проводка.Сумма = фСумма;
	
	Возврат Проводка;
	
КонецФункции
