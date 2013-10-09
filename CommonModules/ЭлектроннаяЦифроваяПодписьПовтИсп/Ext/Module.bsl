﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная цифровая подпись"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает путь модуля криптографии для текущего компьютера
//
Функция ПутьМодуляКриптографии() Экспорт
	
	ТипПлатформыСервера = ОбщегоНазначенияПовтИсп.ТипПлатформыСервера();
	
	Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
		Возврат ""; // в Windows путь модуля криптографии не нужен
	КонецЕсли;
	
	ИмяКомпьютера = ИмяКомпьютера();
	ПутьМодуля = "";
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Подготовить структуру отбора по измерениям
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ИмяКомпьютера", ИмяКомпьютера);
	
	// Получить структуру с данными ресурсов записи
	СтруктураРесурсов = РегистрыСведений.ПутиМодулейКриптографииСерверовLinux.Получить(СтруктураОтбора);
	
	// Получить путь из регистра
	ПутьМодуля = СтруктураРесурсов.ПутьМодуляКриптографии;
	
	Возврат ПутьМодуля;
	
КонецФункции
