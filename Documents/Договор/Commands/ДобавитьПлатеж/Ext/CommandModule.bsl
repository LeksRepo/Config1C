﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Договор", ПараметрКоманды);
	
	ОткрытьФорму("Обработка.ПомощникПриходаРасходаДенежныхСредств.Форма.Форма", ПараметрыОткрытия);
	
КонецПроцедуры
