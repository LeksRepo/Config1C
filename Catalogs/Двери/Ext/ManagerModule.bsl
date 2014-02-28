﻿
Функция ПолучитьЦенуДвери (Дверь, ДатаРасчета) Экспорт
	
	//Если (ДатаРасчета-Дверь.Дата)/86400 < 30 Тогда
	//	Возврат Дверь.ЦенаДвери;
	//КонецЕсли;
	
КонецФункции

Функция ТекущаяСтоимостьНоменклатуры(СписокНоменклатуры, ДатаРасчета, Подразделение, ЭтоДверь = Истина) Экспорт
	
	ТЗ = СписокНоменклатуры.Выгрузить();
	Массив = ТЗ.ВыгрузитьКолонку("Номенклатура");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Розничная, 0) КАК Цена,
	|	СпрНоменклатура.Ссылка КАК Номенклатура
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Дата, Регион = &Регион) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО (ЦеныНоменклатурыСрезПоследних.Номенклатура = СпрНоменклатура.Ссылка)
	|ГДЕ
	|	СпрНоменклатура.Ссылка В (&Номенклатура)";
	
	Запрос.УстановитьПараметр("Дата", ДатаРасчета);
	Запрос.УстановитьПараметр("Регион", Подразделение.Регион);
	Запрос.УстановитьПараметр("Номенклатура", Массив);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Для Каждого Стр Из ТЗ Цикл
			Если Выборка.Номенклатура = Стр.Номенклатура Тогда
				Стр.Цена = Выборка.Цена;
				Если ЭтоДверь Тогда
					Стр.Стоимость = Стр.Цена * Стр.КоличествоСОтходом;
				Иначе
					Стр.Стоимость = Стр.Цена * Стр.Количество;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла
	КонецЦикла;
	
	Возврат ТЗ;
	
КонецФункции

Функция ПолучитьСтруктуруПрофиля(Профиль, Подразделение) Экспорт
	
	СтруктураПрофиля = Новый Структура;
	СтруктураПрофиля.Вставить("СтрокаПрофиля", "");
	СтруктураПрофиля.Вставить("Вертикальный", "");
	СтруктураПрофиля.Вставить("РамкаВерхняя", "");
	СтруктураПрофиля.Вставить("РамкаНижняя", "");
	СтруктураПрофиля.Вставить("РамкаСредняяБезКрепления", "");
	СтруктураПрофиля.Вставить("РамкаСредняяСКреплением", "");
	СтруктураПрофиля.Вставить("ТрекНаПоворотнуюСистему", "");
	СтруктураПрофиля.Вставить("ТрекВерхний", "");
	СтруктураПрофиля.Вставить("ТрекНижний", "");
	СтруктураПрофиля.Вставить("ТрекОднополосныйВерхний", "");
	СтруктураПрофиля.Вставить("ТрекОднополосныйНижний", "");
	СтруктураПрофиля.Вставить("Цвет", Профиль.Цвет.КодЦвета);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Цвет", Профиль.Цвет);
	Запрос.УстановитьПараметр("ВидПрофиляПустаяСсылка", Перечисления.ВидыПрофилей.ПустаяСсылка());
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	спрНоменклатура.Ссылка,
	|	спрНоменклатура.ШиринаДетали,
	|	спрНоменклатура.ГлубинаПаза,
	|	спрНоменклатура.ВидПрофиля
	|ИЗ
	|	Справочник.Номенклатура КАК спрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений КАК НоменклатураПодразделений
	|		ПО (НоменклатураПодразделений.Номенклатура = спрНоменклатура.Ссылка)
	|ГДЕ
	|	спрНоменклатура.Базовый
	|	И спрНоменклатура.Цвет = &Цвет
	|	И НоменклатураПодразделений.Подразделение = &Подразделение
	|	И НоменклатураПодразделений.Доступность
	|	И спрНоменклатура.ВидПрофиля <> &ВидПрофиляПустаяСсылка";
	
	Массив = Новый Массив(8);
	Массив[0] = Профиль.ШиринаДетали;
	Массив[1] = Профиль.ГлубинаПаза;
	СтруктураПрофиля.Вертикальный = Профиль;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.ВидПрофиля = Перечисления.ВидыПрофилей.РамкаВерхняя Тогда
			Массив[2] = Выборка.ШиринаДетали;
			Массив[3] = Выборка.ГлубинаПаза;
			СтруктураПрофиля.РамкаВерхняя = Выборка.Ссылка;
		ИначеЕсли Выборка.ВидПрофиля = Перечисления.ВидыПрофилей.РамкаНижняя Тогда
			Массив[4] = Выборка.ШиринаДетали;
			Массив[5] = Выборка.ГлубинаПаза;
			СтруктураПрофиля.РамкаНижняя = Выборка.Ссылка;
		ИначеЕсли Выборка.ВидПрофиля = Перечисления.ВидыПрофилей.РамкаСредняяБезКрепления Тогда
			Массив[6] = Выборка.ШиринаДетали;
			Массив[7] = Выборка.ГлубинаПаза;
			СтруктураПрофиля.РамкаСредняяБезКрепления = Выборка.Ссылка;
		ИначеЕсли Выборка.ВидПрофиля = Перечисления.ВидыПрофилей.РамкаСредняяСКреплением Тогда
			Массив[6] = ?(ЗначениеЗаполнено(Массив[6]), Массив[6], Выборка.ШиринаДетали);
			Массив[7] = ?(ЗначениеЗаполнено(Массив[7]), Массив[7], Выборка.ГлубинаПаза);
			СтруктураПрофиля.РамкаСредняяСКреплением = Выборка.Ссылка;
		ИначеЕсли Выборка.ВидПрофиля = Перечисления.ВидыПрофилей.ТрекВерхний Тогда
			СтруктураПрофиля.ТрекВерхний = Выборка.Ссылка;
		ИначеЕсли Выборка.ВидПрофиля = Перечисления.ВидыПрофилей.ТрекНаПоворотнуюСистему Тогда
			СтруктураПрофиля.ТрекНаПоворотнуюСистему = Выборка.Ссылка;
		ИначеЕсли Выборка.ВидПрофиля = Перечисления.ВидыПрофилей.ТрекНижний Тогда
			СтруктураПрофиля.ТрекНижний = Выборка.Ссылка;
		ИначеЕсли Выборка.ВидПрофиля = Перечисления.ВидыПрофилей.ТрекОднополосныйВерхний Тогда
			СтруктураПрофиля.ТрекОднополосныйВерхний = Выборка.Ссылка;
		ИначеЕсли Выборка.ВидПрофиля = Перечисления.ВидыПрофилей.ТрекОднополосныйНижний Тогда
			СтруктураПрофиля.ТрекОднополосныйНижний = Выборка.Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	СтрокаПрофиля = "";
	Ошибка = Ложь;
	Для Каждого Элемент Из Массив Цикл
		Если Элемент = Неопределено Тогда
			Ошибка = Истина;
		КонецЕсли;
		СтрокаПрофиля = СтрокаПрофиля + Строка(Элемент) + "_";
	КонецЦикла;
	
	Если НЕ Ошибка Тогда
		СтруктураПрофиля.СтрокаПрофиля = СтрокаПрофиля;
	КонецЕсли;
	
	Возврат СтруктураПрофиля;
	
КонецФункции

Функция ДоступностьДвери(Дверь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Статусы = Новый Массив;
	Статусы.Добавить(Перечисления.СтатусыСпецификации.Изготовлен);
	Статусы.Добавить(Перечисления.СтатусыСпецификации.Отгружен);
	Статусы.Добавить(Перечисления.СтатусыСпецификации.ПереданВЦех);
	Статусы.Добавить(Перечисления.СтатусыСпецификации.Установлен);
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Двери", Дверь);
	Запрос.УстановитьПараметр("Статусы", Статусы);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпецификацияСписокДверей.Ссылка
	|ИЗ
	|	Документ.Спецификация.СписокДверей КАК СпецификацияСписокДверей
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО СпецификацияСписокДверей.Ссылка = СтатусСпецификацииСрезПоследних.Спецификация
	|ГДЕ
	|	СпецификацияСписокДверей.Двери = &Двери
	|	И СтатусСпецификацииСрезПоследних.Статус В(&Статусы)";
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции

Функция ПроизводствоДляРозницы(Подразделение) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регион", Подразделение.Регион);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Подразделения.Ссылка
	|ИЗ
	|	Справочник.Подразделения КАК Подразделения
	|ГДЕ
	|	Подразделения.Регион = &Регион
	|	И Подразделения.ВидПодразделения = ЗНАЧЕНИЕ(Перечисление.ВидыПодразделений.Производство)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	Производство = Выборка.Ссылка;
	Выборка.Сбросить();
	
	Возврат Производство;	
	
КонецФункции

Функция РозницаДляПроизводства(Подразделение) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регион", Подразделение.Регион);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Подразделения.Ссылка
	|ИЗ
	|	Справочник.Подразделения КАК Подразделения
	|ГДЕ
	|	Подразделения.Регион = &Регион
	|	И Подразделения.ВидПодразделения = ЗНАЧЕНИЕ(Перечисление.ВидыПодразделений.Розница)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	Производство = Выборка.Ссылка;
	Выборка.Сбросить();
	
	Возврат Производство;	
	
КонецФункции

Функция ПолучитьНоменклатуруДвери(Ссылка, СтрокаДляРасчета, Отказ) Экспорт
	
	СписокНоменклатуры = Ссылка.СписокНоменклатуры;
	
	МассивПараметровДвери = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаДляРасчета, "☺");
	ЗаполнитьТЧ(Ссылка, МассивПараметровДвери[0], МассивПараметровДвери[1], МассивПараметровДвери[2], Число(МассивПараметровДвери[3]), Число(МассивПараметровДвери[4]), Отказ);
	
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
	
КонецФункции	

Процедура ЗаполнитьТЧ(Ссылка, Профили, Заливки, Гравировки, КоличествоПерехлестов, КоличествоШлегель, Отказ)
	
	СписокНоменклатуры = Ссылка.СписокНоменклатуры;
	ВидДвери = Ссылка.ВидДвери;
	Количество = Ссылка.Количество;
	
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
		ЗаполнитьТаблицу(Ссылка, Профили, КоличествоПерехлестов, КоличествоШлегель, КоличествоСтрок);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Заливки) Тогда
		ЗаполнитьЗаливками(Ссылка, Заливки, Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Гравировки) Тогда
		ЗаполнитьГравировками(Ссылка, Гравировки);
	КонецЕсли;
	
	//Добавим стопор
	Если ВидДвери = Перечисления.ВидыДверей.Раздвижная Тогда
		НоваяСтрока = СписокНоменклатуры.Добавить();
		НоваяСтрока.Номенклатура = Справочники.Номенклатура.СтопорНижнийМетал;
		НоваяСтрока.Количество = Количество;
	КонецЕсли;
	
	//Добавить услугу для сборки двери
	НоваяСтрока = СписокНоменклатуры.Добавить();
	НоваяСтрока.Номенклатура = Справочники.Номенклатура.СборкаДвериРаумПлюс;
	НоваяСтрока.Количество = Количество;
	
КонецПроцедуры

Процедура ЗаполнитьТаблицу(Ссылка, Профили, КоличествоПерехлестов, КоличествоШлегель, КоличествоСтрок)
	
	Профиль = Ссылка.Профиль;
	Подразделение = Ссылка.Подразделение;
	СписокНоменклатуры = Ссылка.СписокНоменклатуры;
	ВидДвери = Ссылка.ВидДвери;
	ШиринаПроема = Ссылка.ШиринаПроема;
	Трек = Ссылка.Трек;
	Количество = Ссылка.Количество;
	
	ЗаполнитьШлегели(Ссылка, КоличествоШлегель, КоличествоСтрок);
	
	СтруктураПрофиля = Справочники.Двери.ПолучитьСтруктуруПрофиля(Профиль, Подразделение);
	
	ТрекНижний = "";
	ТрекВерхний = "";
	ТрекНаПоворот = "";
	Колеса_ПоворотнаяСистема = "";
	СменаВидаДвери = Ложь;
	
	КоличествоСтрокВручную = СписокНоменклатуры.Количество();
	Если КоличествоСтрокВручную > 0 Тогда
		Для Индекс = 1 По КоличествоСтрокВручную Цикл
			Элемент = СписокНоменклатуры[КоличествоСтрокВручную - Индекс];
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
		
		//Колеса
		Если ЗначениеЗаполнено(Колеса_ПоворотнаяСистема) ИЛИ КоличествоСтрок = 0 ИЛИ СменаВидаДвери Тогда
			НоваяСтрока = СписокНоменклатуры.Добавить(); 
			НоваяСтрока.Номенклатура = Справочники.Номенклатура.ПоворотнаяСистема;
			НоваяСтрока.Количество = Количество;
			НоваяСтрока.ДобавленоВручную = Истина;
			
			Если ЗначениеЗаполнено(Колеса_ПоворотнаяСистема) И ЗначениеЗаполнено(Колеса_ПоворотнаяСистема.ДополнительныйЭлемент) Тогда
				НоваяСтрока = СписокНоменклатуры.Добавить();
				НоваяСтрока.Номенклатура = Колеса_ПоворотнаяСистема.ДополнительныйЭлемент;
				НоваяСтрока.Количество = Количество * 2;
				НоваяСтрока.ДобавленоВручную = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
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
			
			//Колеса
			Если ЗначениеЗаполнено(Колеса_ПоворотнаяСистема) ИЛИ КоличествоСтрок = 0 ИЛИ СменаВидаДвери Тогда
				НоваяСтрока = СписокНоменклатуры.Добавить(); 
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
	
КонецПроцедуры

Процедура ЗаполнитьШлегели(Ссылка, КоличествоШлегель, КоличествоСтрок) 
	
	СписокНоменклатуры = Ссылка.СписокНоменклатуры;	
	Профиль = Ссылка.Профиль;
	Количество = Ссылка.Количество;
	ВысотаПроема = Ссылка.ВысотаПроема;
	
	// заполняем шлегели
	ЦветПрофиля = Профиль.Цвет;
	Если ЦветПрофиля = Справочники.Цвета.Бук ИЛИ ЦветПрофиля = Справочники.Цвета.Вишня ИЛИ ЦветПрофиля = Справочники.Цвета.Золото Тогда
		Шлегель = Справочники.Номенклатура.ШлегельЗолото;
	ИначеЕсли ЦветПрофиля = Справочники.Цвета.Венге ИЛИ ЦветПрофиля = Справочники.Цвета.ОрехИталия Тогда
		Шлегель = Справочники.Номенклатура.ШлегельВенге;
	ИначеЕсли ЦветПрофиля = Справочники.Цвета.Хром ИЛИ ЦветПрофиля = Справочники.Цвета.Шампань Тогда
		Шлегель = Справочники.Номенклатура.ШлегельХром;
	ИначеЕсли ЦветПрофиля = Справочники.Цвета.ДубВыбеленный Тогда
		Шлегель = Справочники.Номенклатура.ШлегельБелый;
	КонецЕсли;
	
	Если КоличествоСтрок = 0 Тогда
		НоваяСтрока = СписокНоменклатуры.Вставить(0);
		НоваяСтрока.Номенклатура = Шлегель;
		НоваяСтрока.Ширина = ?(Количество >= 3, Количество + 2, Количество * 2) * ВысотаПроема;
		НоваяСтрока.Количество = 1;
		НоваяСтрока.ДобавленоВручную = Истина;
	Иначе
		Для Каждого Элемент Из СписокНоменклатуры Цикл
			Если Элемент.Номенклатура = Справочники.Номенклатура.ШлегельВенге 
				ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.ШлегельХром 
				ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.ШлегельЗолото
				ИЛИ Элемент.Номенклатура = Справочники.Номенклатура.ШлегельБелый Тогда
				//Элемент.Номенклатура = Шлегель;
				Элемент.Количество = 1;
				Если ЗначениеЗаполнено(КоличествоШлегель) Тогда
					Элемент.Ширина = КоличествоШлегель;
				Иначе
					Элемент.Ширина = ?(Количество >= 3, Количество + 2, Количество * 2) * ВысотаПроема;
					КоличествоШлегель = Неопределено;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьЗаливками(Ссылка, Заливки, Отказ)
	
	Профиль = Ссылка.Профиль;
	СписокНоменклатуры = Ссылка.СписокНоменклатуры;
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
		
		//В зависимости от значение Глубины и Паза профиля, добовляем услугу Фрезеровка, материал Уплотнитель
		Глубина = Параметр.ГлубинаДетали;
		ПазПрофиля = Профиль.ШиринаПаза;
		ДобавитьУплотнитель = Ложь;
		ДобавитьФрезеровку = Ложь;
		Если ЗначениеЗаполнено(ПазПрофиля) И ЗначениеЗаполнено(Глубина) Тогда
			
			Если Глубина > ПазПрофиля Тогда
				ДобавитьФрезеровку = Истина;
			ИначеЕсли Глубина < ПазПрофиля Тогда
				ДобавитьУплотнитель = Истина;
			КонецЕсли;
			
			Если ДобавитьУплотнитель Тогда
				НоваяСтрока = СписокНоменклатуры.Добавить();
				НоваяСтрока.Номенклатура = Справочники.Номенклатура.Уплотнитель4мм;
				НоваяСтрока.Количество = 1;
				НоваяСтрока.Ширина = ПериметрДетали;
				Если Глубина <> 4 Тогда
					ДобавитьФрезеровку = Истина;
				КонецЕсли;
			КонецЕсли;
			
			Если ДобавитьФрезеровку Тогда
				НоваяСтрока = СписокНоменклатуры.Добавить();
				НоваяСтрока.Номенклатура = Справочники.Номенклатура.ФрезеровкаЛДСПЗонаДверей;
				НоваяСтрока.Количество = ПериметрДетали / 1000;
			КонецЕсли;
			
		КонецЕсли;
		
		// { Васильев Александр Леонидович [08.11.2013]
		// раскоментировать когда флешка дверей
		// не будет отнимать от стекла единицу
		// } Васильев Александр Леонидович [08.11.2013]
		
		//		ДобавитьВставку(Номенклатура, Параметр, ШиринаВставки-Число(ДобавитьУплотнитель) ,ВысотаВставки-Число(ДобавитьУплотнитель), Истина, Отказ);
		ДобавитьВставку(СписокНоменклатуры, Параметр, ШиринаВставки,ВысотаВставки , Истина, Отказ);
		
		//Для Мебельных щитов добавить Доп Элементы
		Если ЗначениеЗаполнено(Параметр.ДополнительныйЭлемент) Тогда
			
			ДопЭлемент = Параметр.ДополнительныйЭлемент;
			ДобавитьВставку(СписокНоменклатуры, ДопЭлемент, ШиринаВставки ,ВысотаВставки , Ложь, Отказ);
			
		КонецЕсли;
		
		//Для Мебельных щитов добавить Доп услуги
		Если ЗначениеЗаполнено(Параметр.ДополнительнаяУслуга) Тогда
			НоваяСтрока = СписокНоменклатуры.Добавить();
			НоваяСтрока.Номенклатура = Параметр.ДополнительнаяУслуга;
			НоваяСтрока.Количество = 1;
			//У доп услуги по изготовлению сборной вставки 2 доп элемента
			Если Параметр.ДополнительнаяУслуга = Справочники.Номенклатура.ИзготовлениеСборнойВставки Тогда
				ДопЗеркало = Справочники.Номенклатура.Зеркало;
				ДобавитьВставку(СписокНоменклатуры, ДопЗеркало, ШиринаВставки ,ВысотаВставки , Ложь, Отказ);
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
			НоваяСтрока.Номенклатура =КриволинейнаяУслуга;
			НоваяСтрока.Количество = ДлинаКривогоПила / 1000;
		КонецЕсли;
		
	КонецЦикла; // Для Каждого Элемент Из МассивЗаливки Цикл
	
КонецПроцедуры

Процедура ЗаполнитьГравировками(Ссылка, Гравировки)
	
	СписокНоменклатуры = Ссылка.СписокНоменклатуры;
	
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

Функция ДобавитьВставку(СписокНоменклатуры, фНоменклатура, фШиринаВставки ,фВысотаВставки , фЭтоДеталь, фОтказ)
	
	Если ПроверитьРазмерыЗаливки(фНоменклатура, фШиринаВставки ,фВысотаВставки, фОтказ) Тогда
		
		НоваяСтрока = СписокНоменклатуры.Добавить();
		НоваяСтрока.Номенклатура = фНоменклатура;
		НоваяСтрока.Ширина = фШиринаВставки;
		НоваяСтрока.Длина = фВысотаВставки;
		НоваяСтрока.Количество = 1;
		НоваяСтрока.ЭтоДеталь = фЭтоДеталь;
		
	КонецЕсли;
	
КонецФункции

