﻿
Функция ПолучитьСтруктуруПрофиля(Профиль, Тип = 1) Экспорт
	
	СтруктураПрофиля = Новый Структура;
	СтруктураПрофиля.Вставить("СтрокаПрофиля", "");
	СтруктураПрофиля.Вставить("Вертикальный", Профиль.ВертикальныйПрофиль);
	СтруктураПрофиля.Вставить("РамкаВерхняя", Профиль.РамкаВерхняя);
	СтруктураПрофиля.Вставить("РамкаНижняя", Профиль.РамкаНижняя);
	СтруктураПрофиля.Вставить("РамкаСредняяБезКрепления", Профиль.РамкаСредняяБезКрепления);
	СтруктураПрофиля.Вставить("РамкаСредняяСКреплением", Профиль.РамкаСредняяСКреплением);
	СтруктураПрофиля.Вставить("ТрекНаПоворотнуюСистему", Профиль.ТрекНаПоворотнуюСистему);
	СтруктураПрофиля.Вставить("ТрекВерхний", Профиль.ТрекВерхний);
	СтруктураПрофиля.Вставить("ТрекНижний", Профиль.ТрекНижний);
	СтруктураПрофиля.Вставить("ТрекОднополосныйВерхний", Профиль.ТрекОднополосныйВерхний);
	СтруктураПрофиля.Вставить("ТрекОднополосныйНижний", Профиль.ТрекОднополосныйНижний);
	СтруктураПрофиля.Вставить("Цвет", Профиль.ВертикальныйПрофиль.Цвет.КодЦвета);
	СтруктураПрофиля.Вставить("Шлегель", Профиль.Шлегель);
	СтруктураПрофиля.Вставить("Колеса", Профиль.Колеса);
		
	Массив = Новый Массив(8);
	
	Массив[0] = СтруктураПрофиля.Вертикальный.ШиринаДетали;
	Массив[1] = СтруктураПрофиля.Вертикальный.ГлубинаПаза;
	
	Массив[2] = СтруктураПрофиля.РамкаВерхняя.ШиринаДетали;
	Массив[3] = СтруктураПрофиля.РамкаВерхняя.ГлубинаПаза;
	
	Массив[4] = СтруктураПрофиля.РамкаНижняя.ШиринаДетали;
	Массив[5] = СтруктураПрофиля.РамкаНижняя.ГлубинаПаза;
	
	Если ЗначениеЗаполнено(СтруктураПрофиля.РамкаСредняяБезКрепления) И (Тип = 1) Тогда
		
		Массив[6] = СтруктураПрофиля.РамкаСредняяБезКрепления.ШиринаДетали;
		Массив[7] = СтруктураПрофиля.РамкаСредняяБезКрепления.ГлубинаПаза;
		
	Иначе
		
		Массив[6] = СтруктураПрофиля.РамкаСредняяСКреплением.ШиринаДетали;
		Массив[7] = СтруктураПрофиля.РамкаСредняяСКреплением.ГлубинаПаза;
		
	КонецЕсли;
	
	
		
	СтрокаПрофиля = "";
	Ошибка = Ложь;
	
	Для Каждого Элемент Из Массив Цикл
		Если Элемент = Неопределено Тогда
			Ошибка = Истина;
		КонецЕсли;
		СтрокаПрофиля = СтрокаПрофиля + Строка(Элемент) + "_";
	КонецЦикла;
	
	Если НЕ Ошибка Тогда
		СтруктураПрофиля.СтрокаПрофиля = СтрокаПрофиля;
	КонецЕсли;
	
	Возврат СтруктураПрофиля;
	
КонецФункции

Функция ПолучитьТаблицуНоменклатурыНаПечать(Ссылка, ЕстьНаряд) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если ЕстьНаряд Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ДвериСписокНоменклатуры.Номенклатура.Наименование КАК Наименование,
		|	ДвериСписокНоменклатуры.Длина КАК Длина,
		|	ДвериСписокНоменклатуры.Ширина КАК Ширина,
		|	ДвериСписокНоменклатуры.Количество КАК Количество,
		|	ВЫБОР
		|		КОГДА НЕ СписокПодЗаказ.Комментарий ЕСТЬ NULL 
		|			ТОГДА СписокПодЗаказ.Комментарий
		|		ИНАЧЕ ЕСТЬNULL(СписокМатЗаказчика.Комментарий, """")
		|	КОНЕЦ КАК Комментарий,
		|	ВЫБОР
		|		КОГДА СписокПодЗаказ.Номенклатура ЕСТЬ NULL 
		|				И СписокМатЗаказчика.Номенклатура ЕСТЬ NULL 
		|			ТОГДА 0
		|		ИНАЧЕ ВЫБОР
		|				КОГДА НЕ СписокПодЗаказ.Номенклатура ЕСТЬ NULL 
		|					ТОГДА 1
		|				ИНАЧЕ 2
		|			КОНЕЦ
		|	КОНЕЦ КАК ВидПредоставления
		|ИЗ
		|	Справочник.Двери.СписокНоменклатуры КАК ДвериСписокНоменклатуры
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СписокМатериаловПодЗаказ КАК СписокПодЗаказ
		|		ПО ДвериСписокНоменклатуры.Номенклатура = СписокПодЗаказ.Номенклатура
		|			И (СписокПодЗаказ.Ссылка = ДвериСписокНоменклатуры.Ссылка.Спецификация)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СписокМатериаловЗаказчика КАК СписокМатЗаказчика
		|		ПО ДвериСписокНоменклатуры.Номенклатура = СписокМатЗаказчика.Номенклатура
		|			И (СписокМатЗаказчика.Ссылка = ДвериСписокНоменклатуры.Ссылка.Спецификация)
		|ГДЕ
		|	ДвериСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
		|	И ДвериСписокНоменклатуры.Ссылка = &Ссылка
		|	И ДвериСписокНоменклатуры.Длина > 0
		|	И ДвериСписокНоменклатуры.Ширина > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
		
	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ДвериСписокНоменклатуры.Номенклатура.Наименование КАК Наименование,
		|	ВЫБОР
		|		КОГДА ДвериСписокНоменклатуры.Длина = 0
		|				И ДвериСписокНоменклатуры.Ширина > 0
		|			ТОГДА ДвериСписокНоменклатуры.Ширина
		|		ИНАЧЕ ДвериСписокНоменклатуры.Длина
		|	КОНЕЦ КАК Длина,
		|	ВЫБОР
		|		КОГДА ДвериСписокНоменклатуры.Длина = 0
		|				И ДвериСписокНоменклатуры.Ширина > 0
		|			ТОГДА 0
		|		ИНАЧЕ ДвериСписокНоменклатуры.Ширина
		|	КОНЕЦ КАК Ширина,
		|	ДвериСписокНоменклатуры.Количество КАК Количество,
		|	ВЫБОР
		|		КОГДА ДвериСписокНоменклатуры.Длина > 0
		|				И ДвериСписокНоменклатуры.Ширина > 0
		|			ТОГДА 0
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ДвериСписокНоменклатуры.Ширина > 0
		|						И ДвериСписокНоменклатуры.Длина = 0
		|					ТОГДА 1
		|				ИНАЧЕ 2
		|			КОНЕЦ
		|	КОНЕЦ КАК Порядок,
		|	ВЫБОР
		|		КОГДА НЕ СписокПодЗаказ.Комментарий ЕСТЬ NULL 
		|			ТОГДА СписокПодЗаказ.Комментарий
		|		ИНАЧЕ ЕСТЬNULL(СписокМатЗаказчика.Комментарий, """")
		|	КОНЕЦ КАК Комментарий,
		|	ВЫБОР
		|		КОГДА СписокПодЗаказ.Номенклатура ЕСТЬ NULL 
		|				И СписокМатЗаказчика.Номенклатура ЕСТЬ NULL 
		|			ТОГДА 0
		|		ИНАЧЕ ВЫБОР
		|				КОГДА НЕ СписокПодЗаказ.Номенклатура ЕСТЬ NULL 
		|					ТОГДА 1
		|				ИНАЧЕ 2
		|			КОНЕЦ
		|	КОНЕЦ КАК ВидПредоставления
		|ИЗ
		|	Справочник.Двери.СписокНоменклатуры КАК ДвериСписокНоменклатуры
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СписокМатериаловПодЗаказ КАК СписокПодЗаказ
		|		ПО ДвериСписокНоменклатуры.Номенклатура = СписокПодЗаказ.Номенклатура
		|			И (СписокПодЗаказ.Ссылка = ДвериСписокНоменклатуры.Ссылка.Спецификация)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СписокМатериаловЗаказчика КАК СписокМатЗаказчика
		|		ПО ДвериСписокНоменклатуры.Номенклатура = СписокМатЗаказчика.Номенклатура
		|			И (СписокМатЗаказчика.Ссылка = ДвериСписокНоменклатуры.Ссылка.Спецификация)
		|ГДЕ
		|	ДвериСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
		|	И ДвериСписокНоменклатуры.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок,
		|	Наименование";
		
	КонецЕсли;
	
	Таблица =  Запрос.Выполнить().Выгрузить();
	Строка = "";
	Мас = Новый Массив();
	
	Для Каждого Стр Из Таблица Цикл
		
		Мас.Добавить(Стр.Наименование + "♥" + Стр.Количество + "♥" + Стр.Ширина + "♥" + Стр.Длина + "♥" + Стр.Комментарий + "♥" + Стр.ВидПредоставления);
		
	КонецЦикла;
	
	Строка = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(Мас, "♦");
	
	Возврат Строка;
	
КонецФункции

Функция ПолучитьДанныеДляПечатиДвери(Данные, Примечание) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Наряд","");
	Результат.Вставить("ДатаИзготовления","");
	Результат.Вставить("Очередь","");
	Результат.Вставить("НомерДверь","");
	Результат.Вставить("НомерСпец","");
	Результат.Вставить("НомерДоговор","");
	Результат.Вставить("ТаблицаХлысты","");
	
	Если ЗначениеЗаполнено(Данные.ТекущаяДверь) Тогда
		Результат.Вставить("НомерДверь", ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Данные.ТекущаяДверь.Код));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Данные.Спецификация) Тогда
		Результат.Вставить("НомерСпец", ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Данные.Спецификация.Номер));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Данные.Договор) Тогда
		Результат.Вставить("НомерДоговор", ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Данные.Договор.Номер));
	КонецЕсли;
	
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		Результат.Вставить("ТаблицаНоменклатуры", Справочники.Двери.ПолучитьТаблицуНоменклатурыНаПечать(Данные.ТекущаяДверь, Ложь));
		
	Иначе
		
		ЗапросНаряд = Новый Запрос;
		ЗапросНаряд.УстановитьПараметр("Спецификация", Данные.Спецификация);
		ЗапросНаряд.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Список.НомерСтроки КАК НомерСтроки,
		|	Список.Ссылка.Номер КАК НарядНомер,
		|	Список.Ссылка КАК Наряд,
		|	Список.ДатаИзготовления КАК ДатаИзготовления
		|ИЗ
		|	Документ.НарядЗадание.СписокСпецификаций КАК Список
		|ГДЕ
		|	Список.Спецификация = &Спецификация";
		
		РезультатЗапроса = ЗапросНаряд.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			
			Результат.Вставить("Наряд",ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Выборка.НарядНомер));
			Результат.Вставить("ДатаИзготовления", Формат(Выборка.ДатаИзготовления,"ДЛФ=D"));
			Результат.Вставить("Очередь", Выборка.НомерСтроки);
			
			Результат.Вставить("ТаблицаХлысты", Документы.НарядЗадание.ПолучитьХлыстовойМатериалНаДвери(Выборка.Наряд,Данные.ТекущаяДверь));
			Результат.Вставить("ТаблицаНоменклатуры", Справочники.Двери.ПолучитьТаблицуНоменклатурыНаПечать(Данные.ТекущаяДверь, Истина));
			
		Иначе
			
			Результат.Вставить("ТаблицаНоменклатуры", Справочники.Двери.ПолучитьТаблицуНоменклатурыНаПечать(Данные.ТекущаяДверь, Ложь));
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеДляПечати = Результат;
	
	Строка = "prtx☻" + Примечание + "☻" + "Спец:  <b>" + ДанныеДляПечати.НомерСпец + "</b>         Очередь: <b>№" + ДанныеДляПечати.Очередь + "</b>" + Символы.ПС 
	+ "Дверь: " + ДанныеДляПечати.НомерДверь + "         Наряд: " + ДанныеДляПечати.Наряд + Символы.ПС 
	+ "Договор: " + ДанныеДляПечати.НомерДоговор + "       Изготовить: <b>" + ДанныеДляПечати.ДатаИзготовления+"</b>"
	+ "☻" + ДанныеДляПечати.ТаблицаНоменклатуры
	+ "☻" + ДанныеДляПечати.ТаблицаХлысты;
	
	Возврат Строка;
	
КонецФункции