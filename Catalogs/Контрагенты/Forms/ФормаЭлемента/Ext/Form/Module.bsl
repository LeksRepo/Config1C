﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьВидимостьФормы();
	
КонецПроцедуры

&НаКлиенте
Функция ОбновитьВидимостьФормы()
	
	Элементы.ГруппаЮридическоеЛицо.Видимость = Объект.ЮридическоеЛицо;
	Элементы.ГруппаФизическоеЛицо.Видимость = НЕ Объект.ЮридическоеЛицо;
	
	Если Объект.ЮридическоеЛицо Тогда
		Элементы.Наименование.Доступность = Истина;
	Иначе
		Элементы.Наименование.Доступность = Ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ЮридическоеЛицоПриИзменении(Элемент)
	
	ОбновитьВидимостьФормы();
	
КонецПроцедуры

&НаКлиенте
Функция ПриИзмененииФИО()
	
	// { Васильев Александр Леонидович [07.10.2013]
	//Объект.Фамилия = СокрЛП(Объект.Фамилия);
	//Объект.Имя = СокрЛП(Объект.Имя);
	//Объект.Отчество = СокрЛП(Объект.Отчество);
	// теперь попросили ФИО полностью
	
	// } Васильев Александр Леонидович [07.10.2013]
	
	Объект.Наименование = Объект.Фамилия +" " +Объект.Имя + " " + Объект.Отчество;
	Объект.ПолноеНаименование = Объект.Наименование;
	
КонецФункции

&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	
	ПриИзмененииФИО();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	
	ПриИзмененииФИО();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	
	ПриИзмененииФИО();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.ТолькоПросмотр = Объект.Ссылка = Справочники.Контрагенты.ЧастноеЛицо;
	
КонецПроцедуры

