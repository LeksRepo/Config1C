﻿
&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Подразделение", Подразделение);
	ПараметрыОтчета.Вставить("ПериодОтчета", ПериодОтчета);
	ПараметрыОтчета.Вставить("Ответственный", Ответственный);
	ПараметрыОтчета.Вставить("Основание", Основание);
	
	ТабДок = Отчеты.ЗамерыИВстречи.СформироватьОтчет(ПараметрыОтчета);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Подразделение") Тогда
		Подразделение = Параметры.Подразделение;
	Иначе
		Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
		СвойствоПодразделение = ПланыВидовХарактеристик.НастройкиПользователей.Подразделение;
		Отбор = Новый Структура("Пользователь, Настройка", Пользователь , СвойствоПодразделение);
		Подразделение = РегистрыСведений.НастройкиПользователей.Получить(Отбор).Значение;
	КонецЕсли;
	
	Если Параметры.Свойство("Ответственный") Тогда
		Ответственный = Параметры.Ответственный;
	КонецЕсли;
	
	Если Параметры.Свойство("Основание") Тогда
		Основание = Параметры.Основание;
	КонецЕсли;
	
	Если Параметры.Свойство("ФормаСпецификации") Тогда
		Владелец = Параметры.ФормаСпецификации;
	КонецЕсли;
	
	ПериодОтчета = Новый СтандартныйПериод(ВариантСтандартногоПериода.ЭтаНеделя);
	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		Если Расшифровка.Ссылка <> Null Тогда
			Если ТипЗнч(Расшифровка.Ссылка) = Тип("ДокументСсылка.Замер") Тогда
				ОткрытьФорму("Документ.Замер.ФормаОбъекта", Новый Структура("Ключ", Расшифровка.Ссылка), ЭтаФорма);
			ИначеЕсли ТипЗнч(Расшифровка.Ссылка) = Тип("ДокументСсылка.ВстречаСКлиентом") Тогда
				ОткрытьФорму("Документ.ВстречаСКлиентом.ФормаОбъекта", Новый Структура("Ключ", Расшифровка.Ссылка), ЭтаФорма);
			ИначеЕсли ТипЗнч(Расшифровка.Ссылка) = Тип("ДокументСсылка.Монтаж") Тогда
				НашДоговор = НайтиДоговр(Расшифровка.Ссылка);
				ОткрытьЗначение(НашДоговор);
			КонецЕсли;
			//littox Литус Антон - 13.08.2014
			//Если отчет открыт из спецификации то создавать можно только замер,
			//может немного костыльный способ определения владельца
			//13.08.2014 - littox Литус Антон 
			//
		ИначеЕсли Владелец = "ФормаСпецификации" Тогда
			
			ПараметрыФормы = Новый Структура("Время, ДокументОснование, Замерщик, АдресЗамера", Расшифровка.Время, Расшифровка.Основание, Расшифровка.Ответственный, "Введите адрес");
			ОткрытьФорму("Документ.Замер.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);	
			
		Иначе				
			
			СписокКнопок = Новый СписокЗначений;
			ВидЗамера = ?(ЗначениеЗаполнено(Расшифровка.Основание), "Перезамер", "Замер");
			СписокКнопок.Добавить(КодВозвратаДиалога.Да, ВидЗамера);
			СписокКнопок.Добавить(КодВозвратаДиалога.Нет, "Встреча");
			СписокКнопок.Добавить(КодВозвратаДиалога.Отмена);
			
			Текст = Новый ФорматированнаяСтрока("Основание: " + Расшифровка.Основание, Новый Шрифт(,,Истина));
			
			Ответ = Вопрос(Текст, СписокКнопок);
			
			Если Ответ = КодВозвратаДиалога.Да Тогда
				
				ПараметрыФормы = Новый Структура("Время, ДокументОснование, Замерщик, АдресЗамера", Расшифровка.Время, Расшифровка.Основание, Расшифровка.Ответственный, "Введите адрес");
				ОткрытьФорму("Документ.Замер.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
				
			ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
				
				ПараметрыФормы = Новый Структура("Время, ДокументОснование, Подразделение, Ответственный", Расшифровка.Время, Расшифровка.Основание, Расшифровка.Подразделение, Расшифровка.Ответственный);
				ОткрытьФорму("Документ.ВстречаСКлиентом.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
				
			КонецЕсли;				
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(Основание) Тогда
		СформироватьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ДокументСсылка.ВстречаСКлиентом") ИЛИ ТипЗнч(ВыбранноеЗначение) = Тип("ДокументСсылка.Замер") Тогда 
		
		СформироватьНаСервере();
		//littox Литус Антон - 13.08.2014
		//Если отчет открыт из спецификации то после выбора можно сразу закрывать отчет
		//
		//13.08.2014 - littox Литус Антон 
		//
		Если Владелец = "ФормаСпецификации" Тогда
			ОповеститьОВыборе(ВыбранноеЗначение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры



&НаСервереБезКонтекста
Функция НайтиДоговр(Монтаж)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Монтаж", Монтаж);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Договор.Ссылка
	|ИЗ
	|	Документ.Монтаж КАК Монтаж
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Договор КАК Договор
	|		ПО Монтаж.Спецификация = Договор.Спецификация
	|ГДЕ
	|	Монтаж.Ссылка = &Монтаж";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	Возврат Выборка.Ссылка;
	Выборка.Сбросить();
	
КонецФункции 
