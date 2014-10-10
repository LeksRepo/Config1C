﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Период) Тогда
		 Объект.Период = КонецМесяца(ТекущаяДата());
	КонецЕсли;
	 
	ДатаНаФорме = Формат(Объект.Период,"ДФ='ММММ гггг ''г.'''");
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
	ЗаполнитьДанными();
	
КонецПроцедуры
			   
&НаСервере
Процедура ЗаполнитьДанными()
	
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
			
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
		Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Объект.Период));
		Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Объект.Период)-1);
		
		Запрос.Текст = "ВЫБРАТЬ
		               |	УправленческийОстаткиИОбороты.Субконто1 КАК Статья,
		               |	УправленческийОстаткиИОбороты.СуммаКонечныйРазвернутыйОстатокДт КАК Расход,
		               |	УправленческийОстаткиИОбороты.СуммаКонечныйРазвернутыйОстатокКт КАК Доход
					   |ИЗ
		               |	РегистрБухгалтерии.Управленческий.ОстаткиИОбороты(&НачалоПериода, &КонецПериода, Месяц, , Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПрибыльУбытки)), , Подразделение = &Подразделение) КАК УправленческийОстаткиИОбороты";
		Результат = Запрос.Выполнить();
		Объект.Список.Загрузить(Результат.Выгрузить());
	
	КонецЕсли; 
	
КонецПроцедуры
 