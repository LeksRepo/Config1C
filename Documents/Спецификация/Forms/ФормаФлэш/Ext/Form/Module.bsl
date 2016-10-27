﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ТипПечатиДвери = 0;
	
	ОпределительФлеш = "";
	Спецификация = Документы.Спецификация.ПустаяСсылка();
	
	Если Параметры.Свойство("ХранимыйФайл") Тогда
		
		ОпределительФлеш = Параметры.ХранимыйФайл;
		
	КонецЕсли;
	
	РаскройГотов = Ложь;
	
	ИмяHTML = Справочники.Файлы.ContainerHtml.Наименование + "." + Справочники.Файлы.ContainerHtml.ТекущаяВерсия.Расширение;
	
	Если ОпределительФлеш = "КривойПил" Тогда
		
		ИмяSWF = Справочники.Файлы.ПечатьКривойПилFlash.Наименование + "." + Справочники.Файлы.ПечатьКривойПилFlash.ТекущаяВерсия.Расширение;
		
		СтрокаДляФлэш = Параметры.ВидОтображения + Параметры.СтрокаКривогоПила;
		Спецификация = ?(Параметры.Свойство("Спецификация"), ?(ТипЗнч(Параметры.Спецификация) = Тип("ДокументСсылка.НарядЗадание"), Спецификация, Параметры.Спецификация), Спецификация);
		
	ИначеЕсли ОпределительФлеш = "НовыйРаскрой" Тогда
		
		//Параметры.ВидОтображения
		//1 - Сохраняем флэшку в картинку, при проведении спецификации
		//2 - Обычный просмотр флэшки, до проведения
		//3 - Тоже самое что 2, но без размеров деталей
		
		Спецификация = ?(Параметры.Свойство("Спецификация"), ?(ТипЗнч(Параметры.Спецификация) = Тип("ДокументСсылка.НарядЗадание"), Спецификация, Параметры.Спецификация), Спецификация);
		
		ИмяSWF = Справочники.Файлы.РаскройFlash.Наименование + "." + Справочники.Файлы.РаскройFlash.ТекущаяВерсия.Расширение;
		
		СтрокаДляФлэш = Параметры.ВидОтображения + Параметры.СтрокаНовогоРаскрояЛДСП;
		
		РаскройГотов = (Параметры.ВидОтображения = "2" ИЛИ Параметры.ВидОтображения = "3");
		
		Ширина = ?(РаскройГотов, 150, 51);
		Высота = ?(РаскройГотов, 60, 15);
		Элементы.ХТМЛ.ТолькоПросмотр = НЕ РаскройГотов;
		
	ИначеЕсли ОпределительФлеш = "ЧертежДвери" Тогда
		
		СтруктураМассивовДверей = Новый Структура;
		СтруктураМассивовДверей.Вставить("КартинкиДверей", Новый Массив);
		СтруктураМассивовДверей.Вставить("ФлэшСтроки", Параметры.МассивДверейФлэш);
		
		Если ЗначениеЗаполнено(Параметры.Договор) Тогда
			
			СтруктураМассивовДверей.Вставить("Договор", Параметры.Договор);
			СтруктураМассивовДверей.Вставить("Спецификация", Параметры.Договор.Спецификация);
			ТипПечатиДвери = 1;
			
		Иначе
			ДоговорСсылка = Документы.Спецификация.ПолучитьДоговор(Параметры.Спецификация);
			СтруктураМассивовДверей.Вставить("Договор", ДоговорСсылка);
			СтруктураМассивовДверей.Вставить("Спецификация", Параметры.Спецификация);			
		КонецЕсли; 
		
		СтруктураМассивовДверей.Вставить("ДвериСсылки", Параметры.МассивДверейСсылки);
		СтруктураМассивовДверей.Вставить("ТекущаяДверь", Параметры.МассивДверейСсылки.Получить(0));
		СтруктураМассивовДверей.Вставить("КомментарийДвери",Параметры.МассивДверейСсылки[0].Комментарий);
		
		ИмяSWF = Справочники.Файлы.ДвериFlash.Наименование + "." + Справочники.Файлы.ДвериFlash.ТекущаяВерсия.Расширение;
		
		СтрокаДляФлэш = Параметры.МассивДверейФлэш.Получить(0);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредупредитьНаКлиенте()
	
	Строка = Новый ФорматированнаяСтрока("Обновите справочник файлов!",,,,"e1cib/command/ОбщаяКоманда.СинхронизацияФайлов");
	Предупреждение(Строка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	url = ЛексКлиент.ПутьHTML(ИмяHTML)+"?"+ЛексКлиент.ПутьHTML(ИмяSWF);
	
	Если url <> "" Тогда
		
		Попытка
			Элементы.ХТМЛ.Документ.url = url;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Отказ = Истина;
		КонецПопытки;
		
	Иначе
		
		ПредупредитьНаКлиенте();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ХТМЛПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ПолученнаяСтрока = Элементы.ХТМЛ.Документ.getElementById("forw").tag;
	Элементы.ХТМЛ.Документ.getElementById("forw").tag = "";
	
	Если ОпределительФлеш = "ЧертежДвери" Тогда
		
		Команда = Лев(ПолученнаяСтрока, 4); // код команды, первые 4 символа
		ЗначениеОтФлэш = Прав(ПолученнаяСтрока, СтрДлина(ПолученнаяСтрока) - 5); // полученные значения аргументов от флэш
		ЭлементДляВвода = Элементы.ХТМЛ.Документ.getElementById("back");
		
		Если Команда = "init" Тогда
			
			Просмотр = "0";
			ЭлементДляВвода.tag = "ppic☻"+СтрокаДляФлэш+"☻"+Просмотр+"☻"+ЛексКлиент.ПолучитьЛоготип(СтруктураМассивовДверей.Спецификация);
			ЭлементДляВвода.click();
			
		ИначеЕсли Команда = "prtx" Тогда
			
			Если ТипПечатиДвери = 1 Тогда 
				Примечание = ЛексСервер.УстановитьПримечание();
			Иначе
				Примечание = "%НЕКЛИЕНТУ%" + СтруктураМассивовДверей.КомментарийДвери;
			КонецЕсли;
		
			ЭлементДляВвода.tag = ПолучитьДанныеДляПечатиДвери(СтруктураМассивовДверей,Примечание);
			ЭлементДляВвода.click();
			
		ИначеЕсли Команда = "ppic" Тогда
			
			СтруктураМассивовДверей.КартинкиДверей.Добавить(ЗначениеОтФлэш);
			РаскройГотов = Истина;
			Закрыть(СтруктураМассивовДверей.КартинкиДверей);
			
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		Если Найти(ПолученнаяСтрока, "save") > 0 Тогда
			
			РаскройГотов = Истина;
			Закрыть(ПолученнаяСтрока);
			Возврат;
			
		КонецЕсли;
		
		СтрокаДляФлэш = СтрЗаменить(СтрокаДляФлэш, "%ЛОГОТИП%", ЛексКлиент.ПолучитьЛоготип(Спецификация));
		Элементы.ХТМЛ.Документ.getElementById("back").tag = СтрокаДляФлэш;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеДляПечатиДвери(Данные,Примечание)
	
	Возврат Справочники.Двери.ПолучитьДанныеДляПечатиДвери(Данные,Примечание);
	
КонецФункции
