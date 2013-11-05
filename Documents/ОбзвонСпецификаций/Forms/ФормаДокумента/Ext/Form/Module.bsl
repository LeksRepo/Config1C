﻿
&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", НачалоДня(ТекущаяДата() - 5 * 86400));
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	докСпецификация.Ссылка КАК Спецификация,
	|	докСпецификация.Телефон
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК докДоговор
	|		ПО (докДоговор.Спецификация = докСпецификация.Ссылка)
	|ГДЕ
	|	докСпецификация.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ЧастноеЛицо)
	|	И докДоговор.Спецификация ЕСТЬ NULL 
	|	И докСпецификация.Изделие = ЗНАЧЕНИЕ(Справочник.Изделия.Детали)
	|	И докСпецификация.Проведен
	|	И докСпецификация.ДатаОтгрузки <= &Дата";
	
	Объект.СписокСпецификаций.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСпецификацийПередУдалением(Элемент, Отказ)
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Текст = "Удалить обзвон по данной спецификации?";
	
	Если Объект.СписокСпецификаций.Количество() > 0 
		И Вопрос(Текст, Режим, 0) = КодВозвратаДиалога.Нет Тогда
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры
