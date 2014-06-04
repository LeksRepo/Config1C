﻿
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
	
	Если Объект.ВидНачисления = Перечисления.ВидыНачисленийЗаработнойПлаты.Монтажники Тогда
		
		ЗаполнитьНаСервереМонтажники();
		
	ИначеЕсли Объект.ВидНачисления = Перечисления.ВидыНачисленийЗаработнойПлаты.Оклад Тогда
		
		ЗаполнитьНаСервереПоОкладу();
		
	ИначеЕсли Объект.ВидНачисления = Перечисления.ВидыНачисленийЗаработнойПлаты.Дизайнеры Тогда
		
		ЗаполнитьНаСервереДизайнеры();
		
	ИначеЕсли Объект.ВидНачисления = Перечисления.ВидыНачисленийЗаработнойПлаты.ИнженерТехнолог Тогда
		
		ЗаполнитьНаСервереИнженерТехнолог();
		
	ИначеЕсли Объект.ВидНачисления = Перечисления.ВидыНачисленийЗаработнойПлаты.Технолог Тогда
		
		ЗаполнитьНаСервереТехнолог();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервереИнженерТехнолог()
	
	ВидыПараметровНачислений = Перечисления.ВидыПараметровНачислений;
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(ВидыПараметровНачислений.КоличествоБаловТехнологаВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.КоличествоБаловТехнологаНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.КоличествоОшибокТехнологаВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.КоличествоОшибокТехнологаНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоБаламВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоБаламНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоОшибкамВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоОшибкамНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.КоличествоНарушенийНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.КоличествоНарушенийВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоНарушениямВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоНарушениямНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоНарушениямСредняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.ПроцентЭффективностиРасчетногоЦентраВерхняяГрница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.ПроцентЭффективностиРасчетногоЦентраНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоЭффективностиОтделаВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоЭффективностиОтделаНижняяГраница);
	
	Подразделение = Объект.Подразделение;
	ТаблицаПараметров = ЛексСервер.ПолучитьЗначениеПараметров(МассивПараметров, Подразделение, Объект.ОкончаниеПериода);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("НачалоПериода", Объект.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", Объект.ОкончаниеПериода);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДолжностиСотрудниковСрезПоследних.ФизЛицо КАК Сотрудник,
	|	УправленческийОбороты.СуммаОборот КАК СуммаБалов,
	|	ОшибкиСотрудниковОбороты.КоличествоОборот КАК КоличествоОшибок
	|ИЗ
	|	РегистрСведений.ДолжностиСотрудников.СрезПоследних(
	|			&НачалоПериода,
	|			Подразделение = &Подразделение
	|				И Должность = ЗНАЧЕНИЕ(Справочник.Должности.ИнженерТехнолог)) КАК ДолжностиСотрудниковСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Обороты(
	|				&НачалоПериода,
	|				&КонецПериода,
	|				,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто1 = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.БаллыТехнологов),
	|				,
	|				) КАК УправленческийОбороты
	|		ПО ДолжностиСотрудниковСрезПоследних.ФизЛицо = УправленческийОбороты.Субконто2
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОшибкиСотрудников.Обороты(&НачалоПериода, &КонецПериода, , ) КАК ОшибкиСотрудниковОбороты
	|		ПО ДолжностиСотрудниковСрезПоследних.ФизЛицо = ОшибкиСотрудниковОбороты.Сотрудник
	|ГДЕ
	|	ДолжностиСотрудниковСрезПоследних.Работает";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.КоличествоБаловТехнологаНижняяГраница);
	НижняяГраницаБаловИнженераТехнолога = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.КоличествоБаловТехнологаВерхняяГраница);
	ВерхняяГраницаБаловИнженераТехнолога = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоБаламВерхняяГраница);
	ВерхнееНачислениеПоБаламИнженеруТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоБаламНижняяГраница);
	НижнееНачислениеПоБаламИнженеруТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.КоличествоОшибокТехнологаВерхняяГраница);
	ВерхняяГраницаОшибокИнженераТехнолога = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.КоличествоОшибокТехнологаНижняяГраница);
	НижняяГраницаОшибокИнженераТехнолога = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоОшибкамВерхняяГраница);
	ВерхнееНачислениеПоОшибкамИнженеруТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоОшибкамНижняяГраница);
	НижнееНачислениеПоОшибкамИнженеруТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.КоличествоНарушенийНижняяГраница);
	НижняяГраницаНарушенийИнженераТехнолога = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.КоличествоНарушенийВерхняяГраница);
	ВерхняяГраницаНарушенийИнженераТехнолога = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоНарушениямНижняяГраница);
	НижнееНачислениеПоНарушениямИнженеруТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоНарушениямВерхняяГраница);
	ВерхнееНачислениеПоНарушениямИнженеруТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоНарушениямСредняяГраница);
	СреднееНачислениеПоНарушениямИнженеруТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.ПроцентЭффективностиРасчетногоЦентраВерхняяГрница);
	ВерхняяГраницаПроцентаЭффективностиОтдела = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.ПроцентЭффективностиРасчетногоЦентраНижняяГраница);
	НижняяГраницаПроцентаЭффективностиОтдела = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоЭффективностиОтделаВерхняяГраница);
	ВерхнееНачислениеПоЭффективностиОтделаИнженеруТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеИнженеруТехнологуПоЭффективностиОтделаНижняяГраница);
	НижнееНачислениеПоЭффективностиОтделаИнженеруТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	
	Пока Выборка.Следующий() Цикл
		////////////////балы
		СуммаБалов = ?(ЗначениеЗаполнено(Выборка.СуммаБалов), Выборка.СуммаБалов, 0);
		Надбавка = 0;
		
		Если СуммаБалов > НижняяГраницаБаловИнженераТехнолога Тогда
			
			Если СуммаБалов > ВерхняяГраницаБаловИнженераТехнолога Тогда
				
				Надбавка = ВерхнееНачислениеПоБаламИнженеруТехнологу;
				
			Иначе
				
				Надбавка = НижнееНачислениеПоБаламИнженеруТехнологу;
				
			КонецЕсли;
			
			Комментарий = "Норма выработки = " + СуммаБалов;
			
			ДобавитьСтрокуТабЧасти(Выборка.Сотрудник, Справочники.СтатьиДоходовРасходов.РасходыЗарплатаТехПерсонал, Надбавка, Комментарий)
			
		КонецЕсли;
		///////Технические ошибки
		Надбавка = 0;
		КоличествоОшибок = Выборка.КоличествоОшибок;
		Комментарий = "Количество ошибок = " + КоличествоОшибок;
		
		Если КоличествоОшибок <= ВерхняяГраницаОшибокИнженераТехнолога Тогда
			
			Если КоличествоОшибок > НижняяГраницаОшибокИнженераТехнолога Тогда
				
				Надбавка = НижнееНачислениеПоОшибкамИнженеруТехнологу;
				
			Иначе
				
				Надбавка = ВерхнееНачислениеПоОшибкамИнженеруТехнологу;
				
			КонецЕсли;
			
			ДобавитьСтрокуТабЧасти(Выборка.Сотрудник, Справочники.СтатьиДоходовРасходов.РасходыЗарплатаТехПерсонал, Надбавка, Комментарий)
			
		КонецЕсли;
		/////////////Нарушения исполнительской дисциплины
		МассивССотрудником = Новый Массив;
		Надбавка = 0;
		МассивССотрудником.Добавить(Выборка.Сотрудник);
		
		СтруктураНарушений = ЗаполнитьНаСервереЭффективностьРаботы(МассивССотрудником);
		КоличествоЗаписок = СтруктураНарушений.КоличествоЗаписок;
		
		Если КоличествоЗаписок < ВерхняяГраницаНарушенийИнженераТехнолога Тогда
			
			Если КоличествоЗаписок > НижняяГраницаНарушенийИнженераТехнолога Тогда
				
				Надбавка = СреднееНачислениеПоНарушениямИнженеруТехнологу;
				
			Иначе
				
				Надбавка = ВерхнееНачислениеПоНарушениямИнженеруТехнологу;
				
			КонецЕсли;
			
		Иначе
			
			Надбавка = НижнееНачислениеПоНарушениямИнженеруТехнологу;
			
		КонецЕсли;
		
		Комментарий = "Количество нарушений = " + КоличествоЗаписок;
		
		ДобавитьСтрокуТабЧасти(СтруктураНарушений.Сотрудник, Справочники.СтатьиДоходовРасходов.РасходыЗарплатаТехПерсонал, Надбавка, Комментарий);
		//////////Эффективность отдела
		Надбавка = 0;
		ПроцентЭффективностиОтдела = ПосчитатьЭффективностьРаботыОтдела(МассивССотрудником);
				
		Если ПроцентЭффективностиОтдела < ВерхняяГраницаПроцентаЭффективностиОтдела Тогда
			
			Если ПроцентЭффективностиОтдела > НижняяГраницаПроцентаЭффективностиОтдела Тогда
				
				Надбавка = НижнееНачислениеПоЭффективностиОтделаИнженеруТехнологу;
				
			Иначе
				
				Надбавка = ВерхнееНачислениеПоЭффективностиОтделаИнженеруТехнологу;
				
			КонецЕсли;
			
			Комментарий = "Процент эффективности отдела = " + ПроцентЭффективностиОтдела;
			
			ДобавитьСтрокуТабЧасти(СтруктураНарушений.Сотрудник, Справочники.СтатьиДоходовРасходов.РасходыЗарплатаТехПерсонал, Надбавка, Комментарий);
			
		КонецЕсли;
				
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервереТехнолог()
	
	ВидыПараметровНачислений = Перечисления.ВидыПараметровНачислений;
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(ВидыПараметровНачислений.КоличествоБаловТехнологаВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.КоличествоБаловТехнологаНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.КоличествоОшибокТехнологаВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.КоличествоОшибокТехнологаНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеТехнологуПоБаламВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеТехнологуПоБаламНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеТехнологуПоОшибкамВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеТехнологуПоОшибкамНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.КоличествоНарушенийНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.КоличествоНарушенийВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеТехнологуПоНарушениямВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеТехнологуПоНарушениямНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеТехнологуПоНарушениямСредняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.ПроцентЭффективностиРасчетногоЦентраВерхняяГрница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.ПроцентЭффективностиРасчетногоЦентраНижняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеТехнологуПоЭффективностиОтделаВерхняяГраница);
	МассивПараметров.Добавить(ВидыПараметровНачислений.НачислениеТехнологуПоЭффективностиОтделаНижняяГраница);
	
	Подразделение = Объект.Подразделение;
	ТаблицаПараметров = ЛексСервер.ПолучитьЗначениеПараметров(МассивПараметров, Подразделение, Объект.ОкончаниеПериода);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("НачалоПериода", Объект.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", Объект.ОкончаниеПериода);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДолжностиСотрудниковСрезПоследних.ФизЛицо КАК Сотрудник,
	|	УправленческийОбороты.СуммаОборот КАК СуммаБалов,
	|	ОшибкиСотрудниковОбороты.КоличествоОборот КАК КоличествоОшибок
	|ИЗ
	|	РегистрСведений.ДолжностиСотрудников.СрезПоследних(
	|			&НачалоПериода,
	|			Подразделение = &Подразделение
	|				И Должность = ЗНАЧЕНИЕ(Справочник.Должности.Технолог)) КАК ДолжностиСотрудниковСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Обороты(
	|				&НачалоПериода,
	|				&КонецПериода,
	|				,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто1 = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.БаллыТехнологов),
	|				,
	|				) КАК УправленческийОбороты
	|		ПО ДолжностиСотрудниковСрезПоследних.ФизЛицо = УправленческийОбороты.Субконто2
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОшибкиСотрудников.Обороты(&НачалоПериода, &КонецПериода, , ) КАК ОшибкиСотрудниковОбороты
	|		ПО ДолжностиСотрудниковСрезПоследних.ФизЛицо = ОшибкиСотрудниковОбороты.Сотрудник
	|ГДЕ
	|	ДолжностиСотрудниковСрезПоследних.Работает";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.КоличествоБаловТехнологаНижняяГраница);
	НижняяГраницаБаловТехнолога = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.КоличествоБаловТехнологаВерхняяГраница);
	ВерхняяГраницаБаловТехнолога = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеТехнологуПоБаламВерхняяГраница);
	ВерхнееНачислениеПоБаламТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеТехнологуПоБаламНижняяГраница);
	НижнееНачислениеПоБаламТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.КоличествоОшибокТехнологаВерхняяГраница);
	ВерхняяГраницаОшибокТехнолога = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.КоличествоОшибокТехнологаНижняяГраница);
	НижняяГраницаОшибокТехнолога = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеТехнологуПоОшибкамВерхняяГраница);
	ВерхнееНачислениеПоОшибкамТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеТехнологуПоОшибкамНижняяГраница);
	НижнееНачислениеПоОшибкамТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.КоличествоНарушенийНижняяГраница);
	НижняяГраницаНарушенийТехнолога = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.КоличествоНарушенийВерхняяГраница);
	ВерхняяГраницаНарушенийТехнолога = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеТехнологуПоНарушениямНижняяГраница);
	НижнееНачислениеПоНарушениямТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеТехнологуПоНарушениямВерхняяГраница);
	ВерхнееНачислениеПоНарушениямТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеТехнологуПоНарушениямСредняяГраница);
	СреднееНачислениеПоНарушениямТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.ПроцентЭффективностиРасчетногоЦентраВерхняяГрница);
	ВерхняяГраницаПроцентаЭффективностиОтдела = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.ПроцентЭффективностиРасчетногоЦентраНижняяГраница);
	НижняяГраницаПроцентаЭффективностиОтдела = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеТехнологуПоЭффективностиОтделаВерхняяГраница);
	ВерхнееНачислениеПоЭффективностиОтделаТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.НачислениеТехнологуПоЭффективностиОтделаНижняяГраница);
	НижнееНачислениеПоЭффективностиОтделаТехнологу = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
	
	Пока Выборка.Следующий() Цикл
		////////////////балы
		СуммаБалов = ?(ЗначениеЗаполнено(Выборка.СуммаБалов), Выборка.СуммаБалов, 0);
		Надбавка = 0;
		
		Если СуммаБалов > НижняяГраницаБаловТехнолога Тогда
			
			Если СуммаБалов > ВерхняяГраницаБаловТехнолога Тогда
				
				Надбавка = ВерхнееНачислениеПоБаламТехнологу;
				
			Иначе
				
				Надбавка = НижнееНачислениеПоБаламТехнологу;
				
			КонецЕсли;
			
			Комментарий = "Норма выработки = " + СуммаБалов;
			
			ДобавитьСтрокуТабЧасти(Выборка.Сотрудник, Справочники.СтатьиДоходовРасходов.РасходыЗарплатаТехПерсонал, Надбавка, Комментарий);
			
		КонецЕсли;
		///////Технические ошибки
		Надбавка = 0;
		КоличествоОшибок = Выборка.КоличествоОшибок;
		Комментарий = "Количество ошибок = " + КоличествоОшибок;
		
		Если КоличествоОшибок <= ВерхняяГраницаОшибокТехнолога Тогда
			
			Если КоличествоОшибок > НижняяГраницаОшибокТехнолога Тогда
				
				Надбавка = НижнееНачислениеПоОшибкамТехнологу;
				
			Иначе
				
				Надбавка = ВерхнееНачислениеПоОшибкамТехнологу;
				
			КонецЕсли;
			
			ДобавитьСтрокуТабЧасти(Выборка.Сотрудник, Справочники.СтатьиДоходовРасходов.РасходыЗарплатаТехПерсонал, Надбавка, Комментарий);
		КонецЕсли;
		/////////////Нарушения исполнительской дисциплины
		МассивССотрудником = Новый Массив;
		Надбавка = 0;
		МассивССотрудником.Добавить(Выборка.Сотрудник);
		
		СтруктураНарушений = ЗаполнитьНаСервереЭффективностьРаботы(МассивССотрудником);
		КоличествоЗаписок = СтруктураНарушений.КоличествоЗаписок;
		
		Если КоличествоЗаписок < ВерхняяГраницаНарушенийТехнолога Тогда
			
			Если КоличествоЗаписок > НижняяГраницаНарушенийТехнолога Тогда
				
				Надбавка = СреднееНачислениеПоНарушениямТехнологу;
				
			Иначе
				
				Надбавка = ВерхнееНачислениеПоНарушениямТехнологу;
				
			КонецЕсли;
			
		Иначе
			
			Надбавка = НижнееНачислениеПоНарушениямТехнологу;
			
		КонецЕсли;
		
		Комментарий = "Количество нарушений = " + КоличествоЗаписок;
		
		ДобавитьСтрокуТабЧасти(СтруктураНарушений.Сотрудник, Справочники.СтатьиДоходовРасходов.РасходыЗарплатаТехПерсонал, Надбавка, Комментарий);
		//////////Эффективность отдела
		Надбавка = 0;
		ПроцентЭффективностиОтдела = ПосчитатьЭффективностьРаботыОтдела(МассивССотрудником);
				
		Если ПроцентЭффективностиОтдела < ВерхняяГраницаПроцентаЭффективностиОтдела Тогда
			
			Если ПроцентЭффективностиОтдела > НижняяГраницаПроцентаЭффективностиОтдела Тогда
				
				Надбавка = НижнееНачислениеПоЭффективностиОтделаТехнологу;
				
			Иначе
				
				Надбавка = ВерхнееНачислениеПоЭффективностиОтделаТехнологу;
				
			КонецЕсли;
			
			Комментарий = "Процент эффективности отдела = " + ПроцентЭффективностиОтдела;
			
			ДобавитьСтрокуТабЧасти(СтруктураНарушений.Сотрудник, Справочники.СтатьиДоходовРасходов.РасходыЗарплатаТехПерсонал, Надбавка, Комментарий);
			
		КонецЕсли;
				
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПосчитатьЭффективностьРаботыОтдела(МассивСотрудников)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(УправленческийОборотыСуммаДокумента.СуммаОборот, 0) КАК СуммаРазмещенныхЗаказов,
		|	ЕСТЬNULL(ОшибкиСотрудниковОбороты.СуммаОборот, 0) КАК СуммаПеределок,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(УправленческийОборотыСуммаДокумента.СуммаОборот, 0) > 0
		|			ТОГДА ЕСТЬNULL(ОшибкиСотрудниковОбороты.СуммаОборот, 0) * 100 / ЕСТЬNULL(УправленческийОборотыСуммаДокумента.СуммаОборот, 0)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ПроцентЭффективностиОтдела
		|ИЗ
		|	РегистрСведений.ДолжностиСотрудников.СрезПоследних(
		|			&НачалоПериода,
		|			Подразделение = &Подразделение
		|				И (Должность = ЗНАЧЕНИЕ(Справочник.Должности.ИнженерТехнолог)
		|					ИЛИ Должность = ЗНАЧЕНИЕ(Справочник.Должности.Технолог))) КАК ДолжностиСотрудниковСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Обороты(
		|				&НачалоПериода,
		|				&КонецПериода,
		|				,
		|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
		|				,
		|				Подразделение = &Подразделение
		|					И Субконто1 = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.СуммаРазмещенныхЗаказов),
		|				,
		|				) КАК УправленческийОборотыСуммаДокумента
		|		ПО ДолжностиСотрудниковСрезПоследних.ФизЛицо = УправленческийОборотыСуммаДокумента.Субконто2
		|			И ДолжностиСотрудниковСрезПоследних.ФизЛицо = УправленческийОборотыСуммаДокумента.Субконто2,
		|	РегистрНакопления.ОшибкиСотрудников.Обороты(&НачалоПериода, &КонецПериода, , ) КАК ОшибкиСотрудниковОбороты
		|ГДЕ
		|	ДолжностиСотрудниковСрезПоследних.Работает";
		
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("НачалоПериода", Объект.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", Объект.ОкончаниеПериода);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат 0;
		
	Иначе
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		ВыборкаДетальныеЗаписи.Следующий();
		
		Возврат ВыборкаДетальныеЗаписи.ПроцентЭффективностиОтдела;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ЗаполнитьНаСервереЭффективностьРаботы(МассивФизическихЛиц)
	
	//Запрос = Новый Запрос;
	//Запрос.Текст =
	//	"ВЫБРАТЬ
	//	|	ДолжностиСотрудниковСрезПоследних.ФизЛицо КАК ФизЛицо,
	//	|	НастройкиПоказателейЭффективностиСрезПоследних.Должность,
	//	|	НастройкиПоказателейЭффективностиСрезПоследних.Сумма
	//	|ИЗ
	//	|	РегистрСведений.ДолжностиСотрудников.СрезПоследних(&ОкончаниеПериода, Подразделение = &Подразделение) КАК ДолжностиСотрудниковСрезПоследних
	//	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиПоказателейЭффективности.СрезПоследних(
	//	|				&ОкончаниеПериода,
	//	|				Подразделение = &Подразделение
	//	|					И КлючевойПоказательЭффективности = &КлючевойПоказательЭффективности) КАК НастройкиПоказателейЭффективностиСрезПоследних
	//	|		ПО ДолжностиСотрудниковСрезПоследних.Подразделение = НастройкиПоказателейЭффективностиСрезПоследних.Подразделение
	//	|			И ДолжностиСотрудниковСрезПоследних.Должность = НастройкиПоказателейЭффективностиСрезПоследних.Должность
	//	|ГДЕ
	//	|	ДолжностиСотрудниковСрезПоследних.Работает
	//	|	И ДолжностиСотрудниковСрезПоследних.ФизЛицо В(&МассивФизическихЛиц)";
	//
	//Запрос.УстановитьПараметр("КлючевойПоказательЭффективности", Справочники.КлючевыеПоказателиЭффективности.ЭффективностьРаботы);
	//Запрос.УстановитьПараметр("ОкончаниеПериода", Объект.ОкончаниеПериода);
	//Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	//Запрос.УстановитьПараметр("МассивФизическихЛиц", МассивФизическихЛиц);
	
	//РезультатЗапроса = Запрос.Выполнить();
	//ТЗ = РезультатЗапроса.Выгрузить();
	//МассивСотрудников = ТЗ.ВыгрузитьКолонку("ФизЛицо");
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СтатусыСлужебныхЗаписок.Ответственный,
		|	КОЛИЧЕСТВО(СтатусыСлужебныхЗаписок.СлужебнаяЗаписка) КАК КоличествоЗаписок
		|ИЗ
		|	РегистрСведений.СтатусыСлужебныхЗаписок КАК СтатусыСлужебныхЗаписок
		|ГДЕ
		|	СтатусыСлужебныхЗаписок.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСлужебнойЗаписки.Просрочена)
		|	И СтатусыСлужебныхЗаписок.Ответственный В(&МассивСотрудников)
		|
		|СГРУППИРОВАТЬ ПО
		|	СтатусыСлужебныхЗаписок.Ответственный";
	
	Запрос.УстановитьПараметр("МассивСотрудников", МассивФизическихЛиц);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	СтруктураНарушений = Новый Структура;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СтруктураНарушений.Вставить("Сотрудник", ВыборкаДетальныеЗаписи.Ответственный);
		СтруктураНарушений.Вставить("КоличествоЗаписок", ВыборкаДетальныеЗаписи.КоличествоЗаписок);
		//Для каждого Строка Из ТЗ Цикл
		//
		//	Если Строка.ФизЛицо = ВыборкаДетальныеЗаписи.Ответственный Тогда
		//		
		//		ТЗ.Удалить(Строка);
		//		
		//	КонецЕсли;
		//
		//КонецЦикла;
		
	КонецЦикла;
	
	Возврат СтруктураНарушений;
		
КонецФункции

&НаСервере
Процедура ЗаполнитьНаСервереДизайнеры()
	
	Подразделение = Объект.Подразделение;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ДатаНачала", Объект.НачалоПериода);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДолжностиСотрудниковСрезПоследних.ФизЛицо КАК Дизайнер,
		|	ДолжностиСотрудниковСрезПоследних.Должность,
		|	ШтатноеРасписаниеСрезПоследних.Оклад
		|ИЗ
		|	РегистрСведений.ДолжностиСотрудников.СрезПоследних(
		|			&ДатаНачала,
		|			Подразделение = &Подразделение
		|				И Должность = ЗНАЧЕНИЕ(Справочник.Должности.ДизайнерКонсультант)
		|				И Работает) КАК ДолжностиСотрудниковСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтатноеРасписание.СрезПоследних(
		|				&ДатаНачала,
		|				Подразделение = &Подразделение
		|					И Должность = ЗНАЧЕНИЕ(Справочник.Должности.ДизайнерКонсультант)) КАК ШтатноеРасписаниеСрезПоследних
		|		ПО ДолжностиСотрудниковСрезПоследних.Подразделение = ШтатноеРасписаниеСрезПоследних.Подразделение
		|			И ДолжностиСотрудниковСрезПоследних.Должность = ШтатноеРасписаниеСрезПоследних.Должность";
		
		ВыборкаПоДизайнерам = Запрос.Выполнить().Выбрать();
		ВидыПараметровНачислений = Перечисления.ВидыПараметровНачислений;
		
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(ВидыПараметровНачислений.ВыплатаДизайнерамЗаКухню);
		МассивПараметров.Добавить(ВидыПараметровНачислений.ВыплатаДизайнерамЗаШкаф);
		МассивПараметров.Добавить(ВидыПараметровНачислений.ВыплатаДизайнерамЗаЗамеры);
		МассивПараметров.Добавить(ВидыПараметровНачислений.ВыплатаДизайнерамЗаПеревыполнениеПлана);
		ТаблицаПараметров = ЛексСервер.ПолучитьЗначениеПараметров(МассивПараметров, Подразделение, Объект.НачалоПериода);
		
		НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.ВыплатаДизайнерамЗаКухню);
		НачислениеЗаКухню = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
		НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.ВыплатаДизайнерамЗаШкаф);
		НачислениеЗаШкаф = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
		НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.ВыплатаДизайнерамЗаЗамеры);
		НачислениеЗамерСверхПлана = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
		НайденнаяСтрока = ТаблицаПараметров.Найти(ВидыПараметровНачислений.ВыплатаДизайнерамЗаПеревыполнениеПлана);
		НачислениеЗаВыручкуСверхПлана = ?(ЗначениеЗаполнено(НайденнаяСтрока), НайденнаяСтрока.Значение, 0);;
		
		Пока ВыборкаПоДизайнерам.Следующий() Цикл
			
			Зарплата = 0;
			Дизайнер = ВыборкаПоДизайнерам.Дизайнер;
			
			СтруктураПоказателейДизайнера = Документы.НачислениеЗаработнойПлаты.ПолучитьПоказателиДизайнера(Объект.НачалоПериода, Объект.ОкончаниеПериода, Дизайнер, Объект.Подразделение);
			Оклад = ВыборкаПоДизайнерам.Оклад;
			ПланПоЗамерам = ?(СтруктураПоказателейДизайнера.Свойство("КоличествоПлановыхЗамеров") и ЗначениеЗаполнено(СтруктураПоказателейДизайнера.КоличествоПлановыхЗамеров), СтруктураПоказателейДизайнера.КоличествоПлановыхЗамеров, 0);
			ФактПоЗамерам = ?(СтруктураПоказателейДизайнера.Свойство("КоличествоФактическихЗамеров") и ЗначениеЗаполнено(СтруктураПоказателейДизайнера.КоличествоФактическихЗамеров), СтруктураПоказателейДизайнера.КоличествоФактическихЗамеров, 0);
			ПланПоВыручке = ?(СтруктураПоказателейДизайнера.Свойство("ПлановаяВыручкаПоДоговорам") и ЗначениеЗаполнено(СтруктураПоказателейДизайнера.ПлановаяВыручкаПоДоговорам), СтруктураПоказателейДизайнера.ПлановаяВыручкаПоДоговорам, 0);
			ФактПоВыручке = ?(СтруктураПоказателейДизайнера.Свойство("ФактическаяВыручкаПоДоговорам") и ЗначениеЗаполнено(СтруктураПоказателейДизайнера.ФактическаяВыручкаПоДоговорам), СтруктураПоказателейДизайнера.ФактическаяВыручкаПоДоговорам, 0);
			КоличествоКухонь = ?(СтруктураПоказателейДизайнера.Свойство("КоличествоКухонь") и ЗначениеЗаполнено(СтруктураПоказателейДизайнера.КоличествоКухонь), СтруктураПоказателейДизайнера.КоличествоКухонь, 0);
			КоличествоШкафов = ?(СтруктураПоказателейДизайнера.Свойство("КоличествоШкафов") и ЗначениеЗаполнено(СтруктураПоказателейДизайнера.КоличествоШкафов), СтруктураПоказателейДизайнера.КоличествоШкафов, 0);
			ФактЗаключенныхДоговоров = ?(СтруктураПоказателейДизайнера.Свойство("КоличествоФактическиЗаключенныхДоговоров") и ЗначениеЗаполнено(СтруктураПоказателейДизайнера.КоличествоФактическиЗаключенныхДоговоров), СтруктураПоказателейДизайнера.КоличествоФактическиЗаключенныхДоговоров, 0);
			ОплачиваемыеЗамеры = Окр(ФактЗаключенныхДоговоров, 0, РежимОкругления.Окр15как10);
			
			Если ОплачиваемыеЗамеры > 0 Тогда
				
				Зарплата = Зарплата + ОплачиваемыеЗамеры * НачислениеЗамерСверхПлана;
				
			КонецЕсли;
			
			Зарплата = ?(КоличествоШкафов> 0 или КоличествоКухонь >0, Зарплата + КоличествоШкафов * НачислениеЗаШкаф + КоличествоКухонь * НачислениеЗаКухню, Зарплата);
			Зарплата = ?(ФактПоВыручке - ПланПоВыручке > 0, Зарплата + НачислениеЗаВыручкуСверхПлана, Зарплата);
			
			Если Зарплата < Оклад Тогда
			
				Зарплата = Оклад;
			
			КонецЕсли;
			
			Если ПланПоВыручке > 0 Тогда
			
				ПроцентВыполненияПлана = Окр(ФактПоВыручке * 100 / ПланПоВыручке, 2);
			
			Иначе
			
				ПроцентВыполненияПлана = "План не установлен";
			
			КонецЕсли;
			
			Комментарий = "Оклад=" + Оклад + ", замеров сверх плана=" + ОплачиваемыеЗамеры + ", кухонь=" + КоличествоКухонь + ", шкафов=" + 
				КоличествоШкафов + ", процент выполнения плана=" + (ПроцентВыполненияПлана);
			ДобавитьСтрокуТабЧасти(Дизайнер, Справочники.СтатьиДоходовРасходов.РасходыЗарплатаЗамерыИАктивныеПродажи, Зарплата, Комментарий);
			
		КонецЦикла;
	
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
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОбороты.Субконто2 КАК Монтажник,
	|	УправленческийОбороты.Субконто1 КАК Показатель,
	|	УправленческийОбороты.СуммаОборот КАК Количество
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
	|			) КАК УправленческийОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Монтажник";
	
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
			
		ИначеЕсли Выборка.Показатель = ВидыПоказателейСотрудников.ОбзвонНормально Тогда
			
			Сумма = Выборка.Количество * СтавкиМонтажников.МонтажникуОбзвонНормально;
			Комментарий = "За обзвон без нареканий - " + Выборка.Количество + " шт.";
			
		ИначеЕсли Выборка.Показатель = ВидыПоказателейСотрудников.ОбзвонХорошо Тогда
			
			Сумма = Выборка.Количество * СтавкиМонтажников.МонтажникуОбзвонХорошо;
			Комментарий = "За положительный отзыв в обзвоне - " + Выборка.Количество + " шт.";
			
		КонецЕсли;
		
		ДобавитьСтрокуТабЧасти(Выборка.Монтажник, Справочники.СтатьиДоходовРасходов.РасходыЗарплатаМонтаж, Сумма, Комментарий);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервереПоОкладу()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("НачалоПериода", Объект.НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода", Объект.ОкончаниеПериода);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДолжностиСотрудниковСрезПоследних.ФизЛицо,
	|	ДолжностиСотрудниковСрезПоследних.Должность,
	|	ШтатноеРасписаниеСрезПоследних.Оклад
	|ИЗ
	|	РегистрСведений.ДолжностиСотрудников.СрезПоследних(&НачалоПериода, Подразделение = &Подразделение) КАК ДолжностиСотрудниковСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтатноеРасписание.СрезПоследних(&НачалоПериода, Подразделение = &Подразделение) КАК ШтатноеРасписаниеСрезПоследних
	|		ПО (ШтатноеРасписаниеСрезПоследних.Должность = ДолжностиСотрудниковСрезПоследних.Должность)
	|ГДЕ
	|	ДолжностиСотрудниковСрезПоследних.Работает";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		

		ДобавитьСтрокуТабЧасти(Выборка.ФизЛицо, Неопределено, Выборка.Оклад);
		
	КонецЦикла;
	
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

