﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ЛексСервер.ПроверитьПодразделение(ПараметрКоманды) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Выбраны документы разных подразделений.");
		Возврат;
	КонецЕсли;
	
	МассивМакетов = ОпределитьМакеты(ПараметрКоманды);
	
	Если ЗначениеЗаполнено(МассивМакетов) Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ТребованиеНакладная", СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(МассивМакетов), ПараметрКоманды, ПараметрыВыполненияКоманды, Неопределено);
	Иначе
		Предупреждение("Документы на печать отсутствуют!");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОпределитьМакеты(Документы)
	
	МассивМакетов = Новый Массив;
	МассивМакетов.Добавить("ПечатьТребованиеНакладная");
	МассивМакетов.Добавить("ПечатьРулонныйМатериал");
	МассивМакетов.Добавить("ПечатьХлыстовойМатериал");
	МассивМакетов.Добавить("ПечатьЛистовойМатериал");
	
	Возврат МассивМакетов;
	
КонецФункции

