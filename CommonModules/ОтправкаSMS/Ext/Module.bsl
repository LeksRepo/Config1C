﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Отправка SMS"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Отправляет SMS через настроенного поставщика услуги, возвращает идентификатор сообщения.
//
// Параметры:
//  НомераПолучателей  - Массив - массив строк номеров получателей в формате +7ХХХХХХХХХХ;
//  Текст              - Строка - текст сообщения, максимальная длина у операторов может быть разной;
//  ИмяОтправителя     - Строка - имя отправителя, которое будет отображаться вместо номера у получателей.
//  ПеревестиВТранслит - Булево - Истина, если требуется переводить текст сообщения в транслит перед отправкой.
//
// Возвращаемое значение:
//  Структура: ОтправленныеСообщения - Массив структур: НомерПолучателя
//                                                  ИдентификаторСообщения
//             ОписаниеОшибки        - Строка - пользовательское представление ошибки, если пустая строка,
//                                          то ошибки нет.
Функция ОтправитьSMS(НомераПолучателей, Знач Текст, ИмяОтправителя = "", ПеревестиВТранслит = Ложь) Экспорт
	
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	Если ПеревестиВТранслит Тогда
		Текст = СтрокаЛатиницей(Текст);
	КонецЕсли;
	
	Если Не НастройкаОтправкиSMSВыполнена() Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Неверно заданы настройки провайдера для отправки SMS.'");
		Возврат Результат;
	КонецЕсли;
	
	НастройкиОтправкиSMS = НастройкиОтправкиSMS();
	
	Если НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.МТС Тогда // МТС
		Результат = ОтправкаSMSЧерезМТС.ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя,
			НастройкиОтправкиSMS.Логин, НастройкиОтправкиSMS.Пароль);
	ИначеЕсли НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.Билайн Тогда // Билайн
		Результат = ОтправкаSMSЧерезБилайн.ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя,
			НастройкиОтправкиSMS.Логин, НастройкиОтправкиSMS.Пароль);
	ИначеЕсли ЗначениеЗаполнено(НастройкиОтправкиSMS.Провайдер) Тогда // Другой
		ПараметрыОтправки = Новый Структура;
		ПараметрыОтправки.Вставить("НомераПолучателей", НомераПолучателей);
		ПараметрыОтправки.Вставить("Текст", Текст);
		ПараметрыОтправки.Вставить("ИмяОтправителя", ИмяОтправителя);
		ПараметрыОтправки.Вставить("Логин", НастройкиОтправкиSMS.Логин);
		ПараметрыОтправки.Вставить("Пароль", НастройкиОтправкиSMS.Пароль);
		ПараметрыОтправки.Вставить("Провайдер", НастройкиОтправкиSMS.Провайдер);
		
		ОтправкаSMSПереопределяемый.ОтправитьSMS(ПараметрыОтправки, Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Запрашивает статус доставки сообщения у поставщика услуг.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный SMS при отправке;
//
// Возвращаемое значение:
//  Строка - статус доставки сообщения, который вернул поставщик услуг:
//           "НеОтправлялось" - сообщение еще не было обработано поставщиком услуг (в очереди);
//           "Отправляется"   - сообщение стоит в очереди на отправку у провайдера;
//           "Отправлено"     - сообщение отправлено, ожидается подтверждение о доставке;
//           "НеОтправлено"   - сообщение не отправлено (недостаточно средств на счете, перегружена сеть оператора);
//           "Доставлено"     - сообщение доставлено адресату;
//           "НеДоставлено"   - сообщение не удалось доставить (абонент недоступен, время ожидания подтверждения доставки от абонента истекло);
//           "Ошибка"         - не удалось получить статус у поставщика услуг (статус неизвестен).
//
Функция СтатусДоставки(ИдентификаторСообщения) Экспорт
	
	Если ПустаяСтрока(ИдентификаторСообщения) Тогда
		Возврат "НеОтправлялось";
	КонецЕсли;
	
	Результат = Неопределено;
	НастройкиОтправкиSMS = НастройкиОтправкиSMS();
	
	Если НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.МТС Тогда
		Результат = ОтправкаSMSЧерезМТС.СтатусДоставки(ИдентификаторСообщения,
												  НастройкиОтправкиSMS.Логин,
												  НастройкиОтправкиSMS.Пароль);
	ИначеЕсли НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.Билайн Тогда
		Результат = ОтправкаSMSЧерезБилайн.СтатусДоставки(ИдентификаторСообщения,
													 НастройкиОтправкиSMS.Логин,
													 НастройкиОтправкиSMS.Пароль);
	ИначеЕсли ЗначениеЗаполнено(НастройкиОтправкиSMS.Провайдер) Тогда
		ОтправкаSMSПереопределяемый.СтатусДоставки(ИдентификаторСообщения, НастройкиОтправкиSMS.Провайдер,
			НастройкиОтправкиSMS.Логин, НастройкиОтправкиSMS.Пароль, Результат);
	Иначе // провайдер не выбран
		Результат = "Ошибка";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет правильность сохраненных настроек отправки SMS.
Функция НастройкаОтправкиSMSВыполнена() Экспорт
	
	Результат = Истина;
	
	НастройкиОтправкиSMS = НастройкиОтправкиSMS();
	Провайдер = НастройкиОтправкиSMS.Провайдер;
	Если Провайдер = Перечисления.ПровайдерыSMS.МТС Или Провайдер = Перечисления.ПровайдерыSMS.Билайн Тогда
		Результат = Не ПустаяСтрока(НастройкиОтправкиSMS.Логин) И Не ПустаяСтрока(НастройкиОтправкиSMS.Пароль);
	ИначеЕсли ЗначениеЗаполнено(НастройкиОтправкиSMS.Провайдер) Тогда
		Отказ = Ложь;
		ОтправкаSMSПереопределяемый.ПриПроверкеНастроекОтправкиSMS(НастройкиОтправкиSMS, Отказ);
		Результат = Не Отказ;
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция НастройкиОтправкиSMS()
	Результат = Новый Структура;
	Результат.Вставить("Логин", Константы.ЛогинДляОтправкиSMS.Получить());
	Результат.Вставить("Пароль", Константы.ПарольДляОтправкиSMS.Получить());
	Результат.Вставить("Провайдер", Константы.ПровайдерSMS.Получить());
	
	Возврат Результат;
КонецФункции

Функция СтрокаЛатиницей(Знач Строка)
	Результат = "";
	
    Соответствие = СоответствиеКириллицыИЛатиницы();
	
	ПредыдущийСимвол = "";
	Для Позиция = 1 По СтрДлина(Строка) Цикл
		Символ = Сред(Строка, Позиция, 1);
		СимволЛатиницей = Соответствие[НРег(Символ)]; // поиск соответствия без учета регистра
		Если СимволЛатиницей = Неопределено Тогда
			// другие символы остаются "как есть"
			СимволЛатиницей = Символ;
		Иначе
			Если Символ = ВРег(Символ) Тогда
				СимволЛатиницей = ТРег(СимволЛатиницей); // восстанавливаем регистр
			КонецЕсли;
		КонецЕсли;
		Результат = Результат + СимволЛатиницей;
		ПредыдущийСимвол = СимволЛатиницей;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция СоответствиеКириллицыИЛатиницы()
	// транслитерация, используемая в загранпаспортах 1997-2010 гг.
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("а","a");
	Соответствие.Вставить("б","b");
	Соответствие.Вставить("в","v");
	Соответствие.Вставить("г","g");
	Соответствие.Вставить("д","d");
	Соответствие.Вставить("е","e");
	Соответствие.Вставить("ё","e");
	Соответствие.Вставить("ж","zh");
	Соответствие.Вставить("з","z");
	Соответствие.Вставить("и","i");
	Соответствие.Вставить("й","y");
	Соответствие.Вставить("к","k");
	Соответствие.Вставить("л","l");
	Соответствие.Вставить("м","m");
	Соответствие.Вставить("н","n");
	Соответствие.Вставить("о","o");
	Соответствие.Вставить("п","p");
	Соответствие.Вставить("р","r");
	Соответствие.Вставить("с","s");
	Соответствие.Вставить("т","t");
	Соответствие.Вставить("у","u");
	Соответствие.Вставить("ф","f");
	Соответствие.Вставить("х","kh");
	Соответствие.Вставить("ц","ts");
	Соответствие.Вставить("ч","ch");
	Соответствие.Вставить("ш","sh");
	Соответствие.Вставить("щ","shch");
	Соответствие.Вставить("ъ","""");
	Соответствие.Вставить("ы","y");
	Соответствие.Вставить("ь",""); // пропускается
	Соответствие.Вставить("э","e");
	Соответствие.Вставить("ю","yu");
	Соответствие.Вставить("я","ya");
	
	Возврат Соответствие;
КонецФункции

