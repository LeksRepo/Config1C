﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Для Каждого Документ Из ПараметрКоманды Цикл
	
		ТабДок = Новый ТабличныйДокумент;
		ПриходныйОрдер(ТабДок, Документ);

		ТабДок.ОтображатьСетку = Ложь;
		ТабДок.Защита = Ложь;
		ТабДок.ТолькоПросмотр = Ложь;
		ТабДок.ОтображатьЗаголовки = Ложь;
		ТабДок.Показать();
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриходныйОрдер(ТабДок, ПараметрКоманды)
	Документы.АвансовыйОтчет.ПриходныйОрдер(ТабДок, ПараметрКоманды);
КонецПроцедуры
