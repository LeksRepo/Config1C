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
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.Субконто3 КАК МестоОбработки,
	|	УправленческийОстатки.Субконто2 КАК Номенклатура,
	|	ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Справочник.Номенклатура).Наименование КАК Наименование,
	|	УправленческийОстатки.КоличествоОстаток КАК Количество,
	|	СписокПодЗаказ.Комментарий КАК Комментарий
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.КомплектацииСпецификаций), , Субконто1 = &Ссылка) КАК УправленческийОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СписокМатериаловПодЗаказ КАК СписокПодЗаказ
	|		ПО ((ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Справочник.Номенклатура)) = СписокПодЗаказ.Номенклатура)
	|			И (СписокПодЗаказ.Ссылка = &Ссылка)
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
	
	Если ЭтоПерваяКомплектация(СпецификацияСсылка) Тогда
		
		Выборка = Документы.Спецификация.ПерезаполнитьКомплектацию(СпецификацияСсылка);
		
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = Объект.СписокНоменклатуры.Добавить();
			НоваяСтрока.Номенклатура = Выборка.Номенклатура;
			НоваяСтрока.КоличествоСклад = Выборка.КоличествоСклад;
			НоваяСтрока.КоличествоЦех = Выборка.КоличествоЦех;
			НоваяСтрока.ЗатребованоСклад = Выборка.КоличествоСклад;
			НоваяСтрока.ЗатребованоЦех = Выборка.КоличествоЦех;
			НоваяСтрока.Комментарий = Выборка.Комментарий;
		КонецЦикла;
		
	Иначе
		
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
			
			НоваяСтрока.ЗатребованоСклад = НоваяСтрока.КоличествоСклад;
			НоваяСтрока.ЗатребованоЦех = НоваяСтрока.КоличествоЦех;
			
			НоваяСтрока.Комментарий = Выборка.Комментарий; 
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЭтоПерваяКомплектация(Спецификация)
	
	Первая = Истина;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТекущаяКомплектация", Объект.Ссылка);
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.Текст=
	"ВЫБРАТЬ
	|	Комплектация.Ссылка
	|ИЗ
	|	Документ.Комплектация КАК Комплектация
	|ГДЕ
	|	Комплектация.Спецификация = &Спецификация
	|	И НЕ Комплектация.ПометкаУдаления
	|	И Комплектация.Ссылка <> &ТекущаяКомплектация";
	
	Результат = Запрос.Выполнить();
	Первая = Результат.Пустой();
	
	Возврат Первая;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Спецификация = Объект.Спецификация;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДата();
	КонецЕсли;
	
	Если НЕ ЭтаФорма.ТолькоПросмотр Тогда
		ЭтаФорма.ТолькоПросмотр = ЛексСервер.ДоступностьФормыСкладскиеДокументы(Объект.Ссылка);
	КонецЕсли;
		
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
		Оповестить("ПоявиласьКомплектация", Объект.Спецификация);    //  ОВыборе
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры
