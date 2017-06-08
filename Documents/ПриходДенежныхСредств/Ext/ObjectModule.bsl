﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	БухгалтерскийУчетСервер.ПроведениеДенежныхСредств(Ссылка, Движения);
	
	Если СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями Тогда
		ЛексСервер.ДобавитьПоказателиСотрудникам(ЭтотОбъект, Движения);
	КонецЕсли;
	
	Если СчетКт = ПланыСчетов.Управленческий.Доходы И ТипЗнч(Субконто2Кт) = Тип("ДокументСсылка.Замер") Тогда
		
		СформироватьДопПроводкуПоЗамеру(Движения, Субконто2Кт);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	ЛексСервер.УстановитьОрганизацию(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(Ссылка) И (ТипЗнч(Субконто2Кт) = Тип("ДокументСсылка.Спецификация")) И Субконто2Кт.Проведен Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Спецификация уже размещена. Операции с денежными средствами не доступны.");
		Отказ = Истина;
	КонецЕсли;
	
	Если ТипЗнч(Субконто2Кт) = Тип("ДокументСсылка.Спецификация") И Субконто1Дт <> Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтЧастныхЛицПоСпецификациям Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Статья движения денежных средств заполнена не верно. Установите статью: Поступления от частных лиц по спецификациям.");
		Отказ = Истина;
	КонецЕсли;	
	
	Если ТипЗнч(Субконто2Кт) = Тип("ДокументСсылка.Договор") И Субконто1Дт <> Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияПоДоговорам Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Статья движения денежных средств заполнена не верно. Установите статью: Поступления по договорам.");
		Отказ = Истина;
	КонецЕсли;
	
	Если ТипЗнч(Субконто2Кт) = Тип("ДокументСсылка.РеализацияМатериалов") И Субконто1Дт <> Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтРеализацииМатериалов Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Статья движения денежных средств заполнена не верно. Установите статью: Поступления от реализации материалов.");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если СчетДт = ПланыСчетов.Управленческий.РасчетныйСчет
		И Субконто2Дт.ПринадлежитПодразделению <> Подразделение Тогда
		
		СтрокаСообщения = "Счет '%1' не принадлежит подразделению '%2'";
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, Субконто2Дт , Подразделение);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения, ,"Объект.Субконто2Дт");
		Отказ = Истина;
		
	КонецЕсли;
	
	КоличествоДт = СчетДт.ВидыСубконто.Количество();
	КоличествоКт = СчетКт.ВидыСубконто.Количество();
	Для Счетчик = 1 По КоличествоДт Цикл
		Если НЕ (СчетДт.ВидыСубконто[Счетчик - 1].ВидСубконто=ПланыВидовХарактеристик.ВидыСубконто.ДокументВзаиморасчетов
			ИЛИ СчетДт.ВидыСубконто[Счетчик - 1].ВидСубконто=ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний) Тогда
			ПроверяемыеРеквизиты.Добавить("Субконто" + Счетчик + "Дт");
		КонецЕсли;
	КонецЦикла;
	Для Счетчик = 1 По КоличествоКт Цикл
		Если НЕ (СчетКт.ВидыСубконто[Счетчик - 1].ВидСубконто=ПланыВидовХарактеристик.ВидыСубконто.ДокументВзаиморасчетов
			ИЛИ СчетКт.ВидыСубконто[Счетчик - 1].ВидСубконто=ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний) Тогда
			ПроверяемыеРеквизиты.Добавить("Субконто" + Счетчик + "Кт");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура СформироватьДопПроводкуПоЗамеру(фДвижения, Замер)
	
	Проводка = фДвижения.Управленческий.Добавить();
	Проводка.Подразделение = Подразделение;
	Проводка.Период = Дата; // будем подумать
	Проводка.Сумма = СуммаДокумента;
	Проводка.Содержание = "Замерщику за удаленный замер";
	
	Проводка.СчетДт = ПланыСчетов.Управленческий.Расходы;
	Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.СтатьиДР] = Справочники.СтатьиДоходовРасходов.РасходыЗарплатаЗамерыИАктивныеПродажи;
	
	Проводка.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками;
	Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ФизическиеЛица] = Замер.Замерщик;
	Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.ВидыНачисленийУдержаний] = Справочники.ВидыНачисленийУдержаний.ЗаУдаленныйЗамер;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
		
		Подразделение = ДанныеЗаполнения.Подразделение;
		Комментарий = ДанныеЗаполнения.Комментарий;
		ВидОперации = Перечисления.ВидыОпераций.ВозвратОтПодотчетногоЛица;
		СчетДт = ПланыСчетов.Управленческий.Касса;
		СчетКт = ПланыСчетов.Управленческий.Подотчет;
		Субконто1Дт = Справочники.СтатьиДвиженияДенежныхСредств.ПеремещениеДенежныхСредств;
		Субконто1Кт = Справочники.СтатьиДвиженияДенежныхСредств.ПеремещениеДенежныхСредств;
		Субконто2Кт = ДанныеЗаполнения.ФизЛицо;
		
	КонецЕсли;
	
КонецПроцедуры
