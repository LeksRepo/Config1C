﻿
Функция ПолучитьСтрокуРаскроя(Спецификация) Экспорт
	
	ТолщинаПила = 5;
	
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
		
		//ДлинныеДетали в начало листа
		ОстатокЛинии = Элемент.ВысотаЛиста - Элемент.ВысотаДетали;
		Если ОстатокЛинии < 500 И Элемент.ШиринаДетали <= 201 Тогда
			
			Элемент.Порядок = 1;
			
		КонецЕсли;
		
		//Детали без соблюдения текстуры разворачиваем если высота больше ширины
		//Если НЕ Элемент.СоблюдениеТекстуры И (Элемент.ВысотаДетали > Элемент.ШиринаДетали) Тогда
		//	
		//	ВысотаДеталиБезТекстуры = Элемент.ВысотаДетали;
		//	Элемент.ВысотаДетали = Элемент.ШиринаДетали;
		//	Элемент.ШиринаДетали = ВысотаДеталиБезТекстуры;
		//	Элемент.ПоворотДетали = 1;
		//	
		//КонецЕсли;
		
		Если СписокНоменклатуры.НайтиПоЗначению(Элемент.Номенклатура) = Неопределено Тогда
			СписокНоменклатуры.Добавить(Элемент.Номенклатура);	
		КонецЕсли;
		
		Если НЕ Элемент.СоблюдениеТекстуры Тогда
			СтрокаСписка = СписокНоменклатуры.НайтиПоЗначению(Элемент.Номенклатура);			
			СтрокаСписка.Пометка = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	КонечныйНомерЛиста = 0;
	ДанныеДляРаскроя = "";

	Для Каждого ЭлементСписка Из СписокНоменклатуры Цикл
		
		КоличествоОстатковИтог = -1;
		ПлощадьОстатковИтог = -1;
				
		СписокДеталейНоменклатуры = СписокДеталей.Скопировать(Новый Структура("Номенклатура", ЭлементСписка.Значение));
		ОбходовПоТекстуре = ?(ЭлементСписка.Пометка, 2, 1);
				
		МассивОстатковЛиний = Новый Массив;
		МассивОстатковЛиний.Добавить(0);
		МассивОстатковЛиний.Добавить(500);
		
		Для Инд = 1 По ОбходовПоТекстуре Цикл
			
			Если Инд = 2 Тогда //Есть детали без текстуры
				
				//Очистка остатков
				СписокДеталейНоменклатуры = СписокДеталейНоменклатуры.Скопировать(Новый Структура("Остаток", Ложь));
				
				МассивБезТекстурных = СписокДеталейНоменклатуры.НайтиСтроки(Новый Структура("СоблюдениеТекстуры", Ложь));
				Для Каждого ЭлементБезТекстуры Из МассивБезТекстурных Цикл
					Если ЭлементБезТекстуры.ВысотаДетали > ЭлементБезТекстуры.ШиринаДетали Тогда
						
						ВысотаДеталиБезТекстуры = ЭлементБезТекстуры.ВысотаДетали;
						ЭлементБезТекстуры.ВысотаДетали = ЭлементБезТекстуры.ШиринаДетали;
						ЭлементБезТекстуры.ШиринаДетали = ВысотаДеталиБезТекстуры;
						ЭлементБезТекстуры.ПоворотДетали = 1;
						
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;	
			
			СписокДеталейНоменклатуры.Сортировать("Порядок, ШиринаДетали Убыв, ВысотаДетали Убыв");
			
			Для Каждого ОстатокЛинии Из МассивОстатковЛиний Цикл
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
								
								Элемент.КоординатаУ = ЭлементМассива.КоординатаУ;
								Элемент.КоординатаХ = ЭлементМассива.КоординатаХ;
								Элемент.НомерЛиста = ЭлементМассива.НомерЛиста;
								//Элемент.ПоворотДетали = 0;
								
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
				
				КоличествоОстатков = 0;
				ПлощадьОстатков = 0;
				
				МассивОстатков = СписокДеталейНоменклатуры.НайтиСтроки(Новый Структура("Остаток", Истина));
				Для Каждого ЭлементМассиваОстатков Из МассивОстатков Цикл
					
					Если ЭлементМассиваОстатков.ВысотаДетали > 100 И ЭлементМассиваОстатков.ШиринаДетали > 100 Тогда
						
						КоличествоОстатков = КоличествоОстатков + 1;
						ПлощадьОстатков = ПлощадьОстатков + (ЭлементМассиваОстатков.ВысотаДетали * ЭлементМассиваОстатков.ШиринаДетали);
						
					Иначе
						
						СписокДеталейНоменклатуры.Удалить(ЭлементМассиваОстатков);
						
					КонецЕсли;
					
				КонецЦикла;
				
				Если (ПлощадьОстатковИтог = -1) ИЛИ (ПлощадьОстатков > ПлощадьОстатковИтог) Тогда
					
					ПлощадьОстатковИтог = ПлощадьОстатков;
					ПоследнийНомерЛиста = НомерЛиста;
					ТаблицаДеталейИтог = СписокДеталейНоменклатуры;
					
				КонецЕсли;
				
			КонецЦикла; //Для Каждого ОстатокЛинии Из МассивОстатковЛиний Цикл
						
		КонецЦикла; //Для Инд = 1 По ОбходовПоТекстуре Цикл			
				
		КонечныйНомерЛиста = ПоследнийНомерЛиста;
		
		Для Каждого Элемент Из ТаблицаДеталейИтог Цикл
			
			//Номенклатура = ?(Элемент.Номенклатура = Справочники.Номенклатура.ПустаяСсылка(), "Остаток", Элемент.Номенклатура);
			Номенклатура = ?(Элемент.Остаток, "Остаток", Элемент.Номенклатура);
			
			#Область Формирование_строки_раскроя
			ДанныеДляРаскроя = ДанныеДляРаскроя 
			+ Номенклатура + "☺" // 1 - Номенклатура
			+ "" + "☺" //2 - КлеенаяНоменклатура??? 
			+ Элемент.ВысотаДетали + "☺" //3 - Высота детали
			+ Элемент.ШиринаДетали + "☺" //4 - Ширина детали
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
			+ "" + "☺" //16
			+ Элемент.СоблюдениеТекстуры + "☺" //17 - СоблюдениеТекстуры номенклатуры
			+ "" + "☺" //18 - СоблюдениеТекстуры Клееной номенклатуры???
			+ Элемент.Количество + "☺" //19 - Количество
			+ Элемент.Комментарий + "☺" //20 - Комментарий
			+ "" + "☺" //21
			+ Элемент.ШиринаЛиста + "☺" //22 - Ширина листа раскроя
			+ Элемент.ВысотаЛиста + "☺" //23 - Высота листа раскроя
			+ Элемент.ВыборМебельнойКромкиСверху.КраткоеНаименование + "☺" //24
			+ Элемент.ВыборМебельнойКромкиСнизу.КраткоеНаименование + "☺" //25
			+ Элемент.ВыборМебельнойКромкиСлева.КраткоеНаименование + "☺" //26
			+ Элемент.ВыборМебельнойКромкиСправа.КраткоеНаименование + "☺" //27
			+ "" + "☺" //28
			+ "" + "☺" //29
			+ "" + "☺" //30
			+ "" + "☺" //31
			+ "" + "☺" //32
			+ "" + "☺" //33
			+ "" + "☺" //34
			+ "" + "☺" //35
			+ "" + "☺" //36
			+ "" + "☺" //37
			+ Элемент.НомерЛиста + "☺" //38 - Номер листа
			+ Элемент.КоординатаУ + "☺" //39 - координата по у
			+ Элемент.КоординатаХ + "☺" //40 - координата по х
			+ Элемент.ПоворотДетали + "☺" //41 - признак поворота детали
			+ "☻";
			#КонецОбласти
			
		КонецЦикла;
		
	КонецЦикла;	
	
	Возврат ДанныеДляРаскроя;
	
КонецФункции // ПолучитьСтрокуРаскроя()

