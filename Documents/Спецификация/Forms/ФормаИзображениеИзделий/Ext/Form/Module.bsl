﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РабочийКаталог = Параметры.РабочийКаталог;
	
	СписокИзделий.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицы));
	КоличествоИзделий = СписокИзделий.Количество();
	ДобавляемыеРеквизиты = Новый Массив;
	
	РазмерВерх = 0;
	РазмерНиз = 0;
		
	Если КоличествоИзделий > 0 Тогда                         
		Элементы.ГруппаВерх.Видимость = Истина;
		Элементы.ГруппаНиз.Видимость = Истина;
		Для Каждого Строка Из СписокИзделий Цикл
			Если Строка.Изделие.ВидИзделияПоКаталогу = Справочники.ВидыИзделийПоКаталогу.КухняВерхний ИЛИ
				Строка.Изделие.ВидИзделияПоКаталогу = Справочники.ВидыИзделийПоКаталогу.НадстройкаКомода Тогда
				Группа = Элементы.ГруппаВерх;
				Элементы.Декорация1.Видимость = Истина;
				РазмерВерх = РазмерВерх + Строка.ШиринаИзделия;
			ИначеЕсли Строка.Изделие.ВидИзделияПоКаталогу = Справочники.ВидыИзделийПоКаталогу.КухняНижний ИЛИ
				Строка.Изделие.ВидИзделияПоКаталогу = Справочники.ВидыИзделийПоКаталогу.Комод ИЛИ
				Строка.Изделие.ВидИзделияПоКаталогу = Справочники.ВидыИзделийПоКаталогу.КорпуснаяМебель Тогда
				Группа = Элементы.ГруппаНиз;
				Элементы.Декорация2.Видимость = Истина;				
				РазмерНиз = РазмерНиз + Строка.ШиринаИзделия;
			КонецЕсли;
			НомерСтроки = Строка.ПолучитьИдентификатор();
			
			НовыйЭлементГруппы = Элементы.Добавить("ГруппаИзображение" + НомерСтроки, Тип("ГруппаФормы"), Группа);
			НовыйЭлементГруппы.Вид = ВидГруппыФормы.ОбычнаяГруппа;
			НовыйЭлементГруппы.Отображение = ОтображениеОбычнойГруппы.Нет;
			НовыйЭлементГруппы.ОтображатьЗаголовок  = Ложь;
			НовыйЭлементГруппы.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
			
			НовыйЭлементРазмер = Элементы.Добавить("РазмерИзображение" + НомерСтроки, Тип("ПолеФормы"), НовыйЭлементГруппы);
			НовыйЭлементКартинки = Элементы.Добавить("Изображение" + НомерСтроки, Тип("ПолеФормы"), НовыйЭлементГруппы);
			
			Реквизит = Новый РеквизитФормы("Изображение" + НомерСтроки, Новый ОписаниеТипов("Строка"));
			РеквизитРазмера = Новый РеквизитФормы("РазмерИзображение" + НомерСтроки, Новый ОписаниеТипов("Строка"));
			ДобавляемыеРеквизиты.Очистить();
			ДобавляемыеРеквизиты.Добавить(Реквизит);
			ДобавляемыеРеквизиты.Добавить(РеквизитРазмера);
			ИзменитьРеквизиты(ДобавляемыеРеквизиты);
			
			НовыйЭлементРазмер.ПутьКДанным = "РазмерИзображение" + НомерСтроки;
			НовыйЭлементРазмер.Вид = ВидПоляФормы.ПолеНадписи;
			НовыйЭлементРазмер.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			НовыйЭлементРазмер.РастягиватьПоВертикали = Ложь;
			НовыйЭлементРазмер.РастягиватьПоГоризонтали = Истина;
			НовыйЭлементРазмер.Ширина = 70;
			
			НовыйЭлементКартинки.ПутьКДанным = "Изображение" + НомерСтроки;
			НовыйЭлементКартинки.Вид = ВидПоляФормы.ПолеКартинки;
			НовыйЭлементКартинки.РазмерКартинки = РазмерКартинки.Пропорционально;
			НовыйЭлементКартинки.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			НовыйЭлементКартинки.РастягиватьПоВертикали = Ложь;
			НовыйЭлементКартинки.РастягиватьПоГоризонтали = Истина;
			НовыйЭлементКартинки.Ширина = 70;
			НовыйЭлементКартинки.Высота = 10;
			НовыйЭлементКартинки.РазрешитьНачалоПеретаскивания = Истина;
			НовыйЭлементКартинки.РазрешитьПеретаскивание = Истина;
			НовыйЭлементКартинки.УстановитьДействие("НачалоПеретаскивания", "НачалоПеретаскиванияКартинок");
			НовыйЭлементКартинки.УстановитьДействие("Перетаскивание", "ПеретаскиваниеКартинок");
			НовыйЭлементКартинки.УстановитьДействие("ПроверкаПеретаскивания", "ПроверкаПеретаскиванияКартинок");
			
		КонецЦикла;
	КонецЕсли;
	
	Элементы.Декорация1.Подсказка = "Ширина верхних изделий: " + РазмерВерх;
	Элементы.Декорация2.Подсказка = "Ширина нижних изделий: " + РазмерНиз;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для Каждого Строка Из СписокИзделий Цикл
		
		АдресВХранилище = "";
		ИмяФайла = РабочийКаталог + Строка.Расположение + Строка.КодИзделия;
		ФайлИзображения = Новый Файл(ИмяФайла);
		НашЭлемент = "Изображение" + Строка.ПолучитьИдентификатор();
		НашРазмер = "РазмерИзображение" + Строка.ПолучитьИдентификатор();
		
		Если ФайлИзображения.Существует() Тогда
			
			ПоместитьФайл(АдресВХранилище, ИмяФайла, , Ложь, ЭтаФорма.УникальныйИдентификатор);
			Этаформа[НашЭлемент]  = АдресВХранилище;
			
		Иначе
			
			ИмяФайла = РабочийКаталог + ПредопределенноеЗначение("Перечисление.ВидыПрисоединенныхФайлов.ОсновнаяКартинка") + Строка.КодИзделия;
			ФайлИзображения = Новый Файл(ИмяФайла);
			Если ФайлИзображения.Существует() Тогда
				ПоместитьФайл(АдресВХранилище, ИмяФайла, , Ложь, ЭтаФорма.УникальныйИдентификатор);
				Этаформа[НашЭлемент]  = АдресВХранилище;
			КонецЕсли;
			
		КонецЕсли;
		
		Этаформа[НашРазмер]  = "Размеры: " + Строка.ГлубинаИзделия + ";" + Строка.ШиринаИзделия + ";" + Строка.ВысотаИзделия + ?(ЗначениеЗаполнено(Строка.ВысотаИзделияВерх),"-"+Строка(Строка.ВысотаИзделияВерх),"") + ?(ЗначениеЗаполнено(Строка.ВысотаИзделияНиз),"-"+Строка(Строка.ВысотаИзделияНиз),"");
		Строка.ЭлементФормы = НашЭлемент;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПеретаскиванияКартинок(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ИзображениеИсточник = Элемент.Имя; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПеретаскиваниеКартинок(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если Элемент.Родитель.Родитель = Элементы[ИзображениеИсточник].Родитель.Родитель Тогда
		
		ИзображениеПриемник = ЭтаФорма[Элемент.Имя];
		ЭтаФорма[Элемент.Имя] = ЭтаФорма[ИзображениеИсточник];
		ЭтаФорма[ИзображениеИсточник] = ИзображениеПриемник;
		
		РазмерИзображениеПриемник = ЭтаФорма["Размер" + Элемент.Имя];
		ЭтаФорма["Размер" + Элемент.Имя] = ЭтаФорма["Размер" + ИзображениеИсточник];
		ЭтаФорма["Размер" + ИзображениеИсточник] = РазмерИзображениеПриемник;
		
		Для Каждого Строка Из СписокИзделий Цикл
			Если Строка.ЭлементФормы = ИзображениеИсточник Тогда
				Строка.ЭлементФормы = Элемент.Имя;
			ИначеЕсли Строка.ЭлементФормы = Элемент.Имя Тогда
				Строка.ЭлементФормы = ИзображениеИсточник;
			КонецЕсли;
		КонецЦикла;
			
	Иначе
		
		Предупреждение("Невозможно менять короба разных уровней");
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаПеретаскиванияКартинок(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Порядок = 0;
	Для Каждого НашЭлемент Из Элементы Цикл
		Если ТипЗнч(НашЭлемент) = Тип("ПолеФормы") И НашЭлемент.Вид = ВидПоляФормы.ПолеКартинки Тогда
			
			Строки = СписокИзделий.НайтиСтроки(Новый Структура("ЭлементФормы", НашЭлемент.Имя));
			
			Если Строки.Количество() = 1 Тогда
				
				Строки[0].Порядок = Порядок;
				
			КонецЕсли;
			Порядок = Порядок + 1;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаДетали = ВыгрузитьНужнуюТаблицуВХранилище();
	Если ТаблицаДетали <> Неопределено Тогда 
		ОповеститьОВыборе(ТаблицаДетали);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыгрузитьНужнуюТаблицуВХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(СписокИзделий.Выгрузить());
	
КонецФункции
