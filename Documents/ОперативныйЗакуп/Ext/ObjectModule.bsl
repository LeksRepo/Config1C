﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		ДатаСоздания = ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры

Процедура НеноменклатурныйМатериалЗаполнитьРегистр(Отказ)
	
	НаборЗаписей = РегистрыСведений.ЗаказНеноменклатурногоМатериала.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОперЗакуп.Установить(Ссылка);
	НаборЗаписей.Записать();
	
	Для Каждого Стр ИЗ НеноменклатурныйМатериал Цикл
		
		Если Стр.Заказано Тогда
		
			НаборЗаписей = РегистрыСведений.ЗаказНеноменклатурногоМатериала.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Спецификация.Установить(Стр.Спецификация);
			НаборЗаписей.Отбор.Номенклатура.Установить(Стр.Номенклатура);
			
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество() = 0 Тогда
				
				Запись = НаборЗаписей.Добавить();
				
				Если ЗначениеЗаполнено(Стр.Спецификация) И ЗначениеЗаполнено(Стр.Номенклатура) Тогда
					Запись.Спецификация = Стр.Спецификация;
					Запись.Номенклатура = Стр.Номенклатура;
					Запись.ОперЗакуп = Ссылка;
					Запись.Заказано = Истина;
					НаборЗаписей.Записать();
				Иначе
					Отказ = Истина;
					Сообщить("Не заполнена спецификация для неноменклатурного материала, строка " + Стр.НомерСтроки);
				КонецЕсли;
					
			Иначе			
				
				Запись = НаборЗаписей[0];
				Отказ = Истина;
				Сообщить("Материал: " + Запись.Номенклатура + " уже был заказан в " + Запись.ОперЗакуп);
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	НеноменклатурныйМатериалЗаполнитьРегистр(Отказ);
КонецПроцедуры
