﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если НЕ ЭтоГруппа Тогда
		Дата = ТекущаяДата();
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("Спецификация") Тогда
		
		Спецификация = ДанныеЗаполнения.Спецификация;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	МассивПараметровДвери = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаДляРасчета, "☺");
	ЗаполнитьТЧ(МассивПараметровДвери[0], МассивПараметровДвери[1], МассивПараметровДвери[2], Число(МассивПараметровДвери[3]), Число(МассивПараметровДвери[4]), Отказ);
	
	Для Каждого Строка Из СписокНоменклатуры Цикл
		Если ЗначениеЗаполнено(Строка.Ширина) И НЕ ЗначениеЗаполнено(Строка.Длина) Тогда
			
			Строка.КоличествоСОтходом = (Строка.Ширина / 1000) * Строка.Количество;
			
		ИначеЕсли ЗначениеЗаполнено(Строка.Ширина) И ЗначениеЗаполнено(Строка.Длина) Тогда
			
			Строка.КоличествоСОтходом = ((Строка.Ширина * Строка.Длина) / 1000000) * Строка.Количество;
			
		Иначе
			
			Строка.КоличествоСОтходом = Строка.Количество;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СписокНоменклатуры.Свернуть("Номенклатура, Длина, ДобавленоВручную, Ширина, ЭтоДеталь", "Количество, КоличествоСОтходом");
	
КонецПроцедуры

Процедура ЗаполнитьТЧ(Профили, Заливки, Гравировки, КоличествоПерехлестов, КоличествоШлегель, Отказ)
	
	КоличествоСтрок = СписокНоменклатуры.Количество();
	Если КоличествоСтрок > 0 Тогда
		Для Индекс = 1 По КоличествоСтрок Цикл
			Элемент = СписокНоменклатуры[КоличествоСтрок - Индекс];
			Если НЕ Элемент.ДобавленоВручную Тогда
				СписокНоменклатуры.Удалить(Элемент);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Профили) Тогда
		ЗаполнитьТаблицу(Профили, КоличествоПерехлестов, КоличествоШлегель, КоличествоСтрок);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Заливки) Тогда
		ЗаполнитьЗаливками(Заливки, Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Гравировки) Тогда
		ЗаполнитьГравировками(Гравировки);
	КонецЕсли;
	
	//Добавить услугу для сборки двери
	НоваяСтрока = СписокНоменклатуры.Добавить();
	НоваяСтрока.Номенклатура = Справочники.Номенклатура.СборкаДвериРаумПлюс;
	НоваяСтрока.Количество = Количество;
	
КонецПроцедуры

Процедура ЗаполнитьТаблицу(Профили, КоличествоПерехлестов, КоличествоШлегель, КоличествоСтрок)
	
	ЗаполнитьШлегели(КоличествоШлегель, КоличествоСтрок);
	
	СтруктураПрофиля = Справочники.Двери.ПолучитьСтруктуруПрофиля(Профиль, Спецификация.Подразделение);
	
	ТрекНижний = "";
	ТрекВерхний = "";
	ТрекНаПоворот = "";
	СменаВидаДвери = Ложь;
	
	КоличествоСтрокВручную = СписокНоменклатуры.Количество();
	Если КоличествоСтрокВручную > 0 Тогда
		Для Индекс = 1 По КоличествоСтрокВручную Цикл
			Элемент = СписокНоменклатуры[КоличествоСтрокВручную - Индекс];
			Если (Элемент.Номенклатура.НоменклатурнаяГруппа.Родитель = Справочники.НоменклатурныеГруппы.АлюминиевыйПрофиль) ИЛИ (Элемент.Номенклатура = Справочники.Номенклатура.КолесаС 
				ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.КолесаН ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.ПоворотнаяСистема) Тогда
				
				Если Элемент.Номенклатура.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ТрекОднополосныйНижний Тогда
					ТрекНижний = Элемент.Номенклатура;
				ИначеЕсли Элемент.Номенклатура.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ТрекОднополосныйВерхний Тогда
					ТрекВерхний = Элемент.Номенклатура;
				ИначеЕсли Элемент.Номенклатура.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ТрекНижний Тогда
					ТрекНижний = Элемент.Номенклатура;
				ИначеЕсли Элемент.Номенклатура.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ТрекВерхний Тогда
					ТрекВерхний = Элемент.Номенклатура;
				ИначеЕсли Элемент.Номенклатура.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ТрекНаПоворотнуюСистему Тогда
					ТрекНаПоворот = Элемент.Номенклатура;
					//ИначеЕсли Элемент.Номенклатура = Справочники.Номенклатура.КолесаС ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.КолесаН
					//	ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.ПоворотнаяСистема Тогда
					//	Колеса_ПоворотнаяСистема = Элемент.Номенклатура;
				КонецЕсли;
				
				СменаВидаДвери = (ВидДвери = Перечисления.ВидыДверей.Раздвижная И ЗначениеЗаполнено(ТрекНаПоворот))
				ИЛИ (ВидДвери = Перечисления.ВидыДверей.Распашная И (ЗначениеЗаполнено(ТрекВерхний) ИЛИ ЗначениеЗаполнено(ТрекНижний)));
				
				СписокНоменклатуры.Удалить(Элемент);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	//Добавить услугу распил трека
	МассивОднополосныхТреков = Новый Массив;
	МассивТреков = Новый Массив;
	
	Если КоличествоСтрок = 0 ИЛИ ЗначениеЗаполнено(ТрекНижний) ИЛИ СменаВидаДвери Тогда
		МассивОднополосныхТреков.Добавить(СтруктураПрофиля.ТрекОднополосныйНижний);
		МассивТреков.Добавить(СтруктураПрофиля.ТрекНижний);
	КонецЕсли;
	
	Если КоличествоСтрок = 0 ИЛИ ЗначениеЗаполнено(ТрекВерхний) ИЛИ СменаВидаДвери Тогда
		МассивОднополосныхТреков.Добавить(СтруктураПрофиля.ТрекОднополосныйВерхний);
		МассивТреков.Добавить(СтруктураПрофиля.ТрекВерхний);
	КонецЕсли;
	
	Если ВидДвери = Перечисления.ВидыДверей.Распашная И (ЗначениеЗаполнено(ТрекНаПоворот) ИЛИ КоличествоСтрок = 0 ИЛИ СменаВидаДвери) Тогда
		
		НоваяСтрока = СписокНоменклатуры.Добавить();
		НоваяСтрока.Номенклатура = СтруктураПрофиля.ТрекНаПоворотнуюСистему;
		НоваяСтрока.Количество = 2;
		НоваяСтрока.Ширина = ШиринаПроема + Трек;
		НоваяСтрока.ДобавленоВручную = Истина;
		
	ИначеЕсли ВидДвери = Перечисления.ВидыДверей.Раздвижная И (СменаВидаДвери ИЛИ ЗначениеЗаполнено(ТрекНижний) ИЛИ ЗначениеЗаполнено(ТрекВерхний) ИЛИ КоличествоСтрок = 0) Тогда 
		Если КоличествоПерехлестов = 0 Тогда
			Если ЗначениеЗаполнено(СтруктураПрофиля.ТрекОднополосныйНижний) И ЗначениеЗаполнено(СтруктураПрофиля.ТрекОднополосныйВерхний) Тогда
				Массив = МассивОднополосныхТреков;
			Иначе
				Массив = МассивТреков;
				Если Массив.Количество() > 0 Тогда
					НоваяСтрока = СписокНоменклатуры.Добавить();
					НоваяСтрока.Номенклатура = Справочники.Номенклатура.РаспилитьТрекНаОднуПолосу;
					НоваяСтрока.Количество = 1;
				КонецЕсли;
			КонецЕсли;
		Иначе
			Массив = МассивТреков;
		КонецЕсли;
		
		Если Массив.Количество() > 0 Тогда
			Для Каждого Элемент Из Массив Цикл
				НоваяСтрока = СписокНоменклатуры.Добавить();
				НоваяСтрока.Номенклатура = Элемент;
				НоваяСтрока.Количество = 1;
				НоваяСтрока.Ширина = ШиринаПроема + Трек;
				НоваяСтрока.ДобавленоВручную = Истина;
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
	//Заполнить Профили
	Массив = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Профили, "^");	
	Для Каждого Элемент из Массив Цикл
		Реквизит = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Элемент, "_");
		Параметр = Реквизит[0];
		НоваяСтрока = СписокНоменклатуры.Добавить();
		НоваяСтрока.Ширина = Реквизит[1];
		НоваяСтрока.Количество = 1;
		НоваяСтрока.ЭтоДеталь = Истина;
		
		Если Параметр = "1" Тогда
			НоваяСтрока.Номенклатура = СтруктураПрофиля.РамкаВерхняя;
		ИначеЕсли Параметр = "2" Тогда
			НоваяСтрока.Номенклатура = СтруктураПрофиля.РамкаНижняя;
		ИначеЕсли Параметр = "3" Тогда
			НоваяСтрока.Номенклатура = Профиль;
		ИначеЕсли Параметр = "4" Или Параметр = "5" Или Параметр = "6" Тогда
			НоваяСтрока.Номенклатура = ?(ЗначениеЗаполнено(СтруктураПрофиля.РамкаСредняяБезКрепления), СтруктураПрофиля.РамкаСредняяБезКрепления, СтруктураПрофиля.РамкаСредняяСКреплением);
			
			НоваяСтр = СписокНоменклатуры.Добавить();
			НоваяСтр.Количество = 1;
			Если Параметр = "4" Тогда
				НоваяСтр.Номенклатура = Справочники.Номенклатура.ДобавлениеСреднейРамкиПрямой;
			ИначеЕсли Параметр = "5" Тогда
				НоваяСтр.Номенклатура = Справочники.Номенклатура.ДобавлениеСреднейРамкиКосой;
			ИначеЕсли Параметр = "6" Тогда
				НоваяСтр.Номенклатура = Справочники.Номенклатура.ДобавлениеСреднейРамкиГнутой;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	//Добавим стопор и колеса
	Если ВидДвери = Перечисления.ВидыДверей.Раздвижная Тогда
		//Стопор
		Если КоличествоСтрок = 0 ИЛИ СменаВидаДвери Тогда
			НоваяСтрока = СписокНоменклатуры.Добавить();
			НоваяСтрока.Номенклатура = Справочники.Номенклатура.СтопорНижнийМетал;
			НоваяСтрока.Количество = Количество;
			НоваяСтрока.ДобавленоВручную = Истина;
		Иначе
			Стопор = СписокНоменклатуры.Найти(Справочники.Номенклатура.СтопорНижнийМетал, "Номенклатура");
			Если Стопор <> Неопределено Тогда
				Стопор.Количество = Количество;
			КонецЕсли;
		КонецЕсли;
		
		//Колеса
		НоваяСтрока = СписокНоменклатуры.Добавить();
		НоваяСтрока.Номенклатура = Профиль.ДополнительныйЭлемент;
		НоваяСтрока.Количество = Количество;
		
	ИначеЕсли ВидДвери = Перечисления.ВидыДверей.Распашная Тогда
		
		// 4 Самореза на дверь
		НоваяСтрока = СписокНоменклатуры.Добавить();
		НоваяСтрока.Номенклатура =Справочники.Номенклатура.СаморезСтяжкаRaum; 
		НоваяСтрока.Количество = 4*Количество;
		
		//Стопор
		Стопор = СписокНоменклатуры.Найти(Справочники.Номенклатура.СтопорНижнийМетал, "Номенклатура");
		Если Стопор <> Неопределено Тогда
			СписокНоменклатуры.Удалить(Стопор);
		КонецЕсли;
		
		//Колеса
		НоваяСтрока = СписокНоменклатуры.Добавить();
		ПоворотнаяСистема = Справочники.Номенклатура.ПоворотнаяСистема;
		НоваяСтрока.Номенклатура = ПоворотнаяСистема; 
		НоваяСтрока.Количество = Количество;
		
		Если ЗначениеЗаполнено(ПоворотнаяСистема.ДополнительныйЭлемент) Тогда
			
			НоваяСтрока = СписокНоменклатуры.Добавить();
			ПоворотнаяСистемаДоп = ПоворотнаяСистема.ДополнительныйЭлемент;
			НоваяСтрока.Номенклатура = ПоворотнаяСистемаДоп;
			НоваяСтрока.Количество = Количество * 2;
			Если ЗначениеЗаполнено(ПоворотнаяСистемаДоп.ДополнительныйЭлемент) Тогда
				НоваяСтрока = СписокНоменклатуры.Добавить();
				НоваяСтрока.Номенклатура = ПоворотнаяСистемаДоп.ДополнительныйЭлемент;
				НоваяСтрока.Количество = Количество * 2;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьШлегели(КоличествоШлегель, КоличествоСтрок)
	
	// заполняем шлегели
	Шлегель = Справочники.Номенклатура.ПустаяСсылка();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоответствиеНоменклатуры.ПодставляемаяНоменклатура
		|ИЗ
		|	РегистрСведений.СоответствиеНоменклатуры КАК СоответствиеНоменклатуры
		|ГДЕ
		|	СоответствиеНоменклатуры.Номенклатура = &Номенклатура
		|	И СоответствиеНоменклатуры.Подразделение = &Подразделение
		|	И СоответствиеНоменклатуры.НоменклатурнаяГруппа = &НоменклатурнаяГруппа";

	Запрос.УстановитьПараметр("Номенклатура", Профиль);
	Запрос.УстановитьПараметр("НоменклатурнаяГруппа", Справочники.НоменклатурныеГруппы.Шлегель);
	Запрос.УстановитьПараметр("Подразделение", ?(ЗначениеЗаполнено(Спецификация), Спецификация.Подразделение, Справочники.Подразделения.ПустаяСсылка()));

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
	
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "В подразделении """+ Спецификация.Подразделение + """ профилю """ + Профиль + """ нет связанного шлегеля, обратитесь к инженерам";
		Сообщение.Поле = "СписокНоменклатуры[0].Номенклатура";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
	
	КонецЕсли;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Шлегель = ВыборкаДетальныеЗаписи.ПодставляемаяНоменклатура;
	КонецЦикла;
	
	
	//Если ЦветПрофиля = Справочники.Цвета.Бук ИЛИ ЦветПрофиля = Справочники.Цвета.Вишня ИЛИ ЦветПрофиля = Справочники.Цвета.Золото Тогда
	//	Шлегель = Справочники.Номенклатура.ШлегельЗолото;
	//ИначеЕсли ЦветПрофиля = Справочники.Цвета.Венге ИЛИ ЦветПрофиля = Справочники.Цвета.ОрехИталия Тогда
	//	Шлегель = Справочники.Номенклатура.ШлегельВенге;
	//ИначеЕсли ЦветПрофиля = Справочники.Цвета.Хром ИЛИ ЦветПрофиля = Справочники.Цвета.Шампань Тогда
	//	Шлегель = Справочники.Номенклатура.ШлегельХром;
	//ИначеЕсли ЦветПрофиля = Справочники.Цвета.ДубВыбеленный Тогда
	//	Шлегель = Справочники.Номенклатура.ШлегельБелый;
	//КонецЕсли;
	
	Если КоличествоСтрок = 0 Тогда
		НоваяСтрока = СписокНоменклатуры.Вставить(0);
		НоваяСтрока.Номенклатура = Шлегель;
		НоваяСтрока.Ширина = Количество * 2 * ВысотаПроема * 1.1;
		НоваяСтрока.Количество = 1;
		НоваяСтрока.ДобавленоВручную = Истина;
	Иначе
		Для Каждого Элемент Из СписокНоменклатуры Цикл
			Если Элемент.Номенклатура = Справочники.Номенклатура.ШлегельВенге
				ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.ШлегельХром
				ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.ШлегельЗолото
				ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.ШлегельБелый Тогда
				Если Ссылка.Профиль <> Профиль Тогда
					Элемент.Номенклатура = Шлегель;
				КонецЕсли;
				Элемент.Количество = 1;
				Если ЗначениеЗаполнено(КоличествоШлегель) Тогда
					Элемент.Ширина = КоличествоШлегель;
				Иначе
					Элемент.Ширина = Количество * 2 * ВысотаПроема * 1.1;
					КоличествоШлегель = Неопределено;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьЗаливками(Заливки, Отказ)
	
	МассивЗаливки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Заливки, "^");
	
	Для Каждого Элемент Из МассивЗаливки Цикл
		Реквизит = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Элемент, "_");
		Параметр = Справочники.Номенклатура.НайтиПоКоду(Реквизит[0]);
		//Заполнить Деталями заливки (Стекло, Зеркало, ЛДСП, МДФ и тд)
		Если НЕ ЗначениеЗаполнено(Параметр) Тогда
			Продолжить;
		КонецЕсли;
		
		ДлинаКривогоПила = ?(ЗначениеЗаполнено(Реквизит[3]), Число(Реквизит[3]), 0);
		ПериметрДетали = Реквизит[4];
		
		ШиринаВставки = Число(Реквизит[1]);
		ВысотаВставки = Число(Реквизит[2]);
		
		//В зависимости от значений Глубины и Паза профиля, добовляем услугу Фрезеровка, материал Уплотнитель
		Глубина = Параметр.ГлубинаДетали;
		Уплотнитель = Неопределено;
		
		Если Глубина = 6 Тогда
			Уплонтинель = Справочники.Номенклатура.Уплотнитель4мм;
		ИначеЕсли Глубина = 8 Тогда
			Уплотнитель = Справочники.Номенклатура.АГТУплотнитель;
		ИначеЕсли Глубина > 10 Тогда
			НоваяСтрока = СписокНоменклатуры.Добавить();
			НоваяСтрока.Номенклатура = Справочники.Номенклатура.ФрезеровкаЛДСПЗонаДверей;
			НоваяСтрока.Количество = ПериметрДетали / 1000;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Уплотнитель) Тогда
			НоваяСтрока = СписокНоменклатуры.Добавить();
			НоваяСтрока.Номенклатура = Уплотнитель;
			НоваяСтрока.Количество = 1;
			НоваяСтрока.Ширина = ПериметрДетали;
		КонецЕсли;
		
		Если Параметр.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.Кожа Тогда
			
			ДобавитьВставку(Параметр, ШиринаВставки + 100, ВысотаВставки + 100, Истина, Отказ);
			
		Иначе
			
			Если Параметр <> Справочники.Номенклатура.СтеклоСФотопечатью4мм И Параметр <> Справочники.Номенклатура.СтеклоСФотопечатью6мм Тогда
				Вставка = Параметр;
			Иначе
				Вставка = Справочники.Номенклатура.ПленкаОракал;
			КонецЕсли;
			
			ДобавитьВставку(Вставка, ШиринаВставки, ВысотаВставки, Истина, Отказ);
			
		КонецЕсли;
		
		//Для Мебельных щитов добавить Доп Элементы
		Если ЗначениеЗаполнено(Параметр.ДополнительныйЭлемент) Тогда
			
			ДопЭлемент = Параметр.ДополнительныйЭлемент;
			Если ДопЭлемент = Справочники.Номенклатура.ЛДСП8Белый Тогда
				ДобавитьВставку(ДопЭлемент, ШиринаВставки - 2, ВысотаВставки - 2, Ложь, Отказ);
			Иначе
				ДобавитьВставку(ДопЭлемент, ШиринаВставки, ВысотаВставки, Ложь, Отказ);
			КонецЕсли;
		КонецЕсли;
		
		// добавление доп. услуги
		
		Если ЗначениеЗаполнено(Параметр.ДополнительнаяУслуга) Тогда
			
			КоличествоУслуги = 1;
			Если Параметр = Справочники.Номенклатура.СтеклоСФотопечатью4мм ИЛИ Параметр = Справочники.Номенклатура.СтеклоСФотопечатью6мм Тогда
				КоличествоУслуги = ШиринаВставки * ВысотаВставки / 1000000;
			КонецЕсли;
			
			НоваяСтрока = СписокНоменклатуры.Добавить();
			НоваяСтрока.Номенклатура = Параметр.ДополнительнаяУслуга;
			НоваяСтрока.Количество = КоличествоУслуги;
			
			 // Агеев. У доп услуги по изготовлению сборной вставки 2 доп элемента 
			Если Параметр.ДополнительнаяУслуга = Справочники.Номенклатура.ИзготовлениеСборнойВставки 
				И Параметр.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ЩитМебельный Тогда
				ДопЗеркало = Справочники.Номенклатура.Зеркало;
				ДобавитьВставку(ДопЗеркало, ШиринаВставки, ВысотаВставки , Ложь, Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
		//Добавить Услуги по обработке Стекла Или Дерева
		НоваяСтрока = СписокНоменклатуры.Добавить();
		НоваяСтрока.Количество = 1;
		Если Параметр.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.Зеркало ИЛИ Параметр.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.Стекло Тогда
			НоваяСтрока.Номенклатура = Справочники.Номенклатура.ИзготовлениеДеталиСтекло;
			КриволинейнаяУслуга = Справочники.Номенклатура.КриволинейныйРез;
		Иначе
			НоваяСтрока.Номенклатура = Справочники.Номенклатура.ИзготовлениеДеревяннойДеталиСтекольнаяЗона;
			КриволинейнаяУслуга = Справочники.Номенклатура.КриволинейныйПилЗонаДверей;
		КонецЕсли;
		
		Если ДлинаКривогоПила > 0 Тогда
			НоваяСтрока = СписокНоменклатуры.Добавить();
			НоваяСтрока.Номенклатура = КриволинейнаяУслуга;
			НоваяСтрока.Количество = ДлинаКривогоПила / 1000;
		КонецЕсли;
		
	КонецЦикла; // Для Каждого Элемент Из МассивЗаливки Цикл
	
КонецПроцедуры

Процедура ЗаполнитьГравировками(Гравировки)
	
	//Добавление Услуги гравировки
	МассивГравировок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Гравировки, "^");
	Для Каждого Элемент Из МассивГравировок Цикл
		Площадь = Лев(Элемент, Найти(Элемент, "_") - 1);
		НоваяСтрока = СписокНоменклатуры.Добавить();
		НоваяСтрока.Номенклатура = Справочники.Номенклатура.Гравировка;
		НоваяСтрока.Количество = Макс(Площадь / 1000000, 0.01);
	КонецЦикла;
	
КонецПроцедуры

Функция ПроверитьРазмерыЗаливки(Номенклатура, Ширина, Высота, Отказ)
	
	Ответ = Ложь;
	СвойстваНоменклатуры = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Номенклатура, "ДлинаДетали, ШиринаДетали, НаличиеТекстуры, Наименование");
	
	Если (СвойстваНоменклатуры.ДлинаДетали >= Высота) И (СвойстваНоменклатуры.ШиринаДетали >= Ширина) Тогда
		Ответ = Истина;
	Иначе
		// материал без текстуры -- попробуем перевернуть
		Если НЕ СвойстваНоменклатуры.НаличиеТекстуры И ((СвойстваНоменклатуры.ДлинаДетали >= Ширина) И (СвойстваНоменклатуры.ШиринаДетали >= Высота)) Тогда
			Ответ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Ответ Тогда
		Отказ = Истина;
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Указанный размер (%2 х %3) превышает максимально допустимый (%4 х %5) '%1'. ",
		СвойстваНоменклатуры.Наименование,
		Ширина,
		Высота,
		СвойстваНоменклатуры.ШиринаДетали,
		СвойстваНоменклатуры.ДлинаДетали);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция ДобавитьВставку(фНоменклатура, фШиринаВставки ,фВысотаВставки , фЭтоДеталь, фОтказ)
	
	Если ПроверитьРазмерыЗаливки(фНоменклатура, фШиринаВставки ,фВысотаВставки, фОтказ) Тогда
		
		НоваяСтрока = СписокНоменклатуры.Добавить();
		НоваяСтрока.Номенклатура = фНоменклатура;
		НоваяСтрока.Ширина = фШиринаВставки;
		НоваяСтрока.Длина = фВысотаВставки;
		НоваяСтрока.Количество = 1;
		НоваяСтрока.ЭтоДеталь = фЭтоДеталь;
		
	КонецЕсли;
	
КонецФункции