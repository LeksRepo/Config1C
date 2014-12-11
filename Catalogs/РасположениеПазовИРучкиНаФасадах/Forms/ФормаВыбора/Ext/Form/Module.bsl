﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Если Параметры.Свойство("СтеклянныеФасады") Тогда
	//	
	//	Запрос = Новый Запрос;
	//	Запрос.Текст =
	//	"ВЫБРАТЬ
	//	|	РасположениеПазовИРучкиНаФасадах.ИмяКартинки
	//	|ИЗ
	//	|	Справочник.РасположениеПазовИРучкиНаФасадах КАК РасположениеПазовИРучкиНаФасадах
	//	|ГДЕ
	//	|	НЕ РасположениеПазовИРучкиНаФасадах.ИспользуетсяВСтеклянныхФасадах";
	//	
	//	РезультатЗапроса = Запрос.Выполнить();
	//	
	//	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//	
	//	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//		
	//		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ИмяКартинки) Тогда
	//			
	//			Элементы[ВыборкаДетальныеЗаписи.ИмяКартинки].Видимость = Ложь;
	//			
	//		КонецЕсли;
	//		
	//	КонецЦикла;
	//	
	//КонецЕсли;
	
	ПоложениеПазов = Перечисления.Стороны.Слева;
	
КонецПроцедуры

&НаКлиенте
Процедура ПазовНетРучкаВертикальноВЦентре(Команда)
	
	ОтправитьНазвание("ПазовНетРучкаВертикальноВЦентре");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазовНетРучкаВертикальноПоЦентруСверху(Команда)
	
	ОтправитьНазвание("ПазовНетРучкаВертикальноПоЦентруСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазовНетРучкаВертикальноПоЦентруСнизу(Команда)
	
	ОтправитьНазвание("ПазовНетРучкаВертикальноПоЦентруСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазовНетРучкаГоризонтальноВЦентре(Команда)
	
	ОтправитьНазвание("ПазовНетРучкаГоризонтальноВЦентре");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазовНетРучкаГоризонтальноПоЦентруСверху(Команда)
	
	ОтправитьНазвание("ПазовНетРучкаГоризонтальноПоЦентруСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазовНетРучкаГоризонтальноПоЦентруСнизу(Команда)
	
	ОтправитьНазвание("ПазовНетРучкаГоризонтальноПоЦентруСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСверзуРучкаГоризонтальноПоЦентруСнизу(Команда)
	
	ОтправитьНазвание("ПазыСверзуРучкаГоризонтальноПоЦентруСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСверзуРучкаОтсутствует(Команда)
	
	ОтправитьНазвание("ПазыСверзуРучкаОтсутствует");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСлеваРучкаГоризонтальноПоЦентруСнизу(Команда)
	
	ОтправитьНазвание("ПазыСлеваРучкаГоризонтальноПоЦентруСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСлеваРучкаВертикальноСправаПоЦентру(Команда)
	
	ОтправитьНазвание("ПазыСлеваРучкаВертикальноСправаПоЦентру");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСлеваРучкаВертикальноСправаСверху(Команда)
	
	ОтправитьНазвание("ПазыСлеваРучкаВертикальноСправаСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСлеваРучкаВертикальноСправаСнизу(Команда)
	
	ОтправитьНазвание("ПазыСлеваРучкаВертикальноСправаСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСлеваРучкаГоризонтальноПоЦентруСверху(Команда)
	
	ОтправитьНазвание("ПазыСлеваРучкаГоризонтальноПоЦентруСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСлеваРучкаГоризонтальноСправаПоЦентру(Команда)
	
	ОтправитьНазвание("ПазыСлеваРучкаГоризонтальноСправаПоЦентру");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСлеваРучкаГоризонтальноСправаСверху(Команда)
	
	ОтправитьНазвание("ПазыСлеваРучкаГоризонтальноСправаСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСлеваРучкаГоризонтальноСправаСнизу(Команда)
	
	ОтправитьНазвание("ПазыСлеваРучкаГоризонтальноСправаСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСлеваРучкаОтсутствует(Команда)
	
	ОтправитьНазвание("ПазыСлеваРучкаОтсутствует");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНазвание(Имя)
	
	ОповеститьОВыборе(Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСверзуРучкаГоризонтальноСлеваСнизу(Команда)
	
	ОтправитьНазвание("ПазыСверзуРучкаГоризонтальноСлеваСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСверзуРучкаГоризонтальноСправаСнизу(Команда)
	
	ОтправитьНазвание("ПазыСверзуРучкаГоризонтальноСправаСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСверхуРучкаВертикальноПоЦентруСнизу(Команда)
	
	ОтправитьНазвание("ПазыСверхуРучкаВертикальноПоЦентруСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСверхуРучкаВертикальноСлеваПоЦентру(Команда)
	
	ОтправитьНазвание("ПазыСверхуРучкаВертикальноСлеваПоЦентру");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСверхуРучкаВертикальноСлеваСнизу(Команда)
	
	ОтправитьНазвание("ПазыСверхуРучкаВертикальноСлеваСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСверхуРучкаВертикальноСправаПоЦентру(Команда)
	
	ОтправитьНазвание("ПазыСверхуРучкаВертикальноСправаПоЦентру");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСверхуРучкаВертикальноСправаСнизу(Команда)
	
	ОтправитьНазвание("ПазыСверхуРучкаВертикальноСправаСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСправаРучкаВертикальноСлеваПоЦентру(Команда)
	
	ОтправитьНазвание("ПазыСправаРучкаВертикальноСлеваПоЦентру");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСправаРучкаВертикальноСлеваСверху(Команда)
	
	ОтправитьНазвание("ПазыСправаРучкаВертикальноСлеваСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСправаРучкаВертикальноСлеваСнизу(Команда)
	
	ОтправитьНазвание("ПазыСправаРучкаВертикальноСлеваСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСправаРучкаГоризонтальноПоЦентруСверху(Команда)
	
	ОтправитьНазвание("ПазыСправаРучкаГоризонтальноПоЦентруСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСправаРучкаГоризонтальноПоЦентруСнизу(Команда)
	
	ОтправитьНазвание("ПазыСправаРучкаГоризонтальноПоЦентруСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСправаРучкаГоризонтальноСлеваПоЦентру(Команда)
	
	ОтправитьНазвание("ПазыСправаРучкаГоризонтальноСлеваПоЦентру");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСправаРучкаГоризонтальноСлеваСверху(Команда)
	
	ОтправитьНазвание("ПазыСправаРучкаГоризонтальноСлеваСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСправаРучкаГоризонтальноСлеваСнизу(Команда)
	
	ОтправитьНазвание("ПазыСправаРучкаГоризонтальноСлеваСнизу");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСправаРучкаОтсутствует(Команда)
	
	ОтправитьНазвание("ПазыСправаРучкаОтсутствует");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСнизуРучкаВертикальноПоЦентруСверху(Команда)
	
	ОтправитьНазвание("ПазыСнизуРучкаВертикальноПоЦентруСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыснизуРучкаВертикальноСлеваПоЦентру(Команда)
	
	ОтправитьНазвание("ПазыснизуРучкаВертикальноСлеваПоЦентру");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСнизуРучкаВертикальноСлеваСверху(Команда)
	
	ОтправитьНазвание("ПазыСнизуРучкаВертикальноСлеваСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСнизуРучкаВертикальноСправаПоЦентру(Команда)
	
	ОтправитьНазвание("ПазыСнизуРучкаВертикальноСправаПоЦентру");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСнизуРучкаВертикальноСправаСверху(Команда)
	
	ОтправитьНазвание("ПазыСнизуРучкаВертикальноСправаСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСнизуРучкаГоризонтальноПоЦентруСверху(Команда)
	
	ОтправитьНазвание("ПазыСнизуРучкаГоризонтальноПоЦентруСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСнизуРучкаГоризонтальноСлеваСверху(Команда)
	
	ОтправитьНазвание("ПазыСнизуРучкаГоризонтальноСлеваСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСнизуРучкаГоризонтальноСправаСверху(Команда)
	
	ОтправитьНазвание("ПазыСнизуРучкаГоризонтальноСправаСверху");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазыСнизуРучкаОтсутствует(Команда)
	
	ОтправитьНазвание("ПазыСнизуРучкаОтсутствует");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоложениеПазовПриИзменении(Элемент)
	
	ПоложениеПазовНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ПоложениеПазовНаСервере()
	
	Если ПоложениеПазов = Перечисления.Стороны.Отсутствует Тогда
		
		Элементы.ПазыСнизу.Видимость = Ложь;
		Элементы.ПазыСверху.Видимость = Ложь;
		Элементы.ПазыСлева.Видимость = Ложь;
		Элементы.ПазыСправа.Видимость = Ложь;
		Элементы.ПазовНет.Видимость = Истина;
		
	ИначеЕсли ПоложениеПазов = Перечисления.Стороны.Сверху Тогда
		
		Элементы.ПазыСнизу.Видимость = Ложь;
		Элементы.ПазыСверху.Видимость = Истина;
		Элементы.ПазыСлева.Видимость = Ложь;
		Элементы.ПазыСправа.Видимость = Ложь;
		Элементы.ПазовНет.Видимость = Ложь;
		
	ИначеЕсли ПоложениеПазов = Перечисления.Стороны.Снизу Тогда
		
		Элементы.ПазыСнизу.Видимость = Истина;
		Элементы.ПазыСверху.Видимость = Ложь;
		Элементы.ПазыСлева.Видимость = Ложь;
		Элементы.ПазыСправа.Видимость = Ложь;
		Элементы.ПазовНет.Видимость = Ложь;
		
	ИначеЕсли ПоложениеПазов = Перечисления.Стороны.Слева Тогда
		
		Элементы.ПазыСнизу.Видимость = Ложь;
		Элементы.ПазыСверху.Видимость = Ложь;
		Элементы.ПазыСлева.Видимость = Истина;
		Элементы.ПазыСправа.Видимость = Ложь;
		Элементы.ПазовНет.Видимость = Ложь;
		
	ИначеЕсли ПоложениеПазов = Перечисления.Стороны.Справа Тогда
		
		Элементы.ПазыСнизу.Видимость = Ложь;
		Элементы.ПазыСверху.Видимость = Ложь;
		Элементы.ПазыСлева.Видимость = Ложь;
		Элементы.ПазыСправа.Видимость = Истина;
		Элементы.ПазовНет.Видимость = Ложь;
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПазовНетРучкаОтсутствует(Команда)
	
	ОтправитьНазвание("ПазовНетРучкаОтсутствует");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазовНетРучкаГоризонтальноПоЦентруСправа(Команда)
	
	ОтправитьНазвание("ПазовНетРучкаГоризонтальноПоЦентруСправа");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазовНетРучкаГоризонтальноПоЦентруСлева(Команда)
	
	ОтправитьНазвание("ПазовНетРучкаГоризонтальноПоЦентруСлева");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазовНетРучкаВертикальноПоЦентруСправа(Команда)
	
	ОтправитьНазвание("ПазовНетРучкаВертикальноПоЦентруСправа");
	
КонецПроцедуры

&НаКлиенте
Процедура ПазовНетРучкаВертикальноПоЦентруСлева(Команда)
	
	ОтправитьНазвание("ПазовНетРучкаВертикальноПоЦентруСлева");
	
КонецПроцедуры

