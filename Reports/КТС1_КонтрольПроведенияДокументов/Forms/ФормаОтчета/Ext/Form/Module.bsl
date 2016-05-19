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
	
	Макет = Отчеты.КТС1_КонтрольПроведенияДокументов.ПолучитьМакет("МакетКТС1");
	
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
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Отчет.Подразделение);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(Отчет.Период.ДатаНачала));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(Отчет.Период.ДатаОкончания));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокСпецификаций.Ссылка КАК Наряд,
	|	СписокСпецификаций.Ссылка.ДатаИзготовления КАК НарядДатаИзготовления,
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
	|	Комплектация.Проведен КАК КомплектацияПроведен
	|ИЗ
	|	Документ.НарядЗадание.СписокСпецификаций КАК СписокСпецификаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Комплектация КАК Комплектация
	|		ПО СписокСпецификаций.Спецификация = Комплектация.Спецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СкладГотовойПродукции КАК СкладГотовойПродукции
	|		ПО СписокСпецификаций.Спецификация = СкладГотовойПродукции.Ссылка
	|ГДЕ
	|	СписокСпецификаций.Ссылка.ДатаИзготовления МЕЖДУ &НачалоПериода И &КонецПериода
	|	И СписокСпецификаций.Ссылка.Подразделение = &Подразделение
	|
	|СГРУППИРОВАТЬ ПО
	|	СписокСпецификаций.Ссылка,
	|	СписокСпецификаций.Спецификация,
	|	Комплектация.Ссылка,
	|	Комплектация.Проведен,
	|	Комплектация.ДатаСоздания
	|
	|УПОРЯДОЧИТЬ ПО
	|	СписокСпецификаций.Ссылка.Номер,
	|	СписокСпецификаций.Спецификация.Номер
	|ИТОГИ ПО
	|	Наряд
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НарядЗадание.Ссылка КАК Наряд,
	|	ОперативныйЗакуп.Ссылка КАК Закуп,
	|	ОперативныйЗакуп.Ссылка.ДатаСоздания КАК ДатаСоздания
	|ИЗ
	|	Документ.НарядЗадание КАК НарядЗадание
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОперативныйЗакуп.НарядЗадания КАК ОперативныйЗакуп
	|		ПО НарядЗадание.Ссылка = ОперативныйЗакуп.Наряд
	|ГДЕ
	|	НарядЗадание.ДатаИзготовления МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НарядЗадание.Подразделение = &Подразделение
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
	|	Требование.ДатаСоздания КАК ДатаСоздания
	|ИЗ
	|	Документ.НарядЗадание КАК НарядЗадание2
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ТребованиеНакладная КАК Требование
	|		ПО НарядЗадание2.Ссылка = Требование.НарядЗадание
	|ГДЕ
	|	НарядЗадание2.ДатаИзготовления МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НарядЗадание2.Подразделение = &Подразделение
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
	|	АвансовыйОтчет.ДатаСоздания КАК ДатаСоздания
	|ИЗ
	|	Документ.НарядЗадание КАК НарядЗадание
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОперативныйЗакуп.НарядЗадания КАК ОперативныйЗакуп
	|		ПО НарядЗадание.Ссылка = ОперативныйЗакуп.Наряд
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АвансовыйОтчет КАК АвансовыйОтчет
	|		ПО (АвансовыйОтчет.ДокументОснование = ОперативныйЗакуп.Ссылка)
	|ГДЕ
	|	НарядЗадание.ДатаИзготовления МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НарядЗадание.Подразделение = &Подразделение
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
	|	Поступление.ДатаСоздания КАК ДатаСоздания
	|ИЗ
	|	Документ.НарядЗадание КАК НарядЗадание
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОперативныйЗакуп.НарядЗадания КАК ОперативныйЗакуп
	|		ПО НарядЗадание.Ссылка = ОперативныйЗакуп.Наряд
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеМатериаловУслуг КАК Поступление
	|		ПО (ОперативныйЗакуп.Ссылка = Поступление.ДокументОснование)
	|ГДЕ
	|	НарядЗадание.ДатаИзготовления МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НарядЗадание.Подразделение = &Подразделение
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОперативныйЗакуп.Ссылка.Номер";
		
	Результаты = Запрос.ВыполнитьПакет();
	РезультатОсновной = Результаты[0];
	
	Если НЕ РезультатОсновной.Пустой() Тогда
		
		ОперативныеЗакупы = Результаты[1].Выгрузить();
		Требования = Результаты[2].Выгрузить();
		Авансовые = Результаты[3].Выгрузить();
		Послупления = Результаты[4].Выгрузить();
	
		ВыборкаНаряд = РезультатОсновной.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаНаряд.Следующий() Цикл
			
			ОблНаряд.Параметры.Наряд = "Наряд задание №" + ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаНаряд.Наряд.Номер) + " ( изготовление "+Формат(ВыборкаНаряд.НарядДатаИзготовления,"ДЛФ=DD")+" )";
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
				
				 ОблУровень3.Параметры.Документ = ВыборкаСпец.Спецификация;
				 ОблУровень3.Параметры.Рас = ВыборкаСпец.Спецификация;
				 ТабДок.Вывести(ОблУровень3);
				 
				 Если НЕ (ВыборкаСпец.Комплектация = "НеТребуется") Тогда
				 
					Если ВыборкаСпец.Комплектация = "Комплектация не создана" Тогда
						ОблСтрока = ОблУровень4Ошибка; 	 
					Иначе
						
						Если НЕ ВыборкаСпец.КомплектацияПроведен Тогда
							ОблСтрока = ОблУровень4Ошибка;
					    Иначе
							ОблСтрока = ОблУровень4;
						КонецЕсли;
						
						ОблСтрока.Параметры.Рас = ВыборкаСпец.Комплектация;
						
					КонецЕсли;
					
					ОблСтрока.Параметры.Документ = ВыборкаСпец.Комплектация;
					
					Если ЗначениеЗаполнено(ВыборкаСпец.КомплектацияДатаСоздания) Тогда
						ОблСтрока.Параметры.ДатаСоздания = ВыборкаСпец.КомплектацияДатаСоздания;
					Иначе
						ОблСтрока.Параметры.ДатаСоздания = "";
					КонецЕсли;
					
					ТабДок.Вывести(ОблСтрока);
					
				 КонецЕсли;	
							
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
			
	Возврат ТабДок;
	
КонецФункции
