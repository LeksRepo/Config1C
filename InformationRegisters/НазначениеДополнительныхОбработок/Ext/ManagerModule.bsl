﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Собирает данные справочника по ссылкам объектов метаданных и обновляет по ним данные регистра.
//
Процедура ОбновитьДанныеПоСсылкамОбъектовМетаданных(СсылкиОбъектовМетаданных) Экспорт
	Запрос = НовыйЗапросОбновленияДанныхРегистра(СсылкиОбъектовМетаданных);
	
	ВыборкаСсылок = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСсылок.Следующий() Цикл
		ВыборкаЗаписей = ВыборкаСсылок.Выбрать();
		Пока ВыборкаЗаписей.Следующий() Цикл
			МенеджерЗаписи = СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ВыборкаЗаписей);
			МенеджерЗаписи.Записать(Истина);
		КонецЦикла;
		
		// Регистрация использующихся ссылок для последющей очистки регистра от неиспользуемых.
		СсылкиОбъектовМетаданных.Удалить(СсылкиОбъектовМетаданных.Найти(ВыборкаСсылок.ОбъектНазначения));
	КонецЦикла;
	
	// Очистка регистра по неиспользуемым ссылкам.
	Для Каждого ОбъектНазначения Из СсылкиОбъектовМетаданных Цикл
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ОбъектНазначения.Установить(ОбъектНазначения);
		НаборЗаписей.Записать(Истина);
	КонецЦикла;
КонецПроцедуры

// Полностью перезаполняет данные регистра.
//
Процедура Обновить(РежимОбновленияИБ = Ложь) Экспорт
	
	Запрос = НовыйЗапросОбновленияДанныхРегистра(Неопределено);
	ВыборкаСсылок = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	НаборЗаписей = СоздатьНаборЗаписей();
	Пока ВыборкаСсылок.Следующий() Цикл
		ВыборкаЗаписей = ВыборкаСсылок.Выбрать();
		Пока ВыборкаЗаписей.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ВыборкаЗаписей);
		КонецЦикла;
	КонецЦикла;
	
	Если РежимОбновленияИБ Тогда
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
	Иначе
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает текст запроса, который используется для обновления данных регистра
//
Функция НовыйЗапросОбновленияДанныхРегистра(СсылкиОбъектовМетаданных)
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДополнительныеОтчетыИОбработкиНазначение.ОбъектНазначения КАК ОбъектНазначения,
	|	ВЫБОР
	|		КОГДА ДополнительныеОтчетыИОбработкиНазначение.Ссылка.Вид = &ВидЗаполнениеОбъекта
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ИспользоватьЗаполнениеОбъекта,
	|	ВЫБОР
	|		КОГДА ДополнительныеОтчетыИОбработкиНазначение.Ссылка.Вид = &ВидОтчет
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ИспользоватьОтчеты,
	|	ВЫБОР
	|		КОГДА ДополнительныеОтчетыИОбработкиНазначение.Ссылка.Вид = &ВидПечатнаяФорма
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ИспользоватьПечатныеФормы,
	|	ВЫБОР
	|		КОГДА ДополнительныеОтчетыИОбработкиНазначение.Ссылка.Вид = &ВидСозданиеСвязанныхОбъектов
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ИспользоватьСозданиеСвязанныхОбъектов,
	|	ДополнительныеОтчетыИОбработкиНазначение.Ссылка.ИспользоватьДляФормыОбъекта,
	|	ДополнительныеОтчетыИОбработкиНазначение.Ссылка.ИспользоватьДляФормыСписка
	|ПОМЕСТИТЬ втПервичныеДанные
	|ИЗ
	|	Справочник.ДополнительныеОтчетыИОбработки.Назначение КАК ДополнительныеОтчетыИОбработкиНазначение
	|ГДЕ
	|	ДополнительныеОтчетыИОбработкиНазначение.ОбъектНазначения В(&СсылкиОбъектовМетаданных)
	|	И ДополнительныеОтчетыИОбработкиНазначение.Ссылка.Публикация <> &ПубликацияНеРавно
	|	И ДополнительныеОтчетыИОбработкиНазначение.Ссылка.ПометкаУдаления = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФормыОбъектов.ОбъектНазначения,
	|	ЛОЖЬ КАК ИспользоватьЗаполнениеОбъекта,
	|	ФормыОбъектов.ИспользоватьОтчеты,
	|	ФормыОбъектов.ИспользоватьПечатныеФормы,
	|	ФормыОбъектов.ИспользоватьСозданиеСвязанныхОбъектов,
	|	&ТипФормыОбъекта КАК ТипФормы
	|ПОМЕСТИТЬ втРезультат
	|ИЗ
	|	втПервичныеДанные КАК ФормыОбъектов
	|ГДЕ
	|	ФормыОбъектов.ИспользоватьДляФормыОбъекта = ИСТИНА
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОтключенныеФормыОбъектов.ОбъектНазначения,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	&ТипФормыОбъекта
	|ИЗ
	|	втПервичныеДанные КАК ОтключенныеФормыОбъектов
	|ГДЕ
	|	ОтключенныеФормыОбъектов.ИспользоватьДляФормыОбъекта = ЛОЖЬ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ФормыСписков.ОбъектНазначения,
	|	ФормыСписков.ИспользоватьЗаполнениеОбъекта,
	|	ФормыСписков.ИспользоватьОтчеты,
	|	ФормыСписков.ИспользоватьПечатныеФормы,
	|	ФормыСписков.ИспользоватьСозданиеСвязанныхОбъектов,
	|	&ТипФормыСписка
	|ИЗ
	|	втПервичныеДанные КАК ФормыСписков
	|ГДЕ
	|	ФормыСписков.ИспользоватьДляФормыСписка = ИСТИНА
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОтключенныеФормыСписков.ОбъектНазначения,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	&ТипФормыСписка
	|ИЗ
	|	втПервичныеДанные КАК ОтключенныеФормыСписков
	|ГДЕ
	|	ОтключенныеФормыСписков.ИспользоватьДляФормыСписка = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	табРезультат.ОбъектНазначения КАК ОбъектНазначения,
	|	табРезультат.ТипФормы,
	|	МАКСИМУМ(табРезультат.ИспользоватьЗаполнениеОбъекта) КАК ИспользоватьЗаполнениеОбъекта,
	|	МАКСИМУМ(табРезультат.ИспользоватьОтчеты) КАК ИспользоватьОтчеты,
	|	МАКСИМУМ(табРезультат.ИспользоватьПечатныеФормы) КАК ИспользоватьПечатныеФормы,
	|	МАКСИМУМ(табРезультат.ИспользоватьСозданиеСвязанныхОбъектов) КАК ИспользоватьСозданиеСвязанныхОбъектов
	|ИЗ
	|	втРезультат КАК табРезультат
	|
	|СГРУППИРОВАТЬ ПО
	|	табРезультат.ОбъектНазначения,
	|	табРезультат.ТипФормы
	|ИТОГИ ПО
	|	ОбъектНазначения";
	
	Если СсылкиОбъектовМетаданных = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(
			ТекстЗапроса,
			"ДополнительныеОтчетыИОбработкиНазначение.ОбъектНазначения В(&СсылкиОбъектовМетаданных)
			|	И ",
			"");
	Иначе
		Запрос.УстановитьПараметр("СсылкиОбъектовМетаданных", СсылкиОбъектовМетаданных);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ПубликацияНеРавно", Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена);
	Запрос.УстановитьПараметр("ВидЗаполнениеОбъекта",         Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта);
	Запрос.УстановитьПараметр("ВидОтчет",                     Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет);
	Запрос.УстановитьПараметр("ВидПечатнаяФорма",             Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма);
	Запрос.УстановитьПараметр("ВидСозданиеСвязанныхОбъектов", Перечисления.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов);
	Запрос.УстановитьПараметр("ТипФормыСписка",  ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыСписка());
	Запрос.УстановитьПараметр("ТипФормыОбъекта", ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыОбъекта());
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос;

#КонецОбласти
КонецФункции
#КонецЕсли
