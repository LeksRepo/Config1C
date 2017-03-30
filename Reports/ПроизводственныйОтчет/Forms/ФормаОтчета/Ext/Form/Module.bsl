﻿
&НаКлиенте
Процедура Сформировать(Команда)
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		СформироватьНаСервере();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Укажите подразделение",, "Подразделение");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	ТабДок = Новый ТабличныйДокумент;
	Массив = Новый Массив;
	Отчеты.ПроизводственныйОтчет.ВывестиПроизводственныйОтчет(ТабДок, Подразделение, Массив);
	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	ОткрытьЗначение(Расшифровка);
КонецПроцедуры
