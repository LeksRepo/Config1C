﻿
&НаКлиенте
Процедура ФормулаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьРедакторФормул(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРедакторФормул(Элемент)
	
	ПараметрыФормы = Новый Структура("Формула, ИмяПеременной, Режим", Элемент.ТекстРедактирования, Элемент.Имя, "ВидОплаты");
	Форма = ПолучитьФорму("ОбщаяФорма.РедакторФормул", ПараметрыФормы, Элемент);
	Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Форма.Открыть();
	
КонецПроцедуры
