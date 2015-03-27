﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Даты запрета изменения".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Позволяет изменить работу интерфейса при встраивании.
//
// Параметры:
//  НастройкиРаботыИнтерфейса -
//                 Структура:
//                   ИспользоватьВнешнихПользователей - Булево (начальное значение Ложь).
//
Процедура НастройкаИнтерфейса(Знач НастройкиРаботыИнтерфейса) Экспорт
	
	
	
КонецПроцедуры

// Процедура ЗаполнитьИточникиДанныхДляПроверкиЗапретаИзменения косвенно
// вызывается из процедуры ДатыЗапретаИзменения.ИзменениеЗапрещено(),
// используемой в подписке на событие ПередЗаписью объекта
// для проверки запрета и отказа от изменений запрещенного объекта.
//
// Параметры:
//  ИсточникиДанных - ТаблицаЗначений:
//                    Таблица     - Строка, полное имя объекта метаданных,
//                                  например, Документ.ПриходнаяНакладная
//                    ПолеДаты    - Строка, имя реквизита или имя реквизита
//                                  табличной части, например "Дата", "Товары.ДатаОтгрузки"
//                    Раздел      - Строка, имя предопределенного элемента
//                                  ПланВидовХарактеристикСсылка.РазделыДатЗапрета
//                    ПолеОбъекта - Строка, имя реквизита или имя реквизита
//                                  табличной части, например "Организация", "Товары.Склад"
//
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	// Данные(Таблица, ПолеДаты, Раздел, ПолеОбъекта)
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.АвансовыйОтчет", "Дата", "АвансовыйОтчет");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.АктВыполненияДоговора", "Дата","АктВыполненияДоговора");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.БюджетДДС", "Дата","БюджетДДС");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВстречаСКлиентом", "Дата","ВстречаСКлиентом");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВыплатаЗаработнойПлаты", "Дата","ВыплатаЗаработнойПлаты");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВыпускПродукции", "Дата","ВыпускПродукции");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Договор", "Дата","Договор");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ДополнительноеСоглашение", "Дата","ДополнительноеСоглашение");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Замер", "Дата","Замер");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИнвентаризацияМатериалов", "Дата","ИнвентаризацияМатериалов");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИнвентаризацияМатериаловЦех", "Дата","ИнвентаризацияМатериаловЦех");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Инкассация", "Дата","Инкассация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Комплектация", "Дата","Комплектация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Монтаж", "Дата","Монтаж");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НарядЗадание", "Дата","НарядЗадание");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НачислениеАмортизации", "Дата","НачислениеАмортизации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НачислениеВнутреннее", "Дата","НачислениеВнутреннее");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НачислениеЗаработнойПлаты", "Дата","НачислениеЗаработнойПлаты");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Обзвон", "Дата","Обзвон");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОперативныйЗакуп", "Дата","ОперативныйЗакуп");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Операция", "Дата","Операция");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПереводНоменклатуры", "Дата","ПереводНоменклатуры");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПеремещениеДенежныхСредств", "Дата","ПеремещениеДенежныхСредств");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПеремещениеМатериалов", "Дата","ПеремещениеМатериалов");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПеремещениеОсновныхСредств", "Дата","ПеремещениеОсновныхСредств");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПланПродажПоДизайнерам", "Дата","ПланПродажПоДизайнерам");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПоступлениеДополнительныхРасходов", "Дата","ПоступлениеДополнительныхРасходов");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПоступлениеМатериаловУслуг", "Дата","ПоступлениеМатериаловУслуг");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПриходДенежныхСредств", "Дата","ПриходДенежныхСредств");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РабочийГрафикМонтажников", "Дата","РабочийГрафикМонтажников");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РасходДенежныхСредств", "Дата","РасходДенежныхСредств");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РеализацияМатериалов", "Дата","РеализацияМатериалов");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Рекламация", "Дата","Рекламация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СлужебнаяЗаписка", "Дата","СлужебнаяЗаписка");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеМатериалов", "Дата","СписаниеМатериалов");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеОсновныхСредств", "Дата","СписаниеОсновныхСредств");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ТребованиеНакладная", "Дата","ТребованиеНакладная");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.УстановкаСкладскогоРезерва", "Дата","УстановкаСкладскогоРезерва");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.УстановкаЦенНоменклатуры", "Дата","УстановкаЦенНоменклатуры");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.УстановкаЦеховогоЛимита", "Дата","УстановкаЦеховогоЛимита");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РеализацияГотовойПродукции", "Дата","РеализацияГотовойПродукции");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Спецификация", "Дата","Спецификация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ЗакрытиеМесяца", "Дата","ЗакрытиеМесяца");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИнвентаризацияОсновныхСредств", "Дата","ИнвентаризацияОсновныхСредств");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.КорректировкаЦеховыхОстатков", "Дата","КорректировкаЦеховыхОстатков");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПриходМатериаловЗаказчика", "Дата","ПриходМатериаловЗаказчика");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПлановыйЛимит", "Дата","ПлановыйЛимит");
	
КонецПроцедуры

// Позволяет переопределить выполнение проверок запретов по произвольному условию.
//
// Параметры:
//  Объект       - объект или набор записей (ПередЗаписью или ПриЧтенииНаСервере):
//                 СправочникОбъект
//                 ДокументОбъект
//                 ПланВидовХарактеристикОбъект
//                 ПланСчетовОбъект
//                 ПланВидовРасчетаОбъект
//                 БизнесПроцессОбъект
//                 ЗадачаОбъект
//                 ПланОбменаОбъект
//                 РегистрСведенийНаборЗаписей
//                 РегистрНакопленияНаборЗаписей
//                 РегистрБухгалтерииНаборЗаписей
//                 РегистрРасчетаНаборЗаписей
//
//  ПроверкаЗапретаИзменения - Булево, если установить Ложь проверка запрета
//                             изменения выполняться не будет.
//
//  УзелПроверкиЗапретаЗагрузки - Неопределено, ПланыОбменаСсылка.<Имя плана обмена>.
//                    Когда Неопределено проверка запрета загрузки не выполняется.
//
//  СообщитьОЗапрете - Булево, начальное значение Истина. Если установить Ложь,
//                 тогда сообщение об ошибке не будет отправлено пользователю.
//                 Например, при интерактивной записи будет виден лишь отказ записи.
//                 В журнал регистрации сообщение будет записано в любом случае.
//
Процедура ПередПроверкойЗапретаИзменения(Объект,
                                         ПроверкаЗапретаИзменения,
                                         УзелПроверкиЗапретаЗагрузки,
                                         СообщитьОЗапрете) Экспорт
	
	
	
КонецПроцедуры

