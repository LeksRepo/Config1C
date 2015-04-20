﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Управленческий.Записывать = Истина;
	
	Для Каждого Строка из СписокНоменклатуры Цикл
		
		Проводки = Движения.Управленческий.Добавить();
		Проводки.Период = Дата;
		Проводки.Подразделение = Подразделение;
		
		Если Строка.Оприходовать > 0 Тогда
			
			Проводки.КоличествоДт = Строка.Оприходовать;
			
			Проводки.СчетДт = ПланыСчетов.Управленческий.ОсновноеПроизводство;
			Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Строка.Номенклатура;
			
			Проводки.СчетКт = ПланыСчетов.Управленческий.Доходы;
			Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.ОприходованиеМатериалов;
			
		КонецЕсли;
		
		Если Строка.Списать > 0 Тогда
			
			Проводки.КоличествоКт = Строка.Списать;
			
			Проводки.СчетКт = ПланыСчетов.Управленческий.ОсновноеПроизводство;
			Проводки.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Строка.Номенклатура;
			
			Проводки.СчетДт = ПланыСчетов.Управленческий.Расходы;
			Проводки.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходСписаниеМатериалов;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	ПересчитатьСуммуДокумента();
	
КонецПроцедуры

Процедура ПересчитатьСуммуДокумента()
	
	ТЗ = СписокНоменклатуры.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Список", ТЗ);
	Запрос.Параметры.Вставить("Период", Дата);
	Запрос.Параметры.Вставить("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Список.Номенклатура,
	|	Список.Оприходовать,
	|	Список.Списать
	|ПОМЕСТИТЬ ВТ_Список
	|ИЗ
	|	&Список КАК Список
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ЦеныНоменклатурыСрезПоследних.ПлановаяЗакупочная * (ВТ_Список.Оприходовать - ВТ_Список.Списать)) КАК Сумма
	|ИЗ
	|	ВТ_Список КАК ВТ_Список
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(&Период, Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО ВТ_Список.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		СуммаДокумента = Выборка.Сумма;
	КонецЕсли;
	
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
		|		КОГДА Список.Отклонение > 0
		|			ТОГДА Список.Отклонение
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Оприходовать,
		|	ВЫБОР
		|		КОГДА Список.Отклонение < 0
		|			ТОГДА -Список.Отклонение
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Списать
		|ИЗ
		|	Документ.ИнвентаризацияМатериаловЦех.СписокНоменклатуры КАК Список
		|ГДЕ
		|	Список.Ссылка = &Документ
		|	И Список.Отклонение <> 0";
		
		СписокНоменклатуры.Загрузить(Запрос.Выполнить().Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого Строка Из СписокНоменклатуры Цикл
		
		Если НЕ Строка.Номенклатура.Базовый Тогда
			
			Текст = "Замените номенклатуру на базовую: "+Строка.Номенклатура.Наименование;
			Поле = "СписокНоменклатуры["+(Строка.НомерСтроки-1)+"].Номенклатура";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, Поле );
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры