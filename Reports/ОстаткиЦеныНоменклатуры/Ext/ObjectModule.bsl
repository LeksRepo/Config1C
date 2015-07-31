﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
   УстановитьПривилегированныйРежим(Истина);	
	
   Параметры = КомпоновщикНастроек.Настройки.ПараметрыДанных;
   
   Если НЕ ПараметрыСеанса.ТекущийВнешнийПользователь = Справочники.ВнешниеПользователи.ПустаяСсылка() Тогда
	   
	    Параметры.УстановитьЗначениеПараметра("ЭтоДилер", Истина);		
	Иначе
		Параметры.УстановитьЗначениеПараметра("ЭтоДилер", Ложь);
   		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры
