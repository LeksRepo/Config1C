﻿
//&НаКлиенте
//Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
//	Для Каждого Документ Из ПараметрКоманды Цикл
//		
//		Структура = ВыборМакетов(Документ);
//		МассивДокументов = Новый Массив;
//		МассивДокументов.Вставить(0, Документ);
//		
//		МакетЭскиза = ?(ЗначениеЗаполнено(Структура.Эскиз), Структура.Инструкция + Структура.Эскиз + Структура.ПоКаталогу + Структура.ЭскизнаяЗаявка, Структура.ПоКаталогу);
//		
//		//RonEXI remake: Убрать эту строчку
//		МакетЭскиза=Структура.Инструкция + Структура.Эскиз + Структура.ПоКаталогу + Структура.ЭскизнаяЗаявка;
//		
//		Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(МассивДокументов, ПараметрыВыполненияКоманды.Источник) Тогда
//			
//			ПараметрыПечати = Новый Структура;
//			ПараметрыПечати.Вставить("ФиксированныйКомплект", Ложь);
//			ПараметрыПечати.Вставить("ПереопределитьПользовательскиеНастройкиКоличества", Истина);
// 
//			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Договор",
//			"Договор,УсловияДоставкиВыписка,ТитульныйЛистТПМК"
//			+ МакетЭскиза,
//			МассивДокументов,
//			ПараметрыВыполненияКоманды,
//			Неопределено);
//			
//		КонецЕсли;
//		
//	КонецЦикла;
//	
//КонецПроцедуры

//&НаСервере
//Функция ВыборМакетов(Документ)
//	
//	Спецификация = Документ.Спецификация;
//	Структура = Новый Структура;
//	Структура.Вставить("Инструкция", ","+ Документ.Спецификация.Изделие.ИмяМакетаПаспорта);
//	Структура.Вставить("Эскиз", Неопределено);
//	Структура.Вставить("ПоКаталогу", Неопределено);
//	//RonEXI remake: Показывать эскизную заявку в зависимости от файла с подходящим типом
//	Структура.Вставить("ЭскизнаяЗаявка", ",ЭскизнаяЗаявка");
//	
//	Запрос = Новый Запрос;
//	Запрос.УстановитьПараметр("Ссылка", Спецификация);
//	Запрос.Текст =
//	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
//	|	Файлы.Ссылка,
//	|	Файлы.ВладелецФайла
//	|ИЗ
//	|	Справочник.Файлы КАК Файлы
//	|ГДЕ
//	|	Файлы.ВладелецФайла ССЫЛКА Документ.Спецификация
//	|	И Файлы.ВладелецФайла.Ссылка = &Ссылка";
//	
//	Выборка = Запрос.Выполнить().Выбрать();
//	
//	КоличествоФайлов = 0;
//	
//	Пока Выборка.Следующий() Цикл
//		
//		КоличествоФайлов = ?(Выборка.ВладелецФайла = Спецификация, КоличествоФайлов + 1, КоличествоФайлов);
//		
//	КонецЦикла;
//	
//	//Если КоличествоФайлов > 0 Тогда
//	//	
//	//	Структура.Вставить("Эскиз", ",Эскиз");
//	//	
//	//КонецЕсли;
//	
//	Если Спецификация.СписокИзделийПоКаталогу.Количество() > 0 Тогда
//		
//		Если Спецификация.Изделие.ВидИзделия = Перечисления.ВидыИзделий.ШкафКупе Тогда
//			
//			Структура.Вставить("ПоКаталогу", ",ШкафПоКаталогу");
//			
//		Иначе
//			
//			Структура.Вставить("ПоКаталогу", ",ПоКаталогу");
//			
//		КонецЕсли;
//	КонецЕсли;
//	
//	Возврат Структура;
//	
//КонецФункции // ВыборМакетов()



&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	МассивДоговоров = ПолучитьДвери(ПараметрКоманды);
	Для Каждого Договор Из МассивДоговоров Цикл
		
		МассивДокумент = Новый Массив;
		МассивДокумент.Вставить(0, Договор.Договор);
		//Эскиза же всеравно нет тут пока что вечный фолс
		//МакетЭскиза = ?(ЗначениеЗаполнено(Договор.Эскиз), Договор.Инструкция + Договор.Эскиз + Договор.ПоКаталогу + Договор.ЭскизнаяЗаявка + Договор.ЧертежДвери, Договор.ПоКаталогу);
		
		//RonEXI remake: Убрать эту строчку
		МакетЭскиза=Договор.Инструкция + Договор.Эскиз + Договор.ПоКаталогу + Договор.ЭскизнаяЗаявка + Договор.ЧертежДвери;
		
		Если ЗначениеЗаполнено(Договор.ЧертежДвери) Тогда
			Документ = Новый Структура;
			Документ.Вставить("МассивОбъектов", МассивДокумент);
			Документ.Вставить("Двери", Новый Массив);
			//Массив специально для процедуры УправлениеПечатьюКлиент.ПроверитьДокументыПроведены 
			Для каждого Дверь Из Договор.Двери Цикл
				ПараметрыФормыФлэш = Новый Структура;
				ПараметрыФормыФлэш.Вставить("ХранимыйФайл", "ЧертежДвери");
				ПараметрыФормыФлэш.Вставить("СтрокаДвериФлэш", Дверь);
				//Открывать формуфлэш получать для каждой двери бэйс64код чертежа, возвращать назад
				//Значение = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормыФлэш);
				//Документ.Двери.Добавить(Значение);
			КонецЦикла;
		Иначе
			Документ = МассивДокумент; 
		КонецЕсли;
		
		Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(МассивДокумент, ПараметрыВыполненияКоманды.Источник) Тогда
			
			ПараметрыПечати = Новый Структура;
			ПараметрыПечати.Вставить("ФиксированныйКомплект", Ложь);
			ПараметрыПечати.Вставить("ПереопределитьПользовательскиеНастройкиКоличества", Истина);
 
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Договор",
			"Договор,УсловияДоставкиВыписка,ТитульныйЛистТПМК"
			+ МакетЭскиза,
			Документ,
			ПараметрыВыполненияКоманды,
			ПараметрыПечати);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДвери(Договоры)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Договоры", Договоры);
	//
	//Запрос на случай если понадобится макет эскиза, но нужно немного поправить
	//т.к. в этом запросе ПоКаталогу заполняется не правильно, в рабочем запросе -ОК  
	//
	//Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	Договор.Спецификация КАК Спецификация,
	//|	Договор.Ссылка КАК Договор,
	//|	Договор.Спецификация.Изделие.ИмяМакетаПаспорта КАК Инструкция,
	//|	ВЫБОР
	//|		КОГДА Договор.Спецификация.Изделие.ВидИзделия = ЗНАЧЕНИЕ(Перечисление.ВидыИзделий.ШкафКупе)
	//|			ТОГДА "",ШкафПоКаталогу""
	//|		ИНАЧЕ "",ПоКаталогу""
	//|	КОНЕЦ КАК ПоКаталогу,
	//|	МАКСИМУМ(ВЫБОР
	//|			КОГДА Файлы.Ссылка ССЫЛКА Справочник.Файлы
	//|				ТОГДА "",Эскиз""
	//|			ИНАЧЕ НЕОПРЕДЕЛЕНО
	//|		КОНЕЦ) КАК Эскиз
	//|ПОМЕСТИТЬ ВТ_Договоры
	//|ИЗ
	//|	Документ.Договор КАК Договор
	//|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Файлы КАК Файлы
	//|		ПО (Договор.Спецификация = (ВЫРАЗИТЬ(Файлы.ВладелецФайла КАК Документ.Спецификация)))
	//|ГДЕ
	//|	Договор.Ссылка В(&Договоры)
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	Договор.Ссылка,
	//|	Договор.Спецификация,
	//|	Договор.Спецификация.Изделие.ИмяМакетаПаспорта,
	//|	ВЫБОР
	//|		КОГДА Договор.Спецификация.Изделие.ВидИзделия = ЗНАЧЕНИЕ(Перечисление.ВидыИзделий.ШкафКупе)
	//|			ТОГДА "",ШкафПоКаталогу""
	//|		ИНАЧЕ "",ПоКаталогу""
	//|	КОНЕЦ
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ВТ_Договоры.Спецификация,
	//|	ВТ_Договоры.Договор КАК Договор,
	//|	ВТ_Договоры.Инструкция,
	//|	ВТ_Договоры.ПоКаталогу,
	//|	ВТ_Договоры.Эскиз,
	//|	Двери.СтрокаДляФлэш
	//|ИЗ
	//|	ВТ_Договоры КАК ВТ_Договоры
	//|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Двери КАК Двери
	//|		ПО ВТ_Договоры.Спецификация.Ссылка = Двери.Спецификация
	//|ИТОГИ
	//|	МАКСИМУМ (Эскиз),
	//|	МАКСИМУМ (ПоКаталогу),
	//|	МАКСИМУМ (Инструкция)
	//|ПО
	//|	Договор";
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(Договор.Спецификация) КАК Спецификация,
	|	Договор.Ссылка КАК Договор,
	|	МАКСИМУМ("","" + Договор.Спецификация.Изделие.ИмяМакетаПаспорта) КАК Инструкция,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА Договор.Спецификация.Изделие.ВидИзделия = ЗНАЧЕНИЕ(Перечисление.ВидыИзделий.ШкафКупе)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК Шкаф,
	|	КОЛИЧЕСТВО(СпецификацияСписокИзделийПоКаталогу.Ссылка) КАК ИзделийПоКаталогу
	|ПОМЕСТИТЬ ВТ_Договоры
	|ИЗ
	|	Документ.Договор КАК Договор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СписокИзделийПоКаталогу КАК СпецификацияСписокИзделийПоКаталогу
	|		ПО Договор.Спецификация = СпецификацияСписокИзделийПоКаталогу.Ссылка
	|ГДЕ
	|	Договор.Ссылка В(&Договоры)
	|
	|СГРУППИРОВАТЬ ПО
	|	Договор.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Договоры.Спецификация,
	|	ВТ_Договоры.Договор,
	|	ВТ_Договоры.Инструкция,
	|	ВТ_Договоры.Шкаф,
	|	ВТ_Договоры.ИзделийПоКаталогу,
	|	Двери.СтрокаДляФлэш,
	|	ВЫБОР
	|		КОГДА ВТ_Договоры.Шкаф И ВТ_Договоры.ИзделийПоКаталогу > 0
	|			ТОГДА "",ШкафПоКаталогу""
	|		КОГДА НЕ ВТ_Договоры.Шкаф И ВТ_Договоры.ИзделийПоКаталогу > 0
	|			ТОГДА "",ПоКаталогу""
	|	КОНЕЦ КАК ПоКаталогу
	|ИЗ
	|	ВТ_Договоры КАК ВТ_Договоры
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Двери КАК Двери
	|		ПО ВТ_Договоры.Спецификация = Двери.Спецификация
	|ИТОГИ
	|	КОЛИЧЕСТВО(СтрокаДляФлэш),
	|	МАКСИМУМ (ПоКаталогу),
	|	МАКСИМУМ (Инструкция)
	|ПО
	|	Договор";
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаГруппа = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Договор");
	
	МассивДокументов = Новый Массив;
	
	Пока ВыборкаГруппа.Следующий() Цикл
		СтруктураДоговора = Новый Структура;	
		СтруктураДоговора.Вставить("Договор", ВыборкаГруппа.Договор);
		СтруктураДоговора.Вставить("Инструкция", ВыборкаГруппа.Инструкция);
		СтруктураДоговора.Вставить("ПоКаталогу", ?(ЗначениеЗаполнено(ВыборкаГруппа.ПоКаталогу), ВыборкаГруппа.ПоКаталогу, Неопределено));
		//Пока оставлю эту строку, потом надо уточнить что с эскизом
		СтруктураДоговора.Вставить("Эскиз", Неопределено);
		//RonEXI remake: Показывать эскизную заявку в зависимости от файла с подходящим типом
		//Пока поставим неопределено, т.к. нет макета
		СтруктураДоговора.Вставить("ЭскизнаяЗаявка", Неопределено); //",ЭскизнаяЗаявка");
		СтруктураДоговора.Вставить("ЧертежДвери", Неопределено);
		
		Если ЗначениеЗаполнено(ВыборкаГруппа.СтрокаДляФлэш) Тогда
			СтруктураДоговора.Вставить("ЧертежДвери", ",ЧертежДвери"); 
			СтруктураДоговора.Вставить("Двери", Новый Массив);
			ЗаписьПоДоговору = ВыборкаГруппа.Выбрать();	
			Пока ЗаписьПоДоговору.Следующий() Цикл
				СтруктураДоговора.Двери.Добавить(ЗаписьПоДоговору.СтрокаДляФлэш);
			КонецЦикла;
			
		КонецЕсли;
		МассивДокументов.Добавить(СтруктураДоговора);
	КонецЦикла;
	
	Возврат МассивДокументов;
	
КонецФункции

