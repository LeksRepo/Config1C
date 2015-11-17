﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		ДилерскийДоступ = Истина;
		
		Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Объект.Дилерский = Истина;
		КонецЕсли;
		
		Контрагент = Пользователь.ОбъектАвторизации;
		АвторСтрока = Контрагент.Наименование;
		
		Супервайзер = Справочники.Пользователи.НайтиПоРеквизиту("ФизическоеЛицо",Контрагент.Супервайзер);		
		
		Если НЕ ЗначениеЗаполнено(Объект.Адресат) Тогда
			Объект.Адресат = Супервайзер;
		КонецЕсли;
		
		Элементы.Архив.Видимость = Ложь;
		Элементы.Адресат.Доступность = Ложь;
	
	Иначе
		
		ДилерскийДоступ = Ложь;
		ФизЛицо = Пользователь.ФизическоеЛицо;
		АвторСтрока = ФизЛицо.Фамилия + " " +Лев(ФизЛицо.Имя,1)+"."+Лев(ФизЛицо.Отчество,1)+".";
	
	КонецЕсли;
	
	Если Объект.Дилерский Тогда
		
		СписокВыбораВидСЗ = Элементы.ВидСлужебнойЗаписки.СписокВыбора;
		СписокВыбораВидСЗ.Очистить();
		СписокВыбораВидСЗ.Добавить(Перечисления.ВидыСлужебнойЗаписки.ИнформированиеЗаявка);
		СписокВыбораВидСЗ.Добавить(Перечисления.ВидыСлужебнойЗаписки.ПретензияЗаявление);
		СписокВыбораВидСЗ.Добавить(Перечисления.ВидыСлужебнойЗаписки.Благодарность);
		
	Иначе	
		Элементы.Адресат.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Пользователи");
    	Элементы.Адресат.ВыбиратьТип = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Адресат) Тогда
		АдресатСтрока = ПолучитьСтрокаАдресат(Объект.Адресат); 
	КонецЕсли;
	
	ПользовательАдминистратор = УправлениеДоступомПереопределяемый.ЕстьДоступКПрофилюГруппДоступа(Пользователь, Справочники.ПрофилиГруппДоступа.Администратор);
	
	ДоступностьФормы = ПользовательАдминистратор;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И НЕ ДоступностьФормы Тогда
		
		Если (Объект.Автор <> Пользователь) И (Объект.Адресат <> Пользователь) Тогда
			
			Элементы.История.ТолькоПросмотр = Истина;
			Элементы.ВидСлужебнойЗаписки.ТолькоПросмотр = Истина;
			Элементы.Тема.ТолькоПросмотр = Истина;
			Элементы.Архив.ТолькоПросмотр = Истина;
			
		ИначеЕсли (Объект.Адресат = Пользователь) Тогда
			
			Элементы.История.ТолькоПросмотр = Истина;
			Элементы.ВидСлужебнойЗаписки.ТолькоПросмотр = Истина;
			Элементы.Тема.ТолькоПросмотр = Истина;
			Элементы.Архив.ТолькоПросмотр = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
   	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ХранимыеФайлыВерсий.ВерсияФайла) КАК Количество
	|ИЗ
	|	РегистрСведений.ХранимыеФайлыВерсий КАК ХранимыеФайлыВерсий
	|ГДЕ
	|	ХранимыеФайлыВерсий.ВерсияФайла.Владелец.ВладелецФайла = &ВладелецФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	КоличествоФайлов = Выборка.Количество;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Отказ = НЕ ПроверитьЗаполнение();
	
	Если ЗначениеЗаполнено(ТекстОтвета) ИЛИ ((Не ЗначениеЗаполнено(Объект.ИсторияСтрока)) И (Не ЗначениеЗаполнено(Объект.Проблема))) Тогда
		
		Текст = "Отправте текст в поле Истории";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Элементы.ТекстОтвета");
		Отказ = Истина;
		
	КонецЕсли;
	
	Если НЕ Отказ И НЕ Объект.Проведен И ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда 
		
		Объект.Ознакомлен = Истина;
		Объект.ИсторияСтрока = Объект.ИсторияСтрока + СформироватьТекстАрхив("Документ помещен в архив.");
		Пересохранить = Истина;
		ОбновитьИсторию();
		
	ИначеЕсли НЕ Отказ И Объект.Проведен И ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		
		Объект.ИсторияСтрока = Объект.ИсторияСтрока + СформироватьТекстАрхив("Документ вернули из архива.");
		Пересохранить = Истина;
		ОбновитьИсторию();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
	
	Если ЗначениеЗаполнено(ТекстОтвета) Тогда
		
		#Если НЕ ВебКлиент Тогда
			
			Если НЕ ПроверитьПравописание() Тогда
				
				Возврат;
				
			КонецЕсли;
			
		#КонецЕсли
		
		Если ЗначениеЗаполнено(Объект.Адресат) И ЗначениеЗаполнено(Объект.ВидСлужебнойЗаписки) Тогда
			
			ТекстОтвета = СформироватьТекстОтвета(ТекстОтвета);
			
			Если ЗначениеЗаполнено(Объект.ИсторияСтрока) Тогда
				Объект.ИсторияСтрока = Объект.ИсторияСтрока + ТекстОтвета;
			Иначе
				ТекстАдресат = СформироватьТекстАдресат();
				Объект.ИсторияСтрока = ТекстАдресат + ТекстОтвета;
			КонецЕсли;
			
			ТекстОтвета = "";
			
			Если Объект.Дилерский Тогда
				
				АдресатИзменен = Ложь;
				
				Если ДилерскийДоступ Тогда
					Если Объект.Адресат <> Супервайзер Тогда
						Объект.Адресат = Супервайзер;
						АдресатИзменен = Истина;
					КонецЕсли;
				КонецЕсли;
				
				Если АдресатИзменен Тогда
					АдресатПриИзменении(Неопределено);
				КонецЕсли;
				
			КонецЕсли;
			
			
			Объект.Ознакомлен = (Пользователь = Объект.Адресат);
			Пересохранить = Истина;
			ОбновитьИсторию();
			
		Иначе
			
			Сообщить("Заполните Вид служебной записки и Адресата");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресатПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Адресат) Тогда
		
		АдресатСтрока = ПолучитьСтрокаАдресат(Объект.Адресат); 
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И ЗначениеЗаполнено(Объект.Адресат) Тогда
		
		Объект.Ознакомлен = Ложь;
		
		СтарыйАдресат = ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "Адресат");
		СтарыйАдресатСтрока = ПолучитьСтрокаАдресат(СтарыйАдресат);
		
		Если СтарыйАдресат <> Объект.Адресат Тогда
			
			Объект.ИсторияСтрока = Объект.ИсторияСтрока + СформироватьТекстСменаАдресата(СтарыйАдресатСтрока);
			Пересохранить = Истина;
			ОбновитьИсторию();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидСлужебнойЗапискиПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ВидСЗ = ЛексСервер.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ВидСлужебнойЗаписки");
		
		Если ВидСЗ <> Объект.ВидСлужебнойЗаписки Тогда
			
			Объект.ИсторияСтрока = Объект.ИсторияСтрока + СформироватьТекстСменаВидаСЗ(ВидСЗ);
			Пересохранить = Истина;
			ОбновитьИсторию();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьПравописание()
	
	Массив = ВыполнитьпроверкуПравописания(ТекстОтвета);
	
	ТекстЗамены = "Обнаружены орфографические ошибки:" + Символы.ПС;
	
	Для Каждого Элем Из Массив Цикл
		
		Попытка
			// На случай если не будет замены
			ТекстЗамены = ТекстЗамены + Элем.Слово + " - "+ Элем.Замена[0] + Символы.ПС;
		Исключение
		КонецПопытки;
		
	КонецЦикла;
	
	ТекстЗамены = ТекстЗамены + Символы.ПС + "Произвести замену?";
	
	Если Массив.Количество() > 0 Тогда
		
		Режим = РежимДиалогаВопрос.ДаНетОтмена;
		Ответ = Вопрос(ТекстЗамены, Режим, 0);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			Для каждого Элем Из Массив Цикл
				
				Попытка
					ТекстОтвета = СтрЗаменить(ТекстОтвета, Элем.Слово, Элем.Замена[0]);
				Исключение
				КонецПопытки;
				
			КонецЦикла;
			
		ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
			
			Возврат Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция ВыполнитьпроверкуПравописания(Текст)
	
	#Если НЕ ВебКлиент Тогда
		
		СтрокаПроверки = Текст;
		
		Соединение = Новый HTTPСоединение("speller.yandex.net/services/spellservice/checkText?text="+СтрЗаменить(СтрокаПроверки,"","+"));
		Массив = Новый Массив;
		Файл = ПолучитьИмяВременногоФайла(".xml"); // не работает в ВебКлиенте
		Соединение.Получить("", Файл);
		Чтение = Новый ЧтениеXML;
		Чтение.ОткрытьФайл(Файл);
		
		Пока Чтение.Прочитать() Цикл
			Структура = Новый Структура;
			Если Чтение.Имя = "word" Тогда
				Чтение.Прочитать();
				Структура.Вставить("Слово", Чтение.Значение);
				Чтение.Прочитать();
				Чтение.Прочитать();
			КонецЕсли;
			МассивОб = Новый Массив;
			Пока Чтение.Имя = "s" Цикл
				Чтение.Прочитать();
				МассивОб.Добавить(Чтение.Значение);
				Чтение.Прочитать();
				Чтение.Прочитать();
			КонецЦикла;
			Если НЕ МассивОб.Количество() = 0 Тогда
				Структура.Вставить("Замена", МассивОб);
				Массив.Добавить(Структура);
			КонецЕсли;
		КонецЦикла;
		
		Возврат Массив;
		
	#КонецЕсли
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Пересохранить = Ложь;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если (НЕ ЗначениеЗаполнено(Объект.ИсторияСтрока)) И ЗначениеЗаполнено(Объект.Проблема) Тогда
			Объект.ИсторияСтрока = Объект.Проблема;
			Пересохранить = Истина;
		КонецЕсли;
		
		ОбновитьИсторию();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СформироватьТекстАдресат()
	
	ФормТекст = "";
	ФормТекст = ФормТекст + "☺B☺" + "Адресат:" + "☺B☺ ";
	ФормТекст = ФормТекст + "☺A☺" + АдресатСтрока + "☺A☺" + Символы.ПС + Символы.ПС;
	ФормТекст = ФормТекст + "☺B☺" + "________________________" + "☺B☺";
	
	Возврат ФормТекст;
	
КонецФункции

&НаКлиенте
Функция СформироватьТекстОтвета(Текст)
	
	ФормТекст = Символы.ПС + Символы.ПС;
	ФормТекст = ФормТекст + "☺C☺" + АвторСтрока + "☺C☺ ";
	ФормТекст = ФормТекст + "☺B☺" + Формат(ТекущаяДата(), "ДФ=d.MM.yy") + " в " + Формат(ТекущаяДата(), "ДФ=H:mm") + "☺B☺"+ Символы.ПС;
	ФормТекст = ФормТекст + ТекстОтвета + Символы.ПС;
	ФормТекст = ФормТекст + "☺B☺" + "________________________" + "☺B☺";
	
	Возврат ФормТекст;
	
КонецФункции

&НаКлиенте
Функция СформироватьТекстСменаАдресата(СтарыйАдресат)
	
	ФормТекст = Символы.ПС + Символы.ПС;
	ФормТекст = ФормТекст + "☺E☺Смена адресата:☺E☺ ";
	ФормТекст = ФормТекст + "☺C☺" + СтарыйАдресат + "☺C☺" + " >>> ";
	ФормТекст = ФормТекст + "☺A☺" + АдресатСтрока + "☺A☺ ";
	ФормТекст = ФормТекст + "☺B☺" + Формат(ТекущаяДата(), "ДФ=d.MM.yyyy") + " в☺B☺ ";
	ФормТекст = ФормТекст + "☺B☺" + Формат(ТекущаяДата(), "ДФ=H:mm") + "☺B☺" + Символы.ПС + Символы.ПС;
	ФормТекст = ФормТекст + "☺B☺" + "________________________" + "☺B☺";
	
	Возврат ФормТекст;
	
КонецФункции

&НаКлиенте
Функция СформироватьТекстСменаВидаСЗ(СтарыйВид)
	
	ФормТекст = Символы.ПС + Символы.ПС;
	ФормТекст = ФормТекст + "☺E☺Смена вида СЗ:☺E☺ ";
	ФормТекст = ФормТекст + "☺C☺" + СтарыйВид + "☺C☺" + " >>> ";
	ФормТекст = ФормТекст + "☺A☺" + Объект.ВидСлужебнойЗаписки + "☺A☺ ";
	ФормТекст = ФормТекст + "☺B☺" + Формат(ТекущаяДата(), "ДФ=d.MM.yyyy") + " в☺B☺ ";
	ФормТекст = ФормТекст + "☺B☺" + Формат(ТекущаяДата(), "ДФ=H:mm") + "☺B☺" + Символы.ПС + Символы.ПС;
	ФормТекст = ФормТекст + "☺B☺" + "________________________" + "☺B☺";
	
	Возврат ФормТекст;
	
КонецФункции

&НаКлиенте
Функция СформироватьТекстАрхив(Текст)
	
	ФормТекст = Символы.ПС + Символы.ПС;
	ФормТекст = ФормТекст + "☺C☺" + АвторСтрока + "☺C☺ ";
	ФормТекст = ФормТекст + "☺D☺" + Текст + "☺D☺ "; 
	ФормТекст = ФормТекст + "☺B☺" + Формат(ТекущаяДата(), "ДФ=d.MM.yyyy") + " в☺B☺ ";
	ФормТекст = ФормТекст + "☺B☺" + Формат(ТекущаяДата(), "ДФ=H:mm") + "☺B☺ " + Символы.ПС + Символы.ПС;
	ФормТекст = ФормТекст + "☺B☺" + "________________________" + "☺B☺";
	
	Возврат ФормТекст;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьИсторию()
	
	Тэги = Новый Массив;
	Тэги.Добавить("A");
	Тэги.Добавить("B");
	Тэги.Добавить("C");
	Тэги.Добавить("D");
	Тэги.Добавить("E");
	
	ФормМас = Новый Массив;
	
	Строка = Объект.ИсторияСтрока;
	
	Дальше = Истина;
	
	Пока Дальше Цикл
		
		Мас = РазложитьСтроку(Строка, "☺");
		
		Если Мас.Количество() > 1 Тогда
			
			Дальше = Ложь;
			Тэг = "☺" + Мас[1] + "☺";
			
			Для Каждого Т Из Тэги Цикл
				
				Если Тэг = "☺" + Т + "☺" Тогда
					
					Дальше = Истина;
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если НЕ Дальше Тогда
				
				Мас = РазложитьСтроку(Строка, Тэг);
				Строка = СобратьМассив(Мас, "");
				Дальше = Истина;
				
			Иначе
				
				Мас = РазложитьСтроку(Строка, Тэг);
				
				Если Мас.Количество() > 2 Тогда
					
					ДобавитьФормат(Мас,Тэг,ФормМас);
					Мас.Удалить(0);
					Мас.Удалить(0);
					Строка = СобратьМассив(Мас,Тэг);
					
				Иначе	
					
					Дальше = Ложь;
					ФормМас.Добавить(Новый ФорматированнаяСтрока(Строка,, WebЦвета.Черный));
					
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			
			Дальше = Ложь;
			ФормМас.Добавить(Новый ФорматированнаяСтрока(Строка,, WebЦвета.Черный));
			
		КонецЕсли;
		
	КонецЦикла;
	
	История.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока(ФормМас));
	
	Объект.Проблема = История.ПолучитьТекст();
	
	Если Пересохранить Тогда
		
		Записать();
		
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФормат(Данные,Тип,Массив)
	
	// A - Красный жирный
	// B - Серый
	// C - Синий жирный
	// D - Коричневый жирный
	// E - Черный жирный
	
	Если Тип = "☺A☺" Тогда
		
		Массив.Добавить(Новый ФорматированнаяСтрока(Данные[0],, WebЦвета.Черный));
		Массив.Добавить(Новый ФорматированнаяСтрока(Данные[1],Новый Шрифт(,,Истина), Новый Цвет(160,0,0)));
		
	ИначеЕсли Тип = "☺B☺" Тогда
		
		Массив.Добавить(Новый ФорматированнаяСтрока(Данные[0],, WebЦвета.Черный));
		Массив.Добавить(Новый ФорматированнаяСтрока(Данные[1],, Новый Цвет(149,149,149)));
		
	ИначеЕсли Тип = "☺C☺" Тогда
		
		Массив.Добавить(Новый ФорматированнаяСтрока(Данные[0],, WebЦвета.Черный));
		Массив.Добавить(Новый ФорматированнаяСтрока(Данные[1],Новый Шрифт(,,Истина), Новый Цвет(59,89,167)));
		
	ИначеЕсли Тип = "☺D☺" Тогда
		
		Массив.Добавить(Новый ФорматированнаяСтрока(Данные[0],, WebЦвета.Черный));
		Массив.Добавить(Новый ФорматированнаяСтрока(Данные[1],Новый Шрифт(,,Истина), Новый Цвет(100,45,20)));
		
	ИначеЕсли Тип = "☺E☺" Тогда
		
		Массив.Добавить(Новый ФорматированнаяСтрока(Данные[0],, WebЦвета.Черный));
		Массив.Добавить(Новый ФорматированнаяСтрока(Данные[1],Новый Шрифт(,,Истина)));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция РазложитьСтроку(Строка, Разделитель)
	
	Возврат  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Строка, Разделитель);
	
КонецФункции

&НаКлиенте
Функция СобратьМассив(Массив, Разделитель)
	
	Возврат  СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрокНеПропускатьПустые(Массив, Разделитель);
	
КонецФункции

&НаСервере
Функция ПолучитьСтрокаАдресат(Ссылка)
	
	Стр = "";
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		
		Стр = Ссылка.ОбъектАвторизации.Наименование;
		
	Иначе
		
		ФЛ = Ссылка.ФизическоеЛицо;
		Стр = ФЛ.Фамилия + " " +Лев(ФЛ.Имя,1)+"."+Лев(ФЛ.Отчество,1)+".";
		
	КонецЕсли;
	
	Возврат Стр;	
	
КонецФункции