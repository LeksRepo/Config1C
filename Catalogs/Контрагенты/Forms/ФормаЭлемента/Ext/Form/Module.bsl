﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьВидимостьФормы();
	
КонецПроцедуры

&НаКлиенте
Функция ОбновитьВидимостьФормы()
	
	Элементы.ГруппаЮридическоеЛицо.Видимость = Объект.ЮридическоеЛицо;
	Элементы.ГруппаФизическоеЛицо.Видимость = НЕ Объект.ЮридическоеЛицо;
	Элементы.ДилерскиеНастройки.Видимость = Объект.Дилер;
	Элементы.Наименование.Доступность = Объект.ЮридическоеЛицо;
	
КонецФункции

&НаКлиенте
Процедура ЮридическоеЛицоПриИзменении(Элемент)
	
	ОбновитьВидимостьФормы();
	
КонецПроцедуры

&НаКлиенте
Функция ПриИзмененииФИО()
	
	Объект.Наименование = Объект.Фамилия +" " +Объект.Имя + " " + Объект.Отчество;
	Объект.ПолноеНаименование = Объект.Наименование;
	
КонецФункции

&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	
	Объект.Фамилия = СокрЛП(Объект.Фамилия);
	ПриИзмененииФИО();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	
	Объект.Имя = СокрЛП(Объект.Имя);
	ПриИзмененииФИО();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	
	Объект.Отчество = СокрЛП(Объект.Отчество);
	ПриИзмененииФИО();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.ТолькоПросмотр = Объект.Ссылка = Справочники.Контрагенты.ЧастноеЛицо;
	
КонецПроцедуры

&НаКлиенте
Процедура ДилерПриИзменении(Элемент)
	
	ОбновитьВидимостьФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Свойство("Файл ") Тогда
		Модифицированность = Истина;
		Объект.Логотип = Параметр.Файл;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьДанныеИзВебСервиса(Код)
	
	Данные = ПолучитьДанныеИзВебСервиса(Число(Код));
	
	ТекстСообщения = Данные.ПолучитьТелоКакСтроку();
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ТекстСообщения);
	ПолученныеДанные = ПрочитатьJSON(ЧтениеJSON);
	
	Если ПолученныеДанные.Свойство("suggestions") И ПолученныеДанные.suggestions.Количество() > 0 Тогда
		
		Данные = ПолученныеДанные.suggestions[0].data;
		 
		ПараметрыФормы = Новый Структура;
		
		ПараметрыФормы.Вставить("Наименование", ?(Данные.Свойство("name"),Данные.name.full + " " + Данные.opf.short, ""));
		ПараметрыФормы.Вставить("ИНН", ?(Данные.Свойство("inn"),Данные.inn, ""));
		ПараметрыФормы.Вставить("КПП", ?(Данные.Свойство("kpp"),Данные.kpp, ""));
		ПараметрыФормы.Вставить("ОГРН", ?(Данные.Свойство("ogrn"),Данные.ogrn, ""));
		ПараметрыФормы.Вставить("ЮридическийАдрес", ?(Данные.Свойство("address"),Данные.address.value, ""));
		ПараметрыФормы.Вставить("ПочтовыйАдрес", ?(Данные.Свойство("address"),Данные.address.value, ""));
		ПараметрыФормы.Вставить("Руководитель", ?(Данные.Свойство("management"),Данные.management.name, ""));
		ПараметрыФормы.Вставить("ПолноеНаименование", ?(Данные.Свойство("name"),Данные.name.full_with_opf, ""));
		
		ПараметрыФормы.Вставить("НаименованиеСтарый", Объект.Наименование);
		ПараметрыФормы.Вставить("ИННСтарый", Объект.ИНН);
		ПараметрыФормы.Вставить("КППСтарый", Объект.КПП);
		ПараметрыФормы.Вставить("ОГРНСтарый", Объект.ОГРН);
		ПараметрыФормы.Вставить("ЮридическийАдресСтарый", Объект.ЮридическийАдрес);
		ПараметрыФормы.Вставить("ПочтовыйАдресСтарый", Объект.ПочтовыйАдрес);
		ПараметрыФормы.Вставить("РуководительСтарый", Объект.Руководитель);
		ПараметрыФормы.Вставить("ПолноеНаименованиеСтарый", Объект.ПолноеНаименование);
	
		НовыеДанные = ОткрытьФормуМодально("Справочник.Контрагенты.Форма.ФормаСравнениеДанных", ПараметрыФормы, ЭтаФорма);
		
		Если НовыеДанные <> Неопределено Тогда		
			
			Если НовыеДанные.Свойство("Наименование") Тогда
				Объект.Наименование = НовыеДанные.Наименование;
			КонецЕсли;	
			
			Если НовыеДанные.Свойство("ИНН") Тогда
				Объект.ИНН = НовыеДанные.ИНН;
			КонецЕсли;
			
			Если НовыеДанные.Свойство("КПП") Тогда	
				Объект.КПП = НовыеДанные.КПП;
			КонецЕсли;	
			
			Если НовыеДанные.Свойство("ОГРН") Тогда
				Объект.ОГРН = НовыеДанные.ОГРН;
			КонецЕсли;
			
			Если НовыеДанные.Свойство("ЮридическийАдрес") Тогда
				Объект.ЮридическийАдрес = НовыеДанные.ЮридическийАдрес;
			КонецЕсли;	
			
			Если НовыеДанные.Свойство("ПочтовыйАдрес") Тогда
				Объект.ПочтовыйАдрес = НовыеДанные.ПочтовыйАдрес;
			КонецЕсли;	
			
			Если НовыеДанные.Свойство("Руководитель") Тогда
				Объект.Руководитель = НовыеДанные.Руководитель;
			КонецЕсли;	
			
			Если НовыеДанные.Свойство("ПолноеНаименование") Тогда
				Объект.ПолноеНаименование = НовыеДанные.ПолноеНаименование;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		Сообщить("Данные контрагента не найдены.");		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДанныеИзВебСервиса(Код)
	
	Токен = "e4b68cbc0fb7f887a245b7fc107850d1903d02bf";
	СоответствиеДанные = Новый Соответствие;
	СоответствиеДанные.Вставить("query", Код);
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить("ACTIVE");
	СоответствиеДанные.Вставить("status", МассивСтатусов);
	Сервер = "suggestions.dadata.ru";
	СтрокаЗапроса = "/suggestions/api/4_1/rs/findById/party";
	Возврат ОтправитьЗапрос(СтрокаЗапроса, СоответствиеДанные, Сервер, Токен);
	
КонецФункции

&НаКлиенте
Функция ОтправитьЗапрос(СтрокаЗапроса, СоответствиеДанные, Сервер, Токен)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, СоответствиеДанные);
	СтрокаДанные = ЗаписьJSON.Закрыть();
	ssl1 = Новый ЗащищенноеСоединениеOpenSSL(
	Новый СертификатКлиентаWindows(СпособВыбораСертификатаWindows.Авто),
	Новый СертификатыУдостоверяющихЦентровWindows());
	HTTPСоединение = Новый HTTPСоединение(Сервер,,,,,,ssl1);
	HTTPЗапрос = Новый HTTPЗапрос(СтрокаЗапроса);
	HTTPЗапрос.Заголовки.Вставить("Content-Type", "application/json");
	HTTPЗапрос.Заголовки.Вставить("Accept", "application/json");
	HTTPЗапрос.Заголовки.Вставить("Authorization", "Token " + Токен);
	HTTPЗапрос.УстановитьТелоИзСтроки(СтрокаДанные, "UTF-8", ИспользованиеByteOrderMark.НеИспользовать);
	
	Попытка
		Результат = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос);
	Исключение
		// исключение здесь говорит о том, что запрос не дошел до HTTP-Сервера
		Сообщить("Произошла сетевая ошибка!");
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	
	Если ЗначениеЗаполнено(Объект.ИНН) Тогда
		 ПерезаполнитьДанныеИзВебСервиса(Объект.ИНН);
	ИначеЕсли ЗначениеЗаполнено(Объект.ОГРН) Тогда 
	     ПерезаполнитьДанныеИзВебСервиса(Объект.ОГРН);
	КонецЕсли;
	
КонецПроцедуры
