﻿
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
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	спрНоменклатура.Ссылка,
	|	спрНоменклатура.ШиринаДетали,
	|	спрНоменклатура.ГлубинаПаза,
	|	спрНоменклатура.НоменклатурнаяГруппа
	|ИЗ
	|	Справочник.Номенклатура КАК спрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений КАК НоменклатураПодразделений
	|		ПО (НоменклатураПодразделений.Номенклатура = спрНоменклатура.Ссылка)
	|ГДЕ
	|	спрНоменклатура.Базовый
	|	И спрНоменклатура.Цвет = &Цвет
	|	И НоменклатураПодразделений.Подразделение = &Подразделение
	|	И спрНоменклатура.НоменклатурнаяГруппа В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.АлюминиевыйПрофиль))";
	
	Массив = Новый Массив(8);
	Массив[0] = Профиль.ШиринаДетали;
	Массив[1] = Профиль.ГлубинаПаза;
	СтруктураПрофиля.Вертикальный = Профиль;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.РамкаВерхняя Тогда
			Массив[2] = Выборка.ШиринаДетали;
			Массив[3] = Выборка.ГлубинаПаза;
			СтруктураПрофиля.РамкаВерхняя = Выборка.Ссылка;
		ИначеЕсли Выборка.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.РамкаНижняя Тогда
			Массив[4] = Выборка.ШиринаДетали;
			Массив[5] = Выборка.ГлубинаПаза;
			СтруктураПрофиля.РамкаНижняя = Выборка.Ссылка;
		ИначеЕсли Выборка.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.РамкаСредняяБезКрепления Тогда
			Массив[6] = Выборка.ШиринаДетали;
			Массив[7] = Выборка.ГлубинаПаза;
			СтруктураПрофиля.РамкаСредняяБезКрепления = Выборка.Ссылка;
		ИначеЕсли Выборка.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.РамкаСредняяСКреплением Тогда
			Массив[6] = ?(ЗначениеЗаполнено(Массив[6]), Массив[6], Выборка.ШиринаДетали);
			Массив[7] = ?(ЗначениеЗаполнено(Массив[7]), Массив[7], Выборка.ГлубинаПаза);
			СтруктураПрофиля.РамкаСредняяСКреплением = Выборка.Ссылка;
		ИначеЕсли Выборка.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ТрекВерхний Тогда
			СтруктураПрофиля.ТрекВерхний = Выборка.Ссылка;
		ИначеЕсли Выборка.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ТрекНаПоворотнуюСистему Тогда
			СтруктураПрофиля.ТрекНаПоворотнуюСистему = Выборка.Ссылка;
		ИначеЕсли Выборка.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ТрекНижний Тогда
			СтруктураПрофиля.ТрекНижний = Выборка.Ссылка;
		ИначеЕсли Выборка.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ТрекОднополосныйВерхний Тогда
			СтруктураПрофиля.ТрекОднополосныйВерхний = Выборка.Ссылка;
		ИначеЕсли Выборка.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ТрекОднополосныйНижний Тогда
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

Функция ПолучитьПараметрыВставки(ТолщинаВставки, ТолщинаПазаПрофиля) Экспорт
	
	Уплотнитель = Справочники.Номенклатура.Уплотнитель4мм;
	
	Ответ = Новый Структура;
	Ответ.Вставить("Уплотнитель", Ложь);
	Ответ.Вставить("Фрезеровка", Ложь);
	Ответ.Вставить("ТолщинаУплотнителя", 0);
	
	Если ЗначениеЗаполнено(ТолщинаПазаПрофиля) И ЗначениеЗаполнено(ТолщинаВставки) Тогда
		
		Если ТолщинаВставки > ТолщинаПазаПрофиля Тогда
			
			Ответ.Фрезеровка = Истина;
			
		ИначеЕсли ТолщинаВставки < ТолщинаПазаПрофиля Тогда
			
			Ответ.Уплотнитель = Истина;
			Ответ.ТолщинаУплотнителя = 2 * (Уплотнитель.ГлубинаДетали - Уплотнитель.ГлубинаПаза); // Рома не хочет сам умножать :)
			
			Ответ.Фрезеровка = ТолщинаВставки <> Уплотнитель.ШиринаПаза;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции
