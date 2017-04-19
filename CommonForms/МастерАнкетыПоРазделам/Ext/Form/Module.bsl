﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ШаблонАнкеты") = Ложь Тогда
		Отказ = Истина;
		Возврат;
	Иначе
		ШаблонАнкеты = Параметры.ШаблонАнкеты;
	КонецЕсли;
	
	УстановитьЗначенияРеквизитовФормыСогласноШаблонаАнкеты();
	Анкетирование.УстановитьЭлементДереваРазделовАнкетыВступлениеЗаключение(ДеревоРазделов,"Вступление");
	Анкетирование.ЗаполнитьДеревоРазделов(ЭтаФорма,ДеревоРазделов);
	Анкетирование.УстановитьЭлементДереваРазделовАнкетыВступлениеЗаключение(ДеревоРазделов,"Заключение");
	АнкетированиеКлиентСервер.СформироватьНумерациюДерева(ДеревоРазделов,Истина);
	
	Элементы.ДеревоРазделов.ТекущаяСтрока = 0;
	ПостроениеФормыСогласноРаздела();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ГруппаСтраницыФормаЗаполнения.ТекущаяСтраница = Элементы.ГруппаТелоАнкеты;
	УправлениеДоступностьюКнопкиНавигацияРазделов();
	
КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ДеревоРазделовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоРазделов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьПостроениеФормыЗаполнения();
	УправлениеДоступностьюКнопкиНавигацияРазделов();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииВопросовСУсловием(Элемент)

	УправлениеДоступностьюПодчиненныеВопросы();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СкрытьПоказатьДеревоРазделов(Команда)

	ИзменитьВидимостьДеревоРазделов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущийРаздел(Команда)
	
	ИзменитьРаздел("Назад");
	
КонецПроцедуры

&НаКлиенте
Процедура СледующийРаздел(Команда)
	
	ИзменитьРаздел("Вперед");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборРаздела(Команда)
	
	ВыполнитьПостроениеФормыЗаполнения();
	УправлениеДоступностьюКнопкиНавигацияРазделов();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Отвечает за построение формы заполнения 
&НаСервере
Процедура ПостроениеФормыСогласноРаздела()
	
	//определение выбранного раздела
	ТекущиеДанныеДеревоРазделов = ДеревоРазделов.НайтиПоИдентификатору(Элементы.ДеревоРазделов.ТекущаяСтрока);
	Если ТекущиеДанныеДеревоРазделов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НомерТекущегоРаздела = Элементы.ДеревоРазделов.ТекущаяСтрока;
	Анкетирование.ПостроениеФормыЗаполненияПоРазделу(ЭтаФорма,ТекущиеДанныеДеревоРазделов);
	Анкетирование.СформироватьТаблицуПодчиненияВопросов(ЭтаФорма);
	
	Элементы.ПредыдущийРазделПодвал.Видимость = (ТаблицаВопросовРаздела.Количество() > 0);
	Элементы.СледующийРазделПодвал.Видимость  = (ТаблицаВопросовРаздела.Количество() > 0);
	
КонецПроцедуры

// Начинает процесс построения формы заполнения согласно разделам
&НаКлиенте
Процедура ВыполнитьПостроениеФормыЗаполнения()
	
	Элементы.ГруппаСтраницыФормаЗаполнения.ТекущаяСтраница = Элементы.СтраницаОжидание;
	ПодключитьОбработчикОжидания("ОкончаниеПостроенияФормыЗаполнения",0.1,Истина);
	
КонецПроцедуры

// Заканчивает формирование формы заполнения анкеты
&НаКлиенте
Процедура ОкончаниеПостроенияФормыЗаполнения()
 
 	 ПостроениеФормыСогласноРаздела();
     УправлениеДоступностьюПодчиненныеВопросы();
	 Элементы.ГруппаСтраницыФормаЗаполнения.ТекущаяСтраница = Элементы.ГруппаТелоАнкеты; 
	 УправлениеДоступностьюКнопкиНавигацияРазделов();
 
 КонецПроцедуры

// Отвечает за доступность кнопок навигации по разделам
&НаКлиенте
Процедура УправлениеДоступностьюКнопкиНавигацияРазделов()
	
	Элементы.ПредыдущийРаздел.Доступность       = (Элементы.ДеревоРазделов.ТекущаяСтрока <> 0);
	Элементы.ПредыдущийРазделПодвал.Доступность = (Элементы.ДеревоРазделов.ТекущаяСтрока > 0);
	Элементы.СледующийРаздел.Доступность        = (ДеревоРазделов.НайтиПоИдентификатору(Элементы.ДеревоРазделов.ТекущаяСтрока +  1) <> Неопределено);
	Элементы.СледующийРазделПодвал.Доступность  = (ДеревоРазделов.НайтиПоИдентификатору(Элементы.ДеревоРазделов.ТекущаяСтрока +  1) <> Неопределено);
	
КонецПроцедуры

// Изменяет текущий раздел
&НаКлиенте
Процедура ИзменитьРаздел(Направление)
	
	Элементы.ДеревоРазделов.ТекущаяСтрока = НомерТекущегоРаздела + ?(Направление = "Вперед",1,-1);
	НомерТекущегоРаздела = НомерТекущегоРаздела + ?(Направление = "Вперед",1,-1);
	ТекущиеДанныеДеревоРазделов = ДеревоРазделов.НайтиПоИдентификатору(Элементы.ДеревоРазделов.ТекущаяСтрока);
	Если ТекущиеДанныеДеревоРазделов.КоличествоВопросов = 0 И ТекущиеДанныеДеревоРазделов.ТипСтроки = "Раздел"  Тогда
		ИзменитьРаздел(Направление);
	КонецЕсли;
	ВыполнитьПостроениеФормыЗаполнения();
	
КонецПроцедуры

// Изменяет видимость дерева разделов
&НаКлиенте
Процедура ИзменитьВидимостьДеревоРазделов()

	Элементы.ГруппаДеревоРазделов.Видимость         = НЕ Элементы.ГруппаДеревоРазделов.Видимость;
	Элементы.СкрытьПоказатьДеревоРазделов.Заголовок = ?(Элементы.ГруппаДеревоРазделов.Видимость,"Скрыть разделы","Показать разделы");
	Элементы.ДекорацияОжиданиеЭлементы.Ширина       = ?(Элементы.ГруппаДеревоРазделов.Видимость,20,45);

КонецПроцедуры 

//Управляет доступностью элементов формы
&НаКлиенте
Процедура УправлениеДоступностьюПодчиненныеВопросы()
	
	Для каждого ЭлементКоллекции Из ПодчиненныеВопросы Цикл
		
		ИмяВопроса = АнкетированиеКлиентСервер.ПолучитьИмяВопроса(ЭлементКоллекции.Вопрос);
		
		Для каждого ПодчиненныйВопрос Из ЭлементКоллекции.Подчиненные Цикл
			
			Элементы[ПодчиненныйВопрос.ИмяЭлементаПодчиненногоВопроса].ТолькоПросмотр           = (НЕ ЭтаФорма[ИмяВопроса]);
			Если СтрЧислоВхождений(ПодчиненныйВопрос.ИмяЭлементаПодчиненногоВопроса,"Реквизит") = 0 Тогда
				
				//У флажка и переключателя нет свойства АвтоОтметкаНезаполненного.
				Попытка
					Элементы[ПодчиненныйВопрос.ИмяЭлементаПодчиненногоВопроса].АвтоОтметкаНезаполненного = (ЭтаФорма[ИмяВопроса] И ПодчиненныйВопрос.Обязательный);
				Исключение
				КонецПопытки;
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры 

// Устанавливает значения реквизитов формы, определенных в шаблоне анкеты
//
&НаСервере
Процедура УстановитьЗначенияРеквизитовФормыСогласноШаблонаАнкеты()

	РеквизитыШаблонАнкеты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ШаблонАнкеты,"Заголовок,Вступление,Заключение");
	ЗаполнитьЗначенияСвойств(ЭтаФорма,РеквизитыШаблонАнкеты);

КонецПроцедуры
