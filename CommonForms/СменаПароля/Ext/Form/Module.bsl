﻿
&НаКлиенте
Процедура СменитьПароль(Команда)
	
	Если НовыйПароль <> НовыйПарольПодтверждение Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("'Новый пароль' и 'Подтверждение' не совпадают",, "НовыйПарольПодтверждение");
		
	Иначе
		
		Если НовыйПароль = "" Тогда
			
			Режим = РежимДиалогаВопрос.ДаНет;
			Ответ = Вопрос("Вы уверены что хотите оставить пароль пустым?", Режим, 0);
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		УстановитьНовыйПароль(НовыйПароль);
		ПоказатьОповещениеПользователя("Пароль пользователя изменен");
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ТекущийПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ТекущийПользователь.ИдентификаторПользователяИБ);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УстановитьНовыйПароль(Пароль)
	
	ТекущийПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	ТекущийПользовательИБ.Пароль = Пароль;
	ТекущийПользовательИБ.Записать();
	
КонецФункции // ПолучитьТекущегоПользователя()
