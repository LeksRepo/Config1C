﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = Новый ТабличныйДокумент;
	ПечатьПеремещениеМатериалов(ТабДок, ПараметрКоманды);

	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать();
	
КонецПроцедуры

&НаСервере
Процедура ПечатьПеремещениеМатериалов(ТабДок, ПараметрКоманды)
	
	Документы.ПеремещениеМатериалов.ПечатьПеремещениеМатериалов(ТабДок, ПараметрКоманды);
	
КонецПроцедуры
