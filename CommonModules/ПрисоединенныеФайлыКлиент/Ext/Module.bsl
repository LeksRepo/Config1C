﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Присоединенные файлы".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

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
	
	Параметры = Новый Структура;
	Параметры.Вставить("ДанныеФайла", ДанныеФайла);
	Параметры.Вставить("ДляРедактирования", ДляРедактирования);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлРасширениеПредложено", ПрисоединенныеФайлыСлужебныйКлиент, Параметры);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
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
	
	Параметры = Новый Структура;
	Параметры.Вставить("ВладелецФайла", ВладелецФайла);
	Параметры.Вставить("ИдентификаторФормы", ИдентификаторФормы);
	Параметры.Вставить("Фильтр", Фильтр);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлыРасширениеПредложено", ПрисоединенныеФайлыСлужебныйКлиент, Параметры);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

// Подписывает присоединенный файл.
//
// Параметры:
//  ПрисоединенныйФайл      - Ссылка на присоединенный файл.
//  ИдентификаторФормы      - УникальныйИдентификатор - идентификатор управляемой формы.
//  ДополнительныеПараметры - Неопределено - стандартное поведение (см. ниже).
//                          - Структура - со свойствами:
//   * ДанныеФайла            - Структура - данные файла, если свойства нет, будет вставлено.
//   * ОповещениеПользователя - Структура - параметры оповещения пользователя об успехе:
//                              Текст, НавигационнаяСсылка, Пояснение, Картинка,
//                            - Неопределено - использовать стандартное оповещение,
//                              если свойства нет, не выводить оповещение,
//                              если ДополнительныеПараметры не указаны, значит значение Неопределено.
//   * ОбработкаРезультата    - ОписаниеОповещения - при вызове передается значение типа Булево,
//                              если Истина - файл успешно подписан, иначе не подписан,
//                              если свойства нет, оповещение не будет вызвано.
//
Процедура ПодписатьФайл(ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбран файл, который нужно подписать.'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЭлектроннаяПодписьКлиент.ИспользоватьЭлектронныеПодписи() Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Чтобы добавить электронную подпись, включите
			           |в настройках программы использование электронных подписей.'"));
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОповещениеПользователя");
	КонецЕсли;
	
	Если Не ДополнительныеПараметры.Свойство("ДанныеФайла") Тогда
		ДополнительныеПараметры.Вставить("ДанныеФайла", ПолучитьДанныеФайла(
			ПрисоединенныйФайл, ИдентификаторФормы));
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		ПараметрыВыполнения = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ДополнительныеПараметры);
	#Иначе
		ПараметрыВыполнения = Новый Структура(Новый ФиксированнаяСтруктура(ДополнительныеПараметры));
	#КонецЕсли
	ПараметрыВыполнения.Вставить("ПрисоединенныйФайл", ПрисоединенныйФайл);
	ПрисоединенныеФайлыСлужебныйКлиент.СформироватьПодписьФайла(ПараметрыВыполнения);
	
КонецПроцедуры

// Сохраняет файл вместе вместе с ЭП.
// Используется в обработчике команды сохранения файла.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка на присоединенный файл.
//  ДанныеФайла        - Структура - данные файла.
//  ИдентификаторФормы - УникальныйИдентификатор формы.
//
Процедура СохранитьВместеСЭП(Знач ПрисоединенныйФайл, Знач ДанныеФайла, Знач ИдентификаторФормы) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ПрисоединенныйФайл", ПрисоединенныйФайл);
	Параметры.Вставить("ДанныеФайла", ДанныеФайла);
	Параметры.Вставить("ИдентификаторФормы", ИдентификаторФормы);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьВместеСЭПРасширениеПредложено", ПрисоединенныеФайлыСлужебныйКлиент, Параметры);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
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
// Так же используется, как вспомогательная функция при сохранении файла с ЭП.
//
// Параметры:
//  ДанныеФайла  - Структура - данные файла.
//
// Возвращаемое значение:
//  Строка - имя сохраненного файла.
//
Процедура СохранитьФайлКак(Знач ДанныеФайла) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ДанныеФайла", ДанныеФайла);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьФайлКакРасширениеПредложено", ПрисоединенныеФайлыСлужебныйКлиент, Параметры);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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

#КонецОбласти
