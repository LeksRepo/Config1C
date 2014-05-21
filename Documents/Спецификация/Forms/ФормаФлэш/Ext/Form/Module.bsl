﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Свойство("СпецификацияСсылка") Тогда
		СпецификацияСсылка 	= Параметры.СпецификацияСсылка;
	КонецЕсли;
	
	ХранимыйФайлФлэш 	= Параметры.ХранимыйФайл;
	
	Если ХранимыйФайлФлэш = "Раскрой" Тогда
		
		ИмяHTML 			= ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.РаскройHtml);
		СтрокаДляФлэш 	= Параметры.СтрокаРаскрояЛДСП;
		
	ИначеЕсли ХранимыйФайлФлэш = "КривойПил" Тогда
		
		ИмяHTML 			= ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.КривойПилHtml);
		СтрокаДляФлэш 	= Параметры.СтрокаКривогоПила;
		
	//ИначеЕсли ХранимыйФайлФлэш = "РаскройСтекла" Тогда
	//	
	//	ИмяHTML 			= ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.РаскройСтеклаHTML);
	//	СтрокаДляФлэш 	= Параметры.СтрокаРаскрояСтекла;
	//	
	ИначеЕсли ХранимыйФайлФлэш = "НовыйРаскрой" Тогда
		
		ИмяHTML 			= ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.НовыйРаскройHtml);
		СтрокаДляФлэш 	= Параметры.СтрокаНовогоРаскрояЛДСП;
		
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
	
	//ПолученнаяСтрока = Элементы.ХТМЛ.Документ.getElementById("output").tag;
	
	Роспил 	= Найти(СтрокаДляФлэш, "37*1056*1054*1057*1055*1048*1051*37*") > 0;
	Лекс 		= Найти(СтрокаДляФлэш, "37*1051*1045*1050*1057*37*") > 0;
	
	РабочийКаталог 	= ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
	Код 					= "";
	
	Если Роспил Тогда
		
		Код = "ЛоготипРоспил";
		
	ИначеЕсли Лекс Тогда
		
		Код = "ЛоготипЛекс";
		
	КонецЕсли;
	
	ПутьКИзображению 	= РабочийКаталог + Код + ".jpg";
	ФайлНаДиске 			= Новый Файл(ПутьКИзображению);
	
	Если ФайлНаДиске.Существует() Тогда
		
		ПутьЛоготипа = ПутьКИзображению;
		
	Иначе
		
		ПутьЛоготипа = "";
		
	КонецЕсли;
	
	ПутьЛоготипа = ЛексКлиентСервер.ПеревестиСтрокуВКодыСимволов(ПутьЛоготипа);
	
	Если Лекс Тогда
		
		СтрокаДляФлэш = СтрЗаменить(СтрокаДляФлэш, "37*1051*1045*1050*1057*37*", ПутьЛоготипа);
		
	ИначеЕсли Роспил Тогда
		
		СтрокаДляФлэш = СтрЗаменить(СтрокаДляФлэш, "37*1056*1054*1057*1055*1048*1051*37*", ПутьЛоготипа);
		
	КонецЕсли;
		
	Элементы.ХТМЛ.Документ.getElementById("mylink").tag = СтрокаДляФлэш;
	
	//Элементы.ХТМЛ.Документ.getElementById("input").tag = СтрокаДляФлэш;
	
КонецПроцедуры
