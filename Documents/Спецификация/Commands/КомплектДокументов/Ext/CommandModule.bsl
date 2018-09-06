﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Для Каждого Документ Из ПараметрКоманды Цикл
		
		Массив = Новый Массив;
		Массив.Добавить(Документ);
		
		Отказ = Ложь;
		
		ПараметрыРаскрой = ОбновитьРаскройНаСервере(Документ);
		ПолучитьИЗаписатьРаскрой(ПараметрыРаскрой);
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ФиксированныйКомплект", Ложь);
		ПараметрыПечати.Вставить("ПереопределитьПользовательскиеНастройкиКоличества", Истина);
		
		МассивМакетов = ОпределитьМакеты(Документ);
		
		Если МассивМакетов.Найти("ЧертежДвери") <> Неопределено Тогда
			
			ДляФлэш = ПолучитьДанныеДвериДляФлэш(Документ);
			Картинки = Новый Массив;
			
			Сч = 0;
			
			Пока Сч < ДляФлэш.МассивСтрок.Количество() Цикл
				
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
				
				Попытка
					КартинкаДвери = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормыФлэш);
					Картинки.Добавить(КартинкаДвери[0]);
				Исключение
					Сообщить("Ошибка печати двери.");
				КонецПопытки;
				
				Сч = Сч+1;
				
			КонецЦикла;
			
			ПараметрыПечати.Вставить("КартинкиДвери", Картинки);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(МассивМакетов) Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Спецификация", СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(МассивМакетов), Массив, ПараметрыВыполненияКоманды.Источник, ПараметрыПечати);
		Иначе
			Предупреждение("Документы на печать отсутствуют!");
		КонецЕсли;
		
		УдалитьРисунки(Документ);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРисунки(Документ)
	
	НаборЗаписей = РегистрыСведений.РаскройДеталей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Документ);
	
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 1 Тогда
		Запись = НаборЗаписей[0];
	Иначе
		Возврат;
	КонецЕсли;
	
	Запись.РисунокРаскроя = "";
	Запись.РисунокКривогоПилаФРС = "";
	Запись.РисунокКривогоПилаСтеколка = "";
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРаскрой(Элемент)
	
	Документы.Спецификация.ЗаписатьРаскрой(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИЗаписатьРаскрой(Элемент)
	
	НашаСпецификация = Элемент.Спецификация;
	ВидОтображения = ПолучитьВидОтображенияФлэш(НашаСпецификация);
	
	Если ЗначениеЗаполнено(Элемент.СтрокаКривогоПилаФРС) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ХранимыйФайл", "КривойПил");
		ПараметрыФормы.Вставить("Спецификация", НашаСпецификация);
		ПараметрыФормы.Вставить("СтрокаКривогоПила", Элемент.СтрокаКривогоПилаФРС);
		ПараметрыФормы.Вставить("ВидОтображения", ВидОтображения);
		
		Значение = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы);
		
		Элемент.РисунокКривогоПилаФРС = Значение;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Элемент.СтрокаКривогоПилаСтеколка) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ХранимыйФайл", "КривойПил");
		ПараметрыФормы.Вставить("Спецификация", НашаСпецификация);
		ПараметрыФормы.Вставить("СтрокаКривогоПила", Элемент.СтрокаКривогоПилаСтеколка);
		ПараметрыФормы.Вставить("ВидОтображения", ВидОтображения);
		
		Значение = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы);
		
		Элемент.РисунокКривогоПилаСтеколка = Значение;
		
	КонецЕсли;
	
	ВидОтображения = ПолучитьВидОтображенияРаскрой(НашаСпецификация);
	
	Если ЗначениеЗаполнено(Элемент.СтрокаРаскрой) И ВидОтображения = "1" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ХранимыйФайл", "НовыйРаскрой");
		ПараметрыФормы.Вставить("Спецификация", НашаСпецификация);
		ПараметрыФормы.Вставить("СтрокаНовогоРаскрояЛДСП", Элемент.СтрокаРаскрой);
		ПараметрыФормы.Вставить("ВидОтображения", ВидОтображения);
		
		Значение = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормы);
		
		Элемент.РисунокРаскроя = Значение;
		
	КонецЕсли;
	
	ЗаписатьРаскрой(Элемент);
	
КонецПроцедуры

&НаСервере
Функция ОбновитьРаскройНаСервере(Элемент)
	
	Возврат Документы.Спецификация.ОбновитьРаскройНаСервере(Элемент);
	
КонецФункции

&НаСервере
Функция ПолучитьВидОтображенияРаскрой(Спецификация) Экспорт
	
	Возврат Документы.Спецификация.ПолучитьВидОтображенияРаскрой(Спецификация);
	
КонецФункции

&НаСервере
Функция ПолучитьВидОтображенияФлэш(Спецификация) Экспорт
	
	Возврат Документы.Спецификация.ПолучитьВидОтображенияФлэш(Спецификация);
	
КонецФункции

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
	
	ТекущийСтатус = Документы.Спецификация.ПолучитьСтатусСпецификации(Документ);
	МассивМакетов = Новый Массив;
	
	НаборЗаписей = ПолучитьДанныеРаскрой(Документ);
	ДанныеРаскрой = Неопределено;
	
	Если НаборЗаписей.Количество() > 0 Тогда
		ДанныеРаскрой = НаборЗаписей[0];
	КонецЕсли;
	
	МассивМакетов.Добавить("АктГотовности");
	МассивМакетов.Добавить("ПечатьТорг12");
	
	Если Документ.Упаковка Тогда
		МассивМакетов.Добавить("УпаковочныйЛист");
	КонецЕсли;
	
	МассивМакетов.Добавить("СпецификацияОтк");
	
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
	
	Если Документ.СписокДверей.Количество() > 0 И ТекущийСтатус <> Перечисления.СтатусыСпецификации.Сохранен Тогда
		
		МассивМакетов.Добавить("ЧертежДвери");
		
	КонецЕсли;
	
	МассивМакетов.Добавить("СпецификацияСборка");
	
	Если Документ.СписокИзделийПоКаталогу.Количество() > 0 Тогда
		
		ВидИзделияПоКаталогу = Документ.СписокИзделийПоКаталогу[0].Изделие.ВидИзделияПоКаталогу;
		
		Если ВидИзделияПоКаталогу = Справочники.ВидыИзделийПоКаталогу.КухняВерхний
			ИЛИ ВидИзделияПоКаталогу = Справочники.ВидыИзделийПоКаталогу.КухняНижний
			ИЛИ ВидИзделияПоКаталогу = Справочники.ВидыИзделийПоКаталогу.КорпуснаяМебель Тогда
			
			Если НЕ (Документ.Дилерский И НЕ Документ.Проведен) Тогда
				МассивМакетов.Добавить("ИзделиеПоКаталогу");
				МассивМакетов.Добавить("ПрисадкиПоКаталогу");
			КонецЕсли;
		Иначе
			Если НЕ (Документ.Дилерский И НЕ Документ.Проведен) Тогда
				МассивМакетов.Добавить("ШкафПоКаталогу");
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Документ", Документ);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Файлы.Вид КАК ВидФайла
	|ИЗ
	|	Справочник.ФайлыЛекс КАК Файлы
	|ГДЕ
	|	(ВЫРАЗИТЬ(Файлы.ВладелецФайла КАК Документ.Спецификация)) = &Документ
	|	И (Файлы.Вид = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.Эскиз)
	|			ИЛИ Файлы.Вид = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.ЦеховаяСхема)
	|			ИЛИ Файлы.Вид = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.МонтажнаяСхема))
	|	И НЕ Файлы.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДобавитьЭскиз = Ложь;
	ДобавитьЦеховаяСхема = Ложь;
	ДобавитьМонтажнаяСхема = Ложь;
	
	ВидЭскиз = ПредопределенноеЗначение("Перечисление.ВидыПрисоединенныхФайлов.Эскиз");
	ВидЦеховаяСхема = ПредопределенноеЗначение("Перечисление.ВидыПрисоединенныхФайлов.ЦеховаяСхема");
	ВидМонтажнаяСхема = ПредопределенноеЗначение("Перечисление.ВидыПрисоединенныхФайлов.МонтажнаяСхема");
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ДобавитьЭскиз Тогда
			ДобавитьЭскиз = Выборка.ВидФайла = ВидЭскиз;
		КонецЕсли;
		
		Если НЕ ДобавитьЦеховаяСхема Тогда
			ДобавитьЦеховаяСхема = Выборка.ВидФайла = ВидЦеховаяСхема;
		КонецЕсли;
		
		Если НЕ ДобавитьМонтажнаяСхема Тогда
			ДобавитьМонтажнаяСхема = Выборка.ВидФайла = ВидМонтажнаяСхема;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДобавитьЭскиз Тогда
		 //МассивМакетов.Добавить("Эскиз");
	КонецЕсли;
	
	Если ДобавитьЦеховаяСхема Тогда
		МассивМакетов.Добавить("ЦеховаяСхема");
	КонецЕсли;
	
	Если ДобавитьМонтажнаяСхема Тогда
		МассивМакетов.Добавить("МонтажнаяСхема");
	КонецЕсли;
	
	МассивМакетов.Добавить("СпецификацияЯщики");
	
	Возврат МассивМакетов;
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеРаскрой(Документ)
	
	НаборЗаписей = РегистрыСведений.РаскройДеталей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Документ);
	
	НаборЗаписей.Прочитать();
	
	Возврат НаборЗаписей;
	
КонецФункции
