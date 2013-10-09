﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Свойства"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для стандартной обработки дополнительных реквизитов.

// Создает основные реквизиты и поля формы, необходимые для работы.
// Заполняет дополнительные реквизиты, если используются.
// Вызывается из обработчика ПриСозданииНаСервере формы объекта со свойствами
// 
// Параметры:
//  Форма       - УправляемаяФорма.
//
//  Объект      - Неопределено - взять объект из реквизита формы Объект.
//                ДанныеФормыСтруктура (по типу объекта).
//
//  ИмяЭлементаДляРазмещения - Строка - имя группы формы, в которой будут размещены свойства.
//
//  ПроизвольныйОбъект - Булево, если Истина, тогда в форме создается таблица описания дополнительных реквизитов
//                параметр Объект игнорируется, дополнительные реквизиты не создаются и не заполняются.
//
//                Это востребовано при последовательном использовании одной формы для просмотра или редактирования
//                дополнительных реквизитов разных объектов (в том числе разных типов).
//
//                После выполнения ПриСозданииНаСервере следует вызывать ЗаполнитьДополнительныеРеквизитыВФорме()
//                для добавления и заполнения дополнительных реквизитов.
//                Чтобы сохранить изменения следует вызвать ПеренестиЗначенияИзРеквизитовФормыВОбъект(),
//                а для обновления состава реквизитов вызвать ОбновитьЭлементыДополнительныхРеквизитов().
//
Процедура ПриСозданииНаСервере(Форма, Объект = Неопределено, ИмяЭлементаДляРазмещения = "", ПроизвольныйОбъект = Ложь) Экспорт
	
	Если ПроизвольныйОбъект Тогда
		СоздатьОписаниеДополнительныхРеквизитов = Истина;
	Иначе
		Если Объект = Неопределено Тогда
			ОписаниеОбъекта = Форма.Объект;
		Иначе
			ОписаниеОбъекта = Объект;
		КонецЕсли;
		СоздатьОписаниеДополнительныхРеквизитов = ИспользоватьДопРеквизиты(ОписаниеОбъекта.Ссылка);
	КонецЕсли;
	
	СоздатьОсновныеОбъектыФормы(Форма, ИмяЭлементаДляРазмещения, СоздатьОписаниеДополнительныхРеквизитов);
	
	Если НЕ ПроизвольныйОбъект Тогда
		ЗаполнитьДополнительныеРеквизитыВФорме(Форма, ОписаниеОбъекта);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет объект из реквизитов, созданных в форме.
// Вызывается из обработчика ПередЗаписьюНаСервере формы объекта со свойствами.
//
// Параметры:
//   Форма         - УправляемаяФорма.
//   ТекущийОбъект - <ВидОбъектаМетаданных>Объект.<ИмяОбъектаМетаданных>.
//
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	Структура = Новый Структура("Свойства_ИспользоватьСвойства");
	ЗаполнитьЗначенияСвойств(Структура, Форма);
	
	Если ТипЗнч(Структура.Свойства_ИспользоватьСвойства) = Тип("Булево") Тогда
		ЗаполнитьДополнительныеРеквизитыВФорме(Форма, ТекущийОбъект);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет объект из реквизитов, созданных в форме.
// Вызывается из обработчика ПередЗаписьюНаСервере формы объекта со свойствами.
//
// Параметры:
//  Форма         - УправляемаяФорма, предварительно настроенная в процедуре
//                  УправлениеСвойствами.ПриСозданииНаСервере()
//  
//  ТекущийОбъект - Объект.
//
Процедура ПередЗаписьюНаСервере(Форма, ТекущийОбъект) Экспорт
	
	ПеренестиЗначенияИзРеквизитовФормыВОбъект(Форма, ТекущийОбъект);
	
КонецПроцедуры

// Проверяет заполненность реквизитов обязательных для заполнения.
// 
// Параметры:
//  Форма         - УправляемаяФорма, предварительно настроенная в процедуре
//                  УправлениеСвойствами.ПриСозданииНаСервере().
//
//  Отказ                - параметр обработчика ОбработкаПроверкиЗаполненияНаСервере().
//  ПроверяемыеРеквизиты - параметр обработчика ОбработкаПроверкиЗаполненияНаСервере().
//
Процедура ОбработкаПроверкиЗаполнения(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	Если НЕ Форма.Свойства_ИспользоватьСвойства
	 ИЛИ НЕ Форма.Свойства_ИспользоватьДопРеквизиты Тогда
		
		Возврат;
	КонецЕсли;
	
	Ошибки = Неопределено;
	
	Для каждого Строка Из Форма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
		Если Строка.ЗаполнятьОбязательно Тогда
			Если НЕ ЗначениеЗаполнено(Форма[Строка.ИмяРеквизитаЗначение]) Тогда
				
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
					Строка.ИмяРеквизитаЗначение,
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Поле ""%1"" не заполнено.'"), Строка.Наименование));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

// Обновляет наборы дополнительных реквизитов и сведений для вида объектов со свойствами.
//  Используется при записи элементов справочников, которые являются видами объектов со свойствами.
//  Например, если есть справочник Сущности к которому применяется подсистема Свойства, для него создан
// справочник ВидыСущностей, то при записи элемента ВидыСущностей необходимо вызывать эту процедуру.
//
// Параметры:
//  ВидОбъекта                - Объект, запись которого выполняется.
//  ИмяОбъектаСоСвойствами    - Строка - имя объекта со свойствами вид которого записывается.
//  ИмяРеквизитаНабораСвойств - Строка - используется, когда наборов свойств несколько
//                              или используется имя основного набора отличное от "НаборСвойств".
//
Процедура ПередЗаписьюВидаОбъекта(ВидОбъекта,
                                  ИмяОбъектаСоСвойствами,
                                  ИмяРеквизитаНабораСвойств = "НаборСвойств") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборСвойств   = ВидОбъекта[ИмяРеквизитаНабораСвойств];
	РодительНабора = Справочники.НаборыДополнительныхРеквизитовИСведений[ИмяОбъектаСоСвойствами];
	
	Если ЗначениеЗаполнено(НаборСвойств) Тогда
		
		СтарыеСвойстваНабора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			НаборСвойств, "Наименование, Родитель, ПометкаУдаления");
		
		Если СтарыеСвойстваНабора.Наименование    = ВидОбъекта.Наименование
		   И СтарыеСвойстваНабора.ПометкаУдаления = ВидОбъекта.ПометкаУдаления
		   И СтарыеСвойстваНабора.Родитель        = РодительНабора Тогда
			
			Возврат;
		КонецЕсли;
		
		Если СтарыеСвойстваНабора.Родитель = РодительНабора Тогда
			ЗаблокироватьДанныеДляРедактирования(НаборСвойств);
			НаборСвойствОбъект = НаборСвойств.ПолучитьОбъект();
		Иначе
			НаборСвойствОбъект = НаборСвойств.Скопировать();
		КонецЕсли;
	Иначе
		НаборСвойствОбъект = Справочники.НаборыДополнительныхРеквизитовИСведений.СоздатьЭлемент();
	КонецЕсли;
	
	НаборСвойствОбъект.Наименование    = ВидОбъекта.Наименование;
	НаборСвойствОбъект.ПометкаУдаления = ВидОбъекта.ПометкаУдаления;
	НаборСвойствОбъект.Родитель        = РодительНабора;
	НаборСвойствОбъект.Записать();
	
	ВидОбъекта[ИмяРеквизитаНабораСвойств] = НаборСвойствОбъект.Ссылка;
	
КонецПроцедуры

// Обновляет отображаемые данные на форме объекта со свойствами.
// 
// Параметры:
//  Форма        - УправляемаяФорма, предварительно настроенная в процедуре
//                 УправлениеСвойствами.ПриСозданииНаСервере()
//  
//  Объект       - Неопределено - взять объект из реквизита формы Объект.
//                 Объект - СправочникОбъект, ДокументОбъект, ...
//                 ДанныеФормыСтруктура (по типу объекта).
//
Процедура ОбновитьЭлементыДополнительныхРеквизитов(Форма, Объект = Неопределено) Экспорт
	
	ПеренестиЗначенияИзРеквизитовФормыВОбъект(Форма, Объект);
	
	ЗаполнитьДополнительныеРеквизитыВФорме(Форма, Объект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для нестандартной обработки дополнительных свойств.

// Создает/пересоздает дополнительные реквизиты и элементы в форме владельца свойств.
//
// Параметры:
//  Форма        - УправляемаяФорма, предварительно настроенная в процедуре
//                 УправлениеСвойствами.ПриСозданииНаСервере()
//  
//  Объект       - Неопределено - взять объект из реквизита формы Объект.
//                 Объект - СправочникОбъект, ДокументОбъект, ...
//                 ДанныеФормыСтруктура (по типу объекта).
//
Процедура ЗаполнитьДополнительныеРеквизитыВФорме(Форма, Объект = Неопределено) Экспорт
	
	Если НЕ Форма.Свойства_ИспользоватьСвойства
	 ИЛИ НЕ Форма.Свойства_ИспользоватьДопРеквизиты Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект = Неопределено Тогда
		ОписаниеОбъекта = Форма.Объект;
	Иначе
		ОписаниеОбъекта = Объект;
	КонецЕсли;
	
	Форма.Свойства_НаборыДополнительныхРеквизитовОбъекта = Новый СписокЗначений;
	
	НаборыСвойствОбъекта = УправлениеСвойствамиСлужебный.ПолучитьНаборыСвойствОбъекта(
		ОписаниеОбъекта);
	
	Для каждого Строка Из НаборыСвойствОбъекта Цикл
		Если УправлениеСвойствамиСлужебный.ВидыСвойствНабора(Строка.Набор).ДополнительныеРеквизиты Тогда
			
			Форма.Свойства_НаборыДополнительныхРеквизитовОбъекта.Добавить(
				Строка.Набор, Строка.Заголовок);
		КонецЕсли;
	КонецЦикла;
	
	ОписаниеСвойств = УправлениеСвойствамиСлужебный.ПолучитьТаблицуЗначенийСвойств(
		ОписаниеОбъекта.ДополнительныеРеквизиты.Выгрузить(),
		Форма.Свойства_НаборыДополнительныхРеквизитовОбъекта,
		Ложь);
	
	ОписаниеСвойств.Колонки.Добавить("ИмяРеквизитаЗначение");
	ОписаниеСвойств.Колонки.Добавить("ИмяРеквизитаСвойство");
	ОписаниеСвойств.Колонки.Добавить("ИмяУникальнаяЧасть");
	ОписаниеСвойств.Колонки.Добавить("Булево");
	
	УдалитьСтарыеРеквизитыИЭлементы(Форма);
	
	// Создание реквизитов.
	ДобавляемыеРеквизиты = Новый Массив();
	Для каждого ОписаниеСвойства Из ОписаниеСвойств Цикл
		
		ТипЗначенияСвойства = ОписаниеСвойства.ТипЗначения;
		
		// Поддержка строк неограниченной длины.
		ИспользоватьНеограниченнуюСтроку = УправлениеСвойствамиСлужебный.ИспользоватьНеограниченнуюСтроку(
			ТипЗначенияСвойства, ОписаниеСвойства.МногострочноеПолеВвода);
		
		Если ИспользоватьНеограниченнуюСтроку Тогда
			ТипЗначенияСвойства = Новый ОписаниеТипов("Строка");
		КонецЕсли;
		
		ОписаниеСвойства.ИмяУникальнаяЧасть = 
			СтрЗаменить(ВРег(Строка(ОписаниеСвойства.Набор.УникальныйИдентификатор())), "-", "x")
			+ "_"
			+ СтрЗаменить(ВРег(Строка(ОписаниеСвойства.Свойство.УникальныйИдентификатор())), "-", "x");
		
		ОписаниеСвойства.ИмяРеквизитаЗначение =
			"ДополнительныйРеквизитЗначение_" + ОписаниеСвойства.ИмяУникальнаяЧасть;
		
		Если ОписаниеСвойства.Удалено Тогда
			ТипЗначенияСвойства = Новый ОписаниеТипов("Строка");
		КонецЕсли;
		
		Реквизит = Новый РеквизитФормы(ОписаниеСвойства.ИмяРеквизитаЗначение, ТипЗначенияСвойства, , ОписаниеСвойства.Наименование, Истина);
		
		ДобавляемыеРеквизиты.Добавить(Реквизит);
		
		ОписаниеСвойства.ИмяРеквизитаСвойство = "";
		Если УправлениеСвойствамиСлужебный.ТипЗначенияСодержитЗначенияСвойств(ТипЗначенияСвойства) Тогда
			
			ОписаниеСвойства.ИмяРеквизитаСвойство =
				"ДополнительныйРеквизитСвойство_" + ОписаниеСвойства.ИмяУникальнаяЧасть;
			
			Реквизит = Новый РеквизитФормы(ОписаниеСвойства.ИмяРеквизитаСвойство, Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения"), , , Истина);
			ДобавляемыеРеквизиты.Добавить(Реквизит);
		КонецЕсли;
		
		ОписаниеСвойства.Булево = ОбщегоНазначения.ОписаниеТипаСостоитИзТипа(ТипЗначенияСвойства, Тип("Булево"));
		
	КонецЦикла;
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	// Создание элементов формы.
	ИмяЭлементаДляРазмещения = Форма.Свойства_ИмяЭлементаДляРазмещения;
	ЭлементРазмещения = ?(ИмяЭлементаДляРазмещения = "", Неопределено, Форма.Элементы[ИмяЭлементаДляРазмещения]);
	
	Для Каждого ОписаниеСвойства Из ОписаниеСвойств Цикл
		
		ЗаполнитьЗначенияСвойств(
			Форма.Свойства_ОписаниеДополнительныхРеквизитов.Добавить(), ОписаниеСвойства);
		
		Форма[ОписаниеСвойства.ИмяРеквизитаЗначение] = ОписаниеСвойства.Значение;
		
		Если НаборыСвойствОбъекта.Количество() > 1 Тогда
			
			ЭлементСписка = Форма.Свойства_ЭлементыГруппДополнительныхРеквизитов.НайтиПоЗначению(
				ОписаниеСвойства.Набор);
			
			Если ЭлементСписка <> Неопределено Тогда
				Родитель = Форма.Элементы[ЭлементСписка.Представление];
			Иначе
				ОписаниеНабора = НаборыСвойствОбъекта.Найти(ОписаниеСвойства.Набор, "Набор");
				
				Если ОписаниеНабора = Неопределено Тогда
					ОписаниеНабора = НаборыСвойствОбъекта.Добавить();
					ОписаниеНабора.Набор     = ОписаниеСвойства.Набор;
					ОписаниеНабора.Заголовок = НСтр("ru = 'Удаленные реквизиты'")
				КонецЕсли;
				
				Если НЕ ЗначениеЗаполнено(ОписаниеНабора.Заголовок) Тогда
					ОписаниеНабора.Заголовок = Строка(ОписаниеСвойства.Набор);
				КонецЕсли;
				
				ИмяЭлементаНабора = "НаборДополнительныхРеквизитов" + ОписаниеСвойства.ИмяУникальнаяЧасть;
				
				Родитель = Форма.Элементы.Добавить(ИмяЭлементаНабора, Тип("ГруппаФормы"), ЭлементРазмещения);
				
				Форма.Свойства_ЭлементыГруппДополнительныхРеквизитов.Добавить(
					ОписаниеСвойства.Набор, Родитель.Имя);
				
				Если ТипЗнч(ЭлементРазмещения) = Тип("ГруппаФормы")
				   И ЭлементРазмещения.Вид = ВидГруппыФормы.Страницы Тогда
					
					Родитель.Вид = ВидГруппыФормы.Страница;
				Иначе
					Родитель.Вид = ВидГруппыФормы.ОбычнаяГруппа;
					Родитель.Отображение = ОтображениеОбычнойГруппы.Нет;
				КонецЕсли;
				Родитель.ОтображатьЗаголовок = Ложь;
				
				ЗаполненныеСвойстваГруппы = Новый Структура;
				Для каждого Колонка Из НаборыСвойствОбъекта.Колонки Цикл
					Если ОписаниеНабора[Колонка.Имя] <> Неопределено Тогда
						ЗаполненныеСвойстваГруппы.Вставить(Колонка.Имя, ОписаниеНабора[Колонка.Имя]);
					КонецЕсли;
				КонецЦикла;
				ЗаполнитьЗначенияСвойств(Родитель, ЗаполненныеСвойстваГруппы);
			КонецЕсли;
		Иначе
			Родитель = ЭлементРазмещения;
		КонецЕсли;
		
		Элемент = Форма.Элементы.Добавить(ОписаниеСвойства.ИмяРеквизитаЗначение, Тип("ПолеФормы"), Родитель);
		
		Если ОписаниеСвойства.Булево И ПустаяСтрока(ОписаниеСвойства.ФорматСвойства) Тогда
			Элемент.Вид = ВидПоляФормы.ПолеФлажка
		Иначе
			Элемент.Вид = ВидПоляФормы.ПолеВвода;
			Элемент.АвтоОтметкаНезаполненного = ОписаниеСвойства.ЗаполнятьОбязательно;
		КонецЕсли;
		
		Элемент.ПутьКДанным = ОписаниеСвойства.ИмяРеквизитаЗначение;
		Элемент.Подсказка   = ОписаниеСвойства.Свойство.Подсказка;
		
		Если ОписаниеСвойства.Свойство.МногострочноеПолеВвода > 0 Тогда
			Элемент.МногострочныйРежим = Истина;
			Элемент.Высота= ОписаниеСвойства.Свойство.МногострочноеПолеВвода;
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(ОписаниеСвойства.ФорматСвойства) Тогда
			Элемент.Формат               = ОписаниеСвойства.ФорматСвойства;
			Элемент.ФорматРедактирования = ОписаниеСвойства.ФорматСвойства;
		КонецЕсли;
		
		Если ОписаниеСвойства.Удалено Тогда
			Элемент.ЦветТекстаЗаголовка = ЦветаСтиля.НедоступныеДанныеЦвет;
			Элемент.ШрифтЗаголовка = ШрифтыСтиля.УдаленныйДополнительныйРеквизитШрифт;
			Если Элемент.Вид = ВидПоляФормы.ПолеВвода Тогда
				Элемент.КнопкаОчистки = Истина;
				Элемент.КнопкаВыбора = Ложь;
				Элемент.КнопкаОткрытия = Ложь;
				Элемент.КнопкаСпискаВыбора = Ложь;
				Элемент.РедактированиеТекста = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Если ОписаниеСвойства.ИмяРеквизитаСвойство <> "" Тогда
			Связь = Новый СвязьПараметраВыбора("Отбор.Владелец", ОписаниеСвойства.ИмяРеквизитаСвойство);
			Связи = Новый Массив;
			Связи.Добавить(Связь);
			Элемент.СвязиПараметровВыбора = Новый ФиксированныйМассив(Связи);
			Форма[ОписаниеСвойства.ИмяРеквизитаСвойство] = ОписаниеСвойства.Свойство;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Переносит значения свойств из реквизитов формы в табличную часть объекта.
// 
// Параметры:
//  Форма        - УправляемаяФорма, предварительно настроенная в процедуре
//                 УправлениеСвойствами.ПриСозданииНаСервере()
//  
//  Объект       - Неопределено - взять объект из реквизита формы Объект.
//                 Объект - СправочникОбъект, ДокументОбъект, ...
//                 ДанныеФормыСтруктура (по типу объекта).
//
Процедура ПеренестиЗначенияИзРеквизитовФормыВОбъект(Форма, Объект = Неопределено) Экспорт
	
	Если НЕ Форма.Свойства_ИспользоватьСвойства
	 ИЛИ НЕ Форма.Свойства_ИспользоватьДопРеквизиты Тогда
		
		Возврат;
	КонецЕсли;
	
	Если Объект = Неопределено Тогда
		ОписаниеОбъекта = Форма.Объект;
	Иначе
		ОписаниеОбъекта = Объект;
	КонецЕсли;
	
	СтарыеЗначения = ОписаниеОбъекта.ДополнительныеРеквизиты.Выгрузить();
	ОписаниеОбъекта.ДополнительныеРеквизиты.Очистить();
	
	Для каждого Строка Из Форма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
		
		Значение = Форма[Строка.ИмяРеквизитаЗначение];
		
		Если ЗначениеЗаполнено(Значение) Тогда
			Если ТипЗнч(Значение) = Тип("Булево") И Значение = Ложь Тогда
				Продолжить;
			КонецЕсли;
			
			Если Строка.Удалено Тогда
				ЗаполнитьЗначенияСвойств(
					ОписаниеОбъекта.ДополнительныеРеквизиты.Добавить(),
					СтарыеЗначения.Найти(Строка.Свойство, "Свойство"));
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ОписаниеОбъекта.ДополнительныеРеквизиты.Добавить();
			НоваяСтрока.Свойство = Строка.Свойство;
			НоваяСтрока.Значение = Значение;
			
			// Поддержка строк неограниченной длины.
			Свойство = Строка.Свойство.ПолучитьОбъект();
			
			ИспользоватьНеограниченнуюСтроку = УправлениеСвойствамиСлужебный.ИспользоватьНеограниченнуюСтроку(
				Свойство.ТипЗначения, Свойство.МногострочноеПолеВвода);
			
			Если ИспользоватьНеограниченнуюСтроку Тогда
				НоваяСтрока.ТекстоваяСтрока = Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Удаляет старые реквизиты и элементы формы.
// 
// Параметры:
//  Форма        - УправляемаяФорма, предварительно настроенная в процедуре
//                 УправлениеСвойствами.ПриСозданииНаСервере()
//  
Процедура УдалитьСтарыеРеквизитыИЭлементы(Форма) Экспорт
	
	УдаляемыеРеквизиты = Новый Массив;
	Для каждого ОписаниеСвойства Из Форма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
		
		УдаляемыеРеквизиты.Добавить(ОписаниеСвойства.ИмяРеквизитаЗначение);
		Если Не ПустаяСтрока(ОписаниеСвойства.ИмяРеквизитаСвойство) Тогда
			УдаляемыеРеквизиты.Добавить(ОписаниеСвойства.ИмяРеквизитаСвойство);
		КонецЕсли;
		
		Форма.Элементы.Удалить(Форма.Элементы[ОписаниеСвойства.ИмяРеквизитаЗначение]);
		
	КонецЦикла;
	
	Если УдаляемыеРеквизиты.Количество() > 0 Тогда
		Форма.ИзменитьРеквизиты(, УдаляемыеРеквизиты);
	КонецЕсли;
	
	Для каждого ЭлементСписка Из Форма.Свойства_ЭлементыГруппДополнительныхРеквизитов Цикл
		Форма.Элементы.Удалить(Форма.Элементы[ЭлементСписка.Представление]);
	КонецЦикла;
	
	Форма.Свойства_ОписаниеДополнительныхРеквизитов.Очистить();
	Форма.Свойства_ЭлементыГруппДополнительныхРеквизитов.Очистить();
	
КонецПроцедуры

// Возвращает свойства владельца.
//
// Параметры:
//  ВладелецСвойств      - Ссылка на владельца свойств.
//  ПолучатьДопРеквизиты - Булево - в результат включать дополнительные реквизиты.
//  ПолучатьДопСведения  - Булево - в результат включать дополнительные сведения.
//
// Возвращаемое значение:
//  Массив значений типа ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения.
//
Функция ПолучитьСписокСвойств(ВладелецСвойств, ПолучатьДопРеквизиты = Истина, ПолучатьДопСведения = Истина) Экспорт
	
	Если НЕ (ПолучатьДопРеквизиты ИЛИ ПолучатьДопСведения) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	НаборыСвойствОбъекта = УправлениеСвойствамиСлужебный.ПолучитьНаборыСвойствОбъекта(
		ВладелецСвойств);
	
	МассивНаборовСвойствОбъекта = НаборыСвойствОбъекта.ВыгрузитьКолонку("Набор");
	
	ТекстЗапросаДопРеквизиты = 
		"ВЫБРАТЬ
		|	ТаблицаСвойств.Свойство КАК Свойство
		|ИЗ
		|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК ТаблицаСвойств
		|ГДЕ
		|	ТаблицаСвойств.Ссылка В (&МассивНаборовСвойствОбъекта)";
	
	ТекстЗапросаДопСведения = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаСвойств.Свойство КАК Свойство
		|ИЗ
		|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеСведения КАК ТаблицаСвойств
		|ГДЕ
		|	ТаблицаСвойств.Ссылка В (&МассивНаборовСвойствОбъекта)";
	
	Запрос = Новый Запрос;
	
	Если ПолучатьДопРеквизиты И ПолучатьДопСведения Тогда
		Запрос.Текст = ТекстЗапросаДопСведения +
		"
		| ОБЪЕДИНИТЬ ВСЕ
		|" + ТекстЗапросаДопРеквизиты;
		
	ИначеЕсли ПолучатьДопРеквизиты Тогда
		Запрос.Текст = ТекстЗапросаДопРеквизиты;
		
	ИначеЕсли ПолучатьДопСведения Тогда
		Запрос.Текст = ТекстЗапросаДопСведения;
	КонецЕсли;
	
	Запрос.Параметры.Вставить("МассивНаборовСвойствОбъекта", МассивНаборовСвойствОбъекта);
	
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Свойство");
	
	Возврат Результат;
	
КонецФункции

// Возвращает значения дополнительных свойств объекта.
//
// Параметры:
//  ВладелецСвойств      - Ссылка на владельца свойств.
//  ПолучатьДопРеквизиты - Булево - в результат включать дополнительные реквизиты.
//  ПолучатьДопСведения  - Булево - в результат включать дополнительные сведения.
//  МассивСвойств        - Массив значений типа ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения,
//                         значения которых следует получить.
//                         Неопределено - все свойства владельца.
// Возвращаемое значение :
//   ТаблицаЗначений - колонки "Свойство" и "Значение".
//
Функция ПолучитьЗначенияСвойств(ВладелецСвойств,
                                ПолучатьДопРеквизиты = Истина,
                                ПолучатьДопСведения = Истина,
                                МассивСвойств = Неопределено) Экспорт
	
	Если МассивСвойств = Неопределено Тогда
		МассивСвойств = ПолучитьСписокСвойств(ВладелецСвойств, ПолучатьДопРеквизиты, ПолучатьДопСведения);
	КонецЕсли;
	
	ИмяОбъектаСоСвойствами = ОбщегоНазначения.ИмяТаблицыПоСсылке(ВладелецСвойств);
	
	ТекстЗапросаДопРеквизиты =
		"ВЫБРАТЬ [РАЗРЕШЕННЫЕ]
		|	ТаблицаСвойств.Свойство КАК Свойство,
		|	ТаблицаСвойств.Значение КАК Значение,
		|	ВЫБОР
		|		КОГДА ДополнительныеРеквизитыИСведения.МногострочноеПолеВвода > 0
		|			ТОГДА ТаблицаСвойств.ТекстоваяСтрока
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК ТекстоваяСтрока
		|ИЗ
		|	[ИмяОбъектаСоСвойствами].ДополнительныеРеквизиты КАК ТаблицаСвойств
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК ДополнительныеРеквизитыИСведения
		|		ПО ТаблицаСвойств.Свойство = ДополнительныеРеквизитыИСведения.Ссылка
		|ГДЕ
		|	ТаблицаСвойств.Ссылка = &ВладелецСвойств
		|	И ТаблицаСвойств.Свойство В (&МассивСвойств)";
	
	ТекстЗапросаДопСведения =
		"ВЫБРАТЬ [РАЗРЕШЕННЫЕ]
		|	ТаблицаСвойств.Свойство КАК Свойство,
		|	ТаблицаСвойств.Значение КАК Значение,
		|	"""" КАК ТекстоваяСтрока
		|ИЗ
		|	РегистрСведений.ДополнительныеСведения КАК ТаблицаСвойств
		|ГДЕ
		|	ТаблицаСвойств.Объект = &ВладелецСвойств
		|	И ТаблицаСвойств.Свойство В (&МассивСвойств)";
	
	Запрос = Новый Запрос;
	
	Если ПолучатьДопРеквизиты И ПолучатьДопСведения Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапросаДопРеквизиты, "[РАЗРЕШЕННЫЕ]", "РАЗРЕШЕННЫЕ") +
			"
			| ОБЪЕДИНИТЬ ВСЕ
			|" + СтрЗаменить(ТекстЗапросаДопСведения, "[РАЗРЕШЕННЫЕ]", "");
		
	ИначеЕсли ПолучатьДопРеквизиты Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапросаДопРеквизиты, "[РАЗРЕШЕННЫЕ]", "РАЗРЕШЕННЫЕ");
		
	ИначеЕсли ПолучатьДопСведения Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапросаДопСведения, "[РАЗРЕШЕННЫЕ]", "РАЗРЕШЕННЫЕ");
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяОбъектаСоСвойствами]", ИмяОбъектаСоСвойствами);
	
	Запрос.Параметры.Вставить("ВладелецСвойств", ВладелецСвойств);
	Запрос.Параметры.Вставить("МассивСвойств", МассивСвойств);
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить().Выгрузить();
	РезультатСТекстовымиСтроками = Неопределено;
	ИндексСтроки = 0;
	Для каждого ЗначениеСвойства Из Результат Цикл
		ТекстоваяСтрока = ЗначениеСвойства.ТекстоваяСтрока;
		Если Не ПустаяСтрока(ТекстоваяСтрока) Тогда
			Если РезультатСТекстовымиСтроками = Неопределено Тогда
				РезультатСТекстовымиСтроками = Результат.Скопировать(,"Свойство");
				РезультатСТекстовымиСтроками.Колонки.Добавить("Значение");
				РезультатСТекстовымиСтроками.ЗагрузитьКолонку(Результат.ВыгрузитьКолонку("Значение"), "Значение");
			КонецЕсли;
			РезультатСТекстовымиСтроками[ИндексСтроки].Значение = ТекстоваяСтрока;
		КонецЕсли;
		ИндексСтроки = ИндексСтроки + 1;
	КонецЦикла;
	
	Возврат ?(РезультатСТекстовымиСтроками <> Неопределено, РезультатСТекстовымиСтроками, Результат);
	
КонецФункции

// Проверяет, есть ли у объекта свойство.
//
// Параметры:
//  ВладелецСвойств - Ссылка на владельца свойств.
//  Свойство        - ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения.
//
Функция ПроверитьСвойствоУОбъекта(ВладелецСвойств, Свойство) Экспорт
	
	МассивСвойств = ПолучитьСписокСвойств(ВладелецСвойств);
	
	Если МассивСвойств.Найти(Свойство) = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Возвращает перечисляемые значения указанного свойства.
//
// Параметр:
//  Свойство - ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения.
// 
// Возвращаемое значение:
//  Массив значений типа СправочникСсылка.ЗначенияСвойствОбъектов
//              или типа СправочникСсылка.ЗначенияСвойствОбъектовИерархия.
//
Функция ПолучитьСписокЗначенийСвойств(Свойство) Экспорт
	
	ТипЗначения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Свойство, "ТипЗначения");
	
	Если ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия")) Тогда
		ТексЗапроса =
		"ВЫБРАТЬ
		|	Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ЗначенияСвойствОбъектовИерархия КАК ЗначенияСвойствОбъектов
		|ГДЕ
		|	ЗначенияСвойствОбъектов.Владелец = &Свойство";
	Иначе
		ТексЗапроса =
		"ВЫБРАТЬ
		|	Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|ГДЕ
		|	ЗначенияСвойствОбъектов.Владелец = &Свойство";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТексЗапроса;
	Запрос.Параметры.Вставить("Свойство", Свойство);
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат Результат;
	
КонецФункции

// Записывает дополнительные реквизиты и сведения владельцу свойств.
// Изменения происходят в транзакции.
// 
// Параметры:
//  ВладелецСвойств         - Ссылка или Объект владельца свойств.
//  ТаблицаСвойствИЗначений - ТаблицаЗначений - с колонками:
//                              Свойство - ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения.
//                              Значение - любое значение, допустимое для свойства.
//
Процедура ЗаписатьСвойстваУОбъекта(ВладелецСвойств, ТаблицаСвойствИЗначений) Экспорт
	
	ТаблицаДопРеквизитов = Новый ТаблицаЗначений;
	ТаблицаДопРеквизитов.Колонки.Добавить("Свойство", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения"));
	ТаблицаДопРеквизитов.Колонки.Добавить("Значение");
	
	ТаблицаДопСведений = ТаблицаДопРеквизитов.СкопироватьКолонки();
	
	Для Каждого СтрокаТаблицыСвойств Из ТаблицаСвойствИЗначений Цикл
		Если СтрокаТаблицыСвойств.Свойство.ЭтоДополнительноеСведение Тогда
			НоваяСтрока = ТаблицаДопСведений.Добавить();
		Иначе
			НоваяСтрока = ТаблицаДопРеквизитов.Добавить();
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицыСвойств, "Свойство,Значение");
	КонецЦикла;
	
	ЕстьДопРеквизиты = ТаблицаДопРеквизитов.Количество() > 0;
	ЕстьДопСведения  = ТаблицаДопСведений.Количество() > 0;
	
	МассивСвойств = ПолучитьСписокСвойств(ВладелецСвойств);
	
	МассивДопРеквизитов = Новый Массив;
	МассивДопСведений = Новый Массив;
	
	Для Каждого ДопСвойство Из МассивСвойств Цикл
		Если ДопСвойство.ЭтоДополнительноеСведение Тогда
			МассивДопСведений.Добавить(ДопСвойство);
		Иначе
			МассивДопРеквизитов.Добавить(ДопСвойство);
		КонецЕсли;
	КонецЦикла;
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
	Если ЕстьДопРеквизиты Тогда
		ВладелецСвойствОбъект = ВладелецСвойств.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(ВладелецСвойствОбъект.Ссылка);
		Для Каждого ДопРеквизит Из ТаблицаДопРеквизитов Цикл
			Если МассивДопРеквизитов.Найти(ДопРеквизит.Свойство) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			МассивСтрок = ВладелецСвойствОбъект.ДополнительныеРеквизиты.НайтиСтроки(Новый Структура("Свойство", ДопРеквизит.Свойство));
			Если МассивСтрок.Количество() Тогда
				СтрокаСвойства = МассивСтрок[0];
			Иначе
				СтрокаСвойства = ВладелецСвойствОбъект.ДополнительныеРеквизиты.Добавить();
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(СтрокаСвойства, ДопРеквизит, "Свойство,Значение");
		КонецЦикла;
		ВладелецСвойствОбъект.Записать();
	КонецЕсли;
	
	Если ЕстьДопСведения Тогда
		Для Каждого ДопСведение Из ТаблицаДопСведений Цикл
			Если МассивДопСведений.Найти(ДопСведение.Свойство) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			МенеджерЗаписи = РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();
			
			МенеджерЗаписи.Объект = ВладелецСвойств;
			МенеджерЗаписи.Свойство = ДопСведение.Свойство;
			МенеджерЗаписи.Значение = ДопСведение.Значение;
			
			МенеджерЗаписи.Записать(Истина);
		КонецЦикла;
		
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

// Проверяет, используется ли дополнительные реквизиты с объектом.
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользоватьДопРеквизиты(ВладелецСвойств) Экспорт
	
	Возврат ВладелецСвойств.Метаданные().ТабличныеЧасти.Найти("ДополнительныеРеквизиты") <> Неопределено;
	
КонецФункции

// Проверяет, используется ли дополнительные сведения объектом.
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользоватьДопСведения(ВладелецСвойств) Экспорт
	
	Возврат Метаданные.НайтиПоПолномуИмени("ОбщаяКоманда.ДополнительныеСведенияКоманднаяПанель") <> Неопределено
	      И Метаданные.ОбщиеКоманды.ДополнительныеСведенияКоманднаяПанель.ТипПараметраКоманды.Типы().Найти(ТипЗнч(ВладелецСвойств)) <> Неопределено
	    ИЛИ Метаданные.НайтиПоПолномуИмени("ОбщаяКоманда.ДополнительныеСведенияПанельНавигации") <> Неопределено
	      И Метаданные.ОбщиеКоманды.ДополнительныеСведенияПанельНавигации.ТипПараметраКоманды.Типы().Найти(ТипЗнч(ВладелецСвойств)) <> Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

// Создает основные реквизиты, команды, элементы в форме владельца свойств.
Процедура СоздатьОсновныеОбъектыФормы(Форма, ИмяЭлементаДляРазмещения, СоздатьОписаниеДополнительныхРеквизитов)
	
	Реквизиты = Новый Массив;
	
	// Проверка значения функциональной опции "Использование свойств".
	ОпцияИспользоватьСвойства = Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьДополнительныеРеквизитыИСведения");
	РеквизитИспользоватьСвойства = Новый РеквизитФормы("Свойства_ИспользоватьСвойства", Новый ОписаниеТипов("Булево"));
	Реквизиты.Добавить(РеквизитИспользоватьСвойства);
	
	Если ОпцияИспользоватьСвойства Тогда
		
		РеквизитИспользоватьДопРеквизиты = Новый РеквизитФормы("Свойства_ИспользоватьДопРеквизиты", Новый ОписаниеТипов("Булево"));
		Реквизиты.Добавить(РеквизитИспользоватьДопРеквизиты);
		
		Если СоздатьОписаниеДополнительныхРеквизитов Тогда
			
			// Добавление реквизита содержащего используемые наборы дополнительных реквизитов.
			Реквизиты.Добавить(Новый РеквизитФормы(
				"Свойства_НаборыДополнительныхРеквизитовОбъекта", Новый ОписаниеТипов("СписокЗначений")));
			
			// Добавление реквизита описания создаваемых реквизитов и элементов формы.
			ИмяОписания = "Свойства_ОписаниеДополнительныхРеквизитов";
			
			Реквизиты.Добавить(Новый РеквизитФормы(
				ИмяОписания, Новый ОписаниеТипов("ТаблицаЗначений")));
			
			Реквизиты.Добавить(Новый РеквизитФормы(
				"ИмяРеквизитаЗначение", Новый ОписаниеТипов("Строка"), ИмяОписания));
			
			Реквизиты.Добавить(Новый РеквизитФормы(
				"ИмяРеквизитаСвойство", Новый ОписаниеТипов("Строка"), ИмяОписания));
				
			Реквизиты.Добавить(Новый РеквизитФормы(
				"Свойство", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения"),
					ИмяОписания));
			
			Реквизиты.Добавить(Новый РеквизитФормы(
				"Удалено", Новый ОписаниеТипов("Булево"), ИмяОписания));
			
			Реквизиты.Добавить(Новый РеквизитФормы(
				"ЗаполнятьОбязательно", Новый ОписаниеТипов("Булево"), ИмяОписания));
				
			Реквизиты.Добавить(Новый РеквизитФормы(
				"Наименование", Новый ОписаниеТипов("Строка"), ИмяОписания));
			
			// Добавление реквизита содержащего элементы создаваемых групп дополнительных реквизитов.
			Реквизиты.Добавить(Новый РеквизитФормы(
				"Свойства_ЭлементыГруппДополнительныхРеквизитов", Новый ОписаниеТипов("СписокЗначений")));
			
			// Добавление реквизита с именем элемента в котором будут размещаться поля ввода.
			Реквизиты.Добавить(Новый РеквизитФормы(
				"Свойства_ИмяЭлементаДляРазмещения", Новый ОписаниеТипов("Строка")));
			
			// Добавление команды формы, если установлена роль "ДобавлениеИзменениеБазовойНСИ" или это полноправный пользователь.
			Если Пользователи.РолиДоступны("ДобавлениеИзменениеБазовойНСИ") Тогда
				// Добавление команды.
				Команда = Форма.Команды.Добавить("РедактироватьСоставДополнительныхРеквизитов");
				Команда.Заголовок = НСтр("ru = 'Изменить состав дополнительных реквизитов'");
				Команда.Действие = "Подключаемый_РедактироватьСоставСвойств";
				Команда.Подсказка = НСтр("ru = 'Изменить состав дополнительных реквизитов'");
				Команда.Картинка = БиблиотекаКартинок.НастройкаСписка;
				
				Кнопка = Форма.Элементы.Добавить("РедактироватьСоставДополнительныхРеквизитов", Тип("КнопкаФормы"), Форма.КоманднаяПанель);
				Кнопка.ТолькоВоВсехДействиях = Истина;
				Кнопка.ИмяКоманды = "РедактироватьСоставДополнительныхРеквизитов";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Форма.ИзменитьРеквизиты(Реквизиты);
	
	Форма.Свойства_ИспользоватьСвойства = ОпцияИспользоватьСвойства;
	
	Если ОпцияИспользоватьСвойства Тогда
		Форма.Свойства_ИспользоватьДопРеквизиты = СоздатьОписаниеДополнительныхРеквизитов;
	КонецЕсли;
	
	Если ОпцияИспользоватьСвойства И СоздатьОписаниеДополнительныхРеквизитов Тогда
		Форма.Свойства_ИмяЭлементаДляРазмещения = ИмяЭлементаДляРазмещения;
	КонецЕсли;
	
КонецПроцедуры
