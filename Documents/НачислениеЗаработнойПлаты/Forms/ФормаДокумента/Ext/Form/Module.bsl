﻿// { Васильев Александр Леонидович [02.08.2014]
// Очередные изменения в начислении зарплаты технологов
// Удалить ненужные настройки из регистров
// } Васильев Александр Леонидович [02.08.2014]

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.СписокФизлиц.Количество() > 0 Тогда
		
		Режим = РежимДиалогаВопрос.ДаНет;
		Текст = "Таблица будет перезаполнена" + Символы.ПС + "Продолжить?";
		
		Если Вопрос(Текст, Режим, 0) = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
		
		Объект.СписокФизлиц.Очистить();
		
	КонецЕсли;
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ВариантРасчета = Перечисления.ВидыНачисленийЗаработнойПлаты;
	
	Если Объект.ВариантРасчета = ВариантРасчета.Монтажники Тогда
		
		ЗаполнитьНаСервереМонтажники();
		
	ИначеЕсли Объект.ВариантРасчета = ВариантРасчета.Оклад Тогда
		
		ЗаполнитьНаСервереПоОкладу();
		
	ИначеЕсли Объект.ВариантРасчета = ВариантРасчета.Дизайнеры Тогда
		
		ЗаполнитьНаСервереДизайнеры();
		
	ИначеЕсли Объект.ВариантРасчета = ВариантРасчета.ИнженерТехнолог Тогда
		
		ЗаполнитьНаСервереИнженерТехнолог();
		
	ИначеЕсли Объект.ВариантРасчета = ВариантРасчета.Технолог Тогда
		
		ЗаполнитьНаСервереТехнолог();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервереИнженерТехнолог()
	
	Заглушка = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервереТехнолог()
	
	Заглушка = Истина;
	
КонецПроцедуры

&НаСервере
Функция ПосчитатьЭффективностьРаботыОтдела(МассивСотрудников)
	
	Заглушка = Истина;
	
КонецФункции

&НаСервере
Функция ЗаполнитьНаСервереЭффективностьРаботы(МассивФизическихЛиц)
	
	Заглушка = Истина;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьНаСервереДизайнеры()
	
	Заглушка = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервереМонтажники()
	
	СтавкиМонтажников = ПолучитьСтавкиМонтажников(Объект.Подразделение.Регион, Объект.Дата);
	ВидыПоказателейСотрудников = Перечисления.ВидыПоказателейСотрудников;
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить(ВидыПоказателейСотрудников.КилометровУдаленныхМонтажей);
	МассивПоказателей.Добавить(ВидыПоказателейСотрудников.КоличествоМетровУстановленныхИзделий);
	МассивПоказателей.Добавить(ВидыПоказателейСотрудников.КоличествоУстановленныхИзделий);
	МассивПоказателей.Добавить(ВидыПоказателейСотрудников.ОбзвонНормально);
	МассивПоказателей.Добавить(ВидыПоказателейСотрудников.ОбзвонХорошо);
	МассивПоказателей.Добавить(ВидыПоказателейСотрудников.КоличествоУстановленныхКухонь);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("МассивПоказателей", МассивПоказателей);
	Запрос.УстановитьПараметр("НачалоПериода", Объект.НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода", КонецДня(Объект.ОкончаниеПериода));
	Запрос.УстановитьПараметр("Должность", Справочники.Должности.Монтажник);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОбороты.Субконто1 КАК Показатель,
	|	УправленческийОбороты.СуммаОборот КАК Количество,
	|	ВЫРАЗИТЬ(УправленческийОбороты.Субконто2 КАК Справочник.ФизическиеЛица) КАК Монтажник
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			&ОкончаниеПериода,
	|			,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|			,
	|			Подразделение = &Подразделение
	|				И Субконто1 В (&МассивПоказателей),
	|			,
	|			) КАК УправленческийОбороты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Сумма = 0;
		Комментарий = "";
		
		Если Выборка.Показатель = ВидыПоказателейСотрудников.КилометровУдаленныхМонтажей Тогда
			
			Сумма = Выборка.Количество * СтавкиМонтажников.ПроездМонтажникаЗаГородом;
			Комментарий = "За удаленные монтажи - " + Выборка.Количество + " км.";
			
		ИначеЕсли Выборка.Показатель = ВидыПоказателейСотрудников.КоличествоМетровУстановленныхИзделий Тогда
			
			Сумма = Выборка.Количество * СтавкиМонтажников.СборкаИзделия;
			Комментарий = "За объем выполненных работ - " + Выборка.Количество + " кв.м.";
			
		ИначеЕсли Выборка.Показатель = ВидыПоказателейСотрудников.КоличествоУстановленныхИзделий Тогда
			
			Сумма = Выборка.Количество * СтавкиМонтажников.ВыездМастера;
			Комментарий = "За выезды - " + Выборка.Количество + " шт.";
			
		ИначеЕсли Выборка.Показатель = ВидыПоказателейСотрудников.КоличествоУстановленныхКухонь Тогда
			
			Сумма = Выборка.Количество * СтавкиМонтажников.ВыездМастераНаСборкуКухни;
			Комментарий = "За выезды на установку кухни- " + Выборка.Количество + " шт.";
			
			//ИначеЕсли Выборка.Показатель = ВидыПоказателейСотрудников.ОбзвонНормально Тогда
			//	
			//	Сумма = Выборка.Количество * СтавкиМонтажников.МонтажникуОбзвонНормально;
			//	Комментарий = "За обзвон без нареканий - " + Выборка.Количество + " шт.";
			//	
			//ИначеЕсли Выборка.Показатель = ВидыПоказателейСотрудников.ОбзвонХорошо Тогда
			//	
			//	Сумма = Выборка.Количество * СтавкиМонтажников.МонтажникуОбзвонХорошо;
			//	Комментарий = "За положительный отзыв в обзвоне - " + Выборка.Количество + " шт.";
			
		КонецЕсли;
		
		Если Сумма <> 0 Тогда
			ДобавитьСтрокуТабЧасти(Выборка.Монтажник, Справочники.СтатьиДоходовРасходов.РасходыЗарплатаМонтаж, Сумма, Комментарий);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервереПоОкладу()
	
	Заглушка = Истина;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтавкиМонтажников(Регион, Период)
	
	Ответ = Новый Структура;
	Номенклатура = Справочники.Номенклатура;
	
	МассивНоменклатуры = Новый Массив;
	МассивНоменклатуры.Добавить(Номенклатура.СборкаИзделия);
	МассивНоменклатуры.Добавить(Номенклатура.ПроездМонтажникаЗаГородом);
	МассивНоменклатуры.Добавить(Номенклатура.МонтажникуОбзвонНормально);
	МассивНоменклатуры.Добавить(Номенклатура.МонтажникуОбзвонХорошо);
	МассивНоменклатуры.Добавить(Номенклатура.ВыездМастера);
	МассивНоменклатуры.Добавить(Номенклатура.ВыездМастераНаСборкуКухни);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивНоменклатуры", МассивНоменклатуры);
	Запрос.УстановитьПараметр("Регион", Регион);
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	спрНоменклатура.Ссылка,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная, 0) КАК Цена
	|ИЗ
	|	Справочник.Номенклатура КАК спрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|				&Период,
	|				Регион = &Регион
	|					И Номенклатура В (&МассивНоменклатуры)) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО (ЦеныНоменклатурыСрезПоследних.Номенклатура = спрНоменклатура.Ссылка)
	|ГДЕ
	|	спрНоменклатура.Ссылка В(&МассивНоменклатуры)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Имя = Номенклатура.ПолучитьИмяПредопределенного(Выборка.Ссылка);
		Ответ.Вставить(Имя, Выборка.Цена);
		
	КонецЦикла;
	
	Возврат Ответ;
	
КонецФункции

&НаСервере
Процедура ДобавитьСтрокуТабЧасти(Сотрудник, Статья, Сумма, Комментарий = Неопределено)
	
	НоваяСтрока = Объект.СписокФизлиц.Добавить();
	НоваяСтрока.ФизЛицо = Сотрудник;
	НоваяСтрока.Статья = Статья;
	НоваяСтрока.Сумма = Сумма;
	НоваяСтрока.Комментарий = Комментарий;
	
КонецПроцедуры // ДобавитьСтрокуТабЧасти()

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

