﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление версии ИБ".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Проверить необходимость обновления информационной базы при смене версии конфигурации.
//
Функция НеобходимоОбновлениеИнформационнойБазы() Экспорт
	
	Возврат ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы();
	
КонецФункции

// Только для внутреннего использования.
Функция МинимальнаяВерсияИБ() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		МодульОбновлениеИнформационнойБазыСлужебныйВМоделиСервиса = ОбщегоНазначенияКлиентСервер.ОбщийМодуль(
			"ОбновлениеИнформационнойБазыСлужебныйВМоделиСервиса");
		
		МинимальнаяВерсияОбластейДанных = МодульОбновлениеИнформационнойБазыСлужебныйВМоделиСервиса.МинимальнаяВерсияОбластейДанных();
	Иначе
		МинимальнаяВерсияОбластейДанных = Неопределено;
	КонецЕсли;
	
	ВерсияИБ = ОбновлениеИнформационнойБазы.ВерсияИБ(Метаданные.Имя);
	
	Если МинимальнаяВерсияОбластейДанных = Неопределено Тогда
		МинимальнаяВерсияИБ = ВерсияИБ;
	Иначе
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияИБ, МинимальнаяВерсияОбластейДанных) > 0 Тогда
			МинимальнаяВерсияИБ = МинимальнаяВерсияОбластейДанных;
		Иначе
			МинимальнаяВерсияИБ = ВерсияИБ;
		КонецЕсли;
	КонецЕсли;
	
	Возврат МинимальнаяВерсияИБ;
	
КонецФункции

// Только для внутреннего использования.
Функция ПараметрыРаботыПрограммы(ИмяКонстанты) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = Константы[ИмяКонстанты].Получить().Получить();
	
	Если ТипЗнч(Параметры) <> Тип("Структура") Тогда
		Параметры = Новый Структура;
		Константы[ИмяКонстанты].Установить(Новый ХранилищеЗначения(Параметры));
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(Параметры);
	
КонецФункции
