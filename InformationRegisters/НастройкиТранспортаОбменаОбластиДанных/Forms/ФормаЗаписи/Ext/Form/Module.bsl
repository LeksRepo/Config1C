﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьОбщиеНастройкиТранспорта(Команда)
	
	Отбор              = Новый Структура("КонечнаяТочкаКорреспондента", Запись.КонечнаяТочкаКорреспондента);
	ЗначенияЗаполнения = Новый Структура("КонечнаяТочкаКорреспондента", Запись.КонечнаяТочкаКорреспондента);
	
	ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор, ЗначенияЗаполнения, "НастройкиТранспортаОбменаОбластейДанных", ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
