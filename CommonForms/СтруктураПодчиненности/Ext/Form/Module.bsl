﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ОбъектОтбора", ДокументСсылка);
	
	ИсходныйДокумент = ДокументСсылка;
	
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
		ОбновитьДеревоСтруктурыПодчиненности();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ТаблицаОтчета.Показать();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Обновить(Команда)
	
	ВывестиСтруктуруПодчиненности();
	ТаблицаОтчета.Показать();
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиДляТекущего(Команда)
	
	ТекущийДокумент = Элементы.ТаблицаОтчета.ТекущаяОбласть.Расшифровка;
	
	Если ЗначениеЗаполнено(ТекущийДокумент) Тогда
		ДокументСсылка = ТекущийДокумент;
	Иначе
		Возврат;
	КонецЕсли;
	
	ВывестиСтруктуруПодчиненности();
	ТаблицаОтчета.Показать();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

//////////////////////////////////////////////////////////////////////////////////////////////
// Процедуры вывода в табличный документ.

// Выводит дерево подчиненности в табличный документ
&НаСервере
Процедура ВывестиТабличныйДокумент()

	ТаблицаОтчета.Очистить();
	
	Макет = ПолучитьОбщийМакет("СтруктураПодчиненности");
	
	ВывестиРодительскиеЭлементыДерева(ДеревоРодительскиеДокументы.ПолучитьЭлементы(),Макет,1);
	ВывестиТекущийДокумент(Макет);
	ВывестиПодчиненныеЭлементыДерева(ДеревоПодчиненныеДокументы.ПолучитьЭлементы(),Макет,1)
	
КонецПроцедуры

// Выводит строки дерева родительских документов
//
// Параметры
//  СтрокиДерева  - ДанныеФормыКоллекцияЭлементовДерева - строки дерева
//                 которые выводятся в табличный документ
//  Макет  - МакетТабличногоДокумента - макет, на основании которого
//           происходит вывод в табличный документ
//  УровеньРекурсии - Число - уровень рекурсии процедуры
//
&НаСервере
Процедура ВывестиРодительскиеЭлементыДерева(СтрокиДерева,Макет,УровеньРекурсии)
	
	Счетчик =  СтрокиДерева.Количество();
	Пока Счетчик >0 Цикл
		
		ТекущаяСтрокаДерева = СтрокиДерева.Получить(Счетчик -1);
		ПодчиненныеЭлементыСтрокиДерева = ТекущаяСтрокаДерева.ПолучитьЭлементы();
		ВывестиРодительскиеЭлементыДерева(ПодчиненныеЭлементыСтрокиДерева,Макет,УровеньРекурсии + 1);
		
		Для инд=1 По УровеньРекурсии Цикл
			
			Если инд = УровеньРекурсии Тогда
				
				Если СтрокиДерева.Индекс(ТекущаяСтрокаДерева) < (СтрокиДерева.Количество()-1) Тогда
					Область = Макет.ПолучитьОбласть("КоннекторВерхПравоНиз");
				Иначе	
					Область = Макет.ПолучитьОбласть("КоннекторПравоНиз");
				КонецЕсли;
				
			Иначе
				
				Если НеобходимостьВыводаВертикальногоКоннектора(УровеньРекурсии - инд + 1,ТекущаяСтрокаДерева,Ложь) Тогда
					Область = Макет.ПолучитьОбласть("КоннекторВерхНиз");
				Иначе
					Область = Макет.ПолучитьОбласть("Отступ");
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если инд = 1 Тогда
				ТаблицаОтчета.Вывести(Область);
			Иначе
				ТаблицаОтчета.Присоединить(Область);
			КонецЕсли;
			
		КонецЦикла;
		
		ВывестиДокументИКартинку(ТекущаяСтрокаДерева,Макет,Ложь,Ложь);

		Счетчик = Счетчик - 1;
		
	КонецЦикла;
	
КонецПроцедуры

// Выводит в табличный документ картинку, соответствующую статусу документа и его представление
//
&НаСервере
Процедура ВывестиДокументИКартинку(СтрокаДерева,Макет,ЭтоТекущийДокумент = Ложь,ЭтоПодчиненный = Неопределено)
	
	//Вывод картинки
	Если СтрокаДерева.Проведен Тогда
		Если ЭтоПодчиненный = Неопределено  Тогда
			Если ДеревоПодчиненныеДокументы.ПолучитьЭлементы().Количество() И ДеревоРодительскиеДокументы.ПолучитьЭлементы().Количество()  Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерхНиз");
			ИначеЕсли ДеревоПодчиненныеДокументы.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторНиз");
			ИначеЕсли ДеревоРодительскиеДокументы.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерх");
			Иначе
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерх");
			КонецЕсли;
		ИначеЕсли ЭтоПодчиненный = Истина Тогда
			Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторЛевоНиз");
			Иначе
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведен");
			КонецЕсли;
		Иначе
			Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторЛевоВерх");
			Иначе
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведен");
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли СтрокаДерева.ПометкаУдаления Тогда
		Если ЭтоПодчиненный = Неопределено Тогда
			Если ДеревоПодчиненныеДокументы.ПолучитьЭлементы().Количество() И ДеревоРодительскиеДокументы.ПолучитьЭлементы().Количество()  Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерхНиз");
			ИначеЕсли ДеревоПодчиненныеДокументы.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУделениеКоннекторНиз");
			ИначеЕсли ДеревоРодительскиеДокументы.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерх");
			Иначе
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерх");
			КонецЕсли;
		ИначеЕсли ЭтоПодчиненный = Истина Тогда
			Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторЛевоНиз");
			Иначе
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдаление");
			КонецЕсли;
		Иначе
			Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторЛевоВерх");
			Иначе
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдаление");
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если СтрокаДерева.Ссылка = ДокументСсылка Тогда
			Если ДеревоПодчиненныеДокументы.ПолучитьЭлементы().Количество() И ДеревоРодительскиеДокументы.ПолучитьЭлементы().Количество()  Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерхНиз");
			ИначеЕсли ДеревоПодчиненныеДокументы.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторНиз");
			ИначеЕсли ДеревоРодительскиеДокументы.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерх");
			Иначе
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерх");
			КонецЕсли;
		ИначеЕсли ЭтоПодчиненный = Истина Тогда
			Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторЛевоНиз");
			Иначе
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписан");
			КонецЕсли;
		Иначе
			Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторЛевоВерх");
			Иначе
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписан");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если ЭтоТекущийДокумент Тогда
		ТаблицаОтчета.Вывести(ОбластьКартинка) 
	Иначе
		ТаблицаОтчета.Присоединить(ОбластьКартинка);
	КонецЕсли;
	
	
	//Вывод документа
	ОбластьДокумент = Макет.ПолучитьОбласть(?(ЭтоТекущийДокумент,"ТекущийДокумент","Документ"));
	ОбластьДокумент.Параметры.ПредставлениеДокумента = СтрокаДерева.Представление;
	ОбластьДокумент.Параметры.Документ = СтрокаДерева.Ссылка;
	ТаблицаОтчета.Присоединить(ОбластьДокумент);
	
КонецПроцедуры

// Определяет необходимость вывода вертикального коннектора в  табличный документ
//
// Параметры
//  УровеньВверх  - Число - на каком количестве уровней выше находится 
//                 родитель от которого будет рисоваться вертикальный коннектор
//  СтрокаДерева  - ДанныеФормыЭлементДерева - исходная строка дерева значений
//                  от которой ведется отсчет.
// Возвращаемое значение:
//   Булево   - необходимость вывода в области вертиркального коннекотора
//
&НаСервере
Функция НеобходимостьВыводаВертикальногоКоннектора(УровеньВверх,СтрокаДерева,ИщемСредиПодчиненных = Истина)
	
	ТекущаяСтрока = СтрокаДерева;
	
	Для инд=1 По УровеньВверх Цикл
		
		ТекущаяСтрока = ТекущаяСтрока.ПолучитьРодителя();
		Если инд = УровеньВверх Тогда
			ИскомыйРодитель = ТекущаяСтрока;
		ИначеЕсли инд = (УровеньВверх-1) Тогда
			ИскомаяСтрока = ТекущаяСтрока;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИскомыйРодитель = Неопределено Тогда
		Если ИщемСредиПодчиненных Тогда
			ПодчиненныеЭлементыРодителя =  ДеревоПодчиненныеДокументы.ПолучитьЭлементы(); 
		Иначе
			ПодчиненныеЭлементыРодителя =  ДеревоРодительскиеДокументы.ПолучитьЭлементы();
		КонецЕсли;
	Иначе
		ПодчиненныеЭлементыРодителя =  ИскомыйРодитель.ПолучитьЭлементы(); 
	КонецЕсли;
	
	Возврат ПодчиненныеЭлементыРодителя.Индекс(ИскомаяСтрока) < (ПодчиненныеЭлементыРодителя.Количество()-1);
	
КонецФункции

// Выводит в табличный документ строку с документом, для которого формируется структура подчиненности
//
// Параметры
//  Макет  - МакетТабличногоДокумента - макет, на основании которого формирутеся табличный документ.
&НаСервере
Процедура ВывестиТекущийДокумент(Макет)
	
	Выборка = ПолучитьВыборкуПоРеквизитамДокумента(ДокументСсылка);
	Если Выборка.Следующий() Тогда
		
		ПереопределяемоеПредставление = Неопределено;
		ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
			"СтандартныеПодсистемы.СтруктураПодчиненности\ПриПолученииПредставленияДокументаДляПечати");
		Для Каждого Обработчик Из ОбработчикиСобытия Цикл
			Обработчик.Модуль.ПриПолученииПредставленияДокументаДляПечати(Выборка, ПереопределяемоеПредставление);
		КонецЦикла;
		
		ПереопределяемоеПредставление = СтруктураПодчиненностиПереопределяемый.ПолучитьПредставлениеДокументаДляПечати(Выборка);
		
		Если ПереопределяемоеПредставление <> Неопределено Тогда
			СтруктураРеквизитов = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Выборка.Владелец().Выгрузить()[0]);
			СтруктураРеквизитов.Представление = ПереопределяемоеПредставление;
			ВывестиДокументИКартинку(СтруктураРеквизитов,Макет,Истина);
		Иначе
			СтруктураРеквизитов = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Выборка.Владелец().Выгрузить()[0]);
			СтруктураРеквизитов.Представление = ПолучитьПредставлениеДокументаДляПечати(СтруктураРеквизитов);
			ВывестиДокументИКартинку(СтруктураРеквизитов,Макет,Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует представление документа для вывода в табличный документ
//
// Параметры
//  Выборка  - ВыборкаИзРезультатаЗапроса или ДанныеФормыЭлементДерева - набор данных
//             на основании которого формируется представление
//
// Возвращаемое значение:
//   Строка   - сформированное представление
//
&НаСервере
Функция ПолучитьПредставлениеДокументаДляПечати(Выборка)
	
	ПредставлениеДокумента = Выборка.Представление;
	Если (Выборка.СуммаДокумента <> 0) И (Выборка.СуммаДокумента <> NULL) Тогда
		ПредставлениеДокумента = ПредставлениеДокумента + " " + НСтр("ru='на сумму'") + " " + Выборка.СуммаДокумента + " " + Выборка.Валюта + ".";
	КонецЕсли;
	
	Возврат ПредставлениеДокумента;
	
КонецФункции

// Выводит строки дерева подчиненных документов
//
// Параметры
//  СтрокиДерева  - ДанныеФормыКоллекцияЭлементовДерева - строки дерева
//                 которые выводятся в табличный документ
//  Макет  - МакетТабличногоДокумента - макет, на основании которого
//                 происходит вывод в табличный документ
//  УровеньРекурсии - Число - уровень рекурсии процедуры
//
&НаСервере
Процедура ВывестиПодчиненныеЭлементыДерева(СтрокиДерева,Макет,УровеньРекурсии)

	Для каждого СтрокаДерева Из СтрокиДерева Цикл
		
		ЭтоТекущийДокумент = (СтрокаДерева.Ссылка = ДокументСсылка);
		ЭтоИсходныйДокумент = (СтрокаДерева.Ссылка = ИсходныйДокумент);
		ПодчиненныеЭлементыДерева = СтрокаДерева.ПолучитьЭлементы();
		
		//Вывод коннекторов
		Для инд = 1 По УровеньРекурсии Цикл
			Если УровеньРекурсии > инд Тогда
				
				Если НеобходимостьВыводаВертикальногоКоннектора(УровеньРекурсии - инд + 1,СтрокаДерева) Тогда
					Область = Макет.ПолучитьОбласть("КоннекторВерхНиз");
				Иначе
					Область = Макет.ПолучитьОбласть("Отступ");
					
				КонецЕсли;
			Иначе 
				
				Если СтрокиДерева.Количество() > 1 И (СтрокиДерева.Индекс(СтрокаДерева)<> (СтрокиДерева.Количество()-1)) Тогда
					Область = Макет.ПолучитьОбласть("КоннекторВерхПравоНиз");
				Иначе
					Область = Макет.ПолучитьОбласть("КоннекторВерхПраво");
				КонецЕсли;
				
			КонецЕсли;	
			
			Область.Параметры.Документ = ?(ЭтоИсходныйДокумент,Неопределено,СтрокаДерева.Ссылка);
			
			Если инд = 1 Тогда
				ТаблицаОтчета.Вывести(Область);
			Иначе
				ТаблицаОтчета.Присоединить(Область);
			КонецЕсли;
			
		КонецЦикла;		
		
		ВывестиДокументИКартинку(СтрокаДерева,Макет,Ложь,Истина);
		
		//Вывод подчиненных элементов дерева
		ВывестиПодчиненныеЭлементыДерева(ПодчиненныеЭлементыДерева,Макет,УровеньРекурсии + 1);
		
	КонецЦикла;
	
КонецПроцедуры

//Инициирует вывод в табличный документ и отображает его по окончанию формирования.
&НаКлиенте
Процедура ВывестиСтруктуруПодчиненности()

	ОбновитьДеревоСтруктурыПодчиненности();
	ТаблицаОтчета.Показать();

КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////////
// Процедуры построения дерева подчиненности документов.

&НаСервере
Процедура ОбновитьДеревоСтруктурыПодчиненности()

	Если ОсновнойДокументДоступен() Тогда
		СформироватьДеревьяДокументов();
		ВывестиТабличныйДокумент();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Нстр("ru = 'Документ, для которого сформирован отчет о структуре подчиненности, стал недоступен.'"));
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СформироватьДеревьяДокументов()

	ДеревоРодительскиеДокументы.ПолучитьЭлементы().Очистить();
	ДеревоПодчиненныеДокументы.ПолучитьЭлементы().Очистить();

	ВывестиРодительскиеДокументы(ДокументСсылка,ДеревоРодительскиеДокументы);
	ВывестиПодчиненныеДокументы(ДокументСсылка,ДеревоПодчиненныеДокументы);

КонецПроцедуры

&НаСервере
Функция ОсновнойДокументДоступен()

	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	1
	|ИЗ
	|	Документ." + ДокументСсылка.Метаданные().Имя + " КАК Таб
	|ГДЕ
	|	Таб.Ссылка = &ТекущийДокумент
	|");
	Запрос.УстановитьПараметр("ТекущийДокумент", ДокументСсылка);
	Возврат Не Запрос.Выполнить().Пустой();

КонецФункции

// Получает выборку по реквизитам документа
//
// Параметры
//  ДокументСсылка  - ДокументСсылка - документ, значения реквзитов которого получаются запросом.
//
// Возвращаемое значение:
//   ВыборкаИзРезультатаЗапроса
//
&НаСервере
Функция ПолучитьВыборкуПоРеквизитамДокумента(ДокументСсылка)
	
	МетаданныеДокумента = ДокументСсылка.Метаданные();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Ссылка,
	|	Проведен,
	|	ПометкаУдаления,
	|	#Сумма,
	|	#Валюта,
	|	#Представление
	|ИЗ
	|	Документ." + МетаданныеДокумента.Имя + "
	|ГДЕ
	|	Ссылка = &Ссылка
	|";
	ЗаменитьТекстЗапроса(ТекстЗапроса, МетаданныеДокумента, "#Сумма", "СуммаДокумента");
	ЗаменитьТекстЗапроса(ТекстЗапроса, МетаданныеДокумента, "#Валюта", "Валюта");
	
	МассивДопРеквизитов = Новый Массив;
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.СтруктураПодчиненности\ПриФормированииМассиваДополнительныхРеквизитовДокумента");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриФормированииМассиваДополнительныхРеквизитовДокумента(МетаданныеДокумента.Имя, МассивДопРеквизитов);
	КонецЦикла;
	
	МассивДопРеквизитов = СтруктураПодчиненностиПереопределяемый.МассивДополнительныхРеквизитовДокумента(МетаданныеДокумента.Имя);
	
	ДополнитьТекстЗапросаПоРеквизитамДокумента(ТекстЗапроса, МассивДопРеквизитов);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Возврат Запрос.Выполнить().Выбрать(); 
	
КонецФункции

&НаСервере
Процедура ВывестиРодительскиеДокументы(ТекущийДокумент,ДеревоРодитель)

	СтрокиДерева = ДеревоРодитель.ПолучитьЭлементы();
	МетаданныеДокумента = ТекущийДокумент.Метаданные();
	СписокРеквизитов    = Новый СписокЗначений;
	
	Для Каждого Реквизит ИЗ МетаданныеДокумента.Реквизиты Цикл
		
		Если Метаданные.КритерииОтбора.СвязанныеДокументы.Состав.Содержит(Реквизит) Тогда
			
			Для Каждого ТекущийТип Из Реквизит.Тип.Типы() Цикл
				
				МетаданныеРеквизита = Метаданные.НайтиПоТипу(ТекущийТип);
				
				Если МетаданныеРеквизита <> Неопределено
					И Метаданные.Документы.Содержит(МетаданныеРеквизита)
					И ПравоДоступа("Чтение", МетаданныеРеквизита) Тогда
					
					ЗначениеРеквизита = ТекущийДокумент[Реквизит.Имя];
					
					Если ЗначениеЗаполнено(ЗначениеРеквизита)
						И ТипЗнч(ЗначениеРеквизита) = ТекущийТип
						И ЗначениеРеквизита <> ТекущийДокумент
						И СписокРеквизитов.НайтиПоЗначению(ЗначениеРеквизита) = Неопределено Тогда
						
						СписокРеквизитов.Добавить(ЗначениеРеквизита,Формат(ЗначениеРеквизита.Дата,"ДФ=yyyyMMddЧЧММсс"));
						
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;

	Для Каждого ТЧ Из МетаданныеДокумента.ТабличныеЧасти Цикл
		СтрРеквизитов = "";

		СодержимоеТЧ = ТекущийДокумент[ТЧ.Имя].Выгрузить();

		Для Каждого Реквизит Из ТЧ.Реквизиты Цикл

			Если Метаданные.КритерииОтбора.СвязанныеДокументы.Состав.Содержит(Реквизит) Тогда
				
				Для Каждого ТекущийТип Из Реквизит.Тип.Типы() Цикл
					
					МетаданныеРеквизита = Метаданные.НайтиПоТипу(ТекущийТип);
					
					Если МетаданныеРеквизита<>Неопределено
						И Метаданные.Документы.Содержит(МетаданныеРеквизита)
						И ПравоДоступа("Чтение", МетаданныеРеквизита) Тогда
						
						СтрРеквизитов = СтрРеквизитов + ?(СтрРеквизитов = "", "", ", ") + Реквизит.Имя;
						Прервать;
						
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;

		СодержимоеТЧ.Свернуть(СтрРеквизитов);
		Для Каждого КолонкаТЧ ИЗ СодержимоеТЧ.Колонки Цикл

			Для Каждого СтрокаТЧ ИЗ СодержимоеТЧ Цикл

				ЗначениеРеквизита = СтрокаТЧ[КолонкаТЧ.Имя];

				МетаданныеЗначения = Метаданные.НайтиПоТипу(ТипЗнч(ЗначениеРеквизита));
				Если МетаданныеЗначения <> Неопределено Тогда

					Если ЗначениеЗаполнено(ЗначениеРеквизита)
						И Метаданные.Документы.Содержит(МетаданныеЗначения)
						И ЗначениеРеквизита <> ТекущийДокумент
						И СписокРеквизитов.НайтиПоЗначению(ЗначениеРеквизита) = Неопределено Тогда

							СписокРеквизитов.Добавить(ЗначениеРеквизита,Формат(ЗначениеРеквизита.Дата,"ДФ=yyyyMMddЧЧММсс"));

					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;

	СписокРеквизитов.СортироватьПоПредставлению();
	
	Для каждого ЭлементСписка Из СписокРеквизитов Цикл
		
		Выборка = ПолучитьВыборкуПоРеквизитамДокумента(ЭлементСписка.Значение);
		
		Если Выборка.Следующий() Тогда
			СтрокаДерева = ДобавитьСтрокуВДерево(СтрокиДерева, Выборка);
			Если НЕ ДобавляемыйДокументИмеетсяСредиРодителей(ДеревоРодитель,ЭлементСписка.Значение) Тогда
				ВывестиРодительскиеДокументы(ЭлементСписка.Значение,СтрокаДерева);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Определяет наличие документа среди родителей строки дерева, которая возомжно будет добавлена
//
// Параметры
//  СтрокаРодитель  - ДанныеФормыДерево,ДанныеФормыЭлементДерева - родитель, для 
//                 которого предполагается добавить строку дерева.
//  ДокументСсылка  - Документ - документ, на наличие которого выполняется проверка
//
// Возвращаемое значение:
//   Булево   - Истина если найден, Ложь в обратном случае.
//
Функция ДобавляемыйДокументИмеетсяСредиРодителей(СтрокаРодитель,ИскомыйДокумент)
	
	Если ИскомыйДокумент = ДокументСсылка Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ТипЗнч(СтрокаРодитель) = Тип("ДанныеФормыДерево") Тогда
		Возврат Ложь; 
	КонецЕсли;
	
	ТекущийРодитель = СтрокаРодитель;
	Пока ТекущийРодитель <> Неопределено Цикл
		Если ТекущийРодитель.Ссылка = ИскомыйДокумент Тогда
		    Возврат Истина;
		КонецЕсли;
		ТекущийРодитель = ТекущийРодитель.ПолучитьРодителя();
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции


&НаСервере
Процедура ЗаменитьТекстЗапроса(ТекстЗапроса, МетаданныеДокумента, ЧтоЗаменять, ИмяРеквизита)

	Если МетаданныеДокумента.Реквизиты.Найти(ИмяРеквизита) <> Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ЧтоЗаменять, ИмяРеквизита + " КАК " + ИмяРеквизита);
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ЧтоЗаменять, " NULL КАК " + ИмяРеквизита);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ДополнитьКэшМетаданных(МетаданныеДокумента, ИмяДокумента,КэшРеквизитовДокумента)

	РеквизитыДокумента = КэшРеквизитовДокумента[ИмяДокумента];
	Если РеквизитыДокумента = Неопределено Тогда

		РеквизитыДокумента = Новый Соответствие;
		РеквизитыДокумента.Вставить("СуммаДокумента",  МетаданныеДокумента.Реквизиты.Найти("СуммаДокумента") <> Неопределено);
		РеквизитыДокумента.Вставить("Валюта",          МетаданныеДокумента.Реквизиты.Найти("Валюта") <> Неопределено);

		КэшРеквизитовДокумента.Вставить(ИмяДокумента, РеквизитыДокумента);

	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Функция ПолучитьСписокДокументовПоКритериюОтбора(ЗначениеКритерияОтбора)
	
	Если Метаданные.КритерииОтбора.СвязанныеДокументы.Тип.СодержитТип(ТипЗнч(ЗначениеКритерияОтбора))  Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СвязанныеДокументы.Ссылка
		|ИЗ
		|	КритерийОтбора.СвязанныеДокументы(&ЗначениеКритерияОтбора) КАК СвязанныеДокументы";
		
		Запрос.УстановитьПараметр("ЗначениеКритерияОтбора",ЗначениеКритерияОтбора);
		Возврат Запрос.Выполнить().Выгрузить();
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ВывестиПодчиненныеДокументы(ТекущийДокумент,ДеревоРодитель)
	
	СтрокиДерева = ДеревоРодитель.ПолучитьЭлементы();
	Таблица      = ПолучитьСписокДокументовПоКритериюОтбора(ТекущийДокумент);
	Если Таблица = Неопределено Тогда
		Возврат;
	КонецЕсли;

	КэшПоТипамДокументов   = Новый Соответствие;
	КэшРеквизитовДокумента = Новый Соответствие;

	Для Каждого СтрокаТаблицы ИЗ Таблица Цикл

		МетаданныеДокумента = СтрокаТаблицы.Ссылка.Метаданные();
		Если Не ПравоДоступа("Чтение", МетаданныеДокумента) Тогда
			Продолжить;
		КонецЕсли;

		ИмяДокумента = МетаданныеДокумента.Имя;
		ДополнитьКэшМетаданных(МетаданныеДокумента, ИмяДокумента,КэшРеквизитовДокумента);

		МассивСсылок = КэшПоТипамДокументов[ИмяДокумента];
		Если МассивСсылок = Неопределено Тогда

			МассивСсылок = Новый Массив;
			КэшПоТипамДокументов.Вставить(ИмяДокумента, МассивСсылок);

		КонецЕсли;

		МассивСсылок.Добавить(СтрокаТаблицы.Ссылка);

	КонецЦикла;
	
	ЕСли КэшПоТипамДокументов.Количество() = 0 ТОгда
		Возврат;
	КонецЕсли;

	ТекстЗапросаНачало = "ВЫБРАТЬ РАЗРЕШЕННЫЕ * ИЗ (";
	ТекстЗапросаКонец = ") КАК ПодчиненныеДокументы УПОРЯДОЧИТЬ ПО ПодчиненныеДокументы.Дата";

	Запрос = Новый Запрос;
	ТекстЗапроса = "";
	Для Каждого КлючИЗначение Из КэшПоТипамДокументов Цикл

		ТекстПоТипуДокумента = "
		|	Дата,
		|	Ссылка,
		|	Проведен,
		|	ПометкаУдаления,
		|" + ?(КэшРеквизитовДокумента[КлючИЗначение.Ключ]["СуммаДокумента"], "СуммаДокумента", "NULL") + " КАК СуммаДокумента,
		|" + ?(КэшРеквизитовДокумента[КлючИЗначение.Ключ]["Валюта"],         "Валюта", "NULL") + "         КАК Валюта,
		|	#Представление
		|ИЗ
		|	Документ." + КлючИЗначение.Ключ + "
		|ГДЕ
		|	Ссылка В (&" + КлючИЗначение.Ключ + ")";

		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		
		МассивДопРеквизитов = Новый Массив;
		ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
			"СтандартныеПодсистемы.СтруктураПодчиненности\ПриФормированииМассиваДополнительныхРеквизитовДокумента");
		Для Каждого Обработчик Из ОбработчикиСобытия Цикл
			Обработчик.Модуль.ПриФормированииМассиваДополнительныхРеквизитовДокумента(КлючИЗначение.Ключ, МассивДопРеквизитов);
		КонецЦикла;
		
		МассивДопРеквизитов = СтруктураПодчиненностиПереопределяемый.МассивДополнительныхРеквизитовДокумента(КлючИЗначение.Ключ);
		ДополнитьТекстЗапросаПоРеквизитамДокумента(ТекстПоТипуДокумента, МассивДопРеквизитов);
		
		ТекстЗапроса = ТекстЗапроса + ?(ТекстЗапроса = "", " ВЫБРАТЬ ", " ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ ") + ТекстПоТипуДокумента;

	КонецЦикла;

	Запрос.Текст = ТекстЗапросаНачало + ТекстЗапроса + ТекстЗапросаКонец;
	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ДобавитьСтрокуВДерево(СтрокиДерева, Выборка);
		Если НЕ ДобавляемыйДокументИмеетсяСредиРодителей(ДеревоРодитель,Выборка.Ссылка) Тогда
			ВывестиПодчиненныеДокументы(Выборка.Ссылка,НоваяСтрока)
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ДобавитьСтрокуВДерево(СтрокиДерева, Выборка)

	НоваяСтрока = СтрокиДерева.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка, "Ссылка, Представление, СуммаДокумента, Валюта, Проведен, ПометкаУдаления");
	
	ПереопределяемоеПредставление = Неопределено;
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.СтруктураПодчиненности\ПриПолученииПредставленияДокументаДляПечати");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриПолученииПредставленияДокументаДляПечати(Выборка, ПереопределяемоеПредставление);
	КонецЦикла;
	
	ПереопределенноеПредставление = СтруктураПодчиненностиПереопределяемый.ПолучитьПредставлениеДокументаДляПечати(Выборка);
	Если ПереопределенноеПредставление <> Неопределено Тогда
		НоваяСтрока.Представление = ПереопределенноеПредставление;
	Иначе
		НоваяСтрока.Представление = ПолучитьПредставлениеДокументаДляПечати(Выборка);
	КонецЕсли;
	
	Возврат НоваяСтрока;

КонецФункции

&НаСервере
Процедура ДополнитьТекстЗапросаПоРеквизитамДокумента(ТекстЗапроса, МассивРеквизитов)
	
	ТекстПредставление = "Представление КАК Представление";
	
	Для Инд = 1 По 3 Цикл
		
		ТекстПредставление = ТекстПредставление + ",
			                   |	" + ?(МассивРеквизитов.Количество() >= Инд,МассивРеквизитов[инд - 1],"NULL") + " Как ДополнительныйРеквизит" + Инд;
		
	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#Представление", ТекстПредставление);
	
КонецПроцедуры


