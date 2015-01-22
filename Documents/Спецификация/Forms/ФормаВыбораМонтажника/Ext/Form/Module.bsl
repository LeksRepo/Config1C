﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Город") И ЗначениеЗаполнено(Параметры.Город) Тогда
		
		БезПараметров = Ложь;
		Спецификация = Параметры.Спецификация;
		
		Если ЗначениеЗаполнено(Спецификация) Тогда
			
			Статус = Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация);
			
			Если Статус = Перечисления.СтатусыСпецификации.Установлен Тогда
				Отказ = Истина;
				ТекстСообщения = "Запрещено изменять монтажника после установки изделия";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Параметры.Свойство("Монтажник") И ЗначениеЗаполнено(Параметры.Монтажник) Тогда
			
			Монтажник = Параметры.Монтажник;
			ДатаМонтажа = Параметры.ДатаМонтажа;
			
		КонецЕсли;
		
		Город = Параметры.Город;
		
	Иначе
		
		БезПараметров = Истина;
		
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
		ЛексСервер.УстановитьДатуИзготовленияСпецификации(ДокОбъект);
		
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
	
	Если Не БезПараметров Тогда
		
		ОбластьТекущийМонтаж.Параметры.ДатаМонтажа = Формат(ДатаМонтажа, "ДЛФ=Д");
		ОбластьТекущийМонтаж.Параметры.Монтажник = Монтажник;
		ТабДок.Вывести(ОбластьТекущийМонтаж);
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("ГородРабочий", Город);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка КАК ФизЛицо
	|ПОМЕСТИТЬ втМонтажники
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	(ФизическиеЛица.Должность = ЗНАЧЕНИЕ(Справочник.Должности.Монтажник)
	|			ИЛИ ФизическиеЛица.Должность = ЗНАЧЕНИЕ(Справочник.Должности.СтаршийДизайнер))
	|	И НЕ ФизическиеЛица.ПометкаУдаления
	|	И ФизическиеЛица.Активность
	|	И ФизическиеЛица.ГородРабочий = &ГородРабочий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РабочиеДниМонтажников.Спецификация.АдресМонтажа КАК АдресМонтажа,
	|	РабочиеДниМонтажников.День КАК День,
	|	РабочиеДниМонтажников.Монтажник КАК Монтажник,
	|	РабочиеДниМонтажников.Город
	|ПОМЕСТИТЬ втДни
	|ИЗ
	|	РегистрСведений.РабочиеДниМонтажников КАК РабочиеДниМонтажников
	|ГДЕ
	|	РабочиеДниМонтажников.Город = &ГородРабочий
	|	И РабочиеДниМонтажников.День МЕЖДУ &НачалоПериода И &КонецПериода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	втДни.АдресМонтажа КАК АдресМонтажа,
	|	втДни.День КАК День,
	|	втМонтажники.ФизЛицо КАК ФизЛицо
	|ИЗ
	|	втМонтажники КАК втМонтажники
	|		ЛЕВОЕ СОЕДИНЕНИЕ втДни КАК втДни
	|		ПО втМонтажники.ФизЛицо = втДни.Монтажник
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизЛицо,
	|	День
	|ИТОГИ
	|	МАКСИМУМ(АдресМонтажа)
	|ПО
	|	ФизЛицо,
	|	День ПЕРИОДАМИ(ДЕНЬ, &НачалоПериода, &КонецПериода)";
	
	ВыборкаФизЛица = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ФизЛицо", "Все");
	
	Пока ВыборкаФизЛица.Следующий() Цикл
		
		ОбластьСтрокаСотрудник.Параметры.Монтажник = ВыборкаФизЛица.ФизЛицо;
		ТабДокТаблица.Вывести(ОбластьСтрокаСотрудник);
		ТабДокТаблица.Вывести(ОбластьШапкаТаблица);
		ВыборкаДни = ВыборкаФизЛица.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "День", "Все");
		
		ВыборкаДни.Следующий();
		Пока ВыборкаДни.Следующий() Цикл
			
			ЭтоВс = ДеньНедели(ВыборкаДни.День) = 7;
			Обл = ?(ЭтоВс, ОбластьРазделительНедель, ОбластьСтрока);
			Обл.Параметры.Дата = ВыборкаДни.День;
			Обл.Параметры.Адрес = ВыборкаДни.АдресМонтажа;
			
			Если Не БезПараметров Тогда
				
				Обл.Параметры.Расшифровка = Новый Структура("Спецификация, ДатаМонтажа, Монтажник, Воскресенье", Спецификация, ВыборкаДни.День, ВыборкаДни.ФизЛицо, ЭтоВс);
				Обл.Параметры.Расшифровка.Вставить("МонтажникЗанят", ЗначениеЗаполнено(ВыборкаДни.АдресМонтажа));
				
			КонецЕсли;
			
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
