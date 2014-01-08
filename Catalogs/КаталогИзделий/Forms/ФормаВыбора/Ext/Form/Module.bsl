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
	
	Код = СокрЛП(Элементы.Список.ТекущиеДанные.Код);
	ПутьКИзображению = РабочийКаталог + "Изделие" + Код;
	ФайлНаДиске 			= Новый Файл(ПутьКИзображению);
	
	Если ФайлНаДиске.Существует() Тогда
		
		АдресКартинки = ПутьКИзображению;
		
	Иначе
		
		АдресКартинки = "";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ВидИзделия") Тогда
		
		ВидИзделия = Параметры.ВидИзделия;
		
		//В Форме элемента Каталога изделий Вид изделия бокового только один боковой элемент - ЛевыйБоковойЭлемент, 
		//правый нужен только для формы Шкафа в спецификации
		
		Если ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент Тогда
			ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент
		КонецЕсли;
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидИзделия");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = ВидИзделия;
		ЭлементОтбора.Использование = Истина;
		
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		
	КонецЕсли;
	
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
			
			Элементы.Список.Отображение = ОтображениеТаблицы.Список;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

