﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Обработка.ПанельАдминистрированияБСП.Форма.СинхронизацияДанных",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.ПанельАдминистрированияБСП.Форма.СинхронизацияДанных" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
