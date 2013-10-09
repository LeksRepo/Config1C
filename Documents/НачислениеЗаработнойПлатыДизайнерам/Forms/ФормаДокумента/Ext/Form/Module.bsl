﻿
&НаКлиенте
Процедура Заполинть(Команда)
	
	Если Вопрос("Табличная часть будет очищена. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		ЗаполнитьТабличнуюЧасть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличнуюЧасть()
	
	Объект.СписокДизайнеров.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоказателиСотрудниковОбороты.Сотрудник КАК Сотрудник,
	|	ПоказателиСотрудниковОбороты.Показатель КАК Показатель,
	|	ЕСТЬNULL(ПоказателиСотрудниковОбороты.ЗначениеОборот, 0) КАК Значение,
	|	ЕСТЬNULL(ПоказателиСотрудниковОбороты.ПлановоеЗначениеОборот, 0) КАК ПлановоеЗначение,
	|	ЕСТЬNULL(ПараметрыДолжностейСрезПоследних.ОкладДизайнера, 0) КАК Оклад,
	|	ЕСТЬNULL(ПараметрыДолжностейСрезПоследних.ШтрафБонусДизайнеру, 0) КАК ШтрафБонус,
	|	ДолжностиФизЛицСрезПоследних.Работает
	|ИЗ
	|	РегистрНакопления.ПоказателиСотрудников.Обороты(&НачалоПериода, &КонецПериода, , Подразделение = &Подразделение) КАК ПоказателиСотрудниковОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыДолжностей.СрезПоследних(&КонецПериода, Подразделение = &Подразделение) КАК ПараметрыДолжностейСрезПоследних
	|		ПО ПоказателиСотрудниковОбороты.Подразделение = ПараметрыДолжностейСрезПоследних.Подразделение
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДолжностиФизЛиц.СрезПоследних(
	|				&КонецПериода,
	|				Подразделение = &Подразделение
	|					И Должность = ЗНАЧЕНИЕ(Справочник.Должности.Дизайнер)) КАК ДолжностиФизЛицСрезПоследних
	|		ПО (ДолжностиФизЛицСрезПоследних.ФизЛицо = ПоказателиСотрудниковОбороты.Сотрудник)
	|ГДЕ
	|	ДолжностиФизЛицСрезПоследних.Работает
	|ИТОГИ
	|	СУММА(Значение),
	|	МИНИМУМ(Оклад)
	|ПО
	|	Сотрудник";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	
	Результат = Запрос.Выполнить();
	
	ВыборкаСотрудники = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСотрудники.Следующий() Цикл
		Выборка = ВыборкаСотрудники.Выбрать();

		ДобавитьСтроку(ВыборкаСотрудники.Сотрудник, ВыборкаСотрудники.Оклад, "Оклад");

		Пока Выборка.Следующий() Цикл
			
			// договоров заключенно на сумму
			Если Выборка.Показатель = Перечисления.ВидПоказателяСотрудника.СтоимостьДоговоров Тогда
				
				ЗаСумму = ЛексСервер.ПолучитьСуммуБонуса(Выборка.Значение, Выборка.ПлановоеЗначение, Выборка.ШтрафБонус);

				Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("За стоимость заключенных договоров (%1)", Выборка.Значение);
				ДобавитьСтроку(Выборка.Сотрудник, ЗаСумму, Комментарий);

			КонецЕсли;		
				
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТабличнуюЧасть()

&НаСервере
Функция ДобавитьСтроку(Дизайнер, Сумма, Комментарий)

	Если ЗначениеЗаполнено(Сумма) Тогда
		НоваяСтрока = Объект.СписокДизайнеров.Добавить();
		НоваяСтрока.Дизайнер = Дизайнер;
		НоваяСтрока.Сумма = Сумма;
		НоваяСтрока.Комментарий = Комментарий;
	КонецЕсли;

КонецФункции // ДобавитьСтроку()

