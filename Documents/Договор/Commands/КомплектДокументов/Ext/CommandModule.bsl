﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	МассивДоговоров = ВыборМакетов(ПараметрКоманды);
	Для Каждого Договор Из МассивДоговоров Цикл
		
		МассивДокумент = Новый Массив;
		МассивДокумент.Вставить(0, Договор.Договор);
		МакетЭскиза = ?(ЗначениеЗаполнено(Договор.ЭскизнаяЗаявка), Договор.Инструкция + Договор.ПоКаталогу + Договор.ЭскизнаяЗаявка + Договор.ЧертежДвери, Строка(Договор.ПоКаталогу) + Строка(Договор.ЧертежДвери));

		Если ЗначениеЗаполнено(Договор.ЧертежДвери) Тогда
			Документ = Новый Структура;
			Документ.Вставить("МассивОбъектов", МассивДокумент);
			//Документ.Вставить("Двери", Новый Массив);
			//Массив специально для процедуры УправлениеПечатьюКлиент.ПроверитьДокументыПроведены
			ПараметрыФормыФлэш = Новый Структура;
			ПараметрыФормыФлэш.Вставить("ХранимыйФайл", "ЧертежДвери");
			ПараметрыФормыФлэш.Вставить("МассивДверейФлэш", Договор.ДвериФлэш);
			ПараметрыФормыФлэш.Вставить("МассивДверейСсылки", Договор.ДвериСсылка);
			ПараметрыФормыФлэш.Вставить("Договор", Договор.Договор);
			Значение = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормыФлэш);
			Документ.Вставить("Двери", Значение);
			//Для каждого Дверь Из Договор.Двери Цикл
			//	
			//	ПараметрыФормыФлэш.Вставить("ХранимыйФайл", "ЧертежДвери");
			//	ПараметрыФормыФлэш.Вставить("СтрокаДвериФлэш", Дверь);
			//	//Открывать формуфлэш получать для каждой двери бэйс64код чертежа, возвращать назад
			//	Значение = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормыФлэш);
			//	Документ.Двери.Добавить(Значение);
			//КонецЦикла;
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
Функция ВыборМакетов(Договоры)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Договоры", Договоры);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
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
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ_Договоры.Спецификация,
	|	ВТ_Договоры.Договор КАК Договор,
	|	ВТ_Договоры.Инструкция КАК Инструкция,
	|	ВТ_Договоры.Шкаф,
	|	ВТ_Договоры.ИзделийПоКаталогу,
	|	Двери.СтрокаДляФлэш КАК СтрокаДляФлэш,
	|	Двери.Ссылка КАК Дверь,
	|	ВЫБОР
	|		КОГДА ВТ_Договоры.Шкаф
	|				И ВТ_Договоры.ИзделийПоКаталогу > 0
	|			ТОГДА "",ШкафПоКаталогу""
	|		КОГДА НЕ ВТ_Договоры.Шкаф
	|				И ВТ_Договоры.ИзделийПоКаталогу > 0
	|			ТОГДА "",ПоКаталогу""
	|	КОНЕЦ КАК ПоКаталогу,
	|	ВЫБОР
	|		КОГДА Файлы.Ссылка ССЫЛКА Справочник.Файлы
	|			ТОГДА "",ЭскизнаяЗаявка""
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ЭскизнаяЗаявка
	|ИЗ
	|	ВТ_Договоры КАК ВТ_Договоры
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Файлы КАК Файлы
	|		ПО (НЕ Файлы.ПометкаУдаления)
	|			И (Файлы.ВидФайла = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.Эскиз))
	|			И (ВТ_Договоры.Договор.Спецификация = (ВЫРАЗИТЬ(Файлы.ВладелецФайла КАК Документ.Спецификация)))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Двери КАК Двери
	|		ПО ВТ_Договоры.Спецификация.СписокДверей.Двери = Двери.Ссылка
	|ИТОГИ
	|	МАКСИМУМ(Инструкция),
	|	КОЛИЧЕСТВО(СтрокаДляФлэш),
	|	МАКСИМУМ(ПоКаталогу),
	|	МАКСИМУМ(ЭскизнаяЗаявка)
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
		СтруктураДоговора.Вставить("ЭскизнаяЗаявка", ?(ЗначениеЗаполнено(ВыборкаГруппа.ЭскизнаяЗаявка), ВыборкаГруппа.ЭскизнаяЗаявка, Неопределено));
		СтруктураДоговора.Вставить("ЧертежДвери", Неопределено);
		//littox Литус Антон - 19.08.2014
		//Проблема с флешем возникла на договоре 965
		//19.08.2014 - littox Литус Антон 
		Если ЗначениеЗаполнено(ВыборкаГруппа.СтрокаДляФлэш) Тогда
			СтруктураДоговора.Вставить("ЧертежДвери", ",ЧертежДвери"); 
			СтруктураДоговора.Вставить("ДвериФлэш", Новый Массив);
			СтруктураДоговора.Вставить("ДвериСсылка", Новый Массив);
			ЗаписьПоДоговору = ВыборкаГруппа.Выбрать();	
			Пока ЗаписьПоДоговору.Следующий() Цикл
				СтруктураДоговора.ДвериФлэш.Добавить(ЗаписьПоДоговору.СтрокаДляФлэш);
				СтруктураДоговора.ДвериСсылка.Добавить(ЗаписьПоДоговору.Дверь);
			КонецЦикла;
			
		КонецЕсли;
		МассивДокументов.Добавить(СтруктураДоговора);
	КонецЦикла;
	
	Возврат МассивДокументов;
	
КонецФункции
//&НаКлиенте
//Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
//	Для Каждого Документ Из ПараметрКоманды Цикл
//		
//		Структура = ВыборМакетов(Документ);
//		МассивДокументов = Новый Массив;
//		МассивДокументов.Вставить(0, Документ);
//		
//		МакетЭскиза = ?(ЗначениеЗаполнено(Структура.ЭскизнаяЗаявка), Структура.Инструкция + Структура.ПоКаталогу + Структура.ЭскизнаяЗаявка, Структура.ПоКаталогу);
//		
//		Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(МассивДокументов, ПараметрыВыполненияКоманды.Источник) Тогда
//			
//			ПараметрыПечати = Новый Структура;
//			ПараметрыПечати.Вставить("ФиксированныйКомплект", Ложь);
//			ПараметрыПечати.Вставить("ПереопределитьПользовательскиеНастройкиКоличества", Истина);

//			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Договор","Договор,УсловияДоставкиВыписка,ТитульныйЛистТПМК"
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
//	Структура.Вставить("ПоКаталогу", Неопределено);
//	Структура.Вставить("ЭскизнаяЗаявка", Неопределено);
//	
//	Запрос = Новый Запрос;
//	Запрос.УстановитьПараметр("Спецификация", Спецификация);
//	Запрос.УстановитьПараметр("ВидФайла", Перечисления.ВидыПрисоединенныхФайлов.Эскиз);
//	Запрос.Текст =
//		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
//		|	Файлы.Ссылка КАК ПрикрепленныйФайл
//		|ИЗ
//		|	Справочник.Файлы КАК Файлы
//		|ГДЕ
//		|	Файлы.ВладелецФайла = &Спецификация
//		|	И НЕ Файлы.ПометкаУдаления
//		|   И Файлы.ВидФайла = &ВидФайла";
//		
//		Выборка = Запрос.Выполнить().Выбрать();
//	
//	Если Выборка.Следующий() Тогда
//	
//		Структура.ЭскизнаяЗаявка=",ЭскизнаяЗаявка";
//	
//	КонецЕсли; 
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





