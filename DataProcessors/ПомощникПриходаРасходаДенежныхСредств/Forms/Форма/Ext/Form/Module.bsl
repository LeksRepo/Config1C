﻿
&НаКлиенте
Процедура Далее(Команда)
	
	ПодчиненныеСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	ТекущаяОсновнаяСтраница = Элементы.СтраницыПомощника.ТекущаяСтраница;
	
	Если ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораВидаПлатежа Тогда
		
		Если ВидПлатежа = "Приход" Тогда
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораСпособаПлатежа;
		ИначеЕсли ВидПлатежа = "Расход" Тогда
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораКонтрагентаДоговора;
		Иначе
			ПоказатьОповещениеПользователя("Ошибка", , "Выберите вид платежа", БиблиотекаКартинок.Предупреждение32);
		КонецЕсли;
		
	ИначеЕсли ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораСпособаПлатежа Тогда
		
		Если СпособПлатежа = "Нал" Тогда
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораКонтрагентаДоговора;
		ИначеЕсли СпособПлатежа = "Безнал" Тогда
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораСпособаПлатежаБезнал;	
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
		
		Документ = СформироватьДокумент();
		ПоказатьОповещениеПользователя("Помощник...", ПолучитьНавигационнуюСсылку(Документ), "Документ успешно сформирован!", БиблиотекаКартинок.Предупреждение32);
		
		Если Печать Тогда
			Массив = Новый Массив;
			Массив.Добавить(Документ);
			
			Если ВидПлатежа = "Приход" Тогда
				ИмяДокумента = "Документ.ПриходДенежныхСредств";
				ИмяПечатнойФормы = "ТоварныйЧек";
			ИначеЕсли ВидПлатежа = "Расход" Тогда
				ИмяДокумента = "Документ.РасходДенежныхСредств";
				ИмяПечатнойФормы = "РасходныйКассовыйОрдер";
			КонецЕсли;
			
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечатиНаПринтер(ИмяДокумента, ИмяПечатнойФормы, Массив, Неопределено);
			
		КонецЕсли;
		
		ОповеститьОбИзменении(Документ);
		
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.Спецификация") Тогда
			
			Режим = РежимДиалогаВопрос.ДаНет;
			Ответ = Вопрос("Передать спецификацию в цех?", Режим, 15);
			Если Ответ = КодВозвратаДиалога.Да Тогда
				
				ИзменитьСтатусСпецификации(ДокументОснование);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ВладелецФормы <> Неопределено Тогда
			ОповеститьОВыборе(Документ);
		Иначе
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
	ПриСменеСтраницы(Элементы.СтраницыПомощника.ТекущаяСтраница);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИзменитьСтатусСпецификации(СпецификацияСсылка)
	
	НачатьТранзакцию();
	Документы.Спецификация.УстановитьСтатусСпецификации(СпецификацияСсылка, Перечисления.СтатусыСпецификации.ПереданВЦех);
	СпецификацияОбъект = СпецификацияСсылка.ПолучитьОбъект();
	СпецификацияОбъект.Записать(РежимЗаписиДокумента.Проведение);
	ЗафиксироватьТранзакцию();
	
КонецФункции

&НаКлиенте
Процедура Назад(Команда)
	
	ПодчиненныеСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	ТекущаяОсновнаяСтраница = Элементы.СтраницыПомощника.ТекущаяСтраница;
	
	Если ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораСпособаПлатежа
		ИЛИ (ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораКонтрагентаДоговора И ВидПлатежа = "Расход") Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораВидаПлатежа;
		
	ИначеЕсли ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораСпособаПлатежаБезнал
		ИЛИ (ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораКонтрагентаДоговора И ВидПлатежа = "Приход" И СпособПлатежа = "Нал") Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораСпособаПлатежа;

	ИначеЕсли ТекущаяОсновнаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораКонтрагентаДоговора И ВидПлатежа = "Приход" И СпособПлатежа = "Безнал" Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораСпособаПлатежаБезнал;
	КонецЕсли;
	
	ПриСменеСтраницы(Элементы.СтраницыПомощника.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриСменеСтраницы(ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораВидаПлатежа Тогда
		Элементы.КнопкаНазад.Доступность = Ложь;
	КонецЕсли;
	
	Если ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораСпособаПлатежа Тогда
		Элементы.КнопкаНазад.Доступность = Истина;
	КонецЕсли;
	
	Если ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораСпособаПлатежаБезнал Тогда
		Элементы.КнопкаНазад.Доступность = Истина;
	КонецЕсли;
	
	Если ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ЭтапВыбораКонтрагентаДоговора Тогда
		Элементы.КнопкаНазад.Доступность = Истина;
	КонецЕсли;
	
	ВидимостьКнопок();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьКнопок()
	
	ТекущаяСтраница = Элементы.СтраницыПомощника.ТекущаяСтраница;
	ПодчиненныеСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	
	Если ТекущаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораВидаПлатежа Тогда
		Элементы.КнопкаНазад.Доступность = Ложь;
		Элементы.КнопкаДалее.Заголовок = "Далее >>";
	ИначеЕсли ТекущаяСтраница = ПодчиненныеСтраницы.ЭтапВыбораКонтрагентаДоговора Тогда
		Элементы.КнопкаДалее.Заголовок = "Готово";
		Элементы.КнопкаНазад.Доступность = Истина;
	Иначе
		Элементы.КнопкаДалее.Заголовок = "Далее >>";
		Элементы.КнопкаНазад.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьДокумент()
	
	Если ВидПлатежа = "Расход" Тогда
		НовыйДокумент = Документы.РасходДенежныхСредств.СоздатьДокумент();
		НовыйДокумент.ВидОперации = Перечисления.ВидыОпераций.ВозвратКонтрагентуСОперационнойКассы;
		НовыйДокумент.СчетДт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
		НовыйДокумент.Субконто1Дт = Контрагент;
		НовыйДокумент.Субконто2Дт = ДокументОснование;
		НовыйДокумент.Офис = Офис;
		НовыйДокумент.ВидОперации = Перечисления.ВидыОпераций.ВозвратКонтрагентуСОперационнойКассы;
		НовыйДокумент.СчетКт = ПланыСчетов.Управленческий.ОперационнаяКасса;
		НовыйДокумент.Субконто1Кт = Справочники.СтатьиДвиженияДенежныхСредств.ВозвратДенежныхСредствКлиенту; 
		НовыйДокумент.Субконто2Кт = Сотрудник;
	ИначеЕсли ВидПлатежа = "Приход" Тогда
		
		НовыйДокумент = Документы.ПриходДенежныхСредств.СоздатьДокумент();
		НовыйДокумент.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
		НовыйДокумент.Субконто1Кт = Контрагент;
		НовыйДокумент.Субконто2Кт = ДокументОснование;
		НовыйДокумент.Офис = Офис;
		Если СпособПлатежа = "Нал" Тогда
			НовыйДокумент.ВидОперации = ?(ПлатежОтДилера, Перечисления.ВидыОпераций.ПрочийПриход, Перечисления.ВидыОпераций.ОплатаОтПокупателяВОперационнуюКассу);
			НовыйДокумент.СчетДт = ПланыСчетов.Управленческий.ОперационнаяКасса;
			Если ПлатежОтДилера Тогда
				СтатьяПоступления = Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтДилеровПоСпецификациям;
			ИначеЕсли Контрагент = Справочники.Контрагенты.ЧастноеЛицо Тогда
				СтатьяПоступления = Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтЧастныхЛицПоСпецификациям;
			Иначе
				СтатьяПоступления = Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтРозничныхКлиентов;
			КонецЕсли;
			НовыйДокумент.Субконто1Дт = СтатьяПоступления;
			НовыйДокумент.Субконто2Дт = Сотрудник;
		ИначеЕсли СпособПлатежа = "Безнал" Тогда
			НовыйДокумент.ВидОперации = ?(ПлатежОтДилера, Перечисления.ВидыОпераций.ПрочийПриход, Перечисления.ВидыОпераций.БезналичныйРасчетПокупателя);
			НовыйДокумент.СчетДт = ПланыСчетов.Управленческий.РасчетныйСчет; 
			НовыйДокумент.Субконто1Дт = ?(ПлатежОтДилера, Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтДилеровПоСпецификациям, Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтРозничныхКлиентов);
			НовыйДокумент.Субконто2Дт = РасчетныйСчет;
		КонецЕсли;
	КонецЕсли;
	
	НовыйДокумент.Дата = ТекущаяДата();
	НовыйДокумент.Комментарий = ?(ПлатежОтДилера, "Поступление от дилера " + Контрагент, "Документ к " + ДокументОснование);
	НовыйДокумент.Подразделение = Подразделение;
	НовыйДокумент.Сумма = Сумма;
	НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
	
	Возврат НовыйДокумент.Ссылка;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ЗначениеЗаполнено(ВидПлатежа) Тогда
		
		ВидПлатежа = "Приход";
	
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СпособПлатежа) Тогда
		
		СпособПлатежа = "Нал";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ДокументОснование") Тогда
		
		Если ТипЗнч(Параметры.ДокументОснование) = Тип("ДокументСсылка.Договор") Тогда 
			
			ДокументОснование = Параметры.ДокументОснование;
			Контрагент = ДокументОснование.Контрагент;
			Подразделение = ДокументОснование.Подразделение;
			ВидПлатежа = "Приход";
			СпособПлатежа = "Нал";
			Офис = ДокументОснование.Офис;
			Сумма = ПолучитьСуммуОплатыДоговора(ДокументОснование);
			
		ИначеЕсли ТипЗнч(Параметры.ДокументОснование) = Тип("ДокументСсылка.ДополнительноеСоглашение") Тогда
			
			ДокументОснование = Параметры.ДокументОснование;
			Контрагент = ДокументОснование.Договор.Контрагент;
			Подразделение = ДокументОснование.Договор.Подразделение;
			ВидПлатежа = ?(ДокументОснование.СуммаДокумента > 0, "Приход", "Расход");
			СпособПлатежа = "Нал";
			Офис = ДокументОснование.Офис;
			Сумма = ?(ДокументОснование.СуммаДокумента > 0, ДокументОснование.СуммаДокумента, ДокументОснование.СуммаДокумента * (-1));
			
		ИначеЕсли ТипЗнч(Параметры.ДокументОснование) = Тип("ДокументСсылка.Спецификация") Тогда
			
			ДокументОснование = Параметры.ДокументОснование;
			Контрагент = ДокументОснование.Контрагент;
			Подразделение = ДокументОснование.Подразделение;
			ВидПлатежа = "Приход";
			СпособПлатежа = "Нал";
			Офис = ДокументОснование.Офис;
			Сумма = ДокументОснование.СуммаДокумента;
			
		ИначеЕсли Параметры.ДокументОснование = Неопределено И Параметры.Свойство("ПлатежОтДилера") И Параметры.ПлатежОтДилера Тогда
			
			ДокументОснование = Параметры.ДокументОснование;
			ВидПлатежа = "Приход";
			СпособПлатежа = "Нал";
			ПлатежОтДилера = Параметры.ПлатежОтДилера;
			Элементы.Договор.Доступность = Ложь;
						
		КонецЕсли;
		
	КонецЕсли;
	
	Печать = Истина;
	
	Сотрудник = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСуммуОплатыДоговора(Договор)
	
	ВидыОплатыДоговоров = Перечисления.ВидыОплатыДоговоров;
	ИспользуемыйВидОплаты = Договор.ВидОплатыДоговора;
	Оплата = 0;
	Сумма = Договор.СуммаДокумента;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Субконто2", Договор.Ссылка);
	Запрос.УстановитьПараметр("Счет", ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправленческийОбороты.СуммаОборотКт
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Обороты(, , , Счет = &Счет, , Субконто2 = &Субконто2, , ) КАК УправленческийОбороты";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Оплата = Выборка.СуммаОборотКт;
	КонецЕсли;
	
	Если Оплата > 0 Тогда
		Если ИспользуемыйВидОплаты = ВидыОплатыДоговоров.Рассрочка4Месяца Тогда
			ТекМесяц = Месяц(ТекущаяДата());
			Для каждого Строка Из Договор.Рассрочка Цикл
				Если Месяц(Строка.Дата) = ТекМесяц Тогда
					Сумма = Строка.Сумма;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Сумма = Окр(Договор.СуммаДокумента - Оплата, 0);
		КонецЕсли;
		
	ИначеЕсли НЕ ИспользуемыйВидОплаты = ВидыОплатыДоговоров.ПолнаяПредоплата Тогда
		Сумма = Окр((Договор.СуммаДокумента / 2) + 0.49, 0);
	КонецЕсли;
	
	Возврат Сумма;
	
КонецФункции

