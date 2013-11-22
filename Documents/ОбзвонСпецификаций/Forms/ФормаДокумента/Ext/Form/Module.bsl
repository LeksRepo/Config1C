﻿
&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
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
		Запрос.УстановитьПараметр("Производство", ВыборкаПроизводств.Ссылка);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(МАКСИМУМ(НАЧАЛОПЕРИОДА(ОбзвонСпецификаций.Дата, ДЕНЬ)), ДОБАВИТЬКДАТЕ(&ДатаОкончания, ДЕНЬ, -8)) КАК Дата
		|ПОМЕСТИТЬ ВТ_ПоследняяДата
		|ИЗ
		|	Документ.ОбзвонСпецификаций КАК ОбзвонСпецификаций
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(докСпецификация.Ссылка) КАК Спецификация,
		|	докСпецификация.Контрагент,
		|	докСпецификация.Контрагент.Телефон + "", "" + докСпецификация.Контрагент.ТелефонДополнительный КАК Телефон,
		|	МАКСИМУМ(докСпецификация.ДатаОтгрузки) КАК ДатаОтгрузки
		|ИЗ
		|	Документ.Спецификация КАК докСпецификация,
		|	ВТ_ПоследняяДата КАК ВТ_ПоследняяДата
		|ГДЕ
		|	докСпецификация.Проведен
		|	И докСпецификация.ДатаОтгрузки МЕЖДУ ВТ_ПоследняяДата.Дата И ДОБАВИТЬКДАТЕ(&ДатаОкончания, ДЕНЬ, -1)
		|	И докСпецификация.Дилерский
		|	И докСпецификация.Производство = &Производство
		|
		|СГРУППИРОВАТЬ ПО
		|	докСпецификация.Контрагент,
		|	докСпецификация.Контрагент.Телефон + "", "" + докСпецификация.Контрагент.ТелефонДополнительный
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 15
		|	докСпецификация.Ссылка,
		|	NULL,
		|	докСпецификация.Телефон,
		|	докСпецификация.ДатаОтгрузки
		|ИЗ
		|	Документ.Спецификация КАК докСпецификация
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК докДоговор
		|		ПО (докДоговор.Спецификация = докСпецификация.Ссылка),
		|	ВТ_ПоследняяДата КАК ВТ_ПоследняяДата
		|ГДЕ
		|	докСпецификация.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ЧастноеЛицо)
		|	И докДоговор.Спецификация ЕСТЬ NULL 
		|	И докСпецификация.Проведен
		|	И докСпецификация.Производство = &Производство
		|	И докСпецификация.ДатаОтгрузки МЕЖДУ ВТ_ПоследняяДата.Дата И ДОБАВИТЬКДАТЕ(&ДатаОкончания, ДЕНЬ, -1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаОтгрузки УБЫВ";
		
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = Объект.СписокСпецификаций.Добавить();
			НоваяСтрока.Спецификация = Выборка.Спецификация;
			НоваяСтрока.Телефон = Выборка.Телефон;
			
			Если ЗначениеЗаполнено(Выборка.Контрагент) Тогда
				НоваяСтрока.Комментарий = "Дилерский";
			КонецЕсли;
			
			 НоваяСтрока.Комментарий = НоваяСтрока.Комментарий + " (Отгрузка: " + Формат(Выборка.ДатаОтгрузки, "ДФ=dd.MM.yyyy") + ")";
			 
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
