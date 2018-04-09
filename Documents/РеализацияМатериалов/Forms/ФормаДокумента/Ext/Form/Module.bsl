﻿
#Область ПРОЦЕДУРЫ_И_ФУНКЦИИ_ОБЩЕГО_НАЗНАЧЕНИЯ

&НаКлиенте
Процедура РассчитатьСумму()
	
	Стр = Элементы.СписокНоменклатуры.ТекущиеДанные;
	Стр.Сумма = Стр.Количество * Стр.Цена;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЦенуИКрастность(ТекущиеДанные)
	
	Парам = Новый Структура;
	Парам.Вставить("Подразделение", Объект.Подразделение);
	Парам.Вставить("Номенклатура", ТекущиеДанные.Номенклатура);
	Парам.Вставить("Дата", Объект.Дата);
	
	Данные = ПолучитьДанныеНоменклатуры(Парам);
	
	ТекущиеДанные.Цена = Данные.Цена * КоэффициентОфиса;
	ТекущиеДанные.Кратность = Данные.Кратность;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатуры(Парам)
	
	Если Парам.Номенклатура.Базовый Тогда
		БазоваяНоменклатура = Парам.Номенклатура;
		Коэффициент = 1;
		Кратность = Парам.Номенклатура.Кратность;
	Иначе
		БазоваяНоменклатура = Парам.Номенклатура.БазоваяНоменклатура;
		Коэффициент = Парам.Номенклатура.КоэффициентБазовых;
		Кратность = 1;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", Парам.Дата);
	Запрос.УстановитьПараметр("Подразделение", Парам.Подразделение);
	Запрос.УстановитьПараметр("БазоваяНоменклатура", БазоваяНоменклатура);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.Розничная
	|ИЗ
	|	РегистрСведений.НастройкиНоменклатуры.СрезПоследних(
	|			&Дата,
	|			Номенклатура = &БазоваяНоменклатура
	|				И Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних";
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		Цена = 0;
		
	Иначе
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Цена = Выборка.Розничная * Коэффициент;
		
	КонецЕсли;
	
	Ответ = Новый Структура;
	
	Ответ.Вставить("Цена", Цена);
	Ответ.Вставить("Кратность", Кратность);
	
	Возврат Ответ;
	
КонецФункции // ПолучитьЦенуНоменклатуры()

&НаСервере
Функция ПроверитьОстатокНаСкладе()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("СписокНоменклатуры", Объект.СписокНоменклатуры.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Список.Номенклатура КАК Номенклатура,
	|	Список.Количество КАК Количество
	|ПОМЕСТИТЬ СписокНом
	|ИЗ
	|	&СписокНоменклатуры КАК Список
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА СпрНом.Базовый
	|			ТОГДА СпрНом.Ссылка
	|		ИНАЧЕ СпрНом.БазоваяНоменклатура
	|	КОНЕЦ КАК Номенклатура,
	|	СУММА(ВЫБОР
	|			КОГДА СпрНом.Базовый
	|				ТОГДА СписокНом2.Количество
	|			ИНАЧЕ СписокНом2.Количество * СпрНом.КоэффициентБазовых
	|		КОНЕЦ) КАК Количество
	|ПОМЕСТИТЬ СписокНом3
	|ИЗ
	|	СписокНом КАК СписокНом2
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНом
	|		ПО СписокНом2.Номенклатура = СпрНом.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА СпрНом.Базовый
	|			ТОГДА СпрНом.Ссылка
	|		ИНАЧЕ СпрНом.БазоваяНоменклатура
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СписокНом3.Номенклатура КАК Номенклатура,
	|	МАКСИМУМ(СписокНом3.Количество) КАК Количество,
	|	СУММА(ВЫБОР
	|				КОГДА ОстаткиНаСкладе.Субконто2 ЕСТЬ NULL
	|				ТОГДА 0
	|				ИНАЧЕ
	|					ВЫБОР
	|						КОГДА ОстаткиНаСкладе.Субконто2.Базовый
	|							ТОГДА ЕСТЬNULL(ОстаткиНаСкладе.КоличествоОстаток,0)
	|						ИНАЧЕ ЕСТЬNULL(ОстаткиНаСкладе.КоличествоОстаток,0) * ОстаткиНаСкладе.Субконто2.КоэффициентБазовых
	|					КОНЕЦ
	|		 КОНЕЦ) КАК Остатки,
	|	МАКСИМУМ(ЕСТЬNULL(РезервныйЗапас.Количество, 0)) КАК Резерв
	|ИЗ
	|	СписокНом3 КАК СписокНом3
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто1 = &Склад) КАК ОстаткиНаСкладе
	|		ПО (СписокНом3.Номенклатура = ОстаткиНаСкладе.Субконто2
	|				ИЛИ СписокНом3.Номенклатура = ОстаткиНаСкладе.Субконто2.БазоваяНоменклатура)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РезервныйЗапасМатериалов.СрезПоследних(
	|				,
	|				Подразделение = &Подразделение
	|					И Склад = &Склад) КАК РезервныйЗапас
	|		ПО СписокНом3.Номенклатура = РезервныйЗапас.Номенклатура
	|
	|СГРУППИРОВАТЬ ПО
	|	СписокНом3.Номенклатура";
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	СтрокаОтвет = "";
	
	Для Каждого Строка Из ТЗ Цикл
		
		Перерасход = ((Строка.Остатки - Строка.Количество) - Строка.Резерв) * -1;
		Если Строка.Остатки < Строка.Резерв Тогда
			Перерасход = Строка.Количество;
		КонецЕсли;
		
		Если Строка.Резерв > 0 И Перерасход > 0 Тогда
			
			СтрокаОтвет = СтрокаОтвет + Строка.Номенклатура + "   :   превышение: " + Перерасход + " " + Строка.Номенклатура.ЕдиницаИзмерения + Символы.ПС;
			
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат СтрокаОтвет;
	
КонецФункции

#КонецОбласти

#Область ОБРАБОТЧИКИ_СОБЫТИЙ_ФОРМЫ

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ Объект.Проведен Тогда
		
		Ответ = ПроверитьОстатокНаСкладе();
		
		Если НЕ (Ответ = "") Тогда
			
			//RonEXI: Тут над формулировкой сообщения нужно подумать.
			
			ТекстВопроса = "Обнаружено превышение резервного запаса, по следующим позициям:" + Символы.ПС + "Продолжить?";
			Кнопки = РежимДиалогаВопрос.ДаНет;
			Ответ = Вопрос(ТекстВопроса, Кнопки);
			
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Отказ = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЭтаФорма.ТолькоПросмотр Тогда
		ЭтаФорма.ТолькоПросмотр = ЛексСервер.ДоступностьФормыСкладскиеДокументы(Объект.Ссылка);
	КонецЕсли;
	
	КоэффициентОфиса = ?(Объект.Офис <> Справочники.Офисы.ПустаяСсылка(), Объект.Офис.КоэффициентМатериалы, 1);
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Объект.Дилерский = Объект.Контрагент.Дилер; 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область КОМАНДЫ

&НаКлиенте
Процедура Подобрать(Команда)
	
	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		
		Пар = Новый Структура();
		Пар.Вставить("Комплектация", УпаковатьТаблицу());
		Пар.Вставить("ТолькоБазовая", Ложь);
		Пар.Вставить("Подразделение", Объект.Подразделение);
		Пар.Вставить("Склад", Объект.Склад);
		Пар.Вставить("Офис", Объект.Офис);
		
		Если Объект.Дилерский И ЗначениеЗаполнено(Объект.Контрагент) Тогда
			Пар.Вставить("Контрагент", Объект.Контрагент);
		КонецЕсли;
		
		ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", Пар, Элементы.СписокНоменклатуры,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните склад", ,"Объект.Склад");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УпаковатьТаблицу()
	
	ТЗ = Объект.СписокНоменклатуры.Выгрузить();
	АдресТаблицы = ПоместитьВоВременноеХранилище(ТЗ);
	Структура = Новый Структура;
	Структура.Вставить("АдресТаблицы", АдресТаблицы);
	
	Возврат Структура;
	
КонецФункции

&НаКлиенте
Процедура ИзменитьЦеныНаПроцент(Команда)
	
	Множитель = 1.00;
	ВвестиЧисло(Множитель, "Введите множитель", 5, 2);
	
	Для каждого Строка Из Объект.СписокНоменклатуры Цикл
		
		Строка.Цена = Строка.Цена + (Строка.Цена / 100 * Множитель);
		Строка.Сумма = Строка.Количество * Строка.Цена;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокНоменклатуры(АдресТаблицы)
	
	Объект.СписокНоменклатуры.Очистить();
	ТЗ = ПолучитьИзВременногоХранилища(АдресТаблицы);
	
	Для Каждого Стр Из ТЗ Цикл
		
		Строка = Объект.СписокНоменклатуры.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, Стр);
		
		Парам = Новый Структура;
		Парам.Вставить("Подразделение", Объект.Подразделение);
		Парам.Вставить("Номенклатура", Строка.Номенклатура);
		Парам.Вставить("Дата", Объект.Дата);
		
		Данные = ПолучитьДанныеНоменклатуры(Парам);
		Строка.Цена = Данные.Цена * КоэффициентОфиса;
		Строка.Сумма = Строка.Количество * Строка.Цена;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПРОЦЕДУРЫ_ОБРАБОТЧИКИ_СОБЫТИЙ_РЕКВИЗИТОВ_ШАПКИ

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	КоэффициентОфиса = 1;
	ПерезаполнитьЦены();
	
КонецПроцедуры

&НаКлиенте
Процедура ОфисПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Офис) Тогда
		КоэффициентОфиса = ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.Офис, "КоэффициентМатериалы");
	Иначе
		КоэффициентОфиса = 1;
	КонецЕсли;
	
	ПерезаполнитьЦены();
	
КонецПроцедуры

&НаКлиенте
Процедура ОфисОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИзмененГород = ПроверитьГородОфисаНаСервере(ВыбранноеЗначение, Объект.Офис);
	
	Если ИзмененГород Тогда
		
		Объект.АдресДоставки = "Введите адрес";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьГородОфисаНаСервере(Офис1, Офис2)
	
	Город1 = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Офис1, "Город");
	Город2 = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Офис2, "Город");
	
	Возврат Город1 <> Город2;
	
КонецФункции

&НаСервере
Процедура ПерезаполнитьЦены()
	
	ПерезаполнитьЦеныТаблицы("СписокНоменклатуры", "Количество", 1);
	ПерезаполнитьЦеныТаблицы("ОбрезкиХлыстовогоМатериала", "РазмерПродаваемый", 1000);
	
КонецПроцедуры

&НаСервере
Функция ПерезаполнитьЦеныТаблицы(ИмяТаблицы, ИмяПоляКоличества, ДелительКоличества)
	
	Для Каждого Строка Из Объект[ИмяТаблицы] Цикл
		
		Парам = Новый Структура;
		Парам.Вставить("Подразделение", Объект.Подразделение);
		Парам.Вставить("Номенклатура", Строка.Номенклатура);
		Парам.Вставить("Дата", Объект.Дата);
		
		Данные = ПолучитьДанныеНоменклатуры(Парам);
		
		Строка.Цена = Данные.Цена * КоэффициентОфиса;
		Строка.Кратность = Данные.Кратность;
		Строка.Сумма = Строка[ИмяПоляКоличества] * Строка.Цена / ДелительКоличества;
		
	КонецЦикла;
	
КонецФункции

#КонецОбласти

#Область РАБОТА_С_ТАБЛИЦЕЙ_СПИСОКНОМЕНКЛАТУРЫ

&НаКлиенте
Процедура СписокНоменклатурыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ЗаполнитьСписокНоменклатуры(ВыбранноеЗначение.АдресТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыНоменклатураПриИзменении(Элемент)
	
	Стр = Элементы.СписокНоменклатуры.ТекущиеДанные;
	
	ЗаполнитьЦенуИКрастность(Стр);
	Стр.Количество = ЛексКлиентСервер.ПолучитьКоличествоСУчетомКратности(Стр.Количество, Стр.Кратность);
	РассчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыКоличествоПриИзменении(Элемент)
	
	Стр = Элементы.СписокНоменклатуры.ТекущиеДанные;
	Стр.Количество = ЛексКлиентСервер.ПолучитьКоличествоСУчетомКратности(Стр.Количество, Стр.Кратность);
	РассчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыЦенаПриИзменении(Элемент)
	
	РассчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	ТекущиеДанные.Цена = ?(ТекущиеДанные.Количество > 0, ТекущиеДанные.Сумма / ТекущиеДанные.Количество, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Подразделение) Тогда
		
		ТекстСообщения = "Выберите подразделение!";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Подразделение", "Объект");
		
	Иначе
		
		ПараметрыАдреса = Новый Структура;
		ПараметрыАдреса.Вставить("Подразделение", Объект.Подразделение);
		ПараметрыАдреса.Вставить("Километраж", Объект.Километраж);
		
		Если Объект.АдресДоставки = "Введите адрес" Тогда
			
			СтарыйАдрес = "";
			
		Иначе
			
			СтарыйАдрес = Объект.АдресДоставки;
			
		КонецЕсли;
		
		ПараметрыАдреса.Вставить("Офис", Объект.Офис);
		ПараметрыАдреса.Вставить("СтарыйАдрес", СтарыйАдрес);
		
		СтруктураАдреса = ОткрытьФормуМодально("ОбщаяФорма.ФормаВводаАдреса", ПараметрыАдреса, ЭтаФорма);
		
		Если ТипЗнч(СтруктураАдреса) = Тип("Структура") Тогда
			
			Объект.АдресДоставки = СтруктураАдреса.Адрес;
			Объект.Километраж = СтруктураАдреса.Километраж;
			
		КонецЕсли;
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПакетУслугПриИзменении(Элемент)
	
	Элементы.ДатаОтгрузки.ТолькоПросмотр = Объект.ПакетУслуг <> ПредопределенноеЗначение("Перечисление.ПакетыУслуг.ДоставкаДоКлиента");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.ДатаОтгрузки.ТолькоПросмотр = Объект.ПакетУслуг <> ПредопределенноеЗначение("Перечисление.ПакетыУслуг.ДоставкаДоКлиента");
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПодобратьОбрезкиХлыстовогоМатериала(Команда)
	
	ПараметрыФомы = Новый Структура;
	ПараметрыФомы.Вставить("Подразделение", Объект.Подразделение);
	ПараметрыФомы.Вставить("АдресТаблицыОбрезков", ПолучитьАдресТаблицы());
	ОткрытьФорму("РегистрНакопления.ОбрезкиХлыстовойМатериал.Форма.ФормаПодбора", ПараметрыФомы, Элементы.ОбрезкиХлыстовогоМатериала);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресТаблицы()
	
	Таблица = Объект.ОбрезкиХлыстовогоМатериала.Выгрузить();
	Таблица.Колонки.РазмерХлыста.Имя = "Размер";
	АдресТаблицы = ПоместитьВоВременноеХранилище(Таблица);
	
	Возврат АдресТаблицы;
	
КонецФункции

&НаКлиенте
Процедура ОбрезкиХлыстовогоМатериалаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура")
		И ВыбранноеЗначение.Свойство("АдресХранилища")
		И ЭтоАдресВременногоХранилища(ВыбранноеЗначение.АдресХранилища) Тогда
		ЗагрузитьОбрезкиХлыстовогоМатериала(ВыбранноеЗначение.АдресХранилища);
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Номенклатура") Тогда
		ДобавитьЦелыйХлыст(ВыбранноеЗначение)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьЦелыйХлыст(НоменклатураСсылка)
	
	Парам = Новый Структура;
	Парам.Вставить("Подразделение", Объект.Подразделение);
	Парам.Вставить("Номенклатура", НоменклатураСсылка.БазоваяНоменклатура);
	Парам.Вставить("Дата", Объект.Дата);
	
	СвойстваНоменклатуры = ПолучитьДанныеНоменклатуры(Парам);
	
	НоваяСтрока = Объект.ОбрезкиХлыстовогоМатериала.Добавить();
	НоваяСтрока.Номенклатура = НоменклатураСсылка;
	
	НоваяСтрока.РазмерХлыста = НоменклатураСсылка.БазоваяНоменклатура.ДлинаДетали;
	НоваяСтрока.РазмерПродаваемый = НоваяСтрока.РазмерХлыста;
	НоваяСтрока.РазмерЗаготовки = НоваяСтрока.РазмерХлыста;
	
	НоваяСтрока.Цена = СвойстваНоменклатуры.Цена * КоэффициентОфиса;
	НоваяСтрока.Сумма = НоваяСтрока.РазмерПродаваемый * НоваяСтрока.Цена * КоэффициентОфиса / 1000;
	НоваяСтрока.Кратность = СвойстваНоменклатуры.Кратность;
	
КонецФункции

&НаСервере
Функция ЗагрузитьОбрезкиХлыстовогоМатериала(фнАдресТаблицы)
	
	УдалитьОбрезкиХлыстовИзТаблицы();
	//Объект.ОбрезкиХлыстовогоМатериала.Очистить();
	
	Таблица = ПолучитьИзВременногоХранилища(фнАдресТаблицы);
	
	Для Каждого СтрокаПодбора Из Таблица Цикл
		
		НоваяСтрока = Объект.ОбрезкиХлыстовогоМатериала.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПодбора);
		
		Парам = Новый Структура;
		Парам.Вставить("Подразделение", Объект.Подразделение);
		Парам.Вставить("Номенклатура", НоваяСтрока.Номенклатура);
		Парам.Вставить("Дата", Объект.Дата);
		
		СвойстваНоменклатуры = ПолучитьДанныеНоменклатуры(Парам);
		НоваяСтрока.РазмерХлыста = СтрокаПодбора.Размер;
		НоваяСтрока.РазмерПродаваемый = НоваяСтрока.РазмерХлыста;
		НоваяСтрока.РазмерЗаготовки = НоваяСтрока.РазмерХлыста;
		НоваяСтрока.Цена = СвойстваНоменклатуры.Цена * КоэффициентОфиса;
		НоваяСтрока.Сумма = НоваяСтрока.РазмерПродаваемый * НоваяСтрока.Цена * КоэффициентОфиса / 1000;
		НоваяСтрока.Кратность = СвойстваНоменклатуры.Кратность;
		
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция УдалитьОбрезкиХлыстовИзТаблицы()
	
	МассивИндексовДляУдаления = Новый Массив;
	
	Для каждого Строка Из Объект.ОбрезкиХлыстовогоМатериала Цикл
		Если Строка.Номенклатура.Базовый Тогда
			ИндексСтроки = Объект.ОбрезкиХлыстовогоМатериала.Индекс(Строка);
			МассивИндексовДляУдаления.Добавить(ИндексСтроки);
		КонецЕсли;
	КонецЦикла;
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.ЗагрузитьЗначения(МассивИндексовДляУдаления);
	СписокЗначений.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
	
	МассивИндексовДляУдаления = СписокЗначений.ВыгрузитьЗначения();
	
	Для каждого ЭлементМассива Из МассивИндексовДляУдаления Цикл
		
		Объект.ОбрезкиХлыстовогоМатериала.Удалить(ЭлементМассива);
		
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура ОбрезкиХлыстовогоМатериалаРазмерКлиентуПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОбрезкиХлыстовогоМатериала.ТекущиеДанные;
	ОстатокОтХлыста = ТекущиеДанные.РазмерХлыста - ТекущиеДанные.РазмерЗаготовки;
	
	Если ОстатокОтХлыста < 0 Тогда
		ТекущиеДанные.РазмерЗаготовки = ТекущиеДанные.РазмерХлыста;
		ОстатокОтХлыста = 0;
	КонецЕсли;
	
	Если ОстатокОтХлыста < ТекущиеДанные.Кратность * 1000 Тогда
		ТекущиеДанные.РазмерПродаваемый = ТекущиеДанные.РазмерХлыста;
	Иначе
		ТекущиеДанные.РазмерПродаваемый = ТекущиеДанные.РазмерЗаготовки;
	КонецЕсли;
	
	РассчитатьСуммуХлыстовойМатериал();
	
КонецПроцедуры

&НаКлиенте
Функция РассчитатьСуммуХлыстовойМатериал()
	
	ТекущиеДанные = Элементы.ОбрезкиХлыстовогоМатериала.ТекущиеДанные;
	ТекущиеДанные.Сумма = ТекущиеДанные.РазмерПродаваемый * КоэффициентОфиса * ТекущиеДанные.Цена / 1000;
	
КонецФункции

&НаКлиенте
Процедура РаспилитьЦелыйХлыст(Команда)
	
	ПарамертыФормы = Новый Структура();
	ПарамертыФормы.Вставить("НомГруппы", ПолучитьХлыстовыеНоменклатурныеГруппы());
	ПарамертыФормы.Вставить("Офис", Объект.Офис);
	ПарамертыФормы.Вставить("ТолькоБазовая", Ложь);
	ПарамертыФормы.Вставить("ТолькоНеБазовая", Истина);
	ПарамертыФормы.Вставить("Склад", Объект.Склад);
	ПарамертыФормы.Вставить("Подразделение", Объект.Подразделение);
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", ПарамертыФормы, Элементы.ОбрезкиХлыстовогоМатериала);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьХлыстовыеНоменклатурныеГруппы()
	
	// { Васильев Александр Леонидович [04.04.2018]
	// В будущем, если часто будут дёргать,
	// добавить свойство в номенклатурную группу
	// и по нему определять можно ли пилить целый хлыст.
	// } Васильев Александр Леонидович [04.04.2018]
	
	Результат = Новый СписокЗначений;
	Результат.Добавить(Справочники.НоменклатурныеГруппы.АлюминиевыйПрофиль);
	Результат.Добавить(Справочники.НоменклатурныеГруппы.ФурнитураХлыстовая);
	
	
	Возврат Результат;
	
КонецФункции
