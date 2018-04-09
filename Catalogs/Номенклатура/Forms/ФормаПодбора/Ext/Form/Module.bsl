﻿
#Область ПЕРЕМЕННЫЕ_МОДУЛЯ

&НаКлиенте
Перем РабочийКаталог;

#КонецОбласти

#Область ПРОЦЕДУРЫ_И_ФУНКЦИИ_ОБЩЕГО_НАЗНАЧЕНИЯ

&НаСервере
Процедура УстановитьПараметрыЗапроса(РодительНоменклатуры, СтрокаПоиска = "")
	
	Если НомГруппы.Количество() > 0 Тогда
		ФильтрНоменклатурныеГруппы = НомГруппы.ВыгрузитьЗначения()
	Иначе
		ФильтрНоменклатурныеГруппы = Null;
	КонецЕсли;
	
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("НомГруппы", ФильтрНоменклатурныеГруппы);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("Подразделение", Подразделение);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("Поиск", СтрокаПоиска);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("ТолькоБазовая", ТолькоБазовая);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("ТолькоНеБазовая", ТолькоНеБазовая);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("РодительНоменклатуры", РодительНоменклатуры);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("НеПоказыватьЛистовой", НеПоказыватьЛистовой);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("НаценкаОфиса", НаценкаОфиса);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("НаценкаКонтрагента", НаценкаКонтрагента);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("Склад", Склад);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("ЕстьОстаток", ЕстьОстаток);
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ПолучитьДанныеПоиска(Текст);
	Элементы.ВыборНоменклатуры.Обновить();
	СтрокаПоиска = Текст;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресХранилища()
	
	АдресТаблицы = ПоместитьВоВременноеХранилище(Выбранные.Выгрузить());
	СтруктураОповещения = Новый Структура;
	СтруктураОповещения.Вставить("АдресТаблицы", АдресТаблицы);
	СтруктураОповещения.Вставить("Таблица", "Комплектация");
	
	Возврат СтруктураОповещения;
	
КонецФункции

&НаСервере
Процедура ПолучитьДанныеПоиска(Текст)
	
	МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст," ",Истина);
	Стр = "%" + СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(МассивСтрок, "%") + "%";
	
	УстановитьПараметрыЗапроса(Справочники.Номенклатура.ПустаяСсылка(), Стр);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьКартинку(Элемент)
	
	Если Элемент = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Попытка
		
		Код = Элемент.Код;
		Код = СокрЛП(Код);
		ПутьКИзображению = РабочийКаталог + Код;
		ФайлНаДиске = Новый Файл(ПутьКИзображению);
		
		Если ЗначениеЗаполнено(Код) И ФайлНаДиске.Существует() Тогда
			
			Изображение = "<html><head><META HTTP-EQUIV=""Pragma"" CONTENT=""no-cache""></head><body bottommargin=""0"" topmargin=""0"" leftmargin=""0"" rightmargin=""0""><img src=""" + ПутьКИзображению + """ /></body></html>";
			Изображение = ПутьКИзображению;
			
		Иначе
			
			Изображение = "";
			
		КонецЕсли;
		
	Исключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

&НаСервереБезКонтекста
Функция ПолучитьНаценкуКонтрагента(Контрагент)
	
	Наценка = 1;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПараметрыДилеров.Наценка
	|ИЗ
	|	РегистрСведений.ПараметрыДилеров.СрезПоследних(, ) КАК ПараметрыДилеров
	|ГДЕ
	|	ПараметрыДилеров.Контрагент = &Контрагент";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Наценка = Выборка.Наценка;
		
	КонецЕсли;
	
	Возврат Наценка;
	
КонецФункции

#Область ОБРАБОТЧИКИ_СОБЫТИЙ_ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоБазовая = Истина;
	ТолькоНеБазовая = Ложь;
	НеПоказыватьЛистовой = Ложь;
	НаценкаКонтрагента = 1;
	
	Если Параметры.Свойство("Контрагент") Тогда
		НаценкаКонтрагента = ПолучитьНаценкуКонтрагента(Параметры.Контрагент);
	КонецЕсли;
	
	Если Параметры.Свойство("Подразделение") Тогда
		Подразделение = Параметры.Подразделение;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Подразделение) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Укажите подразделение");
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Если Параметры.Свойство("Офис") И ЗначениеЗаполнено(Параметры.ОФис) Тогда
		Офис = Параметры.ОФис;
		НаценкаОфиса = Офис.КоэффициентМатериалы;
	Иначе
		НаценкаОфиса = 1;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Офис) Тогда
		Элементы.Офис.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("Склад") Тогда
		Склад = Параметры.Склад;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Склад) Тогда
		Элементы.Склад.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("НеПоказыватьЛистовой") Тогда
		НеПоказыватьЛистовой = Параметры.НеПоказыватьЛистовой;
	КонецЕсли;
	
	Если Параметры.Свойство("ТолькоБазовая") Тогда
		ТолькоБазовая = Параметры.ТолькоБазовая;
	КонецЕсли;
	
	Если Параметры.Свойство("ТолькоНеБазовая") Тогда
		ТолькоНеБазовая = Параметры.ТолькоНеБазовая;
	КонецЕсли;
	
	Если Параметры.Свойство("НомГруппы") Тогда
		
		Режим = 1;
		НомГруппы = Параметры.НомГруппы;
		ЗаполнитьДеревоНоменклатурыПоНомГруппам();
		
	Иначе
		
		Режим = 0;
		
	КонецЕсли;
	
	УстановитьПараметрыЗапроса(Справочники.Номенклатура.ПустаяСсылка());
	
	Если Режим = 1 Тогда
		
		Элементы.Выбранные.Видимость = Ложь;
		Элементы.ВводКоличества.Видимость = Ложь;
		Элементы.КаталогНоменклатуры.Видимость = Ложь;
		Элементы.ВыборНоменклатуры.РастягиватьПоВертикали = Истина;
		
	Иначе
		
		Элементы.ДеревоНоменклатуры.Видимость = Ложь;
		
		Элементы.НомГруппы.Видимость = Ложь;
		
		Если Параметры.Свойство("Комплектация") Тогда
			
			ТЗ = ПолучитьИзВременногоХранилища(Параметры.Комплектация.АдресТаблицы);
			Выбранные.Загрузить(ТЗ);
			
			Для каждого Элем Из Выбранные Цикл
				
				Элем.Кратность = Элем.Номенклатура.Кратность;
				Элем.Код = Элем.Номенклатура.Код;
				Элем.ЕдиницаИзмерения = Элем.Номенклатура.ЕдиницаИзмерения;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РабочийКаталог = ЛексКлиент.ПолучитьПутьКаталогаФайлов();
	ВыбранныеОбновитьСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ВыборНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка=Ложь;
	
	Если Режим = 0 Тогда
		
		ВведенноеКоличество = 0;
		
		Если ВводКоличества Тогда
			ВвестиЧисло(ВведенноеКоличество, "Введите количество");
		Иначе
			Если ТекущиеДанные.Кратность = 0 Тогда
				ВведенноеКоличество = 1;
			Иначе
				ВведенноеКоличество = ТекущиеДанные.Кратность;
			КонецЕсли;
		КонецЕсли;
		
		ВыбранныеДобавитьЭлемент(ВведенноеКоличество, ТекущиеДанные.Номенклатура, ТекущиеДанные.Код);
		
	Иначе
		
		ОповеститьОВыборе(ТекущиеДанные.Номенклатура);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Выбранные.Количество() > 0 И Модифицированность Тогда
		
		КодДиалога = Вопрос("Выбранные элементы не перенесены в документ. Перенести?", РежимДиалогаВопрос.ДаНетОтмена, 0);
		
		Если КодДиалога = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		КонецЕсли;
		
		Если КодДиалога = КодВозвратаДиалога.Да Тогда
			Модифицированность = Ложь;
			ОповеститьОВыборе(ПолучитьАдресХранилища());
			Выбранные.Очистить();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КОМАНДЫ

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Модифицированность=Ложь;
	
	Если Режим = 0 Тогда
		ОповеститьОВыборе(ПолучитьАдресХранилища());
	Иначе
		ОповеститьОВыборе(Элементы.ВыборНоменклатуры.ТекущиеДанные.Номенклатура);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РАБОТА_С_ТАБЛИЦЕЙ_ВЫБОР_НОМЕНКЛАТУРЫ

&НаКлиенте
Процедура ВыборНоменклатурыПриАктивизацииСтроки(Элемент)
	
	Элементы.ВыборНоменклатуры.ТекущаяСтрока = Неопределено;
	ПоказатьКартинку(Элементы.ВыборНоменклатуры.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеОбновитьСтроки()
	
	НомСтроки = 1;
	Для каждого Ном Из Выбранные Цикл
		
		Ном.Номер = НомСтроки;
		НомСтроки = НомСтроки + 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область РАБОТА_С_ТАБЛИЦЕЙ_ВЫБРАННЫЕ

&НаКлиенте
Процедура ВыбранныеПриИзменении(Элемент)
	
	Модифицированность=Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПослеУдаления(Элемент)
	
	ВыбранныеОбновитьСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПриАктивизацииСтроки(Элемент)
	
	ТДанные = Элементы.Выбранные.ТекущиеДанные;
	Если ТДанные <> Неопределено Тогда
		Элементы.ВыбранныеКоличество.ТолькоПросмотр = (ТДанные.НомерИзделия <> 0);
	КонецЕсли;
	
	Элементы.Выбранные.ТекущаяСтрока=Неопределено;
	ПоказатьКартинку(Элементы.Выбранные.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеДобавитьЭлемент(фКоличество, фНоменклатура, фКод)
	
	НоменклатураСсылка = фНоменклатура;
	СвойстваНоменклатуры = ЛексСервер.ЗначенияРеквизитовОбъекта(НоменклатураСсылка, "Кратность, ЕдиницаИзмерения, Базовый, БазоваяНоменклатура");
	СвойстваНоменклатуры.Вставить("Код", фКод);
	
	Если НЕ СвойстваНоменклатуры.Базовый Тогда
		СвойстваНоменклатуры.Кратность = 1;
	КонецЕсли;
	
	Если СвойстваНоменклатуры.Кратность <> 0 Тогда
		фКоличество = ЛексКлиентСервер.ПолучитьКоличествоСУчетомКратности(фКоличество, СвойстваНоменклатуры.Кратность);
	КонецЕсли;
	
	Модифицированность = Истина;
	ФлагСуществования = 0;
	
	Для каждого Строка Из Выбранные Цикл
		
		Если Строка.Номенклатура = фНоменклатура И НЕ ЗначениеЗаполнено(Строка.НомерИзделия) Тогда
			
			Строка.Количество = Строка.Количество + фКоличество;
			ФлагСуществования = 1;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ФлагСуществования = 0 Тогда
		
		НоваяСтрока = Выбранные.Вставить(0);
		НоваяСтрока.Номенклатура = фНоменклатура;
		НоваяСтрока.Количество = фКоличество;
		
		НоваяСтрока.ЕдиницаИзмерения = СвойстваНоменклатуры.ЕдиницаИзмерения;
		НоваяСтрока.Кратность = СвойстваНоменклатуры.Кратность;
		НоваяСтрока.Код = СвойстваНоменклатуры.Код;
		ВыбранныеОбновитьСтроки();
		Элементы.Выбранные.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Выбранные.ТекущиеДанные;
	ТекущиеДанные.Количество = ЛексКлиентСервер.ПолучитьКоличествоСУчетомКратности(ТекущиеДанные.Количество, ТекущиеДанные.Кратность);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПередУдалением(Элемент, Отказ)
	
	ТДанные = Элементы.Выбранные.ТекущиеДанные;
	
	Если ТДанные.НомерИзделия <> 0 И ТДанные.ПоКаталогуМестоОбработки = "Цех" Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РАБОТА_С_ТАБЛИЦЕЙ_КАТАЛОГ_НОМЕНКЛАТУРЫ

&НаКлиенте
Процедура КаталогНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ОбновитьСписокВыборНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокВыборНоменклатуры()
	
	Если Режим = 1 Тогда
		ТекущиеДанные = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.КаталогНоменклатуры.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		РодительНоменклатуры = ТекущиеДанные.Ссылка;
		УстановитьПараметрыЗапроса(РодительНоменклатуры);
		
	Иначе
		
		УстановитьПараметрыЗапроса(ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область РАБОТА_С_ТАБЛИЦЕЙ_ДЕРЕВО_НОМЕНКЛАТУРЫ

&НаСервере
Процедура ЗаполнитьДеревоНоменклатурыПоНомГруппам()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НомГруппы", НомГруппы);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СпрНоменклатура.Родитель КАК Родитель
	|ПОМЕСТИТЬ втРодители
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|ГДЕ
	|	СпрНоменклатура.НоменклатурнаяГруппа В ИЕРАРХИИ(&НомГруппы)
	|	И НЕ СпрНоменклатура.ПометкаУдаления
	|	И СпрНоменклатура.Подразделение = &Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втРодители.Родитель КАК Ссылка
	|ИЗ
	|	втРодители КАК втРодители
	|
	|УПОРЯДОЧИТЬ ПО
	|	втРодители.Родитель.Наименование
	|ИТОГИ ПО
	|	Ссылка ТОЛЬКО ИЕРАРХИЯ";
	
	ОбъектДерево = РеквизитФормыВЗначение("ДеревоНоменклатуры");
	ОбъектДерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	ЗначениеВРеквизитФормы(ОбъектДерево, "ДеревоНоменклатуры");
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ОбновитьСписокВыборНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ЕстьОстатокПриИзменении(Элемент)
	
	ОбновитьСписокВыборНоменклатуры();
	
КонецПроцедуры

#КонецОбласти

