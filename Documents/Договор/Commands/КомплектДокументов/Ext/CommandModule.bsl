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
			Документ.Вставить("Двери", Новый Массив);
			
			Сч = 0;
			
			Пока Сч < Договор.ДвериФлэш.Количество() Цикл
				
				ДвериФлэш = Новый Массив;
				ДвериФлэш.Добавить(Договор.ДвериФлэш[Сч]);
				
				ДвериСсылка = Новый Массив;
				ДвериСсылка.Добавить(Договор.ДвериСсылка[Сч]);
			
				ПараметрыФормыФлэш = Новый Структура;
				ПараметрыФормыФлэш.Вставить("ХранимыйФайл", "ЧертежДвери");
				ПараметрыФормыФлэш.Вставить("МассивДверейФлэш", ДвериФлэш);
				ПараметрыФормыФлэш.Вставить("МассивДверейСсылки", ДвериСсылка);
				ПараметрыФормыФлэш.Вставить("Договор", Договор.Договор);
				Значение = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаФлэш", ПараметрыФормыФлэш);
				Документ.Двери.Добавить(Значение);
				
				Сч = Сч+1;
				
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
	|	КОНЕЦ КАК ЭскизнаяЗаявка,
	|	СпецификацияСписокДверей.Двери
	|ПОМЕСТИТЬ ВТ_ДоговорДвери
	|ИЗ
	|	ВТ_Договоры КАК ВТ_Договоры
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Файлы КАК Файлы
	|		ПО (НЕ Файлы.ПометкаУдаления)
	|			И (Файлы.ВидФайла = ЗНАЧЕНИЕ(Перечисление.ВидыПрисоединенныхФайлов.Эскиз))
	|			И (ВТ_Договоры.Договор.Спецификация = (ВЫРАЗИТЬ(Файлы.ВладелецФайла КАК Документ.Спецификация)))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Спецификация.СписокДверей КАК СпецификацияСписокДверей
	|		ПО ВТ_Договоры.Спецификация = СпецификацияСписокДверей.Ссылка
	|			И ВТ_Договоры.Спецификация = СпецификацияСписокДверей.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ_ДоговорДвери.Спецификация,
	|	ВТ_ДоговорДвери.Договор КАК Договор,
	|	ВТ_ДоговорДвери.Инструкция КАК Инструкция,
	|	ВТ_ДоговорДвери.Шкаф,
	|	ВТ_ДоговорДвери.ИзделийПоКаталогу,
	|	ВТ_ДоговорДвери.ПоКаталогу КАК ПоКаталогу,
	|	ВТ_ДоговорДвери.ЭскизнаяЗаявка КАК ЭскизнаяЗаявка,
	|	спрДвери.СтрокаДляФлэш КАК СтрокаДляФлэш,
	|	спрДвери.Ссылка КАК Дверь
	|ИЗ
	|	ВТ_ДоговорДвери КАК ВТ_ДоговорДвери
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Двери КАК спрДвери
	|		ПО ВТ_ДоговорДвери.Двери = спрДвери.Ссылка
	|ИТОГИ
	|	МАКСИМУМ(Инструкция),
	|	МАКСИМУМ(ПоКаталогу),
	|	МАКСИМУМ(ЭскизнаяЗаявка),
	|	КОЛИЧЕСТВО(СтрокаДляФлэш)
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





