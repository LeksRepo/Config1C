﻿
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокАктивныхПользователейНажатие(Элемент)
	
	СтандартныеПодсистемыКлиент.ОткрытьСписокАктивныхПользователей();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Скопировать(Команда)
	
	Если Параметры.Действие <> "СкопироватьИЗакрыть" Тогда
		Закрыть();
	КонецЕсли;
	
	Результат = Новый Структура("Действие", Параметры.Действие);
	Оповестить("СкопироватьНастройкиАктивнымПользователям", Результат);
	
КонецПроцедуры

#КонецОбласти
