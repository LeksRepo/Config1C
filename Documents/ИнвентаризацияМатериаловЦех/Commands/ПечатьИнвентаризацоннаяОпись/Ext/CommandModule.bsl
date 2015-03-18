﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = Новый ТабличныйДокумент;

	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДок.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИнвентаризацияМатериаловЦех_ИНВ3";
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	Печать(ТабДок, ПараметрКоманды);
	ТабДок.Показать("Инвенратризационная опись");
	
КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды)
	Документы.ИнвентаризацияМатериаловЦех.ПечатьИнвентаризационнаяОпись(ТабДок, ПараметрКоманды);
КонецПроцедуры
