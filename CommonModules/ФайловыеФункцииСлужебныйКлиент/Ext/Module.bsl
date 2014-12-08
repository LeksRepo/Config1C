﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Файловые функции".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Показывает напоминание о порядке работы с файлом в веб-клиенте,
// если включена настройка "Показывать подсказки при редактировании файлов".
//
Процедура ПоказатьНапоминаниеПриРедактировании() Экспорт
	
	ПерсональныеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами();
	
	Если ПерсональныеНастройки.ПоказыватьПодсказкиПриРедактированииФайлов = Истина Тогда
		
		РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
		Если НЕ РасширениеПодключено Тогда
			
			Форма = ФайловыеФункцииСлужебныйКлиентПовтИсп.ПолучитьФормуНапоминанияПриРедактировании();
			БольшеНеПоказывать = Форма.ОткрытьМодально();
			
			Если БольшеНеПоказывать = Истина Тогда
				ПоказыватьПодсказкиПриРедактированииФайлов = Ложь;
				
				ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьИОбновитьПовторноИспользуемыеЗначения(
					"НастройкиПрограммы",
					"ПоказыватьПодсказкиПриРедактированииФайлов",
					ПоказыватьПодсказкиПриРедактированииФайлов);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Показывает стандартное предупреждение.
// 
// Параметры:
//  ПредставлениеКоманды - Строка, если указано то будет уточнена команда,
//                         для которой необходимо расширение.
//
Процедура ПредупредитьОНеобходимостиРасширенияРаботыСФайлами(ПредставлениеКоманды = "") Экспорт
	
	Если ЗначениеЗаполнено(ПредставлениеКоманды) Тогда
		
		Предупреждение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для выполнения команды ""%1"" необходимо
			           |установить расширение работы с файлами.'"),
			ПредставлениеКоманды));
	Иначе
		Предупреждение(НСтр("ru = 'Для выполнения команды необходимо
		                          |установить расширение работы с файлами.'"));
	КонецЕсли;
	
КонецПроцедуры

// Показывает стандартное предупреждение.
// 
// Параметры:
//  ПредставлениеКоманды - Строка, если указано то будет уточнена команда,
//                         для которой необходимо расширение.
//
Процедура ПредупредитьОНеобходимостиРасширенияРаботыСКриптографией(ПредставлениеКоманды = "") Экспорт
	
	Если ЗначениеЗаполнено(ПредставлениеКоманды) Тогда
		
		Предупреждение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для выполнения команды ""%1"" необходимо
			           |установить расширение работы с криптографией.'"),
			ПредставлениеКоманды));
	Иначе
		Предупреждение(НСтр("ru = 'Для выполнения команды необходимо
		                          |установить расширение работы с криптографией.'"));
	КонецЕсли;
	
КонецПроцедуры

// Возвращает путь к рабочему каталогу пользователя.
Функция РабочийКаталогПользователя() Экспорт
	
	Возврат ФайловыеФункцииСлужебныйКлиентПовтИсп.РабочийКаталогПользователя();
	
КонецФункции

// Сохраняет путь к рабочему каталогу пользователя в настройках.
//
// Параметры:
//  ИмяКаталога - Строка - имя каталога.
//
Процедура УстановитьРабочийКаталогПользователя(ИмяКаталога) Экспорт
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьИОбновитьПовторноИспользуемыеЗначения(
		"ЛокальныйКэшФайлов", "ПутьКЛокальномуКэшуФайлов", ИмяКаталога);
	
КонецПроцедуры

// Возвращает каталог "Мои Документы" + имя текущего пользователя или
// ранее использованную папку для выгрузки.
//
Функция КаталогВыгрузки() Экспорт
	
	Путь = "";
	
#Если Не ВебКлиент Тогда
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	
	Путь = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("ИмяПапкиВыгрузки", "ИмяПапкиВыгрузки");
	
	Если Путь = Неопределено Тогда
		Если НЕ ПараметрыКлиента.ЭтоБазоваяВерсияКонфигурации Тогда
			
			Оболочка = Новый COMОбъект("MSScriptControl.ScriptControl");
			Оболочка.Language = "vbscript";
			Оболочка.AddCode("
				|Function SpecialFoldersName(Name)
				|set Shell=CreateObject(""WScript.Shell"")
				|SpecialFoldersName=Shell.SpecialFolders(Name)
				|End Function");
			
			Путь = НормализоватьКаталог(Оболочка.Run("SpecialFoldersName", "MyDocuments"));
			
			ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
				"ИмяПапкиВыгрузки", "ИмяПапкиВыгрузки", Путь);
		КонецЕсли;
	КонецЕсли;
	
#КонецЕсли
	
	Возврат Путь;
	
КонецФункции

// Показывает пользователю диалог выбора файлов и возвращает
// массив - выбранные файлы для импорта.
//
Функция ПолучитьСписокИмпортируемыхФайлов() Экспорт
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла     = "";
	ДиалогОткрытияФайла.Фильтр             = НСтр("ru = 'Все файлы(*.*)|*.*'");
	ДиалогОткрытияФайла.МножественныйВыбор = Истина;
	ДиалогОткрытияФайла.Заголовок          = НСтр("ru = 'Выберите файлы'");
	
	МассивИменФайлов = Новый Массив;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
		
		Для Каждого ИмяФайла Из МассивФайлов Цикл
			МассивИменФайлов.Добавить(ИмяФайла);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат МассивИменФайлов;
	
КонецФункции

// Добавляет концевой слэш к имени каталога, если это надо,
// удаляет все запрещенные символы из имени каталога и заменяет "/" на "\".
//
Функция НормализоватьКаталог(ИмяКаталога) Экспорт
	
	Результат = СокрЛП(ИмяКаталога);
	
	// Запоминание имени диска в начале пути "Диск:" без двоеточия.
	СтрДиск = "";
	Если Сред(Результат, 2, 1) = ":" Тогда
		СтрДиск = Сред(Результат, 1, 2);
		Результат = Сред(Результат, 3);
	Иначе
		
		// Проверка, это не UNC-путь (Т.е. вначале нет "\\").
		Если Сред(Результат, 2, 2) = "\\" Тогда
			СтрДиск = Сред(Результат, 1, 2);
			Результат = Сред(Результат, 3);
		КонецЕсли;
	КонецЕсли;
	
	// Преобразование слэшей к Windows-формату.
	Результат = СтрЗаменить(Результат, "/", "\");
	
	// Добавление конечного слэша.
	Результат = СокрЛП(Результат);
	Если Прав(Результат,1) <> "\" Тогда
		Результат = Результат + "\";
	КонецЕсли;
	
	// Замена всех двойных слэшей на одинарные и получение полного пути.
	Результат = СтрДиск + СтрЗаменить(Результат, "\\", "\");
	
	Возврат Результат;
	
КонецФункции

// Проверяет имя файла на наличие некорректных символов.
//
// Параметры:
//  ИмяФайла - Строка- проверяемое имя файла.
//
//  УдалятьНекорректныеСимволы - Булево - Истина указывает удалять некорректные
//             символы из переданной строки.
//
Процедура КорректноеИмяФайла(ИмяФайла, УдалятьНекорректныеСимволы = Ложь) Экспорт
	
	// Перечень запрещенных символов взят отсюда: http://support.microsoft.com/kb/100108/ru
	// при этом были объединены запрещенные символы для файловых систем FAT и NTFS.
	
	СтрИсключения = ОбщегоНазначенияКлиентСервер.ПолучитьНедопустимыеСимволыВИмениФайла();
	
	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'В имени файла не должно быть следующих символов: %1'"), СтрИсключения);
	
	Результат = Истина;
	
	МассивНайденныхНедопустимыхСимволов =
		ОбщегоНазначенияКлиентСервер.НайтиНедопустимыеСимволыВИмениФайла(ИмяФайла);
	
	Если МассивНайденныхНедопустимыхСимволов.Количество() <> 0 Тогда
		
		Результат = Ложь;
		
		Если УдалятьНекорректныеСимволы Тогда
			ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла, "");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Результат Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

// Рекурсивно обходит каталоги и подсчитывает количество файлов и их суммарный размер.
Процедура ОбходФайловРазмер(Путь, МассивФайлов, РазмерСуммарный, КоличествоСуммарное) Экспорт
	
	Для Каждого ВыбранныйФайл Из МассивФайлов Цикл
		
		Если ВыбранныйФайл.ЭтоКаталог() Тогда
			НовыйПуть = Строка(Путь);
			
			НовыйПуть = НовыйПуть + ОбщегоНазначенияКлиентСервер.РазделительПути();
			
			НовыйПуть = НовыйПуть + Строка(ВыбранныйФайл.Имя);
			МассивФайловВКаталоге = НайтиФайлы(НовыйПуть, "*.*");
			
			Если МассивФайловВКаталоге.Количество() <> 0 Тогда
				ОбходФайловРазмер(
					НовыйПуть, МассивФайловВКаталоге, РазмерСуммарный, КоличествоСуммарное);
			КонецЕсли;
		
			Продолжить;
		КонецЕсли;
		
		РазмерСуммарный = РазмерСуммарный + ВыбранныйФайл.Размер();
		КоличествоСуммарное = КоличествоСуммарное + 1;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает полный путь к файлу.
Функция ПолучитьПолныйПутьКФайлуВРабочемКаталоге(ДанныеФайла) Экспорт
	
	Возврат ДанныеФайла.ИмяФайлаСПутемВРабочемКаталоге;
	
КонецФункции

// Возвращает путь к каталогу вида
// "C:\Documents and Settings\ИМЯ ПОЛЬЗОВАТЕЛЯ\Application Data\1C\ФайлыА8\".
//
Функция ВыбратьПутьККаталогуДанныхПользователя() Экспорт
	
	ИмяКаталога = "";
	
#Если Не ВебКлиент Тогда
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	
	Если НЕ ПараметрыРаботыКлиента.ЭтоБазоваяВерсияКонфигурации Тогда
		
		Оболочка = Новый COMОбъект("WScript.Shell");
		Путь = Оболочка.ExpandEnvironmentStrings("%APPDATA%");
		Путь = Путь + "\1C\Файлы\";
		
		Путь = Путь
		+ ПараметрыРаботыКлиента.ИмяКонфигурации
		+ ОбщегоНазначенияКлиентСервер.РазделительПути();
		
		Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
			ИмяПользователя = ПользователиКлиентСервер.ТекущийВнешнийПользователь();
		Иначе
			ИмяПользователя = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли; 
		
		ИмяКаталога = Путь + ИмяПользователя;
		ИмяКаталога = СтрЗаменить(ИмяКаталога, "<", " ");
		ИмяКаталога = СтрЗаменить(ИмяКаталога, ">", " ");
		ИмяКаталога = СокрЛП(ИмяКаталога);
		
		ИмяКаталога = ИмяКаталога + ОбщегоНазначенияКлиентСервер.РазделительПути();
		
		//RonEXI edit: Разные папки для файлов в тестовой и рабочей базе, для веб клиента по старому.
		
		//ЭтоРабочаяБаза = Булево(Найти(СтрокаСоединенияИнформационнойБазы(),"ws="));
		//
		//Если ЭтоРабочаяБаза Тогда
		//	ИмяКаталога = ИмяКаталога + ОбщегоНазначенияКлиентСервер.РазделительПути();
		//Иначе
		//	
		//	ИмяКаталога = Путь + "ФайлыРазработка";
		//	ИмяКаталога = СтрЗаменить(ИмяКаталога, "<", " ");
		//	ИмяКаталога = СтрЗаменить(ИмяКаталога, ">", " ");
		//	ИмяКаталога = СокрЛП(ИмяКаталога);
		//
		//	ИмяКаталога = ИмяКаталога + ОбщегоНазначенияКлиентСервер.РазделительПути();
		//	
		//КонецЕсли;
		
		
	КонецЕсли;
	
#Иначе // ВебКлиент
	
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	
	Если РасширениеПодключено Тогда
		
		Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.Каталог = "";
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите путь к рабочему каталогу'");
		
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			
			ИмяКаталога = ДиалогОткрытияФайла.Каталог;
			
			ИмяКаталога = ИмяКаталога + ОбщегоНазначенияКлиентСервер.РазделительПути();
		КонецЕсли;
		
	КонецЕсли;
	
#КонецЕсли
	
	Возврат ИмяКаталога;
	
КонецФункции

// Открывает Проводник Windows и выделяет указанный файл.
Функция ОткрытьПроводникСФайлом(Знач ПолноеИмяФайла) Экспорт
	
#Если НЕ ВебКлиент Тогда
	ФайлНаДиске = Новый Файл(ПолноеИмяФайла);
	
	Если ФайлНаДиске.Существует() Тогда
		
		Если Лев(ПолноеИмяФайла, 0) <> """" Тогда
			ПолноеИмяФайла = """" + ПолноеИмяФайла + """";
		КонецЕсли;
		
		ЗапуститьПриложение("explorer.exe /select, " + ПолноеИмяФайла);
		
		Возврат Истина;
		
	КонецЕсли;
#КонецЕсли
	
	Возврат Ложь;
	
КонецФункции

// Проверяет свойства файла в рабочем каталоге и в хранилище файлов,
// если требуется уточняет у пользователя и возращает действие.
//
// Параметры:
//  ИмяФайлаСПутем - Строка - полное имя файла с путем в рабочем каталоге.
// 
//  ДанныеФайла    - Структура со свойствами:
//                   Размер                       - Число.
//                   ДатаМодификацииУниверсальная - Дата.
//                   ВРабочемКаталогеНаЧтение     - Булево.
//
// Возвращаемое значение:
//  Строка - возможные строки:
//  "ОткрытьСуществующий", "ВзятьИзХранилищаИОткрыть", "Отменить".
// 
Функция ДействиеПриОткрытииФайлаВРабочемКаталоге(ИмяФайлаСПутем, ДанныеФайла) Экспорт
	
	Если ДанныеФайла.Свойство("ПутьОбновленияИзФайлаНаДиске") Тогда
		Возврат "ВзятьИзХранилищаИОткрыть";
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ДействиеНадФайлом", "ОткрытиеВРабочемКаталоге");
	Параметры.Вставить("ИмяФайлаСПутемВРабочемКаталоге", ИмяФайлаСПутем);
	
	Файл = Новый Файл(Параметры.ИмяФайлаСПутемВРабочемКаталоге);
	
	Параметры.Вставить("ДатаИзмененияУниверсальнаяВХранилищеФайлов",
		ДанныеФайла.ДатаМодификацииУниверсальная);
	
	Параметры.Вставить("ДатаИзмененияУниверсальнаяВРабочемКаталоге",
		Файл.ПолучитьУниверсальноеВремяИзменения());
	
	Параметры.Вставить("ДатаИзмененияВРабочемКаталоге",
		МестноеВремя(Параметры.ДатаИзмененияУниверсальнаяВРабочемКаталоге));
	
	Параметры.Вставить("ДатаИзмененияВХранилищеФайлов",
		МестноеВремя(Параметры.ДатаИзмененияУниверсальнаяВХранилищеФайлов));
	
	Параметры.Вставить("РазмерВРабочемКаталоге", Файл.Размер());
	Параметры.Вставить("РазмерВХранилищеФайлов", ДанныеФайла.Размер);
	
	РазницаДат = Параметры.ДатаИзмененияУниверсальнаяВРабочемКаталоге
	           - Параметры.ДатаИзмененияУниверсальнаяВХранилищеФайлов;
	
	Если РазницаДат < 0 Тогда
		РазницаДат = -РазницаДат;
	КонецЕсли;
	
	Если РазницаДат <= 1 Тогда // 1 секунда - допустимая разница (на Win95 может быть такое)
		
		Если Параметры.РазмерВХранилищеФайлов <> 0
		   И Параметры.РазмерВХранилищеФайлов <> Параметры.РазмерВРабочемКаталоге Тогда
			// Дата одинаковая, но размер отличается - редкий, но возможный случай.
			
			Параметры.Вставить("Заголовок",
				НСтр("ru = 'Размер файла отличается'"));
			
			Параметры.Вставить("Сообщение",
				НСтр("ru = 'Размер файла в рабочем каталоге и в хранилище файлов отличается.
				           |
				           |Взять файл из хранилища файлов и заменить им существующий или
				           |открыть существующий без обновления?'"));
		КонецЕсли;
		
		// Все совпадает - и дата, и размер.
		Возврат "ОткрытьСуществующий"; 
		
	ИначеЕсли Параметры.ДатаИзмененияУниверсальнаяВРабочемКаталоге
	        < Параметры.ДатаИзмененияУниверсальнаяВХранилищеФайлов Тогда
		// В хранилище файлов более новый файл.
		
		Если ДанныеФайла.ВРабочемКаталогеНаЧтение = Ложь Тогда
			// Файл в рабочем каталоге для редактирования.
			
			Параметры.Вставить("Заголовок", НСтр("ru = 'В хранилище файлов новый файл'"));
			
			Параметры.Вставить("Сообщение",
				НСтр("ru = 'Файл в хранилище файлов, отмеченный как занятый для редактирования,
				           |имеет более позднюю дату изменения (новее), чем в рабочем каталоге.
				           |
				           |Взять файл из хранилища файлов и заменить им существующий или
				           |открыть существующий без обновления?'"));
		Иначе
			// Файл в рабочем каталоге для чтения.
			
			// Обновление из хранилища файлов без вопросов.
			Возврат "ВзятьИзХранилищаИОткрыть";
		КонецЕсли;
	
	ИначеЕсли Параметры.ДатаИзмененияУниверсальнаяВРабочемКаталоге
	        > Параметры.ДатаИзмененияУниверсальнаяВХранилищеФайлов Тогда
		// В рабочем каталоге более новый файл.
		
		Если ДанныеФайла.ВРабочемКаталогеНаЧтение = Ложь
		   И ДанныеФайла.Редактирует = ПользователиКлиентСервер.ТекущийПользователь() Тогда
			
			// Файл в рабочем каталоге для редактирования и занят текущим пользователем.
			Возврат "ОткрытьСуществующий";
		Иначе
			// Файл в рабочем каталоге для чтения.
		
			Параметры.Вставить("Заголовок", НСтр("ru = 'В рабочем каталоге новый файл'"));
			
			Параметры.Вставить("Сообщение",
				НСтр("ru = 'Файл в рабочем каталоге имеет более позднюю дату изменения (новее),
				           |чем в хранилище файлов. Возможно, он был изменен.
				           |
				           |Открыть существующий файл или заменить его на файл
				           |из хранилища файлов c потерей изменений и открыть?'"));
		КонецЕсли;
	КонецЕсли;
	
	//ВыборДействияПриОбнаруженииОтличийФайла
	Возврат ОткрытьФормуМодально("ОбщаяФорма.ВыборДействияПриОбнаруженииОтличийФайла", Параметры);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Если НЕ ВебКлиент Тогда
// Извлекает текст из файла на диске на клиенте и помещает результат на сервер.
Процедура ИзвлечьТекстВерсии(ФайлИлиВерсияФайла,
                             АдресФайла,
                             Расширение,
                             УникальныйИдентификатор,
                             Кодировка = Неопределено) Экспорт
	
	ИмяФайлаСПутем = ПолучитьИмяВременногоФайла(Расширение);
	
	Если Не ПолучитьФайл(АдресФайла, ИмяФайлаСПутем, Ложь) Тогда
		Возврат;
	КонецЕсли;
	
	// Для варианта с хранением файлов на диске (на сервере)
	// удаление Файла из временного хранилища после получения.
	Если ЭтоАдресВременногоХранилища(АдресФайла) Тогда
		УдалитьИзВременногоХранилища(АдресФайла);
	КонецЕсли;
	
	РезультатИзвлечения = "НеИзвлечен";
	АдресВременногоХранилищаТекста = "";
	
	Текст = "";
	Если ИмяФайлаСПутем <> "" Тогда
		
		// Извлечение текста из файла.
		Отказ = Ложь;
		Текст = ФайловыеФункцииСлужебныйКлиентСервер.ИзвлечьТекст(ИмяФайлаСПутем, Отказ, Кодировка);
		
		Если Отказ = Ложь Тогда
			РезультатИзвлечения = "Извлечен";
			
			Если Не ПустаяСтрока(Текст) Тогда
				ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
				ТекстовыйФайл = Новый ЗаписьТекста(ИмяВременногоФайла, КодировкаТекста.UTF8);
				ТекстовыйФайл.Записать(Текст);
				ТекстовыйФайл.Закрыть();
				
				ПоместитьФайл(АдресВременногоХранилищаТекста,
				              ИмяВременногоФайла,
				              ,
				              Ложь,
				              УникальныйИдентификатор);
				
				УдалитьФайлы(ИмяВременногоФайла);
			КонецЕсли;
		Иначе
			// Когда Текст извлечь "некому" - это нормальный случай,
			// сообщение об ошибке не формируется.
			РезультатИзвлечения = "ИзвлечьНеУдалось";
		КонецЕсли;
		
	КонецЕсли;
	
	УдалитьФайлы(ИмяФайлаСПутем);
	
	ФайловыеФункцииСлужебныйВызовСервера.ЗаписатьРезультатИзвлеченияТекста(
		ФайлИлиВерсияФайла, РезультатИзвлечения, АдресВременногоХранилищаТекста);
	
КонецПроцедуры
#КонецЕсли
