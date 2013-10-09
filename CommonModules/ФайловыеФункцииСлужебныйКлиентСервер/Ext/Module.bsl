﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Файловые функции".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Персональные настройки состоят из настроек подсистемы ФайловыеФункции
// (см. ФайловыеФункцииСлужебныйПовтИсп.НастройкиРаботыСФайлами),
// а также настроек подсистем РаботаСФайлами и ПрисоединенныеФайлы,
// которые добавляются через процедуру ДобавитьНастройкиРаботыСФайлами
// модуля СтандартныеПодсистемыПереопределяемый.
//
Функция ПерсональныеНастройкиРаботыСФайлами() Экспорт

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ФайловыеФункцииСлужебныйПовтИсп.НастройкиРаботыСФайлами().ПерсональныеНастройки;
#Иначе
	Возврат ФайловыеФункцииСлужебныйКлиентПовтИсп.ПерсональныеНастройкиРаботыСФайлами();
#КонецЕсли

КонецФункции

// Персональные настройки состоят из настроек подсистемы ФайловыеФункции
// (см. ФайловыеФункцииСлужебныйПовтИсп.НастройкиРаботыСФайлами),
// а также настроек подсистем РаботаСФайлами и ПрисоединенныеФайлы,
// которые добавляются через процедуру ДобавитьНастройкиРаботыСФайлами
// модуля СтандартныеПодсистемыПереопределяемый.
//
Функция ОбщиеНастройкиРаботыСФайлами() Экспорт

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ФайловыеФункцииСлужебныйПовтИсп.НастройкиРаботыСФайлами().ОбщиеНастройки;
#Иначе
	Возврат ФайловыеФункцииСлужебныйКлиентПовтИсп.ОбщиеНастройкиРаботыСФайлами();
#КонецЕсли

КонецФункции


// Извлечь текст из файла и возвратить его в виде строки.
Функция ИзвлечьТекст(ПолноеИмяФайла, Отказ = Ложь, Кодировка = Неопределено) Экспорт
	
	ИзвлеченныйТекст = "";
	
	ОбщиеНастройки = ОбщиеНастройкиРаботыСФайлами();
	
#Если Не ВебКлиент Тогда
	
	РасширениеИмениФайла =
		ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ПолноеИмяФайла);
	
	РасширениеФайлаВСписке = РасширениеФайлаВСписке(
		ОбщиеНастройки.СписокРасширенийТекстовыхФайлов, РасширениеИмениФайла);
	
	Если РасширениеФайлаВСписке Тогда
		Отказ = Ложь;
		Возврат ИзвлечьТекстИзТекстовогоФайла(ПолноеИмяФайла, Кодировка);
	КонецЕсли;
	
	Попытка
		Извлечение = Новый ИзвлечениеТекста(ПолноеИмяФайла);
		ИзвлеченныйТекст = Извлечение.ПолучитьТекст();
	Исключение
		// Когда текст некому извлечь исключение не требуется. Это нормальный случай.
		ИзвлеченныйТекст = "";
		Отказ = Истина;
	КонецПопытки;
#КонецЕсли
	
	Если ПустаяСтрока(ИзвлеченныйТекст) Тогда
		
		РасширениеИмениФайла =
			ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ПолноеИмяФайла);
		
		РасширениеФайлаВСписке = РасширениеФайлаВСписке(
			ОбщиеНастройки.СписокРасширенийФайловOpenDocument, РасширениеИмениФайла);
		
		Если РасширениеФайлаВСписке Тогда
			Отказ = Ложь;
			Возврат ИзвлечьТекстOpenDocument(ПолноеИмяФайла);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИзвлеченныйТекст;
	
КонецФункции

// Извлечь текст из файла и поместить во временное хранилище.
Функция ИзвлечьТекстВоВременноеХранилище(ПолноеИмяФайла, УникальныйИдентификатор = "", Отказ = Ложь,
	Кодировка = Неопределено) Экспорт
	
	АдресВременногоХранилища = "";
	Отказ = Ложь;
	
#Если Не ВебКлиент Тогда
	
	Текст = ИзвлечьТекст(ПолноеИмяФайла, Отказ, Кодировка);
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ТекстовыйФайл = Новый ЗаписьТекста(ИмяВременногоФайла, КодировкаТекста.UTF8);
	ТекстовыйФайл.Записать(Текст);
	ТекстовыйФайл.Закрыть();
	
#Если Клиент Тогда
	ПоместитьФайл(АдресВременногоХранилища, ИмяВременногоФайла, , Ложь, УникальныйИдентификатор);
#Иначе
	Возврат Текст;
#КонецЕсли
	
	УдалитьФайлы(ИмяВременногоФайла);
	
#КонецЕсли
	
	Возврат АдресВременногоХранилища;
	
КонецФункции


// Получить уникальное имя файла в рабочем каталоге.
//  Если есть совпадения - будет имя подобное "A1\Приказ.doc".
//
Функция ПолучитьУникальноеИмяСПутем(ИмяКаталога, ИмяФайла, ТипПлатформыТекущий) Экспорт
	
	ИтоговыйПуть = "";
	
	Счетчик = 0;
	ЦиклНомер = 0;
	Успешно = Ложь;
	
	ГенераторСлучая = Неопределено;
	
#Если Не ВебКлиент Тогда
	// ТекущаяДата() используется только для генерации случайного числа,
	// поэтому приведение к ТекущаяДатаСеанса не требуется.
	ГенераторСлучая = Новый ГенераторСлучайныхЧисел(Секунда(ТекущаяДата()));
#КонецЕсли
	
	Пока НЕ Успешно И ЦиклНомер < 100 Цикл
		НомерКаталога = 0;
#Если Не ВебКлиент Тогда
		НомерКаталога = ГенераторСлучая.СлучайноеЧисло(0, 25);
#Иначе
		// ТекущаяДата() используется только для генерации случайного числа,
		// поэтому приведение к ТекущаяДатаСеанса не требуется.
		НомерКаталога = Секунда(ТекущаяДата()) % 26;
#КонецЕсли
		
		КодБукваA = КодСимвола("A", 1); 
		КодКаталога = КодБукваA + НомерКаталога;
		
		БукваКаталога = Символ(КодКаталога);
		
		ПодКаталог = ""; // Частичный путь.
		
		// По умолчанию вначале используется корень, если возможности нет,
		// то добавляется A, B, ... Z,  A1, B1, .. Z1, ..  A2, B2 и т.д.
		Если  Счетчик = 0 Тогда
			ПодКаталог = "";
		Иначе
			ПодКаталог = БукваКаталога; 
			ЦиклНомер = Окр(Счетчик / 26);
			
			Если ЦиклНомер <> 0 Тогда
				ЦиклНомерСтрока = Строка(ЦиклНомер);
				ПодКаталог = ПодКаталог + ЦиклНомерСтрока;
			КонецЕсли;
			
			ПодКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
				ПодКаталог, ТипПлатформыТекущий);
		КонецЕсли;
		
		ПолныйПодКаталог = ИмяКаталога + ПодКаталог;
		
		// Создание каталога для файлов.
		КаталогНаДиске = Новый Файл(ПолныйПодКаталог);
		Если НЕ КаталогНаДиске.Существует() Тогда
			Попытка
				СоздатьКаталог(ПолныйПодКаталог);
			Исключение
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при создании каталога ""%1"":
					           |""%2"".'"),
					ПолныйПодКаталог,
					КраткоеПредставлениеОшибки(ИнформацияОбОшибке()) );
			КонецПопытки;
		КонецЕсли;
		
		ФайлПопытки = ПолныйПодКаталог + ИмяФайла;
		Счетчик = Счетчик + 1;
		
		// Проверка, есть ли файл с таким именем.
		ФайлНаДиске = Новый Файл(ФайлПопытки);
		Если НЕ ФайлНаДиске.Существует() Тогда  // Нет такого файла.
			ИтоговыйПуть = ПодКаталог + ИмяФайла;
			Успешно = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИтоговыйПуть;
	
КонецФункции

// Возвращает Истина, если файл с таким расширением находится в списке расширений
Функция РасширениеФайлаВСписке(СписокРасширений, РасширениеФайла) Экспорт
	
	РасширениеФайлаБезТочки = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(РасширениеФайла);
	
	МассивРасширений = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
		НРег(СписокРасширений), " ");
	
	Если МассивРасширений.Найти(РасширениеФайлаБезТочки) <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции


// Проверяет расширение файла и размер.
Функция ПроверитьВозможностьЗагрузкиФайла(Файл,
                                          ВызыватьИсключение = Истина,
                                          МассивИменФайловСОшибками = Неопределено) Экспорт
	
	ОбщиеНастройки = ОбщиеНастройкиРаботыСФайлами();
	
	// Размер файла слишком большой.
	Если Файл.Размер() > ОбщиеНастройки.МаксимальныйРазмерФайла Тогда
		
		РазмерВМб     = Файл.Размер() / (1024 * 1024);
		РазмерВМбМакс = ОбщиеНастройки.МаксимальныйРазмерФайла / (1024 * 1024);
		
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Размер файла ""%1"" (%2 Мб)
			           |превышает максимально допустимый размер файла (%3 Мб).'"),
			Файл.Имя,
			ПолучитьСтрокуСРазмеромФайла(РазмерВМб),
			ПолучитьСтрокуСРазмеромФайла(РазмерВМбМакс));
		
		Если ВызыватьИсключение Тогда
			ВызватьИсключение ОписаниеОшибки;
		КонецЕсли;
		
		Запись = Новый Структура;
		Запись.Вставить("ИмяФайла", Файл.ПолноеИмя);
		Запись.Вставить("Ошибка",   ОписаниеОшибки);
		
		МассивИменФайловСОшибками.Добавить(Запись);
		Возврат Ложь;
	КонецЕсли;
	
	// Проверка расширения файла.
	Если Не ПроверитьРасширениеФайлаДляЗагрузки(Файл.Расширение, Ложь) Тогда
		
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Загрузка файлов с расширением ""%1"" запрещена.
			           |Обратитесь к администратору.'"),
			Файл.Расширение);
		
		Если ВызыватьИсключение Тогда
			ВызватьИсключение ОписаниеОшибки;
		КонецЕсли;
		
		Запись = Новый Структура;
		Запись.Вставить("ИмяФайла", Файл.ПолноеИмя);
		Запись.Вставить("Ошибка",   ОписаниеОшибки);
		
		МассивИменФайловСОшибками.Добавить(Запись);
		Возврат Ложь;
	КонецЕсли;
	
	// Временные файлы Word не импортируются.
	Если Лев(Файл.Имя, 1) = "~"
	   И Файл.ПолучитьНевидимость() = Истина Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Возвращает Истина, если файл с таким расширением можно загружать.
Функция ПроверитьРасширениеФайлаДляЗагрузки(РасширениеФайла, ВызыватьИсключение = Истина) Экспорт
	
	ОбщиеНастройки = ОбщиеНастройкиРаботыСФайлами();
	
	Если НЕ ОбщиеНастройки.ЗапретЗагрузкиФайловПоРасширению Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если РасширениеФайлаВСписке(ОбщиеНастройки.СписокЗапрещенныхРасширений, РасширениеФайла) Тогда
		
		Если ВызыватьИсключение Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Загрузка файлов с расширением ""%1"" запрещена.
				           |Обратитесь к администратору.'"),
				РасширениеФайла);
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Вызывает исключение, если файл имеет недопустимый размер для загрузки.
Процедура ПроверитьРазмерФайлаДляЗагрузки(Файл) Экспорт
	
	ОбщиеНастройки = ОбщиеНастройкиРаботыСФайлами();
	
	Если ТипЗнч(Файл) = Тип("Файл") Тогда
		Размер = Файл.Размер();
	Иначе
		Размер = Файл.Размер;
	КонецЕсли;
	
	Если Размер > ОбщиеНастройки.МаксимальныйРазмерФайла Тогда
	
		РазмерВМб     = Размер / (1024 * 1024);
		РазмерВМбМакс = ОбщиеНастройки.МаксимальныйРазмерФайла / (1024 * 1024);
		
		Если ТипЗнч(Файл) = Тип("Файл") Тогда
			Имя = Файл.Имя;
		Иначе
			Имя = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
				Файл.ПолноеНаименование, Файл.Расширение);
		КонецЕсли;
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Размер файла ""%1"" (%2 Мб)
			           |превышает максимально допустимый размер файла (%3 Мб).'"),
			Имя,
			ПолучитьСтрокуСРазмеромФайла(РазмерВМб),
			ПолучитьСтрокуСРазмеромФайла(РазмерВМбМакс));
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для пользовательского интерфейса

// Возвращает Строку сообщения о недопустимости подписания занятого файла
//
Функция СтрокаСообщенияОНедопустимостиПодписанияЗанятогоФайла(ФайлСсылка = Неопределено) Экспорт
	
	Если ФайлСсылка = Неопределено Тогда
		Возврат НСтр("ru = 'Нельзя подписать занятый файл.'");
	Иначе
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Нельзя подписать занятый файл: %1.'"),
			Строка(ФайлСсылка) );
	КонецЕсли;
	
КонецФункции

// Возвращает Строку сообщения о недопустимости подписания зашифрованного файла
//
Функция СтрокаСообщенияОНедопустимостиПодписанияЗашифрованногоФайла(ФайлСсылка = Неопределено) Экспорт
	
	Если ФайлСсылка = Неопределено Тогда
		Возврат НСтр("ru = 'Нельзя подписать зашифрованный файл.'");
	Иначе
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Нельзя подписать зашифрованный файл: %1.'"),
						Строка(ФайлСсылка) );
	КонецЕсли;
	
КонецФункции

// Возвращает текст сообщения об ошибке создания нового файла.
//
// Параметры:
//  ИнформацияОбОшибке - ИнформацияОбОшибке.
//
Функция ОшибкаСозданияНовогоФайла(ИнформацияОбОшибке) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Ошибка создания нового файла.
		           |
		           |%1'"),
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке));

КонецФункции

// Возвращает стандартный текст ошибки.
Функция ОшибкаФайлНеНайденВХранилищеФайлов(ИмяФайла, ПоискВТоме = Истина) Экспорт
	
	Если ПоискВТоме Тогда
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка открытия файла:
			           |""%1"".
			           |
			           |Файл не найден в хранилище файлов.
			           |Возможно файл удален антивирусной программой.
			           |Обратитесь к администратору.'"),
			ИмяФайла);
	Иначе
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка открытия файла:
			           |""%1"".
			           |
			           |Файл не найден в хранилище файлов.
			           |Обратитесь к администратору.'"),
			ИмяФайла);
	КонецЕсли;
	
	Возврат ТекстОшибки;
	
КонецФункции

// Получить строку с представлением размера файла - например для отображения в Состояние при передаче файла
Функция ПолучитьСтрокуСРазмеромФайла(Знач РазмерВМб) Экспорт
	
	Если РазмерВМб < 0.1 Тогда
		РазмерВМб = 0.1;
	КонецЕсли;	
	
	СтрокаРазмера = ?(РазмерВМб >= 1, Формат(РазмерВМб, "ЧДЦ=0"), Формат(РазмерВМб, "ЧДЦ=1; ЧН=0"));
	Возврат СтрокаРазмера;
	
КонецФункции	

// Получается индекс пиктограммы файла - индекс в картинке КоллекцияПиктограммФайлов
Функция ПолучитьИндексПиктограммыФайла(Знач РасширениеФайла) Экспорт
	
	Если ТипЗнч(РасширениеФайла) <> Тип("Строка")
	 ИЛИ ПустаяСтрока(РасширениеФайла) Тогда
		
		Возврат 0;
	КонецЕсли;
	
	РасширениеФайла = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(РасширениеФайла);
	
	Расширение = "." + НРег(РасширениеФайла) + ";";
	
	Если Найти(".dt;.1cd;.cf;.cfu;", Расширение) <> 0 Тогда
		Возврат 6; //Файлы 1С.
		
	ИначеЕсли Расширение = ".mxl;" Тогда
		Возврат 8; //Табличный Файл.
		
	ИначеЕсли Найти(".txt;.log;.ini;", Расширение) <> 0 Тогда
		Возврат 10; // Текстовый Файл.
		
	ИначеЕсли Расширение = ".epf;" Тогда
		Возврат 12; //Внешние обработки.
		
	ИначеЕсли Найти(".ico;.wmf;.emf;",Расширение) <> 0 Тогда
		Возврат 14; // Картинки.
		
	ИначеЕсли Найти(".htm;.html;.url;.mht;.mhtml;",Расширение) <> 0 Тогда
		Возврат 16; // HTML.
		
	ИначеЕсли Найти(".doc;.dot;.rtf;",Расширение) <> 0 Тогда
		Возврат 18; // Файл Microsoft Word.
		
	ИначеЕсли Найти(".xls;.xlw;",Расширение) <> 0 Тогда
		Возврат 20; // Файл Microsoft Excel.
		
	ИначеЕсли Найти(".ppt;.pps;",Расширение) <> 0 Тогда
		Возврат 22; // Файл Microsoft PowerPoint.
		
	ИначеЕсли Найти(".vsd;",Расширение) <> 0 Тогда
		Возврат 24; // Файл Microsoft Visio.
		
	ИначеЕсли Найти(".mpp;",Расширение) <> 0 Тогда
		Возврат 26; // Файл Microsoft Visio.
		
	ИначеЕсли Найти(".mdb;.adp;.mda;.mde;.ade;",Расширение) <> 0 Тогда
		Возврат 28; // База данных Microsoft Access.
		
	ИначеЕсли Найти(".xml;",Расширение) <> 0 Тогда
		Возврат 30; // xml.
		
	ИначеЕсли Найти(".msg;",Расширение) <> 0 Тогда
		Возврат 32; // Письмо электронной почты.
		
	ИначеЕсли Найти(".zip;.rar;.arj;.cab;.lzh;.ace;",Расширение) <> 0 Тогда
		Возврат 34; // Архивы.
		
	ИначеЕсли Найти(".exe;.com;.bat;.cmd;",Расширение) <> 0 Тогда
		Возврат 36; // Исполняемые файлы.
		
	ИначеЕсли Найти(".grs;",Расширение) <> 0 Тогда
		Возврат 38; // Графическая схема.
		
	ИначеЕсли Найти(".geo;",Расширение) <> 0 Тогда
		Возврат 40; // Географическая схема.
		
	ИначеЕсли Найти(".jpg;.jpeg;.jp2;.jpe;",Расширение) <> 0 Тогда
		Возврат 42; // jpg.
		
	ИначеЕсли Найти(".bmp;.dib;",Расширение) <> 0 Тогда
		Возврат 44; // bmp.
		
	ИначеЕсли Найти(".tif;.tiff;",Расширение) <> 0 Тогда
		Возврат 46; // tif.
		
	ИначеЕсли Найти(".gif;",Расширение) <> 0 Тогда
		Возврат 48; // gif.
		
	ИначеЕсли Найти(".png;",Расширение) <> 0 Тогда
		Возврат 50; // png.
		
	ИначеЕсли Найти(".pdf;",Расширение) <> 0 Тогда
		Возврат 52; // pdf.
		
	ИначеЕсли Найти(".odt;",Расширение) <> 0 Тогда
		Возврат 54; // Open Office writer.
		
	ИначеЕсли Найти(".odf;",Расширение) <> 0 Тогда
		Возврат 56; // Open Office math.
		
	ИначеЕсли Найти(".odp;",Расширение) <> 0 Тогда
		Возврат 58; // Open Office Impress.
		
	ИначеЕсли Найти(".odg;",Расширение) <> 0 Тогда
		Возврат 60; // Open Office draw.
		
	ИначеЕсли Найти(".ods;",Расширение) <> 0 Тогда
		Возврат 62; // Open Office calc.
		
	ИначеЕсли Найти(".mp3;",Расширение) <> 0 Тогда
		Возврат 64;
		
	ИначеЕсли Найти(".erf;",Расширение) <> 0 Тогда
		Возврат 66; // Внешние отчеты.
		
	ИначеЕсли Найти(".docx;",Расширение) <> 0 Тогда
		Возврат 68; // Файл Microsoft Word docx.
		
	ИначеЕсли Найти(".xlsx;",Расширение) <> 0 Тогда
		Возврат 70; // Файл Microsoft Excel xlsx.
		
	ИначеЕсли Найти(".pptx;",Расширение) <> 0 Тогда
		Возврат 72; // Файл Microsoft PowerPoint pptx.
		
	ИначеЕсли Найти(".p7s;",Расширение) <> 0 Тогда
		Возврат 74; // Файл подписи.
		
	ИначеЕсли Найти(".p7m;",Расширение) <> 0 Тогда
		Возврат 76; // зашифрованное сообщение.
	Иначе
		Возврат 4;
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие

// Удаляет файлы после импорта или загрузки.
Процедура УдалитьФайлыПослеДобавления(МассивСтруктурВсехФайлов, МассивВсехПапок, РежимЗагрузки) Экспорт
	
	Для Каждого Элемент Из МассивСтруктурВсехФайлов Цикл
		ВыбранныйФайл = Новый Файл(Элемент.ИмяФайла);
		ВыбранныйФайл.УстановитьТолькоЧтение(Ложь);
		УдалитьФайлы(ВыбранныйФайл.ПолноеИмя);
	КонецЦикла;
	
	Если РежимЗагрузки Тогда
		Для Каждого Элемент Из МассивВсехПапок Цикл
			НайденныеФайлы = НайтиФайлы(Элемент, "*.*");
			Если НайденныеФайлы.Количество() = 0 Тогда
				ВыбранныйФайл = Новый Файл(Элемент);
				ВыбранныйФайл.УстановитьТолькоЧтение(Ложь);
				УдалитьФайлы(ВыбранныйФайл.ПолноеИмя);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры	

// Возвращает массив файлов, эмулируя работу НайтиФайлы - но не по файловой системе, а по Соответствию
//  если ПсевдоФайловаяСистема пуста - работает с файловой системой
Функция НайтиФайлыПсевдо(Знач ПсевдоФайловаяСистема, Путь) Экспорт
	
	Если ПсевдоФайловаяСистема.Количество() = 0 Тогда
		Файлы = НайтиФайлы(Путь, "*.*");
		Возврат Файлы;
	КонецЕсли;
	
	Файлы = Новый Массив;
	
	ЗначениеНайденное = ПсевдоФайловаяСистема.Получить(Строка(Путь));
	Если ЗначениеНайденное <> Неопределено Тогда
		Для Каждого ИмяФайла Из ЗначениеНайденное Цикл
			Попытка
				ФайлИзСписка = Новый Файл(ИмяФайла);
				Файлы.Добавить(ФайлИзСписка);
			Исключение
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Файлы;
	
КонецФункции

// Функция пытается по переданным именам файлов сделать сопоставление
// на файлы данных и файлы их подписей.
// Сопоставление происходит на основе правила формирования имени подписи,
// и расширения файла подписи (p7s)
// Например:
//	Имя файла данных:  example.txt
//	имя файла подписи: example-Ivanov Petr.p7s
//	имя файла подписи: example-Ivanov Petr (1).p7s
//
// Возвращает соответствие, в котором:
// ключ - имя файла
// значение - массив найденных соответствий - подписей
// 
Функция ПолучитьСоответствиеФайловИПодписей(ИменаФайлов, РасширениеДляФайловПодписи) Экспорт
	
	Результат = Новый Соответствие;
	
	// разделяем файлы по расширению
	ИменаФайловДанных = Новый Массив;
	ИменаФайловПодписей = Новый Массив;
	
	Для Каждого ИмяФайла Из ИменаФайлов Цикл
		Если Прав(ИмяФайла, 3) = РасширениеДляФайловПодписи Тогда
			ИменаФайловПодписей.Добавить(ИмяФайла);
		Иначе
			ИменаФайловДанных.Добавить(ИмяФайла);
		КонецЕсли;
	КонецЦикла;
	
	// отсортируем имена файлов данных по убыванию числа символов в строке
	
	Для ИндексА = 1 По ИменаФайловДанных.Количество() Цикл
		ИндексМАКС = ИндексА; // считаем что текущий файл имеет самое большое число символов
		Для ИндексБ = ИндексА+1 По ИменаФайловДанных.Количество() Цикл
			Если СтрДлина(ИменаФайловДанных[ИндексМАКС-1]) > СтрДлина(ИменаФайловДанных[ИндексБ-1]) Тогда
				ИндексМАКС = ИндексБ;
			КонецЕсли;
		КонецЦикла;
		своп = ИменаФайловДанных[ИндексА-1];
		ИменаФайловДанных[ИндексА-1] = ИменаФайловДанных[ИндексМАКС-1];
		ИменаФайловДанных[ИндексМАКС-1] = своп;
	КонецЦикла;
	
	// поиск соответствий имен файлов
	Для Каждого ИмяФайлаДанных Из ИменаФайловДанных Цикл
		Результат.Вставить(ИмяФайлаДанных, НайтиИменаФайловПодписей(ИмяФайлаДанных, ИменаФайловПодписей));
	КонецЦикла;
	
	// оставшиеся файлы подписей не распознаны как подписи относящиеся к какому то файлу
	Для Каждого ИмяФайлаПодписи Из ИменаФайловПодписей Цикл
		Результат.Вставить(ИмяФайлаПодписи, Новый Массив);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

// Извлекает текст в соответствии с кодировкой.
// Если кодировка не задана - сама вычисляет кодировку.
//
Функция ИзвлечьТекстИзТекстовогоФайла(ПолноеИмяФайла, Кодировка)
	
	ИзвлеченныйТекст = "";
	
#Если Не ВебКлиент Тогда
	
	// Определение кодировки.
	Если Не ЗначениеЗаполнено(Кодировка) Тогда
		Кодировка = Неопределено;
	КонецЕсли;
	
	ЧтениеТекста = Новый ЧтениеТекста(ПолноеИмяФайла, Кодировка);
	ИзвлеченныйТекст = ЧтениеТекста.Прочитать();
	
#КонецЕсли
	
	Возврат ИзвлеченныйТекст;
	
КонецФункции

// Извлечь текст из файла OpenDocument и возвратить его в виде строки
//
Функция ИзвлечьТекстOpenDocument(ПутьКФайлу)
	
	ИзвлеченныйТекст = "";
	
#Если Не ВебКлиент Тогда
	
	ВременнаяПапкаДляРазархивирования = ПолучитьИмяВременногоФайла("");
	ВременныйZIPФайл = ПолучитьИмяВременногоФайла("zip"); 
	
	КопироватьФайл(ПутьКФайлу, ВременныйZIPФайл);
	Файл = Новый Файл(ВременныйZIPФайл);
	Файл.УстановитьТолькоЧтение(Ложь);

	Попытка
		Архив = Новый ЧтениеZipФайла();
		Архив.Открыть(ВременныйZIPФайл);
		Архив.ИзвлечьВсе(ВременнаяПапкаДляРазархивирования, РежимВосстановленияПутейФайловZIP.Восстанавливать);
		Архив.Закрыть();
		ЧтениеXML = Новый ЧтениеXML();
		
		ЧтениеXML.ОткрытьФайл(ВременнаяПапкаДляРазархивирования + "/content.xml");
		ИзвлеченныйТекст = ИзвлечьТекстИзContentXML(ЧтениеXML);
		ЧтениеXML.Закрыть();
	Исключение
		// не считаем ошибкой, т.к. например расширение OTF может быть как OpenDocument, так и шрифт OpenType
		ИзвлеченныйТекст = "";
	КонецПопытки;
	
	УдалитьФайлы(ВременнаяПапкаДляРазархивирования);
	УдалитьФайлы(ВременныйZIPФайл);
	
#КонецЕсли
	
	Возврат ИзвлеченныйТекст;
	
КонецФункции

// Извлечь текст из объекта ЧтениеXML (прочитанного из файла OpenDocument)
Функция ИзвлечьТекстИзContentXML(ЧтениеXML)
	
	ИзвлеченныйТекст = "";
	ПоследнееИмяТега = "";
	
#Если Не ВебКлиент Тогда
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			ПоследнееИмяТега = ЧтениеXML.Имя;
			
			Если ЧтениеXML.Имя = "text:p" Тогда
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + Символы.ПС;
				КонецЕсли;
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "text:line-break" Тогда
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + Символы.ПС;
				КонецЕсли;
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "text:tab" Тогда
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + Символы.Таб;
				КонецЕсли;
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "text:s" Тогда
				
				СтрокаДобавки = " "; // пробел
				
				Если ЧтениеXML.КоличествоАтрибутов() > 0 Тогда
					Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
						Если ЧтениеXML.Имя = "text:c"  Тогда
							ЧислоПробелов = Число(ЧтениеXML.Значение);
							СтрокаДобавки = "";
							Для Индекс = 0 По ЧислоПробелов - 1 Цикл
								СтрокаДобавки = СтрокаДобавки + " "; // пробел
							КонецЦикла;
						КонецЕсли;
					КонецЦикла
				КонецЕсли;
				
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + СтрокаДобавки;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
			
			Если Найти(ПоследнееИмяТега, "text:") <> 0 Тогда
				ИзвлеченныйТекст = ИзвлеченныйТекст + ЧтениеXML.Значение;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
#КонецЕсли

	Возврат ИзвлеченныйТекст;
	
КонецФункции	

Функция НайтиИменаФайловПодписей(ИмяФайлаДанных, ИменаФайловПодписей)
	
	ИменаПодписей = Новый Массив;
	
	Файл = Новый Файл(ИмяФайлаДанных);
	ИмяБезРасширения = Файл.ИмяБезРасширения;
	
	Для Каждого ИмяФайлаПодписи Из ИменаФайловПодписей Цикл
		Если Найти(ИмяФайлаПодписи, ИмяБезРасширения) > 0 Тогда
			ИменаПодписей.Добавить(ИмяФайлаПодписи);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ИмяФайлаПодписи Из ИменаПодписей Цикл
		ИменаФайловПодписей.Удалить(ИменаФайловПодписей.Найти(ИмяФайлаПодписи));
	КонецЦикла;
	
	Возврат ИменаПодписей;
	
КонецФункции

