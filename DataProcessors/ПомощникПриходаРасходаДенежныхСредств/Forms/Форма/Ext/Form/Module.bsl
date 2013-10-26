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
		Массив = Новый Массив;
		Массив.Добавить(Документ);
		Если Печать И ВидПлатежа = "Приход" Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ПриходДенежныхСредств", "ТоварныйЧек", Массив, Неопределено, Неопределено);
		КонецЕсли;
		
		ОповеститьОбИзменении(Документ);
		
		Закрыть();
		
	КонецЕсли;
	
	ПриСменеСтраницы(Элементы.СтраницыПомощника.ТекущаяСтраница);
	
КонецПроцедуры

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
		НовыйДокумент.Субконто2Дт = Договор;
		НовыйДокумент.Офис = Офис;
		НовыйДокумент.ВидОперации = Перечисления.ВидыОпераций.ВозвратКонтрагентуСОперационнойКассы;
		НовыйДокумент.СчетКт = ПланыСчетов.Управленческий.ОперационнаяКасса;
		НовыйДокумент.Субконто1Кт = Справочники.СтатьиДвиженияДенежныхСредств.ВозвратДенежныхСредствКлиенту; 
		НовыйДокумент.Субконто2Кт = Сотрудник;
	ИначеЕсли ВидПлатежа = "Приход" Тогда
		НовыйДокумент = Документы.ПриходДенежныхСредств.СоздатьДокумент();
		НовыйДокумент.СчетКт = ПланыСчетов.Управленческий.ВзаиморасчетыСПокупателями;
		НовыйДокумент.Субконто1Кт = Контрагент;
		НовыйДокумент.Субконто2Кт = Договор;
		НовыйДокумент.Офис = Офис;
		Если СпособПлатежа = "Нал" Тогда
			НовыйДокумент.ВидОперации = Перечисления.ВидыОпераций.ОплатаОтПокупателяВОперационнуюКассу;
			НовыйДокумент.СчетДт = ПланыСчетов.Управленческий.ОперационнаяКасса;
			Если Контрагент = Справочники.Контрагенты.ЧастноеЛицо Тогда
				СтатьяПоступления = Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтЧастныхЛицПоСпецификациям;
			Иначе
				СтатьяПоступления = Справочники.СтатьиДвиженияДенежныхСредств.ПоступленияОтРозничныхКлиентов;
			КонецЕсли;
			НовыйДокумент.Субконто1Дт = СтатьяПоступления;//Справочники.СтатьиДвиженияДенежныхСредств.СтатьяПоступления;
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
	
	Если Параметры.Свойство("Договор") Тогда
		
		Договор 							= Параметры.Договор;
		Контрагент 						= Договор.Контрагент;
		Подразделение 					= Договор.Подразделение;
		ВидПлатежа 						= "Приход";
		СпособПлатежа 					= "Нал";
		Офис 								= Договор.Офис;
		ВидыОплатыДоговоров 		= Перечисления.ВидыОплатыДоговоров;
		ИспользуемыйВидОплаты 	= Договор.ВидОплатыДоговора;
		ПоловинаОплаты = ИспользуемыйВидОплаты = ВидыОплатыДоговоров.Предоплата50БанковскийКредит или ИспользуемыйВидОплаты = ВидыОплатыДоговоров.Рассрочка1Месяц 
			или ИспользуемыйВидОплаты = ВидыОплатыДоговоров.Рассрочка4Месяца;
			
		Если ПоловинаОплаты Тогда
			
			Сумма = Договор.СуммаДокумента / 2;
			
		Иначе
			
			Сумма = Договор.СуммаДокумента;
			
		КонецЕсли;
		
	ИначеЕсли Параметры.Свойство("ДополнительноеСоглашение") Тогда
		
		Договор 			= Параметры.ДополнительноеСоглашение;
		Контрагент 		= Договор.Договор.Контрагент;
		Подразделение 	= Договор.Договор.Подразделение;
		ВидПлатежа 		= ?(Договор.СуммаДокумента > 0, "Приход", "Расход");
		СпособПлатежа 	= "Нал";
		Офис 				= Договор.Офис;
		Сумма 				= ?(Договор.СуммаДокумента > 0, Договор.СуммаДокумента, Договор.СуммаДокумента * (-1));
		
	ИначеЕсли Параметры.Свойство("Спецификация") Тогда
		
		Договор 			= Параметры.Спецификация;
		Контрагент 		= Договор.Контрагент;
		Подразделение 	= Договор.Подразделение;
		ВидПлатежа 		= "Приход";
		СпособПлатежа 	= "Нал";
		Офис 				= Договор.Офис;
		Сумма 				= Договор.СуммаДокумента;
		
	КонецЕсли;
	
	Сотрудник = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
	
КонецПроцедуры
