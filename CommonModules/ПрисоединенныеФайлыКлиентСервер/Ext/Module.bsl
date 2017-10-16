﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Присоединенные файлы".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события

// См. эту процедуру в модуле ПрисоединенныеФайлы.
// Предназначена для поддержки толстого клиента (вариант клиент-сервер).
//
Процедура ПереопределитьПолучаемуюФормуПрисоединенногоФайла(Источник,
                                                      ВидФормы,
                                                      Параметры,
                                                      ВыбраннаяФорма,
                                                      ДополнительнаяИнформация,
                                                      СтандартнаяОбработка) Экспорт
	
	ПрисоединенныеФайлыСлужебныйВызовСервера.ПереопределитьПолучаемуюФормуПрисоединенногоФайла(
		Источник,
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
		
КонецПроцедуры

#КонецОбласти
