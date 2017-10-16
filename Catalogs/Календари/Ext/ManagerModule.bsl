﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Функция читает данные графика работы из регистра
//
// Параметры
//	ГрафикРаботы	- Ссылка на текущий элемент справочника
//	НомерГода		- Номер года, за который необходимо прочитать график
//
// Возвращаемое значение - соответствие, где Ключ - дата
//
Функция ПрочитатьДанныеГрафикаИзРегистра(ГрафикРаботы, НомерГода) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КалендарныеГрафики.ДатаГрафика КАК ДатаКалендаря
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Календарь = &ГрафикРаботы
	|	И КалендарныеГрафики.Год = &ТекущийГод
	|	И КалендарныеГрафики.ДеньВключенВГрафик
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаКалендаря";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ГрафикРаботы",	ГрафикРаботы);
	Запрос.УстановитьПараметр("ТекущийГод",		НомерГода);
	
	ДниВключенныеВГрафик = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДниВключенныеВГрафик.Вставить(Выборка.ДатаКалендаря, Истина);
	КонецЦикла;
	
	Возврат ДниВключенныеВГрафик;
	
КонецФункции

// Процедура записывает данные графика в регистр
//
// Параметры
//	ГрафикРаботы	- Ссылка на текущий элемент справочника
//	НомерГода		- Номер года, за который необходимо записать график
//	ДниВключенныеВГрафик - соответствие даты и данных к ней относящихся
//
// Возвращаемое значение
//	Нет
//
Процедура ЗаписатьДанныеГрафикаВРегистр(ГрафикРаботы, ДниВключенныеВГрафик, ДатаНачала, ДатаОкончания, ЗамещатьРучныеИзменения = Ложь) Экспорт
	
	НаборДни = РегистрыСведений.КалендарныеГрафики.СоздатьНаборЗаписей();
	НаборДни.Отбор.Календарь.Установить(ГрафикРаботы);
	
	// Запись оптимальнее выполнять по годам
	// Выбираем используемые годы
	// Для каждого года 
	// - считываем набор, 
	// - модифицируем его с учетом записываемых данных
	// - записываем
	
	ДанныеПоГодам = Новый Соответствие;
	
	ДатаДня = ДатаНачала;
	Пока ДатаДня <= ДатаОкончания Цикл
		ДанныеПоГодам.Вставить(Год(ДатаДня), Истина);
		ДатаДня = ДатаДня + 86400;
	КонецЦикла;
	
	РучныеИзменения = Неопределено;
	Если Не ЗамещатьРучныеИзменения Тогда
		РучныеИзменения = РучныеИзмененияГрафика(ГрафикРаботы);
	КонецЕсли;
	
	// обрабатываем данные по годам
	Для Каждого КлючИЗначение Из ДанныеПоГодам Цикл
		Год = КлючИЗначение.Ключ;
		
		// Считываем наборы на год
		НаборДни.Отбор.Год.Установить(Год);
		НаборДни.Прочитать();
		
		// заполняем содержимое набора в соответствие по датам для быстрого доступа
		СтрокиНабораДни = Новый Соответствие;
		Для Каждого СтрокаНабора Из НаборДни Цикл
			СтрокиНабораДни.Вставить(СтрокаНабора.ДатаГрафика, СтрокаНабора);
		КонецЦикла;
		
		НачалоГода = Дата(Год, 1, 1);
		КонецГода = Дата(Год, 12, 31);
		
		НачалоОбхода = ?(ДатаНачала > НачалоГода, ДатаНачала, НачалоГода);
		КонецОбхода = ?(ДатаОкончания < КонецГода, ДатаОкончания, КонецГода);
		
		// Для периода обхода данные в наборе должны быть заменены
		ДатаДня = НачалоОбхода;
		Пока ДатаДня <= КонецОбхода Цикл
			
			Если РучныеИзменения <> Неопределено И РучныеИзменения[ДатаДня] <> Неопределено Тогда
				// оставляем без изменений в наборе ручные корректировки
				ДатаДня = ДатаДня + 86400;
				Продолжить;
			КонецЕсли;
			
			// Если строки на дату нет в наборе - создаем ее
			СтрокаНабораДни = СтрокиНабораДни[ДатаДня];
			Если СтрокаНабораДни = Неопределено Тогда
				СтрокаНабораДни = НаборДни.Добавить();
				СтрокаНабораДни.Календарь = ГрафикРаботы;
				СтрокаНабораДни.Год = Год;
				СтрокаНабораДни.ДатаГрафика = ДатаДня;
				СтрокиНабораДни.Вставить(ДатаДня, СтрокаНабораДни);
			КонецЕсли;
			
			// Если день включен в график, то заполним его интервалы
			ДанныеДня = ДниВключенныеВГрафик.Получить(ДатаДня);
			Если ДанныеДня = Неопределено Тогда
				// Удаляем строку из набора, если день - нерабочий
				НаборДни.Удалить(СтрокаНабораДни);
				СтрокиНабораДни.Удалить(ДатаДня);
			Иначе
				СтрокаНабораДни.ДеньВключенВГрафик = Истина;
			КонецЕсли;
			ДатаДня = ДатаДня + 86400;
		КонецЦикла;
		
		// Заполняем вторичные данные для оптимизации расчетов по календарям
		ДатаОбхода = НачалоГода;
		КоличествоДнейВГрафикеСНачалаГода = 0;
		Пока ДатаОбхода <= КонецГода Цикл
			СтрокаНабораДни = СтрокиНабораДни[ДатаОбхода];
			Если СтрокаНабораДни <> Неопределено Тогда
				// День включен в график
				КоличествоДнейВГрафикеСНачалаГода = КоличествоДнейВГрафикеСНачалаГода + 1;
			Иначе
				// День не включен в график
				СтрокаНабораДни = НаборДни.Добавить();
				СтрокаНабораДни.Календарь = ГрафикРаботы;
				СтрокаНабораДни.Год = Год;
				СтрокаНабораДни.ДатаГрафика = ДатаОбхода;
			КонецЕсли;
			СтрокаНабораДни.КоличествоДнейВГрафикеСНачалаГода = КоличествоДнейВГрафикеСНачалаГода;
			ДатаОбхода = ДатаОбхода + 86400;
		КонецЦикла;
		
		НаборДни.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняет обновление графиков работы по данным производственных календарей, 
// на основании которых они заполняются 
//
// Параметры:
//	- УсловияОбновления - таблица значений с колонками 
//		- КодПроизводственногоКалендаря - код производственного календаря, данные которого изменились,
//		- Год - год, за который нужно обновить данные
//
Процедура ОбновитьГрафикиРаботыПоДаннымПроизводственныхКалендарей(УсловияОбновления) Экспорт
	
	// Выявим графики, которые нужно обновить
	// получаем данные этих графиков
	// последовательно обновляем за каждый год
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	УсловияОбновления.КодПроизводственногоКалендаря,
	|	УсловияОбновления.Год,
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(1, 1, 1), ГОД, УсловияОбновления.Год - 1) КАК НачалоГода,
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(1, 12, 31), ГОД, УсловияОбновления.Год - 1) КАК КонецГода
	|ПОМЕСТИТЬ УсловияОбновления
	|ИЗ
	|	&УсловияОбновления КАК УсловияОбновления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Календари.Ссылка КАК ГрафикРаботы,
	|	УсловияОбновления.Год,
	|	Календари.СпособЗаполнения,
	|	Календари.ПроизводственныйКалендарь,
	|	ВЫБОР
	|		КОГДА Календари.ДатаНачала < УсловияОбновления.НачалоГода
	|			ТОГДА УсловияОбновления.НачалоГода
	|		ИНАЧЕ Календари.ДатаНачала
	|	КОНЕЦ КАК ДатаНачала,
	|	ВЫБОР
	|		КОГДА Календари.ДатаОкончания > УсловияОбновления.КонецГода
	|				ИЛИ Календари.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА УсловияОбновления.КонецГода
	|		ИНАЧЕ Календари.ДатаОкончания
	|	КОНЕЦ КАК ДатаОкончания,
	|	Календари.ДатаОтсчета,
	|	Календари.УчитыватьПраздники
	|ПОМЕСТИТЬ ОбновляемыеГрафикиРаботы
	|ИЗ
	|	Справочник.Календари КАК Календари
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПроизводственныеКалендари КАК ПроизводственныеКалендари
	|		ПО (ПроизводственныеКалендари.Ссылка = Календари.ПроизводственныйКалендарь)
	|			И (Календари.СпособЗаполнения = ЗНАЧЕНИЕ(Перечисление.СпособыЗаполненияГрафикаРаботы.ПоНеделям)
	|				ИЛИ Календари.СпособЗаполнения = ЗНАЧЕНИЕ(Перечисление.СпособыЗаполненияГрафикаРаботы.ПоЦикламПроизвольнойДлины)
	|					И Календари.УчитыватьПраздники)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ УсловияОбновления КАК УсловияОбновления
	|		ПО (УсловияОбновления.КодПроизводственногоКалендаря = ПроизводственныеКалендари.Код)
	|			И Календари.ДатаНачала <= УсловияОбновления.КонецГода
	|			И (Календари.ДатаОкончания >= УсловияОбновления.НачалоГода
	|				ИЛИ Календари.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РучныеИзмененияГрафиковРаботы КАК РучныеИзмененияПоВсемГодам
	|		ПО (РучныеИзмененияПоВсемГодам.ГрафикРаботы = Календари.Ссылка)
	|			И (РучныеИзмененияПоВсемГодам.Год = 0)
	|ГДЕ
	|	РучныеИзмененияПоВсемГодам.ГрафикРаботы ЕСТЬ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбновляемыеГрафикиРаботы.ГрафикРаботы,
	|	ОбновляемыеГрафикиРаботы.Год,
	|	ОбновляемыеГрафикиРаботы.СпособЗаполнения,
	|	ОбновляемыеГрафикиРаботы.ПроизводственныйКалендарь,
	|	ОбновляемыеГрафикиРаботы.ДатаНачала,
	|	ОбновляемыеГрафикиРаботы.ДатаОкончания,
	|	ОбновляемыеГрафикиРаботы.ДатаОтсчета,
	|	ОбновляемыеГрафикиРаботы.УчитыватьПраздники
	|ИЗ
	|	ОбновляемыеГрафикиРаботы КАК ОбновляемыеГрафикиРаботы
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОбновляемыеГрафикиРаботы.ГрафикРаботы,
	|	ОбновляемыеГрафикиРаботы.Год
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ШаблонЗаполнения.Ссылка КАК ГрафикРаботы,
	|	ШаблонЗаполнения.НомерСтроки КАК НомерСтроки,
	|	ШаблонЗаполнения.ДеньВключенВГрафик
	|ИЗ
	|	Справочник.Календари.ШаблонЗаполнения КАК ШаблонЗаполнения
	|ГДЕ
	|	ШаблонЗаполнения.Ссылка В
	|			(ВЫБРАТЬ
	|				ОбновляемыеГрафикиРаботы.ГрафикРаботы
	|			ИЗ
	|				ОбновляемыеГрафикиРаботы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГрафикРаботы,
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасписаниеРаботы.Ссылка КАК ГрафикРаботы,
	|	РасписаниеРаботы.НомерДня КАК НомерДня,
	|	РасписаниеРаботы.ВремяНачала,
	|	РасписаниеРаботы.ВремяОкончания
	|ИЗ
	|	Справочник.Календари.РасписаниеРаботы КАК РасписаниеРаботы
	|ГДЕ
	|	РасписаниеРаботы.Ссылка В
	|			(ВЫБРАТЬ
	|				ОбновляемыеГрафикиРаботы.ГрафикРаботы
	|			ИЗ
	|				ОбновляемыеГрафикиРаботы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГрафикРаботы,
	|	РасписаниеРаботы.НомерДня";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("УсловияОбновления", УсловияОбновления);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	ВыборкаПоГрафикам = РезультатыЗапроса[РезультатыЗапроса.ВГраница() - 2].Выбрать();
	ВыборкаПоШаблону = РезультатыЗапроса[РезультатыЗапроса.ВГраница() - 1].Выбрать();
	ВыборкаПоРасписанию = РезультатыЗапроса[РезультатыЗапроса.ВГраница()].Выбрать();
	
	ШаблонЗаполнения = Новый ТаблицаЗначений;
	ШаблонЗаполнения.Колонки.Добавить("ДеньВключенВГрафик", Новый ОписаниеТипов("Булево"));
	
	РасписаниеРаботы = Новый ТаблицаЗначений;
	РасписаниеРаботы.Колонки.Добавить("НомерДня", 		Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(7)));
	РасписаниеРаботы.Колонки.Добавить("ВремяНачала", 	Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Время)));
	РасписаниеРаботы.Колонки.Добавить("ВремяОкончания",	Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Время)));
	
	Пока ВыборкаПоГрафикам.СледующийПоЗначениюПоля("ГрафикРаботы") Цикл
		ШаблонЗаполнения.Очистить();
		Пока ВыборкаПоШаблону.НайтиСледующий(ВыборкаПоГрафикам.ГрафикРаботы, "ГрафикРаботы") Цикл
			НоваяСтрока = ШаблонЗаполнения.Добавить();
			НоваяСтрока.ДеньВключенВГрафик = ВыборкаПоШаблону.ДеньВключенВГрафик;
		КонецЦикла;
		РасписаниеРаботы.Очистить();
		Пока ВыборкаПоРасписанию.НайтиСледующий(ВыборкаПоГрафикам.ГрафикРаботы, "ГрафикРаботы") Цикл
			НовыйИнтервал = РасписаниеРаботы.Добавить();
			НовыйИнтервал.НомерДня			= ВыборкаПоРасписанию.НомерДня;
			НовыйИнтервал.ВремяНачала		= ВыборкаПоРасписанию.ВремяНачала;
			НовыйИнтервал.ВремяОкончания	= ВыборкаПоРасписанию.ВремяОкончания;
		КонецЦикла;
		Пока ВыборкаПоГрафикам.СледующийПоЗначениюПоля("ДатаНачала") Цикл
			// Если дата окончания не указана, она будет подобрана по производственному календарю
			ДатаОкончанияЗаполнения = ВыборкаПоГрафикам.ДатаОкончания;
			ДниВключенныеВГрафик = Справочники.Календари.ДниВключенныеВГрафик(
										ВыборкаПоГрафикам.ДатаНачала, 
										ВыборкаПоГрафикам.СпособЗаполнения, 
										ШаблонЗаполнения, 
										РасписаниеРаботы,
										ДатаОкончанияЗаполнения,
										ВыборкаПоГрафикам.ПроизводственныйКалендарь, 
										ВыборкаПоГрафикам.УчитыватьПраздники, 
										ВыборкаПоГрафикам.ДатаОтсчета);
			Справочники.Календари.ЗаписатьДанныеГрафикаВРегистр(ВыборкаПоГрафикам.ГрафикРаботы, ДниВключенныеВГрафик, ВыборкаПоГрафикам.ДатаНачала, ДатаОкончанияЗаполнения);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

// Составляет коллекцию дат, являющихся рабочими с учетом производственного календаря, 
//  способа заполнения и других настроек
//
// Параметры:
//	- Год - номер года
//	- ПроизводственныйКалендарь - производственный календарь, по которому определяются дни
//	- СпособЗаполнения - способ заполнения
//	- ШаблонЗаполнения - шаблон заполнения по дням
//	- УчитыватьПраздники - булево, если Истина, то дни, выпадающие на праздники, будут исключаться 
//	- ДатаНачала - необязательный, указывается только для заполнения по циклам произвольной длины
//
// Возвращаемое значение - соответствие, где Ключ - дата, значение массив структур с описанием интервалов времени для указанной даты
//
Функция ДниВключенныеВГрафик(ДатаНачала, СпособЗаполнения, ШаблонЗаполнения, РасписаниеРаботы = Неопределено, ДатаОкончания = Неопределено, ПроизводственныйКалендарь = Неопределено, УчитыватьПраздники = Истина, Знач ДатаОтсчета = Неопределено) Экспорт
	
	ДниВключенныеВГрафик = Новый Соответствие;

	Если ШаблонЗаполнения.Количество() = 0 Тогда
		Возврат ДниВключенныеВГрафик;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаОкончания) Тогда
		// Если дата окончания не указана, то заполняем до конца года
		ДатаОкончания = КонецГода(ДатаНачала);
		Если ЗначениеЗаполнено(ПроизводственныйКалендарь) Тогда
			// Если указан производственный календарь, то заполняем до "конца" его заполненности
			ДатаОкончанияЗаполнения = Справочники.ПроизводственныеКалендари.ДатаОкончанияЗаполненияПроизводственногоКалендаря(ПроизводственныйКалендарь);
			Если ДатаОкончанияЗаполнения <> Неопределено 
				И ДатаОкончанияЗаполнения > ДатаОкончания Тогда
				ДатаОкончания = ДатаОкончанияЗаполнения;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Заполнение данных производится по годам
	ТекущийГод = Год(ДатаНачала);
	Пока ТекущийГод <= Год(ДатаОкончания) Цикл
		ДатаНачалаВГоду = ДатаНачала;
		ДатаОкончанияВГоду = ДатаОкончания;
		СкорректироватьДатыНачалаОкончания(ТекущийГод, ДатаНачалаВГоду, ДатаОкончанияВГоду);	
		// Получаем данные графика за год
		Если СпособЗаполнения = Перечисления.СпособыЗаполненияГрафикаРаботы.ПоНеделям Тогда
			ДниЗаГод = ДниВключенныеВГрафикПоНеделям(ТекущийГод, ПроизводственныйКалендарь, ШаблонЗаполнения, УчитыватьПраздники, РасписаниеРаботы, ДатаНачалаВГоду, ДатаОкончанияВГоду);
		Иначе
			ДниЗаГод = ДниВключенныеВГрафикПроизвольнойДлины(ТекущийГод, ПроизводственныйКалендарь, ШаблонЗаполнения, УчитыватьПраздники, ДатаОтсчета, РасписаниеРаботы, ДатаНачалаВГоду, ДатаОкончанияВГоду);
		КонецЕсли;
		// Дополняем общую коллекцию
		Для Каждого КлючИЗначение Из ДниЗаГод Цикл
			ДниВключенныеВГрафик.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		ТекущийГод = ТекущийГод + 1;
	КонецЦикла;
	
	Возврат ДниВключенныеВГрафик;
	
КонецФункции

Функция ДниВключенныеВГрафикПоНеделям(Год, ПроизводственныйКалендарь, ШаблонЗаполнения, УчитыватьПраздники = Истина, РасписаниеРаботы = Неопределено, Знач ДатаНачала = Неопределено, Знач ДатаОкончания = Неопределено)
	
	// Заполнение графика работы по неделям
	
	ДниВключенныеВГрафик = Новый Соответствие;
	
	ЗаполнятьПоПроизводственномуКалендарю = ЗначениеЗаполнено(ПроизводственныйКалендарь);
	
	ДнейВГоду = ДеньГода(Дата(Год, 12, 31));
	ДанныеПроизводственногоКалендаря = Справочники.ПроизводственныеКалендари.ДанныеПроизводственногоКалендаря(ПроизводственныйКалендарь, Год);
	Если ЗаполнятьПоПроизводственномуКалендарю 
		И ДанныеПроизводственногоКалендаря.Количество() <> ДнейВГоду Тогда
		// Если производственный календарь указан, но заполнен неправильно, заполнение по неделям не поддерживается
		Возврат ДниВключенныеВГрафик;
	КонецЕсли;
	
	ДанныеПроизводственногоКалендаря.Индексы.Добавить("Дата");
	
	ДлинаСуток = 24 * 3600;
	
	ДатаДня = ДатаНачала;
	Пока ДатаДня <= ДатаОкончания Цикл
		
		ПраздничныйДень = Ложь;
		Если Не ЗаполнятьПоПроизводственномуКалендарю Тогда
			НомерДня = ДеньНедели(ДатаДня);
		Иначе
			ДанныеДня = ДанныеПроизводственногоКалендаря.НайтиСтроки(Новый Структура("Дата", ДатаДня))[0];
			Если ДанныеДня.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота Тогда
				НомерДня = 6;
			ИначеЕсли ДанныеДня.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье Тогда
				НомерДня = 7;
			Иначе
				НомерДня = ДеньНедели(?(ЗначениеЗаполнено(ДанныеДня.ДатаПереноса), ДанныеДня.ДатаПереноса, ДанныеДня.Дата));
			КонецЕсли;
			ПраздничныйДень = УчитыватьПраздники И ДанныеДня.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник;
		КонецЕсли;
		
		СтрокаДня = ШаблонЗаполнения[НомерДня - 1];
		Если СтрокаДня.ДеньВключенВГрафик И Не ПраздничныйДень Тогда
			ДниВключенныеВГрафик.Вставить(ДатаДня, Истина);
		КонецЕсли;
		
		ДатаДня = ДатаДня + ДлинаСуток;
	КонецЦикла;
	
	Возврат ДниВключенныеВГрафик;
	
КонецФункции

Функция ДниВключенныеВГрафикПроизвольнойДлины(Год, ПроизводственныйКалендарь, ШаблонЗаполнения, УчитыватьПраздники, ДатаОтсчета, РасписаниеРаботы = Неопределено, Знач ДатаНачала = Неопределено, Знач ДатаОкончания = Неопределено)
	
	ДниВключенныеВГрафик = Новый Соответствие;
	
	ДлинаСуток = 24 * 3600;
	
	ДатаДня = ДатаОтсчета;
	Пока ДатаДня <= ДатаОкончания Цикл
		Для Каждого СтрокаДня Из ШаблонЗаполнения Цикл
			Если СтрокаДня.ДеньВключенВГрафик 
				И ДатаДня >= ДатаНачала Тогда
				ДниВключенныеВГрафик.Вставить(ДатаДня, Истина);
			КонецЕсли;
			ДатаДня = ДатаДня + ДлинаСуток;
		КонецЦикла;
	КонецЦикла;
	
	Если Не УчитыватьПраздники Тогда
		Возврат ДниВключенныеВГрафик;
	КонецЕсли;
	
	// Исключаем даты праздничных дней
	
	ДанныеПроизводственногоКалендаря = Справочники.ПроизводственныеКалендари.ДанныеПроизводственногоКалендаря(ПроизводственныйКалендарь, Год);
	Если ДанныеПроизводственногоКалендаря.Количество() = 0 Тогда
		Возврат ДниВключенныеВГрафик;
	КонецЕсли;
	
	ДанныеПраздничныхДней = ДанныеПроизводственногоКалендаря.НайтиСтроки(Новый Структура("ВидДня", Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник));
	
	Для Каждого ДанныеДня Из ДанныеПраздничныхДней Цикл
		ДниВключенныеВГрафик.Удалить(ДанныеДня.Дата);
	КонецЦикла;
	
	Возврат ДниВключенныеВГрафик;
	
КонецФункции

Процедура СкорректироватьДатыНачалаОкончания(Год, ДатаНачала, ДатаОкончания)
	
	НачалоГода = Дата(Год, 1, 1);
	КонецГода = Дата(Год, 12, 31);
	
	Если ДатаНачала <> Неопределено Тогда
		ДатаНачала = Макс(ДатаНачала, НачалоГода);
	Иначе
		ДатаНачала = НачалоГода;
	КонецЕсли;
	
	Если ДатаОкончания <> Неопределено Тогда
		ДатаОкончания = Мин(ДатаОкончания, КонецГода);
	Иначе
		ДатаОкончания = КонецГода;
	КонецЕсли;
	
КонецПроцедуры

// Определяет даты ручных изменений указанного графика
//
Функция РучныеИзмененияГрафика(ГрафикРаботы)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	РучныеИзменения.ГрафикРаботы,
	|	РучныеИзменения.Год,
	|	РучныеИзменения.ДатаГрафика,
	|	ЕСТЬNULL(КалендарныеГрафики.ДеньВключенВГрафик, ЛОЖЬ) КАК ДеньВключенВГрафик
	|ИЗ
	|	РегистрСведений.РучныеИзмененияГрафиковРаботы КАК РучныеИзменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|		ПО (КалендарныеГрафики.Календарь = РучныеИзменения.ГрафикРаботы)
	|			И (КалендарныеГрафики.Год = РучныеИзменения.Год)
	|			И (КалендарныеГрафики.ДатаГрафика = РучныеИзменения.ДатаГрафика)
	|ГДЕ
	|	РучныеИзменения.ГрафикРаботы = &ГрафикРаботы
	|	И РучныеИзменения.ДатаГрафика <> ДАТАВРЕМЯ(1, 1, 1)");

	Запрос.УстановитьПараметр("ГрафикРаботы", ГрафикРаботы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	РучныеИзменения = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		РучныеИзменения.Вставить(Выборка.ДатаГрафика, Выборка.ДеньВключенВГрафик);
	КонецЦикла;
	
	Возврат РучныеИзменения;
	
КонецФункции

#КонецОбласти

#КонецЕсли