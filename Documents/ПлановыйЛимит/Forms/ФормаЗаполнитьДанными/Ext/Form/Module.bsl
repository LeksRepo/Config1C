﻿
&НаКлиенте
Процедура Заполнить(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("КоличествоКоробов", КоличествоКоробов);
	Результат.Вставить("Норматив", Норматив);
	Результат.Вставить("КоличествоДеталей", КоличествоДеталей);
	Результат.Вставить("КоличествоДоставок", КоличествоДоставок);
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры
