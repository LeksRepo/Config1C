﻿
&НаКлиенте
Процедура Подобрать(Команда)
	
	ПараметрыФомы = Новый Структура;
	ПараметрыФомы.Вставить("Подразделение", Объект.Подразделение);
	ПараметрыФомы.Вставить("Дата", Объект.Дата);
	СтруктураАдресов = ПолучитьАдресаТаблиц();
	ПараметрыФомы.Вставить("АдресТаблицыОбрезков", СтруктураАдресов.АдресТаблицыОбрезков);
	ОткрытьФорму("РегистрНакопления.ОбрезкиМатериалов.Форма.ФормаПодбора", ПараметрыФомы, Элементы.СписокНоменклатуры);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресаТаблиц()
	
	СтруктураАдресов = Новый Структура;
	СтруктураАдресов.Вставить("АдресТаблицыОбрезков", ПоместитьВоВременноеХранилище(Объект.СписокНоменклатуры.Выгрузить()));
	
	Возврат СтруктураАдресов;
	
КонецФункции

&НаКлиенте
Процедура СписокНоменклатурыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") И ВыбранноеЗначение.Свойство("АдресХранилища") 
		И ЭтоАдресВременногоХранилища(ВыбранноеЗначение.АдресХранилища) Тогда
		ЗагрузитьТаблицуНаСервере(ВыбранноеЗначение.АдресХранилища);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьТаблицуНаСервере(фАдресТаблицы)
	
	Объект.СписокНоменклатуры.Загрузить(ПолучитьИзВременногоХранилища(фАдресТаблицы));
	
КонецФункции

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры
