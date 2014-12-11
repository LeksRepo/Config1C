﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Спецификация) Тогда
		
		Спецификация = Параметры.Спецификация;
		
		Статус = Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация);
		Если Статус = Перечисления.СтатусыСпецификации.Установлен Тогда
			Отказ = Истина;
			ТекстСообщения = "Запрещено изменять монтажника после установки изделия";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
		
		Монтажник = Спецификация.Монтажник;
		ДатаМонтажа = Спецификация.ДатаМонтажа;
		
		Если Спецификация.Дилерский Тогда
			Город = Спецификация.Контрагент.Город;
		Иначе
			Город = Спецификация.Офис.Город;
		КонецЕсли;
		
	КонецЕсли;
	
	НачалоПериода = ТекущаяДата();
	КонецПериода = НачалоПериода + 30 * 86400;
	
	Сформировать();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьМонтажНаСервере(ДанныеМонтажа)
	
	Если ЗначениеЗаполнено(ДанныеМонтажа) Тогда
		
		ДокОбъект = ДанныеМонтажа.Спецификация.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(ДокОбъект, ДанныеМонтажа);
		
		ДокОбъект.ДатаОтгрузки = ЛексКлиентСервер.ПолучитьДатуОтгрузки(ДокОбъект.ДатаМонтажа);
		//		ЛексСервер.УстановитьДатуИзготовленияСпецификации(Объект);
		
		Если ДокОбъект.Проведен Тогда
			РежимЗаписи = РежимЗаписиДокумента.Проведение;
		Иначе
			РежимЗаписи = РежимЗаписиДокумента.Запись;
		КонецЕсли;
		
		ДокОбъект.Записать(РежимЗаписи);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция Сформировать()
	
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДок.ФиксацияСверху = 1;
	
	ТабДок.Очистить();
	ТабДокТаблица = Новый ТабличныйДокумент;
	ТабДок.ФиксацияСверху = 7;
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
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("ГородРабочий", Город);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
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
	|	ФизЛицо УБЫВ,
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
			ЭтоВс = ДеньНедели(ВыборкаПоСотруднику.День) = 7;
			Обл = ?(ЭтоВс, ОбластьРазделительНедель, ОбластьСтрока);
			Обл.Параметры.Дата = ВыборкаПоСотруднику.День;
			Обл.Параметры.Адрес = ВыборкаПоСотруднику.АдресМонтажа;
			Обл.Параметры.Расшифровка = Новый Структура("Спецификация, ДатаМонтажа, Монтажник, Воскресенье", Спецификация, ВыборкаПоСотруднику.День, Выборка.ФизЛицо, ЭтоВс);
			Обл.Параметры.Расшифровка.Вставить("МонтажникЗанят", ЗначениеЗаполнено(ВыборкаПоСотруднику.АдресМонтажа));
			ТабДокТаблица.Вывести(Обл);
		КонецЦикла;
		
		ТабДок.Присоединить(ТабДокТаблица);
		ТабДокТаблица.Очистить();
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции // Сформировать()

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(Расшифровка) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Расшифровка.МонтажникЗанят Тогда
		
		Если Расшифровка.Воскресенье Тогда
			ТекстВопроса = "Уверены, что хотите поставить монтаж на воскресенье?";
			Если Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Если ВладелецФормы = Неопределено Тогда // открыто командой
			
			ИзменитьМонтажНаСервере(Расшифровка);
			Закрыть();
			
		Иначе // открыто из формы Спецификация
			
			ОповеститьОВыборе(Расшифровка);
			
		КонецЕсли;
		
	Иначе
		
		фДата = Формат(Расшифровка.ДатаМонтажа, "ДЛФ=ДД");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 уже занят %2", Расшифровка.Монтажник, фДата);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьТабличныйДокумент()
	
	Сформировать();
	
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


