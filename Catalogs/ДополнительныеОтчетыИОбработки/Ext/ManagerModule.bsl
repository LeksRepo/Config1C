﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Реквизиты, которые разрешается изменять сразу для нескольких объектов.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ИспользоватьДляФормыОбъекта");
	Результат.Добавить("ИспользоватьДляФормыСписка");
	Результат.Добавить("Ответственный");
	Результат.Добавить("Публикация");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
