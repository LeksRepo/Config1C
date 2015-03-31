﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Напоминания пользователя".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Открывает форму текущих напоминаний пользователя при начале работы системы.
//
Процедура ПроверитьТекущиеНапоминанияПриЗапуске() Экспорт

	ПодключитьОбработчикОжидания("ПроверитьТекущиеНапоминания", 60, Истина); // через 60 секунд после запуска клиента
	
КонецПроцедуры

// Открывает форму текущих напоминаний пользователя.
//
Процедура ПроверитьТекущиеНапоминания() Экспорт

	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	ИнтервалПроверкиНапоминаний = ПараметрыРаботыКлиента.НастройкиНапоминаний.ИнтервалПроверкиНапоминаний;
	
	// открываем форму текущих оповещений
	ВремяБлижайшего = Неопределено;
	ИнтервалСледующейПроверки = ИнтервалПроверкиНапоминаний * 60;
	
	Если НапоминанияПользователяКлиент.ПолучитьТекущиеОповещения(ВремяБлижайшего).Количество() > 0 Тогда
		НапоминанияПользователяКлиент.ОткрытьФормуОповещения();
	ИначеЕсли ЗначениеЗаполнено(ВремяБлижайшего) Тогда
		ИнтервалСледующейПроверки = Мин(ВремяБлижайшего - ОбщегоНазначенияКлиент.ДатаСеанса(), ИнтервалСледующейПроверки);
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ПроверитьТекущиеНапоминания", ИнтервалСледующейПроверки, Истина);
	
КонецПроцедуры

// Сбрасывает таймер проверки текущих напоминаний и выполняет проверку немедленно.
Процедура СброситьТаймерПроверкиТекущихОповещений() Экспорт
	ОтключитьОбработчикОжидания("ПроверитьТекущиеНапоминания");
	ПроверитьТекущиеНапоминания();
КонецПроцедуры

Процедура ОповещениеСлужебныхЗаписок() Экспорт
	
	МассивСлужебок = ЛексСервер.ПолучитьСписокНеОзнакомленныхСлужебок();
	СтруктураДляПеределок = ЛексСервер.ПолучитьНомераПередлок(ПользователиКлиентСервер.ТекущийПользователь());
	ЕстьСлужебки = МассивСлужебок.Количество() > 0;
	ЕстьПеределки = СтруктураДляПеределок.ЕстьМассив;
	
	Если ЕстьСлужебки или ЕстьПеределки Тогда
		
		ПараметрыФормы = Новый Структура;
		
		Если ЕстьСлужебки Тогда
		
			ПараметрыФормы.Вставить("МассивСлужебок", МассивСлужебок);
		
		КонецЕсли; 
		
		Если ЕстьПеределки Тогда
		
			ПараметрыФормы.Вставить("МассивПеределок", СтруктураДляПеределок.МассивСпецификаций);
		
		КонецЕсли;
		
		ОткрытьФорму("ОбщаяФорма.ФормаНеОзнакомленныхСлужебок", ПараметрыФормы);
		
	КонецЕсли;
	
	///Выясняем, надо ли показывать сообщения о переделках
		
КонецПроцедуры

