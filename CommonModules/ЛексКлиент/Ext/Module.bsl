﻿
Функция ПутьHTML (ИмяHTML) Экспорт
	
	ПутьHTML = "";
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	
	Если НЕ РасширениеПодключено Тогда
		
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСФайлами();
		
	Иначе
		
		РабочийКаталог = ПолучитьПутьКаталогаФайлов();
		ПутьHTML = РабочийКаталог + ИмяHTML;
		
		Файл = Новый Файл(ПутьHTML);
		
		Если НЕ Файл.Существует() Тогда
			ПутьHTML = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ПутьHTML;
	
КонецФункции

Функция ОбработкаКомандыПройтиТест(СсылкаУчебноеЗанятие) Экспорт
	
	Если ТипЗнч(СсылкаУчебноеЗанятие) = Тип("СправочникСсылка.УчебныеЗанятия") Тогда
		
		Если ЛексСервер.ЗначениеРеквизитаОбъекта(СсылкаУчебноеЗанятие, "ЭтоГруппа") Тогда
			Возврат Ложь; // Позднее нужно сделать
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура("Тема", СсылкаУчебноеЗанятие);
		ОткрытьФорму("Документ.ТестированиеПользователей.Форма.ФормаДокумента", ПараметрыФормы);
		
	КонецЕсли;
	
КонецФункции

Процедура ПечатьДоговора(ПараметрКоманды, ПараметрыВыполненияКоманды, ДоговорДилера) Экспорт
	
	МассивДоговоров = ЛексСервер.ВыборМакетов(ПараметрКоманды, ДоговорДилера);
	
	Для Каждого Договор Из МассивДоговоров Цикл
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ФиксированныйКомплект", Ложь);
		ПараметрыПечати.Вставить("ПереопределитьПользовательскиеНастройкиКоличества", Истина);
		
		МассивДокумент = Новый Массив;
		МассивДокумент.Добавить(Договор.Договор);
		
		МассивМакетов = Новый Массив();
		
		Если ЗначениеЗаполнено(Договор.ПоКаталогу) Тогда
			МассивМакетов.Добавить(Строка(Договор.ПоКаталогу));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Договор.ЭскизнаяЗаявка) Тогда
			МассивМакетов.Добавить(Строка(Договор.ЭскизнаяЗаявка));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Договор.ЧертежДвери) Тогда
			МассивМакетов.Добавить(Строка(Договор.ЧертежДвери));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Договор.Инструкция) Тогда
			МассивМакетов.Добавить(Строка(Договор.Инструкция));
		КонецЕсли;
		
		Если МассивМакетов.Количество()>0 Тогда
			МакетЭскиза = ","+СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(МассивМакетов, ",");
		Иначе
			МакетЭскиза = "";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Договор.ЧертежДвери) Тогда
			
			Картинки = Новый Массив;
			
			Сч = 0;
			
			Пока Сч < Договор.ДвериФлэш.Количество() Цикл
				
				ДвериФлэш = Новый Массив;
				ДвериФлэш.Добавить(Договор.ДвериФлэш[Сч]);
				
				ДвериСсылка = Новый Массив;
				ДвериСсылка.Добавить(Договор.ДвериСсылка[Сч]);
				
				ПараметрыФормыФлэш = Новый Структура;
				ПараметрыФормыФлэш.Вставить("ХранимыйФайл", "ЧертежДвери");
				ПараметрыФормыФлэш.Вставить("МассивДверейФлэш", ДвериФлэш);
				ПараметрыФормыФлэш.Вставить("МассивДверейСсылки", ДвериСсылка);
				ПараметрыФормыФлэш.Вставить("Договор", Договор.Договор);
				КартинкаДвери = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормыФлэш);
				Картинки.Добавить(КартинкаДвери);
				
				Сч = Сч + 1;
				
			КонецЦикла;
			
			ПараметрыПечати.Вставить("КартинкиДвери", Картинки);
			ПараметрыПечати.Вставить("Договор", Договор.Договор);
			
		КонецЕсли;
		
		Если ЛексСервер.ДоговорНаЮрЛицо(Договор.Договор) ИЛИ УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(МассивДокумент, ПараметрыВыполненияКоманды.Источник) Тогда
			
			Если ДоговорДилера Тогда
				
				УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ДоговорДилера",
				"ДоговорДилера,УсловияДоставкиВыписка,ТитульныйЛистТПМК"
				+ МакетЭскиза,
				МассивДокумент,
				ПараметрыВыполненияКоманды,
				ПараметрыПечати);
				
			Иначе
				
				УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Договор",
				"Договор,УсловияДоставкиВыписка,ТитульныйЛистТПМК"
				+ МакетЭскиза,
				МассивДокумент,
				ПараметрыВыполненияКоманды,
				ПараметрыПечати);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ПечатьДоговора()

Функция ПолучитьЛоготип(Спецификация) Экспорт
	
	Логотип = "";
	
	Если ТипЗнч(Спецификация) = Тип("ДокументСсылка.Спецификация") И ЗначениеЗаполнено(Спецификация) Тогда
		
		Рек = ЛексСервер.ЗначенияРеквизитовОбъекта(Спецификация, "Изделие,Дилерский,Изделие.ЭтоДетали");
		
		ЭтоДетали = Рек.ИзделиеЭтоДетали;
		Изделие = Рек.Изделие;
		Дилерский = ?(Рек.Дилерский = Неопределено, Ложь, Рек.Дилерский);
		
		Если Дилерский Тогда
			Логотип = ЛексСервер.ПолучитьЛоготипДилера(Спецификация);
		ИначеЕсли ЭтоДетали Тогда
			Логотип = ЛексСервер.ПолучитьЛоготипПодразделения(Спецификация);
		Иначе
			Логотип = ЛексСервер.ПолучитьЛоготипОфиса(Спецификация);
		КонецЕсли;
		
		Если Логотип = "" Тогда
			Логотип = ЛексСервер.ПолучитьЛоготипПодразделения(Спецификация);
		КонецЕсли;
		
		Если НЕ (Логотип = "") Тогда
			
			РабочийКаталог = ПолучитьПутьКаталогаФайлов();
			ПутьКИзображению = РабочийКаталог + Логотип;
			
			ФайлНаДиске = Новый Файл(ПутьКИзображению);
			
			Если ФайлНаДиске.Существует() Тогда
				Логотип = ПутьКИзображению;
			Иначе
				Логотип = "";
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Логотип;
	
КонецФункции

Функция ВыборСчетаКассы(ИмяПоляСубконто, фнОбъект) Экспорт
	
	ТипСубконто = ТипЗнч(фнОбъект[ИмяПоляСубконто]);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Подразделение", фнОбъект.Подразделение);
	ПараметрыФормы.Вставить("Активность", Истина);
	
	ЗначениеСправочника = Неопределено;
	
	Если ТипСубконто = Тип("СправочникСсылка.Счета") Тогда
		ИмяФормыВыбора = "Справочник.Счета.ФормаВыбора";
	Иначе
		ИмяФормыВыбора = "Справочник.Кассы.ФормаВыбора";
	КонецЕсли;
	
	ЗначениеСправочника = ОткрытьФормуМодально(ИмяФормыВыбора, Новый Структура("Отбор", ПараметрыФормы));
	
	Если ЗначениеСправочника <> Неопределено Тогда
		фнОбъект[ИмяПоляСубконто] = ЗначениеСправочника;
	КонецЕсли;
	
КонецФункции

Функция ПредупредитьОПовторномПроведении(Объект) Экспорт
	
	Отказ = Ложь;
	
	Если Объект.Проведен Тогда
		
		Режим = РежимДиалогаВопрос.ДаНет;
		Текст = "Вы изменили существующий документ." + Символы.ПС + "Продолжить проведение?";
		
		Если Вопрос(Текст, Режим, 0) = КодВозвратаДиалога.Нет Тогда
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

Функция ПолучитьПутьКаталогаФайлов() Экспорт
	
	// Измененная функция 
	// ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя()
	
	ИмяКаталога = "";
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	
	Оболочка = Новый COMОбъект("WScript.Shell");
	Путь = Оболочка.ExpandEnvironmentStrings("%APPDATA%");
	
	Путь = Путь
	+ "\1C\Файлы\"
	+ ПараметрыРаботыКлиента.ИмяКонфигурации
	+ ОбщегоНазначенияКлиентСервер.РазделительПути();
	
	ЭтоРабочаяБаза = Булево(Найти(СтрокаСоединенияИнформационнойБазы(),"ws="));
	
	Если ЭтоРабочаяБаза Тогда
		ИмяКаталога = Путь + "Файлы";
	Иначе
		ИмяКаталога = Путь + "ФайлыРазработка";
	КонецЕсли;
	
	ИмяКаталога = СтрЗаменить(ИмяКаталога, "<", " ");
	ИмяКаталога = СтрЗаменить(ИмяКаталога, ">", " ");
	ИмяКаталога = СокрЛП(ИмяКаталога);
	ИмяКаталога = ИмяКаталога + ОбщегоНазначенияКлиентСервер.РазделительПути();
	
	Возврат ИмяКаталога;
	
КонецФункции

Процедура ОткрытьФайл(Файл) Экспорт
	
	ДанныеФайла = ЛексСервер.ПолучитьДанныеФайла(Файл);
	
	ИмяКаталога = ЛексКлиентСервер.ПолучитьПапкуДляКэшФайлов(ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя());
	
	ИмяФайла = ДанныеФайла.Наименование + ДанныеФайла.Расширение;
	ИмяФайлаСПутем = ИмяКаталога + ИмяФайла;
	ФайлВХранилище = ЛексСервер.ПолучитьДанныеФайлаВХранилище(Файл);
	
	ПередаваемыйФайл = Новый Массив;
	Описание = Новый ОписаниеПередаваемогоФайла(ИмяФайла, ФайлВХранилище);
	ПередаваемыйФайл.Добавить(Описание);
	
	ПолучитьФайлы(ПередаваемыйФайл,, ИмяКаталога, Ложь);
	
	ФайлВПапке = Новый Файл(ИмяФайлаСПутем);
	Если ФайлВПапке.Существует() Тогда
		ФайлВПапке.УстановитьТолькоЧтение(Ложь);
	КонецЕсли;
	
	ЗапуститьПриложение(ИмяФайлаСПутем);
	
КонецПроцедуры

Процедура УдалитьПапкуКэшФайлов() Экспорт
	
	ИмяКаталога = ЛексКлиентСервер.ПолучитьПапкуДляКэшФайлов(ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя());
	
	Файл = Новый Файл(ИмяКаталога);
	
	Если Файл.Существует() Тогда
		
		Файл.УстановитьТолькоЧтение(Ложь);
		УдалитьФайлы(ИмяКаталога);
		
	КонецЕсли;
	
КонецПроцедуры 

Функция ВыбратьФайл(Форма) Экспорт
	
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	
	Если НЕ РасширениеПодключено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ВыборФайла.МножественныйВыбор = Ложь;
	ВыборФайла.Заголовок = НСтр("ru = 'Выбор файла'");
	ВыборФайла.Фильтр = НСтр("ru = 'Все файлы (*.*)|*.*'");
	
	Результат = ВыборФайла.Выбрать();
	ПолноеИмяФайла = ВыборФайла.ПолноеИмяФайла;
	
	Если НЕ Результат Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Файл = Новый Файл(ПолноеИмяФайла);
	
	ВремяСоздания = ТекущаяДата();
	ИмяСоздания = Файл.ИмяБезРасширения;
	ИмяФайла = ИмяСоздания + Файл.Расширение;
	Расширение = Файл.Расширение;
	Пиктограмма = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Файл.Расширение);
	
	РазмерВКб = Файл.Размер() / 1024;
	Если РазмерВКб < 1 Тогда
		РазмерВКб = 1;
	КонецЕсли;
	
	ПомещаемыеФайлы = Новый Массив;
	Описание = Новый ОписаниеПередаваемогоФайла(Файл.ПолноеИмя, "");
	ПомещаемыеФайлы.Добавить(Описание);
	
	ПомещенныеФайлы = Новый Массив;
	
	Если НЕ ПоместитьФайлы(ПомещаемыеФайлы,ПомещенныеФайлы,,Ложь,Форма.УникальныйИдентификатор) Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Ошибка при помещении файла ""%1"" во временное хранилище.'"),Файл.ПолноеИмя);
		
	КонецЕсли;
	
	Если ПомещенныеФайлы.Количество() = 1 Тогда
		АдресВременногоХранилищаФайла = ПомещенныеФайлы[0].Хранение;
	КонецЕсли;
	
	СтруктураФайла = Новый Структура();
	
	СтруктураФайла.Вставить("Наименование", ИмяСоздания);
	СтруктураФайла.Вставить("АдресВременногоХранилищаФайла", АдресВременногоХранилищаФайла);
	СтруктураФайла.Вставить("Дата", ТекущаяДата());
	СтруктураФайла.Вставить("Автор", ПользователиКлиентСервер.АвторизованныйПользователь());
	СтруктураФайла.Вставить("Размер", РазмерВКб);
	СтруктураФайла.Вставить("Расширение", Расширение);
	СтруктураФайла.Вставить("Пиктограмма", Пиктограмма);
	
	Возврат СтруктураФайла;
	
КонецФункции

Функция ОбщегоНазначенияКлиентПереопределяемыйПередНачаломРаботыСистемы(Параметры) Экспорт
	
	Параметры.Отказ = ЗапретитьВходСКомпьютера();
	УстановитьПараметрыФункциональныхОпцийИнтерфейса(Новый Структура(),"ПолныйУчетПодразделение,ПолныйУчетВидНастройки");
	
	Если НЕ Параметры.Отказ Тогда
		
		Стр = ЛексСервер.ПолучитьПараметрыФункциональныхОпций();
		
		Если ЗначениеЗаполнено(Стр.ТекущееПодразделение) Тогда
	
			Стр.Вставить("ПолныйУчетПодразделение", Стр.ТекущееПодразделение);
			Стр.Вставить("ПолныйУчетВидНастройки", Стр.ПолныйУчет);
			
			УстановитьПараметрыФункциональныхОпцийИнтерфейса(Стр);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

Функция ОбщегоНазначенияКлиентПереопределяемыйПриНачалеРаботыСистемы() Экспорт
	
	ЗаполнитьПутьКЛокальномуКэшуФайлов();
	ПодключитьОбработчикиОповещения();
	ЗаголовокСистемы();
	
	#Если НЕ ВебКлиент Тогда
		
		ПараметрыФ = Новый Структура;
		ПараметрыФ.Вставить("ЗапускПрограммы", Истина);
		ОткрытьФормуМодально("Обработка.СинхронизацияФайлов.Форма", ПараметрыФ);
		
	#КонецЕсли
	
КонецФункции

// Изменение заголовка системы пользователям
// с включенной настройкой.
Функция ЗаголовокСистемы()
	
	Пользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
	Настройка = ПредопределенноеЗначение("ПланВидовХарактеристик.НастройкиПользователей.ОтображатьИмяБазы");
	ОтображатьИмяБазы = ЛексСервер.ПолучитьЗначениеНастройкиПользователя(Пользователь, Настройка);
	
	Если ЗначениеЗаполнено(ОтображатьИмяБазы) И ОтображатьИмяБазы Тогда
		
		Стр = СтрокаСоединенияИнформационнойБазы();
		
		Если Найти(Стр, "Ref") > 0 Тогда
			
			ИмяБазы = "База: " + СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Стр, """")[3];
			Заголовок = ИмяБазы +" / "+ Пользователь;
			
		Иначе
			
			ИмяБазы = "База: Рабочая";
			Заголовок = ИмяБазы +" / "+ Пользователь;
			
		КонецЕсли;
		
		УстановитьЗаголовокКлиентскогоПриложения(Заголовок);
		
	КонецЕсли;
	
КонецФункции

// Оповещения о служебных записках.
// Для дилеров -- один раз при запуске,
// для штатных сотрудинков -- один раз в 15 минут.
Функция ПодключитьОбработчикиОповещения()
	
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		ОповещениеСообщенияДилерам();
		
	Иначе
		
		ОповещениеСлужебныхЗаписок();
		ПодключитьОбработчикОжидания("ОповещениеСлужебныхЗаписок", 1800);
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСвойстваКомпьютера()
	
	Перем Результат;
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяКомпьютера", "КлиентНеопределен");
	Результат.Вставить("Серийник", "КлиентНеопределен");
	
	#Если ТонкийКлиент Тогда
		
		Результат.ИмяКомпьютера = ИмяКомпьютера();
		
		СистемнаяИнформация = Новый СистемнаяИнформация;
		ТекущийТипПлатформы = СистемнаяИнформация.ТипПлатформы;
		
		Результат.Серийник = "Ошибка получения серийного номера";
		
		Если ТекущийТипПлатформы = ТипПлатформы.Windows_x86
			ИЛИ ТекущийТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
			
			Попытка
				
				ФСО = Новый COMОбъект("Scripting.FileSystemObject");
				ФСО_Диск = ФСО.GetDrive("C");
				Результат.Серийник = ФСО_Диск.SerialNumber;
				
			Исключение
				
				// Лучше не сообщать об ошибке,
				// чтобы не выдавать сведений о том,
				// к чему привязывается серийный номер
				
				//Сообщить(ОписаниеОшибки());
				
			КонецПопытки;
			
		КонецЕсли;
		
	#ИначеЕсли ВебКлиент Тогда
		
		Результат.ИмяКомпьютера = "ВебКлиент";
		Результат.Серийник = "ВебКлиент";
		
	#КонецЕсли
	
	Возврат Результат;
	
КонецФункции

// Определение компьютера, фиксация авторизации,
// блокировка работы штатных работников на неодобренных
// компьютерах, запрет работы на компьютере из черного списка.
// Параметры
//  Отказ  - Булево - Блокировка запуска системы
Функция ЗапретитьВходСКомпьютера()
	
	Результат = Ложь;
	
	Если ЛексСервер.НетПользователейВБазе() Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	СвойстваКомпьютера = ПолучитьСвойстваКомпьютера();
	
	Админ = ЛексСервер.ТекущийПользовательАдминистратор();
	Компьютер = ЛексСервер.ОпределитьКомпьютер(СвойстваКомпьютера.Серийник, СвойстваКомпьютера.ИмяКомпьютера);
	
	ВидАктивности = ПредопределенноеЗначение("Перечисление.ВидыАктивностиПользователей.ВходВСистему");
	
	Если Компьютер.ЧерныйСписок 
		И НЕ Админ Тогда
		
		Результат = Истина;
		ВидАктивности = ПредопределенноеЗначение("Перечисление.ВидыАктивностиПользователей.АвторизацияЧерныйСписок");
		
	ИначеЕсли НЕ (Компьютер.Одобренный ИЛИ Админ)
		И НЕ ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		Результат = Истина;
		ВидАктивности = ПредопределенноеЗначение("Перечисление.ВидыАктивностиПользователей.АвторизацияСНеодобренногоКомпьютера");
		Предупреждение("Попытка несанкционированного доступа зафиксирована." + Символы.ПС + "Свяжитесь со службой поддержки.", 30, "Ошибка авторизации");
		
	КонецЕсли;
	
	ЛексСервер.ЗаписатьДействиеПользователя(Компьютер.Ссылка, ВидАктивности);
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьПутьКЛокальномуКэшуФайлов()
	
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "ПутьКЛокальномуКэшуФайлов");
	Элемент.Вставить("Значение",  ЛексКлиент.ПолучитьПутьКаталогаФайлов());
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "МаксимальныйРазмерЛокальногоКэшаФайлов");
	Элемент.Вставить("Значение", ЛексКлиентСервер.ПолучитьМаксимальныйРазмерКэшаФайлов());
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(МассивСтруктур);
	
КонецПроцедуры

Процедура ОповещениеСообщенияДилерам()
	
	Данные = ЛексСервер.ПолучитьСписокНеОзнакомленныхСообщенийДилерам();
	
	Если Данные.Количество > 0 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("АдресТаблицы", Данные.АдресТаблицы);
		
		ОткрытьФорму("ОбщаяФорма.ФормаНеОзнакомленныхСообщенийДилерам", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры
