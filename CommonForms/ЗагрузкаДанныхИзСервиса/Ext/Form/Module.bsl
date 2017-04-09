﻿///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОткрытьФормуАктивныхПользователей(Элемент)
	
	ОткрытьФорму("Обработка.АктивныеПользователи.Форма.ФормаСпискаАктивныхПользователей");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Загрузить(Команда)
	
	АдресХранилища = "";
	Если ПоместитьФайл(АдресХранилища, "data_dump.zip") Тогда
		
		Состояние(
			НСтр("ru = 'Выполняется загрузка данных из сервиса.
                  |Операция может занять продолжительное время, пожалуйста, подождите...'"),
		);
		
		ВыполнитьЗагрузку(АдресХранилища, ЗагружатьИнформациюОПользователях);
		ПрекратитьРаботуСистемы(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Процедура ВыполнитьЗагрузку(Знач АдресФайла, Знач ЗагружатьИнформацияОПользователях)
	
	ДанныеАрхива = ПолучитьИзВременногоХранилища(АдресФайла);
	ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
	ДанныеАрхива.Записать(ИмяАрхива);
	ДанныеАрхива = Неопределено;
	
	ВыгрузкаЗагрузкаДанных.ЗагрузитьТекущуюОбластьИзАрхива(ИмяАрхива, ЗагружатьИнформацияОПользователях);
	
	Попытка
		УдалитьФайлы(ИмяАрхива);
	Исключение
		// Дополнительная обработка не требуется, возможно возникновение исключения при удалении временного файла
	КонецПопытки;
	
КонецПроцедуры



