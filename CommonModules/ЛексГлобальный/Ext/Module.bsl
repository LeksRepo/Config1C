﻿
Процедура ОповещениеСлужебныхЗаписок() Экспорт
		
	Данные = ПолучитьДанныеОповещений();
	
	Если ЗначениеЗаполнено(Данные) Тогда
		ОткрытьФорму("ОбщаяФорма.ФормаНеОзнакомленныхСлужебок", Данные);	
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьДанныеОповещений() Экспорт
	
	Данные = Новый Структура;
	
	МассивСлужебок = ЛексСервер.ПолучитьСписокНеОзнакомленныхСлужебок();
	ЕстьСлужебки = МассивСлужебок.Количество() > 0;
	
	ЭтоДилер = ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя();
	ЕстьПеределки = Ложь;
	ЕстьОбращения = Ложь;
	
	Если НЕ ЭтоДилер Тогда
		
		МассивОбращений = ЛексСервер.ПолучитьСписокАктивныхОбращений();
		ЕстьОбращения = МассивОбращений.Количество() > 0;
		
		МассивПеределок = ЛексСервер.ПолучитьНомераПередлокИСрочек(ПользователиКлиентСервер.АвторизованныйПользователь());
		ЕстьПеределки = МассивПеределок.Количество() > 0;
		
	КонецЕсли;
	
	Если ЕстьСлужебки ИЛИ ЕстьПеределки ИЛИ ЕстьОбращения Тогда
		
		Если ЕстьСлужебки Тогда
			Данные.Вставить("МассивСлужебок", МассивСлужебок);
		КонецЕсли;
		
		Если ЕстьПеределки Тогда
			Данные.Вставить("МассивПеределокИСрочек", МассивПеределок);
		КонецЕсли;
		
		Если ЕстьОбращения Тогда
			Данные.Вставить("МассивОбращений", МассивОбращений);
		КонецЕсли;
		
	Иначе
		Данные = Неопределено;
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

