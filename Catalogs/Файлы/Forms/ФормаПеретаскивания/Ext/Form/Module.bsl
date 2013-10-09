﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПапкаДляДобавления = Параметры.ПапкаДляДобавления;
	
	Для Каждого путьФайла Из Параметры.МассивИменФайлов Цикл
		СписокИменФайлов.Добавить(путьФайла);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		Предупреждение(
			НСтр("ru = 'В Веб-клиенте импорт файлов не поддерживается.
			           |Используйте команду ""Создать"" в списке файлов.'"));
		Отказ = Истина;
		Возврат;
	#КонецЕсли
	
	ХранитьВерсии = Истина;
	ТолькоКаталоги = Истина;
	
	Для Каждого ПутьФайла Из СписокИменФайлов Цикл
		ЗаполнитьСписокФайлов(ПутьФайла, ДеревоФайлов.ПолучитьЭлементы(), Истина, ТолькоКаталоги);
	КонецЦикла;
	
	Если ТолькоКаталоги Тогда
		Заголовок = НСтр("ru = 'Загрузка папок'");
	КонецЕсли;
	
	Состояние();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДеревоФайлов

&НаКлиенте
Процедура ДеревоФайловПометкаПриИзменении(Элемент)
	ЭлементДанных = ДеревоФайлов.НайтиПоИдентификатору(Элементы.ДеревоФайлов.ТекущаяСтрока);
	УстановитьПометку(ЭлементДанных, ЭлементДанных.Пометка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ДобавитьВыполнить()
	
	ОчиститьСообщения();
	
	ПоляНеЗаполнены = Ложь;
	
	ПсевдоФайловаяСистема = Новый Соответствие; // соответствие путь к директории - файлы и папки в ней 
	
	ВыбранныеФайлы = Новый СписокЗначений;
	Для Каждого файлВложенный Из ДеревоФайлов.ПолучитьЭлементы() Цикл
		Если файлВложенный.Пометка = Истина Тогда
			ВыбранныеФайлы.Добавить(файлВложенный.ПолныйПуть);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого файлВложенный Из ДеревоФайлов.ПолучитьЭлементы() Цикл
		ЗаполнитьФайловуюСистему(ПсевдоФайловаяСистема, файлВложенный);
	КонецЦикла;
	
	Если ВыбранныеФайлы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Нет файлов для добавления.'"), , "ВыбранныеФайлы");
		ПоляНеЗаполнены = Истина;
	КонецЕсли;
	
	Если ПапкаДляДобавления.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите папку.'"), , "ПапкаДляДобавления");
		ПоляНеЗаполнены = Истина;
	КонецЕсли;
	
	Если ПоляНеЗаполнены = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ДобавленныеФайлы = Новый Массив;
	
	ПапкаДляДобавленияТекущая = РаботаСФайламиСлужебныйКлиент.ИмпортФайловВыполнить(
		ПапкаДляДобавления, 
		ВыбранныеФайлы, 
		Комментарий, 
		ХранитьВерсии, 
		УдалятьФайлыПослеДобавления, 
		Истина, // Истина - рекурсивно
		УникальныйИдентификатор,
		ПсевдоФайловаяСистема,
		ДобавленныеФайлы,
		Ложь,
		КодировкаТекстаФайла); 
		
	Закрыть();
	
	Оповестить("ИмпортКаталоговЗавершен", Новый Структура, ПапкаДляДобавленияТекущая);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировку(Команда)
	
	ПараметрыФормы = Новый Структура("ТекущаяКодировка", КодировкаТекстаФайла);
	КодВозврата = ОткрытьФормуМодально("Справочник.Файлы.Форма.ВыборКодировки", ПараметрыФормы);
	
	Если ТипЗнч(КодВозврата) = Тип("Структура") Тогда
		
		КодировкаТекстаФайла = КодВозврата.Значение;
		КодировкаПредставление = КодВозврата.Представление;
		УстановитьПредставлениеКомандыКодировки(КодировкаПредставление);
		
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ЗаполнитьСписокФайлов(ПутьФайла, Знач ЭлементыДерева, ЭлементВерхнегоУровня, ТолькоКаталоги = Неопределено)
	
	ФайлПеренесенный = Новый Файл(ПутьФайла);
	
	НовыйЭлемент = ЭлементыДерева.Добавить();
	НовыйЭлемент.ПолныйПуть = ФайлПеренесенный.ПолноеИмя;
	НовыйЭлемент.ИмяФайла = ФайлПеренесенный.Имя;
	НовыйЭлемент.Пометка = Истина;
	
	Если ФайлПеренесенный.Расширение = "" Тогда
		НовыйЭлемент.ИндексКартинки = 2; // папка
	Иначе
		НовыйЭлемент.ИндексКартинки = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(ФайлПеренесенный.Расширение);
	КонецЕсли;
			
	Если ФайлПеренесенный.ЭтоКаталог() Тогда
		
		Путь = ФайлПеренесенный.ПолноеИмя + ОбщегоНазначенияКлиентСервер.РазделительПути();
		
		Если ЭлементВерхнегоУровня = Истина Тогда
			Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Идет сбор информации о каталоге
				           |""%1"".
				           |Пожалуйста, подождите.'"),
				Путь));
		КонецЕсли;
		
		НайденныеФайлы = НайтиФайлы(Путь, "*.*");
		
		ФайлСортированные = Новый Массив;
		
		// папки сперва
		Для Каждого ФайлВложенный Из НайденныеФайлы Цикл
			Если ФайлВложенный.ЭтоКаталог() Тогда
				ФайлСортированные.Добавить(ФайлВложенный.ПолноеИмя);
			КонецЕсли;
		КонецЦикла;
		
		// потом файлы
		Для Каждого ФайлВложенный Из НайденныеФайлы Цикл
			Если НЕ ФайлВложенный.ЭтоКаталог() Тогда
				ФайлСортированные.Добавить(ФайлВложенный.ПолноеИмя);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ФайлВложенный Из ФайлСортированные Цикл
			ЗаполнитьСписокФайлов(ФайлВложенный, НовыйЭлемент.ПолучитьЭлементы(), Ложь);
		КонецЦикла;
		
	Иначе
		
		Если ЭлементВерхнегоУровня Тогда
			ТолькоКаталоги = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФайловуюСистему(ПсевдоФайловаяСистема, ЭлементДерева)
	Если ЭлементДерева.Пометка = Истина Тогда
		ДочерниеЭлементы = ЭлементДерева.ПолучитьЭлементы();
		Если ДочерниеЭлементы.Количество() <> 0 Тогда
			
			ФайлыИПодпапки = Новый Массив;
			Для Каждого ФайлВложенный Из ДочерниеЭлементы Цикл
				ЗаполнитьФайловуюСистему(ПсевдоФайловаяСистема, ФайлВложенный);
				
				Если ФайлВложенный.Пометка = Истина Тогда
					ФайлыИПодпапки.Добавить(ФайлВложенный.ПолныйПуть);
				КонецЕсли;
			КонецЦикла;
			
			ПсевдоФайловаяСистема.Вставить(ЭлементДерева.ПолныйПуть, ФайлыИПодпапки);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// рекурсивно ставит пометку всем дочерним элементам
&НаКлиенте
Процедура УстановитьПометку(ЭлементДерева, Пометка)
	ДочерниеЭлементы = ЭлементДерева.ПолучитьЭлементы();
	
	Для Каждого ФайлВложенный Из ДочерниеЭлементы Цикл
		ФайлВложенный.Пометка = Пометка;
		УстановитьПометку(ФайлВложенный, Пометка);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеКомандыКодировки(Представление)
	
	Команды.ВыбратьКодировку.Заголовок = Представление;
	
КонецПроцедуры

