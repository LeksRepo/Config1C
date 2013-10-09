﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	// прямые
	Проводки = Движения.ВнутренниеВзаиморасчеты.ДобавитьРасход();
	Проводки.Период = Дата;
	Проводки.Подразделение1 = Подразделение;
	Проводки.Подразделение2 = ПодразделениеПолучатель;
	Проводки.Сумма = Сумма;
	
	// обратные
	Проводки = Движения.ВнутренниеВзаиморасчеты.ДобавитьПриход();
	Проводки.Период = Дата;
	Проводки.Подразделение1 = ПодразделениеПолучатель;
	Проводки.Подразделение2 = Подразделение;
	Проводки.Сумма = Сумма;
	
	// оборотка
	Проводки = Движения.ОборотыПоСтатьям.Добавить();
	Проводки.Период = Дата;
	Проводки.Подразделение = Подразделение;
	Проводки.Статья = Справочники.Статьи.РекламацияРасход;
	Проводки.Факт = Сумма;
	
	Проводки = Движения.ОборотыПоСтатьям.Добавить();
	Проводки.Период = Дата;
	Проводки.Подразделение = ПодразделениеПолучатель;
	Проводки.Статья = Справочники.Статьи.РекламацияДоход;
	Проводки.Факт = Сумма;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Подразделение = ПодразделениеПолучатель Тогда
		
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Нельзя выставить рекламацию самому себе";
		Сообщение.Поле = "ПодразделениеПолучатель";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры