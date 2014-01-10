﻿
&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	// { Васильев Александр Леонидович [10.01.2014]
	// доработать бы запрос, что б попадали из текущего документа
	// если перезаполняешь
	// } Васильев Александр Леонидович [10.01.2014]
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Производство", Объект.Подразделение);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СпецификацияНеноменклатурныйМатериал.Ссылка КАК Спецификация,
	|	ВЫРАЗИТЬ(СпецификацияНеноменклатурныйМатериал.ГдеКупить КАК СТРОКА(100)) КАК ГдеКупить,
	|	СпецификацияНеноменклатурныйМатериал.ЕдиницаИзмерения,
	|	СпецификацияНеноменклатурныйМатериал.Количество,
	|	СпецификацияНеноменклатурныйМатериал.Наименование,
	|	СпецификацияНеноменклатурныйМатериал.Номенклатура
	|ИЗ
	|	Документ.Спецификация.НеноменклатурныйМатериал КАК СпецификацияНеноменклатурныйМатериал
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗакупНеноменклатурный.НеноменклатурныйМатериал КАК ЗакупНеноменклатурныйНеноменклатурныйМатериал
	|		ПО СпецификацияНеноменклатурныйМатериал.Ссылка = ЗакупНеноменклатурныйНеноменклатурныйМатериал.Спецификация
	|			И СпецификацияНеноменклатурныйМатериал.Наименование = ЗакупНеноменклатурныйНеноменклатурныйМатериал.Наименование
	|			И СпецификацияНеноменклатурныйМатериал.Номенклатура = ЗакупНеноменклатурныйНеноменклатурныйМатериал.Номенклатура
	|			И СпецификацияНеноменклатурныйМатериал.Количество = ЗакупНеноменклатурныйНеноменклатурныйМатериал.Количество
	|ГДЕ
	|	СпецификацияНеноменклатурныйМатериал.Ссылка.Проведен
	|	И СпецификацияНеноменклатурныйМатериал.Ссылка.Производство = &Производство
	|	И ЗакупНеноменклатурныйНеноменклатурныйМатериал.Ссылка ЕСТЬ NULL";
	
	Объект.НеноменклатурныйМатериал.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры
