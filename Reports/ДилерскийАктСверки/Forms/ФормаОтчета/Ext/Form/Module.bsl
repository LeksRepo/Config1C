﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Если ТипЗнч(Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		Отчет.Дилер = Пользователь;
		Контрагент = Пользователь.ОбъектАвторизации;
		Элементы.Дилер.ТолькоПросмотр = Истина;
		СформироватьОтчет();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДилерПриИзменении(Элемент)
	
	Контрагент = ЛексСервер.ЗначениеРеквизитаОбъекта(Отчет.Дилер, "ОбъектАвторизации");
	СформироватьОтчет();
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчет()
	
	УстановитьПривилегированныйРежим(Истина);
	Подразделение = ПолучитьПодразделение(); // спорный момент, но пока дилеры работают только в одном подразделении
	
	Скидки = ЛексСервер.ПолучитьСкидкуКонтрагента(Подразделение, ТекущаяДата(), Контрагент);
	
	Отчет.СкидкаНаМатериалы = Скидки.СкидкаНаМатериалы;
	Отчет.СкидкаНаУслуги = Скидки.СкидкаНаУслуги;
	
	Отчет.ОборотЗаПрошлыйМесяц = ПолучитьОборотДилераЗаМесяц(ДобавитьМесяц(ТекущаяДата(), -1));
	Отчет.ОборотЗаТекущийМесяц= ПолучитьОборотДилераЗаМесяц(ТекущаяДата());
	Отчет.СвободныйАванс = ПоулчитьСвободныйАванс();
	
	ЗаполнитьСпецификацииВРаботе();
	
КонецФункции

&НаСервере
Функция ПолучитьПодразделение()
	
	СвойствоПодразделение = ПланыВидовХарактеристик.НастройкиПользователей.Подразделение;
	Отбор = Новый Структура("Пользователь, Настройка", Отчет.Дилер, СвойствоПодразделение);
	
	Подразделение = РегистрыСведений.НастройкиПользователей.Получить(Отбор).Значение;
	
	Возврат Подразделение;
	
КонецФункции

&НаСервере
Функция ПолучитьОборотДилераЗаМесяц(Период)
	
	Оборот = 0;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Период));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Период));
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОбороты.СуммаОборотКт КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Месяц,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ВзаиморасчетыСПокупателями),
	|			,
	|			Подразделение = &Подразделение
	|				И Субконто1 = &Контрагент,
	|			,
	|			) КАК УправленческийОбороты";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Оборот = Выборка.Сумма;
	КонецЕсли;
	
	Возврат Оборот;
	
КонецФункции

&НаСервере
Функция ПоулчитьСвободныйАванс()
	
	Аванс = 0;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ВзаиморасчетыСПокупателями),
	|			,
	|			Подразделение = &Подразделение
	|				И Субконто1 = &Контрагент
	|				И Субконто2 = НЕОПРЕДЕЛЕНО) КАК УправленческийОстатки";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Оборот = -Выборка.Сумма;
	КонецЕсли;
	
	Возврат Оборот;
	
КонецФункции

Функция ЗаполнитьСпецификацииВРаботе()
	
	СпецификацииВРаботе.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.СуммаОстатокКт КАК СуммаДокумента,
	|	УправленческийОстатки.Субконто2 КАК Спецификация,
	|	УправленческийОстатки.Субконто2.ДатаОтгрузки КАК ДатаОтгрузки
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ВзаиморасчетыСПокупателями),
	|			,
	|			Подразделение = &Подразделение
	|				И Субконто1 = &Контрагент
	|				И Субконто2 <> НЕОПРЕДЕЛЕНО) КАК УправленческийОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаОтгрузки";
	
	СпецификацииВРаботе.Загрузить(Запрос.Выполнить().Выгрузить());
	ЗаказовВРаботеНаСумму = СпецификацииВРаботе.Итог("СуммаДокумента"); // в запросе бы
	
КонецФункции

&НаКлиенте
Процедура СпецификацииВРаботеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.СпецификацииВРаботе.ТекущиеДанные.Спецификация);
	
КонецПроцедуры

&НаКлиенте
Процедура СвободныйАвансНажатие(Элемент, СтандартнаяОбработка)
	
	Период = Новый СтандартныйПериод;
	Период.ДатаНачала = НачалоМесяца(ТекущаяДата());
	Период.ДатаОкончания = КонецМесяца(ТекущаяДата());
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Период", Период);
	ПараметрыФормы.Вставить("Подразделение", Подразделение);
	ПараметрыФормы.Вставить("Дилер", Отчет.Дилер);
	
	ОткрытьФорму("Отчет.ДилерскийАктСверки.Форма.АктСверки", ПараметрыФормы);
	
КонецПроцедуры
