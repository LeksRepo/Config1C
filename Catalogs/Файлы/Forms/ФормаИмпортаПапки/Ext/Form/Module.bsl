﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("КаталогНаДиске") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Данная обработка вызывается из других процедур конфигурации.
			           |Вручную ее вызывать запрещено.'")); 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Параметры.КаталогНаДиске <> Неопределено Тогда
		Каталог = Параметры.КаталогНаДиске;
	КонецЕсли;
	
	Если Параметры.ПапкаДляДобавления <> Неопределено Тогда
		ПапкаДляДобавления = Параметры.ПапкаДляДобавления;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВыборКаталогов = Истина;
	ХранитьВерсии = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Файлы.Форма.ВыборКодировки") Тогда
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		КодировкаТекстаФайла = ВыбранноеЗначение.Значение;
		КодировкаПредставление = ВыбранноеЗначение.Представление;
		УстановитьПредставлениеКомандыКодировки(КодировкаПредставление);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбранныйКаталогНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	#Если НЕ ВебКлиент Тогда
		Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
		
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		
		ДиалогОткрытияФайла.Каталог = Каталог;
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
		ДиалогОткрытияФайла.Фильтр = Фильтр;
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите каталог'");
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			
			Если ВыборКаталогов = Истина Тогда 
				
				Каталог = ДиалогОткрытияФайла.Каталог;
				
			КонецЕсли;
			
		КонецЕсли;
			
		СтандартнаяОбработка = Ложь;
	#КонецЕсли
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИмпортВыполнить()
	
	Если ПустаяСтрока(Каталог) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не выбран каталог для импорта.'"), , "Каталог");
		Возврат;
		
	КонецЕсли;
	
	Если ПапкаДляДобавления.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите папку.'"), , "ПапкаДляДобавления");
		Возврат;
	КонецЕсли;
	
	ВыбранныеФайлы = Новый СписокЗначений;
	ВыбранныеФайлы.Добавить(Каталог);
	
	Обработчик = Новый ОписаниеОповещения("ИмпортЗавершение", ЭтотОбъект);
	
	РаботаСФайламиСлужебныйКлиент.ИмпортФайловВыполнить(
		Обработчик,
		ПапкаДляДобавления,
		ВыбранныеФайлы,
		Описание,
		ХранитьВерсии,
		УдалятьФайлыПослеДобавления,
		Истина, // Рекурсивно
		УникальныйИдентификатор,
		Новый Соответствие, // ПсевдоФайловаяСистема
		Новый Массив, // ДобавленныеФайлы
		Ложь, // РежимЗагрузки
		КодировкаТекстаФайла);
КонецПроцедуры

&НаКлиенте
Процедура ИмпортЗавершение(Результат, ПараметрыВыполнения) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть();
	Оповестить("ИмпортКаталоговЗавершен", Новый Структура, Результат.ПапкаДляДобавленияТекущая);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировку(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяКодировка", КодировкаТекстаФайла);
	ОткрытьФорму("Справочник.Файлы.Форма.ВыборКодировки", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПредставлениеКомандыКодировки(Представление)
	
	Команды.ВыбратьКодировку.Заголовок = Представление;
	
КонецПроцедуры

#КонецОбласти
