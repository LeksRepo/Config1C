﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//
////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// Печать с использованием макетов в формате MS Word
//
// Описание структур данных:
//
// Handler - структура используемая для связи с COM объектами
//  - COMСоединение - COMОбъект
//  - Тип - строка - либо "DOC" либо "odt"
//  - ИмяФайла - строка - имя файла шаблона (заполняется только для шаблона)
//  - ТипПоследнегоВывода - тип последней выводимой области 
//  - (см. ТипОбласти)
//
// Область в документе
//  - COMСоединение - COMОбъект
//  - Тип - строка - либо "DOC" либо "odt"
//  - Start - позиция начала области
//  - End - позиция окончания области
//

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ    

// Создает COM соединение с COM объектом Word.Application, создает в нем
// единственный документ.
//
Функция ИнициализироватьПечатнуюФормуMSWord(Макет) Экспорт
	
	Handler = Новый Структура("Тип", "DOC");
	
	Попытка
		COMОбъект = Новый COMОбъект("Word.Application");
	Исключение
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),,Истина);
		НеУдалосьСформироватьПечатнуюФорму(ИнформацияОбОшибке());
	КонецПопытки;
	
	Handler.Вставить("COMСоединение", COMОбъект);
	Попытка
		COMОбъект.Documents.Add();
	Исключение
		COMОбъект.Quit(0);
		COMОбъект = 0;
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),,Истина);
		НеУдалосьСформироватьПечатнуюФорму(ИнформацияОбОшибке());
	КонецПопытки;
	

	НастройкиСтраницыМакета = Макет; // для обратной совместимости (изменен тип входного параметра функции)
	Если ТипЗнч(Макет) = Тип("Структура") Тогда
		НастройкиСтраницыМакета = Макет.НастройкиСтраницыМакета;
		// копирование стилей из макета
		Макет.COMСоединение.ActiveDocument.Close();
		Handler.COMСоединение.ActiveDocument.CopyStylesFromTemplate(Макет.ИмяФайла);
		Макет.COMСоединение.Documents.Open(Макет.ИмяФайла);
	КонецЕсли;
	
	// копирование настроек страницы
	Если НастройкиСтраницыМакета <> Неопределено Тогда
		Для Каждого Настройка Из НастройкиСтраницыМакета Цикл
			Попытка
				COMОбъект.ActiveDocument.PageSetup[Настройка.Ключ] = Настройка.Значение;
			Исключение
				// Пропустить, если настройка не поддерживается данной версией программы.
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	// запомнить вид просмотра документа
	Handler.Вставить("ViewType", COMОбъект.Application.ActiveWindow.View.Type);	
	
	Возврат Handler;
	
КонецФункции

// Создает COM соединение с COM объектом Word.Application и открывает
// в нем макет. Файл макета сохраняется на основе двоичных данных
// переданных в параметрах функции.
//
// Параметры:
// ДвоичныеДанныеМакета - ДвоичныеДанные - двоичные данные макета
// Возвращаемое значение:
// структура - ссылка макет
//
Функция ПолучитьМакетMSWord(Знач ДвоичныеДанныеМакета, Знач ИмяВременногоФайла = "") Экспорт
	
	Handler = Новый Структура("Тип", "DOC");
	Попытка
		COMОбъект = Новый COMОбъект("Word.Application");
	Исключение
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),,Истина);
		НеУдалосьСформироватьПечатнуюФорму(ИнформацияОбОшибке());
	КонецПопытки;
	
#Если НЕ ВебКлиент Тогда
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("DOC");
	ДвоичныеДанныеМакета.Записать(ИмяВременногоФайла);
#КонецЕсли
	
	Попытка
		COMОбъект.Documents.Open(ИмяВременногоФайла);
	Исключение
		COMОбъект.Quit(0);
		COMОбъект = 0;
		УдалитьФайлы(ИмяВременногоФайла);
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),,Истина);
		ВызватьИсключение(НСтр("ru = 'Ошибка при открытии файла шаблона.'") + Символы.ПС 
			+ КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Handler.Вставить("COMСоединение", COMОбъект);
	Handler.Вставить("ИмяФайла", ИмяВременногоФайла);
	Handler.Вставить("ЭтоМакет", Истина);
	
	Handler.Вставить("НастройкиСтраницыМакета", Новый Соответствие);
	
	Для Каждого ИмяНастройки Из НастройкиПараметровСтраницы() Цикл
		Попытка
			Handler.НастройкиСтраницыМакета.Вставить(ИмяНастройки, COMОбъект.ActiveDocument.PageSetup[ИмяНастройки]);
		Исключение
			// Пропустить, если настройка не поддерживается данной версией программы.
		КонецПопытки;
	КонецЦикла;
	
	Возврат Handler;
	
КонецФункции

// Закрывает соединение с COM объектом Word.Application
// Параметры:
// Handler - ссылка на печатную форму или макет
// ЗакрытьПриложение - булево - требуется ли закрыть приложение
//
Процедура ЗакрытьСоединение(Handler, Знач ЗакрытьПриложение) Экспорт
	
	Если ЗакрытьПриложение Тогда
		Handler.COMСоединение.Quit(0);
	КонецЕсли;
	
	Handler.COMСоединение = 0;
	
	#Если Не ВебКлиент Тогда
	Если Handler.Свойство("ИмяФайла") Тогда
		УдалитьФайлы(Handler.ИмяФайла);
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

// Устанавливает свойство видимости у приложения MS Word
// Handler - ссылка на печатную форму
//
Процедура ПоказатьДокументMSWord(Знач Handler) Экспорт
	
	COMСоединение = Handler.COMСоединение;
	COMСоединение.Application.Selection.Collapse();
	
	// восстановить вид просмотра документа
	COMСоединение.Application.ActiveWindow.View.Type = Handler.ViewType;
	
	COMСоединение.Application.Visible = Истина;
	COMСоединение.Activate();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции для получения областей из макета

// Получает область из макета.
//
// Параметры:
//  Handler - ссылка на макет
//  ИмяОбласти - имя области в макете
//  СмещениеНачало    - Число - переопределяет границу начала области для случаев, когда область начинается не сразу за
//                              операторной скобкой, а через один или несколько символов.
//                              Значение по умолчанию: 1 - ожидается, что за операторной скобкой открытия области 
//                                                         следует символ перевода строки, который не нужно включать в
//                                                         получаемую область.
//  СмещениеОкончание - Число - переопределяет границу окончания области для случаев, когда область заканчивается не
//                              перед операторной скобкой, а на один или несколько символов раньше. Значение должно 
//                              быть отрицательным.
//                              Значение по умолчанию:-1 - ожидается, что перед операторной скобкой закрытия области
//                                                         есть символ перевода строки, который не нужно включать в
//                                                         получаемую область.
//
Функция ПолучитьОбластьМакетаMSWord(Знач Handler,
									Знач ИмяОбласти,
									Знач СмещениеНачало = 1,
									Знач СмещениеОкончание = -1) Экспорт
	
	Результат = Новый Структура("Document,Start,End");
	
	ПозицияНачало = СмещениеНачало + ПолучитьПозициюНачалаОбласти(Handler.COMСоединение, ИмяОбласти);
	ПозицияОкончание = СмещениеОкончание + ПолучитьПозициюОкончанияОбласти(Handler.COMСоединение, ИмяОбласти);
	
	Если ПозицияНачало >= ПозицияОкончание Или ПозицияНачало < 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат.Document = Handler.COMСоединение.ActiveDocument;
	Результат.Start = ПозицияНачало;
	Результат.End   = ПозицияОкончание;
	
	Возврат Результат;
	
КонецФункции

// Получает область верхнего колонтитула первой области макета
// Параметры
// Handler - ссылка на макет
// Возвращаемое значение
// ссылка на верхний колонтитул
//
Функция ПолучитьОбластьВерхнегоКолонтитула(Знач Handler) Экспорт
	
	Возврат Новый Структура("Header", Handler.COMСоединение.ActiveDocument.Sections(1).Headers.Item(1));
	
КонецФункции

// Получает область нижнего колонтитула первой области макета
// Параметры
// Handler - ссылка на макет
// Возвращаемое значение
// ссылка на нижний колонтитул
//
Функция ПолучитьОбластьНижнегоКолонтитула(Handler) Экспорт
	
	Возврат Новый Структура("Footer", Handler.COMСоединение.ActiveDocument.Sections(1).Footers.Item(1));
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции для добавления областей к печатной форме

// начало: функции работы с колонтитулами документа MS Word

// Добавляет нижний колонтитул в печатную форму из макета.
// Параметры
// ПечатнаяФорма - ссылка на печатную форму
// ОбластьHandler - ссылка на область в макете
// Параметры - список параметров для замены на значения
// ДанныеОбъекта - данные объекта для заполнения
//
Процедура ДобавитьНижнийКолонтитул(Знач ПечатнаяФорма, Знач ОбластьHandler) Экспорт
	
	ОбластьHandler.Footer.Range.Copy();
	НижнийКолонтитул(ПечатнаяФорма).Paste();
	
КонецПроцедуры

// Добавляет верхний колонтитул в печатную форму из макета.
// Параметры
// ПечатнаяФорма - ссылка на печатную форму
// ОбластьHandler - ссылка на область в макете
// Параметры - список параметров для замены на значения
// ДанныеОбъекта - данные объекта для заполнения
//
Процедура ЗаполнитьПараметрыНижнегоКолонтитула(Знач ПечатнаяФорма, Знач ДанныеОбъекта = Неопределено) Экспорт
	
	Если ДанныеОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ПараметрЗначение Из ДанныеОбъекта Цикл
		Если ТипЗнч(ПараметрЗначение.Значение) <> Тип("Массив") Тогда
			Заменить(НижнийКолонтитул(ПечатнаяФорма), ПараметрЗначение.Ключ, ПараметрЗначение.Значение);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция НижнийКолонтитул(ПечатнаяФорма)
	Возврат ПечатнаяФорма.COMСоединение.ActiveDocument.Sections(1).Footers.Item(1).Range;
КонецФункции

// Добавляет верхний колонтитул в печатную форму из макета.
// Параметры
// ПечатнаяФорма - ссылка на печатную форму
// ОбластьHandler - ссылка на область в макете
// Параметры - список параметров для замены на значения
// ДанныеОбъекта - данные объекта для заполнения
//
Процедура ДобавитьВерхнийКолонтитул(Знач ПечатнаяФорма, Знач ОбластьHandler) Экспорт
	
	ОбластьHandler.Header.Range.Copy();
	ВерхнийКолонтитул(ПечатнаяФорма).Paste();
	
КонецПроцедуры

// Добавляет верхний колонтитул в печатную форму из макета.
// Параметры
// ПечатнаяФорма - ссылка на печатную форму
// ОбластьHandler - ссылка на область в макете
// Параметры - список параметров для замены на значения
// ДанныеОбъекта - данные объекта для заполнения
//
Процедура ЗаполнитьПараметрыВерхнегоКолонтитула(Знач ПечатнаяФорма, Знач ДанныеОбъекта = Неопределено) Экспорт
	
	Если ДанныеОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ПараметрЗначение Из ДанныеОбъекта Цикл
		Если ТипЗнч(ПараметрЗначение.Значение) <> Тип("Массив") Тогда
			Заменить(ВерхнийКолонтитул(ПечатнаяФорма), ПараметрЗначение.Ключ, ПараметрЗначение.Значение);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ВерхнийКолонтитул(ПечатнаяФорма)
	Возврат ПечатнаяФорма.COMСоединение.ActiveDocument.Sections(1).Headers.Item(1).Range;
КонецФункции

// конец: функции работы с колонтитулами документа MS Word

// Добавляет область в печатную форму из макета, при этом заменяя
// параметры в области значениями из данных объекта.
// Применяется при одиночном выводе области.
//
// Параметры
// ПечатнаяФорма - ссылка на печатную форму
// ОбластьHandler - ссылка на область в макете.
// ПереходНаСледСтроку - булево, требуется ли вставлять разрыв после вывода области
//
// Возвращаемое значение:
// КоординатыОбласти
//
Функция ПрисоединитьОбласть(Знач ПечатнаяФорма,
							Знач ОбластьHandler,
							Знач ПереходНаСледСтроку = Истина,
							Знач ПрисоединитьСтрокуТаблицы = Ложь) Экспорт
	
	ОбластьHandler.Document.Range(ОбластьHandler.Start, ОбластьHandler.End).Copy();
	
	ПФ_ActiveDocument = ПечатнаяФорма.COMСоединение.ActiveDocument;
	ПозицияОкончанияДокумента	= ПФ_ActiveDocument.Range().End;
	ОбластьВставки				= ПФ_ActiveDocument.Range(ПозицияОкончанияДокумента-1, ПозицияОкончанияДокумента-1);
	
	Если ПрисоединитьСтрокуТаблицы Тогда
		ОбластьВставки.PasteAppendTable();
	Иначе
		ОбластьВставки.Paste();
	КонецЕсли;
	
	// возвращаем границы вставленной области
	Результат = Новый Структура("Document, Start, End",
							ПФ_ActiveDocument,
							ПозицияОкончанияДокумента-1,
							ПФ_ActiveDocument.Range().End-1);
	
	Если ПереходНаСледСтроку Тогда
		ВставитьРазрывНаНовуюСтроку(ПечатнаяФорма);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Добавляет область списка в печатную форму из макета, при этом заменяя
// параметры в области значениями из данных объекта.
// Применяется при выводе данных списка (маркированного или нумерованного)
//
// Параметры
// ОбластьПечатнойФормы - ссылка на область в печатной форме
// ДанныеОбъекта - ДанныеОбъекта
//
Процедура ЗаполнитьПараметры(Знач ОбластьПечатнойФормы, Знач ДанныеОбъекта = Неопределено) Экспорт
	
	Если ДанныеОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ПараметрЗначение Из ДанныеОбъекта Цикл
		Если ТипЗнч(ПараметрЗначение.Значение) <> Тип("Массив") Тогда
			Заменить(ОбластьПечатнойФормы.Document.Content, ПараметрЗначение.Ключ, ПараметрЗначение.Значение);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// начало: работа с коллекциями

// Добавляет область списка в печатную форму из макета, при этом заменяя
// параметры в области значениями из данных объекта.
// Применяется при выводе данных списка (маркированного или нумерованного)
//
// Параметры
// ПечатнаяФорма - ссылка на печатную форму
// ОбластьHandler - ссылка на область в макете.
// Параметры - строка, перечень параметров, которые требуется заменить
// ДанныеОбъекта - ДанныеОбъекта
// ПереходНаСледСтроку - булево, требуется ли вставлять разрыв после вывода области
//
Процедура ПрисоединитьИЗаполнитьНабор(Знач ПечатнаяФорма,
									  Знач ОбластьHandler,
									  Знач ДанныеОбъекта = Неопределено,
									  Знач ПереходНаСледСтроку = Истина) Экспорт
	
	ОбластьHandler.Document.Range(ОбластьHandler.Start, ОбластьHandler.End).Copy();
	
	ActiveDocument = ПечатнаяФорма.COMСоединение.ActiveDocument;
	
	Если ДанныеОбъекта <> Неопределено Тогда
		Для Каждого ДанныеСтроки Из ДанныеОбъекта Цикл
			ПозицияВставки = ActiveDocument.Range().End;
			ОбластьВставки = ActiveDocument.Range(ПозицияВставки-1, ПозицияВставки-1);
			ОбластьВставки.Paste();
			
			Если ТипЗнч(ДанныеСтроки) = Тип("Структура") Тогда
				Для Каждого ПараметрЗначение Из ДанныеСтроки Цикл
					Заменить(ActiveDocument.Content, ПараметрЗначение.Ключ, ПараметрЗначение.Значение);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ПереходНаСледСтроку Тогда
		ВставитьРазрывНаНовуюСтроку(ПечатнаяФорма);
	КонецЕсли;
	
КонецПроцедуры

// Добавляет область списка в печатную форму из макета, при этом заменяя
// параметры в области значениями из данных объекта.
// Применяется при выводе строки таблицы.
//
// Параметры
// ПечатнаяФорма - ссылка на печатную форму
// ОбластьHandler - ссылка на область в макете.
// ИмяТаблицы - наименование таблицы (для доступа к данным)
// ДанныеОбъекта - ДанныеОбъекта
// ПереходНаСледСтроку - булево, требуется ли вставлять разрыв после вывода области
//
Процедура ПрисоединитьИЗаполнитьОбластьТаблицы(Знач ПечатнаяФорма,
												Знач ОбластьHandler,
												Знач ДанныеОбъекта = Неопределено,
												Знач ПереходНаСледСтроку = Истина) Экспорт
	
	Если ДанныеОбъекта = Неопределено Или ДанныеОбъекта.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПерваяСтрока = Истина;
	
	ОбластьHandler.Document.Range(ОбластьHandler.Start, ОбластьHandler.End).Copy();
	
	ActiveDocument = ПечатнаяФорма.COMСоединение.ActiveDocument;
	
	// вставляем первый строку, по которому далее будет выполняться
	// вставка новых строк с форматированием по первой
	ВставитьРазрывНаНовуюСтроку(ПечатнаяФорма); 
	ПозицияВставки = ActiveDocument.Range().End;
	ОбластьВставки = ActiveDocument.Range(ПозицияВставки-1, ПозицияВставки-1);
	ОбластьВставки.Paste();
	ActiveDocument.Range(ПозицияВставки-2, ПозицияВставки-2).Delete();
	
	Если ТипЗнч(ДанныеОбъекта[0]) = Тип("Структура") Тогда
		Для Каждого ПараметрЗначение Из ДанныеОбъекта[0] Цикл
			Заменить(ActiveDocument.Content, ПараметрЗначение.Ключ, ПараметрЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого ДанныеСтрокиТаблицы Из ДанныеОбъекта Цикл
		Если ПерваяСтрока Тогда
			ПерваяСтрока = Ложь;
			Продолжить;
		КонецЕсли;
		
		НоваяПозицияВставки = ActiveDocument.Range().End;
		ActiveDocument.Range(ПозицияВставки-1, ActiveDocument.Range().End-1).Select();
		ПечатнаяФорма.COMСоединение.Selection.InsertRowsBelow();
		
		ActiveDocument.Range(НоваяПозицияВставки-1, ActiveDocument.Range().End-2).Select();
		ПечатнаяФорма.COMСоединение.Selection.Paste();
		ПозицияВставки = НоваяПозицияВставки;
		
		Если ТипЗнч(ДанныеСтрокиТаблицы) = Тип("Структура") Тогда
			Для Каждого ПараметрЗначение Из ДанныеСтрокиТаблицы Цикл
				Заменить(ActiveDocument.Content, ПараметрЗначение.Ключ, ПараметрЗначение.Значение);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПереходНаСледСтроку Тогда
		ВставитьРазрывНаНовуюСтроку(ПечатнаяФорма);
	КонецЕсли;
	
КонецПроцедуры

// конец: работа с коллекциями

// Вставляет разрыв на следующую строку
// Параметры
// Handler - ссылка на документ MS Word в который требуется вставить разрыв
//
Процедура ВставитьРазрывНаНовуюСтроку(Знач Handler) Экспорт
	ActiveDocument = Handler.COMСоединение.ActiveDocument;
	ПозицияОкончанияДокумента = ActiveDocument.Range().End;
	ActiveDocument.Range(ПозицияОкончанияДокумента-1, ПозицияОкончанияДокумента-1).InsertParagraphAfter();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции

Функция ПолучитьПозициюНачалаОбласти(Знач COMСоединение, Знач ИдентификаторОбласти)
	
	ИдентификаторОбласти = "{v8 Область." + ИдентификаторОбласти + "}";
	
	ВесьДокумент = COMСоединение.ActiveDocument.Content;
	ВесьДокумент.Select();
	
	Поиск = COMСоединение.Selection.Find;
	Поиск.Text = ИдентификаторОбласти;
	Поиск.ClearFormatting();
	Поиск.Forward = Истина;
	Поиск.execute();
	
	Если Поиск.Found Тогда
		Возврат COMСоединение.Selection.End;
	КОнецЕсли;
	
	ВОзврат -1;
	
КонецФункции

Функция ПолучитьПозициюОкончанияОбласти(Знач COMСоединение, Знач ИдентификаторОбласти)
	
	ИдентификаторОбласти = "{/v8 Область." + ИдентификаторОбласти + "}";
	
	ВесьДокумент = COMСоединение.ActiveDocument.Content;
	ВесьДокумент.Select();
	
	Поиск = COMСоединение.Selection.Find;
	Поиск.Text = ИдентификаторОбласти;
	Поиск.ClearFormatting();
	Поиск.Forward = Истина;
	Поиск.execute();
	
	Если Поиск.Found Тогда
		Возврат COMСоединение.Selection.Start;
	КОнецЕсли;
	
	ВОзврат -1;

	
КонецФункции

Функция НастройкиПараметровСтраницы()
	
	МассивНастроек = Новый Массив;
	МассивНастроек.Добавить("Orientation");
	МассивНастроек.Добавить("TopMargin");
	МассивНастроек.Добавить("BottomMargin");
	МассивНастроек.Добавить("LeftMargin");
	МассивНастроек.Добавить("RightMargin");
	МассивНастроек.Добавить("Gutter");
	МассивНастроек.Добавить("HeaderDistance");
	МассивНастроек.Добавить("FooterDistance");
	МассивНастроек.Добавить("PageWidth");
	МассивНастроек.Добавить("PageHeight");
	МассивНастроек.Добавить("FirstPageTray");
	МассивНастроек.Добавить("OtherPagesTray");
	МассивНастроек.Добавить("SectionStart");
	МассивНастроек.Добавить("OddAndEvenPagesHeaderFooter");
	МассивНастроек.Добавить("DifferentFirstPageHeaderFooter");
	МассивНастроек.Добавить("VerticalAlignment");
	МассивНастроек.Добавить("SuppressEndnotes");
	МассивНастроек.Добавить("MirrorMargins");
	МассивНастроек.Добавить("TwoPagesOnOne");
	МассивНастроек.Добавить("BookFoldPrinting");
	МассивНастроек.Добавить("BookFoldRevPrinting");
	МассивНастроек.Добавить("BookFoldPrintingSheets");
	МассивНастроек.Добавить("GutterPos");
	
	Возврат МассивНастроек;
	
КонецФункции

Функция СобытиеЖурналаРегистрации()
	Возврат НСтр("ru = 'Печать'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
КонецФункции

Процедура НеУдалосьСформироватьПечатнуюФорму(ИнформацияОбОшибке)
#Если ВебКлиент Тогда
	ТекстУточнения = НСтр("ru = 'При работе через веб требуется браузер Internet Explorer под управлением операционной системы Windows. См. также главу документации ""Настройка веб-браузеров для работы в веб-клиенте""'");
#Иначе		
	ТекстУточнения = "";	
#КонецЕсли
	ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось сформировать печатную форму: %1. 
			|Для вывода печатных форм в формате Microsoft Word требуется, чтобы на компьютере был установлен пакет Microsoft Office. %2'"),
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке), ТекстУточнения);
	ВызватьИсключение ТекстИсключения;
КонецПроцедуры

Процедура Заменить(Object, Знач СтрокаПоиска, Знач СтрокаЗамены)
	
	СтрокаПоиска = "{v8 " + СтрокаПоиска + "}";
	СтрокаЗамены = Строка(СтрокаЗамены);
	
	Object.Select();
	Selection = Object.Application.Selection;
	
	FindObject = Selection.Find;
	FindObject.ClearFormatting();
	Пока FindObject.Execute(СтрокаПоиска) Цикл
		Если ПустаяСтрока(СтрокаЗамены) Тогда
			Selection.Delete();
		Иначе
			Selection.TypeText(СтрокаЗамены);
		КонецЕсли;
	КонецЦикла;
	
	Selection.Collapse();
	
КонецПроцедуры