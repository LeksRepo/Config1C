﻿
//Функция ПолучитьОсновнойЦвет(Спецификация)	
//	
//	Запрос = Новый Запрос;
//	
//	Запрос.УстановитьПараметр("Спецификация", Спецификация);
//	Запрос.УстановитьПараметр("Группа", Справочники.НоменклатурныеГруппы.ЛДСП);
//	
//	Запрос.Текст =
//		"ВЫБРАТЬ
//		|	СпецификацияСписокМатериалы.ВысотаДетали КАК ВысотаДетали,
//		|	СпецификацияСписокМатериалы.Количество КАК Количество,
//		|	СпецификацияСписокМатериалы.Номенклатура КАК Номенклатура,
//		|	СпецификацияСписокМатериалы.ШиринаДетали КАК ШиринаДетали
//		|ИЗ
//		|	Документ.Спецификация.СписокМатериалы КАК СпецификацияСписокМатериалы
//		|ГДЕ
//		|	СпецификацияСписокМатериалы.Ссылка = &Спецификация
//		|	И СпецификацияСписокМатериалы.Номенклатура.НоменклатурнаяГруппа В ИЕРАРХИИ(&Группа)
//		|
//		|УПОРЯДОЧИТЬ ПО
//		|	Номенклатура";
//		
//	РезультатЗапроса = Запрос.Выполнить();
//	
//	Если РезультатЗапроса.Пустой() Тогда
//		
//		ОсновнойЦвет = "В спецификации отсутствует ЛДСП";
//			
//	Иначе
//		Выборка = РезультатЗапроса.Выбрать();
//		
//		ПредыдущийЭлемент = "";
//		Номенклатуры = Новый Соответствие;
//		
//		Пока Выборка.Следующий() Цикл
//			
//			ПлощадьДетали = Выборка.ВысотаДетали * Выборка.ШиринаДетали * Выборка.Количество; 
//			
//			Если ПредыдущийЭлемент = Выборка.Номенклатура Тогда			
//				ОбщаяПлощадьНоменклатуры = ОбщаяПлощадьНоменклатуры + ПлощадьДетали;			
//			Иначе			
//				ОбщаяПлощадьНоменклатуры = ПлощадьДетали;
//			КонецЕсли;
//			
//			Номенклатуры.Вставить(Выборка.Номенклатура, ОбщаяПлощадьНоменклатуры);
//			ПредыдущийЭлемент=Выборка.Номенклатура;
//			
//		КонецЦикла;
//				
//		МаксПлощадь = 0;
//		
//		Для Каждого Элемент Из Номенклатуры Цикл
//			
//			Если Элемент.Значение > МаксПлощадь Тогда
//				МаксПлощадь = Элемент.Значение;
//				ОсновнойЦвет = Элемент.Ключ;		
//			КонецЕсли;
//			
//		КонецЦикла;
//		
//		ОсновнойЦвет = Сред(ОсновнойЦвет, 13); // первые 12 символов это "ЛДСП хх мм. " 
//		
//	КонецЕсли;
//		
//	Возврат ОсновнойЦвет;	

//КонецФункции

&НаКлиенте
Процедура СпецификацияПриИзменении(Элемент)
	Спецификация = Объект.Спецификация;	
	ПерезаполнитьНаСервере(Спецификация);
	//ЭтаФорма.Элементы.ОсновнойЦвет.Заголовок = "Основной цвет: " + ПолучитьОсновнойЦвет(Спецификация);
	//ЭтаФорма.Элементы.ОсновнойЦвет.Видимость = Истина;
КонецПроцедуры

&НаКлиенте
Процедура Перезаполнить(Команда)
	
	Ошибки 				= Неопределено;
	Спецификация 	= Объект.Спецификация;
	
	Если НЕ ЗначениеЗаполнено(Объект.Подразделение) Тогда
		
		ТекстСообщения = "Не выбрано подразделение";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Подразделение", ТекстСообщения);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Спецификация) Тогда
		
		ТекстСообщения = "Не выбрана спецификация";
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Спецификация", ТекстСообщения);
		
	КонецЕсли;
	
	Если Ошибки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		Возврат;
		
	КонецЕсли;
	
	ПерезаполнитьНаСервере(Спецификация);
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьНаСервере(СпецификацияСсылка)
	
	Объект.СписокНоменклатуры.Очистить();
	
	Выборка = Документы.Спецификация.ПерезаполнитьКомплектацию(СпецификацияСсылка);
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.СписокНоменклатуры.Добавить();
		НоваяСтрока.Номенклатура = Выборка.Номенклатура;
		НоваяСтрока.КоличествоСклад = Выборка.КоличествоСклад;
		НоваяСтрока.КоличествоЦех = Выборка.КоличествоЦех;
		
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
