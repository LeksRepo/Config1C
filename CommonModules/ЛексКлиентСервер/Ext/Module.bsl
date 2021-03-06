﻿
Функция ПеревестиСтрокуВКодыСимволов (ИсходнаяСтрока) Экспорт
	
	Результат = "";
	ДлинаСтроки = СтрДлина(ИсходнаяСтрока);
	
	К = 1;
	Пока К <= ДлинаСтроки Цикл
		
		КодСимвола = Строка(КодСимвола(ИсходнаяСтрока, К));
		КодСтрокой = СтрЗаменить(КодСимвола, Символы.НПП, "");
		Результат = Результат + КодСтрокой + "*";
		К = К + 1;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПеревестиКодыСимволовВстроку(ИсходнаяСтрока) Экспорт
	
	Результат = "";
	МассивСимволов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИсходнаяСтрока, "*");
	
	Для Каждого Символ Из МассивСимволов Цикл
		
		Попытка
			ВозврСтрока = ВозврСтрока+Символ(Число(Символ));
		Исключение
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции // ПеревистиКодыСимволовВстроку()

Функция Хэш(ИсходныеДанные, Хэш=5381, М=33, Разрядность=18446744073709551616) Экспорт
	
	// приведем к строке
	Если ТипЗнч(ИсходныеДанные) = Тип("ДвоичныеДанные") Тогда
		СтрокаДляКодирования = Base64Строка(ИсходныеДанные);
	Иначе
		СтрокаДляКодирования = Строка(ИсходныеДанные);
	КонецЕсли;
	
	ДлинаБлока = 11;
	НачПозиция = 1;
	ДлинаСтроки = СтрДлина(СтрокаДляКодирования);
	
	Пока НачПозиция <= ДлинаСтроки Цикл
		СтрокаБлока = Сред(СтрокаДляКодирования, НачПозиция, ДлинаБлока);
		ДлинаПодстроки = СтрДлина(СтрокаБлока);
		Если ДлинаПодстроки = ДлинаБлока Тогда
			Хэш = ((((((((((( Хэш*М + КодСимвола(СтрокаБлока, 1))*М + КодСимвола(СтрокаБлока, 2))*М
			+ КодСимвола(СтрокаБлока, 3))*М + КодСимвола(СтрокаБлока, 4))*М + КодСимвола(СтрокаБлока, 5))*М
			+ КодСимвола(СтрокаБлока, 6))*М + КодСимвола(СтрокаБлока, 7))*М + КодСимвола(СтрокаБлока, 8))*М
			+ КодСимвола(СтрокаБлока, 9))*М + КодСимвола(СтрокаБлока, 10))*М + КодСимвола(СтрокаБлока, 11))
		Иначе
			Для к = 1 По ДлинаПодстроки Цикл
				Хэш = М * Хэш + КодСимвола(СтрокаБлока, к)
			КонецЦикла
		КонецЕсли;
		Хэш = Хэш % Разрядность;
		НачПозиция = НачПозиция + ДлинаБлока
	КонецЦикла;
	
	Возврат Строка(Хэш);
	
КонецФункции

// Функция Дата прописью
// Параметры:
// ДП - Дата
// Возвращаемое значение:
// дата прописью
Функция ДатаПрописью(ДП) Экспорт
	
	стрРез = "";
	Д = Формат(ДП,"ДЛФ=D");
	спсМес = Новый СписокЗначений;
	спсМес.Добавить("января");
	спсМес.Добавить("февраля");
	спсМес.Добавить("марта");
	спсМес.Добавить("апреля");
	спсМес.Добавить("мая");
	спсМес.Добавить("июня");
	спсМес.Добавить("июля");
	спсМес.Добавить("августа");
	спсМес.Добавить("сентября");
	спсМес.Добавить("октября");
	спсМес.Добавить("ноября");
	спсМес.Добавить("декабря");
	
	спсЧисл = Новый СписокЗначений;
	спсЧисл.Добавить("первое","первого");
	спсЧисл.Добавить("второе","второго");
	спсЧисл.Добавить("третье","третьего");
	спсЧисл.Добавить("четвертое","четвертого");
	спсЧисл.Добавить("пятое","пятого");
	спсЧисл.Добавить("шестое","шестого");
	спсЧисл.Добавить("седьмое","седьмого");
	спсЧисл.Добавить("восьмое","восьмого");
	спсЧисл.Добавить("девятое","девятого");
	
	//числительные им.падеж
	спсЧислИм = Новый СписокЗначений;
	спсЧислИм.Добавить("тысяча","тысячного");
	спсЧислИм.Добавить("две тысячи","двухтысячного");
	спсЧислИм.Добавить("три тысячи","трехтысячного");
	спсЧислИм.Добавить("четыре тысячи","четырёхтысячного");
	спсЧислИм.Добавить("пять","пятитысячного");
	спсЧислИм.Добавить("шесть","шеститысячного");
	спсЧислИм.Добавить("семь","семитысячного");
	спсЧислИм.Добавить("восемь","восьмитысячного");
	спсЧислИм.Добавить("девять","девятитысячного");
	
	спсСотни = Новый СписокЗначений;
	спсСотни.Добавить("сто");
	спсСотни.Добавить("двести");
	спсСотни.Добавить("триста");
	спсСотни.Добавить("четыреста");
	спсСотни.Добавить("пятьсот");
	спсСотни.Добавить("шестьсот");
	спсСотни.Добавить("семьсот");
	спсСотни.Добавить("восемьсот");
	спсСотни.Добавить("девятьсот");
	
	//десятки им.падеж
	спсДесИм = Новый СписокЗначений;
	спсДесИм.Добавить("","десятого");
	спсДесИм.Добавить("двадцать","двадцатого");
	спсДесИм.Добавить("тридцать","тридцатого");
	спсДесИм.Добавить("сорок","сорокового");
	спсДесИм.Добавить("пятьдесят","пятидесятого");
	спсДесИм.Добавить("шестьдесят","шестидесятого");
	спсДесИм.Добавить("семьдесят","семидесятого");
	спсДесИм.Добавить("восемьдесят","восьмидесятого");
	спсДесИм.Добавить("девяносто","девяностого");
	
	//субдесятки род.падеж
	спсСубДесРод = Новый СписокЗначений;
	спсСубДесРод.Добавить("одиннадцатого");
	спсСубДесРод.Добавить("двенадцатого");
	спсСубДесРод.Добавить("тринадцатого");
	спсСубДесРод.Добавить("четырнадцатого");
	спсСубДесРод.Добавить("пятнадцатого");
	спсСубДесРод.Добавить("шестнадцатого");
	спсСубДесРод.Добавить("семнадцатого");
	спсСубДесРод.Добавить("восемнадцатого");
	спсСубДесРод.Добавить("девятнадцатого");
	
	спсДес = Новый СписокЗначений;
	спсДес.Добавить("десятое");
	спсДес.Добавить("двадцатое","двадцать");
	спсДес.Добавить("тридцатое","тридцать");
	спсДес.Добавить("сороковое","тридцать");
	спсДес.Добавить("пятидесятое","тридцать");
	спсДес.Добавить("шестидесятое","тридцать");
	спсДес.Добавить("семидесятое","тридцать");
	
	спсСубДес = Новый СписокЗначений;
	спсСубДес.Добавить("одиннадцатое");
	спсСубДес.Добавить("двенадцатое");
	спсСубДес.Добавить("тринадцатое");
	спсСубДес.Добавить("четырнадцатое");
	спсСубДес.Добавить("пятнадцатое");
	спсСубДес.Добавить("шестнадцатое");
	спсСубДес.Добавить("семнадцатое");
	спсСубДес.Добавить("восемнадцатое");
	спсСубДес.Добавить("девятнадцатое");
	
	спсДаты = СтрЗаменить(СокрЛП(Д),".",Символы.ПС);
	//разбираем день
	стрДень = СокрЛП(Число(СтрПолучитьСтроку(спсДаты,1)));
	Если СтрДлина(стрДень)=1 Тогда
		стрДень = спсЧисл.Получить(Число(стрДень)-1).Значение;
	Иначе
		десДень = Число(Лев(стрДень,1));
		едДень = Число(Прав(стрДень,1));
		
		Если едДень=0 Тогда
			стрДень = спсДес.Получить(десДень-1).Значение;
		Иначе
			Если десДень>1 Тогда
				т = Строка(спсДес.Получить(десДень-1));
				стрДень = т+" "+Строка(спсЧисл.Получить(едДень-1).Значение);
			Иначе
				стрДень = спсСубДес.Получить(едДень-1).Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	//разбираем месяц
	стрМес = спсМес.Получить(Число(СтрПолучитьСтроку(спсДаты,2))-1).Значение;
	
	//разбираем год
	стрГод = СтрПолучитьСтроку(спсДаты,3);
	длинаГода = СтрДлина(стрГод);
	Если длинаГода=4 Тогда
		тыс = Сред(стрГод,1,1); сот = Сред(стрГод,2,1); дес = Сред(стрГод,3,1); ед = Сред(стрГод,4,1);
		_т = спсЧислИм.Получить(Число(тыс)-1).Значение;
		Если (Число(сот)=0) и (Число(дес)=0) и (Число(ед)=0) Тогда
			миллениум = Строка(спсЧислИм.Получить(Число(тыс)-1));
			стрГод = миллениум;
		Иначе
			с = ""; дс = ""; е = "";
			Если Число(сот)<>0 Тогда
				с = спсСотни.Получить(Число(сот)-1).Значение;
			КонецЕсли;
			Если Число(дес)<>0 Тогда
				Если Число(ед)=0 Тогда
					дг = Строка(спсДесИм.Получить(Число(дес)-1));
					дс = дг;
				Иначе
					дс = спсСубДесРод.Получить(Число(ед)-1).Значение;
				КонецЕсли;
			КонецЕсли;
			Если (Число(дес)>1) или (Число(дес)=0) Тогда
				Если Число(ед)<>0 Тогда
					е =Строка(спсЧисл.Получить(Число(ед)-1));
				КонецЕсли;
			КонецЕсли;
			стрГод = Строка(_т)+" "+Строка(с)+" "+Строка(дс)+" "+Строка(е);
		КонецЕсли;
	Иначе
		
	КонецЕсли;
	
	стрГод = стрГод+" года";
	стрГод = СтрЗаменить(стрГод,"  "," ");
	стрРез = Строка(стрДень)+" "+Строка(стрМес)+" "+Строка(стрГод);
	стрРез = СтрЗаменить(стрРез,"  "," ");
	
	Возврат стрРез;
	
КонецФункции

Функция ПолучитьДатуОтгрузки(ДатаМонтажа) Экспорт
	
	ДатаОтгрузки = Неопределено;
	
	Если ЗначениеЗаполнено(ДатаМонтажа) Тогда
		
		Если ДеньНедели(ДатаМонтажа) > 1 Тогда
			МинусДней = 1;
		Иначе
			МинусДней = 2;
		КонецЕсли;
		
		ДатаОтгрузки = ДатаМонтажа - МинусДней * 86400;
		
	КонецЕсли;
	
	Возврат ДатаОтгрузки;
	
КонецФункции

Функция ПосчитатьПериметрИКривойПил(ВысотаДетали, ШиринаДетали, СуммаРадиусов, Срез) Экспорт
	
	ДлинаКривогоПила = Окр(3.14159 * (СуммаРадиусов) / 2);
	
	КоличествоКосогоПила = 0;
	
	Если Срез > 0 Тогда
		
		ДлинаКосогоПила = ОКР(POW(Срез*Срез+Срез*Срез,0.5))/1000;
		КоличествоКосогоПила = 1;
		Периметр = 2 * (ВысотаДетали + ШиринаДетали - СуммаРадиусов) + ДлинаКривогоПила - Срез * 2 + ДлинаКосогоПила;
		
	Иначе	
		
		Периметр = 2 * (ВысотаДетали + ШиринаДетали - СуммаРадиусов) + ДлинаКривогоПила;
		
	КонецЕсли;
	
	СтруктураСчитаемыхЗначений = Новый Структура();
	СтруктураСчитаемыхЗначений.Вставить("Периметр", Периметр);
	СтруктураСчитаемыхЗначений.Вставить("ДлинаКривогоПила", ДлинаКривогоПила);
	СтруктураСчитаемыхЗначений.Вставить("КоличествоКосогоПила", КоличествоКосогоПила);
	
	Возврат СтруктураСчитаемыхЗначений;
	
КонецФункции

Функция ПодставитьОбъектВФормулуЯщика(Знач Ссылка, Знач Формула) Экспорт
	
	МассивПеременныхФормулы = Новый Массив;
	МассивПеременныхФормулы.Добавить("ШиринаЯщика");
	МассивПеременныхФормулы.Добавить("ПроемЯщика");
	МассивПеременныхФормулы.Добавить("ВысотаЯщика");
	МассивПеременныхФормулы.Добавить("ГлубинаЯщика");
	МассивПеременныхФормулы.Добавить("ШиринаФасад");
	МассивПеременныхФормулы.Добавить("ВысотаФасад");
	МассивПеременныхФормулы.Добавить("КоличествоРучек");
	МассивПеременныхФормулы.Добавить("БезНаправляющих");
	МассивПеременныхФормулы.Добавить("ЕстьРебро");
	МассивПеременныхФормулы.Добавить("КриволинейныйВыпилПодРучку");
	МассивПеременныхФормулы.Добавить("РучкаЩель");
	МассивПеременныхФормулы.Добавить("ВидФасада");
	МассивПеременныхФормулы.Добавить("НаправляющиеНоменклатура");
	МассивПеременныхФормулы.Добавить("ФасадНоменклатура");
	МассивПеременныхФормулы.Добавить("КромкаФасадНоменклатура");
	МассивПеременныхФормулы.Добавить("ДноНоменклатура");
	МассивПеременныхФормулы.Добавить("НоменклатураЛДСП");
	
	Для Каждого Эл Из МассивПеременныхФормулы Цикл
		
		Стр = Эл;
		Стр2 = Эл;
		
		Если Стр = "НоменклатураЛДСП" Тогда
			Стр2 = "Номенклатура";
		КонецЕсли;
		
		Формула = СтрЗаменить(Формула, Стр, Ссылка + "."+Стр2);
		
	КонецЦикла;
	
	Возврат Формула;
	
КонецФункции

Функция ПолучитьКоличествоСУчетомКратности(Количество, Кратность) Экспорт
	
	Результат = Количество;
	
	Если Кратность > 0 Тогда
		Результат = Кратность * Окр(Количество / Кратность + 0.4999);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьМаксимальныйРазмерКэшаФайлов() Экспорт
	
	Возврат 10*(1024*1024*1024); //10 ГБ
	
КонецФункции

Функция ПолучитьМаксимальныйРазмерФайла() Экспорт
	
	Возврат 10*(1024*1024); //10 МБ
	
КонецФункции

Функция ПолучитьПапкуДляКэшФайлов(Каталог) Экспорт
	
	Возврат Каталог + "CacheFiles\";
	
КонецФункции

Функция ПолучитьСуммуБезБонуса(ТребуемаяСумма, Процент) Экспорт
	
	Результат = (ТребуемаяСумма * 100) / (Процент + 100);
	Результат = Окр(Результат, 1);
	Результат = Окр(Результат, 0, РежимОкругления.Окр15как20);
	
	Возврат Результат;
	
КонецФункции
