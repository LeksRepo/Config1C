﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Параметры.Свойство("ТабличныеДокументы", ТабличныеДокументы);
	
	// Приведение имен файлов: уникальность + замена недопустимых символов
	ИспользованныеИменаДокументов = Новый Массив;
	Для Каждого ЭлементСписка Из ТабличныеДокументы Цикл
		Представление = СокрЛП(ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ЭлементСписка.Представление));
		Номер = 0;
		Пока ИспользованныеИменаДокументов.Найти(ПредставлениеСНомером(Представление, Номер)) <> Неопределено Цикл
			Номер = Номер + 1;
		КонецЦикла;
		ЭлементСписка.Представление = ПредставлениеСНомером(Представление, Номер);
		ИспользованныеИменаДокументов.Добавить(ЭлементСписка.Представление);
	КонецЦикла;
	
	ЗаполнитьТаблицуФорматов();
	
	Для Каждого ФорматСохранения Из ТаблицаФорматов Цикл
		ФорматыСохранения.Добавить(ФорматСохранения.ТипФайлаТабличногоДокумента, ФорматСохранения.Представление, Ложь, ФорматСохранения.Картинка);
	КонецЦикла;
	ФорматыСохранения[0].Пометка = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	ФорматыСохраненияИзНастроек = Настройки["ФорматыСохранения"];
	Если ФорматыСохраненияИзНастроек <> Неопределено Тогда
		Для Каждого ВыбранныйФормат Из ФорматыСохранения Цикл 
			ФорматИзНастроек = ФорматыСохраненияИзНастроек.НайтиПоЗначению(ВыбранныйФормат.Значение);
			Если ФорматИзНастроек <> Неопределено Тогда
				ВыбранныйФормат.Пометка = ФорматИзНастроек.Пометка;
			КонецЕсли;
		КонецЦикла;
		Настройки.Удалить("ФорматыСохранения");
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Прикрепить(Команда)
	
	ВыбранныеФорматыСохранения = Новый Массив;
	
	Для Каждого ВыбранныйФормат Из ФорматыСохранения Цикл
		Если ВыбранныйФормат.Пометка Тогда
			ВыбранныеФорматыСохранения.Добавить(ВыбранныйФормат.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если ВыбранныеФорматыСохранения.Количество() = 0 Тогда
		Предупреждение(НСтр("ru = 'Необходимо указать как минимум один из предложенных форматов.'"));
		Возврат;
	КонецЕсли;
	
	Получатель = Неопределено;
	Тема = "";
	Текст = "";
	СписокВложений = ПоместитьТабличныеДокументыВоВременноеХранилище(ВыбранныеФорматыСохранения);
	
	РаботаСПочтовымиСообщениямиКлиент.ОткрытьФормуОтправкиПочтовогоСообщения(, Получатель, Тема, Текст, СписокВложений, Истина);
	
	Закрыть(Истина);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьТаблицуФорматов()
	
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ТипФайлаТабличногоДокумента", Новый ОписаниеТипов(), "ТаблицаФорматов"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Ссылка", Новый ОписаниеТипов(), "ТаблицаФорматов"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Представление", Новый ОписаниеТипов(), "ТаблицаФорматов"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Расширение", Новый ОписаниеТипов(), "ТаблицаФорматов"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Картинка", Новый ОписаниеТипов(), "ТаблицаФорматов"));
	ИзменитьРеквизиты(ДобавляемыеРеквизиты, Новый Массив);
	
	// Документ PDF (.pdf)
	НовыйФормат = ТаблицаФорматов.Добавить();
	НовыйФормат.ТипФайлаТабличногоДокумента = ТипФайлаТабличногоДокумента.PDF;
	НовыйФормат.Ссылка = Перечисления.ФорматыСохраненияОтчетов.PDF;
	НовыйФормат.Расширение = "pdf";
	НовыйФормат.Картинка = БиблиотекаКартинок.ФорматPDF;
	
	// Лист Microsoft Excel 2007 (.xlsx)
	НовыйФормат = ТаблицаФорматов.Добавить();
	НовыйФормат.ТипФайлаТабличногоДокумента = ТипФайлаТабличногоДокумента.XLSX;
	НовыйФормат.Ссылка = Перечисления.ФорматыСохраненияОтчетов.XLSX;
	НовыйФормат.Расширение = "xlsx";
	НовыйФормат.Картинка = БиблиотекаКартинок.ФорматExcel2007;

	// Лист Microsoft Excel 97-2003 (.xls)
	НовыйФормат = ТаблицаФорматов.Добавить();
	НовыйФормат.ТипФайлаТабличногоДокумента = ТипФайлаТабличногоДокумента.XLS;
	НовыйФормат.Ссылка = Перечисления.ФорматыСохраненияОтчетов.XLS;
	НовыйФормат.Расширение = "xls";
	НовыйФормат.Картинка = БиблиотекаКартинок.ФорматExcel;

	// Электронная таблица OpenDocument (.ods)
	НовыйФормат = ТаблицаФорматов.Добавить();
	НовыйФормат.ТипФайлаТабличногоДокумента = ТипФайлаТабличногоДокумента.ODS;
	НовыйФормат.Ссылка = Перечисления.ФорматыСохраненияОтчетов.ODS;
	НовыйФормат.Расширение = "ods";
	НовыйФормат.Картинка = БиблиотекаКартинок.ФорматOpenOfficeCalc;
	
	// Табличный документ (.mxl)
	НовыйФормат = ТаблицаФорматов.Добавить();
	НовыйФормат.ТипФайлаТабличногоДокумента = ТипФайлаТабличногоДокумента.MXL;
	НовыйФормат.Ссылка = Перечисления.ФорматыСохраненияОтчетов.MXL;
	НовыйФормат.Расширение = "mxl";
	НовыйФормат.Картинка = БиблиотекаКартинок.ФорматMXL;

	// Документ Word 2007 (.docx)
	НовыйФормат = ТаблицаФорматов.Добавить();
	НовыйФормат.ТипФайлаТабличногоДокумента = ТипФайлаТабличногоДокумента.DOCX;
	НовыйФормат.Ссылка = Перечисления.ФорматыСохраненияОтчетов.DOCX;
	НовыйФормат.Расширение = "docx";
	НовыйФормат.Картинка = БиблиотекаКартинок.ФорматWord2007;
	
	// Веб-страница (.html)
	НовыйФормат = ТаблицаФорматов.Добавить();
	НовыйФормат.ТипФайлаТабличногоДокумента = ТипФайлаТабличногоДокумента.HTML;
	НовыйФормат.Ссылка = Перечисления.ФорматыСохраненияОтчетов.HTML;
	НовыйФормат.Расширение = "html";
	НовыйФормат.Картинка = БиблиотекаКартинок.ФорматHTML;
	
	// Текстовый документ UTF-8 (.txt)
	НовыйФормат = ТаблицаФорматов.Добавить();
	НовыйФормат.ТипФайлаТабличногоДокумента = ТипФайлаТабличногоДокумента.TXT;
	НовыйФормат.Ссылка = Перечисления.ФорматыСохраненияОтчетов.TXT;
	НовыйФормат.Расширение = "txt";
	НовыйФормат.Картинка = БиблиотекаКартинок.ФорматTXT;
	
	// Текстовый документ ANSI (.txt)
	НовыйФормат = ТаблицаФорматов.Добавить();
	НовыйФормат.ТипФайлаТабличногоДокумента = ТипФайлаТабличногоДокумента.ANSITXT;
	НовыйФормат.Ссылка = Перечисления.ФорматыСохраненияОтчетов.ANSITXT;
	НовыйФормат.Расширение = "txt";
	НовыйФормат.Картинка = БиблиотекаКартинок.ФорматTXT;

	// дополнительные форматы / изменение списка текущих
	Для Каждого ФорматСохранения Из ТаблицаФорматов Цикл
		ФорматСохранения.Представление = Строка(ФорматСохранения.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеСНомером(Представление, Номер)
	Возврат Представление + ?(Номер = 0, "", " " + Формат(Номер, "ЧГ="));
КонецФункции

&НаСервере
Функция ПоместитьТабличныеДокументыВоВременноеХранилище(ВыбранныеФорматыСохранения)
	Результат = Новый СписокЗначений;
	
	// Архив
	Если УпаковатьВАрхив Тогда
		ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
		ЗаписьZipФайла = Новый ЗаписьZipФайла(ИмяАрхива);
	КонецЕсли;
	
	// Каталог временных файлов
	ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременнойПапки);
	ПолныйПутьКФайлу = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки);
	
	// Сохранение табличных документов
	Для Каждого ТабличныйДокумент Из ТабличныеДокументы Цикл
		
		Если ТабличныйДокумент.Значение.Вывод = ИспользованиеВывода.Запретить Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТипФайла Из ВыбранныеФорматыСохранения Цикл
			ПараметрыФормата = ТаблицаФорматов.НайтиСтроки(Новый Структура("ТипФайлаТабличногоДокумента", ТипФайла))[0];
			
			ИмяФайла = ТабличныйДокумент.Представление + "." + ПараметрыФормата.Расширение;
			ПолноеИмяФайла = ПолныйПутьКФайлу + ИмяФайла;
			
			ТабличныйДокумент.Значение.Записать(ПолноеИмяФайла, ТипФайла);
			
			Если ТипФайла = ТипФайлаТабличногоДокумента.HTML Тогда
				ВставитьКартинкиВHTML(ПолноеИмяФайла);
			КонецЕсли;
			
			Если УпаковатьВАрхив Тогда 
				ЗаписьZipФайла.Добавить(ПолноеИмяФайла);
			Иначе
				Результат.Добавить(ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПолноеИмяФайла), УникальныйИдентификатор), ИмяФайла);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	// если архив подготовлен, записываем и помещаем его во временное хранилище
	Если УпаковатьВАрхив Тогда 
		ЗаписьZipФайла.Записать();
		
		ФайлАрхива = Новый Файл(ИмяАрхива);
		Результат.Добавить(ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяАрхива), УникальныйИдентификатор), ФайлАрхива.Имя);
		
		УдалитьФайлы(ИмяАрхива);
	КонецЕсли;
	
	УдалитьФайлы(ИмяВременнойПапки);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ВставитьКартинкиВHTML(ИмяФайлаHTML)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	ТекстHTML = ТекстовыйДокумент.ПолучитьТекст();
	
	ФайлHTML = Новый Файл(ИмяФайлаHTML);
	
	ИмяПапкиКартинок = ФайлHTML.ИмяБезРасширения + "_files";
	ПутьКПапкеКартинок = СтрЗаменить(ФайлHTML.ПолноеИмя, ФайлHTML.Имя, ИмяПапкиКартинок);
	
	// ожидается, что в папке будут только картинки
	ФайлыКартинок = НайтиФайлы(ПутьКПапкеКартинок, "*");
	
	Для Каждого ФайлКартинки Из ФайлыКартинок Цикл
		КартинкаТекстом = Base64Строка(Новый ДвоичныеДанные(ФайлКартинки.ПолноеИмя));
		КартинкаТекстом = "data:image/" + Сред(ФайлКартинки.Расширение,2) + ";base64," + Символы.ПС + КартинкаТекстом;
		
		ТекстHTML = СтрЗаменить(ТекстHTML, ИмяПапкиКартинок + "\" + ФайлКартинки.Имя, КартинкаТекстом);
	КонецЦикла;
		
	ТекстовыйДокумент.УстановитьТекст(ТекстHTML);
	ТекстовыйДокумент.Записать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	
КонецПроцедуры

