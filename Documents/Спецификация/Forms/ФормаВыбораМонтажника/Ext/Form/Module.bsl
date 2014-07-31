﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачалоПериода = Параметры.НачалоПериода;
	КонецПериода = Параметры.КонецПериода;
	Город = Параметры.Офис.Город;
	//
	ТабДок.Вывести(Сформировать(НачалоПериода, КонецПериода, Город));
	ТабДок.ФиксацияСверху = 1;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция Сформировать(НачалоПериода, КонецПериода, Город)
	
	ТабДокТаблица = Новый ТабличныйДокумент;
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет = Документы.Спецификация.ПолучитьМакет("ВыборМонтажника");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаТаблица = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаОтчета");
	ОбластьСтрокаСотрудник = Макет.ПолучитьОбласть("СтрокаМонтажник");
	ОбластьРазделительНедель = Макет.ПолучитьОбласть("РазделительНедель");
	
	ТабДок.Вывести(ОбластьШапка);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("ГородРабочий", Город);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка КАК Ссылка,
	|	РабочиеДниМонтажников.День КАК День,
	|	РабочиеДниМонтажников.РабочийДень КАК РабочийДень,
	|	РабочиеДниМонтажников.Спецификация,
	|	РабочиеДниМонтажников.Спецификация.АдресМонтажа,
	|	РабочиеДниМонтажников.Спецификация.ДатаМонтажа
	|ИЗ
	|	РегистрСведений.РабочиеДниМонтажников КАК РабочиеДниМонтажников
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ПО РабочиеДниМонтажников.Монтажник = ФизическиеЛица.Ссылка
	|ГДЕ
	|	ФизическиеЛица.Должность = ЗНАЧЕНИЕ(Справочник.Должности.Монтажник)
	|	И ФизическиеЛица.ПометкаУдаления <> ИСТИНА
	|	И РабочиеДниМонтажников.День МЕЖДУ &НачалоПериода И &КонецПериода
	|	И ФизическиеЛица.Активность
	|	И ФизическиеЛица.ГородРабочий = &ГородРабочий
	|
	|УПОРЯДОЧИТЬ ПО
	|	День
	|ИТОГИ
	|	КОЛИЧЕСТВО(РабочийДень)
	|ПО
	|	Ссылка";
	//Формируем массив дат без Вс в пределах указанного периода, чтобы пользователь не мог выбрать Вс
	ДатыБезВоскресений = Новый Массив;
	КолвоДней = (КонецПериода - НачалоПериода) / 86400;
	Для Сч = 0 По КолвоДней Цикл
		СледДень = НачалоПериода+Сч*86400; 		
		Если ДеньНедели(СледДень) <> 7 Тогда
			ДатыБезВоскресений.Добавить(СледДень);
		КонецЕсли;	
	КонецЦикла;
	МаксИндекс = ДатыБезВоскресений.ВГраница();
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл   	
		ОбластьСтрокаСотрудник.Параметры.Монтажник = Выборка.Ссылка;
		ТабДокТаблица.Вывести(ОбластьСтрокаСотрудник);
		ТабДокТаблица.Вывести(ОбластьШапкаТаблица); 		
			
		ВыборкаПоСотруднику = Выборка.Выбрать();
		//Записей по сотруднику в регистре меньше либо равно количеству дней без воскресений в периоде,
		//а выводить нужно все даты в периоде, даже пустые, поэтому ищем каждую дату в выборке
		Для Индекс = 0 По МаксИндекс  Цикл
			Если ОбластьСтрока.Параметры.Дата <> Неопределено И (ДатыБезВоскресений[Индекс] - ОбластьСтрока.Параметры.Дата) > 87000 Тогда
				ТабДокТаблица.Вывести(ОбластьРазделительНедель);	
			КонецЕсли;
			ОбластьСтрока.Параметры.Дата = ДатыБезВоскресений[Индекс];
			СтуктураПоиска = Новый Структура("День", ДатыБезВоскресений[Индекс]);
			
			Если ВыборкаПоСотруднику.НайтиСледующий(СтуктураПоиска) Тогда
				ОбластьСтрока.Параметры.Адрес = ВыборкаПоСотруднику.СпецификацияАдресМонтажа;
			Иначе
				ОбластьСтрока.Параметры.Адрес = Неопределено;
				ОбластьСтрока.Параметры.Расшифровка = Новый Структура("ДатаМонтажа, Монтажник", ДатыБезВоскресений[Индекс], Выборка.Ссылка);
			КонецЕсли;
			
			ТабДокТаблица.Вывести(ОбластьСтрока);
			
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
		Закрыть(Расшифровка);
	Иначе
		Сообщить("Монтажник занят в этот день");
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьТабличныйДокумент()
	
	ТабДок = Сформировать(НачалоПериода, КонецПериода, );
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


