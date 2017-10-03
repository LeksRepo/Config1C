﻿
//////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Договор") Тогда
		
		Договор = ДанныеЗаполнения.Ссылка;
		Подразделение = ДанныеЗаполнения.Подразделение;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Управленческий.Очистить();
	Движения.Управленческий.Записывать = Истина;
	Движения.Управленческий.Записать();
	
	Ошибки = Неопределено;
	МассивСпецификаций = Новый Массив;
	
	БухгалтерскийУчетПроведениеСервер.СписатьИзделияУКлиента(МассивСпецификаций, МоментВремени(), Договор, Подразделение, Движения, Ошибки);
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	БухгалтерскийУчетПроведениеСервер.СформироватьПрибыльПоСпецификациям(МассивСпецификаций, Движения, Дата, Истина);
	БухгалтерскийУчетПроведениеСервер.ЗакрытьДопСоглашенияДоговора(МассивСпецификаций, Движения, Дата, Истина);
	
	Если ЗначениеЗаполнено(ДатаПередачи) Тогда
		
		БухгалтерскийУчетПроведениеСервер.СформироватьПоказателиМонтажникаИлиВодителя(МассивСпецификаций, Движения, ДатаПередачи);
		
	КонецЕсли;
	
	Движения.Управленческий.Записывать = Истина;
	ЛексСервер.ГрупповаяСменаСтатуса(МассивСпецификаций, Перечисления.СтатусыСпецификации.Установлен, Перечисления.СтатусыСпецификации.Отгружен);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ Договор.Проведен И Договор.Дата > '2015.01.01' Тогда
		
		ТекстСобщения = "Запрещено проводить Акт к непроведенному Договору";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСобщения, ЭтотОбъект, "Договор");
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Если Договор.Дата > Дата Тогда
		
		ТекстСобщения = "Дата Акта должна быть больше даты Договора";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСобщения, ЭтотОбъект, "Дата");
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	АктВыполнения= Документы.Договор.ПолучитьАктВыполнения(Договор);
	ТекущийДоговор = Договор;
	
	Если ЗначениеЗаполнено(АктВыполнения) И Ссылка <> АктВыполнения Тогда
		Отказ = Истина;
		ТекстСообщения = "К " + Ссылка + " уже введен " + АктВыполнения;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, АктВыполнения);
	КонецЕсли;
	
	Если ТекущийДоговор <> Ссылка.Договор Тогда
		Спецификация = Ссылка.Договор.Спецификация;
		Если Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация) = Перечисления.СтатусыСпецификации.Установлен Тогда
			
			Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.Отгружен);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Изменение статуса спецификации
	
	Спецификация = Договор.Спецификация;
	
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

Функция ДобавитьПоказательСотрудника(Физлицо, Показатель, Значение, Подразделение)
	
	Проводка = Движения.Управленческий.Добавить();
	Проводка.Период = ДатаПередачи;
	Проводка.Подразделение = Подразделение;
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
