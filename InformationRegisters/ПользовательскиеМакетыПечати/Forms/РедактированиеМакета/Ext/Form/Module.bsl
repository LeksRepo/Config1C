﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	
	ИмяОбъектаМетаданныхМакета = Параметры.ИмяОбъектаМетаданныхМакета;
	
	ЧастиИмени = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяОбъектаМетаданныхМакета, ".");
	ИмяМакета = ЧастиИмени[ЧастиИмени.ВГраница()];
	
	ИмяВладельца = "";
	Для НомерЧасти = 0 По ЧастиИмени.ВГраница()-1 Цикл
		Если Не ПустаяСтрока(ИмяВладельца) Тогда
			ИмяВладельца = ИмяВладельца + ".";
		КонецЕсли;
		ИмяВладельца = ИмяВладельца + ЧастиИмени[НомерЧасти];
	КонецЦикла;
	
	ТипМакета = Параметры.ТипМакета;
	
	ПредставлениеМакета = ПредставлениеМакета();
	ИмяФайлаМакета = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ПредставлениеМакета) + "." + НРег(ТипМакета);
	
	Если Параметры.ТолькоОткрытие Тогда
		Заголовок = НСтр("ru = 'Открытие макета печатной формы'");
	КонецЕсли;
	
	ТипКлиента = ?(Параметры.ЭтоВебКлиент, "", "Не") + "ВебКлиент";
	КлючСохраненияПоложенияОкна = ТипКлиента + ВРег(ТипМакета);
	
	Если Не Параметры.ЭтоВебКлиент И ТипМакета = "MXL" Тогда
		Элементы.НадписьЗавершениеИзмененияНеВебКлиент.Заголовок = НСтр(
			"ru = 'После внесения необходимых изменений в макет нажмите на кнопку ""Завершить изменение""'");
	КонецЕсли;
	
	УстановитьНазваниеПрограммыДляОткрытияМакета();
	
	Элементы.Диалог.ТекущаяСтраница = Элементы["СтраницаЗагрузкаНаКомпьютер" + ТипКлиента];
	Элементы.КоманднаяПанель.ТекущаяСтраница = Элементы.ПанельЗагрузка;
	Элементы.КнопкаИзменить.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если Не ВебКлиент Тогда
		Если Параметры.ТолькоОткрытие Тогда
			Отказ = Истина;
		КонецЕсли;
		Если Параметры.ТолькоОткрытие Или ТипМакета = "MXL" Тогда
			ОткрытьМакет();
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если Не ПустаяСтрока(ВременнаяПапка) Тогда
		УдалитьФайлы(ВременнаяПапка);
	КонецЕсли;
	
	ИмяСобытия = "ОтказОтИзмененияМакета";
	Если МакетЗагружен Тогда
		ИмяСобытия = "Запись_ПользовательскиеМакетыПечати";
	КонецЕсли;
	
	Оповестить(ИмяСобытия, Новый Структура("ИмяОбъектаМетаданныхМакета", ИмяОбъектаМетаданныхМакета), ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СсылкаНаСтраницуПрограммыНажатие(Элемент)
	ПерейтиПоНавигационнойСсылке(АдресПрограммыДляОткрытияМакета);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Изменить(Команда)
	ОткрытьМакет();
	Если Параметры.ТолькоОткрытие Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьИзменение(Команда)
	
	#Если Вебклиент Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПоместитьФайлЗавершение", ЭтотОбъект);
		НачатьПомещениеФайла(ОписаниеОповещения, АдресФайлаМакетаВоВременномХранилище, ИмяФайлаМакета);
	#Иначе
		Если НРег(ТипМакета) = "mxl" Тогда
			ИзменяемыйМакет.Скрыть();
			АдресФайлаМакетаВоВременномХранилище = ПоместитьВоВременноеХранилище(ИзменяемыйМакет);
			МакетЗагружен = Истина;
		Иначе
			Файл = Новый Файл(ПутьКФайлуМакета);
			Если Файл.Существует() Тогда
				ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКФайлуМакета);
				АдресФайлаМакетаВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
				МакетЗагружен = Истина;
			КонецЕсли;
		КонецЕсли;
	
		Если МакетЗагружен Тогда
			ЗаписатьМакет();
		КонецЕсли;

		Закрыть();
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьФайлЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	МакетЗагружен = Результат;
	АдресФайлаМакетаВоВременномХранилище = Адрес;
	ИмяФайлаМакета = ВыбранноеИмяФайла;

	Если МакетЗагружен Тогда
		ЗаписатьМакет();
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры



&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьНазваниеПрограммыДляОткрытияМакета()
	
	НазваниеПрограммыДляОткрытияМакета = "";
	
	ТипФайла = НРег(ТипМакета);
	Если ТипФайла = "mxl" Тогда
		НазваниеПрограммыДляОткрытияМакета = НСтр("ru = '1С:Предприятие - Работа с файлами'");
		АдресПрограммыДляОткрытияМакета = "http://v8.1c.ru/metod/fileworkshop.htm";
	ИначеЕсли ТипФайла = "doc" Тогда
		НазваниеПрограммыДляОткрытияМакета = НСтр("ru = 'Microsoft Word'");
		АдресПрограммыДляОткрытияМакета = "http://office.microsoft.com/ru-ru/word";
	ИначеЕсли ТипФайла = "odt" Тогда
		НазваниеПрограммыДляОткрытияМакета = НСтр("ru = 'OpenOffice Writer'");
		АдресПрограммыДляОткрытияМакета = "http://www.openoffice.org/product/writer.html";
	КонецЕсли;
	
	СведенияДляЗаполнения = Новый Структура;
	СведенияДляЗаполнения.Вставить("ИмяМакета", ПредставлениеМакета);
	СведенияДляЗаполнения.Вставить("НазваниеПрограммы", НазваниеПрограммыДляОткрытияМакета);
	СведенияДляЗаполнения.Вставить("ОписаниеДействия", ?(Параметры.ТолькоОткрытие, НСтр("ru = 'открытия'"), НСтр("ru = 'внесения изменений'")));
	
	ЗаполняемыеЭлементы = Новый Массив;
	ЗаполняемыеЭлементы.Добавить(Элементы.СсылкаНаСтраницуПрограммыПередЗагрузкойВебКлиент);
	ЗаполняемыеЭлементы.Добавить(Элементы.СсылкаНаСтраницуПрограммыПередЗагрузкойНеВебКлиент);
	ЗаполняемыеЭлементы.Добавить(Элементы.СсылкаНаСтраницуПрограммыЗавершениеИзмененияВебКлиент);
	ЗаполняемыеЭлементы.Добавить(Элементы.СсылкаНаСтраницуПрограммыЗавершениеИзмененияНеВебКлиент);
	ЗаполняемыеЭлементы.Добавить(Элементы.НадписьПередЗагрузкойМакетаПрограммаВебКлиент);
	ЗаполняемыеЭлементы.Добавить(Элементы.НадписьПередЗагрузкойМакетаПрограммаНеВебКлиент);
	ЗаполняемыеЭлементы.Добавить(Элементы.НадписьЗавершениеИзмененияВебКлиент);
	ЗаполняемыеЭлементы.Добавить(Элементы.НадписьЗавершениеИзмененияНеВебКлиент);
	
	Для Каждого Элемент Из ЗаполняемыеЭлементы Цикл
		Элемент.Заголовок = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Элемент.Заголовок, СведенияДляЗаполнения);
	КонецЦикла;
	
	ВидимостьСсылкиНаСтраницуПрограммы = Параметры.ЭтоВебКлиент Или ТипФайла <> "mxl";
	Элементы.СсылкаНаСтраницуПрограммыПередЗагрузкойВебКлиент.Видимость = ВидимостьСсылкиНаСтраницуПрограммы;
	Элементы.СсылкаНаСтраницуПрограммыПередЗагрузкойНеВебКлиент.Видимость = ВидимостьСсылкиНаСтраницуПрограммы;
	Элементы.СсылкаНаСтраницуПрограммыЗавершениеИзмененияВебКлиент.Видимость = ВидимостьСсылкиНаСтраницуПрограммы;
	Элементы.СсылкаНаСтраницуПрограммыЗавершениеИзмененияНеВебКлиент.Видимость = ВидимостьСсылкиНаСтраницуПрограммы;
	
	Элементы.НадписьПередЗагрузкойМакетаПрограммаНеВебКлиент.Видимость = ТипФайла <> "mxl";
	
	Элементы.СтраницаЗагрузкаНаКомпьютерВебКлиент.Видимость = Параметры.ЭтоВебКлиент;
	Элементы.СтраницаЗагрузкаВИнформационнуюБазуВебКлиент.Видимость = Параметры.ЭтоВебКлиент;
	Элементы.СтраницаЗагрузкаНаКомпьютерНеВебКлиент.Видимость = Не Параметры.ЭтоВебКлиент;
	Элементы.СтраницаЗагрузкаВИнформационнуюБазуНеВебКлиент.Видимость = Не Параметры.ЭтоВебКлиент;
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеМакета()
	
	Результат = ИмяМакета;
	
	Владелец = Метаданные.НайтиПоПолномуИмени(ИмяВладельца);
	Если Владелец <> Неопределено Тогда
		Макет = Владелец.Макеты.Найти(ИмяМакета);
		Если Макет <> Неопределено Тогда
			Результат = Макет.Синоним;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьМакет()
	#Если ВебКлиент Тогда
		ОткрытьМакетВебКлиент();
	#Иначе
		ОткрытьМакетТонкийКлиент();
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМакетТонкийКлиент()
	
	#Если Не ВебКлиент Тогда
		
		Макет = ПолучитьМакет(ИмяОбъектаМетаданныхМакета);
		ВременнаяПапка = ПолучитьИмяВременногоФайла();
		СоздатьКаталог(ВременнаяПапка);
		ПутьКФайлуМакета = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВременнаяПапка) + ИмяФайлаМакета;
		
		Если ТипМакета = "MXL" Тогда
			Если Параметры.ТолькоОткрытие Тогда
				Макет.ТолькоПросмотр = Истина;
				Макет.Показать(ПредставлениеМакета,,Истина);
			Иначе
				Макет.Записать(ПутьКФайлуМакета);
				Макет.Показать(ПредставлениеМакета, ПутьКФайлуМакета, Истина);
				
				ИзменяемыйМакет = Макет;
			КонецЕсли;
		Иначе
			Макет.Записать(ПутьКФайлуМакета);
			Если Параметры.ТолькоОткрытие Тогда
				ФайлМакета = Новый Файл(ПутьКФайлуМакета);
				ФайлМакета.УстановитьТолькоЧтение(Истина);
			КонецЕсли;
			ЗапуститьПриложение(ПутьКФайлуМакета);
		КонецЕсли;
		
		ПерейтиНаСтраницуЗавершенияИзменения();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМакетВебКлиент()
	Если ПолучитьФайл(ПоместитьМакетВоВременноеХранилище(), ИмяФайлаМакета) <> Ложь Тогда
		ПерейтиНаСтраницуЗавершенияИзменения();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПоместитьМакетВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(ДвоичныеДанныеМакета());
	
КонецФункции

&НаСервере
Функция ДвоичныеДанныеМакета()
	
	ДанныеМакета = УправлениеПечатью.ПолучитьМакет(ИмяОбъектаМетаданныхМакета);
	Если ТипЗнч(ДанныеМакета) = Тип("ТабличныйДокумент") Тогда
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
		ДанныеМакета.Записать(ИмяВременногоФайла);
		ДанныеМакета = Новый ДвоичныеДанные(ИмяВременногоФайла);
		УдалитьФайлы(ИмяВременногоФайла);
	КонецЕсли;
	
	Возврат ДанныеМакета;
	
КонецФункции

&НаКлиенте
Процедура ПерейтиНаСтраницуЗавершенияИзменения()
	Элементы.Диалог.ТекущаяСтраница = Элементы["СтраницаЗагрузкаВИнформационнуюБазу" + ТипКлиента];
	Элементы.КоманднаяПанель.ТекущаяСтраница = Элементы.ПанельЗавершениеИзменения;
	Элементы.КнопкаЗавершитьИзменение.КнопкаПоУмолчанию = Истина;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьМакет()
	Макет = ПолучитьИзВременногоХранилища(АдресФайлаМакетаВоВременномХранилище);
	Если НРег(ТипМакета) = "mxl" И ТипЗнч(Макет) <> Тип("ТабличныйДокумент") Тогда
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
		Макет.Записать(ИмяВременногоФайла);
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.Прочитать(ИмяВременногоФайла);
		Макет = ТабличныйДокумент;
	КонецЕсли;
	
	Запись = РегистрыСведений.ПользовательскиеМакетыПечати.СоздатьМенеджерЗаписи();
	Запись.Объект = ИмяВладельца;
	Запись.ИмяМакета = ИмяМакета;
	Запись.Использование = Истина;
	Запись.Макет = Новый ХранилищеЗначения(Макет, Новый СжатиеДанных(9));
	Запись.Записать();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМакет(ИмяОбъектаМетаданныхМакета)
	Возврат УправлениеПечатью.ПолучитьМакет(ИмяОбъектаМетаданныхМакета);
КонецФункции
