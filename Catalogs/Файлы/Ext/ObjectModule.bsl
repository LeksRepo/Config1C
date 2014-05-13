﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обработка события ПередЗаписью
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("КонвертацияФайлов") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВладелецФайла) Тогда
		
		Если ОбновлениеИнформационнойБазы.ВыполняетсяОбновлениеИнформационнойБазы() Тогда
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Файлы.Ошибка записи файла при обновлении ИБ'"),
				УровеньЖурналаРегистрации.Ошибка,
				,
				Ссылка,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнен владелец в файле
					           |""%1"".'"),
					Строка(Ссылка)));
		Иначе
			ВызватьИсключение НСтр("ru = 'Нельзя записать файл, если не указан владелец файла.'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЭтоНовый() Тогда
		
		ЕстьПометкаУдаленияВИБ = ПометкаУдаленияВИБ();
		УстановленаПометкаУдаления = ПометкаУдаления И Не ЕстьПометкаУдаленияВИБ;
		ИзмененаПометкаУдаления = (ПометкаУдаления <> ЕстьПометкаУдаленияВИБ);
		
		ЗаписьПодписанногоОбъекта = Ложь;
		Если ДополнительныеСвойства.Свойство("ЗаписьПодписанногоОбъекта") Тогда
			ЗаписьПодписанногоОбъекта = ДополнительныеСвойства.ЗаписьПодписанногоОбъекта;
		КонецЕсли;	
		
		// разрешаем ставить пометку удаления на подписанный файл
		Если НЕ ПривилегированныйРежим() И ЗаписьПодписанногоОбъекта <> Истина И НЕ УстановленаПометкаУдаления Тогда
			
			Если ЗначениеЗаполнено(Ссылка) Тогда
				
				СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПодписанЭЦП, Зашифрован");
				СсылкаПодписан = СтруктураРеквизитов.ПодписанЭЦП;
				СсылкаЗашифрован = СтруктураРеквизитов.Зашифрован;
				
				Если ПодписанЭЦП И СсылкаПодписан Тогда
					ВызватьИсключение НСтр("ru = 'Подписанный файл нельзя редактировать.'");
				КонецЕсли;	
				
				Если Зашифрован И СсылкаЗашифрован И ПодписанЭЦП И НЕ СсылкаПодписан Тогда
					ВызватьИсключение НСтр("ru = 'Зашифрованный файл нельзя подписывать.'");
				КонецЕсли;	
				
			КонецЕсли;	
			
		КонецЕсли;	
		
		Если Не ТекущаяВерсия.Пустая() Тогда
			
			РеквизитыТекущейВерсии = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				ТекущаяВерсия, "ПолноеНаименование");
			
			// Проверим равенство имени файла и его текущей версии
			// Если имена отличаются - имя у версии должно стать как у карточки с файлом
			Если РеквизитыТекущейВерсии.ПолноеНаименование <> ПолноеНаименование Тогда
				Объект = ТекущаяВерсия.ПолучитьОбъект();
				Если Объект <> Неопределено И Объект.Ссылка <> Неопределено Тогда
					ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка);
					УстановитьПривилегированныйРежим(Истина);
					Объект.ПолноеНаименование = ПолноеНаименование;
					Объект.ДополнительныеСвойства.Вставить("ПереименованиеФайла", Истина); // чтобы не сработала подписка СкопироватьРеквизитыВерсииФайловВФайл
					Объект.Записать();
					УстановитьПривилегированныйРежим(Ложь);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ИзмененаПометкаУдаления Тогда
			
			// Проверка права "Пометка на удаление".
			ПометкаНаУдалениеРазрешена = Истина;
			СтандартныеПодсистемыПереопределяемый.ПроверитьПравоПометкиУдаления(
				ВладелецФайла, ПометкаНаУдалениеРазрешена);
			
			Если НЕ ПометкаНаУдалениеРазрешена Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'У вас нет права ""Пометка на удаление"" файла ""%1"".'"),
					Строка(Ссылка));
			КонецЕсли;
			
			// Попытка установить пометку удаления
			Если УстановленаПометкаУдаления И Не Редактирует.Пустая() Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Нельзя удалить файл ""%1"",
					           |т.к. он занят для редактирования пользователем ""%2"".'"),
					ПолноеНаименование,
					Строка(Редактирует) );
			КонецЕсли;
			
		КонецЕсли;
		
		НаименованиеВИБ = НаименованиеВИБ();
		Если ПолноеНаименование <> НаименованиеВИБ Тогда 
			Если Не Редактирует.Пустая() Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Нельзя переименовать файл ""%1"",
					           |т.к. он занят для редактирования пользователем ""%2"".'"),
					НаименованиеВИБ,
					Строка(Редактирует));
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Основной И ЕстьОсновной() Тогда
		ВызватьИсключение "Основной файл уже существует.";
	КонецЕсли;
	
	Если Не Основной Тогда		
		РасположениеКартинки = Неопределено;
	КонецЕсли;	
	
	Договор = Документы.Спецификация.ПолучитьДоговор(ВладелецФайла);
	
	Если ЗначениеЗаполнено(Договор) Тогда
		Если Договор.Проведен Тогда
			ВызватьИсключение НСтр("ru = 'Нельзя записать файл, если заключен договор.'");
		КонецЕсли;
	КонецЕсли;
	
	Наименование = СокрЛП(ПолноеНаименование);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда
		ДатаСоздания = ТекущаяДатаСеанса();
		ХранитьВерсии = Истина;
		ИндексКартинки = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Неопределено);
		
		Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает текущее значение пометки удаления в информационной базе
Функция ПометкаУдаленияВИБ()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Файлы.ПометкаУдаления
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|ГДЕ
		|	Файлы.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Результат = Запрос.Выполнить();

	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ПометкаУдаления;
	КонецЕсли;	
	
	Возврат Неопределено;
КонецФункции

// Возвращает текущее значение наименования в информационной базе
Функция НаименованиеВИБ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Файлы.ПолноеНаименование
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|ГДЕ
	|	Файлы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ПолноеНаименование;
	КонецЕсли;
	
	Возврат Неопределено;	
	
КонецФункции

// Возвращает отказ записи элемента, если основной элемент уже существует(основных может быть 2 элемента левый И правый) 
Функция ЕстьОсновной()
	
	ЕстьОсновной = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Файлы.Ссылка,
	|	Файлы.РасположениеКартинки,
	|	ВЫБОР
	|		КОГДА Файлы.РасположениеКартинки = ЗНАЧЕНИЕ(Перечисление.РасположениеКартинки.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОсновная
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|ГДЕ
	|	Файлы.ВладелецФайла = &ВладелецФайла
	|	И Файлы.Основной
	|	И Файлы.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВладелецФайла", ВладелецФайла);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		КоличествоОсновных = Выборка.Количество();
		Выборка.Следующий();
		Если КоличествоОсновных = 2 
			ИЛИ (КоличествоОсновных = 1 
			И (Выборка.РасположениеКартинки = РасположениеКартинки ИЛИ НЕ ЗначениеЗаполнено(РасположениеКартинки) ИЛИ Выборка.ЕстьОсновная)) Тогда
		    ЕстьОсновной = Истина;
		КонецЕсли;	
	КонецЕсли;	
	
	Возврат ЕстьОсновной;
		
КонецФункции

#КонецЕсли