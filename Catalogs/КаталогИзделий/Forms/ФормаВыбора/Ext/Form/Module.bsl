﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РабочийКаталог = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АдресКартинки = "";
	
	Код = СокрЛП(Элементы.Список.ТекущиеДанные.Код);
	ПутьКИзображению = РабочийКаталог + "Изделие" + РасположениеКартинки + Код;
	ФайлНаДиске = Новый Файл(ПутьКИзображению);
	
	Если ФайлНаДиске.Существует() Тогда
		АдресКартинки = ПутьКИзображению;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Кривоватый выбор
	Если Параметры.Свойство("ВидИзделия") Тогда
		
		ВидИзделия = Параметры.ВидИзделия;
		
	Иначе
		
		ВидИзделия = Новый СписокЗначений;
		ВидИзделия.Добавить(Перечисления.ВидыИзделийПоКаталогу.КухняВерхний);
		ВидИзделия.Добавить(Перечисления.ВидыИзделийПоКаталогу.КухняНижний);
		
	КонецЕсли;
	
	РасположениеКартинки = "";
	
	Если ТипЗнч(ВидИзделия) <> Тип("СписокЗначений") Тогда
		//Определение расположения картинки бокового элемента
		Если ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент Тогда
			ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент;
			РасположениеКартинки = Строка(ПредопределенноеЗначение("Перечисление.РасположениеКартинки.Правая"));
		ИначеЕсли ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент Тогда
			РасположениеКартинки = Строка(ПредопределенноеЗначение("Перечисление.РасположениеКартинки.Левая"));
		КонецЕсли;
	КонецЕсли;
	
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидИзделия");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.ПравоеЗначение = ВидИзделия;
	ЭлементОтбора.Использование = Истина;
	
	Если Параметры.Свойство("ИсключитьНесовместимые") И Параметры.Свойство("МассивИзделий") Тогда
		
		ИсключитьНесовместимые = Параметры.ИсключитьНесовместимые;
		МассивИзделий = Параметры.МассивИзделий;
		
		Если ИсключитьНесовместимые Тогда
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("МассивИзделий", МассивИзделий);
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	НесовместимостьИзделийПоКаталогу.НесовместимостимоеИзделие
			|ИЗ
			|	РегистрСведений.НесовместимостьИзделийПоКаталогу КАК НесовместимостьИзделийПоКаталогу
			|ГДЕ
			|	НесовместимостьИзделийПоКаталогу.Изделие В(&МассивИзделий)";
			
			СписокНесовместимых = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("НесовместимостимоеИзделие");
			
			ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
			ЭлементОтбора.ПравоеЗначение = СписокНесовместимых;
			ЭлементОтбора.Использование = Истина;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элемент.ТекущиеДанные.ЭтоГруппа Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;	
КонецПроцедуры


