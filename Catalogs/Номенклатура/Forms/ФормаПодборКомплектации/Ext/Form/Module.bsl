﻿&НаКлиенте
Перем РабочийКаталог;

/// ОБРАБОТЧИКИ СОБЫТИЙ /////////////////////////////////////////////////////////////////////

&НаСервере
Процедура УстановитьПараметрыЗапроса(РодительНоменклатуры, СтрокаПоиска)
	
	Если НомГруппы.Количество() > 0 Тогда
		
		МассивНомГруппы = Новый Массив;
		
		Для каждого Знч Из НомГруппы Цикл
			МассивНомГруппы.Добавить(Знч.Значение);
		КонецЦикла;
		
	Иначе
		МассивНомГруппы = NULL;
	КонецЕсли; 
	
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("НомГруппы", МассивНомГруппы);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("Производство", Производство);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("Поиск", СтрокаПоиска);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("РодительНоменклатуры", РодительНоменклатуры);
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Производство") Тогда
		Производство = Параметры.Производство;	
	Иначе
		Производство = Справочники.Подразделения.ПустаяСсылка();
	КонецЕсли;
	
	Если Параметры.Свойство("НомГруппы") Тогда
		НомГруппы = Параметры.НомГруппы;
		Режим = 1;
	Иначе
		НомГруппы = Новый СписокЗначений;
		Режим = 0;
	КонецЕсли;
	
	УстановитьПараметрыЗапроса(Справочники.Номенклатура.ПустаяСсылка(),"");
	
	Если Режим = 1 Тогда
		
		Элементы.Выбранные.Видимость = Ложь;
		Элементы.ВводКоличества.Видимость = Ложь;
		Элементы.КаталогНоменклатурыНаименование.Видимость = Ложь;
		
	Иначе 
		
		Если Параметры.Свойство("Комплектация") Тогда
			
			ТЗ = ПолучитьИзВременногоХранилища(Параметры.Комплектация.АдресТаблицы);
			Выбранные.Загрузить(ТЗ);
			
			Для каждого Элем Из Выбранные Цикл
				
				Элем.Кратность = Элем.Номенклатура.Кратность;
				Элем.Код = Элем.Номенклатура.Код; 
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Режим = 0 Тогда
		Элементы.ГруппаНоменклатура.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	Иначе
		Элементы.ГруппаНоменклатура.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	КонецЕсли; 
	
	РабочийКаталог = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
	ВыбранныеОбновитьСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.КаталогНоменклатуры.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если Режим = 0 Тогда
			РодительНоменклатуры = ТекущиеДанные.Ссылка;
		Иначе
			РодительНоменклатуры = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
			
		КонецЕсли; 
		
		УстановитьПараметрыЗапроса(РодительНоменклатуры,"");
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ВыборНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	
	Если Режим = 0 Тогда
		
		Если ВводКоличества Тогда
			ПоказатьФормуВводаКоличества(Элемент.ТекущиеДанные);
		Иначе
			НомСсылка=Элемент.ТекущиеДанные.Номенклатура;
			Данные = ЛексСервер.ЗначенияРеквизитовОбъекта(НомСсылка, "ЕдиницаИзмерения,Кратность,Код");
			ВыбранныеДобавитьЭлемент(1, НомСсылка, Данные.ЕдиницаИзмерения, Данные.Кратность, Данные.Код);
		КонецЕсли;
	Иначе
		ОповеститьОВыборе(Элемент.ТекущиеДанные.Номенклатура);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПослеУдаления(Элемент)
	
	ВыбранныеОбновитьСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ПолучитьДанныеПоиска(Текст);
	Элементы.ВыборНоменклатуры.Обновить();
	СтрокаПоиска = Текст;
	
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

&НаКлиенте
Процедура ВыборНоменклатурыПриАктивизацииСтроки(Элемент)
	
	Элементы.ВыборНоменклатуры.ТекущаяСтрока=Неопределено;
	ПоказатьКартинку(Элементы.ВыборНоменклатуры.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПриАктивизацииСтроки(Элемент)
	
	Элементы.Выбранные.ТекущаяСтрока=Неопределено;
	ПоказатьКартинку(Элементы.Выбранные.ТекущиеДанные);
	
КонецПроцедуры

/// ДОПОЛНИТЕЛЬНЫЕ ФУНКЦИИ /////////////////////////////////////////////////////////////////////
&НаСервере
Функция ПолучитьАдресХранилища()
	Если Режим = 0 Тогда
		АдресТаблицы = ПоместитьВоВременноеХранилище(Выбранные.Выгрузить());
		СтруктураОповещения = Новый Структура;
		СтруктураОповещения.Вставить("АдресТаблицы", АдресТаблицы);
		СтруктураОповещения.Вставить("Таблица", "ПодборКомплектации");
		
	Иначе
		АдресТаблицы = ПоместитьВоВременноеХранилище(Выбранные.Выгрузить());
		СтруктураОповещения = Новый Структура;
		СтруктураОповещения.Вставить("АдресТаблицы", АдресТаблицы);
		СтруктураОповещения.Вставить("Таблица", "ПодборКомплектации");
		
	КонецЕсли; 	
	
	Возврат СтруктураОповещения;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьФормуВводаКоличества(Ссылка)
	
	Пар = Новый Структура("ВыбранныйЭлементСсылка",Ссылка);
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВводаКоличества", Пар, ЭтаФорма, Неопределено, Неопределено, Неопределено, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеОбновитьСтроки()
	
	НомСтроки = 1;
	Для каждого Ном Из Выбранные Цикл
		
		Ном.Номер = НомСтроки;
		НомСтроки = НомСтроки+1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеДобавитьЭлемент(Кол, Элем, ЕдиницаИзмерения, Кратность, Код) Экспорт
	
	Модифицированность=Истина;
	ФлагСуществования=0;
	Для каждого Ном Из Выбранные Цикл
		
		Если Ном.Номенклатура=Элем И НЕ ЗначениеЗаполнено(Ном.НомерИзделия) Тогда
			
			Ном.Количество=Ном.Количество+Кол;
			ФлагСуществования=1;
			Прервать;
			
		КонецЕсли; 
		
	КонецЦикла;
	
	Если ФлагСуществования = 0 Тогда
		НоваяСтрока = Выбранные.Вставить(0);
		НоваяСтрока.Номенклатура = Элем;
		НоваяСтрока.Количество = Кол;
		НоваяСтрока.ЕдиницаИзмерения = ЕдиницаИзмерения;
		НоваяСтрока.Кратность = Кратность;
		НоваяСтрока.Код = Код;
		ВыбранныеОбновитьСтроки();
		Элементы.Выбранные.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеПоиска(Текст)
	
	МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст," ",Истина);
	Стр="%"+СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(МассивСтрок, "%")+"%";
	
	УстановитьПараметрыЗапроса(Справочники.Номенклатура.ПустаяСсылка(), Стр); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Модифицированность=Ложь;
	
	Если Режим = 0 Тогда
		ОповеститьОВыборе(ПолучитьАдресХранилища());
	Иначе
		ОповеститьОВыборе(Элементы.ВыборНоменклатуры.ТекущиеДанные.Номенклатура);	
	КонецЕсли; 
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКодНоменклатуры(Ссылка)
	
	Возврат Ссылка.Код;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьКартинку(Элемент)
	
	Если Элемент = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Попытка
		
		Код=Элемент.Код;
		Код = СокрЛП(Код);
		ПутьКИзображению = РабочийКаталог + Код + ".jpg";
		ФайлНаДиске = Новый Файл(ПутьКИзображению);
		
		Если ФайлНаДиске.Существует() Тогда
			//Если Режим = 0 Тогда
			//	Изображение = "<html><head><META HTTP-EQUIV=""Pragma"" CONTENT=""no-cache""></head><body bottommargin=""0"" topmargin=""0"" leftmargin=""0"" rightmargin=""0""><img src=""" + ПутьКИзображению + """ height=100% /></body></html>";
			//Иначе
			//	Изображение = "<html><head><META HTTP-EQUIV=""Pragma"" CONTENT=""no-cache""></head><body bottommargin=""0"" topmargin=""0"" leftmargin=""0"" rightmargin=""0""><img src=""" + ПутьКИзображению + """ width=100% /></body></html>";
			//КонецЕсли;
			
			Изображение = ПутьКИзображению;
			
		Иначе
			Изображение = "";
		КонецЕсли;
		
	Исключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеКоличествоПриИзменении(Элемент)
	
	Кратн=Элементы.Выбранные.ТекущиеДанные.Кратность;
	
	Если Кратн <> 0 Тогда
		Кол=Элементы.Выбранные.ТекущиеДанные.Количество;
		Кол = Кратн*Цел(Кол/Кратн);
		Элементы.Выбранные.ТекущиеДанные.Количество=Кол;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПриИзменении(Элемент)
	
	Модифицированность=Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	ПолучитьДанныеПоиска("");
	Элементы.ВыборНоменклатуры.Обновить();
	СтрокаПоиска = "";
КонецПроцедуры
