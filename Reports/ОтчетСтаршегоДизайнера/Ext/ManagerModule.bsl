﻿
Функция СформироватьОтчет(ПараметрыОтчета) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ПолеСверху = 5;
	ТабДок.ПолеСлева = 5;
	ТабДок.ПолеСнизу = 5;
	ТабДок.ПолеСправа = 5;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет = Отчеты.ОтчетСтаршегоДизайнера.ПолучитьМакет("Макет");
	
	ОбластьШапкаДоговоры = Макет.ПолучитьОбласть("ШапкаДоговоры");
	ОбластьСтрокаДоговоры = Макет.ПолучитьОбласть("СтрокаДоговоры");
	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");
	ОбластьШапка = Макет.ПолучитьОбласть("ШапкаОбщ");
	ОбластьШапкаЗамеры = Макет.ПолучитьОбласть("ШапкаЗамерыОбщ");
	ОбластьСтрокаЗамеры = Макет.ПолучитьОбласть("СтрокаЗамерыОбщ");
	ОбластьШапкаМонтаж = Макет.ПолучитьОбласть("ШапкаМонтажОбщ");
	ОбластьСтрокаМонтаж = Макет.ПолучитьОбласть("СтрокаМонтажОбщ");
	ОбластьШапкаАкт = Макет.ПолучитьОбласть("ШапкаАкт");
	ОбластьСтрокаАкт = Макет.ПолучитьОбласть("СтрокаАкт");
	ОбластьШапкаПеределка = Макет.ПолучитьОбласть("ШапкаПеределки");
	ОбластьСтрокаПеределка = Макет.ПолучитьОбласть("СтрокаПеределки");
	ОбластьШапкаПлан = Макет.ПолучитьОбласть("ШапкаПлан");
	ОбластьСтрокаПлан = Макет.ПолучитьОбласть("СтрокаПлан");
	
	ОбластьШапкаДоговорыБезМонтажа = Макет.ПолучитьОбласть("ШапкаДоговорыБезМонтажа");
	ОбластьСтрокаДоговорыБезМонтажа = Макет.ПолучитьОбласть("СтрокаДоговорыБезМонтажа");
	
	Запрос = ПолучитьЗапрос(ПараметрыОтчета);
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ОбластьШапка.Параметры.ДатаОтчета = Формат(ТекущаяДата(), "ДЛФ=DD");
	ОбластьШапка.Параметры.Замерщик = ПараметрыОтчета.СтаршийДизайнер;
	ТабДок.Вывести(ОбластьШапка);
	
	Пока Выборка.Следующий() Цикл
		
		ВидОтчета = Выборка.Вид;
		
		ЭтоЗамеры = ВидОтчета = "Замер";
		ЭтоМонтаж = ВидОтчета = "Монтаж";
		ЭтоАкт = ВидОтчета = "Акт"; 
		ЭтоПеределка = ВидОтчета = "Переделка";
		ЭтоПлан = ВидОтчета = "План";
		ЭтоДоговорыБезМонтажа = ВидОтчета = "ДоговорыБезМонтажа";
		
		//RonEXI: Таблицу с планом временнно отрубить.
		Если ЭтоПлан Тогда
			 Продолжить;
		КонецЕсли;
		
		ТабДок.Вывести(ОбластьПустаяСтрока);
		
		Если ЭтоЗамеры Тогда
			ТабДок.Вывести(ОбластьШапкаЗамеры);
		ИначеЕсли ЭтоПлан Тогда
			ТабДок.Вывести(ОбластьШапкаПлан);
		ИначеЕсли ЭтоМонтаж Тогда
			ТабДок.Вывести(ОбластьШапкаМонтаж);
		ИначеЕсли ЭтоАкт Тогда
			ТабДок.Вывести(ОбластьШапкаАкт);
		ИначеЕсли ЭтоПеределка Тогда
			ТабДок.Вывести(ОбластьШапкаПеределка);
		ИначеЕсли ЭтоДоговорыБезМонтажа Тогда
			ТабДок.Вывести(ОбластьШапкаДоговорыБезМонтажа);
		КонецЕсли;
		
		ВыборкаПоСотрудникам = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПоСотрудникам.Следующий() Цикл
			
			Если ЭтоЗамеры Тогда
				
				ОбластьСтрокаЗамеры = Макет.ПолучитьОбласть("СтрокаЗамерыОбщ");
				
				ОбластьСтрокаЗамеры.Параметры.Заполнить(ВыборкаПоСотрудникам);

				ОбластьСтрокаЗамеры.Параметры.ДатаЗамера = Формат(ВыборкаПоСотрудникам.ДатаЗамера,"ДФ='dd.MM.yy Ч:mm'");
				ОбластьСтрокаЗамеры.Параметры.РасшифровкаАдрес = Новый Структура("РасшифровкаАдрес", ВыборкаПоСотрудникам.Предмет);
				ОбластьСтрокаЗамеры.Параметры.РасшифровкаЗамер = Новый Структура("РасшифровкаАдрес", ВыборкаПоСотрудникам.Предмет);
				ОбластьСтрокаЗамеры.Параметры.СтатусЗамеры = "";
				
				Если ЗначениеЗаполнено(ВыборкаПоСотрудникам.Заметка) И ВыборкаПоСотрудникам.Заметка Тогда
					ОбластьСтрокаЗамеры.Параметры.РасшифровкаЗаметка = Новый Структура("Заметка, Предмет", ВыборкаПоСотрудникам.Заметка, ВыборкаПоСотрудникам.Предмет);
				Иначе
					ОбластьСтрокаЗамеры.Параметры.РасшифровкаЗаметка = Неопределено;
				КонецЕсли;
				
				//Встреча прошла					
				Если ЗначениеЗаполнено(ВыборкаПоСотрудникам.ДатаВстречи) 
				   И НачалоДня(ВыборкаПоСотрудникам.ДатаВстречи) < НачалоДня(ТекущаяДата()) Тогда  
					
					 ОбластьСтрокаЗамеры.Области.ОбластьДатаВстречи.ЦветТекста = Новый Цвет(252,0,0);
					
				КонецЕсли;
				
				//Прошел месяц от замера
				Если НачалоДня(ВыборкаПоСотрудникам.ДатаЗамера) < НачалоДня(ДобавитьМесяц(ТекущаяДата(), -1)) Тогда
					ОбластьСтрокаЗамеры.Области.ОбластьБольшеМесяца.ЦветТекста = Новый Цвет(252,0,0);
				КонецЕсли;
				
				//Сегодня замер
				Если НачалоДня(ВыборкаПоСотрудникам.ДатаЗамера) = НачалоДня(ТекущаяДата()) Тогда					
					ОбластьСтрокаЗамеры.Параметры.СтатусЗамеры = "Замер";
					ОбластьСтрокаЗамеры.Области.СтрокаЗамерыОбщ.Шрифт = Новый Шрифт(,9,Истина);					
				КонецЕсли;
								
				//Сегодня встреча
				Если ЗначениеЗаполнено(ВыборкаПоСотрудникам.ДатаВстречи) Тогда
					Если НачалоДня(ВыборкаПоСотрудникам.ДатаВстречи) = НачалоДня(ТекущаяДата()) Тогда
						
						Если ВыборкаПоСотрудникам.Встреча.Звонок Тогда
							ОбластьСтрокаЗамеры.Параметры.СтатусЗамеры = "Звонок";
						Иначе
							ОбластьСтрокаЗамеры.Параметры.СтатусЗамеры = "Встреча";
						КонецЕсли;
						
						ОбластьСтрокаЗамеры.Области.СтрокаЗамерыОбщ.Шрифт = Новый Шрифт(,9,Истина,Истина);
					КонецЕсли;
				КонецЕсли;
				
				ТабДок.Вывести(ОбластьСтрокаЗамеры);
				
				ОбластьСтрокаЗамеры.Области.СтрокаЗамерыОбщ.ЦветТекста = Новый Цвет(0,0,0);
				ОбластьСтрокаЗамеры.Области.СтрокаЗамерыОбщ.Шрифт = Новый Шрифт(,8,Ложь,Ложь);
				
			ИначеЕсли ЭтоПлан Тогда
				
				ОбластьСтрокаПлан.Параметры.Заполнить(ВыборкаПоСотрудникам);
				Если ЗначениеЗаполнено(ВыборкаПоСотрудникам.ОтклонениеПлана) И ВыборкаПоСотрудникам.ОтклонениеПлана < 0 Тогда
					ОбластьСтрокаПлан.Области.СтрокаПлан.ЦветТекста = Новый Цвет(252,0,0);
				КонецЕсли;
				
				ТабДок.Вывести(ОбластьСтрокаПлан);
				ОбластьСтрокаПлан.Области.СтрокаПлан.ЦветТекста = Новый Цвет(0,0,0);
				
			ИначеЕсли ЭтоМонтаж Тогда
				
				ОбластьСтрокаМонтаж.Параметры.Заполнить(ВыборкаПоСотрудникам);
				ОбластьСтрокаМонтаж.Параметры.РасшифровкаАдрес = Новый Структура("РасшифровкаАдрес", ВыборкаПоСотрудникам.Предмет);
				ОбластьСтрокаМонтаж.Параметры.Изделие = Строка(ВыборкаПоСотрудникам.Изделие) + "(" + ВыборкаПоСотрудникам.МетровЛДСП + " м2)";
				
				СтатусСпецификации = ?(ВыборкаПоСотрудникам.РазницаДат < 4, Строка(ВыборкаПоСотрудникам.Статус) + " (НР- " + ВыборкаПоСотрудникам.ДатаРазмещения + ")", Строка(ВыборкаПоСотрудникам.Статус));
				ОбластьСтрокаМонтаж.Параметры.Статус = СтатусСпецификации;
				
				Если ЗначениеЗаполнено(ВыборкаПоСотрудникам.Заметка) И ВыборкаПоСотрудникам.Заметка Тогда
					ОбластьСтрокаМонтаж.Параметры.РасшифровкаЗаметка = Новый Структура("Заметка, Предмет", ВыборкаПоСотрудникам.Заметка, ВыборкаПоСотрудникам.Предмет);
				Иначе
					ОбластьСтрокаМонтаж.Параметры.РасшифровкаЗаметка = Неопределено;
				КонецЕсли;
				
				Если НачалоДня(ВыборкаПоСотрудникам.ДатаМонтажа) = НачалоДня(ТекущаяДата()) Тогда
					ОбластьСтрокаМонтаж.Области.СтрокаМонтажОбщ.Шрифт = Новый Шрифт(, 9, Истина);
				ИначеЕсли НачалоДня(ВыборкаПоСотрудникам.ДатаМонтажа) < НачалоДня(ТекущаяДата())
					ИЛИ Найти(СтатусСпецификации,"(НР") > 0 Тогда
					ОбластьСтрокаМонтаж.Области.СтрокаМонтажОбщ.ЦветТекста = Новый Цвет(252, 0, 0);
				КонецЕсли;
				
				ТабДок.Вывести(ОбластьСтрокаМонтаж);
				
				ОбластьСтрокаМонтаж.Области.СтрокаМонтажОбщ.ЦветТекста = Новый Цвет(0, 0, 0);
				ОбластьСтрокаМонтаж.Области.СтрокаМонтажОбщ.Шрифт = Новый Шрифт(, 8, Ложь, Ложь);
				
			ИначеЕсли ЭтоАкт Тогда
				
				ОбластьСтрокаАкт.Параметры.Заполнить(ВыборкаПоСотрудникам);
				ОбластьСтрокаАкт.Параметры.РасшифровкаАкт = Новый Структура("РасшифровкаАкт", ВыборкаПоСотрудникам.Предмет);; 
				ОбластьСтрокаАкт.Параметры.Предмет = "№ "
				+ ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(ВыборкаПоСотрудникам.Предмет.Номер)
				+ " от "+Формат(ВыборкаПоСотрудникам.Предмет.Дата,"ДФ=dd.MM.yy");
				
				ТабДок.Вывести(ОбластьСтрокаАкт);
				
			ИначеЕсли ЭтоПеределка Тогда
				
				ОбластьСтрокаПеределка.Параметры.Заполнить(ВыборкаПоСотрудникам);
				ОбластьСтрокаПеределка.Параметры.РасшифровкаПеределка = Новый Структура("РасшифровкаДоговор", ВыборкаПоСотрудникам.Предмет);
				ТабДок.Вывести(ОбластьСтрокаПеределка);
				
			ИначеЕсли ЭтоДоговорыБезМонтажа Тогда
				
				ОбластьСтрокаДоговорыБезМонтажа.Параметры.Заполнить(ВыборкаПоСотрудникам);
				ОбластьСтрокаДоговорыБезМонтажа.Параметры.Предмет = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(ВыборкаПоСотрудникам.Предмет.Номер) + " от " + Формат(ВыборкаПоСотрудникам.Предмет.Дата,"ДФ=dd.MM.yy");
				
				ОбластьСтрокаДоговорыБезМонтажа.Параметры.РасшифровкаДоговор = Новый Структура("РасшифровкаДоговор", ВыборкаПоСотрудникам.Предмет);
				ОбластьСтрокаДоговорыБезМонтажа.Параметры.Ответственный = ВыборкаПоСотрудникам.Ответственный.Фамилия + " " + Лев(ВыборкаПоСотрудникам.Ответственный.Имя, 1) + ". " + Лев(ВыборкаПоСотрудникам.Ответственный.Отчество, 1) + ".";
				
				ТабДок.Вывести(ОбластьСтрокаДоговорыБезМонтажа);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ДополнитьПросроченнымиОплатами(ТабДок, ПараметрыОтчета.Подразделение);
	
	Возврат ТабДок;
	
КонецФункции

Функция ДополнитьПросроченнымиОплатами(фнТабДок, фнПодразделение)
	
	Макет = Отчеты.ОтчетСтаршегоДизайнера.ПолучитьМакет("Макет");
	
	ОбластьШапкаДоговоры = Макет.ПолучитьОбласть("ШапкаДоговоры");
	ОбластьСтрокаДоговоры = Макет.ПолучитьОбласть("СтрокаДоговоры");
	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяДата", КонецДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("Подразделение", фнПодразделение);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УправленческийОстатки.Субконто2 КАК Договор,
	|	Договор.Автор.ФизическоеЛицо КАК Автор,
	|	Договор.Комментарий,
	|	Договор.Подразделение,
	|	Договор.СуммаДокумента КАК СуммаДоговора
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(
	|			&ТекущаяДата,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ВзаиморасчетыСПокупателями),
	|			,
	|			Субконто2 ССЫЛКА Документ.Договор
	|				И (ВЫРАЗИТЬ(Субконто2 КАК Документ.Договор)) <> ЗНАЧЕНИЕ(Документ.Договор.ПустаяСсылка)
	|				И Подразделение = &Подразделение) КАК УправленческийОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК Договор
	|		ПО ((ВЫРАЗИТЬ(УправленческийОстатки.Субконто2 КАК Документ.Договор)) = Договор.Ссылка)
	|ГДЕ
	|	Договор.Подразделение = &Подразделение";
	
	Выборка = Запрос.Выполнить().Выгрузить();
	ТЗ = Документы.Договор.РасчетПени(Выборка.ВыгрузитьКолонку("Договор"), КонецДня(ТекущаяДата()));
	
	Если ТЗ.Количество() > 0 Тогда
		
		фнТабДок.Вывести(ОбластьПустаяСтрока);
		фнТабДок.Вывести(ОбластьШапкаДоговоры);
		
		Для Каждого Строка Из ТЗ Цикл
			
			Замер = Строка.Договор.Спецификация.ДокументОснование;
			Заказчик = Строка.Договор.Спецификация.Контрагент;
			
			ОбластьСтрокаДоговоры.Параметры.Заполнить(Строка);
			ОбластьСтрокаДоговоры.Параметры.Договор = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(Строка.Договор.Номер)+" от "+Формат(Строка.Договор.Дата,"ДФ=dd.MM.yy");
			
			Если ТипЗнч(Замер) = Тип("ДокументСсылка.Замер") Тогда
				ОбластьСтрокаДоговоры.Параметры.Адрес = Замер.АдресЗамера + ", тел. " + Замер.Телефон + " (" + Замер.ИмяЗаказчика + ")";
			КонецЕсли;
			
			ОбластьСтрокаДоговоры.Параметры.ПервыйПросроченныйПлатеж = Формат(Строка.ПервыйПросроченныйПлатеж, "ДФ=dd.MM.yyyy");
			ОбластьСтрокаДоговоры.Параметры.Автор = ФизическиеЛицаКлиентСервер.ФамилияИнициалыФизЛица(Строка.Автор.Наименование);
			ОбластьСтрокаДоговоры.Параметры.Заказчик = ФизическиеЛицаКлиентСервер.ФамилияИнициалыФизЛица(Заказчик.Наименование);
			ОбластьСтрокаДоговоры.Параметры.РасшифровкаДоговор = Новый Структура("РасшифровкаДоговор", Строка.Договор);
			фнТабДок.Вывести(ОбластьСтрокаДоговоры);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьЗапрос(ПараметрыОтчета)
	
	СтаршийДизайнер = ?(ПараметрыОтчета.Свойство("СтаршийДизайнер"), ПараметрыОтчета.СтаршийДизайнер, Справочники.ФизическиеЛица.ПустаяСсылка());
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", ПараметрыОтчета.Подразделение);
	Запрос.УстановитьПараметр("СтаршийДизайнер", СтаршийДизайнер);	
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Запрос.УстановитьПараметр("НачалоДня", НачалоДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ТекущаяДата()));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ТекущаяДата()));
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	NULL КАК Адрес,
	|	NULL КАК Замерщик,
	|	NULL КАК Офис,
	|	NULL КАК Автор,
	|	NULL КАК Предмет,
	|	NULL КАК ДатаЗамера,
	|	NULL КАК ДатаВстречи,
	|	NULL КАК Встреча,
	|	ФизическиеЛица.Ссылка.Фамилия + "" "" + ПОДСТРОКА(ФизическиеЛица.Ссылка.Имя, 1, 1) + "". "" + ПОДСТРОКА(ФизическиеЛица.Ссылка.Отчество, 1, 1) + ""."" КАК Дизайнер,
	|	NULL КАК Статус,
	|	NULL КАК ДатаМонтажа,
	|	""План"" КАК Вид,
	|	NULL КАК Изделие,
	|	NULL КАК Монтажник,
	|	NULL КАК Фамилия,
	|	NULL КАК Заметка,
	|	NULL КАК Примечание,
	|	NULL КАК ТелефонКлиента,
	|	NULL КАК РазницаДат,
	|	NULL КАК ДатаРазмещения,
	|	NULL КАК ДатаИзготовления,
	|	NULL КАК Виновный,
	|	NULL КАК Сумма,
	|	NULL КАК МетровЛДСП,
	|	МАКСИМУМ(ФизическиеЛица.Руководитель.Фамилия + "" "" + ПОДСТРОКА(ФизическиеЛица.Руководитель.Имя, 1, 1) + "". "" + ПОДСТРОКА(ФизическиеЛица.Руководитель.Отчество, 1, 1) + ""."") КАК Руководитель,
	|	ВЫБОР
	|		КОГДА МАКСИМУМ(ВТ.План) = 0
	|			ТОГДА 0
	|		ИНАЧЕ СУММА(ВТ.Выручка) * 100 / МАКСИМУМ(ВТ.План)
	|	КОНЕЦ КАК ПроцПлана,
	|	ВЫБОР
	|		КОГДА МАКСИМУМ(ВТ.План) = 0
	|			ТОГДА 0
	|		ИНАЧЕ СУММА(ВТ.Выручка) * 100 / МАКСИМУМ(ВТ.План) - МАКСИМУМ(ВТ.План) * (РАЗНОСТЬДАТ(&НачалоПериода, &ТекущаяДата, ДЕНЬ) + 1) / (РАЗНОСТЬДАТ(&НачалоПериода, &КонецПериода, ДЕНЬ) + 1) * 100 / МАКСИМУМ(ВТ.План)
	|	КОНЕЦ КАК ОтклонениеПлана,
	|	1 КАК Порядок,
	|	NULL КАК Ответственный
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			УправленческийОбороты.Субконто2 КАК Сотрудник,
	|			УправленческийОбороты.СуммаОборот КАК План,
	|			0 КАК Выручка,
	|			УправленческийОбороты.Период КАК Период
	|		ИЗ
	|			РегистрБухгалтерии.Управленческий.Обороты(
	|					&НачалоПериода,
	|					&КонецПериода,
	|					Регистратор,
	|					Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|					,
	|					Подразделение = &Подразделение
	|						И Субконто1 = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.ВыручкаПлан),
	|					,
	|					) КАК УправленческийОбороты
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			УправленческийОбороты.Субконто2,
	|			0,
	|			УправленческийОбороты.СуммаОборот,
	|			УправленческийОбороты.Период
	|		ИЗ
	|			РегистрБухгалтерии.Управленческий.Обороты(
	|					&НачалоПериода,
	|					&КонецПериода,
	|					Регистратор,
	|					Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПоказателиСотрудника),
	|					,
	|					Подразделение = &Подразделение
	|						И Субконто1 = ЗНАЧЕНИЕ(Перечисление.ВидыПоказателейСотрудников.Выручка),
	|					,
	|					) КАК УправленческийОбороты) КАК ВТ
	|		ПО ФизическиеЛица.Ссылка = ВТ.Сотрудник
	|ГДЕ
	|	ФизическиеЛица.ЗамерыИВстречи
	|	И ФизическиеЛица.Активность
	|	И ФизическиеЛица.Подразделение = &Подразделение
	|	И ВЫБОР
	|			КОГДА &СтаршийДизайнер <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|				ТОГДА ФизическиеЛица.Руководитель = &СтаршийДизайнер
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|СГРУППИРОВАТЬ ПО
	|	ФизическиеЛица.Ссылка.Фамилия + "" "" + ПОДСТРОКА(ФизическиеЛица.Ссылка.Имя, 1, 1) + "". "" + ПОДСТРОКА(ФизическиеЛица.Ссылка.Отчество, 1, 1) + "".""
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	докЗамер.АдресЗамера + "", тел. "" + докЗамер.Телефон + "" ("" + докЗамер.ИмяЗаказчика + "")"",
	|	докЗамер.Замерщик.Фамилия + "" "" + ПОДСТРОКА(докЗамер.Замерщик.Имя, 1, 1) + "". "" + ПОДСТРОКА(докЗамер.Замерщик.Отчество, 1, 1) + ""."",
	|	докЗамер.Офис,
	|	докЗамер.Автор,
	|	докЗамер.Ссылка,
	|	докЗамер.ДатаЗамера,
	|	Встречи.Встреча.Дата,
	|	Встречи.Встреча,
	|	Встречи.Встреча.Ответственный.Фамилия + "" "" + ПОДСТРОКА(Встречи.Встреча.Ответственный.Имя, 1, 1) + "". "" + ПОДСТРОКА(Встречи.Встреча.Ответственный.Отчество, 1, 1) + ""."",
	|	NULL,
	|	NULL,
	|	""Замер"",
	|	NULL,
	|	NULL,
	|	Встречи.Встреча.Ответственный.Фамилия,
	|	ВЫБОР
	|		КОГДА НаличиеЗаметокПоПредмету.ЕстьЗаметка ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ НаличиеЗаметокПоПредмету.ЕстьЗаметка
	|	КОНЕЦ,
	|	докЗамер.Комментарий,
	|	докЗамер.Телефон,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	2,
	|	NULL
	|ИЗ
	|	Документ.Замер КАК докЗамер
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АктивностьЗамеров КАК АктивностьЗамеров
	|		ПО (АктивностьЗамеров.Замер = докЗамер.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеЗаметокПоПредмету КАК НаличиеЗаметокПоПредмету
	|		ПО (докЗамер.Ссылка = (ВЫРАЗИТЬ(НаличиеЗаметокПоПредмету.Предмет КАК Документ.Замер)))
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			Замер.Ссылка КАК Ссылка,
	|			МАКСИМУМ(ВстречаСКлиентом.Ссылка) КАК Встреча
	|		ИЗ
	|			Документ.Замер КАК Замер
	|				ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВстречаСКлиентом КАК ВстречаСКлиентом
	|				ПО (ВстречаСКлиентом.Основание = Замер.Ссылка)
	|		ГДЕ
	|			ВстречаСКлиентом.Проведен
	|		
	|		СГРУППИРОВАТЬ ПО
	|			Замер.Ссылка) КАК Встречи
	|		ПО докЗамер.Ссылка = Встречи.Ссылка
	|ГДЕ
	|	НЕ докЗамер.ПометкаУдаления
	|	И АктивностьЗамеров.Статус
	|	И докЗамер.Подразделение = &Подразделение
	|	И ВЫБОР
	|			КОГДА &СтаршийДизайнер <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|				ТОГДА докЗамер.Замерщик = &СтаршийДизайнер
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер)) <> ЗНАЧЕНИЕ(Документ.Замер.ПустаяСсылка)
	|			ТОГДА докСпецификация.АдресМонтажа + "", тел. "" + ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Телефон + "" ("" + ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).ИмяЗаказчика + "")""
	|		ИНАЧЕ докСпецификация.АдресМонтажа
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА докСпецификация.ДокументОснование ССЫЛКА Документ.Замер
	|			ТОГДА ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Фамилия + "" "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Имя, 1, 1) + "". "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Отчество, 1, 1) + "".""
	|		КОГДА докСпецификация.ДокументОснование = НЕОПРЕДЕЛЕНО
	|			ТОГДА ВЫРАЗИТЬ(докСпецификация.Автор КАК Справочник.Пользователи).ФизическоеЛицо.Руководитель.Фамилия + "" "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.Автор КАК Справочник.Пользователи).ФизическоеЛицо.Руководитель.Имя, 1, 1) + "". "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.Автор КАК Справочник.Пользователи).ФизическоеЛицо.Руководитель.Отчество, 1, 1) + "".""
	|	КОНЕЦ,
	|	NULL,
	|	NULL,
	|	докСпецификация.Ссылка,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	СтатусСпецификацииСрезПоследних.Статус,
	|	докСпецификация.ДатаМонтажа,
	|	""Монтаж"",
	|	докСпецификация.Изделие,
	|	докСпецификация.Монтажник.Фамилия + "" "" + ПОДСТРОКА(докСпецификация.Монтажник.Имя, 1, 1) + "". "" + ПОДСТРОКА(докСпецификация.Монтажник.Отчество, 1, 1) + ""."",
	|	ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик.Фамилия,
	|	ВЫБОР
	|		КОГДА НаличиеЗаметокПоПредмету.ЕстьЗаметка ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ НаличиеЗаметокПоПредмету.ЕстьЗаметка
	|	КОНЕЦ,
	|	NULL,
	|	NULL,
	|	ВЫБОР
	|		КОГДА РазмещенСрезПоследних.Период ЕСТЬ NULL
	|			ТОГДА РАЗНОСТЬДАТ(&ТекущаяДата, докСпецификация.ДатаОтгрузки, ДЕНЬ)
	|		ИНАЧЕ РАЗНОСТЬДАТ(РазмещенСрезПоследних.Период, докСпецификация.ДатаОтгрузки, ДЕНЬ)
	|	КОНЕЦ,
	|	РазмещенСрезПоследних.Период,
	|	NULL,
	|	NULL,
	|	NULL,
	|	докСпецификация.ПлощадьСборкиИзделия,
	|	NULL,
	|	NULL,
	|	NULL,
	|	3,
	|	NULL
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО (СтатусСпецификацииСрезПоследних.Спецификация = докСпецификация.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеЗаметокПоПредмету КАК НаличиеЗаметокПоПредмету
	|		ПО (докСпецификация.Ссылка = (ВЫРАЗИТЬ(НаличиеЗаметокПоПредмету.Предмет КАК Документ.Спецификация)))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних(, Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен)) КАК РазмещенСрезПоследних
	|		ПО (РазмещенСрезПоследних.Спецификация = докСпецификация.Ссылка)
	|ГДЕ
	|	докСпецификация.Подразделение = &Подразделение
	|	И ВЫБОР
	|			КОГДА &СтаршийДизайнер <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|				ТОГДА ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Замер).Замерщик = &СтаршийДизайнер
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И докСпецификация.Проведен
	|	И СтатусСпецификацииСрезПоследних.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Установлен)
	|	И докСпецификация.ПакетУслуг = ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж)
	|	И докСпецификация.ДатаМонтажа <> ДАТАВРЕМЯ(1, 1, 1)
	|	И НЕ докСпецификация.Изделие.ЭтоДопСоглашение
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДокДоговор.Спецификация.АдресМонтажа + "" "" + ДокДоговор.Спецификация.Контрагент.Наименование,
	|	NULL,
	|	NULL,
	|	ДокДоговор.Автор.ФизическоеЛицо.Фамилия + "" "" + ПОДСТРОКА(ДокДоговор.Автор.ФизическоеЛицо.Имя, 1, 1) + "". "" + ПОДСТРОКА(ДокДоговор.Автор.ФизическоеЛицо.Отчество, 1, 1) + ""."",
	|	ДокДоговор.Ссылка,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	СтатусСпецификацииСрезПоследних.Статус,
	|	NULL,
	|	""ДоговорыБезМонтажа"",
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ДокДоговор.Спецификация.ДатаОтгрузки,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	4,
	|	ВЫБОР
	|		КОГДА ДокДоговор.Ссылка.Спецификация.Дилерский
	|			ТОГДА ДокДоговор.Ссылка.Спецификация.Контрагент.Супервайзер
	|		КОГДА ДокДоговор.Ссылка.Спецификация.Изделие.ЭтоДетали
	|			ТОГДА ДокДоговор.Ссылка.Спецификация.Автор.ФизическоеЛицо
	|		ИНАЧЕ ДокДоговор.Ссылка.Спецификация.Офис.СтаршийОфиса
	|	КОНЕЦ
	|ИЗ
	|	Документ.Договор КАК ДокДоговор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктВыполненияДоговора КАК АктВыполненияДоговора
	|		ПО (АктВыполненияДоговора.Договор = ДокДоговор.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО (СтатусСпецификацииСрезПоследних.Спецификация = ДокДоговор.Спецификация)
	|ГДЕ
	|	ДокДоговор.Спецификация.ПакетУслуг <> ЗНАЧЕНИЕ(Перечисление.ПакетыУслуг.ДоставкаДоКлиентаИМонтаж)
	|	И ДокДоговор.Проведен
	|	И (НЕ АктВыполненияДоговора.Проведен
	|			ИЛИ АктВыполненияДоговора.Проведен ЕСТЬ NULL)
	|	И ДокДоговор.Подразделение = &Подразделение
	|	И ДокДоговор.Дата > ДАТАВРЕМЯ(2017, 7, 1)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	докСпецификация.АдресМонтажа + "", тел. "" + ВЫРАЗИТЬ(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Спецификация).ДокументОснование КАК Документ.Замер).Телефон + "" ("" + ВЫРАЗИТЬ(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Спецификация).ДокументОснование КАК Документ.Замер).ИмяЗаказчика + "")"",
	|	ВЫБОР
	|		КОГДА докСпецификация.ДокументОснование ССЫЛКА Документ.Замер
	|			ТОГДА ВЫРАЗИТЬ(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Спецификация).ДокументОснование КАК Документ.Замер).Замерщик.Фамилия + "" "" + ПОДСТРОКА(ВЫРАЗИТЬ(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Спецификация).ДокументОснование КАК Документ.Замер).Замерщик.Имя, 1, 1) + "". "" + ПОДСТРОКА(ВЫРАЗИТЬ(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Спецификация).ДокументОснование КАК Документ.Замер).Замерщик.Отчество, 1, 1) + "".""
	|		КОГДА докСпецификация.ДокументОснование = НЕОПРЕДЕЛЕНО
	|			ТОГДА ВЫРАЗИТЬ(докСпецификация.Автор КАК Справочник.Пользователи).ФизическоеЛицо.Руководитель.Фамилия + "" "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.Автор КАК Справочник.Пользователи).ФизическоеЛицо.Руководитель.Имя, 1, 1) + "". "" + ПОДСТРОКА(ВЫРАЗИТЬ(докСпецификация.Автор КАК Справочник.Пользователи).ФизическоеЛицо.Руководитель.Отчество, 1, 1) + "".""
	|	КОНЕЦ,
	|	NULL,
	|	докСпецификация.Автор.ФизическоеЛицо.Фамилия + "" "" + ПОДСТРОКА(докСпецификация.Автор.ФизическоеЛицо.Имя, 1, 1) + "". "" + ПОДСТРОКА(докСпецификация.Автор.ФизическоеЛицо.Отчество, 1, 1) + ""."",
	|	докСпецификация.Ссылка,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	СтатусСпецификацииСрезПоследних.Статус,
	|	NULL,
	|	""Переделка"",
	|	NULL,
	|	NULL,
	|	ВЫРАЗИТЬ(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Спецификация).ДокументОснование КАК Документ.Замер).Замерщик.Фамилия,
	|	ВЫБОР
	|		КОГДА НаличиеЗаметокПоПредмету.ЕстьЗаметка ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ НаличиеЗаметокПоПредмету.ЕстьЗаметка
	|	КОНЕЦ,
	|	NULL,
	|	NULL,
	|	NULL,
	|	РазмещенСрезПоследних.Период,
	|	докСпецификация.ДатаИзготовления,
	|	докСпецификация.Виновный.Фамилия + "" "" + ПОДСТРОКА(докСпецификация.Виновный.Имя, 1, 1) + "". "" + ПОДСТРОКА(докСпецификация.Виновный.Отчество, 1, 1) + ""."",
	|	докСпецификация.СуммаДокумента,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	5,
	|	NULL
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних(, ) КАК СтатусСпецификацииСрезПоследних
	|		ПО (СтатусСпецификацииСрезПоследних.Спецификация = докСпецификация.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеЗаметокПоПредмету КАК НаличиеЗаметокПоПредмету
	|		ПО (докСпецификация.Ссылка = (ВЫРАЗИТЬ(НаличиеЗаметокПоПредмету.Предмет КАК Документ.Спецификация)))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних(, Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Размещен)) КАК РазмещенСрезПоследних
	|		ПО (РазмещенСрезПоследних.Спецификация = докСпецификация.Ссылка)
	|ГДЕ
	|	докСпецификация.Подразделение = &Подразделение
	|	И ВЫБОР
	|			КОГДА &СтаршийДизайнер <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|				ТОГДА ВЫРАЗИТЬ(ВЫРАЗИТЬ(докСпецификация.ДокументОснование КАК Документ.Спецификация).ДокументОснование КАК Документ.Замер).Замерщик = &СтаршийДизайнер
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И докСпецификация.Проведен
	|	И СтатусСпецификацииСрезПоследних.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Отгружен)
	|	И докСпецификация.Изделие.ЭтоПеределка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	докЗамер.АдресЗамера + "", тел. "" + докЗамер.Телефон + "" ("" + докЗамер.ИмяЗаказчика + "")"",
	|	докЗамер.Замерщик.Фамилия + "" "" + ПОДСТРОКА(докЗамер.Замерщик.Имя, 1, 1) + "". "" + ПОДСТРОКА(докЗамер.Замерщик.Отчество, 1, 1) + ""."",
	|	NULL,
	|	NULL,
	|	докАктВыполненияДоговора.Ссылка,
	|	докАктВыполненияДоговора.Дата,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	""Акт"",
	|	NULL,
	|	NULL,
	|	докЗамер.Замерщик.Фамилия,
	|	NULL,
	|	докАктВыполненияДоговора.Комментарий,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	6,
	|	NULL
	|ИЗ
	|	Документ.АктВыполненияДоговора КАК докАктВыполненияДоговора
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Замер КАК докЗамер
	|		ПО ((ВЫРАЗИТЬ(докАктВыполненияДоговора.Договор.Спецификация.ДокументОснование КАК Документ.Замер)) = докЗамер.Ссылка)
	|ГДЕ
	|	докАктВыполненияДоговора.Подразделение = &Подразделение
	|	И докАктВыполненияДоговора.ДатаПередачи = ДАТАВРЕМЯ(1, 1, 1)
	|	И ВЫБОР
	|			КОГДА &СтаршийДизайнер <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|				ТОГДА докЗамер.Замерщик = &СтаршийДизайнер
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	ДатаЗамера,
	|	ДатаМонтажа
	|ИТОГИ
	|	МАКСИМУМ(Вид)
	|ПО
	|	Порядок";
	
	Возврат Запрос;
	
КонецФункции
