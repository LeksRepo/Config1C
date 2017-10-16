﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МассивСтруктурСертификатов = Параметры.МассивСтруктурСертификатов;
	
	ФайлСсылка = Неопределено;
	
	Если Параметры.Свойство("ФайлСсылка") Тогда
		ФайлСсылка = Параметры.ФайлСсылка;
	КонецЕсли;
	
	ОтпечатокЛичногоСертификатаДляШифрования = "";
	Если Параметры.Свойство("ОтпечатокЛичногоСертификатаДляШифрования") Тогда
		ОтпечатокЛичногоСертификатаДляШифрования = Параметры.ОтпечатокЛичногоСертификатаДляШифрования;
	КонецЕсли;
	
	Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Зашифровать ""%1""'"),
				Строка(ФайлСсылка) );
	
	Для Каждого СтруктураСертификата Из МассивСтруктурСертификатов Цикл
		НоваяСтрока = ТаблицаСертификатов.Добавить();
		
		НоваяСтрока.КомуВыдан = СтруктураСертификата.КомуВыдан;
		НоваяСтрока.КемВыдан = СтруктураСертификата.КемВыдан;
		НоваяСтрока.ДействителенДо = СтруктураСертификата.ДействителенДо;
		НоваяСтрока.Отпечаток = СтруктураСертификата.Отпечаток;
		
		Если СтруктураСертификата.Свойство("Пометка") Тогда
			НоваяСтрока.Пометка = СтруктураСертификата.Пометка;
		КонецЕсли;
		
		Если НоваяСтрока.Отпечаток = ОтпечатокЛичногоСертификатаДляШифрования Тогда
			НоваяСтрока.ЛичныйСертификатШифрования = Истина;
			НоваяСтрока.Пометка = Истина;
		КонецЕсли;
		
		ЭлектроннаяПодпись.ЗаполнитьНазначениеСертификата(СтруктураСертификата.Назначение, НоваяСтрока.Назначение);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ОбработкаВыбора();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификат(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаСертификатов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ВыбранныйСертификат = ЭлектроннаяПодписьКлиент.ПолучитьСертификатПоОтпечатку(ТекущиеДанные.Отпечаток);
	
	СтруктураСертификата = ЭлектроннаяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(ВыбранныйСертификат);
	Если СтруктураСертификата <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("СтруктураСертификата, Отпечаток", СтруктураСертификата, ТекущиеДанные.Отпечаток);
		ОткрытьФорму("ОбщаяФорма.СертификатЭП", ПараметрыФормы, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаСертификатовКомуВыдан.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаСертификатовКемВыдан.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаСертификатовДействителенДо.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаСертификатовПометка.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаСертификатовНазначение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаСертификатов.ЛичныйСертификатШифрования");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноСерый);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора()
	
	МассивВозврата = Новый Массив;
	Для Каждого СтрокаТаблицыЗначений Из ТаблицаСертификатов Цикл
		Если СтрокаТаблицыЗначений.Пометка Тогда 
			ВыбранныйСертификат = ЭлектроннаяПодписьКлиент.ПолучитьСертификатПоОтпечатку(СтрокаТаблицыЗначений.Отпечаток);
			МассивВозврата.Добавить(ВыбранныйСертификат);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивВозврата.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбран ни один сертификат.'"));
		Возврат;
	КонецЕсли;
	
	Закрыть(МассивВозврата);
	
КонецПроцедуры

#КонецОбласти
