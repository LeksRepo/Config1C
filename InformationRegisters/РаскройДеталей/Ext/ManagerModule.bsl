﻿
Функция ПолучитьСтрокуРаскроя(Спецификация) Экспорт
	
	ТолщинаПила = ?(ЗначениеЗаполнено(Спецификация.Производство.ТолщинаПропила), Спецификация.Производство.ТолщинаПропила, 5);
	ДопустимыйОстатокПоШирине = 200;
	ДопустимыйОстатокПоВысоте = 200;
	
	Если Спецификация.Дилерский Тогда		
		ДанныеДляРаскроя = "%РОСПИЛ%☻";		
	Иначе		
		ДанныеДляРаскроя = "%ЛЕКС%☻"		
	КонецЕсли;
	
	//______________________________________________________
	
	СписокДеталей = ФормированиеСпискаДеталей(Спецификация);
	//______________________________________________________
	
	СписокНоменклатуры = Новый СписокЗначений;
	
	Для Каждого Элемент Из СписокДеталей Цикл
			
		Элемент.ШиринаЛиста = Элемент.Номенклатура.ШиринаДетали;
		Элемент.ВысотаЛиста = Элемент.Номенклатура.ДлинаДетали;
		Элемент.Порядок = 100;
		
		Количество = Элемент.Количество;
		Материал = Элемент.Материал;
		
		//Разбивка клееной детали 
		Если Материал = "10 ЛДСП+10 ЛДСП" ИЛИ Материал = "16 ЛДСП+10 ЛДСП" ИЛИ Материал = "16 ЛДСП+16 ЛДСП" Тогда
			
			Элемент.Материал = Неопределено;
			НоваяСтрока = СписокДеталей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Элемент);
			НоваяСтрока.Номенклатура = Элемент.НоменклатураДляСклеивания;
			НоваяСтрока.ВысотаДетали = НоваяСтрока.ВысотаДетали + 10;
			НоваяСтрока.ШиринаДетали = НоваяСтрока.ШиринаДетали + 10;

		КонецЕсли;
		
		Если Количество > 1 Тогда
			//разбиваем детали
			Элемент.Количество = 1;
			Для ы = 2 По Количество Цикл
				НоваяСтрока = СписокДеталей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Элемент);
			КонецЦикла;
			
		КонецЕсли;
		
		//ДлинныеДетали в начало листа ????? в общий цикл раскроя + высокие строка деталей
		ОстатокЛинии = Элемент.ВысотаЛиста - Элемент.ВысотаДетали;
		Если ОстатокЛинии < 500 И Элемент.ШиринаДетали <= 201 Тогда
			
			Элемент.Порядок = 1;
			
		КонецЕсли;
			
		Если СписокНоменклатуры.НайтиПоЗначению(Элемент.Номенклатура) = Неопределено Тогда
			СписокНоменклатуры.Добавить(Элемент.Номенклатура);	
		КонецЕсли;
		
		Если НЕ Элемент.СоблюдениеТекстуры Тогда
			СтрокаСписка = СписокНоменклатуры.НайтиПоЗначению(Элемент.Номенклатура);			
			СтрокаСписка.Пометка = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	//______________________________________________________
		
	КонечныйНомерЛиста = 0;

	Для Каждого ЭлементСписка Из СписокНоменклатуры Цикл
		
		//Параметры сравнения алгоритмов раскроя
		КоличествоОстатковИтог = -1;
		ПлощадьОстатковИтог = -1;
		
		//Основные таблицы по умолчанию
		СписокДеталейНоменклатуры = СписокДеталей.Скопировать(Новый Структура("Номенклатура", ЭлементСписка.Значение));
		
		//Параметры алгоритма раскроя при формировании линий(2-ой алгоритм)
		МассивОстатковЛиний = Новый Массив;
		МассивОстатковЛиний.Добавить(0);
		МассивОстатковЛиний.Добавить(500);
		
		ОбходовПоТекстуре = Число(ЭлементСписка.Пометка);
		Для Инд = 0 По ОбходовПоТекстуре Цикл
			
			#Область Алгоритм_поворот_деталей_без_текстуры
			Если Инд = 1 Тогда //Есть детали без текстуры
				
				//Очистка остатков
				СписокДеталейНоменклатуры = СписокДеталейНоменклатуры.Скопировать(Новый Структура("Остаток", Ложь));
				
				МассивБезТекстурных = СписокДеталейНоменклатуры.НайтиСтроки(Новый Структура("СоблюдениеТекстуры", Ложь));
				Для Каждого ЭлементБезТекстуры Из МассивБезТекстурных Цикл
					Если ЭлементБезТекстуры.ВысотаДетали > ЭлементБезТекстуры.ШиринаДетали 
						И (ЭлементБезТекстуры.ВысотаДетали <= ЭлементБезТекстуры.ШиринаЛиста)
						И (ЭлементБезТекстуры.ШиринаДетали <= ЭлементБезТекстуры.ВысотаЛиста) Тогда
						
						ВысотаДеталиБезТекстуры = ЭлементБезТекстуры.ВысотаДетали;
						ЭлементБезТекстуры.ВысотаДетали = ЭлементБезТекстуры.ШиринаДетали;
						ЭлементБезТекстуры.ШиринаДетали = ВысотаДеталиБезТекстуры;
						ЭлементБезТекстуры.ПоворотДетали = 1;
						
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			СписокДеталейНоменклатуры.Сортировать("Порядок, ШиринаДетали Убыв, ВысотаДетали Убыв");
			
			#КонецОбласти
						
			Для Каждого ОстатокЛинии Из МассивОстатковЛиний Цикл
				
				#Область Алгоритм_формирование_линий_пила_ограниченных_по_высоте
				Если ОстатокЛинии > 0 Тогда
					
					//Очистка остатков
					СписокДеталейНоменклатуры = СписокДеталейНоменклатуры.Скопировать(Новый Структура("Остаток", Ложь));	
					
					Для Каждого Элемент Из СписокДеталейНоменклатуры Цикл
						
						Порядок = 2;
						МассивЛиний = СписокДеталейНоменклатуры.НайтиСтроки(Новый Структура("ШиринаДетали, Порядок", Элемент.ШиринаДетали, 100));
						Если МассивЛиний.Количество() > 1 Тогда                  
							
							ИндексДетали = МассивЛиний.Количество() - 1;
							НашаВысотаЛиста = Элемент.ВысотаЛиста;
							МинРазмерЛинии = НашаВысотаЛиста - ОстатокЛинии;
							МаксВысотаЛинии = 0;
							МассивИндексов = Новый Массив;
										
							Для Индекс = 0 По ИндексДетали Цикл
								
								ПеременныйМассив = Новый Массив;
								ВысотаЛинии = 0;
								Если МассивЛиний[Индекс].ВысотаДетали <= НашаВысотаЛиста Тогда
									ВысотаЛинии = МассивЛиний[Индекс].ВысотаДетали;
									ПеременныйМассив.Добавить(Индекс);
								КонецЕсли;
												
								Если ВысотаЛинии < НашаВысотаЛиста Тогда
									Для НовыйИндекс = Индекс + 1 По ИндексДетали Цикл
										
										НоваяВысота = ВысотаЛинии + МассивЛиний[НовыйИндекс].ВысотаДетали + ТолщинаПила;
										Если НоваяВысота <= НашаВысотаЛиста Тогда 
											ВысотаЛинии = НоваяВысота;
											ПеременныйМассив.Добавить(НовыйИндекс);                               
										КонецЕсли;
										
									КонецЦикла;
								КонецЕсли;
								
								Если (ВысотаЛинии > МинРазмерЛинии) И (ВысотаЛинии > МаксВысотаЛинии) Тогда
									МаксВысотаЛинии = ВысотаЛинии;
									МассивИндексов = ПеременныйМассив;
								КонецЕсли;
												
							КонецЦикла;
							
							Для Каждого ЗначениеМассива Из МассивИндексов Цикл
								МассивЛиний[ЗначениеМассива].Порядок = Порядок; 
							КонецЦикла;
							
							Порядок = Порядок + 1;
							
						КонецЕсли;	
					КонецЦикла; //Для Каждого Элемент Из СписокДеталейНоменклатуры Цикл
					
					СписокДеталейНоменклатуры.Сортировать("Порядок, ШиринаДетали Убыв, ВысотаДетали Убыв");
					
				КонецЕсли; //ОстатокЛинии > 0
				#КонецОбласти
				
				#Область Расположение_деталей_и_остатков_на_листе_по_алгоритму
				НомерЛиста = КонечныйНомерЛиста + 1;
				
				Для Каждого Элемент Из СписокДеталейНоменклатуры Цикл
										
					Если НЕ Элемент.Остаток Тогда
						
						//Заполнение начальный остаток
						МассивОстатков = СписокДеталейНоменклатуры.НайтиСтроки(Новый Структура("Остаток", Истина));
						Если МассивОстатков.Количество() = 0 Тогда
							НоваяСтрока = СписокДеталейНоменклатуры.Добавить();
							НоваяСтрока.Номенклатура = Элемент.Номенклатура;
							НоваяСтрока.Количество = 1;
							НоваяСтрока.НомерЛиста = НомерЛиста;
							НоваяСтрока.ВысотаДетали = Элемент.ВысотаЛиста;
							НоваяСтрока.ШиринаДетали = Элемент.ШиринаЛиста;
							НоваяСтрока.ВысотаЛиста = Элемент.ВысотаЛиста;
							НоваяСтрока.ШиринаЛиста = Элемент.ШиринаЛиста;
							НоваяСтрока.КоординатаУ = 0;
							НоваяСтрока.КоординатаХ = 0;
							НоваяСтрока.Остаток = Истина;
						КонецЕсли;
						
						
						МассивОстатков = СписокДеталейНоменклатуры.НайтиСтроки(Новый Структура("Остаток", Истина));
						Для Каждого ЭлементМассива Из МассивОстатков Цикл
							
							ОстатокПоВысоте = ЭлементМассива.ВысотаДетали - Элемент.ВысотаДетали;
							ОстатокПоШирине = ЭлементМассива.ШиринаДетали - Элемент.ШиринаДетали;
							
							Если ОстатокПоВысоте >= 0  И ОстатокПоШирине >= 0 Тогда
								
								//__________Размешение детали на листе__________
								Элемент.КоординатаУ = ЭлементМассива.КоординатаУ;
								Элемент.КоординатаХ = ЭлементМассива.КоординатаХ;
								Элемент.НомерЛиста = ЭлементМассива.НомерЛиста;
								//Элемент.ПоворотДетали = 0;
																
								//__________Добавление ВСЕХ остатков__________								
								ИндексОстатка = СписокДеталейНоменклатуры.Индекс(ЭлементМассива);										
								Если ОстатокПоШирине > 5 Тогда
									
									НоваяСтрока = СписокДеталейНоменклатуры.Вставить(ИндексОстатка);
									НоваяСтрока.Номенклатура = Элемент.Номенклатура;
									НоваяСтрока.Количество = 1;
									НоваяСтрока.НомерЛиста = ЭлементМассива.НомерЛиста;
									НоваяСтрока.ВысотаДетали = ЭлементМассива.ВысотаДетали;
									НоваяСтрока.ШиринаДетали = ОстатокПоШирине - ТолщинаПила;
									НоваяСтрока.ВысотаЛиста = Элемент.ВысотаЛиста;
									НоваяСтрока.ШиринаЛиста = Элемент.ШиринаЛиста;
									НоваяСтрока.КоординатаУ = Элемент.КоординатаУ;
									НоваяСтрока.КоординатаХ = Элемент.КоординатаХ + Элемент.ШиринаДетали + ТолщинаПила;
									НоваяСтрока.Остаток = Истина;
									
								КонецЕсли;
																
								Если ОстатокПоВысоте > 5 Тогда
									
									НоваяСтрока = СписокДеталейНоменклатуры.Вставить(ИндексОстатка);
									НоваяСтрока.Номенклатура = Элемент.Номенклатура;
									НоваяСтрока.Количество = 1;
									НоваяСтрока.НомерЛиста = ЭлементМассива.НомерЛиста;
									НоваяСтрока.ВысотаДетали = ОстатокПоВысоте - ТолщинаПила;
									НоваяСтрока.ШиринаДетали = Элемент.ШиринаДетали;
									НоваяСтрока.ВысотаЛиста = Элемент.ВысотаЛиста;
									НоваяСтрока.ШиринаЛиста = Элемент.ШиринаЛиста;
									НоваяСтрока.КоординатаУ = Элемент.КоординатаУ + Элемент.ВысотаДетали + ТолщинаПила;
									НоваяСтрока.КоординатаХ = Элемент.КоординатаХ;
									НоваяСтрока.Остаток = Истина;
									
								КонецЕсли;
								
								СписокДеталейНоменклатуры.Удалить(ЭлементМассива);
								Прервать;
								
							ИначеЕсли (МассивОстатков.Найти(ЭлементМассива) + 1) = МассивОстатков.Количество() Тогда
								
								НомерЛиста = НомерЛиста + 1;	
								
								НоваяСтрока = СписокДеталейНоменклатуры.Добавить();
								НоваяСтрока.Номенклатура = Элемент.Номенклатура;
								НоваяСтрока.Количество = 1;
								НоваяСтрока.НомерЛиста = НомерЛиста;
								НоваяСтрока.ВысотаДетали = Элемент.ВысотаЛиста;
								НоваяСтрока.ШиринаДетали = Элемент.ШиринаЛиста;
								НоваяСтрока.ВысотаЛиста = Элемент.ВысотаЛиста;
								НоваяСтрока.ШиринаЛиста = Элемент.ШиринаЛиста;
								НоваяСтрока.КоординатаУ = 0;
								НоваяСтрока.КоординатаХ = 0;
								НоваяСтрока.Остаток = Истина;
								
								МассивОстатков.Добавить(НоваяСтрока);
																
							КонецЕсли;
							
						КонецЦикла;	
						
						Если Элемент.ПоворотДетали = 1 Тогда
							
							ВысотаДеталиБезТекстуры = Элемент.ВысотаДетали;
							Элемент.ВысотаДетали = Элемент.ШиринаДетали;
							Элемент.ШиринаДетали = ВысотаДеталиБезТекстуры;
							
						КонецЕсли;
						
					КонецЕсли; //НЕ Элемент.Остаток
										
				КонецЦикла; //Для Каждого Элемент Из СписокДеталейНоменклатуры Цикл						
				#КонецОбласти
				
				#Область Поиск_оптимальных_остатков
				СтруктураОптимальногоОстатка = ОптимизацияОстатков(ДопустимыйОстатокПоШирине, ДопустимыйОстатокПоВысоте, СписокДеталейНоменклатуры, НомерЛиста, КонечныйНомерЛиста, ТолщинаПила);
				
				Если (ПлощадьОстатковИтог = -1) ИЛИ (СтруктураОптимальногоОстатка.ПлощадьОстатковПоНоменклатуре > ПлощадьОстатковИтог) Тогда
					
					ПлощадьОстатковИтог = СтруктураОптимальногоОстатка.ПлощадьОстатковПоНоменклатуре;
					КонечныйНомерЛиста = НомерЛиста;
					ТаблицаДеталейИтог = СтруктураОптимальногоОстатка.СписокДеталейНоменклатуры;
					
				КонецЕсли;
				#КонецОбласти
				
			КонецЦикла; //Для Каждого ОстатокЛинии Из МассивОстатковЛиний Цикл
						
		КонецЦикла; //Для Инд = 0 По ОбходовПоТекстуре Цикл			
					
		ДанныеДляРаскроя = ФормированиеСтрокиРаскроя(ДанныеДляРаскроя, ТаблицаДеталейИтог, Спецификация);
			
	КонецЦикла;	
	
	Возврат ДанныеДляРаскроя;
	
КонецФункции // ПолучитьСтрокуРаскроя()

Функция ФормированиеСпискаДеталей(Спецификация)

	СписокДеталей = Спецификация.СписокМатериалы.Выгрузить(,"НомерСтроки, Материал, Номенклатура, ВысотаДетали, ШиринаДетали, Количество, 
	|Идентификатор, НоменклатураДляСклеивания, НомерИзделия, СоблюдениеТекстуры, НеТорцевать, СтруктураОтверстий, Комментарий,
	|РадиусЛевоВерх, РадиусЛевоНиз, РадиусПравоВерх, РадиусПравоНиз, КривойПилСверху, КривойПилСлева, КривойПилСнизу, КривойПилСправа,      
	|ВыборМебельнойКромкиСверху, ВыборМебельнойКромкиСлева, ВыборМебельнойКромкиСнизу, ВыборМебельнойКромкиСправа");
	СписокДеталей.Колонки.Добавить("ШиринаЛиста", Новый ОписаниеТипов("Число"));
	СписокДеталей.Колонки.Добавить("ВысотаЛиста", Новый ОписаниеТипов("Число"));
	СписокДеталей.Колонки.Добавить("НомерЛиста", Новый ОписаниеТипов("Число"));
	СписокДеталей.Колонки.Добавить("КоординатаХ", Новый ОписаниеТипов("Число"));
	СписокДеталей.Колонки.Добавить("КоординатаУ", Новый ОписаниеТипов("Число"));
	СписокДеталей.Колонки.Добавить("ПоворотДетали", Новый ОписаниеТипов("Число"));
	СписокДеталей.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число"));
	СписокДеталей.Колонки.Добавить("Остаток", Новый ОписаниеТипов("Булево"));
	СписокДеталей.Колонки.Добавить("Кромка1", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	СписокДеталей.Колонки.Добавить("Кромка2", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	СписокДеталей.Колонки.Добавить("Кромка3", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	СписокДеталей.Колонки.Добавить("Кромка4", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	
	#Область Преобразование_ящиков_в_детали
	СписокЯщиков = Спецификация.СписокЯщики;                            
	                                                              
	Для Каждого Элемент Из СписокЯщиков Цикл                      
		                                                          
		//ДНО ЯЩИКА                                               
		НоваяСтрока = СписокДеталей.Добавить();                   
		НоваяСтрока.Номенклатура = Элемент.ДноНоменклатура;       
		НоваяСтрока.ВысотаДетали = Элемент.ДлинаДно;              
		НоваяСтрока.ШиринаДетали = Элемент.ШиринаДно;             
		НоваяСтрока.Количество = Элемент.КоличествоЯщиков;
		НоваяСтрока.НомерИзделия = Элемент.НомерИзделия;
		НоваяСтрока.НомерСтроки = Элемент.НомерСтроки;
		НоваяСтрока.СоблюдениеТекстуры = 0;
		
		Если Элемент.ВидЯщика = Перечисления.ВидыЯщика.Обычный Тогда
			
			Если ЗначениеЗаполнено(Элемент.ДлинаРебро) Тогда
				
				//РЕБРО ЯЩИКА
				НоваяСтрока = СписокДеталей.Добавить();
				НоваяСтрока.Номенклатура = Элемент.Номенклатура;
				НоваяСтрока.ВысотаДетали = Элемент.ДлинаРебро;
				НоваяСтрока.ШиринаДетали = Элемент.ВысотаЯщика;
				НоваяСтрока.Количество = Элемент.КоличествоЯщиков;
				НоваяСтрока.НомерИзделия = Элемент.НомерИзделия;
				НоваяСтрока.НомерСтроки = Элемент.НомерСтроки;
				НоваяСтрока.СоблюдениеТекстуры = 0;	
				НоваяСтрока.ВыборМебельнойКромкиСлева = Элемент.КромкаНоменклатура;
				
			КонецЕсли;
			
			//БОКОВАЯ СТОРОНА1
			НоваяСтрока = СписокДеталей.Добавить();
			НоваяСтрока.Номенклатура = Элемент.Номенклатура;
			НоваяСтрока.ВысотаДетали = Элемент.ШиринаБоковойСтороны;
			НоваяСтрока.ШиринаДетали = Элемент.ВысотаБоковойСтороны;
			НоваяСтрока.Количество = 2 * Элемент.КоличествоЯщиков;
			НоваяСтрока.НомерИзделия = Элемент.НомерИзделия;
			НоваяСтрока.НомерСтроки = Элемент.НомерСтроки;
			НоваяСтрока.СоблюдениеТекстуры = 1;
			НоваяСтрока.ВыборМебельнойКромкиСлева = Элемент.КромкаНоменклатура;
			
			//БОКОВАЯ СТОРОНА2
			НоваяСтрока = СписокДеталей.Добавить();
			НоваяСтрока.Номенклатура = Элемент.Номенклатура;
			НоваяСтрока.ВысотаДетали = Элемент.ДлинаБоковойСтороны;
			НоваяСтрока.ШиринаДетали = Элемент.ВысотаБоковойСтороны;
			НоваяСтрока.Количество = 2 * Элемент.КоличествоЯщиков;
			НоваяСтрока.НомерИзделия = Элемент.НомерИзделия;
			НоваяСтрока.НомерСтроки = Элемент.НомерСтроки;
			НоваяСтрока.СоблюдениеТекстуры = 1;
			НоваяСтрока.ВыборМебельнойКромкиСверху = Элемент.КромкаНоменклатура;
			НоваяСтрока.ВыборМебельнойКромкиСнизу = Элемент.КромкаНоменклатура;
			НоваяСтрока.ВыборМебельнойКромкиСлева = Элемент.КромкаНоменклатура;
			
		Иначе
			
			//МТБОКСЫ
			НоваяСтрока = СписокДеталей.Добавить();
			НоваяСтрока.Номенклатура = Элемент.Номенклатура;
			НоваяСтрока.ВысотаДетали = Элемент.ШиринаБоковойСтороны;
			НоваяСтрока.ШиринаДетали = Элемент.ВысотаБоковойСтороны;
			НоваяСтрока.Количество = Элемент.КоличествоЯщиков;
			НоваяСтрока.НомерИзделия = Элемент.НомерИзделия;
			НоваяСтрока.НомерСтроки = Элемент.НомерСтроки;
			НоваяСтрока.СоблюдениеТекстуры = 1;
			НоваяСтрока.ВыборМебельнойКромкиСверху = Элемент.КромкаНоменклатура;
			НоваяСтрока.ВыборМебельнойКромкиСнизу = Элемент.КромкаНоменклатура;
			НоваяСтрока.ВыборМебельнойКромкиСлева = Элемент.КромкаНоменклатура;
			НоваяСтрока.ВыборМебельнойКромкиСправа = Элемент.КромкаНоменклатура;
			
		КонецЕсли;
		
		Если Элемент.ВидФасада <> "Нет" Тогда
			Если ЗначениеЗаполнено(Элемент.ФасадНоменклатура) Тогда
				
				//ФАСАД ЯЩИКА
				НоваяСтрока = СписокДеталей.Добавить();
				НоваяСтрока.Номенклатура = Элемент.ФасадНоменклатура;
				НоваяСтрока.ВысотаДетали = Элемент.ВысотаФасад - 2 * Элемент.КромкаФасадНоменклатура.ГлубинаДетали;
				НоваяСтрока.ШиринаДетали = Элемент.ШиринаФасад - 2 * Элемент.КромкаФасадНоменклатура.ГлубинаДетали;
				НоваяСтрока.Количество = Элемент.КоличествоЯщиков;
				НоваяСтрока.НомерИзделия = Элемент.НомерИзделия;
				НоваяСтрока.НомерСтроки = Элемент.НомерСтроки;
				НоваяСтрока.СоблюдениеТекстуры = 1;
				НоваяСтрока.ВыборМебельнойКромкиСверху = Элемент.КромкаФасадНоменклатура;
				НоваяСтрока.ВыборМебельнойКромкиСнизу = Элемент.КромкаФасадНоменклатура;
				НоваяСтрока.ВыборМебельнойКромкиСлева = Элемент.КромкаФасадНоменклатура;
				НоваяСтрока.ВыборМебельнойКромкиСправа = Элемент.КромкаФасадНоменклатура;
				
			КонецЕсли;
		КонецЕсли;			
	КонецЦикла;
	#КонецОбласти 

	Возврат СписокДеталей;
	
КонецФункции // ФормированиеСпискаДеталей()

//Алгоритмы оптимальных остатков
//	1 - Остатки как есть
//	2 - Находим макс. горизонтальную полосу пила, все что выше остаток
//	3 - Объединяем маленькие остатки в больший(принципы объединения???)				
Функция ОптимизацияОстатков(ДопустимыйОстатокПоШирине, ДопустимыйОстатокПоВысоте, СписокДеталейНоменклатуры, НомерЛиста, КонечныйНомерЛиста, ТолщинаПила)
	
	ПлощадьОстатковПоНоменклатуре = 0;
	СписокДеталейНоменклатуры.Сортировать("НомерЛиста, КоординатаУ Убыв, КоординатаХ Убыв");
	
	Для ТекущийНомерЛиста = КонечныйНомерЛиста + 1 По НомерЛиста Цикл
		
		КоличествоОстатков = 0;
		ПлощадьОстатков = 0;
		СреднийОстаток = 0;
		КоличествоОстатков2 = 1;
		ПлощадьОстатков2 = 0;
		СреднийОстаток2 = 0;
		
		МассивОстатков = СписокДеталейНоменклатуры.НайтиСтроки(Новый Структура("Остаток, НомерЛиста", Истина, ТекущийНомерЛиста));
		
		//_____1_____
		Для Каждого ЭлементМассиваОстатков Из МассивОстатков Цикл
			
			Если ЭлементМассиваОстатков.ВысотаДетали > ДопустимыйОстатокПоВысоте И ЭлементМассиваОстатков.ШиринаДетали > ДопустимыйОстатокПоШирине Тогда
				
				ПлощадьОстатков = ПлощадьОстатков + (ЭлементМассиваОстатков.ВысотаДетали * ЭлементМассиваОстатков.ШиринаДетали);
				КоличествоОстатков = КоличествоОстатков + 1;
				
			КонецЕсли;
			
		КонецЦикла;
		
		СреднийОстаток = ?(КоличествоОстатков > 0, ПлощадьОстатков / КоличествоОстатков, 0);
		
		//_____2_____
		Если МассивОстатков[0].ВысотаДетали > ДопустимыйОстатокПоВысоте Тогда //высота макс. горизонт. линии пила больше допустимого
			
			ПлощадьОстатков2 = МассивОстатков[0].ВысотаДетали * МассивОстатков[0].ШиринаЛиста;
			МаксЛинияПила = МассивОстатков[0].КоординатаУ;
			
			Для Каждого ЭлементМассиваОстатков Из МассивОстатков Цикл
				
				Если ЭлементМассиваОстатков.КоординатаУ < МаксЛинияПила Тогда 
					
					ВысотаОстатка = МаксЛинияПила - ТолщинаПила - ЭлементМассиваОстатков.КоординатаУ;//Высота получившегося остатка
					
					Если ВысотаОстатка > ДопустимыйОстатокПоВысоте И ЭлементМассиваОстатков.ШиринаДетали > ДопустимыйОстатокПоШирине Тогда
						
						ПлощадьОстатков2 = ПлощадьОстатков2 + (ЭлементМассиваОстатков.ШиринаДетали * ВысотаОстатка);	
						КоличествоОстатков2 = КоличествоОстатков2 + 1;
						
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
			
			СреднийОстаток2 = ПлощадьОстатков2 / КоличествоОстатков2;
			
		КонецЕсли;
		
		//_____ИтоговыеОстатки_____
		
		Если СреднийОстаток < СреднийОстаток2 Тогда
			
			МассивОстатков[0].ШиринаДетали = МассивОстатков[0].ШиринаЛиста;
			ПлощадьОстатковПоНоменклатуре = ПлощадьОстатковПоНоменклатуре + ПлощадьОстатков2;
			
		Иначе
			
			ПлощадьОстатковПоНоменклатуре = ПлощадьОстатковПоНоменклатуре + ПлощадьОстатков;
			
		КонецЕсли;
		
		//применение оптимального алгоритма
		Для Каждого ЭлементМассиваОстатков Из МассивОстатков Цикл
			
			Если СреднийОстаток < СреднийОстаток2 И МассивОстатков[0] <> ЭлементМассиваОстатков Тогда
				
				ЭлементМассиваОстатков.ВысотаДетали = МаксЛинияПила - ТолщинаПила - ЭлементМассиваОстатков.КоординатаУ;
				
			КонецЕсли;
			
			Если ЭлементМассиваОстатков.ВысотаДетали < ДопустимыйОстатокПоВысоте ИЛИ ЭлементМассиваОстатков.ШиринаДетали < ДопустимыйОстатокПоШирине Тогда
				
				СписокДеталейНоменклатуры.Удалить(ЭлементМассиваОстатков);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;	
	
	Структура = Новый Структура;
	Структура.Вставить("ПлощадьОстатковПоНоменклатуре", ПлощадьОстатковПоНоменклатуре);
	Структура.Вставить("СписокДеталейНоменклатуры", СписокДеталейНоменклатуры);
	
	Возврат Структура;
	
КонецФункции // ОптимизацияОстатков()

Функция ФормированиеСтрокиРаскроя(СтрокаРаскроя, ТаблицаДеталей, Спецификация)
	
	//Срочность = ?(Спецификация.Срочный, " СРОЧНЫЙ", "");
	//Строка(Спецификация.Номер);
	//Спецификация.Комментарий;
	
	# Область Запрос_Выбор_частых_кромок_на_листе
	ЗапросНаКромки = Новый Запрос;
	ЗапросНаКромки.УстановитьПараметр("ТаблицаДеталей", ТаблицаДеталей);
	ЗапросНаКромки.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДеталей.НомерЛиста,
	|	ВЫРАЗИТЬ(ТаблицаДеталей.ВыборМебельнойКромкиСверху КАК Справочник.Номенклатура) КАК ВыборМебельнойКромкиСверху,
	|	ВЫРАЗИТЬ(ТаблицаДеталей.ВыборМебельнойКромкиСнизу КАК Справочник.Номенклатура) КАК ВыборМебельнойКромкиСнизу,
	|	ВЫРАЗИТЬ(ТаблицаДеталей.ВыборМебельнойКромкиСлева КАК Справочник.Номенклатура) КАК ВыборМебельнойКромкиСлева,
	|	ВЫРАЗИТЬ(ТаблицаДеталей.ВыборМебельнойКромкиСправа КАК Справочник.Номенклатура) КАК ВыборМебельнойКромкиСправа
	|ПОМЕСТИТЬ ВТ_Кромки
	|ИЗ
	|	&ТаблицаДеталей КАК ТаблицаДеталей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Кромки.НомерЛиста КАК НомерЛиста,
	|	ВТ_Кромки.ВыборМебельнойКромкиСверху КАК Кромка,
	|	ВТ_Кромки.ВыборМебельнойКромкиСверху.НоменклатурнаяГруппа КАК Группа,
	|	1 КАК Количество
	|ИЗ
	|	ВТ_Кромки КАК ВТ_Кромки
	|ГДЕ
	|	ВТ_Кромки.ВыборМебельнойКромкиСверху <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_Кромки.НомерЛиста,
	|	ВТ_Кромки.ВыборМебельнойКромкиСнизу,
	|	ВТ_Кромки.ВыборМебельнойКромкиСнизу.НоменклатурнаяГруппа,
	|	1
	|ИЗ
	|	ВТ_Кромки КАК ВТ_Кромки
	|ГДЕ
	|	ВТ_Кромки.ВыборМебельнойКромкиСнизу <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_Кромки.НомерЛиста,
	|	ВТ_Кромки.ВыборМебельнойКромкиСлева,
	|	ВТ_Кромки.ВыборМебельнойКромкиСлева.НоменклатурнаяГруппа,
	|	1
	|ИЗ
	|	ВТ_Кромки КАК ВТ_Кромки
	|ГДЕ
	|	ВТ_Кромки.ВыборМебельнойКромкиСлева <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_Кромки.НомерЛиста,
	|	ВТ_Кромки.ВыборМебельнойКромкиСправа,
	|	ВТ_Кромки.ВыборМебельнойКромкиСправа.НоменклатурнаяГруппа,
	|	1
	|ИЗ
	|	ВТ_Кромки КАК ВТ_Кромки
	|ГДЕ
	|	ВТ_Кромки.ВыборМебельнойКромкиСправа <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Количество УБЫВ
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	НомерЛиста,
	|	Группа,
	|	Кромка";
	#КонецОбласти
	
	ВыборкаВсеКромки = ЗапросНаКромки.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаВсеКромки.Следующий() Цикл
		
		//Выбор первой строки с данного листа, в него добавим частые кромки
		СтрокаЛиста = ТаблицаДеталей.НайтиСтроки(Новый Структура("НомерЛиста", ВыборкаВсеКромки.НомерЛиста))[0];
		
		ВыборкаКромкиПоЛистам = ВыборкаВсеКромки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаКромкиПоЛистам.Следующий() Цикл
			
			ВыборкаКромки = ВыборкаКромкиПоЛистам.Выбрать();
			ВыборкаКромки.Следующий();
			
			//Заполним 4 самые частые кромки разных типов
			Если НЕ ЗначениеЗаполнено(СтрокаЛиста.Кромка1) Тогда
				СтрокаЛиста.Кромка1 = ВыборкаКромки.Кромка;
			ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаЛиста.Кромка2) Тогда
				СтрокаЛиста.Кромка2 = ВыборкаКромки.Кромка;
			ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаЛиста.Кромка3) Тогда
				СтрокаЛиста.Кромка3 = ВыборкаКромки.Кромка;
			ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаЛиста.Кромка4) Тогда
				СтрокаЛиста.Кромка4 = ВыборкаКромки.Кромка;
			КонецЕсли;
			
			ВыборкаКромки.Сбросить();
			
		КонецЦикла;
		
	КонецЦикла;
	
	# Область Запрос_группировка_деталей_для_строки_раскроя
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДеталей", ТаблицаДеталей);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаДеталей.НомерСтроки,
	|	ТаблицаДеталей.Материал,
	|	ТаблицаДеталей.Номенклатура,
	|	ТаблицаДеталей.ВысотаДетали,
	|	ТаблицаДеталей.ШиринаДетали,
	|	ТаблицаДеталей.Количество,
	|	ТаблицаДеталей.Идентификатор,
	|	ТаблицаДеталей.НоменклатураДляСклеивания,
	|	ТаблицаДеталей.НомерИзделия,
	|	ТаблицаДеталей.СоблюдениеТекстуры,
	|	ТаблицаДеталей.НеТорцевать,
	|	ТаблицаДеталей.СтруктураОтверстий,
	|	ТаблицаДеталей.Комментарий,
	|	ТаблицаДеталей.РадиусЛевоВерх,
	|	ТаблицаДеталей.РадиусЛевоНиз,
	|	ТаблицаДеталей.РадиусПравоВерх,
	|	ТаблицаДеталей.РадиусПравоНиз,
	|	ТаблицаДеталей.КривойПилСверху,
	|	ТаблицаДеталей.КривойПилСлева,
	|	ТаблицаДеталей.КривойПилСнизу,
	|	ТаблицаДеталей.КривойПилСправа,
	|	ТаблицаДеталей.ВыборМебельнойКромкиСверху,
	|	ТаблицаДеталей.ВыборМебельнойКромкиСлева,
	|	ТаблицаДеталей.ВыборМебельнойКромкиСнизу,
	|	ТаблицаДеталей.ВыборМебельнойКромкиСправа,
	|	ТаблицаДеталей.ШиринаЛиста,
	|	ТаблицаДеталей.ВысотаЛиста,
	|	ТаблицаДеталей.НомерЛиста,
	|	ТаблицаДеталей.КоординатаХ,
	|	ТаблицаДеталей.КоординатаУ,
	|	ТаблицаДеталей.ПоворотДетали,
	|	ТаблицаДеталей.Порядок,
	|	ТаблицаДеталей.Кромка1,
	|	ТаблицаДеталей.Кромка2,
	|	ТаблицаДеталей.Кромка3,
	|	ТаблицаДеталей.Кромка4,
	|	ТаблицаДеталей.Остаток
	|ПОМЕСТИТЬ ТаблицаДеталей
	|ИЗ
	|	&ТаблицаДеталей КАК ТаблицаДеталей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДеталей.НомерСтроки,
	|	ТаблицаДеталей.Материал,
	|	ТаблицаДеталей.Номенклатура КАК Номенклатура,
	|	ТаблицаДеталей.ВысотаДетали,
	|	ТаблицаДеталей.ШиринаДетали,
	|	ТаблицаДеталей.Количество,
	|	ТаблицаДеталей.Идентификатор,
	|	ТаблицаДеталей.НоменклатураДляСклеивания,
	|	ТаблицаДеталей.НомерИзделия,
	|	ТаблицаДеталей.СоблюдениеТекстуры,
	|	ТаблицаДеталей.НеТорцевать,
	|	ТаблицаДеталей.СтруктураОтверстий,
	|	ТаблицаДеталей.Комментарий,
	|	ТаблицаДеталей.РадиусЛевоВерх,
	|	ТаблицаДеталей.РадиусЛевоНиз,
	|	ТаблицаДеталей.РадиусПравоВерх,
	|	ТаблицаДеталей.РадиусПравоНиз,
	|	ТаблицаДеталей.КривойПилСверху,
	|	ТаблицаДеталей.КривойПилСлева,
	|	ТаблицаДеталей.КривойПилСнизу,
	|	ТаблицаДеталей.КривойПилСправа,
	|	ТаблицаДеталей.ВыборМебельнойКромкиСверху,
	|	ТаблицаДеталей.ВыборМебельнойКромкиСлева,
	|	ТаблицаДеталей.ВыборМебельнойКромкиСнизу,
	|	ТаблицаДеталей.ВыборМебельнойКромкиСправа,
	|	ТаблицаДеталей.ШиринаЛиста КАК ШиринаЛиста,
	|	ТаблицаДеталей.ВысотаЛиста КАК ВысотаЛиста,
	|	ТаблицаДеталей.НомерЛиста КАК НомерЛиста,
	|	ТаблицаДеталей.КоординатаХ,
	|	ТаблицаДеталей.КоординатаУ,
	|	ТаблицаДеталей.ПоворотДетали,
	|	ТаблицаДеталей.Порядок,
	|	ТаблицаДеталей.Кромка1 КАК Кромка1,
	|	ТаблицаДеталей.Кромка2 КАК Кромка2,
	|	ТаблицаДеталей.Кромка3 КАК Кромка3,
	|	ТаблицаДеталей.Кромка4 КАК Кромка4,
	|	ТаблицаДеталей.Остаток
	|ИЗ
	|	ТаблицаДеталей КАК ТаблицаДеталей
	|ИТОГИ
	|	МАКСИМУМ(Номенклатура),
	|	МАКСИМУМ(ШиринаЛиста),
	|	МАКСИМУМ(ВысотаЛиста),
	|	МАКСИМУМ(Кромка1),
	|	МАКСИМУМ(Кромка2),
	|	МАКСИМУМ(Кромка3),
	|	МАКСИМУМ(Кромка4)
	|ПО
	|	НомерЛиста";
	
	#КонецОбласти
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока Выборка.Следующий() Цикл
		
		//Формирование строки раскроя
		СтрокаРаскроя = СтрокаРаскроя 
		+ Выборка.Номенклатура + "☺"
		+ Выборка.Кромка1 + "☺"
		+ Выборка.Кромка1.КраткоеНаименование + "☺"
		+ Выборка.Кромка2 + "☺"
		+ Выборка.Кромка2.КраткоеНаименование + "☺"
		+ Выборка.Кромка3 + "☺"
		+ Выборка.Кромка3.КраткоеНаименование + "☺"
		+ Выборка.Кромка4 + "☺"
		+ Выборка.Кромка4.КраткоеНаименование + "☺"
		+ Выборка.ШиринаЛиста + "☺"
		+ Выборка.ВысотаЛиста + "☺"
		+ Спецификация + "☺"
		+ "<b>Тут можно добавить любую строку</b>" + "☻";
		
		ВыборкаПоДеталям = Выборка.Выбрать();
		Пока ВыборкаПоДеталям.Следующий() Цикл
			
			Номенклатура = ?(ВыборкаПоДеталям.Остаток, "1", "");
			
			СтрокаРаскроя = СтрокаРаскроя
			+ Номенклатура + "☺" // 1 - Номенклатура
			+ ВыборкаПоДеталям.ВысотаДетали + "☺" //2 - Высота детали
			+ ВыборкаПоДеталям.ШиринаДетали + "☺" //3 - Ширина детали
			+ "" + "☺" //4
			+ "" + "☺" //5
			+ "" + "☺" //6
			+ "" + "☺" //7
			+ "" + "☺" //8
			+ "" + "☺" //9
			+ "" + "☺" //10
			+ "" + "☺" //11                            
			+ "" + "☺" //12
			+ "" + "☺" //13
			+ "" + "☺" //14
			+ "" + "☺" //15
			+ ВыборкаПоДеталям.Комментарий + "☺" //16 - Комментарий
			+ "" + "☺" //17
			+ ВыборкаПоДеталям.ВыборМебельнойКромкиСверху.КраткоеНаименование + "☺" //18
			+ ВыборкаПоДеталям.ВыборМебельнойКромкиСнизу.КраткоеНаименование + "☺" //19
			+ ВыборкаПоДеталям.ВыборМебельнойКромкиСлева.КраткоеНаименование + "☺" //20
			+ ВыборкаПоДеталям.ВыборМебельнойКромкиСправа.КраткоеНаименование + "☺" //21
			+ "" + "☺" //22
			+ "" + "☺" //23
			+ "" + "☺" //24
			+ "" + "☺" //25
			+ "" + "☺" //26
			+ "" + "☺" //27
			+ "" + "☺" //28
			+ "" + "☺" //29
			+ "" + "☺" //30
			+ "" + "☺" //31
			+ ВыборкаПоДеталям.КоординатаУ + "☺" //32 - координата по У
			+ ВыборкаПоДеталям.КоординатаХ + "☺" //33 - координата по Х
			+ ВыборкаПоДеталям.ПоворотДетали + "☺☻" //34 - признак поворота детали + конец детали
		КонецЦикла;
		
		СтрокаРаскроя = СтрокаРаскроя + "♦"; //КонецЛиста
		
	КонецЦикла;
	
	Возврат СтрокаРаскроя;
	
КонецФункции // ФормированиеСтрокиРаскроя()

