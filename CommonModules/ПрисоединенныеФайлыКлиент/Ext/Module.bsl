﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Присоединенные файлы".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Открывает файл для просмотра или редактирования.
//  Если файл открывается для просмотра, тогда получает файл в рабочий каталог пользователя,
// при этом ищет файл в рабочем каталоге и предлагает открыть существующий или
// получить файл с сервера.
//  Если файл открывается для редактирования, тогда открывает файл в рабочем каталоге (если есть) или
// получает его с сервера.
//
// Параметры:
//  ДанныеФайла       - Структура - данные файла.
//  ДляРедактирования - Булево - истина, если файл открывается для редактирования, иначе ложь.
//
Процедура ОткрытьФайл(Знач ДанныеФайла, Знач ДляРедактирования = Истина) Экспорт
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	
	Если ПодключитьРасширениеРаботыСФайлами()Тогда
		РабочийКаталогПользователя = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
		ПолноеИмяФайлаНаКлиенте = РабочийКаталогПользователя + ДанныеФайла.ОтносительныйПуть + ДанныеФайла.ИмяФайла;
		
		Отказ = Ложь;
		
		ФайлНаДиске = Новый Файл(ПолноеИмяФайлаНаКлиенте);
		
		Если ЗначениеЗаполнено(ДанныеФайла.Редактирует) // Файл уже редактируется.
		   И ДляРедактирования
		   И ФайлНаДиске.Существует() Тогда
			
			ФайлНаДиске.УстановитьТолькоЧтение(Ложь);
			ПолучитьФайл = Ложь;
			
		ИначеЕсли ФайлНаДиске.Существует() Тогда
			ПолучитьФайл = ДиалогНужноПолучитьФайлССервера(ПолноеИмяФайлаНаКлиенте, ДанныеФайла, ДляРедактирования, Отказ);
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
		Иначе
			ПолучитьФайл = Истина;
		КонецЕсли;
		
		ФайлМожноОткрывать = Истина;
		
		Если ПолучитьФайл Тогда
			ПолноеИмяФайлаНаКлиенте = "";
			ФайлМожноОткрывать = ПолучитьФайлВРабочийКаталог(
				ДанныеФайла.СсылкаНаДвоичныеДанныеФайла,
				ДанныеФайла.ОтносительныйПуть,
				ДанныеФайла.ДатаМодификацииУниверсальная,
				ДанныеФайла.ИмяФайла,
				РабочийКаталогПользователя,
				ПолноеИмяФайлаНаКлиенте);
		КонецЕсли;
		
		Если ФайлМожноОткрывать Тогда
			Если ДляРедактирования Тогда
				ФайлНаДиске.УстановитьТолькоЧтение(Ложь);
			Иначе
				ФайлНаДиске.УстановитьТолькоЧтение(Истина);
			КонецЕсли;
			ОткрытьФайлПриложением(ПолноеИмяФайлаНаКлиенте, ДанныеФайла);
		КонецЕсли;
	Иначе
		Если ДанныеФайла.ФайлРедактируется И ДанныеФайла.ФайлРедактируетТекущийПользователь Тогда
			ФайловыеФункцииСлужебныйКлиент.ПоказатьНапоминаниеПриРедактировании();
		КонецЕсли;
		
		ПолучитьФайл(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла, ДанныеФайла.ИмяФайла, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик команды добавления файлов.
//  Предлагает пользователю выбирать файлы в диалоге выбора файлов и
// пытается поместить выбранные файлы в хранилище файлов, когда:
// - размер файла не превышает максимально допустимый,
// - файл имеет допустимое расширение,
// - имеется свободное место в томе (при хранении файлов в томах),
// - прочие условия.
//
// Параметры:
//  ВладелецФайла      - Ссылка - владелец файла.
//  ИдентификаторФормы - УникальныйИдентификатор формы.
//  Фильтр             - Строка - необязательный параметр,
//                       позволяет задать фильтр выбираемого файла,
//                       например, картинки для номенклатуры.
//
Процедура ДобавитьФайлы(Знач ВладелецФайла, Знач ИдентификаторФормы, Знач Фильтр = "") Экспорт
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ВыборФайла.МножественныйВыбор = Истина;
		ВыборФайла.Заголовок = НСтр("ru = 'Выбор файла'");
		ВыборФайла.Фильтр = ?(ЗначениеЗаполнено(Фильтр), Фильтр, НСтр("ru = 'Все файлы'") + " (*.*)|*.*");
		
		Если ВыборФайла.Выбрать() Тогда
			ПрисоединенныеФайлыМассив = Новый Массив;
			ПрисоединенныеФайлыСлужебныйКлиент.ПоместитьВыбранныеФайлыВХранилище(
				ВыборФайла.ВыбранныеФайлы,
				ВладелецФайла,
				ПрисоединенныеФайлыМассив,
				ИдентификаторФормы);
			
			Если ПрисоединенныеФайлыМассив.Количество() = 1 Тогда
				ПрисоединенныйФайл = ПрисоединенныеФайлыМассив[0];
				
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Создание:'"),
					ПолучитьНавигационнуюСсылку(ПрисоединенныйФайл),
					ПрисоединенныйФайл,
					БиблиотекаКартинок.Информация32);
				
				ПараметрыФормы = Новый Структура("ПрисоединенныйФайл, ЭтоНовый", ПрисоединенныйФайл, Истина);
				ОткрытьФорму("ОбщаяФорма.ПрисоединенныйФайл", ПараметрыФормы, , ПрисоединенныйФайл);
			КонецЕсли;
			
			Если ПрисоединенныеФайлыМассив.Количество() > 0 Тогда
				ОповеститьОбИзменении(ПрисоединенныеФайлыМассив[0]);
				Оповестить("Запись_ПрисоединенныйФайл", Новый Структура("ЭтоНовый", Истина), ПрисоединенныеФайлыМассив);
			КонецЕсли;
		
		КонецЕсли;
		
	Иначе // Если веб-клиент без подключенного расширения.
#Если ВебКлиент Тогда
		ПрисоединенныйФайл = ПрисоединенныеФайлыСлужебныйКлиент.ПоместитьВыбранныеФайлыВХранилищеВеб(
			ВладелецФайла, ИдентификаторФормы);
		
		Если ПрисоединенныйФайл <> Неопределено Тогда
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Создание'"),
				ПолучитьНавигационнуюСсылку(ПрисоединенныйФайл),
				ПрисоединенныйФайл,
				БиблиотекаКартинок.Информация32);
			
			ОповеститьОбИзменении(ПрисоединенныйФайл);
			
			ПараметрыФормы = Новый Структура("ПрисоединенныйФайл", ПрисоединенныйФайл);
			ОткрытьФорму("ОбщаяФорма.ПрисоединенныйФайл", ПараметрыФормы, , ПрисоединенныйФайл);
		КонецЕсли;
#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

// Сохраняет файл вместе вместе с ЭЦП.
// Используется в обработчике команды сохранения файла.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка на присоединенный файл.
//  ДанныеФайла        - Структура - данные файла.
//  ИдентификаторФормы - УникальныйИдентификатор формы.
//
Процедура СохранитьВместеСЭЦП(Знач ПрисоединенныйФайл, Знач ДанныеФайла, Знач ИдентификаторФормы) Экспорт
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		
		ПолноеИмяФайла = СохранитьФайлКак(ДанныеФайла);
		
		Если ПолноеИмяФайла = "" Тогда
			Возврат; // Пользователь нажал Отмена или это веб клиент без расширения.
		КонецЕсли;
		
		Настройка = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьПерсональныеНастройкиРаботыСЭЦП().ДействияПриСохраненииСЭЦП;
		
		Если Настройка = "Спрашивать" Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Объект",                  ПрисоединенныйФайл);
			ПараметрыФормы.Вставить("УникальныйИдентификатор", ИдентификаторФормы);
			
			МассивСтруктурПодписей = ОткрытьФормуМодально("ОбщаяФорма.ВыборПодписей", ПараметрыФормы);
			
		ИначеЕсли Настройка = "СохранятьВсеПодписи" Тогда
			МассивСтруктурПодписей = ПрисоединенныеФайлыСлужебныйВызовСервера.ПолучитьВсеПодписи(ПрисоединенныйФайл, ИдентификаторФормы);
		КонецЕсли;
		
		Если ТипЗнч(МассивСтруктурПодписей) = Тип("Массив") И МассивСтруктурПодписей.Количество() > 0 Тогда
			ЭлектроннаяЦифроваяПодписьКлиент.СохранитьПодписи(
				ПрисоединенныйФайл,
				ПолноеИмяФайла,
				ИдентификаторФормы,
				МассивСтруктурПодписей);
		КонецЕсли;
		
	Иначе
#Если ВебКлиент Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСФайлами();
#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

// Помещает данные файла с сервера в рабочий каталог на диске.
//
// ОСОБЫЕ УСЛОВИЯ.
// Требуется наличие подключенного расширения для работы с файлами.
//
// Параметры:
//  АдресДвоичныхДанныхФайла     - Строка - адрес во временном хранилище с двоичными данными,
//                                 либо навигационная ссылка на данные файла в ИБ.
//  ОтносительныйПуть            - Строка - путь к файлу относительно рабочего каталога.
//  ДатаМодификацииУниверсальная - Дата - универсальная дата модификации файла.
//  ИмяФайла                     - Строка - имя файла (с расширением).
//  РабочийКаталогПользователя   - Строка - путь к рабочему каталогу.
//  ПолноеИмяФайлаНаКлиенте      - Строка (возвращаемое значение) - устанавливается при успешном выполнении.
//
// Возвращаемое значение: булево
//  Истина - файл получен и сохранен успешно, иначе Ложь.
//
Функция ПолучитьФайлВРабочийКаталог(Знач АдресДвоичныхДанныхФайла,
                                    Знач ОтносительныйПуть,
                                    Знач ДатаМодификацииУниверсальная,
                                    Знач ИмяФайла,
                                    Знач РабочийКаталогПользователя = "",
                                    ПолноеИмяФайлаНаКлиенте) Экспорт
	
	Если РабочийКаталогПользователя = Неопределено
	 ИЛИ ПустаяСтрока(РабочийКаталогПользователя) Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	КаталогСохранения = РабочийКаталогПользователя + ОтносительныйПуть;
	
	Попытка
		СоздатьКаталог(КаталогСохранения);
	Исключение
		СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		СообщениеОбОшибке = НСтр("ru = 'Ошибка создания каталога на диске:'") + " " + СообщениеОбОшибке;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
		Возврат Ложь;
	КонецПопытки;
	
	Файл = Новый Файл(КаталогСохранения + ИмяФайла);
	Если Файл.Существует() Тогда
		Файл.УстановитьТолькоЧтение(Ложь);
		УдалитьФайлы(КаталогСохранения + ИмяФайла);
	КонецЕсли;
	
	ПолучаемыйФайл = Новый ОписаниеПередаваемогоФайла(КаталогСохранения + ИмяФайла, АдресДвоичныхДанныхФайла);
	ПолучаемыеФайлы = Новый Массив;
	ПолучаемыеФайлы.Добавить(ПолучаемыйФайл);
	
	ПолученныеФайлы = Новый Массив;
	
	Если ПолучитьФайлы(ПолучаемыеФайлы, ПолученныеФайлы, , Ложь) Тогда
		ПолноеИмяФайлаНаКлиенте = ПолученныеФайлы[0].Имя;
		Файл = Новый Файл(ПолноеИмяФайлаНаКлиенте);
		Файл.УстановитьУниверсальноеВремяИзменения(ДатаМодификацииУниверсальная);
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Помещает файл с диска клиента во временное хранилище.
//
// Параметры:
//  ПутьКФайлу         - Строка - полный путь к файлу.
//  ИдентификаторФормы - УникальныйИдентификатор формы.
//
// Возвращаемое значение:
//  Структура.
//
Функция ПоместитьФайлВХранилище(Знач ПутьКФайлу, Знач ИдентификаторФормы) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ФайлПомещенВХранилище", Ложь);
	
	Файл = Новый Файл(ПутьКФайлу);
	ФайловыеФункцииСлужебныйКлиентСервер.ПроверитьВозможностьЗагрузкиФайла(Файл);
	
	АдресВременногоХранилищаТекста = "";
	Если Не ФайловыеФункцииСлужебныйКлиентСервер.ОбщиеНастройкиРаботыСФайлами().ИзвлекатьТекстыФайловНаСервере Тогда
		АдресВременногоХранилищаТекста = ФайловыеФункцииСлужебныйКлиентСервер.ИзвлечьТекстВоВременноеХранилище(ПутьКФайлу, ИдентификаторФормы);
	КонецЕсли;
	
	ПомещаемыеФайлы = Новый Массив;
	ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ПутьКФайлу));
	ПомещенныеФайлы = Новый Массив;
	
	Если НЕ ПоместитьФайлы(ПомещаемыеФайлы, ПомещенныеФайлы, , Ложь, ИдентификаторФормы) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при помещении файла
				           |""%1""
				           |во временное хранилище.'"),
				ПутьКФайлу) );
		Возврат Результат;
	КонецЕсли;
	
	Результат.Вставить("ФайлПомещенВХранилище", Истина);
	Результат.Вставить("ДатаМодификацииУниверсальная",   Файл.ПолучитьУниверсальноеВремяИзменения());
	Результат.Вставить("АдресФайлаВоВременномХранилище", ПомещенныеФайлы[0].Хранение);
	Результат.Вставить("АдресВременногоХранилищаТекста", АдресВременногоХранилищаТекста);
	Результат.Вставить("Расширение",                     Прав(Файл.Расширение, СтрДлина(Файл.Расширение)-1));
	
	Возврат Результат;
	
КонецФункции

// Сохраняет файл в каталог на диске.
// Так же используется, как вспомогательная функция при сохранении файла с ЭЦП.
//
// Параметры:
//  ДанныеФайла  - Структура - данные файла.
//
// Возвращаемое значение:
//  Строка - имя сохраненного файла.
//
Функция СохранитьФайлКак(Знач ДанныеФайла) Экспорт
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		ВыборФайла.МножественныйВыбор = Ложь;
		ВыборФайла.ПолноеИмяФайла = ДанныеФайла.ИмяФайла;
		ВыборФайла.Расширение = ДанныеФайла.Расширение;
		ВыборФайла.Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Все файлы (*.%1)|*.%1'"), ДанныеФайла.Расширение);
		
		Если НЕ ВыборФайла.Выбрать() Тогда
			Возврат "";
		КонецЕсли;
		
		РазмерВМб = ДанныеФайла.Размер / (1024 * 1024);
		
		ТекстПояснения =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сохраняется файл ""%1"" (%2 Мб)
				           |Пожалуйста, подождите...'"),
				ДанныеФайла.ИмяФайла, 
				ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьСтрокуСРазмеромФайла(РазмерВМб) );
		
		Состояние(ТекстПояснения);
		
		ПолучаемыйФайл = Новый ОписаниеПередаваемогоФайла(ВыборФайла.ПолноеИмяФайла, ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
		ПолучаемыеФайлы = Новый Массив;
		ПолучаемыеФайлы.Добавить(ПолучаемыйФайл);
		
		ПолученныеФайлы = Новый Массив;
		
		Если ПолучитьФайлы(ПолучаемыеФайлы, ПолученныеФайлы, , Ложь) Тогда
			Состояние(НСтр("ru = 'Файл успешно сохранен.'"), , ВыборФайла.ПолноеИмяФайла);
		КонецЕсли;
		
		Возврат ВыборФайла.ПолноеИмяФайла;
	Иначе
#Если ВебКлиент Тогда
		ПолучитьФайл(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла, ДанныеФайла.ИмяФайла, Истина);
		Возврат ДанныеФайла.ИмяФайла;
#КонецЕсли
	КонецЕсли;
	
КонецФункции

// Открывает общую форму присоединенного файла из формы элемента
// справочника присоединенных файлов. Форма элемента закрывается.
// 
// Параметры:
//  Форма     - форма справочника присоединенных файлов.
//
Процедура ПерейтиКФормеПрисоединенногоФайла(Знач Форма) Экспорт
	
	ПрисоединенныйФайл = Форма.Ключ;
	
	Форма.Закрыть();
	
	Для Каждого ОкноКП Из ПолучитьОкна() Цикл
		
		Содержимое = ОкноКП.ПолучитьСодержимое();
		
		Если Содержимое = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Содержимое.ИмяФормы = "ОбщаяФорма.ПрисоединенныйФайл" Тогда
			Если Содержимое.Параметры.Свойство("ПрисоединенныйФайл")
			   И Содержимое.Параметры.ПрисоединенныйФайл = ПрисоединенныйФайл Тогда
				ОкноКП.Активизировать();
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ОткрытьФормуПрисоединенногоФайла(ПрисоединенныйФайл);
	
КонецПроцедуры

// Открывает форму выбора файлов.
// Используется в обработчике выбора для переопределения стандартного поведения.
//
// Параметры:
//  ВладелецФайлов       - Ссылка на объект с файлами.
//  ЭлементФормы         - элемент формы, которому будет отправлено оповещение о выборе.
//  СтандартнаяОбработка - Булево (возвращаемое значение), всегда устанавливается в Ложь.
//
Процедура ОткрытьФормуВыбораФайлов(Знач ВладелецФайлов, Знач ЭлементФормы, СтандартнаяОбработка = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла",      ВладелецФайлов);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	
	ОткрытьФорму("ОбщаяФорма.ВыборПрисоединенныхФайлов", ПараметрыФормы, ЭлементФормы);
	
КонецПроцедуры

// Открывает форму присоединенного файла.
// Может использоваться как обработчик открытия присоединенного файла.
//
// Параметры:
//  ПрисоединенныйФайл   - Ссылка на файл, карточку которого нужно открыть.
//  СтандартнаяОбработка - Булево (возвращаемое значение), всегда устанавливается в Ложь.
//
Процедура ОткрытьФормуПрисоединенногоФайла(Знач ПрисоединенныйФайл, СтандартнаяОбработка = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПрисоединенныйФайл", ПрисоединенныйФайл);
		
		ОткрытьФорму("ОбщаяФорма.ПрисоединенныйФайл", ПараметрыФормы, , ПрисоединенныйФайл);
	КонецЕсли;
	
КонецПроцедуры

// См. эту функцию в модуле ПрисоединенныеФайлы.
Функция ПолучитьДанныеФайла(Знач ПрисоединенныйФайл,
                            Знач ИдентификаторФормы = Неопределено,
                            Знач ПолучатьСсылкуНаДвоичныеДанные = Истина) Экспорт
	
	Возврат ПрисоединенныеФайлыСлужебныйВызовСервера.ПолучитьДанныеФайла(
		ПрисоединенныйФайл, ИдентификаторФормы, ПолучатьСсылкуНаДвоичныеДанные);
	
КонецФункции

// Обновляет данные файла из файла, выбранного пользователем.
// Используется, как обработчик команды обновления присоединенного файла из другого файла.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка на файл.
//  ДанныеФайла        - Структура - данные файла.
//  ИдентификаторФормы - УникальныйИдентификатор формы.
//
// Возвращаемое значение:
//  Булево - Истина, если файл успешно обновлен в хранилище.
//           Ложь, если файл не обновлен в хранилище.
//
Функция ОбновитьПрисоединенныйФайл(Знач ПрисоединенныйФайл, Знач ДанныеФайла, Знач ИдентификаторФормы) Экспорт
	
	ИнформацияОФайле = Новый Структура;
	
	Если ПрисоединенныеФайлыСлужебныйКлиент.ВыбратьФайлНаДискеИПоместитьВХранилище(
	       ДанныеФайла, ИнформацияОФайле, ИдентификаторФормы) Тогда
		
		ПрисоединенныеФайлыСлужебныйВызовСервера.ОбновитьПрисоединенныйФайл(ПрисоединенныйФайл, ИнформацияОФайле);
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ДиалогНужноПолучитьФайлССервера(Знач ИмяФайлаСПутем, Знач ДанныеФайла, Знач ФайлРедактируется, Отказ = Ложь)
	
	СтандартныеДанныеФайла = Новый Структура;
	СтандартныеДанныеФайла.Вставить("ДатаМодификацииУниверсальная", ДанныеФайла.ДатаМодификацииУниверсальная);
	СтандартныеДанныеФайла.Вставить("Размер",                       ДанныеФайла.Размер);
	СтандартныеДанныеФайла.Вставить("ВРабочемКаталогеНаЧтение",     ФайлРедактируется);
	
	// Выяснено, что Файл в рабочем каталоге есть.
	// Проверка даты изменения и принятие решения, что делать дальше.
	Действие = ФайловыеФункцииСлужебныйКлиент.ДействиеПриОткрытииФайлаВРабочемКаталоге(
		ИмяФайлаСПутем, СтандартныеДанныеФайла);
	
	Если Действие = "ВзятьИзХранилищаИОткрыть" Тогда
		УдалитьФайл(ИмяФайлаСПутем);
		Возврат Истина;
		
	ИначеЕсли Действие = "ОткрытьСуществующий" Тогда
		Возврат Ложь;
		
	Иначе // Действие = "Отмена".
		Отказ = Истина;
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Процедура ОткрытьФайлПриложением(Знач ИмяОткрываемогоФайла, ДанныеФайла)
	
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	
	Если РасширениеПодключено Тогда
		
		ЗаголовокСтрока = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
			ДанныеФайла.Наименование, ДанныеФайла.Расширение);
		
		Если НРег(ДанныеФайла.Расширение) = НРег("grs") Тогда
			
			Схема = Новый ГрафическаяСхема; 
			Схема.Прочитать(ИмяОткрываемогоФайла);
			
			Схема.Показать(ЗаголовокСтрока, ИмяОткрываемогоФайла);
			Возврат;
			
		КонецЕсли;
		
		Если НРег(ДанныеФайла.Расширение) = НРег("mxl") Тогда
			
			ДвоичныеДанные = Новый ДвоичныеДанные(ИмяОткрываемогоФайла);
			Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
			ТабличныйДокумент = ФайловыеФункцииСлужебныйВызовСервера.ТабличныйДокументИзВременногоХранилища(Адрес);
			
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("ИмяДокумента", ЗаголовокСтрока);
			ПараметрыОткрытия.Вставить("ПутьКФайлу", ИмяОткрываемогоФайла);
			ПараметрыОткрытия.Вставить("ТабличныйДокумент", ТабличныйДокумент);
			
			ОткрытьФорму("ОбщаяФорма.РедактированиеТабличногоДокумента", ПараметрыОткрытия);
			
			Возврат;
			
		КонецЕсли;
		
		// Открытие Файла.
		Попытка
			
			ЗапуститьПриложение(ИмяОткрываемогоФайла);
			
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			
			Предупреждение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При открытии файла
				           |""%1""
				           |произошла ошибка:
				           |""%2"".'"),
				ИмяОткрываемогоФайла,
				ИнформацияОбОшибке.Описание));
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьФайл(Знач ПолноеИмяФайла)
	
	Файл = Новый Файл(ПолноеИмяФайла);
	Файл.УстановитьТолькоЧтение(Ложь);
	УдалитьФайлы(ПолноеИмяФайла);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Устаревшие процедуры и функции

// Устарела. Следует использовать ПоместитьФайлВХранилище.
//
// Помещает файл с диска клиента во временное хранилище.
//
// Параметры:
//  ДанныеФайла             - (не используется).
//  ИнформацияОФайле        - Структура - (возвращаемое значение).
//  ПолноеИмяФайлаНаКлиенте - Строка - имя файла на диске клиента.
//  ИдентификаторФормы      - УникальныйИдентификатор формы.
//
// Возвращаемое значение:
//  Булево - Истина - файл успешно помещен в хранилище, иначе Ложь.
//
Функция ПоместитьФайлНаДискеВХранилище(Знач ДанныеФайла, ИнформацияОФайле, Знач ПолноеИмяФайлаНаКлиенте, Знач ИдентификаторФормы) Экспорт
	ИнформацияОФайле = ПоместитьФайлВХранилище(ПолноеИмяФайлаНаКлиенте, ИдентификаторФормы);
	Возврат ИнформацияОФайле.ФайлПомещенВХранилище;
КонецФункции

