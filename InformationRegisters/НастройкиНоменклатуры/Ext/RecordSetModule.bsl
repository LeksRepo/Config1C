﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.Номенклатура.ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Услуга Тогда
			
			Запись.ОкруглятьДоЛистов = Ложь;
			Запись.АдресХранения = "";
			Запись.ЗакупОптом = Ложь;
			Запись.МожетПредоставитьЗаказчик = Ложь;
			Запись.ОсновнаяПоСкладу = Неопределено;
			Запись.ПодЗаказ = Ложь;
			Запись.Поставщик = Неопределено;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
