﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗагружаетсяИзИнтернета И ЗначениеЗаполнено(ОсновнаяВалюта) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Зависимая валюта не может быть загружена с сайта РБК'")
		);
		Отказ = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОсновнаяВалюта.ОсновнаяВалюта) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Основная валюта не может быть зависимой.'")
		);
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ОсновнаяВалюта) Тогда
		ИсключаемыеРеквизиты = Новый Массив;
		ИсключаемыеРеквизиты.Добавить("Наценка");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	КонецЕсли;

	Если НЕ ЭтоНовый()
		И РаботаСКурсамиВалют.ПолучитьСписокЗависимыхВалют(Ссылка).Количество() > 0 
		И ЗначениеЗаполнено(ОсновнаяВалюта) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Валюта не может быть подчиненной, так как она является основной для других валют.'")
		);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСКурсамиВалют.ПроверитьКорректностьКурсаНа01_01_1980(Ссылка);
	
	Если ЗначениеЗаполнено(ОсновнаяВалюта) Тогда
		РаботаСКурсамиВалют.ЗаписатьСведенияДляПодчиненногоРегистра(ОсновнаяВалюта, Ссылка);
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОбновитьКурсы") Тогда
		РаботаСКурсамиВалют.ПриОбновленииКурсовВалютВМоделиСервиса(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Если Ссылка.Пустая() Или Ссылка.Код <> Код Или Ссылка.ЗагружаетсяИзИнтернета <> ЗагружаетсяИзИнтернета Тогда
			ДополнительныеСвойства.Вставить("ОбновитьКурсы");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли