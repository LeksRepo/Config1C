﻿
&НаСервере
Функция ЗаполнитьСписокНоменклатуры(ГруппаНоменклатурыСсылка = Неопределено, ПодразделениеСсылка = Неопределено, Склад = Неопределено)
	
	Если ГруппаНоменклатурыСсылка = Неопределено Тогда
		
		ГруппаНоменклатурыСсылка = Справочники.Номенклатура.ПустаяСсылка();
		
	КонецЕсли; 
	
	Если ПодразделениеСсылка = Неопределено Тогда
		
		ПодразделениеСсылка = Справочники.Подразделения.ПустаяСсылка();
		
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Родитель", ГруппаНоменклатурыСсылка);
	Запрос.УстановитьПараметр("Подразделение", ПодразделениеСсылка);
	
	Если НЕ ЗначениеЗаполнено(Склад) Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СпрНоменклатура.Ссылка КАК Номенклатура
		|ИЗ
		|	Справочник.Номенклатура КАК СпрНоменклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.БазовыйЛимитЦеха.СрезПоследних(, Подразделение = &Подразделение) КАК БазовыйЛимитЦехаСрезПоследних
		|		ПО (БазовыйЛимитЦехаСрезПоследних.Номенклатура = СпрНоменклатура.Ссылка)
		|ГДЕ
		|	ВЫБОР
		|			КОГДА &Родитель = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|				ТОГДА БазовыйЛимитЦехаСрезПоследних.Количество ЕСТЬ NULL 
		|			ИНАЧЕ СпрНоменклатура.Родитель = &Родитель
		|		КОНЕЦ
		|	И НЕ СпрНоменклатура.ЭтоГруппа
		|	И СпрНоменклатура.Базовый
		|
		|УПОРЯДОЧИТЬ ПО
		|	СпрНоменклатура.Родитель,
		|	СпрНоменклатура.Наименование";
		
	Иначе
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка КАК Номенклатура
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.РезервныйЗапасМатериалов), , Подразделение = &Подразделение) КАК УправленческийОстатки
		|		ПО Номенклатура.Ссылка = УправленческийОстатки.Субконто2
		|ГДЕ
		|	НЕ Номенклатура.ЭтоГруппа
		|	И ВЫБОР
		|			КОГДА &Родитель = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|				ТОГДА УправленческийОстатки.КоличествоОстаток ЕСТЬ NULL 
		|			ИНАЧЕ Номенклатура.Родитель = &Родитель
		|		КОНЕЦ
		|	И Номенклатура.Базовый
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номенклатура.Родитель,
		|	Номенклатура.Наименование";
		
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Объект.СписокНоменклатуры.Загрузить(Результат.Выгрузить());
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьГруппой(Команда)
	
	Группа = ОткрытьФормуМодально("Справочник.Номенклатура.ФормаВыбораГруппы");
	
	Если ЗначениеЗаполнено(Группа) Тогда
		
		Если Объект.Списокноменклатуры.Количество() > 0 И КодВозвратаДиалога.Нет = Вопрос("Табличная часть будет очищена. Продолжить?", РежимДиалогаВопрос.ДаНет, 0) Тогда
			
			Возврат;
			
		КонецЕсли;
		
		Объект.СписокНоменклатуры.Очистить();
		ЗаполнитьСписокНоменклатуры(Группа);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПустыми(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Подразделение) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Выберите подразделение",,"Подразделение", "Объект");
		
		Возврат;
		
	КонецЕсли;
	
	Если Объект.Списокноменклатуры.Количество() > 0 И КодВозвратаДиалога.Нет = Вопрос("Табличная часть будет очищена. Продолжить?", РежимДиалогаВопрос.ДаНет, 0) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Объект.СписокНоменклатуры.Очистить();
	ЗаполнитьСписокНоменклатуры(, Объект.Подразделение, Объект.Склад);
	
КонецПроцедуры