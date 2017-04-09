﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)
	
	// отказываемся от выполнения типового механизма регистрации объектов
	ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	
	// удаляем все узлы, добавленные по авторегистрации, если признак авторегистрации был ошибочно установлен
	ОбменДанными.Получатели.Очистить();
	
	// заполняем свойство УникальныйИдентификаторИсточникаСтрокой из ссылки источника
	Если Количество() > 0 Тогда
		
		Если ЭтотОбъект[0].ОбъектВыгруженПоСсылке = Истина Тогда
			Возврат;
		КонецЕсли;
		
		ЭтотОбъект[0]["УникальныйИдентификаторИсточникаСтрокой"] = Строка(ЭтотОбъект[0]["УникальныйИдентификаторИсточника"].УникальныйИдентификатор());
		
	КонецЕсли;
	
	Если ОбменДанными.Загрузка
		ИЛИ Не ЗначениеЗаполнено(Отбор.УзелИнформационнойБазы.Значение)
		ИЛИ Не ЗначениеЗаполнено(Отбор.УникальныйИдентификаторПриемника.Значение)
		ИЛИ Не ОбщегоНазначения.СсылкаСуществует(Отбор.УзелИнформационнойБазы.Значение) Тогда
		Возврат;
	КонецЕсли;
	
	// набор записей должен регистрироваться только на одном узле, указанном в отборе
	ОбменДанными.Получатели.Добавить(Отбор.УзелИнформационнойБазы.Значение);
	
КонецПроцедуры




#КонецЕсли