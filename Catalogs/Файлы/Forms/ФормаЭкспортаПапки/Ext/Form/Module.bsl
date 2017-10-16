﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.ПапкаЭкспорта <> Неопределено Тогда
		ЧтоСохраняем = Параметры.ПапкаЭкспорта;
	КонецЕсли;
	
	РасширениеДляЗашифрованныхФайлов = ЭлектроннаяПодписьКлиентСервер.ПерсональныеНастройки().РасширениеДляЗашифрованныхФайлов;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'В Веб-клиенте экспорт каталогов не поддерживается.'"));
		Отказ = Истина;
		Возврат;
	#КонецЕсли
	
	// Установка в качестве папки выгрузки "Мои Документы"
	// папку, используемую для выгрузки последний раз.
	ПапкаДляЭкспорта = ФайловыеФункцииСлужебныйКлиент.КаталогВыгрузки();
	
	ПапкаДляЭкспортаПолная = ПапкаДляЭкспорта
	                       + Строка(ЧтоСохраняем)
	                       + ОбщегоНазначенияКлиентСервер.РазделительПути();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПапкаДляЭкспортаОткрытие(Элемент, СтандартнаяОбработка)
	#Если ВебКлиент Тогда
		Возврат;
	#КонецЕсли
	
	// Здесь откроем папку для просмотра - вдруг что-то сделать понадобиться
	СтандартнаяОбработка = Ложь;
	Если Не ПустаяСтрока(ПапкаДляЭкспорта) Тогда
		Файл = Новый Файл(ПапкаДляЭкспорта);
		Если Не Файл.Существует() Тогда
			ТекстПредупреждения = НСтр("ru = 'Невозможно открыть папку выгрузки.
			                                 |Возможно, папка еще не создана.'");
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		ЗапуститьПриложение(ПапкаДляЭкспорта);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаДляЭкспортаПриИзменении(Элемент)
	
	ПапкаДляЭкспорта = ФайловыеФункцииСлужебныйКлиент.НормализоватьКаталог(
		ПапкаДляЭкспорта);
	
	ПапкаДляЭкспортаПолная = ФайловыеФункцииСлужебныйКлиент.НормализоватьКаталог(
		ПапкаДляЭкспортаПолная);
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаДляЭкспортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	#Если ВебКлиент Тогда
		Возврат;
	#КонецЕсли
	
	// Открытие окна выбора папки сохранения.
	СтандартнаяОбработка = Ложь;
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ВыборФайла.МножественныйВыбор = Ложь;
	ВыборФайла.Каталог = ПапкаДляЭкспорта;
	Если ВыборФайла.Выбрать() Тогда
		
		ПапкаДляЭкспорта = ФайловыеФункцииСлужебныйКлиент.НормализоватьКаталог(
			ВыборФайла.Каталог);
		
		ПапкаДляЭкспортаПолная = ПапкаДляЭкспорта
		                       + Строка(ЧтоСохраняем)
		                       + ОбщегоНазначенияКлиентСервер.РазделительПути();
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьПапку()
	#Если ВебКлиент Тогда
		Возврат;
	#КонецЕсли
	
	// Проверим - каталог выгрузки существует? если нет - создадим
	КаталогВыгрузки = Новый Файл(ПапкаДляЭкспортаПолная);
	
	Если Не КаталогВыгрузки.Существует() Тогда
		
		ТекстОшибки = "";
		Попытка
			СоздатьКаталог(ПапкаДляЭкспортаПолная);
		Исключение
			ТекстОшибки = НСтр("ru = 'Не удалось создать папку выгрузки:'");
			ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		Если ТекстОшибки <> "" Тогда
			ПоказатьПредупреждение(, ТекстОшибки);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполняется экспорт папки ""%1""...
		           |Пожалуйста, подождите.'"),
		Строка(ЧтоСохраняем) ));
	
	// Получим список выгружаемых файлов
	СформироватьДеревоФайлов(ЧтоСохраняем);
	
	// А теперь начнем выгрузку
	Обработчик = Новый ОписаниеОповещения("ВыгрузитьЗавершение", ЭтотОбъект);
	ОбойтиДеревоФайлов(Обработчик, ДеревоФайлов, ПапкаДляЭкспортаПолная, ЧтоСохраняем, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	Если Результат.Успех = Истина Тогда
		СохраняемыйПуть = ПапкаДляЭкспорта;
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("ИмяПапкиВыгрузки", "ИмяПапкиВыгрузки",  СохраняемыйПуть);
		
		Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		             НСтр("ru = 'Успешно завершен экспорт папки ""%1""
		                        |в каталог на диске ""%2"".'"),
		             Строка(ЧтоСохраняем), Строка(ПапкаДляЭкспорта) ) );
		
		Закрыть();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьДеревоФайлов(ПапкаРодитель)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	Файлы.ВладелецФайла КАК Папка,
	               |	Файлы.ВладелецФайла.Наименование КАК НаименованиеПапки,
	               |	Файлы.ТекущаяВерсия,
	               |	Файлы.ПолноеНаименование КАК ПолноеНаименование,
	               |	Файлы.ТекущаяВерсия.Расширение КАК Расширение,
	               |	Файлы.ТекущаяВерсия.Размер КАК Размер,
	               |	Файлы.ТекущаяВерсия.ДатаМодификацииУниверсальная КАК ДатаМодификацииУниверсальная,
	               |	Файлы.Ссылка,
	               |	Файлы.ПометкаУдаления,
	               |	Файлы.Зашифрован
	               |ИЗ
	               |	Справочник.Файлы КАК Файлы
	               |ГДЕ
	               |	Файлы.ВладелецФайла В ИЕРАРХИИ(&Ссылка)
	               |	И Файлы.ТекущаяВерсия <> ЗНАЧЕНИЕ(Справочник.ВерсииФайлов.ПустаяСсылка)
	               |	И Файлы.ПометкаУдаления = ЛОЖЬ
	               |ИТОГИ ПО
	               |	Папка ИЕРАРХИЯ";
	Запрос.Параметры.Вставить("Ссылка", ПапкаРодитель);
	Результат = Запрос.Выполнить();
	ТаблицаВыгрузки = Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗначениеВРеквизитФормы(ТаблицаВыгрузки, "ДеревоФайлов");
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов(ОбработчикРезультата, ТаблицаФайлов, БазовыйКаталогСохранения, РодительскаяПапка, ОбщиеПараметры)
	// Рекурсивная функция, которая собственно и выгружает файлы на локальный диск
	//
	// Параметры:
	//   ОбработчикРезультата - ОписаниеОповещения, Структура, Неопределено - Описание процедуры, принимающей результат работы метода.
	//   ТаблицаФайлов - ДанныеФормыДерево, ДанныеФормыЭлементДерева - дерево значений с выгружаемыми файлами.
	//   БазовыйКаталогСохранения - Строка - строка с именем папки, в которую сохраняются файлы.
	//                 В ней воссоздается структура папок (как в дереве файлов)
	//                 при необходимости.
	//   РодительскаяПапка - СправочникСсылка.ПапкиФайлов - что сохраняем.
	//   ОбщиеПараметры - Структура -
	//       * ФормаВопроса - УправляемаяФорма- Объект, который содержит ссылку на
	//                 созданную в памяти форму вопроса о перезаписи файла с флажком
	//                 "Для всех". Создается для того, чтобы не тратить время на
	//                 регулярное создание формы внутри рекурсивного цикла.
	//       * ДляВсехФайлов - Булево -
	//                 Истина: пользователь выбрал действие при перезаписи файла и
	//                 установил флажок "Для всех". Больше вопросов не задаем.
	//                 Ложь: в каждом случае существования файла на диске, с тем же
	//                 именем, что и в информационной базе будем задавать вопрос.
	//       * БазовоеДействие - КодВозвратаДиалога -
	//                 при выполнении одного действия для всех конфликтов при
	//                 записи файла (параметр ДляВсехФайлов = Истина) выполняется
	//                 действие, заданное этим параметром).
	//                 .Да - перезаписать
	//                 .Пропустить - пропустить файл
	//                 .Прервать - прервать выгрузку
	//
	// Возвращаемое значение: 
	//   Структура - Результат.
	//       * Успех - Булево - Истина - можно продолжать выгрузку / выгрузка завершена успешно.
	//                         Ложь   - действие завершено с ошибками / выгрузка завершена с ошибками.
	//
	
	Если ОбщиеПараметры = Неопределено Тогда
		ОбщиеПараметры = Новый Структура;
		ОбщиеПараметры.Вставить("ФормаВопроса", РаботаСФайламиСлужебныйКлиентПовтИсп.ФормаЭкспортаПапкиФайлСуществует());
		ОбщиеПараметры.Вставить("БазовоеДействие", КодВозвратаДиалога.Пропустить);
		ОбщиеПараметры.Вставить("ДляВсехФайлов", Ложь);
		ОбщиеПараметры.Вставить("ЕщеНеВстретилиВыгружаемуюПапку", Истина);
	КонецЕсли;
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ОбработчикРезультата", ОбработчикРезультата);
	ПараметрыВыполнения.Вставить("ТаблицаФайлов", ТаблицаФайлов);
	ПараметрыВыполнения.Вставить("БазовыйКаталогСохранения", БазовыйКаталогСохранения);
	ПараметрыВыполнения.Вставить("РодительскаяПапка", РодительскаяПапка);
	ПараметрыВыполнения.Вставить("ОбщиеПараметры", ОбщиеПараметры);
	
	// Параметры результата.
	ПараметрыВыполнения.Вставить("Успех", Ложь);
	
	// Параметры для цикла.
	ПараметрыВыполнения.Вставить("Элементы", ПараметрыВыполнения.ТаблицаФайлов.ПолучитьЭлементы());
	ПараметрыВыполнения.Вставить("ВГраница", ПараметрыВыполнения.Элементы.Количество()-1);
	ПараметрыВыполнения.Вставить("Индекс",   -1);
	ПараметрыВыполнения.Вставить("ТребуетсяЗапускЦикла", Истина);
	РаботаСФайламиСлужебныйКлиент.ЗарегистрироватьОписаниеОбработчика(
		ПараметрыВыполнения,
		ЭтотОбъект,
		"ОбойтиДеревоФайлов2");
	
	// Переменные.
	ПараметрыВыполнения.Вставить("ЗаписьФайла", Неопределено);
	
	// Запуск цикла.
	ОбойтиДеревоФайловЗапускЦикла(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайловЗапускЦикла(ПараметрыВыполнения)
	Если ПараметрыВыполнения.ТребуетсяЗапускЦикла Тогда
		Если ПараметрыВыполнения.АсинхронныйДиалог.Открыт Тогда
			Возврат; // Был открыт еще один диалог - перезапуск цикла не нужен.
		КонецЕсли;
		ПараметрыВыполнения.Индекс = ПараметрыВыполнения.Индекс + 1;
		ПараметрыВыполнения.ТребуетсяЗапускЦикла = Ложь;
	Иначе
		Возврат; // Цикл уже запущен.
	КонецЕсли;
	
	Для Индекс = ПараметрыВыполнения.Индекс По ПараметрыВыполнения.ВГраница Цикл
		ПараметрыВыполнения.ЗаписьФайла = ПараметрыВыполнения.Элементы[Индекс];
		ПараметрыВыполнения.Индекс = Индекс;
		ОбойтиДеревоФайлов1(ПараметрыВыполнения);
		Если ПараметрыВыполнения.АсинхронныйДиалог.Открыт Тогда
			Возврат; // Пауза цикла. Стек очищается.
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыВыполнения.Успех = Истина;
	РаботаСФайламиСлужебныйКлиент.ВернутьРезультат(ПараметрыВыполнения.ОбработчикРезультата, ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов1(ПараметрыВыполнения)
	Если ПараметрыВыполнения.ОбщиеПараметры.ЕщеНеВстретилиВыгружаемуюПапку = Истина Тогда
		Если ПараметрыВыполнения.ЗаписьФайла.Папка = ЧтоСохраняем Тогда
			ПараметрыВыполнения.ОбщиеПараметры.ЕщеНеВстретилиВыгружаемуюПапку = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыВыполнения.ОбщиеПараметры.ЕщеНеВстретилиВыгружаемуюПапку = Истина Тогда
		
		РаботаСФайламиСлужебныйКлиент.ЗарегистрироватьОписаниеОбработчика(
			ПараметрыВыполнения,
			ЭтотОбъект,
			"ОбойтиДеревоФайлов2");
		
		ОбойтиДеревоФайлов(
			ПараметрыВыполнения,
			ПараметрыВыполнения.ЗаписьФайла,
			ПараметрыВыполнения.БазовыйКаталогСохранения,
			ПараметрыВыполнения.ЗаписьФайла.Папка,
			ПараметрыВыполнения.ОбщиеПараметры);
		
		Если ПараметрыВыполнения.АсинхронныйДиалог.Открыт Тогда
			Возврат; // Пауза цикла. Стек очищается.
		КонецЕсли;
		
		ОбойтиДеревоФайлов2(ПараметрыВыполнения.АсинхронныйДиалог.РезультатКогдаНеОткрыт, ПараметрыВыполнения);
		Возврат;
	КонецЕсли;
	
	ОбойтиДеревоФайлов3(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов2(Результат, ПараметрыВыполнения) Экспорт
	Если ПараметрыВыполнения.АсинхронныйДиалог.Открыт Тогда
		ПараметрыВыполнения.ТребуетсяЗапускЦикла = Истина;
		ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Ложь;
	КонецЕсли;
	
	Если Результат.Успех <> Истина Тогда
		ПараметрыВыполнения.Успех = Ложь;
		ПараметрыВыполнения.ТребуетсяЗапускЦикла = Ложь; // Цикл перезапускать не требуется.
		РаботаСФайламиСлужебныйКлиент.ВернутьРезультат(ПараметрыВыполнения.ОбработчикРезультата, ПараметрыВыполнения);
		Возврат;
	КонецЕсли;
	
	ОбойтиДеревоФайловЗапускЦикла(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов3(ПараметрыВыполнения)
	// Сформируем путь к каталогу и пойдем дальше. Создавать каталоги будем
	ПараметрыВыполнения.Вставить("БазовыйКаталогСохраненияФайла", ПараметрыВыполнения.БазовыйКаталогСохранения);
	Если  ПараметрыВыполнения.ЗаписьФайла.Папка <> ЧтоСохраняем
		И ПараметрыВыполнения.ЗаписьФайла.ТекущаяВерсия.Пустая()
		И ПараметрыВыполнения.ЗаписьФайла.Папка <> ПараметрыВыполнения.РодительскаяПапка Тогда
		ПараметрыВыполнения.БазовыйКаталогСохраненияФайла = (
			ПараметрыВыполнения.БазовыйКаталогСохраненияФайла
			+ ПараметрыВыполнения.ЗаписьФайла.НаименованиеПапки
			+ ОбщегоНазначенияКлиентСервер.РазделительПути());
	КонецЕсли;
	
	// Проверим наличие базового каталога: если нет - создадим
	Папка = Новый Файл(ПараметрыВыполнения.БазовыйКаталогСохраненияФайла);
	Если Не Папка.Существует() Тогда
		ОбойтиДеревоФайлов4(ПараметрыВыполнения);
		Возврат;
	КонецЕсли;
	
	ОбойтиДеревоФайлов6(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов4(ПараметрыВыполнения)
	ТекстОшибки = "";
	Попытка
		СоздатьКаталог(ПараметрыВыполнения.БазовыйКаталогСохраненияФайла);
	Исключение
		ТекстОшибки = НСтр("ru = 'Ошибка создания папки ""%1"":'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1", ПараметрыВыполнения.БазовыйКаталогСохраненияФайла);
		ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Если ТекстОшибки <> "" Тогда
		РаботаСФайламиСлужебныйКлиент.ПодготовитьОбработчикДляДиалога(ПараметрыВыполнения);
		Обработчик = Новый ОписаниеОповещения("ОбойтиДеревоФайлов5", ЭтотОбъект, ПараметрыВыполнения);
		ПоказатьВопрос(Обработчик, ТекстОшибки, РежимДиалогаВопрос.ПрерватьПовторитьПропустить, , КодВозвратаДиалога.Повторить);
		Возврат;
	КонецЕсли;
	
	ОбойтиДеревоФайлов6(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов5(Ответ, ПараметрыВыполнения) Экспорт
	Если ПараметрыВыполнения.АсинхронныйДиалог.Открыт Тогда
		ПараметрыВыполнения.ТребуетсяЗапускЦикла = Истина;
		ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Ложь;
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Прервать Тогда
		// Просто выйдем с ошибкой
		ПараметрыВыполнения.Успех = Ложь;
		ПараметрыВыполнения.ТребуетсяЗапускЦикла = Ложь; // Цикл перезапускать не требуется.
		РаботаСФайламиСлужебныйКлиент.ВернутьРезультат(ПараметрыВыполнения.ОбработчикРезультата, ПараметрыВыполнения);
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Пропустить Тогда
		// Пропустим данную ветку дерева и пойдем дальше
		ПараметрыВыполнения.Успех = Истина;
		ПараметрыВыполнения.ТребуетсяЗапускЦикла = Ложь; // Цикл перезапускать не требуется.
		РаботаСФайламиСлужебныйКлиент.ВернутьРезультат(ПараметрыВыполнения.ОбработчикРезультата, ПараметрыВыполнения);
		Возврат;
	КонецЕсли;
	
	// Попробуем повторить создание папки.
	ОбойтиДеревоФайлов4(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов6(ПараметрыВыполнения)
	// только в том случае, если в этой папке есть хоть один файл
	ДочерниеЭлементы = ПараметрыВыполнения.ЗаписьФайла.ПолучитьЭлементы();
	Если ДочерниеЭлементы.Количество() > 0 Тогда
		
		РаботаСФайламиСлужебныйКлиент.ЗарегистрироватьОписаниеОбработчика(
			ПараметрыВыполнения,
			ЭтотОбъект,
			"ОбойтиДеревоФайлов7");
		
		ОбойтиДеревоФайлов(
			ПараметрыВыполнения,
			ПараметрыВыполнения.ЗаписьФайла,
			ПараметрыВыполнения.БазовыйКаталогСохраненияФайла,
			ПараметрыВыполнения.ЗаписьФайла.Папка,
			ПараметрыВыполнения.ОбщиеПараметры);
		
		Если ПараметрыВыполнения.АсинхронныйДиалог.Открыт Тогда
			Возврат; // Пауза цикла. Стек очищается.
		КонецЕсли;
		
		ОбойтиДеревоФайлов7(ПараметрыВыполнения.АсинхронныйДиалог.РезультатКогдаНеОткрыт, ПараметрыВыполнения);
		Возврат;
	КонецЕсли;
	
	ОбойтиДеревоФайлов8(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов7(Результат, ПараметрыВыполнения) Экспорт
	Если ПараметрыВыполнения.АсинхронныйДиалог.Открыт Тогда
		ПараметрыВыполнения.ТребуетсяЗапускЦикла = Истина;
		ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Ложь;
	КонецЕсли;
	
	Если Результат.Успех <> Истина Тогда
		ПараметрыВыполнения.Успех = Ложь;
		ПараметрыВыполнения.ТребуетсяЗапускЦикла = Ложь;
		РаботаСФайламиСлужебныйКлиент.ВернутьРезультат(ПараметрыВыполнения.ОбработчикРезультата, ПараметрыВыполнения);
		Возврат;
	КонецЕсли;
	
	// Продолжение обработки элемента.
	ОбойтиДеревоФайлов8(ПараметрыВыполнения);
	
	// Перезапуск цикла если был открыт асинхронный диалог.
	ОбойтиДеревоФайловЗапускЦикла(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов8(ПараметрыВыполнения)
	Если  ПараметрыВыполнения.ЗаписьФайла.ТекущаяВерсия <> NULL
		И ПараметрыВыполнения.ЗаписьФайла.ТекущаяВерсия.Пустая() Тогда
		// Это элемент справочника Файлы без файла - пропустим
		Возврат;
	КонецЕсли;
	
	// Пишем файл в базовый каталог
	ПараметрыВыполнения.Вставить("ИмяФайлаСРасширением", Неопределено);
	ПараметрыВыполнения.ИмяФайлаСРасширением = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
		ПараметрыВыполнения.ЗаписьФайла.ПолноеНаименование,
		ПараметрыВыполнения.ЗаписьФайла.Расширение);
	
	Если ПараметрыВыполнения.ЗаписьФайла.Зашифрован Тогда
		ПараметрыВыполнения.ИмяФайлаСРасширением = ПараметрыВыполнения.ИмяФайлаСРасширением + "." + РасширениеДляЗашифрованныхФайлов;
	КонецЕсли;
	ПараметрыВыполнения.Вставить("ПолноеИмяФайла", ПараметрыВыполнения.БазовыйКаталогСохраненияФайла + ПараметрыВыполнения.ИмяФайлаСРасширением);
	
	ПараметрыВыполнения.Вставить("Результат", Неопределено);
	ОбойтиДеревоФайлов9(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов9(ПараметрыВыполнения)
	ПараметрыВыполнения.Вставить("ФайлНаДиске", Новый Файл(ПараметрыВыполнения.ПолноеИмяФайла));
	Если ПараметрыВыполнения.ФайлНаДиске.Существует() И ПараметрыВыполнения.ФайлНаДиске.ЭтоКаталог() Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Вместо файла
			           |""%1""
			           |существует папка с таким же именем.
			           |
			           |Повторить экспорт этого файла?'"),
			ПараметрыВыполнения.ПолноеИмяФайла);
		РаботаСФайламиСлужебныйКлиент.ПодготовитьОбработчикДляДиалога(ПараметрыВыполнения);
		Обработчик = Новый ОписаниеОповещения("ОбойтиДеревоФайлов10", ЭтотОбъект, ПараметрыВыполнения);
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ПовторитьОтмена, , КодВозвратаДиалога.Отмена);
		Возврат;
	КонецЕсли;
	
	// Файла нет - идем дальше
	ПараметрыВыполнения.Результат = КодВозвратаДиалога.Повторить;
	ОбойтиДеревоФайлов11(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов10(Ответ, ПараметрыВыполнения) Экспорт
	Если ПараметрыВыполнения.АсинхронныйДиалог.Открыт Тогда
		ПараметрыВыполнения.ТребуетсяЗапускЦикла = Истина;
		ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Ложь;
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Повторить Тогда
		// Данный файл игнорируем
		ОбойтиДеревоФайлов9(ПараметрыВыполнения);
		Возврат;
	КонецЕсли;
	
	// Продолжение обработки элемента.
	ПараметрыВыполнения.Результат = КодВозвратаДиалога.Отмена;
	ОбойтиДеревоФайлов11(ПараметрыВыполнения);
	
	// Перезапуск цикла если был открыт асинхронный диалог.
	ОбойтиДеревоФайловЗапускЦикла(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов11(ПараметрыВыполнения)
	Если ПараметрыВыполнения.Результат = КодВозвратаДиалога.Отмена Тогда
		// Игнорируем файл с именем как у папки
		Возврат;
	КонецЕсли;
	
	ПараметрыВыполнения.Результат = КодВозвратаДиалога.Нет;
	
	// Спросим, а что делать с текущим файлом
	Если ПараметрыВыполнения.ФайлНаДиске.Существует() Тогда
		
		// Если у файла стоит R|O и время изменения меньше, чем в информационной базе - просто перепишем
		Если  ПараметрыВыполнения.ФайлНаДиске.ПолучитьТолькоЧтение()
			И ПараметрыВыполнения.ФайлНаДиске.ПолучитьУниверсальноеВремяИзменения() <= ПараметрыВыполнения.ЗаписьФайла.ДатаМодификацииУниверсальная Тогда
			ПараметрыВыполнения.Результат = КодВозвратаДиалога.Да;
		Иначе
			Если Не ПараметрыВыполнения.ОбщиеПараметры.ДляВсехФайлов Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В папке ""%1""
					           |существует файл ""%2""
					           |размер существующего файла = %3 байт, дата изменения %4.
					           |размер сохраняемого файла = %5 байт, дата изменения %6.
					           |
					           |Заменить существующий файл файлом из хранилища файлов?'"),
					ПараметрыВыполнения.БазовыйКаталогСохраненияФайла,
					ПараметрыВыполнения.ИмяФайлаСРасширением,
					ПараметрыВыполнения.ФайлНаДиске.Размер(),
					МестноеВремя(ПараметрыВыполнения.ФайлНаДиске.ПолучитьУниверсальноеВремяИзменения()),
					ПараметрыВыполнения.ЗаписьФайла.Размер,
					МестноеВремя(ПараметрыВыполнения.ЗаписьФайла.ДатаМодификацииУниверсальная));
				
				СтруктураПараметров = Новый Структура;
				СтруктураПараметров.Вставить("ТекстСообщения",   ТекстСообщения);
				СтруктураПараметров.Вставить("ПрименитьДляВсех", ПараметрыВыполнения.ОбщиеПараметры.ДляВсехФайлов);
				СтруктураПараметров.Вставить("БазовоеДействие",  ПараметрыВыполнения.ОбщиеПараметры.БазовоеДействие);
				
				ФормаВопроса = ПараметрыВыполнения.ОбщиеПараметры.ФормаВопроса;
				ФормаВопроса.УстановитьПараметрыИспользования(СтруктураПараметров);
				
				РаботаСФайламиСлужебныйКлиент.ПодготовитьОбработчикДляДиалога(ПараметрыВыполнения);
				Обработчик = Новый ОписаниеОповещения("ОбойтиДеревоФайлов12", ЭтотОбъект, ПараметрыВыполнения);
				
				РаботаСФайламиСлужебныйКлиент.УстановитьОповещениеФормы(ФормаВопроса, Обработчик);
				
				ФормаВопроса.Открыть();
				Возврат;
			КонецЕсли;
			
			ПараметрыВыполнения.Результат = ПараметрыВыполнения.ОбщиеПараметры.БазовоеДействие;
			ОбойтиДеревоФайлов13(ПараметрыВыполнения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Файла нет, спрашивать не будем
	ПараметрыВыполнения.Результат = КодВозвратаДиалога.Да;
	ОбойтиДеревоФайлов14(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов12(Результат, ПараметрыВыполнения) Экспорт
	Если ПараметрыВыполнения.АсинхронныйДиалог.Открыт Тогда
		ПараметрыВыполнения.ТребуетсяЗапускЦикла = Истина;
		ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Ложь;
	КонецЕсли;
	
	ПараметрыВыполнения.Результат = Результат.КодВозврата;
	ПараметрыВыполнения.ОбщиеПараметры.ДляВсехФайлов = Результат.ПрименитьДляВсех;
	ПараметрыВыполнения.ОбщиеПараметры.БазовоеДействие = ПараметрыВыполнения.Результат;
	
	// Продолжение обработки элемента.
	ОбойтиДеревоФайлов13(ПараметрыВыполнения);
	
	// Перезапуск цикла если был открыт асинхронный диалог.
	ОбойтиДеревоФайловЗапускЦикла(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов13(ПараметрыВыполнения)
	Если ПараметрыВыполнения.Результат = КодВозвратаДиалога.Прервать Тогда
		// Прерываем выгрузку
		ПараметрыВыполнения.Успех = Ложь;
		ПараметрыВыполнения.ТребуетсяЗапускЦикла = Ложь; // Цикл перезапускать не требуется.
		РаботаСФайламиСлужебныйКлиент.ВернутьРезультат(ПараметрыВыполнения.ОбработчикРезультата, ПараметрыВыполнения);
		Возврат;
	ИначеЕсли ПараметрыВыполнения.Результат = КодВозвратаДиалога.Пропустить Тогда
		// Пропускаем этот файл
		Возврат;
	КонецЕсли;
	
	// Если можно - запишем файл в файловую систему
	Если ПараметрыВыполнения.Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОбойтиДеревоФайлов14(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов14(ПараметрыВыполнения)
	ПараметрыВыполнения.ФайлНаДиске = Новый Файл(ПараметрыВыполнения.ПолноеИмяФайла);
	Если ПараметрыВыполнения.ФайлНаДиске.Существует() Тогда
		// Снимем флаг R|O для возможности удаления
		ПараметрыВыполнения.ФайлНаДиске.УстановитьТолькоЧтение(Ложь);
	КонецЕсли;
	
	// Всегда удалим и потом создадим заново
	ИнформацияОбОшибке = Неопределено;
	Попытка
		УдалитьФайлы(ПараметрыВыполнения.ПолноеИмяФайла);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
	КонецПопытки;
	Если ИнформацияОбОшибке <> Неопределено Тогда
		ОбойтиДеревоФайлов15(ИнформацияОбОшибке, ПараметрыВыполнения);
		Возврат;
	КонецЕсли;
	
	РазмерВМб = ПараметрыВыполнения.ЗаписьФайла.Размер / (1024 * 1024);
	
	// Обновим индикатор прогресса
	СостояниеЗаголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Экспорт папки ""%1""'"),
		ПараметрыВыполнения.ЗаписьФайла.НаименованиеПапки);
	СостояниеТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Сохраняется на диск файл
		           |""%1"" (%2 Мб)...'"),
		ПараметрыВыполнения.ФайлНаДиске.Имя,
		ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьСтрокуСРазмеромФайла(РазмерВМб));
	Состояние(СостояниеЗаголовок, , СостояниеТекст, БиблиотекаКартинок.Информация32);
	
	// Запишем файл заново
	АдресФайлаДляОткрытия = РаботаСФайламиСлужебныйВызовСервера.ПолучитьНавигационнуюСсылкуДляОткрытия(
		ПараметрыВыполнения.ЗаписьФайла.ТекущаяВерсия,
		УникальныйИдентификатор);
	
	Попытка
		ПолучитьФайл(АдресФайлаДляОткрытия, ПараметрыВыполнения.ПолноеИмяФайла, Ложь);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
	КонецПопытки;
	Если ИнформацияОбОшибке <> Неопределено Тогда
		ОбойтиДеревоФайлов15(ИнформацияОбОшибке, ПараметрыВыполнения);
		Возврат;
	КонецЕсли;
	
	// для варианта с хранением файлов на диске (на сервере) удаляем файл из временного хранилища после получения
	Если ЭтоАдресВременногоХранилища(АдресФайлаДляОткрытия) Тогда
		УдалитьИзВременногоХранилища(АдресФайлаДляОткрытия);
	КонецЕсли;
	
	ПараметрыВыполнения.ФайлНаДиске = Новый Файл(ПараметрыВыполнения.ПолноеИмяФайла);
	
	Попытка
		// Сделаем файл только для чтения
		ПараметрыВыполнения.ФайлНаДиске.УстановитьТолькоЧтение(Истина);
		// Поставим время модификации - как в информационной базе
		ПараметрыВыполнения.ФайлНаДиске.УстановитьУниверсальноеВремяИзменения(
			ПараметрыВыполнения.ЗаписьФайла.ДатаМодификацииУниверсальная);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
	КонецПопытки;
	Если ИнформацияОбОшибке <> Неопределено Тогда
		ОбойтиДеревоФайлов15(ИнформацияОбОшибке, ПараметрыВыполнения);
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов15(ИнформацияОбОшибке, ПараметрыВыполнения)
	// По какой-то случилась файловая ошибка при записи файла и
	// изменении его атрибутов.
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Ошибка записи файла
		           |""%1"".
		           |
		           |%2.'"),
		ПараметрыВыполнения.ПолноеИмяФайла,
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	
	РаботаСФайламиСлужебныйКлиент.ПодготовитьОбработчикДляДиалога(ПараметрыВыполнения);
	Обработчик = Новый ОписаниеОповещения("ОбойтиДеревоФайлов16", ЭтотОбъект, ПараметрыВыполнения);
	
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ПрерватьПовторитьПропустить, , КодВозвратаДиалога.Повторить);
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоФайлов16(Ответ, ПараметрыВыполнения) Экспорт
	Если Ответ = КодВозвратаДиалога.Прервать Тогда
		// Просто выйдем с ошибкой
		ПараметрыВыполнения.Успех = Ложь;
		ПараметрыВыполнения.ТребуетсяЗапускЦикла = Ложь; // Цикл перезапускать не требуется.
		РаботаСФайламиСлужебныйКлиент.ВернутьРезультат(ПараметрыВыполнения.ОбработчикРезультата, ПараметрыВыполнения); // Ложь.
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Пропустить Тогда
		// Пропустим этот файл и пойдем дальше
		Возврат;
	КонецЕсли;
	
	// Попробуем повторить создание папки
	ОбойтиДеревоФайлов14(ПараметрыВыполнения);
КонецПроцедуры

#КонецОбласти
