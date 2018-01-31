﻿
//////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ДоговорДилера") Тогда		
		Договор = ДанныеЗаполнения.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Ошибки = Неопределено;
	МассивСпецификаций = Новый Массив;
	МассивСпецификаций.Добавить(Договор.Спецификация);
		
	Если ЗначениеЗаполнено(ДатаПередачи) Тогда
		
		БухгалтерскийУчетПроведениеСервер.СформироватьПоказателиМонтажникаИлиВодителя(МассивСпецификаций, Движения, ДатаПередачи);
		
	КонецЕсли;
	
	Движения.Управленческий.Записывать = Истина;
	ЛексСервер.ГрупповаяСменаСтатуса(МассивСпецификаций, Перечисления.СтатусыСпецификации.Установлен, Перечисления.СтатусыСпецификации.Отгружен);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ Договор.Проведен Тогда
		
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
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	АктВыполнения= Документы.ДоговорДилера.ПолучитьАктВыполнения(Договор);
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
