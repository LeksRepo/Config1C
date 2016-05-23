﻿
&НаСервере
Процедура ЗаполнитьТаблицуНаСервере()
	
	Объект.СписокДокументов.Очистить();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", Объект.ПериодНачало);
	Запрос.УстановитьПараметр("КонецПериода", Объект.Дата);
	Запрос.УстановитьПараметр("ОперационнаяКасса", Объект.ОперационнаяКасса);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("СсылкаНаИнкассацию", Объект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОбороты.Регистратор,
	|	УправленческийОбороты.КорСубконто2 КАК Основание,
	|	УправленческийОбороты.СуммаОборотДт КАК Принято,
	|	УправленческийОбороты.СуммаОборотКт КАК Выдано
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Регистратор,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ОперационнаяКасса),
	|			,
	|			Субконто2 = &ОперационнаяКасса
	|				И Подразделение = &Подразделение,
	|			,
	|			) КАК УправленческийОбороты
	|ГДЕ
	|	УправленческийОбороты.Регистратор.Ссылка <> &СсылкаНаИнкассацию
	|
	|УПОРЯДОЧИТЬ ПО
	|	УправленческийОбороты.Регистратор.Дата";
	
	ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
	Объект.СписокДокументов.Загрузить(ТаблицаДокументов);
	
	Если НЕ ЗначениеЗаполнено(Объект.СуммаДокумента) Тогда
		Объект.СуммаДокумента = СуммаВКассеНаНачалоПериода + ТаблицаДокументов.Итог("Принято") - ТаблицаДокументов.Итог("Выдано");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСуммуВКассеНаНачалоПериода()
	
	Структура = ПолучитьНачалоПериодаСумму(Объект.Подразделение, Объект.ОперационнаяКасса, Объект.Ссылка);
	
	СуммаВКассеНаНачалоПериода = Структура.Сумма;
	Объект.ПериодНачало = Структура.НачалоПериода;
	ЗаполнитьТаблицуНаСервере();
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьНачалоПериодаСумму(Подразделение, Касса, Ссылка)
	
	Ответ = Новый Структура("Сумма, НачалоПериода", 0, '0001.01.02');
	Ответ.НачалоПериода = ПолучитьДатуПоследнейИнкассации(Подразделение, Касса, Ссылка);
	
	Если ЗначениеЗаполнено(Ответ.НачалоПериода) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ОперационнаяКасса", Касса);
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		Запрос.УстановитьПараметр("Период", Ответ.НачалоПериода + 1);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	УправленческийОстатки.Счет,
		|	УправленческийОстатки.Субконто2,
		|	УправленческийОстатки.СуммаОстаток
		|ИЗ
		|	РегистрБухгалтерии.Управленческий.Остатки(
		|			&Период,
		|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ОперационнаяКасса),
		|			,
		|			Подразделение = &Подразделение
		|				И Субконто2 = &ОперационнаяКасса) КАК УправленческийОстатки";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			Ответ.Сумма = Выборка.СуммаОстаток;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДатуПоследнейИнкассации(Подразделение, Касса, Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОперационнаяКасса", Касса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Инкассация.Дата КАК Дата
	|ИЗ
	|	Документ.Инкассация КАК Инкассация
	|ГДЕ
	|	Инкассация.ОперационнаяКасса = &ОперационнаяКасса
	|	И Инкассация.Проведен
	|	И Инкассация.Ссылка <> &Ссылка
	|	И Инкассация.Подразделение = &Подразделение
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Дата(1,1,1);
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Дата + 1;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьТаблицуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ПользовательАдминистратор = УправлениеДоступомПереопределяемый.ЕстьДоступКПрофилюГруппДоступа(ПользователиКлиентСервер.ТекущийПользователь(), Справочники.ПрофилиГруппДоступа.Администратор);
	ЭтаФорма.Элементы.СписокДокументов.ТолькоПросмотр = НЕ ПользовательАдминистратор;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПарольВБазе = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Инкассатор, "ПарольИнкассатора");
	
	Если ПарольВБазе <> ПарольИнкассатора ИЛИ НЕ ЗначениеЗаполнено(ПарольВБазе) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Введен неверный пароль", Объект.Ссылка, "ПарольИнкассатора");
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицу(Команда)
	
	ЗаполнитьТаблицуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ЗаполнитьСуммуВКассеНаНачалоПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперационнаяКассаПриИзменении(Элемент)
	
	ЗаполнитьСуммуВКассеНаНачалоПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если Объект.Дата < Объект.ПериодНачало Тогда
		Объект.Дата = КонецДня(Объект.ПериодНачало);
	КонецЕсли;
	
	ЗаполнитьТаблицуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.СписокДокументов.ТекущиеДанные.Регистратор);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

