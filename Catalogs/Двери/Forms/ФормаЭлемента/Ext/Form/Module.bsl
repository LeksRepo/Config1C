﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруПрофиля(Профиль, Подразделение)
	
	СтруктураПрофиля = Справочники.Двери.ПолучитьСтруктуруПрофиля(Профиль, Подразделение);
		
	Возврат СтруктураПрофиля;
	
КонецФункции

&НаКлиенте
Функция ОбновитьФлэш(Строка)
	
	//Клик = Ложь;
	ЭлементФлэш = Элементы.Флэш.Документ.getElementById("back");
	
	Если ЭлементФлэш <> Неопределено Тогда
		ЭлементФлэш.tag = Строка;
		ЭлементФлэш.click();
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция СписокЭлементовГруппы(Группа, Подразделение)
	
	// { Васильев Александр Леонидович [08.11.2013]
	// для стекляшек бы только 4 мм толщину (глубину)
	// } Васильев Александр Леонидович [08.11.2013]
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Группа", Группа);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	спрНоменклатура.Наименование КАК Наименование,
	|	спрНоменклатура.Код,
	|	спрНоменклатура.Родитель КАК Родитель
	|ИЗ
	|	Справочник.Номенклатура КАК спрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений КАК НоменклатураПодразделений
	|		ПО (НоменклатураПодразделений.Номенклатура = спрНоменклатура.Ссылка)
	|ГДЕ
	|	(спрНоменклатура.НоменклатурнаяГруппа.Наименование = &Группа
	|			ИЛИ спрНоменклатура.Родитель.Наименование = &Группа)
	|	И НЕ спрНоменклатура.ПометкаУдаления
	|	И НЕ спрНоменклатура.ЭтоГруппа
	|	И спрНоменклатура.НоменклатурнаяГруппа <> ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.ПустаяСсылка)
	|	И спрНоменклатура.Базовый
	|	И НоменклатураПодразделений.Подразделение = &Подразделение
	|	И НоменклатураПодразделений.Доступность
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
	Запрос.УстановитьПараметр("Подразделение", Подразделение);

	Строка = "";
	ВыборкаИтог = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаИтог.Следующий() Цикл
		Если Группа = "Гравировка" Тогда
			Если ЗначениеЗаполнено(Строка) Тогда 
				Строка = Строка + "|"; 
			КонецЕсли;
			Строка = Строка + ВыборкаИтог.Родитель + "_2";
		Иначе
			Выборка = ВыборкаИтог.Выбрать();
			Пока Выборка.Следующий() Цикл
				Строка = Строка + Выборка.Наименование + "|" + СокрЛП(Выборка.Код) + "|";
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	Строка = Лев(Строка, СтрДлина(Строка) - 1);
	
	Возврат Строка;
	
КонецФункции

&НаКлиенте
Процедура ПредупредитьНаКлиенте() 
	Строка = Новый ФорматированнаяСтрока("Обновите справочник файлов!",,,,"e1cib/command/ОбщаяКоманда.СинхронизацияФайлов");
	Предупреждение(Строка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И НЕ ЭтаФорма.ТолькоПросмотр Тогда
		ЭтаФорма.ТолькоПросмотр = Справочники.Двери.ДоступностьДвери(Объект.Ссылка);
	КонецЕсли;
	
	Если Параметры.Свойство("Подразделение") Тогда
		Объект.Подразделение = Параметры.Подразделение;
	КонецЕсли;
	
	Если Параметры.Свойство("ВысотаПроема") Тогда
		Объект.ВысотаПроема = Параметры.ВысотаПроема;
	КонецЕсли;
	
	Если Параметры.Свойство("ШиринаПроема") Тогда
		Объект.ШиринаПроема = Параметры.ШиринаПроема;
	КонецЕсли;
	
	Если Параметры.Свойство("Редактирование") Тогда
		ИзменениеПараметров = Параметры.Редактирование;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		ПодразделениеПриИзмененииНаСервере();
	КонецЕсли;
	
	ИмяHTML = ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.ДвериHtml);
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	ПользовательДизайнер = УправлениеДоступомПереопределяемый.ЕстьДоступКПрофилюГруппДоступа(Пользователь, Справочники.ПрофилиГруппДоступа.ДизайнерКонсультант);
	ПользовательАдминистратор = УправлениеДоступомПереопределяемый.ЕстьДоступКПрофилюГруппДоступа(Пользователь, Справочники.ПрофилиГруппДоступа.Администратор);
	
	РольДизайнера = ПользовательДизайнер ИЛИ ПользовательАдминистратор;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//Клик = Истина;
	
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
	
	Элементы.Профиль.Доступность = ЗначениеЗаполнено(Объект.Подразделение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОповеститьОВыборе(Объект.Ссылка);
	
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
		СтруктураПрофиля = ПолучитьСтруктуруПрофиля(Объект.Профиль, Объект.Подразделение);	
		
		СтрокаПрофиля = СтруктураПрофиля.СтрокаПрофиля;
		КоличествоШлегель = Неопределено;
		
		ОбновитьФлэш("prof☻"
		+ СтрокаПрофиля
		+ Строка(Формат(Объект.ВысотаПроема, "ЧГ=0"))
		+ "_" + Строка(Формат(Объект.ШиринаПроема, "ЧГ=0"))
		+ "_" + ?(Объект.ВидДвери = ПредопределенноеЗначение("Перечисление.ВидыДверей.Раздвижная"), "1", "2")
		+ "_" + Строка(Формат(Объект.Трек, "ЧГ=0"))
		+ "_" + СтруктураПрофиля.Цвет
		+ "_" + Строка(Объект.Профиль));
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
	
	Если Команда = "init" Тогда // получена команда "init"
		
		ИнициализацияФлэш();
		
	ИначеЕсли Команда = "mass" Тогда // получена команда "mass"
		
		МассивФлэш(ЗначениеОтФлэш);
		Модифицированность = Истина;
				
	ИначеЕсли Команда = "fill" Тогда // получена команда "fill" наполнение текстуры
		
		НаполнитьТекстуруФлэш();
		
	ИначеЕсли Команда = "matg" Тогда // получена команда "matg" наполнение групп текстуры
		
		ГруппыТекстурыФлэш(ЗначениеОтФлэш);
		
	ИначеЕсли Команда = "text" Тогда // получена команда "text"  загрузка текстуры
		
		ТекстураФлэш(ЗначениеОтФлэш);
		
	ИначеЕсли Команда = "fil2" Тогда // получена команда "fil2" наполнение гравировок
		
		НаполнитьГравировкиФлэш();
		
	ИначеЕсли Команда = "mat2" Тогда // получена команда "mat2" наполнение групп гравировок
		
		ГруппыГравировкиФлэш(ЗначениеОтФлэш);
		
	ИначеЕсли Команда = "prtx" Тогда // получена команда "prtx" - Предварительный просмотр и печать
		
		ПечатьФлэш();
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СтрокаДляФлэшПриИзменении(Элемент)
	
	ОбновитьФлэш("load☻" + Объект.СтрокаДляФлэш + "☻0");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ПодразделениеПриИзмененииНаСервере();
	Элементы.Профиль.Доступность = ЗначениеЗаполнено(Объект.Подразделение);
	Объект.Профиль = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзмененииНаСервере() 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	спрНоменклатура.Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК спрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураПодразделений КАК НоменклатураПодразделений
	|		ПО НоменклатураПодразделений.Номенклатура = спрНоменклатура.Ссылка
	|ГДЕ
	|	спрНоменклатура.ВидПрофиля В(&ВидПрофиля)
	|	И спрНоменклатура.Базовый
	|	И НоменклатураПодразделений.Подразделение = &Подразделение
	|	И НоменклатураПодразделений.Доступность";
	Запрос.УстановитьПараметр("ВидПрофиля", Перечисления.ВидыПрофилей.Вертикальный);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	СписокПрофилей =  Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	СписокВыбора = Элементы.Профиль.СписокВыбора;
	СписокВыбора.ЗагрузитьЗначения(СписокПрофилей);
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ <Флэш>

&НаКлиенте
Процедура ИнициализацияФлэш()//Команда = "init"
	
	Если ЗначениеЗаполнено(Объект.СтрокаДляФлэш) Тогда
		Строка = Объект.СтрокаДляФлэш;
		Если ЭтаФорма.ТолькоПросмотр Тогда
			Строка = Объект.СтрокаДляФлэш + "☻1";
		Иначе
			Строка = Объект.СтрокаДляФлэш + "☻0";
		КонецЕсли;
		
		//вставить формирование логотипа
		//Логотип = ПолучитьЛоготип();
		
		ОбновитьФлэш("load☻" + Строка + "☻");		// + Логотип);
	Иначе
		ОбновитьФлэш("load☻+");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаполнитьТекстуруФлэш()//Команда = "fill"
	
	ОбновитьФлэш("fill☻"
	+ "ЛДСП 10 мм._0|"
	+ "ЛДСП 16 мм._0|"
	+ "МДФ 8 мм._0|"
//	+ "МДФ 18 мм._0|" не используется в дверях
//	+ "АГТ Панель_0|" не используется в дверях
	+ "Зеркало_1|" 
	+ "Стекло_1|" 
	+ "Щит Мебельный_0|" 
	+ "Гравировка_2");
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыТекстурыФлэш(Группа)//Команда = "matg"
	
	Если СтрДлина(Группа) > 0 Тогда
		ОбновитьФлэш("matg☻" + СписокЭлементовГруппы(Группа, Объект.Подразделение));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаполнитьГравировкиФлэш()//Команда = "fil2"
	
	ОбновитьФлэш("fil2☻" + СписокЭлементовГруппы("Гравировка", Объект.Подразделение));
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыГравировкиФлэш(ГруппаГравировки)//Команда = "mat2"
	
	ОбновитьФлэш("mat2☻" + СписокЭлементовГруппы(ГруппаГравировки, Объект.Подразделение));
	
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
	
	Если РольДизайнера Тогда
		Примечание = "Размеры, указанные в эскизе могут отличаться от фактических по высоте до 3%, по ширине до 5%.
		|Размеры элементов дверей указываются от края двери (центра стыковочного профиля) до центра
		|стыковочного профиля (края двери)При использовании изогнутых стыковочных профилей размеры их
		|присоединения могут отличаться от фактических до 10%";
	КонецЕсли;
	
	// перед печатью обязательно сохраняем объект
	
	Если ЭтаФорма.ТолькоПросмотр ИЛИ Записать() Тогда
		// второй параметр команды -- строка которая выводится рядом с логотипом. до 4-х строк, разделитель параметров ☻
		// пример: "prtx☻ЗдесьПримечание☻Это первая строка" + Символы.ПС + "А это вторая строка"+Символы.ПС + "Теперь строка номер 3"+Символы.ПС+"Последняя строка");
		СтруктураНомеров = ПолучитьНомераДокументов();
		ОбновитьФлэш("prtx☻" + Примечание +"☻"+ ТекущаяДата() + Символы.ПС + СтруктураНомеров.Договор + Символы.ПС+ СтруктураНомеров.Спецификация+ Символы.ПС+СтруктураНомеров.НомерДвери);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНомераДокументов()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпецификацияСписокДверей.Ссылка КАК Спецификация
	|ИЗ
	|	Документ.Спецификация.СписокДверей КАК СпецификацияСписокДверей
	|ГДЕ
	|	СпецификацияСписокДверей.Двери = &Ссылка";
	Выборка 					= Запрос.Выполнить().Выбрать();
	Количество 				= Выборка.Количество();
	Спецификация 			= "";
	Договор 					= "";
	СпецификацияСсылка 	= Документы.Спецификация.ПустаяСсылка();
	СтруктураНомеров 		= Новый Структура;
	СтруктураНомеров.Вставить("Договор", "");
	СтруктураНомеров.Вставить("Спецификация", "");
	СтруктураНомеров.Вставить("НомерДвери", "Дверь №" + Объект.Ссылка.Код);
	
	Если Количество > 0 Тогда
		
		Если Количество = 1 Тогда
			
			Выборка.Следующий();
			Спецификация 			= Спецификация + Выборка.Спецификация;
			СпецификацияСсылка 	= Выборка.Спецификация;
			
		Иначе
			
			Спецификация = Спецификация + "Эта дверь используется в нескольких спецификациях";
			
		КонецЕсли;
		
	Иначе
		
		Спецификация = Спецификация + "Не используется ни в одной спецификации";
		
	КонецЕсли;
	
	Если СпецификацияСсылка <> Документы.Спецификация.ПустаяСсылка() Тогда
		
		ДоговорСсылка = Документы.Спецификация.ПолучитьДоговор(СпецификацияСсылка);
		
		Если ТипЗнч(ДоговорСсылка) = Тип("ДокументСсылка.Договор") Тогда
			
			Договор = Договор + ДоговорСсылка;
			
		КонецЕсли;
		
		СтруктураНомеров.Вставить("Договор", Договор);
		
	КонецЕсли;
	
	СтруктураНомеров.Вставить("Спецификация", Спецификация);
	
	Возврат СтруктураНомеров;
	
КонецФункции // ()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ <Номенклатура>

&НаКлиенте
Процедура Добавить(Команда)
	
	Форма = ПолучитьФорму("Справочник.Номенклатура.Форма.ФормаВыбора");
	Выбор = Форма.ОткрытьМодально();
	Если Выбор <> Неопределено Тогда
		НоваяСтрока = Объект.Номенклатура.Добавить();
		НоваяСтрока.Номенклатура = Выбор;
		НоваяСтрока.ДобавленоВручную = Истина;
		НоваяСтрока.Количество = 1;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПередУдалением(Элемент, Отказ)
	
	Отказ = НЕ Элемент.ТекущиеДанные.ДобавленоВручную;
	
КонецПроцедуры

&НаКлиенте
Процедура Перезаполнить(Команда)
	
	Объект.Номенклатура.Очистить();
	
	ПерезаполнитьНаСервере();
	// { Васильев Александр Леонидович [04.12.2013]
	// отдельно вынести процедуру заполнения.
	// не сохранять при нажатии кнопки
	// } Васильев Александр Леонидович [04.12.2013]
	////Записать();
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьНаСервере()
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
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

///////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ