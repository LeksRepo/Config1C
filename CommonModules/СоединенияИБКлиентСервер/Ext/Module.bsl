﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Завершение работы пользователей".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Удаляет все сеансы информационной базы кроме текущего
//
Процедура УдалитьВсеСеансыКромеТекущего(ПараметрыАдминистрирования) Экспорт
	
	НомерТекущегоСеанса = СоединенияИБВызовСервераПовтИсп.ПараметрыОтключенияСеансов().НомерСеансаИнформационнойБазы;
	
	ВсеКромеТекущего = Новый Структура;
	ВсеКромеТекущего.Вставить("Свойство", "Номер");
	ВсеКромеТекущего.Вставить("ВидСравнения", ВидСравнения.НеРавно);
	ВсеКромеТекущего.Вставить("Значение", НомерТекущегоСеанса);
	
	Фильтр = Новый Массив;
	Фильтр.Добавить(ВсеКромеТекущего);

	АдминистрированиеКластераКлиентСервер.УдалитьСеансыИнформационнойБазы(ПараметрыАдминистрирования,, Фильтр);
	
КонецПроцедуры

// Получить строку соединения ИБ, если задан нестандартный порт кластера серверов.
//
// Параметры
//  ПортКластераСерверов  - Число - нестандартный порт кластера серверов
//
// Возвращаемое значение:
//   Строка   - строка соединения ИБ
//
Функция ПолучитьСтрокуСоединенияИнформационнойБазы(Знач ПортКластераСерверов = 0) Экспорт

	Результат = СтрокаСоединенияИнформационнойБазы();
	Если ИнформационнаяБазаФайловая() Или (ПортКластераСерверов = 0) Тогда
		Возврат Результат;
	КонецЕсли;
	
#Если НаКлиенте Тогда
	Если ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер() Тогда
		Возврат Результат;
	КонецЕсли;
#КонецЕсли
	
	ПодстрокиСтрокиСоединения  = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Результат, ";");
	ИмяСервера = СтроковыеФункцииКлиентСервер.СократитьДвойныеКавычки(Сред(ПодстрокиСтрокиСоединения[0], 7));
	ИмяИБ      = СтроковыеФункцииКлиентСервер.СократитьДвойныеКавычки(Сред(ПодстрокиСтрокиСоединения[1], 6));
	Результат  = "Srvr=" + """" + ИмяСервера + 
		?(Найти(ИмяСервера, ":") > 0, "", ":" + Формат(ПортКластераСерверов, "ЧГ=0")) + """;" + 
		"Ref=" + """" + ИмяИБ + """;";
	Возврат Результат;

КонецФункции

// Возвращает полный путь к информационной базе (строку соединения).
//
// Параметры
//  ПризнакФайловогоРежима  - Булево - выходной параметр. Принимает значение 
//                                     Истина, если текущая ИБ - файловая;
//                                     Ложь - если клиент-серверная.
//  ПортКластераСерверов    - Число  - входной параметр. Задается в случае, если
//                                     кластер серверов использует нестандартный номер порта.
//                                     Значение по умолчанию - 0, означает, что 
//                                     кластер серверов занимает номер порта по умолчанию.
//
// Возвращаемое значение:
//   Строка   - строка соединения ИБ.
//
Функция ПутьКИнформационнойБазе(ПризнакФайловогоРежима = Неопределено, Знач ПортКластераСерверов = 0) Экспорт
	
	СтрокаСоединения = ПолучитьСтрокуСоединенияИнформационнойБазы(ПортКластераСерверов);
	
	ПозицияПоиска = Найти(Врег(СтрокаСоединения), "FILE=");
	
	Если ПозицияПоиска = 1 Тогда // файловая ИБ
		
		ПутьКИБ = Сред(СтрокаСоединения, 6, СтрДлина(СтрокаСоединения) - 6);
		ПризнакФайловогоРежима = Истина;
		
	Иначе
		ПризнакФайловогоРежима = Ложь;
		
		ПозицияПоиска = Найти(Врег(СтрокаСоединения), "SRVR=");
		
		Если НЕ (ПозицияПоиска = 1) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПозицияТочкиСЗапятой = Найти(СтрокаСоединения, ";");
		НачальнаяПозицияКопирования = 6 + 1;
		КонечнаяПозицияКопирования = ПозицияТочкиСЗапятой - 2;
		
		ИмяСервера = Сред(СтрокаСоединения, НачальнаяПозицияКопирования, КонечнаяПозицияКопирования - НачальнаяПозицияКопирования + 1);
		
		СтрокаСоединения = Сред(СтрокаСоединения, ПозицияТочкиСЗапятой + 1);
		
		// позиция имени сервера
		ПозицияПоиска = Найти(Врег(СтрокаСоединения), "REF=");
		
		Если НЕ (ПозицияПоиска = 1) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		НачальнаяПозицияКопирования = 6;
		ПозицияТочкиСЗапятой = Найти(СтрокаСоединения, ";");
		КонечнаяПозицияКопирования = ПозицияТочкиСЗапятой - 2;
		
		ИмяИБНаСервере = Сред(СтрокаСоединения, НачальнаяПозицияКопирования, КонечнаяПозицияКопирования - НачальнаяПозицияКопирования + 1);
		
		ПутьКИБ = """" + ИмяСервера + "\" + ИмяИБНаСервере + """";
	КонецЕсли;
	
	Возврат ПутьКИБ;
	
КонецФункции

// Возвращает текстовую константу для формирования сообщений.
// Используется в целях локализации.
//
// Возвращаемое значение:
//	Строка - текст для администратора.
//
Функция ТекстДляАдминистратора() Экспорт
	
	Возврат НСтр("ru = 'Для администратора:'");
	
КонецФункции

// Возвращает пользовательский текст сообщения блокировки сеансов.
//
// Параметры:
//	 Сообщение - Строка - полное сообщение.
// 
// Возвращаемое значение:
//	Строка - сообщение блокировки.
//
Функция ИзвлечьСообщениеБлокировки(Знач Сообщение) Экспорт
	
	ИндексМаркера = Найти(Сообщение, ТекстДляАдминистратора());
	Если ИндексМаркера = 0  Тогда
		Возврат Сообщение;
	ИначеЕсли ИндексМаркера >= 3 Тогда
		Возврат Сред(Сообщение, 1, ИндексМаркера - 3);
	Иначе
		Возврат "";
	КонецЕсли;
		
КонецФункции

// Возвращает строковую константу для формирования сообщений журнала регистрации.
//
// Возвращаемое значение:
//   Строка - наименование события для журнала регистрации.
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Завершение работы пользователей'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

// Возвращает является ли информационная база файловой.
//
// Возвращаемое значение:
//	Булево - Истина, если информационная база файловая.
//
Функция ИнформационнаяБазаФайловая()
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Результат = ОбщегоНазначения.ИнформационнаяБазаФайловая();
#Иначе
	Результат = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
#КонецЕсли
	Возврат Результат;
КонецФункции

#КонецОбласти
