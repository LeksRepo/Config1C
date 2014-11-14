﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Для Каждого Документ Из ПараметрКоманды Цикл
		
		Массив = Новый Массив;
		Массив.Добавить(Документ);
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ФиксированныйКомплект", Ложь); 
		ПараметрыПечати.Вставить("ПереопределитьПользовательскиеНастройкиКоличества", Истина);
		
		МассивМакетов = ОпределитьМакеты(Документ);
				
		Если ЗначениеЗаполнено(МассивМакетов) Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Спецификация", СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(МассивМакетов), Массив, ПараметрыВыполненияКоманды.Источник, ПараметрыПечати);
		Иначе
			Предупреждение("Документы на печать отсутствуют!");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ОпределитьМакеты(Документ)
	
	МассивМакетов = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Документ", Документ);
	Запрос.УстановитьПараметр("ДокументОснование", Документ.ДокументОснование);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Файлы.ВидФайла
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|ГДЕ
	|	( ВЫРАЗИТЬ(Файлы.ВладелецФайла КАК Документ.Спецификация) = &Документ
	|	  ИЛИ ВЫРАЗИТЬ(Файлы.ВладелецФайла КАК Документ.Замер) = &ДокументОснование )
	|	И (Файлы.ВидФайла = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.Эскиз)
	|			ИЛИ Файлы.ВидФайла = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.ЗамерныйЛист)
	|			ИЛИ Файлы.ВидФайла = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.МонтажнаяСхема))
	|	И Файлы.ПометкаУдаления = Ложь";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДобавитьЭскиз = Ложь;
	ДобавитьЗамерныйЛист = Ложь;
	
	ВидЭскиз = ПредопределенноеЗначение("Перечисление.ВидыПрисоединенныхФайлов.Эскиз");
	ВидЗамерныйЛист = ПредопределенноеЗначение("Перечисление.ВидыПрисоединенныхФайлов.ЗамерныйЛист");
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ВидФайла = ВидЭскиз Тогда
			ДобавитьЭскиз = Истина; 
		КонецЕсли;
		
		Если Выборка.ВидФайла = ВидЗамерныйЛист Тогда
			ДобавитьЗамерныйЛист = Истина;
		КонецЕсли;
	
	КонецЦикла; 
	
	Если ДобавитьЭскиз Тогда	
		МассивМакетов.Добавить("Эскиз");
	КонецЕсли;
	
	Если ДобавитьЗамерныйЛист Тогда	
		МассивМакетов.Добавить("ЗамерныйЛистИнженеру");
	КонецЕсли;
	
	Возврат МассивМакетов;
	
КонецФункции
