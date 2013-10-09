﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УникальныйИдентификаторКарточкиФайла = Параметры.УникальныйИдентификаторКарточкиФайла;
	
	ЗаполнитьДеревоВерсий();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СделатьАктивнойВыполнить()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Неопределено, ТекущиеДанные.Ссылка);
	
	Если ДанныеФайла.Редактирует.Пустая() Тогда
		СменитьАктивнуюВерсиюФайла(ТекущиеДанные.Ссылка);
		ЗаполнитьДеревоВерсий();
		Оповестить("Запись_Файл", Новый Структура("Событие", "АктивнаяВерсияИзменена"), Параметры.Файл);
	Иначе
		Предупреждение(НСтр("ru = 'Смена активной версии разрешена только для не занятых файлов.'"));
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Функция ОбойтиВсеУзлыДерева(Элементы, ТекущаяВерсия)
	
	Для Каждого Версия Из Элементы Цикл
		
		Если Версия.Ссылка = ТекущаяВерсия Тогда
			Идентификатор = Версия.ПолучитьИдентификатор();
			Возврат Идентификатор;
		КонецЕсли;	
		
		КодВозврата = ОбойтиВсеУзлыДерева(Версия.ПолучитьЭлементы(), ТекущаяВерсия);
		Если КодВозврата <> -1 Тогда
			Возврат КодВозврата;
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат -1;
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" И (Параметр.Событие = "ЗаконченоРедактирование" Или Параметр.Событие = "ВерсияСохранена") Тогда
		
		Если Параметры.Файл = Источник Тогда
			
			ТекущаяВерсия = Элементы.Список.ТекущиеДанные.Ссылка;
			ЗаполнитьДеревоВерсий();
			
			КодВозврата = ОбойтиВсеУзлыДерева(ДеревоВерсий.ПолучитьЭлементы(), ТекущаяВерсия);
			Если КодВозврата <> -1 Тогда
				Элементы.Список.ТекущаяСтрока = КодВозврата;
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	РаботаСФайламиСлужебныйКлиент.ОткрытьВерсиюФайла(
		РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
			Неопределено, ТекущиеДанные.Ссылка, УникальныйИдентификатор),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		Версия = ТекущиеДанные.Ссылка;
		
		ПараметрыОткрытияФормы = Новый Структура("Ключ", Версия);
		ОткрытьФорму("Справочник.ВерсииФайлов.ФормаОбъекта", ПараметрыОткрытияФормы);
		
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ПометитьНаУдалениеСнятьПометку();
		
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	
	ПометитьНаУдалениеСнятьПометку();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		Версия = ТекущиеДанные.Ссылка;
		
		ПараметрыОткрытияФормы = Новый Структура("Ключ", Версия);
		ОткрытьФорму("Справочник.ВерсииФайлов.ФормаОбъекта", ПараметрыОткрытияФормы);
		
	КонецЕсли;
	
КонецПроцедуры

// Сравнить 2 выбранные версии. 
&НаКлиенте
Процедура Сравнить(Команда)
	Перем Ссылка1;
	Перем Ссылка2;
	
	ЧислоВыделенныхСтрок = Элементы.Список.ВыделенныеСтроки.Количество();
	
	Если ЧислоВыделенныхСтрок = 2 ИЛИ ЧислоВыделенныхСтрок = 1 Тогда
		
		#Если НЕ ВебКлиент Тогда	
			
			Если ЧислоВыделенныхСтрок = 2 Тогда
				Ссылка1 = ДеревоВерсий.НайтиПоИдентификатору(Элементы.Список.ВыделенныеСтроки[0]).Ссылка;
				Ссылка2 = ДеревоВерсий.НайтиПоИдентификатору(Элементы.Список.ВыделенныеСтроки[1]).Ссылка;
			ИначеЕсли ЧислоВыделенныхСтрок = 1 Тогда
				
				Ссылка1 = Элементы.Список.ТекущиеДанные.Ссылка;
				Ссылка2 = Элементы.Список.ТекущиеДанные.РодительскаяВерсия;
				
			КонецЕсли;
			
			СпособСравненияВерсийФайлов = Неопределено;
			Расширение = НРег(Элементы.Список.ТекущиеДанные.Расширение);
			
			РасширениеПоддерживается = (Расширение = "txt" ИЛИ Расширение = "doc" ИЛИ Расширение = "docx" ИЛИ Расширение = "rtf" ИЛИ Расширение = "htm" ИЛИ Расширение = "html" ИЛИ Расширение = "odt");
			
			Если Не РасширениеПоддерживается Тогда
				Предупреждение(НСтр("ru = 'Сравнение версий поддерживается только для файлов следующих типов: 
				|   Текстовый документ (.txt)
				|   Документ формата RTF (.rtf) 
				|   Документ Microsoft Word (.doc, .docx) 
				|   Документ HTML (.html .htm) 
				|   Текстовый документ OpenDocument (.odt)'"));
				Возврат;
			КонецЕсли;
			
			Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Данная операция не поддерживается в базовой версии.'"));
				Возврат;
			КонецЕсли;
			
			Если Расширение = "odt" Тогда
				СпособСравненияВерсийФайлов = "OpenOfficeOrgWriter";
			КонецЕсли;	
			Если Расширение = "htm" ИЛИ Расширение = "html" Тогда
				СпособСравненияВерсийФайлов = "MicrosoftOfficeWord";
			КонецЕсли;	
			
			Если СпособСравненияВерсийФайлов = Неопределено Тогда
				СпособСравненияВерсийФайлов = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().СпособСравненияВерсийФайлов;
			КонецЕсли;	
			
			Если СпособСравненияВерсийФайлов = Неопределено Тогда // первый вызов - еще не инициализирована настройка
				Результат = ОткрытьФормуМодально("Справочник.ВерсииФайлов.Форма.ФормаВыбораСпособаСравненияВерсий");
				
				Если Результат <> КодВозвратаДиалога.ОК Тогда
					Возврат;
				КонецЕсли;	
				
				СпособСравненияВерсийФайлов = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().СпособСравненияВерсийФайлов;					
			КонецЕсли;
			
			Если СпособСравненияВерсийФайлов = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			ДанныеФайла1 = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(Неопределено, Ссылка1, УникальныйИдентификатор);
			ДанныеФайла2 = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(Неопределено, Ссылка2, УникальныйИдентификатор);
			
			ТекстСостояния = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Выполняется сравнение версий файла ""%1""...'"), ДанныеФайла1.Ссылка);
			Состояние(ТекстСостояния);
			
			ПолноеИмяФайла1 = "";
			Результат1 = РаботаСФайламиСлужебныйКлиент.ПолучитьФайлВерсииВРабочийКаталог(
				ДанныеФайла1, ПолноеИмяФайла1);
			
			ПолноеИмяФайла2 = "";
			Результат2 = РаботаСФайламиСлужебныйКлиент.ПолучитьФайлВерсииВРабочийКаталог(
				ДанныеФайла2, ПолноеИмяФайла2);
			
			Если Результат1 И Результат2 Тогда
				
				ПутьКФайлу1 = "";
				ПутьКФайлу2 = "";
				
				Если ДанныеФайла1.НомерВерсии < ДанныеФайла2.НомерВерсии Тогда
					ПутьКФайлу1 = ПолноеИмяФайла1;
					ПутьКФайлу2 = ПолноеИмяФайла2;
				Иначе
					ПутьКФайлу1 = ПолноеИмяФайла2;
					ПутьКФайлу2 = ПолноеИмяФайла1;
				КонецЕсли;
				
				РаботаСФайламиСлужебныйКлиент.СравнитьФайлы(
					ПутьКФайлу1, ПутьКФайлу2, СпособСравненияВерсийФайлов);
				
			КонецЕсли;
			
			Состояние();
		#Иначе
			Предупреждение(НСтр("ru = 'Сравнение версий в веб-клиенте не поддерживается.'"));
		#КонецЕсли

	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ЧислоВыделенныхСтрок = Элементы.Список.ВыделенныеСтроки.Количество();
	
	КомандаСравненияДоступна = Ложь;
	
	Если ЧислоВыделенныхСтрок = 2 Тогда
		КомандаСравненияДоступна = Истина;
	ИначеЕсли ЧислоВыделенныхСтрок = 1 Тогда
		
		Если Не Элементы.Список.ТекущиеДанные.РодительскаяВерсия.Пустая() Тогда
			КомандаСравненияДоступна = Истина;		
		Иначе
			КомандаСравненияДоступна = Ложь;
		КонецЕсли;
			
	Иначе
		КомандаСравненияДоступна = Ложь;
	КонецЕсли;
	

	Если КомандаСравненияДоступна = Истина Тогда
		Элементы.ОсновнаяКоманднаяПанель.ПодчиненныеЭлементы.Сравнить.Доступность = Истина;
		Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокСравнить.Доступность = Истина;
	Иначе
		Элементы.ОсновнаяКоманднаяПанель.ПодчиненныеЭлементы.Сравнить.Доступность = Ложь;
		Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокСравнить.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсию(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	РаботаСФайламиСлужебныйКлиент.ОткрытьВерсиюФайла(
		РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
			Неопределено, ТекущиеДанные.Ссылка, УникальныйИдентификатор),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляСохранения(
		Неопределено, ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура СменитьАктивнуюВерсиюФайла(Версия)
	
	ФайлОбъект = Версия.Владелец.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ФайлОбъект.Ссылка, , УникальныйИдентификаторКарточкиФайла);
	ФайлОбъект.ТекущаяВерсия = Версия;
	ФайлОбъект.ТекстХранилище = Версия.ТекстХранилище;
	ФайлОбъект.Записать();
	РазблокироватьДанныеДляРедактирования(ФайлОбъект.Ссылка, УникальныйИдентификаторКарточкиФайла);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоВерсий()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВерсииФайлов.Код КАК Код,
	|	ВерсииФайлов.Размер КАК Размер,
	|	ВерсииФайлов.Комментарий КАК Комментарий,
	|	ВерсииФайлов.Автор КАК Автор,
	|	ВерсииФайлов.ДатаСоздания КАК ДатаСоздания,
	|	ВерсииФайлов.ПолноеНаименование КАК ПолноеНаименование,
	|	ВерсииФайлов.РодительскаяВерсия КАК РодительскаяВерсия,
	|	ВерсииФайлов.ИндексКартинки,
	|	ВЫБОР
	|		КОГДА ВерсииФайлов.ПометкаУдаления = ИСТИНА
	|			ТОГДА 1
	|		ИНАЧЕ ВерсииФайлов.ИндексКартинки
	|	КОНЕЦ КАК ИндексКартинкиТекущий,
	|	ВерсииФайлов.ПометкаУдаления КАК ПометкаУдаления,
	|	ВерсииФайлов.Владелец КАК Владелец,
	|	ВерсииФайлов.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ВерсииФайлов.Владелец.ТекущаяВерсия = ВерсииФайлов.Ссылка
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоТекущая,
	|	ВерсииФайлов.Расширение КАК Расширение,
	|	ВерсииФайлов.НомерВерсии КАК НомерВерсии
	|ИЗ
	|	Справочник.ВерсииФайлов КАК ВерсииФайлов
	|ГДЕ
	|	ВерсииФайлов.Владелец = &Владелец");
	
	Запрос.УстановитьПараметр("Владелец", Параметры.Файл);
	Данные = Запрос.Выполнить().Выгрузить();
	
	Дерево = РеквизитФормыВЗначение("ДеревоВерсий");
	Дерево.Строки.Очистить();
	
	ДобавитьПредыдущуюВерсию(Неопределено, Дерево, Данные);
	ЗначениеВРеквизитФормы(Дерево, "ДеревоВерсий");
	
КонецПроцедуры	

&НаСервере
Процедура ДобавитьПредыдущуюВерсию(ТекущаяВетвь, Дерево, Данные)
	
	НайденнаяСтрока = Неопределено;
	
	Если ТекущаяВетвь = Неопределено Тогда
		Для Каждого Строка Из Данные Цикл
			Если Строка.ЭтоТекущая Тогда
				НайденнаяСтрока = Строка;
				Прервать;
			КонецЕсли;	
		КонецЦикла;		
	Иначе
		Для Каждого Строка Из Данные Цикл
			Если Строка.Ссылка = ТекущаяВетвь.РодительскаяВерсия Тогда 
				НайденнаяСтрока = Строка;
				Прервать;
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;	
	
	Если НайденнаяСтрока <> Неопределено Тогда 
		Ветвь = Дерево.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(Ветвь, НайденнаяСтрока);
		Данные.Удалить(НайденнаяСтрока);
		
		ДобавитьПодчиненныеВерсии(Ветвь, Данные);
		ДобавитьПредыдущуюВерсию(Ветвь, Дерево, Данные);
	КонецЕсли;			
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПодчиненныеВерсии(Ветвь, Данные)
	
	Для Каждого Строка из Данные Цикл
		Если Ветвь.Ссылка = Строка.РодительскаяВерсия Тогда
			ЗаполнитьЗначенияСвойств(Ветвь.Строки.Добавить(), Строка);
		КонецЕсли;
	КонецЦикла;
	Для Каждого Веточка из Ветвь.Строки Цикл
		ДобавитьПодчиненныеВерсии(Веточка, Данные);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкуУдаления(Версия, Пометка)
	
	ВерсияОбъект = Версия.ПолучитьОбъект();
	ВерсияОбъект.Заблокировать();
	ВерсияОбъект.УстановитьПометкуУдаления(Пометка);
	
КонецПроцедуры	

&НаКлиенте
Процедура ПометитьНаУдалениеСнятьПометку()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ПометкаУдаления Тогда 
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Cнять с ""%1"" пометку на удаление?'"),
			Строка(ТекущиеДанные.Ссылка));
	Иначе
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пометить ""%1"" на удаление?'"),
			Строка(ТекущиеДанные.Ссылка));
	КонецЕсли;	
	
	Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;	
	
	ТекущиеДанные.ПометкаУдаления = Не ТекущиеДанные.ПометкаУдаления;
	УстановитьПометкуУдаления(ТекущиеДанные.Ссылка, ТекущиеДанные.ПометкаУдаления);
	
	Если ТекущиеДанные.ПометкаУдаления Тогда
		ТекущиеДанные.ИндексКартинкиТекущий = 1;
	Иначе
		ТекущиеДанные.ИндексКартинкиТекущий = ТекущиеДанные.ИндексКартинки;
	КонецЕсли;
	
КонецПроцедуры


