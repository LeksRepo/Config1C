﻿
&НаСервере
Функция ЗаполнитьПрофили()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Спецификация.Подразделение);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АлюминиевыеПрофили.Ссылка
	|ИЗ
	|	Справочник.АлюминиевыеПрофили КАК АлюминиевыеПрофили
	|ГДЕ
	|	АлюминиевыеПрофили.Подразделение = &Подразделение
	|	И АлюминиевыеПрофили.Активность
	|
	|УПОРЯДОЧИТЬ ПО
	|	АлюминиевыеПрофили.Наименование";
	
	СписокПрофилей =  Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Элементы.АлюминПрофиль.СписокВыбора.ЗагрузитьЗначения(СписокПрофилей);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруПрофиля(Профиль, Тип = 1)
	
	СтруктураПрофиля = Справочники.Двери.ПолучитьСтруктуруПрофиля(Профиль, Тип);
	
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
Функция СписокЭлементовГруппы(Группа, Папка = "", Спецификация, Профиль)
	
	НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы[СтрЗаменить(Группа, " ", "")];
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Группа", НоменклатурнаяГруппа);
	Запрос.УстановитьПараметр("Папка", Папка);
	Запрос.УстановитьПараметр("Подразделение", Спецификация.Подразделение);
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	Запрос.УстановитьПараметр("АсимметричныйПрофиль", Профиль.ВертикальныйПрофиль.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ВертикальныйПрофильАсимметричный);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	спрНоменклатура.Наименование КАК Наименование,
	|	спрНоменклатура.Код,
	|	спрНоменклатура.Ссылка,
	|	спрНоменклатура.Родитель КАК Родитель,
	|	спрНоменклатура.ГлубинаДетали КАК ГлубинаДетали,
	|	спрНоменклатура.ПоперечнаяТекстура КАК ПоперечнаяТекстура,
	|	спрНоменклатура.НаличиеТекстуры КАК НаличиеТекстуры,
	|	ЕСТЬNULL(НоменклатураПодразделений.ПодЗаказ, ИСТИНА) КАК ПодЗаказ,
	|	ЕСТЬNULL(НоменклатураПодразделений.ОкруглятьДоЛистов, ИСТИНА) КАК Округлять
	|ИЗ
	|	Справочник.Номенклатура КАК спрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений.СрезПоследних(&Период, Подразделение = &Подразделение) КАК НоменклатураПодразделений
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
	|	И ВЫБОР
	|			КОГДА &АсимметричныйПрофиль
	|				ТОГДА спрНоменклатура.ГлубинаДетали <= 16
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
				
				НаправлениеТекстуры = ?(Выборка.НаличиеТекстуры,Число(Выборка.ПоперечнаяТекстура)+1,0);
				
				Стр.Вставить("НаправлениеТекстуры",НаправлениеТекстуры);
				
				Элементы.Добавить(Стр);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла; // ВыборкаИтог.Следующий()
	
	Если НЕ ВыборПапкиГравировки Тогда
		
		Тип = 0;
		
		Пока Тип < 4 Цикл
			
			Для Каждого Элемент Из Элементы Цикл
				
				Если Элемент.Иконка = Тип Тогда
					
					Строка = Строка + Элемент.Наименование + "♦" + Элемент.Код + "♦" + Элемент.УменьшениеВставки + "♦" + Элемент.Иконка + "♦" + Число(Элемент.НаправлениеТекстуры) + "☺";
					
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

&НаСервереБезКонтекста
Функция ПолучитьДоступностьРазмеров(Спецификация)
	
	Доступность = Истина;
	Изделие = Спецификация.Изделие;
	
	Если Изделие = Справочники.Изделия.ШкафКупеПоКаталогу ИЛИ
		 Изделие = Справочники.Изделия.КорпусныйШкафКупеПоКаталогу Тогда
		 
		 Доступность = Ложь;
		 
	КонецЕсли;
	
	Возврат Доступность;
	
КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Спецификация") Тогда
		Спецификация = Параметры.Спецификация; 
	ИначеЕсли ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		Спецификация = ЛексСервер.ПолучитьСпецификациюДвери(Объект.Ссылка);
	Иначе		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Спецификация не найдена");
	    Отказ = Истина;
	КонецЕсли;
	
	Объект.Подразделение = Спецификация.Подразделение;
	
	ОбщаяНоменклатура = ПолучитьОбщуюНоменклатуру(Объект.Подразделение);
		
	ИмяHTML = Справочники.ФайлыЛекс.ContainerHtml.Наименование + Справочники.ФайлыЛекс.ContainerHtml.Расширение;
	ИмяSWF = Справочники.ФайлыЛекс.ДвериFlash.Наименование + Справочники.ФайлыЛекс.ДвериFlash.Расширение;
	
	ПримечаниеДляПечати = ЛексСервер.УстановитьПримечание();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ТолькоПросмотр = ТолькоПросмотр ИЛИ (НЕ ЛексСервер.ДоступностьСпецификации(Спецификация));
	
	КоличествоДверей = 0;
	ФлэшАктивирован = Ложь;
	
	Если НЕ ТолькоПросмотр Тогда
		
		//Параметры при заполнении двери из каталога по шкафам
		//Возможно открытие созданной двери с параметрами, которые необходимо применить
		
		Если Параметры.Свойство("ВысотаПроема") Тогда
			Объект.ВысотаПроема = Параметры.ВысотаПроема;
		КонецЕсли;
		
		Если Параметры.Свойство("ШиринаПроема") Тогда
			Объект.ШиринаПроема = Параметры.ШиринаПроема;
		КонецЕсли;
		
		Если Параметры.Свойство("КоличествоДверей") Тогда
			КоличествоДверей = Параметры.КоличествоДверей;
		КонецЕсли;
		
		Если Параметры.Свойство("Редактирование") Тогда
			//Переменная при загрузке формы информирует что параметры формы изменены, необходимо загрузить флэшку с новыми параметрами
			//При сохранении переменная информирует об ошибке формирования флэшки(пустые области).
			ИзменениеПараметров = Параметры.Редактирование;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Спецификация) Тогда
		ЗаполнитьПрофили();
	КонецЕсли;
	
	Элементы.ОсновныеРеквизиты.Видимость = Ложь;
	Элементы.КодНаименование.Видимость = Ложь;
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Инициализация = Ложь;
	
	url = ЛексКлиент.ПутьHTML(ИмяHTML)+"?"+ЛексКлиент.ПутьHTML(ИмяSWF);
	
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
	
	ДоступностьРазмеров = ПолучитьДоступностьРазмеров(Спецификация);
	
	Элементы.АлюминПрофиль.Доступность = ЗначениеЗаполнено(Спецификация);
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
		
	Если НЕ ФлэшАктивирован Тогда
		Сообщить("Редактор дверей не загружен. Изменения не сохранены.");
		Отказ = Истина;	
	КонецЕсли;
	
	Если Объект.ВидДвери = ПредопределенноеЗначение("Перечисление.ВидыДверей.Раздвижная") Тогда
	
		Если  Объект.Количество < 2 И Объект.Трек < Объект.ШиринаПроема Тогда
			
			Сообщить("Для одной раздвижной двери, припуск трека не должен быть менее ширины проема");
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ СВОЙСТВ И КАТЕГОРИЙ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура АлюминПрофильПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.АлюминПрофиль) Тогда
		
		СтруктураПрофиля = ПолучитьСтруктуруПрофиля(Объект.АлюминПрофиль);
		
		Если НЕ ЗначениеЗаполнено(СтруктураПрофиля.РамкаСредняяСКреплением) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнена средняя рамка.");
			Объект.АлюминПрофиль = Неопределено;
			
		Иначе
		
			СтрокаПрофиля = СтруктураПрофиля.СтрокаПрофиля;
			КоличествоШлегель = Неопределено;
			
			Данные = "prof☻"
			+ СтрокаПрофиля
			+ Строка(Формат(Объект.ВысотаПроема, "ЧГ=0"))
			+ "_" + Строка(Формат(Объект.ШиринаПроема, "ЧГ=0"))
			+ "_" + ?(Объект.ВидДвери = ПредопределенноеЗначение("Перечисление.ВидыДверей.Раздвижная"), "1", "2")
			+ "_" + Строка(Формат(Объект.Трек, "ЧГ=0"))
			+ "_" + СтруктураПрофиля.Цвет
			+ "_" + Строка(Объект.АлюминПрофиль)
			+ "_" + "100" //Минимальная Высота
			+ "_" + "100"; //Минимальная Ширина
			
			ОбновитьФлэш(Данные); 
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииВидДвери()
	
	ПриИзмененииПараметров();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииШиринаПроема()
	
	ПриИзмененииПараметров();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметров()
	
	Если ЗначениеЗаполнено(Объект.АлюминПрофиль) Тогда
		ОбновитьФлэш("updt☻"
		+ Строка(Формат(Объект.ВысотаПроема, "ЧГ=0")) + "_"
		+ Строка(Формат(Объект.ШиринаПроема, "ЧГ=0")) + "_"
		+ ?(Объект.ВидДвери = ПредопределенноеЗначение("Перечисление.ВидыДверей.Раздвижная"), "1","2") + "_"
		+ Строка(Формат(Объект.Трек, "ЧГ=0")));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьПраваДляРедактированияПрофиля()
	Возврат РольДоступна("РедактированиеПрофиляДвери") ИЛИ РольДоступна("ПолныеПрава");	
КонецФункции

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
		
	ИначеЕсли Команда = "ppan" Тогда
		
		ЕстьДоступ = ПроверитьПраваДляРедактированияПрофиля();
		Если ЕстьДоступ Тогда
			ОбновитьФлэш("ppan");	
		КонецЕсли;
				
	ИначеЕсли Команда = "pro2" Тогда // получена команда "mass"
		
		ПолучитьПрофиль(ЗначениеОтФлэш);
		Модифицированность = Истина;
		
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
		
	ИначеЕсли Команда = "prin" Тогда //prin нажатие кнопки печати из флэшки
		
		Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда	
			ЛексСервер.ЗаписатьДействиеПользователя(Неопределено, ПредопределенноеЗначение("Перечисление.ВидыАктивностиПользователей.ПечатьДвери"));
		КонецЕсли;
		
		Возврат;
			
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
	Логотип = ЛексКлиент.ПолучитьЛоготип(Спецификация);
	
	ФлэшАктивирован = Истина;
	
	Элементы.ОсновныеРеквизиты.Видимость = Истина;
	Элементы.КодНаименование.Видимость = Истина;
	Элементы.Декорация3агрузка.Видимость = Ложь;
	
	Если ЗначениеЗаполнено(Объект.СтрокаДляФлэш) Тогда
		
		Строка = Объект.СтрокаДляФлэш;
				
		ОбновитьФлэш("load☻" + Строка + "☻" + ?(ЭтаФорма.ТолькоПросмотр,1,0) + "☻" + Логотип + "☻" + КоличествоДверей);
		
		Если ИзменениеПараметров Тогда
			
			ПриИзмененииПараметров();
			ИзменениеПараметров = Ложь;
			
		КонецЕсли;
		
	Иначе
		ОбновитьФлэш("load☻+☻☻"+Логотип+"☻"+КоличествоДверей);
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

	//RonEXI: Трофимушкин сказал добавить МДФ16
	//RonEXI: Жульдиков сказал добавить МДФ18
	
	ОбновитьФлэш("fill☻"
	+ "ЛДСП 10_0|"
	+ "ЛДСП 16_0|"
	+ "МДФ 8_0|"
	+ "МДФ 10_0|"
	+ "МДФ 16_0|"
	+ "МДФ 18_0|"
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
		ОбновитьФлэш("matg☻" + СписокЭлементовГруппы(Группа, ,Спецификация, Объект.АлюминПрофиль));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьПрофиль(Тип) 
	
	СтруктураПрофиля = ПолучитьСтруктуруПрофиля(Объект.АлюминПрофиль, Тип);
		
	СтрокаПрофиля = СтруктураПрофиля.СтрокаПрофиля;
	
	Данные = "pro2☻"
	+ СтрокаПрофиля
	+ Строка(Формат(Объект.ВысотаПроема, "ЧГ=0"))
	+ "_" + Строка(Формат(Объект.ШиринаПроема, "ЧГ=0"))
	+ "_" + ?(Объект.ВидДвери = ПредопределенноеЗначение("Перечисление.ВидыДверей.Раздвижная"), "1", "2")
	+ "_" + Строка(Формат(Объект.Трек, "ЧГ=0"))
	+ "_" + СтруктураПрофиля.Цвет
	+ "_" + Строка(Объект.АлюминПрофиль)
	+ "_" + "100" //Минимальная Высота
	+ "_" + "100"; //Минимальная Ширина
	
	ОбновитьФлэш(Данные); 
	
КонецПроцедуры

&НаКлиенте
Процедура НаполнитьГравировкиФлэш()//Команда = "fil2"
	
	ОбновитьФлэш("fil2☻" + СписокЭлементовГруппы("Гравировка", ,Спецификация, Объект.АлюминПрофиль));
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыГравировкиФлэш(ПапкаГравировки)//Команда = "mat2"
	
	ОбновитьФлэш("mat2☻" + СписокЭлементовГруппы("Гравировка", ПапкаГравировки, Спецификация, Объект.АлюминПрофиль));
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстураФлэш(Код)//Команда = "text"
	
	ПредупредитьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура МассивФлэш(СтрокаОтФлэш)//Команда = "mass"
	
	МассивПараметровДвери = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаОтФлэш, "☺");
	Профиль = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МассивПараметровДвери[3], "_");
	
	КоличествоДверейИзменилось = Ложь;
	
	Если Объект.Количество <> Число(Профиль[13]) Тогда
		КоличествоДверейИзменилось = Истина;
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
		
		Если ПримечаниеДляПечати = "" Тогда
			ПримечаниеДляПечати = "%НЕКЛИЕНТУ%" + Объект.Комментарий;	
		КонецЕсли;
		
		СтруктураНомеров = ПолучитьНомераДокументов(Спецификация);
		
		Данные = Новый Структура();
		Данные.Вставить("ТекущаяДверь",Объект.Ссылка);
		Данные.Вставить("Спецификация",Спецификация);
		Данные.Вставить("Договор",СтруктураНомеров.Договор);
				
		Стр = ПолучитьДанныеДляПечатиДвери(Данные,ПримечаниеДляПечати);

		ОбновитьФлэш(Стр);
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеДляПечатиДвери(Данные,Примечание)
	
	Возврат Справочники.Двери.ПолучитьДанныеДляПечатиДвери(Данные,Примечание);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьНомераДокументов(Спецификация)
	
	СтруктураНомеров = Новый Структура;
	СтруктураНомеров.Вставить("Договор", "");
	СтруктураНомеров.Вставить("Проведен", Спецификация.Проведен);
	СтруктураНомеров.Вставить("Дилерский", Спецификация.Дилерский);
	
	ДоговорСсылка = Документы.Спецификация.ПолучитьДоговор(Спецификация);
	Если ТипЗнч(ДоговорСсылка) = Тип("ДокументСсылка.Договор") Тогда
		СтруктураНомеров.Вставить("Договор", ДоговорСсылка);
	КонецЕсли;
	
	Возврат СтруктураНомеров;
	
КонецФункции // ПолучитьНомераДокументов()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ <СписокНоменклатуры>

&НаКлиенте
Процедура Добавить(Команда)
	
	Форма = ПолучитьФорму("Справочник.Номенклатура.ФормаВыбора");
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
	
	Если (Данные.Номенклатура = ОбщаяНоменклатура.ШлегельВенге
		ИЛИ Данные.Номенклатура = ОбщаяНоменклатура.ШлегельЗолото
		ИЛИ Данные.Номенклатура = ОбщаяНоменклатура.ШлегельХром
		ИЛИ Данные.Номенклатура = ОбщаяНоменклатура.ШлегельБелый) Тогда
		
		КоличествоШлегель = Данные.Ширина;
		ПриИзмененииПараметров();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОбщуюНоменклатуру(Подразделение)
	Возврат ЛексСерверПовтИсп.ПолучитьОбщуюНоменклатуруПолностью(Подразделение);	
КонецФункции
