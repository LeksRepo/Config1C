﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокПараметровОтбора = Элементы.СписокНоменклатурыНоменклатура.ПараметрыВыбора;
	
	НовыйМассивПараметров = Новый Массив;
	Для каждого ЭлементОтбора Из СписокПараметровОтбора Цикл
		НовыйМассивПараметров.Добавить(ЭлементОтбора);
	КонецЦикла;
	
	ОтборНоменклатурнаяГруппа = Новый ФиксированныйМассив(ПолучитьНомГруппы("Листовой"));
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.НоменклатурнаяГруппа", ОтборНоменклатурнаяГруппа));
	
	Элементы.СписокНоменклатурыНоменклатура.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	
	СписокПараметровОтбора = Элементы.СписокХлыстовойНоменклатурыНоменклатура.ПараметрыВыбора;
	
	НовыйМассивПараметров = Новый Массив;
	Для каждого ЭлементОтбора Из СписокПараметровОтбора Цикл
		НовыйМассивПараметров.Добавить(ЭлементОтбора);
	КонецЦикла;
	
	ОтборНоменклатурнаяГруппа = Новый ФиксированныйМассив(ПолучитьНомГруппы("Хлыстовой"));
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.НоменклатурнаяГруппа", ОтборНоменклатурнаяГруппа));
	
	Элементы.СписокХлыстовойНоменклатурыНоменклатура.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНомГруппы(Вид)
	
	НоменклатурныеГруппы = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НоменклатурныеГруппы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НоменклатурныеГруппы КАК НоменклатурныеГруппы
	|ГДЕ
	|	НоменклатурныеГруппы.ВидМатериала = ЗНАЧЕНИЕ(Перечисление.ВидыМатериалов."+Вид+")
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Таблица = РезультатЗапроса.Выгрузить();
		НоменклатурныеГруппы = Таблица.ВыгрузитьКолонку("Ссылка");
		
	КонецЕсли;
	
	Возврат НоменклатурныеГруппы;
	
КонецФункции // ПолучитьГруппыТолькоЛистовойМатериал()

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры
