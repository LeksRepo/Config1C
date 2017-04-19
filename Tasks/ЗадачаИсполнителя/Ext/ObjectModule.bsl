﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает Истина, если в задаче указан исполнитель или роль исполнителя.
//
Функция РеквизитыАдресацииЗаполнены() Экспорт
	
	Возврат НЕ Исполнитель.Пустая() ИЛИ НЕ РольИсполнителя.Пустая();

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗадачаБылаВыполнена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Выполнена");
	Если НЕ ЗадачаБылаВыполнена И Выполнена Тогда
		
		Если НЕ РеквизитыАдресацииЗаполнены() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Необходимо указать исполнителя задачи.'"),,,
				"Объект.Исполнитель", Отказ);
			Возврат;
		КонецЕсли;
		
	ИначеЕсли ЗадачаБылаВыполнена И Выполнена Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Эта задача уже была выполнена ранее.'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	Если СрокИсполнения <> '00010101' И ДатаНачала > СрокИсполнения Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Дата начала исполнения не должна превышать крайний срок.'"),,,
			"Объект.ДатаНачала", Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
	Если НЕ Ссылка.Пустая() Тогда
		ИсходныеРеквизиты = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Ссылка, 
			"Выполнена, ПометкаУдаления, СостояниеБизнесПроцесса");
	Иначе 
		ИсходныеРеквизиты = Новый Структура(
			"Выполнена, ПометкаУдаления, СостояниеБизнесПроцесса",
			Ложь, Ложь, Перечисления.СостоянияБизнесПроцессов.ПустаяСсылка());
	КонецЕсли;
	
	Если НЕ ИсходныеРеквизиты.Выполнена И Выполнена Тогда
		
		Если СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Остановлен Тогда
			ВызватьИсключение НСтр("ru = 'Нельзя выполнять задачи остановленных бизнес-процессов.'");
		КонецЕсли;	
		
		// Если задача выполнена, то запишем в реквизит Исполнитель того
		// пользователя, который фактически выполнил задачу. Это нам потом
		// потребуется для отчетов. Такую запись делаем только в том
		// случае, если в базе было не выполнено, а в объекте стало выполнено
		Если НЕ ЗначениеЗаполнено(Исполнитель) Тогда
			Исполнитель = Пользователи.ТекущийПользователь();
		КонецЕсли;
		Если ДатаИсполнения = Дата(1, 1, 1) Тогда
			ДатаИсполнения = ТекущаяДатаСеанса();
		КонецЕсли;
	КонецЕсли;
	
	Если Важность.Пустая() Тогда
		Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СостояниеБизнесПроцесса) Тогда
		СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Активен;
	КонецЕсли;
	
	ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Предмет);
	
	Если ИсходныеРеквизиты.ПометкаУдаления <> ПометкаУдаления Тогда
		БизнесПроцессыИЗадачиСервер.ПриПометкеУдаленияЗадачи(Ссылка, ПометкаУдаления);
	КонецЕсли;
	
	Если НЕ Ссылка.Пустая() И ИсходныеРеквизиты.СостояниеБизнесПроцесса <> СостояниеБизнесПроцесса Тогда
		УстановитьСостояниеПодчиненныхБизнесПроцессов(СостояниеБизнесПроцесса);
	КонецЕсли;
	
	Если Выполнена И Не ПринятаКИсполнению Тогда
		ПринятаКИсполнению = Истина;
		ДатаПринятияКИсполнению = ТекущаяДатаСеанса();
	КонецЕсли;	
		
	// СтандартныеПодсистемы.УправлениеДоступом
	УстановитьПривилегированныйРежим(Истина);
	ГруппаИсполнителейЗадач = БизнесПроцессыИЗадачиСервер.ГруппаИсполнителейЗадач(РольИсполнителя, 
		ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации);
	УстановитьПривилегированныйРежим(Ложь);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Заполнение реквизита ДатаПринятияКИсполнению
	Если ПринятаКИсполнению И ДатаПринятияКИсполнению = Дата('00010101') Тогда
		ДатаПринятияКИсполнению = ТекущаяДатаСеанса();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ЗадачаОбъект.ЗадачаИсполнителя") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, 
			"БизнесПроцесс,ТочкаМаршрута,Наименование,Исполнитель,РольИсполнителя,ОсновнойОбъектАдресации," + 
			"ДополнительныйОбъектАдресации,Важность,ДатаИсполнения,Автор,Описание,СрокИсполнения," + 
			"ДатаНачала,РезультатВыполнения,Предмет");
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Важность) Тогда
		Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СостояниеБизнесПроцесса) Тогда
		СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Активен;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура УстановитьСостояниеПодчиненныхБизнесПроцессов(НовоеСостояние)
	
	НачатьТранзакцию();
	Попытка
		ПодчиненныеБизнесПроцессы = БизнесПроцессыИЗадачиСервер.БизнесПроцессыГлавнойЗадачи(Ссылка);
		Если ПодчиненныеБизнесПроцессы <> Неопределено Тогда
			Для Каждого ПодчиненныйБизнесПроцесс Из ПодчиненныеБизнесПроцессы Цикл
				БизнесПроцессОбъект = ПодчиненныйБизнесПроцесс.ПолучитьОбъект();
				БизнесПроцессОбъект.Заблокировать();
				БизнесПроцессОбъект.Состояние = НовоеСостояние;
				БизнесПроцессОбъект.Записать();
			КонецЦикла;	
		КонецЕсли;	
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры


#КонецЕсли