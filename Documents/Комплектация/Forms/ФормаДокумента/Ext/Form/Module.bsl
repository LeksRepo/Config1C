﻿
&НаКлиенте
Процедура СпецификацияПриИзменении(Элемент)
	
	Спецификация = Объект.Спецификация;
	ПерезаполнитьНаСервере(Спецификация);
	
КонецПроцедуры

&НаКлиенте
Процедура Перезаполнить(Команда)
	
	Ошибки = Неопределено;
	Отказ = Ложь;
	Спецификация = Объект.Спецификация;
	
	Если НЕ ЗначениеЗаполнено(Спецификация) Тогда
		
		ТекстСообщения = "Не выбрана спецификация";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Спецификация", ТекстСообщения);
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если НЕ Отказ Тогда
		ПерезаполнитьНаСервере(Спецификация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОстаткиКомплектацииСпецификаций(СсылкаСпецификация)
	               
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", СсылкаСпецификация);
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.Субконто1 КАК МестоОбработки,
	|	УправленческийОстатки.Субконто3 КАК Номенклатура,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто3 КАК Справочник.Номенклатура).Наименование КАК Наименование,
	|	УправленческийОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.КомплектацииСпецификаций), , Субконто2 = &Ссылка) КАК УправленческийОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	МестоОбработки УБЫВ,
	|	Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка;
	
КонецФункции

&НаСервере
Процедура ПерезаполнитьНаСервере(СпецификацияСсылка)
	
	Объект.СписокНоменклатуры.Очистить();
	
	Выборка = ПолучитьОстаткиКомплектацииСпецификаций(СпецификацияСсылка);
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.СписокНоменклатуры.Добавить();
		НоваяСтрока.Номенклатура = Выборка.Номенклатура;
		
		Если Выборка.МестоОбработки = Перечисления.МестоОбработки.Отгрузка Тогда
			
			НоваяСтрока.КоличествоСклад = Выборка.Количество;
			НоваяСтрока.КоличествоЦех = 0;
			
		Иначе
			
			НоваяСтрока.КоличествоСклад = 0;
			НоваяСтрока.КоличествоЦех = Выборка.Количество;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Спецификация = Объект.Спецификация;
	
	Если Объект.Ссылка = Документы.Комплектация.ПустаяСсылка() И ЗначениеЗаполнено(Объект.Спецификация) И ЗначениеЗаполнено(Объект.Подразделение) Тогда
		ПерезаполнитьНаСервере(Спецификация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если НЕ ВладелецФормы = Неопределено Тогда
		
		ЗакрыватьПриВыборе = Ложь;
		ОповеститьОВыборе(Объект.Спецификация);
		
	КонецЕсли;
	
КонецПроцедуры
