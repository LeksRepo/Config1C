﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//Если ПараметрКоманды <> Неопределено И ПараметрКоманды.Количество() > 0 Тогда
	//	КоличествоДней = 7;
	//	ВвестиЧисло(КоличествоДней, "На сколько дней вперёд?", 2 , 0);

	//	НачалоПериода = НачалоДня(ПолучитьДатуМонтажаИзГрафика(ПараметрКоманды[0]));
	//	КонецПериода = НачалоПериода + (КоличествоДней) * 86400 - 1;
	//	
	//	ТабДок = Новый ТабличныйДокумент;
	//	
	//	ВыбранноеПодразделение = Неопределено;//ПолучитьПодразделениеПользователя();
	//	Пока ВыбранноеПодразделение = Неопределено Цикл
	//		ВыбранноеПодразделение = ОткрытьФормуМодально("Справочник.Подразделения.ФормаВыбора");//.Подразделения.Форма.ФормаВыбораОтбор");
	//	КонецЦикла;
	//	
	//	ПечатьГрафикМонтажа(ТабДок, ПараметрКоманды, НачалоПериода, КонецПериода, ВыбранноеПодразделение);
	//	
	//	ТабДок.АвтоМасштаб = Истина;
	//	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	//	ТабДок.ОтображатьСетку = Ложь;
	//	ТабДок.Защита = Ложь;
	//	ТабДок.ТолькоПросмотр = Истина;
	//	ТабДок.ОтображатьЗаголовки = Ложь;
	//	ТабДок.Показать("График монтажа");
	//	
	//КонецЕсли;
	ОткрытьФорму("Отчет.ГрафикМонтажа.Форма.ФормаОтчета");
	
КонецПроцедуры

//&НаСервере
//Процедура ПечатьГрафикМонтажа(ТабДок, ПараметрКоманды, НачалоПериода, КонецПериода, Подразделение)
//	
//	Документы.Монтаж.ПечатьГрафикМонтажа(ТабДок, ПараметрКоманды, НачалоПериода, КонецПериода, Подразделение);
//	
//КонецПроцедуры

//&НаСервере
//Функция ПолучитьПодразделениеПользователя()

//	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;//ОбщегоНазначения.пПолучитьПараметрСеанса("ТекущийПользователь");
//	Подразделение = ТекПользователь.ФизическоеЛицо.Подразделение;
//	Если ЗначениеЗаполнено(Подразделение) Тогда
//		Результат = Подразделение;
//	Иначе
//		Результат = Неопределено;
//	КонецЕсли;
//	
//	Возврат Результат;

//КонецФункции

//&НаСервере
//Функция ПолучитьДатуМонтажаИзГрафика(Док)
//	
//	Результат = '00010101';
//	Дата = Док.Договор.Спецификация.ДатаМонтажа;
//	Если ЗначениеЗаполнено(Дата) Тогда
//		Результат = Дата;
//	КонецЕсли;
//	
//	Возврат Результат;

//КонецФункции // ПолучитьПодразделениеПользователя()