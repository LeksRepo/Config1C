﻿
&НаКлиенте
Процедура Подобрать(Команда)
	
	СтандартнаяОбработка = Ложь;
	
	Пар = Новый Структура();
	Пар.Вставить("Комплектация", УпаковатьТаблицу());
	Пар.Вставить("ТолькоБазовая", Ложь);
	Пар.Вставить("Подразделение", Объект.Подразделение);
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", Пар,Элементы.Материалы,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Функция УпаковатьТаблицу()
	
	ТЗ = Объект.Материалы.Выгрузить();
	АдресТаблицы = ПоместитьВоВременноеХранилище(ТЗ);
	Структура = Новый Структура;
	Структура.Вставить("АдресТаблицы", АдресТаблицы);
	
	Возврат Структура;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ЗаполнитьБазовую();
	
	ЭтаФорма.ТолькоПросмотр = ЛексСервер.ДоступностьФормыСкладскиеДокументы(Объект.Ссылка);
	Элементы.ДокументОснование.Видимость = ЗначениеЗаполнено(Объект.ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьБазовую()
	
	Таблица = Объект.Материалы;
	
	Для Каждого Стр ИЗ Таблица Цикл
		Стр.Базовая = Стр.Номенклатура.Базовый;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыКоличествоПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Материалы.ТекущиеДанные;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСумму");
	ПриИзмененииРеквизитовВТЧКлиент(ТекущаяСтрока, СтруктураДействий);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРеквизитовВТЧКлиент(ТекущаяСтрока, СтруктураДействий) Экспорт
	
	Перем ЗначениеИзСтруктуры;
	
	СтруктураТЧ = Новый Структура;
	СтруктураТЧ.Вставить("СтруктураПолейТЧ", ПолучитьСтруктуруПолейТЧ(СтруктураДействий));
	СтруктураТЧ.Вставить("ТекущаяСтрока" , ПолучитьДанныеТекущейСтроки(ТекущаяСтрока, СтруктураТЧ.СтруктураПолейТЧ));
	СтруктураТЧ.Вставить("НеобходимВызовСервера",ПолучитьПараметрыОбработкиТЧ(СтруктураДействий));
	Если СтруктураТЧ.НеобходимВызовСервера Тогда
		ПриИзмененииРеквизитовВТЧНАСервере(СтруктураТЧ, СтруктураДействий);
	Иначе
		ОбработатьСтрокуТЧНаСервере(СтруктураТЧ.ТекущаяСтрока, СтруктураДействий);
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтруктураТЧ.ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитовВТЧНАСервере(СтруктураТЧ, СтруктураДействий)
	
	Документы.ПоступлениеМатериаловУслуг.ПриИзмененииРеквизитовВТЧСервер(СтруктураТЧ, СтруктураДействий);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьСтрокуТЧНаСервере(ТекущаяСтрока, СтруктураДействий)
	
	Документы.ПоступлениеМатериаловУслуг.ОбработатьСтрокуТЧСервер(ТекущаяСтрока, СтруктураДействий);
	
КонецПроцедуры // ОбработатьСтрокуТЧНаСервере()

&НаКлиенте
Функция ПолучитьСтруктуруПолейТЧ(СтруктураДействий)
	
	Перем СтруктураПараметровДействия;
	
	СтруктураПолейТЧ = Новый Структура;
	
	Если СтруктураДействий.Свойство("ЗаполнитьЕдиницуХранения", СтруктураПараметровДействия) Тогда
		СтруктураПолейТЧ.Вставить("Номенклатура");
		СтруктураПолейТЧ.Вставить("ЕдиницаХранения");
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьКоэффициент", СтруктураПараметровДействия) Тогда
		СтруктураПолейТЧ.Вставить("ЕдиницаХранения");
		СтруктураПолейТЧ.Вставить("Коэффициент");
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьКоличество", СтруктураПараметровДействия) Тогда
		СтруктураПолейТЧ.Вставить("Количество");
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ПересчитатьСумму", СтруктураПараметровДействия) Тогда
		СтруктураПолейТЧ.Вставить("Сумма");
		СтруктураПолейТЧ.Вставить("Цена");
		СтруктураПолейТЧ.Вставить("Количество");
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ПересчитатьЦену", СтруктураПараметровДействия) Тогда
		СтруктураПолейТЧ.Вставить("Сумма");
		СтруктураПолейТЧ.Вставить("Цена");
		СтруктураПолейТЧ.Вставить("Количество");
	КонецЕсли;
	
	Возврат СтруктураПолейТЧ;
	
КонецФункции

&НаКлиенте
Функция ПолучитьДанныеТекущейСтроки(ТекущаяСтрока, СтруктураПолейТЧ)
	
	ДанныеТекущейСтроки = Новый Структура;
	ДобавитьВСтруктуру(ДанныеТекущейСтроки, СтруктураПолейТЧ);
	ЗаполнитьЗначенияСвойств(ДанныеТекущейСтроки, ТекущаяСтрока);
	
	Возврат ДанныеТекущейСтроки;
	
КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыОбработкиТЧ(СтруктураДействий)
	
	Перем СтруктураПараметровДействия;
	
	НеобходимВызовСервера = Ложь;
	Если СтруктураДействий.Свойство("ЗаполнитьЕдиницуХранения", СтруктураПараметровДействия) Тогда
		НеобходимВызовСервера = Истина;
	Конецесли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьКоэффициент", СтруктураПараметровДействия) Тогда
		НеобходимВызовСервера = Истина;
	Конецесли;
	
	Возврат НеобходимВызовСервера;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьВСтруктуру(Приемник, Источник)
	
	Для Каждого КлючИЗначение Из Источник Цикл
		Приемник.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Материалы.ТекущиеДанные;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьЦену");
	ПриИзмененииРеквизитовВТЧКлиент(ТекущаяСтрока, СтруктураДействий);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыЦенаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Материалы.ТекущиеДанные;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСумму");
	ПриИзмененииРеквизитовВТЧКлиент(ТекущаяСтрока, СтруктураДействий);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыПриИзменении(Элемент)
	
	ПересчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура УслугиПриИзменении(Элемент)
	
	ПересчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеСредстваПриИзменении(Элемент)
	
	ПересчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Функция ПересчитатьСуммуДокумента()
	
	фСуммаДокумента = Объект.Материалы.Итог("Сумма") + Объект.Услуги.Итог("Сумма") + Объект.ОсновныеСредства.Итог("Стоимость");
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПересчитатьСуммуДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыНоменклатураПриИзменении(Элемент)
	
	ТДанные = Элементы.Материалы.ТекущиеДанные;
	ТДанные.ПлановаяЦена = ПолучитьПлановуюЦену(ТДанные.Номенклатура, Объект.Подразделение);
	
	ЗаполнитьБазовую();
	
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
Процедура ЗаполнитьПоПлановойЦене(Команда)
	
	Ответ = Вопрос("Цены материалов будут перезаполнены. Продолжить?", РежимДиалогаВопрос.ДаНет);
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Документ", Объект.Ссылка);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Период",ТекущаяДата());
	
	СформироватьВТМатериалы(Запрос, Объект.Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таб.Номенклатура,
	|	Таб.Номенклатура.Базовый КАК Базовая,
	|	Таб.Содержание,
	|	Таб.Количество,
	|	ВЫБОР
	|		КОГДА Таб.Номенклатура.Базовый
	|			ТОГДА Цены.ПлановаяЗакупочная
	|		ИНАЧЕ Цены.ПлановаяЗакупочная * Таб.Номенклатура.КоэффициентБазовых
	|	КОНЕЦ КАК Цена,
	|	ВЫБОР
	|		КОГДА Таб.Номенклатура.Базовый
	|			ТОГДА Таб.Количество * Цены.ПлановаяЗакупочная
	|		ИНАЧЕ Таб.Количество * Цены.ПлановаяЗакупочная * Таб.Номенклатура.КоэффициентБазовых
	|	КОНЕЦ КАК Сумма
	|ИЗ
	|	втМатериалы КАК Таб
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(&Период, Подразделение = &Подразделение) КАК Цены
	|		ПО (ВЫБОР
	|				КОГДА Таб.Номенклатура.Базовый
	|					ТОГДА Таб.Номенклатура = Цены.Номенклатура
	|				ИНАЧЕ Таб.Номенклатура.БазоваяНоменклатура = Цены.Номенклатура
	|			КОНЕЦ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Таб.Номенклатура.Наименование";
	
	Объект.Материалы.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Функция СформироватьВТМатериалы(Запрос, ТекущийОбъект)
	
	ТаблицаМатериалы = ТекущийОбъект.Материалы.Выгрузить();
	Запрос.УстановитьПараметр("тзМатериалы", ТаблицаМатериалы);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	тзМатериалы.Номенклатура,
	|	тзМатериалы.Количество,
	|	тзМатериалы.Сумма,
	|	тзМатериалы.Цена,
	|	тзМатериалы.Содержание
	|ПОМЕСТИТЬ втМатериалы
	|ИЗ
	|	&тзМатериалы КАК тзМатериалы
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	тзМатериалы.Номенклатура";
	
	Запрос.Выполнить();
	
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Отказ = ЛексКлиент.ПредупредитьОПовторномПроведении(Объект)
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ЗаполнитьСписокНоменклатуры(ВыбранноеЗначение.АдресТаблицы);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокНоменклатуры(АдресТаблицы)
	
	Объект.Материалы.Очистить();
	ТЗ = ПолучитьИзВременногоХранилища(АдресТаблицы);
	
	Для Каждого Стр Из ТЗ Цикл
		
		Строка = Объект.Материалы.Добавить();
		Строка.Номенклатура = Стр.Номенклатура;
		Строка.Количество = Стр.Количество;
		
	КонецЦикла;
	
КонецПроцедуры
