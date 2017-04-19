﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Адресный классификатор".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Вызывает форму загрузки классификатора. Может использоваться как интерфейс.
//
Процедура ЗагрузитьАдресныйКлассификатор() Экспорт
	
#Если ВебКлиент Тогда
	Предупреждение(НСтр("ru = 'В веб-клиенте загрузка адресного классификатора не поддерживается.'"));
#Иначе
	ОткрытьФорму("РегистрСведений.АдресныйКлассификатор.Форма.ЗагрузкаАдресногоКлассификатора");
#КонецЕсли
	
КонецПроцедуры

// Проверяет наличие обновлений адресного классификатора на веб сервере
// для тех объектов, которые ранее уже загружались.
//
Процедура ОпределитьНеобходимостьОбновленияАдресныхОбъектов() Экспорт
	
#Если ВебКлиент Тогда
	Результат = АдресныйКлассификаторВызовСервера.ПроверитьОбновлениеАдресныхОбъектовСервер();
#Иначе
	Результат = АдресныйКлассификаторКлиентСервер.ПроверитьОбновлениеАдресныхОбъектов();
#КонецЕсли
	
	Если Не Результат.Статус Тогда
		Предупреждение(Результат.СообщениеОбОшибке);
		Возврат;
	КонецЕсли;
	
	Если Результат.Значение.Количество() <> 0 Тогда
		КоличествоОбновлений = 0;
		СписокСтрока = "";
		АдресныеОбъекты = Новый Массив;
		
		Для Каждого АдресныйОбъект Из Результат.Значение Цикл
			Если АдресныйОбъект.КодАдресногоОбъекта<>"AL" И АдресныйОбъект.ОбновлениеДоступно Тогда
				КоличествоОбновлений = КоличествоОбновлений + 1;
				АдресныеОбъекты.Добавить(Лев(АдресныйОбъект.КодАдресногоОбъекта, 2));
				СписокСтрока = СписокСтрока + Лев(АдресныйОбъект.КодАдресногоОбъекта, 2)
				                            + " - " + АдресныйОбъект.Наименование + " "   + АдресныйОбъект.Сокращение + Символы.ПС;
			КонецЕсли;
		КонецЦикла;
		
		Если КоличествоОбновлений > 0 Тогда
			// Полный список
			Заголовок = НСтр("ru = 'Обновление адресного классификатора'");
			Текст = НСтр("ru = 'Обнаружены обновления регионов:'") + Символы.ПС + СписокСтрока;
#Если ВебКлиент Тогда
			СтандартныеПодсистемыКлиент.ВопросПользователю(
				Текст, РежимДиалогаВопрос.ОК, 0, КодВозвратаДиалога.ОК, Заголовок,
				Неопределено, Ложь, Ложь);
#Иначе
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить("Да",  НСтр("ru='Обновить'"));
			Кнопки.Добавить("Нет", НСтр("ru='Отмена'"));
			
			Результат = СтандартныеПодсистемыКлиент.ВопросПользователю( 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Приступить к обновлению адресного классификатора на версию от %1?'"),
					Формат(Результат.ВерсияПоследнегоОбновленияКЛАДР, "ДЛФ=D")
				) + Символы.ПС + Символы.ПС + Текст,
				Кнопки, 0, "Да", Заголовок, Неопределено, Ложь, Ложь);
			
			Если Результат="Да" Тогда
				ОткрытьФорму("РегистрСведений.АдресныйКлассификатор.Форма.ЗагрузкаАдресногоКлассификатора",
				Новый Структура("АдресныеОбъекты", АдресныеОбъекты) );
			КонецЕсли;
#КонецЕсли
		Иначе
			Предупреждение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обновление адресного классификатора не требуется.
				           |В программу уже загружены актуальные адресные сведения от %1.'"),
				Формат(Результат.ВерсияПоследнегоОбновленияКЛАДР, "ДЛФ=D")));
		КонецЕсли;
	Иначе
		Предупреждение(НСтр("ru = 'Адресный классификатор не заполнен.'"));
	КонецЕсли;
	
КонецПроцедуры

// Вызывает форму очистки сведений адресного классификатора по адресным объектам
//
// Параметры:
//   Владелец (УправляемаяФорма) Необязательный. Форма, из которой осуществляется очистка адресного классификатора.
//
Процедура ОчиститьКлассификатор(Владелец = Неопределено) Экспорт
	
	ОткрытьФорму("РегистрСведений.АдресныйКлассификатор.Форма.ОчисткаАдресногоКлассификатора", , Владелец);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Содержит полный список файлов данных КЛАДР
//
Функция СписокФайловДанных() Экспорт
	
	Список = Новый Массив;
	
	Список.Добавить("SOCRBASE.DBF");
	Список.Добавить("ALTNAMES.DBF");
	Список.Добавить("DOMA.DBF");
	Список.Добавить("KLADR.DBF");
	Список.Добавить("STREET.DBF");
	
	Возврат Список;
	
КонецФункции

// Заменяет в имени файла расширение с ".DBF" на ".EXE"
//
// Параметры:
//    Строка - Строка - строка с расширением "DBF".
//
// Возвращаемое значение:
//    Строка - строка с расширением "EXE".
//
Функция ЗаменитьРасширение_DBF_На_EXE(Строка)
	
	Возврат СтрЗаменить(Строка, ".DBF", ".EXE");
	
КонецФункции

// Заменяет в имени файла расширение на c ".DBF" на ".ZIP"
//
// Параметры:
//    Строка - Строка - строка с расширением "DBF".
//
// Возвращаемое значение:
//    Строка - строка с расширением "ZIP".
//
Функция ЗаменитьРасширение_DBF_На_ZIP(Строка) Экспорт
	
	Возврат СтрЗаменить(Строка, ".DBF", ".ZIP");
	
КонецФункции

// Заменяет в имени файла расширение на c ".EXE" на ".DBF"
//
// Параметры:
//    Строка - Строка - строка с расширением "EXE".
//
// Возвращаемое значение:
//    Строка - строка с расширением "DBF".
//
Функция ЗаменитьРасширение_EXE_На_DBF(Строка) Экспорт
	
	Возврат СтрЗаменить(Строка, ".EXE", ".DBF");
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Блок функций проверки наличия файлов на диске (ИТС)

// Проверяет существование файлов адресного классификатора на диске ИТС.
//
// Параметры:
//     ПутьКДискуИТС - строка - путь к корню диска ИТС
// 
// Возвращаемое значение:
//     Булево - истина - файлы присутствуют
//              ложь   - файлы отсутствуют
//
Функция ПроверитьНаличиеФайловНаДискеИТС(Знач ПутьКДискуИТС) Экспорт
	
	// если был выбран диск - то убираем последний символ "\"
	Если Прав(ПутьКДискуИТС, 1) = "\" Тогда
		ПутьКДискуИТС = Лев(ПутьКДискуИТС, СтрДлина(ПутьКДискуИТС) - 1);
	КонецЕсли;
	
	ПутьКДискуИТС = ПутьКДискуИТС + ПутьККаталогуСДаннымиКЛАДРНаДискеИТС(ПутьКДискуИТС);
	
	СписокФайловДанных = СписокФайловДанныхНаДискеИТС();
	
	Для Каждого ПутьКФайлу Из СписокФайловДанных Цикл
		ПолныйПутьКФайлу = ПутьКДискуИТС + ПутьКФайлу;
		Если ПутьКФайлу = "ALTNAMES.EXE" Тогда
			Продолжить;
		КонецЕсли;
		ФайлНаДиске = Новый Файл(ПолныйПутьКФайлу);
		Если Не ФайлНаДиске.Существует() Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Функция возвращает относительный путь на диске ИТС по которому находятся файлы КЛАДР.
// 
// Параметры:
//    ПутьКДискуИТС - путь к корневому каталогу диска ИТС.
// 
// Возвращаемое значение:
//    Строка - относительный путь на диске ИТС к файлам КЛАДР (самораспаковывающийся архив).
//             если файлы не найдены, возвращается пустая строка.
//
Функция ПутьККаталогуСДаннымиКЛАДРНаДискеИТС(Знач ПутьКДискуИТС) Экспорт
	
	ВозможныеПути = Новый Массив;
	ВозможныеПути.Добавить("\1CIts\EXE\KLADR\");
	ВозможныеПути.Добавить("\1CitsFr\EXE\KLADR\");
	ВозможныеПути.Добавить("\1CItsB\EXE\KLADR");
	
	Если Прав(ПутьКДискуИТС, 1) = "\" Тогда
		ПутьКДискуИТС = Лев(ПутьКДискуИТС, СтрДлина(ПутьКДискуИТС) - 1);
	КонецЕсли;
	
	Для Каждого Путь Из ВозможныеПути Цикл
		ПолныйПутьКФайлу = ПутьКДискуИТС + Путь +"STREET.EXE" ;
		ФайлНаДиске = Новый Файл(ПолныйПутьКФайлу);
		Если ФайлНаДиске.Существует() Тогда
			Возврат Путь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

// Содержит полный список файлов данных КЛАДР (в формате самораспаковывающегося архива, EXE)
//
// Возвращаемое значение:
//    Массив - список файлов данных КЛАДР.
//
Функция СписокФайловДанныхНаДискеИТС() Экспорт
	
	Список = СписокФайловДанных();
	
	Для Каждого ИмяФайла Из Список Цикл
		НовоеИмя = ЗаменитьРасширение_DBF_На_EXE(ИмяФайла);
		Список.Установить(Список.Найти(ИмяФайла), НовоеИмя);
	КонецЦикла;
	
	Возврат Список;
	
КонецФункции

// Проверяет существование файлов данных в переданном каталоге
//
// Параметры:
//    ПутьККаталогу - строка - путь к каталогу, который необходимо проверить на наличие файлов
// 
// Возвращаемое значение:
//    Истина        - файлы существуют на диске
//    Ложь          - хотя бы одного файла из необходимого набора файлов
//                    не существует на диске
//
Функция ПроверитьНаличиеФайловДанныхВКаталоге(Знач ПутьККаталогу) Экспорт
	
	Если ПустаяСтрока(ПутьККаталогу) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Прав(ПутьККаталогу, 1) <> "\" Тогда
		ПутьККаталогу = ПутьККаталогу + "\";
	КонецЕсли;
	
	Для Каждого ПутьКФайлу Из СписокФайловДанных() Цикл
		ФайлНаДиске = Новый Файл(ПутьККаталогу+ПутьКФайлу);
		Если Не ФайлНаДиске.Существует() Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

#Если Не ВебКлиент Тогда
	
// Распаковывает файлы КЛАДР с диска ИТС и выполняет их архивацию в ZIP-архив.
// 
// Параметры
//    ДискИТС - строка - путь к корневой папке диска ИТС
// 
// Возвращаемое значение
//    Строка - путь к временному каталогу с файлами архива кладр
//
Функция ПреобразоватьФайлыКЛАДРEXEВZIP(Знач ДискИТС) Экспорт
	
	ВременныйКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла());
	
	СоздатьКаталог(ВременныйКаталог);
	
	Если Прав(ДискИТС, 1) = "\" Тогда
		ДискИТС = Лев(ДискИТС, СтрДлина(ДискИТС) - 1);
	КонецЕсли;
	
	ПутьКФайламНаДискеИТС = ДискИТС + ПутьККаталогуСДаннымиКЛАДРНаДискеИТС(ДискИТС);
	
	СписокФайловДанных = СписокФайловДанныхНаДискеИТС();
	
	Для Каждого ИмяФайла Из СписокФайловДанных Цикл
		Файл = Новый Файл(ПутьКФайламНаДискеИТС + ИмяФайла);
		Если Файл.Существует() Тогда
			КопироватьФайл(ПутьКФайламНаДискеИТС + ИмяФайла, ВременныйКаталог + ИмяФайла);
			Файл = Новый Файл(ВременныйКаталог + ИмяФайла);
			Файл.УстановитьТолькоЧтение(Ложь);
			КомандаСистемы(ИмяФайла + " -s", ВременныйКаталог);
		КонецЕсли;
		
		ФайлDBF = Новый Файл(ВременныйКаталог+ЗаменитьРасширение_EXE_На_DBF(ИмяФайла));
		
		Если Не ФайлDBF.Существует() Тогда
			УдалитьФайлы(ВременныйКаталог);
			Возврат Неопределено;
		КонецЕсли;
		
		СжатьФайл(ВременныйКаталог, ЗаменитьРасширение_EXE_На_DBF(ИмяФайла), ВременныйКаталог);
	КонецЦикла;
	
	Возврат ВременныйКаталог;
	
КонецФункции

// Сжимает файл из поставки КЛАДР в ZIP архив.
//
// Параметры
//    ПутьКDBFФайлам         - строка - путь к каталогу с файлами DBF
//    ИмяФайла               - строка - имя файла, который требуется сжать
//    КаталогВременныхФайлов - строка - каталог, в который требуется сохранить файл архива
//
Процедура СжатьФайл(Знач ПутьКDBFФайлам, ИмяФайла, КаталогВременныхФайлов) Экспорт
	
	Если Не ЗначениеЗаполнено(КаталогВременныхФайлов) Тогда
		КаталогВременныхФайлов = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла());
		СоздатьКаталог(КаталогВременныхФайлов);
	КонецЕсли;
	
	ФайлDBF = ПутьКDBFФайлам + ИмяФайла;
	Файл = Новый Файл(ФайлDBF);
	Если Файл.Существует() Тогда
		ПутьКФайлуАрхива = КаталогВременныхФайлов + ЗаменитьРасширение_DBF_На_ZIP(ИмяФайла);
		ZIPФайл = Новый ЗаписьZipФайла(ПутьКФайлуАрхива, , , МетодСжатияZIP.Сжатие, УровеньСжатияZIP.Максимальный);
		ZIPФайл.Добавить(ФайлDBF);
		ZIPФайл.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Загружает файлы КЛАДР региона с Веб сервера
//
// Параметры
//    АдресныйОбъект - Массив - каждая строка идентификатор адресного объекта в формате NN
//    ДанныеАутентификации - Структура - параметры аутентификации на пользовательском сайте 1С
//                           ключ - КодПользователя - значение - пользователь (логин)
//                           ключ - Пароль - значение - пароль пользователя
//    ВременныйКаталог - Строка - путь к временному каталогу.
//
// Возвращаемое значение: Структура, ключ Статус - булево - истина или ложь
//                                   ключ значение - строка - если Статус ложь, содержит
//                                   пояснение об ошибке.
//
Функция ЗагрузитьКЛАДРСВебСервера(Знач АдресныйОбъект, знач ДанныеАутентификации, ВременныйКаталог) Экспорт
	
	URLСтрока = "http://downloads.v8.1c.ru/tmplts/ITS/KLADR/";
	
	Если Не ЗначениеЗаполнено(ВременныйКаталог) Тогда
		ВременныйКаталог = ПолучитьИмяВременногоФайла();
		СоздатьКаталог(ВременныйКаталог);
	КонецЕсли;
	
	ПараметрыЗагрузкиФайла = Новый Структура;
	ПараметрыЗагрузкиФайла.Вставить("Пользователь", ДанныеАутентификации.КодПользователя);
	ПараметрыЗагрузкиФайла.Вставить("Пароль",  ДанныеАутентификации.Пароль);
	
	Если АдресныйОбъект = "AL" Тогда
		//
		Файл = Новый Файл(ВременныйКаталог + "\ALTNAMES.ZIP");
		Если Не Файл.Существует() Тогда
			ПараметрыЗагрузкиФайла.Вставить("ПутьДляСохранения", ВременныйКаталог + "\ALTNAMES.ZIP");
			Результат = ПолучениеФайловИзИнтернетаКлиент.СкачатьФайлНаКлиенте(URLСтрока + "ALTNAMES.ZIP",
			ПараметрыЗагрузкиФайла);
			Если Не Результат.Статус Тогда
				Возврат Результат;
			КонецЕсли;
		КонецЕсли;
		//
	ИначеЕсли АдресныйОбъект = "SO" Тогда
		//
		Файл = Новый Файл(ВременныйКаталог + "\SOCRBASE.ZIP");
		Если Не Файл.Существует() Тогда
			ПараметрыЗагрузкиФайла.Вставить("ПутьДляСохранения", ВременныйКаталог + "\SOCRBASE.ZIP");
			Результат = ПолучениеФайловИзИнтернетаКлиент.СкачатьФайлНаКлиенте(URLСтрока + "SOCRBASE.ZIP",
			ПараметрыЗагрузкиФайла);
			Если Не Результат.Статус Тогда
				Возврат Результат;
			КонецЕсли;
		КонецЕсли;
	Иначе
		ИмяZIP = "BASE" + АдресныйОбъект + ".ZIP";
		ПараметрыЗагрузкиФайла.Вставить("ПутьДляСохранения", ВременныйКаталог + "\" + ИмяZIP);
		Результат = ПолучениеФайловИзИнтернетаКлиент.СкачатьФайлНаКлиенте(URLСтрока + ИмяZIP,
		ПараметрыЗагрузкиФайла);
		Если Не Результат.Статус Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Новый Структура("Статус", Истина);
	
КонецФункции
	
#КонецЕсли
