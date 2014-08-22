﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РабочийКаталог = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Код = СокрЛП(Элементы.Список.ТекущиеДанные.Код);
	
	ИмяФайла = РабочийКаталог + "Изделие" + Код;
	ФайлИзображения = Новый Файл(ИмяФайла);
	Если ФайлИзображения.Существует() Тогда
		АдресКартинки  = ИмяФайла;
	Иначе
		ИмяФайла = РабочийКаталог + "Изделие" + ПредопределенноеЗначение("Перечисление.ВидыПрисоединенныхФайлов.КартинкаПравая") + Код;
		ФайлИзображения = Новый Файл(ИмяФайла);
		Если ФайлИзображения.Существует() Тогда
			АдресКартинки  = ИмяФайла;
		Иначе
			ИмяФайла = РабочийКаталог + "Изделие" + ПредопределенноеЗначение("Перечисление.ВидыПрисоединенныхФайлов.КартинкаЛевая") + Код;
			ФайлИзображения = Новый Файл(ИмяФайла);
			Если ФайлИзображения.Существует() Тогда
				АдресКартинки  = ИмяФайла;
			Иначе
				АдресКартинки  = "";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
