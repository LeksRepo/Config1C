﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НовыйПросмотр = Параметры.НовыйПросмотр;
	
	Если НовыйПросмотр Тогда
		ПриСозданииНовая(Параметры);
	Иначе	
		ПриСозданииСтарая(Параметры);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НовыйПросмотр Тогда
		ПриОткрытииНовая();
	Иначе	
		ПриОткрытииСтарая();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииСтарая(Параметры) 
	
	СписокИзображений = Параметры.СписокИзображений;
	КоличествоИзображений = СписокИзображений.Количество();
	ДобавляемыеРеквизиты = Новый Массив;
	
	Если КоличествоИзображений > 0 Тогда
		ПоследнийНомерКартинки = 1;
		КоличествоГрупп = Цел(СписокИзображений.Количество()/5) + 1;
		Для Индекс = 1 По КоличествоГрупп Цикл
			НовыйЭлемент = Элементы.Добавить("ГруппаИзображений" +Индекс, Тип("ГруппаФормы"), ЭтаФорма);
			НовыйЭлемент.Вид = ВидГруппыФормы.ОбычнаяГруппа;
			НовыйЭлемент.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
			НовыйЭлемент.Отображение = ОтображениеОбычнойГруппы.Нет;
			НовыйЭлемент.ОтображатьЗаголовок = Ложь;
			НовыйЭлемент.РастягиватьПоГоризонтали = Истина;
			
			Для ИндексКартинки = ПоследнийНомерКартинки По КоличествоИзображений Цикл
				
				НомерКартинки = СписокИзображений[ИндексКартинки - 1].Значение;
				Если НомерКартинки/Индекс <= 5 Тогда	
					НовыйЭлементКартинки = Элементы.Добавить("Изображение" +НомерКартинки, Тип("ПолеФормы"), Элементы["ГруппаИзображений" +Индекс]);
					
					Реквизит = Новый РеквизитФормы("Картинка" + НомерКартинки, Новый ОписаниеТипов("Строка"));
					ДобавляемыеРеквизиты.Очистить();
					ДобавляемыеРеквизиты.Добавить(Реквизит);
					ИзменитьРеквизиты(ДобавляемыеРеквизиты);
					
					НовыйЭлементКартинки.ПутьКДанным = "Картинка" + НомерКартинки;
					НовыйЭлементКартинки.Вид = ВидПоляФормы.ПолеКартинки;
					НовыйЭлементКартинки.РазмерКартинки = РазмерКартинки.Пропорционально;
					НовыйЭлементКартинки.Заголовок = СписокИзображений[ИндексКартинки - 1].Представление;
					НовыйЭлементКартинки.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
					НовыйЭлементКартинки.РастягиватьПоВертикали = Ложь;
					НовыйЭлементКартинки.РастягиватьПоГоризонтали = Истина;
					НовыйЭлементКартинки.Ширина = 70;
					НовыйЭлементКартинки.Высота = 10;
					
					Если НомерКартинки/Индекс = 5 Тогда	
						ПоследнийНомерКартинки = НомерКартинки +1;
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииСтарая()
	
	Для Индекс = 1 По КоличествоИзображений Цикл
		ЭлементФормы = Элементы["Изображение" +Индекс];
		Если ЗначениеЗаполнено(ЭлементФормы.Заголовок) Тогда
			АдресВХранилище = "";
			ИмяФайла = ЭлементФормы.Заголовок;
			ФайлИзображения = Новый Файл(ИмяФайла);
			Если ФайлИзображения.Существует() Тогда
				ПоместитьФайл(АдресВХранилище, ИмяФайла, , Ложь);
				Этаформа["Картинка" +Индекс]  = АдресВХранилище;
			КонецЕсли;
			Элементы["Изображение" +Индекс].Заголовок = "Изделие" + Индекс;
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНовая(Параметры) 
	
	СписокИзделий = Параметры.Детали;
	КоличествоИзделий = СписокИзделий.Количество();
	ДобавляемыеРеквизиты = Новый Массив;
	
	Если КоличествоИзделий > 0 Тогда
		//ПоследнийНомерКартинки = 1;
		//КоличествоГрупп = Цел(СписокИзображений.Количество()/5) + 1;
		//Для Индекс = 1 По КоличествоГрупп Цикл
		//	НовыйЭлемент = Элементы.Добавить("ГруппаИзображений" +Индекс, Тип("ГруппаФормы"), ЭтаФорма);
		//	НовыйЭлемент.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		//	НовыйЭлемент.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		//	НовыйЭлемент.Отображение = ОтображениеОбычнойГруппы.Нет;
		//	НовыйЭлемент.ОтображатьЗаголовок = Ложь;
		//	НовыйЭлемент.РастягиватьПоГоризонтали = Истина;
		//	
		//	Для ИндексКартинки = ПоследнийНомерКартинки По КоличествоИзображений Цикл
		//		
		//		НомерКартинки = СписокИзображений[ИндексКартинки - 1].Значение;
		//		Если НомерКартинки/Индекс <= 5 Тогда	
		//			НовыйЭлементКартинки = Элементы.Добавить("Изображение" +НомерКартинки, Тип("ПолеФормы"), Элементы["ГруппаИзображений" +Индекс]);
		//			
		//			Реквизит = Новый РеквизитФормы("Картинка" + НомерКартинки, Новый ОписаниеТипов("Строка"));
		//			ДобавляемыеРеквизиты.Очистить();
		//			ДобавляемыеРеквизиты.Добавить(Реквизит);
		//			ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		//			
		//			НовыйЭлементКартинки.ПутьКДанным = "Картинка" + НомерКартинки;
		//			НовыйЭлементКартинки.Вид = ВидПоляФормы.ПолеКартинки;
		//			НовыйЭлементКартинки.РазмерКартинки = РазмерКартинки.Пропорционально;
		//			НовыйЭлементКартинки.Заголовок = СписокИзображений[ИндексКартинки - 1].Представление;
		//			НовыйЭлементКартинки.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		//			НовыйЭлементКартинки.РастягиватьПоВертикали = Ложь;
		//			НовыйЭлементКартинки.РастягиватьПоГоризонтали = Истина;
		//			НовыйЭлементКартинки.Ширина = 70;
		//			НовыйЭлементКартинки.Высота = 10;
		//			
		//			Если НомерКартинки/Индекс = 5 Тогда	
		//				ПоследнийНомерКартинки = НомерКартинки +1;
		//				Прервать;
		//			КонецЕсли;
		//		КонецЕсли;
		//	КонецЦикла;
		//КонецЦикла; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииНовая()
	
	Для Индекс = 1 По КоличествоИзображений Цикл
		ЭлементФормы = Элементы["Изображение" +Индекс];
		Если ЗначениеЗаполнено(ЭлементФормы.Заголовок) Тогда
			АдресВХранилище = "";
			ИмяФайла = ЭлементФормы.Заголовок;
			ФайлИзображения = Новый Файл(ИмяФайла);
			Если ФайлИзображения.Существует() Тогда
				ПоместитьФайл(АдресВХранилище, ИмяФайла, , Ложь);
				Этаформа["Картинка" +Индекс]  = АдресВХранилище;
			КонецЕсли;
			Элементы["Изображение" +Индекс].Заголовок = "Изделие" + Индекс;
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры
