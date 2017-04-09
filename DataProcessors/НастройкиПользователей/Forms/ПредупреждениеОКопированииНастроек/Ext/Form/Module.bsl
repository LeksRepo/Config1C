﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СписокАктивныхПользователейНажатие(Элемент)
	
	СтандартныеПодсистемыКлиент.ОткрытьСписокАктивныхПользователей();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Скопировать(Команда)
	
	Если Параметры.Действие <> "СкопироватьИЗакрыть" Тогда
		Закрыть();
	КонецЕсли;
	
	Результат = Новый Структура("Действие", Параметры.Действие);
	Оповестить("СкопироватьНастройкиАктивнымПользователям", Результат);
	
КонецПроцедуры
