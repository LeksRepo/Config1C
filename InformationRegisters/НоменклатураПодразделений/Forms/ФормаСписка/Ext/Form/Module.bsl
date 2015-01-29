﻿
&НаКлиенте
Процедура ГруппаПриИзменении(Элемент)
	
	УстановитьПараметрыЗапроса();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Подразделение = ЛексСервер.ПолучитьЗначениеНастройкиПользователя(ПараметрыСеанса.ТекущийПользователь, ПланыВидовХарактеристик.НастройкиПользователей.Подразделение);
	Если НЕ ЗначениеЗаполнено(Подразделение) ИЛИ Подразделение.ВидПодразделения <> Перечисления.ВидыПодразделений.Производство Тогда
		Подразделение = СлучайноеПодразделение();
	КонецЕсли;
	
	УстановитьПараметрыЗапроса();
	
КонецПроцедуры

&НаСервере
Функция УстановитьПараметрыЗапроса()
	
	//Список.Параметры.УстановитьЗначениеПараметра("Регион", Подразделение.Регион);
	Список.Параметры.УстановитьЗначениеПараметра("Подразделение", Подразделение);
	Список.Параметры.УстановитьЗначениеПараметра("ГруппаНоменклатуры", Группа);
	
КонецФункции

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	УстановитьПараметрыЗапроса();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СлучайноеПодразделение()
	
	// муахахахахаааха какая поебень
	
	Ссылка = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Подразделения.Ссылка
	|ИЗ
	|	Справочник.Подразделения КАК Подразделения
	|ГДЕ
	|	НЕ Подразделения.ПометкаУдаления
	|	И Подразделения.ВидПодразделения = ЗНАЧЕНИЕ(Перечисление.ВидыПодразделений.Производство)";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		Ссылка = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;
	
	Возврат Ссылка;
	
КонецФункции

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Номенклатура = ТекущиеДанные.Номенклатура;
		КлючЗаписи = ПолучитьКлючЗаписи(Номенклатура, Подразделение);
		ПараметрыФормы = Новый Структура;
		Если ЗначениеЗаполнено(КлючЗаписи) Тогда
			ПараметрыФормы.Вставить("Ключ", КлючЗаписи);
		Иначе
			ЗначенияЗаполнения = Новый Структура;
			ЗначенияЗаполнения.Вставить("Номенклатура", Номенклатура);
			ЗначенияЗаполнения.Вставить("Подразделение", Подразделение);
			ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		КонецЕсли;
		
		ОткрытьФорму("РегистрСведений.НоменклатураПодразделений.ФормаЗаписи", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКлючЗаписи(Номенклатура, Подразделение)
	
	КлючЗаписи = Неопределено;
	
	МенеджерЗаписи = РегистрыСведений.НоменклатураПодразделений.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Подразделение = Подразделение;
	МенеджерЗаписи.Номенклатура = Номенклатура;
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		// запись существует, можно получать ключ
		ЗначениеКлюча = Новый Структура;
		ЗначениеКлюча.Вставить("Номенклатура", Номенклатура);
		ЗначениеКлюча.Вставить("Подразделение", Подразделение);
		
		КлючЗаписи = РегистрыСведений.НоменклатураПодразделений.СоздатьКлючЗаписи(ЗначениеКлюча);
		
	КонецЕсли;
	
	Возврат КлючЗаписи;
	
КонецФункции
