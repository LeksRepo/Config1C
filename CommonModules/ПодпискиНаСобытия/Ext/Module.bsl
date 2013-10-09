﻿Процедура ПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	// Для Акта к расчету инженера проверяем другую дату.
	
	//Если ТипЗнч(Источник) = Тип("ДокументОбъект.АктВыполненияРасчетаИнженера") Тогда
	//	Если ЗначениеЗаполнено(Источник.ДатаОтгрузки) Тогда
	//		ПроверяемаяДата = Источник.ДатаОтгрузки;
	//	Иначе
	//		ПроверяемаяДата = '31991130';
	//	КонецЕсли;
	//Иначе
	//	ПроверяемаяДата = Источник.Дата;
	//КонецЕсли;

	//Отказ = ЛексСервер.ПериодЗакрыт(ПроверяемаяДата);
	//
	//Если Отказ Тогда
	//	ТекстСообщения = "Запрещено сохранять документ от "+Формат(ПроверяемаяДата, "ДФ=dd.MM.yyyy")+Символы.ПС+"Период закрыт";
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Источник);
	//Иначе
	
	//КонецЕсли;
	
	//ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения);
	
	Если НЕ Отказ Тогда
		УстановитьАвторов(Источник);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопированииДокумента(Источник, ОбъектКопирования) Экспорт
	
	// нужно очищать авторов при копировании документа
	ПустойПользователь = Справочники.Пользователи.ПустаяСсылка();
	Источник.Автор = ПустойПользователь;
	//Источник.Соавтор = ПустойПользователь;
	
КонецПроцедуры

Функция УстановитьАвторов(Объект)
	
	Если Не ЗначениеЗаполнено(Объект.Автор) Тогда 
		
		Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
			Объект.Автор = ПользователиКлиентСервер.ТекущийВнешнийПользователь();
		Иначе
			Объект.Автор = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
		
	КонецЕсли; 
	
	//Если НЕ (ЭтоНовый(Объект))
	//	И (Объект.Соавтор <> ПараметрыСеанса.ТекущийПользователь)
	//	И (Объект.Автор <> ПараметрыСеанса.ТекущийПользователь ИЛИ Объект.Автор = ПараметрыСеанса.ТекущийПользователь И НЕ Объект.Соавтор.Ссылка.Пустая()) Тогда
	//	Объект.Соавтор = ПараметрыСеанса.ТекущийПользователь;
	//КонецЕсли;
		
КонецФункции 

Функция ЭтоНовый(НашОбъект)
	
	Возврат НашОбъект.Ссылка.Пустая();
	
КонецФункции

Процедура ОбработкаЗаполненияДокументов(Источник, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	// утсановим новым документам
	// текущую дату сервера
	Источник.Дата = ТекущаяДата();
	
КонецПроцедуры
