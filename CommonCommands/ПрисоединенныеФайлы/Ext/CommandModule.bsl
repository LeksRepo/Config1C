﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Параметры = Новый Структура;
	Параметры.Вставить("ВладелецФайла", ПараметрКоманды);
	Заголовок = НСтр("ru = 'Присоединенные файлы'");
	Параметры.Вставить("ЗаголовокФормы", Заголовок);
	
	ОткрытьФорму(
		"Справочник.Файлы.Форма.ФормаСпискаПрисоединенныхФайлов", 
		Параметры,
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно);
		
КонецПроцедуры
