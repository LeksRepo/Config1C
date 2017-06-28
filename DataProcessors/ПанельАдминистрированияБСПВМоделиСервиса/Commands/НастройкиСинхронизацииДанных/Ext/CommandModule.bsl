﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ДоступноИспользованиеРазделенныхДанных Тогда
		
		ОткрытьФорму(
			"Обработка.ПанельАдминистрированияБСПВМоделиСервиса.Форма.СинхронизацияДанныхДляАдминистратораАбонента",
			Новый Структура,
			ПараметрыВыполненияКоманды.Источник,
			"Обработка.ПанельАдминистрированияБСПВМоделиСервиса.Форма.СинхронизацияДанныхДляАдминистратораАбонента" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
			ПараметрыВыполненияКоманды.Окно);
		
	Иначе
		ОткрытьФорму(
			"Обработка.ПанельАдминистрированияБСПВМоделиСервиса.Форма.СинхронизацияДанныхДляАдминистратораСервиса",
			Новый Структура,
			ПараметрыВыполненияКоманды.Источник,
			"Обработка.ПанельАдминистрированияБСПВМоделиСервиса.Форма.СинхронизацияДанныхДляАдминистратораСервиса" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
			ПараметрыВыполненияКоманды.Окно);
		
	КонецЕсли;
	
КонецПроцедуры
