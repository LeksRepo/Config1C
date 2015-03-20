﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Управленческий.Записывать = Истина;
	
	Для Каждого Строка из СписокНоменклатуры Цикл
		
		Проводки = Движения.Управленческий.Добавить();
		Проводки.Период = Дата;
		Проводки.Подразделение = Подразделение;
		
		Если Строка.Оприходовать > 0 Тогда
			
			Проводки.КоличествоДт = Строка.Количество;
			
			Проводки.СчетДт = ПланыСчетов.Управленческий.ОсновноеПроизводство;
			Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Строка.Номенклатура;
			
			Проводки.СчетКт = ПланыСчетов.Управленческий.Доходы;
			Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ОприходованиеМатериалов;
			
		ИначеЕсли Строка.Списать > 0 Тогда
			
			Проводки.КоличествоКт = -Строка.Количество;
			
			Проводки.СчетКт = ПланыСчетов.Управленческий.ОсновноеПроизводство;
			Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Строка.Номенклатура;
			
			Проводки.СчетДт = ПланыСчетов.Управленческий.Расходы;
			Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходСписаниеМатериалов;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
		ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ИнвентаризацияМатериаловЦех") Тогда
		
		ДокументОснование = ДанныеЗаполнения;
		Подразделение = ДанныеЗаполнения.Подразделение;
		Комментарий = "Введено на основании: " + ДанныеЗаполнения;
		
		Запрос = Новый Запрос;
		Запрос.Параметры.Вставить("Документ", ДанныеЗаполнения);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Список.Номенклатура,
		|	Список.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ВЫБОР
		|		 КОГДА Список.Отклонение > 0 
		|		 ТОГДА Список.Отклонение
		|	     ИНАЧЕ 0
		|	КОНЕЦ КАК Оприходовать,	 
		|	ВЫБОР
		|		 КОГДА Список.Отклонение < 0 
		|		 ТОГДА -Список.Отклонение
		|	     ИНАЧЕ 0
		|	КОНЕЦ КАК Списать
		|ИЗ
		|	Документ.ИнвентаризацияМатериаловЦех.СписокНоменклатуры КАК Список
		|ГДЕ
		|	Список.Ссылка = &Документ
		|   И Список.Отклонение <> 0";
		
		СписокНоменклатуры.Загрузить(Запрос.Выполнить().Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры
