﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Для Каждого Документ Из ПараметрКоманды Цикл
		
		Массив = Новый Массив;
		Массив.Добавить(Документ);
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ФиксированныйКомплект", Ложь); 
		ПараметрыПечати.Вставить("ПереопределитьПользовательскиеНастройкиКоличества", Истина);
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ДополнительноеСоглашение", "Соглашение", Массив, ПараметрыВыполненияКоманды.Источник, ПараметрыПечати);
	КонецЦикла;
	
КонецПроцедуры

