﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)
	
	// Запрещаем изменять набор записей для неразделенных узлов из разделенного режима
	ОбменДаннымиСервер.ВыполнитьКонтрольЗаписиНеразделенныхДанных(Отбор.Узел.Значение);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаНабора Из ЭтотОбъект Цикл
		
		// Сбрасываем значение пароля, если не установлен признак хранения пароля в ИБ
		Если Не СтрокаНабора.WSЗапомнитьПароль Тогда
			
			СтрокаНабора.WSПароль = "";
			
		КонецЕсли;
		
		// Удаляем незначащие символы (пробелы) слева и справа для строковых параметров
		СокрЛПЗначениеПоля(СтрокаНабора, "COMИмяИнформационнойБазыНаСервере1СПредприятия");
		СокрЛПЗначениеПоля(СтрокаНабора, "COMИмяПользователя");
		СокрЛПЗначениеПоля(СтрокаНабора, "COMИмяСервера1СПредприятия");
		СокрЛПЗначениеПоля(СтрокаНабора, "COMКаталогИнформационнойБазы");
		СокрЛПЗначениеПоля(СтрокаНабора, "COMПарольПользователя");
		СокрЛПЗначениеПоля(СтрокаНабора, "FILEКаталогОбменаИнформацией");
		СокрЛПЗначениеПоля(СтрокаНабора, "FTPСоединениеПароль");
		СокрЛПЗначениеПоля(СтрокаНабора, "FTPСоединениеПользователь");
		СокрЛПЗначениеПоля(СтрокаНабора, "FTPСоединениеПуть");
		СокрЛПЗначениеПоля(СтрокаНабора, "WSURLВебСервиса");
		СокрЛПЗначениеПоля(СтрокаНабора, "WSИмяПользователя");
		СокрЛПЗначениеПоля(СтрокаНабора, "WSПароль");
		СокрЛПЗначениеПоля(СтрокаНабора, "ПарольАрхиваСообщенияОбмена");
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// обновляем кэш платформы для зачитывания актуальных настроек транспорта
	// сообщений обмена процедурой ОбменДаннымиПовтИсп.ПолучитьСтруктуруНастроекОбмена
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура СокрЛПЗначениеПоля(Запись, Знач Поле)
	
	Запись[Поле] = СокрЛП(Запись[Поле]);
	
КонецПроцедуры

#КонецЕсли

