﻿
&НаКлиенте
Функция ОткрытьФормуПодбора(ИмяПодбора, ТаблицаДляФормы, СтрокаДанных, ВладелецПодобра)
	
	АдресТаблицы 		= ВыгрузитьНужнуюТаблицуВХранилище(ТаблицаДляФормы);
	ПараметрыПодбора 	= Новый Структура;
	
	ПараметрыПодбора.Вставить("АдресТаблицы", АдресТаблицы);
	
	Если СтрокаДанных <> Неопределено Тогда
		
		ПараметрыПодбора.Вставить("Идентификатор", СтрокаДанных.НомерСтроки - 1);
		
	КонецЕсли;
	
	ОткрытьФорму("Справочник.КаталогИзделий.Форма." + ИмяПодбора, ПараметрыПодбора, ВладелецПодобра);
	
КонецФункции

&НаСервере
Функция ВыгрузитьНужнуюТаблицуВХранилище(ТабличнаяЧасть)
	
	Возврат ПоместитьВоВременноеХранилище(ТабличнаяЧасть.Выгрузить());
	
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

&НаКлиенте
Процедура СписокМатериалыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЗагрузитьТабличнуюЧасть(ВыбранноеЗначение, Элемент.Имя);	
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСостав(Команда)
	
	Отказ = Истина;
	
	ИмяТекущейСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	
	Если ИмяТекущейСтраницы = "СтраницаМатериалы"  Тогда
		
		ИмяПодбора 			= "ФормаВыборМатериала";
		ТаблицаДляФормы 	= Объект.СписокМатериалы;
		СтрокаДанных 		= Элементы.СписокМатериалы.ТекущиеДанные;
		ВладелецПодобра	= Элементы.СписокМатериалы;
		
	ИначеЕсли ИмяТекущейСтраницы = "СтраницаЯщики" Тогда
		
		ИмяПодбора 			= "ФормаЯщики";
		ТаблицаДляФормы 	= Объект.СписокЯщики;
		СтрокаДанных 		= Элементы.СписокЯщики.ТекущиеДанные;
		ВладелецПодобра 	= Элементы.СписокЯщики;
		
	КонецЕсли;
	
	ОткрытьФормуПодбора(ИмяПодбора, ТаблицаДляФормы, СтрокаДанных, ВладелецПодобра);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РабочийКаталог = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
	ОтобразитьКартинку();
	
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
		ИмяФайла = РабочийКаталог + "Изделие" + Объект.Код;
		ФайлИзображения = Новый Файл(ИмяФайла);
		Если ФайлИзображения.Существует() Тогда
			ПоместитьФайл(АдресВХранилище, ИмяФайла, , Ложь, ЭтаФорма.УникальныйИдентификатор);
			Изображение  = АдресВХранилище;
		Иначе
			ИмяФайла = РабочийКаталог + "Изделие" + ПредопределенноеЗначение("Перечисление.РасположениеКартинки.Правая") + Объект.Код;
			ФайлИзображения = Новый Файл(ИмяФайла);
			Если ФайлИзображения.Существует() Тогда
				ПоместитьФайл(АдресВХранилище, ИмяФайла, , Ложь, ЭтаФорма.УникальныйИдентификатор);
				Изображение  = АдресВХранилище;
			Иначе
				ИмяФайла = РабочийКаталог + "Изделие" + ПредопределенноеЗначение("Перечисление.РасположениеКартинки.Левая") + Объект.Код;
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
		Попытка
			Выполнить("Проверка = " + Количество);
		Исключение
			Количество = "";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка в формуле");
		КонецПопытки;
	Иначе
		Количество = "";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните средние значения изделия");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.НаВсеИзделие.Доступность = Объект.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Крыша;
	Элементы.УчитыватьПол.Доступность = Объект.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.Пол;
	Элементы.НеВлияетНаОсновной.Доступность = (Объект.ВидИзделия <> Перечисления.ВидыИзделийПоКаталогу.ОсновнойЭлемент 
	И Объект.ВидИзделия <> Перечисления.ВидыИзделийПоКаталогу.КухняВерхний
	И Объект.ВидИзделия <> Перечисления.ВидыИзделийПоКаталогу.КухняНижний);
	Элементы.Угловой.Доступность = (Объект.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.КухняВерхний ИЛИ Объект.ВидИзделия = Перечисления.ВидыИзделийПоКаталогу.КухняНижний);
	
	Элементы.ФормаНесовместимость.Доступность = ЗначениеЗаполнено(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидИзделияПриИзменении(Элемент)
	
	Элементы.НаВсеИзделие.Доступность = Объект.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.Крыша");
	Элементы.УчитыватьПол.Доступность = Объект.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.Пол");
	Элементы.НеВлияетНаОсновной.Доступность = (Объект.ВидИзделия <> ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.ОсновнойЭлемент") 
	И Объект.ВидИзделия <> ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.КухняВерхний")
	И Объект.ВидИзделия <> ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.КухняНижний"));
	Элементы.Угловой.Доступность = (Объект.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.КухняВерхний") 
	ИЛИ Объект.ВидИзделия = ПредопределенноеЗначение("Перечисление.ВидыИзделийПоКаталогу.КухняНижний"));
	
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
