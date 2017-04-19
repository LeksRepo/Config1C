﻿////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТекущийОбъект = ЭтотОбъект();
	ТекущийОбъект.ПрочитатьНастройки();
	ТекущийОбъект.ПрочитатьПризнакПоддержкиБСП();
	ЭтотОбъект(ТекущийОбъект);
	
	ОбъектРегистрации = Параметры.ОбъектРегистрации;
	Расшифровка       = "";
	
	Если ТипЗнч(ОбъектРегистрации)=Тип("Структура") Тогда
		ТаблицаРегистрации = Параметры.ТаблицаРегистрации;
		ОбъектСтрокой = ТаблицаРегистрации;
		Для Каждого КлючЗначение Из ОбъектРегистрации Цикл
			Расшифровка = Расшифровка + "," + КлючЗначение.Значение;
		КонецЦикла;
		Расшифровка = " (" + Сред(Расшифровка,2) + ")";
	Иначе		
		ТаблицаРегистрации = "";
		ОбъектСтрокой = ОбъектРегистрации;
	КонецЕсли;
	Заголовок = "Регистрация " + ТекущийОбъект.ПредставлениеСсылки(ОбъектСтрокой) + Расшифровка;
	
	ПрочитатьУзлыОбмена();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РазвернутьВсеУзлы();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДеревоУзловОбмена
//

&НаКлиенте
Процедура ДеревоУзловОбменаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Поле=Элементы.ДеревоУзловОбменаНаименование Или Поле=Элементы.ДеревоУзловОбменаКод Тогда
		ОткрытьФормуРедактированияДругихОбъектов();
		Возврат;
	ИначеЕсли Поле<>Элементы.ДеревоУзловОбменаНомерСообщения Тогда
		Возврат;
	КонецЕсли;
	
	ТекДанные = Элементы.ДеревоУзловОбмена.ТекущиеДанные;
	
	НомерСообщения = ТекДанные.НомерСообщения;
	Подсказка = НСтр("ru='Номер отправленного'"); 
	Если ВвестиЧисло(НомерСообщения, Подсказка) Тогда
		ИзменитьНомерСообщенияНаСервере(ТекДанные.Ссылка, НомерСообщения, ОбъектРегистрации, ТаблицаРегистрации);
		
		ТекущийУзел = ТекущийВыбранныйУзел();
		ПрочитатьУзлыОбмена(Истина);
		РазвернутьВсеУзлы(ТекущийУзел);
		
		Если Параметры.ОповещатьОбИзменениях Тогда
			Оповестить("ИзменениеРегистрацииОбменаДаннымиОбъекта",
				Новый Структура("ОбъектРегистрации, ТаблицаРегистрации", ОбъектРегистрации, ТаблицаРегистрации),
				ЭтаФорма);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоУзловОбменаПометкаПриИзменении(Элемент)
	ИзменениеПометки(Элементы.ДеревоУзловОбмена.ТекущаяСтрока);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
//

&НаКлиенте
Процедура ПеречитатьДеревоУзлов(Команда)
	ТекущийУзел = ТекущийВыбранныйУзел();
	ПрочитатьУзлыОбмена();
	РазвернутьВсеУзлы(ТекущийУзел);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияОтУзла(Команда)
	ОткрытьФормуРедактированияДругихОбъектов();
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВсеУзлы(Команда)
	Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		СтрокаПлана.Пометка = Истина;
		ИзменениеПометки(СтрокаПлана.ПолучитьИдентификатор())
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкуВсемУзлам(Команда)
	Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		СтрокаПлана.Пометка = Ложь;
		ИзменениеПометки(СтрокаПлана.ПолучитьИдентификатор())
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ИнвертироватьПометкуВсемУзлам(Команда)
	Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		Для Каждого СтрокаУзла Из СтрокаПлана.ПолучитьЭлементы() Цикл
			СтрокаУзла.Пометка = Не СтрокаУзла.Пометка;
			ИзменениеПометки(СтрокаУзла.ПолучитьИдентификатор())
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРегистрацию(Команда)
	
	Текст = НСтр("ru='Изменить регистрацию ""%1""
	             |на узлах?'");
	
	ЗаголовокВопроса = НСтр("ru='Подтверждение'");
	
	Текст = СтрЗаменить(Текст, "%1", ОбъектРегистрации);
	Ответ = Вопрос(Текст, РежимДиалогаВопрос.ДаНет,,,ЗаголовокВопроса);
	Если Ответ=КодВозвратаДиалога.Да Тогда
		
		Колво = ИзменениеРегистрацииПоУзлам(ДеревоУзловОбмена);
		Если Колво>0 Тогда
			Текст = НСтр("ru='Регистрация %1 была изменена на %2 узлах'");
			ЗаголовокОповещения = НСтр("ru='Изменение регистрации:'");
			
			Текст = СтрЗаменить(Текст, "%1", ОбъектРегистрации);
			Текст = СтрЗаменить(Текст, "%2", Колво);
			
			ПоказатьОповещениеПользователя(ЗаголовокОповещения,
				ПолучитьНавигационнуюСсылку(ОбъектРегистрации),
				Текст,
				Элементы.СкрытаяКартинкаИнформация32.Картинка);
			
			Если Параметры.ОповещатьОбИзменениях Тогда
				Оповестить("ИзменениеРегистрацииОбменаДаннымиОбъекта",
					Новый Структура("ОбъектРегистрации, ТаблицаРегистрации", ОбъектРегистрации, ТаблицаРегистрации),
					ЭтаФорма);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ТекущийУзел = ТекущийВыбранныйУзел();
	ПрочитатьУзлыОбмена(Истина);
	РазвернутьВсеУзлы(ТекущийУзел);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастроек(Команда)
	ОткрытьФормуНастроекОбработки();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

&НаКлиенте
Функция ТекущийВыбранныйУзел()
	ТекущиеДанные = Элементы.ДеревоУзловОбмена.ТекущиеДанные;
	Если ТекущиеДанные=Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат Новый Структура("Наименование, Ссылка", ТекущиеДанные.Наименование, ТекущиеДанные.Ссылка);
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуНастроекОбработки()
	ТекИмяФормы = ПолучитьИмяФормы() + "Форма.Настройки";
	ОткрытьФорму(ТекИмяФормы, , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияДругихОбъектов()
	ТекИмяФормы = ПолучитьИмяФормы() + "Форма.Форма";
	Данные = Элементы.ДеревоУзловОбмена.ТекущиеДанные;
	Если Данные<>Неопределено И Данные.Ссылка<>Неопределено Тогда
		ТекПараметры = Новый Структура("УзелОбмена, ИдентификаторКоманды, ОбъектыНазначения", Данные.Ссылка);
		ОткрытьФорму(ТекИмяФормы, ТекПараметры, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВсеУзлы(УзелФокуса=Неопределено)
	НайденныйУзел = Неопределено;
	
	Для Каждого Строка Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		Идентификатор = Строка.ПолучитьИдентификатор();
		Элементы.ДеревоУзловОбмена.Развернуть(Идентификатор, Истина);
		
		Если УзелФокуса<>Неопределено И НайденныйУзел=Неопределено Тогда
			Если Строка.Наименование=УзелФокуса.Наименование И Строка.Ссылка=УзелФокуса.Ссылка Тогда
				НайденныйУзел = Идентификатор;
			Иначе
				Для Каждого Подстрока Из Строка.ПолучитьЭлементы() Цикл
					Если Подстрока.Наименование=УзелФокуса.Наименование И Подстрока.Ссылка=УзелФокуса.Ссылка Тогда
						НайденныйУзел = Подстрока.ПолучитьИдентификатор();
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если УзелФокуса<>Неопределено И НайденныйУзел<>Неопределено Тогда
		Элементы.ДеревоУзловОбмена.ТекущаяСтрока = НайденныйУзел;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИзменениеРегистрацииПоУзлам(Знач Данные)
	ТекущийОбъект = ЭтотОбъект();
	КолвоУзлов = 0;
	Для Каждого Строка Из Данные.ПолучитьЭлементы() Цикл
		Если Строка.Ссылка<>Неопределено Тогда
			флУже = ТекущийОбъект.ОбъектЗарегистрированНаУзле(Строка.Ссылка, ОбъектРегистрации, ТаблицаРегистрации);
			Если Строка.Пометка=0 И флУже Тогда
				Результат = ТекущийОбъект.ИзменитьРегистрациюНаСервере(Ложь, Истина, Строка.Ссылка, ОбъектРегистрации, ТаблицаРегистрации);
				КолвоУзлов = КолвоУзлов + Результат.Успешно;
			ИначеЕсли Строка.Пометка=1 И (Не флУже) Тогда
				Результат = ТекущийОбъект.ИзменитьРегистрациюНаСервере(Истина, Истина, Строка.Ссылка, ОбъектРегистрации, ТаблицаРегистрации);
				КолвоУзлов = КолвоУзлов  + Результат.Успешно;
			КонецЕсли;
		КонецЕсли;
		КолвоУзлов = КолвоУзлов + ИзменениеРегистрацииПоУзлам(Строка);
	КонецЦикла;
	Возврат КолвоУзлов;
КонецФункции

&НаСервере
Функция ИзменитьНомерСообщенияНаСервере(Узел, НомерСообщения, Данные, ИмяТаблицы=Неопределено)
	Возврат ЭтотОбъект().ИзменитьРегистрациюНаСервере(НомерСообщения, Истина, Узел, Данные, ИмяТаблицы);
КонецФункции

&НаСервере
Функция ЭтотОбъект(ТекущийОбъект=Неопределено) 
	Если ТекущийОбъект=Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаСервере
Функция ПолучитьИмяФормы(ТекущийОбъект=Неопределено)
	Возврат ЭтотОбъект().ПолучитьИмяФормы(ТекущийОбъект);
КонецФункции

&НаСервере
Процедура ИзменениеПометки(Строка)
	ЭлементДанных = ДеревоУзловОбмена.НайтиПоИдентификатору(Строка);
	ЭтотОбъект().ИзменениеПометки(ЭлементДанных);
КонецПроцедуры

&НаСервере
Процедура ПрочитатьУзлыОбмена(ТолькоОбновить=Ложь)
	ТекущийОбъект = ЭтотОбъект();
	Дерево = ТекущийОбъект.СформироватьДеревоУзлов(ОбъектРегистрации, ТаблицаРегистрации);
	
	Если ТолькоОбновить Тогда
		// Обновляем некоторые поля текущим данным
		Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
			Для Каждого СтрокаУзла Из СтрокаПлана.ПолучитьЭлементы() Цикл
				СтрокаДерева = Дерево.Строки.Найти(СтрокаУзла.Ссылка, "Ссылка", Истина);
				Если СтрокаДерева<>Неопределено Тогда
					ЗаполнитьЗначенияСвойств(СтрокаУзла, СтрокаДерева, "Пометка, ИсходнаяПометка, НомерСообщения, НеВыгружалось");
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	Иначе
		// Переформируем полностью
		ЗначениеВРеквизитФормы(Дерево, "ДеревоУзловОбмена");
	КонецЕсли;
	
	Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		Для Каждого СтрокаУзла Из СтрокаПлана.ПолучитьЭлементы() Цикл
			ТекущийОбъект.ИзменениеПометки(СтрокаУзла);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры


