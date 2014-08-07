﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачалоПериода = Параметры.НачалоПериода;
	КонецПериода = Параметры.КонецПериода;
	Город = Параметры.Офис.Город;
	Монтажник = Параметры.Монтажник;
	ДатаМонтажа = Параметры.ДатаМонтажа;
	ТабДок.Вывести(Сформировать(НачалоПериода, КонецПериода, Город, ДатаМонтажа, Монтажник));
	ТабДок.ФиксацияСверху = 1;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция Сформировать(НачалоПериода, КонецПериода, Город, ДатаМонтажа, Монтажник)
	
	ТабДокТаблица = Новый ТабличныйДокумент;
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет = Документы.Спецификация.ПолучитьМакет("ВыборМонтажника");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьТекущийМонтаж = Макет.ПолучитьОбласть("ТекущийМонтаж");
	ОбластьШапкаТаблица = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаОтчета");
	ОбластьСтрокаСотрудник = Макет.ПолучитьОбласть("СтрокаМонтажник");
	ОбластьРазделительНедель = Макет.ПолучитьОбласть("РазделительНедель");
	
	ТабДок.Вывести(ОбластьШапка);
	ОбластьТекущийМонтаж.Параметры.ДатаМонтажа = Формат(ДатаМонтажа, "ДЛФ=Д");
	ОбластьТекущийМонтаж.Параметры.Монтажник = Монтажник;
	ТабДок.Вывести(ОбластьТекущийМонтаж);
	
	Запрос = Новый Запрос;
	МенеджерВТ = Новый МенеджерВременныхТаблиц();
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("ГородРабочий", Город);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РабочиеДниМонтажников.Спецификация.АдресМонтажа КАК АдресМонтажа,
	|	РабочиеДниМонтажников.Монтажник КАК Монтажник,
	|	РабочиеДниМонтажников.День КАК День
	|ПОМЕСТИТЬ ВТ_РабочиеДни
	|ИЗ
	|	РегистрСведений.РабочиеДниМонтажников КАК РабочиеДниМонтажников
	|ГДЕ
	|	РабочиеДниМонтажников.Город = &ГородРабочий
	|	И РабочиеДниМонтажников.День МЕЖДУ &НачалоПериода И &КонецПериода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка КАК ФизЛицо,
	|	ВТ_РабочиеДни.День КАК День,
	|	ВТ_РабочиеДни.АдресМонтажа КАК АдресМонтажа
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_РабочиеДни КАК ВТ_РабочиеДни
	|		ПО ФизическиеЛица.Ссылка = ВТ_РабочиеДни.Монтажник
	|ГДЕ
	|	ФизическиеЛица.Должность = ЗНАЧЕНИЕ(Справочник.Должности.Монтажник)
	|	И НЕ ФизическиеЛица.ПометкаУдаления
	|	И ФизическиеЛица.Активность
	|	И ФизическиеЛица.ГородРабочий = &ГородРабочий
	|
	|УПОРЯДОЧИТЬ ПО
	|	День
	|ИТОГИ
	|	МАКСИМУМ(АдресМонтажа)
	|ПО
	|	ФизЛицо,
	|	День ПЕРИОДАМИ(ДЕНЬ, &НачалоПериода, &КонецПериода)";
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ФизЛицо", "Все");
	
	Пока Выборка.Следующий() Цикл
		
		ОбластьСтрокаСотрудник.Параметры.Монтажник = Выборка.ФизЛицо;
		ТабДокТаблица.Вывести(ОбластьСтрокаСотрудник);
		ТабДокТаблица.Вывести(ОбластьШапкаТаблица);
		ВыборкаПоСотруднику = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "День", "Все");
		
		ВыборкаПоСотруднику.Следующий();
		Пока ВыборкаПоСотруднику.Следующий() Цикл
			Если ДеньНедели(ВыборкаПоСотруднику.День) = 7 Тогда
				ОбластьРазделительНедель.Параметры.Дата = ВыборкаПоСотруднику.День;
				ОбластьРазделительНедель.Параметры.Адрес = ВыборкаПоСотруднику.АдресМонтажа;
				ОбластьРазделительНедель.Параметры.Расшифровка = Новый Структура("ДатаМонтажа, Монтажник, Воскресенье", ВыборкаПоСотруднику.День, Выборка.ФизЛицо, Истина);
				ОбластьРазделительНедель.Параметры.Расшифровка.Вставить("МонтажникЗанят", ЗначениеЗаполнено(ВыборкаПоСотруднику.АдресМонтажа));
				ТабДокТаблица.Вывести(ОбластьРазделительНедель);
			Иначе
				ОбластьСтрока.Параметры.Дата = ВыборкаПоСотруднику.День;
				ОбластьСтрока.Параметры.Адрес = ВыборкаПоСотруднику.АдресМонтажа;
				ОбластьСтрока.Параметры.Расшифровка = Новый Структура("ДатаМонтажа, Монтажник, Воскресенье", ВыборкаПоСотруднику.День, Выборка.ФизЛицо, Ложь);
				ОбластьСтрока.Параметры.Расшифровка.Вставить("МонтажникЗанят", ЗначениеЗаполнено(ВыборкаПоСотруднику.АдресМонтажа));
				ТабДокТаблица.Вывести(ОбластьСтрока);
			КонецЕсли;
		КонецЦикла;
		
		ТабДок.Присоединить(ТабДокТаблица);
		ТабДокТаблица.Очистить();
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции // Сформировать()

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		Если НЕ Расшифровка.МонтажникЗанят Тогда  
			Если Расшифровка.Воскресенье Тогда
				ТекстВопроса = "Действительно хотите поставить монтаж на воскресенье?";
				Если Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
					Закрыть(Расшифровка);
				КонецЕсли
			Иначе
				Закрыть(Расшифровка);
			КонецЕсли
		Иначе
			Сообщить("Монтажник занят в этот день");
		КонецЕсли
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьТабличныйДокумент()
	
	ТабДок = Сформировать(НачалоПериода, КонецПериода, Город, ДатаМонтажа, Монтажник);
	ТабДок.ФиксацияСверху = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	СформироватьТабличныйДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	СформироватьТабличныйДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура ГородПриИзменении(Элемент)
	
	СформироватьТабличныйДокумент();
	
КонецПроцедуры


