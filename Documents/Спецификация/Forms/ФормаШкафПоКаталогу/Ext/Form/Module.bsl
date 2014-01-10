﻿
&НаКлиенте
Процедура ИзделиеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущийЭлементИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу." + ЭтаФорма.ТекущийЭлемент.Имя);	
	НашаСтрока = Детали.НайтиСтроки(Новый Структура("ВидИзделия", ТекущийЭлементИзделия));
	ЕстьСтрока = НашаСтрока.Количество() = 1;
	ЕстьЯщики = Ложь;
	
	Если ЕстьСтрока Тогда
		Элементы.Детали.ТекущаяСтрока = Детали.Индекс(НашаСтрока[0]);
		ТекущиеДанные = Элементы.Детали.ТекущиеДанные;
		ЕстьЯщики = ТекущиеДанные.ЕстьЯщики;
		
		Если ТекущиеДанные <> Неопределено Тогда
			Если НЕ ЗначениеЗаполнено(ТекущиеДанные.НоменклатураЛДСП) И ЗначениеЗаполнено(ШапкаОсновныхНастроек.НоменклатураЛДСП) Тогда			
				ТекущиеДанные.НоменклатураЛДСП = ШапкаОсновныхНастроек.НоменклатураЛДСП;		
			ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.НоменклатураЛДСП) Тогда
				ШапкаОсновныхНастроек.Вставить("НоменклатураЛДСП", ТекущиеДанные.НоменклатураЛДСП);
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(ТекущиеДанные.КромкаЛДСП) И ЗначениеЗаполнено(ШапкаОсновныхНастроек.КромкаЛДСП) Тогда			
				ТекущиеДанные.КромкаЛДСП = ШапкаОсновныхНастроек.КромкаЛДСП;		
			ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.КромкаЛДСП) Тогда
				ШапкаОсновныхНастроек.Вставить("КромкаЛДСП", ТекущиеДанные.КромкаЛДСП);
			КонецЕсли;
		КонецЕсли;	
	Иначе
		Элементы.Детали.ТекущаяСтрока = Неопределено;
	КонецЕсли;
	
	УстановитьДоступность(ЕстьСтрока, ЕстьЯщики);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборИзделия(Команда)
	
	ЭлементИзделия = ЭтаФорма.ТекущийЭлемент.Имя;
	ТекущийЭлементИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу." + ЭтаФорма.ТекущийЭлемент.Имя);
	
	МассивИзделий = Новый Массив;
	
	Для Каждого Строка Из Детали Цикл
		
		МассивИзделий.Добавить(Строка.Изделие);
		
	КонецЦикла;	
	
	Изделие = ОткрытьФормуМодально("Справочник.КаталогИзделий.ФормаВыбора", Новый Структура("ВидИзделия, ИсключитьНесовместимые, МассивИзделий", ТекущийЭлементИзделия, Истина, МассивИзделий), ЭтаФорма);
	
	Если ЗначениеЗаполнено(Изделие) Тогда	
		СтруктураИзделия = ПолучитьСтруктуруИзделия(Изделие);
		
		НашаСтрока = Детали.НайтиСтроки(Новый Структура("ВидИзделия", ТекущийЭлементИзделия));
		ЕстьСтрока = НашаСтрока.Количество() = 1;
		
		Если ЕстьСтрока Тогда
			НоваяСтрока = НашаСтрока[0];
		Иначе
			НоваяСтрока = Детали.Добавить();
		КонецЕсли;
		
		НоваяСтрока.Изделие = Изделие;
		НоваяСтрока.ВысотаИзделия = СтруктураИзделия.ВысотаИзделия;
		НоваяСтрока.ШиринаИзделия = СтруктураИзделия.ШиринаИзделия;
		НоваяСтрока.ГлубинаИзделия = СтруктураИзделия.ГлубинаИзделия;
		НоваяСтрока.ВысотаИзделияМин = СтруктураИзделия.ВысотаИзделияМин;
		НоваяСтрока.ШиринаИзделияМин = СтруктураИзделия.ШиринаИзделияМин;
		НоваяСтрока.ГлубинаИзделияМин = СтруктураИзделия.ГлубинаИзделияМин;
		НоваяСтрока.ВысотаИзделияМакс = СтруктураИзделия.ВысотаИзделияМакс;
		НоваяСтрока.ШиринаИзделияМакс = СтруктураИзделия.ШиринаИзделияМакс;
		НоваяСтрока.ГлубинаИзделияМакс = СтруктураИзделия.ГлубинаИзделияМакс;
		НоваяСтрока.ВидИзделия = ТекущийЭлементИзделия;
		НоваяСтрока.НоменклатураЛДСП = ШапкаОсновныхНастроек.НоменклатураЛДСП;
		НоваяСтрока.КромкаЛДСП = ШапкаОсновныхНастроек.КромкаЛДСП;
		НоваяСтрока.ЕстьЯщики = СтруктураИзделия.ЕстьЯщики;
		НоваяСтрока.НаВсеИзделие = СтруктураИзделия.НаВсеИзделие;
				
		УстановитьДоступность(Истина, СтруктураИзделия.ЕстьЯщики);	
		ОтобразитьКартинку(СтруктураИзделия.АдресЭлемента, ЭлементИзделия);	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступность(Флаг, ЕстьЯщики = Ложь)
	
	Элементы.ДеталиНоменклатураЛДСП.Доступность = Флаг;
	Элементы.ДеталиКромкаЛДСП.Доступность = Флаг;
	Элементы.РучкиЯщиков.Доступность = ЕстьЯщики;
	Элементы.ДноЯщика.Доступность = ЕстьЯщики;
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	ЭлементИзделия = ЭтаФорма.ТекущийЭлемент.Имя;	
	ТекущийЭлементИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу." + ЭлементИзделия);
	НашаСтрока = Детали.НайтиСтроки(Новый Структура("ВидИзделия", ТекущийЭлементИзделия));
	ЕстьСтрока = НашаСтрока.Количество() = 1;
	
	Если ЕстьСтрока Тогда
		Детали.Удалить(НашаСтрока[0]);
		ЭтаФорма[ЭлементИзделия] = "";	
	КонецЕсли;
	
	УстановитьДоступность(Ложь);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруИзделия(Изделие)
	
	Структура = Новый Структура;
	Структура.Вставить("АдресЭлемента", "Изделие" + Изделие.Код);
	Структура.Вставить("ВысотаИзделия", Изделие.ВысотаИзделия);
	Структура.Вставить("ШиринаИзделия", Изделие.ШиринаИзделия);
	Структура.Вставить("ГлубинаИзделия", Изделие.ГлубинаИзделия);
	Структура.Вставить("ВысотаИзделияМин", Изделие.ВысотаИзделияМин);
	Структура.Вставить("ШиринаИзделияМин", Изделие.ШиринаИзделияМин);
	Структура.Вставить("ГлубинаИзделияМин", Изделие.ГлубинаИзделияМин);
	Структура.Вставить("ВысотаИзделияМакс", Изделие.ВысотаИзделияМакс);
	Структура.Вставить("ШиринаИзделияМакс", Изделие.ШиринаИзделияМакс);
	Структура.Вставить("ГлубинаИзделияМакс", Изделие.ГлубинаИзделияМакс);
	ЕстьЯщики = Изделие.СписокЯщики.Количество() > 0;
	Структура.Вставить("ЕстьЯщики", ЕстьЯщики);
	Структура.Вставить("НаВсеИзделие", Изделие.НаВсеИзделие);
	
	Возврат Структура;                                   
	
КонецФункции

&НаКлиенте
Процедура ОтобразитьКартинку(АдресЭлемента, ЭлементИзделия)
	
	АдресЭлемента = РабочийКаталог + АдресЭлемента;
	АдресВХранилище = "";
	Если ЗначениеЗаполнено(АдресЭлемента) Тогда
		ИмяФайла = АдресЭлемента;
		ФайлИзображения = Новый Файл(ИмяФайла);
		Если ФайлИзображения.Существует() Тогда
			ПоместитьФайл(АдресВХранилище, ИмяФайла, , Ложь, ЭтаФорма.УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
	ЭтаФорма[ЭлементИзделия] = АдресВХранилище;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РабочийКаталог = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
	
	ПолучитьИтоговыеРазмеры(ВысотаПроемаДвери, ШиринаПроемаДвери);
	
	//Очень криво обращаться по имени, надо чтото придумать
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("Крыша");
	МассивЭлементов.Добавить("ЛевыйБоковойЭлемент");
	МассивЭлементов.Добавить("ОсновнойЭлемент");
	МассивЭлементов.Добавить("Пол");
	МассивЭлементов.Добавить("ПравыйБоковойЭлемент");
	
	Для Каждого Строка Из МассивЭлементов Цикл
		Если ЗначениеЗаполнено(ЭтаФорма[Строка]) Тогда
			ОтобразитьКартинку(ЭтаФорма[Строка], Строка);
		КонецЕсли;	
	КонецЦикла;
	
	Элементы.РучкиЯщиков.Доступность = ЗначениеЗаполнено(РучкиЯщиков);
	Элементы.ДноЯщика.Доступность = ЗначениеЗаполнено(РучкиЯщиков);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Подразделение = Параметры.Подразделение;
	
	#Область Заполнение_номенклатурных_групп	
	СписокНоменклатурныхГрупп = Новый СписокЗначений;
	
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ЛДСП16);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.КантТ);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кромка045_19);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кромка2_19);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Кромка2_35);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.ДВП);
	СписокНоменклатурныхГрупп.Добавить(Справочники.НоменклатурныеГруппы.Ручка);
	
	МассивыНоменклатурныхГрупп = ЛексСервер.ОтборНоменклатурныхГрупп(СписокНоменклатурныхГрупп, Подразделение);
	
	ДобавитьДопГруппы();
	
	Элементы.ДеталиНоменклатураЛДСП.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ЛДСП16);
	Элементы.ДеталиКромкаЛДСП.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Кромка);
	Элементы.РучкиЯщиков.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.Ручка);
	Элементы.ДноЯщика.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ДВП);
	
	Элементы.ЗадняяСтенка.СписокВыбора.ЗагрузитьЗначения(ПолучитьСписокСтенок());	
	#КонецОбласти
	
	#Область ШапкаОсновныхНастроек
	ШапкаОсновныхНастроек = Новый Структура;
	
	ШапкаОсновныхНастроек.Вставить("НоменклатураЛДСП", "");
	ШапкаОсновныхНастроек.Вставить("КромкаЛДСП", "");
	#КонецОбласти
	
	СтруктураФормы = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицы);
	
	Двери = СтруктураФормы.Двери;
	Детали.Загрузить(СтруктураФормы.Детали.Выгрузить());
	
	Для Каждого Строка Из Детали Цикл
		НашеИзделие = Строка.Изделие;
		Если Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЗадняяСтенка Тогда
			ЗадняяСтенка = НашеИзделие;
			НоменклатураСтенка = Строка.НоменклатураЛДСП;
			
			МатериалСтенки = ПолучитьМатериалСтенки(ЗадняяСтенка);
			
			Если МатериалСтенки = "16 ЛДСП" Тогда
				Элементы.НоменклатураСтенка.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ЛДСП16);
			ИначеЕсли МатериалСтенки = "ДВП" Тогда
				Элементы.НоменклатураСтенка.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ДВП);
			Иначе
				Элементы.НоменклатураСтенка.СписокВыбора.Очистить();
			КонецЕсли;
			
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ОсновнойЭлемент Тогда
			ГлубинаИтог = Строка.ГлубинаИзделия;
			ВысотаПроемаДвери = Строка.ВысотаИзделия;
			ШиринаПроемаДвери = Строка.ШиринаИзделия;
			ОсновнойЭлемент = "Изделие" + НашеИзделие.Код;
			РучкиЯщиков = Строка.Ручка;
			ДноЯщика = Строка.НоменклатураДВП;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент Тогда
			ЛевыйБоковойЭлемент = "Изделие" + НашеИзделие.Код;
			РучкиЯщиков = Строка.Ручка;
			ДноЯщика = Строка.НоменклатураДВП;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Пол Тогда
			Пол = "Изделие" + НашеИзделие.Код;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент Тогда
			ПравыйБоковойЭлемент = "Изделие" + НашеИзделие.Код;
			РучкиЯщиков = Строка.Ручка;
			ДноЯщика = Строка.НоменклатураДВП;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Крыша Тогда
			Крыша = "Изделие" + НашеИзделие.Код;
		КонецЕСли;
		
		Строка.ШиринаИзделияМакс = НашеИзделие.ШиринаИзделияМакс;
		Строка.ВысотаИзделияМакс = НашеИзделие.ВысотаИзделияМакс;
		Строка.ГлубинаИзделияМакс = НашеИзделие.ГлубинаИзделияМакс;
		Строка.ШиринаИзделияМин = НашеИзделие.ШиринаИзделияМин;
		Строка.ВысотаИзделияМин = НашеИзделие.ВысотаИзделияМин;
		Строка.ГлубинаИзделияМин = НашеИзделие.ГлубинаИзделияМин;
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура ДобавитьДопГруппы() 
	
	Кромка2 = Новый Массив;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кромка2_19 Цикл
		Кромка2.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кромка2_35 Цикл
		Кромка2.Добавить(Элемент);
	КонецЦикла;
	МассивыНоменклатурныхГрупп.Вставить("Кромка2мм", Кромка2);
	
	Кромка 	= Новый Массив;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кромка045_19 Цикл
		Кромка.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.Кромка2мм Цикл
		Кромка.Добавить(Элемент);
	КонецЦикла;
	Для каждого Элемент Из МассивыНоменклатурныхГрупп.КантТ Цикл
		Кромка.Добавить(Элемент);
	КонецЦикла;
	МассивыНоменклатурныхГрупп.Вставить("Кромка", Кромка);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокСтенок() 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КаталогИзделий.Ссылка
	|ИЗ
	|	Справочник.КаталогИзделий КАК КаталогИзделий
	|ГДЕ
	|	КаталогИзделий.ВидИзделия = ЗНАЧЕНИЕ(Перечисление.ВидыИзделийПоКаталогу.ЗадняяСтенка)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаКлиенте
Процедура ЗадняяСтенкаПриИзменении(Элемент)
	
	ТекущийЭлементИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЗадняяСтенка");
	
	УстановитьДоступность(Ложь);
	
	Если ЗначениеЗаполнено(ЗадняяСтенка) Тогда
		
		МатериалСтенки = ПолучитьМатериалСтенки(ЗадняяСтенка);
		
		Если МатериалСтенки = "16 ЛДСП" Тогда
			Элементы.НоменклатураСтенка.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ЛДСП16);
		ИначеЕсли МатериалСтенки = "ДВП" Тогда
			Элементы.НоменклатураСтенка.СписокВыбора.ЗагрузитьЗначения(МассивыНоменклатурныхГрупп.ДВП);
		Иначе
			Элементы.НоменклатураСтенка.СписокВыбора.Очистить();
		КонецЕсли;
		
		Стенка = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЗадняяСтенка"); 
		НашаСтрока = Детали.НайтиСтроки(Новый Структура("ВидИзделия", Стенка));
		ЕстьСтрока = НашаСтрока.Количество() = 1;
		
		Если ЕстьСтрока Тогда
			НоваяСтрока = НашаСтрока[0];
		Иначе
			НоваяСтрока = Детали.Добавить();
		КонецЕсли;
		
		НоваяСтрока.Изделие = ЗадняяСтенка;
		НоваяСтрока.ВидИзделия = Стенка;
		НоменклатураСтенка = Неопределено;
	Иначе
		НоменклатураСтенка = Неопределено;
		Элементы.НоменклатураСтенка.СписокВыбора.Очистить();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ЗадняяСтенкаОчистка(Элемент, СтандартнаяОбработка)
	
	НашаСтрока = Детали.НайтиСтроки(Новый Структура("ВидИзделия", ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЗадняяСтенка")));
	ЕстьСтрока = НашаСтрока.Количество() = 1;
	
	Если ЕстьСтрока Тогда
		Детали.Удалить(НашаСтрока[0]);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМатериалСтенки(ЗадняяСтенка)
	
	//Изделие по каталогу Задняя стенка должна иметь 1 деталь - саму стенку, определяем ее материал
	Если ЗначениеЗаполнено(ЗадняяСтенка) Тогда
		Если ЗадняяСтенка.СписокМатериалы.Количество() > 0 Тогда
			Возврат ЗадняяСтенка.СписокМатериалы[0].Материал;
		КонецЕсли;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ДвериНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РазмерыОсновногоЭлемента = ПолучитьРазмерыОсновногоЭлемента();
	Если РазмерыОсновногоЭлемента <> Неопределено Тогда
		Если РазмерыОсновногоЭлемента.Высота > 0 И РазмерыОсновногоЭлемента.Ширина > 0  Тогда
			
			СписокКнопок = Новый СписокЗначений;	
			СписокКнопок.Добавить(КодВозвратаДиалога.Да, "Создать");
			СписокКнопок.Добавить(КодВозвратаДиалога.Нет, "Выбрать");
			СписокКнопок.Добавить(КодВозвратаДиалога.Отмена, "Отмена");
			
			Ответ = Вопрос("Создать новую или выбрать существующую дверь?",СписокКнопок,,);
			
			Если Ответ = КодВозвратаДиалога.Да Тогда
				
				ПараметрыФормы = Новый Структура("Подразделение", Подразделение);
				ПараметрыФормы.Вставить("ВысотаПроема", РазмерыОсновногоЭлемента.Высота);
				ПараметрыФормы.Вставить("ШиринаПроема", РазмерыОсновногоЭлемента.Ширина);
				
				Форма = ПолучитьФорму("Справочник.Двери.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма);
				Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
				Форма.Открыть();	
				
			ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
				
				ПараметрыФормы = Новый Структура("ШиринаПроема", РазмерыОсновногоЭлемента.Ширина);
				ПараметрыФормы.Вставить("ВысотаПроема", РазмерыОсновногоЭлемента.Высота);
				Форма = ПолучитьФорму("Справочник.Двери.Форма.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
				Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
				Форма.Открыть();
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьРазмерыОсновногоЭлемента()
	
	НашОсновнойЭлемент = Детали.НайтиСтроки(Новый Структура("ВидИзделия", ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ОсновнойЭлемент")));
	ЕстьОсновной = НашОсновнойЭлемент.Количество() > 0;
	Если ЕстьОсновной Тогда
		Размеры = Новый Структура;
		Размеры.Вставить("Глубина", ГлубинаИтог);
		
		ШиринаОсновногоЭлемента = ШиринаИтог;
		ВысотаОсновногоЭлемента = ВысотаИтог;
		ВысотаПол = 0;
		ВысотаКрыша = 0;
		
		Для Каждого Строка Из Детали Цикл
			Если Строка.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.Крыша") Тогда
				Если НЕ Строка.НаВсеИзделие Тогда
					ВысотаКрыша = Строка.ВысотаИзделия;
				КонецЕсли;
				ВысотаОсновногоЭлемента = ВысотаОсновногоЭлемента - Строка.ВысотаИзделия;	
			ИначеЕсли Строка.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.Пол") Тогда
				ВысотаПол = Строка.ВысотаИзделия;
				ВысотаОсновногоЭлемента = ВысотаОсновногоЭлемента - ВысотаПол; 	
			ИначеЕсли Строка.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент") Тогда
				ШиринаОсновногоЭлемента = ШиринаОсновногоЭлемента - Строка.ШиринаИзделия;	
			ИначеЕсли Строка.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент") Тогда
				ШиринаОсновногоЭлемента = ШиринаОсновногоЭлемента - Строка.ШиринаИзделия;	
			КонецЕсли;	
		КонецЦикла;
		
		Размеры.Вставить("Ширина", ШиринаОсновногоЭлемента);
		Размеры.Вставить("Высота", ВысотаОсновногоЭлемента);
		Размеры.Вставить("ВысотаБоковой", ВысотаОсновногоЭлемента + ВысотаПол + ВысотаКрыша);
		
		Возврат Размеры;
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Выберите основной элемент", , "ОсновнойЭлемент");
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьИтоговыеРазмеры(ВысотаОсновного, ШиринаОсновного)
	
	ШиринаИтог = ШиринаОсновного;
	ВысотаИтог = ВысотаОсновного;
	
	Для Каждого Строка Из Детали Цикл
		Если Строка.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.Крыша") Тогда
			ВысотаИтог = ВысотаИтог + Строка.ВысотаИзделия;	
		ИначеЕсли Строка.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.Пол") Тогда
			ВысотаИтог = ВысотаИтог + Строка.ВысотаИзделия; 	
		ИначеЕсли Строка.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент") Тогда
			ШиринаИтог = ШиринаИтог + Строка.ШиринаИзделия;	
		ИначеЕсли Строка.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент") Тогда
			ШиринаИтог = ШиринаИтог + Строка.ШиринаИзделия;	
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Двери") И ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		ДвериПриИзмененииНаКлиенте(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста                                
Функция ПолучитьРазмерыДвери(Дверь)
	
	Структура = Новый Структура;                          
	Структура.Вставить("ВысотаПроема", Дверь.ВысотаПроема);
	Структура.Вставить("ШиринаПроема", Дверь.ШиринаПроема);
	
	Возврат Структура;
	
КонецФункции

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	РазмерыОсновногоЭлемента = ПолучитьРазмерыОсновногоЭлемента();
	Отказ = Ложь;
	Если РазмерыОсновногоЭлемента <> Неопределено Тогда 
		Модифицированность = Ложь;
		СтруктураФормы = ПроверитьИУстановитьРазмерыПередСохранением(РазмерыОсновногоЭлемента);
		
		Если ЗначениеЗаполнено(Двери) Тогда
			
			Отказ = ПроверкаДвери(РазмерыОсновногоЭлемента);
			
		КонецЕсли;	
		
		Если (СтруктураФормы <> Неопределено) И (НЕ Отказ) Тогда 
			ОповеститьОВыборе(СтруктураФормы);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПроверитьИУстановитьРазмерыПередСохранением(РазмерыОсновного)
	
	Отказ = Ложь;
	
	ЕстьКрыша = Ложь;
	ЕстьКрышаНаВсе = Ложь;
	ЕстьПол = Ложь;
	ЕстьОсновной = Ложь;
	ЕстьЛевыйБоковой = Ложь;
	ЕстьПравыйБоковой = Ложь;
	                                           
	Для Каждого Строка Из Детали Цикл
		
		Строка.ГлубинаИзделия = ГлубинаИтог;
		Строка.Ручка = РучкиЯщиков;
		Строка.НоменклатураДВП = ДноЯщика;
		
		Если Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Крыша Тогда 
						
			Если Строка.Изделие.НаВсеИзделие Тогда
				ЕстьКрышаНаВсе = Истина;
				Строка.ШиринаИзделия = ШиринаИтог;
			Иначе
				ЕстьКрыша = Истина;
				Строка.ШиринаИзделия = РазмерыОсновного.Ширина;
			КонецЕсли;
			
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Пол Тогда
			Строка.ШиринаИзделия = РазмерыОсновного.Ширина;
			ЕстьПол = Истина;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент Тогда
			Строка.ВысотаИзделия = РазмерыОсновного.ВысотаБоковой;
			ЕстьЛевыйБоковой = Истина;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент Тогда
			Строка.ВысотаИзделия = РазмерыОсновного.ВысотаБоковой;
			ЕстьПравыйБоковой = Истина;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ОсновнойЭлемент Тогда
			Строка.ШиринаИзделия = РазмерыОсновного.Ширина;
			Строка.ВысотаИзделия = РазмерыОсновного.Высота;
			ЕстьОсновной = Истина;
		ИначеЕсли Строка.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЗадняяСтенка Тогда
			Строка.ШиринаИзделия = РазмерыОсновного.Ширина + 30;
			Строка.ВысотаИзделия = РазмерыОсновного.Высота + 30;
			Если НоменклатураСтенка.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ЛДСП16 Тогда
				Строка.НоменклатураЛДСП = НоменклатураСтенка;
			ИначеЕсли НоменклатураСтенка.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ДВП Тогда
				Строка.НоменклатураДВП = НоменклатураСтенка;
			КонецЕсли;
			НашаСтенка = Строка.Изделие;
			Строка.ШиринаИзделияМакс = НашаСтенка.ШиринаИзделияМакс;
			Строка.ВысотаИзделияМакс = НашаСтенка.ВысотаИзделияМакс;
			Строка.ГлубинаИзделияМакс = НашаСтенка.ГлубинаИзделияМакс;
			Строка.ШиринаИзделияМин = НашаСтенка.ШиринаИзделияМин;
			Строка.ВысотаИзделияМин = НашаСтенка.ВысотаИзделияМин;
			Строка.ГлубинаИзделияМин = НашаСтенка.ГлубинаИзделияМин;
			
			Если НЕ ЗначениеЗаполнено(НоменклатураСтенка) Тогда
				Текст = "Не выбрана номенклатура задней стенки";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "НоменклатураСтенка");				
				Отказ = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.НоменклатураЛДСП) И (Строка.ВидИзделия <> Перечисления.ВидыИзделийПоКаталогу.ЗадняяСтенка) Тогда
			Если ЗначениеЗаполнено(ШапкаОсновныхНастроек.НоменклатураЛДСП) Тогда
				Строка.НоменклатураЛДСП = ШапкаОсновныхНастроек.НоменклатураЛДСП;
			Иначе	
				Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
				Текст = "Не выбрана номенклатура ЛДСП у " + Строка.ВидИзделия;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.НоменклатураЛДСП");				
				Отказ = Истина;
			КонецЕсли;	
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.КромкаЛДСП) И (Строка.ВидИзделия <> Перечисления.ВидыИзделийПоКаталогу.ЗадняяСтенка) Тогда
			Если ЗначениеЗаполнено(ШапкаОсновныхНастроек.КромкаЛДСП) Тогда
				Строка.КромкаЛДСП = ШапкаОсновныхНастроек.КромкаЛДСП;
			Иначе
				Элементы.Детали.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
				Текст = "Не выбрана кромка у " + Строка.ВидИзделия;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.Детали.ТекущиеДанные.КромкаЛДСП");
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если Строка.ШиринаИзделия > Строка.ШиринаИзделияМакс ИЛИ Строка.ШиринаИзделия < Строка.ШиринаИзделияМин Тогда
			Текст = Строка(Строка.ВидИзделия) + " не подходит по ширине. Ширина изделия = " + Строка.ШиринаИзделия + " (Мин = " + Строка.ШиринаИзделияМин + ", Макс = " + Строка.ШиринаИзделияМакс + ")";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "ШиринаИтог");
			Отказ = Истина;	
		КонецЕсли;	
		
		Если Строка.ВысотаИзделия > Строка.ВысотаИзделияМакс ИЛИ Строка.ВысотаИзделия < Строка.ВысотаИзделияМин Тогда
			Текст = Строка(Строка.ВидИзделия) + " не подходит по высоте. Высота изделия = " + Строка.ВысотаИзделия + " (Мин = " + Строка.ВысотаИзделияМин + ", Макс = " + Строка.ВысотаИзделияМакс + ")";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "ВысотаИтог");
			Отказ = Истина;
		КонецЕсли;
		
		Если Строка.ГлубинаИзделия > Строка.ГлубинаИзделияМакс ИЛИ Строка.ГлубинаИзделия < Строка.ГлубинаИзделияМин Тогда
			Текст = Строка(Строка.ВидИзделия) + " не подходит по глубине. Глубина изделия = " + Строка.ГлубинаИзделия + " (Мин = " + Строка.ГлубинаИзделияМин + ", Макс = " + Строка.ГлубинаИзделияМакс + ")";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "ГлубинаИтог");
			Отказ = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ Отказ Тогда
		
		# Область СозданиеСтрокиПрипусков
		
		Для Каждого Элемент Из Детали Цикл
			
			Элемент.СтрокаПрипусков = "";
			
			Если Элемент.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Крыша Тогда 
				
				Если НЕ ЕстьЛевыйБоковой Тогда
					Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСлева";
				КонецЕсли;
				Если НЕ ЕстьПравыйБоковой Тогда
					Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСправа";
				КонецЕсли;
				
			ИначеЕсли Элемент.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Пол Тогда
				
				Если НЕ ЕстьЛевыйБоковой Тогда
					Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСлева";
				КонецЕсли;
				Если НЕ ЕстьПравыйБоковой Тогда
					Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСправа";
				КонецЕсли;
				
			ИначеЕсли Элемент.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ЛевыйБоковойЭлемент
				ИЛИ Элемент.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ПравыйБоковойЭлемент Тогда
				
				Если НЕ ЕстьКрышаНаВсе Тогда
					Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСверху";
				КонецЕсли;
				Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСнизу";
								
			ИначеЕсли Элемент.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.ОсновнойЭлемент Тогда
				
				Если НЕ ЕстьКрыша И НЕ ЕстьКрышаНаВсе Тогда
					Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСверху";
				КонецЕсли;
				Если НЕ ЕстьЛевыйБоковой Тогда
					Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСлева";
				КонецЕсли;
				Если НЕ ЕстьПол Тогда
					Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСнизу";
				КонецЕсли;
				Если НЕ ЕстьПравыйБоковой Тогда
					Элемент.СтрокаПрипусков = Элемент.СтрокаПрипусков + "ПрипускСправа";
				КонецЕсли;
				
			КонецЕсли;			
		КонецЦикла;
		
		# КонецОбласти
		
		Структура = Новый Структура;
		Структура.Вставить("Детали", Детали.Выгрузить());
		Структура.Вставить("Двери", Двери);
		
		Возврат ПоместитьВоВременноеХранилище(Структура);
		
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ДеталиНоменклатураЛДСППриИзменении(Элемент)
	
	ШапкаОсновныхНастроек.Вставить("НоменклатураЛДСП", Элементы.Детали.ТекущиеДанные.НоменклатураЛДСП);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеталиКромкаЛДСППриИзменении(Элемент)
	
	ШапкаОсновныхНастроек.Вставить("КромкаЛДСП", Элементы.Детали.ТекущиеДанные.КромкаЛДСП);	
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураСтенкаПриИзменении(Элемент)
	
	ТекущийЭлементИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ЗадняяСтенка");
	УстановитьДоступность(Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция ПроверкаДвери(РазмерыОсновногоЭлемента)
	
	Отказ = Ложь;
	
	Если ВысотаПроемаДвери <> РазмерыОсновногоЭлемента.Высота 
		ИЛИ ШиринаПроемаДвери <> РазмерыОсновногоЭлемента.Ширина Тогда
		
		СписокКнопок = Новый СписокЗначений;	
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, "Редактировать");
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, "Отмена");
		
		Ответ = Вопрос("Размеры двери не совпадают с размерами изделия.", СписокКнопок,,);
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			ПараметрыФормы = Новый Структура("Ключ", Двери);
			ПараметрыФормы.Вставить("ВысотаПроема", РазмерыОсновногоЭлемента.Высота);
			ПараметрыФормы.Вставить("ШиринаПроема", РазмерыОсновногоЭлемента.Ширина);
			ПараметрыФормы.Вставить("Редактирование", Истина);
			Форма = ПолучитьФорму("Справочник.Двери.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма);
			Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
			Форма.Открыть();
			
		КонецЕсли;
		
		Отказ = Истина;
		
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

&НаКлиенте
Процедура ДвериПриИзменении(Элемент)
	
	ДвериПриИзмененииНаКлиенте(Двери);
	
КонецПроцедуры

&НаКлиенте
Процедура ДвериПриИзмененииНаКлиенте(Значение)
	
	Если ЗначениеЗаполнено(Значение) Тогда
		РазмерыДвери = ПолучитьРазмерыДвери(Значение);
		ВысотаПроемаДвери = РазмерыДвери.ВысотаПроема;
		ШиринаПроемаДвери = РазмерыДвери.ШиринаПроема;
	КонецЕсли;
	
	РазмерыОсновногоЭлемента = ПолучитьРазмерыОсновногоЭлемента();
	Если РазмерыОсновногоЭлемента <> Неопределено Тогда
		Если ВысотаПроемаДвери = РазмерыОсновногоЭлемента.Высота 
			И ШиринаПроемаДвери = РазмерыОсновногоЭлемента.Ширина 
			Тогда
			
			Двери = Значение;
			
		Иначе
			
			Двери = Неопределено;
			ВысотаПроемаДвери = 0;
			ШиринаПроемаДвери = 0;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Двери не подходят по размерам", , "Двери");
			
		КонецЕсли;
	Иначе
		Двери = Неопределено;
	КонецЕсли;
КонецПроцедуры





