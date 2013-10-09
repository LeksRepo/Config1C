﻿
&НаКлиенте
Процедура СписокСпецификацийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСпецификации(Команда)
	
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Текст = "Список спецификаций будет изменен" + Символы.ПС + "Продолжить?" ;
		
		Если Объект.СписокСпецификаций.Количество() > 0 
			И Вопрос(Текст, Режим, 0) = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
		
		АдресТаблицы = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораСпецификации", Новый Структура("Подразделение, ТЗ, Статус", Объект.Подразделение, Объект.СписокСпецификаций, ПредопределенноеЗначение("Перечисление.СтатусыСпецификации.Изготовлен")), ЭтаФорма);
		Если АдресТаблицы <> Неопределено Тогда
			ЗаполнитьНаСервере(АдресТаблицы);
		КонецЕсли;
	Иначе
		Текст = "Заполните Подразделение";
		Поле = "Объект.Подразделение";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ,Поле);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура  ЗаполнитьНаСервере(АдресТаблицы) 
	
	ТЗ = ПолучитьИзВременногоХранилища(АдресТаблицы);
	Объект.СписокСпецификаций.Загрузить(ТЗ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Текст = "Список спецификаций будет очищен" + Символы.ПС + "Продолжить?" ;
	
	Если Объект.СписокСпецификаций.Количество() > 0 И Объект.Подразделение <> ВыбранноеЗначение Тогда
		Если Вопрос(Текст, Режим, 0) = КодВозвратаДиалога.Нет Тогда
			СтандартнаяОбработка = Ложь;
		Иначе
			Объект.СписокСпецификаций.Очистить();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

