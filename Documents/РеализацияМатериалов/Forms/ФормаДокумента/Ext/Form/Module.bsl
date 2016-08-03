﻿
#Область ПРОЦЕДУРЫ_И_ФУНКЦИИ_ОБЩЕГО_НАЗНАЧЕНИЯ

&НаКлиенте
Процедура РассчитатьСумму()
	
	Стр = Элементы.СписокНоменклатуры.ТекущиеДанные;
	Стр.Сумма = Стр.Количество * Стр.Цена;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьПользователя()
	
	Ответ = Ложь;
	
	СписокПравРазрешеноИзменятьЦену = Новый СписокЗначений;
	СписокПравРазрешеноИзменятьЦену.Добавить(Метаданные.Роли.ПолныеПрава);
	СписокПравРазрешеноИзменятьЦену.Добавить(Метаданные.Роли.Администрирование);
	СписокПравРазрешеноИзменятьЦену.Добавить(Метаданные.Роли.ИзмененияВТЧРеализацииМатериалов);
	
	Для каждого ы Из СписокПравРазрешеноИзменятьЦену Цикл
		Ответ = Ответ ИЛИ РольДоступна(ы.Значение);
	КонецЦикла;
	
	Возврат Ответ;
	
КонецФункции // ПроверитьПользователя()

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
	|	РегистрСведений.ЦеныНоменклатурыПоПодразделениям.СрезПоследних(
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

&НаКлиенте
Процедура РасчитатьСтоимость()
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Цена;
	
КонецПроцедуры // РасчитатьСтоимость()

&НаСервере
Функция ПроверитьОстатокНаСкладе()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("СписокНоменклатуры", Объект.СписокНоменклатуры.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Список.Номенклатура КАК Номенклатура,
	|	Список.Количество КАК Количество
	|ПОМЕСТИТЬ СписокНом
	|ИЗ
	|	&СписокНоменклатуры КАК Список
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
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
	|ВЫБРАТЬ
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
	
	КоэффициентОфиса = ?(Объект.Офис <> Справочники.Офисы.ПустаяСсылка(),Объект.Офис.КоэффициентМатериалы,1);
	
	РазрешеноИзменятьЦену = ПроверитьПользователя();
	Элементы.СписокНоменклатурыЦена.ТолькоПросмотр = НЕ РазрешеноИзменятьЦену;
	Элементы.СписокНоменклатурыСумма.ТолькоПросмотр = НЕ РазрешеноИзменятьЦену;
	Элементы.ИзменитьЦеныНаПроцент.Доступность = РазрешеноИзменятьЦену;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область КОМАНДЫ

&НаКлиенте
Процедура Подобрать(Команда)
	
	СтандартнаяОбработка = Ложь;
	
	Пар = Новый Структура();
	Пар.Вставить("Комплектация", УпаковатьТаблицу());
	Пар.Вставить("ТолькоБазовая", Ложь);
	Пар.Вставить("Подразделение", Объект.Подразделение);
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", Пар, Элементы.СписокНоменклатуры,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
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

&НаСервере
Процедура ПерезаполнитьЦены()
	
	Для Каждого Строка Из Объект.СписокНоменклатуры Цикл
		
		Парам = Новый Структура;
		Парам.Вставить("Подразделение", Объект.Подразделение);
		Парам.Вставить("Номенклатура", Строка.Номенклатура);
		Парам.Вставить("Дата", Объект.Дата);
		
		Данные = ПолучитьДанныеНоменклатуры(Парам);
		
		Строка.Цена = Данные.Цена * КоэффициентОфиса;
		Строка.Кратность = Данные.Кратность;
		
		Строка.Сумма = Строка.Количество * Строка.Цена;
		
	КонецЦикла;
	
КонецПроцедуры

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
	РассчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыКоличествоПриИзменении(Элемент)
	
	Стр = Элементы.СписокНоменклатуры.ТекущиеДанные;
	Стр.Количество = ЛексКлиентСервер.ПолучитьКоличествоСУчетомКратности(Стр.Количество, Стр.Кратность);
	РасчитатьСтоимость();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыЦенаПриИзменении(Элемент)
	
	РасчитатьСтоимость();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	ТекущиеДанные.Цена = ?(ТекущиеДанные.Количество > 0, ТекущиеДанные.Сумма / ТекущиеДанные.Количество, 0);
	
КонецПроцедуры

#КонецОбласти
