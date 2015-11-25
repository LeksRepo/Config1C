﻿&НаКлиенте
Процедура ФормулаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура("Формула, ИмяПеременной, Режим", Элемент.ТекстРедактирования, Элемент.Имя, "СхемаЯщика");
	Форма = ПолучитьФорму("ОбщаяФорма.РедакторФомул", ПараметрыФормы, Элемент);
	Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Форма.Открыть();

КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборНоменклатуры(Значение)
	
	ПараметрыОтбора = Новый Структура;
    ПараметрыОтбора.Вставить("ПолеВыбора", Значение);
    Элементы.НоменклатурныеГруппы.ОтборСтрок = Новый ФиксированнаяСтруктура(ПараметрыОтбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНомГруппыПриИзменении(Элемент)
	
	Элементы.НоменклатурныеГруппыМатериал.Видимость = (ОтборНомГруппы = "ЯщикКромка" ИЛИ ОтборНомГруппы = "ФасадКромка");	
	УстановитьОтборНоменклатуры(ОтборНомГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатурныеГруппыГруппаПриИзменении(Элемент)
	Элементы.НоменклатурныеГруппы.ТекущиеДанные.ПолеВыбора = ОтборНомГруппы;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтборНомГруппы = "Направляющие";
	Элементы.НоменклатурныеГруппыМатериал.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьОтборНоменклатуры(ОтборНомГруппы);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОтверстия(Команда)
	
	Данные = Элементы.Детали.ТекущиеДанные;
	
	Структура = Новый Структура;
	Структура.Вставить("ТаблицаОтверстий", Данные.СтруктураОтверстий);
	Структура.Вставить("Обновлять", Ложь);
	
	АдресСтруктурыОтверстий = ОткрытьФормуМодально("ОбщаяФорма.ФормаРедактораОтверстий", Структура, ЭтаФорма);
	Если АдресСтруктурыОтверстий <> Неопределено Тогда
		Данные.СтруктураОтверстий = АдресСтруктурыОтверстий;
	КонецЕсли;
	
КонецПроцедуры
