﻿
&НаКлиенте
Процедура Сформировать(Команда)
	
	ПериодОтчета.ДатаНачала = НачалоМесяца(Месяц);
	ПериодОтчета.ДатаОкончания = КонецМесяца(Месяц);
	
	СформироватьНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьПоказатели()
	
	ДоходЗаПериод = ПолучитьОборотПоСчету(ПланыСчетов.Управленческий.Доходы, ВидДвиженияБухгалтерии.Кредит);
	РасходЗаПериод = ПолучитьОборотПоСчету(ПланыСчетов.Управленческий.Расходы, ВидДвиженияБухгалтерии.Дебет);
	ПрибыльЗаПериод = ДоходЗаПериод - РасходЗаПериод;
	
	ДДСЗаПериод = ПолучитьОборотыПоДДС();
	ВыплатыЗаПериод = ДДСЗаПериод.ВыплатыЗаПериод;
	ПоступленияЗаПериод = ДДСЗаПериод.ПоступленияЗаПериод;
	
	СтоимостьОсновныхСредств = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.ПервоначальнаяСтоимостьОС, ВидДвиженияБухгалтерии.Дебет);
	
	ОстатокДенежныхСредств = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.ДенежныеСредства);
	ОстатокВКассах = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.Касса);
	ОстатокВОперационныхКассах = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.ОперационнаяКасса);
	ОстатокВПодотчете = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.Подотчет);
	ОстатокНаРасчетныхСчетах = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.РасчетныйСчет);
	
	ЗаймыВыданные = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.ЗаймыВыданные, ВидДвиженияБухгалтерии.Дебет);
	ЗаймыПолученные = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.ЗаймыПолученные, ВидДвиженияБухгалтерии.Кредит);
	
	СтоимостьЗаключенныхДоговоровЗаПериод = ПолучитьСтоимостьЗаключенныхДоговоров(ПериодОтчета);
	СтоимостьЗаключенныхДоговоровЗаДень = ПолучитьСтоимостьЗаключенныхДоговоров(Новый СтандартныйПериод(День, День));
	
	ОтгруженоЗаПериод = ПолучитьСуммуОтгруженныхИзделий(ПериодОтчета.ДатаНачала, ПериодОтчета.ДатаОкончания);
	ОтгруженоЗаДень = ПолучитьСуммуОтгруженныхИзделий(НачалоДня(День), КонецДня(День));
	
	ПродукцияУПокупателей = ПолучитьСуммуИзделийУКлиента();
	ПродукцияНаСкладе = ПолучитьСуммуИзделийНаСкладе();
	ТМЦНаСкладах = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.МатериалыНаСкладе, ВидДвиженияБухгалтерии.Дебет);
	ТМЦВЦеху = ПолучитьОстатокПоСчету(ПланыСчетов.Управленческий.ОсновноеПроизводство, ВидДвиженияБухгалтерии.Дебет);
	
	МыДолжныПодразделениям = ПолучитьРазвернутыйОстатокПоСчету(ПланыСчетов.Управленческий.ВзаиморасчетыСПодразделениями, ВидДвиженияБухгалтерии.Кредит);
	НамДолжныПодразделения = ПолучитьРазвернутыйОстатокПоСчету(ПланыСчетов.Управленческий.ВзаиморасчетыСПодразделениями, ВидДвиженияБухгалтерии.Дебет);
	
	МыДолжныКлиентам = ПолучитьРазвернутыйОстатокПоСчету(ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями, ВидДвиженияБухгалтерии.Кредит);
	НамДолжныКлиенты = ПолучитьРазвернутыйОстатокПоСчету(ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями, ВидДвиженияБухгалтерии.Дебет);
	
	МыДолжныПоставщикам = ПолучитьРазвернутыйОстатокПоСчету(ПланыСчетов.Управленческий.ВзаиморасчетыСПоставщиками, ВидДвиженияБухгалтерии.Кредит);
	НамДолжныПоставщики = ПолучитьРазвернутыйОстатокПоСчету(ПланыСчетов.Управленческий.ВзаиморасчетыСПоставщиками, ВидДвиженияБухгалтерии.Дебет);
	
	МыДолжныСотрудникам = ПолучитьРазвернутыйОстатокПоСчету(ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками, ВидДвиженияБухгалтерии.Кредит);
	НамДолжныСотрудники = ПолучитьРазвернутыйОстатокПоСчету(ПланыСчетов.Управленческий.ВзаиморасчетыССотрудниками, ВидДвиженияБухгалтерии.Дебет);
	
	МыДолжныИтого = МыДолжныПодразделениям + МыДолжныКлиентам+ МыДолжныПоставщикам + МыДолжныСотрудникам;
	НамДолжныИтого = НамДолжныПодразделения+ НамДолжныКлиенты + НамДолжныПоставщики + НамДолжныСотрудники;
	
КонецФункции

&НаСервере
Процедура СформироватьНаСервере()
	
	ЗаполнитьПоказатели();
	
	ТабДокКасса = Отчеты.КлючевыеЭкономическиеПоказатели.СформироватьОтчет(ПериодОтчета, СписокПодразделений, "Касса");
	ТабДокНачисления = Отчеты.КлючевыеЭкономическиеПоказатели.СформироватьОтчет(ПериодОтчета, СписокПодразделений, "Начисления");
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОборотПоСчету(Счет, ВидДвижения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонецПериода", ПериодОтчета.ДатаОкончания);
	Запрос.УстановитьПараметр("НачалоПериода", ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УправленческийОбороты.СуммаОборотДт,
	|	УправленческийОбороты.СуммаОборотКт
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(&НачалоПериода, &КонецПериода, , Счет В ИЕРАРХИИ (&Счет), , Подразделение В (&СписокПодразделений), , ) КАК УправленческийОбороты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если ВидДвижения = ВидДвиженияБухгалтерии.Дебет Тогда
		Оборот = Выборка.СуммаОборотДт;
	ИначеЕсли ВидДвижения = ВидДвиженияБухгалтерии.Кредит Тогда
		Оборот = Выборка.СуммаОборотКт;
	КонецЕсли;
	
	Возврат Оборот;
	
КонецФункции

&НаСервере
Функция ПолучитьОборотыПоДДС() 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонецПериода", ПериодОтчета.ДатаОкончания);
	Запрос.УстановитьПараметр("НачалоПериода", ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УправленческийОбороты.СуммаОборотДт,
	|	УправленческийОбороты.СуммаОборотКт
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ДенежныеСредства)),
	|			,
	|			Подразделение В (&СписокПодразделений)
	|				И НЕ Субконто1.Внутрифирменная
	|				И НЕ Субконто1.МеждуСчетами,
	|			,
	|			) КАК УправленческийОбороты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Движения = Новый Структура;
	Движения.Вставить("ВыплатыЗаПериод", Выборка.СуммаОборотКт);
	Движения.Вставить("ПоступленияЗаПериод", Выборка.СуммаОборотДт);
	
	Возврат Движения;
	
КонецФункции

&НаСервере
Функция ПолучитьОстатокПоСчету(Счет, ВидДвижения = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(День));
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УправленческийОстатки.СуммаОстатокДт,
	|	УправленческийОстатки.СуммаОстатокКт,
	|	УправленческийОстатки.СуммаРазвернутыйОстатокДт,
	|	УправленческийОстатки.СуммаРазвернутыйОстатокКт,
	|	УправленческийОстатки.СуммаОстаток
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(ДОБАВИТЬКДАТЕ(&КонецПериода, СЕКУНДА, 1), Счет В ИЕРАРХИИ (&Счет), , Подразделение В (&СписокПодразделений)) КАК УправленческийОстатки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если ВидДвижения = ВидДвиженияБухгалтерии.Дебет Тогда
		Остаток = Выборка.СуммаРазвернутыйОстатокДт;
	ИначеЕсли ВидДвижения = ВидДвиженияБухгалтерии.Кредит Тогда
		Остаток = Выборка.СуммаРазвернутыйОстатокКт;
	Иначе
		Остаток = Выборка.СуммаОстаток;
	КонецЕсли;
	
	Возврат Остаток;
	
КонецФункции

&НаСервере
Функция ПолучитьСтоимостьЗаключенныхДоговоров(Период)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонецПериода", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("НачалоПериода", Период.ДатаНачала);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УправленческийОбороты.СуммаОборотДт
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|			,
	|			Подразделение В (&СписокПодразделений)
	|				И Субконто1 = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.СтоимостьЗаключенныхДоговоров),
	|			,
	|			) КАК УправленческийОбороты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Оборот = Выборка.СуммаОборотДт;
	
	Возврат Оборот;
	
КонецФункции

&НаСервере
Функция ПолучитьСуммуОтгруженныхИзделий(НачалоПериода, КонецПериода);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(УправленческийОбороты.Субконто1.СуммаДокумента) КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ГотоваяПродукция),
	|			,
	|			Подразделение В (&СписокПодразделений),
	|			КорСчет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ИзделияУКлиента)
	|				ИЛИ КорСчет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.РасходыПроизводства),
	|			) КАК УправленческийОбороты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Сумма = Выборка.Сумма;
	
	Возврат Сумма;
	
КонецФункции

&НаСервере
Функция ПолучитьСуммуИзделийУКлиента();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(День));
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(УправленческийОстатки.Субконто1.СуммаДокумента) КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(ДОБАВИТЬКДАТЕ(&КонецПериода, СЕКУНДА, 1), Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ИзделияУКлиента), , Подразделение В (&СписокПодразделений)) КАК УправленческийОстатки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Сумма = Выборка.Сумма;
	
	Возврат Сумма;
	
КонецФункции

&НаСервере
Функция ПолучитьСуммуИзделийНаСкладе();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(День));
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(УправленческийОстатки.Субконто1.СуммаДокумента) КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(ДОБАВИТЬКДАТЕ(&КонецПериода, СЕКУНДА, 1), Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ГотоваяПродукция), , Подразделение В (&СписокПодразделений)) КАК УправленческийОстатки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Сумма = Выборка.Сумма;
	
	Возврат Сумма;
	
КонецФункции

&НаСервере
Функция ПолучитьРазвернутыйОстатокПоСчету(Счет, ВидДвижения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонецПериода", День);
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОстатки.Субконто1,
	|	УправленческийОстатки.Субконто2,
	|	УправленческийОстатки.Субконто3,
	|	УправленческийОстатки.СуммаРазвернутыйОстатокДт КАК СуммаРазвернутыйОстатокДт,
	|	УправленческийОстатки.СуммаРазвернутыйОстатокКт КАК СуммаРазвернутыйОстатокКт
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(&КонецПериода, Счет = &Счет, , Подразделение В (&СписокПодразделений)) КАК УправленческийОстатки
	|ИТОГИ
	|	СУММА(СуммаРазвернутыйОстатокДт),
	|	СУММА(СуммаРазвернутыйОстатокКт)
	|ПО
	|	ОБЩИЕ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если ВидДвижения = ВидДвиженияБухгалтерии.Дебет Тогда
		Остаток = Выборка.СуммаРазвернутыйОстатокДт;
	ИначеЕсли ВидДвижения = ВидДвиженияБухгалтерии.Кредит Тогда
		Остаток = Выборка.СуммаРазвернутыйОстатокКт;
	КонецЕсли;
	
	Возврат Остаток;
	
КонецФункции

&НаКлиенте
Процедура ТабДокКассаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РасшифроватьЯчейку(Расшифровка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокНачисленияОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РасшифроватьЯчейку(Расшифровка);
	
КонецПроцедуры

&НаКлиенте
Функция РасшифроватьЯчейку(Расшифровка)
	
	Если Расшифровка.ВидРасшифровки <> "ДДС" И Расшифровка.ВидРасшифровки <> "ДР" Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТабДок = СформироватьРасшифровку(Расшифровка);
	ТабДок.Показать("Расшифровка");
	
КонецФункции

&НаСервере
Функция СформироватьРасшифровку(Расшифровка)
	
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_РасшифровкаКлючевыеПоказатели";
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = Отчеты.КлючевыеЭкономическиеПоказатели.ПолучитьМакет("МакетРасшифровки");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ОбластьЗаголовок.Параметры.Статья = Расшифровка.Статья;
	ОбластьЗаголовок.Параметры.Период =Расшифровка.Период ;
	ОбластьЗаголовок.Параметры.СписокПодразделений = СписокПодразделений;
	
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапка);
	
	
	ТабДок.Вывести(ОбластьПодвал);
	
	Возврат ТабДок;
	
КонецФункции
