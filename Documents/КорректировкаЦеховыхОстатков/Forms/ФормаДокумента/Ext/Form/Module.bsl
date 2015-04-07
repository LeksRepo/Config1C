﻿
&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьСписокНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокНоменклатуры()
	
	Если Объект.СписокНоменклатуры.Количество() > 0 Тогда
		
		Режим = РежимДиалогаВопрос.ДаНет;
		Текст = "Табличные части будут изменены." + Символы.ПС + "Продолжить?";
		
		Если Вопрос(Текст, Режим, 0) = КодВозвратаДиалога.Нет Тогда
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры // ЗаполнитьСписокНоменклатуры()

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОстаткиВЦеху.Субконто1 КАК Номенклатура,
	|	-ОстаткиВЦеху.КоличествоОстатокДт КАК Оприходовать
	|ИЗ
	|	РегистрБухгалтерии.Управленческий.Остатки(&Дата, Счет = ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ОсновноеПроизводство), , Подразделение = &Подразделение) КАК ОстаткиВЦеху
	|ГДЕ
	|	ОстаткиВЦеху.КоличествоОстатокДт < 0";
	
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("Дата", КонецДня(Объект.Дата));
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Объект.СписокНоменклатуры.Загрузить(РезультатЗапроса);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Объект.СписокНоменклатуры.Очистить();
	
КонецПроцедуры
