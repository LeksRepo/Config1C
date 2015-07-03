﻿
Функция СформироватьОтчет(ТабДок, Подразделение, КлиентскаяДата) Экспорт
	
	#Если Никогда Тогда
		ТабДок = Новый ТабличныйДокумент;
	#КонецЕсли
	
	ТабДок.Очистить();
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет = Отчеты.ОтделТехническогоКонтроля.ПолучитьМакет("МакетОтделТехническогоКонтроля");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьВЦеху = Макет.ПолучитьОбласть("ВЦеху");
	ОбластьНаСкладе = Макет.ПолучитьОбласть("НаСкладе");
	
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьСтрокаВыделить = Макет.ПолучитьОбласть("СтрокаВыделить");
	
	ОбластьСтрокаБезКартинки = Макет.ПолучитьОбласть("Строка");
	ОбластьСтрокаВыделитьБезКартинки = Макет.ПолучитьОбласть("СтрокаВыделить");
	
	Для Каждого Рис Из ОбластьСтрокаБезКартинки.Рисунки Цикл
		ОбластьСтрокаБезКартинки.Рисунки.Очистить();
	КонецЦикла;
	
	Для Каждого Рис Из ОбластьСтрокаВыделитьБезКартинки.Рисунки Цикл
		ОбластьСтрокаВыделитьБезКартинки.Рисунки.Очистить();
	КонецЦикла;
		
	ОбластьЗаметка = Макет.ПолучитьОбласть("Заметка");
	
	ОбластьЗаголовок.Параметры.Подразделение = Подразделение;
	Если ЗначениеЗаполнено(КлиентскаяДата) Тогда
		ДатаСоставления = КлиентскаяДата;
	Иначе
		ДатаСоставления = ТекущаяДата();
	КонецЕсли;
	ОбластьЗаголовок.Параметры.ДатаСоставления = ДатаСоставления;
	
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапка);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	докСпецификация.Ссылка КАК Спецификация,
	|	НарядЗаданиеСписокСпецификаций.Ссылка КАК Наряд,
	|	докДоговор.Ссылка КАК Договор,
	|	СтатусСпецификацииСрезПоследних.Статус КАК Статус,
	|	ВЫБОР
	|		КОГДА докДоговор.Ссылка ЕСТЬ NULL 
	|			ТОГДА докСпецификация.Контрагент
	|		ИНАЧЕ докДоговор.Контрагент
	|	КОНЕЦ КАК Контрагент,
	|	докСпецификация.Технолог,
	|	докСпецификация.Технолог.ТелефонРабочий КАК ТелефонТехнолога,
	|	Заметки.Содержание КАК СодержаниеЗаметки,
	|	докСпецификация.ДатаОтгрузки,
	|	докСпецификация.ДатаИзготовления,
	|	докСпецификация.АдресМонтажа КАК Адрес,
	|	докСпецификация.Номер КАК НомерСпецификации,
	|	Заметки.Ссылка КАК Заметка,
	|	докСпецификация.ОсобыеУслуги,
	|	докСпецификация.ЦветЛДСПОсновной,
	|	докСпецификация.ЦветЛДСПДополнительный,
	|	докСпецификация.ЦветВертикальногоПрофиля,
	|	докСпецификация.КомплектацияСклад,
	|	докСпецификация.КомплектацияЦех,
	|	докСпецификация.Дилерский,
	|	докСпецификация.Контрагент.Телефон КАК ТелефонДилера,
	|	докСпецификация.Контрагент КАК Дилер,
	|	докСпецификация.Контрагент.ЮридическоеЛицо КАК ДилерЮридическоеЛицо,
	|	докСпецификация.Контрагент.Фамилия КАК ДилерФамилия,
	|	докСпецификация.Контрагент.Имя КАК ДилерИмя,
	|	докСпецификация.Контрагент.Отчество КАК ДилерОтчество,
	|	докСпецификация.КоличествоМетровЛДСП КАК ПлощадьИзделия,
	|	докСпецификация.КоличествоКоробов,
	|	докСпецификация.Упаковка,
	|	докСпецификация.Изделие.КраткоеНаименование КАК Изделие,
	|	НарядЗаданиеСписокСпецификаций.Ссылка.Номер КАК НомерНаряда,
	|	НарядЗаданиеСписокСпецификаций.Ссылка.ДатаИзготовления КАК ДатаИзготовленияНаряда
	|ИЗ
	|	Документ.Спецификация КАК докСпецификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусСпецификации.СрезПоследних КАК СтатусСпецификацииСрезПоследних
	|		ПО (СтатусСпецификацииСрезПоследних.Спецификация = докСпецификация.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НарядЗадание.СписокСпецификаций КАК НарядЗаданиеСписокСпецификаций
	|		ПО (НарядЗаданиеСписокСпецификаций.Спецификация = докСпецификация.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Договор КАК докДоговор
	|		ПО (докДоговор.Спецификация = докСпецификация.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Заметки КАК Заметки
	|		ПО докСпецификация.Ссылка = Заметки.Предмет
	|ГДЕ
	|	докСпецификация.Подразделение = &Подразделение
	|	И (СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.ПереданВЦех)
	|			ИЛИ СтатусСпецификацииСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификации.Изготовлен))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Статус
	|ИТОГИ
	|	МАКСИМУМ(НомерНаряда),
	|	МАКСИМУМ(ДатаИзготовленияНаряда)
	|ПО
	|	Статус,
	|	Наряд";
	
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаМесто = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаМесто.Следующий() Цикл
		
			Если ВыборкаМесто.Статус = Перечисления.СтатусыСпецификации.Изготовлен Тогда
				ТабДок.Вывести(ОбластьНаСкладе);
			КонецЕсли;
		
		ВыборкаНаряд = ВыборкаМесто.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаНаряд.Следующий() Цикл
			
			Если ВыборкаМесто.Статус = Перечисления.СтатусыСпецификации.ПереданВЦех Тогда
				
				ОбластьВЦеху.Параметры.НомерНаряда = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаНаряд.НомерНаряда);
				ОбластьВЦеху.Параметры.ДатаИзготовленияНаряда = Формат(ВыборкаНаряд.ДатаИзготовленияНаряда, "ДЛФ=DD");
				ТабДок.Вывести(ОбластьВЦеху);
				
			КонецЕсли;
			
			ВыборкаДетальныеЗаписи = ВыборкаНаряд.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
				Если ВыборкаДетальныеЗаписи.ДатаОтгрузки < КлиентскаяДата Тогда
					ОбластьВывод = ОбластьСтрокаВыделить;
				Иначе
					ОбластьВывод = ОбластьСтрока;
				КонецЕсли;
				
				Если ВыборкаДетальныеЗаписи.Спецификация.ПакетУслуг = Перечисления.ПакетыУслуг.СамовывозОтПроизводителя Тогда
					
					Если ВыборкаДетальныеЗаписи.ДатаОтгрузки < КлиентскаяДата Тогда
						ОбластьВывод = ОбластьСтрокаВыделитьБезКартинки;
					Иначе
						ОбластьВывод = ОбластьСтрокаБезКартинки;
					КонецЕсли;
					
				КонецЕсли;	
					
				
				ОбластьВывод.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
				Если ВыборкаДетальныеЗаписи.Адрес = "Введите адрес" Тогда
					ОбластьВывод.Параметры.Адрес = "";
				КонецЕсли;
				
				ПризнакиСпецификации = "%1 / %2 / %3";
				ПризнакиСпецификации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПризнакиСпецификации,
				ВыборкаДетальныеЗаписи.ЦветЛДСПОсновной,
				ВыборкаДетальныеЗаписи.ЦветЛДСПДополнительный,
				ВыборкаДетальныеЗаписи.ЦветВертикальногоПрофиля);
				
				ОбластьВывод.Параметры.ПризнакиСпецификации = ПризнакиСпецификации;
				ОбластьВывод.Параметры.НомерСпецификации = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаДетальныеЗаписи.НомерСпецификации);
				ОбластьВывод.Параметры.ТелефонЗаказчика = ВыборкаДетальныеЗаписи.Контрагент.Телефон;
				
				КоличествоДверей = 0;
				Для каждого СтрокаДверь Из ВыборкаДетальныеЗаписи.Спецификация.СписокДверей Цикл
					КоличествоДверей = КоличествоДверей + СтрокаДверь.Двери.Количество;
				КонецЦикла;
				ОбластьВывод.Параметры.КоличествоДверей = КоличествоДверей;
				
				Если НЕ ВыборкаДетальныеЗаписи.Дилерский Тогда
					ОбластьВывод.Параметры.Технолог = ФизическиеЛица.ФамилияИнициалыФизЛица(ВыборкаДетальныеЗаписи.Технолог);
				Иначе
					ОбластьВывод.Параметры.ТелефонТехнолога = ВыборкаДетальныеЗаписи.ТелефонДилера;
					Если НЕ ВыборкаДетальныеЗаписи.ДилерЮридическоеЛицо Тогда
						ОбластьВывод.Параметры.Технолог = ФизическиеЛица.ФамилияИнициалыФизЛица("" + ВыборкаДетальныеЗаписи.Дилер);
					Иначе
						ОбластьВывод.Параметры.Технолог = ВыборкаДетальныеЗаписи.Дилер;
					КонецЕсли;
					
				КонецЕсли;
				
				ТабДок.Вывести(ОбластьВывод);
				
				Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Заметка) Тогда
					
					ОбластьЗаметка.Параметры.Спецификация = ВыборкаДетальныеЗаписи.Спецификация;
					ОбластьЗаметка.Параметры.Заметка = ВыборкаДетальныеЗаписи.Заметка;
					ОбластьЗаметка.Параметры.СодержаниеЗаметки = ВыборкаДетальныеЗаписи.СодержаниеЗаметки.Получить().ПолучитьТекст();
					
					ТабДок.Вывести(ОбластьЗаметка);
					
				КонецЕсли;
				
			КонецЦикла; // ВыборкаДетальныеЗаписи.Следующий()
			
		КонецЦикла; //ВыборкаНаряд.Следующий()
		
	КонецЦикла; // ВыборкаМесто.Следующий()
	
КонецФункции
