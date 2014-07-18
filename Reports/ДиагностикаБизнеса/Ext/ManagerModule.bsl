﻿
Функция СформироватьОтчет(ПараметрыОтчета) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДокСлужебок = Новый ТабличныйДокумент;

	ТабДок.АвтоМасштаб = Истина;
	
	Макет = Отчеты.ДиагностикаБизнеса.ПолучитьМакет("Макет");
	
	Тело = Макет.ПолучитьОбласть("Тело|КолонкиТело");
	СтрокаПодразделение = Макет.ПолучитьОбласть("СтрокаПодразделение|КолонкиТело");
	СтрокаДоговор = Макет.ПолучитьОбласть("ШапкаДоговор|КолонкиДоговор");
	СтрокаАкт = Макет.ПолучитьОбласть("ШапкаАкт|КолонкиАкт");
	ШапкаСлужебок = Макет.ПолучитьОбласть("ШапкаСлужебок|КолонкиСлужебок");
	СтрокаСлужебок = Макет.ПолучитьОбласть("СтрокаСлужебок|КолонкиСлужебок"); 
	ШапкаСпецификации = Макет.ПолучитьОбласть("ШапкаСпецификация|КолонкиВыпуска");
	ШапкаВыпуска = Макет.ПолучитьОбласть("ШапкаВыпуск|КолонкиВыпуска");
	
	#Область Запрос_отчета
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаОтчета", ПараметрыОтчета.Дата);	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	докМонтаж.ДатаМонтажа КАК ДатаМонтажа,
	|	докДоговор.Спецификация,
	|	докДоговор.Номер КАК НомерДоговора,
	|	докДоговор.Спецификация.Номер КАК НомерСпецификации,
	|	докДоговор.Спецификация.Изделие КАК ВидИзделия,
	|	докМонтаж.Монтажник,
	|	докМонтаж.Экспедитор,
	|	докДоговор.Автор.ФизическоеЛицо КАК Дизайнер,
	|	ВЫРАЗИТЬ(докДоговор.Спецификация.ДокументОснование КАК Документ.Замер).Замерщик КАК Замерщик,
	|	докДоговор.Спецификация.АдресМонтажа КАК Адрес,
	|	докДоговор.Спецификация.Производство КАК Подразделение,
	|	докДоговор.Ссылка КАК Договор,
	|	ВЫБОР
	|		КОГДА докАктВыполненияДоговора.Ссылка ЕСТЬ NULL 
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК Порядок,
	|	докАктВыполненияДоговора.Номер КАК НомерАкта,
	|	докАктВыполненияДоговора.Ссылка КАК Акт,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаИзготовления
	|ПОМЕСТИТЬ ВТ_Доки
	|ИЗ
	|	Документ.Договор КАК докДоговор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктВыполненияДоговора КАК докАктВыполненияДоговора
	|		ПО (докАктВыполненияДоговора.Договор = докДоговор.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Монтаж КАК докМонтаж
	|		ПО докДоговор.Спецификация = докМонтаж.Спецификация
	|ГДЕ
	|	докДоговор.Спецификация.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж)
	|	И докМонтаж.ДатаМонтажа <= &ДатаОтчета
	|	И (докАктВыполненияДоговора.Дата ЕСТЬ NULL 
	|			ИЛИ докАктВыполненияДоговора.ДатаПередачи = ДАТАВРЕМЯ(1, 1, 1)
	|				И докАктВыполненияДоговора.Дата <= &ДатаОтчета)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДАТАВРЕМЯ(1, 1, 1),
	|	докСпецификация.Ссылка,
	|	NULL,
	|	докСпецификация.Номер,
	|	докСпецификация.Изделие,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	докСпецификация.АдресМонтажа,
	|	докСпецификация.Производство,
	|	NULL,
	|	3,
	|	NULL,
	|	NULL,
	|	докСпецификация.ДатаИзготовления
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВыпускПродукции.СписокСпецификаций КАК ВыпускПродукцииСписокСпецификаций
	|		ПО (ВыпускПродукцииСписокСпецификаций.Спецификация = докСпецификация.Ссылка)
	|ГДЕ
	|	докСпецификация.ДатаИзготовления <= &ДатаОтчета
	|	И ВыпускПродукцииСписокСпецификаций.Ссылка ЕСТЬ NULL 
	|	И докСпецификация.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Доки.ДатаМонтажа КАК ДатаМонтажа,
	|	ВТ_Доки.Спецификация КАК Спецификация,
	|	ВТ_Доки.НомерДоговора,
	|	ВТ_Доки.НомерСпецификации,
	|	ВТ_Доки.ВидИзделия,
	|	ВТ_Доки.Монтажник,
	|	ВТ_Доки.Экспедитор,
	|	ВТ_Доки.Дизайнер,
	|	ВТ_Доки.Замерщик,
	|	ВТ_Доки.Адрес,
	|	ВТ_Доки.Подразделение КАК Подразделение,
	|	ВТ_Доки.Договор КАК Договор,
	|	ВТ_Доки.Порядок КАК Порядок,
	|	ВТ_Доки.НомерАкта,
	|	ВТ_Доки.Акт,
	|	ВТ_Доки.ДатаИзготовления КАК ДатаИзготовления,
	|	СлужебнаяЗаписка.Ссылка КАК СЗ,
	|	Заметки.ТекстСодержания КАК Текст
	|ИЗ
	|	ВТ_Доки КАК ВТ_Доки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Заметки КАК Заметки
	|		ПО (ВТ_Доки.Спецификация = (ВЫРАЗИТЬ(Заметки.Предмет КАК Документ.Спецификация)))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СлужебнаяЗаписка КАК СлужебнаяЗаписка
	|		ПО (ВТ_Доки.Договор = СлужебнаяЗаписка.Документ
	|				ИЛИ ВТ_Доки.Спецификация = СлужебнаяЗаписка.Документ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	ДатаМонтажа,
	|	ДатаИзготовления
	|ИТОГИ ПО
	|	Подразделение,
	|	Спецификация";
	
	#КонецОбласти
	
	ВыборкаПоПодразделениям = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоПодразделениям.Следующий() Цикл
		
		СтрокаПодразделение.Параметры.Заполнить(ВыборкаПоПодразделениям);				
		ТабДок.Вывести(СтрокаПодразделение);	
		ТабДок.НачатьГруппуСтрок();	
		
		ВыборкаПоДоговорам = ВыборкаПоПодразделениям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПоДоговорам.Следующий() Цикл
			
			Выборка = ВыборкаПоДоговорам.Выбрать();
			
			Выборка.Следующий();
			
			Тело.Параметры.Заполнить(Выборка);
			
			Если ЗначениеЗаполнено(Выборка.Договор) Тогда
				
				СтрокаДоговор.Параметры.Заполнить(Выборка);
				СтрокаДоговор.Параметры.РасшифровкаСпецификация = Новый Структура("Спецификация", Выборка.Спецификация);
				СтрокаДоговор.Параметры.РасшифровкаДоговор = Новый Структура("Договор", Выборка.Договор);
				ТабДок.Вывести(СтрокаДоговор);
				
			Иначе
				
				ШапкаСпецификации.Параметры.Заполнить(Выборка);
				ШапкаСпецификации.Параметры.РасшифровкаСпецификация = Новый Структура("Спецификация", Выборка.Спецификация);
				ТабДок.Вывести(ШапкаСпецификации);
				
			КонецЕсли;
			
			ШапкаСлужебок.Параметры.Расшифровка = Новый Структура("Ссылка, Текст", Выборка.Спецификация, Выборка.Текст);					
			
			Если ЗначениеЗаполнено(Выборка.ДатаИзготовления) Тогда
				
				ШапкаВыпуска.Параметры.ДатаИзготовления = Формат(Выборка.ДатаИзготовления,"ДЛФ=DD");
				ТабДок.Вывести(ШапкаВыпуска);
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Выборка.НомерАкта) Тогда
				
				СтрокаАкт.Параметры.Заполнить(Выборка);
				СтрокаАкт.Параметры.РасшифровкаАкта = Новый Структура("Акт", Выборка.Акт);
				ТабДок.Вывести(СтрокаАкт);
				
			КонецЕсли;
			
			ТабДок.Вывести(Тело);
			
			Выборка.Сбросить();
			
			ТабДокСлужебок.Очистить();
			ТабДокСлужебок.Вывести(ШапкаСлужебок);
			
			Пока Выборка.Следующий() Цикл
				
				СтрокаСлужебок.Параметры.Заполнить(Выборка);
				СтрокаСлужебок.Параметры.РасшифровкСЗ = Новый Структура("Служебка", Выборка.СЗ);
				ТабДокСлужебок.Вывести(СтрокаСлужебок);
				
			КонецЦикла;
			
			ТабДок.Присоединить(ТабДокСлужебок);
			
		КонецЦикла;
		
		ТабДок.ЗакончитьГруппуСтрок();
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции
