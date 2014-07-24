﻿
&НаКлиенте
Процедура ЗаполнитьГруппой(Команда)
	
	Группа = ОткрытьФормуМодально("Справочник.Номенклатура.ФормаВыбораГруппы");
	
	Если ЗначениеЗаполнено(Группа) Тогда
		
		Если Объект.СписокНоменклатуры.Количество() > 0 
			И КодВозвратаДиалога.Нет = Вопрос("Табличная часть будет очищена. Продолжить?", РежимДиалогаВопрос.ДаНет, 0) Тогда
			
			Возврат;
			
		КонецЕсли;
		
		Объект.СписокНоменклатуры.Очистить();
		ЗаполнитьСписок(Группа);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСписок(ГруппаНоменклатуры)
	
	Если ГруппаНоменклатуры = Неопределено Тогда
		ГруппаНоменклатуры = Справочники.Номенклатура.ПустаяСсылка();
	КонецЕсли; 
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Родитель", ГруппаНоменклатуры);
	Запрос.УстановитьПараметр("Регион", Объект.Регион);
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Номенклатура,
	|	ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная,
	|	ЦеныНоменклатурыСрезПоследних.Внутренняя,
	|	ЦеныНоменклатурыСрезПоследних.Розничная,
	|	ЦеныНоменклатурыСрезПоследних.Поставщик
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Период, Регион = &Регион) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО ЦеныНоменклатурыСрезПоследних.Номенклатура = СпрНоменклатура.Ссылка
	|ГДЕ
	|	НЕ СпрНоменклатура.ЭтоГруппа
	|	И СпрНоменклатура.Базовый
	|	И СпрНоменклатура.Родитель = &Родитель
	|	И НЕ СпрНоменклатура.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	СпрНоменклатура.Наименование";
	
	Результат = Запрос.Выполнить();
	Объект.СписокНоменклатуры.Загрузить(Результат.Выгрузить());
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПустыми(Команда)
	
	Если Объект.СписокНоменклатуры.Количество() > 0
		И КодВозвратаДиалога.Нет = Вопрос("Табличная часть будет очищена. Продолжить?", РежимДиалогаВопрос.ДаНет, 0) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьПустымиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПустымиНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регион", Объект.Регион);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Номенклатура,
	|	ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная,
	|	ЦеныНоменклатурыСрезПоследних.Внутренняя,
	|	ЦеныНоменклатурыСрезПоследних.Розничная
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(, Регион = &Регион) КАК ЦеныНоменклатурыСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО ЦеныНоменклатурыСрезПоследних.Номенклатура = СпрНоменклатура.Ссылка
	|ГДЕ
	|	НЕ СпрНоменклатура.ЭтоГруппа
	|	И СпрНоменклатура.Базовый
	|	И НЕ СпрНоменклатура.ПометкаУдаления
	|	И (ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная + ЦеныНоменклатурыСрезПоследних.Внутренняя + ЦеныНоменклатурыСрезПоследних.Розничная = 0 ИЛИ ЦеныНоменклатурыСрезПоследних.Розничная IS NULL) 
	|
	|УПОРЯДОЧИТЬ ПО
	|	СпрНоменклатура.Наименование";
	
	Результат = Запрос.Выполнить();
	Объект.СписокНоменклатуры.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Список=Объект.СписокНоменклатуры;
	
	Для Каждого Элемент Из Список Цикл
		Если (Элемент.ПлановаяЗакупочная=0 ИЛИ Элемент.Розничная=0 ИЛИ Элемент.Внутренняя=0) Тогда

			Если КодВозвратаДиалога.Нет = Вопрос("Заполнены не все цены. Продолжить?", РежимДиалогаВопрос.ДаНет, 0) Тогда 
				Отказ=Истина;	
			КонецЕсли; 
			
			Прервать;
			
		 КонецЕсли;
	КонецЦикла;

КонецПроцедуры
