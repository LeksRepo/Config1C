﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураАдреса = Новый Структура;
	
	СтруктураАдреса.Вставить("НаселенныйПункт","");
	СтруктураАдреса.Вставить("Улица","");
	СтруктураАдреса.Вставить("Дом","");
	СтруктураАдреса.Вставить("Подъезд","");
	СтруктураАдреса.Вставить("КодПодъезда","");
	СтруктураАдреса.Вставить("Этаж","");
	СтруктураАдреса.Вставить("Квартира","");
	
	//Разбираем старый адрес на сотовляющие и определяем город или населенный пункт
	Если ЗначениеЗаполнено(Параметры.СтарыйАдрес) Тогда
		
		СтруктураДляУлиц = Новый Структура;
		НаселенныйПункт = "";
		СтарыйАдрес = Параметры.СтарыйАдрес;
		СтарыйАдрес = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтарыйАдрес, ", ");
		
		СтруктураАдреса.Вставить("НаселенныйПункт", СтарыйАдрес[0]);
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("НаселенныйПункт", СтарыйАдрес[0]);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Адреса.КодАдресногоОбъектаВКоде,
		|	Адреса.КодГородаВКоде,
		|	Адреса.КодНаселенногоПунктаВКоде,
		|	Адреса.КодРайона
		|ИЗ
		|	РегистрСведений.Адреса КАК Адреса
		|ГДЕ
		|	Адреса.НаселенныйПункт = &НаселенныйПункт";
		Выборка = Запрос.Выполнить().Выбрать();
		
		Выборка.Следующий();
		СтруктураДляУлиц.Вставить("КодАдресногоОбъектаВКоде", Выборка.КодАдресногоОбъектаВКоде);
		СтруктураДляУлиц.Вставить("КодГородаВКоде", Выборка.КодГородаВКоде);
		СтруктураДляУлиц.Вставить("КодНаселенногоПунктаВКоде", Выборка.КодНаселенногоПунктаВКоде);
		СтруктураДляУлиц.Вставить("КодРайона", Выборка.КодРайона);
		СтруктураУлицИСокращений = ЗапроситьСписокУлиц(СтруктураДляУлиц);
		СтруктураАдреса.Вставить("СписокУлиц", СтруктураУлицИСокращений.СписокУлиц);
		
		СтруктураНаселенногоПункта = Новый Структура;
		СтруктураНаселенногоПункта.Вставить("СписокУлиц", СтруктураУлицИСокращений);
		Элементы.Улица.СписокВыбора.ЗагрузитьЗначения(СтруктураАдреса.СписокУлиц);
		
		МассивСокращений = СтруктураУлицИСокращений.Сокращения;
		
		Для каждого Элемент Из СтарыйАдрес Цикл
			
			Для каждого ЭлементМассива Из МассивСокращений Цикл
			
				СтруктураАдреса.Вставить("Улица", ?(Найти(Элемент, ЭлементМассива) > 0, Элемент,СтруктураАдреса.Улица));  //   СтрЗаменить( , ЭлементМассива,"")
			
			КонецЦикла;
			
			СтруктураАдреса.Вставить("Дом", ?( Найти(Элемент, "дом. ") > 0, СтрЗаменить(Элемент, "дом. ",""),СтруктураАдреса.Дом));
			СтруктураАдреса.Вставить("Подъезд", ?( Найти(Элемент, "подъезд. ") > 0, СтрЗаменить(Элемент, "подъезд. ",""),СтруктураАдреса.Подъезд));
			СтруктураАдреса.Вставить("КодПодъезда", ?( Найти(Элемент, "код подъезда. ") > 0, СтрЗаменить(Элемент, "код подъезда. ",""),СтруктураАдреса.КодПодъезда));
			СтруктураАдреса.Вставить("Этаж", ?( Найти(Элемент, "этаж. ") > 0, СтрЗаменить(Элемент, "этаж. ",""),СтруктураАдреса.Этаж));
			СтруктураАдреса.Вставить("Квартира", ?( Найти(Элемент, "кв. ") > 0, СтрЗаменить(Элемент, "кв. ",""),СтруктураАдреса.Квартира));
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураАдреса.Улица <> "" или СтруктураАдреса.Улица = "" и СтруктураАдреса.НаселенныйПункт = "" Тогда
		
		АвтоматическийВвод = Истина;
		Элементы.ПоКлассификатору.Видимость = Истина;
		Элементы.РучнойНабор.Видимость = Ложь;
		НаселенныйПункт = СтруктураАдреса.НаселенныйПункт;
		Улица = СтруктураАдреса.Улица;
		Дом = СтруктураАдреса.Дом;
		Подъезд = СтруктураАдреса.Подъезд;
		КодПодъезда = СтруктураАдреса.КодПодъезда;
		Этаж = СтруктураАдреса.Этаж;
		Квартира = СтруктураАдреса.Квартира;
		
	Иначе 
		
		АвтоматическийВвод = Ложь;
		Элементы.ПоКлассификатору.Видимость = Ложь;
		Элементы.РучнойНабор.Видимость = Истина;
		НаселенныйПунктВручную = СтруктураАдреса.НаселенныйПункт;
		ПроверочнаяУлица = СтарыйАдрес[1];
		
		Если ЗначениеЗаполнено(СтруктураАдреса.Улица) Тогда
			
			УлицаВручную = СтруктураАдреса.Улица;
			
		ИначеЕсли ЗначениеЗаполнено(ПроверочнаяУлица) Тогда
			
			УлицаВручную = ПроверочнаяУлица;
			
		Иначе
			
			УлицаВручную = "";
			
		КонецЕсли;
		
		ДомВручную = СтруктураАдреса.Дом;
		ПодъездВручную = СтруктураАдреса.Подъезд;
		КодПодъездаВручную = СтруктураАдреса.КодПодъезда;
		ЭтажВручную = СтруктураАдреса.Этаж;
		КвартираВручную = СтруктураАдреса.Квартира;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметры.СтарыйАдрес) Тогда
		
		АвтоматическийВвод = Истина;
		
	КонецЕсли;
		
	Запрос = Новый Запрос;
	
	Если Параметры.Свойство("Офис") Тогда
		
		ГородВладелец = Параметры.Офис.Город;
		
	ИначеЕсли Параметры.Свойство("Подразделение") Тогда
		
		ГородВладелец = Параметры.Подразделение.Город;
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ГородВладелец", ГородВладелец);
	Запрос.УстановитьПараметр("НаселенныйПункт", НаселенныйПункт);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Адреса.Километраж
	|ИЗ
	|	РегистрСведений.Адреса КАК Адреса
	|ГДЕ
	|	Адреса.ГородВладелец = &ГородВладелец
	|	И Адреса.НаселенныйПункт = &НаселенныйПункт";
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Километраж = Выборка.Километраж;
		
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////
//// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

//////////////////////////////////////////////////////////////////////////////////
//// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Функция СформироватьАдрес()
	
	Адрес = "";
	
	Если АвтоматическийВвод Тогда
		
		Адрес = Адрес + НаселенныйПункт + ", " + Улица + "," + " дом. " + Дом + "," + ?(ЗначениеЗаполнено(Подъезд), " подъезд. " + Подъезд + ",", "") + 
		?(ЗначениеЗаполнено(КодПодъезда), " код подъезда. " + КодПодъезда + ",", "") + " этаж. " + Этаж + "," + ?(ЗначениеЗаполнено(Квартира), " кв. " + Квартира, "");
		
	Иначе
		
		Адрес = Адрес + НаселенныйПунктВручную + ", " + УлицаВручную + "," + " дом. " + ДомВручную + "," + ?(ЗначениеЗаполнено(ПодъездВручную), " подъезд. " + ПодъездВручную + ",", "") + 
		?(ЗначениеЗаполнено(КодПодъездаВручную), " код подъезда. " + КодПодъездаВручную + ",", "") + " этаж. " + ЭтажВручную + "," + ?(ЗначениеЗаполнено(КвартираВручную), " кв. " + КвартираВручную, "");
		
	КонецЕсли;
	
	ОтображениеАдреса = Адрес;
	
	Возврат Адрес;
	
КонецФункции // СформироватьАдрес()

&НаКлиенте
Процедура КомандаОКВыполнить()
	
	Если АвтоматическийВвод Тогда
		
		Если Этаж = 0 Тогда
			
			Этаж = 1;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(НаселенныйПункт) Тогда
			
			//ОбщегоНазначенияКлиентСервер.СообщитьПользователю();
			Сообщение=Новый СообщениеПользователю();
			Сообщение.Текст="Не заполнен населенный пункт!";
			Сообщение.Поле="НаселенныйПункт";
			Сообщение.Сообщить();
			Возврат;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Улица) Тогда
			
			Сообщение=Новый СообщениеПользователю();
			Сообщение.Текст="Не заполнена улица!";
			Сообщение.Поле="Улица";
			Сообщение.Сообщить();
			Возврат;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Дом) Тогда
			
			Сообщение=Новый СообщениеПользователю();
			Сообщение.Текст="Не заполнен номер дома!";
			Сообщение.Поле="Дом";
			Сообщение.Сообщить();
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		Если ЭтажВручную = 0 Тогда
			
			ЭтажВручную = 1;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(НаселенныйПунктВручную) Тогда
			
			//ОбщегоНазначенияКлиентСервер.СообщитьПользователю();
			Сообщение=Новый СообщениеПользователю();
			Сообщение.Текст="Не заполнен населенный пункт!";
			Сообщение.Поле="НаселенныйПунктВручную";
			Сообщение.Сообщить();
			Возврат;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(УлицаВручную) Тогда
			
			Сообщение=Новый СообщениеПользователю();
			Сообщение.Текст="Не заполнена улица!";
			Сообщение.Поле="УлицаВручную";
			Сообщение.Сообщить();
			Возврат;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДомВручную) Тогда
			
			Сообщение=Новый СообщениеПользователю();
			Сообщение.Текст="Не заполнен номер дома!";
			Сообщение.Поле="ДомВручную";
			Сообщение.Сообщить();
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Адрес = "";
	Адрес = СформироватьАдрес();
	СтруктураПередачиАдреса = Новый Структура;
	СтруктураПередачиАдреса.Вставить("Адрес", Адрес);
	СтруктураПередачиАдреса.Вставить("Километраж", ?(АвтоматическийВвод, Километраж, КилометражВручную));
	
	Закрыть(СтруктураПередачиАдреса);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораНП(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПараметрыВыбора = Новый Структура;
	СтруктураНаселенногоПункта = Новый Структура;
	ПараметрыВыбора.Вставить("ГородВладелец", ГородВладелец);
	
	СтруктураНаселенногоПункта = ОткрытьФормуМодально("РегистрСведений.Адреса.Форма.ФормаВыбораНаселенногоПункта", ПараметрыВыбора, НаселенныйПункт);
	
	Если ТипЗнч(СтруктураНаселенногоПункта) = Тип("Структура") Тогда
		
		Улица 					= Неопределено;
		Дом 						= Неопределено;
		Подъезд 				= Неопределено;
		КодПодъезда 			= Неопределено;
		Этаж 						= Неопределено;
		Квартира 				= Неопределено;
		НаселенныйПункт	= СтруктураНаселенногоПункта.НаселенныйПункт;
		Километраж 			= СтруктураНаселенногоПункта.Километраж;
		
		СтруктураНаселенногоПункта.Вставить("СписокУлиц", ЗапроситьСписокУлиц(СтруктураНаселенногоПункта));
		Элементы.Улица.СписокВыбора.ЗагрузитьЗначения(СтруктураНаселенногоПункта.СписокУлиц.СписокУлиц);
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗапроситьСписокУлиц(СтруктураНаселенногоПункта)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ТипАдресногоОбъектаВКоде", 5);
	Запрос.УстановитьПараметр("КодАдресногоОбъектаВКоде", СтруктураНаселенногоПункта.КодАдресногоОбъектаВКоде);
	Запрос.УстановитьПараметр("КодГородаВКоде", СтруктураНаселенногоПункта.КодГородаВКоде);
	Запрос.УстановитьПараметр("КодНаселенногоПунктаВКоде", СтруктураНаселенногоПункта.КодНаселенногоПунктаВКоде);
	Запрос.УстановитьПараметр("КодРайонаВКоде", СтруктураНаселенногоПункта.КодРайона);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АдресныйКлассификатор.Наименование КАК Наименование,
	|	АдресныйКлассификатор.Наименование + "" "" + АдресныйКлассификатор.Сокращение + ""."" КАК ПолноеНаименование
	|ИЗ
	|	РегистрСведений.АдресныйКлассификатор КАК АдресныйКлассификатор
	|ГДЕ
	|	АдресныйКлассификатор.ТипАдресногоЭлемента = 5
	|	И АдресныйКлассификатор.КодАдресногоОбъектаВКоде = &КодАдресногоОбъектаВКоде
	|	И АдресныйКлассификатор.КодГородаВКоде = &КодГородаВКоде
	|	И АдресныйКлассификатор.КодНаселенногоПунктаВКоде = &КодНаселенногоПунктаВКоде
	|	И АдресныйКлассификатор.КодРайонаВКоде = &КодРайонаВКоде
	|	И АдресныйКлассификатор.Сокращение <> ""стр""
	|	И АдресныйКлассификатор.Сокращение <> ""гск""
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АдресныйКлассификатор.Сокращение + ""."" КАК Сокращение
	|ИЗ
	|	РегистрСведений.АдресныйКлассификатор КАК АдресныйКлассификатор
	|ГДЕ
	|	АдресныйКлассификатор.ТипАдресногоЭлемента = 5
	|	И АдресныйКлассификатор.КодАдресногоОбъектаВКоде = &КодАдресногоОбъектаВКоде
	|	И АдресныйКлассификатор.КодГородаВКоде = &КодГородаВКоде
	|	И АдресныйКлассификатор.КодНаселенногоПунктаВКоде = &КодНаселенногоПунктаВКоде
	|	И АдресныйКлассификатор.КодРайонаВКоде = &КодРайонаВКоде
	|	И АдресныйКлассификатор.Сокращение <> ""стр""
	|	И АдресныйКлассификатор.Сокращение <> ""гск""
	|
	|СГРУППИРОВАТЬ ПО
	|	АдресныйКлассификатор.Сокращение + "".""
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сокращение";
	
	МассивРезультаттов = Запрос.ВыполнитьПакет();
	СписокУлиц = МассивРезультаттов[0].Выгрузить().ВыгрузитьКолонку("ПолноеНаименование");
	Сокращения = МассивРезультаттов[1].Выгрузить().ВыгрузитьКолонку("Сокращение");
	Структурка = Новый Структура;
	Структурка.Вставить("СписокУлиц", СписокУлиц);
	Структурка.Вставить("Сокращения", Сокращения);
	
	Возврат Структурка;
	
	//Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ПолноеНаименование");    //  Наименование
	
КонецФункции // ЗапроситьСписокУлиц()

&НаКлиенте
Процедура УлицаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка 	= Ложь;
	Ожидание 						= 2; 
	Список 							= Новый СписокЗначений;
	
	Если ТипЗнч(СтруктураНаселенногоПункта) = Тип("Структура") Тогда
		
		МассивУлиц	= СтруктураНаселенногоПункта.СписокУлиц.СписокУлиц;
		ДлинаТекста 	= СтрДлина(Текст);
		
		Если ДлинаТекста > 0 Тогда
			
			МассивПодставляемыхЗначений = Новый Массив;
			
			Для каждого Значение Из МассивУлиц Цикл
				
				СравнивоемоеЗначение = Лев(Значение, ДлинаТекста);
				
				Если Текст = СравнивоемоеЗначение Тогда
					
					МассивПодставляемыхЗначений.Добавить(Значение); 
					
				КонецЕсли;
				
			КонецЦикла;
			
			Список.ЗагрузитьЗначения(МассивПодставляемыхЗначений);
			
			ДанныеВыбора = Список;
			
		КонецЕсли;
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктПриИзменении(Элемент)
	
	Модифицированность = Истина;
	СформироватьАдрес();
	
КонецПроцедуры

&НаКлиенте
Процедура УлицаПриИзменении(Элемент)
	
	СформироватьАдрес();
	
КонецПроцедуры

&НаКлиенте
Процедура ДомПриИзменении(Элемент)
	
	СформироватьАдрес();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодъездПриИзменении(Элемент)
	
	СформироватьАдрес();
	
КонецПроцедуры

&НаКлиенте
Процедура КодПодъездаПриИзменении(Элемент)
	
	СформироватьАдрес();
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтажПриИзменении(Элемент)
	
	СформироватьАдрес();
	
КонецПроцедуры

&НаКлиенте
Процедура КвартираПриИзменении(Элемент)
	
	СформироватьАдрес();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьАдрес();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	НаселенныйПункт = Неопределено;
	Улица 			= Неопределено;
	Дом 			= Неопределено;
	Подъезд 		= Неопределено;
	КодПодъезда 	= Неопределено;
	Этаж 			= Неопределено;
	Квартира 		= Неопределено;
	Километраж 		= Неопределено;
	
	СформироватьАдрес();
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическийВводПриИзменении(Элемент)
	
	Если АвтоматическийВвод Тогда
		
		Элементы.ПоКлассификатору.Видимость = Истина;
		Элементы.РучнойНабор.Видимость = Ложь;
		
	Иначе
		
		Элементы.ПоКлассификатору.Видимость = Ложь;
		Элементы.РучнойНабор.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктВручнуюОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СформироватьАдрес();
	
КонецПроцедуры

&НаКлиенте
Процедура УлицаВручнуюОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СформироватьАдрес();
	
КонецПроцедуры

&НаКлиенте
Процедура ДомВручнуюОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	СформироватьАдрес();
КонецПроцедуры

&НаКлиенте
Процедура ПодъездВручнуюОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	СформироватьАдрес();
КонецПроцедуры

&НаКлиенте
Процедура КодПодъездаВручнуюОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	СформироватьАдрес();
КонецПроцедуры

&НаКлиенте
Процедура ЭтажВручнуюОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	СформироватьАдрес();
КонецПроцедуры

&НаКлиенте
Процедура КвартираВручнуюОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	СформироватьАдрес();
КонецПроцедуры
