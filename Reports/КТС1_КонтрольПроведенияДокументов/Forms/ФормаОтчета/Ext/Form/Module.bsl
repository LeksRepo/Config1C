﻿
&НаКлиенте
Процедура Сформировать(Команда)
	
	Если ЗначениеЗаполнено(Отчет.Подразделение) Тогда
		ТабличныйДокумент = СформироватьТабличныйДокумент();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьТабличныйДокумент()
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ОриентацияСтраницы=ОриентацияСтраницы.Ландшафт;
	ТабДок.Защита=Истина;
	
	Макет = Отчеты.КтС1_КонтрольПроведенияДокументов.ПолучитьМакет("МакетКТС1");
	
	ОблШапка = Макет.ПолучитьОбласть("Шапка");
	ОблПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");
	ОблНаряд = Макет.ПолучитьОбласть("Наряд");
	ОблУровень2 = Макет.ПолучитьОбласть("Уровень2");
	ОблУровень2Ошибка = Макет.ПолучитьОбласть("Уровень2Ошибка");
	ОблУровень3 = Макет.ПолучитьОбласть("Уровень3");
	ОблУровень3Ошибка = Макет.ПолучитьОбласть("Уровень3Ошибка");
	ОблУровень4 = Макет.ПолучитьОбласть("Уровень4");
	ОблУровень4Ошибка = Макет.ПолучитьОбласть("Уровень4Ошибка");
	
	ОблШапка.Параметры.Период = Формат(Отчет.Период.ДатаНачала, "ДЛФ=DD")+" - "+Формат(Отчет.Период.ДатаОкончания, "ДЛФ=DD");
	ОблШапка.Параметры.Подразделение = Отчет.Подразделение;
	ТабДок.Вывести(ОблШапка);
	
	МассивДокументовВАрхив = Новый Массив();
	МассивДокументовВАрхив.Добавить(Новый Структура("Документ, Наименование","ТребованиеНакладная","Требования накладные"));
	МассивДокументовВАрхив.Добавить(Новый Структура("Документ, Наименование","ПоступлениеМатериаловУслуг","Поступления материалов и услуг"));
	МассивДокументовВАрхив.Добавить(Новый Структура("Документ, Наименование","СписаниеМатериалов","Списания материалов"));
	МассивДокументовВАрхив.Добавить(Новый Структура("Документ, Наименование","АвансовыйОтчет","Авансовые отчеты"));
	МассивДокументовВАрхив.Добавить(Новый Структура("Документ, Наименование","ПеремещениеМатериалов","Перемещения материалов"));
	МассивДокументовВАрхив.Добавить(Новый Структура("Документ, Наименование","Комплектация","Комплектации"));
	МассивДокументовВАрхив.Добавить(Новый Структура("Документ, Наименование","РеализацияМатериалов","Реализации материалов"));
	МассивДокументовВАрхив.Добавить(Новый Структура("Документ, Наименование","РеализацияГотовойПродукции", "Реализация (отгрузка) продукции"));
	
	Первый = Истина;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Отчет.Подразделение);
	Запрос.Текст = "";
	
	Для Каждого Док Из МассивДокументовВАрхив Цикл
		
		Если Запрос.Текст <> "" Тогда
			
			Запрос.Текст = Запрос.Текст +
			"
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|";
			
		КонецЕсли;
		
		Если Первый Тогда
		    Первый = Ложь;
			Запрос.Текст = Запрос.Текст +
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ";
		Иначе
			Запрос.Текст = Запрос.Текст +
			"ВЫБРАТЬ";
		КонецЕсли;
		
		Запрос.Текст = Запрос.Текст +
		"
		|	""%2"" КАК ТипДокумента,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Список.Ссылка) КАК Количество
		|ИЗ
		|	Документ.%1 КАК Список
		|ГДЕ
		|	Список.Проведен
		|	И Список.Подразделение = &Подразделение 
		|	И НЕ Список.СданВАрхив";
		
		Запрос.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Запрос.Текст, Док.Документ, Док.Наименование);
		
	КонецЦикла;
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		ТабДок.Вывести(ОблПустаяСтрока);
		ОблВАрхивШапка = Макет.ПолучитьОбласть("ВАрхивШапка");
		ОблВАрхивСтрока = Макет.ПолучитьОбласть("ВАрхивСтрока");
		ТабДок.Вывести(ОблВАрхивШапка);
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.Количество > 0 Тогда
				ОблВАрхивСтрока.Параметры.Заполнить(Выборка);
				ТабДок.Вывести(ОблВАрхивСтрока);
			КонецЕсли;
			
		КонецЦикла;
		
		ТабДок.Вывести(ОблПустаяСтрока);
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Отчет.Подразделение);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(Отчет.Период.ДатаНачала));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(Отчет.Период.ДатаОкончания));
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫРАЗИТЬ(СписокСпецификаций.Ссылка КАК Документ.НарядЗадание) КАК Наряд,
	|	СписокСпецификаций.Ссылка.ДатаИзготовления КАК НарядДатаИзготовления,
	|	ВЫРАЗИТЬ(СписокСпецификаций.Спецификация КАК Документ.Спецификация) КАК Спецификация
	|ПОМЕСТИТЬ втСписокСпец
	|ИЗ
	|	Документ.НарядЗадание.СписокСпецификаций КАК СписокСпецификаций
	|ГДЕ
	|	СписокСпецификаций.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И СписокСпецификаций.Ссылка.Подразделение = &Подразделение
	|
	|СГРУППИРОВАТЬ ПО
	|	СписокСпецификаций.Спецификация,
	|	СписокСпецификаций.Ссылка,
	|	СписокСпецификаций.Ссылка.ДатаИзготовления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Остатки.Субконто1 КАК Спецификация,
	|	СУММА(Остатки.КоличествоОстаток) КАК Количество
	|ПОМЕСТИТЬ втОстаткиКомплектации
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.КомплектацииСпецификаций),
	|			,
	|			Субконто1 В
	|				(ВЫБРАТЬ
	|					Список.Спецификация
	|				ИЗ
	|					втСписокСпец КАК Список)) КАК Остатки
	|
	|СГРУППИРОВАТЬ ПО
	|	Остатки.Субконто1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокСпецификаций.Наряд КАК Наряд,
	|	СписокСпецификаций.НарядДатаИзготовления КАК НарядДатаИзготовления,
	|	СписокСпецификаций.Спецификация КАК Спецификация,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(СкладГотовойПродукции.Номенклатура) > 0
	|			ТОГДА ВЫБОР
	|					КОГДА Комплектация.Ссылка ЕСТЬ NULL 
	|						ТОГДА ""Комплектация не создана""
	|					ИНАЧЕ Комплектация.Ссылка
	|				КОНЕЦ
	|		ИНАЧЕ ""НеТребуется""
	|	КОНЕЦ КАК Комплектация,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(СкладГотовойПродукции.Номенклатура) > 0
	|			ТОГДА ВЫБОР
	|					КОГДА Комплектация.Ссылка ЕСТЬ NULL 
	|						ТОГДА """"
	|					ИНАЧЕ Комплектация.ДатаСоздания
	|				КОНЕЦ
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК КомплектацияДатаСоздания,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(СкладГотовойПродукции.Номенклатура) > 0
	|			ТОГДА ВЫБОР
	|					КОГДА Комплектация.Ссылка ЕСТЬ NULL 
	|						ТОГДА """"
	|					ИНАЧЕ Комплектация.Дата
	|				КОНЕЦ
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК КомплектацияДатаДокумента,
	|	Комплектация.Проведен КАК КомплектацияПроведен,
	|	ЕСТЬNULL(ОстаткиКомплектации.Количество, 0) КАК ОстатокКоличество
	|ИЗ
	|	втСписокСпец КАК СписокСпецификаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Комплектация КАК Комплектация
	|		ПО СписокСпецификаций.Спецификация = Комплектация.Спецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СкладГотовойПродукции КАК СкладГотовойПродукции
	|		ПО СписокСпецификаций.Спецификация = СкладГотовойПродукции.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстаткиКомплектации КАК ОстаткиКомплектации
	|		ПО СписокСпецификаций.Спецификация = ОстаткиКомплектации.Спецификация
	|ГДЕ
	|	НЕ Комплектация.ПометкаУдаления
	|
	|СГРУППИРОВАТЬ ПО
	|	СписокСпецификаций.Наряд,
	|	СписокСпецификаций.Спецификация,
	|	Комплектация.Ссылка,
	|	Комплектация.Проведен,
	|	СписокСпецификаций.НарядДатаИзготовления,
	|	ОстаткиКомплектации.Количество,
	|	Комплектация.ДатаСоздания,
	|	Комплектация.Дата
	|
	|УПОРЯДОЧИТЬ ПО
	|	СписокСпецификаций.Наряд.Номер,
	|	СписокСпецификаций.Спецификация.Номер
	|ИТОГИ
	|	СУММА(ОстатокКоличество)
	|ПО
	|	Наряд,
	|	Спецификация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НарядЗадание.Ссылка КАК Наряд,
	|	ОперативныйЗакуп.Ссылка КАК Закуп,
	|	ОперативныйЗакуп.Ссылка.ДатаСоздания КАК ДатаСоздания,
	|	ОперативныйЗакуп.Ссылка.Дата КАК ДатаДокумента
	|ИЗ
	|	Документ.НарядЗадание КАК НарядЗадание
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОперативныйЗакуп.НарядЗадания КАК ОперативныйЗакуп
	|		ПО НарядЗадание.Ссылка = ОперативныйЗакуп.Наряд
	|ГДЕ
	|	НарядЗадание.ДатаИзготовления МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НарядЗадание.Подразделение = &Подразделение
	|	И НЕ ОперативныйЗакуп.Ссылка.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОперативныйЗакуп.Ссылка.Номер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НарядЗадание2.Ссылка КАК Наряд,
	|	Требование.Ссылка КАК Требование,
	|	Требование.Проведен КАК Проведен,
	|	Требование.ДатаСоздания КАК ДатаСоздания,
	|	Требование.Дата КАК ДатаДокумента
	|ИЗ
	|	Документ.НарядЗадание КАК НарядЗадание2
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ТребованиеНакладная КАК Требование
	|		ПО НарядЗадание2.Ссылка = Требование.НарядЗадание
	|ГДЕ
	|	НарядЗадание2.ДатаИзготовления МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НарядЗадание2.Подразделение = &Подразделение
	|	И НЕ Требование.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Требование.Номер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НарядЗадание.Ссылка КАК Наряд,
	|	ОперативныйЗакуп.Ссылка КАК Закуп,
	|	АвансовыйОтчет.Ссылка КАК Авансовый,
	|	АвансовыйОтчет.Проведен КАК Проведен,
	|	АвансовыйОтчет.ДатаСоздания КАК ДатаСоздания,
	|	АвансовыйОтчет.Дата КАК ДатаДокумента
	|ИЗ
	|	Документ.НарядЗадание КАК НарядЗадание
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОперативныйЗакуп.НарядЗадания КАК ОперативныйЗакуп
	|		ПО НарядЗадание.Ссылка = ОперативныйЗакуп.Наряд
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АвансовыйОтчет КАК АвансовыйОтчет
	|		ПО (АвансовыйОтчет.ДокументОснование = ОперативныйЗакуп.Ссылка)
	|ГДЕ
	|	НарядЗадание.ДатаИзготовления МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НарядЗадание.Подразделение = &Подразделение
	|	И НЕ АвансовыйОтчет.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОперативныйЗакуп.Ссылка.Номер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОперативныйЗакуп.Ссылка КАК Закуп,
	|	Поступление.Ссылка КАК Поступление,
	|	Поступление.Проведен КАК Проведен,
	|	Поступление.ДатаСоздания КАК ДатаСоздания,
	|	Поступление.Дата КАК ДатаДокумента
	|ИЗ
	|	Документ.НарядЗадание КАК НарядЗадание
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОперативныйЗакуп.НарядЗадания КАК ОперативныйЗакуп
	|		ПО НарядЗадание.Ссылка = ОперативныйЗакуп.Наряд
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеМатериаловУслуг КАК Поступление
	|		ПО (ОперативныйЗакуп.Ссылка = Поступление.ДокументОснование)
	|ГДЕ
	|	НарядЗадание.ДатаИзготовления МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НарядЗадание.Подразделение = &Подразделение
	|	И НЕ Поступление.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОперативныйЗакуп.Ссылка.Номер";
	
	Результаты = Запрос.ВыполнитьПакет();
	РезультатОсновной = Результаты[2];
	
	Если НЕ РезультатОсновной.Пустой() Тогда
		
		ОперативныеЗакупы = Результаты[3].Выгрузить();
		Требования = Результаты[4].Выгрузить();
		Авансовые = Результаты[5].Выгрузить();
		Послупления = Результаты[6].Выгрузить();
		
		ВыборкаНаряд = РезультатОсновной.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаНаряд.Следующий() Цикл
			
			ОблНаряд.Параметры.Наряд = "" + ВыборкаНаряд.Наряд + " ( изготовление "+Формат(ВыборкаНаряд.Наряд.ДатаИзготовления,"ДФ=dd.MM.yy")+" )";
			ОблНаряд.Параметры.Рас = ВыборкаНаряд.Наряд;
			ТабДок.Вывести(ОблПустаяСтрока);
			ТабДок.Вывести(ОблНаряд);
			
			Отбор = Новый Структура();
			Отбор.Вставить("Наряд", ВыборкаНаряд.Наряд);
			
			Мас = ОперативныеЗакупы.НайтиСтроки(Отбор);
			ЕстьЗакупы = Ложь;
			
			Для Каждого Стр ИЗ Мас Цикл
				
				Если ЗначениеЗаполнено(Стр.Закуп) Тогда
					
					ОблСтрока = ОблУровень2;
					ОблСтрока.Параметры.Документ = Стр.Закуп;
					
					Если ЗначениеЗаполнено(Стр.ДатаСоздания) Тогда
						ОблСтрока.Параметры.ДатаСоздания = Стр.ДатаСоздания;
					Иначе
						ОблСтрока.Параметры.ДатаСоздания = "";
					КонецЕсли;
					
					Если ЗначениеЗаполнено(Стр.ДатаДокумента) Тогда
						ОблСтрока.Параметры.ДатаДокумента = Стр.ДатаДокумента;
					Иначе
						ОблСтрока.Параметры.ДатаДокумента = "";
					КонецЕсли;
					
					ОблСтрока.Параметры.Рас = Стр.Закуп;
					ТабДок.Вывести(ОблСтрока);
					ЕстьЗакупы = Истина;
					
					Отбор2 = Новый Структура();
					Отбор2.Вставить("Закуп", Стр.Закуп);
					
					Мас2 = Авансовые.НайтиСтроки(Отбор2);
					
					Для Каждого Стр2 ИЗ Мас2 Цикл
						
						Если ЗначениеЗаполнено(Стр2.Авансовый) Тогда
							
							Если Стр2.Проведен Тогда
								ОблСтрока = ОблУровень3;
							Иначе
								ОблСтрока = ОблУровень3Ошибка;
							КонецЕсли;
							
							ОблСтрока.Параметры.Документ = Стр2.Авансовый;
							
							Если ЗначениеЗаполнено(Стр2.ДатаСоздания) Тогда
								ОблСтрока.Параметры.ДатаСоздания = Стр2.ДатаСоздания;
							Иначе
								ОблСтрока.Параметры.ДатаСоздания = "";
							КонецЕсли;
							
							Если ЗначениеЗаполнено(Стр2.ДатаДокумента) Тогда
								ОблСтрока.Параметры.ДатаДокумента = Стр2.ДатаДокумента;
							Иначе
								ОблСтрока.Параметры.ДатаДокумента = "";
							КонецЕсли;
							
							ОблСтрока.Параметры.Рас = Стр2.Авансовый;
							ТабДок.Вывести(ОблСтрока);
							
						КонецЕсли;
						
					КонецЦикла;
					
					Отбор2 = Новый Структура();
					Отбор2.Вставить("Закуп", Стр.Закуп);
					
					Мас2 = Послупления.НайтиСтроки(Отбор2);
					
					Для Каждого Стр2 ИЗ Мас2 Цикл
						
						Если ЗначениеЗаполнено(Стр2.Поступление) Тогда
							
							Если Стр2.Проведен Тогда
								ОблСтрока = ОблУровень3;
							Иначе
								ОблСтрока = ОблУровень3Ошибка;
							КонецЕсли;
							
							ОблСтрока.Параметры.Документ = Стр2.Поступление;
							
							Если ЗначениеЗаполнено(Стр2.ДатаСоздания) Тогда
								ОблСтрока.Параметры.ДатаСоздания = Стр2.ДатаСоздания;
							Иначе
								ОблСтрока.Параметры.ДатаСоздания = "";
							КонецЕсли;
							
							Если ЗначениеЗаполнено(Стр2.ДатаДокумента) Тогда
								ОблСтрока.Параметры.ДатаДокумента = Стр2.ДатаДокумента;
							Иначе
								ОблСтрока.Параметры.ДатаДокумента = "";
							КонецЕсли;
							
							ОблСтрока.Параметры.Рас = Стр2.Поступление;
							ТабДок.Вывести(ОблСтрока);
							
						КонецЕсли;
						
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Мас = Требования.НайтиСтроки(Отбор);
			ЕстьТребования = Ложь;
			
			Для Каждого Стр ИЗ Мас Цикл
				
				Если ЗначениеЗаполнено(Стр.Требование) Тогда
					
					Если Стр.Проведен Тогда
						ОблСтрока = ОблУровень2;
					Иначе
						ОблСтрока = ОблУровень2Ошибка;
					КонецЕсли;
					
					ОблСтрока.Параметры.Документ = Стр.Требование;
					
					Если ЗначениеЗаполнено(Стр.ДатаСоздания) Тогда
						ОблСтрока.Параметры.ДатаСоздания = Стр.ДатаСоздания;
					Иначе
						ОблСтрока.Параметры.ДатаСоздания = "";
					КонецЕсли;
					
					Если ЗначениеЗаполнено(Стр.ДатаДокумента) Тогда
						ОблСтрока.Параметры.ДатаДокумента = Стр.ДатаДокумента;
					Иначе
						ОблСтрока.Параметры.ДатаДокумента = "";
					КонецЕсли;
					
					ОблСтрока.Параметры.Рас = Стр.Требование;
					ТабДок.Вывести(ОблСтрока);
					
					ЕстьТребования = Истина;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если ЕстьЗакупы И НЕ ЕстьТребования Тогда
				
				ОблУровень2Ошибка.Параметры.Документ = "Требования накладные не созданы";
				ОблУровень2Ошибка.Параметры.Рас = Неопределено;
				ТабДок.Вывести(ОблУровень2Ошибка);
				
			КонецЕсли;
			
			ВыборкаСпец = ВыборкаНаряд.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаСпец.Следующий() Цикл
				
				СпецСтрока = ОблУровень3;
				
				Если ВыборкаСпец.ОстатокКоличество > 0 Тогда
					СпецСтрока = ОблУровень3Ошибка;
					СпецСтрока.Параметры.Документ = "" + ВыборкаСпец.Спецификация + " ( не скомплектована полностью )";
				Иначе
					СпецСтрока.Параметры.Документ = ВыборкаСпец.Спецификация;
				КонецЕсли;
				
				СпецСтрока.Параметры.Рас = ВыборкаСпец.Спецификация;
				ТабДок.Вывести(СпецСтрока);
				
				ВыборкаКомплектация = ВыборкаСпец.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока ВыборкаКомплектация.Следующий() Цикл
					
					Если НЕ (ВыборкаКомплектация.Комплектация = "НеТребуется") Тогда
						
						Если ВыборкаКомплектация.Комплектация = "Комплектация не создана" Тогда
							ОблСтрока = ОблУровень4Ошибка;
						Иначе
							
							Если НЕ ВыборкаКомплектация.КомплектацияПроведен Тогда
								ОблСтрока = ОблУровень4Ошибка;
							Иначе
								ОблСтрока = ОблУровень4;
							КонецЕсли;
							
							ОблСтрока.Параметры.Рас = ВыборкаКомплектация.Комплектация;
							
						КонецЕсли;
						
						ОблСтрока.Параметры.Документ = ВыборкаКомплектация.Комплектация;
						
						Если ЗначениеЗаполнено(ВыборкаКомплектация.КомплектацияДатаСоздания) Тогда
							ОблСтрока.Параметры.ДатаСоздания = ВыборкаКомплектация.КомплектацияДатаСоздания;
						Иначе
							ОблСтрока.Параметры.ДатаСоздания = "";
						КонецЕсли;
						
						Если ЗначениеЗаполнено(ВыборкаКомплектация.КомплектацияДатаДокумента) Тогда
							ОблСтрока.Параметры.ДатаДокумента = ВыборкаКомплектация.КомплектацияДатаДокумента;
						Иначе
							ОблСтрока.Параметры.ДатаДокумента = "";
						КонецЕсли;
						
						ТабДок.Вывести(ОблСтрока);
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ТабДок;
	
КонецФункции
