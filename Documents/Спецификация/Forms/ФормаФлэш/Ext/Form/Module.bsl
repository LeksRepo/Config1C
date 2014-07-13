﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Свойство("СпецификацияСсылка") Тогда
		СпецификацияСсылка 	= Параметры.СпецификацияСсылка;
	КонецЕсли;
		
	ХранимыйФайлФлэш = Параметры.ХранимыйФайл;
	РаскройГотов = Ложь;
	
	Если ХранимыйФайлФлэш = "КривойПил" Тогда
		
		ИмяHTML = ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.КривойПилHtml);
		СтрокаДляФлэш = Параметры.СтрокаКривогоПила;
		
	ИначеЕсли ХранимыйФайлФлэш = "НовыйРаскрой" Тогда
		
		//Параметры.ВидОтображения
		//1 - Сохраняем флэшку в картинку, при проведении спецификации
		//2 - Обычный просмотр флэшки, до проведения
		ИмяHTML = ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.НовыйРаскройHtml);
		СтрокаДляФлэш = Параметры.ВидОтображения + Параметры.СтрокаНовогоРаскрояЛДСП;
		
		РаскройГотов = Параметры.ВидОтображения = "2";
		
		ЭтаФорма.Ширина = ?(РаскройГотов, 150, 51);
		ЭтаФорма.Высота = ?(РаскройГотов, 60, 15);
		Элементы.ХТМЛ.ТолькоПросмотр = НЕ РаскройГотов;
		
	КонецЕсли;                

КонецПроцедуры

&НаКлиенте
Процедура ПредупредитьНаКлиенте()
	Строка = Новый ФорматированнаяСтрока("Обновите справочник файлов!",,,,"e1cib/command/ОбщаяКоманда.СинхронизацияФайлов");
	Предупреждение(Строка);	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	url = ЛексКлиент.ПутьHTML(ИмяHTML);

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
	
	ПолученнаяСтрока = Элементы.ХТМЛ.Документ.getElementById("output").tag;
	
	Если Найти(ПолученнаяСтрока, "save") > 0 Тогда
		
		РаскройГотов = Истина;
		Закрыть(ПолученнаяСтрока);
		Возврат;
		
	КонецЕсли;
	
	Роспил = Найти(СтрокаДляФлэш, "%РОСПИЛ%") > 0;
	Лекс = Найти(СтрокаДляФлэш, "%ЛЕКС%") > 0;
	
	РабочийКаталог = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
	Код = "";
	
	Если Роспил Тогда
		
		Код = "ЛоготипРоспил";
		
	ИначеЕсли Лекс Тогда
		
		Код = "ЛоготипЛекс";
		
	КонецЕсли;
	
	ПутьКИзображению = РабочийКаталог + Код + ".jpg";
	ФайлНаДиске = Новый Файл(ПутьКИзображению);
	
	Если ФайлНаДиске.Существует() Тогда
		
		ПутьЛоготипа = ПутьКИзображению;
		
	Иначе
		
		ПутьЛоготипа = "";
		
	КонецЕсли;
	
	ПутьЛоготипа = ЛексКлиентСервер.ПеревестиСтрокуВКодыСимволов(ПутьЛоготипа);
	
	Если Лекс Тогда
		
		СтрокаДляФлэш = СтрЗаменить(СтрокаДляФлэш, "%ЛЕКС%", ПутьЛоготипа);
		
	ИначеЕсли Роспил Тогда
		
		СтрокаДляФлэш = СтрЗаменить(СтрокаДляФлэш, "%РОСПИЛ%", ПутьЛоготипа);
		
	КонецЕсли;
	
	Элементы.ХТМЛ.Документ.getElementById("input").tag = СтрокаДляФлэш;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Отказ = НЕ РаскройГотов;
	
КонецПроцедуры

