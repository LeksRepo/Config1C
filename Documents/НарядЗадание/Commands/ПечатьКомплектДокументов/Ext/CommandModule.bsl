﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ЛексСервер.ПроверитьПодразделение(ПараметрКоманды) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Выбраны документы разных подразделений.");
		Возврат;
	КонецЕсли;
	
	МассивМакетов = ОпределитьМакеты(ПараметрКоманды);
	
	Если ЗначениеЗаполнено(МассивМакетов) Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.НарядЗадание", СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(МассивМакетов), ПараметрКоманды, ПараметрыВыполненияКоманды, Неопределено);
	Иначе
		Предупреждение("Документы на печать отсутствуют!");
	КонецЕсли;
	
	//RonEXI: Пока станок не работает, выключил.
	//ВыгрузитьФайлыDXF(ПараметрКоманды);
	
КонецПроцедуры

&НаСервере
Функция ОпределитьМакеты(Документы)
	
	МассивМакетов = Новый Массив;
	МассивМакетов.Добавить("ПечатьРулонныйМатериал");
	МассивМакетов.Добавить("ПечатьХлыстовойМатериал");
	МассивМакетов.Добавить("ПечатьХлыстМатСклад");
	МассивМакетов.Добавить("ПечатьЛистовойМатериал");
	МассивМакетов.Добавить("ПечатьПоследовательностьВыпуска");
	
	Возврат МассивМакетов;
	
КонецФункции

&НаКлиенте
Функция ВыгрузитьФайлыDXF(Документ) Экспорт
	
	Стр = ВыгрузитьСтрокиDXF(Документ);
	
	МассивСтрок = Стр.МассивСтрок;
	Подразделение = Стр.Подразделение;
	АдресКомпьютераЧПУ = Стр.АдресКомпьютераЧПУ;
	ДатаИзготовления = Стр.ДатаИзготовления;
	НомерНаряда = Стр.НомерНаряда;
	
	Если ЗначениеЗаполнено(Документ)
		И ЗначениеЗаполнено(Подразделение)
		И ЗначениеЗаполнено(АдресКомпьютераЧПУ) Тогда
		
		Каталог = АдресКомпьютераЧПУ;
		
		НомерНаряда = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(НомерНаряда, "0", "Слева");
		ДатаИзготовления = Формат(ДатаИзготовления, "ДЛФ=D");
		ИмяПапкиНаряд = ДатаИзготовления + "_Naryad_" + НомерНаряда+"\";
		
		УдалитьФайлы(Каталог + ИмяПапкиНаряд);
		
		Если МассивСтрок.Количество()>0 Тогда
			
			Попытка
				
				СоздатьКаталог(Каталог + ИмяПапкиНаряд);
				КаталогСоздан = Истина;
				
			Исключение
				
				Сообщить("Не удалось выгрузить чертежи для ЧПУ. Включите компьютер в цеху.");
				КаталогСоздан = Ложь;
				
			КонецПопытки;
			
			Если КаталогСоздан Тогда
				
				Для Каждого Строка ИЗ МассивСтрок Цикл
					
					СтрокаDXF = Строка.СтрокаDXF;
					НомерСпец = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Строка.Номер, "0", "Слева");
					НомерСтроки = Строка.НомерСтроки;
					Файл = Новый ЗаписьТекста(Каталог + ИмяПапкиНаряд + НомерСпец + "_" + НомерСтроки + ".dxf", КодировкаТекста.ANSI);
					Файл.Записать(СтрокаDXF);
					Файл.Закрыть();
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ВыгрузитьСтрокиDXF(Документ) Экспорт
	
	МассивСтрок = Новый Массив();
	
	Если ЗначениеЗаполнено(Документ) 
		И ЗначениеЗаполнено(Документ.Подразделение) 
		И ЗначениеЗаполнено(Документ.Подразделение.АдресКомпьютераЧПУ) Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Наряд", Документ);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Список.СтрокаDXF,
		|	Список.НомерСтроки КАК НомерСтроки,
		|	Список.Ссылка.Номер КАК Номер,
		|	Список.Ссылка
		|ИЗ
		|	Документ.Спецификация.СписокДеталей КАК Список
		|ГДЕ
		|	Список.Ссылка В
		|			(ВЫБРАТЬ
		|				Список.Спецификация
		|			ИЗ
		|				Документ.НарядЗадание.СписокСпецификаций КАК Список
		|			ГДЕ
		|				Список.Ссылка В (&Наряд))
		|	И Список.ДетальРедактированная
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номер,
		|	НомерСтроки";
		
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				Если ЗначениеЗаполнено(Выборка.СтрокаDXF) Тогда
					
					Стр = Новый Структура();
					Стр.Вставить("Номер", Выборка.Номер);
					Стр.Вставить("НомерСтроки", Выборка.НомерСтроки);
					Стр.Вставить("СтрокаDXF", Выборка.СтрокаDXF);
					
					МассивСтрок.Добавить(Стр);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Стр = Новый Структура();
	
	Стр.Вставить("МассивСтрок", МассивСтрок);
	Стр.Вставить("Подразделение", Документ.Подразделение);
	Стр.Вставить("АдресКомпьютераЧПУ", Документ.Подразделение.АдресКомпьютераЧПУ);
	Стр.Вставить("ДатаИзготовления", Документ.ДатаИзготовления);
	Стр.Вставить("НомерНаряда", Документ.Номер);
	
	Возврат Стр;
	
КонецФункции
