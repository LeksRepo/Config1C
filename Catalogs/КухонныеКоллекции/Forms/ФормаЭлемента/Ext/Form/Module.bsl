﻿
&НаКлиенте
Процедура СписокЦентрШиринаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьРедакторФормул(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокЦентрГлубинаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьРедакторФормул(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокЦентрКоличествоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьРедакторФормул(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРедакторФормул(Элемент)
	
	ПараметрыФормы = Новый Структура("Формула, ИмяПеременной, Режим", Элемент.ТекстРедактирования, Элемент.Имя, "Коллекция");
	Форма = ПолучитьФорму("ОбщаяФорма.РедакторФормул", ПараметрыФормы, Элемент);
	Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Форма.Открыть();
	
КонецПроцедуры
