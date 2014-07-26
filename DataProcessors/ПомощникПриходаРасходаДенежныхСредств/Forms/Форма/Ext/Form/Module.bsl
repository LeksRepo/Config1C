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
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ИмяДокумента, ИмяПечатнойФормы, Массив, Неопределено, Неопределено);
			
		КонецЕсли;
		
		ОповеститьОбИзменении(Документ);
		
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.Спецификация") Тогда
			
			Режим = РежимДиалогаВопрос.ДаНет;
			Ответ = Вопрос("Передать спецификацию в цех?", Режим, 15);
			Если Ответ = КодВозвратаДиалога.Да Тогда
				
				ИзменитьСтатусСпецификации(ДокументОснование);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Закрыть();
		
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
	НовыйДокумент.Комментарий = "Документ к " + ДокументОснование;
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
			ВидыОплатыДоговоров = Перечисления.ВидыОплатыДоговоров;
			ИспользуемыйВидОплаты = ДокументОснование.ВидОплатыДоговора;
			
			//// половина оплаты
			//Если ИспользуемыйВидОплаты = ВидыОплатыДоговоров.Предоплата50БанковскийКредит
			//	ИЛИ ИспользуемыйВидОплаты = ВидыОплатыДоговоров.Рассрочка1Месяц
			//	ИЛИ ИспользуемыйВидОплаты = ВидыОплатыДоговоров.Рассрочка4Месяца Тогда
			//	
			//	Запрос = Новый Запрос;
			//	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
			//	Запрос.Текст =
			//	"ВЫБРАТЬ
			//	|	СУММА(ПриходДенежныхСредств.Сумма) КАК Оплачено,
			//	|	КОЛИЧЕСТВО(ПриходДенежныхСредств.Ссылка) - 1 КАК Платежей
			//	|ИЗ
			//	|	Документ.ПриходДенежныхСредств КАК ПриходДенежныхСредств
			//	|ГДЕ
			//	|	ПриходДенежныхСредств.Субконто2Кт = &Ссылка";
			//	
			//	РезультатЗапроса = Запрос.Выполнить();
			//	Если НЕ РезультатЗапроса.Пустой() Тогда
			//		Выборка = РезультатЗапроса.Выбрать();
			//		Выборка.Следующий();
			//		Оплачено = Выборка.Оплачено;
			//		
			//		Если ИспользуемыйВидОплаты = ВидыОплатыДоговоров.Рассрочка4Месяца Тогда
			//			Сумма = Окр((ДокументОснование.СуммаДокумента - Оплачено) /(4 - Выборка.Платежей), 0, РежимОкругления.Окр15как20);
			//		Иначе
			//			Сумма = Окр(ДокументОснование.СуммаДокумента - Оплачено, 0, РежимОкругления.Окр15как20);
			//		КонецЕсли;
			//		
			//	ИначеЕсли ИспользуемыйВидОплаты = ВидыОплатыДоговоров.Рассрочка1Месяц
			//		ИЛИ ИспользуемыйВидОплаты = ВидыОплатыДоговоров.Рассрочка4Месяца Тогда
			//		
			//		Сумма = Окр((ДокументОснование.СуммаДокумента / 2) + 0.49, 0, РежимОкругления.Окр15как20);
			//	КонецЕсли;
			//	
			//Иначе
			//	Сумма = ДокументОснование.СуммаДокумента;
			//КонецЕсли;
			
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
			
		КонецЕсли;
		
	КонецЕсли;
	
	Печать = Истина;
	
	Сотрудник = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
	
КонецПроцедуры
