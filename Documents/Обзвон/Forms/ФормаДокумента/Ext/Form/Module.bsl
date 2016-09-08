﻿
&НаКлиенте
Процедура ЗаполнитьДоговоры(Команда)
	
	ЗаполнитьДоговорыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоговорыНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", НачалоДня(ТекущаяДата() - 8 * 86400));
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОбзвонСписокДоговоров.Договор,
	|	ОбзвонСписокДоговоров.Клиент КАК Клиент,
	|	ОбзвонСписокДоговоров.Телефон,
	|	МАКСИМУМ(ОбзвонСписокДоговоров.ОбщийКомментарий) КАК ОбщийКомментарий,
	|	ОбзвонСписокДоговоров.Клиент.Фамилия КАК Фамилия,
	|	МАКСИМУМ(ОбзвонСписокДоговоров.Ссылка.Дата) КАК ДатаЗвонка,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОбзвонСписокДоговоров.Ссылка.Дата) КАК КоличествоПерезвонить
	|ПОМЕСТИТЬ ВТ_Перезвон
	|ИЗ
	|	Документ.Обзвон.СписокДоговоров КАК ОбзвонСписокДоговоров
	|ГДЕ
	|	ОбзвонСписокДоговоров.ОбщаяОценка = ЗНАЧЕНИЕ(Перечисление.Оценки.Перезвонить)
	|	И НЕ ОбзвонСписокДоговоров.Договор В
	|				(ВЫБРАТЬ
	|					Дозвон.Договор
	|				ИЗ
	|					Документ.Обзвон.СписокДоговоров КАК Дозвон
	|				ГДЕ
	|					Дозвон.ОбщаяОценка <> ЗНАЧЕНИЕ(Перечисление.Оценки.Перезвонить))
	|	И ОбзвонСписокДоговоров.Ссылка <> &Ссылка
	|	И НЕ ОбзвонСписокДоговоров.Ссылка.ПометкаУдаления
	|
	|СГРУППИРОВАТЬ ПО
	|	ОбзвонСписокДоговоров.Клиент,
	|	ОбзвонСписокДоговоров.Договор,
	|	ОбзвонСписокДоговоров.Телефон,
	|	ОбзвонСписокДоговоров.Клиент.Фамилия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Перезвон.Договор,
	|	ВТ_Перезвон.Клиент,
	|	ВТ_Перезвон.Договор.Спецификация.АдресМонтажа КАК Адрес,
	|	ВТ_Перезвон.Телефон,
	|	ВТ_Перезвон.ОбщийКомментарий,
	|	ВТ_Перезвон.Фамилия,
	|	""Дизайн"" КАК ПодсказкаДизайн,
	|	""Замер"" КАК ПодсказкаЗамер,
	|	""Монтаж"" КАК ПодсказкаМонтаж,
	|	""Доставка"" КАК ПодсказкаДоставка,
	|	ВТ_Перезвон.ДатаЗвонка,
	|	ВТ_Перезвон.Договор.Офис КАК Офис,
	|	"""" КАК ПакетУслуг,
	|	ВТ_Перезвон.Договор.Представление КАК ПредставлениеДоговора,
	|	NULL КАК ДатаМонтажа
	|ИЗ
	|	ВТ_Перезвон КАК ВТ_Перезвон
	|ГДЕ
	|	ВТ_Перезвон.КоличествоПерезвонить < 2
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	докДоговор.Ссылка,
	|	докДоговор.Спецификация.Контрагент,
	|	докДоговор.Спецификация.АдресМонтажа,
	|	докДоговор.Спецификация.Контрагент.Телефон + "", "" + докДоговор.Спецификация.Контрагент.ТелефонДополнительный,
	|	докДоговор.Спецификация.Изделие.Наименование,
	|	докДоговор.Спецификация.Контрагент.Фамилия,
	|	""Дизайн"",
	|	""Замер"",
	|	""Монтаж"",
	|	""Доставка"",
	|	NULL,
	|	докДоговор.Офис,
	|	докДоговор.Спецификация.ПакетУслуг,
	|	докДоговор.Представление,
	|	докДоговор.Спецификация.ДатаМонтажа
	|ИЗ
	|	Документ.Договор КАК докДоговор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Обзвон.СписокДоговоров КАК ОбзвонСписокДоговоров
	|		ПО (ОбзвонСписокДоговоров.Договор = докДоговор.Ссылка)
	|ГДЕ
	|	ОбзвонСписокДоговоров.Договор ЕСТЬ NULL 
	|	И докДоговор.Дата >= ДАТАВРЕМЯ(2013, 10, 1, 0, 0, 0)
	|	И докДоговор.Проведен
	|	И докДоговор.Спецификация.ДатаМонтажа МЕЖДУ ДАТАВРЕМЯ(2013, 10, 1, 0, 0, 0) И &Дата
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТ_Перезвон.Фамилия";
	
	ТаблицаДоговоров = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Строка Из ТаблицаДоговоров Цикл
		
		Если ЗначениеЗаполнено(Строка.ПакетУслуг) Тогда
			Строка.ОбщийКомментарий = Строка.ОбщийКомментарий + " (" + Строка.ПакетУслуг + ")";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.ДатаМонтажа) Тогда
			Строка.ОбщийКомментарий = Строка.ОбщийКомментарий + " (Монтаж: " + Формат(Строка.ДатаМонтажа, "ДФ=dd.MM.yyyy") + ")";
		КонецЕсли;
		
		Строка.ПредставлениеДоговора = Строка.ПредставлениеДоговора + " (" + Строка.Офис + ")";
		
	КонецЦикла;
	
	Объект.СписокДоговоров.Загрузить(ТаблицаДоговоров);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.СписокДоговоровЗаполнить.Доступность = НЕ ЗначениеЗаполнено(Объект.Ссылка);
	ЗаполнитьПоля();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СписокДоговоровЗаполнить.Доступность = НЕ ЗначениеЗаполнено(Объект.Проведен);
	ЗаполнитьПоля();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоля()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДоговоров", Объект.СписокДоговоров.Выгрузить());
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДоговоров.Договор
	|ПОМЕСТИТЬ ТаблицаДоговоров
	|ИЗ
	|	&ТаблицаДоговоров КАК ТаблицаДоговоров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаДоговоров.Договор,
	|	ОбзвонСписокДоговоров.Ссылка.Дата,
	|	ОбзвонСписокДоговоров.Договор.Спецификация.ДатаМонтажа КАК ДатаМонтажа
	|ИЗ
	|	ТаблицаДоговоров КАК ТаблицаДоговоров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Обзвон.СписокДоговоров КАК ОбзвонСписокДоговоров
	|		ПО ТаблицаДоговоров.Договор = ОбзвонСписокДоговоров.Договор
	|ГДЕ
	|	ОбзвонСписокДоговоров.Ссылка <> &Ссылка
	|	И НЕ ОбзвонСписокДоговоров.Ссылка.ПометкаУдаления";
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	Если Объект.СписокДоговоров.Количество() > 0 Тогда
		
		Для Каждого Строка Из Объект.СписокДоговоров Цикл
			
			Строка.ПодсказкаДизайн = "Дизайн";
			Строка.ПодсказкаЗамер = "Замер";
			Строка.ПодсказкаМонтаж = "Монтаж";
			Строка.ПодсказкаДоставка = "Доставка";
			
			НайденнаяСтрока = ТЗ.Найти(Строка.Договор);
			Если НайденнаяСтрока <> Неопределено Тогда
				Строка.ДатаЗвонка = НайденнаяСтрока.Дата;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДоговоровПередУдалением(Элемент, Отказ)
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Текст = "Удалить обзвон по данному договору?";
	
	Если Объект.СписокДоговоров.Количество() > 0
		И Вопрос(Текст, Режим, 0) = КодВозвратаДиалога.Нет Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДилеров(Команда)
	ЗаполнитьДилеровНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДилеровНаСервере()
	
	Объект.СписокДилеров.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Спецификация.Контрагент
	|ИЗ
	|	Документ.Спецификация КАК Спецификация
	|ГДЕ
	|	Спецификация.Проведен
	|	И Спецификация.Дилерский
	|	И Спецификация.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Период, МЕСЯЦ) И КОНЕЦПЕРИОДА(&Период, МЕСЯЦ)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.СписокДилеров.Добавить();
		НоваяСтрока.Дилер = Выборка.Контрагент;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпецификации(Команда)
	ЗаполнитьСпецификацииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпецификацииНаСервере()
	
	Объект.СписокСпецификаций.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Подразделения.Ссылка
	|ИЗ
	|	Справочник.Подразделения КАК Подразделения
	|ГДЕ
	|	Подразделения.ВидПодразделения = ЗНАЧЕНИЕ(Перечисление.ВидыПодразделений.Производство)";
	
	ВыборкаПроизводств = Запрос.Выполнить().Выбрать();
		
	Пока ВыборкаПроизводств.Следующий() Цикл
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДатаОкончания", НачалоДня(ТекущаяДата()));
		Запрос.УстановитьПараметр("Подразделение", ВыборкаПроизводств.Ссылка);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(МАКСИМУМ(НАЧАЛОПЕРИОДА(Обзвон.Дата, ДЕНЬ)), ДОБАВИТЬКДАТЕ(&ДатаОкончания, ДЕНЬ, -8)) КАК Дата
		|ПОМЕСТИТЬ ВТ_ПоследняяДата
		|ИЗ
		|	Документ.Обзвон КАК Обзвон
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 15
		|	МАКСИМУМ(докСпецификация.Ссылка) КАК Спецификация,
		|	докСпецификация.Телефон КАК Телефон,
		|	докСпецификация.ДатаОтгрузки КАК ДатаОтгрузки
		|ИЗ
		|	Документ.Спецификация КАК докСпецификация
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК докДоговор
		|		ПО (докДоговор.Спецификация = докСпецификация.Ссылка),
		|	ВТ_ПоследняяДата КАК ВТ_ПоследняяДата
		|ГДЕ
		|	докСпецификация.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ЧастноеЛицо)
		|	И докДоговор.Спецификация ЕСТЬ NULL 
		|	И докСпецификация.Проведен
		|	И НЕ докСпецификация.Дилерский
		|	И докСпецификация.СуммаДокумента > 5000
		|	И докСпецификация.Изделие <> ЗНАЧЕНИЕ(Справочник.Изделия.Переделка)
		|	И докСпецификация.Изделие <> ЗНАЧЕНИЕ(Справочник.Изделия.ДопСоглашение)
		|	И докСпецификация.Подразделение = &Подразделение
		|	И докСпецификация.ДатаОтгрузки МЕЖДУ ВТ_ПоследняяДата.Дата И ДОБАВИТЬКДАТЕ(&ДатаОкончания, ДЕНЬ, -1)
		|
		|СГРУППИРОВАТЬ ПО
		|	докСпецификация.Телефон,
		|	докСпецификация.ДатаОтгрузки
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаОтгрузки ВОЗР";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = Объект.СписокСпецификаций.Добавить();
			НоваяСтрока.Спецификация = Выборка.Спецификация;
			НоваяСтрока.Телефон = Выборка.Телефон;			
			НоваяСтрока.Комментарий = НоваяСтрока.Комментарий + "(Отгрузка: " + Формат(Выборка.ДатаОтгрузки, "ДФ=dd.MM.yyyy") + ")";
			
		КонецЦикла
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСпецификацийПередУдалением(Элемент, Отказ)
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Текст = "Удалить обзвон по данной спецификации?";
	
	Если Объект.СписокСпецификаций.Количество() > 0 
		И Вопрос(Текст, Режим, 0) = КодВозвратаДиалога.Нет Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

