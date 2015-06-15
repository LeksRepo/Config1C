﻿
&НаКлиенте
Процедура Перенести(Команда)
	
	ФМ = РазложитьСтроку(Формула, Символы.ПС);
	Формула = СобратьМассив(ФМ, "");
	
	ОповеститьОВыборе(Формула);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.Заголовок = Параметры.ИмяПеременной; 
	Формула = Параметры.Формула;
	Режим = Параметры.Режим;
	ЗаполнитьДоступныеПеременные();	
	ЗаполнитьПеременные();
	
	Если Режим = "СхемаЯщика" Тогда 
	
		Формулы.Параметры.УстановитьЗначениеПараметра("ТипФормулы", "Ящики");
		
	КонецЕсли;
	
	Если Режим = "Каталог" Тогда 
	
		Формулы.Параметры.УстановитьЗначениеПараметра("ТипФормулы", "Каталог");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоступныеПеременные()
	
	Если Режим = "Каталог" Тогда
		
			ДоступныеПеременные.Добавить("ШиринаИзделия");
			ДоступныеПеременные.Добавить("ВысотаИзделия");
			ДоступныеПеременные.Добавить("ГлубинаИзделия");
			ДоступныеПеременные.Добавить("ВысотаПроема");
			ДоступныеПеременные.Добавить("ШиринаПроема");
			ДоступныеПеременные.Добавить("ВысотаПотолок");
			ДоступныеПеременные.Добавить("ВысотаПол");
			ДоступныеПеременные.Добавить("ШиринаПравый");
			ДоступныеПеременные.Добавить("ШиринаЛевый");
			ДоступныеПеременные.Добавить("ПрипускСверху");
			ДоступныеПеременные.Добавить("ПрипускСлева");
			ДоступныеПеременные.Добавить("ПрипускСправа");
			ДоступныеПеременные.Добавить("ПрипускСнизу");
			ДоступныеПеременные.Добавить("ЗавалПол");
			ДоступныеПеременные.Добавить("ЗавалЛевый");
			ДоступныеПеременные.Добавить("ЗавалПравый");
			ДоступныеПеременные.Добавить("ЗавалПотолок");
			ДоступныеПеременные.Добавить("ЗавалСтенка");	
			ДоступныеПеременные.Добавить("ГлубинаМатериала");
			ДоступныеПеременные.Добавить("ГлубинаМатериалаДоп");
			ДоступныеПеременные.Добавить("НоменклатураМатериала.ДлинаДетали");
			ДоступныеПеременные.Добавить("НоменклатураМатериала.ШиринаДетали");
			ДоступныеПеременные.Добавить("НоменклатураМатериала.ГлубинаДетали");
			ДоступныеПеременные.Добавить("Раздвижная");	
			ДоступныеПеременные.Добавить("Распашная");
			ДоступныеПеременные.Добавить("Столешница");
			ДоступныеПеременные.Добавить("Европаз");
			ДоступныеПеременные.Добавить("РадиусЛ");
			ДоступныеПеременные.Добавить("РадиусП");
			ДоступныеПеременные.Добавить("Отсек");
		
	КонецЕсли;
	
	Если Режим = "СхемаЯщика" Тогда
		
			ДоступныеПеременные.Добавить("ПроемЯщика");
			ДоступныеПеременные.Добавить("ВысотаЯщика");
			ДоступныеПеременные.Добавить("ГлубинаЯщика");
			ДоступныеПеременные.Добавить("ШиринаФасад");
			ДоступныеПеременные.Добавить("ВысотаФасад");
			ДоступныеПеременные.Добавить("КоличествоРучек");
			ДоступныеПеременные.Добавить("БезНаправляющих");
			ДоступныеПеременные.Добавить("ЕстьРебро");
			ДоступныеПеременные.Добавить("ВидФасада");
			ДоступныеПеременные.Добавить("НаправляющиеНоменклатура.ДлинаДетали");
			ДоступныеПеременные.Добавить("НаправляющиеНоменклатура.ШиринаДетали");
			ДоступныеПеременные.Добавить("НаправляющиеНоменклатура.ГлубинаДетали");
			ДоступныеПеременные.Добавить("ФасадНоменклатура.ДлинаДетали");
			ДоступныеПеременные.Добавить("ФасадНоменклатура.ШиринаДетали");
			ДоступныеПеременные.Добавить("ФасадНоменклатура.ГлубинаДетали");
			ДоступныеПеременные.Добавить("КромкаФасадНоменклатура.ДлинаДетали");
			ДоступныеПеременные.Добавить("КромкаФасадНоменклатура.ШиринаДетали");
			ДоступныеПеременные.Добавить("КромкаФасадНоменклатура.ГлубинаДетали");
			ДоступныеПеременные.Добавить("ДноНоменклатура.ДлинаДетали");
			ДоступныеПеременные.Добавить("ДноНоменклатура.ШиринаДетали");
			ДоступныеПеременные.Добавить("ДноНоменклатура.ГлубинаДетали");
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПеременные()
	
	СтруктураПеременных = Новый Массив;
	
	Если Режим = "СхемаЯщика" Тогда
	
			СтруктураПеременных.Добавить("ПроемЯщика");
			СтруктураПеременных.Добавить("ВысотаЯщика");
			СтруктураПеременных.Добавить("ГлубинаЯщика");
			СтруктураПеременных.Добавить("ШиринаФасад");
			СтруктураПеременных.Добавить("ВысотаФасад");
			СтруктураПеременных.Добавить("КоличествоРучек");
			СтруктураПеременных.Добавить("БезНаправляющих");
			СтруктураПеременных.Добавить("ЕстьРебро");
			СтруктураПеременных.Добавить("ВидФасада");

				Эл = Новый Массив;
				Эл.Добавить("НаправляющиеНоменклатура.ДлинаДетали");
				Эл.Добавить("НаправляющиеНоменклатура.ШиринаДетали");
				Эл.Добавить("НаправляющиеНоменклатура.ГлубинаДетали");
			
			Раздел = Новый Массив;
			Раздел.Добавить("НаправляющиеНоменклатура");
			Раздел.Добавить(Эл);
			
			СтруктураПеременных.Добавить(Раздел);
			
				Эл = Новый Массив;
				Эл.Добавить("ФасадНоменклатура.ДлинаДетали");
				Эл.Добавить("ФасадНоменклатура.ШиринаДетали");
				Эл.Добавить("ФасадНоменклатура.ГлубинаДетали");
			
			Раздел = Новый Массив;
			Раздел.Добавить("ФасадНоменклатура");
			Раздел.Добавить(Эл);
			
			СтруктураПеременных.Добавить(Раздел);
			
				Эл = Новый Массив;
				Эл.Добавить("КромкаФасадНоменклатура.ДлинаДетали");
				Эл.Добавить("КромкаФасадНоменклатура.ШиринаДетали");
				Эл.Добавить("КромкаФасадНоменклатура.ГлубинаДетали");
			
			Раздел = Новый Массив;
			Раздел.Добавить("КромкаФасадНоменклатура");
			Раздел.Добавить(Эл);
			
			СтруктураПеременных.Добавить(Раздел);
			
				Эл = Новый Массив;
				Эл.Добавить("ДноНоменклатура.ДлинаДетали");
				Эл.Добавить("ДноНоменклатура.ШиринаДетали");
				Эл.Добавить("ДноНоменклатура.ГлубинаДетали");
			
			Раздел = Новый Массив;
			Раздел.Добавить("ДноНоменклатура");
			Раздел.Добавить(Эл);
			
			СтруктураПеременных.Добавить(Раздел);
			
	КонецЕсли;
		
	Если Режим = "Каталог" Тогда
						
				Эл = Новый Массив;
				Эл.Добавить("ШиринаИзделия");
				Эл.Добавить("ВысотаИзделия");
				Эл.Добавить("ГлубинаИзделия");
				Эл.Добавить("ВысотаПроема");
				Эл.Добавить("ШиринаПроема");
				Эл.Добавить("ВысотаПотолок");
				Эл.Добавить("ВысотаПол");
				Эл.Добавить("ШиринаПравый");
				Эл.Добавить("ШиринаЛевый");
			
			Раздел = Новый Массив;
			Раздел.Добавить("Габариты изделия");
			Раздел.Добавить(Эл);
			
			СтруктураПеременных.Добавить(Раздел);
				
				Эл = Новый Массив;
				Эл.Добавить("ПрипускСверху");
				Эл.Добавить("ПрипускСлева");
				Эл.Добавить("ПрипускСправа");
				Эл.Добавить("ПрипускСнизу");
			
			Раздел = Новый Массив;
			Раздел.Добавить("Припуск");
			Раздел.Добавить(Эл);
			
			СтруктураПеременных.Добавить(Раздел);
			
				Эл = Новый Массив;
				Эл.Добавить("ЗавалПол");
				Эл.Добавить("ЗавалЛевый");
				Эл.Добавить("ЗавалПравый");
				Эл.Добавить("ЗавалПотолок");
				Эл.Добавить("ЗавалСтенка");
			
			Раздел = Новый Массив;
			Раздел.Добавить("Завал");
			Раздел.Добавить(Эл);
			
			СтруктураПеременных.Добавить(Раздел);
			
				Эл = Новый Массив;
				Эл.Добавить("ГлубинаМатериала");
				Эл.Добавить("ГлубинаМатериалаДоп");
			
					Эл2 = Новый Массив;
					Эл2.Добавить("НоменклатураМатериала.ДлинаДетали");
					Эл2.Добавить("НоменклатураМатериала.ШиринаДетали");
					Эл2.Добавить("НоменклатураМатериала.ГлубинаДетали");
			
					Раздел2 = Новый Массив;
					Раздел2.Добавить("НоменклатураМатериала");
					Раздел2.Добавить(Эл2);
			
				Эл.Добавить(Раздел2);
			
			
			Раздел = Новый Массив;
			Раздел.Добавить("Метериал");
			Раздел.Добавить(Эл);
			
			СтруктураПеременных.Добавить(Раздел);
			
				Эл = Новый Массив;
				Эл.Добавить("Раздвижная");
				Эл.Добавить("Распашная");
			
			Раздел = Новый Массив;
			Раздел.Добавить("Двери");
			Раздел.Добавить(Эл);
			
			СтруктураПеременных.Добавить(Раздел);

			СтруктураПеременных.Добавить("Столешница");
			СтруктураПеременных.Добавить("Европаз");

			СтруктураПеременных.Добавить("РадиусЛ");
			СтруктураПеременных.Добавить("РадиусП");

			СтруктураПеременных.Добавить("Отсек");
		
		
	КонецЕсли;
			
			
	Для Каждого Эл Из СтруктураПеременных Цикл
		
		Если ТипЗнч(Эл)=Тип("Массив") Тогда
			
			СтрокаСправ = СписокПеременных.ПолучитьЭлементы().Добавить();
			СтрокаСправ.Переменная = Эл[0];
			СтрокаСправ.Активность = Ложь;
			
			Для Каждого Эл2 Из Эл[1] Цикл
				
				Если ТипЗнч(Эл2)=Тип("Массив") Тогда
					
					СтрокаРеквизит = СтрокаСправ.ПолучитьЭлементы ().Добавить();
				    СтрокаРеквизит.Переменная = Эл2[0];
					СтрокаРеквизит.Активность = Ложь;					
					
					Для Каждого Эл3 Из Эл2[1] Цикл
						
						СтрокаРеквизит2 = СтрокаРеквизит.ПолучитьЭлементы ().Добавить();
				    	СтрокаРеквизит2.Переменная = Эл3;
						СтрокаРеквизит2.Активность = Истина;
							
					КонецЦикла;	
					
				Иначе	
					СтрокаРеквизит = СтрокаСправ.ПолучитьЭлементы ().Добавить();
				    СтрокаРеквизит.Переменная = Эл2;
					СтрокаРеквизит.Активность = Истина;
				КонецЕсли;
				
			КонецЦикла;	
			
		Иначе
			
			СтрокаСправ = СписокПеременных.ПолучитьЭлементы().Добавить();
			СтрокаСправ.Переменная = Эл;
			СтрокаСправ.Активность = Истина;
			
		КонецЕсли;
		
	КонецЦикла;	
			
КонецПроцедуры


&НаКлиенте
Процедура СписокФормул(Команда)
	
	ОткрытьФорму("Справочник.ФормулыКаталога.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеременныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Данные = Элементы.СписокПеременных.ТекущиеДанные;
	
	Если Данные.Активность Тогда 
		
		 ДобавитьКФормуле(Данные.Переменная);	 
	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ФормулыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Данные = Элементы.Формулы.ТекущиеДанные.Наименование;
	
	Если ЗначениеЗаполнено(Данные) Тогда
		
		  ДобавитьКФормуле("Фор."+Данные);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКФормуле(Знч)
	
	НачСтр=0;
	НачКол=0;
	КонСтр=0;
	КонКол=0;
	
	Элементы.Формула.ПолучитьГраницыВыделения(НачСтр, НачКол, КонСтр, КонКол);
	
	ДлинаЗнч = СтрДлина(Знч);
	
	Элементы.Формула.ВыделенныйТекст = Знч;
	
	ЭтаФорма.ТекущийЭлемент = Элементы.Формула;
	ЭтаФорма.ОбновитьОтображениеДанных();
	
	Элементы.Формула.УстановитьГраницыВыделения(НачСтр, НачКол+ДлинаЗнч, НачСтр, НачКол+ДлинаЗнч); 	
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЦифру1(Команда)
	ДобавитьКФормуле("1");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЦифру2(Команда)
	ДобавитьКФормуле("2");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЦифру3(Команда)
	ДобавитьКФормуле("3");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЦифру4(Команда)
	ДобавитьКФормуле("4");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЦифру5(Команда)
	ДобавитьКФормуле("5");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЦифру6(Команда)
	ДобавитьКФормуле("6");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЦифру7(Команда)
	ДобавитьКФормуле("7");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЦифру8(Команда)
	ДобавитьКФормуле("8");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЦифру9(Команда)
	ДобавитьКФормуле("9");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЦифру0(Команда)
	ДобавитьКФормуле("0");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЦифруDel(Команда)
	
	НачСтр=0;
	НачКол=0;
	КонСтр=0;
	КонКол=0;
		
	Элементы.Формула.ПолучитьГраницыВыделения(НачСтр, НачКол, КонСтр, КонКол);
	
	ДлинаЗнч = СтрДлина(Элементы.Формула.ВыделенныйТекст);
	
	НИндекс = НачКол;
	
	Если ДлинаЗнч > 0 Тогда
		
		НачалоСтроки = Лев(Формула,НачКол-1);	
		
	Иначе
		
		Кол = НачКол-2;
		
		Если Кол < 1 Тогда
			 НачалоСтроки = "";	
		Иначе
			 НачалоСтроки = Лев(Формула,НачКол-2);
			 НИндекс=НачКол-1;
		КонецЕсли;
				
	КонецЕсли;
	
	КонецСтроки = Прав(Формула,СтрДлина(Формула)-(КонКол-1));
	Формула = НачалоСтроки + КонецСтроки;
	
	ЭтаФорма.ТекущийЭлемент = Элементы.Формула;
	ЭтаФорма.ОбновитьОтображениеДанных();
	
	//RonEXI: УстановитьГраницыВыделения не может установить выделение нулевой длины, приходится выделять 1 букву
	Если НИндекс-1 > 0 Тогда 
		Элементы.Формула.УстановитьГраницыВыделения(НИндекс-1,НИндекс);
		Элементы.Формула.ВыделенныйТекст = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьПлюс(Команда)
	ДобавитьКФормуле("+");
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьМинус(Команда)
	ДобавитьКФормуле("-");
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьСкобкаОткр(Команда)
	ДобавитьКФормуле("(");
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьСкобкаЗакр(Команда)
	ДобавитьКФормуле(")");
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьЗапятая(Команда)
	ДобавитьКФормуле(",");
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьТочка(Команда)
	ДобавитьКФормуле(".");
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьРазделить(Команда)
	ДобавитьКФормуле("/");
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьУмножить(Команда)
	ДобавитьКФормуле("*");
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьПроцент(Команда)
	ДобавитьКФормуле("%");
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьУсловие(Команда)
	ДобавитьКФормуле("?(Условие,ЕслиИстина,ЕслиЛожь)");
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьМакс(Команда)
	ДобавитьКФормуле("Макс(Значение,Значение)");
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьМин(Команда)
	ДобавитьКФормуле("Мин(Значение,Значение)");
КонецПроцедуры


&НаКлиенте
Процедура КомандаДобавитьРавно(Команда)
	ДобавитьКФормуле("=");

КонецПроцедуры

&НаКлиенте
Функция РазложитьСтроку(Строка, Разделитель)
	
	Возврат  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Строка, Разделитель);
	
КонецФункции

&НаКлиенте
Функция СобратьМассив(Массив, Разделитель)
	
	Возврат  СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(Массив, Разделитель);
	
КонецФункции

&НаКлиенте
Процедура ПолучитьПеременныеФормулы(Команда)
	
	РазложеннаяФормула = РазложитьФормулу(Формула);
	
	ЗаполненныеПараметры = Новый Массив();
	
	Для Каждого Строка Из СписокПараметров Цикл
		
		 Стр = Новый Структура;
		 Стр.Вставить("Параметр",Строка.Параметр);
		 Стр.Вставить("Значение",Строка.Значение);

		 ЗаполненныеПараметры.Добавить(Стр);
		 	
	 КонецЦикла;
	 
	 СписокПараметров.Очистить();
		
	Для Каждого Пер Из ДоступныеПеременные Цикл
		
		К = Найти(РазложеннаяФормула, Пер.Значение);	
		
		Если К > 0 Тогда
			
			
			ПеремЗаполнена = Ложь;
			
			Для Каждого Стр Из ЗаполненныеПараметры Цикл
				
				Если Стр.Параметр = Пер.Значение Тогда
					
					Ст = СписокПараметров.Добавить();
					Ст.Параметр = Стр.Параметр;
					Ст.Значение = Стр.Значение;
					
					ПеремЗаполнена = Истина;
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если НЕ ПеремЗаполнена Тогда
				
				Ст = СписокПараметров.Добавить();
				Ст.Параметр = Пер.Значение;
				Ст.Значение = 0;

			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция РазложитьФормулу(Знач Форм)
	
	ПолучитьВсеДоступныеФормулы();
	
	ВременнаяФормула = Форм;
	
	Для Каждого Фор Из ДоступныеФормулы Цикл
		
		ВременнаяФормула = СтрЗаменить(ВременнаяФормула,"Фор."+Фор.Наименование, Фор.Формула);
		
	КонецЦикла;
	
	ВложенныеФормулы=1;
	
	Пока ВложенныеФормулы > 0 Цикл 
		
		Для Каждого Фор Из ДоступныеФормулы Цикл
			ВременнаяФормула = СтрЗаменить(ВременнаяФормула,"%%"+Фор.Наименование+"%%", Фор.Формула);
		КонецЦикла;
		
		ВложенныеФормулы = Найти(ВременнаяФормула, "%%");
		
	КонецЦикла;
	
	Возврат ВременнаяФормула;
	
КонецФункции
	
	
&НаСервере
Процедура ПолучитьВсеДоступныеФормулы()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФормулыКаталога.Наименование,
	|	ФормулыКаталога.Формула
	|ИЗ
	|	Справочник.ФормулыКаталога КАК ФормулыКаталога";
	
	ДоступныеФормулы.Очистить();
	ДоступныеФормулы.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры


&НаКлиенте
Процедура ВычислитьФормулу(Команда)
	
	РазложеннаяФормула = РазложитьФормулу(Формула);
	
	Для Каждого Эл Из СписокПараметров Цикл
		
		РазложеннаяФормула = СтрЗаменить(РазложеннаяФормула,Эл.Параметр, Эл.Значение);
		
	КонецЦикла;
	
	Попытка 	
		Выполнить("РезультатФормулы=Строка("+РазложеннаяФормула+")");
	Исключение
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Формула не верна:" + Символы.ПС + РазложеннаяФормула;
		Сообщение.Сообщить();
		
		РезультатФормулы = "Ошибка";
		
	КонецПопытки;
		
КонецПроцедуры


&НаКлиенте
Процедура СписокПеременныхПриАктивизацииСтроки(Элемент)
	ЭтаФорма.ТекущийЭлемент = Элементы.Формула;
	ЭтаФорма.ОбновитьОтображениеДанных();
КонецПроцедуры


&НаКлиенте
Процедура ФормулыПриАктивизацииСтроки(Элемент)
	ЭтаФорма.ТекущийЭлемент = Элементы.Формула;
	ЭтаФорма.ОбновитьОтображениеДанных();
КонецПроцедуры
