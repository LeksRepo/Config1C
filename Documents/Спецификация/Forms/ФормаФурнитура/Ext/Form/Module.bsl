﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДанныеОКоличествах = Новый Структура;
	
	ДанныеОКоличествах.Вставить("КоличествоДеталейЛДСП", Параметры.КоличествоДеталейЛДСП);
	ДанныеОКоличествах.Вставить("КоличествоЯщиков", Параметры.КоличествоЯщиков);
	ДанныеОКоличествах.Вставить("КоличествоНужныхРадиусов", Параметры.КоличествоНужныхРадиусов);
	Шуруп16х35черный = Параметры.Шуруп16х35черный;
	Шуруп40х35черный = Параметры.Шуруп40х35черный;
	Дюбель6х40черный = Параметры.Дюбель6х40черный;
	Шуруп30х35черный = Параметры.Шуруп30х35черный;
	Шуруп16х35хром = Параметры.Шуруп16х35хром;
	Шуруп40х35золото = Параметры.Шуруп40х35золото;
	Шуруп16х35золото = Параметры.Шуруп16х35золото;
	Шуруп40х35хром = Параметры.Шуруп40х35хром;
	ФлянецХромированный = Параметры.ФлянецХромированный;
	Подразделение = Параметры.Подразделение;
	Евровинт50 = Параметры.Евровинт50;
	
	СписокГрупп = Новый СписокЗначений;
	СписокГрупп.Добавить(Справочники.НоменклатурныеГруппы.МонтажныйУголок);
	
	Массив = ЛексСервер.ОтборНоменклатурныхГрупп(СписокГрупп, Подразделение);
	
	Если Массив.Свойство("МонтажныйУголок") Тогда
		
		Элементы.Уголки.СписокВыбора.ЗагрузитьЗначения(Массив.МонтажныйУголок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Рассчитать(Команда)
	
	УголкиКоличество = Окр(ДанныеОКоличествах.КоличествоДеталейЛДСП * 3.8, 0);
	Шуруп16х35черный = 80 * (УголкиКоличество * 2) / 100;
	Шуруп40х35черный = 20 * (УголкиКоличество * 2) / 100;
	Дюбель6х40черный = Шуруп40х35черный;
	Шуруп30х35черный = ДанныеОКоличествах.КоличествоЯщиков * 5;
	Шуруп16х35хром = ФлянецХромированный * 4;
	Евровинт50 = ДанныеОКоличествах.КоличествоНужныхРадиусов * 5;
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если ЗначениеЗаполнено(Уголки) И УголкиКоличество = 0 Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Укажите количество";
		Сообщение.Поле = "УголкиКоличество";
		Сообщение.Сообщить();
		Возврат;
		
	КонецЕсли;
	
	Если УголкиКоличество > 0 И НЕ ЗначениеЗаполнено(Уголки) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Укажите уголки";
		Сообщение.Поле = "Уголки";
		Сообщение.Сообщить();
		Возврат;
		
	КонецЕсли;
	
	АдресТаблицы = СоздатьТаблицу();
	СтруктураОповещения = Новый Структура;
	СтруктураОповещения.Вставить("Таблица", "Фурнитура");
	СтруктураОповещения.Вставить ("АдресТаблицы", АдресТаблицы);
	ОповеститьОВыборе(СтруктураОповещения);
	
КонецПроцедуры

&НаСервере
Функция СоздатьТаблицу()
	
	Фурнитура = Новый ТаблицаЗначений;
	Фурнитура.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Фурнитура.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	Фурнитура.Колонки.Добавить("ЕдиницаИзмерения", Новый ОписаниеТипов("СправочникСсылка.ЕдиницыИзмерения"));
	
	ОбщНоменклатура = ЛексСерверПовтИсп.ПолучитьОбщуюНоменклатуруПолностью(Подразделение);
	
	ДобавитьСтрокуВТаблицу(Фурнитура, Уголки, УголкиКоличество);
	
	ДобавитьСтрокуВТаблицу(Фурнитура, ОбщНоменклатура.Дюбель6х40черный, Дюбель6х40черный);
	ДобавитьСтрокуВТаблицу(Фурнитура, ОбщНоменклатура.ФлянецХромированный, ФлянецХромированный);
	ДобавитьСтрокуВТаблицу(Фурнитура, ОбщНоменклатура.Шуруп16х35золото, Шуруп16х35золото);
	ДобавитьСтрокуВТаблицу(Фурнитура, ОбщНоменклатура.Шуруп16х35черный, Шуруп16х35черный);
	ДобавитьСтрокуВТаблицу(Фурнитура, ОбщНоменклатура.Шуруп16х35хром, Шуруп16х35хром);
	ДобавитьСтрокуВТаблицу(Фурнитура, ОбщНоменклатура.Шуруп30х35черный, Шуруп30х35черный);
	ДобавитьСтрокуВТаблицу(Фурнитура, ОбщНоменклатура.Шуруп40х35золото, Шуруп40х35золото);
	ДобавитьСтрокуВТаблицу(Фурнитура, ОбщНоменклатура.Шуруп40х35хром, Шуруп40х35хром);
	ДобавитьСтрокуВТаблицу(Фурнитура, ОбщНоменклатура.Шуруп40х35черный, Шуруп40х35черный);
	ДобавитьСтрокуВТаблицу(Фурнитура, ОбщНоменклатура.Евровинт50, Евровинт50);
	АдресТаблицы = ПоместитьВоВременноеХранилище(Фурнитура);
	
	Возврат АдресТаблицы;
	
КонецФункции

&НаСервере
Функция ДобавитьСтрокуВТаблицу(Фурнитура, Номенклатура, Количество)
	
	Если Количество > 0 Тогда
		
		НоваяСтрока = Фурнитура.Добавить();
		НоваяСтрока.Номенклатура = Номенклатура;
		НоваяСтрока.Количество = Количество;
		НоваяСтрока.ЕдиницаИзмерения = Номенклатура.ЕдиницаИзмерения;
		
	КонецЕсли;
	
КонецФункции // ДобавитьСтрокуВТаблицу()

