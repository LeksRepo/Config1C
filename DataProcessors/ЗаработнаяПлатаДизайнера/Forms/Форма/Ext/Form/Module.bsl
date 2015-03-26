﻿
&НаКлиенте
Процедура МесяцВперед(Команда)
	
	ИзменитьПериод(1);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНазад(Команда)
	
	ИзменитьПериод(-1);
	
КонецПроцедуры

&НаКлиенте
Функция ИзменитьПериод(Направление)
	
	УстановленныйМесяц = Период.ДатаНачала;
	НовыйМесяц = ДобавитьМесяц(УстановленныйМесяц, Направление);
	Период.ДатаНачала = НачалоМесяца(НовыйМесяц);
	Период.ДатаОкончания = КонецМесяца(НовыйМесяц);
	ОбновитьДанныеНаСервере();
	
КонецФункции // ИзменитьПериод()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Период.ДатаНачала = НачалоМесяца(ТекущаяДата());
	Период.ДатаОкончания = КонецМесяца(ТекущаяДата());
	ОбновитьДанныеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Дизайнер = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
	МассивРолей = Новый Массив;
	МассивРолей.Добавить("АдминистраторСистемы");
	РазрешитьПросмотр = Ложь;
	
	Для каждого Элемент Из МассивРолей Цикл
		
		Если РольДоступна(Элемент) Тогда
			
			РазрешитьПросмотр = Истина;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.Дизайнер.Доступность = РазрешитьПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанные(Команда)
	
	ОбновитьДанныеНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ОбновитьДанныеНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УправленческийОстаткиИОбороты.Субконто1 КАК Дизайнер,
		|	-УправленческийОстаткиИОбороты.СуммаНачальныйОстаток КАК СуммаНаНачалоПериода,
		|	УправленческийОстаткиИОбороты.СуммаОборотКт КАК Начислено,
		|	УправленческийОстаткиИОбороты.СуммаОборотДт КАК Выплачено,
		|	-УправленческийОстаткиИОбороты.СуммаКонечныйОстаток КАК СуммаНаКонецПериода
		|ИЗ
		|	РегистрБухгалтерии.Управленческий.ОстаткиИОбороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			,
		|			,
		|			Счет = ЗНАЧЕНИЕ(ПланСчетов.управленческий.ВзаиморасчетыССотрудниками),
		|			,
		|			Подразделение = &Подразделение
		|				И Субконто1 = &Дизайнер) КАК УправленческийОстаткиИОбороты";
	
	Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("Дизайнер", Дизайнер);
	Запрос.УстановитьПараметр("Подразделение", Дизайнер.Подразделение);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	
	СуммаНаНачалоПериода = ВыборкаДетальныеЗаписи.СуммаНаНачалоПериода;
	Начислено = ВыборкаДетальныеЗаписи.Начислено;
	Выплачено = ВыборкаДетальныеЗаписи.Выплачено;
	СуммаНаКонецПериода = ВыборкаДетальныеЗаписи.СуммаНаКонецПериода;
	
КонецФункции

&НаКлиенте
Функция ВывестиПодробностиПоЗарплате(ВидОперации)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидОперации", ВидОперации);
	ПараметрыФормы.Вставить("Период", Период);
	ПараметрыФормы.Вставить("Дизайнер", Дизайнер);
	ОткрытьФорму("Обработка.ЗаработнаяПлатаДизайнера.Форма.Подробности", ПараметрыФормы);
	
КонецФункции // ВывестиПодробностиПоЗарплате()

&НаКлиенте
Процедура НачисленоНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВывестиПодробностиПоЗарплате("Начисления");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплаченоНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВывестиПодробностиПоЗарплате("Выплаты");
	
КонецПроцедуры
