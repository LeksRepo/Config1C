﻿&НаКлиенте
Перем НарастающийНомерИзображения;

&НаКлиенте
Перем ПозицияДляВставки;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ТаблицаФайлов.Видимость = Ложь;
	Элементы.ФормаПринятьВсеКакОдинФайл.Видимость = Ложь;
	Элементы.ФормаПринятьВсеКакОтдельныеФайлы.Видимость = Ложь;
	
	Если Параметры.Свойство("ВладелецФайла") Тогда
		ВладелецФайла = Параметры.ВладелецФайла;
	КонецЕсли;
	
	ИдентификаторКлиента = Параметры.ИдентификаторКлиента;
	
	Если Параметры.Свойство("НеОткрыватьКарточкуПослеСозданияИзФайла") Тогда
		НеОткрыватьКарточкуПослеСозданияИзФайла = Параметры.НеОткрыватьКарточкуПослеСозданияИзФайла;
	КонецЕсли;
	
	НомерФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьНовыйНомерДляСканирования(ВладелецФайла);
	ИмяФайла = РаботаСФайламиКлиентСервер.ПолучитьИмяСканированногоФайла(НомерФайла, "");

	ФорматСканированногоИзображения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ФорматСканированногоИзображения", 
		ИдентификаторКлиента, Перечисления.ФорматыСканированногоИзображения.PNG
	);
	
	ФорматХраненияОдностраничный = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ФорматХраненияОдностраничный", 
		ИдентификаторКлиента, Перечисления.ФорматыХраненияОдностраничныхФайлов.PNG
	);
	
	ФорматХраненияМногостраничный = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ФорматХраненияМногостраничный", 
		ИдентификаторКлиента, Перечисления.ФорматыХраненияМногостраничныхФайлов.TIF
	);
	
	РазрешениеПеречисление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/Разрешение", 
		ИдентификаторКлиента
	);
	
	ЦветностьПеречисление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/Цветность", 
		ИдентификаторКлиента
	);
	
	ПоворотПеречисление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/Поворот", 
		ИдентификаторКлиента
	);
	
	РазмерБумагиПеречисление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/РазмерБумаги", 
		ИдентификаторКлиента
	);
	
	ДвустороннееСканирование = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ДвустороннееСканирование", 
		ИдентификаторКлиента
	);
	
	ИспользоватьImageMagickДляПреобразованияВPDF = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ИспользоватьImageMagickДляПреобразованияВPDF", 
		ИдентификаторКлиента
	);
	
	КачествоJPG = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/КачествоJPG", 
		ИдентификаторКлиента, 100
	);
	
	СжатиеTIFF = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/СжатиеTIFF", 
		ИдентификаторКлиента, Перечисления.ВариантыСжатияTIFF.БезСжатия
	);
	
	ПутьКПрограммеКонвертации = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ПутьКПрограммеКонвертации", 
		ИдентификаторКлиента, "convert.exe" // ImageMagick
	);
	
	ПоказыватьДиалогСканераЗагрузка = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ПоказыватьДиалогСканера", 
		ИдентификаторКлиента, Истина
	);
	
	ПоказыватьДиалогСканера = ПоказыватьДиалогСканераЗагрузка;
	
	ИмяУстройства = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ИмяУстройства", 
		ИдентификаторКлиента, ""
	);
	
	ИмяУстройстваСканирования = ИмяУстройства;
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = Перечисления.ФорматыХраненияОдностраничныхФайлов.PDF Тогда
			ФорматКартинки = Строка(ФорматСканированногоИзображения);
		Иначе	
			ФорматКартинки = Строка(ФорматХраненияОдностраничный);
		КонецЕсли;
	Иначе	
		ФорматКартинки = Строка(ФорматСканированногоИзображения);
	КонецЕсли;
	
	ФорматJPG = Перечисления.ФорматыСканированногоИзображения.JPG;
	ФорматTIF = Перечисления.ФорматыСканированногоИзображения.TIF;
	
	ПреобразоватьПеречисленияВПараметрыИПолучитьПредставление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не РаботаСФайламиСлужебныйКлиент.ПроинициализироватьКомпоненту() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не РаботаСФайламиСлужебныйКлиент.ДоступнаКомандаСканировать() Тогда
		Отказ = Истина;
		// вызывается здесь, т.к. вызов КомпонентаTwain.ЕстьУстройства() занимает очень много времени (больше, чем ОбновитьПовторноИспользуемыеЗначения())
		ОбновитьПовторноИспользуемыеЗначения(); 
		Возврат;
	КонецЕсли;
	
	ПоказыватьДиалог = ПоказыватьДиалогСканера;
	ВыбранноеУстройство = ИмяУстройстваСканирования;
	
	Если ВыбранноеУстройство = "" Тогда
		НастройкаИмя = ОткрытьФормуМодально("Справочник.Файлы.Форма.ВыборУстройстваСканирования");
		Если ТипЗнч(НастройкаИмя) = Тип("Структура") Тогда
			ВыбранноеУстройство = НастройкаИмя.Значение;
		КонецЕсли;
		
		Если ВыбранноеУстройство = "" Тогда 
			Отказ = Истина;
			Возврат;
		КонецЕсли;	
	КонецЕсли;	
	
	Если Разрешение = -1 ИЛИ Цветность = -1 ИЛИ Поворот = -1 ИЛИ РазмерБумаги = -1 Тогда
		
		Разрешение = РаботаСФайламиСлужебныйКлиент.ПолучитьНастройку(
			ВыбранноеУстройство, "XRESOLUTION");
		
		Цветность = РаботаСФайламиСлужебныйКлиент.ПолучитьНастройку(
			ВыбранноеУстройство, "PIXELTYPE");
		
		Поворот = РаботаСФайламиСлужебныйКлиент.ПолучитьНастройку(
			ВыбранноеУстройство, "ROTATION");
		
		РазмерБумаги = РаботаСФайламиСлужебныйКлиент.ПолучитьНастройку(
			ВыбранноеУстройство, "SUPPORTEDSIZES");
		
		ДвустороннееСканированиеЧисло = РаботаСФайламиСлужебныйКлиент.ПолучитьНастройку(
			ВыбранноеУстройство, "DUPLEX");
		
		ДоступностьПоворот = (Поворот <> -1);
		ДоступностьРазмерБумаги = (РазмерБумаги <> -1);
		ДоступностьДвустороннееСканирование = (ДвустороннееСканированиеЧисло <> -1);
		
		СистемнаяИнформация = Новый СистемнаяИнформация();
		ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
		
		РаботаСФайламиСлужебныйВызовСервера.ПреобразоватьИСохранитьПараметрыСканера(
			Разрешение, Цветность, Поворот, РазмерБумаги, ИдентификаторКлиента);
	Иначе
		
		ДоступностьПоворот = Не ПоворотПеречисление.Пустая();
		ДоступностьРазмерБумаги = Не РазмерБумагиПеречисление.Пустая();
		ДоступностьДвустороннееСканирование = Истина;

	КонецЕсли;	
	
	ИмяФайлаКартинки = "";
	Элементы.Принять.Доступность = Ложь;
	
	ПараметрСжатие = ?(ВРег(ФорматКартинки) = "JPG", КачествоJPG, СжатиеTIFFЧисло);
	
	КомпонентаTwain.НачатьСканирование(ПоказыватьДиалог, ВыбранноеУстройство, ФорматКартинки, 
		Разрешение, Цветность, Поворот, РазмерБумаги, 
		ПараметрСжатие,
		ДвустороннееСканирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	УдалитьВременныеФайлы(ТаблицаФайлов);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ТаблицаФайлов

&НаКлиенте
Процедура ТаблицаФайловПриАктивизацииСтроки(Элемент)
#Если НЕ ВебКлиент Тогда
	НомерТекущейСТроки = Элементы.ТаблицаФайлов.ТекущаяСтрока;
	СтрокаТаблицы = Элементы.ТаблицаФайлов.ДанныеСтроки(НомерТекущейСТроки);
	
	Если ПутьКВыбранномуФайлу <> СтрокаТаблицы.ПутьКФайлу Тогда
		
		ПутьКВыбранномуФайлу = СтрокаТаблицы.ПутьКФайлу;
		
		Если ПустаяСтрока(СтрокаТаблицы.АдресКартинки) Тогда
			ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКВыбранномуФайлу);
			СтрокаТаблицы.АдресКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		КонецЕсли;	
		
		АдресКартинки = СтрокаТаблицы.АдресКартинки;
		
	КонецЕсли;	
	
#КонецЕсли	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловПередУдалением(Элемент, Отказ)
	
	Если ТаблицаФайлов.Количество() < 2 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НомерТекущейСТроки = Элементы.ТаблицаФайлов.ТекущаяСтрока;
	СтрокаТаблицы = Элементы.ТаблицаФайлов.ДанныеСтроки(НомерТекущейСТроки);
	УдалитьФайлы(СтрокаТаблицы.ПутьКФайлу);
	
	Если ТаблицаФайлов.Количество() = 2 Тогда
		Элементы.ТаблицаФайловКонтекстноеМенюУдалить.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Отмена(Команда)
	УдалитьВременныеФайлы(ТаблицаФайлов);
	Закрыть();
КонецПроцедуры

// Кнопка "Пересканировать" замещает выделенную (или единственную, если она одна) картинку 
//  (или добавляет в конец новые картинки, если ничего не выделено) новым изображением (изображениями).
&НаКлиенте
Процедура Пересканировать(Команда)
	
	Если ТаблицаФайлов.Количество() = 1 Тогда
		УдалитьВременныеФайлы(ТаблицаФайлов);
	ИначеЕсли ТаблицаФайлов.Количество() > 1 Тогда
		
		НомерТекущейСТроки = Элементы.ТаблицаФайлов.ТекущаяСтрока;
		СтрокаТаблицы = Элементы.ТаблицаФайлов.ДанныеСтроки(НомерТекущейСТроки);
		ПозицияДляВставки = ТаблицаФайлов.Индекс(СтрокаТаблицы);
		УдалитьФайлы(СтрокаТаблицы.ПутьКФайлу);
		ТаблицаФайлов.Удалить(СтрокаТаблицы);
		
	КонецЕсли;
	
	Если АдресКартинки <> "" Тогда
		УдалитьИзВременногоХранилища(АдресКартинки);
	КонецЕсли;	
	АдресКартинки = "";
	ПутьКВыбранномуФайлу = "";
	
	ПоказыватьДиалог = ПоказыватьДиалогСканера;
	ВыбранноеУстройство = ИмяУстройстваСканирования;
	ПараметрСжатие = ?(ВРег(ФорматКартинки) = "JPG", КачествоJPG, СжатиеTIFFЧисло);
	
	КомпонентаTwain.НачатьСканирование(ПоказыватьДиалог, ВыбранноеУстройство, ФорматКартинки, 
		Разрешение, Цветность, Поворот, РазмерБумаги, 
		ПараметрСжатие,
		ДвустороннееСканирование);
		
КонецПроцедуры

&НаКлиенте
Процедура ПринятьВсеКакОтдельныеФайлы(Команда)
	
	МассивФайловКопия = Новый Массив;
	Для Каждого Строка Из ТаблицаФайлов Цикл
		МассивФайловКопия.Добавить(Новый Структура("ПутьКФайлу", Строка.ПутьКФайлу));
	КонецЦикла;	
	
	ТаблицаФайлов.Очистить(); // чтобы не удалились файлы в ПриЗакрытии
	
	Закрыть();
	
	РасширениеРезультата = Строка(ФорматХраненияОдностраничный);
	РасширениеРезультата = НРег(РасширениеРезультата); 
	
	// здесь работаем со всеми картинками -каждую как отдельный файл принимаем
	Для Каждого Строка Из МассивФайловКопия Цикл
		
		ПутьКФайлуЛокальный = Строка.ПутьКФайлу;
		
		ФайлРезультата = "";
		Если РасширениеРезультата = "pdf" Тогда
			
		#Если НЕ ВебКлиент Тогда 	
			ФайлРезультата = ПолучитьИмяВременногоФайла("pdf");
		#КонецЕсли	
		
			СтрокаВсехПутей = ПутьКФайлуЛокальный;
			КомпонентаTwain.ОбъединитьВМногостраничныйФайл(СтрокаВсехПутей, ФайлРезультата, ПутьКПрограммеКонвертации);
			
			ОбъектФайлРезультата = Новый Файл(ФайлРезультата);
			Если НЕ ОбъектФайлРезультата.Существует() Тогда				
				ТекстСообщения = ПолучитьТекстСообщенияОшибкиПреобразованияВPDF(ФайлРезультата);					
				Предупреждение(ТекстСообщения);
				ФайлРезультата = "";
			КонецЕсли;	
			
			ПутьКФайлуЛокальный = ФайлРезультата;
			
		КонецЕсли;	
		
		Если НЕ ПустаяСтрока(ПутьКФайлуЛокальный) Тогда
			НеОткрыватьКарточку = Истина;
			РаботаСФайламиКлиент.СоздатьДокументНаОсновеФайла(ПутьКФайлуЛокальный, ВладелецФайла, ЭтаФорма, НеОткрыватьКарточку, ИмяФайла);
		КонецЕсли;
	
		Если НЕ ПустаяСтрока(ФайлРезультата) Тогда
			УдалитьФайлы(ФайлРезультата);
		КонецЕсли;
		
		НомерФайла = НомерФайла + 1;
		ИмяФайла = РаботаСФайламиКлиентСервер.ПолучитьИмяСканированногоФайла(НомерФайла, "");
		
	КонецЦикла;
	
	РаботаСФайламиСлужебныйВызовСервера.ЗанестиМаксимальныйНомерДляСканирования(
		ВладелецФайла, НомерФайла - 1);
	
	УдалитьВременныеФайлы(МассивФайловКопия);
	
КонецПроцедуры

&НаКлиенте
Процедура Принять(Команда)
	
	МассивФайловКопия = Новый Массив;
	Для Каждого Строка Из ТаблицаФайлов Цикл
		МассивФайловКопия.Добавить(Новый Структура("ПутьКФайлу", Строка.ПутьКФайлу));
	КонецЦикла;	
	
	// здесь работаем с одним файлом
	СтрокаТаблицы = ТаблицаФайлов.Получить(0);
	ПутьКФайлуЛокальный = СтрокаТаблицы.ПутьКФайлу;
	
	ТаблицаФайлов.Очистить(); // чтобы не удалились файлы в ПриЗакрытии
	
	Закрыть();
	
	РасширениеРезультата = Строка(ФорматХраненияОдностраничный);
	РасширениеРезультата = НРег(РасширениеРезультата); 
	
	ФайлРезультата = "";
	Если РасширениеРезультата = "pdf" Тогда
		
		#Если НЕ ВебКлиент Тогда 	
			ФайлРезультата = ПолучитьИмяВременногоФайла("pdf");
		#КонецЕсли	
	
		СтрокаВсехПутей = ПутьКФайлуЛокальный;
		КомпонентаTwain.ОбъединитьВМногостраничныйФайл(СтрокаВсехПутей, ФайлРезультата, ПутьКПрограммеКонвертации);
		
		ОбъектФайлРезультата = Новый Файл(ФайлРезультата);
		Если НЕ ОбъектФайлРезультата.Существует() Тогда			
			ТекстСообщения = ПолучитьТекстСообщенияОшибкиПреобразованияВPDF(ФайлРезультата);
			Предупреждение(ТекстСообщения);
			ФайлРезультата = "";
		КонецЕсли;	
		
		УдалитьФайлы(ПутьКФайлуЛокальный);
		ПутьКФайлуЛокальный = ФайлРезультата;
		
	КонецЕсли;	
	
	Если НЕ ПустаяСтрока(ПутьКФайлуЛокальный) Тогда
		РаботаСФайламиКлиент.СоздатьДокументНаОсновеФайла(ПутьКФайлуЛокальный, ВладелецФайла, ЭтаФорма, НеОткрыватьКарточкуПослеСозданияИзФайла, ИмяФайла);
	КонецЕсли;	
	
	УдалитьВременныеФайлы(МассивФайловКопия);
	Если НЕ ПустаяСтрока(ФайлРезультата) Тогда
		УдалитьФайлы(ФайлРезультата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Настройка(Команда)
	
	ДвустороннееСканированиеЧисло = РаботаСФайламиСлужебныйКлиент.ПолучитьНастройку(
		ИмяУстройстваСканирования, "DUPLEX");
	
	ДоступностьДвустороннееСканирование = (ДвустороннееСканированиеЧисло <> -1);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьДиалогСканера",  ПоказыватьДиалогСканера);
	ПараметрыФормы.Вставить("Разрешение",               РазрешениеПеречисление);
	ПараметрыФормы.Вставить("Цветность",                ЦветностьПеречисление);
	ПараметрыФормы.Вставить("Поворот",                  ПоворотПеречисление);
	ПараметрыФормы.Вставить("РазмерБумаги",             РазмерБумагиПеречисление);
	ПараметрыФормы.Вставить("ДвустороннееСканирование", ДвустороннееСканирование);
	
	ПараметрыФормы.Вставить(
		"ИспользоватьImageMagickДляПреобразованияВPDF", ИспользоватьImageMagickДляПреобразованияВPDF);
	
	ПараметрыФормы.Вставить("ДоступностьПоворот",       ДоступностьПоворот);
	ПараметрыФормы.Вставить("ДоступностьРазмерБумаги",  ДоступностьРазмерБумаги);
	
	ПараметрыФормы.Вставить("ДоступностьДвустороннееСканирование", ДоступностьДвустороннееСканирование);
	ПараметрыФормы.Вставить("ФорматСканированногоИзображения",     ФорматСканированногоИзображения);
	ПараметрыФормы.Вставить("КачествоJPG",                         КачествоJPG);
	ПараметрыФормы.Вставить("СжатиеTIFF",                          СжатиеTIFF);
	ПараметрыФормы.Вставить("ФорматХраненияОдностраничный",        ФорматХраненияОдностраничный);
	ПараметрыФормы.Вставить("ФорматХраненияМногостраничный",       ФорматХраненияМногостраничный);
	
	КодВозврата = ОткрытьФормуМодально(
		"Справочник.Файлы.Форма.НастройкаСканированияНаСеанс", ПараметрыФормы);
	
	Если ТипЗнч(КодВозврата) = Тип("Структура") Тогда
		
		РазрешениеПеречисление   = КодВозврата.Разрешение;
		ЦветностьПеречисление    = КодВозврата.Цветность;
		ПоворотПеречисление      = КодВозврата.Поворот;
		РазмерБумагиПеречисление = КодВозврата.РазмерБумаги;
		ДвустороннееСканирование = КодВозврата.ДвустороннееСканирование;
		
		ИспользоватьImageMagickДляПреобразованияВPDF =
			КодВозврата.ИспользоватьImageMagickДляПреобразованияВPDF;
		
		ПоказыватьДиалогСканера         = КодВозврата.ПоказыватьДиалогСканера;
		ФорматСканированногоИзображения = КодВозврата.ФорматСканированногоИзображения;
		КачествоJPG                     = КодВозврата.КачествоJPG;
		СжатиеTIFF                      = КодВозврата.СжатиеTIFF;
		ФорматХраненияОдностраничный    = КодВозврата.ФорматХраненияОдностраничный;
		ФорматХраненияМногостраничный   = КодВозврата.ФорматХраненияМногостраничный;
		
		ПреобразоватьПеречисленияВПараметрыИПолучитьПредставление();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьВсеКакОдинФайл(Команда)
	
	МассивФайловКопия = Новый Массив;
	Для Каждого Строка Из ТаблицаФайлов Цикл
		МассивФайловКопия.Добавить(Новый Структура("ПутьКФайлу", Строка.ПутьКФайлу));
	КонецЦикла;	
	
	ТаблицаФайлов.Очистить(); // чтобы не удалились файлы в ПриЗакрытии
	
	Закрыть();
	
	// здесь работаем со всеми картинками - объединяем их в один многостраничный файл
	СтрокаВсехПутей = "";
	Для Каждого Строка Из МассивФайловКопия Цикл
		СтрокаВсехПутей = СтрокаВсехПутей + "*";
		СтрокаВсехПутей = СтрокаВсехПутей + Строка.ПутьКФайлу;
	КонецЦикла;
	
	ФайлРезультата = "";
#Если НЕ ВебКлиент Тогда 	
	РасширениеРезультата = Строка(ФорматХраненияМногостраничный);
	РасширениеРезультата = НРег(РасширениеРезультата); 
	ФайлРезультата = ПолучитьИмяВременногоФайла(РасширениеРезультата);
#КонецЕсли	
	КомпонентаTwain.ОбъединитьВМногостраничныйФайл(СтрокаВсехПутей, ФайлРезультата, ПутьКПрограммеКонвертации);
	
	ОбъектФайлРезультата = Новый Файл(ФайлРезультата);
	Если НЕ ОбъектФайлРезультата.Существует() Тогда		
		ТекстСообщения = ПолучитьТекстСообщенияОшибкиПреобразованияВPDF(ФайлРезультата);			
		Предупреждение(ТекстСообщения);
		ФайлРезультата = "";
	КонецЕсли;	
	
	Если НЕ ПустаяСтрока(ФайлРезультата) Тогда
		РаботаСФайламиКлиент.СоздатьДокументНаОсновеФайла(ФайлРезультата, ВладелецФайла, ЭтаФорма, НеОткрыватьКарточкуПослеСозданияИзФайла, ИмяФайла);
	КонецЕсли;	

	УдалитьВременныеФайлы(МассивФайловКопия);
	УдалитьФайлы(ФайлРезультата);
	
КонецПроцедуры

&НаКлиенте
Процедура СканироватьЕще(Команда)
	
	ПоказыватьДиалог = ПоказыватьДиалогСканера;
	ВыбранноеУстройство = ИмяУстройстваСканирования;
	ПутьКПрограммеКонвертации = "convert.exe";
	ПараметрСжатие = ?(ВРег(ФорматКартинки) = "JPG", КачествоJPG, СжатиеTIFFЧисло);
	
	ПозицияДляВставки = Неопределено;
	
	КомпонентаTwain.НачатьСканирование(ПоказыватьДиалог, ВыбранноеУстройство, ФорматКартинки, 
		Разрешение, Цветность, Поворот, РазмерБумаги, 
		ПараметрСжатие,
		ДвустороннееСканирование);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПреобразоватьПеречисленияВПараметрыИПолучитьПредставление()
		
	Разрешение = -1;
	Если РазрешениеПеречисление = Перечисления.РазрешенияСканированногоИзображения.dpi200 Тогда
		Разрешение = 200; 
	ИначеЕсли РазрешениеПеречисление = Перечисления.РазрешенияСканированногоИзображения.dpi300 Тогда
		Разрешение = 300;
	ИначеЕсли РазрешениеПеречисление = Перечисления.РазрешенияСканированногоИзображения.dpi600 Тогда
		Разрешение = 600;
	ИначеЕсли РазрешениеПеречисление = Перечисления.РазрешенияСканированногоИзображения.dpi1200 Тогда
		Разрешение = 1200;
	КонецЕсли;
	
	Цветность = -1;
	Если ЦветностьПеречисление = Перечисления.ЦветностиИзображения.Монохромное Тогда
		Цветность = 0;
	ИначеЕсли ЦветностьПеречисление = Перечисления.ЦветностиИзображения.ГрадацииСерого Тогда
		Цветность = 1;
	ИначеЕсли ЦветностьПеречисление = Перечисления.ЦветностиИзображения.Цветное Тогда
		Цветность = 2;
	КонецЕсли;
	
	Поворот = 0;
	Если ПоворотПеречисление = Перечисления.СпособыПоворотаИзображения.НетПоворота Тогда
		Поворот = 0;
	ИначеЕсли ПоворотПеречисление = Перечисления.СпособыПоворотаИзображения.ВправоНа90 Тогда
		Поворот = 90;
	ИначеЕсли ПоворотПеречисление = Перечисления.СпособыПоворотаИзображения.ВправоНа180 Тогда
		Поворот = 180;
	ИначеЕсли ПоворотПеречисление = Перечисления.СпособыПоворотаИзображения.ВлевоНа90 Тогда
		Поворот = 270;
	КонецЕсли;
	
	РазмерБумаги = 0;
	Если РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.НеЗадано Тогда
		РазмерБумаги = 0;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.A3 Тогда
		РазмерБумаги = 11;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.A4 Тогда
		РазмерБумаги = 1;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.A5 Тогда
		РазмерБумаги = 5;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.B4 Тогда
		РазмерБумаги = 6;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.B5 Тогда
		РазмерБумаги = 2;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.B6 Тогда
		РазмерБумаги = 7;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.C4 Тогда
		РазмерБумаги = 14;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.C5 Тогда
		РазмерБумаги = 15;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.C6 Тогда
		РазмерБумаги = 16;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.USLetter Тогда
		РазмерБумаги = 3;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.USLegal Тогда
		РазмерБумаги = 4;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.USExecutive Тогда
		РазмерБумаги = 10;
	КонецЕсли;
	
	СжатиеTIFFЧисло = 6; // БезСжатия
	Если СжатиеTIFF = Перечисления.ВариантыСжатияTIFF.LZW Тогда
		СжатиеTIFFЧисло = 2;
	ИначеЕсли СжатиеTIFF = Перечисления.ВариантыСжатияTIFF.RLE Тогда
		СжатиеTIFFЧисло = 5;
	ИначеЕсли СжатиеTIFF = Перечисления.ВариантыСжатияTIFF.БезСжатия Тогда
		СжатиеTIFFЧисло = 6;
	ИначеЕсли СжатиеTIFF = Перечисления.ВариантыСжатияTIFF.CCITT3 Тогда
		СжатиеTIFFЧисло = 3;
	ИначеЕсли СжатиеTIFF = Перечисления.ВариантыСжатияTIFF.CCITT4 Тогда
		СжатиеTIFFЧисло = 4;
		
	КонецЕсли;
	
	Представление = "";
	// информационная надпись вида:
	// "Формат хранения: PDF. Формат сканирования: JPG. Качество: 75. Формат хранения многостраничный: PDF. Разрешение: 200. Цветное";
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = Перечисления.ФорматыХраненияОдностраничныхФайлов.PDF Тогда
			ФорматКартинки = Строка(ФорматСканированногоИзображения);
			
			Представление = Представление + НСтр("ru = 'Формат хранения:'") + " ";
			Представление = Представление + "PDF";
			Представление = Представление + ". ";
			Представление = Представление + НСтр("ru = 'Формат сканирования:'") + " ";
			Представление = Представление + ФорматКартинки;
			Представление = Представление + ". ";
		Иначе	
			ФорматКартинки = Строка(ФорматХраненияОдностраничный);
			Представление = Представление + НСтр("ru = 'Формат хранения:'") + " ";
			Представление = Представление + ФорматКартинки;
			Представление = Представление + ". ";
		КонецЕсли;
	Иначе	
		ФорматКартинки = Строка(ФорматСканированногоИзображения);
		Представление = Представление + НСтр("ru = 'Формат хранения:'") + " ";
		Представление = Представление + ФорматКартинки;
		Представление = Представление + ". ";
	КонецЕсли;

	Если ВРег(ФорматКартинки) = "JPG" Тогда
		Представление = Представление +  НСтр("ru = 'Качество:'") + " " + Строка(КачествоJPG) + ". ";
	КонецЕсли;	
	
	Если ВРег(ФорматКартинки) = "TIF" Тогда
		Представление = Представление +  НСтр("ru = 'Сжатие:'") + " " + Строка(СжатиеTIFF) + ". ";
	КонецЕсли;
	
	Представление = Представление + НСтр("ru = 'Формат хранения многостраничный:'") + " ";
	Представление = Представление + Строка(ФорматХраненияМногостраничный);
	Представление = Представление + ". ";
	
	Представление = Представление + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Разрешение: %1 dpi. %2.'") + " ",
		Строка(Разрешение), Строка(ЦветностьПеречисление));
	
	Если НЕ ПоворотПеречисление.Пустая() Тогда
		Представление = Представление +  НСтр("ru = 'Поворот:'")+ " " + Строка(ПоворотПеречисление) + ". ";
	КонецЕсли;	
	
	Если НЕ РазмерБумагиПеречисление.Пустая() Тогда
		Представление = Представление +  НСтр("ru = 'Размер бумаги:'") + " " + Строка(РазмерБумагиПеречисление) + ". ";
	КонецЕсли;	
	
	Если ДвустороннееСканирование = Истина Тогда
		Представление = Представление +  НСтр("ru = 'Двустороннее сканирование'") + ". ";
	КонецЕсли;	
	
	ТекстНастроек = Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
#Если НЕ ВебКлиент Тогда
		
	Если Источник = "TWAIN" И Событие = "ImageAcquired" Тогда
		
		ИмяФайлаКартинки = Данные;
		Элементы.Принять.Доступность = Истина;
		
		КоличествоСтрокДоДобавления = ТаблицаФайлов.Количество();
		
		СтрокаТаблицы = Неопределено;
		
		Если ПозицияДляВставки = Неопределено Тогда
			СтрокаТаблицы = ТаблицаФайлов.Добавить();
		Иначе	
			СтрокаТаблицы = ТаблицаФайлов.Вставить(ПозицияДляВставки);
			ПозицияДляВставки = ПозицияДляВставки + 1;
		КонецЕсли;
		
		СтрокаТаблицы.ПутьКФайлу = ИмяФайлаКартинки;
		
		Если НарастающийНомерИзображения = Неопределено Тогда
			НарастающийНомерИзображения = 1;
		КонецЕсли;	
			
		СтрокаТаблицы.Представление = "Изображение" + Строка(НарастающийНомерИзображения);
		НарастающийНомерИзображения = НарастающийНомерИзображения + 1;
		
		Если КоличествоСтрокДоДобавления = 0 Тогда
			ПутьКВыбранномуФайлу = СтрокаТаблицы.ПутьКФайлу;
			ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКВыбранномуФайлу);
			АдресКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
			СтрокаТаблицы.АдресКартинки = АдресКартинки;
		КонецЕсли;
		
		Если ТаблицаФайлов.Количество() > 1 И Элементы.ТаблицаФайлов.Видимость = Ложь Тогда
			Элементы.ТаблицаФайлов.Видимость = Истина;
			Элементы.ФормаПринятьВсеКакОдинФайл.Видимость = Истина;
			Элементы.ФормаПринятьВсеКакОтдельныеФайлы.Видимость = Истина;
			Элементы.Принять.Видимость = Ложь;
		КонецЕсли;	
		
		Если ТаблицаФайлов.Количество() > 1 Тогда
			Элементы.ТаблицаФайловКонтекстноеМенюУдалить.Доступность = Истина;
		КонецЕсли;	
		
	ИначеЕсли Источник = "TWAIN" И Событие = "EndBatch" Тогда
		
		Если ТаблицаФайлов.Количество() <> 0 Тогда
			ИдентификаторСтроки = ТаблицаФайлов[ТаблицаФайлов.Количество() - 1].ПолучитьИдентификатор();
			Элементы.ТаблицаФайлов.ТекущаяСтрока = ИдентификаторСтроки;
		КонецЕсли;	
		
	ИначеЕсли Источник = "TWAIN" И Событие = "UserPressedCancel" Тогда	
		Закрыть();
	КонецЕсли;	
	
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура УдалитьВременныеФайлы(ТаблицаЗначенийФайлов)
	
	Для Каждого Строка Из ТаблицаЗначенийФайлов Цикл
		УдалитьФайлы(Строка.ПутьКФайлу);
	КонецЦикла;	
	
	ТаблицаЗначенийФайлов.Очистить();
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекстСообщенияОшибкиПреобразованияВPDF(ФайлРезультата)
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не найден файл ""%1"".
		           |Проверьте, что установлена программа ImageMagick и
		           |указан правильный путь к программе преобразования в
		           |PDF в форме настроек сканирования.'"),
		ФайлРезультата);
		
	Возврат ТекстСообщения;
	
КонецФункции

