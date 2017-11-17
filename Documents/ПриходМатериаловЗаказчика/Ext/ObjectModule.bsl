﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Спецификация") Тогда
		
		Подразделение = ДанныеЗаполнения.Подразделение;
		Спецификация = ДанныеЗаполнения;
		Документы.ПриходМатериаловЗаказчика.ЗаполнитьМатериалыЗаказчика(ЭтотОбъект.Материалы, Спецификация);
		
	КонецЕсли;
	
	Если РольДоступна("ДобавлениеИзменениеПриходМатериаловЗаказчика") Тогда
		
		Кладовщик = Пользователи.ТекущийПользователь().ФизическоеЛицо;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	ПриходМатериаловЗаказчикаСсылка = Документы.ПриходМатериаловЗаказчика.ПолучитьПриходМатериаловЗаказчика(Спецификация);
	
	Если ЗначениеЗаполнено(ПриходМатериаловЗаказчикаСсылка) И Ссылка <> ПриходМатериаловЗаказчикаСсылка Тогда
		
		Отказ = Истина;
		ТекстСообщения = "К " + Спецификация + " уже введена " + ПриходМатериаловЗаказчикаСсылка;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ПриходМатериаловЗаказчикаСсылка);
		
	КонецЕсли;
	
КонецПроцедуры
