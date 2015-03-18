﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДок.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИнвентаризацияМатериаловЦех_ИНВ19";
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ПечатьСличительнаяВедомость(ТабДок, ПараметрКоманды);
	ТабДок.Показать("Сличительная ведомость");
	
КонецПроцедуры

&НаСервере
Процедура ПечатьСличительнаяВедомость(ТабДок, ПараметрКоманды)
	
	Документы.ИнвентаризацияМатериаловЦех.ПечатьСличительнаяВедомость(ТабДок, ПараметрКоманды, Ложь);
	
КонецПроцедуры
