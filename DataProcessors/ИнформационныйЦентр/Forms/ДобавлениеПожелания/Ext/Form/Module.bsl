﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Получение логина (для модели сервиса) текущего пользователя
	УстановитьПривилегированныйРежим(Истина);
	Логин = Строка(ПараметрыСеанса.ТекущийПользователь.ИдентификаторПользователяСервиса);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Отправить(Команда)
	
	Если ПустаяСтрока(Содержание.ПолучитьТекст()) Тогда 
		Предупреждение(НСтр("ru = 'Предложение не может быть пустым'"));
		Возврат;
	КонецЕсли;
	
	РезультатОтправки = ОтправитьПожелание();
	Если Не РезультатОтправки Тогда 
		Предупреждение(НСтр("ru = 'К сожалению не получилось отправить Ваше предложение.
		|Попробуйте выполнить эту операцию позже.'"));
		Возврат;
	Иначе
		Предупреждение(НСтр("ru = 'Ваше предложение будет рассмотрено. Спасибо, что делаете наш сервис лучше.'"));
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ОтправитьПожелание()
	
	Попытка
		Прокси = ИнформационныйЦентрСервер.ПолучитьПроксиИнформационногоЦентра_1_0_1_2();
		СообщениеПользователя = ПривестиКОбъектуXDTOСообщениеПользователя(Прокси.ФабрикаXDTO);
		Возврат Прокси.AddUserMessage(СообщениеПользователя);
	Исключение
		ИмяСобытия = ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

&НаСервере
Функция ПривестиКОбъектуXDTOСообщениеПользователя(ФабрикаXDTOВебСервиса)
	
	ТипСообщения = ФабрикаXDTOВебСервиса.Тип("http://www.1c.ru/SaaS/1.0/XMLSchema/ManageInfoCenter_1_0_1_2", "UserMessage");
	ОписаниеСообщения = ФабрикаXDTOВебСервиса.Создать(ТипСообщения);
	
	ОписаниеСообщения.Content  = ПолучитьСодержаниеСообщенияПользователя(ФабрикаXDTOВебСервиса);
	ОписаниеСообщения.Date     = ТекущаяДата(); // Проектное решение БСП
	ОписаниеСообщения.Author   = Логин;
	УстановитьПривилегированныйРежим(Истина);
	ОписаниеСообщения.DataArea = ОбщегоНазначения.ЗначениеРазделителяСеанса();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ОписаниеСообщения;
	
КонецФункции

&НаСервере
Функция ПолучитьСодержаниеСообщенияПользователя(ФабрикаXDTOВебСервиса)
	
	ТипСодержания      = ФабрикаXDTOВебСервиса.Тип("http://www.1c.ru/SaaS/1.0/XMLSchema/ManageInfoCenter_1_0_1_2", "HTMLContent");
	ОписаниеСодержания = ФабрикаXDTOВебСервиса.Создать(ТипСодержания);
	
	СписокВложений = Неопределено;
	ТекстHTML      = Неопределено;
	Содержание.ПолучитьHTML(ТекстHTML, СписокВложений);
	
	ОписаниеСодержания.Files    = ПривестиСписокФайловСодержанияСообщенияПользователя(СписокВложений, ФабрикаXDTOВебСервиса);
	ОписаниеСодержания.TextHTML = ТекстHTML;
	
	Возврат ОписаниеСодержания;
	
КонецФункции

&НаСервере
Функция ПривестиСписокФайловСодержанияСообщенияПользователя(СписокВложений, ФабрикаXDTOВебСервиса)
	
	ТипСпискаКартинок    = ФабрикаXDTOВебСервиса.Тип("http://www.1c.ru/SaaS/1.0/XMLSchema/ManageInfoCenter_1_0_1_2", "FileList");
	ТипСтруктурыКартинки = ФабрикаXDTOВебСервиса.Тип("http://www.1c.ru/SaaS/1.0/XMLSchema/ManageInfoCenter_1_0_1_2", "FileListElement");
	
	СписокКартинок = ФабрикаXDTOВебСервиса.Создать(ТипСпискаКартинок);
	
	Если СписокВложений.Количество() = 0 Тогда 
		Возврат СписокКартинок;
	КонецЕсли;
	
	Для каждого Вложение из СписокВложений Цикл
		
		СтруктураКартинки = ФабрикаXDTOВебСервиса.Создать(ТипСтруктурыКартинки);
		СтруктураКартинки.FullName = Вложение.Ключ;
		СтруктураКартинки.BinData  = Вложение.Значение.ПолучитьДвоичныеДанные();
		
		СписокКартинок.Files.Добавить(СтруктураКартинки);
		
	КонецЦикла;
	
	Возврат СписокКартинок;
	
КонецФункции
