﻿
Функция СформироватьОтчет(ПараметрыОтчета) Экспорт
	
	ТабДокТаблица = Новый ТабличныйДокумент;
	ТабДокМонтажи = Новый ТабличныйДокумент;
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДок.ФиксацияСверху = 4;
	
	Макет = Отчеты.ЗамерыИВстречи.ПолучитьМакет("Макет");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаТаблица = Макет.ПолучитьОбласть("ШапкаТаблица|Таблица");
	ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаОтчета|Таблица");
	ОбластьСтрокаСотрудник = Макет.ПолучитьОбласть("СтрокаСотрудник|Таблица");
	
	ОбластьШапка.Параметры.Подразделение = ПараметрыОтчета.Подразделение;
	ОбластьШапка.Параметры.ПериодОтчета = ПредставлениеПериода(ПараметрыОтчета.ПериодОтчета.ДатаНачала, ПараметрыОтчета.ПериодОтчета.ДатаОкончания);
	ОбластьШапка.Параметры.Основание = ПараметрыОтчета.Основание;
	ТабДок.Вывести(ОбластьШапка);
	
	СписокОтветственных = ПараметрыОтчета.Ответственные;
	Если НЕ ЗначениеЗаполнено(СписокОтветственных) Тогда
		СписокОтветственных = NULL;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Подразделение", ПараметрыОтчета.Подразделение);
	Запрос.УстановитьПараметр("Ответственные", СписокОтветственных);
	Запрос.УстановитьПараметр("ДатаНачала", ПараметрыОтчета.ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ПараметрыОтчета.ПериодОтчета.ДатаОкончания));
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		Запрос.УстановитьПараметр("Дилер", ПараметрыСеанса.ТекущийКонтрагент);
	КонецЕсли;
	
	//Запрос.Текст = ПолучитьТекстЗапроса();
	
	Выборка = ВыполнитьЗапрос(Запрос);
	Пока Выборка.Следующий() Цикл
		
		ОбластьСтрокаСотрудник.Параметры.Заполнить(Выборка);
		ТабДокТаблица.Вывести(ОбластьСтрокаСотрудник);
		
		НачальнаяДата = Дата(1, 1, 1);
		
		ВыборкаПоСотруднику = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Время", "ВСЕ");
		Пока ВыборкаПоСотруднику.Следующий() Цикл
			
			Если ЗначениеЗаполнено(ВыборкаПоСотруднику.Время) Тогда
				Если НачалоДня(ВыборкаПоСотруднику.Время) <> НачальнаяДата Тогда
					НачальнаяДата = НачалоДня(ВыборкаПоСотруднику.Время);
					ОбластьШапкаТаблица.Параметры.Дата = ВыборкаПоСотруднику.Время;
					ТабДокТаблица.Вывести(ОбластьШапкаТаблица);
				КонецЕсли;
				
				ЧасВремени = Час(ВыборкаПоСотруднику.Время);
				ЭтоМонтаж = ТипЗнч(ВыборкаПоСотруднику.Ссылка) = Тип("ДокументСсылка.Спецификация");
				
				Если ЧасВремени >= 9 И ЧасВремени <= 19 ИЛИ ЭтоМонтаж Тогда
					
					ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаОтчета|Таблица");
					
					ОбластьСтрока.Параметры.Расшифровка = Новый Структура(
					"Время, Ссылка, Основание, Подразделение, Ответственный",
					ВыборкаПоСотруднику.Время,
					ВыборкаПоСотруднику.Ссылка,
					ПараметрыОтчета.Основание,
					ПараметрыОтчета.Подразделение,
					ВыборкаПоСотруднику.Ответственный);
					
					Если ЭтоМонтаж Тогда
						
						ВыборкаПоДокументам = ВыборкаПоСотруднику.Выбрать();
						Пока ВыборкаПоДокументам.Следующий() Цикл
							
							ОбластьСтрока.Параметры.Заполнить(ВыборкаПоДокументам);
							
							Если ОбластьСтрока.Параметры.ВидСсылки = "ЗВ" Тогда
								 ОбластьСтрока.Параметры.ВидСсылки = "";
							Иначе	 
								 ОбластьСтрока.Рисунки.Удалить(ОбластьСтрока.Рисунки.D1);
							КонецЕсли;
							
							ОбластьСтрока.Параметры.Время = Неопределено;
							ТабДокМонтажи.Вывести(ОбластьСтрока);
						КонецЦикла;
						
					Иначе
						
						ОбластьСтрока.Параметры.Заполнить(ВыборкаПоСотруднику);
						
						Если ОбластьСтрока.Параметры.ВидСсылки = "ЗВ" Тогда
							 ОбластьСтрока.Параметры.ВидСсылки = "";
						Иначе	 
							 ОбластьСтрока.Рисунки.Удалить(ОбластьСтрока.Рисунки.D1);
						КонецЕсли;
						
						ТабДокТаблица.Вывести(ОбластьСтрока);
						
					КонецЕсли;
					
				ИначеЕсли ЧасВремени = 23 Тогда
					
					ТабДокТаблица.Вывести(ТабДокМонтажи);
					ТабДокМонтажи.Очистить();
					
				КонецЕсли;
				
			КонецЕсли; // ЗначениеЗаполнено(ВыборкаПоСотруднику.Время)
			
		КонецЦикла; // Пока ВыборкаПоСотруднику.Следующий() Цикл
		
		ТабДок.Присоединить(ТабДокТаблица);
		ТабДокТаблица.Очистить();
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Функция ВыполнитьЗапрос(Запрос)
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФизическиеЛица.Ссылка КАК ФизЛицо,
	|	ФизическиеЛица.Подразделение КАК Подразделение
	|ПОМЕСТИТЬ ВТ_Сотрудники
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ФизическиеЛица.Подразделение = &Подразделение
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &Ответственные ЕСТЬ NULL
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ФизическиеЛица.Ссылка В (&Ответственные)
	|		КОНЕЦ
	|	И ФизическиеЛица.Активность
	|	И ФизическиеЛица.ЗамерыИВстречи";
	Запрос.Выполнить();
	
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗамерыИВстречи.Регистратор КАК Ссылка,
		|	ЗамерыИВстречи.Период КАК Дата,
		|	ЗамерыИВстречи.Сотрудник КАК Ответственный,
		|	ВЫБОР
		|		КОГДА ЗамерыИВстречи.Регистратор.Дилер = &Дилер
		|			ТОГДА ЗамерыИВстречи.Регистратор.ИмяЗаказчика + "" / "" + ЗамерыИВстречи.Регистратор.АдресЗамера
		|		ИНАЧЕ ""Занят""
		|	КОНЕЦ КАК ИмяАдрес,
		|	""З"" КАК ВидСсылки
		|ПОМЕСТИТЬ ВТ_ВстречиЗамеры
		|ИЗ
		|	РегистрСведений.ГрафикВстречИЗамеров КАК ЗамерыИВстречи
		|ГДЕ
		|	(ЗамерыИВстречи.Сотрудник, ЗамерыИВстречи.Подразделение) В
		|			(ВЫБРАТЬ
		|				ВТ.ФизЛицо,
		|				ВТ.Подразделение
		|			ИЗ
		|				ВТ_Сотрудники КАК ВТ)
		|	И ЗамерыИВстречи.Период МЕЖДУ &ДатаНачала И &ДатаОкончания";
		
	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗамерыИВстречи.Регистратор КАК Ссылка,
		|	ЗамерыИВстречи.Период КАК Дата,
		|	ЗамерыИВстречи.Сотрудник КАК Ответственный,
		|	ВЫБОР
		|		КОГДА ЗамерыИВстречи.Регистратор ССЫЛКА Документ.ВстречаСКлиентом
		|			ТОГДА ЗамерыИВстречи.Регистратор.Основание.ИмяЗаказчика + "" / "" + ЗамерыИВстречи.Регистратор.Основание.АдресЗамера
		|		КОГДА ЗамерыИВстречи.Регистратор ССЫЛКА Документ.Замер
		|			ТОГДА ЗамерыИВстречи.Регистратор.ИмяЗаказчика + "" / "" + ЗамерыИВстречи.Регистратор.АдресЗамера
		|		ИНАЧЕ ""?""
		|	КОНЕЦ КАК ИмяАдрес,
		|	ВЫБОР
		|		КОГДА ЗамерыИВстречи.Регистратор ССЫЛКА Документ.ВстречаСКлиентом
		|			ТОГДА ВЫБОР
		|					КОГДА ЗамерыИВстречи.Регистратор.Звонок
		|						ТОГДА ""ЗВ""
		|					ИНАЧЕ ""В""
		|				КОНЕЦ
		|		КОГДА ЗамерыИВстречи.Регистратор ССЫЛКА Документ.Замер
		|			ТОГДА ""З""
		|		ИНАЧЕ ""?""
		|	КОНЕЦ КАК ВидСсылки
		|ПОМЕСТИТЬ ВТ_ВстречиЗамеры
		|ИЗ
		|	РегистрСведений.ГрафикВстречИЗамеров КАК ЗамерыИВстречи
		|ГДЕ
		|	(ЗамерыИВстречи.Сотрудник, ЗамерыИВстречи.Подразделение) В
		|			(ВЫБРАТЬ
		|				ВТ.ФизЛицо,
		|				ВТ.Подразделение
		|			ИЗ
		|				ВТ_Сотрудники КАК ВТ)
		|	И ЗамерыИВстречи.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Монтажи.Спецификация,
		|	Монтажи.День,
		|	Монтажи.Спецификация.ДокументОснование.Замерщик,
		|	Монтажи.Спецификация.АдресМонтажа,
		|	""М""
		|ИЗ
		|	РегистрСведений.РабочиеДниМонтажников КАК Монтажи
		|ГДЕ
		|	(Монтажи.Спецификация.ДокументОснование.Замерщик, Монтажи.Спецификация.Подразделение) В
		|			(ВЫБРАТЬ
		|				ВТ.ФизЛицо,
		|				ВТ.Подразделение
		|			ИЗ
		|				ВТ_Сотрудники КАК ВТ)
		|	И Монтажи.День МЕЖДУ &ДатаНачала И &ДатаОкончания";
		
	КонецЕсли;
	
	Запрос.Выполнить();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВТ_Сотрудники.ФизЛицо КАК Ответственный,
	|	ВТ_ВстречиЗамеры.Ссылка КАК Ссылка,
	|	ВЫРАЗИТЬ(ВТ_ВстречиЗамеры.Дата КАК ДАТА) КАК Время,
	|	ВТ_ВстречиЗамеры.ИмяАдрес КАК ИмяАдрес,
	|	ВТ_ВстречиЗамеры.ВидСсылки КАК ВидСсылки
	|ИЗ
	|	ВТ_Сотрудники КАК ВТ_Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВстречиЗамеры КАК ВТ_ВстречиЗамеры
	|		ПО ВТ_Сотрудники.ФизЛицо = ВТ_ВстречиЗамеры.Ответственный
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТ_Сотрудники.ФизЛицо,
	|	Время
	|ИТОГИ
	|	МАКСИМУМ(Ссылка),
	|	МАКСИМУМ(ИмяАдрес),
	|	МАКСИМУМ(ВидСсылки)
	|ПО
	|	Ответственный,
	|	Время ПЕРИОДАМИ(ЧАС, &ДатаНачала, &ДатаОкончания)";
	
	Возврат Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);;
	
КонецФункции
