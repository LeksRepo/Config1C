﻿//------------------------------------------------------------------------------
// СПЕЦИФИКАЦИЯ ПАРАМЕТРОВ ПЕРЕДАВАЕМЫХ В ФОРМУ
//
//	УчетнаяЗапись	- СписокЗначений, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты, Неопределено
//						если тип список значений, тогда
//						представление - наименование учетной записи,
//						значение - ссылка на учетную запись.
//						Если не заполняется, учетные записи предлагаются из списка
//						доступных текущему пользователю
//
//	Кому			- СписокЗначений, Строка:
//						если список значений, то представление - имя получателя
//												значение		- почтовый адрес
//						если строка то список почтовых адресов,
//						в формате правильного e-mail адреса*
//
//	Вложения		- СписокЗначений, где
//						представление - строка - наименование вложения
//						значение      - ДвоичныеДанные - двоичные данные вложения
//									- Строка - адрес файла во временном хранилище
//									- Строка - путь к файлу на клиенте
//
//	УдалятьФайлыПослеОтправки - булево - удалять файлы в локальной файловой системы
//								после успешной отправки
//
//	Тема				- Строка - тема письма
//	Тело				- Строка - тело письма
//	АдресОтвета		- Строка - адрес по которому получателям письма
//								будет предложено написать ответ
//
// Использовать
//
// *формат правильного e-mail адреса:
// Z = ([Имя Пользователя] [<]пользователь@почтовыйсервер[>][;]), Строка = Z[Z]..
//
// ВОЗВРАЩАЕМОЕ ЗНАЧЕНИЕ
//
// Неопределено
//
// Булево: истина - сообщение успешно отправлено
//			ложь   - сообщение не было отправлено
//
//------------------------------------------------------------------------------
// СПЕЦИФИКАЦИЯ ФУНКЦИОНИРОВАНИЯ ФОРМЫ
//
//   Если в списке переданных учетных записей более одной записи, то на форме
// появится возможность выбора учетной записи, с которой будет отправлено
// электронное сообщение. Выбор произвольной учетной записи (не переданной)
// будет невозможно.
//
//   Если учетные записи не передаются пользователю предлагаются доступные
// ему учетные записи. При этом у элемента формы - учетной записи появляется
// кнопка выбора учетных записей.
//
//    Если файлы для вложения существует на сервере 1С:Предприятие, в качестве
// параметра необходимо не двоичные данные, а ссылку на данные во временном
// хранилище.
//
//------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Заполняет поля формы по переданным в форму параметрам 
//
// В форму могут передаваться следующие параметры:
// УчетнаяЗапись* - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты, список - 
//               ссылка на учетную запись, которая будет использоваться
//               при отправке сообщения, либо список из учетных записей (для выбора)
// Вложения      - соответствие - вложения в письмо, где
//                 ключ     - имя файла
//                 значение - двоичные данные файла
// Тема          - строка - тема письма
// Тело          - строка - тело письма
// Кому          - соответствие/строка - адресаты письма
//                 если тип соответствие, то
//                 ключ     - строка - Имя адресата
//                 значение - строка - электронный адрес в формате addr@server
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТемаПисьма = Параметры.Тема;
	ТелоПисьма = Параметры.Тело;
	АдресОтвета = Параметры.АдресОтвета;
	
	ВложенияВПисьмо = Параметры.Вложения;
	
	// помечаем те вложения, которые являются путями к файлам на клиенте
	Для Каждого ОписаниеВложение из ВложенияВПисьмо Цикл
		Если ТипЗнч(ОписаниеВложение.Значение) = Тип("Строка") Тогда
			Если ЭтоАдресВременногоХранилища(ОписаниеВложение.Значение) Тогда
				ОписаниеВложение.Значение = ПолучитьИзВременногоХранилища(ОписаниеВложение.Значение);
			Иначе
				ОписаниеВложение.Пометка = Истина; // Это путь к файлу в локальной файловой системе
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// обработка сложных параметров формы (составного типа)
	// УчетнаяЗапись, Кому
	
	Если НЕ ЗначениеЗаполнено(Параметры.УчетнаяЗапись) Тогда
		// учетная запись не передана - выбираем первую доступную
		ДоступныеУчетныеЗаписи = ЭлектроннаяПочта.ПолучитьДоступныеУчетныеЗаписи(Истина);
		Если ДоступныеУчетныеЗаписи.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не обнаружены доступные учетные записи электронной почты, обратитесь к администратору системы.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
			Возврат;
		КонецЕсли;
		УчетнаяЗапись = ДоступныеУчетныеЗаписи[0].Ссылка;
		ПарольЗадан = ЗначениеЗаполнено(УчетнаяЗапись.Пароль);
		Элементы.УчетнаяЗапись.КнопкаВыбора = Истина;
	ИначеЕсли ТипЗнч(Параметры.УчетнаяЗапись) = Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты") Тогда
		УчетнаяЗапись = Параметры.УчетнаяЗапись;
		ПарольЗадан = ЗначениеЗаполнено(УчетнаяЗапись.Пароль);
		УчетнаяЗаписьУказана = Истина;
	ИначеЕсли ТипЗнч(Параметры.УчетнаяЗапись) = Тип("СписокЗначений") Тогда
		НаборУчетныхЗаписей = Параметры.УчетнаяЗапись;
		
		Если НаборУчетныхЗаписей.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не указаны учетные записи для отправки сообщения, обратитесь к администратору системы.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			Возврат;
		КонецЕсли;
		
		ПарольЗаданМас = Новый Массив;
		
		Для Каждого ЭлементУчетнаяЗапись Из НаборУчетныхЗаписей Цикл
			Элементы.УчетнаяЗапись.СписокВыбора.Добавить(
										ЭлементУчетнаяЗапись.Значение,
										ЭлементУчетнаяЗапись.Представление);
			Если ЭлементУчетнаяЗапись.Значение.ИспользоватьДляПолучения Тогда
				АдресаОтветаПоУчетнымЗаписям.Добавить(ЭлементУчетнаяЗапись.Значение,
														ПолучитьПочтовыйАдресПоУчетнойЗаписи(ЭлементУчетнаяЗапись.Значение));
			КонецЕсли;
			Если ЗначениеЗаполнено(ЭлементУчетнаяЗапись.Значение.Пароль) Тогда
				ПарольЗаданМас.Добавить(ЭлементУчетнаяЗапись.Значение);
			КонецЕсли;
		КонецЦикла;
		ПарольЗадан = Новый ФиксированныйМассив(ПарольЗаданМас);
		Элементы.УчетнаяЗапись.СписокВыбора.СортироватьПоПредставлению();
		УчетнаяЗапись = НаборУчетныхЗаписей[0].Значение;
		
		// для переданного списка учетных запсией выбираем их из списка выбора
		Элементы.УчетнаяЗапись.КнопкаСпискаВыбора = Истина;
		УчетнаяЗаписьУказана = Истина;
		
		Если Элементы.УчетнаяЗапись.СписокВыбора.Количество() <= 1 Тогда
			Элементы.УчетнаяЗапись.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Кому) = Тип("СписокЗначений") Тогда
		ПочтовыйАдресПолучателя = "";
		Для Каждого ЭлементПочтовыйАдрес Из Параметры.Кому Цикл
			Если ЗначениеЗаполнено(ЭлементПочтовыйАдрес.Представление) тогда
				ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя
										+ ЭлементПочтовыйАдрес.Представление
										+ " <"
										+ ЭлементПочтовыйАдрес.Значение
										+ ">; "
			Иначе
				ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя 
										+ ЭлементПочтовыйАдрес.Значение
										+ "; ";
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(Параметры.Кому) = Тип("Строка") Тогда
		ПочтовыйАдресПолучателя = Параметры.Кому;
	ИначеЕсли ТипЗнч(Параметры.Кому) = Тип("Массив") Тогда
		Для Каждого СтруктураПолучателя Из Параметры.Кому Цикл
			ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя + СтруктураПолучателя.Представление + " <" + СтруктураПолучателя.Адрес + ">; ";
		КонецЦикла;
	КонецЕсли;
	
	// Получаем список адресов, которые пользователь использовал ранее
	СписокАдресовОтвета = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РедактированиеНовогоПисьма", 
		"СписокАдресовОтвета"
	);
	
	Если СписокАдресовОтвета <> Неопределено И СписокАдресовОтвета.Количество() > 0 Тогда
		Для Каждого ЭлементаАдресОтвета Из СписокАдресовОтвета Цикл
			Элементы.АдресОтвета.СписокВыбора.Добавить(ЭлементаАдресОтвета.Значение, ЭлементаАдресОтвета.Представление);
		КонецЦикла;
		Элементы.АдресОтвета.КнопкаСпискаВыбора = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресОтвета) Тогда
		АвтоматическаяПодстановкаАдресаОтвета = Ложь;
	Иначе
		Если УчетнаяЗапись.ИспользоватьДляПолучения Тогда
			// устанавливаем почтовый адрес по умолчанию
			Если ЗначениеЗаполнено(УчетнаяЗапись.ИмяПользователя) тогда
				АдресОтвета = УчетнаяЗапись.ИмяПользователя + " <" + УчетнаяЗапись.АдресЭлектроннойПочты + ">";
			Иначе
				АдресОтвета = УчетнаяЗапись.АдресЭлектроннойПочты;
			КонецЕсли;
		КонецЕсли;
		
		АвтоматическаяПодстановкаАдресаОтвета = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьПредставлениеВложений();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура УчетнаяЗаписьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если УчетнаяЗаписьУказана Тогда
		// если учетная записьбыла передана в качестве параметра
		// не позволяем выбрать другую
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Подставляет адрес ответа, если флаг автоматической подставновки ответа
// установлен.
//
&НаКлиенте
Процедура УчетнаяЗаписьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если АвтоматическаяПодстановкаАдресаОтвета Тогда
		Если АдресаОтветаПоУчетнымЗаписям.НайтиПоЗначению(ВыбранноеЗначение) <> Неопределено Тогда
			АдресОтвета = АдресаОтветаПоУчетнымЗаписям.НайтиПоЗначению(ВыбранноеЗначение).Представление;
		Иначе
			АдресОтвета = ПолучитьПочтовыйАдресПоУчетнойЗаписи(ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОтветаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если АвтоматическаяПодстановкаАдресаОтвета Тогда
		Если Не ЗначениеЗаполнено(АдресОтвета)
		 ИЛИ Не ЗначениеЗаполнено(Текст) Тогда
			АвтоматическаяПодстановкаАдресаОтвета = Ложь;
		Иначе
			АдресСоответствие1 = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(АдресОтвета);
			Попытка
				АдресСоответствие2 = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(Текст);
			Исключение
				СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , "АдресОтвета");
				СтандартнаяОбработка = Ложь;
				Возврат;
			КонецПопытки;
				
			Если НЕ EMAILАдресаОдинаковы(АдресСоответствие1, АдресСоответствие2) Тогда
				АвтоматическаяПодстановкаАдресаОтвета = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	АдресОтвета = ПолучитьПриведенныйПочтовыйАдресВФормате(Текст);
	
КонецПроцедуры

// Снимает флаг авто подстановки адреса ответа
//
&НаКлиенте
Процедура АдресОтветаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	АвтоматическаяПодстановкаАдресаОтвета = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОтветаОчистка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	АктуализироватьАдресОтветаВХранимомСписке(АдресОтвета, Ложь);
	
	Для Каждого ЭлементаАдресОтвета Из Элементы.АдресОтвета.СписокВыбора Цикл
		Если ЭлементаАдресОтвета.Значение = АдресОтвета
		   И ЭлементаАдресОтвета.Представление = АдресОтвета Тогда
			Элементы.АдресОтвета.СписокВыбора.Удалить(ЭлементаАдресОтвета);
		КонецЕсли;
	КонецЦикла;
	
	АдресОтвета = "";
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Вложения

// Удаляет вложение из списка, а так же вызывает функцию
// обновления таблицы представления вложений
//
&НаКлиенте
Процедура ВложенияПередУдалением(Элемент, Отказ)
	
	НаименованиеВложения = Элемент.ТекущиеДанные[Элемент.ТекущийЭлемент.Имя];
	
	Для Каждого ЭлементВложение Из ВложенияВПисьмо Цикл
		Если ЭлементВложение.Представление = НаименованиеВложения Тогда
			ВложенияВПисьмо.Удалить(ЭлементВложение);
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьПредставлениеВложений();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ДобавлениеФайлаКВложениям();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьВложение();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") Тогда
		АдресВременногоХранилища = "";
		Если ПоместитьФайл(АдресВременногоХранилища, ПараметрыПеретаскивания.Значение.ПолноеИмя, , Ложь) Тогда
			Файлы = Новый Массив;
			ПередаваемыйФайл = Новый ОписаниеПередаваемогоФайла(ПараметрыПеретаскивания.Значение.Имя, АдресВременногоХранилища);
			Файлы.Добавить(ПередаваемыйФайл);
			ДобавитьФайлыВСписок(Файлы);
			ОбновитьПредставлениеВложений();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	ОткрытьВложение();
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПисьмо()
	
	ОчиститьСообщения();
	
	Попытка
		ПриведенныйПочтовыйАдрес = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ПочтовыйАдресПолучателя);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), ,
				ПочтовыйАдресПолучателя);
		Возврат;
	КонецПопытки;
	
	Если ЗначениеЗаполнено(АдресОтвета) Тогда
		Попытка
			ПриведенныйАдресОтвета = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(АдресОтвета);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), ,
					"АдресОтвета");
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	Пароль = Неопределено;
	
	Если ((ТипЗнч(ПарольЗадан) = Тип("Булево") И Не ПарольЗадан)
	 Или  (ТипЗнч(ПарольЗадан) = Тип("ФиксированныйМассив") И ПарольЗадан.Найти(УчетнаяЗапись) = Неопределено)) Тогда
		ПараметрУчетнаяЗапись = Новый Структура("УчетнаяЗапись", УчетнаяЗапись);
		Пароль = ОткрытьФормуМодально("ОбщаяФорма.ПодтверждениеПароляУчетнойЗаписи",
										 ПараметрУчетнаяЗапись);
		Если ТипЗнч(Пароль) <> Тип("Строка") Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыПисьма = СформироватьПараметрыПисьма(ПриведенныйПочтовыйАдрес, Пароль);
	
	Если ПараметрыПисьма = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Ошибка формирования параметров почтового сообщения'"));
		Возврат;
	КонецЕсли;
	
	Попытка
		ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
	СохранитьАдресОтвета(АдресОтвета);
	Предупреждение(НСтр("ru = 'Сообщение успешно отправлено'"));
	
	УстановитьСостояниеОтправленногоСообщения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложитьФайлВыполнить()
	
	ДобавлениеФайлаКВложениям();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// СЕКЦИЯ ОБРАБОТЧИКОВ СОБЫТИЙ ФОРМЫ И ЭЛЕМЕНТОВ ФОРМЫ
//

&НаСервереБезКонтекста
Функция ОтправитьПочтовоеСообщение(знач УчетнаяЗапись, знач ПараметрыПисьма)
	
	Возврат ЭлектроннаяПочта.ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПочтовыйАдресПоУчетнойЗаписи(знач УчетнаяЗапись)
	
	Возврат СокрЛП(УчетнаяЗапись.ИмяПользователя)
			+ ? (ПустаяСтрока(СокрЛП(УчетнаяЗапись.ИмяПользователя)),
					УчетнаяЗапись.АдресЭлектроннойПочты,
					" <" + УчетнаяЗапись.АдресЭлектроннойПочты + ">");
	
КонецФункции

&НаКлиенте
Процедура УстановитьСостояниеОтправленногоСообщения()
	
	Заголовок = НСтр("ru = 'Сообщение отправлено'");
	Элементы.ОтправитьПисьмо.Доступность = Ложь;
	Элементы.ЭлектронныйАдресКому.ТолькоПросмотр = Истина;
	Элементы.ТемаПисьма.ТолькоПросмотр = Истина;
	Элементы.ТелоПисьма.ТолькоПросмотр = Истина;
	Элементы.Вложения.ТолькоПросмотр = Истина;
	Если Элементы.Найти("УчетнаяЗапись") <> Неопределено Тогда
		Элементы.УчетнаяЗапись.ТолькоПросмотр = Истина;
	КонецЕсли;
	Элементы.АдресОтвета.ТолькоПросмотр = Истина;
	Элементы.ПриложитьФайл.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВложение()
	
	Если Элементы.Вложения.ТекущиеДанные <> Неопределено Тогда
		НаименованиеВложения = Элементы.Вложения.ТекущиеДанные[Элементы.Вложения.ТекущийЭлемент.Имя];
		
		Для Каждого ЭлементСпискаВложений Из ВложенияВПисьмо Цикл
			Если ЭлементСпискаВложений.Представление = НаименованиеВложения Тогда
				Если ТипЗнч(ЭлементСпискаВложений.Значение) = Тип("ДвоичныеДанные") Тогда
#Если ВебКлиент Тогда
					АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ЭлементСпискаВложений.Значение);
					ПолучитьФайл(АдресВоВременномХранилище, , Истина)
#Иначе
					Файл = Новый Файл(ЭлементСпискаВложений.Представление);
					Если Файл.Расширение = "mxl" Тогда
						ТабличныйДокумент = ПолучитьТабличныйДокументПоДвоичнымДанным(ЭлементСпискаВложений.Значение);
						ТабличныйДокумент.ТолькоПросмотр = Истина;
						ТабличныйДокумент.Показать(ЭлементСпискаВложений.Представление);
					Иначе
						ИмяФайлаДляОткрытия = ПолучитьИмяВременногоФайла(Файл.Расширение);
						ЭлементСпискаВложений.Значение.Записать(ИмяФайлаДляОткрытия);
						ЗапуститьПриложение(ИмяФайлаДляОткрытия);
					КонецЕсли;
#КонецЕсли
				Иначе
#Если НЕ ВебКлиент Тогда
					Если Прав(СокрЛП(ЭлементСпискаВложений.Значение), 4) = ".mxl" Тогда
						ТабличныйДокумент = ПолучитьТабличныйДокументПоДвоичнымДанным(Новый ДвоичныеДанные(ЭлементСпискаВложений.Значение));
						ТабличныйДокумент.ТолькоПросмотр = Истина;
						ТабличныйДокумент.Показать(ЭлементСпискаВложений.Представление, ЭлементСпискаВложений.Значение);
					Иначе
#КонецЕсли
						ЗапуститьПриложение(ЭлементСпискаВложений.Значение);
#Если НЕ ВебКлиент Тогда
					КонецЕсли;
#КонецЕсли
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТабличныйДокументПоДвоичнымДанным(ДвоичныеДанные)
	
	ИмяФайла = ПолучитьИмяВременногоФайла("mxl");
	ДвоичныеДанные.Записать(ИмяФайла);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Прочитать(ИмяФайла);
	
	Попытка
		УдалитьФайлы(ИмяФайла);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Получение табличного документа'"), УровеньЖурналаРегистрации.Ошибка, , , 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаКлиенте
Процедура ДобавлениеФайлаКВложениям()
	
	Перем ПомещенныеФайлы;
	
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		ПомещенныеФайлы = Новый Массив;
		Если ПоместитьФайлы(, ПомещенныеФайлы, "", Истина, ) Тогда
			ДобавитьФайлыВСписок(ПомещенныеФайлы);
			ОбновитьПредставлениеВложений();
		КонецЕсли;
	Иначе
		Предупреждение(НСтр("ru = 'В Веб-клиенте без установленного расширения работы с файлами добавление файлов не поддерживается.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьФайлыВСписок(ПомещенныеФайлы)
	
	Для Каждого ОписаниеФайла Из ПомещенныеФайлы Цикл
		Файл = Новый Файл(ОписаниеФайла.Имя);
		ВложенияВПисьмо.Добавить(ПолучитьИзВременногоХранилища(ОписаниеФайла.Хранение), Файл.Имя);
		УдалитьИзВременногоХранилища(ОписаниеФайла.Хранение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставлениеВложений()
	
	ПредставлениеВложений.Очистить();
	
	индекс = 0;
	
	Для Каждого ЭлементВложение Из ВложенияВПисьмо Цикл
		Если Индекс = 0 Тогда
			СтрокаПредставления = ПредставлениеВложений.Добавить();
		КонецЕсли;
		
		СтрокаПредставления["Вложение" + Строка(Индекс + 1)] = ЭлементВложение.Представление;
		
		Индекс = Индекс + 1;
		Если Индекс = 2 тогда
			Индекс = 0;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Проверяет возможность отправления письма и если
// это возможно - формирует параметры отправки
//
&НаКлиенте
Функция СформироватьПараметрыПисьма(знач ПриведенныйПочтовыйАдрес,
                                    знач Пароль = Неопределено)
	
	ПараметрыПисьма = Новый Структура;
	
	Если ЗначениеЗаполнено(Пароль) Тогда
		ПараметрыПисьма.Вставить("Пароль", Пароль);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПриведенныйПочтовыйАдрес) Тогда
		ПараметрыПисьма.Вставить("Кому", ПриведенныйПочтовыйАдрес);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресОтвета) Тогда
		ПараметрыПисьма.Вставить("АдресОтвета", АдресОтвета);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТемаПисьма) Тогда
		ПараметрыПисьма.Вставить("Тема", ТемаПисьма);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТелоПисьма) Тогда
		ПараметрыПисьма.Вставить("Тело", ТелоПисьма);
	КонецЕсли;
	
	Если ВложенияВПисьмо.Количество() > 0 Тогда
		Вложения = Новый Соответствие;
		Для Каждого ЭлементВложение Из ВложенияВПисьмо Цикл
			Если ЭлементВложение.Пометка Тогда
				ДвоичныеДанные = Новый ДвоичныеДанные(ЭлементВложение.Значение);
				Вложения.Вставить(ЭлементВложение.Представление, ДвоичныеДанные);
			Иначе
				Вложения.Вставить(ЭлементВложение.Представление, ЭлементВложение.Значение);
			КонецЕсли;
		КонецЦикла;
		ПараметрыПисьма.Вставить("Вложения", Вложения);
	КонецЕсли;
	
	Возврат ПараметрыПисьма;
	
КонецФункции

// Добавляет адрес ответа в список сохраняемых значений
//
&НаСервереБезКонтекста
Функция СохранитьАдресОтвета(знач АдресОтвета)
	
	АктуализироватьАдресОтветаВХранимомСписке(АдресОтвета);
	
КонецФункции

// Добавляет адрес ответа в список сохраняемых значений
//
&НаСервереБезКонтекста
Функция АктуализироватьАдресОтветаВХранимомСписке(знач АдресОтвета,
                                                   знач ДобавлятьАдресВСписок = Истина)
	
	// Получаем список адресов, которые пользователь использовал ранее
	СписокАдресовОтвета = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РедактированиеНовогоПисьма",
		"СписокАдресовОтвета"
	);
	
	Если СписокАдресовОтвета = Неопределено Тогда
		СписокАдресовОтвета = Новый СписокЗначений();
	КонецЕсли;
	
	Для Каждого ЭлементАдресОтвета Из СписокАдресовОтвета Цикл
		Если ЭлементАдресОтвета.Значение = АдресОтвета
		   И ЭлементАдресОтвета.Представление = АдресОтвета Тогда
			СписокАдресовОтвета.Удалить(ЭлементАдресОтвета);
		КонецЕсли;
	КонецЦикла;
	
	Если ДобавлятьАдресВСписок
	   И ЗначениеЗаполнено(АдресОтвета) Тогда
		СписокАдресовОтвета.Вставить(0, АдресОтвета, АдресОтвета);
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"РедактированиеНовогоПисьма",
		"СписокАдресовОтвета",
		СписокАдресовОтвета
	);
	
КонецФункции

// Сравнивает два e-mail адреса
// Параметры
// АдресСоответствие1 - строка - первый e-mail адрес
// АдресСоответствие2 - строка - второй e-mail адрес
// Возвращаемое значение
// Истина, или Ложь в зависимости от того одинаковы ли e-mail адреса
//
&НаКлиенте
Функция EMAILАдресаОдинаковы(АдресСоответствие1, АдресСоответствие2)
	
	Если АдресСоответствие1.Количество() <> 1
	 Или АдресСоответствие2.Количество() <> 1 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если АдресСоответствие1[0].Представление = АдресСоответствие2[0].Представление
	   И АдресСоответствие1[0].Адрес         = АдресСоответствие2[0].Адрес Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ПолучитьПриведенныйПочтовыйАдресВФормате(Текст)
	
	ПочтовыйАдрес = "";
	
	МассивАдресов = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(Текст);
	
	Для Каждого ЭлементАдрес Из МассивАдресов Цикл
		Если ЗначениеЗаполнено(ЭлементАдрес.Представление) тогда
			ПочтовыйАдрес = ПочтовыйАдрес + ЭлементАдрес.Представление
							+ ? (ПустаяСтрока(СокрЛП(ЭлементАдрес.Адрес)), "", " <" + ЭлементАдрес.Адрес + ">");
		Иначе
			ПочтовыйАдрес = ПочтовыйАдрес + ЭлементАдрес.Адрес + "; ";
		КонецЕсли;
	КонецЦикла;
		
	Возврат ПочтовыйАдрес;
	
КонецФункции
