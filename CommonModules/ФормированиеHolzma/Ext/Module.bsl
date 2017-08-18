// Здесь будем формировать файл в формет PTX для конвертера CadLink станка Holzma
// Описание формата файла:
// http://esupport.cabnetware.com/Help/NcCenter21Help/Menu_Bar/Utilities/Machine_Catalog/NC_Links/Saw_Links/Holzma.htm

#Область Общего_назначения

Функция Сформировать(фнПараметры) Экспорт
	
	ТекстФайла = СформироватьТекстФайла(фнПараметры);
	
КонецФункции

Функция СформироватьСтрокуИзМассива(фнМассив, Разделитель)
	
	Результат = "";
	
	Для каждого Элемент Из фнМассив Цикл
		
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
	
	// Отутствует в описании формата
	//Текст.ДобавитьСтроку(NOTES(фнПараметры));
	//Текст.ДобавитьСтроку("");
	
	// Раздел не обязателен, нужен для этикеток
	//Текст.ДобавитьСтроку(PARTS_INF(фнПараметры));
	//Текст.ДобавитьСтроку("");
	
	// Раздел не обязателен, нужен для этикеток
	//Текст.ДобавитьСтроку(PARTS_UDI(фнПараметры));
	//Текст.ДобавитьСтроку("");
	
	Текст.ДобавитьСтроку(BOARDS(фнПараметры));
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
	
	Массив = Новый Массив;
	
	Массив.Добавить("HEADER");
	Массив.Добавить("1.08");
	//Массив.Добавить(Строка(фнПараметры.РаскройДерево.Строки[0].Спецификация)); // TITLE
	Массив.Добавить("Номер спецификации"); // TITLE
	Массив.Добавить(0); // UNITS
	Массив.Добавить(0); // ORIGIN
	Массив.Добавить(1); // TRIM_TYPE
	
	Результат = СформироватьСтрокуИзМассива(Массив, ",");
	
	Возврат Результат;
	
КонецФункции

Функция JOBS(фнПараметры)
	
	Результат = "";
	
	// В этом разделе перечислим спецификации.
	
	// В примере выглядит так:
	//JOBS,1,SHkaf DSP buk 16,,,,,1,SHkaf DSP buk 16,SHkaf DSP buk 16,90,21.1
	
	//JOB_INDEX - Unique index number used to link other records to an appropriate job
	//NAME - Job number/name – reference for job
	//DESC - Job description/title - title of job
	//ORD_DATE – Date of order  (DD/MM/YYYY)
	//CUT_DATE – Date for cutting/delivery (DD/MM/YYYY)
	//CUSTOMER  - Customer code or name
	//STATUS - Status of the job.
	
	Для каждого Спецификация из фнПараметры.МассивСпецификаций Цикл
		
		Массив = Новый Массив;
		Массив.Добавить("JOBS");
		Массив.Добавить(ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Спецификация.Номер)); //JOB_INDEX
		//Массив.Добавить(Строка(Спецификация)); //NAME
		Массив.Добавить("Имя спецификации"); //NAME
		Массив.Добавить(Спецификация.Комментарий); //DESC
		Массив.Добавить(Формат(Спецификация.Дата, "ДФ=dd.MM.yyyy")); //ORD_DATE
		Массив.Добавить(Формат(Спецификация.ДатаИзготовления, "ДФ=dd.MM.yyyy")); //CUT_DATE
		Массив.Добавить(Спецификация.Контрагент); //CUSTOMER
		Массив.Добавить("0"); //STATUS
		
		Результат = Результат + СформироватьСтрокуИзМассива(Массив, ",");
		Результат = Результат + Символы.ПС;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция PARTS_REQ(фнПараметры)
	
	Результат = "";
	
	// Список деталей.
	
	// В примере выглядит так:
	//PARTS_REQ,1,1,1,1,302.0,502.0,9,0,0,1,9
	//PARTS_REQ,1,10,11,1,1168.0,498.0,9,0,0,1,9
	
	//PARTS_REQ - JOB_INDEX, PART_ INDEX,  CODE,  MAT_INDEX,  LENGTH,  WIDTH,  QTY_REQ, QTY_OVER, QTY_UNDER,  GRAIN,  QTY_PROD
	
	//This record contains data about each different size (or line item) in the cutting list.  This record is used to provide details about each part (over and above cut sizes).
	
	//JOB_INDEX - Index number used to link this record to other records for this job.
	//PART_INDEX - Index number to link this record with other associated part records
	//CODE - Part code or description.
	//MAT_INDEX - Index of material used for this part.
	//LENGTH - Cut length of part shown in appropriate measurement unit
	//WIDTH - Cut length of part shown in appropriate measurement unit
	//QTY_REQ - number of pieces this size
	//QTY_OVER - allowed over production
	//QTY_UNDER - allowed under production.
	//GRAIN - 0=No grain/part can be rotated, 1 = grain/part cannot be rotated.
	//QTY_PROD -  quantity of parts produced by patterns
	
	Для Каждого Деталь Из фнПараметры.СписокДеталей Цикл
		
		Массив = Новый Массив;
		Массив.Добавить("PARTS_REQ");
		Массив.Добавить(ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Деталь.Спецификация.Номер)); //JOB_INDEX
		Массив.Добавить(Деталь.НомерСтроки); //PART_INDEX
		Массив.Добавить(Деталь.НаименованиеДетали); //CODE
		Массив.Добавить(Деталь.Номенклатура.Код); //MAT_INDEX
		Массив.Добавить(Деталь.ВысотаДетали); //LENGTH
		Массив.Добавить(Деталь.ШиринаДетали); //WIDTH
		Массив.Добавить(1); //QTY_REQ
		Массив.Добавить(0); //QTY_OVER
		Массив.Добавить(0); //QTY_UNDER
		Массив.Добавить(1); //GRAIN
		Массив.Добавить(); //QTY_PROD
		
		Результат = Результат + СформироватьСтрокуИзМассива(Массив, ",");
		Результат = Результат + Символы.ПС;
		
	КонецЦикла;
	
	Возврат Результат;
	
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
	
	Для ъ = 0 По тзПлиты.Количество() - 1 Цикл
		
		Массив = Новый Массив;
		Массив.Добавить("BOARDS");
		Массив.Добавить(1); //JOB_INDEX
		Массив.Добавить(ъ + 1); //BRD_INDEX
		Массив.Добавить(тзПлиты[ъ].КодНоменклатуры); //CODE
		Массив.Добавить(тзПлиты[ъ].КодНоменклатуры); //MAT_INDEX
		Массив.Добавить(тзПлиты[ъ].ВысотаЛиста); //LENGTH
		Массив.Добавить(тзПлиты[ъ].ШиринаЛиста); //WIDTH
		Массив.Добавить(9999); //QTY_STOCK
		Массив.Добавить(тзПлиты[ъ].КоличествоПлит); //QTY_USED
		Массив.Добавить(0); //COST
		Массив.Добавить(0); //STK_FLAG
		
		Результат = Результат + СформироватьСтрокуИзМассива(Массив, ",");
		Результат = Результат + Символы.ПС;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьТаблицуПлит(фнДерево)
	
	тзПлиты = Новый ТаблицаЗначений;
	тзПлиты.Колонки.Добавить("Номенклатура");
	тзПлиты.Колонки.Добавить("КодНоменклатуры");
	тзПлиты.Колонки.Добавить("ВысотаЛиста");
	тзПлиты.Колонки.Добавить("ШиринаЛиста");
	тзПлиты.Колонки.Добавить("КоличествоПлит");
	
	Для каждого СтрокаСпецификация Из фнДерево.Строки Цикл
		
		Для каждого СтрокаНоменклатура Из СтрокаСпецификация.Строки Цикл
			
			Для каждого СтрокаЛисты Из СтрокаНоменклатура.Строки Цикл
				
				НоваяСтрока = тзПлиты.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЛисты);
				НоваяСтрока.КодНоменклатуры = НоваяСтрока.Номенклатура.Код;
				НоваяСтрока.КоличествоПлит = 1;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	тзПлиты.Свернуть("Номенклатура, КодНоменклатуры, ВысотаЛиста, ШиринаЛиста", "КоличествоПлит");
	
	Возврат тзПлиты;
	
КонецФункции


#КонецОбласти
