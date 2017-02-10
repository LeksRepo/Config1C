﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Для Каждого Документ Из ПараметрКоманды Цикл
		
		Массив = Новый Массив;
		Массив.Добавить(Документ);
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ФиксированныйКомплект", Ложь); 
		ПараметрыПечати.Вставить("ПереопределитьПользовательскиеНастройкиКоличества", Истина);
		
		МассивМакетов = ОпределитьМакеты(Документ);
		
		ЕстьЧертежДвери = Ложь;
		
		Для каждого Элемент Из МассивМакетов Цикл
			Если Элемент = "ЧертежДвери" Тогда
				ЕстьЧертежДвери = Истина;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
		
		Если ЕстьЧертежДвери Тогда
			
			ДляФлэш = ПолучитьДанныеДвериДляФлэш(Документ);
			Картинки = Новый Массив;
			
			Сч = 0;
			
			Пока Сч < ДляФлэш.МассивСтрок.Количество() Цикл

				//Массивы потому что форма флэш хочет массивы а не строки, а флэшка не может печатать массивы дверей. //RonEXI edit
				МассивСтрок = Новый Массив;
				МассивСтрок.Добавить(ДляФлэш.МассивСтрок[Сч]);
				
				МассивСсылок = Новый Массив;
				МассивСсылок.Добавить(ДляФлэш.МассивСсылок[Сч]);
				
				
				ПараметрыФормыФлэш = Новый Структура;
				ПараметрыФормыФлэш.Вставить("ХранимыйФайл", "ЧертежДвери");
				ПараметрыФормыФлэш.Вставить("МассивДверейФлэш", МассивСтрок);
				ПараметрыФормыФлэш.Вставить("МассивДверейСсылки", МассивСсылок);
				ПараметрыФормыФлэш.Вставить("Спецификация", Документ);
				ПараметрыФормыФлэш.Вставить("Договор", Неопределено);
				
				КартинкаДвери = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормыФлэш);
				Картинки.Добавить(КартинкаДвери);
				
				Сч = Сч+1;
				
			КонецЦикла;
			
			ПараметрыПечати.Вставить("КартинкиДвери", Картинки);
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(МассивМакетов) Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Спецификация", СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(МассивМакетов), Массив, ПараметрыВыполненияКоманды.Источник, ПараметрыПечати);
		Иначе
			Предупреждение("Документы на печать отсутствуют!");
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеДвериДляФлэш(Документ)
	
	МассивСтрок = Новый Массив;
	МассивСсылок = Новый Массив;
	
	Для каждого Строка Из Документ.СписокДверей Цикл
		
		МассивСтрок.Добавить(Строка.Двери.СтрокаДляФлэш);
		МассивСсылок.Добавить(Строка.Двери);
		
	КонецЦикла; 
	
	Стр = Новый Структура;
	Стр.Вставить("МассивСтрок", МассивСтрок);
	Стр.Вставить("МассивСсылок", МассивСсылок);
	
	Возврат Стр;
	
КонецФункции

&НаСервере
Функция ОпределитьМакеты(Документ)
	
	МассивМакетов = Новый Массив;
	
	НаборЗаписей = ПолучитьДанныеРаскрой(Документ);
	ДанныеРаскрой = Неопределено;
	
	Если НаборЗаписей.Количество() > 0 Тогда
		ДанныеРаскрой = НаборЗаписей[0];	
	КонецЕсли;
	
	МассивМакетов.Добавить("СпецификацияФРС");
	
	Если (ДанныеРаскрой <> Неопределено) И ЗначениеЗаполнено(ДанныеРаскрой.СтрокаРаскрой) Тогда	
		МассивМакетов.Добавить("Раскрой");
	КонецЕсли;
	
	Если (ДанныеРаскрой <> Неопределено) И ЗначениеЗаполнено(ДанныеРаскрой.СтрокаКривогоПилаФРС) Тогда
		МассивМакетов.Добавить("КриволинейныеДеталиФРС");
	КонецЕсли;
	
	МассивМакетов.Добавить("СпецификацияСтекольная");
	
	Если (ДанныеРаскрой <> Неопределено) И ЗначениеЗаполнено(ДанныеРаскрой.СтрокаКривогоПилаСтеколка) Тогда
		МассивМакетов.Добавить("КриволинейныеДеталиСтеколка");
	КонецЕсли;

	Если Документ.СписокДверей.Количество() > 0 Тогда
	
		МассивМакетов.Добавить("ЧертежДвери");
		
	КонецЕсли;
	
	МассивМакетов.Добавить("СпецификацияСборка");
	
	Если Документ.СписокИзделийПоКаталогу.Количество() > 0 Тогда
	
		Если Документ.СписокИзделийПоКаталогу[0].Изделие.ВидИзделияПоКаталогу = Справочники.ВидыИзделийПоКаталогу.КухняВерхний
			ИЛИ Документ.СписокИзделийПоКаталогу[0].Изделие.ВидИзделияПоКаталогу = Справочники.ВидыИзделийПоКаталогу.КухняНижний
			ИЛИ Документ.СписокИзделийПоКаталогу[0].Изделие.ВидИзделияПоКаталогу = Справочники.ВидыИзделийПоКаталогу.КорпуснаяМебель Тогда
			МассивМакетов.Добавить("ИзделиеПоКаталогу");
		Иначе
			МассивМакетов.Добавить("ШкафПоКаталогу");
		КонецЕсли;
		
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Документ", Документ);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Файлы.ВидФайла
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|ГДЕ
	|	(ВЫРАЗИТЬ(Файлы.ВладелецФайла КАК Документ.Спецификация)) = &Документ
	|	И (Файлы.ВидФайла = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.Эскиз)
	|			ИЛИ Файлы.ВидФайла = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.ЦеховаяСхема))
	|	И НЕ Файлы.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДобавитьЭскиз = Ложь;
	ДобавитьЦеховаяСхема = Ложь;
	
	ВидЭскиз = ПредопределенноеЗначение("Перечисление.ВидыПрисоединенныхФайлов.Эскиз");
	ВидЦеховаяСхема = ПредопределенноеЗначение("Перечисление.ВидыПрисоединенныхФайлов.ЦеховаяСхема");
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ДобавитьЭскиз Тогда
			ДобавитьЭскиз = Выборка.ВидФайла = ВидЭскиз;
		КонецЕсли;	
		
		Если НЕ ДобавитьЦеховаяСхема Тогда
			ДобавитьЦеховаяСхема = Выборка.ВидФайла = ВидЦеховаяСхема;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДобавитьЭскиз Тогда
		//МассивМакетов.Добавить("Эскиз");
	КонецЕсли;
	
	Если ДобавитьЦеховаяСхема Тогда
		МассивМакетов.Добавить("ЦеховаяСхема");
	КонецЕсли;
	
	//RonEXI: Дима сказал не печатать
	//МассивМакетов.Добавить("СпецификацияОТК");
	
	МассивМакетов.Добавить("АктГотовности");
	
	Если Документ.Упаковка Тогда		
		МассивМакетов.Добавить("УпаковочныйЛист");
	КонецЕсли;
	
	Возврат МассивМакетов;
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеРаскрой(Документ)
	
	НаборЗаписей = РегистрыСведений.РаскройДеталей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Документ);
	
	НаборЗаписей.Прочитать();
		
	Возврат НаборЗаписей;
	
КонецФункции



