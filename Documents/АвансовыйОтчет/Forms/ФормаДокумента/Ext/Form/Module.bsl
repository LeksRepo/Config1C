﻿
&НаКлиенте
Процедура СписокПлатежейСчетУчетаПриИзменении(Элемент)
	
	УстановитьДоступностьПолейТЧ();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьПолейТЧ() 
	
	Данные = Элементы.СписокПлатежей.ТекущиеДанные;
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Данные.СчетУчета);
	Данные.Количественный = ДанныеСчета.Количественный;
	Элементы.СписокПлатежейКоличество.ТолькоПросмотр = НЕ Данные.Количественный;
	
	Для Индекс = 1 По 3 Цикл
		
		Если ЗначениеЗаполнено(ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"]) Тогда
			Данные["Субконто" + Индекс] = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"].ПривестиЗначение(Данные["Субконто" + Индекс]);
			Элементы["СписокПлатежейСубконто" + Индекс].ОграничениеТипа = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
			Элементы["СписокПлатежейСубконто" + Индекс].ТолькоПросмотр = Ложь;
			
			// { Васильев Александр Леонидович [11.09.2014]
			// Для статей доходов и расходов установим фильтр по Активности.
			НовыйПараметр = Новый ПараметрВыбора("Отбор.Активность", Истина);
			НовыйМассив = Новый Массив();
			НовыйМассив.Добавить(НовыйПараметр);
			НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
			Элементы["СписокПлатежейСубконто" + Индекс].ПараметрыВыбора = НовыеПараметры; 
			// } Васильев Александр Леонидович [11.09.2014]
			
		Иначе
			
			Элементы["СписокПлатежейСубконто" + Индекс].ТолькоПросмотр = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПлатежейПриАктивизацииСтроки(Элемент)
	
	Если Объект.СписокПлатежей.Количество() > 0 Тогда
		УстановитьДоступностьПолейТЧ();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПлатежейКоличествоЦенаПриИзменении(Элемент)
	
	Данные = Элементы.СписокПлатежей.ТекущиеДанные;
	КоличествоЦенаПриИзменении(Данные);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПлатежейСуммаПриИзменении(Элемент)
	
	Данные = Элементы.СписокПлатежей.ТекущиеДанные;
	СуммаПриИзменении(Данные);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЦенаПриИзменении(Данные)
	
	Если Данные.Количество = 0 Тогда
		Данные.Сумма = Данные.Цена;
	Иначе
		Данные.Сумма = Данные.Количество * Данные.Цена;
	КонецЕсли;
	
	Объект.СуммаДокумента = Объект.СписокНоменклатуры.Итог("Сумма") + Объект.СписокПлатежей.Итог("Сумма");
		
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Данные)
	
	Если Данные.Количество = 0 Тогда
		Данные.Цена = Данные.Сумма;
	Иначе
		Данные.Цена = Окр(Данные.Сумма / Данные.Количество, 2);
	КонецЕсли;
	Объект.СуммаДокумента = Объект.СписокНоменклатуры.Итог("Сумма") + Объект.СписокПлатежей.Итог("Сумма");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыКоличествоЦенаПриИзменении(Элемент)
	
	Данные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	КоличествоЦенаПриИзменении(Данные);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыСуммаПриИзменении(Элемент)
	
	Данные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	СуммаПриИзменении(Данные);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеНажатие(Элемент, СтандартнаяОбработка)
	
	ОткрытьЗначение(Объект.ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьБазовую();
	
	ДоступноПринятие = ЛексСервер.ДоступноПринятиеБухгалтером(Объект.Ссылка);
	
	Если ЗначениеЗаполнено(Объект.ДатаПередачи) 
	   И ЗначениеЗаполнено(Объект.ОтветственныйЗаХранение)
	   И НЕ ДоступноПринятие Тогда
	   
	   ЭтаФорма.ТолькоПросмотр = Истина;
	   
   КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьБазовую()
	
	Таблица = Объект.СписокНоменклатуры;
	
	Для Каждого Стр ИЗ Таблица Цикл
		Стр.Базовая = Стр.Номенклатура.Базовый;		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПлановуюЦену(Номенклатура, Подразделение)
	
	Ном = Номенклатура;
	Если НЕ Ном.Базовый Тогда
		Ном = Ном.БазоваяНоменклатура;	
	КонецЕсли;
		
	Отбор = Новый Структура("Подразделение, Номенклатура", Подразделение, Ном);
	Цена = РегистрыСведений.ЦеныНоменклатурыПоПодразделениям.ПолучитьПоследнее(ТекущаяДата(), Отбор).ПлановаяЗакупочная;
	
	Если НЕ Номенклатура.Базовый Тогда
		Цена = Цена * Номенклатура.КоэффициентБазовых;
	КонецЕсли;
	
	Возврат Цена;
	
КонецФункции

&НаКлиенте
Процедура СписокНоменклатурыНоменклатураПриИзменении(Элемент)
	
	ТДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	ТДанные.ПлановаяЦена = ПолучитьПлановуюЦену(ТДанные.Номенклатура, Объект.Подразделение);
	
	ЗаполнитьБазовую();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Отказ = ЛексКлиент.ПредупредитьОПовторномПроведении(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	СтандартнаяОбработка = Ложь;
	
	Пар = Новый Структура();
	Пар.Вставить("Комплектация", УпаковатьТаблицу());
	Пар.Вставить("ТолькоБазовая", Ложь);
	Пар.Вставить("Подразделение", Объект.Подразделение);
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", Пар,Элементы.СписокНоменклатуры,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Функция УпаковатьТаблицу()
	
	ТЗ = Объект.СписокНоменклатуры.Выгрузить();
	АдресТаблицы = ПоместитьВоВременноеХранилище(ТЗ);
	Структура = Новый Структура;
	Структура.Вставить("АдресТаблицы", АдресТаблицы);
	
	Возврат Структура;
	
КонецФункции

&НаКлиенте
Процедура СписокНоменклатурыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Модифицированность = Истина;
	ЗаполнитьСписокНоменклатуры(ВыбранноеЗначение.АдресТаблицы);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокНоменклатуры(АдресТаблицы)
	
	Объект.СписокНоменклатуры.Очистить();
	ТЗ = ПолучитьИзВременногоХранилища(АдресТаблицы);
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("ТЗ", ТЗ);
	Запрос.Параметры.Вставить("Подразделение", Объект.Подразделение);
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Список.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	Список.Количество КАК Количество
	|ПОМЕСТИТЬ втНом
	|ИЗ
	|	&ТЗ КАК Список
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокНом.Номенклатура КАК Номенклатура,
	|	СписокНом.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА СписокНом.Номенклатура.Базовый
	|			ТОГДА ЕСТЬNULL(Цены.ПлановаяЗакупочная, 0)
	|		ИНАЧЕ ЕСТЬNULL(Цены.ПлановаяЗакупочная, 0) * СписокНом.Номенклатура.КоэффициентБазовых
	|	КОНЕЦ КАК ПлановаяЦена
	|ИЗ
	|	втНом КАК СписокНом
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(, Подразделение = &Подразделение) КАК Цены
	|		ПО (СписокНом.Номенклатура = Цены.Номенклатура
	|				ИЛИ СписокНом.Номенклатура.БазоваяНоменклатура = Цены.Номенклатура)";
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Стр Из ТЗ Цикл
		
		Строка = Объект.СписокНоменклатуры.Добавить();
		Строка.Номенклатура = Стр.Номенклатура;
		Строка.Количество = Стр.Количество;
		Строка.ПлановаяЦена = Стр.ПлановаяЦена;
		
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ТекущийОбъект.ДатаПередачи)
	   И ЗначениеЗаполнено(ТекущийОбъект.ОтветственныйЗаХранение) Тогда
	    ТекущийОбъект.СданВАрхив = Истина;
    Иначе
	    ТекущийОбъект.СданВАрхив = Ложь;
    КонецЕсли;
	
КонецПроцедуры

