﻿
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		
		Отказ = Истина;
		
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Запрещено добавлять новые элементы";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры
