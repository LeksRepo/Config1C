﻿
&НаКлиенте
Процедура ДобавитьВсеОрганизации(Команда)
	
	Если Объект.Организации.Количество() > 0
		И Вопрос("Список организаций будет очищен. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьОрганизации();	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОрганизации()
	
	Объект.Организации.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Организации.Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	(НЕ Организации.ПометкаУдаления)";
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НоваяСтрока = Объект.Организации.Добавить();
		НоваяСтрока.Организация = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьОрганизации()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
	//	// для нового документа
	//	ЗаполнитьОрганизации();
	//Иначе
	//	// определим доступность по ролям
	//	Если НЕ РольДоступна("Администратор") 
	//		И НЕ РольДоступна("КадроваяСлужба") Тогда
	//		ПечатьРазрешена = ОбщегоНазначения.ПолучитьПараметрСеанса("ТекущийПользователь") = Объект.РазрешитьПечатьПользователю;
	//		Элементы.Печать.Доступность = ПечатьРазрешена;
	//		Элементы.ПечатьВсехЛистов.Доступность = ПечатьРазрешена;
	//	Иначе // зашёл админ или КадроваяСлужба
	//		ЭтаФорма.ТолькоПросмотр = Ложь;
	//	КонецЕсли;
	//	
	//КонецЕсли;
	//
	//// сформировать табличный документ
	//// по первой строке состава
	//
	//Если НЕ Отказ Тогда
	//	Если Объект.Состав.Количество() > 0 Тогда
	//		СформироватьТабличныйДокумент(ТабличныйДокумент, Объект.Состав[0].Макет);
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СформироватьДокумент(Элементы.Состав.ТекущиеДанные.Макет);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокумент(ИмяМакета)
	
	СформироватьТабличныйДокумент(ТабличныйДокумент, ИмяМакета);
	
КонецПроцедуры // СформироватьДокумент

&НаСервереБезКонтекста
Процедура СформироватьТабличныйДокумент(ТабДок, ИмяМакета)
	
	Отказ = Ложь;
	
	Попытка
		Макет = Справочники.ПравоваяБаза.ПолучитьМакет(ИмяМакета);
		ОблТело = Макет.ПолучитьОбласть("Тело");
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Не найден макет %1", ИмяМакета);
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецПопытки;
	
	Если НЕ Отказ Тогда
		ТабДок.Очистить();
		ТабДок.Вывести(ОблТело);
	КонецЕсли;
		
КонецПроцедуры // СформироватьТабличныйДокумент

&НаКлиенте
Процедура ПечатьВсехЛистов(Команда)
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок = ПечатьВсехЛистовСервер();
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать();
	
КонецПроцедуры

&НаСервере
Функция ПечатьВсехЛистовСервер()
	
	ТабДок = Новый ТабличныйДокумент;
	ВыводитьРазделительСтраниц = Ложь;
	
	Для каждого Строка Из Объект.Состав Цикл
		
		Если ВыводитьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		Макет = Справочники.ПравоваяБаза.ПолучитьМакет(Строка.Макет);
		ОбластьТело = Макет.ПолучитьОбласть("Тело");
		ТабДок.Вывести(ОбластьТело);
		ВыводитьРазделительСтраниц = Истина;
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции // ПечатьВсехЛистовСервер()