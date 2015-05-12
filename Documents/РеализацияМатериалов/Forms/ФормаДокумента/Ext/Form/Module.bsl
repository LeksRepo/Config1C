﻿&НаКлиенте
Процедура СписокНоменклатурыНоменклатураПриИзменении(Элемент)
	ПриИзмененииНоменклатуры();
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыКоличествоПриИзменении(Элемент)
	
	РасчитатьСтоимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииНоменклатуры()
	
	Стр = Элементы.СписокНоменклатуры.ТекущиеДанные;
	
	ЗаполнитьЦену(Стр);
	
	Если Стр.Кратность > 0 Тогда
		
		Стр.Количество = Стр.Кратность * Окр((Стр.Количество / Стр.Кратность)+0.4999,0,РежимОкругления.Окр15как20);	
		
	КонецЕсли;
	
	РассчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСумму()
	
	Стр = Элементы.СписокНоменклатуры.ТекущиеДанные;
	Стр.Сумма = Стр.Количество * Стр.Цена;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РазрешеноИзменятьЦену = ПроверитьПользователя();
	ЭтаФорма.Элементы.СписокНоменклатурыЦена.ТолькоПросмотр = НЕ РазрешеноИзменятьЦену;
	ЭтаФорма.Элементы.СписокНоменклатурыСумма.ТолькоПросмотр = НЕ РазрешеноИзменятьЦену;
	ЭтаФорма.Элементы.ИзменитьЦеныНаПроцент.Доступность = РазрешеноИзменятьЦену;
	
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
Процедура ЗаполнитьЦену(ТекущиеДанные)
	
	Парам = Новый Структура;
	Парам.Вставить("Подразделение", Объект.Подразделение);
	Парам.Вставить("Номенклатура", ТекущиеДанные.Номенклатура);
	Парам.Вставить("Дата", Объект.Дата);
	
	Данные = ПолучитьДанныеНоменклатуры(Парам);
	
	ТекущиеДанные.Цена = Данные.Цена;
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
		Кратность = Парам.Номенклатура.Кратность; 
		Кратность = ?(Кратность=0,1,Кратность);
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
	Ответ.Вставить("Цена",Цена);
	Ответ.Вставить("Кратность",Кратность);
	
	Возврат Ответ;
	
КонецФункции // ПолучитьЦенуНоменклатуры()

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РасчитатьСтоимость()
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Цена;
	
КонецПроцедуры // РасчитатьСтоимость()


&НаКлиенте
Процедура СписокНоменклатурыЦенаПриИзменении(Элемент)
	
	РасчитатьСтоимость();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
	ТекущиеДанные.Цена = ?(ТекущиеДанные.Количество > 0, ТекущиеДанные.Сумма / ТекущиеДанные.Количество, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЦеныНаПроцент(Команда)
	
	Множитель = 1.00;
	ВвестиЧисло(Множитель, "Введите множитель", 5, 2);
	
	Для каждого Строка Из Объект.СписокНоменклатуры Цикл
	
		Строка.Цена = Строка.Цена + (Строка.Цена / 100 * Множитель);
		Строка.Сумма = Строка.Количество * Строка.Цена;
	
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ Объект.Проведен Тогда
		
		Ответ = ПроверитьОстатокНаСкладе();
		
		Если НЕ (Ответ = "") Тогда
			
			//RonEXI: Тут над формулировкой сообщения нужно подумать.
			
			ТекстВопроса = "После сохранения на складе появится перерасход по следующим позициям:"+Символы.ПС+Символы.ПС+Ответ+Символы.ПС+"Продолжить?";
		    Кнопки = РежимДиалогаВопрос.ДаНет;
		    Ответ = Вопрос(ТекстВопроса, Кнопки);
		
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Отказ = Истина;
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

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
	|	СписокНом2.Номенклатура КАК Номенклатура,
	|	СУММА(СписокНом2.Количество) КАК Количество
	|ПОМЕСТИТЬ СписокНом3
	|ИЗ
	|	СписокНом КАК СписокНом2
	|
	|СГРУППИРОВАТЬ ПО
	|	СписокНом2.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокНом3.Номенклатура КАК Номенклатура,
	|	ЕСТЬNULL(ОстаткиНаСкладе.КоличествоОстатокДт,0) КАК Остаток,
	|	ЕСТЬNULL(ОстаткиНаСкладе.КоличествоОстатокДт,0) - СписокНом3.Количество КАК НовыйОстаток,
	|	ЕСТЬNULL(РезервныйЗапас.Количество,0) КАК Резерв,
	|	ЕСТЬNULL(РезервныйЗапас.Количество,0) - (ЕСТЬNULL(ОстаткиНаСкладе.КоличествоОстатокДт,0) - СписокНом3.Количество) КАК Перерасход
	|ИЗ
	|	СписокНом3 КАК СписокНом3
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
	|				,
	|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.МатериалыНаСкладе),
	|				,
	|				Подразделение = &Подразделение
	|					И Субконто1 = &Склад) КАК ОстаткиНаСкладе
	|		ПО СписокНом3.Номенклатура = ОстаткиНаСкладе.Субконто2
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РезервныйЗапасМатериалов.СрезПоследних(
	|				,
	|				Подразделение = &Подразделение
	|					И Склад = &Склад) КАК РезервныйЗапас
	|		ПО СписокНом3.Номенклатура = РезервныйЗапас.Номенклатура";
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	СтрокаОтвет = "";
	
	Для Каждого Строка Из ТЗ Цикл
		
		Если Строка.Перерасход > 0 Тогда
			
			СтрокаОтвет = СтрокаОтвет + Строка.Номенклатура + "   :   перерасход: " + Строка.Перерасход + " " + Строка.Номенклатура.ЕдиницаИзмерения + Символы.ПС; 
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтрокаОтвет;
	
КонецФункции
