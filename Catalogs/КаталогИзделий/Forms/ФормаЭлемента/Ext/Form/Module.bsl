﻿
&НаСервере
Процедура ОбновитьХарактеристики()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Таблица", Объект.СписокХарактеристик.Выгрузить());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Таблица.Характеристика,
	|	Таблица.ЗначениеХарактеристики
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	&Таблица КАК Таблица
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Таблица.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.ЗначениеХарактеристики,
	|	ХарактеристикиШкафовКупе.Ссылка КАК Характеристика
	|ИЗ
	|	ПланВидовХарактеристик.ХарактеристикиШкафовКупе КАК ХарактеристикиШкафовКупе
	|		ЛЕВОЕ СОЕДИНЕНИЕ Таблица КАК Таблица
	|		ПО (Таблица.Характеристика = ХарактеристикиШкафовКупе.Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Характеристика";
	
	Объект.СписокХарактеристик.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Функция ОткрытьФормуПодбора(ИмяПодбора, ТаблицаДляФормы, СтрокаДанных, ВладелецПодобра)
	
	ПараметрыПодбора = Новый Структура;
	
	Если ТипЗнч(ТаблицаДляФормы) = Тип("Структура") Тогда
		
		АдресаТаблиц = ВыгрузитьТаблицыДеталиПрисадкиВХранилище();
		ПараметрыПодбора.Вставить("Детали", АдресаТаблиц.Детали);
		ПараметрыПодбора.Вставить("Присадки", АдресаТаблиц.Присадки);
		
	Иначе
		
		АдресТаблицы = ВыгрузитьНужнуюТаблицуВХранилище(ТаблицаДляФормы);
		ПараметрыПодбора.Вставить("АдресТаблицы", АдресТаблицы);
	
	КонецЕсли;	
		
	Если СтрокаДанных <> Неопределено Тогда
		
		ПараметрыПодбора.Вставить("Идентификатор", СтрокаДанных.НомерСтроки - 1);
		
	КонецЕсли;
	
	ОткрытьФорму("Справочник.КаталогИзделий.Форма." + ИмяПодбора, ПараметрыПодбора, ВладелецПодобра);
	
КонецФункции

&НаСервере
Функция ВыгрузитьНужнуюТаблицуВХранилище(ТабличнаяЧасть)
	
	Возврат ПоместитьВоВременноеХранилище(ТабличнаяЧасть.Выгрузить());
	
КонецФункции

&НаСервере
Функция ВыгрузитьТаблицыДеталиПрисадкиВХранилище()
	
	Стр = Новый Структура();
	Стр.Вставить("Детали", ПоместитьВоВременноеХранилище(Объект.СписокДеталей.Выгрузить()));
	Стр.Вставить("Присадки", ПоместитьВоВременноеХранилище(Объект.СписокПрисадок.Выгрузить()));
	
	Возврат Стр;
	
КонецФункции

&НаКлиенте
Процедура СписокЯщикиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЗагрузитьТабличнуюЧасть(ВыбранноеЗначение, Элемент.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТабличнуюЧасть(АдресТаблицы, ИмяТабличнойЧасти)
	
	ТЗ = ПолучитьИзВременногоХранилища(АдресТаблицы);
	
	Если ТипЗнч(ТЗ) = Тип("ТаблицаЗначений") Тогда
		
		Модифицированность = Истина;
		Объект[ИмяТабличнойЧасти].Загрузить(ТЗ)
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТаблицыДеталиПрисадки(Адреса)
	
	ТЗ = ПолучитьИзВременногоХранилища(Адреса.Детали);
	Объект.СписокДеталей.Загрузить(ТЗ);
	
	ТЗ = ПолучитьИзВременногоХранилища(Адреса.Присадки);
	Объект.СписокПрисадок.Загрузить(ТЗ);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДеталейОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЗагрузитьТаблицыДеталиПрисадки(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСостав(Команда)
	
	Отказ = Истина;
	
	ИмяТекущейСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	
	Если ИмяТекущейСтраницы = "СтраницаМатериалы" Тогда
		
		ИмяПодбора = "ФормаВыборМатериала";
		
		ТаблицаДляФормы = Новый Структура();
		ТаблицаДляФормы.Вставить("Детали", Объект.СписокДеталей);
		ТаблицаДляФормы.Вставить("Присадки", Объект.СписокПрисадок);
		
		СтрокаДанных = Элементы.СписокДеталей.ТекущиеДанные;
		ВладелецПодобра = Элементы.СписокДеталей;
		
	ИначеЕсли ИмяТекущейСтраницы = "СтраницаЯщики" Тогда
		
		ИмяПодбора = "ФормаЯщики";
		ТаблицаДляФормы = Объект.СписокЯщики;
		СтрокаДанных = Элементы.СписокЯщики.ТекущиеДанные;
		ВладелецПодобра = Элементы.СписокЯщики;
		
	КонецЕсли;
	
	ОткрытьФормуПодбора(ИмяПодбора, ТаблицаДляФормы, СтрокаДанных, ВладелецПодобра);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РабочийКаталог = ЛексКлиент.ПолучитьПутьКаталогаФайлов();
	ОтобразитьКартинку();
	ВидимостьНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзображение(Команда)
	
	ПараметрыФормы = Новый Структура("ВсегдаОткрывать", Истина);
	ОткрытьФормуМодально("Обработка.СинхронизацияФайлов.Форма", ПараметрыФормы, ЭтаФорма);
	
	ОтобразитьКартинку();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьКартинку() 
	
	Если ЗначениеЗаполнено(Объект.Код) Тогда
		АдресВХранилище = "";
		ИмяФайла = РабочийКаталог + ПредопределенноеЗначение("Перечисление.ВидыПрисоединенныхФайлов.ОсновнаяКартинка") + Объект.Код;
		ФайлИзображения = Новый Файл(ИмяФайла);
		Если ФайлИзображения.Существует() Тогда
			ПоместитьФайл(АдресВХранилище, ИмяФайла, , Ложь, ЭтаФорма.УникальныйИдентификатор);
			Изображение  = АдресВХранилище;
		Иначе
			ИмяФайла = РабочийКаталог + ПредопределенноеЗначение("Перечисление.ВидыПрисоединенныхФайлов.КартинкаПравая") + Объект.Код;
			ФайлИзображения = Новый Файл(ИмяФайла);
			Если ФайлИзображения.Существует() Тогда
				ПоместитьФайл(АдресВХранилище, ИмяФайла, , Ложь, ЭтаФорма.УникальныйИдентификатор);
				Изображение  = АдресВХранилище;
			Иначе
				ИмяФайла = РабочийКаталог + ПредопределенноеЗначение("Перечисление.ВидыПрисоединенныхФайлов.КартинкаЛевая") + Объект.Код;
				ФайлИзображения = Новый Файл(ИмяФайла);
				Если ФайлИзображения.Существует() Тогда
					ПоместитьФайл(АдресВХранилище, ИмяФайла, , Ложь, ЭтаФорма.УникальныйИдентификатор);
					Изображение  = АдресВХранилище;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыКоличествоПриИзменении(Элемент)
	
	Количество = Элементы.СписокНоменклатуры.ТекущиеДанные.Количество;
	Проверка = 0;
	
	Если ЗначениеЗаполнено(Объект.ГлубинаИзделия) И ЗначениеЗаполнено(Объект.ВысотаИзделия)
		И ЗначениеЗаполнено(Объект.ШиринаИзделия) Тогда
		
	Иначе
		Количество = "";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните средние значения изделия");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КорневойВид = ПолучитьКорневойВид(Объект.ВидИзделияПоКаталогу);
	
	Если КорневойВид = Справочники.ВидыИзделийПоКаталогу.ОсновнойЭлемент Тогда
		
		ОбновитьХарактеристики();
		
	КонецЕсли;
	
	Элементы.ГруппаДопРазмеры.Видимость = Объект.УгловоеИзделие;	
	
КонецПроцедуры

&НаКлиенте
Процедура Несовместимость(Команда)
	
	ПараметрыФормы = Новый Структура("Изделие", Объект.Ссылка);
	ОткрытьФормуМодально("Справочник.КаталогИзделий.Форма.ФормаНесовместимости", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Элементы.ФормаНесовместимость.Доступность = ЗначениеЗаполнено(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидИзделияПоКаталогуПриИзменении(Элемент)
	
	КорневойВид = ПолучитьКорневойВид(Объект.ВидИзделияПоКаталогу);
	
	ВидимостьНастроек();
	
	Если КорневойВид = ПредопределенноеЗначение("Справочник.ВидыИзделийПоКаталогу.ОсновнойЭлемент") Тогда
		
		ОбновитьХарактеристики();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьНастроек()
	
	ЭтоКухняНижний = КорневойВид = ПредопределенноеЗначение("Справочник.ВидыИзделийПоКаталогу.КухняНижний");
	ЭтоКухняВерхний = КорневойВид = ПредопределенноеЗначение("Справочник.ВидыИзделийПоКаталогу.КухняВерхний");
	ЭтоОсновнойЭлемент = КорневойВид = ПредопределенноеЗначение("Справочник.ВидыИзделийПоКаталогу.ОсновнойЭлемент");
	ЭтоБоковойЭлемент = КорневойВид = ПредопределенноеЗначение("Справочник.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент");
	
	Элементы.НаВсеИзделие.Доступность = КорневойВид = ПредопределенноеЗначение("Справочник.ВидыИзделийПоКаталогу.Потолок");
	Элементы.СтраницаОтсеков.Доступность = ЭтоОсновнойЭлемент;
	
	Элементы.НеВлияетНаОсновной.Доступность = (НЕ ЭтоКухняНижний И НЕ ЭтоКухняВерхний И НЕ ЭтоОсновнойЭлемент
	И КорневойВид <> ПредопределенноеЗначение("Справочник.ВидыИзделийПоКаталогу.Комод")
	И КорневойВид <> ПредопределенноеЗначение("Справочник.ВидыИзделийПоКаталогу.НадстройкаКомода")
	И КорневойВид <> ПредопределенноеЗначение("Справочник.ВидыИзделийПоКаталогу.КорпуснаяМебель"));
	
	Элементы.Угловой.Доступность = (ЭтоКухняНижний ИЛИ ЭтоКухняВерхний);
	
	Элементы.Корпусный.Доступность = (НЕ ЭтоКухняНижний И НЕ ЭтоКухняВерхний
	И КорневойВид <> ПредопределенноеЗначение("Справочник.ВидыИзделийПоКаталогу.Комод")
	И КорневойВид <> ПредопределенноеЗначение("Справочник.ВидыИзделийПоКаталогу.НадстройкаКомода"));
	
	Элементы.СтраницаХарактеристик.Видимость = ЭтоОсновнойЭлемент;
	
	Элементы.РадиусЭлемента.Доступность = ЭтоБоковойЭлемент;
	Элементы.ШиринаКрыши.Доступность = ЭтоБоковойЭлемент;
	Элементы.ЭлементСКрышей.Доступность = ЭтоБоковойЭлемент;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКорневойВид(ВидИзделия)
	
	//Справочник наш, при условии что 2 уровня в иерархии
	Возврат ?(ВидИзделия.Родитель.Пустая(), ВидИзделия, ВидИзделия.Родитель);
	
КонецФункции

&НаКлиенте
Процедура СписокХарактеристикПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокХарактеристикПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ШиринаКрышиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьРедакторФормул(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ШиринаИзделияСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьРедакторФормул(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВысотаИзделияСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьРедакторФормул(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ГлубинаИзделияСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьРедакторФормул(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРедакторФормул(Элемент)
	
	ПараметрыФормы = Новый Структура("Формула, ИмяПеременной, Режим", Элемент.ТекстРедактирования, Элемент.Имя, "Каталог");
	Форма = ПолучитьФорму("ОбщаяФорма.РедакторФормул", ПараметрыФормы, Элемент);
	Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Форма.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыКоличествоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьРедакторФормул(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокОтсековКоэффициентОтсекаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьРедакторФормул(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура УгловоеИзделиеПриИзменении(Элемент)
	Элементы.ГруппаДопРазмеры.Видимость = Объект.УгловоеИзделие;
КонецПроцедуры

&НаКлиенте
Процедура ШиринаФактическаяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьРедакторФормул(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВысотаФактическаяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьРедакторФормул(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ГлубинаФактическаяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьРедакторФормул(Элемент);
КонецПроцедуры
