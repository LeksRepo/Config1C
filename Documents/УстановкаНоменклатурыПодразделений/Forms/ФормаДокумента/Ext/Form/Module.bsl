﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Элементы.СписокНоменклатуры.Доступность = ЗначениеЗаполнено(Объект.Подразделение);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДата();
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыОсновнаяПоСкладуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) Тогда	
		ДанныеВыбора = ПолучитьСписокНоменклатуры(ТекущиеДанные.Номенклатура);		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокНоменклатуры(фнНоменклатура)
	
	СписокЗначений = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("БазоваяНоменклатура", фнНоменклатура);
	Запрос.Текст = "ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Номенклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	(Номенклатура.БазоваяНоменклатура = &БазоваяНоменклатура
	|			ИЛИ Номенклатура.Ссылка = &БазоваяНоменклатура)";
	
	РезультатЗапроса = Запрос.Выполнить();
	Таблица = РезультатЗапроса.Выгрузить();
	Массив = Таблица.ВыгрузитьКолонку("Номенклатура");
	СписокЗначений.ЗагрузитьЗначения(Массив);
	
	Возврат СписокЗначений;
	
КонецФункции

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Элементы.СписокНоменклатуры.Доступность = ЗначениеЗаполнено(Объект.Подразделение);
	Объект.СписокНоменклатуры.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
		
	Стр = ПолучитьНоменклатуруПодразделений(ТекущиеДанные.Номенклатура,Объект.Подразделение);
	
	Если Стр.Базовый Тогда 
	
		ТекущиеДанные.ПодЗаказ = Стр.ПодЗаказ;
		ТекущиеДанные.ОкруглятьДоЛистов = Стр.ОкруглятьДоЛистов;
		ТекущиеДанные.ЗакупОптом = Стр.ЗакупОптом;
		ТекущиеДанные.ОсновнаяПоСкладу = Стр.ОсновнаяПоСкладу;
		ТекущиеДанные.ДнейНаИзготовление = Стр.ДнейНаИзготовление;
		
	Иначе
		
		ТекущиеДанные.Номенклатура = Неопределено;
		ТекущиеДанные.ПодЗаказ = Ложь;
		ТекущиеДанные.ОкруглятьДоЛистов = Ложь;
		ТекущиеДанные.ЗакупОптом = Ложь;
		ТекущиеДанные.ОсновнаяПоСкладу = Ложь;
		ТекущиеДанные.ДнейНаИзготовление = 0;
		
		Сообщить("Введите базовую номенклатуру.");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНоменклатуруПодразделений(Номенклатура, Подразделение)
	
	ПодЗаказ = Ложь;
	ОкруглятьДоЛистов = Ложь;
	ЗакупОптом = Ложь;
	ОсновнаяПоСкладу = Неопределено;
	Базовый = Ложь;
	ДнейНаИзготовление = 0;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпрНом.Базовый КАК Базовый,
	|	ЕСТЬNULL(Данные.ПодЗаказ, ЛОЖЬ) КАК ПодЗаказ,
	|	ЕСТЬNULL(Данные.ОкруглятьДоЛистов, ЛОЖЬ) КАК ОкруглятьДоЛистов,
	|	ЕСТЬNULL(Данные.ЗакупОптом, ЛОЖЬ) КАК ЗакупОптом,
	|	Данные.ОсновнаяПоСкладу КАК ОсновнаяПоСкладу,
	|	ЕСТЬNULL(Данные.ДнейНаИзготовление, 0) КАК ДнейНаИзготовление
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНом
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений.СрезПоследних(, Подразделение = &Подразделение) КАК Данные
	|		ПО СпрНом.Ссылка = Данные.Номенклатура
	|ГДЕ
	|	СпрНом.Ссылка = &Номенклатура";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ПодЗаказ = Выборка.ПодЗаказ;
		ОкруглятьДоЛистов = Выборка.ОкруглятьДоЛистов;
		ЗакупОптом = Выборка.ЗакупОптом;
		ОсновнаяПоСкладу = Выборка.ОсновнаяПоСкладу;
		Базовый = Выборка.Базовый;
		ДнейНаИзготовление = Выборка.ДнейНаИзготовление;
	КонецЕсли;
	
	Стр = Новый Структура();
	Стр.Вставить("ПодЗаказ", ПодЗаказ);
	Стр.Вставить("ОкруглятьДоЛистов", ОкруглятьДоЛистов);
	Стр.Вставить("ЗакупОптом", ЗакупОптом);
	Стр.Вставить("ОсновнаяПоСкладу", ОсновнаяПоСкладу);
	Стр.Вставить("Базовый", Базовый);
	Стр.Вставить("ДнейНаИзготовление", ДнейНаИзготовление);
	
	Возврат Стр;
	
КонецФункции


&НаКлиенте
Процедура ЗаполнитьГруппой(Команда)
	
	Группа = ОткрытьФормуМодально("Справочник.Номенклатура.ФормаВыбораГруппы");
	
	Если ЗначениеЗаполнено(Группа) Тогда
		
		Если Объект.СписокНоменклатуры.Количество() > 0 
			И КодВозвратаДиалога.Нет = Вопрос("Табличная часть будет очищена. Продолжить?", РежимДиалогаВопрос.ДаНет, 0) Тогда
			
			Возврат;
			
		КонецЕсли;
		
		Объект.СписокНоменклатуры.Очистить();
		ЗаполнитьСписок(Группа);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСписок(ГруппаНоменклатуры)
	
	Если ГруппаНоменклатуры = Неопределено Тогда
		ГруппаНоменклатуры = Справочники.Номенклатура.ПустаяСсылка();
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Родитель", ГруппаНоменклатуры);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Номенклатура,
	|	НоменклатураПодразделений.ОсновнаяПоСкладу,
	|	НоменклатураПодразделений.ЗакупОптом,
	|	НоменклатураПодразделений.ОкруглятьДоЛистов,
	|	НоменклатураПодразделений.ПодЗаказ,
	|	НоменклатураПодразделений.ДнейНаИзготовление
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений.СрезПоследних(, Подразделение = &Подразделение) КАК НоменклатураПодразделений
	|		ПО (НоменклатураПодразделений.Номенклатура = СпрНоменклатура.Ссылка)
	|ГДЕ
	|	НЕ СпрНоменклатура.ЭтоГруппа
	|	И СпрНоменклатура.Базовый
	|	И СпрНоменклатура.Родитель В ИЕРАРХИИ(&Родитель)
	|	И НЕ СпрНоменклатура.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	СпрНоменклатура.Наименование";
	
	Результат = Запрос.Выполнить();
	Объект.СписокНоменклатуры.Загрузить(Результат.Выгрузить());
	
КонецФункции


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры


&НаКлиенте
Процедура СписокНоменклатурыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Базовый", Истина);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Отбор);
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьПустыми(Команда)
	
	Для Каждого Строка ИЗ Объект.СписокНоменклатуры Цикл
		
		Строка.ПодЗаказ = Ложь;
		Строка.ОкруглятьДоЛистов = Ложь;
		Строка.ЗакупОптом = Ложь;
		Строка.ДнейНаИзготовление = 0;
		
	КонецЦикла;
	
КонецПроцедуры

