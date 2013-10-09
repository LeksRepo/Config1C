﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ,СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Анкетирование.УстановитьКорневойЭлементДереваАнкеты(ДеревоАнкеты);
	Анкетирование.ЗаполнитьДеревоШаблонаАнкеты(ЭтаФорма,"ДеревоАнкеты",Объект.Ссылка);
	АнкетированиеКлиентСервер.СформироватьНумерациюДерева(ДеревоАнкеты);
	УстановитьУсловноеОформлениеФормы();
	ОпределитьЕстьЛиДанномуШаблонуАнкеты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Элементы.ФормаДереваАнкеты.Развернуть(ДеревоАнкеты.ПолучитьЭлементы()[0].ПолучитьИдентификатор(),Ложь);
	
	Если Объект.РедактированиеШаблонаЗавершено ИЛИ ПоДанномуШаблонуЕстьАнкеты Тогда
		УстановитьНедоступностьРедактирования();
	Иначе
		ОпределитьДоступностьДереваШаблона();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Анкетирование.УдалитьВопросыШаблонаАнкеты(Объект.Ссылка);
	ДеревоШаблонаАнкеты  = РеквизитФормыВЗначение("ДеревоАнкеты");
	
	ЗаписатьДеревоШаблонаАнкеты(ДеревоШаблонаАнкеты.Строки[0],1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = "ОкончаниеРедактированияПараметровТабличногоВопроса" Тогда
		
		ОбработатьРезультатРаботыМастераТабличныхВопросов(ТекущиеДанные,Параметр,Элементы.ФормаДереваАнкеты.ТекущаяСтрока);
		ОбновитьИнформациюТабличныйВопрос(ТекущиеДанные);
		Модифицированность = Истина;
		
	ИначеЕсли ИмяСобытия = "ОкочаниеРедактированияПараметровСтрокиШаблонаАнкеты" Тогда
		
		ЗаполнитьЗначенияСвойств(ТекущиеДанные,Параметр);
		Модифицированность = Истина;
		Информация         = СформироватьСтрокуФормулировкиДляПревью(ТекущиеДанные);
		
		Если ТекущиеДанные.ТипСтроки <> "Вопрос" Тогда
			ТекущиеДанные.Обязательный = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ДеревоШаблонаАнкеты  = РеквизитФормыВЗначение("ДеревоАнкеты");
	
	Если ДеревоШаблонаАнкеты.Строки[0].Строки.Найти("","Формулировка",Истина) <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не все формулировки или имена разделов заполнены.'"),,"ДеревоАнкеты");
		Отказ = Истина;
	КонецЕсли;
	
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ЭлементарныйВопрос",ПланыВидовХарактеристик.ВопросыДляАнкетирования.ПустаяСсылка());
	СтруктураОтбора.Вставить("ТипСтроки","Вопрос");
	
	НайденныеСтроки = ДеревоШаблонаАнкеты.Строки[0].Строки.НайтиСтроки(СтруктураОтбора,Истина);
	Если НайденныеСтроки.Количество() <> 0 Тогда
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если НайденнаяСтрока.ТипВопроса <> Перечисления.ТипыВопросовШаблонаАнкеты.Табличный Тогда
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не все вопросы заполнены.'"),,"ДеревоАнкеты");
				Отказ = Истина;
				Прервать;
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОпределитьДоступностьДереваШаблона();
	Если Объект.РедактированиеШаблонаЗавершено Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ФормаДереваАнкеты

&НаКлиенте
Процедура ФормаДереваАнкетыПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ТипСтроки = "Корень" Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтраницаПревьюТабличногоВопроса = Элементы.Найти("Страница_ПревьюТабличногоВопроса_" + СтрЗаменить(Строка(ТекущиеДанные.КлючСтроки),"-","_"));
	Если СтраницаПревьюТабличногоВопроса <> Неопределено Тогда 
		Элементы.СтраницыИнформация.ТекущаяСтраница = СтраницаПревьюТабличногоВопроса;
	Иначе
		Информация = СформироватьСтрокуФормулировкиДляПревью(ТекущиеДанные);
		Элементы.СтраницыИнформация.ТекущаяСтраница = Элементы.СтраницаИнформация;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если (Строка = Неопределено) ИЛИ (ПараметрыПеретаскивания.Значение = Неопределено) Тогда
		Возврат;
	КонецЕсли;
		
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("Число") Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	СтрокаНазначение     = ДеревоАнкеты.НайтиПоИдентификатору(Строка);
	СтрокаПеретаскивание = ДеревоАнкеты.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение);
	
	Если (СтрокаПеретаскивание.ТипСтроки = "Раздел") И (СтрокаНазначение.ТипСтроки = "Вопрос") Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	ИначеЕсли (СтрокаПеретаскивание.ТипСтроки = "Вопрос") И (СтрокаНазначение.ТипСтроки = "Корень")	Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	ИначеЕсли (СтрокаПеретаскивание.ТипСтроки = "Раздел") И (СтрокаНазначение.ТипСтроки = "Раздел") Тогда
		Если СтрокаПеретаскивание.ВопросШаблона = СтрокаНазначение.ВопросШаблона Тогда
		      ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
			Возврат;
		КонецЕсли;
		Родитель = СтрокаНазначение.ПолучитьРодителя();
		Пока Родитель.ТипСтроки <> "Корень" Цикл
				Если Родитель = СтрокаПеретаскивание Тогда
					ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
					Возврат;
				Иначе
					Родитель = Родитель.ПолучитьРодителя();
				КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если Элементы.ФормаДереваАнкеты.ТолькоПросмотр Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	КонецЕсли; 
	
	СтрокаПеретаскивание = ДеревоАнкеты.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение);
	Если ТипЗнч(СтрокаПеретаскивание) = Тип("Неопределено") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	Иначе
		Если СтрокаПеретаскивание.ТипСтроки = "Корень" Тогда
			СтандартнаяОбработка = Ложь;
			ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтрокаНазначение     = ДеревоАнкеты.НайтиПоИдентификатору(Строка);
	СтрокаПеретаскивание = ДеревоАнкеты.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение);
	
	Если (СтрокаПеретаскивание.ТипСтроки = "Вопрос") И (СтрокаНазначение.ТипСтроки = "Вопрос") Тогда
		
		//Вопрос без условия перетаскиваем на вопрос с условием  
		Если СтрокаПеретаскивание.ТипВопроса <> ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием")
			И СтрокаНазначение.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием") Тогда
			
			СтандартнаяОбработка = Ложь;
			ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Ложь);
			
			Модифицированность = Истина;
			
		ИначеЕсли СтрокаПеретаскивание.ПолучитьРодителя() <> СтрокаНазначение.ПолучитьРодителя() Тогда
			
			СтандартнаяОбработка = Ложь;
			ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Истина);
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	ИначеЕсли (СтрокаПеретаскивание.ТипСтроки = "Вопрос") И (СтрокаНазначение.ТипСтроки = "Раздел") Тогда
		
		Если СтрокаПеретаскивание.ПолучитьРодителя() <> СтрокаНазначение Тогда
			
			СтандартнаяОбработка = Ложь;
			ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Ложь);
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	ИначеЕсли (СтрокаПеретаскивание.ТипСтроки = "Раздел") И (СтрокаНазначение.ТипСтроки = "Раздел") Тогда
		
		Если СтрокаПеретаскивание.ПолучитьРодителя() <> СтрокаНазначение Тогда
			
			СтандартнаяОбработка = Ложь;
			ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Ложь);
			
			Модифицированность = Истина; 
			
		ИначеЕсли СтрокаПеретаскивание.ПолучитьРодителя() <> СтрокаНазначение.ПолучитьРодителя() Тогда
			
			СтандартнаяОбработка = Ложь;
			ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Истина);
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	ИначеЕсли (СтрокаПеретаскивание.ТипСтроки = "Раздел") И (СтрокаНазначение.ТипСтроки = "Вопрос") Тогда
		
		Если (СтрокаПеретаскивание.ПолучитьРодителя() <> СтрокаНазначение.ПолучитьРодителя()) И (СтрокаНазначение.ПолучитьРодителя() <> СтрокаПеретаскивание)Тогда
			
			СтандартнаяОбработка = Ложь;
			ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Истина);
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ((СтрокаПеретаскивание.ТипСтроки = "Раздел") ИЛИ (СтрокаПеретаскивание.ТипСтроки = "Вопрос")) И (СтрокаНазначение.ТипСтроки = "Корень") Тогда
		
		СтандартнаяОбработка = Ложь;
		ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Ложь);
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыПриИзменении(Элемент)
	
	Модифицированность = Истина;
	АнкетированиеКлиентСервер.СформироватьНумерациюДерева(ДеревоАнкеты);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ТипСтроки = "Корень" Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли ТекущиеДанные.ТипСтроки = "Раздел" 
		ИЛИ (ТекущиеДанные.ТипСтроки = "Вопрос" И ТекущиеДанные.ТипВопроса <> ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный") ) Тогда
		
		ОткрытьФормуПростыхВопросов(ТекущиеДанные);
		
	ИначеЕсли ТекущиеДанные.ТипСтроки = "Вопрос" И ТекущиеДанные.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный") Тогда
		
		ОткрытьФормуМастераТабличныхВопросов(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	СписокВыбора = Новый  СписокЗначений;
	СписокВыбора.Добавить("Раздел");
	СписокВыбора.Добавить("Простой вопрос");
	СписокВыбора.Добавить("Условный вопрос");
	СписокВыбора.Добавить("Табличный вопрос");
	
	ВыбранноеЗначение = СписокВыбора.ВыбратьЭлемент("Выберите тип добавляемого элемента.",СписокВыбора[0]);
	Если НЕ ВыбранноеЗначение = Неопределено Тогда
		
		Если ВыбранноеЗначение.Значение = "Раздел" Тогда
			
			ДобавитьРаздел(Команды.ДобавитьРаздел);
			
		ИначеЕсли ВыбранноеЗначение.Значение = "Простой вопрос" Тогда
			
			ДобавитьПростойВопрос(Команды.ДобавитьПростойВопрос)
			
		ИначеЕсли ВыбранноеЗначение.Значение = "Условный вопрос" Тогда
			
			ДобавитьВопросСУсловием(Команды.ДобавитьВопросСУсловием)
			
		ИначеЕсли ВыбранноеЗначение.Значение = "Табличный вопрос" Тогда
			
			ДобавитьТабличныйВопрос(Команды.ДобавитьТабличныйВопрос);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	АнкетированиеКлиентСервер.СформироватьНумерациюДерева(ДеревоАнкеты);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.ФормаДереваАнкеты.ТолькоПросмотр Тогда
		Возврат;	
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если (Поле.Имя = "ДеревоАнкетыЗаметки") И (ТекущиеДанные.ТипСтроки <> "Корень") Тогда
		ОбщегоНазначенияКлиент.ОткрытьФормуРедактированияМногострочногоТекста(Элемент.ДанныеСтроки(ВыбраннаяСтрока).Заметки,
		                                                                      Элемент.ДанныеСтроки(ВыбраннаяСтрока).Заметки,
		                                                                      Модифицированность,
		                                                                      Нстр("ru='Заметки'"));
	Иначе	
		Если ТекущиеДанные.ТипСтроки = "Корень" Тогда
			Отказ = Истина;
			Возврат;
		ИначеЕсли ТекущиеДанные.ТипСтроки = "Раздел" 
			ИЛИ (ТекущиеДанные.ТипСтроки = "Вопрос" И ТекущиеДанные.ТипВопроса <> ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный") ) Тогда
			
			ОткрытьФормуПростыхВопросов(ТекущиеДанные);
			
		ИначеЕсли ТекущиеДанные.ТипСтроки = "Вопрос" И ТекущиеДанные.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный") Тогда
			
			ОткрытьФормуМастераТабличныхВопросов(ТекущиеДанные);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

//Устанавливает флаг окончания редактирования шаблона анкеты
//и записывет анкету
&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Объект.РедактированиеШаблонаЗавершено = Истина;
	Записать();
	
	Если Модифицированность Тогда
		Объект.РедактированиеШаблонаЗавершено = Ложь;
	Иначе
		УстановитьНедоступностьРедактирования();
	КонецЕсли;
	
КонецПроцедуры

//Добавляет раздел в дерево шаблона анкеты
&НаКлиенте
Процедура ДобавитьРаздел(Команда)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Родитель = ПолучитьРодителяДеревоАнкеты(ТекущиеДанные,Истина);
	ДобавитьСтрокуДеревоАнкеты(Родитель,"Раздел");
	
КонецПроцедуры

//Добавляет простой вопрос в дерево шаблона анкеты
&НаКлиенте
Процедура ДобавитьПростойВопрос(Команда)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьВопрос(ТекущиеДанные,ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Простой"));
	
КонецПроцедуры 

//Добавляет вопрос с условием в шаблон анкеты
&НаКлиенте
Процедура ДобавитьВопросСУсловием(Команда)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьВопрос(ТекущиеДанные,ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием"));
	
КонецПроцедуры

//Добавляетм табличный вопрос в шаблон анкеты
&НаКлиенте
Процедура ДобавитьТабличныйВопрос(Команда)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьВопрос(ТекущиеДанные,ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный"));
	
КонецПроцедуры 

&НаКлиенте
Процедура ОткрытьФормуЗаполненияАнкеты(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат; 
	КонецЕсли;
	
	Если Модифицированность Тогда
		Ответ = Вопрос(Нстр("ru = 'Шаблон анкеты был модифицирован. 
			|Для корректного отображения изменений шаблон необходимо записать.
			|Записать?'"),РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да,Нстр("ru = 'Записать?'"));
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Записать();
		КонецЕсли;
	КонецЕсли;
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("ШаблонАнкеты",Объект.Ссылка);
	ОткрытьФорму("ОбщаяФорма.МастерАнкетыПоРазделам",СтруктураПараметры,ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Добавляет новую строку в дерево формы
// Родитель   - СтрокаДереваАнкеты - элемент дерева значений формы, от которого отращивается новая ветка
// ТипСтроки  - Строка - Тип строки дерева
// Возвращаемое значение:
// Строка     - новая строка дерева 
//
&НаКлиенте
Функция ДобавитьСтрокуДеревоАнкеты(Родитель,ТипСтроки,ТипВопроса = Неопределено)
	
	ЭлементыДерева = Родитель.ПолучитьЭлементы();
	НоваяСтрока    = ЭлементыДерева.Добавить();
	
	НоваяСтрока.ТипСтроки    = ТипСтроки;
	НоваяСтрока.Обязательный = ЛОЖЬ;
	НоваяСтрока.КлючСтроки   = Новый УникальныйИдентификатор;
	
	Если ТипСтроки = "Вопрос" Тогда
		
		НоваяСтрока.ТипВопроса         = ТипВопроса;
		НоваяСтрока.КодКартинки        = АнкетированиеКлиентСервер.ПолучитьКодКартинкиШаблонаАнкеты(ЛОЖЬ,ТипВопроса);
		НоваяСтрока.ЭлементарныйВопрос = ?(ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный"),"",ПредопределенноеЗначение("ПланВидовХарактеристик.ВопросыДляАнкетирования.ПустаяСсылка"));
		НоваяСтрока.Обязательный       = ?(ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный"),"",Ложь);
		
	Иначе
		
		НоваяСтрока.ТипВопроса         = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ПустаяСсылка");
		НоваяСтрока.КодКартинки        = АнкетированиеКлиентСервер.ПолучитьКодКартинкиШаблонаАнкеты(ИСТИНА);
		НоваяСтрока.ЭлементарныйВопрос = "";
		НоваяСтрока.Обязательный       = "";
		
	КонецЕсли;
	
	АнкетированиеКлиентСервер.СформироватьНумерациюДерева(ДеревоАнкеты);
	Элементы.ФормаДереваАнкеты.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	
	Модифицированность = Истина;
	Элементы.ФормаДереваАнкеты.ИзменитьСтроку();
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаСервере
Процедура ЗаписатьДеревоШаблонаАнкеты(СтрокаДереваРодитель,УровеньРекурсии,СправочникРодитель = Неопределено)
	
	Счётчик = 0;
	
	//запишем новые
	Для каждого СтрокаДерева Из СтрокаДереваРодитель.Строки Цикл
		
		Счётчик = Счётчик + 1;
		СпрСсылка = ДобавитьЭлементСправочникаВопросШаблонаАнкеты(СтрокаДерева,?(УровеньРекурсии = 1,Счётчик,Неопределено),СправочникРодитель);
		
		Если СтрокаДерева.Строки.Количество() > 0 Тогда
			Если СтрокаДерева.ТипСтроки = "Раздел" Тогда
				ЗаписатьДеревоШаблонаАнкеты(СтрокаДерева,УровеньРекурсии+1,СпрСсылка);
			Иначе
				Для каждого СтрокаПодчиненныйВопрос Из СтрокаДерева.Строки Цикл
					ДобавитьЭлементСправочникаВопросШаблонаАнкеты(СтрокаПодчиненныйВопрос,Неопределено,СправочникРодитель,СпрСсылка);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьЭлементСправочникаВопросШаблонаАнкеты(СтрокаДерева,Код = Неопределено,СправочникРодитель = Неопределено,ВопросРодитель = Неопределено)
	
	Если СтрокаДерева.ТипСтроки = "Раздел" Тогда
		
		СпрОбъект = Справочники.ВопросыШаблонаАнкеты.СоздатьГруппу();
		
	Иначе
		
		СпрОбъект = Справочники.ВопросыШаблонаАнкеты.СоздатьЭлемент();
		СпрОбъект.ТипВопроса                        = СтрокаДерева.ТипВопроса;
		СпрОбъект.ЭлементарныйВопрос                = СтрокаДерева.ЭлементарныйВопрос;
		СпрОбъект.ТипТабличногоВопроса              = СтрокаДерева.ТипТабличногоВопроса;
		СпрОбъект.Обязательный                      = СтрокаДерева.Обязательный;
		СпрОбъект.РодительВопрос                    = ?(ВопросРодитель = Неопределено, Справочники.ВопросыШаблонаАнкеты.ПустаяСсылка(),ВопросРодитель);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(СтрокаДерева.СоставТабличногоВопроса,СпрОбъект.СоставТабличногоВопроса);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(СтрокаДерева.ПредопределенныеОтветы,СпрОбъект.ПредопределенныеОтветы);
		СпрОбъект.ВысотаЭлементаФормулировкиВопроса = СтрокаДерева.ВысотаЭлементаФормулировкиВопроса;
		
	КонецЕсли;
	
	Если Код <> Неопределено Тогда
		СпрОбъект.Код = Код;
	КонецЕсли;
	СпрОбъект.Наименование = СтрокаДерева.Формулировка;
	СпрОбъект.Заметки      = СтрокаДерева.Заметки;
	СпрОбъект.Формулировка = СтрокаДерева.Формулировка;
	СпрОбъект.Родитель     = ?(СправочникРодитель = Неопределено,Справочники.ВопросыШаблонаАнкеты.ПустаяСсылка(),СправочникРодитель);
	СпрОбъект.Владелец    = Объект.Ссылка;
	
	СпрОбъект.Записать();
	
	Возврат СпрОбъект.Ссылка;
	
КонецФункции

// Обрабатывает результат работы мастера табличных вопросов
//
// Параметры
//  ТекущиеДанные -ДанныеФормыЭлементДерева - текущая данные дерева шаблона
//  Параметр  - Структура - результаты работы формы мастера табличного вопроса
//
&НаКлиенте
Процедура ОбработатьРезультатРаботыМастераТабличныхВопросов(ТекущиеДанные,Параметр,ТекущаяСтрока)
	
	ТекущиеДанные.СоставТабличногоВопроса.Очистить();
	ТекущиеДанные.ПредопределенныеОтветы.Очистить();
	
	ТекущиеДанные.ТипТабличногоВопроса = Параметр.ТипТабличногоВопроса;
	ТекущиеДанные.Наименование         = Параметр.Формулировка;
	ТекущиеДанные.Формулировка         = Параметр.Формулировка;
	ТекущиеДанные.ЭлементарныйВопрос   = Параметр.Формулировка;
	ТекущиеДанные.Обязательный         = "";
	
	НомерСтроки = 1;
	Для каждого Вопрос Из Параметр.Вопросы Цикл
	
		НоваяСтрока = ТекущиеДанные.СоставТабличногоВопроса.Добавить();
		НоваяСтрока.ЭлементарныйВопрос = Вопрос;
		НоваяСтрока.НомерСтроки        = НомерСтроки;
		
		НомерСтроки = НомерСтроки + 1;
	
	КонецЦикла;
	
	Для каждого Ответ Из Параметр.Ответы Цикл
		ЗаполнитьЗначенияСвойств(ТекущиеДанные.ПредопределенныеОтветы.Добавить(),Ответ);
	КонецЦикла;
	
	ОбработатьПревьюТабличногоВопроса(ТекущаяСтрока);
	УстановитьУсловноеОформлениеФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПревьюТабличногоВопроса(ТекущаяСтрока)
	
	ДанныеДереваАнкеты = ДеревоАнкеты.НайтиПоИдентификатору(ТекущаяСтрока);
	Если ДанныеДереваАнкеты = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	ДобавитьСтраницуПревьюТабличногоВопроса(ДанныеДереваАнкеты.ТипТабличногоВопроса,
	                                        ДанныеДереваАнкеты.СоставТабличногоВопроса.Выгрузить(),
	                                        ДанныеДереваАнкеты.ПредопределенныеОтветы.Выгрузить(),
	                                        ДанныеДереваАнкеты.КлючСтроки);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтраницуПревьюТабличногоВопроса(ТипТабличногоВопроса,СоставТабличногоВопроса,ПредопределенныеОтветы,КлючСтроки)
	
	ДобавляемыеРеквизиты = Новый Массив;
	ИмяТаблицы = "ПревьюТабличногоВопроса_" + СтрЗаменить(Строка(КлючСтроки),"-","_");
	
	Если Элементы.Найти("Страница_" + ИмяТаблицы) = Неопределено Тогда
		
		ЭлементСтраница = Элементы.Добавить("Страница_" + ИмяТаблицы,Тип("ГруппаФормы"),Элементы.СтраницыИнформация);
		ЭлементСтраница.Вид = ВидГруппыФормы.Страница;
		
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяТаблицы,Новый ОписаниеТипов("ТаблицаЗначений")));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Формулировка_" + ИмяТаблицы,Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(150))));
	
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);

		Элемент = Элементы.Добавить("Формулировка_" + ИмяТаблицы,Тип("ПолеФормы"),ЭлементСтраница);
		Элемент.ПутьКДанным        = "Формулировка_" + ИмяТаблицы;
		Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		Элемент.Шрифт              = Новый Шрифт("MS Shell Dlg",10,Истина);
		
		Элемент = Элементы.Добавить(ИмяТаблицы,Тип("ТаблицаФормы"),ЭлементСтраница);
		Элемент.ТолькоПросмотр           = Истина;
		Элемент.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
		Элемент.ПутьКДанным              = ИмяТаблицы;
		
	КонецЕсли;
		
	Анкетирование.ОбновитьПревьюТабличныйВопрос(СоставТабличногоВопроса,ПредопределенныеОтветы,ТипТабличногоВопроса,ЭтаФорма,ИмяТаблицы,КлючСтроки);
	
КонецПроцедуры

//Устанавливает условное оформеление формы
&НаСервере
Процедура УстановитьУсловноеОформлениеФормы();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоАнкеты.ТипСтроки");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОтбораДанных.ПравоеЗначение = "Вопрос";
	
	ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеОформления.Использование = Истина;
	ПолеОформления.Поле          = Новый ПолеКомпоновкиДанных("ДеревоАнкетыОбязательный");
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона",WebЦвета.СеребристоСерый);
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьЕстьЛиДанномуШаблонуАнкеты()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Анкета.Ссылка
	|ИЗ
	|	Документ.Анкета КАК Анкета
	|ГДЕ
	|	(НЕ Анкета.ПометкаУдаления)
	|	И Анкета.Опрос В
	|			(ВЫБРАТЬ
	|				НазначениеОпросов.Ссылка
	|			ИЗ
	|				Документ.НазначениеОпросов КАК НазначениеОпросов
	|			ГДЕ
	|				НазначениеОпросов.ШаблонАнкеты = &ШаблонАнкеты)";
	
	Запрос.УстановитьПараметр("ШаблонАнкеты",Объект.Ссылка);
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		
		ПоДанномуШаблонуЕстьАнкеты = Истина;
		
	Иначе
		
		ПоДанномуШаблонуЕстьАнкеты = Ложь;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьРодителяДеревоАнкеты(ТекущийРодитель,МожетБытьКорнем,ТипВопроса = Неопределено)
	
	Если МожетБытьКорнем Тогда
		
		Пока (ТекущийРодитель.ТипСтроки <> "Корень") И (ТекущийРодитель.ТипСтроки <> "Раздел") Цикл
			ТекущийРодитель = ТекущийРодитель.ПолучитьРодителя();
			Если ТекущийРодитель = Неопределено Тогда
				Возврат ДеревоАнкеты.ПолучитьЭлементы()[0];
			КонецЕсли;
		КонецЦикла;
		
	Иначе 
		
		Пока (ТекущийРодитель.ТипСтроки <> "Раздел")
			И ((ТекущийРодитель.ТипСтроки = "Вопрос") И (НЕ ТекущийРодитель.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием"))
			ИЛИ (ТекущийРодитель.ТипСтроки = "Вопрос" И  ТекущийРодитель.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием") И ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием"))) Цикл
			
			ТекущийРодитель = ТекущийРодитель.ПолучитьРодителя();
			
		КонецЦикла
		
	КонецЕсли;
	
	Возврат ТекущийРодитель;
	
КонецФункции

// Добавляет вопрос в шаблон анкеты
//
// Параметры
//  ТекущиеДанные - ДанныеФормыЭлементДерева - данные текущей строки дерева
//  ТипВопроса    - Перечисления.ТипыВопросовШаблонаАнкет - тип добавляемого вопроса
//
&НаКлиенте
Процедура ДобавитьВопрос(ТекущиеДанные,ТипВопроса)

	Родитель = ПолучитьРодителяДеревоАнкеты(ТекущиеДанные,Ложь,ТипВопроса);
	Если Родитель.ТипСтроки = "Корень" Тогда
		Предупреждение(НСтр("ru = 'Вопросы нельзя добавлять в корень анкеты.'"),15,НСтр("ru = 'Ошибка добавления'"));
		Возврат;
	КонецЕсли;	
	ДобавитьСтрокуДеревоАнкеты(Родитель,"Вопрос",ТипВопроса);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюТабличныйВопрос(ТекущиеДанные)
	
	СтрокаКлюч   = СтрЗаменить(Строка(ТекущиеДанные.КлючСтроки),"-","_");
	ИмяТаблицы   = "ПревьюТабличногоВопроса_" + СтрокаКлюч;
	ИмяРеквизита = "Формулировка_" + ИмяТаблицы;
	Попытка
		ЭтаФорма[ИмяРеквизита] = СформироватьСтрокуФормулировкиДляПревью(ТекущиеДанные);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

// Формирует строку с представлением вопроса для отображения в страницах превью
//
// Параметры
//  ТекущиеДанные  - ДанныеФормыЭлементДерева - данные строки дерева
//
// Возвращаемое значение:
//   Строка   - возвращаемая строка
//
&НаКлиенте
Функция СформироватьСтрокуФормулировкиДляПревью(ТекущиеДанные)

	Возврат ТекущиеДанные.ПолныйКод + " " + ТекущиеДанные.Формулировка;

КонецФункции

&НаКлиенте
Процедура ОпределитьДоступностьДереваШаблона()
	
	НовыйЭлемент               = Объект.Ссылка.Пустая();
	НедоступностьРедактирования = (НовыйЭлемент Или Объект.РедактированиеШаблонаЗавершено ИЛИ ПоДанномуШаблонуЕстьАнкеты);
	
	Элементы.ДеревоАнкеты.ТолькоПросмотр                                    = НедоступностьРедактирования;
	Элементы.ФормаДереваАнкеты.ТолькоПросмотр                               = НедоступностьРедактирования;
	Элементы.ЗакончитьРедактирование.Доступность                            = НЕ НедоступностьРедактирования;
	Элементы.ФормаДереваАнкеты.КоманднаяПанель.Доступность                  = НЕ НедоступностьРедактирования;
	Элементы.ФормаДереваАнкеты.КонтекстноеМеню.Доступность                  = НЕ НедоступностьРедактирования;
	Элементы.КонтекстноеМенюФормаДереваАнкетыДобавить.Доступность           = НЕ НедоступностьРедактирования;
	Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьРаздел.Доступность          = НЕ НедоступностьРедактирования;
	Элементы.ДеревоАнкетыКонтекстноеМенюПереместитьВверх.Доступность        = НЕ НедоступностьРедактирования;
	Элементы.ДеревоАнкетыКонтекстноеМенюПереместитьВниз.Доступность         = НЕ НедоступностьРедактирования;
	Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьВопрос.Доступность          = НЕ НедоступностьРедактирования;
	Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьВопросСУсловием.Доступность = НЕ НедоступностьРедактирования;
	Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьТабличныйВопрос.Доступность = НЕ НедоступностьРедактирования;
	
	Если НовыйЭлемент Тогда
		ИнформацияДерево = НСтр("ru = 'Для редактирования вопросов необходимо записать шаблон анкеты'");
	Иначе
		ИнформацияДерево = НСтр("ru = 'Дерево редактирования вопросов шаблона анкеты'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНедоступностьРедактирования()
	
	Если Объект.РедактированиеШаблонаЗавершено ИЛИ ПоДанномуШаблонуЕстьАнкеты Тогда
		
		ЭтаФорма.ТолькоПросмотр                                                 = Истина;
		Элементы.ДеревоАнкеты.ТолькоПросмотр                                    = Истина;
		Элементы.ФормаДереваАнкеты.ТолькоПросмотр                               = Истина;
		Элементы.ФормаДереваАнкеты.КоманднаяПанель.Доступность                  = Ложь;
		Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьРаздел.Доступность          = Ложь;
		Элементы.ДеревоАнкетыКонтекстноеМенюПереместитьВверх.Доступность        = Ложь;
		Элементы.ДеревоАнкетыКонтекстноеМенюПереместитьВниз.Доступность         = Ложь;
		Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьВопрос.Доступность          = Ложь;
		Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьВопросСУсловием.Доступность = Ложь;
		Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьТабличныйВопрос.Доступность = Ложь;
		Элементы.ЗакончитьРедактирование.Доступность                            = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПростыхВопросов(ТекущиеДанные)
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("ТипСтрокиДерева",ТекущиеДанные.ТипСтроки);
	СтруктураПараметры.Вставить("ЭлементарныйВопрос",ТекущиеДанные.ЭлементарныйВопрос);
	СтруктураПараметры.Вставить("Обязательный",ТекущиеДанные.Обязательный);
	СтруктураПараметры.Вставить("ТипВопроса",ТекущиеДанные.ТипВопроса);
	СтруктураПараметры.Вставить("Формулировка",ТекущиеДанные.Формулировка);
	СтруктураПараметры.Вставить("ЗакрыватьПриВыборе",Истина);
	СтруктураПараметры.Вставить("ЗакрыватьПриЗакрытииВладельца",Истина);
	СтруктураПараметры.Вставить("ТолькоПросмотр",Ложь);
	СтруктураПараметры.Вставить("ВысотаЭлементаФормулировкиВопроса",ТекущиеДанные.ВысотаЭлементаФормулировкиВопроса);
	
	ОткрытьФорму("Справочник.ШаблоныАнкет.Форма.ФормаПростыхВопросов",СтруктураПараметры,ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуМастераТабличныхВопросов(ТекущиеДанные)
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("ТипТабличногоВопроса",ТекущиеДанные.ТипТабличногоВопроса);
	СтруктураПараметры.Вставить("СоставТабличногоВопроса",ТекущиеДанные.СоставТабличногоВопроса);
	СтруктураПараметры.Вставить("ПредопределенныеОтветы",ТекущиеДанные.ПредопределенныеОтветы);
	СтруктураПараметры.Вставить("Формулировка",ТекущиеДанные.Формулировка);
	
	ОткрытьФорму("Справочник.ШаблоныАнкет.Форма.ФормаМастераТабличныхВопросов",СтруктураПараметры,ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,ИспользоватьРодителяСтрокиНазначения = ЛОЖЬ,УдалятьПослеДобавления = Истина);
	
	Если ИспользоватьРодителяСтрокиНазначения Тогда
		НоваяСтрока = СтрокаНазначение.ПолучитьРодителя().ПолучитьЭлементы().Добавить();
	Иначе
		НоваяСтрока = СтрокаНазначение.ПолучитьЭлементы().Добавить();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаПеретаскивание,,"СоставТабличногоВопроса,ПредопределенныеОтветы");
	Если СтрокаПеретаскивание.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(СтрокаПеретаскивание.СоставТабличногоВопроса,НоваяСтрока.СоставТабличногоВопроса);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(СтрокаПеретаскивание.ПредопределенныеОтветы,НоваяСтрока.ПредопределенныеОтветы);
	КонецЕсли;
	
	Для каждого Элемент Из СтрокаПеретаскивание.ПолучитьЭлементы() Цикл
		ПеретащитьЭлементДерева(НоваяСтрока,Элемент,Ложь,Ложь);
	КонецЦикла;
	
	Если УдалятьПослеДобавления Тогда
		СтрокаПеретаскивание.ПолучитьРодителя().ПолучитьЭлементы().Удалить(СтрокаПеретаскивание);
	КонецЕсли;
	
	Если ИспользоватьРодителяСтрокиНазначения Тогда
		Элементы.ФормаДереваАнкеты.Развернуть(СтрокаНазначение.ПолучитьРодителя().ПолучитьИдентификатор(),Ложь);
	Иначе	
		Элементы.ФормаДереваАнкеты.Развернуть(СтрокаНазначение.ПолучитьИдентификатор(),Ложь);
	КонецЕсли;
	
КонецПроцедуры
