﻿Перем ТабДок,ОблСтрока,ОблСтрока2,ОблСтрока3;
Перем СуммаНач,СуммаКон,СуммаДт,СуммаКт;

&НаКлиенте
Процедура СформироватьОтчет(Команда) Экспорт
	
	ТабличныйДокумент = СформироватьТабличныйДокумент();
	
КонецПроцедуры

&НаСервере
Функция СформироватьТабличныйДокумент()
	
	СуммаНач=0;
	СуммаКон=0;
	СуммаДт=0;
	СуммаКт=0;
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ОриентацияСтраницы=ОриентацияСтраницы.Ландшафт;
	ТабДок.Защита=Истина;
	
	Макет = Отчеты.АктивПодразделения.ПолучитьМакет("МакетАктивОбороты");
	
	ОблШапка = Макет.ПолучитьОбласть("Шапка");
	ОблСтрока = Макет.ПолучитьОбласть("Строка");
	ОблСтрока2 = Макет.ПолучитьОбласть("Строка2");
	ОблСтрока3 = Макет.ПолучитьОбласть("Строка3");
	ОблПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ОблШапка.Параметры.ПредставлениеПериода = Формат(Отчет.НачалоПериода, "ДЛФ=DD")+" - "+Формат(Отчет.КонецПериода, "ДЛФ=DD");
	ОблШапка.Параметры.Подразделение = Отчет.СписокПодразделений;
	ТабДок.Вывести(ОблШапка);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Отчет.СписокПодразделений);
	Запрос.УстановитьПараметр("НачалоПериода", Отчет.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(Отчет.КонецПериода));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстаткиИОбороты.Счет КАК Счет,
	|	УправленческийОстаткиИОбороты.Счет.Код КАК Код,
	|	УправленческийОстаткиИОбороты.Счет.Порядок КАК Порядок,
	|	УправленческийОстаткиИОбороты.СуммаНачальныйОстаток КАК СуммаНачальныйОстаток,
	|	УправленческийОстаткиИОбороты.СуммаКонечныйОстаток КАК СуммаКонечныйОстаток,
	|	УправленческийОстаткиИОбороты.СуммаОборотДт КАК СуммаОборотДт,
	|	УправленческийОстаткиИОбороты.СуммаОборотКт КАК СуммаОборотКт
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.ОстаткиИОбороты(&НачалоПериода, &КонецПериода, , , , , Подразделение В (&Подразделение)) КАК УправленческийОстаткиИОбороты
	|ГДЕ
	|	НЕ УправленческийОстаткиИОбороты.Счет.Забалансовый
	|УПОРЯДОЧИТЬ ПО
	|	Порядок
	|ИТОГИ
	|	СУММА(СуммаНачальныйОстаток),
	|	СУММА(СуммаКонечныйОстаток),
	|	СУММА(СуммаОборотДт),
	|	СУММА(СуммаОборотКт)
	|ПО
	|	Счет ИЕРАРХИЯ";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТабДок.НачатьАвтоГруппировкуСтрок();
	
	ОбходИерархии(Выборка);
	
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	
	ОблПодвал.Параметры.НачальныйОстаток = Формат(СуммаНач, "ЧДЦ=2");
	ОблПодвал.Параметры.Приход = Формат(СуммаДт, "ЧДЦ=2");
	ОблПодвал.Параметры.Расход = Формат(СуммаКт, "ЧДЦ=2");
	ОблПодвал.Параметры.КонечныйОстаток = Формат(СуммаКон, "ЧДЦ=2");
	ТабДок.Вывести(ОблПодвал); 
	
	Возврат ТабДок;
	
КонецФункции

&НаСервере
Процедура ОбходИерархии(Выборка)
	
	Пока Выборка.Следующий() Цикл
		
		Ур=Выборка.Уровень();
		
		Если Ур = 0 Тогда 
			
			Область = ОблСтрока;
			
			СуммаНач = СуммаНач + Выборка.СуммаНачальныйОстаток;
			СуммаКон = СуммаКон + Выборка.СуммаКонечныйОстаток;
			СуммаДт = СуммаДт + Выборка.СуммаОборотДт;
			СуммаКт = СуммаКт + Выборка.СуммаОборотКт;
	
		КонецЕсли;
		Если Ур = 1 Тогда Область = ОблСтрока2; КонецЕсли;
		Если Ур > 1 Тогда Область = ОблСтрока3; КонецЕсли;		 
		
		Область.Параметры.Счет = Выборка.Счет;
		Область.Параметры.НачальныйОстаток = Формат(Выборка.СуммаНачальныйОстаток, "ЧДЦ=2");
		Область.Параметры.Приход = Формат(Выборка.СуммаОборотДт, "ЧДЦ=2");
		Область.Параметры.Расход = Формат(Выборка.СуммаОборотКт, "ЧДЦ=2");
		Область.Параметры.КонечныйОстаток = Формат(Выборка.СуммаКонечныйОстаток, "ЧДЦ=2");
		Область.Параметры.Код = Выборка.Код;
		Область.Параметры.РасПарам = Выборка.Счет;
			
		Если Выборка.ТипЗаписи() <> ТипЗаписиЗапроса.ДетальнаяЗапись Тогда
			
			Если ЗначениеЗаполнено(Выборка.Счет) Тогда
				ТабДок.Вывести(Область,Выборка.Уровень());
			КонецЕсли;
			Выборка2=Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			ОбходИерархии(Выборка2);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПодразделения(Команда)
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		Отчет.СписокПодразделений.Очистить();
		Для каждого Знч Из ВыбранноеЗначение Цикл
			Отчет.СписокПодразделений.Добавить(Знч.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ТабличныйДокумент = СформироватьТабличныйДокумент();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("НачалоПериода") Тогда
		 Отчет.НачалоПериода = Параметры.НачалоПериода;
		 Отчет.КонецПериода =  Параметры.КонецПериода;
	КонецЕсли;
	 
	Если Параметры.Свойство("Подразделение") Тогда
		 Отчет.СписокПодразделений = Параметры.Подразделение;
	КонецЕсли; 
	
	
	Если НЕ ЗначениеЗаполнено(Отчет.СписокПодразделений) Тогда
		Если НЕ ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
			Отчет.СписокПодразделений.Добавить(ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо.Подразделение);
		КонецЕсли;  
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Отчет.НачалоПериода)
		или НЕ ЗначениеЗаполнено(Отчет.КонецПериода) Тогда
		Отчет.НачалоПериода = НачалоМесяца(ТекущаяДата());
		Отчет.КонецПериода = КонецМесяца(ТекущаяДата());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНазад(Команда)
	
	УстановитьМесяц(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцВперед(Команда)
	
	УстановитьМесяц(1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьМесяц(КоличествоМесяцев)
	
	Отчет.НачалоПериода = ДобавитьМесяц(Отчет.НачалоПериода, КоличествоМесяцев);
	Отчет.КонецПериода = КонецМесяца(Отчет.НачалоПериода);
	ТабличныйДокумент = СформироватьТабличныйДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТабличныйДокумент = СформироватьТабличныйДокумент();
КонецПроцедуры

&НаКлиенте
Процедура ТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыРасшифровки = Новый Структура();
	ПараметрыРасшифровки.Вставить("Счет",Расшифровка);
	ПараметрыРасшифровки.Вставить("Подразделение",Отчет.СписокПодразделений);
	ПараметрыРасшифровки.Вставить("НачалоПериода",Отчет.НачалоПериода);
	ПараметрыРасшифровки.Вставить("КонецПериода",КонецДня(Отчет.КонецПериода));
	
	
	ОткрытьФорму("Отчет.АктивПодразделения.Форма.ФормаРасшифровки", ПараметрыРасшифровки, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Свернуть(Команда)
	ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(0);
КонецПроцедуры

&НаКлиенте
Процедура Развернуть(Команда)
	ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(10);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьДаты()
	Если Отчет.НачалоПериода > Отчет.КонецПериода Тогда
		Отчет.НачалоПериода = НачалоМесяца(Отчет.КонецПериода);
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	ПроверитьДаты();
	ТабличныйДокумент = СформироватьТабличныйДокумент();
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	ПроверитьДаты();
	ТабличныйДокумент = СформироватьТабличныйДокумент();
КонецПроцедуры

&НаКлиенте
Процедура СписокПодразделенийНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыПодбора = Новый Структура("ОригинальныйСписок", Отчет.СписокПодразделений);
	ОткрытьФорму("Справочник.Подразделения.Форма.ФормаВыбораНескольких", ПараметрыПодбора, ЭтаФорма);
	
КонецПроцедуры


