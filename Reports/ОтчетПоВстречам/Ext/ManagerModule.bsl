﻿
Функция СформироватьОтчет(ПараметрыОтчета) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.АвтоМасштаб = Истина;
	
	Макет = Отчеты.ОтчетПоВстречам.ПолучитьМакет("Макет");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрокаДата = Макет.ПолучитьОбласть("СтрокаДата");
	ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаОтчета");
	
	ОбластьШапка.Параметры.Подразделение = ПараметрыОтчета.Подразделение;
	ОбластьШапка.Параметры.Ответственный = ПараметрыОтчета.Ответственный;
	ОбластьШапка.Параметры.ПериодОтчета = ПредставлениеПериода(ПараметрыОтчета.ПериодОтчета.ДатаНачала, ПараметрыОтчета.ПериодОтчета.ДатаОкончания);
	ТабДок.Вывести(ОбластьШапка);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", ПараметрыОтчета.Подразделение);
	Запрос.УстановитьПараметр("Ответственный", ПараметрыОтчета.Ответственный);
	Запрос.УстановитьПараметр("ДатаНачала", ПараметрыОтчета.ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ПараметрыОтчета.ПериодОтчета.ДатаОкончания);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(1, 1, 1), ГОД, ГОД(ВстречаСКлиентом.Дата) - 1), МЕСЯЦ, МЕСЯЦ(ВстречаСКлиентом.Дата) - 1), ДЕНЬ, ДЕНЬ(ВстречаСКлиентом.Дата) - 1) КАК Дата,
	|	ВстречаСКлиентом.Дата КАК Время,
	|	ВстречаСКлиентом.Комментарий,
	|	ВстречаСКлиентом.Основание,
	|	ВстречаСКлиентом.Ссылка
	|ПОМЕСТИТЬ ВТ_Встречи
	|ИЗ
	|	Документ.ВстречаСКлиентом КАК ВстречаСКлиентом
	|ГДЕ
	|	ВстречаСКлиентом.Ответственный = &Ответственный
	|	И ВстречаСКлиентом.Подразделение = &Подразделение
	|	И ВстречаСКлиентом.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДОБАВИТЬКДАТЕ(&ДатаНачала, ДЕНЬ, РазностьДат.НомерДняИзДиапазона) КАК Дата,
	|	ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(&ДатаНачала, ДЕНЬ, РазностьДат.НомерДняИзДиапазона), ЧАС, 9) КАК Время
	|ПОМЕСТИТЬ ВТ_Интервалы
	|ИЗ
	|	(ВЫБРАТЬ
	|		aa.a * 1000 + bb.b * 100 + cc.c * 10 + dd.d КАК НомерДняИзДиапазона
	|	ИЗ
	|		(ВЫБРАТЬ
	|			0 КАК a
	|		
	|		ОБЪЕДИНИТЬ
	|		
	|		ВЫБРАТЬ
	|			1
	|		
	|		ОБЪЕДИНИТЬ
	|		
	|		ВЫБРАТЬ
	|			2
	|		
	|		ОБЪЕДИНИТЬ
	|		
	|		ВЫБРАТЬ
	|			3
	|		
	|		ОБЪЕДИНИТЬ
	|		
	|		ВЫБРАТЬ
	|			4
	|		
	|		ОБЪЕДИНИТЬ
	|		
	|		ВЫБРАТЬ
	|			5
	|		
	|		ОБЪЕДИНИТЬ
	|		
	|		ВЫБРАТЬ
	|			6
	|		
	|		ОБЪЕДИНИТЬ
	|		
	|		ВЫБРАТЬ
	|			7
	|		
	|		ОБЪЕДИНИТЬ
	|		
	|		ВЫБРАТЬ
	|			8
	|		
	|		ОБЪЕДИНИТЬ
	|		
	|		ВЫБРАТЬ
	|			9) КАК aa
	|			ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				0 КАК b
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				1
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				2
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				3
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				4
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				5
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				6
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				7
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				8
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				9) КАК bb
	|			ПО (ИСТИНА)
	|			ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				0 КАК c
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				1
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				2
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				3
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				4
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				5
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				6
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				7
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				8
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				9) КАК cc
	|			ПО (ИСТИНА)
	|			ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				0 КАК d
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				1
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				2
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				3
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				4
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				5
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				6
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				7
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				8
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				9) КАК dd
	|			ПО (ИСТИНА)
	|	ГДЕ
	|		aa.a * 1000 + bb.b * 100 + cc.c * 10 + dd.d <= РАЗНОСТЬДАТ(&ДатаНачала, &ДатаОкончания, ДЕНЬ)) КАК РазностьДат
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВТ_Встречи.Дата ЕСТЬ NULL 
	|			ТОГДА ВТ_Интервалы.Дата
	|		ИНАЧЕ ВТ_Встречи.Дата
	|	КОНЕЦ КАК Дата,
	|	ВЫБОР
	|		КОГДА ВТ_Встречи.Время ЕСТЬ NULL 
	|			ТОГДА ВТ_Интервалы.Время
	|		ИНАЧЕ ВТ_Встречи.Время
	|	КОНЕЦ КАК Время,
	|	ВТ_Встречи.Комментарий,
	|	ВТ_Встречи.Основание,
	|	ВТ_Встречи.Ссылка
	|ИЗ
	|	ВТ_Встречи КАК ВТ_Встречи
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_Интервалы КАК ВТ_Интервалы
	|		ПО ВТ_Встречи.Дата = ВТ_Интервалы.Дата
	|			И ВТ_Встречи.Время = ВТ_Интервалы.Время
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Время
	|ИТОГИ ПО
	|	Дата";
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		
		ОбластьСтрокаДата.Параметры.Дата = Выборка.Дата;
		ТабДок.Вывести(ОбластьСтрокаДата);
		
		Время = 9;
		ВыборкаПоДатам = Выборка.Выбрать();
		Пока ВыборкаПоДатам.Следующий() Цикл

			ВремяВыборки = Час(ВыборкаПоДатам.Время);
			Если Время < ВремяВыборки Тогда
				Для Индекс = Время По ВремяВыборки - 1 Цикл
					ИнтервалВремени = Дата(Год(ВыборкаПоДатам.Время), Месяц(ВыборкаПоДатам.Время), День(ВыборкаПоДатам.Время), Индекс, 0, 0);
					ОбластьСтрока.Параметры.Время = ИнтервалВремени;
					ОбластьСтрока.Параметры.Комментарий = Неопределено;
					ОбластьСтрока.Параметры.Основание = Неопределено;
					ОбластьСтрока.Параметры.Расшифровка = Новый Структура("Время, Ссылка, Подразделение, Ответственный", ИнтервалВремени, Неопределено, ПараметрыОтчета.Подразделение, ПараметрыОтчета.Ответственный); 					
					ТабДок.Вывести(ОбластьСтрока);
				КонецЦикла;
			КонецЕсли;                                                                  
			
			ОбластьСтрока.Параметры.Время = ВыборкаПоДатам.Время;
			ОбластьСтрока.Параметры.Комментарий = ВыборкаПоДатам.Комментарий;
			ОбластьСтрока.Параметры.Основание = ВыборкаПоДатам.Основание;
			ОбластьСтрока.Параметры.Расшифровка = Новый Структура("Ссылка", ВыборкаПоДатам.Ссылка);
			
			ТабДок.Вывести(ОбластьСтрока);
			
			Время = ВремяВыборки + 1;
		КонецЦикла;
		
		Если Время < 19 Тогда
			Для Индекс = Время По 18 Цикл
				ИнтервалВремени = Дата(Год(Выборка.Дата), Месяц(Выборка.Дата), День(Выборка.Дата), Индекс, 0, 0);
				ОбластьСтрока.Параметры.Время = ИнтервалВремени;
				ОбластьСтрока.Параметры.Комментарий = Неопределено;
				ОбластьСтрока.Параметры.Основание = Неопределено;
				ОбластьСтрока.Параметры.Расшифровка = Новый Структура("Время, Ссылка, Подразделение, Ответственный", ИнтервалВремени, Неопределено, ПараметрыОтчета.Подразделение, ПараметрыОтчета.Ответственный);
				
				ТабДок.Вывести(ОбластьСтрока);
			КонецЦикла;
		КонецЕсли;		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции
