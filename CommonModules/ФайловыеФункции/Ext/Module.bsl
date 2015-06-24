﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Файловые функции".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает максимальный размер файла.
Функция МаксимальныйРазмерФайла() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	//RonEXI: Установил максимальный размер файла 1GB
	
	МаксимальныйРазмерФайла = 1024*1024*1024; // 1GB 
	
	//МаксимальныйРазмерФайла = Константы.МаксимальныйРазмерФайла.Получить();
	//
	//Если МаксимальныйРазмерФайла = Неопределено
	// ИЛИ МаксимальныйРазмерФайла = 0 Тогда
	//	
	//	МаксимальныйРазмерФайла = 50*1024*1024; // 50 мб
	//	Константы.МаксимальныйРазмерФайла.Установить(МаксимальныйРазмерФайла);
	//КонецЕсли;
	//
	//Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
	//   И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
	//	
	//	МаксимальныйРазмерФайлаОбластиДанных =
	//		Константы.МаксимальныйРазмерФайлаОбластиДанных.Получить();
	//	
	//	Если МаксимальныйРазмерФайлаОбластиДанных = Неопределено
	//	 ИЛИ МаксимальныйРазмерФайлаОбластиДанных = 0 Тогда
	//		
	//		МаксимальныйРазмерФайлаОбластиДанных = 50*1024*1024; // 50 мб
	//		
	//		Константы.МаксимальныйРазмерФайлаОбластиДанных.Установить(
	//			МаксимальныйРазмерФайлаОбластиДанных);
	//	КонецЕсли;
	//	
	//	МаксимальныйРазмерФайла = Мин(МаксимальныйРазмерФайла, МаксимальныйРазмерФайлаОбластиДанных);
	//КонецЕсли;
	
	Возврат МаксимальныйРазмерФайла;
	
КонецФункции

// Возвращает максимальный размер файла провайдера.
Функция МаксимальныйРазмерФайлаОбщий() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	//RonEXI: Установил максимальный размер файла 1GB
	
	МаксимальныйРазмерФайла = 1024*1024*1024; // 1GB 
	
	//МаксимальныйРазмерФайла = Константы.МаксимальныйРазмерФайла.Получить();
	//
	//Если МаксимальныйРазмерФайла = Неопределено
	// ИЛИ МаксимальныйРазмерФайла = 0 Тогда
	//	
	//	МаксимальныйРазмерФайла = 50*1024*1024; // 50 мб
	//	Константы.МаксимальныйРазмерФайла.Установить(МаксимальныйРазмерФайла);
	//КонецЕсли;
	
	Возврат МаксимальныйРазмерФайла;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с томами файлов

// Есть ли хоть один том хранения файлов.
Функция ЕстьТомаХраненияФайлов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ТомаХраненияФайлов КАК ТомаХраненияФайлов
	|ГДЕ
	|	ТомаХраненияФайлов.ПометкаУдаления = ЛОЖЬ";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

