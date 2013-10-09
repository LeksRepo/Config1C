﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Выполняет внешнюю обработку печати.
//
// Параметры:
//  ИсточникДанных        - Произвольный    - источник данных;
//  ПараметрыИсточника    - Произвольный    - параметры источника печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - (выходной) см. УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм;
//  ОбъектыПечати         - СписокЗначений  - (выходной) список объектов печати, где значение - Ссылка, а представление - имя области печати;
//  ПараметрыВывода       - Структура       - (выходной) см. УправлениеПечатью.ПодготовитьСтруктуруПараметровВывода.
//
// Возвращаемое значение:
//  Булево - Ложь, если печать не была выполнена.
Функция ПечатьПоВнешнемуИсточнику(ИсточникДанных, ПараметрыИсточника, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	Если ТипЗнч(ИсточникДанных) = Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда
		ДополнительныеОтчетыИОбработки.ПечатьПоВнешнемуИсточнику(
			ИсточникДанных, ПараметрыИсточника, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
		Возврат Истина;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	Возврат Ложь;
	
КонецФункции

// Переопределяет таблицу возможных форматов для сохранения табличного документа.
// Вызывается из ОбщегоНазначения.НастройкиФорматовСохраненияТабличногоДокумента()
//
// Параметры
//  ТаблицаФорматов - ТаблицаЗначений:
//                     ТипФайлаТабличногоДокумента - ТипФайлаТабличногоДокумента                 - значение в платформе, соответствующее формату;
//                     Ссылка                      - ПеречислениеСсылка.ФорматыСохраненияОтчетов - ссылка на метаданные, где хранится представление;
//                     Представление               - Строка -                                    - представление типа файла (заполняется из перечисления);
//                     Расширение                  - Строка -                                    - тип файла для операционной системы;
//                     Картинка                    - Картинка                                    - значок формата.
//
Процедура ПриЗаполненииНастроекФорматовСохраненияТабличногоДокумента(ТаблицаФорматов) Экспорт
	
КонецПроцедуры


