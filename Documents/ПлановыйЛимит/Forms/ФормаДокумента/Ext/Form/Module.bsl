﻿
&НаКлиенте
Процедура ЗаполнитьТаблицуДней()
	
	Если ЗначениеЗаполнено(Объект.Подразделение) И ЗначениеЗаполнено(Объект.Дата) Тогда
		
		Объект.ТаблицаДней.Очистить();
		
		КоличествоДней = День(КонецМесяца(Объект.Дата));
		ТекущаяДатаСтроки = НачалоМесяца(Объект.Дата);
		
		Сч = 1;
		
		Пока Сч <= КоличествоДней Цикл
			
			НоваяСтрока = Объект.ТаблицаДней.Добавить();
			НоваяСтрока.Дата = ТекущаяДатаСтроки;
			НоваяСтрока.Норматив = 0;
			
			Если ДеньНедели(ТекущаяДатаСтроки) = 7 Тогда
				НоваяСтрока.Выходной = Истина;
			КонецЕсли;
			
			ТекущаяДатаСтроки = ТекущаяДатаСтроки + 60*60*24;
			Сч = Сч + 1;
			
		КонецЦикла;
		
		ОбновитьДиаграмму();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДиаграмму()
	
	Диаграмма.Очистить();
	Диаграмма.ОтображатьЛегенду = Ложь;
	Диаграмма.ТипДиаграммы = ТипДиаграммы.График;
	Диаграмма.РежимСглаживания = РежимСглаживанияДиаграммы.ГладкаяКривая;
	Диаграмма.НатяжениеСглаживания = 70;
	Диаграмма.РежимПолупрозрачности = РежимПолупрозрачностиДиаграммы.НеИспользовать;
	
	Диаграмма.ПропускатьБазовоеЗначение = Истина;
	Диаграмма.БазовоеЗначение = 0;
	
	Серия1 = Диаграмма.Серии.Добавить("Норматив");
	Серия1.Цвет = WebЦвета.ЗеленыйЛес;
	Серия1.Маркер = ТипМаркераДиаграммы.Круг;
	
	Серия2 = Диаграмма.Серии.Добавить("Выходные");
	Серия2.Цвет = WebЦвета.Черный;
	Серия2.Маркер = ТипМаркераДиаграммы.Круг;
	Серия2.Линия = Новый Линия(ТипЛинииДиаграммы.Сплошная, 3);
	
	Сч = 0;
	
	Для Каждого Строка Из Объект.ТаблицаДней Цикл
		
		ТекущееЗначение = Строка.Норматив;
		Если ТекущееЗначение = 0 Тогда
			ТекущееЗначение = 0.001;
		КонецЕсли;
		
		Диаграмма.Точки.Добавить(Формат(Строка.Дата, "ДФ=dd.MM"));
		Диаграмма.УстановитьЗначение(Сч, Серия1, ТекущееЗначение);
		
		Если ДеньНедели(Строка.Дата) = 7 Тогда
			
			Диаграмма.УстановитьЗначение(Сч, Серия2, ТекущееЗначение);
			
		КонецЕсли;
		
		Сч = Сч + 1;
		
	КонецЦикла;
	
	Диаграмма.Обновление = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДнейНормативПриИзменении(Элемент)
	
	ОбновитьДиаграмму();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьДублированиеДокумента(Дата, Подразделение, Документ)
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("НачалоМесяца", НачалоМесяца(Дата));
	Запрос.Параметры.Вставить("КонецМесяца", КонецМесяца(Дата));
	Запрос.Параметры.Вставить("Подразделение", Подразделение);
	Запрос.Параметры.Вставить("Документ", Документ);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПлановыйЛимит.Ссылка
	|ИЗ
	|	Документ.ПлановыйЛимит КАК ПлановыйЛимит
	|ГДЕ
	|	ПлановыйЛимит.Дата МЕЖДУ &НачалоМесяца И &КонецМесяца
	|	И ПлановыйЛимит.Подразделение = &Подразделение
	|	И ПлановыйЛимит.Ссылка <> &Документ";
	
	Результат = Запрос.Выполнить();
	Возврат НЕ Результат.Пустой();
	
КонецФункции

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ЗаполнитьТаблицуДней();
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	ОткрытьФорму("Документ.ПлановыйЛимит.Форма.ФормаЗаполнитьДанными", , Элементы.ТаблицаДней, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДнейОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Для Каждого Строка Из Объект.ТаблицаДней Цикл
		
		Если НЕ ДеньНедели(Строка.Дата) = 7 Тогда
			
			Если ДеньНедели(Строка.Дата) = 6 Тогда
				
				Строка.Норматив = Окр(ВыбранноеЗначение.Норматив / 2);
				Строка.КоличествоКоробов = Окр(ВыбранноеЗначение.КоличествоКоробов / 2);
				Строка.КоличествоДеталей = Окр(ВыбранноеЗначение.КоличествоДеталей / 2);
				Строка.КоличествоДоставок = Окр(ВыбранноеЗначение.КоличествоДоставок / 2);
				
			Иначе
				
				Строка.Норматив = ВыбранноеЗначение.Норматив;
				Строка.КоличествоКоробов = ВыбранноеЗначение.КоличествоКоробов;
				Строка.КоличествоДеталей = ВыбранноеЗначение.КоличествоДеталей;
				Строка.КоличествоДоставок = ВыбранноеЗначение.КоличествоДоставок;
				
			КонецЕсли;
			
		Иначе
			
			Строка.Норматив = 0;
			Строка.КоличествоКоробов = 0;
			Строка.КоличествоДеталей = 0;
			Строка.КоличествоДоставок = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбновитьДиаграмму();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьДиаграмму();
	
КонецПроцедуры
