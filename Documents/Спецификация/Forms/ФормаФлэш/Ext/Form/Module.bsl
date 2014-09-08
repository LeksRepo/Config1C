﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	//Если Параметры.Свойство("СпецификацияСсылка") Тогда
	//	СпецификацияСсылка = Параметры.СпецификацияСсылка;
	//КонецЕсли;
	
	ОпределительФлеш = "";
	Спецификация = Документы.Спецификация.ПустаяСсылка();
	
	Если Параметры.Свойство("ХранимыйФайл") Тогда
		
		ОпределительФлеш = Параметры.ХранимыйФайл;
		
	КонецЕсли;
	
	РаскройГотов = Ложь;
	
	Если ОпределительФлеш = "КривойПил" Тогда
		
		ИмяHTML = ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.КривойПилHtml);
		СтрокаДляФлэш = Параметры.СтрокаКривогоПила;
		
	ИначеЕсли ОпределительФлеш = "НовыйРаскрой" Тогда
		
		//Параметры.ВидОтображения
		//1 - Сохраняем флэшку в картинку, при проведении спецификации
		//2 - Обычный просмотр флэшки, до проведения
		ИмяHTML = ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.НовыйРаскройHtml);
		СтрокаДляФлэш = Параметры.ВидОтображения + Параметры.СтрокаНовогоРаскрояЛДСП;
		
		РаскройГотов = Параметры.ВидОтображения = "2";
		
		ЭтаФорма.Ширина = ?(РаскройГотов, 150, 51);
		ЭтаФорма.Высота = ?(РаскройГотов, 60, 15);
		Элементы.ХТМЛ.ТолькоПросмотр = НЕ РаскройГотов;
		
	ИначеЕсли ОпределительФлеш = "Редактор3д" Тогда
		
		ИмяHTML = ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.Редактор3DHtml);
		Подразделение = Параметры.Подразделение;
		Спецификация = ?(Параметры.Свойство("Спецификация"), Параметры.Спецификация, Спецификация);
		СтрокаДляФлэш = Параметры.Строка3дРедактора;
		МассивыНоменклатурныхГрупп = ЛексСервер.ОтборФиксированныхНоменклатурныхГрупп(Подразделение);
		
	ИначеЕсли ОпределительФлеш = "ЧертежДвери" Тогда
		СтруктураМассивовДверей = Новый Структура;
		СтруктураМассивовДверей.Вставить("КартинкиДверей", Новый Массив);
		СтруктураМассивовДверей.Вставить("ФлэшСтроки", Параметры.МассивДверейФлэш);
		СтруктураМассивовДверей.Вставить("Договор", Параметры.Договор);
		СтруктураМассивовДверей.Вставить("Спецификация", Параметры.Договор.Спецификация);
		СтруктураМассивовДверей.Вставить("ДвериСсылки", Параметры.МассивДверейСсылки);
		СтруктураМассивовДверей.Вставить("ТекущаяДверь", Параметры.МассивДверейСсылки.Получить(0));
		ИмяHTML = ЛексСервер.ПолучитьИмяХТМЛ(Справочники.Файлы.ДвериHtml);
		СтрокаДляФлэш = Параметры.МассивДверейФлэш.Получить(0);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПредупредитьНаКлиенте()
	Строка = Новый ФорматированнаяСтрока("Обновите справочник файлов!",,,,"e1cib/command/ОбщаяКоманда.СинхронизацияФайлов");
	Предупреждение(Строка);	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	url = ЛексКлиент.ПутьHTML(ИмяHTML);

	Если url <> "" Тогда
		Попытка
			Элементы.ХТМЛ.Документ.url = url;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Отказ = Истина;
		КонецПопытки;
	Иначе
		ПредупредитьНаКлиенте();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ХТМЛПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
 	
	Если ОпределительФлеш = "ЧертежДвери" Тогда
		ПолученнаяСтрока = Элементы.ХТМЛ.Документ.getElementById("forw").tag;
	Иначе
		
		ПолученнаяСтрока = Элементы.ХТМЛ.Документ.getElementById("output").tag;
		КоличествоКликов = КоличествоКликов + 1;
		
	КонецЕсли;
	
	Если ОпределительФлеш = "Редактор3д" Тогда
		
		#Если НЕ ВебКлиент Тогда
			
			Элементы.ХТМЛ.ТолькоПросмотр = Ложь;
			Чтение = Новый ЧтениеXML;
			Чтение.УстановитьСтроку(ПолученнаяСтрока);
			Чтение.Прочитать();
			ОбъектХДТО = ФабрикаXDTO.ПрочитатьXML(Чтение);
			Команда = ОбъектХДТО.Actions;
			Параметр = ОбъектХДТО.Param;
			ЗапросКромок = Ложь;
			
			Если НЕ ТипЗнч(ОбъектХДТО.ItemList) = Тип("ОбъектXDTO") и ЗначениеЗаполнено(ОбъектХДТО.ItemList) Тогда
				
				ЗапросКромок = Истина;
				
			КонецЕсли;
			
			Если Команда = "Init" Тогда
				
				ОбъектХДТО.Param = ?(ЗначениеЗаполнено(СтрокаДляФлэш), СтрокаДляФлэш, "New");
				Запись = Новый ЗаписьXML;
				Запись.УстановитьСтроку(); 
				Запись.ЗаписатьОбъявлениеXML();
				ФабрикаXDTO.ЗаписатьXML(Запись, ОбъектХДТО);
				Стр = Запись.Закрыть();
				
			ИначеЕсли Команда = "GetMat" или Команда = "GetKrom" Тогда
				
				Стр = ПолучитьОбъектХДТО(Команда, Параметр, ЗапросКромок);
				ЭтаФорма.Модифицированность = Истина;
				
			ИначеЕсли Команда = "SaveBox" Тогда
				
				ПараметрФормы = Новый Структура;
				ПараметрФормы.Вставить("АдресТаблицы", ВыгрузитьНужнуюТаблицуВХранилище());
				СтрокаДляФлэш = "";
				СтрокаДляФлэш = Параметр;
				Значения = ОткрытьФормуМодально("Справочник.КаталогИзделий.Форма.ФормаЯщики", ПараметрФормы, ЭтаФорма);
				//ЯщикСохранен = СохранитьЭлементКаталога(Значения, Параметр);
				Возврат;
				
			ИначеЕсли Команда = "OpenBox" Тогда
				
				Если КоличествоКликов / 2 <> Цел(КоличествоКликов / 2) Тогда
					
					Ящик = ПолучитьИзделиеЯщик();
					//Изделие = ОткрытьФормуМодально("Справочник.КаталогИзделий.ФормаВыбора", Новый Структура("Отбор, ВидИзделияПоКаталогу", Новый Структура("Активный", Истина), Ящик ), ЭтаФорма); // МассивИзделий
					ПараметрыФормыЯщиков = Новый Структура();
					ПараметрыФормыЯщиков.Вставить("Редактор3д", Истина);
					ПараметрыФормыЯщиков.Вставить("АдресТаблицы", ВыгрузитьНужнуюТаблицуВХранилище());
					ПараметрыФормыЯщиков.Вставить("Подразделение", Подразделение);
					Изделие = ОткрытьФормуМодально("Документ.Спецификация.Форма.ФормаЯщики", ПараметрыФормыЯщиков, ЭтаФорма);
					ОбъектХДТО.Param = СтрокаДляФлэш;
					Запись = Новый ЗаписьXML;
					Запись.УстановитьСтроку(); 
					Запись.ЗаписатьОбъявлениеXML();
					ФабрикаXDTO.ЗаписатьXML(Запись, ОбъектХДТО);
					Стр = Запись.Закрыть();
					Элементы.ХТМЛ.Документ.getElementById("input").tag = Стр;
					Элементы.ХТМЛ.Документ.getElementById("input").Click();
					
				КонецЕсли;
				
				Возврат;
				
			ИначеЕсли Команда = "Edit" Тогда
				
				//СтруктураДетали = Новый Структура;
				//
				//ПараметрыДетали = ОбъектХДТО.ItemList.Item;
				//		
				//		СтруктураДетали.Вставить("KromDown", ПараметрыДетали.KromDown);
				//		СтруктураДетали.Вставить("KromLeft", ПараметрыДетали.KromLeft);
				//		СтруктураДетали.Вставить("KromRight", ПараметрыДетали.KromRight);
				//		СтруктураДетали.Вставить("KromUp", ПараметрыДетали.KromUp);
				//		СтруктураДетали.Вставить("LengthDetails", ПараметрыДетали.LengthDetails);
				//		СтруктураДетали.Вставить("Mat2Link", ПараметрыДетали.Mat2Link);
				//		СтруктураДетали.Вставить("MatLink", ПараметрыДетали.MatLink);
				//		СтруктураДетали.Вставить("WidthDetails", ПараметрыДетали.WidthDetails);
				//		СтруктураДетали.Вставить("R1", ПараметрыДетали.R1);
				//		СтруктураДетали.Вставить("R2", ПараметрыДетали.R2);
				//		СтруктураДетали.Вставить("R3", ПараметрыДетали.R3);
				//		СтруктураДетали.Вставить("R4", ПараметрыДетали.R4);
				//		СтруктураДетали.Вставить("SectionLink", ПараметрыДетали.SectionLink);
				//		
				//	//////////////////////////////////
				//	
				//	
				//	//Если НЕ ЗначениеЗаполнено(ТекущиеДанные.СтрокаДляФлэш) Тогда
				//		
				//		ВысотаДетали = СтруктураДетали.LengthDetails;
				//		ШиринаДетали = СтруктураДетали.WidthDetails;
				//		СтрокаДляРедактирования = "new☻"+Строка(ВысотаДетали)+"☻"+Строка(ШиринаДетали);
				//		
				//	//Иначе
				//	//	
				//	//	СтрокаДляРедактирования = "old☻"+ТекущиеДанные.СтрокаДляФлэш;
				//	//	
				//	//КонецЕсли;
				//	
				//	//АдресТаблицы = ПолучитьАдресТаблицы();
				//	
				//	Параметр = Новый Структура;
				//	
				//	Параметр.Вставить("СтрокаДляРедактирования", СтрокаДляРедактирования);
				//	Параметр.Вставить("Подразделение", Подразделение);
				//	МатериалДетали = ПолучитьМатериал(СтруктураДетали.SectionLink);
				//	Параметр.Вставить("Материал", Строка(МатериалДетали));
				//	//Параметр.Вставить("АдресТаблицы", АдресТаблицы);
				//	ОткрытьФорму("Документ.Спецификация.Форма.ФормаРедактированиеДеталей", Параметр, Элементы.ХТМЛ);
				//	
				//	////////////////////////////////
				//	Возврат;
				
			ИначеЕсли Команда = "Save" Тогда
				
				Режим = РежимДиалогаВопрос.ДаНетОтмена;
				Ответ = Вопрос("Данные будут сохранены. Закрыть редактор?", Режим, 0, , "Нажмите ""Отмена"", чтобы продолжить без сохранения");
				
				Если Ответ = КодВозвратаДиалога.Да или Ответ = КодВозвратаДиалога.Нет Тогда
					
					ЕстьДетали = ОбъектХДТО.ItemList.Свойства().Получить("Item") <> Неопределено;
					СтрокаДляРедактора = ОбъектХДТО.Param;
					ЗаписатьСтрокуРаскроя(СтрокаДляРедактора);
					
					Если ЕстьДетали Тогда
						
						Список = ОбъектХДТО.ItemList.Item;
						МассивСтруктур = Новый Массив;
						СписокДеталей = ОбъектХДТО.ItemList.Item;
						
						Если ТипЗнч(СписокДеталей) = Тип("ОбъектXDTO") Тогда
							
							Список = Новый Массив;
							Список.Добавить(СписокДеталей);
							
						Иначе
							
							Список = СписокДеталей;
							
						КонецЕсли;
						
						Для каждого Строка Из Список Цикл
							
							СтруктураДеталей = Новый Структура;
							СтруктураДеталей.Вставить("KromDown", Строка.KromDown);
							СтруктураДеталей.Вставить("KromLeft", Строка.KromLeft);
							СтруктураДеталей.Вставить("KromRight", Строка.KromRight);
							СтруктураДеталей.Вставить("KromUp", Строка.KromUp);
							СтруктураДеталей.Вставить("LengthDetails", Строка.LengthDetails);
							СтруктураДеталей.Вставить("Mat2Link", Строка.Mat2Link);
							СтруктураДеталей.Вставить("MatLink", Строка.MatLink);
							СтруктураДеталей.Вставить("WidthDetails", Строка.WidthDetails);
							СтруктураДеталей.Вставить("R1", Строка.R1);
							СтруктураДеталей.Вставить("R2", Строка.R2);
							СтруктураДеталей.Вставить("R3", Строка.R3);
							СтруктураДеталей.Вставить("R4", Строка.R4);
							СтруктураДеталей.Вставить("SectionLink", Строка.SectionLink);
							МассивСтруктур.Добавить(СтруктураДеталей);
							
						КонецЦикла;
						
						АдресТаблицы = ПолучитьАдресТаблицыДеталей(МассивСтруктур);
						
						СтруктураОповещения = Новый Структура;
						СтруктураОповещения.Вставить("АдресХранилища", АдресТаблицы);
						
						Если Ответ = КодВозвратаДиалога.Да Тогда
							
							ЭтаФорма.Модифицированность = Ложь;
							
						Иначе
							
							ЭтаФорма.Модифицированность = Истина;
							
						КонецЕсли;
						
						ОповеститьОВыборе(СтруктураОповещения);
						
					Иначе
						
						ЭтаФорма.Закрыть();
						
					КонецЕсли;
					
				КонецЕсли;
				
				Возврат;
				
			КонецЕсли;
			
			Элементы.ХТМЛ.Документ.getElementById("input").tag = Стр;
			Элементы.ХТМЛ.Документ.getElementById("input").Click();
			
		#КонецЕсли
			
	ИначеЕсли ОпределительФлеш = "ЧертежДвери" Тогда
		
		Команда = Лев(ПолученнаяСтрока, 4); // код команды, первые 4 символа
		ЗначениеОтФлэш = Прав(ПолученнаяСтрока, СтрДлина(ПолученнаяСтрока) - 5); // полученные значения аргументов от флэш
		ЭлементДляВвода = Элементы.ХТМЛ.Документ.getElementById("back");
		
		Если Команда = "init" Тогда
			
			ЭлементДляВвода.tag = "ppic☻"+СтрокаДляФлэш;
			ЭлементДляВвода.click();
			
		ИначеЕсли Команда = "prtx" Тогда
			
			ЭлементДляВвода.tag = "prtx☻"+ ЛексСервер.УстановитьПримечание() + "☻" + ТекущаяДата() + Символы.ПС
									+ СтруктураМассивовДверей.Договор + Символы.ПС + СтруктураМассивовДверей.Спецификация
									+ Символы.ПС + СтруктураМассивовДверей.ТекущаяДверь;
			ЭлементДляВвода.click();
			
		ИначеЕсли Команда = "ppic" Тогда
			
			СтруктураМассивовДверей.КартинкиДверей.Добавить(ЗначениеОтФлэш);
			КоличествоЧертежей = СтруктураМассивовДверей.КартинкиДверей.Количество();
			Если СтруктураМассивовДверей.ФлэшСтроки.Количество() <> КоличествоЧертежей Тогда
				СтруктураМассивовДверей.ТекущаяДверь = СтруктураМассивовДверей.ДвериСсылки.Получить(КоличествоЧертежей);
				СтрокаДляФлэш = СтруктураМассивовДверей.ФлэшСтроки.Получить(КоличествоЧертежей);
				Элементы.ХТМЛ.Документ.url = ЛексКлиент.ПутьHTML(ИмяHTML);
				ЭлементДляВвода.tag = "ppic☻"+СтрокаДляФлэш;
				ЭлементДляВвода.click();
				
			Иначе
				
				РаскройГотов = Истина;
				Закрыть(СтруктураМассивовДверей.КартинкиДверей);
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если Найти(ПолученнаяСтрока, "save") > 0 Тогда
			
			РаскройГотов = Истина;
			Закрыть(ПолученнаяСтрока);
			Возврат;
			
		КонецЕсли;
		
		Роспил = Найти(СтрокаДляФлэш, "%РОСПИЛ%") > 0;
		Лекс = Найти(СтрокаДляФлэш, "%ЛЕКС%") > 0;
		
		РабочийКаталог = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
		Код = "";
		
		Если Роспил Тогда
			
			Код = "ЛоготипРоспил";
			
		ИначеЕсли Лекс Тогда
			
			Код = "ЛоготипЛекс";
			
		КонецЕсли;
		
		ПутьКИзображению = РабочийКаталог + Код + ".jpg";
		ФайлНаДиске = Новый Файл(ПутьКИзображению);
		
		Если ФайлНаДиске.Существует() Тогда
			
			ПутьЛоготипа = ПутьКИзображению;
			
		Иначе
			
			ПутьЛоготипа = "";
			
		КонецЕсли;
		
		//RonEXI edit
		//ПутьЛоготипа = ЛексКлиентСервер.ПеревестиСтрокуВКодыСимволов(ПутьЛоготипа);
		
		Если Лекс Тогда
			
			СтрокаДляФлэш = СтрЗаменить(СтрокаДляФлэш, "%ЛЕКС%", ПутьЛоготипа);
			
		ИначеЕсли Роспил Тогда
			
			СтрокаДляФлэш = СтрЗаменить(СтрокаДляФлэш, "%РОСПИЛ%", ПутьЛоготипа);
			
		КонецЕсли;
		
		Элементы.ХТМЛ.Документ.getElementById("input").tag = СтрокаДляФлэш;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ЗаписатьСтрокуРаскроя(СтрокаДляРедактора)
	
	НаборЗаписей = РегистрыСведений.РаскройДеталей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Спецификация);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		
		Запись = НаборЗаписей.Добавить();
		
	Иначе
		
		Запись = НаборЗаписей[0];
		
	КонецЕсли;
	
	Запись.Строка3дРедактора = СтрокаДляРедактора;
	Запись.Объект = Спецификация;
	
	НаборЗаписей.Записать();
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИзделиеЯщик()
	
	Возврат Справочники.ВидыИзделийПоКаталогу.Ящик;
	
КонецФункции

&НаСервере
Функция ВыгрузитьНужнуюТаблицуВХранилище()
	
	ТЗ = Новый ТаблицаЗначений;
	
	Возврат ПоместитьВоВременноеХранилище(ТЗ);
	
КонецФункции

&НаСервере
Функция ПолучитьМатериал(Строка)
	
	Идентификатор = Новый УникальныйИдентификатор(Строка);
	Материал = Справочники.ВидыДеталей.ПолучитьСсылку(Идентификатор);
	Возврат Материал;
	
КонецФункции

&НаСервере
Функция ПолучитьАдресТаблицыДеталей(Список)
	
	ТаблицаДеталей = Новый ТаблицаЗначений;
	ТаблицаДеталей.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаДеталей.Колонки.Добавить("НоменклатураДляСклеивания", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаДеталей.Колонки.Добавить("ШиринаДетали", Новый ОписаниеТипов("Число"));
	ТаблицаДеталей.Колонки.Добавить("ВысотаДетали", Новый ОписаниеТипов("Число"));
	ТаблицаДеталей.Колонки.Добавить("Материал", Новый ОписаниеТипов("Строка"));
	ТаблицаДеталей.Колонки.Добавить("РадиусЛевоВерх", Новый ОписаниеТипов("Число"));
	ТаблицаДеталей.Колонки.Добавить("РадиусПравоВерх", Новый ОписаниеТипов("Число"));
	ТаблицаДеталей.Колонки.Добавить("РадиусЛевоНиз", Новый ОписаниеТипов("Число"));
	ТаблицаДеталей.Колонки.Добавить("РадиусПравоНиз", Новый ОписаниеТипов("Число"));
	ТаблицаДеталей.Колонки.Добавить("ДлинаКривогоПила", Новый ОписаниеТипов("Число"));
	ТаблицаДеталей.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	ТаблицаДеталей.Колонки.Добавить("ВыборМебельнойКромкиСверху", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаДеталей.Колонки.Добавить("ВыборМебельнойКромкиСнизу", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаДеталей.Колонки.Добавить("ВыборМебельнойКромкиСлева", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаДеталей.Колонки.Добавить("ВыборМебельнойКромкиСправа", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаДеталей.Колонки.Добавить("Срез", Новый ОписаниеТипов("Булево"));
	
	Для каждого Деталь Из Список Цикл
		
		НоваяСтрока = ТаблицаДеталей.Добавить();
		Идентификатор = Новый УникальныйИдентификатор(Деталь.MatLink);
		НоваяСтрока.Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Идентификатор);
		
		Если ЗначениеЗаполнено(Деталь.Mat2Link) Тогда
			
			Идентификатор = Новый УникальныйИдентификатор(Деталь.Mat2Link);
			НоваяСтрока.НоменклатураДляСклеивания = Справочники.Номенклатура.ПолучитьСсылку(Идентификатор);
			
		Иначе
			
			НоваяСтрока.НоменклатураДляСклеивания = Справочники.Номенклатура.ПустаяСсылка();
			
		КонецЕсли;
		
		НоваяСтрока.ШиринаДетали = Число(Деталь.WidthDetails);
		НоваяСтрока.ВысотаДетали = Число(Деталь.LengthDetails);
		Идентификатор = Новый УникальныйИдентификатор(Деталь.SectionLink);
		НоваяСтрока.Материал = Справочники.ВидыДеталей.ПолучитьСсылку(Идентификатор);
		НоваяСтрока.РадиусЛевоВерх = Число(Деталь.R1);
		НоваяСтрока.РадиусПравоВерх = Число(Деталь.R2);
		
		МассивСлов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивСлов(Деталь.R3, "_");
		
		НоваяСтрока.РадиусПравоНиз = Число(МассивСлов[0]);
		НоваяСтрока.Срез = МассивСлов.Количество() = 2;
		
		НоваяСтрока.РадиусЛевоНиз = Число(Деталь.R4);
		НоваяСтрока.ДлинаКривогоПила = 0;  //Когда добавим кривые детали - заменить.
		НоваяСтрока.Количество = 1;
		НоваяСтрока.ВыборМебельнойКромкиСверху = ЗаполнитьКромку(Деталь.KromUp);
		НоваяСтрока.ВыборМебельнойКромкиСнизу = ЗаполнитьКромку(Деталь.KromDown);
		НоваяСтрока.ВыборМебельнойКромкиСлева = ЗаполнитьКромку(Деталь.KromLeft);
		НоваяСтрока.ВыборМебельнойКромкиСправа = ЗаполнитьКромку(Деталь.KromRight);
		
	КонецЦикла;
	
	АдресТаблицы = ПоместитьВоВременноеХранилище(ТаблицаДеталей);
	
	Возврат АдресТаблицы;
	
КонецФункции

&НаСервере
Функция ЗаполнитьКромку(СтрокаСсылки)
	
	Номенклатура = Справочники.Номенклатура.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(СтрокаСсылки) Тогда
	
		Идентификатор = Новый УникальныйИдентификатор(СтрокаСсылки);
		Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Идентификатор);
	
	КонецЕсли;
		
	Возврат Номенклатура;
	
КонецФункции // ЗаполнитьКромку()

&НаСервере
Функция ПолучитьОбъектХДТО(Команда, СправочникСсылка, ЗапросКромок, СтрокаТаблицы = Неопределено)
	
	ТипСписокТегов = ФабрикаXDTO.Тип("masterleks.ru/Flash1C", "TegsList");
	ТипСписокМатериалов = ФабрикаXDTO.Тип("masterleks.ru/Flash1C", "ItemList");
	ТипЭлементНоменклатуры = ФабрикаXDTO.Тип("masterleks.ru/Flash1C", "ItemType");
	ТипКоманды = ФабрикаXDTO.Тип("masterleks.ru/Flash1C", "Actions");
	СписокТегов = ФабрикаXDTO.Создать(ТипСписокТегов);
	СписокМатериалов = ФабрикаXDTO.Создать(ТипСписокМатериалов);
	СписокТегов = ФабрикаXDTO.Создать(ТипСписокТегов);
	СписокНоменклатуры = ФабрикаXDTO.Создать(ТипСписокМатериалов);

	Если ЗначениеЗаполнено(СправочникСсылка) Тогда
		
		Если Команда = "GetMat" Тогда
			
			НоменклатурныеГруппы = Справочники.НоменклатурныеГруппы;
			НомГруппа = НоменклатурныеГруппы.ПустаяСсылка();
			
			НовыйGUID = Новый УникальныйИдентификатор(СправочникСсылка); 
			Ссылка = Справочники.ВидыДеталей.ПолучитьСсылку(НовыйGUID);
			
			НомГруппа = Ссылка.Номенклатура;
			
			СписокМатериалов = ВыполнитьЗапросПоНоменклатурнойГруппе(НомГруппа, ТипЭлементНоменклатуры, СписокМатериалов);
			СписокТегов.ItemList = СписокМатериалов;
			СписокТегов.Actions = Команда;
			
		ИначеЕсли Команда = "GetKrom" Тогда
			
			НоменклатурныеГруппы = Справочники.НоменклатурныеГруппы;
			НомГруппа = НоменклатурныеГруппы.ПустаяСсылка();
			
			НовыйGUID = Новый УникальныйИдентификатор(СправочникСсылка);
			
			Если ЗапросКромок Тогда
				
				НомГруппа = Справочники.НоменклатурныеГруппы.ПолучитьСсылку(НовыйGUID);
				СписокМатериалов = ВыполнитьЗапросПоНоменклатурнойГруппе(НомГруппа, ТипЭлементНоменклатуры, СписокМатериалов);
				СписокТегов.ItemList = СписокМатериалов;
				СписокТегов.Actions = Команда
				
			Иначе
			
				Ссылка = Справочники.ВидыДеталей.ПолучитьСсылку(НовыйGUID);
						
				Для каждого НомГруппа Из Ссылка.СписокПодходящихКромок Цикл
					
					ИспользуемаяНомГруппа = НомГруппа.НоменклатурнаяГруппа;
					Название = ИспользуемаяНомГруппа.Наименование;
				
					ЭлементНоменклатуры = ФабрикаXDTO.Создать(ТипЭлементНоменклатуры);
					ЭлементНоменклатуры.Name = Название;
					СтрокаСсылка = ИспользуемаяНомГруппа.Ссылка.УникальныйИдентификатор();
					ЭлементНоменклатуры.Link = Строка(СтрокаСсылка);
					
					СписокМатериалов.Item.Добавить(ЭлементНоменклатуры);
				
				КонецЦикла;
			
			КонецЕсли;
			
			СписокТегов.ItemList = СписокМатериалов;
			СписокТегов.Actions = Команда;
			
		КонецЕсли;
		
	ИначеЕсли Не СтрокаТаблицы = Неопределено Тогда
		
		//ЭлементНоменклатуры = ФабрикаXDTO.Создать(ТипЭлементНоменклатуры);
		//	ЭлементНоменклатуры.Name = Выборка.Наименование;
		//	ЭлементНоменклатуры.ShortName = Выборка.КраткоеНаименование;
		//	СтрокаСсылка = Строка(Выборка.Ссылка.УникальныйИдентификатор());
		//	ЭлементНоменклатуры.Link = СтрокаСсылка;
		//	ЭлементНоменклатуры.DepthDetails = Выборка.ГлубинаДетали;
		//	ЭлементНоменклатуры.WidthDetails = Выборка.ШиринаДетали;
		//	ЭлементНоменклатуры.LengthDetails = Выборка.ДлинаДетали;
		//	Цвет = Строка(Выборка.Цвет);
		//	ЭлементНоменклатуры.Color = Цвет;
		//	
		//	СписокМатериалов.Item.Добавить(ЭлементНоменклатуры);

		
	Иначе
		
		ВидыДеталей = Справочники.ВидыДеталей;
		ВыборкаВидовДеталей = ВидыДеталей.Выбрать();
		
		Пока ВыборкаВидовДеталей.Следующий() Цикл
			
			Название = ВыборкаВидовДеталей.Наименование;
			
			ЭлементНоменклатуры = ФабрикаXDTO.Создать(ТипЭлементНоменклатуры);
			ЭлементНоменклатуры.Name = Название;
			СтрокаСсылка = ВыборкаВидовДеталей.Ссылка.УникальныйИдентификатор();
			ЭлементНоменклатуры.Link = Строка(СтрокаСсылка);
			
			СписокМатериалов.Item.Добавить(ЭлементНоменклатуры);
		
		КонецЦикла;
		
		СписокТегов.ItemList = СписокМатериалов;
		СписокТегов.Actions = "GetMat";
		
	КонецЕсли;
		
		Запись = Новый ЗаписьXML;
		Запись.УстановитьСтроку(); 
		Запись.ЗаписатьОбъявлениеXML();
		ФабрикаXDTO.ЗаписатьXML(Запись, СписокТегов);
		Стр = Запись.Закрыть();
		Возврат Стр;
	
КонецФункции

&НаСервере
Функция ВыполнитьЗапросПоНоменклатурнойГруппе(НомГруппа, ТипЭлементНоменклатуры, СписокМатериалов)
	
	Если НомГруппа = Справочники.НоменклатурныеГруппы.ПустаяСсылка() Тогда
		
		ЭлементНоменклатуры = ФабрикаXDTO.Создать(ТипЭлементНоменклатуры);
		ЭлементНоменклатуры.Name = "";
		ЭлементНоменклатуры.ShortName = "";
		СтрокаСсылка = "";
		ЭлементНоменклатуры.Link = СтрокаСсылка;
		ЭлементНоменклатуры.DepthDetails = 0;
		ЭлементНоменклатуры.WidthDetails = 0;
		ЭлементНоменклатуры.LengthDetails = 0;
		Цвет = "";
		ЭлементНоменклатуры.Color = Цвет;
		
		СписокМатериалов.Item.Добавить(ЭлементНоменклатуры);
		
	Иначе
		
		ИмяГруппы = Справочники.НоменклатурныеГруппы.ПолучитьИмяПредопределенного(НомГруппа);
		МассивСсылок = МассивыНоменклатурныхГрупп[ИмяГруппы];
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка,
		|	Номенклатура.Наименование,
		|	Номенклатура.ГлубинаДетали,
		|	Номенклатура.ДлинаДетали,
		|	Номенклатура.КраткоеНаименование,
		|	Номенклатура.Цвет,
		|	Номенклатура.ШиринаДетали
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Ссылка В(&МассивСсылок)";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		
		
		Пока Выборка.Следующий() Цикл
			
			ЭлементНоменклатуры = ФабрикаXDTO.Создать(ТипЭлементНоменклатуры);
			ЭлементНоменклатуры.Name = Выборка.Наименование;
			ЭлементНоменклатуры.ShortName = Выборка.КраткоеНаименование;
			СтрокаСсылка = Строка(Выборка.Ссылка.УникальныйИдентификатор());
			ЭлементНоменклатуры.Link = СтрокаСсылка;
			ЭлементНоменклатуры.DepthDetails = Выборка.ГлубинаДетали;
			ЭлементНоменклатуры.WidthDetails = Выборка.ШиринаДетали;
			ЭлементНоменклатуры.LengthDetails = Выборка.ДлинаДетали;
			Цвет = Строка(Выборка.Цвет);
			ЭлементНоменклатуры.Color = Цвет;
			
			СписокМатериалов.Item.Добавить(ЭлементНоменклатуры);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СписокМатериалов;
			
КонецФункции

&НаСервере
Функция СоздатьСписокМатериалов(Материал)
	
	ТипЭлементСписка = ФабрикаXDTO.Тип("masterleks.ru/Flash1C", "ItemType");
	ЭлементСписка = ФабрикаXDTO.Создать(ТипЭлементСписка);
	ЭлементСписка.Name = Материал;
	Возврат ЭлементСписка;
	
КонецФункции // СоздатьСписокМатериалов()

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Если ЭтаФорма.ОпределительФлеш = "Редактор3д" Тогда
		
		Если ЭтаФорма.Модифицированность Тогда
			
			Режим = РежимДиалогаВопрос.ДаНет;
			Ответ = Вопрос("Закрыть редактор без сохранения результата?", Режим, 0, , "Нажмите ""Нет"", чтобы продолжить работу в редакторе");
			
			Если Ответ = КодВозвратаДиалога.Да Тогда
				
				РаскройГотов = Истина;
				
			Иначе
				
				РаскройГотов = Ложь;
				
			КонецЕсли;
				
		Иначе
			
			РаскройГотов = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
		
	Отказ = НЕ РаскройГотов;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ОбработкаВыбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораНаСервере(Значение)
	
	Если ТипЗнч(Значение) = Тип("Строка") Тогда
		
		Табличка = ПолучитьИзВременногоХранилища(Значение);
		
		Для каждого Строка Из Табличка Цикл
			
			НовыйОбъект = Справочники.КаталогИзделий.СоздатьЭлемент();
			НовыйОбъект.Наименование = Строка.ИмяЯщика;
			НовыйОбъект.Активный = Истина;
			НовыйОбъект.ВидИзделияПоКаталогу = Справочники.ВидыИзделийПоКаталогу.Ящик;
			НовыйОбъект.Строка3дРедактора = СтрокаДляФлэш;
			НовыйОбъект.Записать();
			
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Значение) = Тип("Структура") Тогда
		
		Табличка = ПолучитьИзВременногоХранилища(Значение.АдресТаблицы);
		
		Для каждого Строка Из Табличка Цикл
			
			ПолучитьОбъектХДТО("OpenBox", Справочники.ВидыДеталей.ПустаяСсылка(), Ложь, Строка);
			
		КонецЦикла;
		
	Иначе
		
		СтрокаДляФлэш = "";
		СтрокаДляФлэш = Значение.Строка3дРедактора;
		
	КонецЕсли;
	
КонецПроцедуры

