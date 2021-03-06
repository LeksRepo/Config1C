﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Варианты отчетов" (сервер, переопределяемый)
// 
// Выполняется на сервере, изменяется под специфику прикладной конфигурации,
// но предназначен для использования только данной подсистемой.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет разделы, в которых доступна панель отчетов.
//
// Параметры:
//   Разделы - СписокЗначений - Разделы в которые выведена команды открытия панели отчетов.
//       * Значение - ОбъектМетаданных: Подсистема - Метаданные подсистемы.
//       * Представление - Строка - Заголовок панели отчетов этого раздела.
//
// Описание:
//   В Разделы необходимо добавить метаданные тех подсистем 1го уровня,
//   в которых размещены команды вызова панелей отчетов.
//
// Например:
//	Разделы.Добавить(Метаданные.Подсистемы.ИмяПодсистемы);
//
Процедура ОпределитьРазделыСВариантамиОтчетов(Разделы) Экспорт
	
	
	
КонецПроцедуры

// Содержит настройки размещения вариантов отчетов в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//
// Описание:
//   В данной процедуре необходимо указать каким именно образом предопределенные варианты отчетов
//   будут регистрироваться в программе и показываться в панели отчетов.
//
// Вспомогательные методы:
//   НастройкиОтчета   = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.<ИмяОтчета>);
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Метаданные.Отчеты.<ИмяОтчета>/Метаданные.Подсистемы.<ИмяПодсистемы>, Истина/Ложь);
//   ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.<ИмяОтчета>);
//
//   Данные функции получают соответственно настройки отчета и настройки варианта отчета следующей структуры:
//       * Включен - Булево -
//           Если Ложь, то вариант отчета не регистрируется в подсистеме.
//           Используется для удаления технических и контекстных вариантов отчетов из всех интерфейсов.
//           Эти варианты отчета по прежнему можно открывать в форме отчета программно при помощи
//           параметров открытия (см. справку по "Расширение управляемой формы для отчета.КлючВарианта").
//       * ВидимостьПоУмолчанию - Булево -
//           Если Ложь, то вариант отчета по умолчанию скрыт в панели отчетов.
//           Пользователь может "включить" его в режиме настройки панели отчетов
//           или открыть через форму "Все отчеты".
//       * Описание - Строка - Дополнительная информация по варианту отчета.
//           В панели отчетов выводится в качестве подсказки.
//           Должно расшифровывать для пользователя содержимое варианта отчета
//           и не должно дублировать наименование варианта отчета.
//           Используется при поиске.
//       * Размещение - Соответствие - Настройки размещения варианта отчета в разделах.
//           ** Ключ     - ОбъектМетаданных: Подсистема - Подсистема, в которой размещается отчет или вариант отчета
//           ** Значение - Строка - Необязательный. Настройки размещения в подсистеме.
//               ""        - Выводить отчет в своей группе обычным шрифтом.
//               "Важный"  - Выводить отчет в своей группе жирным шрифтом.
//               "СмТакже" - Выводить отчет в группе "См. также".
//       * ФункциональныеОпции - Массив из Строка -
//            Имена функциональных опций варианта отчета.
//       * НастройкиДляПоиска - Структура - Дополнительные настройки для поиска этого варианта отчета.
//           Эти настройки необходимо задавать только если СКД не используется или используется не в полном объеме.
//           Например, СКД может использоваться только для параметризации и получения данных,
//           а вывод выполняться в фиксированный макет табличного документа.
//           ** НаименованияПолей - Строка - Имена полей варианта отчета. Разделитель имен: Символы.ПС.
//           ** НаименованияПараметровИОтборов - Строка - Имена настроек варианта отчета. Разделитель имен: Символы.ПС.
//
// Например:
//
//  (1) Добавить в подсистему вариант отчета.
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "ИмяВарианта1");
//	Вариант.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//  (2) Отключить вариант отчета.
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "ИмяВарианта1");
//	Вариант.Включен = Ложь;
//
//  (3) Отключить все варианты отчета, кроме требуемого.
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Отчет.Включен = Ложь;
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта");
//	Вариант.Включен = Истина;
//
//  (4) Заполнить наименования полей, параметров и отборов:
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчетаБезСхемы, "");
//	Вариант.НастройкиДляПоиска.НаименованияПолей =
//		НСтр("ru = 'Контрагент
//		|Договор
//		|Ответственный
//		|Скидка
//		|Дата'");
//	Вариант.НастройкиДляПоиска.НаименованияПараметровИОтборов =
//		НСтр("ru = 'Период
//		|Ответственный
//		|Контрагент
//		|Договор'");
//
//  (5) Переключить режим вывода в панели отчетов:
//  (5.1) По отчетам:
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Метаданные.Отчеты.ИмяОтчета, "ПоОтчетам");
//  (5.2) По вариантам:
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Отчет, "ПоВариантам");
//
// Важно:
//   Отчет выступает в качестве контейнера вариантов.
//     Изменяя настройки отчета можно сразу изменять настройки всех его вариантов.
//     Однако, если явно получить настройки варианта отчета, то они станут самостоятельными,
//     т.е. более не будут наследовать изменения настроек от отчета. См. пример 3.
//   
//   Начальная настройка размещения отчетов по подсистемам зачитывается из метаданных,
//     ее дублирование в коде не требуется.
//   
//   Функциональные опции вариантов объединяются с функциональными опциями отчетов по следующим правилам:
//     (ФункциональнаяОпция1Отчета ИЛИ ФункциональнаяОпция2Отчета) И (ФункциональнаяОпция3Варианта ИЛИ ФункциональнаяОпция4Варианта).
//   Функциональные опции отчетов не зачитываются из метаданных,
//     они применяются на этапе использования подсистемы пользователем.
//   Через ОписаниеОтчета можно добавлять функциональные опции, которые будут соединяться по указанным выше правилам,
//     но надо помнить, что эти функциональные опции будут действовать только для предопределенных вариантов этого отчета.
//   Для пользовательских вариантов отчета действуют только функциональные опции отчета
//     - они отключаются только с отключением всего отчета.
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	
	
КонецПроцедуры

// Содержит описания изменений имен вариантов отчетов. Используется
//   при обновлении информационной базы, в целях контроля ссылочной целостности
//   и для сохранения настроек варианта, сделанных администратором.
//
// Параметры:
//   Изменения - ТаблицаЗначений - Таблица изменений имен вариантов. Колонки:
//       * Отчет - ОбъектМетаданных - Метаданные отчета, в схеме которого изменилось имя варианта.
//       * СтароеИмяВарианта - Строка - Старое имя варианта, до изменения.
//       * АктуальноеИмяВарианта - Строка - Текущее (последнее актуальное) имя варианта.
//
// Описание:
//   В Изменения необходимо добавить описания изменений имен вариантов
//   отчетов, подключенных к подсистеме.
//
// Например:
//	Изменение = Изменения.Добавить();
//	Изменение.Отчет = Метаданные.Отчеты.<ИмяОтчета>;
//	Изменение.СтароеИмяВарианта = "<СтароеИмяВарианта>";
//	Изменение.АктуальноеИмяВарианта = "<АктуальноеИмяВарианта>";
//
// Важно:
//   Старое имя варианта резервируется и не может быть использовано в дальнейшем.
//   Если изменений было несколько, то каждое изменение необходимо зарегистрировать,
//   указывая в актуальном имени варианта последнее (текущее) имя варианта отчета.
//   Поскольку имена вариантов отчетов не выводятся в пользовательском интерфейсе,
//   то рекомендуется задавать их таким образом, что бы затем не менять.
//
Процедура ЗарегистрироватьИзмененияКлючейВариантовОтчетов(Изменения) Экспорт
	
КонецПроцедуры

// Глобальные настройки, применяемые как умолчания для объектов подсистемы.
//
// Параметры:
//   Настройки - Коллекция настроек подсистемы. Реквизиты:
//       * ВыводитьОтчетыВместоВариантов - Булево - Умолчание для вывода гиперссылок в панели отчетов:
//           - Истина - Варианты отчетов по умолчанию скрыты, а отчеты включены и видимы.
//           - Ложь - Значение по умолчанию. Варианты отчетов по умолчанию видимы, а отчеты отключены.
//
Процедура ОпределитьГлобальныеНастройки(Настройки) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
