﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	 Ответ = Вопрос("Цены материалов будут перезаполнены. Продолжить?",РежимДиалогаВопрос.ДаНет);
		
	 Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	 КонецЕсли;
	
	 ЗаполнитьНаСервере(ПараметрКоманды);
	 
	 Если ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Документ.ПоступлениеМатериаловУслуг.Форма.ФормаДокумента" Тогда
		ПараметрыВыполненияКоманды.Источник.Прочитать();	
	 КонецЕсли;
	
КонецПроцедуры
 
&НаСервере
Процедура ЗаполнитьНаСервере(Документ)	
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Документ", Документ);
	Запрос.УстановитьПараметр("Подразделение", Документ.Подразделение);
	Запрос.УстановитьПараметр("Период",ТекущаяДата());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таб.Номенклатура,
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
	|	Документ.ПоступлениеМатериаловУслуг.Материалы КАК Таб
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(&Период, Подразделение = &Подразделение) КАК Цены
	|		ПО (ВЫБОР
	|				КОГДА Таб.Номенклатура.Базовый
	|					ТОГДА Таб.Номенклатура = Цены.Номенклатура
	|				ИНАЧЕ Таб.Номенклатура.БазоваяНоменклатура = Цены.Номенклатура
	|			КОНЕЦ)
	|ГДЕ
	|	Таб.Ссылка = &Документ";
	
	ДокОбъект = Документ.ПолучитьОбъект();	
	ДокОбъект.Материалы.Загрузить(Запрос.Выполнить().Выгрузить());
	ДокОбъект.Записать();
	
КонецПроцедуры
