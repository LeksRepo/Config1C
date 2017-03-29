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
		
		МассивДокумент = Новый Массив;
		МассивДокумент.Вставить(0, Договор.Договор);
		
		//RonEXI: Тут какаято лажа с запятыми при формировании строки, иногда запрос выдаёт пустые значения с запятой, делал не я, ставлю костыль.
		//МакетЭскиза = ?(ЗначениеЗаполнено(Договор.ЭскизнаяЗаявка), Договор.Инструкция + Договор.ПоКаталогу + Договор.ЭскизнаяЗаявка + Договор.ЧертежДвери, Строка(Договор.ПоКаталогу) + Строка(Договор.ЧертежДвери));
		
		МакетЭскиза = ?(ЗначениеЗаполнено(Договор.ЭскизнаяЗаявка), Строка(Договор.ПоКаталогу) + Строка(Договор.ЭскизнаяЗаявка) + Строка(Договор.ЧертежДвери), Строка(Договор.ПоКаталогу) + Строка(Договор.ЧертежДвери));
		
		МассивМакетов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МакетЭскиза, ",");
		НовыйМассивМакетов = Новый Массив;
		
		Для Каждого Эл Из МассивМакетов Цикл
			Если НЕ ((Эл = "") ИЛИ (Эл = " ")) Тогда
				НовыйМассивМакетов.Добавить(Эл);	
			КонецЕсли;
		КонецЦикла;
		
		Если НовыйМассивМакетов.Количество()>0 Тогда
			МакетЭскиза = ","+СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(НовыйМассивМакетов, ",");
		Иначе
			МакетЭскиза = "";
		КонецЕсли;
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		Если ЗначениеЗаполнено(Договор.ЧертежДвери) Тогда
			Документ = Новый Структура;
			Документ.Вставить("МассивОбъектов", МассивДокумент);
			Документ.Вставить("Двери", Новый Массив);
			
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
				Значение = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормыФлэш);
				Документ.Двери.Добавить(Значение);
				
				Сч = Сч + 1;
				
			КонецЦикла;
			
		Иначе
			
			Документ = МассивДокумент;
			
		КонецЕсли;
		
		Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(МассивДокумент, ПараметрыВыполненияКоманды.Источник) Тогда
			
			ПараметрыПечати = Новый Структура;
			ПараметрыПечати.Вставить("ФиксированныйКомплект", Ложь);
			ПараметрыПечати.Вставить("ПереопределитьПользовательскиеНастройкиКоличества", Истина);
			
			Если ДоговорДилера Тогда
				
				УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Договор",
				"ДоговорДилера,УсловияДоставкиВыписка,ТитульныйЛистТПМК"
				+ МакетЭскиза,
				Документ,
				ПараметрыВыполненияКоманды,
				ПараметрыПечати);
				
			Иначе
				
				УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Договор",
				"Договор,УсловияДоставкиВыписка,ТитульныйЛистТПМК"
				+ МакетЭскиза,
				Документ,
				ПараметрыВыполненияКоманды,
				ПараметрыПечати);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ПечатьДоговора()

Функция ПолучитьЛоготип(Спецификация) Экспорт
	
	Логотип = "";
	
	Если ТипЗнч(Спецификация) = Тип("ДокументСсылка.Спецификация") Тогда
		
		Рек = ЛексСервер.ЗначенияРеквизитовОбъекта(Спецификация, "Изделие,Дилерский");
		
		Изделие = Рек.Изделие;
		Дилерский = ?(Рек.Дилерский = Неопределено, Ложь, Рек.Дилерский);
		
		Если Дилерский Тогда
			Логотип = ЛексСервер.ПолучитьЛоготипДилера(Спецификация);
		ИначеЕсли Изделие = ПредопределенноеЗначение("Справочник.Изделия.Детали")  Тогда
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
	ПараметрыФормы.Вставить("ПринадлежитПодразделению", фнОбъект.Подразделение);
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

	СтруктураФайла.Вставить("Наименование",ИмяСоздания);
	СтруктураФайла.Вставить("АдресВременногоХранилищаФайла",АдресВременногоХранилищаФайла);
	СтруктураФайла.Вставить("Дата",ТекущаяДата());
	СтруктураФайла.Вставить("Автор",ПользователиКлиентСервер.ТекущийПользователь());
	СтруктураФайла.Вставить("Размер",РазмерВКб);
	СтруктураФайла.Вставить("Расширение", Расширение);
	СтруктураФайла.Вставить("Пиктограмма", Пиктограмма);
	
	Возврат СтруктураФайла;
	
КонецФункции