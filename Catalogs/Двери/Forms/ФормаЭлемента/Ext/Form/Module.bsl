﻿
&НаСервере
Функция ЗаполнитьПрофили()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПроизводственноеПодразделение", Объект.Спецификация.Подразделение);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	спрНоменклатура.Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК спрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений КАК НоменклатураПодразделений
	|		ПО (НоменклатураПодразделений.Номенклатура = спрНоменклатура.Ссылка)
	|ГДЕ
	|	спрНоменклатура.НоменклатурнаяГруппа = ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.ВертикальныйПрофиль)
	|	И спрНоменклатура.Базовый
	|	И НЕ спрНоменклатура.ЗапретИспользования
	|	И НоменклатураПодразделений.Подразделение = &ПроизводственноеПодразделение";
	
	СписокПрофилей =  Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	СписокВыбора = Элементы.Профиль.СписокВыбора;
	СписокВыбора.ЗагрузитьЗначения(СписокПрофилей);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруПрофиля(Профиль, Спецификация)
	
	СтруктураПрофиля = Справочники.Двери.ПолучитьСтруктуруПрофиля(Профиль, Спецификация.Подразделение);
	
	Возврат СтруктураПрофиля;
	
КонецФункции

&НаКлиенте
Функция ОбновитьФлэш(Строка)
	
	ЭлементФлэш = Элементы.Флэш.Документ.getElementById("back");
	
	Если ЭлементФлэш <> Неопределено Тогда
		ЭлементФлэш.tag = Строка;
		ЭлементФлэш.click();
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция СписокЭлементовГруппы(Группа, Папка = "", Спецификация)
	
	НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы[СтрЗаменить(Группа, " ", "")];
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Группа", НоменклатурнаяГруппа);
	Запрос.УстановитьПараметр("Папка", Папка);
	Запрос.УстановитьПараметр("ПроизводственноеПодразделение", Спецификация.Подразделение);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	спрНоменклатура.Наименование КАК Наименование,
	|	спрНоменклатура.Код,
	|	спрНоменклатура.Ссылка,
	|	спрНоменклатура.Родитель КАК Родитель,
	|	спрНоменклатура.ГлубинаДетали КАК ГлубинаДетали,
	|	НоменклатураПодразделений.ПодЗаказ КАК ПодЗаказ,
	|	НоменклатураПодразделений.ОкруглятьДоЛистов КАК Округлять
	|ИЗ
	|	Справочник.Номенклатура КАК спрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений КАК НоменклатураПодразделений
	|		ПО (НоменклатураПодразделений.Номенклатура = спрНоменклатура.Ссылка)
	|ГДЕ
	|	спрНоменклатура.НоменклатурнаяГруппа В ИЕРАРХИИ(&Группа)
	|	И ВЫБОР
	|			КОГДА &Папка <> """"
	|				ТОГДА спрНоменклатура.Родитель.Наименование = &Папка
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И НЕ спрНоменклатура.ПометкаУдаления
	|	И НЕ спрНоменклатура.ЗапретИспользования
	|	И НЕ спрНоменклатура.ЭтоГруппа
	|	И спрНоменклатура.НоменклатурнаяГруппа <> ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.ПустаяСсылка)
	|	И спрНоменклатура.Базовый
	|	И НоменклатураПодразделений.Подразделение = &ПроизводственноеПодразделение
	|	И ВЫБОР
	|			КОГДА спрНоменклатура.НоменклатурнаяГруппа В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.Стекло))
	|					ИЛИ спрНоменклатура.НоменклатурнаяГруппа В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.Зеркало))
	|				ТОГДА ВЫБОР
	|						КОГДА спрНоменклатура.ГлубинаДетали = 4
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ЛОЖЬ
	|					КОНЕЦ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование
	|ИТОГИ ПО
	|	Родитель";
	
	ВыборПапкиГравировки = Ложь;
	Строка = "";
	ВыборкаИтог = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Элементы = Новый Массив;
	
	Пока ВыборкаИтог.Следующий() Цикл
		
		Если Группа = "Гравировка" И Папка = "" Тогда
			
			ВыборПапкиГравировки = Истина;
			
			Если ЗначениеЗаполнено(Строка) Тогда
				Строка = Строка + "|";
			КонецЕсли;
			
			Строка = Строка + ВыборкаИтог.Родитель + "_2";
			
		Иначе
			
			Выборка = ВыборкаИтог.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				Стр = Новый Структура;
				Стр.Вставить("Наименование",Выборка.Наименование);
				Стр.Вставить("Код",Выборка.Код);
				Стр.Вставить("УменьшениеВставки", ПолучитьУменьшениеВставки(Выборка.ГлубинаДетали));
				
				Если Выборка.ПодЗаказ И Выборка.Округлять Тогда
					Иконка = 3;	
				ИначеЕсли (НЕ Выборка.ПодЗаказ) И (НЕ Выборка.Округлять) Тогда
					Иконка = 0;
				ИначеЕсли Выборка.ПодЗаказ Тогда
					Иконка = 2;
				ИначеЕсли Выборка.Округлять Тогда
					Иконка = 1;
				КонецЕсли;
				
				Стр.Вставить("Иконка", Иконка);
				
				Элементы.Добавить(Стр);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла; // ВыборкаИтог.Следующий()
	
	Если НЕ ВыборПапкиГравировки Тогда
		
		Тип = 0;
		
		Пока Тип < 4 Цикл
			
			Для Каждого Элемент Из Элементы Цикл
				
				Если Элемент.Иконка = Тип Тогда
					
					Строка = Строка + Элемент.Наименование + "♦" + Элемент.Код + "♦" + Элемент.УменьшениеВставки + "♦" + Элемент.Иконка + "☺";
					
				КонецЕсли;
				
			КонецЦикла;
			
			Тип = Тип + 1;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Строка = Лев(Строка, СтрДлина(Строка) - 1);
	
	Возврат Строка;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьУменьшениеВставки(ГлубинаДетали)
	
	Если ГлубинаДетали = 4 Тогда
		
		ТолщинаУплотнителя = 2;
		
	Иначе
		
		ТолщинаУплотнителя = 0;
		
	КонецЕсли;
	
	Возврат ТолщинаУплотнителя;
	
КонецФункции

&НаКлиенте
Процедура ПредупредитьНаКлиенте()
	
	Строка = Новый ФорматированнаяСтрока("Обновите справочник файлов!",,,,"e1cib/command/ОбщаяКоманда.СинхронизацияФайлов");
	Предупреждение(Строка);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДоступностьРазмеров()
	
	МассивОкон = ПолучитьОкна();
	
	Для ы = 0 По МассивОкон.Количество() - 1 Цикл
		Если МассивОкон[ы] <> Неопределено Тогда
			Если МассивОкон[ы].Заголовок = "Шкаф-купе" Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяHTML = ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.ДвериHtml);
	ПримечаниеДляПечати = ЛексСервер.УстановитьПримечание();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ТолькоПросмотр = ТолькоПросмотр ИЛИ (НЕ ЛексСервер.ДоступностьСпецификации(Объект.Спецификация));
	
	Если НЕ ТолькоПросмотр Тогда
		
		//Параметры при заполнении двери из каталога по шкафам
		//Возможно открытие созданной двери с параметрами, которые необходимо применить
		
		Если Параметры.Свойство("ВысотаПроема") Тогда
			Объект.ВысотаПроема = Параметры.ВысотаПроема;
		КонецЕсли;
		
		Если Параметры.Свойство("ШиринаПроема") Тогда
			Объект.ШиринаПроема = Параметры.ШиринаПроема;
		КонецЕсли;
		
		Если Параметры.Свойство("Редактирование") Тогда
			//Переменная при загрузке формы информирует что параметры формы изменены, необходимо загрузить флэшку с новыми параметрами
			//При сохранении переменная информирует об ошибке формирования флэшки(пустые области).
			ИзменениеПараметров = Параметры.Редактирование;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Спецификация) Тогда
		ЗаполнитьПрофили();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Инициализация = Ложь;
	
	url = ЛексКлиент.ПутьHTML(ИмяHTML);
	Если url <> "" Тогда
		Попытка
			Элементы.Флэш.Документ.url = url;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Отказ = Истина;
		КонецПопытки;
	Иначе
		ПредупредитьНаКлиенте();
	КонецЕсли;
	
	ДоступностьРазмеров = ПолучитьДоступностьРазмеров();
	
	Элементы.Профиль.Доступность = ЗначениеЗаполнено(Объект.Спецификация);
	Элементы.ВысотаПроема.Доступность = ДоступностьРазмеров;
	Элементы.ШиринаПроема.Доступность = ДоступностьРазмеров;
	
	ДоступностьНоменклатуры = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если МодифицированностьДвери Тогда
		ОповеститьОВыборе(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОбновитьФлэш("save");
	
	Отказ = ИзменениеПараметров;
	ИзменениеПараметров = Ложь;
	МодифицированностьДвери = Модифицированность;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ СВОЙСТВ И КАТЕГОРИЙ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ПрофильПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Профиль) Тогда
		
		СтруктураПрофиля = ПолучитьСтруктуруПрофиля(Объект.Профиль, Объект.Спецификация);
		
		СтрокаПрофиля = СтруктураПрофиля.СтрокаПрофиля;
		КоличествоШлегель = Неопределено;
		
		ОбновитьФлэш("prof☻"
		+ СтрокаПрофиля
		+ Строка(Формат(Объект.ВысотаПроема, "ЧГ=0"))
		+ "_" + Строка(Формат(Объект.ШиринаПроема, "ЧГ=0"))
		+ "_" + ?(Объект.ВидДвери = ПредопределенноеЗначение("Перечисление.ВидыДверей.Раздвижная"), "1", "2")
		+ "_" + Строка(Формат(Объект.Трек, "ЧГ=0"))
		+ "_" + СтруктураПрофиля.Цвет
		+ "_" + Строка(Объект.Профиль)
		+ "_" + "100" //Минимальная Высота
		+ "_" + "100"); //Минимальная Ширина
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметров()
	
	Если ЗначениеЗаполнено(Объект.Профиль) Тогда
		ОбновитьФлэш("updt☻"
		+ Строка(Формат(Объект.ВысотаПроема, "ЧГ=0")) + "_"
		+ Строка(Формат(Объект.ШиринаПроема, "ЧГ=0")) + "_"
		+ ?(Объект.ВидДвери = ПредопределенноеЗначение("Перечисление.ВидыДверей.Раздвижная"), "1","2") + "_"
		+ Строка(Формат(Объект.Трек, "ЧГ=0")));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФлэшПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если Элементы.Флэш.Документ.getElementById("forw") = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаОтФлэш = Элементы.Флэш.Документ.getElementById("forw").tag;
	Команда = Лев(СтрокаОтФлэш, 4); // код команды, первые 4 символа
	ЗначениеОтФлэш = Прав(СтрокаОтФлэш, СтрДлина(СтрокаОтФлэш) - 5); // полученные значения аргументов от флэш 
	
	Элементы.Флэш.Документ.getElementById("forw").tag = "";
	
	Если Команда = "init" И НЕ Инициализация Тогда // получена команда "init"
		
		ИнициализацияФлэш();
		
	ИначеЕсли Команда = "mass" Тогда // получена команда "mass"
		
		МассивФлэш(ЗначениеОтФлэш);
		Модифицированность = Истина;
		
	ИначеЕсли Команда = "fill" Тогда // получена команда "fill" наполнение текстуры
		
		НаполнитьТекстуруФлэш();
		
	ИначеЕсли Команда = "matg" Тогда // получена команда "matg" наполнение групп текстуры
		
		ГруппыТекстурыФлэш(ЗначениеОтФлэш);
		
	ИначеЕсли Команда = "text" Тогда // получена команда "text" загрузка текстуры
		
		ТекстураФлэш(ЗначениеОтФлэш);
		
	ИначеЕсли Команда = "fil2" Тогда // получена команда "fil2" наполнение гравировок
		
		НаполнитьГравировкиФлэш();
		
	ИначеЕсли Команда = "mat2" Тогда // получена команда "mat2" наполнение групп гравировок
		
		ГруппыГравировкиФлэш(ЗначениеОтФлэш);
		
	ИначеЕсли Команда = "prtx" Тогда // получена команда "prtx" - Предварительный просмотр и печать
		
		ПечатьФлэш();
		
	ИначеЕсли Команда = "serr" Тогда //save_error отмена сохраненния
		
		ИзменениеПараметров = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаДляФлэшПриИзменении(Элемент)
	
	ОбновитьФлэш("load☻" + Объект.СтрокаДляФлэш + "☻0");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ <Флэш>

&НаКлиенте
Процедура ИнициализацияФлэш()//Команда = "init"
	
	Инициализация = Истина;
	Логотип = ЛексКлиент.ПолучитьЛоготип(Объект.Спецификация);
	
	Если ЗначениеЗаполнено(Объект.СтрокаДляФлэш) Тогда
		Строка = Объект.СтрокаДляФлэш;
		Если ЭтаФорма.ТолькоПросмотр Тогда
			Строка = Объект.СтрокаДляФлэш + "☻1";
		Иначе
			Строка = Объект.СтрокаДляФлэш + "☻0";
		КонецЕсли;
		
		ОбновитьФлэш("load☻" + Строка + "☻" + Логотип);
		
		Если ИзменениеПараметров Тогда
			
			ПриИзмененииПараметров();
			ИзменениеПараметров = Ложь;
			
		КонецЕсли;
		
	Иначе
		ОбновитьФлэш("load☻+☻☻"+Логотип);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаполнитьТекстуруФлэш()//Команда = "fill"
	
	// { Васильев Александр Леонидович [13.10.2014]
	// Хорошо бы переделать на свойства к каждой номенклатуре.
	// } Васильев Александр Леонидович [13.10.2014]
	
	//0 обычная текстура
	//1 номенклатура для которой разрешена гравировка
	//2 гравировка
	//3 не используется
	//4 только прямоугольная деталь (кожа)
	
	ОбновитьФлэш("fill☻"
	+ "ЛДСП 10_0|"
	+ "ЛДСП 16_0|"
	+ "МДФ 8_0|"
	+ "МДФ 10_0|"
	+ "Зеркало_1|"
	+ "Стекло_1|"
	+ "Щит Мебельный_4|"
	+ "Гравировка_2");
	
	// { Васильев Александр Леонидович [13.10.2014]
	// Вынести формирование этой строки.
	// Создавать на основании справочника НоменклатурныеГруппы
	// один раз при создании формы.
	// } Васильев Александр Леонидович [13.10.2014]
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыТекстурыФлэш(Группа)//Команда = "matg"
	
	Если СтрДлина(Группа) > 0 Тогда
		ОбновитьФлэш("matg☻" + СписокЭлементовГруппы(Группа, ,Объект.Спецификация));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаполнитьГравировкиФлэш()//Команда = "fil2"
	
	ОбновитьФлэш("fil2☻" + СписокЭлементовГруппы("Гравировка", ,Объект.Спецификация));
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыГравировкиФлэш(ПапкаГравировки)//Команда = "mat2"
	
	ОбновитьФлэш("mat2☻" + СписокЭлементовГруппы("Гравировка", ПапкаГравировки, Объект.Спецификация));
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстураФлэш(Код)//Команда = "text"
	
	ПредупредитьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура МассивФлэш(СтрокаОтФлэш)//Команда = "mass"
	
	МассивПараметровДвери = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаОтФлэш, "☺");
	Профиль = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МассивПараметровДвери[3], "_");
	Если Объект.Количество <> Число(Профиль[13]) Тогда
		КоличествоШлегель = Неопределено;
		Объект.Количество = Число(Профиль[13]);
	КонецЕсли;
	Объект.КоличествоПерехлестов = Число(Профиль[15]);
	Объект.ВысотаДвери = Число(Профиль[17]); 
	Объект.ШиринаДвери = Число(Профиль[16]);
	Объект.ВысотаПолотна = Число(Профиль[19]);
	Объект.ШиринаПолотна = Число(Профиль[18]);
	
	Объект.СтрокаДляРасчета = МассивПараметровДвери[0] + "☺" + МассивПараметровДвери[1] + "☺" + МассивПараметровДвери[2] + "☺" + Число(Объект.КоличествоПерехлестов) + "☺" + КоличествоШлегель +"☺☺☺";
	
	СтрокаФлэш = Сред(СтрокаОтФлэш, Найти(СтрокаОтФлэш, "☺") + 1);
	СтрокаФлэш = Сред(СтрокаФлэш, Найти(СтрокаФлэш, "☺") + 1);
	Объект.СтрокаДляФлэш = Сред(СтрокаФлэш, Найти(СтрокаФлэш, "☺") + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьФлэш()//Команда = "prtx"
	
	// перед печатью обязательно сохраняем объект
	
	Если ЭтаФорма.ТолькоПросмотр ИЛИ Записать() Тогда
		
		МожноПечатать = Истина;
		
		// второй параметр команды -- строка которая выводится рядом с логотипом. до 4-х строк, разделитель параметров ☻
		// пример: "prtx☻ЗдесьПримечание☻Это первая строка" + Символы.ПС + "А это вторая строка"+Символы.ПС + "Теперь строка номер 3"+Символы.ПС+"Последняя строка");
		
		Если ПримечаниеДляПечати = "" Тогда
			ПримечаниеДляПечати = "%НЕКЛИЕНТУ%" + Объект.Комментарий;	
		КонецЕсли;
		
		СтруктураНомеров = ПолучитьНомераДокументов(Объект.Спецификация);
		ОбновитьФлэш("prtx☻" + ПримечаниеДляПечати + "☻" + ТекущаяДата() + Символы.ПС + СтруктураНомеров.Договор + Символы.ПС + Объект.Спецификация + Символы.ПС + Объект.Ссылка);
		
		// { Васильев Александр Леонидович [30.09.2014]
		// Цветную картинку разрешить всем печатать,
		// а чертёж только для завода.
		// } Васильев Александр Леонидович [30.09.2014]
		
		//Если СтруктураНомеров.Свойство("Проведен") Тогда
		//	Если НЕ СтруктураНомеров.Проведен И СтруктураНомеров.Дилерский Тогда
		//		МожноПечатать = Ложь;
		//	КонецЕсли;
		//КонецЕсли;
		//
		//Если МожноПечатать Тогда
		//	ОбновитьФлэш("prtx☻" + ПримечаниеДляПечати + "☻" + ТекущаяДата() + Символы.ПС + СтруктураНомеров.Договор + Символы.ПС + Объект.Спецификация + Символы.ПС + Объект.Ссылка);
		//Иначе
		//	ВызватьИсключение "Печать возможна только для размещенных заказов";
		//КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНомераДокументов(Спецификация)
	
	СтруктураНомеров = Новый Структура;
	СтруктураНомеров.Вставить("Договор", "");
	СтруктураНомеров.Вставить("Проведен", Спецификация.Проведен);
	СтруктураНомеров.Вставить("Дилерский", Спецификация.Дилерский);
	
	ДоговорСсылка = Документы.Спецификация.ПолучитьДоговор(Спецификация);
	Если ТипЗнч(ДоговорСсылка) = Тип("ДокументСсылка.Договор") Тогда
		Договор = Строка(ДоговорСсылка);
	КонецЕсли;
	СтруктураНомеров.Вставить("Договор", Договор);
	
	Возврат СтруктураНомеров;
	
КонецФункции // ПолучитьНомераДокументов()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ <СписокНоменклатуры>

&НаКлиенте
Процедура Добавить(Команда)
	
	Форма = ПолучитьФорму("Справочник.Номенклатура.Форма.ФормаВыбора");
	Выбор = Форма.ОткрытьМодально();
	Если Выбор <> Неопределено Тогда
		НоваяСтрока = Объект.СписокНоменклатуры.Добавить();
		НоваяСтрока.Номенклатура = Выбор;
		НоваяСтрока.ДобавленоВручную = Истина;
		НоваяСтрока.Количество = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПередУдалением(Элемент, Отказ)
	
	Отказ = НЕ Элемент.ТекущиеДанные.ДобавленоВручную;
	
КонецПроцедуры

&НаКлиенте
Процедура Перезаполнить(Команда)
	
	Объект.СписокНоменклатуры.Очистить();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураШиринаПриИзменении(Элемент)
	
	Данные = Элемент.Родитель.ТекущиеДанные;
	
	Если (Данные.Номенклатура = ПредопределенноеЗначение("Справочник.Номенклатура.ШлегельВенге")
		ИЛИ Данные.Номенклатура = ПредопределенноеЗначение("Справочник.Номенклатура.ШлегельЗолото")
		ИЛИ Данные.Номенклатура = ПредопределенноеЗначение("Справочник.Номенклатура.ШлегельХром")
		ИЛИ Данные.Номенклатура = ПредопределенноеЗначение("Справочник.Номенклатура.ШлегельБелый")) Тогда
		
		КоличествоШлегель = Данные.Ширина;
		ПриИзмененииПараметров();
		
	КонецЕсли;
	
КонецПроцедуры