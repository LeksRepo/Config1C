﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Структура = ПолучитьСтруктуруОснование(ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура("Основание, Подразделение", ПараметрКоманды, Структура.Подразделение);
	ОткрытьФорму("Отчет.ЗамерыИВстречам.Форма.ФормаОтчета", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруОснование(Основание)

	Структура = Новый Структура;
	Структура.Вставить("Подразделение", Основание.Подразделение);
	//Структура.Вставить("Ответственный", Основание.Агент);
	
	Возврат Структура;

КонецФункции 
