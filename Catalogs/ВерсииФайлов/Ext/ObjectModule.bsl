﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("КонвертацияФайлов") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("РазмещениеФайловВТомах") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		РодительскаяВерсия = Владелец.ТекущаяВерсия;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() Тогда
		
		УстановленаПометкаУдаления = ПометкаУдаления И Не ПометкаУдаленияВИБ();
		
		ЗаписьПодписанногоОбъекта = Ложь;
		Если ДополнительныеСвойства.Свойство("ЗаписьПодписанногоОбъекта") Тогда
			ЗаписьПодписанногоОбъекта = ДополнительныеСвойства.ЗаписьПодписанногоОбъекта;
		КонецЕсли;
		
		// разрешаем ставить пометку удаления на подписанную версию
		Если НЕ ПривилегированныйРежим() И ЗаписьПодписанногоОбъекта <> Истина И НЕ УстановленаПометкаУдаления Тогда
			
			Если ЗначениеЗаполнено(Ссылка) Тогда
				
				СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПодписанЭП, Зашифрован");
				СсылкаПодписан = СтруктураРеквизитов.ПодписанЭП;
				СсылкаЗашифрован = СтруктураРеквизитов.Зашифрован;
				
				Если ПодписанЭП И СсылкаПодписан Тогда
					ВызватьИсключение НСтр("ru = 'Подписанную версию нельзя редактировать.'");
				КонецЕсли;
				
				Если Зашифрован И СсылкаЗашифрован И ПодписанЭП И НЕ СсылкаПодписан Тогда
					ВызватьИсключение НСтр("ru = 'Зашифрованный файл нельзя подписывать.'");
				КонецЕсли;
				
			КонецЕсли;
		
		КонецЕсли;
	КонецЕсли;
	
	// Выполним установку индекса пиктограммы при записи объекта
	ИндексКартинки = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Расширение);
	
	Если СтатусИзвлеченияТекста.Пустая() Тогда
		СтатусИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.НеИзвлечен;
	КонецЕсли;
	
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Файлы") Тогда
		Наименование = СокрЛП(ПолноеНаименование);
	КонецЕсли;
	
	Если Владелец.ТекущаяВерсия = Ссылка Тогда
		Если ПометкаУдаления = Истина И Владелец.ПометкаУдаления <> Истина Тогда
			ВызватьИсключение НСтр("ru = 'Активную версию нельзя удалить.'");
		КонецЕсли;
	ИначеЕсли РодительскаяВерсия.Пустая() Тогда
		Если ПометкаУдаления = Истина И Владелец.ПометкаУдаления <> Истина Тогда
			ВызватьИсключение НСтр("ru = 'Первую версию нельзя удалить.'");
		КонецЕсли;
	ИначеЕсли ПометкаУдаления = Истина И Владелец.ПометкаУдаления <> Истина Тогда
		// Очищаем у версий, дочерних к помеченной, ссылку на родительскую - 
		// переставляем на родительскую версию удаляемой версии
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВерсииФайлов.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ВерсииФайлов КАК ВерсииФайлов
			|ГДЕ
			|	ВерсииФайлов.РодительскаяВерсия = &РодительскаяВерсия";
		
		Запрос.УстановитьПараметр("РодительскаяВерсия", Ссылка);
		
		Результат = Запрос.Выполнить();
		
		Если Не Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка);
			Объект.РодительскаяВерсия = РодительскаяВерсия;
			Объект.Записать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске Тогда
		Если НЕ Том.Пустая() Тогда
			ПолныйПуть = ФайловыеФункцииСлужебный.ПолныйПутьТома(Том) + ПутьКФайлу; 
			Попытка
				Файл = Новый Файл(ПолныйПуть);
				Файл.УстановитьТолькоЧтение(Ложь);
				УдалитьФайлы(ПолныйПуть);
				
				ПутьСПодкаталогом = Файл.Путь;
				МассивФайловВКаталоге = НайтиФайлы(ПутьСПодкаталогом, "*.*");
				Если МассивФайловВКаталоге.Количество() = 0 Тогда
					УдалитьФайлы(ПутьСПодкаталогом);
				КонецЕсли;
				
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
	// Проверку ОбменДанными.Загрузка следует выполнять начиная с этой строки.
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает текущее значение пометки удаления в информационной базе
Функция ПометкаУдаленияВИБ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВерсииФайлов.ПометкаУдаления
		|ИЗ
		|	Справочник.ВерсииФайлов КАК ВерсииФайлов
		|ГДЕ
		|	ВерсииФайлов.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ПометкаУдаления;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецЕсли