﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Для Каждого Документ Из ПараметрКоманды Цикл
		
		Структура = ВыборМакетов(Документ);
		МассивДокументов = Новый Массив;
		МассивДокументов.Вставить(0, Документ);
		
		МакетЭскиза = ?(ЗначениеЗаполнено(Структура.Эскиз), Структура.Инструкция + Структура.Эскиз + Структура.ПоКаталогу, Структура.ПоКаталогу);
		
		Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(МассивДокументов, ПараметрыВыполненияКоманды.Источник) Тогда
			
			ПараметрыПечати = Новый Структура;
			ПараметрыПечати.Вставить("ФиксированныйКомплект", Ложь); 
			ПараметрыПечати.Вставить("ПереопределитьПользовательскиеНастройкиКоличества", Истина);
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Договор",
			"Договор,УсловияДоставкиВыписка,ТитульныйЛистТПМК,ИспользуемыеМатериалы"+ МакетЭскиза,
			МассивДокументов,
			ПараметрыВыполненияКоманды,
			Неопределено);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ВыборМакетов(Документ)
	
	Спецификация 	= Документ.Спецификация;
	Структура 			= Новый Структура;
	Структура.Вставить("Инструкция", ","+ Документ.Спецификация.Изделие.ИмяМакетаПаспорта);
	Структура.Вставить("Эскиз", Неопределено);
	Структура.Вставить("ПоКаталогу", Неопределено);
	                                                                                          
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Спецификация);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Файлы.Ссылка,
	|	Файлы.ВладелецФайла
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|ГДЕ
	|	Файлы.ВладелецФайла ССЫЛКА Документ.Спецификация
	|	И Файлы.ВладелецФайла.Ссылка = &Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	
	КоличествоФайлов = 0;
	
	Пока Выборка.Следующий() Цикл
		
		КоличествоФайлов = ?(Выборка.ВладелецФайла = Спецификация, КоличествоФайлов + 1, КоличествоФайлов);
		
	КонецЦикла;
	
	Если КоличествоФайлов > 0 Тогда
		
		Структура.Вставить("Эскиз", ",Эскиз");
		
	КонецЕсли;
	
	Если Спецификация.СписокИзделийПоКаталогу.Количество() > 0 Тогда
		
		Если Спецификация.Изделие.ВидИзделия = Перечисления.ВидыИзделий.ШкафКупе Тогда
			
			Структура.Вставить("ПоКаталогу", ",ШкафПоКаталогу");
			                                                            
		Иначе
			
			Структура.Вставить("ПоКаталогу", ",ПоКаталогу");
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат Структура;
	
КонецФункции // ВыборМакетов()
