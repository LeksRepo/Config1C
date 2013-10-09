﻿
&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Подразделение", Подразделение);
	ПараметрыОтчета.Вставить("ПериодОтчета", ПериодОтчета);
	ПараметрыОтчета.Вставить("ПоЦеху", ПоЦеху);
	ПараметрыОтчета.Вставить("ГруппаНоменклатуры", ГруппаНоменклатуры);
	
	ТабДок = Отчеты.СкладскаяВедомость.СформироватьОтчет(ПараметрыОтчета);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	СвойствоПодразделение = ПланыВидовХарактеристик.НастройкиПользователей.Подразделение;
	Отбор = Новый Структура("Пользователь, Настройка", Пользователь , СвойствоПодразделение);
	
	Подразделение = РегистрыСведений.НастройкиПользователей.Получить(Отбор).Значение;
	
	ПериодОтчета = Новый СтандартныйПериод(ВариантСтандартногоПериода.ЭтотМесяц);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцВперед(Команда)
	
	ИзменитьМесяц(1);
	СформироватьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНазад(Команда)
	
	ИзменитьМесяц(-1);
	СформироватьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Функция ИзменитьМесяц(Куда)
	
	ПрошлаяДата = ДобавитьМесяц(ПериодОтчета.ДатаНачала, Куда);
	ПериодОтчета.ДатаНачала = НачалоМесяца(ПрошлаяДата);
	ПериодОтчета.ДатаОкончания = КонецМесяца(ПрошлаяДата);
	
КонецФункции
