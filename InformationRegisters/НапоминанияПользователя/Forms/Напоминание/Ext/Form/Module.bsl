﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Объект.Пользователь = Пользователи.ТекущийПользователь();
	
	Если Параметры.Свойство("Источник") Тогда 
		Объект.Источник = Параметры.Источник;
		Объект.Описание = ОбщегоНазначения.ПредметСтрокой(Объект.Источник);
	КонецЕсли;
	
	Если Параметры.Свойство("Ключ") Тогда
		ИсходныеПараметры = Новый Структура("Пользователь,ВремяСобытия,Источник");
		ЗаполнитьЗначенияСвойств(ИсходныеПараметры, Параметры.Ключ);
		ИсходныеПараметры = Новый ФиксированнаяСтруктура(ИсходныеПараметры);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Источник) Тогда
		ЗаполнитьСписокРеквизитовИсточника();
	КонецЕсли;
	
	ЗаполнитьВариантыПериодичности();
	ОпределитьВыбранныйВариантПериодичности();	
	
	ЭтоНовый = Не ЗначениеЗаполнено(Объект.ИсходныйКлючЗаписи);
	Элементы.Прекратить.Видимость = Не ЭтоНовый;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Расписание = ТекущийОбъект.Расписание.Получить();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноТекущегоВремени Тогда
		ТекущийОбъект.ВремяСобытия = ТекущаяДатаСеанса() + Объект.ИнтервалВремениНапоминания;
		ТекущийОбъект.СрокНапоминания = ТекущийОбъект.ВремяСобытия;
		ТекущийОбъект.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ВУказанноеВремя;
	ИначеЕсли ТекущийОбъект.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета Тогда
		ДатаВИсточнике = НапоминанияПользователяСлужебный.ПолучитьЗначениеРеквизитаПредмета(Объект.Источник, Объект.ИмяРеквизитаИсточника);
		Если ЗначениеЗаполнено(ДатаВИсточнике) Тогда
			ДатаВИсточнике = ВычислитьБлижайшуюДату(ДатаВИсточнике);
			ТекущийОбъект.ВремяСобытия = ДатаВИсточнике;
			ТекущийОбъект.СрокНапоминания = ДатаВИсточнике - Объект.ИнтервалВремениНапоминания;
		КонецЕсли;
	ИначеЕсли ТекущийОбъект.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ВУказанноеВремя Тогда
		ТекущийОбъект.СрокНапоминания = Объект.ВремяСобытия;
	ИначеЕсли ТекущийОбъект.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.Периодически Тогда
		БлижайшееВремяНапоминания = НапоминанияПользователяСлужебный.ПолучитьБлижайшуюДатуСобытияПоРасписанию(Расписание);
		Если БлижайшееВремяНапоминания = Неопределено Тогда
			БлижайшееВремяНапоминания = ТекущаяДатаСеанса();
		КонецЕсли;
		ТекущийОбъект.ВремяСобытия = БлижайшееВремяНапоминания;
		ТекущийОбъект.СрокНапоминания = ТекущийОбъект.ВремяСобытия;
	КонецЕсли;
	
	Если ТекущийОбъект.СпособУстановкиВремениНапоминания <> Перечисления.СпособыУстановкиВремениНапоминания.Периодически Тогда
		Расписание = Неопределено;
	КонецЕсли;
	
	ТекущийОбъект.Расписание = Новый ХранилищеЗначения(Расписание, Новый СжатиеДанных(9));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// если это новая запись
	Если Не ЗначениеЗаполнено(Объект.ИсходныйКлючЗаписи) Тогда
		Если Элементы.ИмяРеквизитаИсточника.СписокВыбора.Количество() > 0 Тогда
			Объект.ИмяРеквизитаИсточника = Элементы.ИмяРеквизитаИсточника.СписокВыбора[0].Значение;
			Объект.СпособУстановкиВремениНапоминания = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета");
		КонецЕсли;
		Объект.ВремяСобытия = ОбщегоНазначенияКлиент.ДатаСеанса();
	КонецЕсли;
	
	ЗаполнитьСписокВремени();
	
	ЗаполнитьСпособыОповещения();
	Если Элементы.ИмяРеквизитаИсточника.СписокВыбора.Количество() = 0 Тогда
		Элементы.СпособУстановкиВремениНапоминания.СписокВыбора.Удалить(Элементы.СпособУстановкиВремениНапоминания.СписокВыбора.НайтиПоЗначению(ПолучитьКлючПоЗначениюВСоответствии(ПолучитьПредопределенныеСпособыОповещения(),ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета"))));
	КонецЕсли;		
		
	Если Объект.ИнтервалВремениНапоминания > 0 Тогда
		ИнтервалВремениСтрокой = НапоминанияПользователяКлиентСервер.ПредставлениеВремени(Объект.ИнтервалВремениНапоминания);
	КонецЕсли;
	
	ПредопределенныеСпособыОповещения = ПолучитьПредопределенныеСпособыОповещения();
	ВыбранныйСпособ = ПолучитьКлючПоЗначениюВСоответствии(ПредопределенныеСпособыОповещения, Объект.СпособУстановкиВремениНапоминания);
	
	Если Объект.СпособУстановкиВремениНапоминания = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноТекущегоВремени") Тогда
		СпособУстановкиВремениНапоминания = НСтр("ru = 'через'") + " " + НапоминанияПользователяКлиентСервер.ПредставлениеВремени(Объект.ИнтервалВремениНапоминания);
	Иначе
		СпособУстановкиВремениНапоминания = ВыбранныйСпособ;
	КонецЕсли;
	
	УстановитьВидимость();
	
	ОбновитьРасчетноеВремяНапоминания();
	ПодключитьОбработчикОжидания("ОбновитьРасчетноеВремяНапоминания", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	// для обновления кэша
	СтруктураПараметров = НапоминанияПользователяКлиентСервер.ПолучитьСтруктуруНапоминания(Объект, Истина);
	СтруктураПараметров.Вставить("ИндексКартинки", 2);
	
	НапоминанияПользователяКлиент.ОбновитьЗаписьВКэшеОповещений(СтруктураПараметров);
	
	НапоминанияПользователяКлиент.СброситьТаймерПроверкиТекущихОповещений();
	
	Если ЗначениеЗаполнено(Объект.Источник) Тогда 
		ОповеститьОбИзменении(Объект.Источник);
	КонецЕсли;
	
	Оповестить("Запись_НапоминанияПользователя", Новый Структура, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если ИсходныеПараметры <> Неопределено Тогда 
		НапоминанияПользователяКлиент.УдалитьЗаписьИзКэшаОповещений(ИсходныеПараметры);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособУстановкиВремениНапоминанияПриИзменении(Элемент)
	ОчиститьСообщения();
	
	ИнтервалВремени = НапоминанияПользователяКлиентСервер.ПолучитьИнтервалВремениИзСтроки(СпособУстановкиВремениНапоминания);
	Если ИнтервалВремени > 0 Тогда
		ИнтервалВремениСтрокой = НапоминанияПользователяКлиентСервер.ПредставлениеВремени(ИнтервалВремени);
		СпособУстановкиВремениНапоминания = НСтр("ru = 'через'") + " " + ИнтервалВремениСтрокой;
	Иначе
		Если Элементы.СпособУстановкиВремениНапоминания.СписокВыбора.НайтиПоЗначению(СпособУстановкиВремениНапоминания) = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Интервал времени не определен.'"), , "СпособУстановкиВремениНапоминания");
		КонецЕсли;
	КонецЕсли;
	
	ПредопределенныеСпособыОповещения = ПолучитьПредопределенныеСпособыОповещения();
	ВыбранныйСпособ = ПредопределенныеСпособыОповещения.Получить(СпособУстановкиВремениНапоминания);
	
	Если ВыбранныйСпособ = Неопределено Тогда
		Объект.СпособУстановкиВремениНапоминания = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноТекущегоВремени");
	Иначе
		Объект.СпособУстановкиВремениНапоминания = ВыбранныйСпособ;
	КонецЕсли;
	
	Объект.ИнтервалВремениНапоминания = ИнтервалВремени;
	
	УстановитьВидимость();		
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИнтервалаВремени(Элемент)
	Объект.ИнтервалВремениНапоминания = НапоминанияПользователяКлиентСервер.ПолучитьИнтервалВремениИзСтроки(ИнтервалВремениСтрокой);
	Если Объект.ИнтервалВремениНапоминания > 0 Тогда
		ИнтервалВремениСтрокой = НапоминанияПользователяКлиентСервер.ПредставлениеВремени(Объект.ИнтервалВремениНапоминания);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Интервал времени не определен'"), , "ИнтервалВремениСтрокой");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВариантПериодичностиПриИзменении(Элемент)
	ПриИзмененииРасписания();
КонецПроцедуры

&НаКлиенте
Процедура ВариантПериодичностиОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПриИзмененииРасписания();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ЗаполнитьСписокВремени();
КонецПроцедуры

&НаКлиенте
Процедура ВремяПриИзменении(Элемент)
	Объект.ВремяСобытия = НачалоМинуты(Объект.ВремяСобытия);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Прекратить(Команда)
	
	КнопкиДиалога = Новый СписокЗначений;
	КнопкиДиалога.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Прекратить'"));
	КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Не прекращать'"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПрекратитьНапоминание", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Прекратить напоминание?'"), КнопкиДиалога);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПрекратитьНапоминание(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЭтотОбъект.Модифицированность = Ложь;
		Если ИсходныеПараметры <> Неопределено Тогда 
			ОтключитьНапоминание();
			НапоминанияПользователяКлиент.УдалитьЗаписьИзКэшаОповещений(ИсходныеПараметры);
			Оповестить("Запись_НапоминанияПользователя", Новый Структура, Объект.ИсходныйКлючЗаписи);
			ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.НапоминанияПользователя"));
		КонецЕсли;
		Если ЭтотОбъект.Открыта() Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьНапоминание()
	НапоминанияПользователяСлужебный.ОтключитьНапоминание(ИсходныеПараметры, Ложь);
КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитИсточникаСуществуетИСодержитТипДата(МетаданныеИсточника, ИмяРеквизита, ПроверятьДату = Ложь)
	Результат = Ложь;
	Если МетаданныеИсточника.Реквизиты.Найти(ИмяРеквизита) <> Неопределено
	   и МетаданныеИсточника.Реквизиты[ИмяРеквизита].Тип.СодержитТип(Тип("Дата")) Тогда
		Результат = Истина;
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьКлючПоЗначениюВСоответствии(Соответствие, Значение)
	Результат = Неопределено;
	Для Каждого КлючИЗначение Из Соответствие Цикл
		Если ТипЗнч(Значение) = Тип("РасписаниеРегламентногоЗадания") Тогда
			Если ОбщегоНазначенияКлиентСервер.РасписанияОдинаковые(КлючИЗначение.Значение, Значение) Тогда
		    	Возврат КлючИЗначение.Ключ;
			КонецЕсли;
		Иначе
			Если КлючИЗначение.Значение = Значение Тогда
				Возврат КлючИЗначение.Ключ;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;	
КонецФункции

&НаКлиенте
Функция ПолучитьПредопределенныеСпособыОповещения()
	Результат = Новый Соответствие;
	Результат.Вставить(НСтр("ru = 'относительно предмета'"), ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета"));
	Результат.Вставить(НСтр("ru = 'в указанное время'"), ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ВУказанноеВремя"));
	Результат.Вставить(НСтр("ru = 'периодически'"), ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.Периодически"));
	Возврат Результат;
КонецФункции
           
&НаКлиенте
Процедура ЗаполнитьСпособыОповещения()
	СпособыОповещения = Элементы.СпособУстановкиВремениНапоминания.СписокВыбора;
	СпособыОповещения.Очистить();
	Для Каждого Способ Из ПолучитьПредопределенныеСпособыОповещения() Цикл
		СпособыОповещения.Добавить(Способ.Ключ);
	КонецЦикла;	
	
	Элементы.ИнтервалВремениОтносительноИсточника.СписокВыбора.Очистить();
	ИнтервалыВремени = НапоминанияПользователяКлиентСервер.ПолучитьСтандартныеИнтервалыОповещения();
	Для Каждого Интервал Из ИнтервалыВремени Цикл
		СпособыОповещения.Добавить(НСтр("ru = 'через'") + " " + Интервал);
		Элементы.ИнтервалВремениОтносительноИсточника.СписокВыбора.Добавить(Интервал);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВремени()
	Элементы.Время.СписокВыбора.Очистить();
	Для Час = 0 по 23 Цикл 
		Для Период = 0 По 1 Цикл
			Время = Час*60*60 + Период*30*60;
			Элементы.Время.СписокВыбора.Добавить(НачалоДня(Объект.ВремяСобытия) + Время, "" + Час + ":" + Формат(Период*30,"ЧЦ=2; ЧН=00"));		
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРеквизитовИсточника()
	
	МассивРеквизитов = Новый Массив;
	
	// заполняем по умолчанию
	МетаданныеИсточника = Объект.Источник.Метаданные();	
	Для Каждого Реквизит Из МетаданныеИсточника.Реквизиты Цикл
		Если РеквизитИсточникаСуществуетИСодержитТипДата(МетаданныеИсточника, Реквизит.Имя) Тогда
			МассивРеквизитов.Добавить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	// получаем переопределенный массив реквизитов
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.НапоминанияПользователя\ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания(Объект.Источник, МассивРеквизитов);
	КонецЦикла;
	НапоминанияПользователяКлиентСерверПереопределяемый.ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания(Объект.Источник, МассивРеквизитов);
		
	Элементы.ИмяРеквизитаИсточника.СписокВыбора.Очистить();
	
	Для Каждого ИмяРеквизита Из МассивРеквизитов Цикл
		Если РеквизитИсточникаСуществуетИСодержитТипДата(МетаданныеИсточника, ИмяРеквизита) Тогда
			Если ТипЗнч(Объект.Источник[ИмяРеквизита]) = Тип("Дата") И Объект.Источник[ИмяРеквизита] > ТекущаяДатаСеанса() Тогда
				Реквизит = МетаданныеИсточника.Реквизиты.Найти(ИмяРеквизита);
				ПредставлениеРеквизита = ?(ПустаяСтрока(Реквизит.Синоним),Реквизит.Имя, Реквизит.Синоним);
				Если Элементы.ИмяРеквизитаИсточника.СписокВыбора.НайтиПоЗначению(ИмяРеквизита) = Неопределено Тогда
					Элементы.ИмяРеквизитаИсточника.СписокВыбора.Добавить(ИмяРеквизита, ПредставлениеРеквизита);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВариантыПериодичности()
	Элементы.ВариантПериодичности.СписокВыбора.Очистить();
	СписокРасписаний = НапоминанияПользователяСлужебный.ПолучитьСтандартныеРасписанияДляНапоминания();
	Для Каждого СтандартноеРасписание Из СписокРасписаний Цикл
		Элементы.ВариантПериодичности.СписокВыбора.Добавить(СтандартноеРасписание.Ключ, СтандартноеРасписание.Ключ);
	КонецЦикла;
	Элементы.ВариантПериодичности.СписокВыбора.Добавить("", НСтр("ru = 'по заданному расписанию...'"));	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	
	ПредопределенныеСпособыОповещения = ПолучитьПредопределенныеСпособыОповещения();
	ВыбранныйСпособ = ПредопределенныеСпособыОповещения.Получить(СпособУстановкиВремениНапоминания);
	
	Если ВыбранныйСпособ <> Неопределено Тогда
		Если ВыбранныйСпособ = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ВУказанноеВремя") Тогда
			Элементы.ПанельДетальныхНастроек.ТекущаяСтраница = Элементы.ДатаВремя;
		ИначеЕсли ВыбранныйСпособ = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета") Тогда
			Элементы.ПанельДетальныхНастроек.ТекущаяСтраница = Элементы.НастройкаИсточника;
		ИначеЕсли ВыбранныйСпособ = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.Периодически") Тогда
			Элементы.ПанельДетальныхНастроек.ТекущаяСтраница = Элементы.НастройкаПериодичности;
		КонецЕсли;			
	Иначе
		Элементы.ПанельДетальныхНастроек.ТекущаяСтраница = Элементы.БезДетализации;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДиалогНастройкиРасписания()
	Если Расписание = Неопределено Тогда 
		Расписание = Новый РасписаниеРегламентногоЗадания;
		Расписание.ПериодПовтораДней = 1;
	КонецЕсли;
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьДиалогНастройкиРасписанияЗавершение", ЭтотОбъект);
	ДиалогРасписания.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДиалогНастройкиРасписанияЗавершение(ВыбранноеРасписание, ДополнительныеПараметры) Экспорт
	Если ВыбранноеРасписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Расписание = ВыбранноеРасписание;
	Если Не РасписаниеСоответствуетТребованиям(Расписание) Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Периодичность в течение дня не поддерживается, соответствующие настройки очищены.'"));
	КонецЕсли;
	НормализоватьРасписание(Расписание);
	ОпределитьВыбранныйВариантПериодичности();
КонецПроцедуры

&НаКлиенте
Функция РасписаниеСоответствуетТребованиям(ПроверяемоеРасписание)
	Если ПроверяемоеРасписание.ПериодПовтораВТечениеДня > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Каждого РасписаниеДня Из ПроверяемоеРасписание.ДетальныеРасписанияДня Цикл
		Если РасписаниеДня.ПериодПовтораВТечениеДня > 0 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура НормализоватьРасписание(НормализуемоеРасписание);
	НормализуемоеРасписание.ВремяКонца = '000101010000';
	НормализуемоеРасписание.ВремяЗавершения =  НормализуемоеРасписание.ВремяКонца;
	НормализуемоеРасписание.ПериодПовтораВТечениеДня = 0;
	НормализуемоеРасписание.ПаузаПовтора = 0;
	НормализуемоеРасписание.ИнтервалЗавершения = 0;
	Для Каждого РасписаниеДня Из НормализуемоеРасписание.ДетальныеРасписанияДня Цикл
		РасписаниеДня.ВремяКонца = '000101010000';
		РасписаниеДня.ВремяЗавершения =  РасписаниеДня.ВремяКонца;
		РасписаниеДня.ПериодПовтораВТечениеДня = 0;
		РасписаниеДня.ПаузаПовтора = 0;
		РасписаниеДня.ИнтервалЗавершения = 0;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОпределитьВыбранныйВариантПериодичности()
	СтандартныеРасписания = НапоминанияПользователяСлужебный.ПолучитьСтандартныеРасписанияДляНапоминания();
	
	Если Расписание = Неопределено Тогда
		ВариантПериодичности = Элементы.ВариантПериодичности.СписокВыбора.Получить(0).Значение;
		Расписание = СтандартныеРасписания[ВариантПериодичности];
	Иначе
		ВариантПериодичности = ПолучитьКлючПоЗначениюВСоответствии(СтандартныеРасписания, Расписание);
	КонецЕсли;
	
	Элементы.ВариантПериодичности.КнопкаОткрытия = ПустаяСтрока(ВариантПериодичности);
	Элементы.ВариантПериодичности.Подсказка = Расписание;
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРасписания()
	ПользовательскаяНастройка = ПустаяСтрока(ВариантПериодичности);
	Если ПользовательскаяНастройка Тогда
		ОткрытьДиалогНастройкиРасписания();
	Иначе
		СтандартныеРасписания = Неопределено;
		ПолучитьСтандартныеРасписания(СтандартныеРасписания);
		Расписание = СтандартныеРасписания[ВариантПериодичности];
	КонецЕсли;
	ОпределитьВыбранныйВариантПериодичности();
КонецПроцедуры

&НаСервере
Процедура ПолучитьСтандартныеРасписания(СтандартныеРасписания)
	
	СтандартныеРасписания = НапоминанияПользователяСлужебный.ПолучитьСтандартныеРасписанияДляНапоминания();
	
КонецПроцедуры

&НаСервере
Функция ВычислитьБлижайшуюДату(ИсходнаяДата)
	Результат = ИсходнаяДата;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА &ИсходнаяДата > &ТекущаяДата
	|			ТОГДА &ИсходнаяДата
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(&ИсходнаяДата, ГОД, РАЗНОСТЬДАТ(&ИсходнаяДата, &ТекущаяДата, ГОД))
	|	КОНЕЦ КАК БудущаяДата";
	
	Запрос.УстановитьПараметр("ИсходнаяДата", ИсходнаяДата);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Результат = Выборка.БудущаяДата;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция РасчетноеВремяСтрокой()
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	РасчетноеВремяНапоминания = ТекущаяДата + Объект.ИнтервалВремениНапоминания;
	
	ВыводитьДату = День(РасчетноеВремяНапоминания) <> День(ТекущаяДата);
	
	ДатаСтрокой = Формат(РасчетноеВремяНапоминания,"ДЛФ=DD");
	ВремяСтрокой = Формат(РасчетноеВремяНапоминания,"ДФ=H:mm");
	
	Возврат "(" + ?(ВыводитьДату, ДатаСтрокой + " ", "") +  ВремяСтрокой + ")";
	
КонецФункции

&НаКлиенте
Процедура ОбновитьРасчетноеВремяНапоминания()
	Элементы.РасчетноеВремяНапоминания.Заголовок = РасчетноеВремяСтрокой();
КонецПроцедуры

#КонецОбласти
