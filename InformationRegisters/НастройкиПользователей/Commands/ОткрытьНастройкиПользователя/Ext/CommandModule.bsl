﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("Пользователь", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.НастройкиПользователей.Форма.ФормаНастройкиПользователя", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры // ОбработкаКоманды() 
