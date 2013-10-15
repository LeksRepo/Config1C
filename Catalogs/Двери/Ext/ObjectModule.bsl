﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если НЕ ЭтоГруппа Тогда
		Дата = ТекущаяДата();
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	МассивПараметровДвери = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаДляРасчета, "☺");
	ЗаполнитьТЧ(МассивПараметровДвери[0], МассивПараметровДвери[1], МассивПараметровДвери[2], Число(МассивПараметровДвери[3]), Число(МассивПараметровДвери[4]), Отказ);
	
	Для Каждого Строка Из Номенклатура Цикл
		Если ЗначениеЗаполнено(Строка.Ширина) И НЕ ЗначениеЗаполнено(Строка.Длина) Тогда
			
			Строка.КоличествоСОтходом = (Строка.Ширина / 1000) * Строка.Количество;
			
		ИначеЕсли ЗначениеЗаполнено(Строка.Ширина) И ЗначениеЗаполнено(Строка.Длина) Тогда
			
			Строка.КоличествоСОтходом = ((Строка.Ширина * Строка.Длина) / 1000000) * Строка.Количество;
			
		Иначе
			
			Строка.КоличествоСОтходом = Строка.Количество;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьТЧ(Профили, Заливки, Гравировки, КоличествоПерехлестов, КоличествоШлегель, Отказ)
	
	КоличествоСтрок = Номенклатура.Количество();
	Если КоличествоСтрок > 0 Тогда
		Для Индекс = 1 По КоличествоСтрок Цикл
			Элемент = Номенклатура[КоличествоСтрок - Индекс];
			Если НЕ Элемент.ДобавленоВручную Тогда
				Номенклатура.Удалить(Элемент);
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
	НоваяСтрока = Номенклатура.Добавить();
	НоваяСтрока.Номенклатура = Справочники.Номенклатура.СборкаДвериРаумПлюс;
	НоваяСтрока.Количество = Количество;
	
КонецПроцедуры

Процедура ЗаполнитьТаблицу(Профили, КоличествоПерехлестов, КоличествоШлегель, КоличествоСтрок)
	
	ЗаполнитьШлегели(КоличествоШлегель, КоличествоСтрок);
	
	СтруктураПрофиля = Справочники.Двери.ПолучитьСтруктуруПрофиля(Профиль, Подразделение);
	
	ТрекНижний = "";
	ТрекВерхний = "";
	ТрекНаПоворот = "";
	Колеса_ПоворотнаяСистема = "";
	СменаВидаДвери = Ложь;
	
	КоличествоСтрокВручную = Номенклатура.Количество();
	Если КоличествоСтрокВручную > 0 Тогда
		Для Индекс = 1 По КоличествоСтрокВручную Цикл
			Элемент = Номенклатура[КоличествоСтрокВручную - Индекс];
			Если ЗначениеЗаполнено(Элемент.Номенклатура.ВидПрофиля) ИЛИ (Элемент.Номенклатура = Справочники.Номенклатура.КолесаС 
				ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.КолесаН ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.ПоворотнаяСистема) Тогда
				
				Если Элемент.Номенклатура.ВидПрофиля = Перечисления.ВидыПрофилей.ТрекОднополосныйНижний Тогда
					ТрекНижний = Элемент.Номенклатура;
				ИначеЕсли Элемент.Номенклатура.ВидПрофиля = Перечисления.ВидыПрофилей.ТрекОднополосныйВерхний Тогда
					ТрекВерхний = Элемент.Номенклатура;
				ИначеЕсли Элемент.Номенклатура.ВидПрофиля = Перечисления.ВидыПрофилей.ТрекНижний Тогда
					ТрекНижний = Элемент.Номенклатура;
				ИначеЕсли Элемент.Номенклатура.ВидПрофиля = Перечисления.ВидыПрофилей.ТрекВерхний Тогда
					ТрекВерхний = Элемент.Номенклатура;
				ИначеЕсли Элемент.Номенклатура.ВидПрофиля = Перечисления.ВидыПрофилей.ТрекНаПоворотнуюСистему Тогда
					ТрекНаПоворот = Элемент.Номенклатура;
				ИначеЕсли Элемент.Номенклатура = Справочники.Номенклатура.КолесаС ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.КолесаН
					ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.ПоворотнаяСистема Тогда
					Колеса_ПоворотнаяСистема = Элемент.Номенклатура;
				КонецЕсли;
				
				СменаВидаДвери = (ВидДвери = Перечисления.ВидыДверей.Раздвижная И ЗначениеЗаполнено(ТрекНаПоворот))
				ИЛИ (ВидДвери = Перечисления.ВидыДверей.Распашная И (ЗначениеЗаполнено(ТрекВерхний) ИЛИ ЗначениеЗаполнено(ТрекНижний)));
				
				Номенклатура.Удалить(Элемент);
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
		
		НоваяСтрока = Номенклатура.Добавить();
		НоваяСтрока.Номенклатура = СтруктураПрофиля.ТрекНаПоворотнуюСистему;
		НоваяСтрока.Количество = 2;
		НоваяСтрока.Ширина = ШиринаПроема + Трек;
		НоваяСтрока.ДобавленоВручную = Истина;
		
		//Колеса
		Если ЗначениеЗаполнено(Колеса_ПоворотнаяСистема) ИЛИ КоличествоСтрок = 0 ИЛИ СменаВидаДвери Тогда
			НоваяСтрока = Номенклатура.Добавить(); 
			НоваяСтрока.Номенклатура = Справочники.Номенклатура.ПоворотнаяСистема;
			НоваяСтрока.Количество = Количество;
			НоваяСтрока.ДобавленоВручную = Истина;
		КонецЕсли;
		
	ИначеЕсли ВидДвери = Перечисления.ВидыДверей.Раздвижная И (СменаВидаДвери ИЛИ ЗначениеЗаполнено(ТрекНижний) ИЛИ ЗначениеЗаполнено(ТрекВерхний) ИЛИ КоличествоСтрок = 0) Тогда 
		Если КоличествоПерехлестов = 0 Тогда
			Если ЗначениеЗаполнено(СтруктураПрофиля.ТрекОднополосныйНижний) И ЗначениеЗаполнено(СтруктураПрофиля.ТрекОднополосныйВерхний) Тогда
				Массив = МассивОднополосныхТреков;
			Иначе 	
				Массив = МассивТреков;
				Если Массив.Количество() > 0 Тогда
					НоваяСтрока = Номенклатура.Добавить();
					НоваяСтрока.Номенклатура = Справочники.Номенклатура.РаспилитьТрекНаОднуПолосу;
					НоваяСтрока.Количество = 1;
				КонецЕсли;
			КонецЕсли;	
		Иначе	
			Массив = МассивТреков;
		КонецЕсли;
		
		Если Массив.Количество() > 0 Тогда
			Для Каждого Элемент Из Массив Цикл
				НоваяСтрока = Номенклатура.Добавить();
				НоваяСтрока.Номенклатура = Элемент;
				НоваяСтрока.Количество = 1;
				НоваяСтрока.Ширина = ШиринаПроема + Трек;
				НоваяСтрока.ДобавленоВручную = Истина;
			КонецЦикла;
			
			//Колеса
			Если ЗначениеЗаполнено(Колеса_ПоворотнаяСистема) ИЛИ КоличествоСтрок = 0 ИЛИ СменаВидаДвери Тогда
				НоваяСтрока = Номенклатура.Добавить(); 
				НоваяСтрока.Номенклатура = Профиль.ДополнительныйЭлемент;
				НоваяСтрока.Количество = Количество;
				НоваяСтрока.ДобавленоВручную = Истина;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	//Заполнить Профили
	Массив = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Профили, "^");	
	Для Каждого Элемент из Массив Цикл
		Реквизит = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Элемент, "_");
		Параметр = Реквизит[0];
		НоваяСтрока = Номенклатура.Добавить();
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
			
			НоваяСтр = Номенклатура.Добавить();
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
	
	//Заполнить Колеса
	
	//НоваяСтрока = Номенклатура.Добавить();
	//Если ВидДвери = Перечисления.ВидыДверей.Раздвижная Тогда 
	//	НоваяСтрока.Номенклатура = Профиль.ДополнительныйЭлемент;	
	//ИначеЕсли ВидДвери = Перечисления.ВидыДверей.Распашная Тогда 
	//	НоваяСтрока.Номенклатура = Справочники.Номенклатура.ПоворотнаяСистема;
	//КонецЕсли;
	//НоваяСтрока.Количество = Количество;
	
КонецПроцедуры

Процедура ЗаполнитьШлегели(КоличествоШлегель, КоличествоСтрок) 
	
	// заполняем шлегели
	ЦветПрофиля = Профиль.Цвет;
	Если ЦветПрофиля = Справочники.Цвета.Бук ИЛИ ЦветПрофиля = Справочники.Цвета.Вишня 
		ИЛИ ЦветПрофиля = Справочники.Цвета.Золото Тогда
		Шлегель = Справочники.Номенклатура.ШлегельЗолото; //для Бук-Вишня-Золото
	ИначеЕсли ЦветПрофиля = Справочники.Цвета.Венге ИЛИ ЦветПрофиля = Справочники.Цвета.ОрехИталия Тогда
		Шлегель = Справочники.Номенклатура.ШлегельВенге;  //для Венге-Италия
	ИначеЕсли ЦветПрофиля = Справочники.Цвета.Хром ИЛИ ЦветПрофиля = Справочники.Цвета.Шампань Тогда
		Шлегель = Справочники.Номенклатура.ШлегельХром;  //для Хром-Шампань
	ИначеЕсли ЦветПрофиля = Справочники.Цвета.ДубВыбеленный Тогда
		Шлегель = Справочники.Номенклатура.ШлегельБелый;  //для Дуб	
	КонецЕсли;
	
	Если КоличествоСтрок = 0 Тогда	
		НоваяСтрока = Номенклатура.Вставить(0);
		НоваяСтрока.Номенклатура = Шлегель;
		Если ЗначениеЗаполнено(КоличествоШлегель) Тогда
			НоваяСтрока.Количество = КоличествоШлегель;
		Иначе
			НоваяСтрока.Количество = ?(Количество >= 3, Количество + 2, Количество * 2);
			КоличествоШлегель = Неопределено;
		КонецЕсли;
		НоваяСтрока.Ширина = НоваяСтрока.Количество * ВысотаПроема;
		НоваяСтрока.ДобавленоВручную = Истина;
	Иначе
		Для Каждого Элемент Из Номенклатура Цикл
			Если Элемент.Номенклатура = Справочники.Номенклатура.ШлегельВенге 
				ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.ШлегельХром 
				ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.ШлегельЗолото Тогда
				Элемент.Номенклатура = Шлегель;	
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
		Если ЗначениеЗаполнено(Параметр) Тогда
			ДлинаКривогоПила = ?(ЗначениеЗаполнено(Реквизит[3]), Число(Реквизит[3]), 0);
			ПериметрДетали = Реквизит[4];
			Если (Параметр.ДлинаДетали >= Число(Реквизит[2])) И (Параметр.ШиринаДетали >= Число(Реквизит[1])) Тогда
				НоваяСтрока = Номенклатура.Добавить();
				НоваяСтрока.Номенклатура = Параметр;
				НоваяСтрока.Ширина = Реквизит[1];
				НоваяСтрока.Длина = Реквизит[2];
				НоваяСтрока.Количество = 1;
				НоваяСтрока.ЭтоДеталь = Истина;
			Иначе
				Отказ = Истина;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Превышены допустимые размеры " + Параметр.Наименование);
			КонецЕсли;
			//Для Мебельных щитов добавить Доп Элементы
			Если ЗначениеЗаполнено(Параметр.ДополнительныйЭлемент) Тогда
				ДопЭлемент = Параметр.ДополнительныйЭлемент;
				Если (ДопЭлемент.ДлинаДетали >= Число(Реквизит[2])) И (ДопЭлемент.ШиринаДетали >= Число(Реквизит[1])) Тогда
					НоваяСтрока = Номенклатура.Добавить();
					НоваяСтрока.Номенклатура = ДопЭлемент;
					НоваяСтрока.Ширина = Реквизит[1];
					НоваяСтрока.Длина = Реквизит[2];
					НоваяСтрока.Количество = 1;
				Иначе
					Отказ = Истина;
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Превышены допустимые размеры " + ДопЭлемент.Наименование);
				КонецЕсли;
			КонецЕсли;
			//Для Мебельных щитов добавить Доп услуги
			Если ЗначениеЗаполнено(Параметр.ДополнительнаяУслуга) Тогда
				НоваяСтрока = Номенклатура.Добавить();
				НоваяСтрока.Номенклатура = Параметр.ДополнительнаяУслуга;
				НоваяСтрока.Количество = 1;
				//У доп услуги по изготовлению сборной вставки 2 доп элемента
				Если Параметр.ДополнительнаяУслуга = Справочники.Номенклатура.ИзготовлениеСборнойВставки Тогда
					ДопЗеркало = Справочники.Номенклатура.Зеркало;
					Если (ДопЗеркало.ДлинаДетали >= Число(Реквизит[2])) И (ДопЗеркало.ШиринаДетали >= Число(Реквизит[1])) Тогда
						НоваяСтрока = Номенклатура.Добавить();
						НоваяСтрока.Номенклатура = ДопЗеркало;
						НоваяСтрока.Ширина = Реквизит[1];
						НоваяСтрока.Длина = Реквизит[2];
						НоваяСтрока.Количество = 1;
					Иначе
						Отказ = Истина;
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Превышены допустимые размеры " + ДопЗеркало.Наименование);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			//Добавить Услуги При обработки Стекла Или Дерева
			НоваяСтрока = Номенклатура.Добавить();
			Если Параметр.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.Зеркало Или
				Параметр.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.Стекло Тогда
				НоваяСтрока.Номенклатура = Справочники.Номенклатура.ИзготовлениеДеталиСтекло;
				Если ДлинаКривогоПила > 0 Тогда
					НоваяСтр = Номенклатура.Добавить();
					НоваяСтр.Номенклатура = Справочники.Номенклатура.КриволинейныйРез;
					НоваяСтр.Количество = ДлинаКривогоПила / 1000;
				КонецЕсли;
			Иначе
				НоваяСтрока.Номенклатура = Справочники.Номенклатура.ИзготовлениеДеревяннойДеталиСтекольнаяЗона;
				Если ДлинаКривогоПила > 0 Тогда
					НоваяСтр = Номенклатура.Добавить();
					НоваяСтр.Номенклатура = Справочники.Номенклатура.КриволинейныйПилЗонаДверей;
					НоваяСтр.Количество = ДлинаКривогоПила / 1000;
				КонецЕсли;
			КонецЕсли;
			НоваяСтрока.Количество = 1;
			
			//В зависимости от значение Глубины и Паза профиля, добовляем либо услугу фрезировка, либо номенклатуру Уплотнитель
			Глубина = Параметр.ГлубинаДетали;
			ПазПрофиля = Профиль.ШиринаПаза;
			Если ЗначениеЗаполнено(ПазПрофиля) И ЗначениеЗаполнено(Глубина) Тогда
				Если Глубина > ПазПрофиля Тогда
					НоваяСтрока = Номенклатура.Добавить();
					НоваяСтрока.Номенклатура = Справочники.Номенклатура.ФрезеровкаЛДСПЗонаДверей;
					НоваяСтрока.Количество = ПериметрДетали / 1000;
				ИначеЕсли Глубина < ПазПрофиля Тогда
					НоваяСтрока = Номенклатура.Добавить();
					Если Параметр.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.Зеркало Или
						Параметр.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.Стекло Тогда
						НоваяСтрока.Номенклатура = Справочники.Номенклатура.Уплотнитель4мм;
					Иначе
						НоваяСтрока.Номенклатура = Справочники.Номенклатура.АгтУплотнитель;
					КонецЕсли;
					НоваяСтрока.Количество = 1;
					НоваяСтрока.Ширина = ПериметрДетали;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьГравировками(Гравировки)
	
	//Добавление Услуги гравировки
	МассивГравировок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Гравировки, "^");
	Для Каждого Элемент Из МассивГравировок Цикл
		Площадь = Лев(Элемент, Найти(Элемент, "_") - 1);
		НоваяСтрока = Номенклатура.Добавить();
		НоваяСтрока.Номенклатура = Справочники.Номенклатура.Гравировка;
		НоваяСтрока.Количество = Макс(Площадь / 1000000, 0.01);
	КонецЦикла;	
	
КонецПроцедуры	

