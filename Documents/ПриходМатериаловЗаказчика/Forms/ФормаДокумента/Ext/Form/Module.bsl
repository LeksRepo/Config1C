﻿
&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаКлиенте();
	
	Если Объект.Материалы.Количество() > 0 Тогда
		
		Ответ = Вопрос("Таблица будет перезаполнена. Продолжить?", РежимДиалогаВопрос.ДаНет);
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			ЗаполнитьНаСервере();
			
		КонецЕсли;
		
	Иначе
		
		ЗаполнитьНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Объект.Материалы.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СпецификацияСписокНоменклатуры.Номенклатура,
		|	СпецификацияСписокНоменклатуры.Количество
		|ИЗ
		|	Документ.Спецификация.СписокНоменклатуры КАК СпецификацияСписокНоменклатуры
		|ГДЕ
		|	СпецификацияСписокНоменклатуры.ПредоставитЗаказчик
		|	И СпецификацияСписокНоменклатуры.Ссылка = &Спецификация";

	Запрос.УстановитьПараметр("Спецификация", Объект.Спецификация);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НоваяСтрока = Объект.Материалы.Добавить();
		НоваяСтрока.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
		НоваяСтрока.Количество = ВыборкаДетальныеЗаписи.Количество;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СпецификацияПриИзменении(Элемент)
	
	ЗаполнитьНаКлиенте();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры
