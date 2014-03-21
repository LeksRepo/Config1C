﻿&НаСервере
Функция ПроверитьСтатусСпецификации(Договор)
	
	Спецификация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "Спецификация");
	Адрес = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Спецификация, "АдресМонтажа");
	Статус = Документы.Спецификация.ПолучитьСтатусСпецификации(Спецификация);
	
	РазрешеноИзменятьСпецификацию= (Статус = Перечисления.СтатусыСпецификации.Сохранен
		или Статус = Перечисления.СтатусыСпецификации.Рассчитывается);
		
	Если РазрешеноИзменятьСпецификацию Тогда
		
		СуммаДокумента = ПолучитьСуммуСпецификации(Спецификация);
		СсылкаНаСпецификацию = Спецификация.Ссылка;
		
	Иначе
		
		СуммаДокумента = 0;
		СсылкаНаСпецификацию = Документы.Спецификация.ПустаяСсылка();
		
	КонецЕсли;
	
	СтруктураСпецификации = Новый структура;
	СтруктураСпецификации.Вставить("Спецификация", СсылкаНаСпецификацию);
	СтруктураСпецификации.Вставить("СуммаДокумента", СуммаДокумента);
	
	Возврат СтруктураСпецификации;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСуммуСпецификации(Спецификация)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Спецификация, "СуммаДокумента");
	
КонецФункции // ПолучитьСуммуСпецификации()

&НаКлиенте
Процедура ОткрытьСпецификацию()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимОткрытияОкнаФормы", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	Если ЗначениеЗаполнено(Спецификация) Тогда
		
		ПараметрыФормы.Вставить("Ключ", Спецификация);
		ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаДокумента", ПараметрыФормы, ЭтаФорма);
		
	Иначе
		
		СтруктураРеквизитов = ПолучитьЗначенияРеквизитов();
		Форма = ПолучитьФорму("Документ.Спецификация.Форма.ФормаДокумента");
		Форма.Объект.Контрагент = СтруктураРеквизитов.Контрагент;
		Форма.Объект.Офис = СтруктураРеквизитов.Офис;
		Форма.Объект.АдресМонтажа = СтруктураРеквизитов.АдресМонтажа;
		Форма.Объект.Телефон = СтруктураРеквизитов.Телефон;
		Форма.ВладелецФормы = ЭтаФорма;
		Форма.Объект.Изделие = СтруктураРеквизитов.Изделие;
		Форма.Договор = Договор;
		
		Форма.ОткрытьМодально();
		
	КонецЕсли;
	
КонецПроцедуры // ОткрытьСпецификацию()

&НаСервере
Функция ПолучитьЗначенияРеквизитов()
	
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "Контрагент, Спецификация, Офис");
	СтруктураРеквизитов.Вставить("АдресМонтажа", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураРеквизитов.Спецификация, "АдресМонтажа"));
	СтруктураРеквизитов.Вставить("Телефон", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураРеквизитов.Спецификация, "Телефон"));
	СтруктураРеквизитов.Вставить("Изделие", Справочники.Изделия.ДопСоглашение);
	Возврат СтруктураРеквизитов;
	
КонецФункции // ПолучитьЗначенияРеквизитов()

&НаСервере
Процедура ПоменятьСтатусСпецификации(Спецификация)
	
	Документы.Спецификация.УстановитьСтатусСпецификации(Спецификация, Перечисления.СтатусыСпецификации.ПроверяетсяИнженером);
	
КонецПроцедуры // ПоменятьСтатусСпецификации()

&НаКлиенте
Процедура Далее(Команда)
	
	ПодчиненныеСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	ТекущаяОсновнаяСтраница = Элементы.СтраницыПомощника.ТекущаяСтраница;
	
	Если ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ПервыйЭтап Тогда
		
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапПредупреждения;
		
		Если ЗначениеЗаполнено(Спецификация) Тогда
			
			Элементы.Декорация15.Заголовок = "Откроется существующий документ ""Спецификация"". Нажмите ""Далее""";
			
		Иначе
			
			Элементы.Декорация15.Заголовок = "Старый документ ""спецификация"" не доступен для редактирования. Будет создан новый. Нажмите ""Далее >>"".";
			
		КонецЕсли;
		
	ИначеЕсли ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапПредупреждения Тогда
		
		ОткрытьСпецификацию();
		
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапПроверкиСпецификации;
		
	ИначеЕсли ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапПроверкиСпецификации Тогда
		
		Если Сумма <> 0 Тогда
				
				Если ВидПлатежа = "Приход" Тогда
					
					Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораСпособаПлатежа;
					
				ИначеЕсли ВидПлатежа = "Расход" Тогда
					
					Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораКонтрагентаДоговора;
					
				КонецЕсли;
				
				Если ВидПлатежа = "Приход" или ВидПлатежа = "Расход" Тогда
					
					ПоменятьСтатусСпецификации(Спецификация);
					
				КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораСпособаПлатежа Тогда
		
		Если СпособПлатежа = "Нал" Тогда
			
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораКонтрагентаДоговора;
			
		ИначеЕсли СпособПлатежа = "Безнал" Тогда
			
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораСпособаПлатежаБезнал;
			РасчетныйСчет = ОпределитьРасчетныйСчет(Подразделение);
			
		Иначе
			
			ПоказатьОповещениеПользователя("Ошибка", , "Выберите способ платежа", БиблиотекаКартинок.Предупреждение32);
			
		КонецЕсли;
		
	ИначеЕсли ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораСпособаПлатежаБезнал Тогда
		
		Если ЗначениеЗаполнено(РасчетныйСчет) Тогда
			
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораКонтрагентаДоговора;
			
		Иначе
			
			ПоказатьОповещениеПользователя("Ошибка", , "Укажите расчетный счет", БиблиотекаКартинок.Предупреждение32);
			
		КонецЕсли;
		
	ИначеЕсли ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораКонтрагентаДоговора Тогда
		
		СтрутураДокументов = СформироватьДокумент();
		ПоказатьОповещениеПользователя("Помощник...", ПолучитьНавигационнуюСсылку(СтрутураДокументов.ПрихожникРасходник), "Документ успешно сформирован!", БиблиотекаКартинок.Предупреждение32);
		Массив = Новый Массив;
		Массив.Добавить(СтрутураДокументов.ПрихожникРасходник);
		
		Если Печать Тогда
			
			МассивДляДопника = Новый Массив;
			МассивДляДопника.Добавить(СтрутураДокументов.ДопСоглашение);
		
			ПараметрыПечати = Новый Структура;
			ПараметрыПечати.Вставить("ФиксированныйКомплект", Ложь); 
			ПараметрыПечати.Вставить("ПереопределитьПользовательскиеНастройкиКоличества", Истина);
		
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ДополнительноеСоглашение", "Соглашение", МассивДляДопника, Неопределено, ПараметрыПечати);
			
			Если ВидПлатежа = "Приход" Тогда
			
				УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ПриходДенежныхСредств", "ТоварныйЧек", Массив, Неопределено, Неопределено);
			
			КонецЕсли;
		
		КонецЕсли;
		
		Закрыть();
		
	КонецЕсли;
	
	ВидимостьКнопок();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ПодчиненныеСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	ТекущаяОсновнаяСтраница = Элементы.СтраницыПомощника.ТекущаяСтраница;
	
	Если ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораКонтрагентаДоговора И ВидПлатежа = "Расход" Тогда
		
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораСпособаПлатежа;
		
	ИначеЕсли ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораСпособаПлатежаБезнал
		ИЛИ (ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораКонтрагентаДоговора И ВидПлатежа = "Приход" И СпособПлатежа = "Нал") Тогда
		
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораСпособаПлатежа;
		
	ИначеЕсли ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораКонтрагентаДоговора И ВидПлатежа = "Приход" И СпособПлатежа = "Безнал" Тогда
		
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораСпособаПлатежаБезнал;
		
	КонецЕсли;
	
	ВидимостьКнопок();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОпределитьРасчетныйСчет(Подразделение)
	
	Если Подразделение.Код = "000000003" Тогда
		
		Возврат Справочники.Счета.НайтиПоКоду("000000007");
		
	Иначе
		
		Возврат Справочники.Счета.НайтиПоКоду("000000037");
		
	КонецЕсли;
		
КонецФункции

&НаКлиенте
Процедура ВидимостьКнопок()
	
	ТекущаяСтраница = Элементы.СтраницыПомощника.ТекущаяСтраница;
	ПодчиненныеСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	
	Если ТекущаяСтраница = ПодчиненныеСтраницы.ПервыйЭтап Тогда
		
		Элементы.КнопкаНазад.Доступность = Ложь;
		Элементы.КнопкаДалее.Заголовок = "Далее >>";
		
	ИначеЕсли ТекущаяСтраница = ПодчиненныеСтраницы.ЭтапПроверкиСпецификации Тогда
		
		Элементы.КнопкаНазад.Доступность = Ложь;
		Элементы.КнопкаДалее.Заголовок = "Далее >>";
		
	ИначеЕсли ТекущаяСтраница = ПодчиненныеСтраницы.ЭтапПредупреждения Тогда
		
		Элементы.КнопкаНазад.Доступность = Ложь;
		Элементы.КнопкаДалее.Заголовок = "Далее >>";
		
	ИначеЕсли ТекущаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораКонтрагентаДоговора Тогда
		
		Элементы.КнопкаДалее.Заголовок = "Готово";
		Элементы.КнопкаНазад.Доступность = Истина;
		
	ИначеЕсли ТекущаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораСпособаПлатежа Тогда
		
		Элементы.КнопкаДалее.Заголовок = "Далее >>";
		Элементы.КнопкаНазад.Доступность = Ложь;
		
	Иначе
		
		Элементы.КнопкаДалее.Заголовок = "Далее >>";
		Элементы.КнопкаНазад.Доступность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьДокумент()
	
	НовоеДопСоглашение = Документы.ДополнительноеСоглашение.СоздатьДокумент();
	НовоеДопСоглашение.Договор = Договор;
	НовоеДопСоглашение.Дата = ТекущаяДата();
	НовоеДопСоглашение.Офис = Офис;
	НовоеДопСоглашение.СуммаДокумента = Сумма;
	НовоеДопСоглашение.Комментарий = Комментарий;
	НовоеДопСоглашение.Записать(РежимЗаписиДокумента.Запись);
	СсылкаНаДопСоглашение = НовоеДопСоглашение.Ссылка;
	
	Если ВидПлатежа = "Расход" Тогда
		
		НовыйДокумент = Документы.РасходДенежныхСредств.СоздатьДокумент();
		НовыйДокумент.ВидОперации = Перечисления.ВидыОпераций.ВозвратКонтрагентуСОперационнойКассы;
		НовыйДокумент.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
		НовыйДокумент.Субконто1Дт = Контрагент;
		НовыйДокумент.Субконто2Дт = СсылкаНаДопСоглашение;
		НовыйДокумент.Офис = Офис;
		НовыйДокумент.ВидОперации = Перечисления.ВидыОпераций.ВозвратКонтрагентуСОперационнойКассы;
		НовыйДокумент.СчетКт = ПланыСчетов.Управленческий.ОперационнаяКасса;
		НовыйДокумент.Субконто1Кт = Справочники.СтатьиДвиженияДенежныхСредств.ВозвратДенежныхСредствКлиенту; 
		НовыйДокумент.Субконто2Кт = Сотрудник;
		
	ИначеЕсли ВидПлатежа = "Приход" Тогда
		
		НовыйДокумент = Документы.ПриходДенежныхСредств.СоздатьДокумент();
		НовыйДокумент.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
		НовыйДокумент.Субконто1Кт = Контрагент;
		НовыйДокумент.Субконто2Кт = СсылкаНаДопСоглашение;
		НовыйДокумент.Офис = Офис;
		
		Если СпособПлатежа = "Нал" Тогда
			
			НовыйДокумент.ВидОперации = Перечисления.ВидыОпераций.ОплатаОтПокупателяВОперационнуюКассу;
			НовыйДокумент.СчетДт = ПланыСчетов.Управленческий.ОперационнаяКасса;
			
			Если Контрагент = Справочники.Контрагенты.ЧастноеЛицо Тогда
				
				СтатьяПоступления = Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтЧастныхЛицПоСпецификациям;
				
			Иначе
				
				СтатьяПоступления = Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтРозничныхКлиентов;
				
			КонецЕсли;
			
			НовыйДокумент.Субконто1Дт = СтатьяПоступления;
			НовыйДокумент.Субконто2Дт = Сотрудник;
			
		ИначеЕсли СпособПлатежа = "Безнал" Тогда
			
			НовыйДокумент.ВидОперации = Перечисления.ВидыОпераций.БезналичныйРасчетПокупателя;
			НовыйДокумент.СчетДт = ПланыСчетов.Управленческий.РасчетныйСчет; 
			НовыйДокумент.Субконто1Дт = Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтРозничныхКлиентов;
			НовыйДокумент.Субконто2Дт = РасчетныйСчет;
			
		КонецЕсли;
		
	КонецЕсли;
	
	НовыйДокумент.Дата = ТекущаяДата();
	НовыйДокумент.Комментарий = "Документ создан помощником";
	НовыйДокумент.Подразделение = Подразделение; 
	НовыйДокумент.Сумма = ?(ВидПлатежа = "Приход", Сумма, -Сумма);
	НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
	
	НовоеДопСоглашение.Записать(РежимЗаписиДокумента.Проведение);
	СтруктураДокументов = Новый Структура;
	СтруктураДокументов.Вставить("ПрихожникРасходник", НовыйДокумент.Ссылка);
	СтруктураДокументов.Вставить("ДопСоглашение", НовоеДопСоглашение.Ссылка);
	
	Возврат СтруктураДокументов;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ЗначениеЗаполнено(ВидПлатежа) Тогда
		
		ВидПлатежа = "Приход";
	
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СпособПлатежа) Тогда
		
		СпособПлатежа = "Нал";
		
	КонецЕсли;
	
	СтруктураРеквизитов = ПроверитьСтатусСпецификации(Договор);
	Спецификация = СтруктураРеквизитов.Спецификация;
	СтараяСуммаДокумента = СтруктураРеквизитов.СуммаДокумента;
	Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ПервыйЭтап;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Договор = Параметры.Договор;
	СтруктураРеквизитов = ЛексСервер.ЗначенияРеквизитовОбъекта(Договор, "Контрагент, Подразделение, Офис, ВидОплатыДоговора");
	Контрагент = СтруктураРеквизитов.Контрагент;
	Подразделение = СтруктураРеквизитов.Подразделение;
	ВидПлатежа = "Приход";
	СпособПлатежа = "Нал";
	Офис = СтруктураРеквизитов.Офис;
	ВидыОплатыДоговоров = Перечисления.ВидыОплатыДоговоров;
	ИспользуемыйВидОплаты = СтруктураРеквизитов.ВидОплатыДоговора;
	Сотрудник = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
	Справочник = Справочники.Счета;
	Элементы.РасчетныйСчет.СписокВыбора.Добавить(Справочник.НайтиПоКоду("000000007"));
	Элементы.РасчетныйСчет.СписокВыбора.Добавить(Справочник.НайтиПоКоду("000000037"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		Спецификация = ВыбранноеЗначение.Спецификация;
		Сумма = ВыбранноеЗначение.СуммаДокумента;
		
		Если Сумма <> 0 Тогда
			
			Если СтараяСуммаДокумента > Сумма Тогда
				
				ВидПлатежа = "Расход";
				
			ИначеЕсли СтараяСуммаДокумента < Сумма Тогда
				
				ВидПлатежа = "Приход";
				
			Иначе
				
				ЭтаФорма.Закрыть();
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Цена документа спецификация не изменилась. Доп. соглашение не было создано.";
				Сообщение.Сообщить();
				
			КонецЕсли;
			
			Сумма = Окр(Сумма - СтараяСуммаДокумента);
			
		Иначе
			
			ЭтаФорма.Закрыть();
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Сумма не изменилась. Доп. соглашение не было создано.";
			Сообщение.Сообщить();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпецификацияОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьСпецификацию()
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(СсылкаНаДопСоглашение) Тогда
		
		Если Сумма <> 0 и НЕ СтараяСуммаДокумента = Сумма Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Вы изменили спецификацию. Необходимо ввести доп. соглашение.";
			Сообщение.Сообщить();
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
