﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная цифровая подпись"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Формирует данные подписи объекта
//
// Параметры
//  МенеджерКриптографии  - МенеджерКриптографии - менеджер криптографии
//  ОбъектДляПодписиСсылка  - любая ссылка - ссылка на подписываемый объект
//  ДвоичныеДанные  - ДвоичныеДанные - двоичные данные подписи
//  СтруктураПараметровПодписи  - Структура - информация о подписи - выбранный сертификат, пароль, комментарий
//
// Возвращаемое значение:
//   Структура   - данные для занесения в табличную часть ЭЦП
Функция СформироватьДанныеПодписи(
			МенеджерКриптографии,
			ОбъектДляПодписиСсылка,
			ДвоичныеДанные,
			СтруктураПараметровПодписи) Экспорт
	
	МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = СтруктураПараметровПодписи.Пароль;
	ДатаПодписи = Дата('00010101');
	
	НоваяПодписьДвоичныеДанные = МенеджерКриптографии.Подписать(ДвоичныеДанные, СтруктураПараметровПодписи.Сертификат);
	
	Отпечаток = Base64Строка(СтруктураПараметровПодписи.Сертификат.Отпечаток);
	КомуВыданСертификат = ЭлектроннаяЦифроваяПодписьКлиентСервер.ПолучитьПредставлениеПользователя(СтруктураПараметровПодписи.Сертификат.Субъект);
	ДвоичныеДанныеСертификата = СтруктураПараметровПодписи.Сертификат.Выгрузить();
	
	ДанныеПодписи = Новый Структура("ОбъектСсылка, НоваяПодписьДвоичныеДанные, Отпечаток, ДатаПодписи, Комментарий, ИмяФайлаПодписи, КомуВыданСертификат, АдресФайла, ДвоичныеДанныеСертификата",
							ОбъектДляПодписиСсылка,
							НоваяПодписьДвоичныеДанные,
							Отпечаток,
							ДатаПодписи,
							СтруктураПараметровПодписи.Комментарий,
							"", // ИмяФайлаПодписи
							КомуВыданСертификат,
							"", // АдресФайла
							ДвоичныеДанныеСертификата);
		
	Возврат ДанныеПодписи;
	
КонецФункции

// Проверяет подпись. В случае ошибки бросает исключение
//
// Параметры
//  МенеджерКриптографии  - МенеджерКриптографии - менеджер криптографии
//  ДвоичныеДанныеФайла  -    двоичные данные файла
//  ДвоичныеДанныеПодписи  -  двоичные данные подписи
Процедура ПроверитьПодпись(МенеджерКриптографии, ДвоичныеДанныеФайла, ДвоичныеДанныеПодписи) Экспорт
	
	Сертификат = Неопределено;
	МенеджерКриптографии.ПроверитьПодпись(ДвоичныеДанныеФайла, ДвоичныеДанныеПодписи, Сертификат);
	
	МассивРежимовПроверки = Новый Массив;
	МассивРежимовПроверки.Добавить(РежимПроверкиСертификатаКриптографии.ИгнорироватьВремяДействия);
	МассивРежимовПроверки.Добавить(РежимПроверкиСертификатаКриптографии.РазрешитьТестовыеСертификаты);
	МенеджерКриптографии.ПроверитьСертификат(Сертификат, МассивРежимовПроверки);
	
КонецПроцедуры	

Процедура ОткрытьФормуНастройкиЭЦП(Модально = Ложь) Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	
	ВебКлиентВLinux = Ложь;
	
	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86 ИЛИ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		ВебКлиентВLinux = Истина;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ВебКлиентВLinux, ПоказыватьНастройкиШифрования", ВебКлиентВLinux, Истина);
	
	Если Модально Тогда
		ОткрытьФормуМодально("Общаяформа.ПерсональныеНастройкиЭЦП", ПараметрыФормы);
	Иначе
		ОткрытьФорму("Общаяформа.ПерсональныеНастройкиЭЦП", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// По окончании подписания нотифицирует о подписании
//
// Параметры
//  ОбъектСсылка  - любая ссылка - объект, в табличную часть которого будет занесена информация о ЭЦП
Процедура ИнформироватьОПодписанииОбъекта(ОбъектСсылка) Экспорт
	
	ОповеститьОбИзменении(ОбъектСсылка);
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Установлена подпись для ""%1""'"),
		ОбъектСсылка);
	Состояние(ТекстСообщения);
	
КонецПроцедуры

// Находит сертификат по строке отпечатка
//
// Параметры
//  Отпечаток  - Строка - base64 кодированный отпечаток сертификата 
//  ТолькоВЛичномХранилище  - Булево - вести поиск только в личном хранилище
//
// Возвращаемое значение:
//   СертификатКриптографии  - сертификат криптографии 
Функция ПолучитьСертификатПоОтпечатку(Отпечаток, ТолькоВЛичномХранилище = Ложь) Экспорт
	
	ДвоичныеДанныеОтпечатка = Base64Значение(Отпечаток);
	
	Отказ = Ложь;
	МенеджерКриптографии = ПолучитьМенеджерКриптографии(Отказ);
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ХранилищеСертификатов = Неопределено;
	Если ТолькоВЛичномХранилище Тогда
		ХранилищеСертификатов = МенеджерКриптографии.ПолучитьХранилищеСертификатов(ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты);
	Иначе	
		ХранилищеСертификатов = МенеджерКриптографии.ПолучитьХранилищеСертификатов();
	КонецЕсли;
	
	Сертификат = ХранилищеСертификатов.НайтиПоОтпечатку(ДвоичныеДанныеОтпечатка);
	
	Возврат Сертификат;
	
КонецФункции

// Заполняет структуру полями сертификата
//
// Параметры
//  Отпечаток  - Строка - base64 кодированный отпечаток сертификата 
//
// Возвращаемое значение:
//   Структура  - структура с полями сертификата
Функция ЗаполнитьСтруктуруСертификатаПоОтпечатку(Отпечаток) Экспорт
	
	ДвоичныеДанныеОтпечатка = Base64Значение(Отпечаток);
	
	Отказ = Ложь;
	МенеджерКриптографии = ПолучитьМенеджерКриптографии(Отказ);
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ХранилищеСертификатов = МенеджерКриптографии.ПолучитьХранилищеСертификатов();
	Сертификат = ХранилищеСертификатов.НайтиПоОтпечатку(ДвоичныеДанныеОтпечатка);
	
	Если Сертификат = Неопределено Тогда
		Предупреждение(НСтр("ru = 'Сертификат не найден'"));
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ЭлектроннаяЦифроваяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(Сертификат);
	
КонецФункции	

//  Получает массив структур сертификатов для показа в диалоге выбора сертификатов для подписи или шифрования
//
// Параметры
//  ТолькоЛичные  - Булево - если Ложь, то берутся также и сертификаты получателей 
//
// Возвращаемое значение:
//   Массив  - массив структур с полями сертификата
Функция ПолучитьМассивСтруктурСертификатов(знач ТолькоЛичные) Экспорт
	
	МассивСтруктурСертификатов = Новый Массив;
	
	Отказ = Ложь;
	МенеджерКриптографии = ПолучитьМенеджерКриптографии(Отказ);
	Если Отказ Тогда
		Возврат МассивСтруктурСертификатов;
	КонецЕсли;
	
	ТекущаяДата = ТекущаяДата(); // Используется для выявления истекших сертификатов, которые хранятся на клиентском компьютере.
	
	Хранилище = МенеджерКриптографии.ПолучитьХранилищеСертификатов(ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты);
	СертификатыХранилища = Хранилище.ПолучитьВсе();
	
	МассивСтрокОтпечатков = Новый Массив;
	
	Для Каждого Сертификат Из СертификатыХранилища Цикл
		Если Сертификат.ДатаОкончания < ТекущаяДата Тогда
			Продолжить; // Пропуск истекших сертификатов.
		КонецЕсли;
		
		СтруктураСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(Сертификат);
		Если СтруктураСертификата <> Неопределено Тогда
			СтрокаОтпечатка = Base64Строка(Сертификат.Отпечаток);
			
			Если МассивСтрокОтпечатков.Найти(СтрокаОтпечатка) = Неопределено Тогда
				МассивСтрокОтпечатков.Добавить(СтрокаОтпечатка);
				МассивСтруктурСертификатов.Добавить(СтруктураСертификата);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ ТолькоЛичные Тогда
		Хранилище = МенеджерКриптографии.ПолучитьХранилищеСертификатов(ТипХранилищаСертификатовКриптографии.СертификатыПолучателей);
		СертификатыХранилища = Хранилище.ПолучитьВсе();
		
		Для Каждого Сертификат Из СертификатыХранилища Цикл
			Если Сертификат.ДатаОкончания < ТекущаяДата Тогда 
				Продолжить; // Пропуск истекших сертификатов.
			КонецЕсли;
			
			СтруктураСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(Сертификат);
			Если СтруктураСертификата <> Неопределено Тогда
				СтрокаОтпечатка = Base64Строка(Сертификат.Отпечаток);
				
				Если МассивСтрокОтпечатков.Найти(СтрокаОтпечатка) = Неопределено Тогда
					МассивСтрокОтпечатков.Добавить(СтрокаОтпечатка);
					МассивСтруктурСертификатов.Добавить(СтруктураСертификата);
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	
	Возврат МассивСтруктурСертификатов;
	
КонецФункции	

// Создает на клиенте менеджер криптографии.  Пароль не устанавливается
//
// Возвращаемое значение:
//   МенеджерКриптографии  - менеджер криптографии
Функция ПолучитьМенеджерКриптографии(Отказ = Ложь) Экспорт
	
	Отказ = Ложь;
	
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		Отказ = Истина;
		Возврат Неопределено;
	КонецЕсли;
	
	ПерсональныеНастройкиРаботыСЭЦП = ПолучитьПерсональныеНастройкиРаботыСЭЦП();
	ПровайдерЭЦП = ПерсональныеНастройкиРаботыСЭЦП.ПровайдерЭЦП;
	ПутьМодуляКриптографии = ПерсональныеНастройкиРаботыСЭЦП.ПутьМодуляКриптографии;
	ТипПровайдераЭЦП = ПерсональныеНастройкиРаботыСЭЦП.ТипПровайдераЭЦП;
	
	Если ПустаяСтрока(ПровайдерЭЦП) Тогда
		ВызватьИсключение
			НСтр("ru = 'Не указан провайдер ЭЦП.
			           |В настройках криптографии укажите провайдера ЭЦП,
			           |тип провайдера, алгоритмы подписи и хеширования.'");
	КонецЕсли;
	
	МенеджерКриптографии = Новый МенеджерКриптографии(ПровайдерЭЦП, ПутьМодуляКриптографии, ТипПровайдераЭЦП);
	
	МенеджерКриптографии.АлгоритмПодписи = ПерсональныеНастройкиРаботыСЭЦП.АлгоритмПодписи;
	МенеджерКриптографии.АлгоритмХеширования = ПерсональныеНастройкиРаботыСЭЦП.АлгоритмХеширования;
	МенеджерКриптографии.АлгоритмШифрования = ПерсональныеНастройкиРаботыСЭЦП.АлгоритмШифрования;
	
	Возврат МенеджерКриптографии;
	
КонецФункции

// Открывает форму просмотра сертификата ЭЦП
//
// Параметры
//  Отпечаток  - Строка - отпечаток сертификата ЭЦП
//
Процедура ОткрытьСертификат(Отпечаток) Экспорт
	
	Если ОбщегоНазначенияКлиентПовтИсп.ЭтоВебКлиентПодMacOS() Тогда
		Возврат;
	КонецЕсли;	
		
	СтруктураСертификата = ЗаполнитьСтруктуруСертификатаПоОтпечатку(Отпечаток);
	Если СтруктураСертификата <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("СтруктураСертификата, Отпечаток", СтруктураСертификата, Отпечаток);
		СтруктураВозврата = ОткрытьФормуМодально("ОбщаяФорма.СертификатЭЦП", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму просмотра сертификата ЭЦП
//
// Параметры
//  СтруктураСертификата - Структура с полями сертификата
//  Отпечаток  - Строка - отпечаток сертификата ЭЦП
//  АдресСертификата - Строка - адрес сертификата во временном хранилище
//
Процедура ОткрытьСертификатСоСтруктурой(СтруктураСертификата, Отпечаток, АдресСертификата) Экспорт
	
	Если ОбщегоНазначенияКлиентПовтИсп.ЭтоВебКлиентПодMacOS() Тогда
		Возврат;
	КонецЕсли;	
		
	Если СтруктураСертификата <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("СтруктураСертификата, Отпечаток, АдресСертификата", 
			СтруктураСертификата, Отпечаток, АдресСертификата);
		ОткрытьФормуМодально("ОбщаяФорма.СертификатЭЦП", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру, содержащую различные персональные настройки
Функция ПолучитьПерсональныеНастройкиРаботыСЭЦП() Экспорт
	Возврат СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ПерсональныеНастройкиРаботыСЭЦП;
КонецФункции	

// Открывает форму просмотра сертификата ЭЦП
Процедура ОткрытьСертификатПоОтпечаткуИАдресу(Отпечаток, АдресСертификата) Экспорт
	
	Если ОбщегоНазначенияКлиентПовтИсп.ЭтоВебКлиентПодMacOS() Тогда
		Возврат;
	КонецЕсли;	
		
	РасширениеПодключеноФайл = ПодключитьРасширениеРаботыСФайлами();
	
	Отпечаток = Отпечаток;
	Сертификат = Неопределено;
	СтруктураСертификата = Неопределено;
	Если НЕ ПустаяСтрока(АдресСертификата) Тогда
		ДвоичныеДанныеСертификата = ПолучитьИзВременногоХранилища(АдресСертификата);
		Сертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
		СтруктураСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(Сертификат);
	Иначе
		СтруктураСертификата = ЗаполнитьСтруктуруСертификатаПоОтпечатку(Отпечаток);
	КонецЕсли;	
	
	Если СтруктураСертификата <> Неопределено Тогда
		ОткрытьСертификатСоСтруктурой(СтруктураСертификата, Отпечаток, АдресСертификата);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму просмотра подписи ЭЦП
Процедура ОткрытьПодпись(ТекущиеДанные) Экспорт
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если ОбщегоНазначенияКлиентПовтИсп.ЭтоВебКлиентПодMacOS() Тогда
		Возврат;
	КонецЕсли;	
		
	РасширениеПодключеноФайл = ПодключитьРасширениеРаботыСФайлами();
	
	ОбъектУказан = Ложь;
	
	Если ТипЗнч(ТекущиеДанные.Объект) = Тип("Строка") Тогда		
		Если НЕ ПустаяСтрока(ТекущиеДанные.Объект) Тогда
			ОбъектУказан = Истина;
		КонецЕсли;	
	ИначеЕсли ТекущиеДанные.Объект <> Неопределено И (НЕ ТекущиеДанные.Объект.Пустая()) Тогда
		ОбъектУказан = Истина;
	КонецЕсли;	
	
	Если ОбъектУказан Тогда
		
		Отпечаток = ТекущиеДанные.Отпечаток;
		Сертификат = Неопределено;
		СтруктураСертификата = Неопределено;
		Если НЕ ПустаяСтрока(ТекущиеДанные.АдресСертификата) Тогда
			ДвоичныеДанныеСертификата = ПолучитьИзВременногоХранилища(ТекущиеДанные.АдресСертификата);
			Сертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
			СтруктураСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(Сертификат);
		Иначе
			СтруктураСертификата = ЗаполнитьСтруктуруСертификатаПоОтпечатку(Отпечаток);
		КонецЕсли;	
		
		Если СтруктураСертификата <> Неопределено Тогда
			ПараметрыФормы = Новый Структура("СтруктураСертификата, Отпечаток, АдресСертификата, УстановившийПодпись, Комментарий, АдресПодписи, ДатаПодписи", 
				СтруктураСертификата, Отпечаток, ТекущиеДанные.АдресСертификата,
				ТекущиеДанные.УстановившийПодпись, ТекущиеДанные.Комментарий, ТекущиеДанные.АдресПодписи,
				ТекущиеДанные.ДатаПодписи);
			ОткрытьФормуМодально("ОбщаяФорма.ПодписьЭЦП", ПараметрыФормы);
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

// "Сохранить как" вместе с подписями - все или выбранные
//
// Параметры
//  ФайлСсылка  - СправочникСсылка - объект, в табличной части которого содержатся подписи
//  ПолноеИмяФайла - Строка - полное имя с путем, под которым сохранен файл
//  УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор формы
//  МассивСтруктурПодписей - Массив  - массив структур подписей. Если Неопределено - сохраняем все подписи
//
Процедура СохранитьПодписи(ФайлСсылка, ПолноеИмяФайла, УникальныйИдентификатор, МассивСтруктурПодписей) Экспорт
	
	ОсновнойФайл = Новый Файл(ПолноеИмяФайла);
	Путь = ОсновнойФайл.Путь;
	
	МассивИмен = Новый Массив;
	МассивИмен.Добавить(ОсновнойФайл.Имя);
	
	РасширениеДляФайловПодписи = ПолучитьПерсональныеНастройкиРаботыСЭЦП().РасширениеДляФайловПодписи;
	
	Для Каждого СтруктураПодписи Из МассивСтруктурПодписей Цикл
		ИмяФайлаПодписи = СтруктураПодписи.ИмяФайлаПодписи;
		
		Если ПустаяСтрока(ИмяФайлаПодписи) Тогда 
			ИмяФайлаПодписи = Строка(ФайлСсылка) + "-" + Строка(СтруктураПодписи.КомуВыданСертификат) + "." + РасширениеДляФайловПодписи;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайлаПодписи);
		
		ПолныйПутьПодписи = Путь;
		ПолныйПутьПодписи = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолныйПутьПодписи, ОбщегоНазначенияКлиентПовтИсп.ТипПлатформыКлиента());
		ПолныйПутьПодписи = ПолныйПутьПодписи + ИмяФайлаПодписи;
		
		ФайлПоИмени = Новый Файл(ПолныйПутьПодписи);
		ФайлСуществует = ФайлПоИмени.Существует();
		
		Счетчик = 0;
		ИмяФайлаПодписиБезПостфикса = ФайлПоИмени.ИмяБезРасширения;
		Пока ФайлСуществует Цикл
			Счетчик = Счетчик + 1;
			ИмяФайлаПодписи = ИмяФайлаПодписиБезПостфикса + " (" + Строка(Счетчик) + ")" + "." + РасширениеДляФайловПодписи;
			ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайлаПодписи);
			
			ПолныйПутьПодписи = Путь;
			ПолныйПутьПодписи = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолныйПутьПодписи, ОбщегоНазначенияКлиентПовтИсп.ТипПлатформыКлиента());
			ПолныйПутьПодписи = ПолныйПутьПодписи + ИмяФайлаПодписи;
			
			ФайлДляПроверки = Новый Файл(ПолныйПутьПодписи);
			ФайлСуществует = ФайлДляПроверки.Существует();
		КонецЦикла;	
		
		Файл = Новый Файл(ПолныйПутьПодписи);
		МассивИмен.Добавить(Файл.Имя);
		ПередаваемыеФайлы = Новый Массив;
		Описание = Новый ОписаниеПередаваемогоФайла(ПолныйПутьПодписи, СтруктураПодписи.АдресПодписи);
		ПередаваемыеФайлы.Добавить(Описание);
		
		ПутьКФайлу = Файл.Путь;
		ПутьКФайлу = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКФайлу, ОбщегоНазначенияКлиентПовтИсп.ТипПлатформыКлиента());
		
		// Сохраним Файл из БД на диск
		ПолучитьФайлы(ПередаваемыеФайлы,, ПутьКФайлу, Ложь);
		
		УдалитьИзВременногоХранилища(СтруктураПодписи.АдресПодписи);
	КонецЦикла;
	
	Если МассивСтруктурПодписей.Количество() <> 0 Тогда
		Текст = НСтр("ru = 'Каталог:'") + Символы.ПС;
		Текст = Текст + Путь;
		Текст = Текст + Символы.ПС + Символы.ПС;
		Текст = Текст + НСтр("ru = 'Файлы:'") + Символы.ПС;
		
		Для Каждого ИмяФайла Из МассивИмен Цикл
			Текст = Текст + ИмяФайла + Символы.ПС;
		КонецЦикла;
		
		ПараметрыФормы = Новый Структура("Текст", Текст);
		ОткрытьФорму("ОбщаяФорма.ОтчетОСохраненииФайлов", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет ЭЦП из файла (файлов)
//
// Параметры
//  ФайлСсылка  - любая ссылка - объект, в табличную часть которого будет занесена информация о ЭЦП
//  МассивФайловПодписей  - Массив структур - массив структур (ПутьКФайлу, Комментарий)
//  УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор формы
//  ВладелецФайла  - любая ссылка - значение реквизита ВладелецФайла у ФайлСсылка
Функция СформироватьПодписиДляЗанесениюВБазу(ФайлСсылка, МассивФайловПодписей, УникальныйИдентификатор = Неопределено) Экспорт
	
	МассивДанныхДляЗанесенияВБазу = Новый Массив;
	
#Если НЕ ВебКлиент Тогда	
		
	Отказ = Ложь;
	МенеджерКриптографии = ПолучитьМенеджерКриптографии(Отказ);
	Если Отказ Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	ДатаПодписи = Дата('00010101');
	
	Для Каждого Элемент Из МассивФайловПодписей Цикл
		
		ИмяФайлаСПутем = Элемент.ПутьКФайлу;
		
		Сертификаты = МенеджерКриптографии.ПолучитьСертификатыИзПодписи(ИмяФайлаСПутем);
		
		Если Сертификаты.Количество() <> 0 Тогда
			
			Сертификат = Сертификаты[0];
			
			НоваяПодписьДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайлаСПутем);
			
			Файл = Новый Файл(ИмяФайлаСПутем);
			ИмяФайлаПодписи = Файл.Имя;
			
			Отпечаток = Base64Строка(Сертификат.Отпечаток);
			КомуВыданСертификат = ЭлектроннаяЦифроваяПодписьКлиентСервер.ПолучитьПредставлениеПользователя(Сертификат.Субъект);
			ДвоичныеДанныеСертификата = Сертификат.Выгрузить();
			
			ДанныеПодписи = Новый Структура("ОбъектСсылка, НоваяПодписьДвоичныеДанные, Отпечаток, ДатаПодписи, Комментарий, ИмяФайлаПодписи, КомуВыданСертификат, АдресФайла, ДвоичныеДанныеСертификата",
				ФайлСсылка,
				НоваяПодписьДвоичныеДанные,
				Отпечаток,
				ДатаПодписи,
				Элемент.Комментарий,
				ИмяФайлаПодписи,
				КомуВыданСертификат,
				"", // АдресФайла
				ДвоичныеДанныеСертификата);
			
			МассивДанныхДляЗанесенияВБазу.Добавить(ДанныеПодписи);
			
		КонецЕсли;
		
	КонецЦикла;
	
#КонецЕсли	

	Возврат МассивДанныхДляЗанесенияВБазу;

КонецФункции

// Сохраняет подпись на диск
Процедура СохранитьПодпись(АдресПодписи) Экспорт
	
	Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
		Возврат;
	КонецЕсли;
	
	РасширениеДляФайловПодписи = ПолучитьПерсональныеНастройкиРаботыСЭЦП().РасширениеДляФайловПодписи;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	
	Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Файлы цифровых подписей (*.%1)|*.%1|Все файлы (*.*)|*.*'"),
		РасширениеДляФайловПодписи
	);
	
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файл для сохранения подписи'");
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		
		ПолныйПутьПодписи = ДиалогОткрытияФайла.ПолноеИмяФайла;
		
		Файл = Новый Файл(ПолныйПутьПодписи);
		ПередаваемыеФайлы = Новый Массив;
		Описание = Новый ОписаниеПередаваемогоФайла(ПолныйПутьПодписи, АдресПодписи);
		ПередаваемыеФайлы.Добавить(Описание);
		
		ПутьКФайлу = Файл.Путь;
		ПутьКФайлу = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКФайлу, ОбщегоНазначенияКлиентПовтИсп.ТипПлатформыКлиента());		
		
		// Сохраним Файл из БД на диск
		ПолучитьФайлы(ПередаваемыеФайлы,, ПутьКФайлу, Ложь);
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Подпись сохранена в файл
			           |""%1"".'"),
			ДиалогОткрытияФайла.ПолноеИмяФайла
		);
		
		Состояние(Текст);
		
	КонецЕсли;
	
КонецПроцедуры
