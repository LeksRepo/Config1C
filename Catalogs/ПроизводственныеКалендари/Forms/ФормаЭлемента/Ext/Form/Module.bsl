﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗаполнитьДаннымиТекущегоГода(Параметры.ЗначениеКопирования);
	КонецЕсли;
	
	ЦветаВидовДней = Новый ФиксированноеСоответствие(Справочники.ПроизводственныеКалендари.ЦветаОформленияВидовДнейПроизводственногоКалендаря());
	
	СписокВидовДня = Справочники.ПроизводственныеКалендари.СписокВидовДня();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьДаннымиТекущегоГода();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборДаты") Тогда
		Если ВыбранноеЗначение = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ВыделенныеДаты = Элементы.Календарь.ВыделенныеДаты;
		Если ВыделенныеДаты.Количество() = 0 Или Год(ВыделенныеДаты[0]) <> НомерТекущегоГода Тогда
			Возврат;
		КонецЕсли;
		ДатаПереноса = ВыделенныеДаты[0];
		ПеренестиВидДня(ДатаПереноса, ВыбранноеЗначение);
		Элементы.Календарь.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Перем НомерГода;
	
	Если Не ПараметрыЗаписи.Свойство("НомерГода", НомерГода) Тогда
		НомерГода = НомерТекущегоГода;
	КонецЕсли;
	
	ЗаписатьДанныеПроизводственногоКалендаря(НомерГода, ТекущийОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура НомерТекущегоГодаПриИзменении(Элемент)
	
	ЗаписыватьДанныеГрафика = Ложь;
	Если Модифицированность Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Записать измененные данные за %1 год?'"), 
							Формат(НомерПредыдущегоГода, "ЧГ=0"));
		
		Если Вопрос(ТекстСообщения, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			ЗаписыватьДанныеГрафика = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ОбработатьИзменениеГода(ЗаписыватьДанныеГрафика);
	
	Модифицированность = Ложь;
	
	Элементы.Календарь.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура КалендарьПриВыводеПериода(Элемент, ОформлениеПериода)
	
	Для Каждого СтрокаОформленияПериода Из ОформлениеПериода.Даты Цикл
		ЦветОформленияДня = ЦветаВидовДней.Получить(ВидыДней.Получить(СтрокаОформленияПериода.Дата));
		Если ЦветОформленияДня = Неопределено Тогда
			ЦветОформленияДня = ОбщегоНазначенияКлиент.ЦветСтиля("ВидДняПроизводственногоКалендаряНеУказанЦвет");
		КонецЕсли;
		СтрокаОформленияПериода.ЦветТекста = ЦветОформленияДня;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ИзменитьДень(Команда)
	
	ВыделенныеДаты = Элементы.Календарь.ВыделенныеДаты;
	
	Если ВыделенныеДаты.Количество() > 0 И Год(ВыделенныеДаты[0]) = НомерТекущегоГода Тогда
		ВыбранныйЭлемент = ВыбратьИзСписка(СписокВидовДня, , СписокВидовДня.НайтиПоЗначению(ВидыДней.Получить(ВыделенныеДаты[0])));
		Если ВыбранныйЭлемент <> Неопределено Тогда
			ИзменитьВидыДней(ВыделенныеДаты, ВыбранныйЭлемент.Значение);
			Элементы.Календарь.Обновить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиДень(Команда)
	
	ВыделенныеДаты = Элементы.Календарь.ВыделенныеДаты;
	
	Если ВыделенныеДаты.Количество() = 0 Или Год(ВыделенныеДаты[0]) <> НомерТекущегоГода Тогда
		Возврат;
	КонецЕсли;
		
	ДатаПереноса = ВыделенныеДаты[0];
	ВидДня = ВидыДней.Получить(ДатаПереноса);
	
	ПараметрыВыбораДаты = Новый Структура;
	ПараметрыВыбораДаты.Вставить("НачальноеЗначение",			ДатаПереноса);
	ПараметрыВыбораДаты.Вставить("НачалоПериодаОтображения",	НачалоГода(Календарь));
	ПараметрыВыбораДаты.Вставить("КонецПериодаОтображения",		КонецГода(Календарь));
	ПараметрыВыбораДаты.Вставить("Заголовок",					НСтр("ru = 'Выбор даты переноса'"));
	ПараметрыВыбораДаты.Вставить("ПоясняющийТекст",				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
																НСтр("ru = 'Выберите дату, на которую будет осуществлен перенос дня %1 (%2)'"), 
																Формат(ДатаПереноса, "ДФ='д ММММ'"), 
																ВидДня));
	
	ОткрытьФорму("ОбщаяФорма.ВыборДаты", ПараметрыВыбораДаты, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	
	ЗаполнитьДаннымиПоУмолчанию();
	
	Элементы.Календарь.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ПроизводственныйКалендарь", Объект.Ссылка);
	ПараметрыПечати.Вставить("НомерГода", НомерТекущегоГода);
	
	ПараметрКоманды = Новый Массив;
	ПараметрКоманды.Добавить(Объект.Ссылка);
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатьюКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("УправлениеПечатьюКлиент");
		МодульУправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.ПроизводственныеКалендари", "ПроизводственныйКалендарь", 
			ПараметрКоманды, ЭтаФорма, ПараметрыПечати);
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьДаннымиТекущегоГода(ЗначениеКопирования = Неопределено)
	
	// Заполняет форму данными текущего года
	
	НастроитьПолеКалендаря();
	
	Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		СсылкаНаКалендарь = ЗначениеКопирования;
	Иначе
		СсылкаНаКалендарь = Объект.Ссылка;
	КонецЕсли;
	
	ПрочитатьДанныеПроизводственногоКалендаря(СсылкаНаКалендарь, НомерТекущегоГода);
		
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанныеПроизводственногоКалендаря(ПроизводственныйКалендарь, НомерГода)
	
	// Загрузка данных производственного календаря за указанный год
	ПреобразоватьДанныеПроизводственногоКалендаря(
		Справочники.ПроизводственныеКалендари.ДанныеПроизводственногоКалендаря(ПроизводственныйКалендарь, НомерГода));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДаннымиПоУмолчанию()
	
	// Заполняет форму данными производственного календаря, 
	// составленными на основе сведений о праздничных днях и переносах
	
	ПреобразоватьДанныеПроизводственногоКалендаря(
		Справочники.ПроизводственныеКалендари.РезультатЗаполненияПроизводственногоКалендаряПоУмолчанию(Объект.Код, НомерТекущегоГода));

	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПреобразоватьДанныеПроизводственногоКалендаря(ДанныеПроизводственногоКалендаря)
	
	// Данные производственного календаря используются в форме 
	// в виде соответствий ВидыДней и ПереносыДней
	// Процедура заполняет эти соответствия
	
	ВидыДнейСоответствие = Новый Соответствие;
	ПереносыДнейСоответствие = Новый Соответствие;
	
	Для Каждого СтрокаТаблицы Из ДанныеПроизводственногоКалендаря Цикл
		ВидыДнейСоответствие.Вставить(СтрокаТаблицы.Дата, СтрокаТаблицы.ВидДня);
		Если ЗначениеЗаполнено(СтрокаТаблицы.ДатаПереноса) Тогда
			ПереносыДнейСоответствие.Вставить(СтрокаТаблицы.Дата, СтрокаТаблицы.ДатаПереноса);
		КонецЕсли;
	КонецЦикла;
	
	ВидыДней = Новый ФиксированноеСоответствие(ВидыДнейСоответствие);
	ПереносыДней = Новый ФиксированноеСоответствие(ПереносыДнейСоответствие);
	
	ЗаполнитьПредставлениеПереносов(ЭтаФорма);
	
	Элементы.СписокПереносов.Видимость = СписокПереносов.Количество() > 0;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеПроизводственногоКалендаря(Знач НомерГода, Знач ТекущийОбъект = Неопределено)
	
	// Запись данных производственного календаря за указанный год
	
	Если ТекущийОбъект = Неопределено Тогда
		ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	
	ДанныеПроизводственногоКалендаря = Новый ТаблицаЗначений;
	ДанныеПроизводственногоКалендаря.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ДанныеПроизводственногоКалендаря.Колонки.Добавить("ВидДня", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыДнейПроизводственногоКалендаря"));
	ДанныеПроизводственногоКалендаря.Колонки.Добавить("ДатаПереноса", Новый ОписаниеТипов("Дата"));
	
	Для Каждого КлючИЗначение Из ВидыДней Цикл
		
		СтрокаТаблицы = ДанныеПроизводственногоКалендаря.Добавить();
		СтрокаТаблицы.Дата = КлючИЗначение.Ключ;
		СтрокаТаблицы.ВидДня = КлючИЗначение.Значение;
		
		// Если день перенесен с другой даты, вписываем дату переноса
		ДатаПереноса = ПереносыДней.Получить(СтрокаТаблицы.Дата);
		Если ДатаПереноса <> Неопределено 
			И ДатаПереноса <> СтрокаТаблицы.Дата Тогда
			СтрокаТаблицы.ДатаПереноса = ДатаПереноса;
		КонецЕсли;
		
	КонецЦикла;
	
	Справочники.ПроизводственныеКалендари.ЗаписатьДанныеПроизводственногоКалендаря(ТекущийОбъект.Ссылка, НомерГода, ДанныеПроизводственногоКалендаря);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеГода(ЗаписыватьДанныеГрафика)
	
	Если Не ЗаписыватьДанныеГрафика Тогда
		ЗаполнитьДаннымиТекущегоГода();
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Записать(Новый Структура("НомерГода", НомерПредыдущегоГода));
	Иначе
		ЗаписатьДанныеПроизводственногоКалендаря(НомерПредыдущегоГода);
	КонецЕсли;
	
	ЗаполнитьДаннымиТекущегоГода();	
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидыДней(ДатыДней, ВидДня)
	
	// Устанавливает дням по всем датам массива определенный вид
	
	ВидыДнейСоответствие = КалендарныеГрафикиКлиентСервер.СоответствиеПоФиксированномуСоответствию(ВидыДней);
	
	Для Каждого ВыбраннаяДата Из ДатыДней Цикл
		ВидыДнейСоответствие.Вставить(ВыбраннаяДата, ВидДня);
	КонецЦикла;
	
	ВидыДней = Новый ФиксированноеСоответствие(ВидыДнейСоответствие);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВидДня(ДатаПереноса, ДатаНазначения)
	
	// Нужно обменять местами два дня в календаре
	// - обменяться видами дня
	// - запомнить даты переноса
	//	* если переносимый день уже имеет дату переноса (уже был откуда-то перенесен), 
	//		используем имеющуюся дату переноса
	//	* если даты совпадают (день возвращен на "свое место") - удаляем такую запись
	
	ВидыДнейСоответствие = КалендарныеГрафикиКлиентСервер.СоответствиеПоФиксированномуСоответствию(ВидыДней);
	
	ВидыДнейСоответствие.Вставить(ДатаНазначения, ВидыДней.Получить(ДатаПереноса));
	ВидыДнейСоответствие.Вставить(ДатаПереноса, ВидыДней.Получить(ДатаНазначения));
	
	ПереносыДнейСоответствие = КалендарныеГрафикиКлиентСервер.СоответствиеПоФиксированномуСоответствию(ПереносыДней);
	
	ВписатьДатуПереноса(ПереносыДнейСоответствие, ДатаПереноса, ДатаНазначения);
	ВписатьДатуПереноса(ПереносыДнейСоответствие, ДатаНазначения, ДатаПереноса);
	
	ВидыДней = Новый ФиксированноеСоответствие(ВидыДнейСоответствие);
	ПереносыДней = Новый ФиксированноеСоответствие(ПереносыДнейСоответствие);
	
	ЗаполнитьПредставлениеПереносов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВписатьДатуПереноса(ПереносыДнейСоответствие, ДатаПереноса, ДатаНазначения)
	
	// Заполняет в соответствии с датами переносов дней корректную дату переноса
	
	ИсточникДняДатыНазначения = ПереносыДней.Получить(ДатаНазначения);
	Если ИсточникДняДатыНазначения = Неопределено Тогда
		ИсточникДняДатыНазначения = ДатаНазначения;
	КонецЕсли;
	
	Если ДатаПереноса = ИсточникДняДатыНазначения Тогда
		ПереносыДнейСоответствие.Удалить(ДатаПереноса);
	Иначе	
		ПереносыДнейСоответствие.Вставить(ДатаПереноса, ИсточникДняДатыНазначения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьПредставлениеПереносов(Форма)
	
	// Формирует представление переносов в виде списка значений
	
	Форма.СписокПереносов.Очистить();
	Для Каждого КлючИЗначение Из Форма.ПереносыДней Цикл
		// С прикладной точки зрения переносится всегда выходной день на рабочий, 
		// поэтому из двух дат выбираем ту, которой соответствовал выходной день (сейчас соответствует рабочий)
		ДатаИсточник = КлючИЗначение.Ключ;
		ДатаПриемник = КлючИЗначение.Значение;
		ВидДня = Форма.ВидыДней.Получить(ДатаИсточник);
		Если ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Суббота")
			Или ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Воскресенье") Тогда
			// Обменяем даты местами, чтобы отобразить сведения о переносе как "А на Б", а не "Б на А"
			ДатаПереноса = ДатаПриемник;
			ДатаПриемник = ДатаИсточник;
			ДатаИсточник = ДатаПереноса;
		КонецЕсли;
		Если Форма.СписокПереносов.НайтиПоЗначению(ДатаИсточник) <> Неопределено 
			Или Форма.СписокПереносов.НайтиПоЗначению(ДатаПриемник) <> Неопределено Тогда
			// Перенос уже добавлен, пропускаем
			Продолжить;
		КонецЕсли;
		ВидДняИсточник = ПредставлениеВидаДняПереноса(Форма.ВидыДней.Получить(ДатаПриемник), ДатаИсточник);
		ВидДняПриемник = ПредставлениеВидаДняПереноса(Форма.ВидыДней.Получить(ДатаИсточник), ДатаПриемник);
		Форма.СписокПереносов.Добавить(ДатаИсточник, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
															НСтр("ru = '%1 (%3) перенесен на %2 (%4)'"),
															Формат(ДатаИсточник, "ДФ='д ММММ'"),
															Формат(ДатаПриемник, "ДФ='д ММММ'"),
															ВидДняИсточник,
															ВидДняПриемник));
	КонецЦикла;
	Форма.СписокПереносов.СортироватьПоЗначению();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеВидаДняПереноса(ВидДня, Дата)
	
	// Если день является рабочим (или праздником), то в качестве представления выводим название дня недели
	
	Если ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий") 
		Или ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Праздник") Тогда
		ВидДня = Формат(Дата, "ДФ='дддд'");
	КонецЕсли;
	
	Возврат НРег(Строка(ВидДня));
	
КонецФункции	

&НаСервере
Процедура НастроитьПолеКалендаря()
	
	Если НомерТекущегоГода = 0 Тогда
		НомерТекущегоГода = Год(ТекущаяДатаСеанса());
	КонецЕсли;
	НомерПредыдущегоГода = НомерТекущегоГода;
	
	Элементы.Календарь.НачалоПериодаОтображения	= Дата(НомерТекущегоГода, 1, 1);
	Элементы.Календарь.КонецПериодаОтображения	= Дата(НомерТекущегоГода, 12, 31);
		
КонецПроцедуры
