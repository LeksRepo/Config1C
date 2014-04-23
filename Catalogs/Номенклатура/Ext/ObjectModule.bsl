﻿
Перем НоваяНоменклатура;

Процедура ПередЗаписью(Отказ)
	
	Если ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Услуга Тогда
		Базовый = Истина;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа И Базовый Тогда
		КоэффициентБазовых = 1;
	КонецЕсли;
	
	НоваяНоменклатура = ЭтоНовый();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Материал И НЕ Базовый И БазоваяНоменклатура.Пустая() Тогда
		
		Отказ = Истина;
		ТекстСообщения = "Заполните базовую номенклатуру";
		Поле = "БазоваяНоменклатура";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если НоваяНоменклатура И НЕ ЭтоГруппа И ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Материал Тогда
		
		ДоступностьПодразделению = РегистрыСведений.НоменклатураПодразделений;
		НаборПодразделение = ДоступностьПодразделению.СоздатьНаборЗаписей();
		
		Выборка = Справочники.Подразделения.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Если Выборка.ВидПодразделения = Перечисления.ВидыПодразделений.Производство Тогда
				НоваяСтрока = НаборПодразделение.Добавить();
				НоваяСтрока.Номенклатура = Ссылка;
				НоваяСтрока.Подразделение = Выборка.Ссылка;
				НоваяСтрока.Доступность = Истина;
			КонецЕсли;
		КонецЦикла;
		
		НаборПодразделение.Записать(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

