﻿
&НаКлиенте
Процедура Сформировать(Команда)
	
	СкомпоноватьРезультат();
	
	Если Результат.Рисунки.Количество()>0 Тогда
		Результат.Рисунки[0].Ширина = 300;
	КонецЕсли;	
		
КонецПроцедуры