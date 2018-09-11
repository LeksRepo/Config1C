﻿// Здесь будем формировать файл в формет PTX для конвертера CadLink станка Holzma
// Описание формата файла:
// http://content.planit.com/s2m/Help/S2M_Help/Ribbonbar/Main_Tab/Machine/NC_Links/Saw_Links/Holzma.htm

#Область Общего_назначения

Функция Сформировать(фнПараметры) Экспорт
	
	ТекстФайла = СформироватьТекстФайла(фнПараметры);
	
	Возврат ТекстФайла.ПолучитьТекст(); 
	
КонецФункции

Функция СформироватьСтрокуИзМассива(фнМассив, Разделитель)
	
	Результат = "";
	
	Для Каждого Элемент Из фнМассив Цикл
		
		Если ТипЗнч(Элемент) = Тип("Число") Тогда
			
			ЭлементСтрокой = Формат(Элемент, "ЧРД = . ; ЧГ = ")
			
		Иначе
			
			ЭлементСтрокой = Элемент;
			
		КонецЕсли;
		
		
		Результат = Результат + ЭлементСтрокой + Разделитель;
		
	КонецЦикла;
	
	ДлинаРазделителя = СтрДлина(Разделитель);
	ДлинаРезультата = СтрДлина(Результат);
	Результат = Лев(Результат, ДлинаРезультата - ДлинаРазделителя);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Формирование_текста_файла

Функция СформироватьТекстФайла(фнПараметры)
	
	Текст = Новый ТекстовыйДокумент;
	
	Текст.ДобавитьСтроку(HEADER(фнПараметры));
	Текст.ДобавитьСтроку("");
	
	Текст.ДобавитьСтроку(JOBS(фнПараметры));
	Текст.ДобавитьСтроку("");
	
	Текст.ДобавитьСтроку(PARTS_REQ(фнПараметры));
	Текст.ДобавитьСтроку("");
	
	Текст.ДобавитьСтроку(BOARDS(фнПараметры));
	Текст.ДобавитьСтроку("");
	
	Текст.ДобавитьСтроку(MATERIALS(фнПараметры));
	Текст.ДобавитьСтроку("");
	
	Текст.ДобавитьСтроку(PATTERNS_CUTS(фнПараметры));
	Текст.ДобавитьСтроку("");
	
	Возврат Текст;
	
КонецФункции

Функция HEADER(фнПараметры)
	
	// В примере выглядит так:
	//HEADER,1.08,,0,0,1
	
	//HEADER – VERSION,  TITLE,  UNITS,  ORIGIN,  TRIM_TYPE 
	
	// Я так понял, с которого угла формируется раскрой, будем пробовать.
	
	//	ORIGIN - This field indicates the origin for the VECTOR drawing records.  The origin for the CUT records is assumed to be 0 (top left).
	//0 = top to bottom - left to right
	//1 =  top to bottom – right to left
	//2 = bottom to top – left to right
	//3 = bottom to top – right to left
	
	// TRIM_TYPE -- подрезка деталей, не понял что где, будем смотреть
	
	НомерДок = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(фнПараметры.Наряд.Номер, "");
	
	Массив = Новый Массив;
	
	Массив.Добавить("HEADER");
	Массив.Добавить("1.08");
	Массив.Добавить("№"+НомерДок); // TITLE
	Массив.Добавить("0"); // UNITS
	Массив.Добавить("0"); // ORIGIN
	Массив.Добавить("1"); // TRIM_TYPE
	
	Результат = СформироватьСтрокуИзМассива(Массив, ",");
	
	Возврат Результат;
	
КонецФункции

Функция JOBS(фнПараметры)
	
	Результат = "";
	
	// В этом разделе перечислим спецификации.
	
	// В примере выглядит так:
	//JOBS,1,SHkaf 9 DSP buk 16,,,,,1,SHkaf 9 DSP buk 16,SHkaf 9 DSP buk 16,757,16.5
	
	//JOB_INDEX - Unique index number used to link other records to an appropriate job
	//NAME - Job number/name – reference for job
	//DESC - Job description/title - title of job
	//ORD_DATE – Date of order  (DD/MM/YYYY)
	//CUT_DATE – Date for cutting/delivery (DD/MM/YYYY)
	//CUSTOMER  - Customer code or name
	//STATUS - Status of the job.
	
	//STATUS - Status of the job.
	//0 - not optimised
	//1 - optimised
	//2 - optimise failed
	
	Наряд = фнПараметры.Наряд;
	НомерДок = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Наряд.Номер, "");
	
	Массив = Новый Массив;
	Массив.Добавить("JOBS");
	Массив.Добавить("1"); //JOB_INDEX
	Массив.Добавить(Формат(Наряд.ДатаИзготовления, "ДФ=dd.MM.yyyy") + "_№" + НомерДок); //NAME
	Массив.Добавить(""); //DESC
	Массив.Добавить(Формат(Наряд.Дата, "ДФ=dd.MM.yyyy")); //ORD_DATE
	Массив.Добавить(Формат(Наряд.ДатаИзготовления, "ДФ=dd.MM.yyyy")); //CUT_DATE
	Массив.Добавить(""); //CUSTOMER
	Массив.Добавить("1"); //STATUS
	
	Массив.Добавить(Формат(Наряд.ДатаИзготовления, "ДФ=dd.MM.yyyy") + "_№" + НомерДок); //Не известно
	Массив.Добавить(Формат(Наряд.ДатаИзготовления, "ДФ=dd.MM.yyyy") + "_№" + НомерДок); //Не известно
	
	Результат = Результат + СформироватьСтрокуИзМассива(Массив, ",");
	
	Возврат Результат;
	
КонецФункции

Функция PARTS_REQ(фнПараметры)
	
	МассивСтрок = Новый Массив();
	
	// Список деталей.
	
	// В примере выглядит так:
	//PARTS_REQ,1,1,1,1,2440.0,600.0,9,0,0,1,9
	
	//JOB_INDEX - Номер JOB
	//PART_INDEX - Порядковый номер
	//CODE - Код или описание
	//MAT_INDEX - Номер MATERIALS
	//LENGTH - Высота детали
	//WIDTH - Ширина детали
	//QTY_REQ - Количество деталей этого размера
	//QTY_OVER - allowed over production
	//QTY_UNDER - allowed under production.
	//GRAIN - Нельзя поворачивать 1, можно поворачить 0.
	//QTY_PROD -  Количество произведенных деталей.
		
	PART_INDEX = 0;
	
	тзДет = ПолучитьТаблицуДеталей(фнПараметры.РаскройДерево);
	
	Для Каждого Стр ИЗ тзДет Цикл
		
		Для Каждого Рез ИЗ Стр.тзРезы Цикл
			
			PART_INDEX = PART_INDEX + 1;
			
			Массив = Новый Массив;
			Массив.Добавить("PARTS_REQ");
			Массив.Добавить("1"); //JOB_INDEX
			Массив.Добавить(PART_INDEX); //PART_INDEX
			Массив.Добавить(PART_INDEX); //CODE
			Массив.Добавить(Стр.MAT_INDEX); //MAT_INDEX
			Массив.Добавить(Стр.ВысотаЛиста); //LENGTH
			Массив.Добавить(Рез.Отступ); //WIDTH
			Массив.Добавить("1"); //QTY_REQ
			Массив.Добавить("0"); //QTY_OVER
			Массив.Добавить("0"); //QTY_UNDER
			Массив.Добавить("1"); //GRAIN
			Массив.Добавить("1"); //QTY_PROD

			МассивСтрок.Добавить(СформироватьСтрокуИзМассива(Массив, ","));
			
		КонецЦикла;

	КонецЦикла;
	
	Возврат СформироватьСтрокуИзМассива(МассивСтрок, Символы.ПС);
	
КонецФункции

Функция BOARDS(фнПараметры)
	
	Результат = "";
	
	// В примере выглядит так:
	//BOARDS,1,1,DSP BUK 16,1,2440.0,1830.0,99999,41,0.000,0,,,1
	
	//BOARDS - JOB_INDEX, BRD_INDEX,  CODE, MAT_INDEX,  LENGTH,  WIDTH,  QTY_STOCK,  QTY_USED,  COST, STK_FLAG
	//These records contain details of the board/sheet sizes to be used; one record for each different size/material.
	
	//JOB_INDEX - Index number used to link this record to other records for this job.
	//BRD_INDEX - index number linking this record with the PATTERNS records for this job.
	//CODE – Board code - usually the stock code for the sheet size.
	//MAT_INDEX - Index of material used for this part.
	//LENGTH - Size of sheet in appropriate measurement unit.
	//WIDTH - Size of sheet in appropriate measurement unit.
	//QTY_STOCK - Total number of sheets available  – default 99999 (0=none)
	//QTY_USED - Total number of sheets this size used in patterns
	//COST - Cost per sq. metre or sq. foot according to measurement unit
	//STK_FLAG – Flag to indicate action if insufficient stock
	
	тзПлиты = ПолучитьТаблицуПлит(фнПараметры.РаскройДерево);
	
	Для Инд = 0 По тзПлиты.Количество() - 1 Цикл
		
		Номенклатура = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(тзПлиты[Инд].Номенклатура, ",");
		Номенклатура = СформироватьСтрокуИзМассива(Номенклатура, ".");
		
		Массив = Новый Массив;
		Массив.Добавить("BOARDS");
		Массив.Добавить(1); //JOB_INDEX
		Массив.Добавить(Инд + 1); //BRD_INDEX
		Массив.Добавить(Номенклатура); //CODE
		Массив.Добавить(тзПлиты[Инд].MAT_IND); //MAT_INDEX
		Массив.Добавить(тзПлиты[Инд].ВысотаЛиста); //LENGTH
		Массив.Добавить(тзПлиты[Инд].ШиринаЛиста); //WIDTH
		Массив.Добавить(9999); //QTY_STOCK
		Массив.Добавить(тзПлиты[Инд].КоличествоПлит); //QTY_USED
		Массив.Добавить("0"); //COST
		Массив.Добавить("0"); //STK_FLAG
		
		Результат = Результат + СформироватьСтрокуИзМассива(Массив, ",");
		
		Если Инд < (тзПлиты.Количество() - 1) Тогда  
			Результат = Результат + Символы.ПС;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция MATERIALS(фнПараметры)
	
	ТолщинаПропила = фнПараметры.Подразделение.ТолщинаПропила;
	МассивСтрок = Новый Массив();
	
	// В примере выглядит так:
	// MATERIALS,1,1,DSP BUK 16,,16.0,4,5.0,5.0,10.0,10.0,10.0,10.0,0,0,0.0,9,1,0,0,,1
	
	//JOB_INDEX - Номер записи JOB, связанной с этим материалом.
	//MAT_INDEX - Уникальный номер материала.
	//CODE – Название материала.
	//DESC - Описание материала. Можно не заполнять.
	//THICK - Толщина материала.
	//BOOK - Максимальное количество в пачке.
	//KERF_RIP - Ширина пропила.
	//KERF_XCT - Ширина пропила поперечный пил.
	//TRIM_FRIP - Подрезка. 10мм стоит в примере. Fixed rip trim (Rear) – includes saw kerf – amount sheet size is reduced by
	//TRIM_VRIP - Подрезка. 10мм стоит в примере. Minimum variable rip trim (Front) – includes saw kerf  
	//TRIM_FXCT - Подрезка. 10мм стоит в примере. Fixed crosscut trim (Rear) – includes saw kerf
	//TRIM_VXCT - Подрезка. 10мм стоит в примере. Minimum variable cross cut trim (Front) – includes saw kerf
	//TRIM_HEAD - Подрезка. 0мм стоит в примере. Internal head cut trim – includes saw kerf
	//TRIM_FRCT - Подрезка. 0мм стоит в примере. Fixed recut trim (Rear) – includes saw kerf
	//TRIM_VRCT - Подрезка. 0мм стоит в примере. Minimum variable recut trim (Front) – includes saw kerf
	//RULE1 - Optimisation rule 1 – cut nesting limit – 1 to 9 (e.g. 3 = allow third phase recuts)
	//RULE2 - Optimisation rule 2 – head cuts allowed  (0=No, 1 =Yes)
	//RULE3 - Optimisation rule 3 – board rotation allowed (short rip) (0=No, 1=Yes)
	//RULE4 - Optimisation rule 4 – show separate patterns for duplicate parts (0=No 1=Yes)
	
	тзМат = ПолучитьТаблицуМатериалов(фнПараметры.РаскройДерево);
	
	Для Каждого Стр ИЗ тзМат Цикл
		
		Номенклатура = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Стр.Номенклатура, ",");
		Номенклатура = СформироватьСтрокуИзМассива(Номенклатура, ".");
		
		Массив = Новый Массив;
		Массив.Добавить("MATERIALS");
		Массив.Добавить(1); //JOB_INDEX
		Массив.Добавить(Стр.Индекс); //MAT_INDEX
		
		Массив.Добавить(Номенклатура); //CODE
		Массив.Добавить(Номенклатура); //DESC
		
		Массив.Добавить(Стр.Толщина); //THICK
		
		Массив.Добавить("4"); //BOOK //Пока поставлю 4 как в примере, нужно узнать сколько вмещается в станок.
		
		Массив.Добавить(ТолщинаПропила); //KERF_RIP
		Массив.Добавить(ТолщинаПропила); //KERF_XCT
		
		Массив.Добавить("10"); //TRIM_FRIP
		Массив.Добавить("10"); //TRIM_VRIP
		Массив.Добавить("10"); //TRIM_FXCT
		Массив.Добавить("10"); //TRIM_VXCT
		
		Массив.Добавить("0"); //TRIM_HEAD
		Массив.Добавить("0"); //TRIM_FRCT
		Массив.Добавить("0"); //TRIM_VRCT
		
		Массив.Добавить("9"); //RULE1
		Массив.Добавить("1"); //RULE2
		Массив.Добавить("0"); //RULE3
		Массив.Добавить("0"); //RULE4
		
		Массив.Добавить(""); // ???
		Массив.Добавить("1"); // ???
		
		МассивСтрок.Добавить(СформироватьСтрокуИзМассива(Массив, ","));

	КонецЦикла;
	
	Возврат СформироватьСтрокуИзМассива(МассивСтрок, Символы.ПС);
	
КонецФункции

Функция PATTERNS_CUTS(фнПараметры)
	
	Результат = "";
	ТолщинаПропила = фнПараметры.Подразделение.ТолщинаПропила;
	
	// В примере выглядит так:
	// PATTERNS,1,1,1,0,1,1,1
	
	//JOB_INDEX - Номер JOB
	//PTN_INDEX - Порядковый номер PATTERN
	//BRD_INDEX - Номер BOARDS
	//TYPE - Тип первого реза

	//	0 = rip length  first – non-head cut pattern
	//	1 = turn board before ripping - non-head cut pattern
	//	2 = head cut pattern – head cut across width
	//	3 = head cut pattern – head cut along length
	//	4 = crosscut only

	//QTY_RUN - Количество листов по этому паттерну.
	//QTY_CYCLES  - Количество циклов
	//MAX_BOOK – Максимальное количество листов в пачке.
	//PICTURE –  Картинка
	
	// В примере выглядит так:
	// CUTS, 1, 1, 1, 1, 1, 600.0, 1, 1, 1, RIP
	
	//JOB_INDEX - Номер JOB
	//PTN_INDEX - Номер PATTERN
	//CUT_INDEX - Прядковый номер реза
	//SEQUENCE - Порядок выполнения
	//FUNCTION - Тип реза:

	//	0 = head cut
	//	1 = rip cut
	//	2 = cross cut
	//	3 = 3rd phase / recut
	//	4 = 4th phase /recut

	//	90,91,92,93 = trim / waste cut corresponding to phase of cut (to override defaults)

	//DIMENSION  - Сколько отрезать миллиметров.
	//QTY_RPT - Количество повторений этой операции.
	//PART_INDEX - Номер детали или обрезка полученой после выполнения. Если после команды деталь ещё не готова тогда 0.
	//QTY_PARTS  - Количество деталей, полученных после этой операции.
	//COMMENT - Комментарий
	
	тзДет = ПолучитьТаблицуДеталей(фнПараметры.РаскройДерево);
	
	PART_INDEX = 0;
	
	Для Каждого Стр ИЗ тзДет Цикл
		
		Массив = Новый Массив;
		Массив.Добавить("PATTERNS");
		Массив.Добавить("1"); //JOB_INDEX
		Массив.Добавить(Стр.PTN_INDEX); //PTN_INDEX
		Массив.Добавить(Стр.BRD_INDEX); //BRD_INDEX
		Массив.Добавить("0"); //TYPE
		Массив.Добавить("1"); //QTY_RUN
		Массив.Добавить("1"); //QTY_CYCLES
		Массив.Добавить("1"); //MAX_BOOK
				
		Результат = Результат + СформироватьСтрокуИзМассива(Массив, ",");
		Результат = Результат + Символы.ПС;
		
		CUT_IND = 0;

		Для Каждого Рез ИЗ Стр.тзРезы Цикл
			
			CUT_IND = CUT_IND + 1;
			PART_INDEX = PART_INDEX + 1;
			
			Массив = Новый Массив;
			Массив.Добавить("CUTS");
			Массив.Добавить("1"); //JOB_INDEX
			Массив.Добавить(Стр.PTN_INDEX); //PTN_INDEX
			Массив.Добавить(CUT_IND); //CUT_INDEX
			Массив.Добавить(CUT_IND); //SEQUENCE
			Массив.Добавить("1"); //FUNCTION
			Массив.Добавить(Рез.Отступ); //DIMENSION
			Массив.Добавить("1"); //QTY_RPT
			Массив.Добавить(PART_INDEX); //PART_INDEX
			Массив.Добавить("1"); //QTY_PARTS
			
			Результат = Результат + СформироватьСтрокуИзМассива(Массив, ",");
			Результат = Результат + Символы.ПС;
			
		КонецЦикла;
		
		Результат = Результат + Символы.ПС;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьТаблицуМатериалов(фнДерево)
	
	Индекс = 1;
	
	тзМат = Новый ТаблицаЗначений;
	тзМат.Колонки.Добавить("Номенклатура");
	тзМат.Колонки.Добавить("Толщина");
	тзМат.Колонки.Добавить("Индекс");
	
	Для каждого СтрокаСпецификация Из фнДерево.Строки Цикл
		
		Для каждого СтрокаНоменклатура Из СтрокаСпецификация.Строки Цикл
			
			НоваяСтрока = тзМат.Добавить();
			НоваяСтрока.Номенклатура = СтрокаНоменклатура.Номенклатура; 
			НоваяСтрока.Толщина = СтрокаНоменклатура.Номенклатура.ГлубинаДетали;
			НоваяСтрока.Индекс = Индекс;
			
			Индекс = Индекс + 1;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат тзМат;
	
КонецФункции

Функция ПолучитьТаблицуПлит(фнДерево)
	
	тзПлиты = Новый ТаблицаЗначений;
	тзПлиты.Колонки.Добавить("Номенклатура");
	тзПлиты.Колонки.Добавить("КодНоменклатуры");
	тзПлиты.Колонки.Добавить("ВысотаЛиста");
	тзПлиты.Колонки.Добавить("ШиринаЛиста");
	тзПлиты.Колонки.Добавить("КоличествоПлит");
	тзПлиты.Колонки.Добавить("MAT_IND");
	
	MAT_IND = 0;
	
	Для каждого СтрокаСпецификация Из фнДерево.Строки Цикл
		
		Для каждого СтрокаНоменклатура Из СтрокаСпецификация.Строки Цикл
			
			MAT_IND = MAT_IND + 1;
			
			Для каждого СтрокаЛисты Из СтрокаНоменклатура.Строки Цикл
				
				НоваяСтрока = тзПлиты.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЛисты);
				НоваяСтрока.КодНоменклатуры = НоваяСтрока.Номенклатура.Код;
				НоваяСтрока.КоличествоПлит = 1;
				НоваяСтрока.MAT_IND = MAT_IND;
				
				Если (СтрокаЛисты.ВысотаЛиста = НоваяСтрока.Номенклатура.ДлинаДетали
				    И СтрокаЛисты.ШиринаЛиста = НоваяСтрока.Номенклатура.ШиринаДетали) Тогда
				      НоваяСтрока.ВысотаЛиста = НоваяСтрока.Номенклатура.ДлинаБезТорцовки;
					  НоваяСтрока.ШиринаЛиста = НоваяСтрока.Номенклатура.ШиринаБезТорцовки;
				Иначе
					  НоваяСтрока.ШиринаЛиста = НоваяСтрока.ШиринаЛиста + 20;
				КонецЕсли;
				            
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	тзПлиты.Свернуть("Номенклатура, КодНоменклатуры, ВысотаЛиста, ШиринаЛиста, MAT_IND", "КоличествоПлит");
	
	Возврат тзПлиты;
	
КонецФункции

Функция ПолучитьТаблицуДеталей(фнДерево)
	
	тзДетали = Новый ТаблицаЗначений;
	тзДетали.Колонки.Добавить("PTN_INDEX");
	тзДетали.Колонки.Добавить("BRD_INDEX");
	тзДетали.Колонки.Добавить("MAT_INDEX");
	тзДетали.Колонки.Добавить("ВысотаЛиста");
	тзДетали.Колонки.Добавить("тзРезы");
	
	PTN_INDEX = 0;
	MAT_INDEX = 0;
	BRD_INDEX = 0;
	
	ВысотаЛиста = 0;
	ШиринаЛиста = 0;
	
	Номенклатура = Неопределено;
	
	Для каждого СтрокаСпецификация Из фнДерево.Строки Цикл
		
		Для каждого СтрокаНоменклатура Из СтрокаСпецификация.Строки Цикл
			
			MAT_INDEX = MAT_INDEX + 1;
			
			Для каждого СтрокаЛисты Из СтрокаНоменклатура.Строки Цикл
				
				PTN_INDEX = PTN_INDEX + 1;
				
				Если ВысотаЛиста <> СтрокаЛисты.ВысотаЛиста ИЛИ ШиринаЛиста <> СтрокаЛисты.ШиринаЛиста ИЛИ Номенклатура <> СтрокаНоменклатура.Номенклатура Тогда
					 BRD_INDEX = BRD_INDEX + 1;
					 ВысотаЛиста = СтрокаЛисты.ВысотаЛиста;
					 ШиринаЛиста = СтрокаЛисты.ШиринаЛиста;
					 Номенклатура = СтрокаНоменклатура.Номенклатура;
				КонецЕсли;
				
				НоваяСтрока = тзДетали.Добавить();
				НоваяСтрока.PTN_INDEX = PTN_INDEX;
				НоваяСтрока.BRD_INDEX = BRD_INDEX;
				НоваяСтрока.MAT_INDEX = MAT_INDEX;

				Если (СтрокаЛисты.ВысотаЛиста = СтрокаЛисты.Номенклатура.ДлинаДетали
				    И СтрокаЛисты.ШиринаЛиста = СтрокаЛисты.Номенклатура.ШиринаДетали) Тогда
					
					НоваяСтрока.ВысотаЛиста = СтрокаНоменклатура.Номенклатура.ДлинаБезТорцовки;
					
				Иначе
					
					НоваяСтрока.ВысотаЛиста = СтрокаЛисты.ВысотаЛиста;
					           
				КонецЕсли;
				
				тзРезы = Новый ТаблицаЗначений;
				тзРезы.Колонки.Добавить("Отступ");
				
				Если СтрокаНоменклатура.Номенклатура.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ЛДСП16 Тогда
				
					СтрокаЛисты.Строки.Сортировать("Абсцисса Убыв");
					
					НСтр = тзРезы.Добавить();
					НСтр.Отступ = 10;

					Для Каждого СтрокаДетали Из СтрокаЛисты.Строки Цикл
					
						Если НЕ СтрокаДетали.Остаток И СтрокаДетали.Ордината = 0 Тогда
							
							НСтр = тзРезы.Добавить();
							НСтр.Отступ = СтрокаДетали.ШиринаДетали; 
							
						КонецЕсли;
						
					КонецЦикла;
					
				Иначе
					
					НСтр = тзРезы.Добавить();
					
					Если (СтрокаЛисты.ВысотаЛиста = СтрокаЛисты.Номенклатура.ДлинаДетали
					    И СтрокаЛисты.ШиринаЛиста = СтрокаЛисты.Номенклатура.ШиринаДетали) Тогда
						
						  НСтр.Отступ = СтрокаНоменклатура.Номенклатура.ШиринаБезТорцовки;
					Иначе
						  НСтр.Отступ = СтрокаЛисты.ШиринаЛиста + 20;	  
					КонецЕсли;
					
					
				КонецЕсли;
				
				НоваяСтрока.тзРезы = тзРезы; 
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат тзДетали;
	
КонецФункции

#КонецОбласти
