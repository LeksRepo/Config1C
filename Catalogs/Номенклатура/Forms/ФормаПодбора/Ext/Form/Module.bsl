﻿&НаКлиенте
Перем РабочийКаталог;

/// ОБРАБОТЧИКИ СОБЫТИЙ /////////////////////////////////////////////////////////////////////
&НаСервере
Процедура ЗаполнитьДеревоНоменклатурыПоНомГруппам()
	
	Элем = ДеревоНоменклатуры.ПолучитьЭлементы(); 
    Элем.Очистить();
	
	Если НомГруппы.Количество() > 0 Тогда
		
		МассивНомГруппы = Новый Массив;
		
		Для каждого Знч Из НомГруппы Цикл
			МассивНомГруппы.Добавить(Знч.Значение);
		КонецЦикла;
		
	Иначе
		МассивНомГруппы = NULL;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НомГруппы", МассивНомГруппы);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Доступность", ДоступностьНоменклатуры);
	Запрос.Текст=
	"ВЫБРАТЬ
	|	СпрНоменклатура.Родитель.Наименование КАК Родитель1Наименование,
	|	СпрНоменклатура.Родитель.Родитель.Наименование КАК Родитель2Наименование,
	|	СпрНоменклатура.Родитель.Родитель.Родитель.Наименование КАК Родитель3Наименование,
	|	СпрНоменклатура.Родитель.Родитель.Родитель.Родитель.Наименование КАК Родитель4Наименование,
	|	СпрНоменклатура.Родитель КАК Родитель1,
	|	СпрНоменклатура.Родитель.Родитель КАК Родитель2,
	|	СпрНоменклатура.Родитель.Родитель.Родитель КАК Родитель3,
	|	СпрНоменклатура.Родитель.Родитель.Родитель.Родитель КАК Родитель4
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений КАК НоменклатураПодразделений
	|		ПО СпрНоменклатура.Ссылка = НоменклатураПодразделений.Номенклатура
	|ГДЕ
	|	СпрНоменклатура.НоменклатурнаяГруппа В(&НомГруппы)
	|	И НЕ СпрНоменклатура.ПометкаУдаления
	|	И НоменклатураПодразделений.Подразделение = &Подразделение
	|	И НоменклатураПодразделений.Доступность = &Доступность
	|	И НоменклатураПодразделений.Номенклатура.Базовый
	|
	|СГРУППИРОВАТЬ ПО
	|	СпрНоменклатура.Родитель,
	|	СпрНоменклатура.Родитель.Родитель,
	|	СпрНоменклатура.Родитель.Родитель.Родитель,
	|	СпрНоменклатура.Родитель.Родитель.Родитель.Родитель
	|
	|УПОРЯДОЧИТЬ ПО
	|	Родитель4Наименование,
	|	Родитель3Наименование,
	|	Родитель2Наименование,
	|	Родитель1Наименование;";

	Результат = Запрос.Выполнить().Выгрузить();
	
	Если Результат.Количество() > 0 Тогда
	
		ОбходДереваНоменклатуры(Результат, ДеревоНоменклатуры, Неопределено, 4);
		ОбходДереваНоменклатуры(Результат, ДеревоНоменклатуры, Неопределено, 3);
		ОбходДереваНоменклатуры(Результат, ДеревоНоменклатуры, Неопределено, 2);
		ОбходДереваНоменклатуры(Результат, ДеревоНоменклатуры, Неопределено, 1);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНомИзТаблицы(Таблица, Ссылка)
	
	Для Каждого Строка Из Таблица Цикл
							
		 Если Строка.Родитель1 = Ссылка Тогда
			  Строка.Родитель1  = Неопределено;
		 КонецЕсли;
		 Если Строка.Родитель2 = Ссылка Тогда
			  Строка.Родитель2  = Неопределено;
		 КонецЕсли;
		 Если Строка.Родитель3 = Ссылка Тогда
			  Строка.Родитель3  = Неопределено;
		 КонецЕсли;
		 Если Строка.Родитель4 = Ссылка Тогда
			  Строка.Родитель4  = Неопределено;
		 КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбходДереваНоменклатуры(Данные, Ветка, Родитель, Уровень)
	
	Если Уровень > 0 Тогда
	
			Для Каждого Строка Из Данные Цикл
				
				ТекущиеДанные = Строка["Родитель"+Уровень];
				
				Если (НЕ ЗначениеЗаполнено(Родитель)) ИЛИ (Строка["Родитель"+(Уровень+1)]=Родитель) Тогда
				
						Если ЗначениеЗаполнено(ТекущиеДанные) Тогда
							
							 Эл = Ветка.ПолучитьЭлементы().Добавить();
							 Эл.Ссылка = ТекущиеДанные;
							 
							 Если (Уровень-1) > 0 Тогда
							 	ОбходДереваНоменклатуры(Данные, Эл, ТекущиеДанные, Уровень-1);
							 КонецЕсли;
							
							 УдалитьНомИзТаблицы(Данные, ТекущиеДанные);
 			
						 КонецЕсли;
					
				КонецЕсли;

			КонецЦикла;
			
	КонецЕсли;
		
КонецПроцедуры

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
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("Подразделение", Подразделение);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("Поиск", СтрокаПоиска);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("ТолькоБазовая", ТолькоБазовая);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("РодительНоменклатуры", РодительНоменклатуры);
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("Доступность", ДоступностьНоменклатуры);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоступностьНоменклатуры = Истина;
	
	ТолькоБазовая = Истина;
	
	Если Параметры.Свойство("Подразделение") Тогда
		Подразделение = Параметры.Подразделение;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Подразделение) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Укажите подразделение");
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Дилер = РольДоступна("ДилерскийДоступКСпецификации");
	Администратор = РольДоступна("ПолныеПрава");
	Элементы.ДоступнаяНеДоступнаяНоменклатура.Видимость = Дилер ИЛИ Администратор;
		
	Если Параметры.Свойство("НомГруппы") Тогда
			
		НомГруппы = Параметры.НомГруппы;
		Режим = 1;
		
		ЗаполнитьДеревоНоменклатурыПоНомГруппам();
		
	Иначе
		
		Если Параметры.Свойство("ТолькоБазовая") Тогда
			ТолькоБазовая = Параметры.ТолькоБазовая;
			
			Если НЕ ТолькоБазовая Тогда
				
				Элементы.Подразделение.Видимость=Ложь;
				Элементы.ДоступнаяНеДоступнаяНоменклатура.Видимость=Ложь;
				
			КонецЕсли;
			
		КонецЕсли;
	
		НомГруппы = Новый СписокЗначений;
		Режим = 0;
	
	КонецЕсли;
		
	УстановитьПараметрыЗапроса(Справочники.Номенклатура.ПустаяСсылка(),"");
	
	Если Режим = 1 Тогда
		
		Элементы.Выбранные.Видимость = Ложь;
		Элементы.ВводКоличества.Видимость = Ложь;
		Элементы.КаталогНоменклатуры.Видимость = Ложь;
		Элементы.ВыборНоменклатуры.РастягиватьПоВертикали = Истина;
		
		ПоказыватьГруппы = Истина;
		
	Иначе
		
		Элементы.ДеревоНоменклатуры.Видимость = Ложь;

		ПоказыватьГруппы = Истина;
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
Процедура РазвернутьДеревоНоменклатуры()
	
	 КоллекцияЭлементовДерева=ДеревоНоменклатуры.ПолучитьЭлементы();
	
	 Для Каждого Строка Из КоллекцияЭлементовДерева Цикл    
		 
		 ИдентификаторСтроки=Строка.ПолучитьИдентификатор();
	     Элементы.ДеревоНоменклатуры.Развернуть(ИдентификаторСтроки);
		
		 КоллекцияЭлементовДерева2 = Строка.ПолучитьЭлементы();
		
		 Для Каждого Строка2 Из КоллекцияЭлементовДерева2 Цикл
			 
			  ИдентификаторСтроки2=Строка2.ПолучитьИдентификатор();
	     	  Элементы.ДеревоНоменклатуры.Развернуть(ИдентификаторСтроки2);
	 
		 КонецЦикла	 
			 
	 КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РабочийКаталог = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
	ВыбранныеОбновитьСтроки();
	РазвернутьДеревоНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.КаталогНоменклатуры.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если Режим = 0 Тогда
			РодительНоменклатуры = ТекущиеДанные.Ссылка;
		Иначе
			Если ПоказыватьГруппы Тогда
				РодительНоменклатуры = ТекущиеДанные.Ссылка;
			Иначе
				РодительНоменклатуры = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
			КонецЕсли;
		КонецЕсли; 
		
		УстановитьПараметрыЗапроса(РодительНоменклатуры,"");
	Иначе
		
		УстановитьПараметрыЗапроса(ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"),"");
		
	КонецЕсли;
	
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
			ВведенноеКоличество = 1;
		КонецЕсли;
		
		ВыбранныеДобавитьЭлемент(ВведенноеКоличество, ТекущиеДанные.Номенклатура, ТекущиеДанные.Код);
		
	Иначе
		
		ОповеститьОВыборе(ТекущиеДанные.Номенклатура);
		
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
	
	Элементы.ВыборНоменклатуры.ТекущаяСтрока = Неопределено;
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
Процедура ВыбранныеОбновитьСтроки()
	
	НомСтроки = 1;
	Для каждого Ном Из Выбранные Цикл
		
		Ном.Номер = НомСтроки;
		НомСтроки = НомСтроки + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеДобавитьЭлемент(фКоличество, фНоменклатура, фКод)
	
	НоменклатураСсылка = фНоменклатура;
	СвойстваНоменклатуры = ЛексСервер.ЗначенияРеквизитовОбъекта(НоменклатураСсылка, "Кратность, ЕдиницаИзмерения");
	СвойстваНоменклатуры.Вставить("Код",фКод);
	
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

&НаКлиенте
Процедура ПоказатьКартинку(Элемент)
	
	Если Элемент = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Попытка
		
		Код=Элемент.Код;
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

&НаКлиенте
Процедура ВыбранныеКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Выбранные.ТекущиеДанные;
	
	Кратн = ТекущиеДанные.Кратность;
	
	Если Кратн <> 0 Тогда
		Кол = ТекущиеДанные.Количество;
		Кол = Кратн * Цел(Кол/Кратн);
		ТекущиеДанные.Количество=Кол;
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

&НаКлиенте
Процедура ДоступнаяНеДоступнаяНоменклатура(Команда)
	
	ДоступностьНоменклатуры = НЕ ДоступностьНоменклатуры;
	
	ЗаполнитьДеревоНоменклатурыПоНомГруппам();
	РазвернутьДеревоНоменклатуры();
	ВыборНоменклатуры.Параметры.УстановитьЗначениеПараметра("Доступность", ДоступностьНоменклатуры);
	
	Элементы.НадписьПредоставитьСамостоятельно.Видимость = НЕ ДоступностьНоменклатуры;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьГруппы(Команда)
	
	// { Васильев Александр Леонидович [08.06.2015]
	// Не согласен что отключили.
	Заглушка = Истина;
	// } Васильев Александр Леонидович [08.06.2015]
	
	
	//RonEXI: Дима сказал убрать кнопку, пока не удаляю код.
	
	//ПоказыватьГруппы = НЕ ПоказыватьГруппы;
	//
	//Если Режим = 1 Тогда
	//	 Элементы.ДеревоНоменклатуры.Видимость = ПоказыватьГруппы;
	//Иначе	
	//	 Элементы.КаталогНоменклатуры.Видимость = ПоказыватьГруппы; 
	// КонецЕсли;
	//
	//Если НЕ ПоказыватьГруппы Тогда
	//	 УстановитьПараметрыЗапроса(ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"),"");
	//КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ПоказыватьГруппы Тогда
			РодительНоменклатуры = ТекущиеДанные.Ссылка;
		Иначе
			РодительНоменклатуры = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
		КонецЕсли; 
		
		УстановитьПараметрыЗапроса(РодительНоменклатуры,"");
	Иначе
		
		УстановитьПараметрыЗапроса(ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"),"");
		
	КонецЕсли;

КонецПроцедуры
