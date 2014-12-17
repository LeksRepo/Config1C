﻿
Функция СформироватьОтчет(ПараметрыОтчета, ОтчетСтДиз = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ПолеСверху = 5;
	ТабДок.ПолеСлева = 5;
	ТабДок.ПолеСнизу = 5;
	ТабДок.ПолеСправа = 5;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	СтаршийДизайнер = ?(ПараметрыОтчета.Свойство("СтаршийДизайнер"), ПараметрыОтчета.СтаршийДизайнер, Справочники.ФизическиеЛица.ПустаяСсылка());
	
	ЕстьСтаршийДизайнер = ЗначениеЗаполнено(СтаршийДизайнер);
		
	Макет = Отчеты.ОтчетСтаршегоДизайнера.ПолучитьМакет("Макет");
	
	ОбластьШапкаДоговоры = Макет.ПолучитьОбласть("ШапкаДоговоры");
	ОбластьСтрокаДоговоры = Макет.ПолучитьОбласть("СтрокаДоговоры");	
	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");
	ОбластьШапка = Макет.ПолучитьОбласть("ШапкаОбщ");
	ОбластьШапкаЗамеры = Макет.ПолучитьОбласть("ШапкаЗамерыОбщ");
	ОбластьСтрокаЗамеры = Макет.ПолучитьОбласть("СтрокаЗамерыОбщ");
	ОбластьШапкаМонтаж = Макет.ПолучитьОбласть("ШапкаМонтажОбщ");
	ОбластьСтрокаМонтаж = Макет.ПолучитьОбласть("СтрокаМонтажОбщ");
	ОбластьШапкаАкт = Макет.ПолучитьОбласть("ШапкаАкт");
	ОбластьСтрокаАкт = Макет.ПолучитьОбласть("СтрокаАкт");
	
	# Область Запрос
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регион", ПараметрыОтчета.Подразделение.Регион);
	Запрос.УстановитьПараметр("СтаршийДизайнер", СтаршийДизайнер);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	докЗамер.АдресЗамера + "", тел. "" + докЗамер.Телефон + "" ("" + докЗамер.ИмяЗаказчика + "")"" КАК Адрес,
	|	докЗамер.Замерщик.Фамилия + "" "" + ПОДСТРОКА(докЗамер.Замерщик.Имя, 1, 1) + "". "" + ПОДСТРОКА(докЗамер.Замерщик.Отчество, 1, 1) + ""."" КАК Замерщик,
	|	докЗамер.Офис КАК Офис,
	|	докЗамер.Автор.ФизическоеЛицо.Фамилия + "" "" + ПОДСТРОКА(докЗамер.Автор.ФизическоеЛицо.Имя, 1, 1) + "". "" + ПОДСТРОКА(докЗамер.Автор.ФизическоеЛицо.Отчество, 1, 1) + ""."" КАК Автор,
	|	докЗамер.Ссылка КАК Предмет,
	|	докЗамер.Дата КАК ДатаЗамера,
	|	Встречи.Встреча.Дата КАК ДатаВстречи,
	|	Встречи.Встреча.Ответственный.Фамилия + "" "" + ПОДСТРОКА(Встречи.Встреча.Ответственный.Имя, 1, 1) + "". "" + ПОДСТРОКА(Встречи.Встреча.Ответственный.Отчество, 1, 1) + ""."" КАК Дизайнер,
	|	NULL КАК Статус,
	|	NULL КАК ДатаМонтажа,
	|	""Замер"" КАК Вид,
	|	NULL КАК Изделие,
	|	NULL КАК Монтажник,
	|	Встречи.Встреча.Ответственный.Фамилия КАК Фамилия,
	|	ВЫБОР
	|		КОГДА НаличиеЗаметокПоПредмету.ЕстьЗаметка ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ НаличиеЗаметокПоПредмету.ЕстьЗаметка
	|	КОНЕЦ КАК Заметка,
	|	докЗамер.Комментарий КАК Примечание,
	|	докЗамер.Телефон КАК ТелефонКлиента,
	|	NULL КАК РазницаДат
	|ИЗ
	|	Документ.Замер КАК докЗамер
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АктивностьЗамеров КАК АктивностьЗамеров
	|		ПО (АктивностьЗамеров.Замер = докЗамер.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеЗаметокПоПредмету КАК НаличиеЗаметокПоПредмету
	|		ПО (докЗамер.Ссылка = (ВЫРАЗИТЬ(НаличиеЗаметокПоПредмету.Предмет КАК Документ.Замер)))
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			Замер.Ссылка КАК Ссылка,
	|			МИНИМУМ(ВстречаСКлиентом.Ссылка) КАК Встреча
	|		ИЗ
	|			Документ.Замер КАК Замер
	|				ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВстречаСКлиентом КАК ВстречаСКлиентом
	|				ПО (ВстречаСКлиентом.Основание = Замер.Ссылка)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			Замер.Ссылка) КАК Встречи
	|		ПО докЗамер.Ссылка = Встречи.Ссылка
	|ГДЕ
	|	АктивностьЗамеров.Статус
	|	И докЗамер.Подразделение.Регион = &Регион
	|	И ВЫБОР
	|			КОГДА &СтаршийДизайнер <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|				ТОГДА докЗамер.Замерщик = &СтаршийДизайнер
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	докСпецификация.АдресМонтажа + "", тел. "" + ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Телефон + "" ("" + ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).ИмяЗаказчика + "")"",
	|	ВЫБОР
	|		КОГДА докСпецификация.ДокументОснование ССЫЛКА Документ.Замер
	|			ТОГДА ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Фамилия + "" "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Имя, 1, 1) + "". "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Отчество, 1, 1) + "".""
	|		КОГДА докСпецификация.ДокументОснование = НЕОПРЕДЕЛЕНО
	|			ТОГДА ВЫРАЗИТЬ(докСпецификация.Автор КАК Справочник.Пользователи).ФизическоеЛицо.Руководитель.Фамилия + "" "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.Автор КАК Справочник.Пользователи).ФизическоеЛицо.Руководитель.Имя, 1, 1) + "". "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.Автор КАК Справочник.Пользователи).ФизическоеЛицо.Руководитель.Отчество, 1, 1) + "".""
	|	КОНЕЦ,
	|	NULL,
	|	NULL,
	|	докСпецификация.Ссылка,
	|	NULL,
	|	NULL,
	|	NULL,
	|	СтатусСпецификацииСрезПоследних.Статус,
	|	докСпецификация.ДатаМонтажа,
	|	""Монтаж"",
	|	докСпецификация.Изделие,
	|	докСпецификация.Монтажник.Фамилия + "" "" + ПОДСТРОКА(докСпецификация.Монтажник.Имя, 1, 1) + "". "" + ПОДСТРОКА(докСпецификация.Монтажник.Отчество, 1, 1) + ""."",
	|	ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Фамилия,
	|	ВЫБОР
	|		КОГДА НаличиеЗаметокПоПредмету.ЕстьЗаметка ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ НаличиеЗаметокПоПредмету.ЕстьЗаметка
	|	КОНЕЦ,
	|	NULL,
	|	NULL,
	|	ВЫБОР
	|		КОГДА РазмещенСрезПоследних.Период ЕСТЬ NULL 
	|			ТОГДА РАЗНОСТЬДАТ(&ТекущаяДата, докСпецификация.ДатаОтгрузки, ДЕНЬ)
	|		ИНАЧЕ РАЗНОСТЬДАТ(РазмещенСрезПоследних.Период, докСпецификация.ДатаОтгрузки, ДЕНЬ)
	|	КОНЕЦ
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО (СтатусСпецификацииСрезПоследних.Спецификация = докСпецификация.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеЗаметокПоПредмету КАК НаличиеЗаметокПоПредмету
	|		ПО (докСпецификация.Ссылка = (ВЫРАЗИТЬ(НаличиеЗаметокПоПредмету.Предмет КАК Документ.Спецификация)))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних(, Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен)) КАК РазмещенСрезПоследних
	|		ПО (РазмещенСрезПоследних.Спецификация = докСпецификация.Ссылка)
	|ГДЕ
	|	докСпецификация.Подразделение.Регион = &Регион
	|	И ВЫБОР
	|			КОГДА &СтаршийДизайнер <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|				ТОГДА ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик = &СтаршийДизайнер
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И докСпецификация.Проведен
	|	И СтатусСпецификацииСрезПоследних.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Установлен)
	|	И докСпецификация.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж)
	|	И докСпецификация.ДатаМонтажа <> ДАТАВРЕМЯ(1, 1, 1)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	докЗамер.АдресЗамера + "", тел. "" + докЗамер.Телефон + "" ("" + докЗамер.ИмяЗаказчика + "")"",
	|	докЗамер.Замерщик.Фамилия + "" "" + ПОДСТРОКА(докЗамер.Замерщик.Имя, 1, 1) + "". "" + ПОДСТРОКА(докЗамер.Замерщик.Отчество, 1, 1) + ""."",
	|	NULL,
	|	NULL,
	|	докАктВыполненияДоговора.Ссылка,
	|	докАктВыполненияДоговора.Дата,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	""НАкт"",
	|	NULL,
	|	NULL,
	|	докЗамер.Замерщик.Фамилия,
	|	NULL,
	|	докАктВыполненияДоговора.Комментарий,
	|	NULL,
	|	NULL
	|ИЗ
	|	Документ.АктВыполненияДоговора КАК докАктВыполненияДоговора
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Замер КАК докЗамер
	|		ПО ((ВЫРАЗИТЬ(докАктВыполненияДоговора.Договор.Спецификация.ДокументОснование КАК Документ.Замер)) = докЗамер.Ссылка)
	|ГДЕ
	|	докАктВыполненияДоговора.Подразделение.Регион = &Регион
	|	И докАктВыполненияДоговора.ДатаПередачи = ДАТАВРЕМЯ(1, 1, 1)
	|	И ВЫБОР
	|			КОГДА &СтаршийДизайнер <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|				ТОГДА докЗамер.Замерщик = &СтаршийДизайнер
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Вид,
	|	ДатаЗамера,
	|	ДатаМонтажа
	|ИТОГИ ПО
	|	Вид";
	
	#КонецОбласти
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ОбластьШапка.Параметры.ДатаОтчета = Формат(ТекущаяДата(), "ДЛФ=DD");
	ОбластьШапка.Параметры.Замерщик = СтаршийДизайнер;
	ШапкаПоказана = Ложь;
	
	Если ОтчетСтДиз Тогда
		ТабДок.Вывести(ОбластьШапка);
		ШапкаПоказана = Истина;
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		
		ВидОтчета = Выборка.Вид;
		
		ЭтоЗамеры = ВидОтчета = "Замер";
		ЭтоМонтаж = ВидОтчета = "Монтаж";
		ЭтоАкт = ВидОтчета = "НАкт"; 
		
		Если ОтчетСтДиз Тогда
			//ТабДок.Вывести(ОбластьПустаяСтрока);
			ТабДок.Вывести(ОбластьПустаяСтрока);
		КонецЕсли;
		
		Если ЭтоЗамеры Тогда
			ТабДок.Вывести(ОбластьШапкаЗамеры);
		ИначеЕсли ЭтоМонтаж И ОтчетСтДиз Тогда
			ТабДок.Вывести(ОбластьШапкаМонтаж);
		ИначеЕсли ЭтоАкт И ОтчетСтДиз Тогда	
			ТабДок.Вывести(ОбластьШапкаАкт);
		КонецЕсли;
		
		ВыборкаПоСотрудникам = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПоСотрудникам.Следующий() Цикл
			
			Если ЭтоЗамеры Тогда 
				
				ОбластьСтрокаЗамеры.Параметры.Заполнить(ВыборкаПоСотрудникам);
				ОбластьСтрокаЗамеры.Параметры.РасшифровкаАдрес = Новый Структура("РасшифровкаАдрес", ВыборкаПоСотрудникам.Предмет);
				ОбластьСтрокаЗамеры.Параметры.СтатусЗамеры = "";
				
				Если ЗначениеЗаполнено(ВыборкаПоСотрудникам.Заметка) И ВыборкаПоСотрудникам.Заметка Тогда
					ОбластьСтрокаЗамеры.Параметры.РасшифровкаЗаметка = Новый Структура("Заметка, Предмет", ВыборкаПоСотрудникам.Заметка, ВыборкаПоСотрудникам.Предмет);
				Иначе
					ОбластьСтрокаЗамеры.Параметры.РасшифровкаЗаметка = Неопределено;
				КонецЕсли;
				
				Если НачалоДня(ВыборкаПоСотрудникам.ДатаЗамера) = НачалоДня(ТекущаяДата()) Тогда
					ОбластьСтрокаЗамеры.Параметры.СтатусЗамеры = "Замер";
					ОбластьСтрокаЗамеры.Области.СтрокаЗамерыОбщ.Шрифт = Новый Шрифт(,9,Истина);
				ИначеЕсли НачалоДня(ВыборкаПоСотрудникам.ДатаЗамера) < НачалоДня(ТекущаяДата()) 
					И НачалоДня(ВыборкаПоСотрудникам.ДатаЗамера) >= НачалоДня(ДобавитьМесяц(ТекущаяДата(), -1)) Тогда
					ОбластьСтрокаЗамеры.Области.СтрокаЗамерыОбщ.ЦветТекста = Новый Цвет(0,0,0);
				ИначеЕсли НачалоДня(ВыборкаПоСотрудникам.ДатаЗамера) < НачалоДня(ДобавитьМесяц(ТекущаяДата(), -1)) Тогда
					ОбластьСтрокаЗамеры.Области.СтрокаЗамерыОбщ.ЦветТекста = Новый Цвет(252,0,0);	
				КонецЕсли;
				
				Если ЗначениеЗаполнено(ВыборкаПоСотрудникам.ДатаВстречи) Тогда
					Если НачалоДня(ВыборкаПоСотрудникам.ДатаВстречи) = НачалоДня(ТекущаяДата()) Тогда
						ОбластьСтрокаЗамеры.Параметры.СтатусЗамеры = "Встреча";
						ОбластьСтрокаЗамеры.Области.СтрокаЗамерыОбщ.Шрифт = Новый Шрифт(,9,Истина,Истина);
						ОбластьСтрокаЗамеры.Области.СтрокаЗамерыОбщ.ЦветТекста = Новый Цвет(0,0,0);
					ИначеЕсли НачалоДня(ВыборкаПоСотрудникам.ДатаВстречи) < НачалоДня(ТекущаяДата()) Тогда
						ОбластьСтрокаЗамеры.Параметры.ДатаВстречи = Неопределено;
					КонецЕсли;
				КонецЕсли;
				
				ТабДок.Вывести(ОбластьСтрокаЗамеры);
				
				ОбластьСтрокаЗамеры.Области.СтрокаЗамерыОбщ.ЦветТекста = Новый Цвет(0,0,0);
				ОбластьСтрокаЗамеры.Области.СтрокаЗамерыОбщ.Шрифт = Новый Шрифт(,8,Ложь,Ложь);
				
			ИначеЕсли ЭтоМонтаж И ОтчетСтДиз Тогда
				
				ОбластьСтрокаМонтаж.Параметры.Заполнить(ВыборкаПоСотрудникам);
				ОбластьСтрокаМонтаж.Параметры.РасшифровкаАдрес = Новый Структура("РасшифровкаАдрес", ВыборкаПоСотрудникам.Предмет);
				
				СтатусСпецификации = ?(ВыборкаПоСотрудникам.РазницаДат < 4, Строка(ВыборкаПоСотрудникам.Статус) + " (НР)", Строка(ВыборкаПоСотрудникам.Статус));
				ОбластьСтрокаМонтаж.Параметры.Статус = СтатусСпецификации;
								
				Если ЗначениеЗаполнено(ВыборкаПоСотрудникам.Заметка) И ВыборкаПоСотрудникам.Заметка Тогда
					ОбластьСтрокаМонтаж.Параметры.РасшифровкаЗаметка = Новый Структура("Заметка, Предмет", ВыборкаПоСотрудникам.Заметка, ВыборкаПоСотрудникам.Предмет);
				Иначе
					ОбластьСтрокаМонтаж.Параметры.РасшифровкаЗаметка = Неопределено;	
				КонецЕсли;
				
				Если НачалоДня(ВыборкаПоСотрудникам.ДатаМонтажа) = НачалоДня(ТекущаяДата()) Тогда
					ОбластьСтрокаМонтаж.Области.СтрокаМонтажОбщ.Шрифт = Новый Шрифт(,9,Истина);
				ИначеЕсли НачалоДня(ВыборкаПоСотрудникам.ДатаМонтажа) < НачалоДня(ТекущаяДата())
					ИЛИ Найти(СтатусСпецификации,"(НР)") > 0 Тогда
					ОбластьСтрокаМонтаж.Области.СтрокаМонтажОбщ.ЦветТекста = Новый Цвет(252,0,0);
				КонецЕсли;
				
				ТабДок.Вывести(ОбластьСтрокаМонтаж);
				
				ОбластьСтрокаМонтаж.Области.СтрокаМонтажОбщ.ЦветТекста = Новый Цвет(0,0,0);
				ОбластьСтрокаМонтаж.Области.СтрокаМонтажОбщ.Шрифт = Новый Шрифт(,8,Ложь,Ложь);
				
			ИначеЕсли ЭтоАкт И ОтчетСтДиз Тогда
				
				ОбластьСтрокаАкт.Параметры.Заполнить(ВыборкаПоСотрудникам);			
				ТабДок.Вывести(ОбластьСтрокаАкт);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяДата", КонецДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("Подразделение", ПараметрыОтчета.Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УправленческийОстатки.Субконто2 КАК Договор,
	|	Договор.Автор.ФизическоеЛицо КАК Автор,
	|	Договор.Комментарий,
	|	Договор.Подразделение,
	|	Договор.СуммаДокумента КАК СуммаДоговора
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			&ТекущаяДата,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ВзаиморасчетыСПокупателями),
	|			,
	|			Субконто2 ССЫЛКА Документ.Договор
	|				И (ВЫРАЗИТЬ(Субконто2 КАК Документ.Договор)) <> ЗНАЧЕНИЕ(Документ.Договор.ПустаяСсылка)
	|				И Подразделение = &Подразделение) КАК УправленческийОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК Договор
	|		ПО ((ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Документ.Договор)) = Договор.Ссылка)
	|ГДЕ
	|	Договор.Подразделение = &Подразделение";
	
	Выборка = Запрос.Выполнить().Выгрузить();
	ТЗ = Документы.Договор.РасчетПени(Выборка.ВыгрузитьКолонку("Договор"), КонецДня(ТекущаяДата()));
	
	Если ТЗ.Количество() > 0 Тогда
		
		Если НЕ ШапкаПоказана И ОтчетСтДиз Тогда
			ТабДок.Вывести(ОбластьПустаяСтрока);
			ОбластьШапка.Параметры.Замерщик = ФизическиеЛица.ФамилияИнициалыФизЛица(ТЗ[0].Автор);
			ТабДок.Вывести(ОбластьШапка);
		КонецЕсли;
		
		ТабДок.Вывести(ОбластьПустаяСтрока);
		ТабДок.Вывести(ОбластьШапкаДоговоры);
		
	КонецЕсли;
	
	Для Каждого Строка Из ТЗ Цикл
		
		Замер = Строка.Договор.Спецификация.ДокументОснование;
			
		ОбластьСтрокаДоговоры.Параметры.Заполнить(Строка);
		
		Если ТипЗнч(Замер) = Тип("ДокументСсылка.Замер") Тогда
			ОбластьСтрокаДоговоры.Параметры.Адрес = Замер.АдресЗамера + ", тел. " + Замер.Телефон + " (" + Замер.ИмяЗаказчика + ")";
		КонецЕсли;
		
		ОбластьСтрокаДоговоры.Параметры.ПервыйПросроченныйПлатеж = Формат(Строка.ПервыйПросроченныйПлатеж, "ДФ=dd.MM.yyyy");
		ОбластьСтрокаДоговоры.Параметры.Автор = ФизическиеЛица.ФамилияИнициалыФизЛица(Строка.Автор);
		ОбластьСтрокаДоговоры.Параметры.РасшифровкаДоговор = Новый Структура("РасшифровкаДоговор", Строка.Договор);
		ТабДок.Вывести(ОбластьСтрокаДоговоры);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции
